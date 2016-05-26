<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=convalidaciones.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
usuario=negocio.obtenerUsuario
pers_ncorr_encargado=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")
v_peri_ccod=negocio.obtenerPeriodoAcademico("Postulacion")
'-----------------------------------------------------------------------
sede=request.Form("sede")
carrera=request.Form("carrera")
jornada=request.Form("jornada")
rut=request.Form("rut")
'------------------------------------------------------------------------------------
if sede<>"" and sede<>"-1" then
  nombre_sede=conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede&"'")
else
  nombre_sede="Todas las sedes"  
end if
if carrera<>"" and carrera<>"-1" then
  nombre_carrera=conexion.consultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar)='"&carrera&"'")
else
  nombre_carrera="Todas las carreras inpartidas en la sede"  
end if
if jornada<>"" and jornada<>"-1" then
  nombre_jornada=conexion.consultaUno("select jorn_tdesc from jornadas where cast(jorn_ccod as varchar)='"&jornada&"'")
else
  nombre_jornada="Ambas jornadas (Diurna - Vespertina)"  
end if



fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------

set f_convalidaciones = new CFormulario
f_convalidaciones.Carga_Parametros "listado_convalidaciones.xml", "convalidaciones2"
f_convalidaciones.Inicializar conexion
		   
consulta = "select protic.format_rut(a.pers_nrut) as rut,a.pers_tnombre + ' ' + a.pers_tape_paterno + ' ' + a.pers_tape_materno  as nombre_completo," & vbCrLf &_
		   " b.carr_tdesc as carrera," & vbCrLf &_
		   " c.carcon_ncantidad_asig as cantidad,c.carcon_total as total, isnull(protic.ano_ingreso_carrera(a.pers_ncorr,b.carr_ccod),protic.ano_ingreso_universidad(a.pers_ncorr)) as ano_ingreso" & vbCrLf &_
		   " from personas_postulante a,carreras b,cargos_convalidacion c,postulantes d,ofertas_academicas e,especialidades f" & vbCrLf &_
		   " where c.post_ncorr=d.post_ncorr" & vbCrLf &_
		   " and d.pers_ncorr=a.pers_ncorr" & vbCrLf &_
           " and c.ofer_ncorr =e.ofer_ncorr" & vbCrLf &_
           " and e.espe_ccod = f.espe_ccod" & vbCrLf &_
		   " and f.espe_ccod in(Select espe_ccod from sis_especialidades_usuario where cast(pers_ncorr as varchar)='"&pers_ncorr_encargado&"')"& vbCrLf &_
           " and f.carr_ccod=b.carr_ccod" 
 if sede<>"" and sede<>"-1" then
 	consulta=consulta & " and cast(e.sede_ccod as varchar)='"&sede&"'" 
 end if
 if jornada<>"" and jornada<>"-1" then	
    consulta=consulta & " and cast(e.jorn_ccod as varchar)='"&jornada&"'"
 end if
 if carrera<>"" and carrera<>"-1" then
    consulta=consulta & " and cast(f.carr_ccod as varchar)='"&carrera&"'"
 end if		   
if rut<>""  then
	consulta= consulta & " and cast(a.pers_nrut as varchar)='"&rut&"'"
end if
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_convalidaciones.Consultar consulta
%>
<html>
<head>
<title> DListado Convalidaciones</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado Convalidaciones</font></div>
	<div align="right"><%=fecha%></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Sede</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <% =nombre_sede%> </td>
    
  </tr>
  <tr> 
    <td><strong>Carrera</strong></td>
    <td colspan="3"><strong>:</strong> <%=nombre_carrera %> </td>
  </tr>
  <tr>
    <td><strong>Jornada</strong></td>
    <td colspan="3"> <strong>:</strong><%=nombre_jornada%></td>
 </tr>
 
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="5%"><div align="center"><strong>Rut</strong></div></td>
    <td width="15%"><div align="center"><strong>Nombre</strong></div></td>
    <td width="15%"><div align="center"><strong>Carrera</strong></div></td>
	<td width="15%"><div align="center"><strong>Año de Ingreso</strong></div></td>
	<td width="5%"><div align="center"><strong>Cantidad Asig.</strong></div></td>
    <td width="5%"><div align="center"><strong>Total</strong></div></td>
  </tr>
  <%  while f_convalidaciones.Siguiente %>
  <tr> 
    <td><div align="center"><%=f_convalidaciones.ObtenerValor("rut")%></div></td>
    <td><div align="center"><%=f_convalidaciones.ObtenerValor("nombre_completo")%></div></td>
    <td><div align="center"><%=f_convalidaciones.ObtenerValor("carrera")%></div></td>
	 <td><div align="center"><%=f_convalidaciones.ObtenerValor("ano_ingreso")%></div></td>
    <td><div align="left"><%=f_convalidaciones.ObtenerValor("cantidad")%></div></td>
    <td><div align="center"><%=f_convalidaciones.ObtenerValor("total")%></div></td>
  </tr>
  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>