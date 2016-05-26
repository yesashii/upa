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

'---------------------------------------------------encuesta Egresados--------------------------------
set f_egresados = new CFormulario
f_egresados.Carga_Parametros "tabla_vacia.xml", "tabla"
f_egresados.Inicializar conexion
		   
consulta = " select  c.carr_tdesc as carrera, "& vbCrLf &_
		   " case sexo when 1 then 'Femenino' when '2' then 'Masculino' end as sexo,edad_alumno, case condicion_egreso when 1 then 'Egresado' else 'No clickeado' end as egresado, "& vbCrLf &_
		   " case condicion_titulado when 1 then 'Titulado' else 'No clickeado' end as titulado,ano_inicio,ano_final, "& vbCrLf &_
		   " case trabajando when 1 then 'Sí' else 'No' end as trabajando,case tiempo_demora when 5 then 'Menos de 2 meses' when 4 then 'Entre 2 meses y 6 meses' when 3 then 'Entre 6 meses y 1 año' when 2 then 'Más de 1 año' when 1 then 'No he encontrado trabajo' end as tiempo_demora, "& vbCrLf &_
		   " case renta_promedio when 5 then 'Menos de $200.000' when 4 then 'Entre $200.001 y $500.000' when 3 then 'Entre $500.001 y 1.000.000' when 2 then 'Entre $1.000.001 y $1.500.000' when 1 then 'Más de $1.500.001' end as renta_promedio, "& vbCrLf &_
		   " nombre_empresa,case tamano_empresa when 1 then 'Grande (100 funcionarios o más)'  when 2 then 'Mediana (entre 31 y 99 funcionarios)' when 3 then 'Pequeña (30 funcionarios o menos)' end as tamano, "& vbCrLf &_
		   " caracteristica_empresa,case rol_alumno when 1 then 'Jefatura'  when 2 then 'Empleado(a)' when 3 then 'Independiente' end as rol, "& vbCrLf &_
		   " cargo_empresa,protic.trunc(fecha_grabado)as fecha, "& vbCrLf &_
		   " contenidos_faltantes,sugerencias_autoridades,sugerencias_carrera"& vbCrLf &_
		   " from encuestas_egresados a, personas b,carreras c "& vbCrLf &_
		   " where a.pers_ncorr = b.pers_ncorr and isnull(antiguos,'N')='N' and a.carr_ccod=c.carr_ccod and a.carr_ccod='"&carr_ccod &"' and isnull(a.pers_ncorr,0)<>0"& vbCrLf &_
		   " union"& vbCrLf &_
		   " select  c.carr_tdesc as carrera, "& vbCrLf &_
		   " case sexo when 1 then 'Femenino' when '2' then 'Masculino' end as sexo,edad_alumno, case condicion_egreso when 1 then 'Egresado' else 'No clickeado' end as egresado, "& vbCrLf &_
		   " case condicion_titulado when 1 then 'Titulado' else 'No clickeado' end as titulado,ano_inicio,ano_final, "& vbCrLf &_
		   " case trabajando when 1 then 'Sí' else 'No' end as trabajando,case tiempo_demora when 5 then 'Menos de 2 meses' when 4 then 'Entre 2 meses y 6 meses' when 3 then 'Entre 6 meses y 1 año' when 2 then 'Más de 1 año' when 1 then 'No he encontrado trabajo' end as tiempo_demora, "& vbCrLf &_
		   " case renta_promedio when 5 then 'Menos de $200.000' when 4 then 'Entre $200.001 y $500.000' when 3 then 'Entre $500.001 y 1.000.000' when 2 then 'Entre $1.000.001 y $1.500.000' when 1 then 'Más de $1.500.001' end as renta_promedio, "& vbCrLf &_
		   " nombre_empresa,case tamano_empresa when 1 then 'Grande (100 funcionarios o más)'  when 2 then 'Mediana (entre 31 y 99 funcionarios)' when 3 then 'Pequeña (30 funcionarios o menos)' end as tamano, "& vbCrLf &_
		   " caracteristica_empresa,case rol_alumno when 1 then 'Jefatura'  when 2 then 'Empleado(a)' when 3 then 'Independiente' end as rol, "& vbCrLf &_
		   " cargo_empresa,protic.trunc(fecha_grabado)as fecha, "& vbCrLf &_
		   " contenidos_faltantes,sugerencias_autoridades,sugerencias_carrera"& vbCrLf &_
		   " from encuestas_egresados a,carreras c "& vbCrLf &_
		   " where isnull(antiguos,'N')='N' and a.carr_ccod=c.carr_ccod and a.carr_ccod='"&carr_ccod &"' and isnull(a.pers_ncorr,0)=0"
           
