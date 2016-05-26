<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'-------------------------------------------------------------------
'for each k in request.querystring
'	response.write(k&"="&request.querystring(k)&"<br>")
'next
'response.End()
'-------------------------------------------------------------------
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=libro_de_clases_excel.xls"
Response.ContentType = "application/vnd.ms-excel"
'-------------------------------------*
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
set errores = new cErrores
'-------------------------------------*

'-------------------------------------*
var_nombrePrograma = request.querystring("programa")
var_codigoSence = request.querystring("dcur_nsence")
var_fechaDeEmision = request.querystring("var_fecha")
dcur_ncorr = request.querystring("dcur_ncorr")
var_contador = 0
'-------------------------------------*

'-------------------------------------------------------------*
set f_alumnos = new CFormulario
f_alumnos.Carga_Parametros "libro_clases_otec.xml", "alumnos"
f_alumnos.Inicializar conexion
'-------------------------------------------------------------*
'************************************************************************'
'*				CONSULTA QUE LLENA LA TABLA DE ALUMNOS(PRUEBA)			*'
'************************************************************************'
consulta = "" & vbCrLf & _
"select distinct cast(c.pers_nrut as varchar) + '-' + c.pers_xdv                         as rut,       " & vbCrLf & _
"                c.pers_tape_paterno + ' ' + c.pers_tape_materno + ', ' + c.pers_tnombre as alumno,    " & vbCrLf & _
"                lower(c.pers_temail)                          							as pers_temail " & vbCrLf & _
"from   personas as c                                                                                  " & vbCrLf & _
"       inner join postulacion_otec as b                                                               " & vbCrLf & _
"               on c.pers_ncorr = b.pers_ncorr                                                         " & vbCrLf & _
"                  and epot_ccod = 4                                                                   " & vbCrLf & _
"       inner join datos_generales_secciones_otec as d                                                 " & vbCrLf & _
"               on b.dgso_ncorr = d.dgso_ncorr                                                         " & vbCrLf & _
"where  cast(d.dcur_ncorr as varchar) = '"&dcur_ncorr&"'                                                          " & vbCrLf & _
"order  by alumno                                                                                      " 
'************************************************************************'
f_alumnos.Consultar consulta
%>

<html>
<head>
</head>
<body>
<strong>Programa : </strong><%response.Write(var_nombrePrograma)%> <br/>
<strong>C&oacute;digo Sence : </strong><%response.Write(var_codigoSence)%> <br/>
<strong>Fecha de emisi&oacute;n : </strong><%response.Write(var_fechaDeEmision)%> <br/>
<hr/>
<br/>

<table width="750" border="1">
<tr>
    <td colspan="4" style="background-color:#09F; color:#FFF;text-align:center"><strong>LISTA DE ALUMNOS<strong></td>
  </tr>
  <tr>
    <td width="30" style="text-align:center;background-color:#06F;color:#FFF">N</td> 
    <td width="131" style="text-align:center;background-color:#06F;color:#FFF">RUT</td>
    <td width="289" style="text-align:center;background-color:#06F;color:#FFF">ALUMNO</td>
    <td width="272" style="text-align:center;background-color:#06F;color:#FFF">CORREO ELECTR&Oacute;NICO</td>	
  </tr>
<% while f_alumnos.Siguiente 
'-------------------------------------
var_contador = var_contador + 1
var_rut = f_alumnos.obtenerValor("rut")
var_nombre = f_alumnos.obtenerValor("alumno")
var_mail = f_alumnos.obtenerValor("pers_temail")
'-------------------------------------
%>
  <tr>
	<td align="center" ><%response.Write(var_contador)%></td>
    <td><%response.Write(var_rut)%></td>
    <td><%response.Write(var_nombre)%></td>
    <td><%response.Write(var_mail)%></td>
  </tr>
<% wend %>
</table>
</body>
</html>