<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=actas_escuela.doc"
Response.ContentType = "application/vnd.ms-word"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
v_peri_ccod=negocio.obtenerPeriodoAcademico("TOMACARGA")
'-----------------------------------------------------------------------
sede=request.Form("sede")
carrera=request.Form("carrera")
jornada=request.Form("jornada")
'------------------------------------------------------------------------------------

fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------

set f_secciones = new CFormulario
f_secciones.Carga_Parametros "tabla_vacia.xml", "tabla"
f_secciones.Inicializar conexion
		   
consulta = " select distinct top 2 a.secc_ccod,secc_tdesc as seccion,ltrim(rtrim(b.asig_ccod))+' ' + b.asig_tdesc as asig_tdesc, c.duas_tdesc as duracion, "& vbCrLf &_
		   " d.anos_ccod as ano_curso, d.plec_ccod as plec_ccod,protic.retorna_profesor(cast(a.secc_ccod aS varchar)) as PROFESOR, "& vbCrLf &_
		   " isnull(protic.obtener_nombre_completo(e.PERS_NCORR, 'n'),'Encargado') AS DIRECTOR_CARRERA,  "& vbCrLf &_
		   " case a.estado_cierre_ccod when 2 then 'ACTA FINAL' else 'ACTA FINAL (PROVISORIA)' end  as titulo "& vbCrLf &_
		   " from secciones a join  asignaturas b  "& vbCrLf &_
		   " 		on a.asig_ccod = b.asig_ccod  "& vbCrLf &_
		   " join duracion_asignatura c    "& vbCrLf &_
		   "		on b.duas_ccod=c.duas_ccod "& vbCrLf &_
		   " join periodos_academicos d "& vbCrLf &_
		   "		on a.peri_ccod = d.peri_ccod "& vbCrLf &_
		   " left outer join cargos_carrera e "& vbCrLf &_
		   "		on a.carr_ccod = e.carr_ccod and a.sede_ccod = e.sede_ccod and 1 = e.tcar_ccod "& vbCrLf &_
		   " where cast(a.sede_ccod as varchar)='1' and a.carr_ccod='21' and cast(a.jorn_ccod as varchar)='1'  "& vbCrLf &_
		   " and cast(a.peri_ccod as varchar)='202' "& vbCrLf &_
   	       " and exists (select 1 from cargas_academicas ca where ca.secc_ccod=a.secc_ccod ) "& vbCrLf &_
		   " order by asig_tdesc asc, secc_tdesc asc "

 
f_secciones.Consultar consulta
%>
<html>
<head>
<title>Actas por carrera</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<%while f_secciones.siguiente%>
<table width="100%" border="0">
 <tr> 
    <td colspan="3"><div align="center"><font size="+1" face="Arial, Helvetica, sans-serif">Universidad Del Pac&Iacute;fico</font></div></td>
 </tr>
 <tr> 
    <td colspan="3"><div align="center"><font size="+1" face="Arial, Helvetica, sans-serif">REGISTRO CURRICULAR</font></div></td>
 </tr>
  <tr> 
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="3"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif"><%=f_secciones.obtenerValor("titulo")%></font></div></td>
 </tr>
  <tr> 
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><font face="Times New Roman, Times, serif" size="2"><strong>ASIGNATURA</strong></font></td>
    <td width="84%" colspan="2"><font face="Times New Roman, Times, serif" size="2"><strong>:</strong> <% =f_secciones.obtenerValor("asig_tdesc")%></font></td>
  </tr>
  <tr> 
    <td width="16%"><font face="Times New Roman, Times, serif" size="2"><strong>CARACTER</strong></font></td>
    <td width="84%" colspan="2"><font face="Times New Roman, Times, serif" size="2"><strong>:</strong> <% =f_secciones.obtenerValor("duracion")%></font> </td>
  </tr>
  <tr> 
    <td width="16%"><font face="Times New Roman, Times, serif" size="2"><strong>SECCIÓN</strong></font></td>
    <td width="84%" colspan="2"><font face="Times New Roman, Times, serif" size="2"><strong>:</strong><% =f_secciones.obtenerValor("seccion")%></font> </td>
  </tr>
  <tr> 
    <td width="16%"><font face="Times New Roman, Times, serif" size="2"><strong>PROFESOR</strong></font></td>
    <td width="84%" colspan="2"><font face="Times New Roman, Times, serif" size="2"><strong>:</strong> <% =f_secciones.obtenerValor("profesor")%></font> </td>
  </tr>
  <tr> 
    <td width="16%"><font face="Times New Roman, Times, serif" size="2"><strong>AÑO</strong></font></td>
    <td width="84%" colspan="2"><font face="Times New Roman, Times, serif" size="2"><strong>:</strong> <% =f_secciones.obtenerValor("asig_tdesc")%>&nbsp;&nbsp;&nbsp;<strong>SEMESTRE  :</strong> <% =f_secciones.obtenerValor("plec_ccod")%></font> </td>
  </tr>
