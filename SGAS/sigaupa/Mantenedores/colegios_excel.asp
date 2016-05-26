<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=asignaturas.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

regi_ccod = request.querystring("regi_ccod")
ciud_ccod = request.querystring("ciud_ccod")
sin_ubicacion = request.querystring("sin_ubicacion")
nombre_colegio = request.querystring("nombre_colegio")
Region = conexion.consultauno("SELECT regi_tdesc FROM Regiones WHERE cast(regi_ccod as varchar)='" & regi_ccod&"'" )
Ciudad = conexion.consultauno("SELECT ciud_tcomuna FROM Ciudades WHERE cast(ciud_ccod as varchar)='" & ciud_ccod&"'"  )
Comuna = conexion.consultauno("SELECT ciud_tdesc FROM Ciudades WHERE cast(ciud_ccod as varchar)='" & ciud_ccod&"'"  )

'------------------------------------------------------------------------------------
set tabla = new cformulario
tabla.carga_parametros	"tabla_vacia.xml",	"tabla"
tabla.inicializar		conexion

 if sin_ubicacion ="N" or sin_ubicacion ="" then 
 consulta = " SELECT regi_tdesc,ciud_tdesc,ciud_tcomuna,cole_ccod,cole_ccod as cole_ccod2,cole_tdesc,tcol_tdesc,cole_tlocalidad,cole_trbd, case cole_tarea when 0 then 'Rural' when 1 then 'Urbana' else '' end as cole_tarea, cole_tdireccion,cole_tfono,cole_temail," & vbCrLf &_
 			" (select case count(*) when 0 then 'No' else 'Sí '+ cast(count(*) as varchar)+' persona(s)' end  " & vbCrLf &_
  			" from ( select distinct pers_ncorr from personas_postulante pp where pp.cole_ccod= a.cole_ccod " & vbCrLf &_
			" union  " & vbCrLf &_
			"        select distinct pers_ncorr_alumno from personas_eventos_upa pp where pp.cole_ccod= a.cole_ccod)aa ) as con_personas " & vbCrLf &_
            " FROM colegios a, Tipos_Colegios b,ciudades c,regiones d " & vbCrLf &_
		    " WHERE  cast(c.regi_CCOD as varchar) ='" & regi_ccod & "' and a.ciud_ccod=c.ciud_ccod and c.regi_ccod=d.regi_ccod " & vbCrLf &_
			" and a.tcol_ccod*=b.tcol_ccod and a.cole_tdesc like '%"&nombre_colegio&"%'"& vbCrLf &_
			" ORDER BY ciud_tcomuna,cole_tdesc"
 else
 consulta = " SELECT '' as regi_tdesc,'' as ciud_tdesc,'' as ciud_tcomuna,cole_ccod,cole_ccod as cole_ccod2,cole_tdesc,tcol_tdesc,cole_tlocalidad,cole_trbd, case cole_tarea when 0 then 'Rural' when 1 then 'Urbana' else '' end as cole_tarea, cole_tdireccion,cole_tfono,cole_temail," & vbCrLf &_
            " (select case count(*) when 0 then 'No' else 'Sí '+ cast(count(*) as varchar)+' persona(s)' end  " & vbCrLf &_
  			" from ( select distinct pers_ncorr from personas_postulante pp where pp.cole_ccod= a.cole_ccod " & vbCrLf &_
			" union  " & vbCrLf &_
			"        select distinct pers_ncorr_alumno from personas_eventos_upa pp where pp.cole_ccod= a.cole_ccod)aa ) as con_personas " & vbCrLf &_
            " FROM colegios a, Tipos_Colegios b" & vbCrLf &_
		    " WHERE isnull(cast(ciud_ccod as varchar),'S')='S'" & vbCrLf &_
			" and a.tcol_ccod *= b.tcol_ccod and a.cole_tdesc like '%"&nombre_colegio&"%'"& vbCrLf &_
			" ORDER BY cole_tdesc"
 end if
tabla.consultar consulta 


fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
%>
<html>
<head>
<title>Listado de Asignaturas</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Colegios</font></div>
	<div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Región</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=Region%> </td>
  </tr>
  <tr> 
    <td width="16%"><strong>Ciudad</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <%=Ciudad%> </td>
  </tr>
  <tr> 
    <td><strong>Comuna</strong></td>
    <td colspan="3"><strong>:</strong> <%=Comuna%> </td>
  </tr>
  <tr>
    <td><strong>Fecha</strong></td>
    <td colspan="3"> <strong>:</strong> <%=fecha%></td>
 </tr>
 
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td><div align="center"><strong>Fila</strong></div></td>
	<td><div align="center"><strong>Región</strong></div></td>
	<td><div align="center"><strong>Ciudad</strong></div></td>
	<td><div align="center"><strong>Comuna</strong></div></td>
	<td><div align="center"><strong>Localidad</strong></div></td>
    <td><div align="center"><strong>Código Interno</strong></div></td>
    <td><div align="center"><strong>Establecimiento</strong></div></td>
	<td><div align="center"><strong>Total Asignados</strong></div></td>
	<td><div align="center"><strong>RBD</strong></div></td>
    <td><div align="center"><strong>Dependencia</strong></div></td>
	<td><div align="center"><strong>Área Geográfica</strong></div></td>
	<td><div align="center"><strong>Dirección</strong></div></td>
    <td><div align="center"><strong>Teléfono</strong></div></td>
	<td><div align="center"><strong>e-mail</strong></div></td>
  </tr>
  <%  
  fila=1  
  while tabla.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("regi_tdesc")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("ciud_tcomuna")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("ciud_tdesc")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("cole_tlocalidad")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("cole_ccod")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("cole_tdesc")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("con_personas")%></div></td>
    <td><div align="center"><%=tabla.ObtenerValor("cole_trbd")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("tcol_tdesc")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("cole_tarea")%></div></td>
	<td><div align="center"><%=tabla.ObtenerValor("cole_tdireccion")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("cole_tfono")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("cole_temail")%></div></td>
  </tr>
  <% fila=fila +1 
   wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>