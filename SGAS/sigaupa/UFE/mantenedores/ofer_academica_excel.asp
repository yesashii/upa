<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

nom_carrera=request.Form("nom_carrera") 
q_carr_ccod=request.Form("test[0][carr_ccod]")
q_sede_ccod=request.Form("test[0][sede_ccod]")
q_anos_ccod=request.Form("test[0][anos_ccod]")


Response.AddHeader "Content-Disposition", "attachment;filename=oferta_academica.xls"
Response.ContentType = "application/vnd.ms-excel"



set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'carr_tdesc = request.querystring("carr_tdesc")
'carrera = carr_tdesc
'
if carrera="" then
	carrera=" Todas las carreras"
end if	

'------------------------------------------------------------------------------------
set tabla = new cformulario
tabla.carga_parametros	"tabla_vacia.xml",	"tabla"
tabla.inicializar		conexion

if q_carr_ccod<>"" then
filtro1=filtro1&"and g.carr_ccod="&q_carr_ccod&""
end if

if q_sede_ccod<>"" then
filtro2=filtro2&"and e.sede_ccod="&q_sede_ccod&""
end if

if nom_carrera<>"" then
filtro3=filtro3&"and c.nom_carrera_ing like '%" & nom_carrera& "%'"
end if
consulta= 	"select  a.ofai_ncorr, a.ofai_ncorr as eliminar , c.nom_carrera_ing, e.sede_tdesc, b.jorn_tdesc, d.ttie_tdesc, f.anos_ccod , a.ofai_nduracion " & vbCrlf & _
 			"from ufe_oferta_academica_ing a, jornadas b, ufe_carreras_ingresa c , ufe_tipo_titulo_ies d , sedes e , anos f, ufe_carreras_homologadas g,ufe_sedes_ies h " & vbCrlf & _
			"where a.jorn_ccod=b.jorn_ccod and a.car_ing_ncorr = c.car_ing_ncorr " & vbCrlf & _
			"and a.ttie_ccod=d.ttie_ccod " & vbCrlf & _
			"and a.seie_ing_ccod=h.seie_ing_ccod " & vbCrlf & _
			"and a.anos_ccod=f.anos_ccod "& vbCrlf & _
			"and c.car_ing_ncorr=g.car_ing_ncorr" & vbCrlf & _ 
			"and h.sede_ccod=e.sede_ccod"& vbCrlf & _ 
			""&filtro1&""& vbCrlf & _
			""&filtro2&""& vbCrlf & _
			""&filtro3&""& vbCrlf & _
			"and a.anos_ccod="&q_anos_ccod&""& vbCrlf & _
			"order by nom_carrera_ing"


			

tabla.consultar consulta 


fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
%>
<html>
<head>
<title>Oferta Academica Ingresa</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
 <tr> 
    <td colspan="4"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">Oferta Academica Ingresa</font></div>
	<div align="right"></div></td>
    
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
   <tr>
    <td width="4%"><strong>Fecha</strong></td>
    <td width="96%" colspan="3"> <strong>:</strong> <%=fecha%></td>
 </tr>
 
</table>

<p>&nbsp;</p><table width="100%" border="1">
  <tr> 
    <td><div align="center"><strong>Fila</strong></div></td>
    <td><div align="center"><strong>Carrera</strong></div></td>
    <td><div align="center"><strong>Sede</strong></div></td>
    <td><div align="center"><strong>Jornada</strong></div></td>
	 <td><div align="center"><strong>Tipo Titulo</strong></div></td>
     <td><div align="center"><strong>Año</strong></div></td>
	 <td><div align="center"><strong>Duracion</strong></div></td>
     
  </tr>
  <%  
  fila=1  
  while tabla.Siguiente %>
  <tr> 
    <td><div align="center"><%=fila%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("nom_carrera_ing")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("sede_tdesc")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("jorn_tdesc")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("ttie_tdesc")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("anos_ccod")%></div></td>
    <td><div align="left"><%=tabla.ObtenerValor("ofai_nduracion")%></div></td>
 
 </tr>
  <% fila=fila +1 
   wend %>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>