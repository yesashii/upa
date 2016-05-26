<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
on error resume next
set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next

'response.End()

usuario = negocio.obtenerUsuario
pote_ncorr = request.form("m[0][pote_ncorr]")
forma_pago = request.Form("forma_pago")
tdet_ccod=request.Form("m[0][tdet_ccod]")
datos_persona_correctos= request.Form("m[0][datos_persona_correctos]")
datos_empresa_correctos= request.Form("m[0][datos_empresa_correctos]")
datos_otic_correctos=request.Form("m[0][datos_otic_correctos]")

'if tdet_ccod="" or esVacio(tdet_ccod) or tdest_ccod is null then
'	tdet_ccod=null
'end if	

if pote_ncorr <> "" then 
	
	if forma_pago="1" then
		c_postulantes = "update	postulacion_otec set epot_ccod=2, tdet_ccod="&tdet_ccod&",datos_persona_correctos='"&datos_persona_correctos&"',"&_
		                "audi_tusuario='"&usuario&"',audi_fmodificacion=getDate()"&_
						"where cast(pote_ncorr as varchar)='"&pote_ncorr&"'"
	elseif forma_pago="2" or forma_pago="3" or  forma_pago="5" then
		c_postulantes = "update	postulacion_otec set epot_ccod=2, tdet_ccod="&tdet_ccod&",datos_persona_correctos='"&datos_persona_correctos&"',"&_
						"datos_empresa_correctos='"&datos_persona_correctos&"',"&_
		                "audi_tusuario='"&usuario&"',audi_fmodificacion=getDate()"&_
						"where cast(pote_ncorr as varchar)='"&pote_ncorr&"'"
	elseif forma_pago="4" then
		c_postulantes = "update	postulacion_otec set epot_ccod=2, tdet_ccod="&tdet_ccod&",datos_persona_correctos='"&datos_persona_correctos&"',"&_
						"datos_empresa_correctos='"&datos_empresa_correctos&"',datos_otic_correctos='"&datos_otic_correctos&"',"&_
		                "audi_tusuario='"&usuario&"',audi_fmodificacion=getDate()"&_
						"where cast(pote_ncorr as varchar)='"&pote_ncorr&"'"
	end if 

end if

'----Guardamos un detalle para propósitos de dirección de admisión-----------------Marcelo Sandoval 20-08-2013
dgso_ncorr = conectar.consultaUno("select dgso_ncorr from postulacion_otec where cast(pote_ncorr as varchar)='"&pote_ncorr&"'")
c_tiene_detalle = "select count(*) from detalle_postulacion_otec where cast(pote_ncorr as varchar)='"&pote_ncorr&"' and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'"
tiene_detalle = conectar.consultaUno(c_tiene_detalle)
if tiene_detalle = "0" then
	c_insert_detalle = "insert into detalle_postulacion_otec (pote_ncorr,dgso_ncorr,dpos_nnota,eepo_ccod,dpos_tobservacion,dpos_fexamen,audi_tusuario,audi_fmodificacion)"&_
					   "values ("&pote_ncorr&","&dgso_ncorr&",NULL,2,'APROBADO EN POSTULACION POR DIR. EXTENSION',getDate(),'"&usuario&"',getDate())"
    conectar.ejecutaS c_insert_detalle
end if
'-------------------------Cierre del grabado en detalle--------------------------------------------------------
'response.Write("<br>"&c_postulantes)
'response.Write("<br>"&c_empresa)
'response.Write("<br>"&c_postulacion)
'response.End()
'response.End()
conectar.ejecutaS c_postulantes
'conectar.ejecutaS c_empresa
'conectar.ejecutaS c_postulacion
'response.End()
if cdbl(forma_pago)>1 then  
    'Segmento de código que envía email a encargados de área para cada programa, se comentará para definir su continuidad con Guillermo Araya
	'Comentado por Marcelo Sandoval 09-07-2013
	dgso_ncorr=conectar.ConsultaUno("select dgso_ncorr from postulacion_otec where pote_ncorr="&pote_ncorr&"")
	forma_pago=conectar.ConsultaUno("select forma_pago from postulacion_otec where pote_ncorr="&pote_ncorr&"")
	pers_ncorr=conectar.ConsultaUno("select pers_ncorr from postulacion_otec where pote_ncorr="&pote_ncorr&"")
	dire="http://admision.upacifico.cl/postulacion_extension/www/envio_mail_desde_asp.php?usuario="&usuario&"&pers_ncorr="&pers_ncorr&"&dgso_ncorr="&dgso_ncorr&"&fpot_ccod="&forma_pago&""
	
	'response.Redirect(dire)'línea comentada
	response.Redirect(request.ServerVariables("HTTP_REFERER"))
else
	response.Redirect(request.ServerVariables("HTTP_REFERER"))
end if

'response.Redirect("editar_asignatura.asp?asig_ccod="&request.Form("m[0][asig_ccod]"))

%>
