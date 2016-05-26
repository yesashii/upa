<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=reporte_flujos.xls"
Response.ContentType = "application/vnd.ms-excel"

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina

'for each x in request.Form
'	response.Write("<br>"&x&" -> "&request.Form(x))
'next


v_fecha= request.Form("test[0][fecha_corte]")
'response.Write("<br>Fecha : "&fecha)
'response.End()

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion

conexion.EstadoTransaccion conexion.EjecutaS("delete from documento_pagado")

sql_inserta_temp="insert into documento_pagado  " & vbcrlf & _
				" 	select  c.ingr_ncorr,'ghernan',getdate() " & vbcrlf & _
				" 	from      " & vbcrlf & _
				"	compromisos a      " & vbcrlf & _
				"	join detalle_compromisos b      " & vbcrlf & _
				"		on a.tcom_ccod = b.tcom_ccod      " & vbcrlf & _   
				"		and a.inst_ccod = b.inst_ccod     " & vbcrlf & _    
				"		and a.comp_ndocto = b.comp_ndocto  " & vbcrlf & _
				"		and a.ecom_ccod = '1' " & vbcrlf & _
				"	join detalle_ingresos c     " & vbcrlf & _
				"		on protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')    = c.ting_ccod " & vbcrlf & _
				"		and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto " & vbcrlf & _
				"		and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr')  = c.ingr_ncorr " & vbcrlf & _
				"		and c.ting_ccod in(3,4,13,38,51,52,59,66,49) " & vbcrlf & _
				"		and c.edin_ccod not in (6,11)    " & vbcrlf & _ 
				"	join ingresos e " & vbcrlf & _
				"		on c.ingr_ncorr=e.ingr_ncorr " & vbcrlf & _
				"		and e.eing_ccod not in (3,6)      " & vbcrlf & _      
				" 	where protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0 " & vbcrlf & _
				"	and protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso)= c.ding_mdocto "

conexion.EstadoTransaccion conexion.EjecutaS(sql_inserta_temp)

sql_flujo =" select protic.obtener_rut(a.pers_ncorr) as rut,c.ting_tdesc as tipo_docto, " & vbcrlf & _
			"b.ding_ndocto as numero_docto,b.ding_ncorrelativo as correlativo,cast(b.ding_mdetalle as numeric) as detalle, " & vbcrlf & _
			"cast(b.ding_mdocto as numeric) as total_docto,protic.trunc(b.ding_fdocto) as fecha_docto,d.edin_tdesc as estado_docto, " & vbcrlf & _
			"case when a.ting_ccod=15 then " & vbcrlf & _
			"(select top 1 peri_tdesc from periodos_academicos where anos_ccod>=year(getdate()) and plec_ccod=1 " & vbcrlf & _
			"order by peri_ccod asc) " & vbcrlf & _
			"else (select top 1 peri_tdesc  from abonos ab, periodos_academicos pa where ab.peri_ccod=pa.peri_ccod and ab.ingr_ncorr=a.ingr_ncorr) end as periodo, " & vbcrlf & _
			"(select sede_tdesc from sedes where sede_ccod in ((isnull((select top 1 sede_ccod from alumnos al, ofertas_academicas oa where al.ofer_ncorr=oa.ofer_ncorr and al.pers_ncorr=a.pers_ncorr  " & vbcrlf & _
			"and oa.peri_ccod in (select top 1 pa.peri_ccod  from abonos ab, periodos_academicos pa where ab.peri_ccod=pa.peri_ccod and ab.ingr_ncorr=a.ingr_ncorr)),1)))) as sede " & vbcrlf & _
			"from ingresos a, detalle_ingresos b, tipos_ingresos c, estados_detalle_ingresos d " & vbcrlf & _
			"where a.ingr_ncorr=b.ingr_ncorr " & vbcrlf & _
			"	and a.eing_ccod=4 -- documentados " & vbcrlf & _
			"	and b.ting_ccod in (3,4,13,38,51,52,59,66,49) --DOCUMENTOS (3=cheques,38=cheque protestado,4=letras, 13=T Credito, 51=T. Debito, 52=Pagare Transbank, 59=Pagare Multidebito, 66=Pagare Upa, 49=Factura Exenta) " & vbcrlf & _
			"	and convert(datetime,ding_fdocto,103)>=convert(datetime,'"&v_fecha&"',103)" & vbcrlf & _
			"	and b.edin_ccod not in (6,11) " & vbcrlf & _
			"	and b.ingr_ncorr not in (select ingr_ncorr from documento_pagado) --TABLA CON DATOS DOCUMENTOS ABONADOS " & vbcrlf & _
			"	and b.ting_ccod=c.ting_ccod " & vbcrlf & _
			"	and b.edin_ccod=d.edin_ccod " & vbcrlf & _
			"	order by ding_fdocto, b.ting_ccod "

set f_flujo  = new cformulario
f_flujo.carga_parametros "tabla_vacia.xml", "tabla" 
f_flujo.inicializar conexion							
f_flujo.consultar sql_flujo


