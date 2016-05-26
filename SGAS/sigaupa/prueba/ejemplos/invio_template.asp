<%@ Language=VBScript %>

<%
'============ Linkbruttocane su specifiche MSDN ================
'* assicurarsi di non inserire javascript che potrebbero dare errori nel client
'* di posta dei vostri utenti
'=====qui non modificare================
Dim iMsg
Dim iConf
Dim Flds
set iMsg = CreateObject("CDO.Message")
set iConf = CreateObject("CDO.Configuration")
Set Flds = iConf.Fields
Flds("http://schemas.microsoft.com/cdo/configuration/urlgetlatestversion") = True
Flds.Update

With iMsg

Set .Configuration = iConf

'*===== modifica CreateMHTMLBody From To e subject
'cambiare la pagina dopo aver provato a riceverla, vedasi codice utilizzabile nella pagina stessa
'per essere sicuri di non inviare codice non leggibile dal client di posta

.CreateMHTMLBody "http://vademecum.aruba.it/main/sicurezza_via_mail.htm"

'mettere la propria mail
.To = "4test@aruba.it,roberto.zappoli@staff.aruba.it"

'mettere una mail valida come mittente
.From = "linkbruttocane@aruba.it"

.Subject = "test messaggio html via cdosys, uso template"
.Send
End With

%>
<title>cdosys invio pagina html template</title>
pagina html inviata