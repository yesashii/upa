<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=convalidaciones_eliminadas.xls"
Response.ContentType = "application/vnd.ms-excel"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


'---------------------------------------------------------------------------------------------------
set f_notas = new CFormulario
f_notas.Carga_Parametros "conc_notas.xml", "notas"
f_notas.Inicializar conexion

sql_notas = conexion.ConsultaUno("select protic.obtener_sql_notas('" & q_pers_nrut & "') ")

consulta = " select cast(g.pers_nrut as varchar)+'-'+g.pers_xdv as rut, g.pers_tape_paterno + ' ' + g.pers_tape_materno + ' ' + g.pers_tnombre as alumno, " & vbCrLf &_
		   " b.asig_ccod,b.asig_tdesc,a.acon_ncorr,conv_nnota,protic.initcap(c.sitf_tdesc) as tipo,reso_nresolucion, " & vbCrLf &_
		   " conv_res_eliminacion as res_eliminacion,conv_obs_eliminacion as obs_eliminacion, " & vbCrLf &_
		   " gg.pers_tape_paterno + ' ' + gg.pers_tape_materno + ' ' + gg.pers_tnombre as eliminada_por,protic.trunc(a.audi_fmodificacion) as el_dia " & vbCrLf &_
		   " from convalidaciones_eliminadas a, asignaturas b,situaciones_finales c,actas_convalidacion d, " & vbCrLf &_
		   " resoluciones e,alumnos f,personas g,personas gg " & vbCrLf &_
		   " where a.matr_ncorr = f.matr_ncorr " & vbCrLf &_
		   " and a.asig_ccod = b.asig_ccod " & vbCrLf &_
		   " and a.sitf_ccod = c.sitf_ccod " & vbCrLf &_
		   " and a.acon_ncorr = d.acon_ncorr " & vbCrLf &_
		   " and d.reso_ncorr = e.reso_ncorr " & vbCrLf &_
		   " and f.pers_ncorr = g.pers_ncorr " & vbCrLf &_
		   " and a.audi_tusuario = gg.pers_nrut" 
		  
 
f_notas.Consultar consulta



%>


<html>

<body>
<br>
<table width="98%"  border="1">
  <tr>
    <td bgcolor="#CCFF99"><div align="center"><strong>Rut</strong></div></td>
    <td bgcolor="#CCFF99"><div align="center"><strong>Alumno</strong></div></td>
    <td bgcolor="#CCFF99"><div align="center"><strong>Cód. Asignatura</strong></div></td>
    <td bgcolor="#CCFF99"><div align="center"><strong>Asignatura</strong></div></td>
    <td bgcolor="#CCFF99"><div align="center"><strong>Nota</strong></div></td>
    <td bgcolor="#CCFF99"><div align="center"><strong>Concepto</strong></div></td>
	<td bgcolor="#CCFF99"><div align="center"><strong>Res. Ingreso</strong></div></td>
	<td bgcolor="#CCFF99"><div align="center"><strong>Res. Eliminación</strong></div></td>
	<td bgcolor="#CCFF99"><div align="center"><strong>Observación</strong></div></td>
	<td bgcolor="#CCFF99"><div align="center"><strong>Eliminada por</strong></div></td>
	<td bgcolor="#CCFF99"><div align="center"><strong>El día</strong></div></td>
  </tr>
  <%while f_notas.Siguiente%>
  <tr>
    <td><%=f_notas.ObtenerValor("rut")%></td>
    <td><%=f_notas.ObtenerValor("alumno")%></td>
    <td><%=f_notas.ObtenerValor("asig_ccod")%></td>
    <td><%=f_notas.ObtenerValor("asig_tdesc")%></td>
    <td><%=f_notas.ObtenerValor("conv_nnota")%></td>
	<td><%=f_notas.ObtenerValor("tipo")%></td>
	<td><%=f_notas.ObtenerValor("reso_nresolucion")%></td>
	<td><%=f_notas.ObtenerValor("res_eliminacion")%></td>
	<td><%=f_notas.ObtenerValor("obs_eliminacion")%></td>
	<td><%=f_notas.ObtenerValor("eliminada_por")%></td>
	<td><%=f_notas.ObtenerValor("el_dia")%></td>
  </tr>
  <%wend%>
</table>
</body>
</html>