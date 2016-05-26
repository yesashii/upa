<!-- #include file = "../biblioteca/de_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_evalua.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'-----------------------------------------------------
for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next
'response.End()

set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar


''set f_encuesta = new CFormulario
'f_encuesta.Carga_Parametros "asi_soy_yo.xml", "guardar_respuestas"
'f_encuesta.Inicializar conectar
'f_encuesta.ProcesaForm

rasy_ncorr = conectar.ConsultaUno("exec ObtenerSecuencia 'encuesta_asi_soy_yo'")



'-------------------------crear registro de encuesta----------------
'c_insert = "insert into encuesta_asi_soy_yo(rasy_ncorr,pers_ncorr,carr_ccod,email)"&_
		   '" values ("&rasy_ncorr&","&request.Form("encu[0][pers_ncorr]")&", '"&request.Form("encu[0][carr_ccod]")&"', '"&request.Form("encu[0][pers_temail]")&"')"
'response.Write(c_insert)
'conectar.ejecutaS c_insert

set f_encuesta_1 = new CFormulario
f_encuesta_1.Carga_Parametros "asi_soy_yo.xml", "guardar_respuestas"
f_encuesta_1.Inicializar conectar
f_encuesta_1.ProcesaForm

pers_ncorr=request.Form("encu[0][pers_ncorr]") 
carr_ccod=request.Form("encu[0][carr_ccod]") 
edad=request.Form("encu[0][edad]") 
pers_tfono=request.Form("encu[0][pers_tfono]") 
pers_tcelular=request.Form("encu[0][pers_tcelular]") 
email=request.Form("encu[0][pers_temail]") 
de_provincia=request.Form("encu[0][de_provincia]") 
asi_1=request.Form("encu[0][preg_1]") 
asi_2=request.Form("encu[0][preg_2]") 
asi_3=request.Form("encu[0][preg_3]") 
asi_4=request.Form("encu[0][preg_4]") 
asi_5=request.Form("encu[0][preg_5]") 
asi_6=request.Form("encu[0][preg_6]") 
asi_7=request.Form("encu[0][preg_7]") 
asi_8=request.Form("encu[0][preg_8]") 
asi_9=request.Form("encu[0][preg_9]") 
asi_10=request.Form("encu[0][preg_10]") 
asi_11=request.Form("encu[0][preg_11]") 
asi_12=request.Form("encu[0][preg_12]") 
asi_13_egb_leng=request.Form("encu[0][preg_13_egb_leng]") 
asi_13_egb_mat=request.Form("encu[0][preg_13_egb_mat]") 
asi_13_em_leng=request.Form("encu[0][preg_13_em_leng]") 
asi_13_em_mat=request.Form("encu[0][preg_13_em_mat]") 
asi_14=request.Form("encu[0][preg_14]") 
asi_14_si=request.Form("encu[0][preg_14_si]")
comentarios=request.Form("encu[0][comentarios]") 

if asi_11=1 or asi_11=2 or asi_11=3 then
asi_12="null"
end if
existe_alumno=conectar.ConsultaUno("select count(*) from encuesta_asi_soy_yo where pers_ncorr="&pers_ncorr&"")

if existe_alumno=0 then

	if request.Form("encu[0][ciud_ccod]") = "" then
	ciud_ccod=0
	else
	ciud_ccod=request.Form("encu[0][ciud_ccod]") 
	end if

	inser="insert into encuesta_asi_soy_yo(rasy_ncorr,pers_ncorr,carr_ccod,ciud_ccod,email,edad,pers_tfono,pers_tcelular,de_provincia,asi_1,asi_2,asi_3,asi_4,asi_5,asi_6,asi_7,asi_8,asi_9,asi_10,asi_11,asi_12,asi_13_egb_leng,asi_13_egb_mat,asi_13_em_leng,asi_13_em_mat,asi_14,asi_14_si,comentarios,fecha) values ("&rasy_ncorr&","&pers_ncorr&",'"&carr_ccod&"',"&ciud_ccod&",'"&email&"','"&edad&"','"&pers_tfono&"','"&pers_tcelular&"','"&de_provincia&"',"&asi_1&","&asi_2&","&asi_3&","&asi_4&","&asi_5&","&asi_6&","&asi_7&","&asi_8&","&asi_9&","&asi_10&","&asi_11&","&asi_12&","&asi_13_egb_leng&","&asi_13_egb_mat&","&asi_13_em_leng&","&asi_13_em_mat&","&asi_14&",'"&asi_14_si&"','"&comentarios&"',getDate())"

'response.Write("rasy_ncorr  "&rasy_ncorr)
	response.Write("</br>"&inser)

	conectar.ejecutaS inser
'response.End()

'f_encuesta_1.AgregaCampoFilaPost 0, "rasy_ncorr", rasy_ncorr
'f_encuesta_1.AgregaCampoFilaPost 0, "fecha", conectar.consultaUno("select protic.trunc(getDate())")
'if request.Form("encu[0][ciud_ccod]") = "" then
	'f_encuesta_1.AgregaCampoFilaPost 0, "ciud_ccod", null
'else
'	f_encuesta_1.AgregaCampoFilaPost 0, "ciud_ccod", request.Form("encu[0][ciud_ccod]") = ""
'end if
'f_encuesta_1.MantieneTablas false
'response.End()

	Respuesta = conectar.ObtenerEstadoTransaccion()
'----------------------------------------------------
	response.Write("respuesta "&Respuesta)
		if respuesta = true then
  	session("mensajeerror")= "Resultados ingresados con Éxito"
		else
  	session("mensajeerror")= "Error al guadar los resultados"
		end if
'response.End()
		response.Redirect(request.ServerVariables("HTTP_REFERER"))
else
  
 	session("mensajeerror")= "Tu respuesta ya fue Guardada"
'response.End()
	response.Redirect(request.ServerVariables("HTTP_REFERER"))
end if
%>


