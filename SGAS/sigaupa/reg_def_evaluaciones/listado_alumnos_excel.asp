<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=alumnos_carrera.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

carr_ccod  = request.QueryString("carr_ccod")
peri_ccod = negocio.obtenerPeriodoAcademico("TOMACARGA")
'------------------------------------------------------------------------------------
set tabla = new cformulario
tabla.carga_parametros	"tabla_vacia.xml",	"tabla"
tabla.inicializar		conexion


consulta = " select e.asig_ccod as cod_asignatura,e.asig_tdesc as asignatura,b.secc_tdesc, "& vbCrLf	&_
		   " cast(d.pers_nrut as varchar)+'-'+d.pers_xdv as rut, pers_tnombre as nombres, pers_tape_paterno + ' ' + pers_tape_materno as apellidos, "& vbCrLf	&_
		   " a.carg_nnota_final as nota, isnull(a.sitf_ccod,'') as situación_final  "& vbCrLf	&_
		   " from cargas_academicas a, secciones b, alumnos c, personas d,asignaturas e "& vbCrLf	&_
		   " where a.secc_ccod=b.secc_ccod "& vbCrLf	&_
		   " and cast(b.peri_ccod as varchar)='"&peri_ccod&"' "& vbCrLf	&_
		   " and b.carr_ccod = '"&carr_ccod&"' "& vbCrLf	&_
		   " and a.matr_ncorr=c.matr_ncorr and c.pers_ncorr=d.pers_ncorr "& vbCrLf	&_
		   " and b.asig_ccod=e.asig_ccod "& vbCrLf	&_
		   " order by e.asig_ccod,asig_tdesc, secc_tdesc, apellidos "
			
'response.write("<pre>"&consulta&"</pre>")
tabla.consultar consulta 

carrera = conexion.consultaUno("select carr_tdesc from carreras where carr_ccod = '"&carr_ccod&"'")
periodo = conexion.consultaUno("select peri_tdesc from periodos_academicos where peri_ccod = '"&peri_ccod&"'")
fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
%>
<html>
<head>
<title>Listado de Alumnos</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="2"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado alumnos por Carrera.</font></div>
	<div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr>
    <td width="5%"><strong>Fecha</strong></td>
    <td width="95%" colspan="3"> <strong>:</strong> <%=fecha%></td>
 </tr>
 <tr>
    <td width="5%"><strong>Carrera</strong></td>
    <td width="95%" colspan="3"> <strong>:</strong> <%=carrera%></td>
 </tr>
 <tr>
    <td width="5%"><strong>Periodo</strong></td>
    <td width="95%" colspan="3"> <strong>:</strong> <%=periodo%></td>
 </tr>
 
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td><div align="center"><strong>Fila</strong></div></td>
    <td><div align="center"><strong>Cod. Asignatura</strong></div></td>
    <td><div align="center"><strong>Asignatura</strong></div></td>
	<td><div align="center"><strong>Sección</strong></div></td>
	<td><div align="center"><strong>Rut</strong></div></td>
    <td><div align="center"><strong>Nombres</strong></div></td>
	<td><div align="center"><strong>Apellidos</strong></div></td>
	<td><div align="center"><strong>Calificación</strong></div></td>
	<td><div align="center"><strong>Sit. Final</strong></div></td>
  </tr>
  <%  
  fila=1  
  while tabla.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("cod_asignatura")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("asignatura")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("secc_tdesc")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("nombres")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("apellidos")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("nota")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("situación_final")%></div></td>
  </tr>
  <% fila=fila +1 
   wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>