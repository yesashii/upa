<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
'Response.AddHeader "Content-Disposition", "attachment;filename=listado_becas_externas_arancel.xls"
'Response.ContentType = "application/vnd.ms-excel"

'---------------------------------------------------------------------------------------------------

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion


'response.End()
set f_alumnos  = new cformulario
f_alumnos.carga_parametros "tabla_vacia.xml", "tabla"
f_alumnos.inicializar conexion							

sql="select a.pers_ncorr,cast(pers_nrut as varchar)+' '+pers_xdv as rut, pers_tape_paterno,pers_tape_materno,pers_tnombre as nombre, '1'as jornada, '1' as sede, '1' as carrera, '1' as edad"& vbCrLf &_
"from mis_datos a"& vbCrLf &_
"join personas b"& vbCrLf &_
"on a.pers_ncorr=b.PERS_NCORR"& vbCrLf &_
"where datepart(yyyy,a.audi_fmodificacion)=2011"

f_alumnos.consultar sql

'-------------------------------------------------------------------------------



'response.End()		
cont_general=0


'------------------------------------------------------------------------------
%>
 <html>
<head>
<title><%=pagina.Titulo%></title>  

</head>
<body bgcolor="#ffffff" leftmargin="43" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="100%" border="1">
 <% while f_alumnos.Siguiente
 cont_general=cont_general+1
 
 	set f_mis_datos_hermano  = new cformulario
	f_mis_datos_hermano.carga_parametros "tabla_vacia.xml", "tabla"
	f_mis_datos_hermano.inicializar conexion							
	
	sql_descuentos=sql="select top 1 midh_nombre+' '+midh_ape_paterno+' '+midh_ape_materno as midh_nombre,midh_edad,midh_cargo,midh_empresa,pare_ccod"& vbCrLf &_
					"from mis_datos_hermanos a"& vbCrLf &_
					"where a.pers_ncorr="&f_alumnos.ObtenerValor("pers_ncorr")&""
	
	f_mis_datos_hermano.consultar sql_descuentos
 
 
 
 
 %>
  <tr>
  <%if cont_general=1 then %>
    <td width="11%"><div align="center"><strong>Rut</strong></div></td>
    <td width="22%"><div align="up"><strong>Nombre</strong></div></td>
	<td width="38%"><div align="center"><strong>A. Paterno</strong></div></td>
    <td width="38%"><div align="center"><strong>A. Materno</strong></div></td>
	<td width="38%"><div align="center"><strong>Sede</strong></div></td>
	<td width="38%"><div align="center"><strong>Carrera</strong></div></td>
	<td width="38%"><div align="center"><strong>Jornada</strong></div></td>
  <%end if%>
	<%  while f_mis_datos_hermano.Siguiente  cont_hermanos1=0  
	
	array_hermanos(cont_hermanos1)="h"
	cont_hermanos1=cont_hermanos1+1
	lago=ubound (array_hermanos) -1


	%>
	
	<%if largo<cont_hermanos1 or cont_hermanos1=0 then %>
	<td width="38%"><div align="center"><strong>Nombre (<%=cont_hermanos%>)</strong></div></td>	
	<td width="38%"><div align="center"><strong>Edad (<%=cont_hermanos%>)</strong></div></td>	
	<td width="38%"><div align="center"><strong>Parentesco (<%=cont_hermanos%>)</strong></div></td>	
	<td width="38%"><div align="center"><strong>Cargo u Ocupación (<%=cont_hermanos%>)</strong></div></td>	
	<td width="38%"><div align="center"><strong>Organismo o Empresa (<%=cont_hermanos%>)</strong></div></td>

	<% end if 
		wend %>
  </tr>
  <tr>
    <td><div align="left"><%=f_alumnos.ObtenerValor("rut")%></div></td>
	<td><div align="left"><%=f_alumnos.ObtenerValor("nombre")%></div></td>
	<td><div align="left"><%=f_alumnos.ObtenerValor("pers_tape_paterno")%></div></td>
    <td><div align="left"><%=f_alumnos.ObtenerValor("pers_mape_paterno")%></div></td>
    <td><div align="left"><%=f_alumnos.ObtenerValor("sede")%></div></td>
  	<td><div align="left"><%=f_alumnos.ObtenerValor("carrera")%></div></td>
	<td><div align="left"><%=f_alumnos.ObtenerValor("jornada")%></div></td>
    
   <%  while f_mis_datos_hermano.Siguiente %>
  
	<td><div align="left"><%=f_mis_datos_hermano.ObtenerValor("midh_nombre")%></div></td>
	<td><div align="left"><%=f_mis_datos_hermano.ObtenerValor("midh_edad")%></div></td>
    <td><div align="left"><%=f_mis_datos_hermano.ObtenerValor("pare_ccod")%></div></td>
    <td><div align="left"><%=f_mis_datos_hermano.ObtenerValor("midh_cargo")%></div></td>
	<td><div align="left"><%=f_mis_datos_hermano.ObtenerValor("midh_empresa")%></div></td>
  <%  wend %>
  </tr>
  <%wend %>
</table>
</html>