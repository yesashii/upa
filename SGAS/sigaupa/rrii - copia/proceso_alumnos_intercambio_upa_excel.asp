<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=listado_postulantes.xls"
Response.ContentType = "application/vnd.ms-excel"

pais_ccod =Request.Form("b[0][pais_ccod]")
ciex_ccod =Request.Form("b[0][ciex_ccod]")
univ_ccod =Request.Form("b[0][univ_ccod]")
peri_ccod =Request.Form("b[0][peri_ccod]")
pers_nrut =Request.Form("b[0][pers_nrut]")
pers_xdv =Request.Form("b[0][pers_xdv]")
con_diau_fconsulta_esc=Request.Form("_b[0][con_diau_fconsulta_esc]")
sin_diau_fconsulta_esc=Request.Form("_b[0][sin_diau_fconsulta_esc]")
con_diau_respuesta_esc=Request.Form("_b[0][con_diau_respuesta_esc]")
sin_diau_respuesta_esc=Request.Form("_b[0][sin_diau_respuesta_esc]")
con_diau_fenvio_carta_apoderado=Request.Form("_b[0][con_diau_fenvio_carta_apoderado]")
sin_diau_fenvio_carta_apoderado=Request.Form("_b[0][sin_diau_fenvio_carta_apoderado]")
con_diau_fpeticion_certi_alum_reg=Request.Form("_b[0][con_diau_fpeticion_certi_alum_reg]")
sin_diau_fpeticion_certi_alum_reg=Request.Form("_b[0][sin_diau_fpeticion_certi_alum_reg]")
con_diau_frecepcion_certi_alum_reg=Request.Form("_b[0][con_diau_frecepcion_certi_alum_reg]")
sin_diau_frecepcion_certi_alum_reg=Request.Form("_b[0][sin_diau_frecepcion_certi_alum_reg]")
con_diau_fpeticion_certi_notas =Request.Form("_b[0][con_diau_fpeticion_certi_notas]")
sin_diau_fpeticion_certi_notas=Request.Form("_b[0][sin_diau_fpeticion_certi_notas]")
con_diau_frecepcion_certi_notas=Request.Form("_b[0][con_diau_frecepcion_certi_notas]")
sin_diau_frecepcion_certi_notas=Request.Form("_b[0][sin_diau_frecepcion_certi_notas]")
con_diau_estado_ramos=Request.Form("_b[0][con_diau_estado_ramos]")
sin_diau_estado_ramos=Request.Form("_b[0][sin_diau_estado_ramos]")
con_diau_fenvio_memo_es=Request.Form("_b[0][con_diau_fenvio_memo_es]")
sin_diau_fenvio_memo_es=Request.Form("_b[0][sin_diau_fenvio_memo_es]")
con_diau_fenvio_ramos_esc=Request.Form("_b[0][con_diau_fenvio_ramos_esc]")
sin_diau_fenvio_ramos_esc=Request.Form("_b[0][sin_diau_fenvio_ramos_esc]")
con_diau_frecepcion_acuerdo_preconva=Request.Form("_b[0][con_diau_frecepcion_acuerdo_preconva]")
sin_diau_frecepcion_acuerdo_preconva=Request.Form("_b[0][sin_diau_frecepcion_acuerdo_preconva]")
con_diau_fenvio_doctos_extranjero=Request.Form("_b[0][con_diau_fenvio_doctos_extranjero]")
sin_diau_fenvio_doctos_extranjero=Request.Form("_b[0][sin_diau_fenvio_doctos_extranjero]")
con_diau_frecepcion_carta_acepta=Request.Form("_b[0][con_diau_frecepcion_carta_acepta]")
sin_diau_frecepcion_carta_acepta=Request.Form("_b[0][sin_diau_frecepcion_carta_acepta]")
con_diau_ffirma=Request.Form("_b[0][con_diau_ffirma]")
sin_diau_ffirma=Request.Form("_b[0][sin_diau_ffirma]")




'---------------------------------------------------------------------------------------------------

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion





if  pais_ccod <>""  then
filtro2=filtro2&"and f.pais_ccod="&pais_ccod&""
end if

if  ciex_ccod <>"" then
filtro=filtro&"and d.ciex_ccod="&ciex_ccod&""
end if




