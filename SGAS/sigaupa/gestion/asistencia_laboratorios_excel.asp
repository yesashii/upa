<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=asistencia_laboratorios.xls"
Response.ContentType = "application/vnd.ms-excel"

inicio = request.querystring("inicio")
termino = request.querystring("termino")


'------------------------------------------------------------------------------------
set pagina = new CPagina
'------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'------------------------------------------------------------------------------------
set lista = new CFormulario
lista.carga_parametros "tabla_vacia.xml", "tabla"
lista.Inicializar conexion

consulta_alumnos =  "  select cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut,pers_tape_paterno + ' ' + pers_tape_materno + ', ' + pers_tnombre as alumno, "& vbCrLf &_
					"  c.sede_tdesc as sede,e.carr_tdesc as carrera,f.jorn_tdesc as jornada, protic.trunc(fecha_asistencia) as fecha,fecha_asistencia, "& vbCrLf &_
				    "  cast(datepart(hour,fecha_asistencia) as varchar) + ':' + case when datepart(minute,fecha_asistencia) <=9 then '0' else '' end + cast(datepart(minute,fecha_asistencia) as varchar) as hora " & vbCrlf &_
					"  from asistencia_laboratorios a, personas b,ofertas_academicas oa,sedes c, especialidades d, carreras e, jornadas f "& vbCrLf &_
					"  where a.pers_ncorr=b.pers_ncorr "

if inicio <> "" then				
				    consulta_alumnos = consulta_alumnos & "  and convert(varchar,fecha_asistencia,103)>=convert(datetime,'"&inicio&"',103) "
end if
if termino <> "" then				
				    consulta_alumnos = consulta_alumnos & "  and convert(varchar,fecha_asistencia,103)<=convert(datetime,'"&termino&"',103) "
end if					
					consulta_alumnos = consulta_alumnos & "  and oa.ofer_ncorr = protic.ultima_oferta_matriculado(a.pers_ncorr) "& vbCrLf &_
					"  and oa.sede_ccod=c.sede_ccod "& vbCrLf &_
					"  and oa.espe_ccod=d.espe_ccod and d.carr_ccod = e.carr_ccod "& vbCrLf &_
					"  and oa.jorn_ccod=f.jorn_ccod "

'response.Write("<pre>"&consulta_alumnos&"</pre>")					
'response.End()
if inicio = "" and termino = "" then
   consulta_alumnos = "select '' as fecha_asistencia, '' as alumno,* from personas where 1=2"
end if

lista.Consultar consulta_alumnos & "  order by fecha_asistencia asc,alumno asc"
lista.siguiente

'------------------------------------------------------------------------------------------------------
'response.Write("<pre>"&consulta_alumnos&"</pre>")
'cantidad_alumnos = conexion.consultaUno("select count(*) from ("&consulta_alumnos&")tabla_a")
%>
<html>
<head>
<title>Asistencia a Laboratorios de Computación.</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="75%" border="1">
<tr>
	<td align="center" width="100%" colspan="8"><font size="+2">Asistencia a Laboratorios de computación</font>
	</td>
</tr>
<tr>
	<td align="center" width="100%" colspan="8"><font size="+2">&nbsp;</font>
	</td>
</tr>
<tr>
	<td align="center" width="100%" colspan="8"><font size="+2">&nbsp;</font>
	</td>
</tr>
<tr> 
    <td width="2%" bgcolor="#FFFFCC"><div align="center"><strong>N°</strong></div></td>
	<td width="5%"  bgcolor="#FFFFCC"><div align="center"><strong>Rut</strong></div></td>
    <td width="15%"  bgcolor="#FFFFCC"><div align="center"><strong>Nombre Alumno</strong></div></td>
	<td width="15%"  bgcolor="#FFFFCC"><div align="center"><strong>Sede</strong></div></td>
    <td width="5%"  bgcolor="#FFFFCC"><div align="center"><strong>Carrera</strong></div></td>
    <td width="5%"  bgcolor="#FFFFCC"><div align="center"><strong>Jornada</strong></div></td>
    <td width="25%"  bgcolor="#FFFFCC"><div align="center"><strong>Fecha</strong></div></td>
	<td width="5%"  bgcolor="#FFFFCC"><div align="center"><strong>Hora</strong></div></td>
  </tr>
  <% fila = 1  
    while lista.Siguiente %>
  <tr> 
   <td><div align="left"><%=fila%></div></td>
   <td><div align="left"><%=lista.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=lista.ObtenerValor("alumno")%></div></td>
	<td><div align="left"><%=lista.ObtenerValor("sede")%></div></td>
    <td><div align="left"><%=lista.ObtenerValor("carrera")%></div></td>
    <td><div align="left"><%=lista.ObtenerValor("jornada")%></div></td>
    <td><div align="center"><%=lista.ObtenerValor("fecha")%></div></td>
	<td><div align="center"><%=lista.ObtenerValor("hora")%></div></td>
  </tr>
  <% fila= fila + 1 
    wend %>
</table>
</body>
</html>