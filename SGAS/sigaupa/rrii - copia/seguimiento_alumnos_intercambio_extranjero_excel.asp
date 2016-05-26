<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
server.ScriptTimeout = 2000 
Response.AddHeader "Content-Disposition", "attachment;filename=listado_postulantes.xls"
Response.ContentType = "application/vnd.ms-excel"

'	for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'	next
'response.End()

espi_ccod =Request.form("b[0][espi_ccod]")
pais_ccod =Request.form("b[0][pais_ccod]")
ciex_ccod =Request.form("b[0][ciex_ccod]")
univ_ccod =Request.form("b[0][univ_ccod]")
peri_ccod =Request.form("b[0][peri_ccod]")
pers_nrut =Request.form("b[0][pers_nrut]")
pers_xdv =Request.form("b[0][pers_xdv]")
con_doie_fenvio_memo_esc=Request.form("_b[0][con_doie_fenvio_memo_esc]")
sin_doie_fenvio_memo_esc=Request.form("_b[0][sin_doie_fenvio_memo_esc]")
con_doie_frespuesta_escuela=Request.form("_b[0][con_doie_frespuesta_escuela]")
sin_doie_frespuesta_escuela=Request.form("_b[0][sin_doie_frespuesta_escuela]")
con_doie_respuesta_escuela=Request.form("_b[0][con_doie_respuesta_escuela]")
sin_doie_respuesta_escuela=Request.form("_b[0][sin_doie_respuesta_escuela]")
con_doie_fenvio_ramos=Request.form("_b[0][con_doie_fenvio_ramos]")
sin_doie_fenvio_ramos=Request.form("_b[0][sin_doie_fenvio_ramos]")
con_doie_fenvio_carta_acep=Request.form("_b[0][con_doie_fenvio_carta_acep]")
sin_doie_fenvio_carta_acep=Request.form("_b[0][sin_doie_fenvio_carta_acep]")
con_doie_frecepcion_carga_acad=Request.form("_b[0][con_doie_frecepcion_carga_acad]")
sin_doie_frecepcion_carga_acad=Request.form("_b[0][sin_doie_frecepcion_carga_acad]")
con_doie_fbienvenida=Request.form("_b[0][con_doie_fbienvenida]")
sin_doie_fbienvenida=Request.form("_b[0][sin_doie_fbienvenida]")
'---------------------------------------------------------------------------------------------------

set pagina = new CPagina

set conexion = new cConexion
set negocio = new cNegocio

conexion.inicializar "upacifico"
negocio.inicializa conexion

if  espi_ccod <>""  then
filtro0=filtro0&"and c.espi_ccod = '"&espi_ccod&"'"
end if

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

if pasaporte<>"" then
filtro5=filtro5&"and PERS_TPASAPORTE='"&pasaporte&"'"
end if


filtro_doc=""

if con_doie_fenvio_memo_esc<>"" then
filtro_doc=filtro_doc&" and (select count(doie_fenvio_memo_esc) from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr)>0"
end if
if sin_doie_fenvio_memo_esc<>"" then
filtro_doc=filtro_doc&" and (select count(doie_fenvio_memo_esc) from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr)=0"
end if
if con_doie_frespuesta_escuela<>"" then
filtro_doc=filtro_doc&" and (select count(doie_frespuesta_escuela) from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr)>0"
end if
if sin_doie_frespuesta_escuela<>"" then
filtro_doc=filtro_doc&" and (select count(doie_frespuesta_escuela) from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr)=0"
end if
if con_doie_respuesta_escuela<>"" then
filtro_doc=filtro_doc&" and (select count(doie_frespuesta_escuela) from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr)<>''"
end if
if sin_doie_respuesta_escuela<>"" then
filtro_doc=filtro_doc&" and (select doie_frespuesta_escuela from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr)=''"
end if
if con_doie_fenvio_ramos<>"" then
filtro_doc=filtro_doc&" and (select count(doie_fenvio_ramos) from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr)>0"
end if
if sin_doie_fenvio_ramos<>"" then
filtro_doc=filtro_doc&" and (select count(doie_fenvio_ramos) from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr)=0"
end if
if con_doie_fenvio_carta_acep<>"" then
filtro_doc=filtro_doc&" and (select count(doie_fenvio_carta_acep) from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr)>0"
end if
if sin_doie_fenvio_carta_acep<>"" then
filtro_doc=filtro_doc&" and (select count(doie_fenvio_carta_acep) from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr)=0"
end if
if con_doie_frecepcion_carga_acad<>"" then
filtro_doc=filtro_doc&" and (select count(doie_frecepcion_carga_acad) from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr)>0"
end if
if sin_doie_frecepcion_carga_acad<>"" then
filtro_doc=filtro_doc&" and (select count(doie_frecepcion_carga_acad) from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr)=0"
end if
if con_doie_fbienvenida<>"" then
filtro_doc=filtro_doc&" and (select count(doie_fbienvenida) from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr)>0"
end if
if sin_doie_fbienvenida<>"" then
filtro_doc=filtro_doc&" and (select count(doie_fbienvenida) from rrii_documentacion_intercambio_extranjero aadd where aadd.paie_ncorr=c.paie_ncorr)=0"
end if


