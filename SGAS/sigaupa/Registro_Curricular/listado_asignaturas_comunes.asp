<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=asignaturas_comunes.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_peri_ccod=negocio.obtenerPeriodoAcademico("Postulacion")
'-----------------------------------------------------------------------

carr_ccod=request.QueryString("carr_ccod")

set tabla = new cformulario
tabla.carga_parametros	"tabla_vacia.xml",	"tabla"
tabla.inicializar		conexion

consulta = " select e.nive_ccod as nivel,a.mall_ccod as mall_ccod2,a.mall_ccod,c.espe_tdesc as especialidad,b.plan_tdesc as plan_est, " & vbCrLf & _
		   " d.asig_ccod as cod_asignatura, d.asig_tdesc as asignatura,asig_nhoras " & vbCrLf & _
		   " from asignaturas_comunes a, planes_estudio b, especialidades c, asignaturas d,malla_curricular e " & vbCrLf & _
		   " where a.carr_ccod='"&carr_ccod&"' and a.plan_ccod=b.plan_ccod " & vbCrLf & _
		   " and b.espe_ccod=c.espe_ccod and a.asig_ccod=d.asig_ccod " & vbCrLf & _
		   " and e.mall_ccod=a.mall_ccod " & vbCrLf & _
		   " order by nivel,especialidad,plan_est "

tabla.Consultar consulta

fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
carrera=conexion.consultaUno("select carr_tdesc from carreras where carr_ccod='"&carr_ccod&"'")

'------------------------------------------------------------------------------------
%>
<html>
<head>
<title>Asignaturas comunes</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Asignaturas Comunes de la carrera </font></div>
	  <div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Carrera</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <% =carrera%> </td>
    
  </tr>
  <tr> 
    <td><strong>Fecha Impresi&oacute;n </strong></td>
    <td colspan="3"><strong>:</strong> <%=fecha%> </td>
  </tr>
   
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="3%"><div align="center"><strong>Nivel</strong></div></td>
	<td width="15%"><div align="center"><strong>Especialidad</strong></div></td>
	<td width="15%"><div align="center"><strong>Plan Estudios</strong></div></td>
    <td width="7%"><div align="center"><strong>Código</strong></div></td>
    <td width="25%"><div align="center"><strong>Asignatura</strong></div></td>
	<td width="5%"><div align="center"><strong>Horas</strong></div></td>
  </tr>
  <%  while tabla.Siguiente %>
  <tr> 
    <td><div align="center"><%=tabla.ObtenerValor("nivel")%></div></td>
	<td><div align="center"><%=tabla.ObtenerValor("especialidad")%></div></td>
	<td><div align="center"><%=tabla.ObtenerValor("plan_est")%></div></td>
    <td><div align="center"><%=tabla.ObtenerValor("cod_asignatura")%></div></td>
    <td><div align="center"><%=tabla.ObtenerValor("asignatura")%></div></td>
    <td><div align="center"><%=tabla.ObtenerValor("asig_nhoras")%></div></td>
  </tr>
  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>