<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=evaluaciones.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 300000

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

sede_ccod  = request.QueryString("sede_ccod")
sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede_ccod&"'")

actividad = session("_actividad")
'response.Write("a "&actividad)
if (actividad = "7")  then
	periodo = negocio.obtenerPeriodoAcademico("TOMACARGA")
else
	periodo = negocio.obtenerPeriodoAcademico("CLASES18")
end if

'------------------------------------------------------------------------------------
set tabla = new cformulario
tabla.carga_parametros	"tabla_vacia.xml",	"tabla"
tabla.inicializar		conexion

usuario=negocio.ObtenerUsuario()
pers_ncorr_encargado=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")
periodo_tdesc = conexion.consultaUno("Select peri_tdesc from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")

consulta = "SELECT distinct a.ASIG_CCOD, a.ASIG_TDESC , secc_tdesc ,b.secc_ccod,d.carr_tdesc, e.jorn_tdesc, "& vbCrLf	&_
		    "(select case count(*) when '0' then 'No' else 'Sí' end  from bloques_horarios bb, bloques_profesores cc where bb.secc_ccod=b.secc_ccod and bb.bloq_ccod=cc.bloq_ccod and tpro_ccod=1) as con_docente, "& vbCrLf	&_
			"protic.PROFESORES_SECCION_CON_CORREO(b.secc_ccod) nombre_correo," & vbCrLf	&_
			"(select count(distinct cc.pers_ncorr) from bloques_horarios bb, bloques_profesores cc where bb.secc_ccod=b.secc_ccod and bb.bloq_ccod=cc.bloq_ccod and tpro_ccod=1) as Num, "& vbCrLf	&_
			"case isnull(b.estado_cierre_ccod,1) when 1 then 'Sin Cerrar' else 'Cerrada' end as estado, "& vbCrLf	&_
			"(select case count(*) when 0 then 'No' else 'Sí' end from calificaciones_seccion bb where b.secc_ccod=bb.secc_ccod)as con_evaluaciones, "& vbCrLf	&_
			"(select case count(*) when 0 then 'No' else 'Sí' end from calificaciones_alumnos bb where b.secc_ccod=bb.secc_ccod)as notas_parciales, "& vbCrLf &_	
			"(select case count(*) when 0 then 'No' else 'Sí' end from cargas_Academicas bb where b.secc_ccod=bb.secc_ccod and isnull(sitf_ccod,'0') <>'0' )as notas_finales, "& vbCrLf	&_
			"(select count(aa.matr_ncorr) from cargas_academicas aa , alumnos bb "& vbCrLf	&_
			   " where aa.matr_ncorr=bb.matr_ncorr "& vbCrLf	&_
			   " --and bb.emat_ccod in (1,2) "& vbCrLf	&_
			   " and aa.secc_ccod = b.secc_ccod "& vbCrLf	&_
			   " and aa.carg_nsence is  null "& vbCrLf	&_
			   " and aa.matr_ncorr    not in (select matr_ncorr_destino from resoluciones_homologaciones  where secc_ccod_destino = b.secc_ccod) "& vbCrLf	&_
			   " and aa.matr_ncorr    not in (select matr_ncorr from convalidaciones where matr_ncorr=aa.matr_ncorr and asig_ccod = b.asig_ccod)) as cant_alumnos, "& vbCrLf	&_ 
			   "(select count(aa.matr_ncorr) from cargas_academicas aa , alumnos bb "& vbCrLf	&_
			   " where aa.matr_ncorr=bb.matr_ncorr "& vbCrLf	&_
			   " --and bb.emat_ccod in (1,2) "& vbCrLf	&_
			   " and ltrim(rtrim(aa.sitf_ccod))='A'"& vbCrLf	&_
			   " and aa.secc_ccod = b.secc_ccod "& vbCrLf	&_
			   " and aa.carg_nsence is  null "& vbCrLf	&_
			   " and aa.matr_ncorr    not in (select matr_ncorr_destino from resoluciones_homologaciones  where secc_ccod_destino = b.secc_ccod) "& vbCrLf	&_
			   " and aa.matr_ncorr    not in (select matr_ncorr from convalidaciones where matr_ncorr=aa.matr_ncorr and asig_ccod = b.asig_ccod)) as cant_aprobados, "& vbCrLf	&_ 
			   "(select count(aa.matr_ncorr) from cargas_academicas aa , alumnos bb "& vbCrLf	&_
			   " where aa.matr_ncorr=bb.matr_ncorr "& vbCrLf	&_
			   " --and bb.emat_ccod in (1,2) "& vbCrLf	&_
			   " and ltrim(rtrim(aa.sitf_ccod))='R'"& vbCrLf	&_
			   " and aa.secc_ccod = b.secc_ccod "& vbCrLf	&_
			   " and aa.carg_nsence is  null "& vbCrLf	&_
			   " and aa.matr_ncorr    not in (select matr_ncorr_destino from resoluciones_homologaciones  where secc_ccod_destino = b.secc_ccod) "& vbCrLf	&_
			   " and aa.matr_ncorr    not in (select matr_ncorr from convalidaciones where matr_ncorr=aa.matr_ncorr and asig_ccod = b.asig_ccod)) as cant_reprobados, "& vbCrLf	&_ 
			   "(select count(aa.matr_ncorr) from cargas_academicas aa , alumnos bb "& vbCrLf	&_
			   " where aa.matr_ncorr=bb.matr_ncorr "& vbCrLf	&_
			   " --and bb.emat_ccod in (1,2) "& vbCrLf	&_
			   " and isnull(aa.sitf_ccod,'SP')='SP'"& vbCrLf	&_
			   " and aa.secc_ccod = b.secc_ccod "& vbCrLf	&_
			   " and aa.carg_nsence is  null "& vbCrLf	&_
			   " and aa.matr_ncorr    not in (select matr_ncorr_destino from resoluciones_homologaciones  where secc_ccod_destino = b.secc_ccod) "& vbCrLf	&_
			   " and aa.matr_ncorr    not in (select matr_ncorr from convalidaciones where matr_ncorr=aa.matr_ncorr and asig_ccod = b.asig_ccod)) as cant_pendientes, isnull(secc_porce_asiste,0) as porcentaje_a "& vbCrLf	&_ 
			"FROM asignaturas a, secciones b, bloques_horarios c, carreras d,jornadas e,especialidades f"& vbCrLf	&_
			"WHERE a.asig_ccod=b.asig_ccod "& vbCrLf	&_
			"  and cast(b.sede_ccod as varchar) = '"&sede_ccod&"'"& vbCrLf	&_
			"  and cast(b.peri_ccod as varchar)='"&periodo&"'"& vbCrLf	&_
			"  and b.secc_finicio_sec is not null and b.carr_ccod=d.carr_ccod and b.jorn_ccod=e.jorn_ccod"& vbCrLf	&_
			"  and d.carr_ccod = f.carr_ccod and f.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where pers_ncorr='"&pers_ncorr_encargado&"')"& vbCrLf	&_
			"  and b.secc_ftermino_sec is not null "& vbCrLf	&_
			"  and b.secc_ccod  = c.secc_ccod  ORDER BY carr_tdesc,jorn_tdesc,a.asig_tdesc, b.secc_tdesc"
			
