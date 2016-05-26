<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=encuestas_acreditacion_empleadores.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
carr_ccod= request.QueryString("carr_ccod")
fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------

set f_empleadores = new CFormulario
f_empleadores.Carga_Parametros "tabla_vacia.xml", "tabla"
f_empleadores.Inicializar conexion
		   
consulta = " select b.carr_tdesc as carrera,nombre_empresa,case tamano_empresa when 1 then 'Grande (100 funcionarios o más)'  when 2 then 'Mediana (entre 31 y 99 funcionarios)' when 3 then 'Pequeña (30 funcionarios o menos)' end as tamano, "& vbCrLf &_
		   " actividad_empresa,cargo_encuestado,protic.trunc(fecha_grabado)as fecha, "& vbCrLf &_
		   " case egresado_upa when 1 then 'Sí' when 2 then 'No' else 'no contestada' end as egresado, "& vbCrLf &_
		   " deficiencias_egresados as deficiencias_limitaciones,caracteristicas_egresados,capacidades_egresados as capacidades_necesarias"& vbCrLf &_
		   " from encuestas_empleadores a, carreras b  where isnull(antiguos,'N')='N' and a.carr_ccod = b.carr_ccod and a.carr_ccod='"&carr_ccod&"'"
           
f_empleadores.Consultar consulta


%>
<html>
<head>
<title>Resultados Parciales Encuesta Acreditación Empleadores</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Resultados Parciales Encuesta de Acreditación empleadores</font></div>
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
  <tr><td colspan="3" bgcolor="#CCFFCC"><font size="+1"><strong>Encuesta Empleadores</strong></font></td>
      <td colspan="8" bgcolor="#CCFFCC">&nbsp;</td>
  </tr>
  <tr> 
    <td><div align="center"><strong>fila</strong></div></td>
	<td><div align="center"><strong>Carrera</strong></div></td>
    <td><div align="center"><strong>Nombre Empresa</strong></div></td>
    <td><div align="center"><strong>Tamaño Empresa</strong></div></td>
	<td><div align="center"><strong>Actividad</strong></div></td>
    <td><div align="center"><strong>Cargo Encuestado</strong></div></td>
	<td><div align="center"><strong>Fecha</strong></div></td>
	<td><div align="center"><strong>Egresado UPA</strong></div></td>
	<td><div align="left"><strong>Señale a continuación las deficiencias y limitaciones profesionales que usted observa en los egresados de la Universidad del Pacífico y que le parece importante que la carrera enfrente.</strong></div></td>
	<td><div align="left"><strong>Señale las características que UD. reconoce en el egresado de la Universidad del Pacífico.</strong></div></td>
	<td><div align="left"><strong>Señale a continuación las características y capacidades que debería tener un profesional de la carrera, para que le resultara útil a su organización.</strong></div></td>
  </tr>
  <% fila = 1  
    while f_empleadores.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
	<td><div align="left"><%=f_empleadores.ObtenerValor("carrera")%></div></td>
    <td><div align="left"><%=f_empleadores.ObtenerValor("nombre_empresa")%></div></td>
    <td><div align="left"><%=f_empleadores.ObtenerValor("tamano")%></div></td>
    <td><div align="left"><%=f_empleadores.ObtenerValor("actividad_empresa")%></div></td>
    <td><div align="left"><%=f_empleadores.ObtenerValor("cargo_encuestado")%></div></td>
	<td><div align="left"><%=f_empleadores.ObtenerValor("fecha")%></div></td>
	<td><div align="left"><%=f_empleadores.ObtenerValor("egresado")%></div></td>
	<td><div align="left"><%=f_empleadores.ObtenerValor("deficiencias_limitaciones")%></div></td>
	<td><div align="left"><%=f_empleadores.ObtenerValor("caracteristicas_egresados")%></div></td>
	<td><div align="left"><%=f_empleadores.ObtenerValor("capacidades_necesarias")%></div></td>
  </tr>
  <% fila = fila + 1 
     wend %>
  <tr><td colspan="3">&nbsp;</td>
      <td colspan="8">&nbsp;</td>
  </tr>
</table>
<p>&nbsp;</p> 
<div align="center"></div>
</body>
</html>