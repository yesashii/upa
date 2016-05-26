<!-- #include file = "../biblioteca/_conexion.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=cumplimiento_asignaturas_salida.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

'-----------------------------------------------------------------------
q_saca_ncorr = Request.QueryString("saca_ncorr")
q_pers_ncorr = Request.QueryString("pers_ncorr")
'------------------------------------------------------------------------------------
fecha_actual=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------

set f_salida = new CFormulario
f_salida.Carga_Parametros "tabla_vacia.xml", "tabla"
f_salida.Inicializar conexion

SQL = " select b.pers_ncorr,a.saca_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut,  "& vbCrLf &_
      " b.pers_tnombre + ' ' + b.pers_tape_paterno + ' ' + b.pers_tape_materno as alumno, "& vbCrLf &_
	  " a.saca_tdesc as salida, c.tsca_ccod,case c.tsca_ccod when 1 then '<font color=#073299><strong>' "& vbCrLf &_ 
      "            when 2 then '<font color=#004000><strong>' "& vbCrLf &_ 
  	  " 		   when 3 then '<font color=#b76d05><strong>' "& vbCrLf &_ 
	  "			   when 4 then '<font color=#714e9c><strong>' "& vbCrLf &_ 
	  " 		   when 5 then '<font color=#ab2b05><strong>' "& vbCrLf &_ 
	  "  		   when 6 then '<font color=#0078c0><strong>' end + c.tsca_tdesc + '</strong></font>' as tipo_salida, d.carr_ccod, d.carr_tdesc, "& vbCrLf &_
      "    (select top 1 sede_ccod from alumnos t1, ofertas_academicas t2, especialidades t3 "& vbCrLf &_
      "            where t1.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod "& vbCrLf &_
      "            and t1.pers_ncorr=b.pers_ncorr and t3.carr_ccod=a.carr_ccod order by t2.peri_ccod desc) as sede_ccod, "& vbCrLf &_
      "    (select top 1 sede_tdesc from alumnos t1, ofertas_academicas t2, especialidades t3,sedes t4 "& vbCrLf &_
      "            where t1.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod and t2.sede_ccod=t4.sede_ccod "& vbCrLf &_
      "            and t1.pers_ncorr=b.pers_ncorr and t3.carr_ccod=a.carr_ccod order by t2.peri_ccod desc) as sede_tdesc,   "& vbCrLf &_
      "    (select top 1 jorn_tdesc from alumnos t1, ofertas_academicas t2, especialidades t3,jornadas t4 "& vbCrLf &_
      "            where t1.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod and t2.jorn_ccod=t4.jorn_ccod "& vbCrLf &_
      "            and t1.pers_ncorr=b.pers_ncorr and t3.carr_ccod=a.carr_ccod order by t2.peri_ccod desc) as jorn_tdesc,"& vbCrLf &_              
	  "    (select top 1 peri_ccod from alumnos t1, ofertas_academicas t2, especialidades t3 "& vbCrLf &_
      "            where t1.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod "& vbCrLf &_
      "            and t1.pers_ncorr=b.pers_ncorr and t3.carr_ccod=a.carr_ccod and t1.emat_ccod in (4,8) "& vbCrLf &_
	  "            order by t2.peri_ccod desc) as peri_ccod, "& vbCrLf &_
	  "    (select top 1 peri_tdesc from alumnos t1, ofertas_academicas t2, especialidades t3,periodos_academicos t4 "& vbCrLf &_
      "            where t1.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod and t2.peri_ccod=t4.peri_ccod "& vbCrLf &_
      "            and t1.pers_ncorr=b.pers_ncorr and t3.carr_ccod=a.carr_ccod and t1.emat_ccod in (4,8) "& vbCrLf &_
	  "            order by t2.peri_ccod desc) as peri_tdesc, "& vbCrLf &_
      "    (select case count(*) when 0 then 'N' else 'S' end  from alumnos t1, ofertas_academicas t2, especialidades t3 "& vbCrLf &_
      "            where t1.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod "& vbCrLf &_
      "            and t1.pers_ncorr=b.pers_ncorr and t3.carr_ccod=a.carr_ccod and t1.emat_ccod in (4)) as egresado,     "& vbCrLf &_
      "    (select case count(*) when 0 then 'N' else 'S' end  from alumnos t1, ofertas_academicas t2, especialidades t3 "& vbCrLf &_
      "            where t1.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod "& vbCrLf &_
      "            and t1.pers_ncorr=b.pers_ncorr and t3.carr_ccod=a.carr_ccod and t1.emat_ccod in (8)) as titulado, "& vbCrLf &_
	  "    (select t1.plan_ccod  from alumnos t1, ofertas_academicas t2, especialidades t3 "& vbCrLf &_
      "            where t1.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod "& vbCrLf &_
      "            and t1.pers_ncorr=b.pers_ncorr and t3.carr_ccod=a.carr_ccod and t1.emat_ccod in (8)) as plan_ccod "& vbCrLf &_
	  " from salidas_carrera a, personas b,tipos_salidas_carrera c, carreras d "& vbCrLf &_
	  " where cast(b.pers_ncorr as varchar)='"&q_pers_ncorr&"' and cast(a.saca_ncorr as varchar)='"&q_saca_ncorr&"' "& vbCrLf &_
	  " and a.tsca_ccod=c.tsca_ccod and a.carr_ccod=d.carr_ccod "

