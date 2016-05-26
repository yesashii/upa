<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=detalle_gestion_matricula_sede.xls"
Response.ContentType = "application/vnd.ms-excel"
'---------------------------------------------------------------------------------------------------
sede_ccod= request.QueryString("sede_ccod")
ano_ccod  = request.querystring("ano_ccod")
epot_ccod= request.QueryString("epot_ccod")
dgso_ncorr = request.querystring("dgso_ncorr")
if ano_ccod ="" then 
ano_ccod=0
end if

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion

if sede_ccod="" then
 sede_ccod=conexion.consultaUno("select sede_ccod from sedes where sede_tdesc='"&sede_tdesc&"'")
 end if
if epot_ccod="4" then
epot_ccod="3,4"
end if
sede_tdesc=conexion.consultaUno("select sede_tdesc from sedes where sede_ccod='"&sede_ccod&"'")
 
consulta ="select distinct upper(pers_tape_paterno)+' '+upper(pers_tape_materno)+' '+upper(pers_tnombre) as nombre, "& vbcrlf & _
			" cast(pers_nrut as varchar)+'-'+pers_xdv as rut,a.dgso_ncorr, "& vbcrlf & _
			" (select epot_tdesc from estados_postulacion_otec where epot_ccod=a.epot_ccod)as estado , "& vbcrlf & _
			" protic .trunc (a.audi_fmodificacion) as fecha_post,protic .trunc (d.audi_fmodificacion) as fecha_matr, "& vbcrlf & _
			" (select empr_trazon_social from empresas where empr_ncorr=a.empr_ncorr_empresa)as empresa, "& vbcrlf & _
			" (select empr_trazon_social from empresas where empr_ncorr=a.empr_ncorr_otic)as otic, "& vbcrlf & _
			" (select cast(empr_nrut as varchar)+'-'+empr_xdv as rut from empresas where empr_ncorr=a.empr_ncorr_empresa)as rut_empresa, "& vbcrlf & _
			" (select cast(empr_nrut as varchar)+'-'+empr_xdv as rut from empresas where empr_ncorr=a.empr_ncorr_otic)as rut_otic, "& vbcrlf & _
			"  protic.ES_MOROSO_OTEC(a.pers_ncorr,(select comp_ndocto from postulantes_cargos_otec where pote_ncorr=a.pote_ncorr and pers_ncorr_institucion=a.pers_ncorr)) as deuda_particuar, "& vbcrlf & _
			"  protic.ES_MOROSO_OTEC(a.empr_ncorr_empresa,(select top 1 comp_ndocto from postulantes_cargos_otec where pote_ncorr=a.pote_ncorr and pers_ncorr_institucion=a.empr_ncorr_empresa and tipo_institucion=2)) as deuda_empresa, "& vbcrlf & _
			"  protic.ES_MOROSO_OTEC(a.empr_ncorr_otic,(select top 1 comp_ndocto from postulantes_cargos_otec where pote_ncorr=a.pote_ncorr and pers_ncorr_institucion=a.empr_ncorr_otic and tipo_institucion=3)) as deuda_otic, lower(isnull(b.pers_temail,'--')) as email "& vbcrlf & _
			" from postulacion_otec a "& vbcrlf & _
			" join personas b"& vbcrlf & _
			"	on a.pers_ncorr=b.pers_ncorr"& vbcrlf & _
			"	and a.epot_ccod in ("&epot_ccod&")"& vbcrlf & _
			"	and a.dgso_ncorr="&dgso_ncorr&""& vbcrlf & _
			" join datos_generales_secciones_otec c"& vbcrlf & _
			"	on a.dgso_ncorr=c.dgso_ncorr"& vbcrlf & _
			"	and sede_ccod="&sede_ccod&""& vbcrlf & _
			" left outer join postulantes_cargos_otec d"& vbcrlf & _
			"	on d.pote_ncorr=a.pote_ncorr"& vbcrlf & _
			" order by nombre"

	
	 sede_tdesc=conexion.consultaUno("select sede_tdesc from sedes where sede_ccod='"&sede_ccod&"'")
	curso=conexion.consultaUno("select dcur_tdesc from diplomados_cursos where dcur_ncorr in (select dcur_ncorr from datos_generales_secciones_otec where dgso_ncorr='"&dgso_ncorr&"')")
	
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
<td></td>


<td width="28%" height="17" ><div align="center"><strong>Diplomado/Curso :<%=curso%></strong></div></td>
</tr>

   
  <tr>
		<td width="14%" height="17" ><div align="center"><strong>Sede</strong></div></td>
		<td width="28%" height="17" ><div align="center"><strong>Nombre</strong></div></td>
		<td width="12%" ><div align="center"><strong>Rut</strong></div></td>
        <td width="11%" ><div align="center"><strong>E-mail</strong></div></td>	 
		<td width="18%" ><div align="center"><strong>Fecha Postulacion </strong></div></td>
		<td width="14%" ><div align="center"><strong>Fecha Matricula </strong></div></td>
		<td width="14%" ><div align="center"><strong>Estado</strong></div></td>
		<td width="14%" ><div align="center"><strong>Empresa</strong></div></td>
		<td width="14%" ><div align="center"><strong>Rut Empresa</strong></div></td>
		<td width="14%" ><div align="center"><strong>Otic</strong></div></td> 
		<td width="14%" ><div align="center"><strong>Rut Otic</strong></div></td>
		<td width="11%" ><div align="center"><strong>Deuda particular</strong></div></td>
		<td width="11%" ><div align="center"><strong>Deuda Empresa</strong></div></td> 
		<td width="11%" ><div align="center"><strong>Deuda Otic</strong></div></td>	
  </tr>
  <%  while lista.Siguiente %>
  <tr bordercolor="#999999">
    <td ><div align="left"><%=sede_tdesc%></div></td>
    <td ><div align="left"><%=lista.Obtenervalor("nombre")%></div></td>
    <td ><div align="right"><%=lista.Obtenervalor("rut")%></div></td>
    <td ><div align="left"><%=lista.Obtenervalor("email")%></div></td>
    <td ><div align="right"><%=lista.Obtenervalor("fecha_post")%></div></td>
    <td ><div align="right"><%=lista.Obtenervalor("fecha_matr")%></div></td>
    <td ><div align="right"><%=lista.Obtenervalor("estado")%></div></td>
	<td ><div align="right"><%=lista.Obtenervalor("empresa")%></strong></div></td>
	<td ><div align="right"><%=lista.Obtenervalor("rut_empresa")%></strong></div></td>
	<td ><div align="right"><%=lista.Obtenervalor("otic")%></strong></div></td>
	<td ><div align="right"><%=lista.Obtenervalor("rut_otic")%></strong></div></td>
	<td ><div align="right"><%=lista.Obtenervalor("deuda_particuar")%></div></td>
	<td ><div align="right"><%=lista.Obtenervalor("deuda_empresa")%></div></td>
	<td ><div align="right"><%=lista.Obtenervalor("deuda_otic")%></div></td>	
  </tr>
  <%  wend %>
</table>
</body>
</html>