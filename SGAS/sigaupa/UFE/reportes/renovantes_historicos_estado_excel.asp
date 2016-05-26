<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 

for each k in request.form
	response.Write(k&" = "&request.form(k)&"<br>")
next
'response.End()

Response.AddHeader "Content-Disposition", "attachment;filename=renovantes_historicos_estado.xls"
Response.ContentType = "application/vnd.ms-excel"

q_pers_nrut =Request.form("busqueda[0][pers_nrut]")
q_pers_xdv = Request.form("busqueda[0][pers_xdv]")
q_esre_ccod =Request.form("busqueda[0][esre_ccod]")
q_esre_timportancia= Request.form("busqueda[0][esre_timportancia]")


'response.Write(q_pers_nrut)
'response.Write(q_pers_xdv)
'response.Write(q_esre_ccod)
'response.Write(q_esre_timportancia)
'---------------------------------------------------------------------------------------------------


set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion




'*********************
if q_pers_nrut<>""  then
filtro=filtro&" and a.rut="&q_pers_nrut&""
end if

 if q_esre_ccod<>""  then
filtro=filtro&" and a.estado_renovante="&q_esre_ccod&""
end if

 if q_esre_timportancia<>""  then
filtro=filtro&" and b.esre_timportancia='"&q_esre_timportancia&"'"
end if

 
 if q_pers_nrut<>"" or q_esre_ccod <>"" or q_esre_timportancia<>"" then
 
 select_reno="select cast(rut as varchar)+'-'+dv as rut,nombres+' '+paterno+' '+materno as nombre,b.esre_ccod ,"& vbCrLf &_
"b.esre_tdesc,esre_timportancia,case when b.esre_timportancia='BAJA' then '<img src="&CHR(034)&"imagenes/sem_verde.png"&CHR(034)&" width="&CHR(034)&"25"&CHR(034)&" height="&CHR(034)&"25"&CHR(034)&"/>' when b.esre_timportancia='MEDIA' then '<img src="&CHR(034)&"imagenes/sem_amarillo.png"&CHR(034)&" width="&CHR(034)&"25"&CHR(034)&" height="&CHR(034)&"25"&CHR(034)&"/>'"& vbCrLf &_
 "when b.esre_timportancia='ALTA' then '<img src="&CHR(034)&"imagenes/sem_rojo.png"&CHR(034)&" width="&CHR(034)&"25"&CHR(034)&" height="&CHR(034)&"25"&CHR(034)&"/>' end as importancia,esre_tprocedimiento "& vbCrLf &_
"from ufe_renovantes_historicos a,UFE_estados_renovantes b"& vbCrLf &_
"where a.estado_renovante=b.esre_ccod "& vbCrLf &_
""&filtro&""
	
else
select_reno="select ''"
end if
'**********************
	
				
fecha=conexion.ConsultaUno("select protic.trunc(getdate())")
hora =conexion.ConsultaUno("select cast(datepart(hour,getdate())as varchar)+':'+cast(datepart(minute,getdate())as varchar)+' hrs'")



'response.Write("<pre>"&select_reno&"</pre>")
'response.End()

set f_valor_documentos  = new cformulario
f_valor_documentos.carga_parametros "tabla_vacia.xml", "tabla" 
f_valor_documentos.inicializar conexion							
f_valor_documentos.consultar select_reno


'------------------------------------------------------------------------------
%>
 <html>
<head>
<title><%=pagina.Titulo%></title>  

</head>
<body bgcolor="#ffffff" leftmargin="43" topmargin="0" marginwidth="0" marginheight="0">
<BR>
<BR>
<table width="100%" border="1">
  <tr align="center">
    <td></td>
    
    <td><div align="center"><strong>Año <%=q_anos_ccod%></strong></div></td>
	 <td><div align="center"><strong>Reporte hecho el <%=fecha%></strong></div></td>
      <td><div align="left"><strong>a las <%=hora%></strong></div></td>
  </tr>
 
  <tr>
    <td width="11%"><div align="up"><strong>Importancia</strong></div></td>
    <td width="15%"><div align="center"><strong>Rut</strong></div></td>
	<td width="24%"><div align="center"><strong>Nombre</strong></div></td>
    <td width="21%"><div align="center"><strong>Estado</strong></div></td>
	 <td width="10%"><div align="center"><strong>Codigo</strong></div></td>
	 <td width="19%"><div align="center"><strong>Procedimiento</strong></div></td>
  </tr>
  <%  while f_valor_documentos.Siguiente %>
  <tr>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("esre_timportancia")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("rut")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("Nombre")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("esre_tdesc")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("esre_ccod")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("esre_tprocedimiento")%></div></td>
  </tr>
  <%  wend %>
</table>
</html>