<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
Response.AddHeader "Content-Disposition", "attachment;filename=reporte_perfiles_colegios.xls"
Response.ContentType = "application/vnd.ms-excel"

set pagina = new CPagina
pagina.Titulo = "Reporte Colegios"

v_fecha_inicio 		= request.querystring("busqueda[0][even_fevento]")
v_fecha_termino 	= request.querystring("busqueda[0][fecha_termino]")
v_tiop_ccod	 		= request.querystring("busqueda[0][tiop_ccod]")
v_pcol_ccod 		= request.querystring("busqueda[0][pcol_ccod]")


set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"


	formulario.carga_parametros "consulta.xml", "consulta"
	formulario.inicializar conectar

	if v_fecha_inicio <> "" and esvacio(v_fecha_termino) then
		sql_adicional= sql_adicional + " and  convert(datetime,a.even_fevento,103) >= convert(datetime,'"&v_fecha_inicio&"',103) "& vbCrLf
	end if
	if EsVacio(v_fecha_inicio) and v_fecha_termino<>"" then
		sql_adicional= sql_adicional + " and convert(datetime,a.even_fevento,103) <=  convert(datetime,'"&v_fecha_termino&"',103) "& vbCrLf
	end if
	
	if v_fecha_inicio <> "" and v_fecha_termino <> "" then
		sql_adicional= sql_adicional + " and convert(datetime,a.even_fevento,103) BETWEEN  convert(datetime,'"&v_fecha_inicio&"',103) and convert(datetime,'"&v_fecha_termino&"',103)"& vbCrLf 
	end if
	
	if v_pcol_ccod <> "" then
		sql_adicional= sql_adicional + " and a.pcol_ccod ="&v_pcol_ccod& vbCrLf 
	else
		sql_adicional= sql_adicional + " and a.pcol_ccod in (1,2) "& vbCrLf 
	end if


		sql_datos_eventos= "select even_ncorr,protic.trunc(a.even_fevento) as Fecha,e.pcol_tdesc as Perfil_Colegio, "& vbCrLf &_
						" c.cole_tdesc as Colegio,isnull(b.ciud_tcomuna,d.ciud_tcomuna) as Ciudad ,isnull(b.ciud_tdesc,d.ciud_tdesc) as Comuna "& vbCrLf &_
						" from eventos_upa a, ciudades b, colegios c, ciudades d,perfil_colegio e "& vbCrLf &_
						" where a.ciud_ccod_origen*=b.ciud_ccod "& vbCrLf &_
						" and a.cole_ccod=c.cole_ccod "& vbCrLf &_
						" and c.ciud_ccod=d.ciud_ccod "& vbCrLf &_
						" and a.pcol_ccod=e.pcol_ccod "& vbCrLf &_
						" and a.teve_ccod not in (8)  "& vbCrLf &_
						" and datepart(year,a.even_fevento)=datepart(year,getdate())"& vbCrLf &_
						" "&sql_adicional&"  "& vbCrLf &_
						" order by convert(datetime,a.even_fevento,103) asc "


formulario.consultar sql_datos_eventos

%>


<html>
<head>
<title>Reporte Eventos</title>
</head>
<body>
<table width="75%" border="1">
  <tr>
	<td width="11%" bgcolor="#66CC00"><div align="center"><strong>Fecha</strong></div></td>
	<td width="11%" bgcolor="#66CC00"><div align="center"><strong>Perfil Colegio</strong></div></td> 
    <td width="11%" bgcolor="#66CC00"><div align="center"><strong>Colegio</strong></div></td>
    <td width="11%" bgcolor="#66CC00"><div align="center"><strong>Ciudad</strong></div></td>
    <td width="14%" bgcolor="#66CC00"><div align="center"><strong>Comuna</strong></div></td>
  </tr>
  <%  while formulario.Siguiente %>
  <tr>
	<td><div align="left"><%=formulario.ObtenerValor("Fecha")%></div></td>
	<td><div align="left"><%=formulario.ObtenerValor("Perfil_Colegio")%></div></td> 
    <td><div align="left"><%=formulario.ObtenerValor("Colegio")%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("Ciudad")%></div></td>
    <td><div align="left"><%=formulario.ObtenerValor("Comuna")%></div></td>
    
 </tr>
  <%  wend %>
</table>
</body>
</html>
