<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=LISTADO_NOTAS.xls"
Response.ContentType = "application/vnd.ms-excel"

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

 
'---------------------------------------------------------------------------------------------------

set f_encabezado_lista = new CFormulario
f_encabezado_lista.Carga_Parametros "enca_lista_excel.xml", "movimiento_caja"
f_encabezado_lista.Inicializar conexion

consulta ="SELECT ltrim(rtrim(A.ASIG_CCOD)) as ASIG_CCOD,ASIG_TDESC,CARR_TDESC,SECC_TDESC"& vbCrLf &_
			"FROM SECCIONES S, ASIGNATURAS A, CARRERAS C"& vbCrLf &_
			"WHERE S.ASIG_CCOD=A.ASIG_CCOD AND S.CARR_CCOD=C.CARR_CCOD"& vbCrLf &_
			"AND cast(SECC_CCOD as varchar)='" & q_secc_ccod & "'"

f_encabezado_lista.Consultar consulta

consulta1="select isnull(max(CALI_NEVALUACION),1) as maximo"& vbCrLf &_
"from calificaciones_seccion cs"& vbCrLf &_
"where cast(cs.secc_ccod as varchar)='" & q_secc_ccod & "'"

max=conexion.consultauno(consulta1)

'-----------------------------------------------------------------------------------------------
set f_listado = new CFormulario
f_listado.Carga_Parametros "consulta.xml", "consulta" 'carga el xml
f_listado.Inicializar conexion 'inicializo conexion


consulta="select rut,nombre_alumno,"
for i=1 to cint(max)
consulta=consulta&"cast(cast(max(case when CALI_NEVALUACION ="&i&" then nota else null end) as decimal(2,1)) as varchar) NOTA_"&i&", "
next 
consulta=consulta&"	cast(cast(max(case when CALI_NEVALUACION =2 then nota else null end) as decimal(2,1)) as varchar) NOTA_2,"& vbCrLf &_
		" cast(cast(max(case when CALI_NEVALUACION =3 then nota else null end) as decimal(2,1)) as varchar) NOTA_3,"& vbCrLf &_		
        " cast(cast(MAX(NP) as decimal(2,1)) as varchar) as NP,"& vbCrLf &_
        " cast(cast(MAX(NEO) as decimal(2,1)) as varchar) AS NEO,"& vbCrLf &_
        " cast(cast(MAX(NEE) as decimal(2,1)) as varchar) AS NEE,"& vbCrLf &_
        " cast(cast(MAX(NF) as decimal(2,1)) as varchar) AS NF,"& vbCrLf &_
        " cast(MAX(ASIS) as numeric(3)) AS ASIS,ESTADO"& vbCrLf &_
"from (select protic.obtener_rut(pers_ncorr) rut,protic.obtener_nombre_completo(pers_ncorr,'PMN') nombre_alumno, "& vbCrLf &_
"	  isnull(cas.CARG_NNOTA_PRESENTACION, protic.nota_presentacion(cas.matr_ncorr,ca.secc_ccod))  NP,"& vbCrLf &_
"	  cas.CARG_NNOTA_EXAMEN NEO, "& vbCrLf &_
"     cas.CARG_NNOTA_REPETICION NEE, "& vbCrLf &_
"     cas.CARG_NNOTA_FINAL NF, "& vbCrLf &_
"     cas.CARG_NASISTENCIA ASIS,"& vbCrLf &_
"	  cas.SITF_CCOD ESTADO, "& vbCrLf &_
"	  ca.secc_ccod,"& vbCrLf &_	  
"	  CALI_NEVALUACION,CALI_NPONDERACION,"& vbCrLf &_
"	  max(CALA_NNOTA) nota"& vbCrLf &_
"      from calificaciones_alumnos ca,"& vbCrLf &_
"      calificaciones_seccion cs,"& vbCrLf &_
"	  cargas_academicas cas,"& vbCrLf &_
"      alumnos a"& vbCrLf &_
"      where "& vbCrLf &_
"      a.matr_ncorr=ca.matr_ncorr"& vbCrLf &_
"	  and cas.matr_ncorr=ca.matr_ncorr"& vbCrLf &_
"	  and cas.secc_ccod=ca.secc_ccod"& vbCrLf &_
"      and cs.cali_ncorr *= ca.cali_ncorr"& vbCrLf &_
"      and cs.secc_ccod *= ca.secc_ccod"& vbCrLf &_
"      --and EMAT_CCOD in (1,2) "& vbCrLf &_
"      and cast(cs.secc_ccod as varchar)='" & q_secc_ccod & "'"& vbCrLf &_
"      group by pers_ncorr, "& vbCrLf &_
"	   cas.CARG_NNOTA_PRESENTACION, "& vbCrLf &_
"	   cas.CARG_NNOTA_EXAMEN , "& vbCrLf &_
"      cas.CARG_NNOTA_REPETICION , "& vbCrLf &_
"      cas.CARG_NNOTA_FINAL , "& vbCrLf &_
"      cas.CARG_NASISTENCIA ,"& vbCrLf &_
"	   cas.SITF_CCOD, "& vbCrLf &_
"		ca.secc_ccod,cas.matr_ncorr,CALI_NEVALUACION,CALI_NPONDERACION"& vbCrLf &_
"      )t"& vbCrLf &_
"group by rut,nombre_alumno,secc_ccod,ESTADO order by nombre_alumno"

