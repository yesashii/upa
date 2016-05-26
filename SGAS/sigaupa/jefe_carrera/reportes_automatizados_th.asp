<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=topones_horarios.xls"
Response.ContentType = "application/vnd.ms-excel"

'----------------------------------------------------------------------------------
peri_ccod = Request.QueryString("busqueda[0][peri_ccod]")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Topones de horario por semestres"

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

consulta = 	"select distinct a.matr_ncorr,sede_tdesc as sede,carr_tdesc as carrera, jorn_tdesc as jornada,c.pers_nrut,c.pers_xdv,c.pers_tape_paterno + ' ' + c.pers_tnombre  as alumno, "& vbCrLf &_
			" c.pers_temail as email,f.asig_ccod,f.asig_tdesc as asignatura_1, protic.horario_con_sala(e.secc_ccod) as horario,g.dias_ccod,g.hora_ccod, "& vbCrLf &_
			" (select top 1 asi.asig_tdesc from alumnos aa (nolock), cargas_academicas ab (nolock), secciones ac, bloques_horarios ad,ofertas_academicas oa,asignaturas asi "& vbCrLf &_
			"			where aa.pers_ncorr=a.pers_ncorr and aa.matr_ncorr=ab.matr_ncorr "& vbCrLf &_
			"			and ab.secc_Ccod=ac.secc_ccod and cast(ac.peri_ccod as varchar)='"&peri_ccod&"' "& vbCrLf &_
			"			and ac.secc_ccod=ad.secc_ccod and ac.asig_ccod = asi.asig_ccod "& vbCrLf &_
			"			and aa.ofer_ncorr=oa.ofer_ncorr and cast(oa.peri_ccod as varchar)='"&peri_ccod&"' "& vbCrLf &_
			"			and ad.dias_ccod=g.dias_ccod and ad.hora_ccod=g.hora_ccod and ac.asig_ccod <> e.asig_ccod) as asignatura_2 "& vbCrLf &_
			" from alumnos a (nolock), ofertas_academicas b, personas c, cargas_academicas d (nolock), secciones e, "& vbCrLf &_
			" asignaturas f,bloques_horarios g,sedes h, especialidades i, carreras j, jornadas k "& vbCrLf &_
			" where a.ofer_ncorr=b.ofer_ncorr and cast(b.peri_ccod as varchar)='"&peri_ccod&"' "& vbCrLf &_
			" and a.pers_ncorr=c.pers_ncorr "& vbCrLf &_
			" and a.matr_ncorr=d.matr_ncorr "& vbCrLf &_
			" and d.secc_ccod=e.secc_ccod "& vbCrLf &_
			" and e.secc_ccod=g.secc_ccod "& vbCrLf &_
			" and b.sede_ccod=h.sede_ccod "& vbCrLf &_
			" and b.espe_ccod=i.espe_ccod "& vbCrLf &_
			" and i.carr_ccod=j.carr_ccod "& vbCrLf &_
			" and b.jorn_ccod=k.jorn_ccod "& vbCrLf &_
			" and e.asig_ccod=f.asig_ccod  "& vbCrLf &_
			" and exists (select 1 from alumnos aa (nolock), cargas_academicas ab (nolock), secciones ac, bloques_horarios ad,ofertas_academicas oa "& vbCrLf &_
			"			where aa.pers_ncorr=a.pers_ncorr and aa.matr_ncorr=ab.matr_ncorr "& vbCrLf &_
			"			and ab.secc_Ccod=ac.secc_ccod and cast(ac.peri_ccod as varchar)='"&peri_ccod&"' "& vbCrLf &_
			"			and ac.secc_ccod=ad.secc_ccod "& vbCrLf &_
			"			and aa.ofer_ncorr=oa.ofer_ncorr and cast(oa.peri_ccod as varchar)='"&peri_ccod&"' "& vbCrLf &_
			"			and ad.dias_ccod=g.dias_ccod and ad.hora_ccod=g.hora_ccod and ac.asig_ccod <> e.asig_ccod) "& vbCrLf &_
			" union "& vbCrLf &_
			" select distinct a.matr_ncorr,sede_tdesc as sede,carr_tdesc as carrera, jorn_tdesc as jornada,c.pers_nrut,c.pers_xdv,c.pers_tape_paterno + ' ' + c.pers_tnombre  as alumno, "& vbCrLf &_
			" c.pers_temail as email,f.asig_ccod,f.asig_tdesc as asignatura_1, protic.horario_con_sala(e.secc_ccod) as horario,g.dias_ccod,g.hora_ccod, "& vbCrLf &_
			" (select top 1 asi.asig_tdesc  "& vbCrLf &_
			"			from alumnos aa (nolock), cargas_academicas ab (nolock), secciones ac, bloques_horarios ad,ofertas_academicas oa,asignaturas asi "& vbCrLf &_
			"			where aa.pers_ncorr=a.pers_ncorr and aa.matr_ncorr=ab.matr_ncorr "& vbCrLf &_
			"			and ab.secc_Ccod=ac.secc_ccod and cast(ac.peri_ccod as varchar)= '"&peri_ccod&"' "& vbCrLf &_
			"			and ac.secc_ccod=ad.secc_ccod and ac.asig_ccod = asi.asig_ccod and asi.duas_ccod = 3 "& vbCrLf &_
			"			and aa.ofer_ncorr=oa.ofer_ncorr and cast(oa.peri_ccod as varchar) = '"&peri_ccod&"' "& vbCrLf &_
			"			and ad.dias_ccod=g.dias_ccod and ad.hora_ccod=g.hora_ccod and ac.asig_ccod <> e.asig_ccod) as asignatura_2 "& vbCrLf &_
			" from alumnos a (nolock), ofertas_academicas b, personas c, cargas_academicas d (nolock), secciones e, "& vbCrLf &_
			" asignaturas f,bloques_horarios g,sedes h, especialidades i, carreras j, jornadas k "& vbCrLf &_
			" where a.ofer_ncorr=b.ofer_ncorr and cast(b.peri_ccod as varchar)='"&peri_ccod&"' "& vbCrLf &_
			" and a.pers_ncorr=c.pers_ncorr "& vbCrLf &_
			" and a.matr_ncorr=d.matr_ncorr "& vbCrLf &_
			" and d.secc_ccod=e.secc_ccod "& vbCrLf &_
			" and e.secc_ccod=g.secc_ccod "& vbCrLf &_
			" and b.sede_ccod=h.sede_ccod "& vbCrLf &_
			" and b.espe_ccod=i.espe_ccod "& vbCrLf &_
			" and i.carr_ccod=j.carr_ccod "& vbCrLf &_
			" and b.jorn_ccod=k.jorn_ccod "& vbCrLf &_
			" and e.asig_ccod=f.asig_ccod "& vbCrLf &_
			" and exists (select 1 from alumnos aa (nolock), cargas_academicas ab (nolock), secciones ac, bloques_horarios ad,ofertas_academicas oa,asignaturas asi "& vbCrLf &_
			"			where aa.pers_ncorr=a.pers_ncorr and aa.matr_ncorr=ab.matr_ncorr "& vbCrLf &_
			"			and ab.secc_Ccod=ac.secc_ccod and cast(ac.peri_ccod as varchar)='"&primer_semestre&"' "& vbCrLf &_
			"			and ac.secc_ccod=ad.secc_ccod "& vbCrLf &_
			"			and aa.ofer_ncorr=oa.ofer_ncorr and cast(oa.peri_ccod as varchar)='"&primer_semestre&"' and ac.asig_ccod=asi.asig_ccod and asi.duas_ccod = 3 "& vbCrLf &_
			"			and ad.dias_ccod=g.dias_ccod and ad.hora_ccod=g.hora_ccod and ac.asig_ccod <> e.asig_ccod) "& vbCrLf &_
			" order by sede, carrera, jornada  "

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
	<td bgcolor="#FF9900"><div align="center"><strong>Código</strong></div></td>
    <td bgcolor="#FF9900"><div align="center"><strong>Sede</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Carrera</strong></div></td>
    <td bgcolor="#FF9900"><div align="center"><strong>Jornada</strong></div></td>
    <td bgcolor="#FF9900"><div align="center"><strong>Rut</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Nombre</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Email</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Cód. Asignatura</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Asignatura 1</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Horario</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Día</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Hora</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Asignatura 2</strong></div></td>
  </tr>
  <%NUMERO=1%>
  <%while f_listado.Siguiente%> <!-- mientras hay registro hace-->
  <tr>
    <td align="left"><%=NUMERO%> </td>
	<td align="left"><%=f_listado.ObtenerValor("matr_ncorr")%></td>
    <td align="left"><%=f_listado.ObtenerValor("sede")%></td>
	<td align="left"><%=f_listado.ObtenerValor("carrera")%></td>
	<td align="left"><%=f_listado.ObtenerValor("jornada")%></td>
    <td align="left"><%=f_listado.ObtenerValor("pers_nrut")&"-"&f_listado.ObtenerValor("pers_xdv")%></td>
	<td align="left"><%=f_listado.ObtenerValor("alumno")%></td>
	<td align="left"><%=f_listado.ObtenerValor("email")%></td>
	<td align="left"><%=f_listado.ObtenerValor("asig_ccod")%></td>
	<td align="left"><%=f_listado.ObtenerValor("asignatura_1")%></td>
	<td align="left"><%=f_listado.ObtenerValor("horario")%></td>
	<td align="left"><%=f_listado.ObtenerValor("dias_ccod")%></td>
	<td align="left"><%=f_listado.ObtenerValor("hora_ccod")%></td>
	<td align="left"><%=f_listado.ObtenerValor("asignatura_2")%></td>
   </tr>
   <%NUMERO=NUMERO+1%>
  <%wend%>
</table>
</body>
</html>
