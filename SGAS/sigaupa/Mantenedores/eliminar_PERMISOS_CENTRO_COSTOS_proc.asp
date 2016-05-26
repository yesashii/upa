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
'Uresponse.End()'

pers_nrut=request.form("b[0][pers_nrut]")
ccod_tcodigo=request.form("b[0][ccos_tcodigo]")


set f_cc = new cformulario
f_cc.carga_parametros "centro_costo_compra.xml", "elimina_permiso_cc" 
f_cc.inicializar conexion							
f_cc.ProcesaForm

for filai = 0 to f_cc.CuentaPost - 1

pers_nrut = f_cc.ObtenerValorPost (filai, "pers_nrut")
ccod_tcodigo = f_cc.ObtenerValorPost (filai, "ccos_tcodigo")

if pers_nrut<>"" and ccod_tcodigo<>"" then
query="delete from ocag_permisos_centro_costo where pers_nrut="&pers_nrut&" and ccos_tcodigo='"&ccod_tcodigo&"'"

'response.write(query&"<br>")'
conexion.EjecutaS(query)
end if
next
'response.End()'
response.Redirect(Request.ServerVariables("HTTP_REFERER"))'
%>