f_egresados.Consultar consulta
%>
<html>
<head>
<title>Resultados Parciales Encuesta Acreditación Egresados</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Resultados Parciales Encuesta de Acreditación Egresados</font></div>
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
  <tr><td colspan="9" bgcolor="#CCFFCC"><font size="+1"><strong>Encuesta Alumnos Egresados</strong></font></td>
      <td colspan="12" bgcolor="#CCFFCC">&nbsp;</td>
  </tr>
  <tr> 
    <td><div align="center"><strong>fila</strong></div></td>
	<td><div align="center"><strong>Carrera</strong></div></td>
    <td><div align="center"><strong>Identificativo</strong></div></td>
	<td><div align="center"><strong>Sexo</strong></div></td>
    <td><div align="center"><strong>Edad</strong></div></td>
	<td><div align="center"><strong>Egresado</strong></div></td>
	<td><div align="center"><strong>Titulado</strong></div></td>
	<td><div align="center"><strong>Año Ingreso</strong></div></td>
	<td><div align="center"><strong>Año Término</strong></div></td>
	<td><div align="center"><strong>Trabajando</strong></div></td>
	<td><div align="center"><strong>tiempo en conseguir trabajo</strong></div></td>
	<td><div align="center"><strong>Renta Promedio</strong></div></td>
	<td><div align="center"><strong>Nombre Empresa</strong></div></td>
	<td><div align="center"><strong>Tamaño</strong></div></td>
	<td><div align="center"><strong>Actividad</strong></div></td>
	<td><div align="center"><strong>Rol Egresado</strong></div></td>
	<td><div align="center"><strong>Cargo en Empresa</strong></div></td>
	<td><div align="center"><strong>Fecha</strong></div></td>
	<td><div align="left"><strong>1. ¿Qué contenidos no me fueron entregados y hoy me doy cuenta de que me sería muy favorable conocer?</strong></div></td>
	<td><div align="left"><strong>2. ¿Qué sugerencias le haría a las autoridades de la carrera para mejorar la calidad de la formación?</strong></div></td>
	<td><div align="left"><strong>3. Señale a continuación, sugerencias o comentarios referidos a las fortalezas y/o debilidades de la carrera o institución, que le gustaría destacar:</strong></div></td>
  </tr>
  <% fila = 1  
    while f_egresados.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("carrera")%></div></td>
    <td><div align="left"><%=" Egresado "&fila %></div></td>
    <td><div align="left"><%=f_egresados.ObtenerValor("sexo")%></div></td>
    <td><div align="left"><%=f_egresados.ObtenerValor("edad_alumno")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("egresado")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("titulado")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("ano_inicio")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("ano_final")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("trabajando")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("tiempo_demora")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("renta_promedio")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("nombre_empresa")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("tamano")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("caracteristica_empresa")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("rol")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("cargo_empresa")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("fecha")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("contenidos_faltantes")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("sugerencias_autoridades")%></div></td>
	<td><div align="left"><%=f_egresados.ObtenerValor("sugerencias_carrera")%></div></td>
  </tr>
  <% fila = fila + 1 
     wend %>
  <tr><td colspan="9">&nbsp;</td>
      <td colspan="12">&nbsp;</td>
  </tr>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>