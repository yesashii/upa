<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=LISTA_ASIGNATURA.xls"
Response.ContentType = "application/vnd.ms-excel"

'----------------------------------------------------------------------------------
q_secc_ccod = Request.QueryString("secc_ccod")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Listado de Alumnos"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


'---------------------------------------------------------------------------------------------------

set f_encabezado_lista = new CFormulario
f_encabezado_lista.Carga_Parametros "enca_lista_excel.xml", "movimiento_caja"
f_encabezado_lista.Inicializar conexion

consulta ="SELECT A.ASIG_CCOD,ASIG_TDESC,CARR_TDESC,SECC_TDESC,protic.PROFESORES_SECCION_CON_RUT(s.secc_ccod)as DOCENTE"& vbCrLf &_
			"FROM SECCIONES S, ASIGNATURAS A, CARRERAS C"& vbCrLf &_
			"WHERE S.ASIG_CCOD=A.ASIG_CCOD AND S.CARR_CCOD=C.CARR_CCOD"& vbCrLf &_
			"AND cast(SECC_CCOD as varchar)='" & q_secc_ccod & "'"

f_encabezado_lista.Consultar consulta


'-----------------------------------------------------------------------------------------------
set f_listado = new CFormulario
f_listado.Carga_Parametros "consulta.xml", "consulta" 'carga el xml
f_listado.Inicializar conexion 'inicializo conexion

consulta = 	" select protic.obtener_rut(a.pers_ncorr) as rut, cast(PERS_TAPE_PATERNO as varchar) as ap_paterno,cast(PERS_TAPE_MATERNO as varchar) as ap_materno, cast(PERS_TNOMBRE as varchar)as nombre, "& vbCrLf &_
			" protic.obtener_nombre_carrera(a.ofer_ncorr,'C') as carrera, "& vbCrLf &_
            " (select top 1 lower(email_nuevo) from cuentas_email_upa tt where tt.pers_ncorr=a.pers_ncorr order by fecha_creacion desc) as email "& vbCrLf &_
			" from cargas_academicas ca, alumnos a,personas p"& vbCrLf &_
			" where ca.matr_ncorr=a.MATR_NCORR and a.pers_ncorr=p.pers_ncorr and cast(secc_ccod as varchar)='" & q_secc_ccod & "'"& vbCrLf &_
			" ORDER BY PERS_TAPE_PATERNO,PERS_TAPE_MATERNO,PERS_TNOMBRE"

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
<%
f_encabezado_lista.DibujaRegistro
%>
<br>
<table width="100%" border="1" cellpadding="0" cellspacing="0">
  <tr>
    <td><div align="center"><strong>NUM</strong></div></td>
	<td><div align="center"><strong>RUT</strong></div></td>
    <td><div align="center"><strong>A.PATERNO</strong></div></td>
	<td><div align="center"><strong>A.MATERNO</strong></div></td>
	<td><div align="center"><strong>NOMBRES</strong></div></td>
	<td><div align="center"><strong>CARRERAS</strong></div></td>
	<td><div align="center"><strong>EMAIL</strong></div></td>
    <td width="5"><div align="center"><strong>NOTA1</strong></div></td>
    <td width="5"><div align="center"><strong>NOTA2</strong></div></td>
    <td width="5"><div align="center"><strong>NOTA3</strong></div></td>
    <td width="5"><div align="center"><strong>NOTA4</strong></div></td>
    <td width="5"><div align="center"><strong>NOTA5</strong></div></td>
  </tr>
  <%NUMERO=1%>
  <%while f_listado.Siguiente%> <!-- mientras hay registro hace-->
  <tr>
    <td><%=NUMERO%> </td>
	<td><%=f_listado.ObtenerValor("RUT")%></td>
    <td><%=f_listado.ObtenerValor("ap_paterno")%></td>
	<td><%=f_listado.ObtenerValor("ap_materno")%></td>
	<td><%=f_listado.ObtenerValor("nombre")%></td>
	<td><%=f_listado.ObtenerValor("carrera")%></td>
	<td><%=f_listado.ObtenerValor("EMAIL")%></td>
    <td> </td>
    <td> </td>
    <td> </td>
    <td> </td>
    <td> </td>
   </tr>
   <%NUMERO=NUMERO+1%>
  <%wend%>
</table>
</body>
</html>
