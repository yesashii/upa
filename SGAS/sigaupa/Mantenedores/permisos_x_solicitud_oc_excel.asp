<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=reporte_solicitudes_x_rut.xls"
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
set f_solicitudes = new CFormulario
f_solicitudes.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
f_solicitudes.Inicializar conexion

sql_solicitudes= 	" select a.tsol_ccod as codigo,tsol_tdesc as tipo_solicitud, tsol_tcodigo as sigla, "&_
					" protic.obtener_rut(pers_ncorr) as rut,protic.obtener_nombre_completo(pers_ncorr, 'n') as nombre "&_
					"	  from ocag_permisos_solicitudes_usuarios a, personas b,ocag_tipo_solicitud c  "&_  
					"	   where a.pers_nrut=b.pers_nrut  "&_  
					"	   and a.tsol_ccod=c.tsol_ccod  "&_
					"	   order by nombre desc  "

f_solicitudes.Consultar sql_solicitudes

%>
<html>
<head>
<title>Listado Solicitudes de Giro x Rut</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="75%" border="1">
  	<tr>
		<td width="11%"><div align="center"><strong>Codigo</strong></div></td>
		<td width="11%"><div align="center"><strong>Tipo</strong></div></td> 
		<td width="11%"><div align="center"><strong>Sigla</strong></div></td>
		<td width="11%"><div align="center"><strong>Rut</strong></div></td> 
		<td width="11%"><div align="center"><strong>Nombre</strong></div></td>
  	</tr>
  <%  while f_solicitudes.Siguiente %>
  	<tr> 
		<td><div align="center"><%=f_solicitudes.ObtenerValor("codigo")%></div></td>
		<td><div align="center"><%=f_solicitudes.ObtenerValor("tipo_solicitud")%></div></td>
		<td><div align="center"><%=f_solicitudes.ObtenerValor("sigla")%></div></td>
		<td><div align="center"><%=f_solicitudes.ObtenerValor("rut")%></div></td>
		<td><div align="center"><%=f_solicitudes.ObtenerValor("nombre")%></div></td>
	</tr>
  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>