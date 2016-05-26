<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario = negocio.ObtenerUsuario()

for each k in request.form'
	response.write(k&"="&request.Form(k)&"<br>")'
next'
'Uresponse.End()

pers_nrut=request.form("b[0][pers_nrut]")
pare_ccod=request.form("b[0][pare_ccod]")


set f_cc = new cformulario
f_cc.carga_parametros "areas_gastos.xml", "eliminar_perfil_area_usuario" 
f_cc.inicializar conexion							
f_cc.ProcesaForm

for filai = 0 to f_cc.CuentaPost - 1

pers_nrut = f_cc.ObtenerValorPost (filai, "pers_nrut")
pare_ccod = f_cc.ObtenerValorPost (filai, "pare_ccod")

if pers_nrut<>"" and pare_ccod<>"" then
query="delete from ocag_perfiles_areas_usuarios where pers_nrut="&pers_nrut&" and pare_ccod='"&pare_ccod&"'"

'response.write(query&"<br>")'
'response.End()'
conexion.EjecutaS(query)
end if
next

response.Redirect(Request.ServerVariables("HTTP_REFERER"))'
%>
