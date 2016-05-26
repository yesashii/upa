<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=correos_docentes.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_peri_ccod=negocio.obtenerPeriodoAcademico("TOMACARGA")
'-----------------------------------------------------------------------
sede_ccod=request("sede_ccod")
carr_ccod=request("carr_ccod")
jorn_ccod=request("jorn_ccod")

'------------------------------------------------------------------------------------
set tabla = new cformulario
tabla.carga_parametros	"tabla_vacia.xml",	"tabla"
tabla.inicializar		conexion

tablas= " select distinct cast(d.pers_nrut as varchar)+'-'+d.pers_xdv as rut, "& vbCrLf &_
		" d.pers_tape_paterno + ' ' + d.pers_tape_materno + ', ' + d.pers_tnombre as profesor, "& vbCrLf &_
		" d.pers_tfono as fono, d.pers_tcelular as celular, lower(email_nuevo) as email_institucional  "& vbCrLf &_
		" from secciones a, bloques_horarios b, bloques_profesores c, personas d, cuentas_email_upa e "& vbCrLf &_
		" where a.secc_ccod=b.secc_ccod and b.bloq_ccod=c.bloq_ccod and c.tpro_ccod=1 "& vbCrLf &_
		" and c.pers_ncorr=d.pers_ncorr and d.pers_ncorr=e.pers_ncorr "& vbCrLf &_
		" and cast(a.peri_ccod as varchar)='"&v_peri_ccod&"' and cast(a.sede_ccod as varchar)='"&sede_ccod&"' "& vbCrLf &_
		" and a.carr_ccod='"&carr_ccod&"' and cast(a.jorn_ccod as varchar)='"&jorn_ccod&"' "& vbCrLf &_
		" order by profesor "
		

tabla.consultar tablas
fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
sede=conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede_ccod&"'")
carrera=conexion.consultaUno("select carr_tdesc from carreras where carr_ccod='"&carr_ccod&"'")
jornada=conexion.consultaUno("select jorn_tdesc from jornadas where cast(jorn_ccod as varchar)='"&jorn_ccod&"'")
periodo=conexion.consultaUno("select peri_tdesc from periodos_academicos where cast(peri_ccod as varchar)='"&v_peri_ccod&"'")

'------------------------------------------------------------------------------------

%>
<html>
<head>
<title>Cuentas de email profesores</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Cuentas de email profesores</font></div>
	<div align="right"><%=fecha%></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Sede</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=sede%></td>
  </tr>
  <tr> 
    <td><strong>Carrera</strong></td>
    <td colspan="3"><strong>:</strong> <%=carrera%></td>
  </tr>
  <tr>
    <td><strong>Jornada</strong></td>
    <td colspan="3"> <strong>:</strong> <%=jornada%></td>
 </tr>
 <tr>
    <td><strong>Período</strong></td>
    <td colspan="3"> <strong>:</strong> <%=periodo%></td>
 </tr>
 <tr>
    <td><strong>Fecha</strong></td>
    <td colspan="3"> <strong>:</strong> <%=fecha%></td>
 </tr>
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td><div align="center"><strong>Rut</strong></div></td>
    <td><div align="center"><strong>Profesor</strong></div></td>
    <td><div align="center"><strong>Teléfono</strong></div></td>
	<td><div align="center"><strong>Celular</strong></div></td>
	<td><div align="center"><strong>Email institucional</strong></div></td>
  </tr>
  <%  while tabla.Siguiente %>
  <tr> 
    <td><div align="left"><%=tabla.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("profesor")%></div></td>
    <td><div align="center"><%=tabla.ObtenerValor("fono")%></div></td>
    <td><div align="center"><%=tabla.ObtenerValor("celular")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("email_institucional")%></div></td>
  </tr>
  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>