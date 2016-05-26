<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=Notas_parciales_Asignatura.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 300000
'----------------------------------------------------------------------------------
q_secc_ccod = Request.QueryString("secc_ccod")
parametro = Request.QueryString("parametro")

'q_secc_ccod=43309

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Listado de Alumnos"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

 docente = conexion.consultaUno("select top 1 pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from bloques_horarios a, bloques_profesores b, personas c where cast(a.secc_ccod as varchar)='"&q_secc_ccod&"' and a.bloq_ccod=b.bloq_ccod and b.pers_ncorr=c.pers_ncorr and b.tpro_ccod=1")

'---------------------------------------------------------------------------------------------------

set f_encabezado_lista = new CFormulario
f_encabezado_lista.Carga_Parametros "enca_lista_excel.xml", "movimiento_caja"
f_encabezado_lista.Inicializar conexion

consulta =  " SELECT ltrim(rtrim(A.ASIG_CCOD)) as ASIG_CCOD,ASIG_TDESC,CARR_TDESC,SECC_TDESC,'"&docente&"' as DOCENTE, D.PERI_TDESC AS PERIODO"& vbCrLf &_
			" FROM SECCIONES S, ASIGNATURAS A, CARRERAS C,PERIODOS_ACADEMICOS D"& vbCrLf &_
			" WHERE S.ASIG_CCOD=A.ASIG_CCOD AND S.CARR_CCOD=C.CARR_CCOD"& vbCrLf &_
			" AND cast(SECC_CCOD as varchar)='" & q_secc_ccod & "' AND S.PERI_CCOD=D.PERI_CCOD "

f_encabezado_lista.Consultar consulta

'-----------------------si la asignatura es anual y el periodo es priemr sem 2006 no considere estados matr. 
'---------------------------si es semestral o trimestral y el periodo mayor a 202 entonces no considere matr.
periodo = conexion.consultaUno("select peri_ccod from secciones where cast(secc_ccod as varchar)='"&q_secc_ccod&"'")
asig_ccod = conexion.consultaUno("select asig_ccod from secciones where cast(secc_ccod as varchar)='"&q_secc_ccod&"'")
duracion_asig = conexion.consultaUno("select duas_ccod from asignaturas where asig_ccod ='"&asig_ccod&"'")
filtro_matr = " and a.emat_ccod in (1,2) "
if duracion_asig = "3" and periodo >= "202" then
	filtro_matr = " "
elseif (duracion_asig = "1" or duracion_asig ="2") and periodo > "202" then
    filtro_matr = " "
end if
'-----------------------------------------------------------------------------------------------------------

'response.End()

consulta1="select count(*) as maximo "& vbCrLf &_
" from calificaciones_seccion cs"& vbCrLf &_
" where cast(cs.secc_ccod as varchar)='" & q_secc_ccod & "'"

max=conexion.consultauno(consulta1)


'-----------------------------------------------------------------------------------------------
set f_listado = new CFormulario
f_listado.Carga_Parametros "consulta.xml", "consulta" 'carga el xml
f_listado.Inicializar conexion 'inicializo conexion

consulta= " select b.matr_ncorr, cast(c.pers_nrut as varchar)+ '-' + c.pers_xdv as rut, "& vbCrLf &_
		  " c.pers_tape_paterno + ' ' + c.pers_tape_materno + ' ' + c.pers_tnombre as alumno, "& vbCrLf &_
		  " d.emat_tdesc as estado, a.sitf_ccod as est_final, "& vbCrLf &_
		  " a.carg_nnota_final as nota_final, a.carg_nasistencia as asistencia  "& vbCrLf &_
		  " from cargas_academicas a, alumnos b, personas c, estados_matriculas d "& vbCrLf &_
		  " where cast(secc_ccod as varchar) = '" & q_secc_ccod & "' "& vbCrLf &_
		  " and a.matr_ncorr = b.matr_ncorr "& vbCrLf &_
		  " and b.pers_ncorr = c.pers_ncorr "& vbCrLf &_
		  " and b.emat_ccod = d.emat_ccod  "& vbCrLf &_
		  " order by alumno"

'response.write("<pre>"&consulta&"</pre>")
'response.End()
f_listado.Consultar consulta 'este hace la pega
'response.write(consulta)

periodo = conexion.consultaUno("select peri_ccod from secciones where cast(secc_ccod as varchar)='"&q_secc_ccod&"'")
anos_ccod = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
periodo_tdesc = conexion.consultaUno("Select peri_tdesc from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")

