<%
Set objMessage = CreateObject("CDO.Message")
Set Config = Server.createObject ("CDO.Configuration")

Config.Fields("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "mail.upacifico.cl"
Config.Fields("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
Config.Fields("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
Config.Fields("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 60 


Config.Fields.Update

Set objMessage.Configuration = Config

objMessage.Subject 	= "smtp Email de prueba desde pagina asp 3 pagina correo cdo"
objMessage.Sender 	= "mriffo@upacifico.cl"
objMessage.To 		= "mriffo@upacifico.cl"
objMessage.Bcc 		= "mario.riffo@gmail.com"
ObjMessage.HTMLBody ="smtp Esto es una prueba para ver si llega el email con CDOSYS"
objMessage.Send

set objMessage=nothing
set Config=nothing
%>
