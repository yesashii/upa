<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=reporte_centro_costos_x_rut.xls"
Response.ContentType = "application/vnd.ms-excel"
'------------------------------------------------------------------------------------
set pagina = new CPagina
'------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
Usuario = negocio.ObtenerUsuario()

'----------------------------------------------------------------------------
set f_centro_costo = new CFormulario
f_centro_costo.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
f_centro_costo.Inicializar conexion

sql_descuentos= " Select ccos_ncorr,a.ccos_tcodigo,b.ccos_tdesc,protic.obtener_rut(pers_ncorr) as rut, "&_
				"	protic.obtener_nombre_completo(pers_ncorr, 'n') as nombre "&_
				"	from ocag_permisos_centro_costo a, ocag_centro_costo b, personas c  "&_
				"	where a.ccos_tcodigo=b.ccos_tcodigo  "&_
				"	and a.pers_nrut=c.pers_nrut "

f_centro_costo.Consultar sql_descuentos

%>
<html>
<head>
<title>Listado Centro de Costos x Rut</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="75%" border="1">
  	<tr>
		<td width="11%"><div align="center"><strong>Cod CC </strong></div></td>
		<td width="11%"><div align="center"><strong>Codigo</strong></div></td> 
		<td width="11%"><div align="center"><strong>Descripcion</strong></div></td>
		<td width="11%"><div align="center"><strong>Rut</strong></div></td> 
		<td width="11%"><div align="center"><strong>Nombre</strong></div></td>
  	</tr>
  <%  while f_centro_costo.Siguiente %>
  	<tr> 
		<td><div align="center"><%=f_centro_costo.ObtenerValor("ccos_ncorr")%></div></td>
		<td><div align="center"><%=f_centro_costo.ObtenerValor("ccos_tcodigo")%></div></td>
		<td><div align="center"><%=f_centro_costo.ObtenerValor("ccos_tdesc")%></div></td>
		<td><div align="center"><%=f_centro_costo.ObtenerValor("rut")%></div></td>
		<td><div align="center"><%=f_centro_costo.ObtenerValor("nombre")%></div></td>
	</tr>
  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>