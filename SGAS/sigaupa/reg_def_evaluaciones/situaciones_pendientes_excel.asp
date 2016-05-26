<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=evaluaciones.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

carr_ccod  = request.QueryString("carr_ccod")

'------------------------------------------------------------------------------------
set tabla = new cformulario
tabla.carga_parametros	"tabla_vacia.xml",	"tabla"
tabla.inicializar		conexion


consulta = " select i.anos_ccod,i.peri_tdesc as periodo, c.sede_tdesc as sede, d.carr_tdesc as carrera,e.jorn_tdesc as jornada, "& vbCrLf	&_
		   " cast(g.pers_nrut as varchar)+'-'+g.pers_xdv as rut, g.pers_tnombre + ' ' + g.pers_tape_paterno+' '+g.pers_tape_materno as alumno, "& vbCrLf	&_
		   " h.asig_ccod as cod_asignatura,h.asig_tdesc as asignatura,'M '+cast(b.matr_ncorr as varchar)+ ' S '+ cast(b.secc_ccod as varchar) as cod_interno  "& vbCrLf	&_
		   " from secciones a, cargas_academicas b,sedes c, carreras d, jornadas e,alumnos f, personas g,asignaturas h,periodos_Academicos i  "& vbCrLf	&_
		   " where a.carr_ccod='"&carr_ccod&"' and a.secc_ccod = b.secc_ccod "& vbCrLf	&_
		   " and b.sitf_ccod='SP' "& vbCrLf	&_
		   " and a.sede_ccod = c.sede_ccod and a.carr_ccod= d.carr_ccod "& vbCrLf	&_
		   " and a.jorn_ccod = e.jorn_ccod and b.matr_ncorr = f.matr_ncorr "& vbCrLf	&_
		   " and f.pers_ncorr = g.pers_ncorr and a.asig_ccod=h.asig_ccod "& vbCrLf	&_
		   " and a.peri_ccod = i.peri_ccod "& vbCrLf	&_
		   " order by anos_ccod,periodo,sede,jornada asc "
			
'response.write("<pre>"&consulta&"</pre>")
tabla.consultar consulta 


fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
%>
<html>
<head>
<title>Listado de Alumnos que presentan situación pendiente</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Alumnos que presentan situación pendiente en la Carrera.</font></div>
	<div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
    <td width="5%"><strong>Fecha</strong></td>
    <td width="95%" colspan="3"> <strong>:</strong> <%=fecha%></td>
 </tr>
 
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td><div align="center"><strong>Fila</strong></div></td>
    <td><div align="center"><strong>Periodo</strong></div></td>
    <td><div align="center"><strong>Sede</strong></div></td>
	<td><div align="center"><strong>Carrera</strong></div></td>
    <td><div align="center"><strong>Jornada</strong></div></td>
	<td><div align="center"><strong>Rut</strong></div></td>
    <td><div align="center"><strong>Nombre Alumno</strong></div></td>
	<td><div align="center"><strong>Cód. Asignatura</strong></div></td>
	<td><div align="center"><strong>Asignatura</strong></div></td>
	<td><div align="center"><strong>Cód. Interno</strong></div></td>
  </tr>
  <%  
  fila=1  
  while tabla.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("periodo")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("sede")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("carrera")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("jornada")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("alumno")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("cod_asignatura")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("asignatura")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("cod_interno")%></div></td>
  </tr>
  <% fila=fila +1 
   wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>