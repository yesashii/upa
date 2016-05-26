<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=asignaturas_sin_docentes.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
v_peri_ccod=negocio.obtenerPeriodoAcademico("Postulacion")
'-----------------------------------------------------------------------
sede=request.Form("a[0][sede_ccod]")
carrera=request.Form("a[0][carr_ccod]")
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
fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
set f_asignaturas = new CFormulario
f_asignaturas.Carga_Parametros "asignaturas_docentes.xml", "listado_asignaturas"
f_asignaturas.inicializar conexion

sql=" select distinct b.asig_ccod, b.asig_tdesc, e.dias_tdesc as dia,f.sala_tdesc,c.hora_ccod as bloque "& vbCrLf &_
	" from secciones a, asignaturas b, bloques_horarios c,dias_semana e,salas f "& vbCrLf &_
	" where a.asig_ccod=b.asig_ccod "& vbCrLf &_
	" and a.secc_ccod=c.secc_ccod "& vbCrLf &_
	" and not exists (select 1 from bloques_profesores d where c.bloq_ccod=d.bloq_ccod) "& vbCrLf &_
	" and c.dias_ccod=e.dias_ccod "& vbCrLf &_
	" and c.sala_ccod=f.sala_ccod "& vbCrLf &_
	" and cast(a.peri_ccod as varchar)='"&v_peri_ccod&"' "& vbCrLf &_
	" and cast(a.sede_ccod as varchar)='"&sede&"'" & vbCrLf &_
	" and cast(a.carr_ccod as varchar)='"&carrera&"'"

f_asignaturas.consultar sql	
%>
<html>
<head>
<title> DListado Convalidaciones</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado Asignaturas sin Docente asignado</font></div>
	  <div align="right"></div></td>
    
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
    <td><strong>Fecha</strong></td>
    <td colspan="3"><strong>:</strong> <%=fecha%></td>
  </tr>
  
  
 
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="3%"><div align="center"><strong>N°</strong></div></td>
    <td width="5%"><div align="center"><strong>Cod. Asig.</strong></div></td>
    <td width="15%"><div align="center"><strong>Asignatura</strong></div></td>
    <td width="5%"><div align="center"><strong>Día</strong></div></td>
	<td width="10%"><div align="center"><strong>Sala</strong></div></td>
    <td width="5%"><div align="center"><strong>Bloque</strong></div></td>
  </tr>
  <% fila=1
      while f_asignaturas.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
    <td><div align="center"><%=f_asignaturas.ObtenerValor("asig_ccod")%></div></td>
    <td><div align="center"><%=f_asignaturas.ObtenerValor("asig_tdesc")%></div></td>
    <td><div align="center"><%=f_asignaturas.ObtenerValor("dia")%></div></td>
    <td><div align="left"><%=f_asignaturas.ObtenerValor("sala_tdesc")%></div></td>
    <td><div align="center"><%=f_asignaturas.ObtenerValor("bloque")%></div></td>
  </tr>
  <%fila=fila + 1
    wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>