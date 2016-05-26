<%
Set oMail = Server.CreateObject("Persits.MailSender")
Set oMail = Server.CreateObject("SMTPsvg.Mailer")
oMail.FromName = "mriffo@upacifico.cl"
oMail.FromAddress= "mriffo@upacifico.cl"
oMail.RemoteHost = "10.10.10.1"
oMail.AddRecipient destinatario_nombre , destinatario_mail
'oMail.AddRecipient "Roberto Escobar" , "rescobar@inacap.cl"
oMail.Subject = "Pruebas de correo"
oMail.ContentType = "text/html"
oMail.Bodytext = "<html><body>Hemos recibido tu opinión.<br>" & _
"Encontraras la respuesta en la zona privada de la Intranet Académica " & _
"accediendo a través del menú ""Ambiente Alumno"" o, " & _
"haciendo click en la imagen del Buzón de Sugerencias "&_
"ubicada al lado derecho de la ventana.<br><br></body></html>"
oMail.Sendmail
Set oMail = Nothing
%>
