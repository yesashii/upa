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

asig_tdesc = request.querystring("asig_tdesc")
asig_ccod  = request.QueryString("asig_ccod")
codigo  = asig_ccod
asignatura = asig_tdesc
if codigo="" then
	codigo=" Todas las asignaturas"
end if	
if asignatura="" then
	asignatura=" Todas las asignaturas"
end if	

'------------------------------------------------------------------------------------
set tabla = new cformulario
tabla.carga_parametros	"tabla_vacia.xml",	"tabla"
tabla.inicializar		conexion
if asig_ccod="" and asig_tdesc ="" then
	asig_ccod =""
	asig_tdesc =""
end if
consulta =" select a.ASIG_CCOD, a.TASG_CCOD, a.EASI_CCOD, a.ASIG_TDESC, a.ASIG_NHORAS,  " & vbCrlf & _
" convert(varchar,asig_fini_vigencia,103) as ASIG_FINI_VIGENCIA, " & vbCrlf & _
" convert(varchar,asig_ffin_vigencia,103) as ASIG_FFIN_VIGENCIA,case a.duas_ccod when 1 then 'Trimestral' when 2 then 'Semestral' when 3 then 'Anual' when 5 then 'Periodo' else '' end as duas_tdesc, " & vbCrlf & _
" a.AUDI_TUSUARIO,a.AUDI_FMODIFICACION, b.easi_tdesc, c.tasg_tdesc,a.asig_nnivel_ayudante, d.clas_tdesc,isnull(e.area_tdesc,'--') as area,isnull(f.cred_tdesc,'--') as credito  " & vbCrlf & _
" from asignaturas a join estado_asignatura b" & vbCrlf & _
"      on a.easi_ccod = b.easi_ccod " & vbCrlf & _
" join tipos_asignatura c" & vbCrlf & _
"      on a.tasg_ccod  = c.tasg_ccod" & vbCrlf & _
" join clases_asignatura d" & vbCrlf & _
"      on isnull(a.clas_ccod,1) = d.clas_ccod" & vbCrlf & _
" left outer join area_asignatura e" & vbCrlf & _
"      on a.area_ccod=e.area_ccod" & vbCrlf & _
" left outer join creditos_asignatura f  " & vbCrlf & _
"      on a.cred_ccod = f.cred_ccod " & vbCrlf & _
" Where (a.asig_ccod like '%"&asig_ccod&"%' or '%"&asig_ccod&"%' is null )"& vbCrlf & _
" and ( a.asig_tdesc like '%"&asig_tdesc&"%' or '%"&asig_tdesc&"%' is null )"

'" nvl(to_char(a.ASIG_FINI_VIGENCIA, 'dd/mm/yyyy'),'- -') AS ASIG_FINI_VIGENCIA,   " & vbCrlf & _
'" nvl(to_char(a.ASIG_FFIN_VIGENCIA, 'dd/mm/yyyy'),'- -') AS ASIG_FFIN_VIGENCIA,  " & vbCrlf & _

'response.write("<pre>"&consulta&"</pre>")
tabla.consultar consulta & " order by asig_tdesc"


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
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Asignaturas</font></div>
	<div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr> 
    <td width="16%"><strong>Cod.Asignatura</strong></td>
    <td width="84%" colspan="3"><strong>:</strong> <% =codigo%> </td>
    
  </tr>
  <tr> 
    <td><strong>Asignatura</strong></td>
    <td colspan="3"><strong>:</strong> <%=asignatura%> </td>
  </tr>
  <tr>
    <td><strong>Fecha</strong></td>
    <td colspan="3"> <strong>:</strong> <%=fecha%></td>
 </tr>
 
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td width="3%"><div align="center"><strong>Fila</strong></div></td>
    <td width="7%"><div align="center"><strong>Código</strong></div></td>
    <td width="25%"><div align="center"><strong>Asignatura</strong></div></td>
	<td width="5%"><div align="center"><strong>Horas</strong></div></td>
    <td width="25%"><div align="center"><strong>Duración</strong></div></td>
	<td width="25%"><div align="center"><strong>Tipo</strong></div></td>
	<td width="25%"><div align="center"><strong>Nivel Ayudante</strong></div></td>
    <td width="10%"><div align="center"><strong>Clasificación</strong></div></td>
	<td width="25%"><div align="center"><strong>Área</strong></div></td>
	<td width="25%"><div align="center"><strong>Créditos</strong></div></td>
  </tr>
  <%  
  fila=1  
  while tabla.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("asig_ccod")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("asig_tdesc")%></div></td>
    <td><div align="center"><%=tabla.ObtenerValor("asig_nhoras")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("duas_tdesc")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("tasg_tdesc")%></div></td>
	<td><div align="center"><%=tabla.ObtenerValor("asig_nnivel_ayudante")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("clas_tdesc")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("area")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("credito")%></div></td>
  </tr>
  <% fila=fila +1 
   wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>