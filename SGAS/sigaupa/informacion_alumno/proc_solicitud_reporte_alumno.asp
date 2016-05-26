<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file="../biblioteca/_negocio.asp" -->
<%

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio			=	new cnegocio		
negocio.inicializa conexion
'datos recibidos
codigo_carrera= request.Form("enca[0][carreras_alumno]") 
codigo_motivo = request.Form("enca[0][tdes_ccod]")
tipo_certificado =request.Form("certificado")
rut = request.Form("b[0][pers_nrut]")
'datos referentes a los parámetros para llenar el email
carrera = conexion.consultaUno("select protic.initcap(carr_tdesc) from carreras where cast(carr_ccod as varchar)='"&codigo_carrera&"'")
motivo = conexion.consultaUno("select protic.initcap(tdes_tdesc) from tipos_descripciones where cast(tdes_ccod as varchar)='"&codigo_motivo&"'")
nombre = conexion.consultaUno("select protic.initcap(pers_tnombre +' '+ pers_tape_paterno + ' ' + pers_tape_materno) as nombre from personas where cast(pers_nrut as varchar)='"&rut&"'")
rut = conexion.consultaUno("select cast(pers_nrut as varchar)+ '-'+ pers_xdv as rut from personas where cast(pers_nrut as varchar)='"&rut&"'")
email_persona = conexion.consultaUno("select pers_temail from personas where cast(pers_nrut as varchar)='"&rut&"'")

fecha_01 = conexion.consultaUno("select protic.trunc(getDate())")
if tipo_certificado="1" then
	certificado = "Certificado de Alumno regular"
elseif tipo_certificado="2" then											
	certificado = "Certificado Concentración de Notas"
elseif tipo_certificado="3" then
	certificado = "Certificado de Grado académico"
end if	

'compongo el cuerpo del mensaje 
cuerpo = "Solicitud de Certificados Online" & VBNEWLINE & VBNEWLINE 
cuerpo = cuerpo & "Mediante el presente e-mail el alumno " & nombre &" número de rut "&rut&", "& VBNEWLINE 
cuerpo = cuerpo & "perteneciente a la carrera de "&carrera& VBNEWLINE 
cuerpo = cuerpo & "ha solicitado el "&certificado&", con fecha "&fecha_01&"."&VBNEWLINE 
cuerpo = cuerpo & "Para ser presentado en "&motivo&VBNEWLINE 
'response.Write(cuerpo)

'creo el objeto correo
set mail = server.createObject("Persits.MailSender") 
'configuro el mensaje 
'señalo el servidor de salida para enviar el correo 
mail.host = "upacifico.cl" 
'indico la dirección de correo del remitente 
mail.from = email_persona
'indico la dirección del destinatario del mensaje 
mail.addAddress "msandoval@upacifico.cl" 
'indico el cuerpo del mensaje 
mail.body = cuerpo 
'lo envio 
'aseguro que no se presenten errores en la página si se producen 
On Error Resume Next 
mail.send 
if Err ><0 then 
response.write "Error, no se ha podido completar la operación" 
else 
response.write "Gracias por rellenar el formulario. Se ha enviado correctamente." 
end if 


'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>



