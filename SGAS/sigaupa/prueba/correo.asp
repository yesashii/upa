<%@ Language=VBScript%>

<html>

<head>
   <title>Enviar a un amigo</title>

</head>
<body>
<%
Dim cBody, n

For Each n In Request.Form
    cBody = cBody & n & ": " & Request.Form(n) & chr(13)
Next

Set oCDO = Server.CreateObject("CDONTS.NewMail")

'Asignamos las propiedades al objeto
oCDO.From = "mriffo@upacifico.cl"
oCDO.To = "mperelli@upacifico.cl"
oCDO.Subject = "Asunto del mensaje"
oCDO.Body = cBody
'oCDO.Cc = "resal@tudominio.com;webmaster@tudominio.com"
oCDO.Bcc = "mriffo@upacifico.cl"
'oCDO.MailFormat = 0

oCDO.Send

Set oCDO = Nothing 'Liberar...
'Mostramos mensaje de que seenvió con éxito.
Response.Write "¡Se envió Ok, qué fácil!!"

%>
</body>
</html> 