if univ_ccod<>"" then
filtro3=filtro3&"and d.univ_ccod="&univ_ccod&""
end if
 
 
if pers_nrut<>"" then
filtro4=filtro4&"and pers_nrut="&pers_nrut&""
end if


filtro5=""
if con_diau_fconsulta_esc <>"" then
filtro5=filtro5&" and (select count(diau_fconsulta_esc) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)>0"
end if
if sin_diau_fconsulta_esc <>"" then
filtro5=filtro5&" and (select count(diau_fconsulta_esc) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)=0"
end if
if con_diau_respuesta_esc <>"" then
filtro5=filtro5&" and (select count(diau_respuesta_esc) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)>0"
end if
if sin_diau_respuesta_esc <>"" then
filtro5=filtro5&" and (select count(diau_respuesta_esc) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)=0"
end if
if con_diau_fenvio_carta_apoderado <>"" then
filtro5=filtro5&" and (select count(diau_fenvio_carta_apoderado) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)>0"
end if
if sin_diau_fenvio_carta_apoderado <>"" then
filtro5=filtro5&" and (select count(diau_fenvio_carta_apoderado) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)=0"
end if
if con_diau_fpeticion_certi_alum_reg <>"" then
filtro5=filtro5&" and (select count(diau_fpeticion_certi_alum_reg) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)>0"
end if
if sin_diau_fpeticion_certi_alum_reg <>"" then
filtro5=filtro5&" and (select count(diau_fpeticion_certi_alum_reg) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)=0"
end if
if con_diau_frecepcion_certi_alum_reg <>"" then
filtro5=filtro5&" and (select count(diau_frecepcion_certi_alum_reg) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)>0"
end if
if sin_diau_frecepcion_certi_alum_reg <>"" then
filtro5=filtro5&" and (select count(diau_frecepcion_certi_alum_reg) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)=0"
end if
if con_diau_fpeticion_certi_notas <>"" then
filtro5=filtro5&" and (select count(diau_fpeticion_certi_notas) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)>0"
end if
if sin_diau_fpeticion_certi_notas <>"" then
filtro5=filtro5&" and (select count(diau_fpeticion_certi_notas) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)=0"
end if
if con_diau_frecepcion_certi_notas <>"" then
filtro5=filtro5&" and (select count(diau_frecepcion_certi_notas) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)>0"
end if
if sin_diau_frecepcion_certi_notas <>"" then
filtro5=filtro5&" and (select count(diau_frecepcion_certi_notas) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)=0"
end if
if con_diau_estado_ramos <>"" then
filtro5=filtro5&" and (select count(diau_estado_ramos) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)>0"
end if
if sin_diau_estado_ramos <>"" then
filtro5=filtro5&" and (select count(diau_estado_ramos) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)=0"
end if
if con_diau_fenvio_memo_es <>"" then
filtro5=filtro5&" and (select count(diau_fenvio_memo_es) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)>0"
end if
if sin_diau_fenvio_memo_es <>"" then
filtro5=filtro5&" and (select count(diau_fenvio_memo_es) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)=0"
end if
if con_diau_fenvio_ramos_esc <>"" then
filtro5=filtro5&"and (select count(diau_fenvio_ramos_esc) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)>0"
end if
if sin_diau_fenvio_ramos_esc <>"" then
filtro5=filtro5&" and (select count(diau_fenvio_ramos_esc) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)=0"
end if
if con_diau_frecepcion_acuerdo_preconva <>"" then
filtro5=filtro5&" and (select count(diau_frecepcion_acuerdo_preconva) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)>0"
end if
if sin_diau_frecepcion_acuerdo_preconva <>"" then
filtro5=filtro5&" and (select count(diau_frecepcion_acuerdo_preconva) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)=0"
end if
if con_diau_fenvio_doctos_extranjero <>"" then
filtro5=filtro5&" and (select count(diau_fenvio_doctos_extranjero) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)>0"
end if
if sin_diau_fenvio_doctos_extranjero <>"" then
filtro5=filtro5&" and (select count(diau_fenvio_doctos_extranjero) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)=0"
end if
if con_diau_frecepcion_carta_acepta <>"" then
filtro5=filtro5&" and (select count(diau_frecepcion_carta_acepta) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)>0"
end if
if sin_diau_frecepcion_carta_acepta <>"" then
filtro5=filtro5&" and (select count(diau_frecepcion_carta_acepta) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)=0"
end if
if con_diau_ffirma <>"" then
filtro5=filtro5&" and (select count(diau_ffirma) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)>0"
end if
if sin_diau_ffirma <>"" then
filtro5=filtro5&" and (select count(diau_ffirma) from rrii_documentacion_intercambio_alumnos_upa aadd where aadd.paiu_ncorr=c.paiu_ncorr)=0"
end if




