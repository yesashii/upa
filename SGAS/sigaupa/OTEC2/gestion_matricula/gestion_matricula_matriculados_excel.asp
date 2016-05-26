<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=gestion_matricula_sede.xls"
Response.ContentType = "application/vnd.ms-excel"
'---------------------------------------------------------------------------------------------------
sede_tdesc= request.QueryString("sede_ccod")
sede_ccod=request.QueryString("sede_tdesc")
ano_ccod  = request.querystring("busqueda[0][ano_ccod]")
ano_ccod2  = request.querystring("ano_ccod")

if ano_ccod2 ="" then
ano_ccod2=0
end if
if ano_ccod="" then
ano_ccod=ano_ccod2
end if

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion

if sede_ccod="" then
 sede_ccod=conexion.consultaUno("select sede_ccod from sedes where sede_tdesc='"&sede_tdesc&"'")
 end if
 
consulta ="select dcur_tdesc,esot_tdesc,dgso_ncorr,dgo.sede_ccod,dgso_nquorum,pendiente,aprobado,matriculado,protic.trunc(dgso_finicio)as dgso_finicio,protic.trunc(dgso_ftermino)as dgso_ftermino"& vbcrlf & _
"from(select mmm.dcur_ncorr, isnull(count(pendiente),0)as pendiente,isnull(count(aprobado),0)as aprobado,isnull(count(matriculado),0)as matriculado"& vbcrlf & _
"from(select dgo.sede_ccod,dgo.dcur_ncorr,"& vbcrlf & _
"case when epot_ccod =1 then epot_ccod end as  pendiente,"& vbcrlf & _
"case when epot_ccod =2 then epot_ccod end as  aprobado,"& vbcrlf & _
"case when epot_ccod in (3,4) then epot_ccod end as  matriculado"& vbcrlf & _
"from diplomados_cursos dc right outer join datos_generales_secciones_otec dgo"& vbcrlf & _
"on dgo.dcur_ncorr=dc.dcur_ncorr"& vbcrlf & _
"left outer join postulacion_otec pot"& vbcrlf & _
"on pot.dgso_ncorr=dgo.dgso_ncorr"& vbcrlf & _
"right outer join ofertas_otec oot"& vbcrlf & _
"on dgo.dcur_ncorr=oot.dcur_ncorr"& vbcrlf & _
"where dgo.sede_ccod='"&sede_ccod&"'"& vbcrlf & _
"and anio_admision="&ano_ccod&")as mmm"& vbcrlf & _
"group by mmm.dcur_ncorr)as nnn,datos_generales_secciones_otec dgo,diplomados_cursos dc,estado_seccion_otec ff"& vbcrlf & _
"where nnn.dcur_ncorr=dgo.dcur_ncorr"& vbcrlf & _
"and nnn.dcur_ncorr=dc.dcur_ncorr"& vbcrlf & _
"and dgo.sede_ccod='"&sede_ccod&"'"& vbcrlf & _
"and dgo.esot_ccod=ff.esot_ccod"& vbcrlf & _
"order by dgso_finicio"



'"select dcur_tdesc,dgso_nquorum,pendiente,aprobado,matriculado"& vbcrlf & _
'"from(select mmm.dcur_ncorr, isnull(count(pendiente),0)as pendiente,isnull(count(aprobado),0)as aprobado,isnull(count(matriculado),0)as matriculado"& vbcrlf & _
'"from(select dgo.sede_ccod,dgo.dcur_ncorr,"& vbcrlf & _
'"case when epot_ccod =1 then epot_ccod end as  pendiente,"& vbcrlf & _
'"case when epot_ccod =2 then epot_ccod end as  aprobado,"& vbcrlf & _
'"case when epot_ccod in (3,4) then epot_ccod end as  matriculado"& vbcrlf & _
'"from diplomados_cursos dc,datos_generales_secciones_otec dgo,postulacion_otec pot,ofertas_otec oot"& vbcrlf & _
'"where pot.dgso_ncorr=dgo.dgso_ncorr"& vbcrlf & _
'"and dgo.dcur_ncorr=dc.dcur_ncorr"& vbcrlf & _
'"and dgo.sede_ccod='"&sede_ccod&"'" & vbcrlf & _
'"and dgo.dcur_ncorr=oot.dcur_ncorr"& vbcrlf & _
'"and anio_admision="&ano_ccod&")as mmm"& vbcrlf & _
'"group by mmm.dcur_ncorr)as nnn,datos_generales_secciones_otec dgo,diplomados_cursos dc"& vbcrlf & _
'"where nnn.dcur_ncorr=dgo.dcur_ncorr"& vbcrlf & _
'"and nnn.dcur_ncorr=dc.dcur_ncorr"

