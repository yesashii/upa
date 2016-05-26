<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=asignaturas.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

carr_ccod  = request.QueryString("carr_ccod")
codigo  = carr_ccod
carrera = conexion.consultaUno("Select carr_tdesc from carreras where cast(carr_ccod as varchar)='"&carr_ccod&"'")
if codigo="" then
	codigo="Todas las carreras"
	carrera = "Todas las carreras"
end if	

periodo=negocio.obtenerPeriodoAcademico("Postulacion")
nombre_periodo = conexion.consultaUno("Select protic.initcap(peri_tdesc) from periodos_Academicos where cast(peri_ccod as varchar)='"&periodo&"'")

'------------------------------------------------------------------------------------
set tabla = new cformulario
tabla.carga_parametros	"tabla_vacia.xml",	"tabla"
tabla.inicializar		conexion

if carr_ccod <> "" then
	filtro_carrera = " and cast(a.carr_ccod as varchar)='"&carr_ccod&"'"
else
	filtro_carrera = ""
end if

 consulta = " select a.pobe_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, protic.initcap(b.pers_tape_paterno + ' ' + b.pers_tape_materno+ ' ' + b.pers_tnombre) as postulante,"& vbCrLf &_
			" pobe_ningreso_revisado as ingresos,pobe_nintegrantes_revisado as Nintegrantes,pobe_ncapacidad_pago as capacidad,protic.initcap(c.carr_tdesc) as carrera, "& vbCrLf &_
			" isnull(cast(pobe_nresolucion as varchar),'') as nresolucion, "& vbCrLf &_
			" protic.trunc(pobe_fobtencion) as fecha_obtencion,aran_mmatricula as matricula, aran_mcolegiatura as arancel,	"& vbCrLf &_
			" cast(isnull(cast(pobe_nporcentaje_asignado as varchar),'') as varchar) + ' %' as porcentaje "& vbCrLf &_
			" from postulacion_becas a, personas_postulante b,carreras c,ofertas_academicas d, aranceles e "& vbCrLf &_
			" where a.pers_ncorr=b.pers_ncorr and a.epob_ccod=2  and a.carr_ccod=c.carr_ccod"& vbCrLf &_
			" and cast(a.peri_ccod as varchar)='"&periodo&"' " &filtro_carrera& vbCrLf &_
			" and a.ofer_ncorr = d.ofer_ncorr and d.aran_ncorr=e.aran_ncorr " &vbCrLf &_
			" ORDER BY capacidad asc "
'response.Write("<pre>"&consulta&"</pre>")
tabla.consultar consulta 

'response.End()
fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
%>
<html>
<head>
<title>Listado de Carreras</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado Postulaciones Becas.</font></div>
	<div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Cod. Carrera</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=codigo%> </td>
    
  </tr>
  <tr> 
    <td><strong>Carrera</strong></td>
    <td colspan="3"><strong>:</strong> <%=carrera%> </td>
  </tr>
  <tr> 
    <td><strong>Periodo</strong></td>
    <td colspan="3"><strong>:</strong> <%=nombre_periodo%> </td>
  </tr>
  <tr>
    <td><strong>Fecha</strong></td>
    <td colspan="3"> <strong>:</strong> <%=fecha%></td>
 </tr>
 
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="3%"><div align="center"><strong>Fila</strong></div></td>
    <td width="7%"><div align="center"><strong>Rut</strong></div></td>
    <td width="15%"><div align="center"><strong>Nombre Postulante</strong></div></td>
	 <td width="10%"><div align="center"><strong>Carrera</strong></div></td>
	<td width="5%"><div align="center"><strong>Ingresos G.F</strong></div></td>
    <td width="5%"><div align="center"><strong>Integrantes</strong></div></td>
	<td width="5%"><div align="center"><strong>Capacidad Pago</strong></div></td>
	<td width="5%"><div align="center"><strong>Resoluci&oacute;n</strong></div></td>
    <td width="5%"><div align="center"><strong>Fecha</strong></div></td>
	<td width="10%"><div align="center"><strong>Matricula</strong></div></td>
	<td width="10%"><div align="center"><strong>Arancel</strong></div></td>
	<td width="10%"><div align="center"><strong>Porcentaje</strong></div></td>
  </tr>
  <%  
  fila=1  
  while tabla.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("postulante")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("carrera")%></div></td>
    <td><div align="center"><%=formatcurrency(tabla.ObtenerValor("ingresos"),0)%></div></td>
    <td><div align="center"><%=tabla.ObtenerValor("Nintegrantes")%></div></td>
	<td><div align="left"><%=formatcurrency(tabla.ObtenerValor("capacidad"),0)%></div></td>
	<td><div align="center"><%=tabla.ObtenerValor("nresolucion")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("fecha_obtencion")%></div></td>
	<td><div align="left"><%=formatcurrency(tabla.ObtenerValor("matricula"),0)%></div></td>
	<td><div align="left"><%=formatcurrency(tabla.ObtenerValor("arancel"),0)%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("porcentaje")%></div></td>
  </tr>
  <% fila=fila +1 
   wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>