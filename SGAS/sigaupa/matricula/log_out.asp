<%
Response.Buffer = True
Response.ExpiresAbsolute = Now() - 1
Response.Expires = 0
Response.CacheControl = "no-cache"

Session.Contents.Remove("pers_ncorr")
Session.Contents.Remove("post_ncorr")

if Session("ses_act_ancedentes") = "S" then
	Session.Contents.Remove("ses_act_ancedentes")
	'Response.Redirect("../lanzadera/lanzadera.asp")
elseif Session("ses_modificar_informacion") = "S" then
	Session.Contents.Remove("ses_modificar_informacion")
end if
Response.Redirect("inicio.asp")

%>
