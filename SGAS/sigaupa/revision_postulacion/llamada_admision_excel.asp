<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=llamadas_admision.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


fecha_01 = conexion.consultaUno("select getDate() ")
'------------------------------------------------------------------------------------

set f_pases = new CFormulario
f_pases.Carga_Parametros "listado_pases.xml", "list_alumnos"
f_pases.Inicializar conexion
		   
consulta=" select cast(a.pers_nrut as varchar) + '-' + a.pers_nxdv as rut,nombre_completo,a.pers_tfono as fono, a.pers_temail as email,observacion,case isnull(postulado_online,0) when 0 then 'NO' else 'SI' end as postulado_online, "& vbCrLf &_ 
		 " b.pers_tnombre + ' ' + b.pers_tape_paterno + ' ' + b.pers_tape_materno as realizado_por, "& vbCrLf &_ 
		 " protic.trunc(a.audi_fmodificacion) as fecha_realizado, "& vbCrLf &_ 
		 " (select case count(*) when 0 then 'NO' else 'SI' end "& vbCrLf &_ 
		 " from personas_postulante tt, postulantes t2, detalle_postulantes t3 "& vbCrLf &_ 
		 " where tt.pers_nrut = a.pers_nrut and tt.pers_ncorr=t2.pers_ncorr and t2.post_ncorr=t3.POST_NCORR "& vbCrLf &_ 
		 " and t2.peri_ccod='222') as postulacion_2011_01, "& vbCrLf &_ 
		 " (select case count(*) when 0 then 'NO' else 'SI' end "& vbCrLf &_ 
		 " from personas_postulante tt, postulantes t2, detalle_postulantes t3, alumnos t4 "& vbCrLf &_ 
		 " where tt.pers_nrut = a.pers_nrut and tt.pers_ncorr=t2.pers_ncorr and t2.post_ncorr=t3.POST_NCORR "& vbCrLf &_ 
		 " and tt.pers_ncorr=t4.pers_ncorr and t2.post_ncorr=t4.post_ncorr and t4.alum_nmatricula <> 7777 "& vbCrLf &_ 
		 " and t4.emat_ccod <> 9 "& vbCrLf &_ 
		 " and t2.peri_ccod='222') as matriculado_2011_01,a.audi_fmodificacion   "& vbCrLf &_ 
		 " from ADMI_LLAMADAS_ADMISION a, personas b "& vbCrLf &_ 
		 " where a.audi_tusuario= cast(b.pers_nrut as varchar) "& vbCrLf &_ 
		 " order by a.audi_fmodificacion "   

f_pases.Consultar consulta 

%>
<html>
<head>
<title>Listado llamados admisión</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado llamados admisión</font></div>
	<div align="right"><%=fecha_01%></div></td>
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
</table>
<p>&nbsp;</p>
<table width="100%" border="1">
  <tr> 
    <td bgcolor="#9966CC"><div align="center"><strong>Rut</strong></div></td>
    <td bgcolor="#9966CC"><div align="center"><strong>Nombre Completo</strong></div></td>
    <td bgcolor="#9966CC"><div align="center"><strong>Teléfono</strong></div></td>
	<td bgcolor="#9966CC"><div align="center"><strong>Email</strong></div></td>
    <td bgcolor="#9966CC"><div align="center"><strong>Observación</strong></div></td>
    <td bgcolor="#9966CC"><div align="center"><strong>¿Marcó Postulado Online?</strong></div></td>
    <td bgcolor="#9966CC"><div align="center"><strong>Realizado Por</strong></div></td>
	<td bgcolor="#9966CC"><div align="center"><strong>Fecha</strong></div></td>
    <td bgcolor="#9966CC"><div align="center"><strong>Postulado 2011</strong></div></td>
	<td bgcolor="#9966CC"><div align="center"><strong>Matriculado 2011</strong></div></td>
  </tr>
  <%  while f_pases.Siguiente %>
  <tr> 
    <td><div align="left"><%=f_pases.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=f_pases.ObtenerValor("nombre_completo")%></div></td>
    <td><div align="left"><%=f_pases.ObtenerValor("fono")%></div></td>
    <td><div align="left"><%=f_pases.ObtenerValor("email")%></div></td>
    <td><div align="left"><%=f_pases.ObtenerValor("observacion")%></div></td>
	<td><div align="left"><%=f_pases.ObtenerValor("postulado_online")%></div></td>
	<td><div align="left"><%=f_pases.ObtenerValor("realizado_por")%></div></td>
	<td><div align="left"><%=f_pases.ObtenerValor("fecha_realizado")%></div></td>
	<td><div align="left"><%=f_pases.ObtenerValor("postulacion_2011_01")%></div></td>
	<td><div align="left"><%=f_pases.ObtenerValor("matriculado_2011_01")%></div></td>	
  </tr>
  <%  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>