<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=rep_inscritos.xls"
Response.ContentType = "application/vnd.ms-excel"


'---------------------------------------------------------------------------------------------------
q_peri_ccod = Request.QueryString("peri_ccod")
q_sede_ccod = Request.QueryString("sede_ccod")
q_carr_ccod = Request.QueryString("carr_ccod")


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Gestión Alumnos con Ramos Inscritos"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


'---------------------------------------------------------------------------------------------------
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "rep_inscritos.xml", "inscritos2"
f_consulta.Inicializar conexion

'SQL = " SELECT CARR_TDESC CARRERA,ASIG_TDESC ASIGNATURA,SECC_TDESC SECCION,DECODE(S.JORN_CCOD,1,'D',2,'V') JORNADA,"
'SQL = SQL &  "        MC.NIVE_CCOD, COUNT(*) INSCRITOS"
'SQL = SQL &  " FROM CARGAS_ACADEMICAS CA, SECCIONES S, CARRERAS C, ASIGNATURAS A, MALLA_CURRICULAR MC"
'SQL = SQL &  " WHERE CA.SECC_CCOD=S.SECC_CCOD"
'SQL = SQL &  "   AND S.CARR_CCOD=C.CARR_CCOD"
'SQL = SQL &  "   AND S.ASIG_CCOD=A.ASIG_CCOD"
'SQL = SQL &  "   AND PERI_CCOD = '" & q_peri_ccod & "'"
'SQL = SQL &  "   AND SEDE_CCOD = '" & q_sede_ccod & "'"
'SQL = SQL &  "   AND S.CARR_CCOD = nvl('" & q_carr_ccod & "', S.CARR_CCOD)"
'SQL = SQL &  "   AND S.MALL_CCOD = MC.MALL_CCOD (+)"
'SQL = SQL &  "   AND EXISTS (SELECT 1 FROM ALUMNOS AL WHERE AL.MATR_NCORR=CA.MATR_NCORR AND EMAT_CCOD=1)"
'SQL = SQL &  "   AND EXISTS (SELECT 1 FROM BLOQUES_HORARIOS BH WHERE  BH.SECC_CCOD=S.SECC_CCOD AND EXISTS (SELECT 1 FROM BLOQUES_PROFESORES BP WHERE BP.BLOQ_CCOD=BH.BLOQ_CCOD))"
'SQL = SQL &  " GROUP BY CARR_TDESC,ASIG_TDESC,SECC_TDESC,S.JORN_CCOD, MC.NIVE_CCOD"
'SQL = SQL &  " ORDER BY CARR_TDESC,INSCRITOS"

SQL = " SELECT CARR_TDESC CARRERA,ASIG_TDESC ASIGNATURA,SECC_TDESC SECCION, CASE S.JORN_CCOD WHEN 1 THEN 'D' WHEN 2 THEN 'V' ELSE '' END as JORNADA, " & vbCrLf &_
      "        MC.NIVE_CCOD, COUNT(*) as INSCRITOS, S.SECC_CCOD,a.asig_ccod,s.secc_ncupo " & vbCrLf &_
      " FROM CARGAS_ACADEMICAS CA, SECCIONES S, CARRERAS C, ASIGNATURAS A, MALLA_CURRICULAR MC " & vbCrLf &_
      " WHERE CA.SECC_CCOD=S.SECC_CCOD " & vbCrLf &_
      "   AND S.CARR_CCOD=C.CARR_CCOD " & vbCrLf &_
      "   AND S.ASIG_CCOD=A.ASIG_CCOD " & vbCrLf &_
      "   AND cast(PERI_CCOD as varchar)= '" & q_peri_ccod & "' " & vbCrLf &_
      "   AND cast(SEDE_CCOD as varchar)= '" & q_sede_ccod & "' " & vbCrLf &_
      "   AND cast(S.CARR_CCOD as varchar)=  case '" & q_carr_ccod & "' when '' then S.CARR_CCOD else '" & q_carr_ccod & "' end " & vbCrLf &_
      "   AND S.MALL_CCOD *= MC.MALL_CCOD " & vbCrLf &_
      "   AND EXISTS (SELECT 1 FROM ALUMNOS AL WHERE AL.MATR_NCORR=CA.MATR_NCORR AND EMAT_CCOD=1) " & vbCrLf &_
      "   AND EXISTS (SELECT 1 FROM BLOQUES_HORARIOS BH WHERE  BH.SECC_CCOD=S.SECC_CCOD) " & vbCrLf &_
      " GROUP BY CARR_TDESC,ASIG_TDESC,SECC_TDESC,S.JORN_CCOD, MC.NIVE_CCOD,S.SECC_CCOD,A.ASIG_CCOD,S.SECC_NCUPO" & vbCrLf &_
      " ORDER BY CARR_TDESC,INSCRITOS"


f_consulta.Consultar SQL
%>


<html>
<head>
</head>
<body>
<table width="98%"  border="1">
  <tr>
    <td><div align="center"><strong>Carrera</strong></div></td>
	<td><div align="center"><strong>Cod. Asig</strong></div></td>
    <td><div align="center"><strong>Asignatura</strong></div></td>
    <td><div align="center"><strong>Secci&oacute;n</strong></div></td>
	<td><div align="center"><strong>Cupo</strong></div></td>
	<td><div align="center"><strong>Jornada</strong></div></td>
    <td><div align="center"><strong>Nivel</strong></div></td>
    <td><div align="center"><strong>Inscritos</strong></div></td>
  </tr>
  <%while f_consulta.Siguiente%>
  <tr>  
    <td><%=f_consulta.ObtenerValor("carrera")%></td>
    <td><%=f_consulta.ObtenerValor("asig_ccod")%></td>
    <td><%=f_consulta.ObtenerValor("asignatura")%></td>
    <td>&nbsp;<%=f_consulta.ObtenerValor("seccion")%></td>
	 <td><%=f_consulta.ObtenerValor("secc_ncupo")%></td>
    <td><%=f_consulta.ObtenerValor("jornada")%></td>
    <td><%=f_consulta.ObtenerValor("nive_ccod")%></td>
	<td><%=f_consulta.ObtenerValor("inscritos")%></td>
  </tr>
  <%wend%>
</table>
</body>
</html>

