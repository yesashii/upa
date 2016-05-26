<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=reporte_perfiles_areas_x_gastos.xls"
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
set f_tipo_gasto = new CFormulario
f_tipo_gasto.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
f_tipo_gasto.Inicializar conexion

sql_gastos_asociados= " select a.pare_ccod,a.pare_tdesc, b.tgas_ccod, tgas_tdesc, tgas_cod_cuenta "&_ 
				" from ocag_perfiles_areas a, ocag_tipo_gasto_perfil b, ocag_tipo_gasto c "&_
				" where a.pare_ccod=b.pare_ccod "&_
				" and b.tgas_ccod=c.tgas_ccod "

f_tipo_gasto.Consultar sql_gastos_asociados

%>
<html>
<head>
<title> Detalle Perfiles Areas x Tipos de Gastos</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="75%" border="1">
  <tr>
  	<td width="11%"><div align="center"><strong>Cod area </strong></div></td>
	<td width="11%"><div align="center"><strong>Descripcion</strong></div></td> 
    <td width="11%"><div align="center"><strong>Tipo Gasto</strong></div></td>
	<td width="11%"><div align="center"><strong>Cod Cuenta</strong></div></td>
  </tr>
  <%  while f_tipo_gasto.Siguiente %>
  <tr> 
   	<td><div align="center"><%=f_tipo_gasto.ObtenerValor("pare_ccod")%></div></td>
	<td><div align="center"><%=f_tipo_gasto.ObtenerValor("pare_tdesc")%></div></td>
    <td><div align="center"><%=f_tipo_gasto.ObtenerValor("tgas_tdesc")%></div></td>
	<td><div align="center"><%=f_tipo_gasto.ObtenerValor("tgas_cod_cuenta")%></div></td>	
  </tr>
  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>