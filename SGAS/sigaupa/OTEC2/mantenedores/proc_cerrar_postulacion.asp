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
	elseif forma_pago="2" or forma_pago="3" then
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




'response.Write("<br>"&c_postulantes)
'response.Write("<br>"&c_empresa)
'response.Write("<br>"&c_postulacion)
'response.End()
'response.End()
conectar.ejecutaS c_postulantes
'conectar.ejecutaS c_empresa
'conectar.ejecutaS c_postulacion
'response.End()
'response.write(request.ServerVariables("HTTP_REFERER"))
response.Redirect(request.ServerVariables("HTTP_REFERER"))

'response.Redirect("editar_asignatura.asp?asig_ccod="&request.Form("m[0][asig_ccod]"))

%>