consulta2="select isnull(count(pendiente),0)as t_pendiente,isnull(count(aprobado),0)as t_aprobado,isnull(count(matriculado),0)as t_matriculado"& vbcrlf & _
"from(select dcur_tdesc,sede_ccod,"& vbcrlf & _
"case when epot_ccod =1 then epot_ccod end as  pendiente,"& vbcrlf & _
"case when epot_ccod =2 then epot_ccod end as  aprobado,"& vbcrlf & _
"case when epot_ccod in (3,4) then epot_ccod end as  matriculado"& vbcrlf & _
 "from diplomados_cursos dc,datos_generales_secciones_otec dgo,postulacion_otec pot"& vbcrlf & _
"where pot.dgso_ncorr=dgo.dgso_ncorr"& vbcrlf & _
"and dgo.dcur_ncorr=dc.dcur_ncorr"& vbcrlf & _
"and sede_ccod="&sede_ccod&")as mm"

	
	 sede_tdesc=conexion.consultaUno("select sede_tdesc from sedes where sede_ccod='"&sede_ccod&"'")
	
'response.Write("<pre>"&sede_tdesc&"</pre>")
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
  
  <td width="16%" height="17" ><div align="center"><strong>Sede</strong></div></td>
   <td width="48%" height="17" ><div align="center"><strong>Carrera</strong></div></td>
   <td width="6%" ><div align="center"><strong>Fecha Incio</strong></div></td>
    <td width="6%" ><div align="center"><strong>Fecha Termino</strong></div></td>
	<td width="6%" ><div align="center"><strong>Estado</strong></div></td>
  <td width="12%" ><div align="center"><strong>Pendientes</strong></div></td>
  <td width="12%" ><div align="center"><strong>Aprobados</strong></div></td>
  <td width="12%" ><div align="center"><strong>Matriculados</strong></div></td>
   <td width="12%" ><div align="center"><strong>Meta</strong></div></td>

   
  </tr>
   
  <%  while lista.Siguiente 
  total_pendiente = total_pendiente  + cdbl(lista.Obtenervalor("pendiente"))
		total_aprobado = total_aprobado  + cdbl(lista.Obtenervalor("aprobado"))
		total_matriculado = total_matriculado  + cdbl(lista.Obtenervalor("matriculado"))
		total_meta = total_meta  + cdbl(lista.Obtenervalor("dgso_nquorum"))%>
  <tr borderColor="#999999"> 
    
    <td ><div align="left"><%=sede_tdesc%></div></td>
	<td ><div align="left"><%=lista.Obtenervalor("dcur_tdesc")%></div></td>
	<td ><div align="left"><%=lista.Obtenervalor("dgso_finicio")%></div></td>
	<td ><div align="left"><%=lista.Obtenervalor("dgso_ftermino")%></div></td>
	<td ><div align="left"><%=lista.Obtenervalor("esot_tdesc")%></div></td>
	<td ><div align="right"><%=lista.Obtenervalor("pendiente")%></div></td>
	<td ><div align="right"><%=lista.Obtenervalor("aprobado")%></div></td>
	<td ><div align="right"><%=lista.Obtenervalor("matriculado")%></div></td>
	<td ><div align="right"><%=lista.Obtenervalor("dgso_nquorum")%></div></td>
	
  </tr>
   
  
  
      <% wend %>
	   <%  while lista2.Siguiente %>
  <tr> 
    
    <td colspan="5"><div align="center"><strong>Total</strong></div></td>
	<td ><div align="right"><strong><%=total_pendiente%></strong></div></td>
	<td ><div align="right"><strong><%=total_aprobado%></strong></div></td>
	 <td ><div align="right"><strong><%=total_matriculado%></strong></div></td>
	  <td ><div align="right"><strong><%=total_meta%></strong></div></td>
	  
  </tr>
  <%  wend %>
</table>
</body>
</html>