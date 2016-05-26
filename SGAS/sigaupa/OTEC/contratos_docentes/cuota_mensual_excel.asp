<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=couta_mes.xls"
Response.ContentType = "application/vnd.ms-excel"

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next

q_pers_nrut =Request.QueryString("pers_nrut")
q_pers_xdv = Request.QueryString("pers_xdv")
q_tdet_ccod =Request.QueryString("tdet_ccod")
q_sede_ccod= request.QueryString("sede_ccod")
q_mes_ccod= request.Form("b[0][mes_ccod]")
'---------------------------------------------------------------------------------------------------
'response.Write(q_mes_ccod)
set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion


if q_mes_ccod = "" then
sql_descuentos= "select ''"

else 

anio=conexion.ConsultaUno("select datepart(yyyy,getdate())")

fecha_consulta="28/"&q_mes_ccod&"/"&anio&""

'sql= "select  pers_nrut,cast(pers_nrut as varchar)+'-'+pers_xdv as  rut,pers_tape_paterno,pers_tape_materno,pers_tnombre,((daot_nhora*daot_mhora)/anot_ncuotas)as total,"& vbCrLf &_
'"datepart(yyyy,cdot_finicio)anio_contrato,ccos_tcompuesto,dcur_tdesc,tcdo_tdesc,(select sede_tdesc from sedes yy where yy.sede_ccod=b.sede_ccod)as sede,mote_tdesc,cod_presupuestario"& vbCrLf &_
'"from contratos_docentes_otec a,"& vbCrLf &_
'"anexos_otec b,"& vbCrLf &_
'"detalle_anexo_otec c,"& vbCrLf &_
'"personas d,"& vbCrLf &_
'"mallas_otec e,"& vbCrLf &_
'"centros_costos_asignados f,"& vbCrLf &_
'"centros_costo g,"& vbCrLf &_
'"diplomados_cursos h,"& vbCrLf &_
'"tipos_contratos_docentes i,"& vbCrLf &_
'"secciones_otec j,"& vbCrLf &_
'"datos_generales_secciones_otec k,"& vbCrLf &_
'"modulos_otec l,"& vbCrLf &_
'"ofertas_otec o"& vbCrLf &_
'"where a.cdot_ncorr=b.cdot_ncorr"& vbCrLf &_
'"and b.anot_ncorr=c.anot_ncorr"& vbCrLf &_
'"and a.pers_ncorr=d.pers_ncorr"& vbCrLf &_
'"and ecdo_ccod=1"& vbCrLf &_
'"and eane_ccod=1"& vbCrLf &_
'"and c.mote_ccod=e.mote_ccod"& vbCrLf &_
'"and f.ccos_ccod=g.ccos_ccod"& vbCrLf &_
'"and f.tdet_ccod=h.tdet_ccod"& vbCrLf &_
'"and h.dcur_ncorr=e.dcur_ncorr"& vbCrLf &_
'"and a.tcdo_ccod=i.tcdo_ccod"& vbCrLf &_
'"and c.seot_ncorr=j.seot_ncorr"& vbCrLf &_
'"and j.dgso_ncorr=k.dgso_ncorr"& vbCrLf &_
'"and k.dcur_ncorr=e.dcur_ncorr"& vbCrLf &_
'"and k.dcur_ncorr=e.dcur_ncorr"& vbCrLf &_
'"and e.MAOT_NCORR=j.maot_ncorr"& vbCrLf &_
'"and e.MOTE_CCOD=l.MOTE_CCOD"& vbCrLf &_
'"and k.dgso_ncorr=o.dgso_ncorr"& vbCrLf &_
'"and datepart(yyyy,cdot_finicio)in( datepart(yyyy,getdate()),datepart(yyyy,getdate())-1)"& vbCrLf &_
'"and convert(datetime,'28/"&q_mes_ccod&"/'+cast(datepart(yyyy,getdate())as varchar),103)between convert(datetime,protic.trunc('01/'+cast(datepart(mm,anot_finicio)as varchar)+'/'+cast(datepart(yyyy,anot_finicio)as varchar)),103) and convert(datetime,'28/'+cast(datepart(mm,anot_ffin)as varchar)+'/'+cast(datepart(yyyy,anot_ffin)as varchar),103)"& vbCrLf &_
'"order by pers_tape_paterno,pers_tape_materno"