</table>
<table width="100%" border="2">
  <tr> 
    <td width="3%"><div align="center"><font face="Times New Roman, Times, serif" size="2"><strong>N°</strong></font></div></td>
    <td width="10%"><div align="center"><font face="Times New Roman, Times, serif" size="2"><strong>Rut</strong></font></div></td>
    <td width="40%" align="left"><font face="Times New Roman, Times, serif" size="2"><table width="100%"><tr>
	                                                    <td align="center" width="50%"><strong>Apellidos</strong></td>
														<td align="center" width="50%"><strong>Nombres</strong></td>
													</tr>
								 </table></font></td>
    <td width="10%"><div align="center"><font face="Times New Roman, Times, serif" size="2"><strong>Asistencia</strong></font></div></td>
	<td width="10%"><div align="center"><font face="Times New Roman, Times, serif" size="2"><strong>Nota Final</strong></font></div></td>
    <td width="10%"><div align="center"><font face="Times New Roman, Times, serif" size="2"><strong>Concepto</strong></font></div></td>
  </tr>
  <%  secc_ccod = f_secciones.obtenerValor("secc_ccod")
  
     set f_alumnos = new CFormulario
	 f_alumnos.Carga_Parametros "tabla_vacia.xml", "tabla"
	 f_alumnos.Inicializar conexion
     consulta_alumnos = " select cast(c.pers_nrut as varchar)+'-' + c.pers_xdv as rut, c.pers_tape_paterno + ' ' + c.pers_tape_materno as apellidos, "& vbCrLf &_
					  " c.pers_tnombre as nombres, isnull(cast(a.carg_nasistencia as varchar),'') as asistencia, isnull(cast(a.carg_nnota_final as varchar),'') as nota_final, isnull(cast(sitf_ccod as varchar),'') as concepto "& vbCrLf &_
					  " from cargas_academicas a, alumnos b, personas c "& vbCrLf &_
					  " where cast(secc_ccod as varchar)='"&secc_ccod&"' "& vbCrLf &_
					  " and a.matr_ncorr=b.matr_ncorr and b.pers_ncorr=c.pers_ncorr"
   
   f_alumnos.Consultar consulta_alumnos
   fila = 1
   while f_alumnos.Siguiente %>
  <tr> 
    <td><div align="center"><font face="Times New Roman, Times, serif" size="2"><%=fila%></font></div></td>
    <td><div align="center"><font face="Times New Roman, Times, serif" size="2"><%=f_alumnos.ObtenerValor("rut")%></font></div></td>
    <td><font face="Times New Roman, Times, serif" size="2"><table width="100%"><tr>
	                                               <td align="center" width="50%"><%=f_alumnos.ObtenerValor("apellidos")%></td>
												   <td align="center" width="50%"><%=f_alumnos.ObtenerValor("nombres")%></td>
											  </tr>
						   </table></font>
	</td>
    <td><font face="Times New Roman, Times, serif" size="2"><div align="center"><%=f_alumnos.ObtenerValor("asistencia")%></div></font></td>
    <td><font face="Times New Roman, Times, serif" size="2"><div align="center"><%=f_alumnos.ObtenerValor("nota_final")%></div></font></td>
    <td><font face="Times New Roman, Times, serif" size="2"><div align="center"><%=f_alumnos.ObtenerValor("concepto")%></div></font></td>
  </tr>
  <% fila = fila + 1  
    wend %>
</table>
<table width="100%">
<tr><td colspan="2">&nbsp;</td></tr>
<tr><td colspan="2">&nbsp;</td></tr>
<tr><td colspan="2">&nbsp;</td></tr>
<tr>
    <td align="center"><strong>_______________________</strong></td>
	<td align="center"><strong>_______________________</strong></td>
</tr>
<tr>
    <td align="center"><strong>Elena Ort&uacute;zar Mu&ntilde;oz</strong></td>
	<td align="center"><strong><%=f_secciones.obtenerValor("director_carrea")%></strong></td>
</tr>
<tr>
    <td align="center"><strong>Secretaria General</strong></td>
	<td align="center"><strong>Director Escuela</strong></td>
</tr>
<tr>
    <td align="center"><strong>Universidad del Pac&iacute;fico</strong></td>
	<td align="center"><strong>Universidad del Pac&iacute;fico</strong></td>
</tr>
</table>
<%Wend%>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>