set f_resumen_convenio = new CFormulario
f_resumen_convenio.Carga_Parametros "tabla_vacia.xml", "tabla" 
f_resumen_convenio.Inicializar conexion

sql_descuentos="select cast(pers_nrut as varchar)+'-'+pers_xdv as rut,pers_tpasaporte,c.paie_ncorr,pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre,"& vbCrLf &_
"pais_tdesc,"& vbCrLf &_
"ciex_tdesc,"& vbCrLf &_
"univ_tdesc,"& vbCrLf &_
"espi_tdesc,"& vbCrLf &_
"doie_med_compania,	doie_med_poliza, doie_med_telefono,"& vbCrLf &_		
"doie_fdocument,	doie_tcomentario_document, doie_tcomentario_fbienvenida,"& vbCrLf &_		
	"protic.trunc(doie_fenvio_memo_esc)as doie_fenvio_memo_esc,"& vbCrLf &_
	"protic.trunc(doie_frespuesta_escuela)as doie_frespuesta_escuela,"& vbCrLf &_ 
	"doie_respuesta_escuela ,"& vbCrLf &_
	"protic.trunc(doie_fenvio_ramos)as doie_fenvio_ramos ,"& vbCrLf &_
	"protic.trunc(doie_fenvio_carta_acep)as doie_fenvio_carta_acep ,"& vbCrLf &_
	"protic.trunc(doie_frecepcion_carga_acad) as doie_frecepcion_carga_acad,"& vbCrLf &_
	"doie_fbienvenida,a.pers_temail as emailp,"& vbCrLf &_
	"(select CARR_TDESC from carreras ca where c.carr_ccod = ca.CARR_CCOD)as carrera,"& vbCrLf &_
 "'"&pais_ccod&"' as pais_ccod,'"&ciex_ccod&"'as ciex_ccod ,'"&univ_ccod&"' as univ_ccod,(select peri_tdesc from PERIODOS_ACADEMICOS where peri_ccod = '"&peri_ccod&"') as peri_ccod,'"&pers_nrut&"' as pers_nrut,'"&pers_xdv&"' as pers_xdv,'"&pasaporte&"' as pasaporte,protic.imagenes_estado_documen(c.paie_ncorr) as estados_doc,"& vbCrLf &_
    "(select top 1 lower(email_nuevo) from cuentas_email_upa tt where tt.pers_ncorr=a.pers_ncorr) as email"& vbCrLf &_
"from personas_postulante a,rrii_postulacion_alumnos_intercambio_extranjero c,universidad_ciudad d,universidades e,ciudades_extranjeras g, paises f,ESTADO_POSTULACION_INTERCAMBIO h,rrii_documentacion_intercambio_extranjero i"& vbCrLf &_
"where a.PERS_NCORR=c.PERS_NCORR"& vbCrLf &_
"and c.unci_ncorr=d.unci_ncorr"& vbCrLf &_
"and d.univ_ccod=e.univ_ccod"& vbCrLf &_
"and d.ciex_ccod=g.ciex_ccod"& vbCrLf &_
"and g.pais_ccod=f.PAIS_CCOD"& vbCrLf &_
"and c.espi_ccod=h.espi_ccod"& vbCrLf &_
"and c.paie_ncorr=i.paie_ncorr"& vbCrLf &_
"and (c.peri_ccod="&peri_ccod&" or c.peri_ccod_fin="&peri_ccod&")"& vbCrLf &_
""&filtro&""& vbCrLf &_
""&filtro0&""& vbCrLf &_
""&filtro2&""& vbCrLf &_
""&filtro3&""& vbCrLf &_
""&filtro4&""& vbCrLf &_
""&filtro5&""& vbCrLf &_
""&filtro_doc&""& vbCrLf &_
"and espi_tdesc <> 'ELIMINADO'"& vbCrLf &_
"order by  pais_tdesc,ciex_tdesc"
'response.Write("<pre>"&sql_descuentos&"</pre>")
'response.End()