set f_resumen_convenio = new CFormulario
f_resumen_convenio.Carga_Parametros "tabla_vacia.xml", "tabla" 
f_resumen_convenio.Inicializar conexion




sql_descuentos="select c.paiu_ncorr,pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre,"& vbCrLf &_
 "pais_tdesc,"& vbCrLf &_
 "ciex_tdesc,"& vbCrLf &_
 "univ_tdesc,"& vbCrLf &_
 "espi_tdesc,"& vbCrLf &_
 " diau_fconsulta_esc,diau_respuesta_esc,diau_tcomentario_consulta_esc,diau_fenvio_carta_apoderado,diau_frecepcion_carta_apoderado,diau_fpeticion_certi_alum_reg,diau_frecepcion_certi_alum_reg,diau_fpeticion_certi_notas,diau_frecepcion_certi_notas,diau_estado_ramos,diau_fenvio_memo_es,diau_fenvio_ramos_esc,diau_frecepcion_acuerdo_preconva,diau_fenvio_doctos_extranjero,diau_comen_recepcion_carta_apoderado,diau_comen_recepcion_certi_alum_reg,diau_comen_recepcion_certi_notas,diau_comen_envio_ramos_esc,diau_comen_recepcion_acuerdo_preconva,diau_frecepcion_carta_acepta,diau_comen_firma,diau_tcomentario_carta_acepta,diau_comen_recepcion_carta_acepta,diau_ffirma,diau_comen_envio_doctos_extranjero,"& vbCrLf &_
 "'"&pais_ccod&"' as pais_ccod,'"&ciex_ccod&"'as ciex_ccod ,'"&univ_ccod&"' as univ_ccod,'"&peri_ccod&"' as peri_ccod,'"&pers_nrut&"' as pers_nrut,'"&pers_xdv&"' as pers_xdv"& vbCrLf &_
"from personas a,rrii_postulacion_alumnos_intercambio_upa c,universidad_ciudad d,universidades e,ciudades_extranjeras g, paises f,ESTADO_POSTULACION_INTERCAMBIO h,rrii_documentacion_intercambio_alumnos_upa i"& vbCrLf &_
"where a.PERS_NCORR=c.PERS_NCORR"& vbCrLf &_
"and c.unci_ncorr=d.unci_ncorr"& vbCrLf &_
"and d.univ_ccod=e.univ_ccod"& vbCrLf &_
"and d.ciex_ccod=g.ciex_ccod"& vbCrLf &_
"and g.pais_ccod=f.PAIS_CCOD"& vbCrLf &_
"and c.espi_ccod=h.espi_ccod"& vbCrLf &_
"and c.paiu_ncorr=i.paiu_ncorr"& vbCrLf &_
"and c.peri_ccod="&peri_ccod&""& vbCrLf &_
""&filtro&""& vbCrLf &_
""&filtro2&""& vbCrLf &_
""&filtro3&""& vbCrLf &_
""&filtro4&""& vbCrLf &_
"order by  nombre"
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.Write("<pre>"&numero_total&"</pre>")
'response.Write("<pre>"&q_sfun_ccod&"</pre>")
'response.End()

