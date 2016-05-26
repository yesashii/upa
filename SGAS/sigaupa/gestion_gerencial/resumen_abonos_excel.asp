<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 150000 
Response.AddHeader "Content-Disposition", "attachment;filename=resumen_excel_abonos_flujos.xls"
Response.ContentType = "application/vnd.ms-excel"
 
'---------------------------------------------------------------------------------------------------


'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion

v_fecha_corte  = request.querystring("busqueda[0][ding_fdocto]")

'**********************************************************************************
set f_flujo = new CFormulario
f_flujo.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_flujo.inicializar conexion 
		

sql_abonados=	"select  top 100 protic.obtener_rut(e.pers_ncorr) as rut,d.ting_tdesc as tipo_documento,c.ding_ndocto numero_documento, protic.trunc(c.ding_fdocto) as fecha_vencimiento, " & vbCrLf &_
				" c.ding_mdocto- protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo_documento" & vbCrLf &_
               	" 	from     " & vbCrLf &_
               	" 	compromisos a " & vbCrLf &_    
              	" 	join  detalle_compromisos b     " & vbCrLf &_
              	"  		on a.tcom_ccod = b.tcom_ccod        " & vbCrLf &_
              	"  		and a.inst_ccod = b.inst_ccod        " & vbCrLf &_
              	"  		and a.comp_ndocto = b.comp_ndocto " & vbCrLf &_
              	"  		and a.ecom_ccod = '1' " & vbCrLf &_
            	" 	join  detalle_ingresos c     " & vbCrLf &_
              	"  		on c.ting_ccod in(3,4,13,38,51,52,59,66) " & vbCrLf &_
              	"  		and c.edin_ccod not in (6,11) " & vbCrLf &_  
             	"  		and  protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')    = c.ting_ccod " & vbCrLf &_
              	"  		and  protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto " & vbCrLf &_
              	"  		and  protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr')  = c.ingr_ncorr " & vbCrLf &_
        		"	join tipos_ingresos d " & vbCrLf &_ 
            	" 		on c.ting_ccod=d.ting_ccod " & vbCrLf &_ 
				" 	join  ingresos e " & vbCrLf &_
              	"  		on c.ingr_ncorr=e.ingr_ncorr " & vbCrLf &_
              	"  		and e.eing_ccod not in (3,6)  " & vbCrLf &_          
        		" where protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0 " & vbCrLf &_
        		" and protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso)< c.ding_mdocto"


		if not Esvacio(Request.QueryString) then
			f_flujo.Consultar sql_abonados

		else
			vacia = "select '' where 1=2 "
			
			f_flujo.Consultar vacia
			f_flujo.AgregaParam "mensajeError", "Ingrese criterio de búsqueda"
		end if

%>
<html>
<head>
<title>Flujo de vencimientos</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif"> Flujo de vencimientos </font></div>
	  <div align="right"></div></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
  </tr>
</table>

<font color="#0000FF" size="+1" ><strong>Resumen</strong></font>
<table width="100%" border="1">
	   <tr> 
		<td bgcolor="#66CC99" colspan="10"><div align="center"><strong>Detalle Documentos</strong></div></td>
	  </tr>

  <tr> 
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>rut</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>tipo_docto</strong></div></td>
    <td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>numero_docto</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>fecha_docto</strong></div></td>
	<td width="10%" bgcolor="#FFFFCC"><div align="center"><strong>saldo_documento</strong></div></td>
  </tr>
  <% fila = 1 
     while f_flujo.Siguiente %>
  <tr> 
	<td><div align="center"><%=f_flujo.ObtenerValor("rut")%></div></td>
    <td><div align="center"><%=f_flujo.ObtenerValor("tipo_documento")%></div></td>
	<td><div align="center"><%=f_flujo.ObtenerValor("numero_documento")%></div></td>
	<td><div align="center"><%=f_flujo.ObtenerValor("fecha_vencimiento")%></div></td>
	<td><div align="center"><%=f_flujo.ObtenerValor("saldo_documento")%></div></td>
  </tr>
<%
  wend %>
</table>
<p></p>
<p></p>
</body>
</html>