f_resumen_convenio.Consultar sql_descuentos

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
	<td width="26%" bgcolor="#99CC33"><div align="center"><strong>Rut</strong></div></td>
	<td width="26%" bgcolor="#99CC33"><div align="center"><strong>Pasaporte</strong></div></td>
    <td width="26%" bgcolor="#99CC33"><div align="center"><strong>Nombre</strong></div></td>
	<td width="26%" bgcolor="#99CC33"><div align="center"><strong>Email Upa</strong></div></td>
    <td width="26%" bgcolor="#99CC33"><div align="center"><strong>Email Personal</strong></div></td>
    <td width="23%" bgcolor="#99CC33"><div align="center"><strong>Universidad</strong></div></td>
	<td width="23%" bgcolor="#99CC33"><div align="center"><strong>Carrera postulacion</strong></div></td>
	<td width="23%" bgcolor="#99CC33"><div align="center"><strong>Periodo postulacion</strong></div></td>
	<td width="17%" bgcolor="#99CC33"><div align="center"><strong>Ciudad</strong></div></td>
	<td width="19%" bgcolor="#99CC33"><div align="center"><strong>Pais</strong></div></td>
    <td width="15%" bgcolor="#99CC33"><div align="center"><strong>Estado</strong></div></td>
    <td width="15%" bgcolor="#99CC33"><div align="center"><strong>Entrega de Documentos</strong></div></td>
    <td width="15%" bgcolor="#99CC33"><div align="center"><strong>Comentario Documentos</strong></div></td>
	<td width="15%" bgcolor="#99CC33"><div align="center"><strong>Fecha Envio Memo Escuela</strong></div></td>
	<td width="15%" bgcolor="#99CC33"><div align="center"><strong>Fecha Respuesta Escuela</strong></div></td>
	<td width="15%" bgcolor="#99CC33"><div align="center"><strong>Respuesta Escuela</strong></div></td>
	<td width="15%" bgcolor="#99CC33"><div align="center"><strong>Fecha Envio Ramos</strong></div></td>
	<td width="15%" bgcolor="#99CC33"><div align="center"><strong>Fecha Envio Carta de Aceptacion</strong></div></td>
	<td width="15%" bgcolor="#99CC33"><div align="center"><strong>Fecha Recepcion Carga Academica</strong></div></td>
	<td width="15%" bgcolor="#99CC33"><div align="center"><strong>Bienvenida</strong></div></td>
    <td width="15%" bgcolor="#99CC33"><div align="center"><strong>Comentario Bienvenida</strong></div></td>
    <td width="15%" bgcolor="#99CC33"><div align="center"><strong>Compania Seguro Medico</strong></div></td>
    <td width="15%" bgcolor="#99CC33"><div align="center"><strong>Poliza Seguro Medico</strong></div></td>
    <td width="15%" bgcolor="#99CC33"><div align="center"><strong>Fono Seguro Medico</strong></div></td>
  </tr>
  <%  while f_resumen_convenio.Siguiente %>
  <tr> 
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("rut")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("pers_tpasaporte")%></div></td>
    <td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("nombre")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("email")%></div></td>
    <td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("emailp")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("univ_tdesc")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("carrera")%></div></td>	
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("peri_ccod")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("ciex_tdesc")%></div></td>
    <td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("pais_tdesc")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("espi_tdesc")%></div></td>
    <td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("doie_fdocument")%></div></td>
    <td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("doie_tcomentario_document")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("doie_fenvio_memo_esc")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("doie_frespuesta_escuela")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("doie_respuesta_escuela")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("doie_fenvio_ramos")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("doie_fenvio_carta_acep")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("doie_frecepcion_carga_acad")%></div></td>
	<td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("doie_fbienvenida")%></div></td>
    <td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("doie_tcomentario_fbienvenida")%></div></td>
    <td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("doie_med_compania")%></div></td>
    <td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("doie_med_poliza")%></div></td>
    <td valign="top"><div align="center"><%=f_resumen_convenio.ObtenerValor("doie_med_telefono")%></div></td>
  </tr>
  <%  wend %>
</table>
</html>