'response.write("<pre>"&consulta&"</pre>")
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
<p>
<%
f_encabezado_lista.DibujaRegistro
%>
</p>
<table width="100%" border="1" cellpadding="0" cellspacing="0">
  <tr>
    <td><div align="center"><strong>NUM</strong></div></td>
	<td><div align="center"><strong>RUT</strong></div></td>
    <td><div align="center"><strong>NOMBRE DEL ALUMNO</strong></div></td>
	<%
	for i=1 to cint(max)
	response.write("<td width=5><div align=""center""><strong>NOTA"&i&"</strong></div></td>")
	next 
	%>
	<td><div align="center"><strong>ASISTENCIA</strong></div></td>
	<td><div align="center"><strong>N_P</strong></div></td>
	<%if parametro <> "N" then%>
	<td><div align="center"><strong>EX_O</strong></div></td>
	<td><div align="center"><strong>EX_E</strong></div></td>
	<%end if%>
	<td><div align="center"><strong>N_F</strong></div></td>
	<td><div align="center"><strong>ESTADO</strong></div></td>
  </tr>
  <%NUMERO=1%>
  <%while f_listado.Siguiente%> <!-- mientras hay registro hace-->
  <tr>
    <td><%=NUMERO%> </td>
	<td><%=f_listado.ObtenerValor("RUT")%></td>
    <td><%=f_listado.ObtenerValor("nombre_alumno")%></td>
	<%
	for i=1 to cint(max)
	response.write("<td aling='center'>")
	d="NOTA_"&i
	if esVacio(f_listado.ObtenerValor("NOTA_"&i)) then
		response.Write("<font color='#FF0000'>SP</font>")
	else
		response.write(f_listado.ObtenerValor("NOTA_"&i))
	end if	
	response.write("</td>")
	next 
	%>
	<td><%=f_listado.ObtenerValor("ASIS")%></td>
	<td align="center"><%=f_listado.ObtenerValor("NP")%></td>
	<%if parametro <>"N" then%>
	<td align="center"><%=f_listado.ObtenerValor("NEO")%></td>
	<td align="center"><%=f_listado.ObtenerValor("NEE")%></td>
	<%end if%>
	<td align="center"><%=f_listado.ObtenerValor("NF")%></td>
	<td><%=f_listado.ObtenerValor("ESTADO")%></td>
  </tr>
   <%NUMERO=NUMERO+1%>
  <%wend%>
</table>
<table>
   <tr>
   		<td width="1">&nbsp;</td>
   		<td width="32">N_P:</td>
        <td width="927">Nota presentaci&oacute;n</td>
   </tr>
   <tr>
   		<td>&nbsp;</td>
   		<td>SP&nbsp;:</td>
   		<td>Situaci&oacute;n pendiente (Para efectos de cálculo se ha considerado dicha calificaci&oacute;n como un 1.0)</td>
   </tr>
</table>
</body>
</html>
