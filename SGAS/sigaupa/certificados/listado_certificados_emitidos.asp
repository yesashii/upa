<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=listado_certificados_emitidos.xls"
Response.ContentType = "application/vnd.ms-excel"

'----------------------------------------------------------------------------------
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Listado de Certificados Emitidos"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


'-----------------------------------------------------------------------------------------------
set f_listado = new CFormulario
f_listado.Carga_Parametros "consulta.xml", "consulta" 'carga el xml
f_listado.Inicializar conexion 'inicializo conexion

consulta = 	" select b.sede_tdesc as sede,c.carr_tdesc as carrera,d.jorn_tdesc as jornada,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, "& vbCrLf &_
			" e.pers_tape_paterno + ' ' + e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, protic.trunc(cert_fecha) as fecha, "& vbCrLf &_
			" cert_tipo as tipo, cert_motivo as motivo,isnull(comentario,'') as comentario "& vbCrLf &_
			" from certificados_emitidos a, sedes b, carreras c, jornadas d, personas e "& vbCrLf &_
			" where a.sede_ccod = b.sede_ccod "& vbCrLf &_
			" and a.carr_ccod = c.carr_ccod "& vbCrLf &_
			" and a.jorn_ccod = d.jorn_ccod "& vbCrLf &_
			" and a.pers_ncorr = e.pers_ncorr "& vbCrLf &_
			" order by sede,carrera,jornada,nombre"


f_listado.Consultar consulta 'este hace la pega
%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<script language="JavaScript">
</script>

</head>
<body>
<br>
<table width="100%" border="1" cellpadding="0" cellspacing="0">
  <tr>
  	<td colspan="10"><div align="center"><font size="+1"><strong><%=pagina.Titulo%></strong></font></div></td>
  </tr>
  <tr>
  	<td colspan="10"><div align="center"><font size="+1"><strong>&nbsp;</strong></font></div></td>
  </tr>
  <tr>
    <td bgcolor="#FFFF99"><div align="center"><strong>Nº</strong></div></td>
	<td bgcolor="#FFFF99"><div align="left"><strong>SEDE</strong></div></td>
    <td bgcolor="#FFFF99"><div align="left"><strong>CARRERA</strong></div></td>
	<td bgcolor="#FFFF99"><div align="left"><strong>JORNADA</strong></div></td>
	<td bgcolor="#FFFF99"><div align="left"><strong>RUT</strong></div></td>
	<td bgcolor="#FFFF99"><div align="left"><strong>NOMBRE</strong></div></td>
	<td bgcolor="#FFFF99"><div align="left"><strong>FECHA</strong></div></td>
	<td bgcolor="#FFFF99"><div align="left"><strong>TIPO</strong></div></td>
	<td bgcolor="#FFFF99"><div align="left"><strong>MOTIVO</strong></div></td>
	<td bgcolor="#FFFF99"><div align="left"><strong>COMENTARIO</strong></div></td>
  </tr>
  <%NUMERO=1%>
  <%while f_listado.Siguiente%> <!-- mientras hay registro hace-->
  <tr>
    <td><%=NUMERO%> </td>
	<td><%=f_listado.ObtenerValor("sede")%></td>
    <td><%=f_listado.ObtenerValor("carrera")%></td>
	<td><%=f_listado.ObtenerValor("jornada")%></td>
	<td><%=f_listado.ObtenerValor("rut")%></td>
	<td><%=f_listado.ObtenerValor("nombre")%></td>
	<td><%=f_listado.ObtenerValor("fecha")%></td>
	<td><%=f_listado.ObtenerValor("tipo")%></td>
	<td><%=f_listado.ObtenerValor("motivo")%></td>
	<td><%=f_listado.ObtenerValor("comentario")%></td>
   </tr>
   <%NUMERO=NUMERO+1%>
  <%wend%>
</table>
</body>
</html>
