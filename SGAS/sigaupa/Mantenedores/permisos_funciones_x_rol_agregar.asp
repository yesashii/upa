<!-- #include file = "../biblioteca/_conexion.asp" -->
<%

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

set conexion = new CConexion
conexion.Inicializar "upacifico"

set formulario = new CFormulario
formulario.Carga_Parametros "Mant_Permisos_OC.xml", "f1"
formulario.Inicializar conexion
formulario.ProcesaForm
'formulario.listarpost
for fila = 0 to formulario.CuentaPost - 1
   sfun_ccod = formulario.ObtenerValorPost (fila, "sfun_ccod")
    if sfun_ccod = "" then
       formulario.EliminaFilaPost fila
	end if   
next   

formulario.MantieneTablas false
'conexion.estadotransaccion false  'como un roolback
'response.End()
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>

