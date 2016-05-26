<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario = negocio.ObtenerUsuario()

'for each k in request.form'
'	response.write(k&"="&request.Form(k)&"<br>")'
'next'
'response.End()

pers_nrut=request.form("b[0][pers_nrut]")
rusu_ccod=request.form("b[0][rusu_ccod]")


set f_cc = new cformulario
f_cc.carga_parametros "roles_compra.xml", "elimina_permiso_roles" 
f_cc.inicializar conexion							
f_cc.ProcesaForm

for filai = 0 to f_cc.CuentaPost - 1

	pers_nrut = f_cc.ObtenerValorPost (filai, "pers_nrut")
	rusu_ccod = f_cc.ObtenerValorPost (filai, "rusu_ccod")

	if pers_nrut<>"" and rusu_ccod<>"" then
		query="delete from ocag_permisos_roles_usuarios where pers_nrut="&pers_nrut&" and rusu_ccod='"&rusu_ccod&"'"
		
		'response.write(query&"<br>")'
		conexion.EjecutaS(query)
	end if
next
'response.End()'
response.Redirect(Request.ServerVariables("HTTP_REFERER"))'
%>
