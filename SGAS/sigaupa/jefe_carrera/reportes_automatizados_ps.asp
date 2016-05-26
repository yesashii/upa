<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'Response.AddHeader "Content-Disposition", "attachment;filename=Resultados_parciales.xls"
'Response.ContentType = "application/vnd.ms-excel"
'Server.ScriptTimeOut = 150000

'----------------------------------------------------------------------------------
peri_ccod = Request.QueryString("busqueda[0][peri_ccod]")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Resultados parciales alumno"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

peri_tdesc = conexion.consultaUno("select peri_tdesc from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")

set negocio = new CNegocio
negocio.Inicializa conexion

fecha_01 = conexion.consultaUno("select getDate() ")

'-----------------------------------------------------------------------------------------------
set f_listado = new CFormulario
f_listado.Carga_Parametros "consulta.xml", "consulta" 'carga el xml
f_listado.Inicializar conexion 

consulta = 	" Select sede_tdesc as sede, carr_tdesc as carrera, jorn_tdesc as jornada,  "& vbCrLf &_
			" cast(g.pers_nrut as varchar)+'-'+g.pers_xdv as rut, g.pers_tnombre as nombres,  "& vbCrLf &_
			" g.pers_tape_paterno + ' ' + g.pers_tape_materno as apellidos,  "& vbCrLf &_
			" j.asig_ccod as cod_asig,j.asig_tdesc as asignatura, i.secc_tdesc as sección,  "& vbCrLf &_
			" isnull((select top 1 protic.trunc(cali_fevaluacion)  from calificaciones_seccion t2  "& vbCrLf &_
			" where t2.secc_ccod=i.secc_ccod and t2.teva_ccod='5' ),'') as fecha_solemne_1,  "& vbCrLf &_
			" isnull((select cast(cala_nnota as varchar)  "& vbCrLf &_
			" from calificaciones_alumnos tt, calificaciones_seccion t2  "& vbCrLf &_
			" where tt.secc_ccod=i.secc_ccod and tt.matr_ncorr=a.matr_ncorr   "& vbCrLf &_
			" and tt.cali_ncorr=t2.cali_ncorr and tt.secc_ccod=t2.secc_ccod and t2.teva_ccod='5'),'') as calificacion_solemne_1,  "& vbCrLf &_
			" isnull((select top 1 protic.trunc(cali_fevaluacion) from calificaciones_seccion t2  "& vbCrLf &_
			" where t2.secc_ccod=i.secc_ccod and t2.teva_ccod='6' ),'') as fecha_solemne_2,  "& vbCrLf &_
			" isnull((select cast(cala_nnota as varchar)  "& vbCrLf &_
			" from calificaciones_alumnos tt, calificaciones_seccion t2  "& vbCrLf &_
			" where tt.secc_ccod=i.secc_ccod and tt.matr_ncorr=a.matr_ncorr   "& vbCrLf &_
			" and tt.cali_ncorr=t2.cali_ncorr and tt.secc_ccod=t2.secc_ccod and t2.teva_ccod='6'),'') as calificacion_solemne_2,  "& vbCrLf &_
			" isnull((select top 1 protic.trunc(cali_fevaluacion) from calificaciones_seccion t2  "& vbCrLf &_
			" where t2.secc_ccod=i.secc_ccod and t2.teva_ccod='X' ),'') as fecha_solemne_3,  "& vbCrLf &_
			" isnull((select cast(cala_nnota as varchar)  "& vbCrLf &_
			" from calificaciones_alumnos tt, calificaciones_seccion t2  "& vbCrLf &_
			" where tt.secc_ccod=i.secc_ccod and tt.matr_ncorr=a.matr_ncorr   "& vbCrLf &_
			" and tt.cali_ncorr=t2.cali_ncorr and tt.secc_ccod=t2.secc_ccod and t2.teva_ccod='X'),'') as calificacion_solemne_3   "& vbCrLf &_
			" from alumnos a (nolock), ofertas_academicas b, sedes c, especialidades d, carreras e,   "& vbCrLf &_
			"     jornadas f, personas g (nolock), cargas_academicas h (nolock), secciones i, asignaturas j  "& vbCrLf &_
			" where a.ofer_ncorr=b.ofer_ncorr and b.sede_ccod=c.sede_ccod and b.espe_ccod=d.espe_ccod  "& vbCrLf &_
			" and d.carr_ccod=e.carr_ccod and b.jorn_ccod = f.jorn_ccod and cast(b.peri_ccod as varchar)='"&peri_ccod&"' "& vbCrLf &_
			" and a.pers_ncorr=g.pers_ncorr  "& vbCrLf &_
			" and a.matr_ncorr=h.matr_ncorr and h.secc_ccod = i.secc_ccod  "& vbCrLf &_
			" and i.asig_ccod =j.asig_ccod  "& vbCrLf &_
			" and exists (select 1 from calificaciones_seccion t3   "& vbCrLf &_
			"             where t3.secc_ccod=i.secc_ccod and t3.teva_ccod in ('5','6','X'))  "& vbCrLf &_
			"order by sede, carrera, jornada, apellidos, asignatura, sección "