sql_saldos =" Select protic.obtener_rut(a.pers_ncorr) as rut,c.ding_mdocto as total_docto,f.edin_tdesc as estado_docto, " & vbcrlf & _
			"	d.ting_tdesc as tipo_docto,c.ting_ccod as tipo_documento,c.ding_ndocto numero_documento,c.ding_fdocto as fecha_vencimiento, " & vbcrlf & _
			"	cast(c.ding_mdocto- protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as numeric) as saldo_documento " & vbcrlf & _
    		"	from      								" & vbcrlf & _
            "  	compromisos a     				" & vbcrlf & _ 
            "	join detalle_compromisos b      	" & vbcrlf & _
            "    	on a.tcom_ccod = b.tcom_ccod       	" & vbcrlf & _ 
            "    	and a.inst_ccod = b.inst_ccod      	" & vbcrlf & _
            "    	and a.comp_ndocto = b.comp_ndocto  	" & vbcrlf & _
            "    	and a.ecom_ccod = '1' 				" & vbcrlf & _
            "	join detalle_ingresos c   		" & vbcrlf & _  
            "    	on protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')    = c.ting_ccod 	" & vbcrlf & _
            "    	and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto " & vbcrlf & _
            "    	and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr')  = c.ingr_ncorr 	" & vbcrlf & _
            "    	and c.ting_ccod in(3,4,13,38,51,52,59,66,49) 	" & vbcrlf & _
            "    	and c.edin_ccod not in (6,11)    	" & vbcrlf & _
			"    	and convert(datetime,c.ding_fdocto,103)>=convert(datetime,'"&v_fecha&"',103)    	" & vbcrlf & _  
        	"   join tipos_ingresos d					" & vbcrlf & _ 
            "    	on c.ting_ccod= d.ting_ccod  		" & vbcrlf & _ 
			"	join ingresos e 					" & vbcrlf & _
            "    	on c.ingr_ncorr=e.ingr_ncorr 		" & vbcrlf & _
            "    	and e.eing_ccod not in (3,6)    	" & vbcrlf & _ 
			"   join estados_detalle_ingresos f			" & vbcrlf & _ 
            "    	on c.edin_ccod=f.edin_ccod    		" & vbcrlf & _      
        	"	where protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0 " & vbcrlf & _
        	"		and protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso)< c.ding_mdocto "


set f_saldo  = new cformulario
f_saldo.carga_parametros "tabla_vacia.xml", "tabla" 
f_saldo.inicializar conexion							
f_saldo.consultar sql_saldos

'response.Write("<pre>"&sql_saldos&"</pre>")
'response.End()
'---------------------------------------------------------------------------------------------------
'***************************************************************************************************
%>
 <html>
<head>
<title><%=pagina.Titulo%></title>  

</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="75%" border="1">
  <tr> 
    <td><div align="center"><strong>Rut</strong></div></td>
    <td><div align="center"><strong>Tipo documento</strong></div></td>
    <td><div align="center"><strong>N° Documento</strong></div></td>
    <td><div align="center"><strong>Correlativo</strong></div></td>
	<td><div align="center"><strong>Detalle</strong></div></td>
	<td><div align="center"><strong>Total</strong></div></td>
	<td><div align="center"><strong>Fecha</strong></div></td>
	<td><div align="center"><strong>Estado</strong></div></td>	
	<td><div align="center"><strong>Periodo</strong></div></td>	
	<td><div align="center"><strong>Sede</strong></div></td>		
  </tr>
  <%  while f_flujo.Siguiente %>
  <tr> 
    <td><div align="left"><%=f_flujo.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=f_flujo.ObtenerValor("tipo_docto")%></div></td>
    <td><div align="left"><%=f_flujo.ObtenerValor("numero_docto")%></div></td>
    <td><div align="left"><%=f_flujo.ObtenerValor("correlativo")%></div></td>
	<td><div align="left"><%=f_flujo.ObtenerValor("detalle")%></div></td>
	<td><div align="right"><%=f_flujo.ObtenerValor("total_docto")%></div></td>
	<td><div align="right"><%=f_flujo.ObtenerValor("fecha_docto")%></div></td>
	<td><div align="left"><%=f_flujo.ObtenerValor("estado_docto")%></div></td>
	<td><div align="left"><%=f_flujo.ObtenerValor("periodo")%></div></td>
	<td><div align="left"><%=f_flujo.ObtenerValor("sede")%></div></td>
  </tr>
  <%  wend %>
</table>
<br/>

<table width="75%" border="1">
  <tr>
	<td><div align="center"><strong>Rut</strong></div></td> 
    <td><div align="center"><strong>Tipo documento</strong></div></td>
	<td><div align="center"><strong>Estado</strong></div></td>	
    <td><div align="center"><strong>N° Documento</strong></div></td>
    <td><div align="center"><strong>Fecha vencimiento</strong></div></td>
	<td><div align="center"><strong>Monto Docto</strong></div></td>
	<td><div align="center"><strong>Saldo Docto</strong></div></td>
  </tr>
  <%  while f_flujo.Siguiente %>
  <tr>
	<td><div align="left"><%=f_saldo.ObtenerValor("rut")%></div></td> 
    <td><div align="left"><%=f_saldo.ObtenerValor("tipo_docto")%></div></td>
	<td><div align="left"><%=f_saldo.ObtenerValor("estado_docto")%></div></td>
    <td><div align="left"><%=f_saldo.ObtenerValor("numero_documento")%></div></td>
    <td><div align="left"><%=f_saldo.ObtenerValor("fecha_vencimiento")%></div></td>
	<td><div align="left"><%=f_saldo.ObtenerValor("total_docto")%></div></td>
	<td><div align="left"><%=f_saldo.ObtenerValor("saldo_documento")%></div></td>
  </tr>
  <%  wend %>
</table>
</body>
</html>