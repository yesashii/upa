<!--METADATA TYPE="typelib" UUID="CD000000-8B95-11D1-82DB-00C04FB1625D" NAME="CDO for Windows 2000 Type Library" -->
<!--METADATA TYPE="typelib" UUID="00000205-0000-0010-8000-00AA006D2EA4" NAME="ADODB Type Library" -->
<%
'============Linkbruttocane su specifiche MSDN================
'*   il corpo finale del messaggio contiene tutti i campi    *
'*   inseriti nella pagina html, in pratica puoi mettere     *
'*   tutti i campi che ti servono nel modulo di invio senza  *
'*   fare altre configurazioni aggiuntive.                   *  
'=============================================================

DIM corpoMessaggio, numeroCampi, invioA, invioDa, nomeDominio, indirizzoIp, modulo, browserSistemaOperativo

	'* voce da modificare con il proprio indirizzo email
	
invioA =  "linkbruttocane@aruba.it"

	'* voce da modificare con un indirizzo email che funga da mittente: 
	'* in caso di errore riceverete notifica a questo indirizzo un MAILER-DAEMON
	'* dato che cdosys supporta questa notifica
		
invioDa =  "linkbruttocane@technet.it"

'------------fine modifiche necessarie------------------

nomeDominio 				= Request.ServerVariables("HTTP_HOST")
indirizzoIp					= Request.ServerVariables("REMOTE_ADDR") 
modulo						= Request.ServerVariables("HTTP_REFERER")
browserSistemaOperativo		= Request.ServerVariables("HTTP_USER_AGENT")

	'*rilevo i campi del form
	
FOR numeroCampi = 1 TO (Request.Form.Count() - 1)
   IF NOT Request.Form(numeroCampi) = "" THEN
      corpoMessaggio = corpoMessaggio & "<br>" & Request.Form.Key(numeroCampi) & " = " & Trim(Request.Form(numeroCampi))
   END IF
NEXT

	'* creo gli oggetti cdosys sul server e li gestisco
	
DIM iMsg, Flds, iConf

Set iMsg = CreateObject("CDO.Message")
Set iConf = CreateObject("CDO.Configuration")
Set Flds = iConf.Fields

Flds(cdoSendUsingMethod) = cdoSendUsingPort
Flds(cdoSMTPServer) = "smtp.aruba.it" 
Flds(cdoSMTPServerPort) = 25
Flds(cdoSMTPAuthenticate) = cdoAnonymous ' 0
Flds.Update

With iMsg
   Set .Configuration = iConf
   .To = invioA
   .From = Request.Form("email")
   .Sender = invioDa
   .Subject = "Contatto dal dominio " & nomeDominio
   '.TextBody = "Questi i dati inseriti nel modulo presente alla pagina " & modulo & " da utente con indirizzo IP " & indirizzoIp & "  browser e sistema operativo " & browserSistemaOperativo  & vbCrLf & corpoMessaggio & ""
   .HTMLBody = "<font face=verdana size=2>Questi i dati inseriti nel modulo presente alla pagina <b> " & modulo & " </b>da utente con indirizzo IP <b>" & indirizzoIp & " </b> browser e sistema operativo <b>" & browserSistemaOperativo  & "</b><br>" & corpoMessaggio 

   .Send
End With
%> 
<script>
document.location.replace('grazie.asp');
</script>