response.Write("<pre>"&consulta&"</pre>")
response.End()

f_listado.Consultar consulta 'este hace la pega
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
<p>
	<center><font size="+3"><%=pagina.Titulo%>(<%=peri_tdesc%>)</font><br><%=fecha_01%></center>
</p>
<table width="100%" border="1" cellpadding="0" cellspacing="0">
  <tr>
		<td bgcolor="#FF9900"><div align="center"><strong>NUM</strong></div></td>
		<td bgcolor="#FF9900"><div align="center"><strong>Sede</strong></div></td>
		<td bgcolor="#FF9900"><div align="center"><strong>Carrera</strong></div></td>
		<td bgcolor="#FF9900"><div align="center"><strong>Jornada</strong></div></td>
		<td bgcolor="#FF9900"><div align="center"><strong>Rut</strong></div></td>
		<td bgcolor="#FF9900"><div align="center"><strong>Nombre</strong></div></td>
		<td bgcolor="#FF9900"><div align="center"><strong>Cód. Asignatura</strong></div></td>
		<td bgcolor="#FF9900"><div align="center"><strong>Asignatura</strong></div></td>
		<td bgcolor="#FF9900"><div align="center"><strong>Sección</strong></div></td>
		<td bgcolor="#FF9900"><div align="center"><strong>Fecha Solemne 1</strong></div></td>
		<td bgcolor="#FF9900"><div align="center"><strong>Nota Solemne 1</strong></div></td>
		<td bgcolor="#FF9900"><div align="center"><strong>Fecha Solemne 2</strong></div></td>
		<td bgcolor="#FF9900"><div align="center"><strong>Nota Solemne 2</strong></div></td>
		<td bgcolor="#FF9900"><div align="center"><strong>Fecha Solemne 3</strong></div></td>
		<td bgcolor="#FF9900"><div align="center"><strong>Nota Solemne 3</strong></div></td>
  </tr>
  <%NUMERO=1%>
  <%while f_listado.Siguiente%> <!-- mientras hay registro hace-->
  <tr>
		<td align="left"><%=NUMERO%> </td>
		<td align="left"><%=f_listado.ObtenerValor("sede")%></td>
		<td align="left"><%=f_listado.ObtenerValor("carrera")%></td>
		<td align="left"><%=f_listado.ObtenerValor("jornada")%></td>
		<td align="left"><%=f_listado.ObtenerValor("rut")%></td>
		<td align="left"><%=f_listado.ObtenerValor("apellidos")&", "&f_listado.ObtenerValor("nombres")%></td>
		<td align="left"><%=f_listado.ObtenerValor("cod_asig")%></td>
		<td align="left"><%=f_listado.ObtenerValor("asignatura")%></td>
		<td align="left"><%=f_listado.ObtenerValor("sección")%></td>
		<td align="left"><%=f_listado.ObtenerValor("fecha_solemne_1")%></td>
		<td align="left"><%=f_listado.ObtenerValor("calificacion_solemne_1")%></td>
		<td align="left"><%=f_listado.ObtenerValor("fecha_solemne_2")%></td>
		<td align="left"><%=f_listado.ObtenerValor("calificacion_solemne_2")%></td>
		<td align="left"><%=f_listado.ObtenerValor("fecha_solemne_3")%></td>
		<td align="left"><%=f_listado.ObtenerValor("calificacion_solemne_3")%></td>
   </tr>
   <%NUMERO=NUMERO+1%>
  <%wend%>
</table>
</body>
</html>
