<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=docentes_facultades.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
facultad=request.QueryString("facu_ccod")
'------------------------------------------------------------------------------------
if facultad<>"" and facultad<>"-1" then
  nombre_facultad=conexion.consultaUno("select facu_tdesc from facultades where cast(facu_ccod as varchar)='"&facultad&"'")
end if
fecha_01=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------

set f_docentes = new CFormulario
f_docentes.Carga_Parametros "docentes_facultades.xml", "f_docentes"
f_docentes.Inicializar conexion
		   
consulta =  " select  a.*, Doctor + Magister + Licenciado + Sin_grado as Totales from (select c.carr_tdesc as carrera, " & vbCrLf &_
			" (select count(distinct a1.pers_ncorr) " & vbCrLf &_
			"  from carreras_docente a1,profesores c1,grados_profesor b1 " & vbCrLf &_
			"  where a1.carr_ccod= c.carr_ccod and a1.pers_ncorr=c1.pers_ncorr " & vbCrLf &_
			"  and c1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=5 and c1.tpro_ccod=1) as Doctor, " & vbCrLf &_
			" (select count(distinct a1.pers_ncorr) " & vbCrLf &_
			"  from carreras_docente a1,profesores c1,grados_profesor b1 " & vbCrLf &_
			"  where a1.carr_ccod= c.carr_ccod and a1.pers_ncorr=c1.pers_ncorr " & vbCrLf &_
			"  and c1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=4 and c1.tpro_ccod=1" & vbCrLf &_
			"  and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod=5)) as Magister," & vbCrLf &_
			" (select count(distinct a1.pers_ncorr) " & vbCrLf &_
			"  from carreras_docente a1,profesores c1,grados_profesor b1 " & vbCrLf &_
			"  where a1.carr_ccod= c.carr_ccod and a1.pers_ncorr=c1.pers_ncorr " & vbCrLf &_
			"  and c1.pers_ncorr=b1.pers_ncorr and b1.grac_ccod=3 and c1.tpro_ccod=1" & vbCrLf &_
			"  and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod in (5,4))) as Licenciado, " & vbCrLf &_
			" (select count(distinct a1.pers_ncorr) " & vbCrLf &_
			"  from carreras_docente a1,profesores c1,grados_profesor b1 " & vbCrLf &_
			"  where a1.carr_ccod= c.carr_ccod and a1.pers_ncorr=c1.pers_ncorr " & vbCrLf &_
			"  and c1.pers_ncorr=b1.pers_ncorr and c1.tpro_ccod=1" & vbCrLf &_
			"  and not exists(select 1 from grados_profesor r where a1.pers_ncorr=r.pers_ncorr and r.grac_ccod in (5,4,3))) as Sin_grado" & vbCrLf &_
			" from areas_academicas b,carreras c " & vbCrLf &_
			" where cast(b.facu_ccod  as varchar)='"&facultad&"' and c.tcar_ccod=1" & vbCrLf &_
			" and b.area_ccod=c.area_ccod ) a " & vbCrLf &_
			" order by carrera "

f_docentes.Consultar consulta
%>
<html>
<head>
<title> Listado docentes</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Disposici&oacute;n de Docentes por Facultad</font></div>
	  <div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Facultad</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=nombre_facultad %></td>
    
  </tr>
  <tr> 
    <td><strong>Fecha</strong></td>
    <td colspan="3"><strong>:</strong> <%=fecha_01%></td>
  </tr>
  
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="35%"><div align="left"><strong>Carrera</strong></div></td>
    <td width="10%"><div align="center"><strong>Doctor</strong></div></td>
    <td width="10%"><div align="center"><strong>Magister</strong></div></td>
	<td width="10%"><div align="center"><strong>Licenciado</strong></div></td>
	<td width="10%"><div align="center"><strong>Sin Grados</strong></div></td>
    <td width="10%"><div align="center"><strong>Totales</strong></div></td>
  </tr>
  <%  
    total_doctor=0
	total_magister=0
	total_licenciado=0
	total_singrado=0
	total_general=0
    while f_docentes.Siguiente %>
  <tr> 
    <td><div align="left"><%=f_docentes.ObtenerValor("carrera")%></div></td>
    <td><div align="center"><%=f_docentes.ObtenerValor("doctor")%></div></td>
    <td><div align="center"><%=f_docentes.ObtenerValor("magister")%></div></td>
    <td><div align="center"><%=f_docentes.ObtenerValor("licenciado")%></div></td>
	<td><div align="center"><%=f_docentes.ObtenerValor("sin_grado")%></div></td>
    <td><div align="center"><strong><%=f_docentes.ObtenerValor("totales")%></strong></div></td>
  </tr>
  <% total_doctor= total_doctor +  f_docentes.ObtenerValor("doctor")
     total_magister= total_magister +  f_docentes.ObtenerValor("magister")
	 total_licenciado= total_licenciado +  f_docentes.ObtenerValor("licenciado")
	 total_singrado= total_singrado +  f_docentes.ObtenerValor("sin_grado")
	 total_general= total_general +  f_docentes.ObtenerValor("totales")
    wend %>
  <tr> 
    <td><div align="right"><strong>Totales</strong></div></td>
    <td><div align="center"><strong><%=total_doctor%></strong></div></td>
    <td><div align="center"><strong><%=total_magister%></strong></div></td>
    <td><div align="center"><strong><%=total_licenciado%></strong></div></td>
	<td><div align="center"><strong><%=total_singrado%></strong></div></td>
    <td><div align="center"><strong><%=total_general%></strong></div></td>
  </tr>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>