<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=formacion_profesional.xls"
Response.ContentType = "application/vnd.ms-excel"

'----------------------------------------------------------------------------------
peri_ccod = Request.QueryString("busqueda[0][peri_ccod]")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "FORMACIÓN PROFESIONAL"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

anos_ccod = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
peri_tdesc = conexion.consultaUno("select peri_tdesc from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
primer_semestre = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod&"' and plec_ccod=1")
fecha_01 = conexion.consultaUno("select getDate() ")

'-----------------------------------------------------------------------------------------------
set f_listado = new CFormulario
f_listado.Carga_Parametros "consulta.xml", "consulta" 'carga el xml
f_listado.Inicializar conexion 

consulta = 	" select sede_tdesc as sede, carr_tdesc as carrera, jorn_tdesc as jornada, "& vbCrLf &_
			" cast(a.pers_nrut as varchar) + '-' + pers_xdv as rut, "& vbCrLf &_
			" a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno as alumno, "& vbCrLf &_
			" f.asig_ccod,f.asig_tdesc as asignatura,e.secc_tdesc as seccion,j.espe_tdesc as especialidad,k.plan_tdesc as plan_estudio "& vbCrLf &_
			" from personas a, alumnos b, ofertas_academicas c, cargas_academicas d, secciones e, "& vbCrLf &_
			" asignaturas f,sedes g, carreras h, jornadas i,especialidades j,planes_estudio k "& vbCrLf &_
			" where a.pers_ncorr=b.pers_ncorr and b.ofer_ncorr=c.ofer_ncorr  "& vbCrLf &_
			"  and cast(c.peri_ccod as varchar)='"&peri_ccod&"'  "& vbCrLf &_
			"  and b.matr_ncorr = d.matr_ncorr  "& vbCrLf &_
			"  and d.secc_ccod = e.secc_ccod  "& vbCrLf &_
			"  and e.asig_ccod = f.asig_ccod  "& vbCrLf &_
			"  and c.sede_ccod = g.sede_ccod "& vbCrLf &_
			"  and c.jorn_ccod = i.jorn_ccod "& vbCrLf &_
			"  and c.espe_ccod = j.espe_Ccod and j.carr_ccod = h.carr_ccod and b.plan_ccod = k.plan_ccod "& vbCrLf &_
			"  and exists (select 1 from malla_curricular aa, planes_estudio bb, especialidades cc  "& vbCrLf &_
			"			where e.mall_ccod = aa.mall_ccod and e.asig_ccod=aa.asig_ccod  "& vbCrLf &_
		    "			and aa.plan_ccod=bb.plan_ccod and bb.espe_ccod = cc.espe_ccod  "& vbCrLf &_
			"			and cc.espe_tdesc like '%form%profesio%')  "& vbCrLf &_
			"  and not exists (select 1 from equivalencias ss where ss.matr_ncorr=d.matr_ncorr and ss.secc_ccod=d.secc_ccod) "& vbCrLf &_
			"  order by sede,carrera,jornada "
			
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
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
	<td bgcolor="#FF9900"><div align="center"><strong>Especialidad</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Plan</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Cód Asignatura</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Asignatura</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Sección</strong></div></td>
  </tr>
  <%NUMERO=1%>
  <%while f_listado.Siguiente%> <!-- mientras hay registro hace-->
  <tr>
    <td align="left"><%=NUMERO%> </td>
    <td align="left"><%=f_listado.ObtenerValor("sede")%></td>
	<td align="left"><%=f_listado.ObtenerValor("carrera")%></td>
	<td align="left"><%=f_listado.ObtenerValor("jornada")%></td>
    <td align="left"><%=f_listado.ObtenerValor("rut")%></td>
	<td align="left"><%=f_listado.ObtenerValor("alumno")%></td>
	<td align="left"><%=f_listado.ObtenerValor("especialidad")%></td>
	<td align="left"><%=f_listado.ObtenerValor("plan_estudio")%></td>
	<td align="left"><%=f_listado.ObtenerValor("asig_ccod")%></td>
	<td align="left"><%=f_listado.ObtenerValor("asignatura")%></td>
	<td align="left"><%=f_listado.ObtenerValor("seccion")%></td>
   </tr>
   <%NUMERO=NUMERO+1%>
  <%wend%>
</table>
</body>
</html>
