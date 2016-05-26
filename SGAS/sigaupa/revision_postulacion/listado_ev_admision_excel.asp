<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=encuesta_admision.xls"
Response.ContentType = "application/vnd.ms-excel"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

periodo=negocio.obtenerPeriodoAcademico("Postulacion")
'-----------------------------------------------------------------------
'------------------------------------------------------------------------------------
set tabla = new cformulario
tabla.carga_parametros	"adm_mallas_curriculares3.xml",	"tabla_conv"
tabla.inicializar		conexion

consulta_encuestas   = " select cast(b.pers_nrut as varchar) + '-' + b.pers_xdv as rut, protic.initCap(pers_tnombre) as nombres, "& vbcrlf & _
					   " protic.initCap(pers_tape_paterno + ' ' + pers_tape_materno) as apellidos, "& vbcrlf & _
					   " case preg_1_1 when '1' then 'OK' else '' end as preg_1_1,  "& vbcrlf & _
					   " Case preg_1_2 when '1' then 'OK' else '' end as preg_1_2,  "& vbcrlf & _
					   " case preg_1_3 when '1' then 'OK' else '' end as preg_1_3,  "& vbcrlf & _
					   " case preg_1_4 when '1' then 'OK' else '' end as preg_1_4,  "& vbcrlf & _
					   " case preg_1_5 when '1' then 'OK' else '' end as preg_1_5,  "& vbcrlf & _
					   " case preg_1_6 when '1' then 'OK' else '' end as preg_1_6,  "& vbcrlf & _
					   " case preg_2_1 when '1' then 'OK' else '' end as preg_2_1,  "& vbcrlf & _
					   " case preg_2_2 when '1' then 'OK' else '' end as preg_2_2,  "& vbcrlf & _ 
					   " case preg_2_3 when '1' then 'OK' else '' end as preg_2_3,  "& vbcrlf & _
					   " case preg_2_4 when '1' then 'OK' else '' end as preg_2_4,  "& vbcrlf & _
					   " case preg_2_5 when '1' then 'OK' else '' end as preg_2_5,  "& vbcrlf & _
					   " case preg_2_6 when '1' then 'OK' else '' end as preg_2_6,  "& vbcrlf & _ 
					   " case preg_2_7 when '1' then 'OK' else '' end as preg_2_7,  "& vbcrlf & _
				       " fecha_grabado, "& vbcrlf & _
					   " case realizado_desde when '1' then 'Computador personal o externo a las dependencias de la Universidad.' "& vbcrlf & _
					   " when '2' then 'Computador ubicado dentro de las dependencias de la Universidad.' "& vbcrlf & _
					   " when '3' then 'Computador perteneciente a funcionario o secretaria de admisión de la Universidad.' "& vbcrlf & _
					   " when '4' then 'Contacto telefónico con ejecutivo telemarketing.' "& vbcrlf & _
					   " else '' end as realizado_desde  "& vbcrlf & _
					   " from encuestas_postulantes a, personas_postulante b "& vbcrlf & _
					   " where a.pers_ncorr=b.pers_ncorr and cast(a.peri_ccod as varchar)='"&periodo&"' " & vbcrlf & _
					   " order by fecha_grabado, apellidos "

					  

		
tabla.consultar consulta_encuestas

'------------------------------------------------------------------------------------------------------
'--------------------------------------------------------------------------
fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
%>
<html>
<head>
<title>Listado Encuestas Admisión</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Listado Encuestas Marketing</font></div>
	  <div align="right"><%=fecha%></div>
	</td>
 </tr>
</table>
<table width="100%" border="1">
   <tr>
   	<td colspan="4">&nbsp;</td>
	<td colspan="7" bgcolor="#CCFFCC" align="center">I) Me informe sobre la Universidad del Pacífico a través de:</td>
	<td colspan="7" bgcolor="#FFFFCC" align="center">II) He percibido información de la Universidad del Pacífico en los siguientes medios:</td>
	<td colspan="2" bgcolor="#FF9966">&nbsp;</td>
   </tr>
   <tr valign="top"> 
    <td><div align="center"><strong>Nº</strong></div></td>
	<td><div align="left"><strong>Rut</strong></div></td>
    <td><div align="left"><strong>Nombres</strong></div></td>
    <td><div align="left"><strong>Apellidos</strong></div></td>
	<td><div align="left"><strong>Mis compañeros de colegios y/o amigos.</strong></div></td>
    <td><div align="left"><strong>Conocidos que estudian en la Universidad del Pacífico.</strong></div></td>
	<td><div align="left"><strong>Las charlas de orientación en mi colegio y/u orientadores.</strong></div></td>
	<td><div align="left"><strong>Profesores de la Universidad del Pacífico.</strong></div></td>
	<td><div align="left"><strong>Familiares y/o parientes.</strong></div></td>
	<td><div align="left"><strong>Preuniversitario.</strong></div></td>
    <td><div align="left"><strong>Afluencia espontánea.</strong></div></td>
	<td><div align="left"><strong>Radio.</strong></div></td>
	<td><div align="left"><strong>Televisión.</strong></div></td>
	<td><div align="left"><strong>Diarios.</strong></div></td>
	<td><div align="left"><strong>Revistas.</strong></div></td>
	<td><div align="left"><strong>Letreros en vía publica.</strong></div></td>
	<td><div align="left"><strong>Transporte publico.</strong></div></td>
	<td><div align="left"><strong>Internet.</strong></div></td>
	<td><div align="left"><strong>Realizado desde</strong></div></td>
    <td><div align="left"><strong>Fecha Grabado</strong></div></td>
  </tr>
  <% fila = 1   
     while tabla.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
    <td><div align="center"><%=tabla.ObtenerValor("rut")%></div></td>
    <td><div align="center"><%=tabla.ObtenerValor("nombres")%></div></td>
    <td><div align="center"><%=tabla.ObtenerValor("apellidos")%></div></td>
    <td><div align="center"><%=tabla.ObtenerValor("preg_1_1")%></div></td>
	<td><div align="center"><%=tabla.ObtenerValor("preg_1_2")%></div></td>
	<td><div align="center"><%=tabla.ObtenerValor("preg_1_3")%></div></td>
	<td><div align="center"><%=tabla.ObtenerValor("preg_1_4")%></div></td>
	<td><div align="center"><%=tabla.ObtenerValor("preg_1_5")%></div></td>
	<td><div align="center"><%=tabla.ObtenerValor("preg_1_6")%></div></td>
    <td><div align="center"><%=tabla.ObtenerValor("preg_1_7")%></div></td>	
	<td><div align="center"><%=tabla.ObtenerValor("preg_2_1")%></div></td>	
	<td><div align="center"><%=tabla.ObtenerValor("preg_2_2")%></div></td>	
	<td><div align="center"><%=tabla.ObtenerValor("preg_2_3")%></div></td>	
	<td><div align="center"><%=tabla.ObtenerValor("preg_2_4")%></div></td>
	<td><div align="center"><%=tabla.ObtenerValor("preg_2_5")%></div></td>	
	<td><div align="center"><%=tabla.ObtenerValor("preg_2_6")%></div></td>	
	<td><div align="center"><%=tabla.ObtenerValor("preg_2_7")%></div></td>	
	<td><div align="left"><%=tabla.ObtenerValor("realizado_desde")%></div></td>
    <td><div align="center"><%=tabla.ObtenerValor("fecha_grabado")%></div></td>	
  </tr>
  <% fila = fila + 1  
  wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>