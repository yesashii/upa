<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.form(k)&"<br>")
'next
Response.AddHeader "Content-Disposition", "attachment;filename=predictivo_escuelas.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'------------------------------------------------------------------------------------
'response.End()
fecha=conexion.consultaUno("select getDate() ")

set f_candidatos = new cFormulario
f_candidatos.carga_parametros "tabla_vacia.xml", "tabla"
f_candidatos.inicializar conexion
c_datos = " select * from PREDICTIVO_EGRESO_TEMPORAL where audi_tusuario='"&negocio.obtenerUsuario&"'"

f_candidatos.consultar c_datos

'response.End()
%>
<html>
<head>
<title>Predictivo de candidatos a egreso por escuela</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Predictivo de candidatos a egreso por escuela</font></div></td>
 </tr>
 <tr> 
    <td colspan="4">&nbsp;</td>
 </tr>
 <tr> 
    <td colspan="4">Fecha Actual: <%=fecha%></div></td>
 </tr>
</table>

<p>&nbsp;</p><table width="100%" border="1">
<tr>
	<td colspan="2" align="center">
		<table width="90%" border="1">
		  <tr> 
				<td bgcolor="#FFFFCC"><div align="center"><strong>N°</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Sede</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Carrera</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Jornada</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Especialidad</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Plan</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>RUT</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Nombre</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Año de ingreso</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Último estado</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Último período</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Egresado</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Titulado</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>ES CAE</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Asignaturas Malla</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Aprobadas o en curso</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Restantes</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Teléfono</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Celular</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>E-mail</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Informar CAE</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Fecha CAE</strong></div></td>
				<td bgcolor="#FFFFCC"><div align="center"><strong>Observaci&oacute;n</strong></div></td>
			</tr>
			<% fila = 1
			 while f_candidatos.siguiente%>
			<tr> 
				<td><div align="center"><%=fila%></div></td>
				<td><div align="left"><%=f_candidatos.obtenerValor("SEDE")%></div></td>
				<td><div align="left"><%=f_candidatos.obtenerValor("carrera")%></div></td>
				<td><div align="left"><%=f_candidatos.obtenerValor("jornada")%></div></td>
				<td><div align="left"><%=f_candidatos.obtenerValor("especialidad")%></div></td>
				<td><div align="left"><%=f_candidatos.obtenerValor("plan_es")%></div></td>
				<td><div align="left"><%=f_candidatos.obtenerValor("rut")%></div></td>
				<td><div align="left"><%=f_candidatos.obtenerValor("nombre")%></div></td>
				<td><div align="left"><%=f_candidatos.obtenerValor("ingreso")%></div></td>	
				<td><div align="left"><%=f_candidatos.obtenerValor("ultimo_estado")%></div></td>
				<td><div align="left"><%=f_candidatos.obtenerValor("ultimo_periodo")%></div></td>
				<td><div align="left"><%=f_candidatos.obtenerValor("egresado")%></div></td>
				<td><div align="left"><%=f_candidatos.obtenerValor("titulado")%></div></td>
				<td><div align="left"><%=f_candidatos.obtenerValor("es_cae")%></div></td>
				<td><div align="center"><%=f_candidatos.obtenerValor("asignaturas_malla")%></div></td>
				<td><div align="center"><%=f_candidatos.obtenerValor("aprobadas")%></div></td>
				<td bgcolor="#FFFFCC" ><div align="center"><%=f_candidatos.obtenerValor("restantes")%></div></td>
				<td><div align="left"><%=f_candidatos.obtenerValor("telefono")%></div></td>
				<td><div align="left"><%=f_candidatos.obtenerValor("celular")%></div></td>
				<td><div align="left"><%=f_candidatos.obtenerValor("email")%></div></td>
				<td><div align="left"><%=f_candidatos.obtenerValor("informar_cae")%></div></td>
				<td><div align="left"><%=f_candidatos.obtenerValor("fecha_cae")%></div></td>
				<td><div align="left"><%=f_candidatos.obtenerValor("observaciones_cae")%></div></td>
			</tr>
			<%fila= fila + 1  
			wend %>
		</table>
	</td>
</tr>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>