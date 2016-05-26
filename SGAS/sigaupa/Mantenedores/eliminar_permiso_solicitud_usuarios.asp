<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario = negocio.ObtenerUsuario()

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()

pers_nrut=request.form("b[0][pers_nrut]")
tsol_ccod=request.form("b[0][tsol_ccod]")

set f_cc = new cformulario
f_cc.carga_parametros "permisos_solicitudes_oc.xml", "elimina_permiso_solicitud" 
f_cc.inicializar conexion							
f_cc.ProcesaForm

for filai = 0 to f_cc.CuentaPost - 1
	pers_nrut = f_cc.ObtenerValorPost (filai, "pers_nrut")
	tsol_ccod = f_cc.ObtenerValorPost (filai, "tsol_ccod")

	if pers_nrut<>"" and tsol_ccod<>"" then
		query="delete from ocag_permisos_solicitudes_usuarios where pers_nrut="&pers_nrut&" and tsol_ccod='"&tsol_ccod&"'"
		'response.Write(query)
		conexion.EjecutaS(query)
	end if
next
'response.End()
response.Redirect(Request.ServerVariables("HTTP_REFERER"))'
%>