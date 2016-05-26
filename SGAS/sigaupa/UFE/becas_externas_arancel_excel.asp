<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=listado_becas_externas_arancel.xls"
Response.ContentType = "application/vnd.ms-excel"

q_pers_nrut =Request.QueryString("pers_nrut")
q_pers_xdv = Request.QueryString("pers_xdv")
q_tdet_ccod =Request.QueryString("tdet_ccod")
q_sede_ccod= request.QueryString("sede_ccod")
q_anos_ccod= request.QueryString("anos_ccod")
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion


if q_pers_nrut <> "" and q_pers_xdv <> ""then
	
	
  filtro1=filtro1&"and c.pers_ncorr=protic.obtener_pers_ncorr1('"&q_pers_nrut&"')"
 
                    
end if


if q_tdet_ccod <> "" then
	

  	filtro2=filtro2&"and a.tdet_ccod='" &q_tdet_ccod&"'"
  					
end if
		
 
 if q_sede_ccod <> "" then
	

  	filtro3=filtro3&"and d.sede_ccod='" &q_sede_ccod&"'"
  					
end if
  if q_anos_ccod <> "" then
	

  	filtro4=filtro4&"and d.peri_ccod in (select peri_ccod from periodos_academicos a1 where a1.anos_ccod="&q_anos_ccod&")"
  					
end if
if q_tdet_ccod = "" then
sql_descuentos= "select ''"

else 
sql_descuentos= "select a.post_ncorr, pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,carr_tdesc as carrera,(select sede_tdesc from sedes where sede_ccod=d.sede_ccod)sede"& vbCrLf &_
 				"from alumno_credito a,alumnos b,personas c,ofertas_academicas d,especialidades e,carreras f"& vbCrLf &_
				"where a.post_ncorr=b.post_ncorr"& vbCrLf &_
				"and b.pers_ncorr=c.pers_ncorr"& vbCrLf &_
				"and b.ofer_ncorr=d.ofer_ncorr"& vbCrLf &_
				"and d.espe_ccod=e.espe_ccod"& vbCrLf &_
				"and e.carr_ccod=f.carr_ccod"& vbCrLf &_
				"and d.peri_ccod in (select peri_ccod from periodos_academicos a1 where a1.anos_ccod="&q_anos_ccod&")"& vbCrLf &_
				" " &filtro2&" "& vbCrLf &_
				" " &filtro1&" "& vbCrLf &_
				" " &filtro3&" "& vbCrLf &_
				"order by carrera,nombre"
				
				'
				numero_total=conexion.ConsultaUno("select count(post_ncorr) from(select a.post_ncorr, pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,carr_tdesc as carrera,(select sede_tdesc from sedes where sede_ccod=d.sede_ccod)sede"& vbCrLf &_
 				"from alumno_credito a,alumnos b,personas c,ofertas_academicas d,especialidades e,carreras f"& vbCrLf &_
				"where a.post_ncorr=b.post_ncorr"& vbCrLf &_
				"and b.pers_ncorr=c.pers_ncorr"& vbCrLf &_
				"and b.ofer_ncorr=d.ofer_ncorr"& vbCrLf &_
				"and d.espe_ccod=e.espe_ccod"& vbCrLf &_
				"and d.peri_ccod in (select peri_ccod from periodos_academicos a1 where a1.anos_ccod="&q_anos_ccod&")"& vbCrLf &_
				" " &filtro2&" "& vbCrLf &_
				" " &filtro1&" "& vbCrLf &_
				" " &filtro3&" "& vbCrLf &_
				"and e.carr_ccod=f.carr_ccod )as bb")
				

total=numero_total			
end if			
				
fecha=conexion.ConsultaUno("select protic.trunc(getdate())")
hora =conexion.ConsultaUno("select cast(datepart(hour,getdate())as varchar)+':'+cast(datepart(minute,getdate())as varchar)+' hrs'")




	
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&q_tdet_ccod&"</pre>")
'response.Write("<pre>"&q_sede_ccod&"</pre>")
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.End()
set f_valor_documentos  = new cformulario
f_valor_documentos.carga_parametros "tabla_vacia.xml", "tabla" 
f_valor_documentos.inicializar conexion							
f_valor_documentos.consultar sql_descuentos

'-------------------------------------------------------------------------------



'response.End()		

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
    <td width="22%"><div align="up"><strong>Nombre</strong></div></td>
    <td width="11%"><div align="center"><strong>Rut</strong></div></td>
    <td width="38%"><div align="center"><strong>Carrera</strong></div></td>
    <td width="29%"><div align="center"><strong>Sede</strong></div></td>
  </tr>
  <%  while f_valor_documentos.Siguiente %>
  <tr>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("nombre")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("carrera")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("sede")%></div></td>
  </tr>
  <%  wend %>
</table>
</html>