f_resumen_convenio.Consultar sql_descuentos


				
				
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
 
  <tr>
    <td width="26%" bgcolor="#99CC33"><div align="center"><strong>Nombre</strong></div></td>
    <td width="23%" bgcolor="#99CC33"><div align="center"><strong>Universidad</strong></div></td>
	<td width="17%" bgcolor="#99CC33"><div align="center"><strong>Ciudad</strong></div></td>
	<td width="19%" bgcolor="#99CC33"><div align="center"><strong>Pais</strong></div></td>
    <td width="15%" bgcolor="#99CC33"><div align="center"><strong>Estado</strong></div></td>
	<td width="15%" bgcolor="#99CC33"><div align="center"><strong>Fecha Consulta Escuela</strong></div></td>
	<td width="15%" bgcolor="#99CC33"><div align="center"><strong>Respuesta Escuela</strong></div></td>
	<td width="15%" bgcolor="#99CC33"><div align="center"><strong>Comentario Consulta Escuela</strong></div></td>
	<td width="15%" bgcolor="#99CC33"><div align="center"><strong>Fecha Envio Carta Apoderado</strong></div></td>
	<td width="15%" bgcolor="#99CC33"><div align="center"><strong>Fecha Recepcion Carta Apoderado</strong></div></td>
	<td width="15%" bgcolor="#99CC33"><div align="center"><strong>Fecha Peticion Certificado Alumno Regular</strong></div></td>
	<td width="15%" bgcolor="#99CC33"><div align="center"><strong>Fecha Recepcion Certificado Alumno Regular</strong></div></td>
	<td width="15%" bgcolor="#99CC33"><div align="center"><strong>Fecha Peticion Certificado Notas</strong></div></td>
	<td width="15%" bgcolor="#99CC33"><div align="center"><strong>Fecha Recepcion Certificado Notas</strong></div></td>
	<td width="15%" bgcolor="#99CC33"><div align="center"><strong>Estado Ramos</strong></div></td>
	<td width="15%" bgcolor="#99CC33"><div align="center"><strong>Fecha Envio Ramos Escuela</strong></div></td>
	<td width="15%" bgcolor="#99CC33"><div align="center"><strong>Fecha Recepcion Acuerdo Preconvalidacion</strong></div></td>
	<td width="15%" bgcolor="#99CC33"><div align="center"><strong>Fecha Envio Doctos Extranjero</strong></div></td>
	<td width="15%" bgcolor="#99CC33"><div align="center"><strong>Comentario Recepcion Carta Apoderado</strong></div></td>
	<td width="15%" bgcolor="#99CC33"><div align="center"><strong>Comentario Recepcion Certificado Alumno Regular</strong></div></td>
	<td width="15%" bgcolor="#99CC33"><div align="center"><strong>Comentario Recepcion Certificado Notas</strong></div></td>
	<td width="15%" bgcolor="#99CC33"><div align="center"><strong>Comentario Envio Ramos Escuela</strong></div></td>
	<td width="15%" bgcolor="#99CC33"><div align="center"><strong>Comentario Recepcion Acuerdo Preconvalidacion</strong></div></td>
	<td width="15%" bgcolor="#99CC33"><div align="center"><strong>Fecha Recepcion Carta Aceptacion</strong></div></td>
	<td width="15%" bgcolor="#99CC33"><div align="center"><strong>Comentario Firma</strong></div></td>
	
  </tr>
  <%  while f_resumen_convenio.Siguiente %>
  <tr> 
    <td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("nombre")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("univ_tdesc")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("ciex_tdesc")%></div></td>
    <td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("pais_tdesc")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("espi_tdesc")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("diau_fconsulta_esc")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("diau_respuesta_esc")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("diau_tcomentario_consulta_esc")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("diau_fenvio_carta_apoderado")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("diau_frecepcion_carta_apoderado")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("diau_fpeticion_certi_alum_reg")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("diau_frecepcion_certi_alum_reg")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("diau_fpeticion_certi_notas")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("diau_frecepcion_certi_notas")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("diau_estado_ramos")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("diau_fenvio_ramos_esc")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("diau_frecepcion_acuerdo_preconva")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("diau_fenvio_doctos_extranjero")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("diau_comen_recepcion_carta_apoderado")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("diau_comen_recepcion_certi_alum_reg")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("diau_comen_recepcion_certi_notas")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("diau_comen_envio_ramos_esc")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("diau_comen_recepcion_acuerdo_preconva")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("diau_frecepcion_carta_acepta")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("diau_comen_firma")%></div></td>
   
  </tr>
  <%  wend %>
</table>
</html>