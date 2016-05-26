<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=seguros_escolaridad.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
peri_ccod = negocio.obtenerPeriodoAcademico("POSTULACION")
anos_ccod = conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
 

'------------------------------------------------------------------------------------
set tabla = new cformulario
tabla.carga_parametros	"tabla_vacia.xml",	"tabla"
tabla.inicializar		conexion

consulta ="  select case no_deseo when 'S' then 'NO solicita Seguro' else 'Sí' end  as solicita, "& vbCrlf & _
		  "	 cast(c.pers_nrut as varchar)+'-'+c.pers_xdv as rut, "& vbCrlf & _
		  "	 c.pers_tnombre + ' ' + c.pers_tape_paterno + ' ' + c.pers_tape_materno as alumno, "& vbCrlf & _
		  "	 e.sede_tdesc as sede,h.carr_tdesc as carrera, g.jorn_tdesc as jornada , "& vbCrlf & _
		  "	 protic.ano_ingreso_carrera(c.pers_ncorr,f.carr_ccod) as anio_ingreso, "& vbCrlf & _
		  "	 cast(pp.pers_nrut as varchar)+'-'+pp.pers_xdv as rut_contratante,  "& vbCrlf & _
		  "	 pp.pers_tnombre + ' ' + pp.pers_tape_paterno + ' ' + pp.pers_tape_materno as contratante, "& vbCrlf & _
		  "	 protic.trunc(pp.pers_fnacimiento) as fecha_nacimiento, "& vbCrlf & _
		  "	 protic.trunc(sses_fpostulacion) as fecha_postulacion, "& vbCrlf & _
		  "	 protic.listado_preexistencias(a.post_ncorr,a.pers_ncorr_contratante)  as enfermedades, case rechazado when 'S' then 'Sí' else 'No' end as rechazado"& vbCrlf & _
		  "	  from solicitud_seguro_escolaridad a, postulantes b, personas c, "& vbCrlf & _
		  "	 ofertas_academicas d, sedes e, especialidades f, jornadas g, carreras h, "& vbCrlf & _
		  "	 personas pp,periodos_academicos pa "& vbCrlf & _
		  "	 where a.post_ncorr=b.post_ncorr and b.pers_ncorr=c.pers_ncorr and b.peri_ccod=pa.peri_ccod and cast(pa.anos_ccod as varchar)='"&anos_ccod&"'"& vbCrlf & _
		  "	 and a.ofer_ncorr=d.ofer_ncorr and d.sede_ccod=e.sede_ccod and d.espe_ccod=f.espe_ccod "& vbCrlf & _
		  "	 and d.jorn_ccod=g.jorn_ccod and f.carr_ccod=h.carr_ccod and a.pers_ncorr_contratante=pp.pers_ncorr "& vbCrlf & _
		  "	 order by sede,carrera,jornada "

response.write("<pre>"&consulta&"</pre>")
tabla.consultar consulta 


fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
%>
<html>
<head>
<title>Listado de solicitudes seguro escolaridad</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Solicitud Seguro Escolaridad (<%=anos_ccod%>)</font></div>
	<div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
    <td width="5%"><strong>Fecha</strong></td>
    <td width="95%" colspan="3" align="left"> <strong>:</strong> <%=fecha%></td>
 </tr>
 
</table>

<p>&nbsp;</p>
<table width="100%" border="1">
  <tr> 
    <td width="3%" bgcolor="#FFFFCC"><div align="center"><strong>Fila</strong></div></td>
    <td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Solicita</strong></div></td>
    <td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Rut</strong></div></td>
	<td width="15%" bgcolor="#FFFFCC"><div align="center"><strong>Alumno</strong></div></td>
    <td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Sede</strong></div></td>
	<td width="15%" bgcolor="#FFFFCC"><div align="center"><strong>Carrera</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Jornada</strong></div></td>
    <td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Promoción</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Rut Contratante</strong></div></td>
	<td width="15%" bgcolor="#FFFFCC"><div align="center"><strong>Contratante</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Fecha Nacimiento</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Fecha Postulación</strong></div></td>
	<td width="15%" bgcolor="#FFFFCC"><div align="center"><strong>Preexistencias</strong></div></td>
	<td width="5%" bgcolor="#FFFFCC"><div align="center"><strong>Rechazado</strong></div></td>
  </tr>
  <%  
  fila=1  
  while tabla.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("solicita")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("alumno")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("sede")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("carrera")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("jornada")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("anio_ingreso")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("rut_contratante")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("contratante")%></div></td>
	<td><div align="center"><%=tabla.ObtenerValor("fecha_nacimiento")%></div></td>
	<td><div align="center"><%=tabla.ObtenerValor("fecha_postulacion")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("enfermedades")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("rechazado")%></div></td>
  </tr>
  <% fila=fila +1 
   wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>