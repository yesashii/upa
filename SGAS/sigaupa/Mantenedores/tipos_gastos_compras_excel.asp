<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=reporte_tipos_de_gasto.xls"
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

sql_tipo_gasto= "select tgas_ccod,tgas_tdesc,tgas_cod_cuenta,tgas_nombre_cuenta  from ocag_tipo_gasto where isnull(etga_ccod,1) not in (3) order by tgas_tdesc"

f_tipo_gasto.Consultar sql_tipo_gasto

%>
<html>
<head>
<title>Tipos de Gastos</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="75%" border="1">
  <tr>
  	<td width="11%"><div align="center"><strong>Cod tipo</strong></div></td>
	<td width="11%"><div align="center"><strong>Descripcion</strong></div></td> 
    <td width="11%"><div align="center"><strong>Cod cuenta</strong></div></td>
    <td width="11%"><div align="center"><strong>Nombre Cuenta</strong></div></td>
  </tr>
  <%  while f_tipo_gasto.Siguiente %>
  <tr> 
   	<td><div align="center"><%=f_tipo_gasto.ObtenerValor("tgas_ccod")%></div></td>
	<td><div align="center"><%=f_tipo_gasto.ObtenerValor("tgas_tdesc")%></div></td>
    <td><div align="center"><%=f_tipo_gasto.ObtenerValor("tgas_cod_cuenta")%></div></td>
    <td><div align="center"><%=f_tipo_gasto.ObtenerValor("tgas_nombre_cuenta")%></div></td>
  </tr>
  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>