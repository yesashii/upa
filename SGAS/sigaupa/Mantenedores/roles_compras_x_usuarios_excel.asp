<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=reporte_roles_x_usuarios.xls"
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
set f_roles_usuarios = new CFormulario
f_roles_usuarios.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
f_roles_usuarios.Inicializar conexion

sql_roles= "select b.rusu_tdesc,a.rusu_ccod, protic.obtener_rut(pers_ncorr) as rut  "&_
		" , protic.obtener_nombre_completo(pers_ncorr,'n') as  nombre  "&_
		" from ocag_permisos_roles_usuarios a, ocag_roles_usuarios b, personas c  "&_
		" where a.rusu_ccod=b.rusu_ccod  "&_
		" and a.pers_nrut=c.pers_nrut  "&_
		" order by  rut desc "

f_roles_usuarios.Consultar sql_roles

%>
<html>
<head>
<title> Detalle Roles x Usuarios</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="75%" border="1">
  <tr>
  	<td width="11%"><div align="center"><strong>Cod Rol </strong></div></td>
	<td width="11%"><div align="center"><strong>Descripcion Rol</strong></div></td> 
    <td width="11%"><div align="center"><strong>Rut</strong></div></td>
	<td width="11%"><div align="center"><strong>Nombre</strong></div></td>
  </tr>
  <%  while f_roles_usuarios.Siguiente %>
  <tr> 
   	<td><div align="center"><%=f_roles_usuarios.ObtenerValor("rusu_ccod")%></div></td>
	<td><div align="center"><%=f_roles_usuarios.ObtenerValor("rusu_tdesc")%></div></td>
    <td><div align="center"><%=f_roles_usuarios.ObtenerValor("rut")%></div></td>
	<td><div align="center"><%=f_roles_usuarios.ObtenerValor("nombre")%></div></td>	
  </tr>
  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>