sql= "select  pers_nrut,cast(pers_nrut as varchar)+'-'+pers_xdv as  rut,pers_tape_paterno,pers_tape_materno,pers_tnombre,((daot_nhora*daot_mhora)/anot_ncuotas)as total,"& vbCrLf &_
"datepart(yyyy,cdot_finicio)anio_contrato,ccos_tcompuesto,dcur_tdesc,tcdo_tdesc,(select sede_tdesc from sedes yy where yy.sede_ccod=b.sede_ccod)as sede,mote_tdesc,cod_presupuestario"& vbCrLf &_
"from contratos_docentes_otec a"& vbCrLf &_
"join anexos_otec b"& vbCrLf &_
"on a.cdot_ncorr=b.cdot_ncorr"& vbCrLf &_
"join detalle_anexo_otec c"& vbCrLf &_
"on b.anot_ncorr=c.anot_ncorr"& vbCrLf &_
"join personas d"& vbCrLf &_
"on a.pers_ncorr=d.pers_ncorr"& vbCrLf &_
"join mallas_otec e"& vbCrLf &_
"on c.mote_ccod=e.mote_ccod"& vbCrLf &_
"join diplomados_cursos h"& vbCrLf &_
"on h.dcur_ncorr=e.dcur_ncorr"& vbCrLf &_
"join tipos_contratos_docentes i"& vbCrLf &_
"on a.tcdo_ccod=i.tcdo_ccod"& vbCrLf &_
"join secciones_otec j"& vbCrLf &_
"on c.seot_ncorr=j.seot_ncorr"& vbCrLf &_
"and e.MAOT_NCORR=j.maot_ncorr"& vbCrLf &_
"join datos_generales_secciones_otec k"& vbCrLf &_
"on j.dgso_ncorr=k.dgso_ncorr"& vbCrLf &_
"and e.dcur_ncorr=k.dcur_ncorr"& vbCrLf &_
"join modulos_otec l"& vbCrLf &_
"on k.dcur_ncorr=e.dcur_ncorr"& vbCrLf &_
"and e.MOTE_CCOD=l.MOTE_CCOD"& vbCrLf &_
"join ofertas_otec o"& vbCrLf &_
"on k.dgso_ncorr=o.dgso_ncorr"& vbCrLf &_
"left outer join centros_costos_asignados f"& vbCrLf &_
"on h.tdet_ccod=f.tdet_ccod"& vbCrLf &_
"left outer join centros_costo g"& vbCrLf &_
"on  f.ccos_ccod=g.ccos_ccod"& vbCrLf &_
"where  ecdo_ccod=1"& vbCrLf &_
"and eane_ccod=1"& vbCrLf &_
"and datepart(yyyy,cdot_finicio)in( datepart(yyyy,getdate()),datepart(yyyy,getdate())-1)"& vbCrLf &_
"and convert(datetime,'28/"&q_mes_ccod&"/'+cast(datepart(yyyy,getdate())as varchar),103)between convert(datetime,protic.trunc('01/'+cast(datepart(mm,anot_finicio)as varchar)+'/'+cast(datepart(yyyy,anot_finicio)as varchar)),103) and convert(datetime,'28/'+cast(datepart(mm,anot_ffin)as varchar)+'/'+cast(datepart(yyyy,anot_ffin)as varchar),103)"& vbCrLf &_
"order by pers_tape_paterno,pers_tape_materno"

'response.Write("<pre>"&sql&"</pre>")	
				'
end if			
				



	
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&q_tdet_ccod&"</pre>")
'response.Write("<pre>"&q_sede_ccod&"</pre>")
'response.Write("<pre>"&sql&"</pre>")
'response.End()
set f_valor_documentos  = new cformulario
f_valor_documentos.carga_parametros "tabla_vacia.xml", "tabla" 
f_valor_documentos.inicializar conexion							
f_valor_documentos.consultar sql

'-------------------------------------------------------------------------------



'response.End()		

'------------------------------------------------------------------------------
%>
 <html>
<head>
<title><%=pagina.Titulo%></title>  

</head>
<body bgcolor="#ffffff" leftmargin="43" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="100%" border="1">

 
  <tr>
    <td width="22%"><div align="up"><strong>Rut sin Digito</strong></div></td>
    <td width="11%"><div align="center"><strong>Rut</strong></div></td>
	<td width="22%"><div align="up"><strong>Apellido Paterno</strong></div></td>
	<td width="22%"><div align="up"><strong>Apellido Materno</strong></div></td>
	<td width="22%"><div align="up"><strong>Nombre</strong></div></td>
    <td width="38%"><div align="center"><strong>Sede</strong></div></td>
	<td width="29%"><div align="center"><strong>Módulo</strong></div></td>
    <td width="29%"><div align="center"><strong>Diplomado/Curso </strong></div></td>
	<td width="29%"><div align="center"><strong>Total</strong></div></td>
	<td width="29%"><div align="center"><strong>Centro Costo</strong></div></td>
	<td width="29%"><div align="center"><strong>Tipo Contrato</strong></div></td>
	<td width="29%"><div align="center"><strong>Codigo Presupuestario</strong></div></td>
  </tr>
  <%  while f_valor_documentos.Siguiente %>
  <tr>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_nrut")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_tape_paterno")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_tape_materno")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_tnombre")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("sede")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("mote_tdesc")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("dcur_tdesc")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("total")%></div></td>
 	<td><div align="left"><%=f_valor_documentos.ObtenerValor("ccos_tcompuesto")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("tcdo_tdesc")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("cod_presupuestario")%></div></td>
  </tr>
  <%  wend %>
</table>
</html>