<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=encuestas_acreditacion.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
carr_ccod = request.QueryString("carr_ccod")
fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'---------------------------------------------------encuesta docente--------------------------------
set f_docentes = new CFormulario
f_docentes.Carga_Parametros "tabla_vacia.xml", "tabla"
f_docentes.Inicializar conexion
		   
consulta = " select d.carr_tdesc as carrera, "& vbCrLf &_
		   " isnull(c.sexo_tdesc,'NO INGRESADO') as sexo_tdesc,cast(datediff(year,pers_fnacimiento,getDate()) as varchar) as edad,anos_universidad,protic.obtener_grados_docente(a.pers_ncorr) as grados_docente, "& vbCrLf &_
		   " protic.obtener_titulos_docente(a.pers_ncorr) as titulos_docente,protic.obtener_asignaturas_docente_carrera_anuales (1,d.carr_ccod,a.pers_ncorr,2006) as asignaturas,protic.trunc(fecha_grabado)as fecha, "& vbCrLf &_
		   " fortalesas_carrera"& vbCrLf &_
		   " from encuestas_docentes a, personas b, sexos c,carreras d"& vbCrLf &_
		   " where a.pers_ncorr = b.pers_ncorr and  isnull(antiguos,'N')='N'"& vbCrLf &_
		   " and b.sexo_ccod *= c.sexo_ccod and a.carr_ccod = d.carr_ccod and a.carr_ccod='"&carr_ccod&"' and isnull(a.pers_ncorr,0)<>0 "& vbCrLf &_
		   " union all "& vbCrLf &_
		   " select d.carr_tdesc as carrera, "& vbCrLf &_
		   " 'NO INGRESADO' as sexo_tdesc,'--' as edad,anos_universidad,'--' as grados_docente, "& vbCrLf &_
		   " '--' as titulos_docente,'--' as asignaturas,protic.trunc(fecha_grabado)as fecha, "& vbCrLf &_
		   " fortalesas_carrera"& vbCrLf &_
		   " from encuestas_docentes a,carreras d"& vbCrLf &_
		   " where  isnull(antiguos,'N')='N'"& vbCrLf &_
		   " and a.carr_ccod = d.carr_ccod and a.carr_ccod='"&carr_ccod&"' and isnull(a.pers_ncorr,0)=0 "
		   

           
f_docentes.Consultar consulta

%>
<html>
<head>
<title>Resultados Parciales Encuesta Acreditación Docentes</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Resultados Parciales Encuesta de Acreditación Docentes</font></div>
	</td>
 </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Fecha</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=fecha%> </td>
  </tr>
  <tr> 
    <td width="16%">&nbsp;</td>
    <td width="84%" colspan="3">&nbsp;</td>
  </tr>
</table>

<p>&nbsp;</p>
 <table width="100%" border="1">
  <tr><td colspan="5" bgcolor="#CCFFCC"><font size="+1"><strong>Encuesta Docentes</strong></font></td>
      <td colspan="6" bgcolor="#CCFFCC">&nbsp;</td>
  </tr>
  <tr> 
    <td><div align="center"><strong>fila</strong></div></td>
	<td><div align="center"><strong>Carrera</strong></div></td>
    <td><div align="center"><strong>Identificativo</strong></div></td>
	<td><div align="center"><strong>Sexo</strong></div></td>
    <td><div align="center"><strong>Edad</strong></div></td>
	<td><div align="center"><strong>Años Universidad</strong></div></td>
	<td><div align="center"><strong>Grados Académicos</strong></div></td>
	<td><div align="center"><strong>Títulos</strong></div></td>
	<td><div align="center"><strong>Asignaturas</strong></div></td>
	<td><div align="center"><strong>Fecha</strong></div></td>
	<td><div align="left"><strong>Señale a continuación sugerencias o comentarios referidos a las fortalezas y/o debilidades de la carrera o institución, que le gustaría destacar:</strong></div></td>
  </tr>
  <% fila = 1  
    while f_docentes.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
	<td><div align="left"><%=f_docentes.ObtenerValor("carrera")%></div></td>
    <td><div align="left"><%="Docente "&fila%></div></td>
    <td><div align="left"><%=f_docentes.ObtenerValor("sexo_tdesc")%></div></td>
    <td><div align="left"><%=f_docentes.ObtenerValor("edad")%></div></td>
	<td><div align="left"><%=f_docentes.ObtenerValor("anos_universidad")%></div></td>
	<td><div align="left"><%=f_docentes.ObtenerValor("grados_docente")%></div></td>
	<td><div align="left"><%=f_docentes.ObtenerValor("titulos_docente")%></div></td>
	<td><div align="left"><%=f_docentes.ObtenerValor("asignaturas")%></div></td>
	<td><div align="left"><%=f_docentes.ObtenerValor("fecha")%></div></td>
	<td><div align="left"><%=f_docentes.ObtenerValor("Fortalesas_carrera")%></div></td>
  </tr>
  <% fila = fila + 1 
     wend %>
  <tr><td colspan="5">&nbsp;</td>
      <td colspan="6">&nbsp;</td>
  </tr>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>