<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=evaluaciones.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 300000

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

periodo = "240"

c_maxima_evaluacion = " select max(b.cali_nevaluacion) " & vbCrLf	&_
					  " from secciones a, calificaciones_Seccion b " & vbCrLf	&_
					  " where a.secc_ccod=b.secc_ccod " & vbCrLf	&_
					  " and cast(a.peri_ccod as varchar) = '"&periodo&"' "

maxima_evolucion = conexion.consultaUno(c_maxima_evaluacion)

'------------------------------------------------------------------------------------
set tabla = new cformulario
tabla.carga_parametros	"tabla_vacia.xml",	"tabla"
tabla.inicializar		conexion

consulta =  " select distinct  top 50 g.facu_tdesc as facultad,sede_tdesc as sede,carr_tdesc as carrera, jorn_tdesc as jornada, "& vbCrLf	&_
			" e.asig_ccod as cod_asignatura, e.asig_tdesc as asignatura, "& vbCrLf	&_
			" a.secc_tdesc as seccion, a.secc_ccod, h.matr_ncorr, cast(j.pers_nrut as varchar)+'-'+j.pers_xdv as rut, "& vbCrLf	&_
			" j.pers_tape_paterno + ' ' + j.pers_tape_materno + ', ' + j.pers_tnombre as alumno, "& vbCrLf	&_
			" (select count(*) from calificaciones_seccion tt where tt.secc_ccod = a.secc_ccod ) as calificaciones "& vbCrLf	&_
			" from alumnos i (nolock), personas j, ofertas_academicas k, especialidades l,secciones a, sedes b, carreras c, jornadas d, asignaturas e, areas_academicas f, facultades g,cargas_academicas h (nolock)  "& vbCrLf	&_
			" where i.pers_ncorr=j.pers_ncorr and i.ofer_ncorr=k.ofer_ncorr "& vbCrLf	&_
			" and cast(k.peri_ccod as varchar)='"&periodo&"' "& vbCrLf	&_
			" and i.matr_ncorr=h.matr_ncorr "& vbCrLf	&_ 
			" and h.secc_ccod=a.secc_ccod and k.espe_ccod=l.espe_ccod "& vbCrLf	&_
			" and k.sede_ccod=b.sede_ccod and l.carr_ccod=c.carr_ccod "& vbCrLf	&_
			" and k.jorn_ccod=d.jorn_ccod and a.asig_ccod=e.asig_ccod "& vbCrLf	&_
			" and c.area_ccod=f.area_ccod and f.facu_ccod=g.facu_ccod "& vbCrLf	&_
			" order by sede, carrera, jornada, alumno "

			
'response.write("<pre>"&consulta&"</pre>")
'response.End()
tabla.consultar consulta 

set tabla_e = new cformulario
tabla_e.carga_parametros	"tabla_vacia.xml",	"tabla"
tabla_e.inicializar		conexion

consulta_e = "  select a.secc_ccod, b.cali_nevaluacion, c.matr_ncorr, c.cala_nnota, d.teva_tdesc, b.cali_nponderacion  "& vbCrLf	&_ 
			 "	from secciones a, calificaciones_seccion b (nolock), calificaciones_alumnos c (nolock), tipos_evaluacion d  "& vbCrLf	&_
			 "	where a.secc_ccod=b.secc_ccod   "& vbCrLf	&_
			 "	and b.secc_ccod=c.secc_ccod   "& vbCrLf	&_
			 "	and b.cali_ncorr = c.cali_ncorr  "& vbCrLf	&_
			 "	and b.teva_ccod = d.teva_ccod  "& vbCrLf	&_
			 "	and cast(a.peri_ccod as varchar)='"&periodo&"'  "& vbCrLf	&_
			 "	order by c.matr_ncorr, b.cali_nevaluacion"

tabla_e.consultar consulta_e 

fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
%>
<html>
<head>
<title>Listado de Calificaciones parciales por alumno</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
  <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado de Calificaciones parciales por alumno</font></div></td>
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
    <td><strong>Fecha</strong></td>
    <td colspan="3"> <strong>:</strong> <%=fecha%></td>
  </tr>
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td><div align="center"><strong>Fila</strong></div></td>
    <td><div align="center"><strong>Facultad</strong></div></td>
    <td><div align="center"><strong>Sede</strong></div></td>
	<td><div align="center"><strong>Carrera</strong></div></td>
    <td><div align="center"><strong>Jornada</strong></div></td>
	<td><div align="center"><strong>Código</strong></div></td>
    <td><div align="center"><strong>Asignatura</strong></div></td>
	<td><div align="center"><strong>Sección</strong></div></td>
	<td><div align="center"><strong>Rut</strong></div></td>
	<td><div align="center"><strong>Alumno</strong></div></td>
	<%
	  posicion = 1
	  while posicion <= cint(maxima_evolucion)
	%>  
	    <td colspan="3"><div align="center"><strong><%=posicion%></strong></div></td>
	<% posicion = posicion + 1
	  wend
	%>
  </tr>
  <%  
  fila=1  
  while tabla.Siguiente 
     seccion = tabla.obtenerValor("secc_ccod")
	 matricula = tabla.obtenerValor("matr_ncorr")
	 calificaciones = tabla.obtenerValor("calificaciones")%>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("facultad")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("sede")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("carrera")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("jornada")%></div></td>
    <td><div align="center"><%=tabla.ObtenerValor("cod_asignatura")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("asignatura")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("seccion")%></div></td>
	<td><div align="center"><%=tabla.ObtenerValor("rut")%></div></td>
	<td><div align="center"><%=tabla.ObtenerValor("alumno")%></div></td>
	<%
	  posicion = 1
	  while posicion <= cint(maxima_evolucion)
	     posicion2 = 1
		 tabla_e.primero
		 while (tabla_e.siguiente or posicion2 <= calificaciones)
		    if cdbl(seccion) = cdbl(tabla_e.obtenerValor("secc_ccod")) and cdbl(matricula) = cdbl(tabla_e.obtenerValor("matr_ncorr")) and cint(posicion) = cint(tabla_e.obtenerValor("cali_nevaluacion")) then
			   posicion2 = posicion2 + 1
			   nota = tabla_e.obtenerValor("cala_nnota")
			   tipo = tabla_e.obtenerValor("teva_tdesc")
			   ponderacion =  tabla_e.obtenerValor("cali_nponderacion")
			end if
		 wend
	%>  
	    <td><div align="center"><%=nota%></div></td>
	    <td><div align="left"><%=tipo%></div></td>
	    <td><div align="center"><%=ponderacion%></div></td>
	<%  posicion = posicion + 1
	    nota = ""
	    tipo = ""
	    ponderacion =  ""
	  wend
	%>
  </tr>
  <% fila=fila +1 
   wend %>
</table>
</body>
</html>