f_salida.Consultar SQL
f_salida.Siguiente
rut = f_salida.obtenerValor("rut")
alumno = f_salida.obtenerValor("alumno")
carrera = f_salida.obtenerValor("carr_tdesc")
sede = f_salida.obtenerValor("sede_tdesc")
jornada = f_salida.obtenerValor("jorn_tdesc")
tipo_salida = f_salida.obtenerValor("tipo_salida")
sal = f_salida.obtenerValor("salida")

plan_ccod = f_salida.obtenerValor("plan_ccod")
egresado  = f_salida.obtenerValor("egresado")
titulado  = f_salida.obtenerValor("titulado")
carr_ccod = f_salida.obtenerValor("carr_ccod")
tsca_ccod = f_salida.obtenerValor("tsca_ccod")
f_salida.primero

set f_asignaturas = new CFormulario
f_asignaturas.Carga_Parametros "tabla_vacia.xml", "tabla"
f_asignaturas.Inicializar conexion

c_asignaturas_faltantes = " select d.espe_tdesc as especialidad,c.plan_tdesc as plan_estudio, e.asig_ccod as cod_asignatura, e.asig_tdesc as asignatura, "& vbCrLf &_
						  " case protic.es_ramo_aprobado('"&q_pers_ncorr&"',b.asig_ccod,'"&carr_ccod&"',"&plan_ccod&") when 0 then 'N0' else 'SI' end as aprobado "& vbCrLf &_
						  " from asignaturas_salidas_carrera a, malla_curricular b, planes_estudio c, especialidades d, asignaturas e  "& vbCrLf &_
						  " where a.mall_ccod=b.mall_ccod and b.plan_ccod=c.plan_ccod and c.espe_ccod=d.espe_ccod "& vbCrLf &_
						  " and b.asig_ccod=e.asig_ccod "& vbCrLf &_
						  " and cast(a.saca_ncorr as varchar)='"&q_saca_ncorr&"'  "& vbCrLf &_
						  " order by aprobado,especialidad, plan_estudio, asignatura"
'response.Write("<pre>"&c_asignaturas_faltantes&"</pre>")
f_asignaturas.Consultar c_asignaturas_faltantes						  
'response.End()
%>
<html>
<head>
<title> DListado Convalidaciones</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado de cumplimiento requisitos de asignaturas salida</font></div>
	<div align="right"><%=fecha_actual%></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Sede</strong></td>
    <td width="84%" colspan="3"><strong>:</strong><%=sede%> </td>
  </tr>
  <tr> 
    <td width="16%"><strong>Carrera</strong></td>
    <td width="84%" colspan="3"><strong>:</strong><%=carrera%> </td>
  </tr>
  <tr> 
    <td width="16%"><strong>Jornada</strong></td>
    <td width="84%" colspan="3"><strong>:</strong><%=jornada%> </td>
  </tr>
    <tr> 
    <td width="16%"><strong>Rut</strong></td>
    <td width="84%" colspan="3"><strong>:</strong><%=rut%> </td>
  </tr>
    <tr> 
    <td width="16%"><strong>Nombre</strong></td>
    <td width="84%" colspan="3"><strong>:</strong><%=alumno%> </td>
  </tr>
  <tr> 
    <td width="16%"><strong>Salida</strong></td>
    <td width="84%" colspan="3"><strong>:</strong><%=sal%> </td>
  </tr>
  <tr> 
    <td><strong>Tipo</strong></td>
    <td colspan="3"><strong>:</strong><%=tipo_salida%> </td>
  </tr>
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td bgcolor="#666699"><div align="center"><strong>Aprobado</strong></div></td>
    <td bgcolor="#666699"><div align="center"><strong>Especialidad</strong></div></td>
    <td bgcolor="#666699"><div align="center"><strong>Plan</strong></div></td>
	<td bgcolor="#666699"><div align="center"><strong>Código</strong></div></td>
	<td bgcolor="#666699"><div align="center"><strong>Asignatura</strong></div></td>
  </tr>
  <%  while f_asignaturas.Siguiente %>
  <tr> 
    <td><div align="center"><%=f_asignaturas.ObtenerValor("aprobado")%></div></td>
    <td><div align="left"><%=f_asignaturas.ObtenerValor("especialidad")%></div></td>
    <td><div align="left"><%=f_asignaturas.ObtenerValor("plan_estudio")%></div></td>
	<td><div align="left"><%=f_asignaturas.ObtenerValor("cod_asignatura")%></div></td>
    <td><div align="left"><%=f_asignaturas.ObtenerValor("asignatura")%></div></td>
  </tr>
  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>