'response.Write(anos_ccod)
if anos_ccod >= "2006" then
	 parametro="N"	 
end if

%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<script language="JavaScript">
</script>

</head>
<body>
<p>
<%
f_encabezado_lista.DibujaRegistro
%>
</p>
<table width="100%" border="1" cellpadding="0" cellspacing="0">
  <tr>
    <td bgcolor="#9999FF"><div align="center"><strong>NUM</strong></div></td>
	<td bgcolor="#9999FF"><div align="center"><strong>RUT</strong></div></td>
    <td bgcolor="#9999FF"><div align="center"><strong>NOMBRE DEL ALUMNO</strong></div></td>
	<td bgcolor="#9999FF"><div align="center"><strong>ESTADO MATRICULA</strong></div></td>
	<%
	set f_lista2 = new CFormulario
	f_lista2.Carga_Parametros "tabla_vacia.xml", "tabla"
	f_lista2.Inicializar conexion
	secc_ccod = q_secc_ccod		
	consulta =  "  select a.cali_ncorr,cast(datepart(day,cali_fevaluacion) as varchar) + '-' + "& vbCrLf &_	
				"       cast(datepart(month,cali_fevaluacion) as varchar) + '-' + "& vbCrLf &_	
				"       cast(datepart(year,cali_fevaluacion) as varchar) + ' (' + "& vbCrLf &_	
				"       cast(cali_nponderacion as varchar) + '% )' as muestra, "& vbCrLf &_	
				"       cali_nevaluacion as orden, "& vbCrLf &_	
				"       (select count(*) from calificaciones_alumnos ca where ca.cali_ncorr=a.cali_ncorr and ca.secc_ccod=a.secc_ccod ) as evaluado "& vbCrLf &_	
				"       from calificaciones_seccion a where cast(secc_Ccod as varchar)='"&secc_ccod&"' "& vbCrLf &_	
				" order by orden asc"
											
	f_lista2.Consultar consulta 
	contador2 = 1
	while f_lista2.siguiente
		muestra = f_lista2.ObtenerValor("muestra")		
		evaluado = f_lista2.ObtenerValor("evaluado")
		response.write("<td width=5 bgcolor=""#9999FF""><div align=""center""><strong>Evaluación "&contador2&"<br>"&muestra&"</strong></div></td>")
	    contador2 = contador2 + 1
	wend 
	%>
	<td bgcolor="#9999FF"><div align="center"><strong>ASISTENCIA</strong></div></td>
	<td bgcolor="#9999FF"><div align="center"><strong>NOTA FINAL</strong></div></td>
	<td bgcolor="#9999FF"><div align="center"><strong>ESTADO</strong></div></td>
  </tr>
  <%NUMERO=1%>
  <%while f_listado.Siguiente%> <!-- mientras hay registro hace-->
  <tr>
    <td><%=NUMERO%> </td>
	<td><%=f_listado.ObtenerValor("rut")%></td>
    <td><%=f_listado.ObtenerValor("alumno")%></td>
	<td><%=f_listado.ObtenerValor("estado")%></td>
	<%
	f_lista2.primero
	while f_lista2.siguiente
		clave = f_lista2.ObtenerValor("cali_ncorr")		
		alumno = f_listado.ObtenerValor("matr_ncorr")
		evaluado = f_lista2.ObtenerValor("evaluado")	
		if evaluado <> "0" then
			nota = conexion.consultaUno("select cala_nnota from calificaciones_alumnos where cast(cali_ncorr as varchar)='"&clave&"' and cast(matr_ncorr as varchar)='"&alumno&"'")
			response.write("<td width=5 bgcolor=""#FFFFFF""><div align=""center"">"&nota&"</div></td>")
		else
			response.write("<td width=5 bgcolor=""#FFFFFF""><div align=""center"">&nbsp;</div></td>")
		end if	
	wend
	%>
	<td><%=f_listado.ObtenerValor("asistencia")%>&nbsp;</td>
	<td><%=f_listado.ObtenerValor("nota_final")%>&nbsp;</td>
	<td><%=f_listado.ObtenerValor("est_final")%>&nbsp;</td>
  </tr>
   <%NUMERO=NUMERO+1%>
  <%wend%>
</table>
<table>
   <tr>
   		<td>&nbsp;</td>
   		<td>&nbsp;</td>
   		<td>&nbsp;</td>
   </tr>
</table>
</body>
</html>
