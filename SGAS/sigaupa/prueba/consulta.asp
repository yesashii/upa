<%
' me fijo si viene algun valor en el querystring, si no viene nada, no hago nada
if request.querystring("emailUsuario") <> "" then
    email = request.querystring("emailUsuario")
    if email = "webmaster@dominio.com" then
       response.write "Si, existe"
    else
       response.write "No existe"
    end if
end if
%>
