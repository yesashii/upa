<!-- 
METADATA 
TYPE="typelib" 
UUID="CD000000-8B95-11D1-82DB-00C04FB1625D" 
NAME="CDO for Windows 2000 Library" 
--> 
<% 
Set cdoConfig = CreateObject("CDO.Configuration") 

With cdoConfig.Fields 
.Item(cdoSendUsingMethod) = cdoSendUsingPort 
.Item(cdoSMTPServer) = "mail.upacifico.cl" 
.Update 
End With 

Set cdoMessage = CreateObject("CDO.Message") 

With cdoMessage 
Set .Configuration = cdoConfig 
.From = "mperelli@upacifico.cl" 
.To = "rbadilla@upacifico.cl" 
.cc = "mriffo@upacifico.cl"
.Bcc = "msandoval@upacifico.cl"
.Subject = "Probando envio de correo" 
.TextBody = "Este es un correo de pruebas. No lo responda por la shu..." 
.Send 
End With 

Set cdoMessage = Nothing 
Set cdoConfig = Nothing 
Response.Write "¡Correo se envió Ok!!"
%>
