<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=seguimiento_otec.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 150000

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

DCUR_NCORR = request.querystring("b[0][DCUR_NCORR]")
sede_ccod = request.querystring("b[0][sede_ccod]")
epot_ccod = request.querystring("b[0][epot_ccod]")
f_inicio = request.querystring("b[0][f_inicio]")
f_termino = request.querystring("b[0][f_termino]")

'------------------------------------------------------------------------------------
set tabla = new cformulario
tabla.carga_parametros	"tabla_vacia.xml",	"tabla"
tabla.inicializar		conexion

dcur_tdesc = conexion.consultaUno("select dcur_tdesc from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")
sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede_ccod&"'")
dcur_nsence = conexion.consultaUno("select dcur_nsence from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")
dgso_ncorr = conexion.consultaUno("select dgso_ncorr from datos_generales_secciones_otec where cast(DCUR_NCORR as varchar)='"&DCUR_NCORR&"' and cast(sede_ccod as varchar)='"&sede_ccod&"' and esot_ccod in (1,2)")
periodo_programa = conexion.consultaUno("select 'FECHA INICIO : <strong>'+ protic.trunc(dgso_finicio) + '</strong>    FECHA TERMINO : <strong>' + protic.trunc(dgso_ftermino) + '</strong>' from datos_generales_secciones_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")
epot_tdesc = conexion.consultaUno("select epot_tdesc from estados_postulacion_otec where cast(epot_ccod as varchar)='"&epot_ccod&"'")


consulta= " select cast(a.pers_nrut as varchar)+'-'+a.pers_xdv as rut,a.pers_nrut,a.pers_xdv, " & vbCrlf & _
		  " pers_tnombre +' '+ pers_tape_paterno + ' ' + pers_tape_materno as alumno, " & vbCrlf & _
		  " c.epot_tdesc as estado_postulacion, " & vbCrlf & _
		  " case fpot_ccod when 1 then 'Persona Natural' when 2  then 'Empresa sin Sence' when 3 then 'Empresa con Sence' when 4 then 'Empresa y Otic' end as forma_pago, " & vbCrlf & _
		  " protic.trunc(fecha_postulacion)as fecha_postulacion, a.pers_tfono as fono, a.pers_tcelular as celular, lower(a.pers_temail) as email, " & vbCrlf & _
		  " (select cast(empr_nrut as varchar)+'-'+empr_xdv+': '+ empr_trazon_social " & vbCrlf & _
		  "  from empresas tt where tt.empr_ncorr=empr_ncorr_empresa) as empresa, " & vbCrlf & _
		  " (select empr_tfono " & vbCrlf & _
		  "  from empresas tt where tt.empr_ncorr=empr_ncorr_empresa) as fono_empresa,  " & vbCrlf & _
		  " (select lower(empr_temail_ejecutivo) " & vbCrlf & _
		  "  from empresas tt where tt.empr_ncorr=empr_ncorr_empresa) as email_empresa, " & vbCrlf & _
		  " (select cast(empr_nrut as varchar)+'-'+empr_xdv+': '+ empr_trazon_social " & vbCrlf & _
		  "  from empresas tt where tt.empr_ncorr=empr_ncorr_otic) as otic, " & vbCrlf & _
		  " (select empr_tfono " & vbCrlf & _
		  "  from empresas tt where tt.empr_ncorr=empr_ncorr_otic) as fono_otic,  " & vbCrlf & _
		  " (select lower(empr_temail_ejecutivo) " & vbCrlf & _
		  "  from empresas tt where tt.empr_ncorr=empr_ncorr_otic) as email_otic " & vbCrlf & _ 
		  " from personas a, postulacion_otec b,estados_postulacion_otec c " & vbCrlf & _
		  " where a.pers_ncorr=b.pers_ncorr and b.epot_ccod=c.epot_ccod " & vbCrlf & _
		  " and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'  " 

if epot_ccod <> "" then
		consulta = consulta & " and cast(b.epot_ccod as varchar)='"&epot_ccod&"'"
end if

if f_inicio <> "" then
		consulta = consulta & " and convert(datetime,convert(varchar,fecha_postulacion,103),103) >= convert(datetime,'"&f_inicio&"',103)"
end if

if f_termino <> "" then
		consulta = consulta & " and convert(datetime,convert(varchar,fecha_postulacion,103),103) <= convert(datetime,'"&f_termino&"',103)"
end if

'response.write("<pre>"&consulta&"</pre>")
'response.End()
tabla.consultar consulta 


fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
%>
<html>
<head>
<title>Listado de Postulaciones Otec</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Postulaciones Otec ( <%=epot_tdesc%> )</font></div>
	<div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
       <td colspan="4"><%response.Write("PROGRAMA: <strong>"&dcur_tdesc&"</strong>")%></td>
  </tr>
  <tr>
       <td colspan="4"><%response.Write("SEDE: <strong>"&sede_tdesc&"</strong>")%></td>
  </tr>
  <tr>
      <td colspan="4"><%response.Write("CÓDIGO SENCE: <strong>"&dcur_nsence&"</strong>")%></td>
  </tr>
  <tr>
	  <td><%=periodo_programa%></td>
  </tr>
  <tr>
      <td colspan="4"><%response.Write("FECHA ACTUAL: <strong>"&fecha&"</strong>")%></td>
  </tr>

</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td><div align="center"><strong>Fila</strong></div></td>
    <td><div align="center"><strong>Rut</strong></div></td>
    <td><div align="center"><strong>Alumno</strong></div></td>
	<td><div align="center"><strong>Teléfono</strong></div></td>
	<td><div align="center"><strong>Celular</strong></div></td>
	<td><div align="center"><strong>Email</strong></div></td>
	<td><div align="center"><strong>Estado Postulación</strong></div></td>
    <td><div align="center"><strong>Forma de Pago</strong></div></td>
	<td><div align="center"><strong>fecha de Postulacion</strong></div></td>
	<td><div align="center"><strong>Empresa</strong></div></td>
    <td><div align="center"><strong>Fono Empresa</strong></div></td>
	<td><div align="center"><strong>Email Empresa</strong></div></td>
	<td><div align="center"><strong>Otic</strong></div></td>
    <td><div align="center"><strong>Fono Otic</strong></div></td>
	<td><div align="center"><strong>Email Otic</strong></div></td>
  </tr>
  <%  
  fila=1  
  while tabla.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("alumno")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("fono")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("celular")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("email")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("estado_postulacion")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("forma_pago")%></div></td>
    <td><div align="center"><%=tabla.ObtenerValor("fecha_postulacion")%></div></td>
  	<td><div align="left"><%=tabla.ObtenerValor("empresa")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("fono_empresa")%></div></td>
    <td><div align="center"><%=tabla.ObtenerValor("email_empresa")%></div></td>
	<td><div align="left"><%=tabla.ObtenerValor("otic")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("fono_otic")%></div></td>
    <td><div align="center"><%=tabla.ObtenerValor("email_otic")%></div></td>
  </tr>
  <% fila=fila +1 
   wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>