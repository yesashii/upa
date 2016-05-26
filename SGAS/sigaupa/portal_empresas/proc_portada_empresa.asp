<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%


 Session.Contents.RemoveAll()
'-----------------------------------------------------------

 login =request.Form("datos[0][login]")
 uclave =request.Form("datos[0][clave]")
  response.Write("<br/>login="&login)
 response.Write("<br/>clave="&uclave)

'response.End()

 set conexion = new CConexion
 conexion.Inicializar "upacifico"

consulta="select case count(*) when 0 then 'N' else 'S' end from sis_usuarios where susu_tlogin='"&login&"' and susu_tclave='"&uclave&"'"

existe=conexion.ConsultaUno(consulta)
' response.Write("<br/>existe="&existe)
'response.Write("<br/>existe="&consulta)
'response.End()
if existe="S" then
session("rut_usuario") = login	
response.Redirect("inicio_empresa.asp")

elseif existe="N" then
session("mensajeerror") = "El Usuario o Clave son incorrectos"
response.Redirect("portada_empresa.asp")
'response.Write("<br/>aqui se devuelve")
end if
 %>