'response.write("<pre>"&consulta&"</pre>")
'response.End()
tabla.consultar consulta 




fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
%>
<html>
<head>
<title>Listado de Asignaturas</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Evaluaciones Sedes</font></div>
	<div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Sede</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <% =sede_tdesc%> </td>
    
  </tr>
 <tr>
    <td><strong>Fecha</strong></td>
    <td colspan="3"> <strong>:</strong> <%=fecha%></td>
 </tr>
 <tr>
    <td><strong>Periodo</strong></td>
    <td colspan="3"> <strong>:</strong> <%=periodo_tdesc%></td>
 </tr>
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td><div align="center"><strong>Fila</strong></div></td>
    <td><div align="center"><strong>Carrera</strong></div></td>
    <td><div align="center"><strong>Jornada</strong></div></td>
	<td><div align="center"><strong>Código</strong></div></td>
    <td><div align="center"><strong>Asignatura</strong></div></td>
	<td><div align="center"><strong>Sección</strong></div></td>
    <td><div align="center"><strong>Con Profesores Asignados?</strong></div></td>
	<td><div align="center"><strong>Nº Profesores</strong></div></td>
	<td><div align="center"><strong>Porcentaje Asistencia</strong></div></td>
	<td><div align="center"><strong>Definió Evaluaciones?</strong></div></td>
	<td><div align="center"><strong>Tiene Notas Parciales</strong></div></td>
	<td><div align="center"><strong>Cant. Alumnos</strong></div></td>
	<td><div align="center"><strong>Cant. Aprobados</strong></div></td>
	<td><div align="center"><strong>Cant. Reprobados</strong></div></td>
	<td><div align="center"><strong>Cant. Pendientes</strong></div></td>
    <td><div align="center"><strong>Tiene Notas Finales?</strong></div></td>
	<td><div align="center"><strong>Estado Evaluación</strong></div></td>
	<td><div align="center"><strong>Nombre y Correo </strong></div></td>
  </tr>
  <%  
  fila=1  
  while tabla.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("carr_tdesc")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("jorn_tdesc")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("asig_ccod")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("asig_tdesc")%></div></td>
    <td><div align="center"><%=tabla.ObtenerValor("secc_tdesc")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("con_docente")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("Num")%></div></td>
	<td><div align="center"><%=tabla.ObtenerValor("porcentaje_a")%></div></td>
	<td><div align="center"><%=tabla.ObtenerValor("con_evaluaciones")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("notas_parciales")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("cant_alumnos")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("cant_aprobados")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("cant_reprobados")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("cant_pendientes")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("notas_finales")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("estado")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("nombre_correo")%></div></td>
  </tr>
  <% fila=fila +1 
   wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>