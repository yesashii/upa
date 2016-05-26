<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%
Response.AddHeader "Content-Disposition", "attachment;filename=entrevistas_facultad.xls"
Response.ContentType = "application/vnd.ms-excel"


set conexion = new cConexion
set z = new cHorario
set negocio = new cnegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion

facu_ccod = request.querystring("facu_ccod")
periodo = negocio.obtenerPeriodoAcademico("POSTULACION")


facu_tdesc = conexion.consultauno("select facu_tdesc from facultades where cast(facu_ccod as varchar)= '"&facu_ccod&"'")
peri_tdesc = conexion.consultauno("select peri_tdesc from periodos_academicos where cast(peri_ccod as varchar) ='"&periodo&"'")
fecha2 = conexion.consultauno("select protic.trunc(getDate())")

set f_consulta = new CFormulario
f_consulta.Carga_Parametros "tabla_vacia.xml", "tabla"
f_consulta.Inicializar conexion

consulta = 	" select g.sede_tdesc as sede, b.carr_tdesc as carrera, h.jorn_tdesc as jornada,  " & vbCrLf &_
			"  cast(i.pers_nrut as varchar)+'-'+ i.pers_xdv as rut, protic.initCap(i.pers_tnombre + ' ' + i.pers_tape_paterno + ' ' + i.pers_tape_materno) as postulante,  " & vbCrLf &_
		    "  i.pers_tfono as teléfono, i.pers_tcelular as celular, lower(i.pers_temail) as email, j.fecha_entrevista, protic.trunc(j.fecha_entrevista) as fecha,  " & vbCrLf &_
			"  htes_hinicio as hora  " & vbCrLf &_
			" from areas_academicas a, carreras b, especialidades c, ofertas_academicas d,   " & vbCrLf &_
			"     detalle_postulantes e, postulantes f, sedes g, jornadas h, personas_postulante i, observaciones_postulacion j, horarios_test k  " & vbCrLf &_
			" where a.area_ccod=b.area_ccod and b.carr_ccod=c.carr_ccod  " & vbCrLf &_
			"     and cast(a.facu_ccod as varchar)='"&facu_ccod&"' and c.espe_ccod=d.espe_ccod  " & vbCrLf &_
			"     and cast(d.peri_ccod as varchar)='"&periodo&"' and d.post_bnuevo='S'  " & vbCrLf &_
			"     and d.ofer_ncorr=e.ofer_ncorr and e.post_ncorr=f.post_ncorr  " & vbCrLf &_
			"     and d.sede_ccod=g.sede_ccod and d.jorn_ccod=h.jorn_ccod  " & vbCrLf &_
			"     and f.pers_ncorr=i.pers_ncorr and e.post_ncorr=j.post_ncorr and e.ofer_ncorr=j.ofer_ncorr  " & vbCrLf &_
			"     and isnull(protic.trunc(j.fecha_entrevista),'') <> '' and j.htes_ccod=k.htes_ccod  " & vbCrLf &_
			"     and fecha_entrevista >= convert(datetime, protic.trunc(getDate()),103)  " & vbCrLf &_
			" order by fecha_entrevista,hora,sede,carrera,jornada  "


f_consulta.Consultar consulta
%><html>
<head>
<title>Horario de la sala para el periodo</title>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript1.2" src="tabla.js"></script>
<script language="JavaScript" >
</script>
</head>
<body bgcolor="#FFFFFF">
<h1 align="right"><font size="4">UPACIFICO</font></h1>
<h2 class="Estilo1">Reporte de entrevistas agendadas para la facultad</h2>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="10%"><font size="2"><strong>Facultades</strong></font></td>
    <td><font size="2">: <%=facu_tdesc%></font></td>
  </tr>
  <tr> 
    <td width="10%"><font size="2"><strong>Período</strong></font></td>
    <td><font size="2">: <%=peri_tdesc%></font></td>
  </tr>
  <tr> 
    <td><font size="2"><strong>Fecha actual</strong></font></td>
    <td><font size="2">: <%=fecha2%> </font></td>
  </tr>
  <tr> 
    <td><font size="2">&nbsp;</font></td>
    <td>&nbsp;</td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <th bgcolor="#0066CC"><font size="1" color="#FFFFFF"><strong>Fecha entrevista</strong></font></th>
	<th bgcolor="#0066CC"><font size="1" color="#FFFFFF"><strong>Hora</strong></font></th>
	<th bgcolor="#0066CC"><font size="1" color="#FFFFFF"><strong>Sede</strong></font></th>
	<th bgcolor="#0066CC"><font size="1" color="#FFFFFF"><strong>Carrera</strong></font></th>
	<th bgcolor="#0066CC"><font size="1" color="#FFFFFF"><strong>Jornada</strong></font></th>
	<th bgcolor="#0066CC"><font size="1" color="#FFFFFF"><strong>Rut</strong></font></th>
	<th bgcolor="#0066CC"><font size="1" color="#FFFFFF"><strong>Nombre postulante</strong></font></th>
	<th bgcolor="#0066CC"><font size="1" color="#FFFFFF"><strong>Teléfono</strong></font></th>
	<th bgcolor="#0066CC"><font size="1" color="#FFFFFF"><strong>Celular</strong></font></th>
	<th bgcolor="#0066CC"><font size="1" color="#FFFFFF"><strong>Email</strong></font></th>
  </tr>
  <%
  	while  f_consulta.siguiente
  %>
  <tr> 
    <td><%=f_consulta.obtenerValor("fecha")%></td>
	<td align="center"><%=f_consulta.obtenerValor("hora")%></td>
	<td><%=f_consulta.obtenerValor("sede")%></td>
	<td><%=f_consulta.obtenerValor("carrera")%></td>
	<td><%=f_consulta.obtenerValor("jornada")%></td>
	<td><%=f_consulta.obtenerValor("rut")%></td>
	<td><%=f_consulta.obtenerValor("postulante")%></td>
	<td align="center"><%=f_consulta.obtenerValor("teléfono")%></td>
	<td align="center"><%=f_consulta.obtenerValor("celular")%></td>
	<td><%=f_consulta.obtenerValor("email")%></td>
  </tr>
  <%wend %>
</table>
</body>
</html>
