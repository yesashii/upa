<html>
<head >
<title>Página ASP de prueba para enviar mensajes</title> 
</head>
<body>

<%
set mail=server.CreateObject("CDONTS.NewMail")
mail.From= Request("sender") ' like my.email.addr@comsoltech.com
mail.To = Request("receiver") ' like john.doe@comsoltech.com
mail.Subject = Request("subject")
mail.Body = Request("body")
mail.BodyFormat = 0 ' 0 = HTML, 1 = Plain
mail.MailFormat = 1 ' 0 = MIME, 1 = Text
mail.Importance = 1 ' 0 =High, 1 = Medium, 2 = Low
mail.Send
set mail=nothing 
%>

<p>
<b>Se ha enviado el mensaje:</b><br>
De: <%= Request("sender") %><br>
A: <%= Request("receiver") %><br>
Con el asunto: <%= Request("subject") %>
</p>
</body>
</html>
