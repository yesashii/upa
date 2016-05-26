<%

for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next

'response.End()

'Vamos a mandar un mail!
Dim sDestintatario, sAsunto, sCuerpo
Dim oMail	'el objeto CDO

sAsunto="Clave de acceso a Pacífico online"

'Creamos el cuerpo con varias líneas para facilitar la lectura
sCuerpo = "Estimado "&request.Form("nombre") & VbCrLf
sCuerpo = sCuerpo & "Los datos de acceso a pafícico online registrado para tu Rut son:" & VbCrLf
sCuerpo = sCuerpo & VbCrlf & VbCrLf & " login : "&request.Form("login") & VbCrLf
sCuerpo = sCuerpo & VbCrlf & VbCrLf & " clave : "&request.Form("clave") & VbCrLf
sCuerpo = sCuerpo & "Si encuentras algún problema de acceso comunicate con el departamento de informática de la Universidad" & VbCrLf

sDestinatario="msandoval@upacifico.cl"

'Enviamos el email
set oMail=Server.CreateObject("CDONTS.NewMail")

'Establecemos las propiedades del objeto
oMail.From = "msandoval@upacifico.cl" 'Pon aquí tu mombre y dirección
oMail.To = sDestinatario
oMail.Subject = sAsunto
oMail.Body = sCuerpo

' Enviamos el email!
oMail.Send

set oMail = nothing
Response.Write ("Mensaje enviado.")


response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

