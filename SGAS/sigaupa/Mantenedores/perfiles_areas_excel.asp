<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=reporte_perfiles_areas.xls"
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

sql_tipo_gasto= " select pa.pare_ccod, pare_tdesc, cast(pp.pers_nrut as varchar)+'-'+pp.pers_xdv as rut, "&_
				"	protic.obtener_nombre_completo(pp.pers_ncorr,'n') as nombre "&_
				"	from ocag_perfiles_areas as pa, ocag_perfiles_areas_usuarios pau, personas pp "&_
				"	where pau.pare_ccod=pa.pare_ccod "&_
				"	and pau.pers_nrut=pp.pers_nrut "

f_tipo_gasto.Consultar sql_tipo_gasto

%>
<html>
<head>
<title> Detalle Perfiles Areas</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="75%" border="1">
  <tr>
  	<td width="11%"><div align="center"><strong>Cod area </strong></div></td>
	<td width="11%"><div align="center"><strong>Descripcion</strong></div></td> 
    <td width="11%"><div align="center"><strong>Rut Usuario</strong></div></td>
	<td width="11%"><div align="center"><strong>Nombre Usuario</strong></div></td>
  </tr>
  <%  while f_tipo_gasto.Siguiente %>
  <tr> 
   	<td><div align="center"><%=f_tipo_gasto.ObtenerValor("pare_ccod")%></div></td>
	<td><div align="center"><%=f_tipo_gasto.ObtenerValor("pare_tdesc")%></div></td>
    <td><div align="center"><%=f_tipo_gasto.ObtenerValor("rut")%></div></td>
	<td><div align="center"><%=f_tipo_gasto.ObtenerValor("nombre")%></div></td>	
  </tr>
  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>