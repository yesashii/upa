<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'----------------------------------------------------------------------------------------------------
set f_permisos = new CFormulario
f_permisos.Carga_Parametros "exp_tit_permisos_carrera.xml", "t_permisos"
f_permisos.Inicializar conexion
f_permisos.ProcesaForm

f_permisos.AgregaCampoPost "carr_ccod", request.Form("carr_ccod")
f_permisos.MantieneTablas false
'response.End()


response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
