<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'Response.AddHeader "Content-Disposition", "attachment;filename=LISTA_ASIGNATURA.xls"
'Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 150000
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Listado de Alumnos"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


'---------------------------------------------------------------------------------------------------
set f_listado = new CFormulario
f_listado.Carga_Parametros "consulta.xml", "consulta" 'carga el xml
f_listado.Inicializar conexion 'inicializo conexion

consulta=   "select protic.obtener_rut(b.pers_ncorr) as rut, protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre_alumno," & vbCrlf & _  
			"emat_tdesc as estado_matricula, protic.ano_ingreso_carrera(b.pers_ncorr,d.carr_ccod) as promocion, " & vbCrlf & _ 
			"sede_tdesc as sede,(select carr_tdesc from carreras t where t.carr_ccod = d.carr_ccod) as carrera,  jorn_tdesc as jornada," & vbCrlf & _ 
			"--case when protic.es_nuevo_carrera(b.pers_ncorr,d.carr_ccod,222)='S' then 'NUEVO' else 'ANTIGUO' end as Tipo_Alumno," & vbCrlf & _ 
			"(select count(*) from sdescuentos sd where sd.stde_ccod=1402 and sd.post_ncorr in (select pos.post_ncorr from postulantes pos, alumnos al where pos.post_ncorr=al.post_ncorr and pos.peri_ccod<=220 and pos.pers_ncorr=b.pers_ncorr)) as tenia_cae_anteriores," & vbCrlf & _ 
			"case when (select count(*) from sdescuentos sd where sd.stde_ccod=1402 and sd.post_ncorr in (select pos.post_ncorr from postulantes pos, alumnos al where pos.post_ncorr=al.post_ncorr and pos.peri_ccod<=220 and pos.pers_ncorr=b.pers_ncorr))>=1 then 'RENOVANTE' else 'NUEVO CAE' end as tipo_cae" & vbCrlf & _ 
			"from sdescuentos a, alumnos b , ofertas_academicas c, especialidades d, estados_matriculas e, jornadas f, sedes g " & vbCrlf & _ 
			"where a.post_ncorr=b.post_ncorr " & vbCrlf & _ 
			"and a.ofer_ncorr=b.ofer_ncorr " & vbCrlf & _ 
			"and a.esde_ccod = 1 " & vbCrlf & _ 
			"and a.stde_ccod=1402 " & vbCrlf & _ 
			"and a.ofer_ncorr=c.ofer_ncorr " & vbCrlf & _ 
			"and c.peri_ccod=222 " & vbCrlf & _ 
			"and c.espe_ccod=d.espe_ccod " & vbCrlf & _ 
			"and b.emat_ccod not  in (9) " & vbCrlf & _ 
			"and b.emat_ccod=e.emat_ccod " & vbCrlf & _ 
			"and c.jorn_ccod=f.jorn_ccod " & vbCrlf & _ 
			"and c.sede_ccod=g.sede_ccod"

'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_listado.Consultar consulta 'este hace la pega
'response.End()
'response.write(consulta)
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
    <td><div align="center"><strong>NUM</strong></div></td>
	<td><div align="center"><strong>RUT</strong></div></td>
    <td><div align="center"><strong>NOMBRE</strong></div></td>
	<td><div align="center"><strong>estado_matricula</strong></div></td>
    <td width="5"><div align="center"><strong>promocion</strong></div></td>
    <td width="5"><div align="center"><strong>Sede</strong></div></td>
    <td width="5"><div align="center"><strong>carrera</strong></div></td>
    <td width="5"><div align="center"><strong>Jornada</strong></div></td>
    <td width="5"><div align="center"><strong>tenia_cae_anteriores</strong></div></td>
	<td width="5"><div align="center"><strong>tipo_cae</strong></div></td>
  </tr>
  <%NUMERO=1%>
  <%while f_listado.Siguiente%> <!-- mientras hay registro hace-->
  <tr>
    <td><%=NUMERO%> </td>
	<td><%=f_listado.ObtenerValor("rut")%></td>
    <td><%=f_listado.ObtenerValor("nombre_alumno")%></td>
	<td><%=f_listado.ObtenerValor("estado_matricula")%></td>
    <td><%=f_listado.ObtenerValor("promocion")%></td>
    <td><%=f_listado.ObtenerValor("sede")%> </td>
    <td><%=f_listado.ObtenerValor("carrera")%> </td>
    <td><%=f_listado.ObtenerValor("jornada")%> </td>
    <td><%=f_listado.ObtenerValor("tenia_cae_anteriores")%> </td>
	<td><%=f_listado.ObtenerValor("tipo_cae")%> </td>
   </tr>
   <%NUMERO=NUMERO+1%>
  <%wend%>
</table>
</body>
</html>
