<%

'Vamos a mandar un mail!
Dim sDestintatario, sAsunto, sCuerpo
Dim oMail	'el objeto CDO

sAsunto="E-Mail de prueba desde ASP"

'Creamos el cuerpo con varias líneas para facilitar la lectura
sCuerpo = "Este es mi primer mensaje enviado desde ASP." & VbCrLf
sCuerpo = sCuerpo & "Acabaré gestionando una lista de correo algún día!" & VbCrLf
sCuerpo = sCuerpo & VbCrlf & VbCrLf & "Ah! Lo aprendí en www.aspfacil.com"

sDestinatario="mriffo@upacifico.cl"

'Enviamos el email
set oMail=Server.CreateObject("CDONTS.NewMail")

'Establecemos las propiedades del objeto
oMail.From = "ASPFácil ejemplo de Mail " 'Pon aquí tu mombre y dirección
oMail.To = sDestinatario
oMail.Subject = sAsunto
oMail.Body = sCuerpo

' Enviamos el email!
oMail.Send

set oMail = nothing
Response.Write ("Mensaje enviado.")

%>
