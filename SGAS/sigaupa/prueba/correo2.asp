<%

'Vamos a mandar un mail!
Dim sDestintatario, sAsunto, sCuerpo
Dim oMail	'el objeto CDO

sAsunto="E-Mail de prueba desde ASP"

'Creamos el cuerpo con varias l�neas para facilitar la lectura
sCuerpo = "Este es mi primer mensaje enviado desde ASP." & VbCrLf
sCuerpo = sCuerpo & "Acabar� gestionando una lista de correo alg�n d�a!" & VbCrLf
sCuerpo = sCuerpo & VbCrlf & VbCrLf & "Ah! Lo aprend� en www.aspfacil.com"

sDestinatario="mriffo@upacifico.cl"

'Enviamos el email
set oMail=Server.CreateObject("CDONTS.NewMail")

'Establecemos las propiedades del objeto
oMail.From = "ASPF�cil ejemplo de Mail " 'Pon aqu� tu mombre y direcci�n
oMail.To = sDestinatario
oMail.Subject = sAsunto
oMail.Body = sCuerpo

' Enviamos el email!
oMail.Send

set oMail = nothing
Response.Write ("Mensaje enviado.")

%>
