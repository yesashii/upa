<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=gestion_matricula.xls"
Response.ContentType = "application/vnd.ms-excel"
'---------------------------------------------------------------------------------------------------
ano_ccod  = request.querystring("ano_ccod")
if ano_ccod ="" then 
ano_ccod=0
end if

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion



consulta = "select sede_tdesc,count(pendiente)as pendiente,count(aprobado) as aprobado,count(matriculado)as matriculado  from"& vbcrlf & _
"(select dgot.sede_ccod,"& vbcrlf & _
"case when epot_ccod =1 then epot_ccod end as  pendiente,"& vbcrlf & _
"case when epot_ccod =2 then epot_ccod end as  aprobado,"& vbcrlf & _
"case when epot_ccod in (3,4) then epot_ccod end as  matriculado"& vbcrlf & _
"from postulacion_otec pot,datos_generales_secciones_otec dgot,ofertas_otec oot"& vbcrlf & _
"where pot.dgso_ncorr=dgot.dgso_ncorr"& vbcrlf & _
"and dgot.dcur_ncorr=oot.dcur_ncorr"& vbcrlf & _
"and anio_admision="&ano_ccod&")as mm,sedes s"& vbcrlf & _
"where mm.sede_ccod=s.sede_ccod"& vbcrlf & _
"group by sede_tdesc"

consulta2="select count(pendiente)as t_pendiente,count(aprobado) as t_aprobado,count(matriculado)as t_matriculado  from"& vbcrlf & _
"(select dgot.sede_ccod,"& vbcrlf & _
"case when epot_ccod =1 then epot_ccod end as  pendiente,"& vbcrlf & _
"case when epot_ccod =2 then epot_ccod end as  aprobado,"& vbcrlf & _
"case when epot_ccod in (3,4) then epot_ccod end as  matriculado"& vbcrlf & _
"from postulacion_otec pot,datos_generales_secciones_otec dgot,ofertas_otec oot"& vbcrlf & _
"where pot.dgso_ncorr=dgot.dgso_ncorr"& vbcrlf & _
"and dgot.dcur_ncorr=oot.dcur_ncorr"& vbcrlf & _
"and anio_admision="&ano_ccod&")as mm"


	
	
'response.Write("<pre>"&ano_ccod&"</pre>")	
'response.Write("<pre>"&consulta&"</pre>")
'response.Write("<pre>"&consulta2&"</pre>")
'response.End()
set lista  = new cformulario
lista.carga_parametros "tabla_vacia.xml", "tabla" 
lista.inicializar conexion							
lista.consultar consulta



set lista2  = new cformulario
lista2.carga_parametros "tabla_vacia.xml", "tabla" 
lista2.inicializar conexion							
lista2.consultar consulta2

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
  
  <td width="24%" height="17"><div align="center"><strong>Sedes</strong></div></td>
  <td width="24%"><div align="center"><strong>Pendientes</strong></div></td>
  <td width="26%"><div align="center"><strong>Aprobados</strong></div></td>
  <td width="26%"><div align="center"><strong>Matriculados</strong></div></td>

   
  </tr>
   
  <%  while lista.Siguiente %>
  <tr> 
    
    <td><div align="left"><%=lista.Obtenervalor("sede_tdesc")%></div></td>
	<td><div align="right"><%=lista.Obtenervalor("pendiente")%></div></td>
	<td ><div align="right"><%=lista.Obtenervalor("aprobado")%></div></td>
	<td ><div align="right"><%=lista.Obtenervalor("matriculado")%></div></td>
	
  </tr>
   
  
  
      <%  wend %>
	   <%  while lista2.Siguiente %>
  <tr> 
    
    <td><div align="center"><strong>Total</strong></div></td>
	<td><div align="right"><strong><%=lista2.Obtenervalor("t_pendiente")%></strong></div></td>
	<td ><div align="right"><strong><%=lista2.Obtenervalor("t_aprobado")%></strong></div></td>
	 <td ><div align="right"><strong><%=lista2.Obtenervalor("t_matriculado")%></strong></div></td>
	  
  </tr>
  <%  wend %>
</table>
</body>
</html>