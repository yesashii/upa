<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=listado_descuentos_x_usuario.xls"
Response.ContentType = "application/vnd.ms-excel"

q_carr_ccod=request.QueryString("carr_ccod")
q_peri_ccod = Request.QueryString("peri_ccod")
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion


	  sql_descuentos=   "select  distinct pers_nrut,pers_xdv,per.pers_tnombre+' '+per.pers_tape_paterno+' '+per.pers_tape_materno as nombre , carr_tdesc ,pers_temail,pers_tfono,pers_tcelular"& vbCrLf &_
				  "from alumnos a, "& vbCrLf &_
                  "postulantes pos,"& vbCrLf &_
			      "personas per,"& vbCrLf &_
                  "ofertas_academicas oa,"& vbCrLf &_
                  "especialidades espe,"& vbCrLf &_
                  "carreras car,"& vbCrLf &_
                  "sedes sede" & vbCrLf &_
                  "where a.post_ncorr=pos.post_ncorr"& vbCrLf &_
                  "and pos.pers_ncorr = per.pers_ncorr"& vbCrLf &_
                  "and pos.peri_ccod ='"&q_peri_ccod&"' "& vbCrLf &_
                  "and a.ofer_ncorr = oa.ofer_ncorr"& vbCrLf &_
                  "and oa.espe_ccod=espe.espe_ccod"& vbCrLf &_
                  "and espe.carr_ccod = car.carr_ccod"& vbCrLf &_
                  "and car.carr_ccod= '"&q_carr_ccod&"' "

	
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.End()
set f_valor_documentos  = new cformulario
f_valor_documentos.carga_parametros "tabla_vacia.xml", "tabla" 
f_valor_documentos.inicializar conexion							
f_valor_documentos.consultar sql_descuentos

'------------------------------------------------------------------------------
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
   <td><div align="center"><strong>Nombre</strong></div></td>
  <td><div align="center"><strong>Fono</strong></div></td>
    <td><div align="center"><strong>Celular</strong></div></td>
	<td><div align="center"><strong>Carrera</strong></div></td>
	
	
  </tr>
  <%  while f_valor_documentos.Siguiente %>
  <tr> 
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("nombre")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_tfono")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("pers_tcelular")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("carr_tdesc")%></div></td>
	    
  </tr>
  <%  wend %>
</table>
</body>
</html>