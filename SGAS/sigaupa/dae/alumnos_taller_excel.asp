<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=listado_alumnos_talleres_sicologia.xls"
Response.ContentType = "application/vnd.ms-excel"

q_pers_nrut =Request.QueryString("pers_nrut")
q_pers_xdv = Request.QueryString("pers_xdv")
q_tdet_ccod =Request.QueryString("tdet_ccod")
q_sede_ccod= request.QueryString("sede_ccod")
q_anos_ccod= request.QueryString("anos_ccod")
q_carr_ccod= request.QueryString("carr_ccod")
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion



if q_pers_nrut <> "" and q_pers_xdv <> ""then
	
	
  filtro1=filtro1&"and a.pers_ncorr=protic.obtener_pers_ncorr1('"&q_pers_nrut&"')"
 
                    
end if


if q_tasi_ncorr <> "" then
	

  	filtro2=filtro2&"and cast(b.tasi_ncorr as varchar)='" &q_tasi_ncorr&"'"
  					
end if
		
 
 if q_sede_ccod <> "" then
	

  	filtro3=filtro3&"and b.sede_ccod='"&q_sede_ccod&"'"
  					
end if

 if q_carr_ccod <> "" then
	

  	filtro4=filtro4&"and c.carr_ccod='" &q_carr_ccod&"'"
  					
end if
 
if q_anos_ccod = "" then
sql_descuentos= "select ''"

else 
sql_descuentos= "select   protic.obtener_rut(a.pers_ncorr)as rut,protic.obtener_nombre(a.pers_ncorr,'n') as nombre,tasi_tdesc as taller,fecha as 				fecha_taller,peri_tdesc as periodo_academico,sede_tdesc as sede,carr_tdesc as carrera"& vbCrLf &_
				"from alumnos_talleres_psicologia a , talleres_dictados_sicologia b,carreras c,especialidades d,ofertas_academicas e,alumnos f,periodos_academicos g,sedes h,talleres_sicologia i"& vbCrLf &_
				"where a.tdsi_ncorr=b.tdsi_ncorr"& vbCrLf &_
				"and i.tasi_ncorr=b.tasi_ncorr"& vbCrLf &_
				"and g.peri_ccod=b.peri_ccod"& vbCrLf &_
				"and g.peri_ccod = e.peri_ccod"& vbCrLf &_
				"and h.sede_ccod=b.sede_ccod"& vbCrLf &_
				"and c.carr_ccod= d.carr_ccod " & vbCrLf &_
				" " &filtro4&" "& vbCrLf &_
				"and e.ofer_ncorr=f.ofer_ncorr "& vbCrLf &_
				"and f.pers_ncorr=a.pers_ncorr "& vbCrLf &_
				"and d.espe_ccod=e.espe_ccod"& vbCrLf &_
				" " &filtro2&" "& vbCrLf &_
				" " &filtro1&" "& vbCrLf &_
				" " &filtro3&" "& vbCrLf &_
				"order by taller,nombre"
				
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
	<td width="29%"><div align="center"><strong>Fecha de Realizaci&oacute;n </strong></div></td>
	<td width="29%"><div align="center"><strong>Periodo Academico </strong></div></td>
	<td width="29%"><div align="center"><strong>Taller</strong></div></td>
	
  </tr>
  <%  while f_valor_documentos.Siguiente %>
  <tr>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("nombre")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("rut")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("carrera")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("sede")%></div></td>
	<td><div align="left"><%=f_valor_documentos.ObtenerValor("fecha_taller")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("periodo_academico")%></div></td>
    <td><div align="left"><%=f_valor_documentos.ObtenerValor("taller")%></div></td>
   
  </tr>
  <%  wend %>
</table>
</html>