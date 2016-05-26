<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Response.AddHeader "Content-Disposition", "attachment;filename=equivalencias.xls"
Response.ContentType = "application/vnd.ms-excel"

'----------------------------------------------------------------------------------
peri_ccod = Request.QueryString("busqueda[0][peri_ccod]")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "EQUIVALENCIAS MAL REALIZADAS"

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

consulta = 	" select tt.peri_tdesc,sede_tdesc as sede, carr_tdesc as carrera, jorn_tdesc as jornada, "& vbCrLf &_
			" cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, "& vbCrLf &_
			" e.pers_tnombre as nombre, e.pers_tape_paterno + ' ' + e.pers_tape_materno as apellidos, "& vbCrLf &_
			" ltrim(rtrim(c.asig_ccod)) + '  ' + c.asig_tdesc as asignatura_cursada, "& vbCrLf &_
			" ltrim(rtrim(k.asig_ccod)) + '  ' + k.asig_tdesc as asignatura_plan "& vbCrLf &_
			" from equivalencias a, secciones b, asignaturas c,alumnos d, personas e, ofertas_academicas f, sedes g, especialidades h,  "& vbCrLf &_
			" carreras i, jornadas j, asignaturas k,periodos_academicos tt "& vbCrLf &_
			" where a.secc_ccod=b.secc_ccod and b.peri_ccod=tt.peri_Ccod and CAST(tt.peri_Ccod AS VARCHAR)='"&peri_ccod&"' "& vbCrLf &_
			" and b.asig_ccod=c.asig_ccod and a.matr_ncorr=d.matr_ncorr "& vbCrLf &_
			" and d.pers_ncorr=e.pers_ncorr and d.ofer_ncorr = f.ofer_ncorr "& vbCrLf &_
			" and f.sede_ccod=g.sede_ccod and f.espe_ccod=h.espe_ccod "& vbCrLf &_
			" and h.carr_ccod=i.carr_ccod and f.jorn_ccod=j.jorn_ccod "& vbCrLf &_
			" and a.asig_ccod=k.asig_ccod "& vbCrLf &_
			" and c.asig_tdesc <> k.asig_tdesc "& vbCrLf &_
			" order by tt.peri_ccod,sede,carrera, jornada, apellidos "
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
	<td bgcolor="#FF9900"><div align="center"><strong>Período</strong></div></td>
    <td bgcolor="#FF9900"><div align="center"><strong>Sede</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Carrera</strong></div></td>
    <td bgcolor="#FF9900"><div align="center"><strong>Jornada</strong></div></td>
    <td bgcolor="#FF9900"><div align="center"><strong>Rut</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Nombres</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Apellidos</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Asignatura Cursada</strong></div></td>
	<td bgcolor="#FF9900"><div align="center"><strong>Asignatura del plan</strong></div></td>
  </tr>
  <%NUMERO=1%>
  <%while f_listado.Siguiente%> <!-- mientras hay registro hace-->
  <tr>
    <td align="left"><%=NUMERO%> </td>
	<td align="left"><%=f_listado.ObtenerValor("peri_tdesc")%></td>
    <td align="left"><%=f_listado.ObtenerValor("sede")%></td>
	<td align="left"><%=f_listado.ObtenerValor("carrera")%></td>
	<td align="left"><%=f_listado.ObtenerValor("jornada")%></td>
    <td align="left"><%=f_listado.ObtenerValor("rut")%></td>
	<td align="left"><%=f_listado.ObtenerValor("nombre")%></td>
	<td align="left"><%=f_listado.ObtenerValor("apellidos")%></td>
	<td align="left"><%=f_listado.ObtenerValor("asignatura_cursada")%></td>
	<td align="left"><%=f_listado.ObtenerValor("asignatura_plan")%></td>
   </tr>
   <%NUMERO=NUMERO+1%>
  <%wend%>
</table>
</body>
</html>
