<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=docentes_sin_asignatura.xls"
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
set f_profesores = new CFormulario
f_profesores.Carga_Parametros "asignaturas_docentes.xml", "listado_profesores"
f_profesores.inicializar conexion

'sql2=" select distinct cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut,b.pers_tape_paterno + ' ' +b.pers_tape_materno + ',' + b.pers_tnombre as profesor, " & vbCrLf &_
'	" c.tpro_tdesc as tipo_profesor " & vbCrLf &_
'	" from profesores a,personas b, tipos_profesores c " & vbCrLf &_
'	" where a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
'	" and a.tpro_ccod=c.tpro_ccod " & vbCrLf &_
'	" and not exists (select 1 from bloques_profesores d where a.pers_ncorr=d.pers_ncorr) " & vbCrLf &_
'	" and a.sede_ccod='"&sede&"'"
	
sql2= "  select distinct cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut,b.pers_tape_paterno + ' ' +b.pers_tape_materno + ',' + b.pers_tnombre as profesor, " & vbCrLf &_
	  " c.tpro_tdesc as tipo_profesor " & vbCrLf &_
	  " from profesores a,personas b, tipos_profesores c,carreras_docente d " & vbCrLf &_
	  " where a.pers_ncorr=d.pers_ncorr " & vbCrLf &_
	  " and a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
	  " and a.tpro_ccod=c.tpro_ccod " & vbCrLf &_
	  " and d.sede_ccod='"&sede&"' " & vbCrLf &_
	  " and d.peri_ccod='"&v_peri_ccod&"' " & vbCrLf &_
	  " and d.carr_ccod='"&carrera&"' " & vbCrLf &_
	  " and not exists (select 1 from bloques_profesores f where a.pers_ncorr=f.pers_ncorr) "
	  
f_profesores.consultar sql2	
%>
<html>
<head>
<title> Listado Docentes</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado 
        Docentes sin Asignatura</font></div>
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
    <td width="10%"><div align="center"><strong>RUT.</strong></div></td>
    <td width="35%"><div align="center"><strong>Nombre Docente</strong></div></td>
    <td width="5%"><div align="center"><strong>Tipo</strong></div></td>
 </tr>
  <% fila=1
      while f_profesores.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
    <td><div align="center"><%=f_profesores.ObtenerValor("rut")%></div></td>
    <td><div align="center"><%=f_profesores.ObtenerValor("profesor")%></div></td>
    <td><div align="center"><%=f_profesores.ObtenerValor("tipo_profesor")%></div></td>
  </tr>
  <%fila=fila + 1
    wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>