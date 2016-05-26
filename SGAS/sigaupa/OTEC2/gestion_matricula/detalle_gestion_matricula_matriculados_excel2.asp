<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=detalle_gestion_matricula.xls"
Response.ContentType = "application/vnd.ms-excel"
'---------------------------------------------------------------------------------------------------
sede_ccod= request.QueryString("sede_ccod")
ano_ccod  = request.querystring("ano_ccod")
epot_ccod= request.QueryString("epot_ccod")
dgso_ncorr = request.querystring("dgso_ncorr")
if ano_ccod ="" then 
ano_ccod=0
end if
'response.Write("<pre> sede= "&sede_ccod&"</pre>")
'response.Write("<pre> año= "&ano_ccod&"</pre>")
'response.Write("<pre>epot= "&epot_ccod&"</pre>")
'response.Write("<pre> dgso= "&dgso_ncorr&"</pre>")
'response.End()


 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "gestion_matricula_otec.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 

 




set f_botonera = new CFormulario
f_botonera.Carga_Parametros "gestion_matricula_otec.xml", "botonera"

v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")

set lista = new CFormulario
lista.carga_parametros "gestion_matricula_otec.xml", "detalle_gestion_matricula"
lista.inicializar conexion


 sede_tdesc=conexion.consultaUno("select sede_tdesc from sedes where sede_ccod='"&sede_ccod&"'")
 
consulta ="select upper(pers_tape_paterno)+' '+upper(pers_tape_materno)+' '+upper(pers_tnombre) as nombre,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,a.dgso_ncorr,(select epot_tdesc from estados_postulacion_otec where epot_ccod=a.epot_ccod)as estado ,protic .trunc (a.audi_fmodificacion) as fecha_post"& vbcrlf & _
"from postulacion_otec a,personas b,datos_generales_secciones_otec c"& vbcrlf & _
"where a.pers_ncorr=b.pers_ncorr"& vbcrlf & _
"and a.dgso_ncorr=c.dgso_ncorr"& vbcrlf & _
"and a.dgso_ncorr="&dgso_ncorr&""& vbcrlf & _
"and sede_ccod="&sede_ccod&""& vbcrlf & _
"and epot_ccod="&epot_ccod&""& vbcrlf & _
"order by nombre"


	
	
	
'response.Write("<pre>"&sede_tdesc&"</pre>")
'response.Write("<pre>"&consulta&"</pre>")
'response.Write("<pre>"&consulta2&"</pre>")
'response.End()
set lista  = new cformulario
lista.carga_parametros "tabla_vacia.xml", "tabla" 
lista.inicializar conexion							
lista.consultar consulta




'------------------------------------------------------------------------------
%>
 <html>
<head>
<title><%=pagina.Titulo%></title>  

</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="93%" border="1" align="center">
  <tr> 
  
  <td width="16%" height="17" ><div align="center"><strong>Sede</strong></div></td>
   <td width="48%" height="17" ><div align="center"><strong>Nombre</strong></div></td>
  <td width="12%" ><div align="center"><strong>Rut</strong></div></td>
  <td width="12%" ><div align="center"><strong>Fecha Postulacion</strong></div></td>
  <td width="12%" ><div align="center"><strong>Fecha Matricula </strong></div></td>
   <td width="12%" ><div align="center"><strong>Estado </strong></div></td>

   
  </tr>
   
  <%  while lista.Siguiente %>
  <tr borderColor="#999999"> 
    
    <td ><div align="left"><%=sede_tdesc%></div></td>
	<td ><div align="left"><%=lista.Obtenervalor("nombre")%></div></td>
	<td ><div align="right"><%=lista.Obtenervalor("rut")%></div></td>
	<td ><div align="right"><%=lista.Obtenervalor("fecha_post")%></div></td>
	<td ><div align="right"><%=lista.Obtenervalor("fecha_mtra")%></div></td>
	<td ><div align="right"><%=lista.Obtenervalor("estado")%></div></td>
	
  </tr>
   
  
  
      <%  wend %>
	
</table>
</body>
</html>