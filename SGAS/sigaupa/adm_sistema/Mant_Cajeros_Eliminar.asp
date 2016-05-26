<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set formulario = new CFormulario
formulario.Carga_Parametros "Mant_Cajeros.xml", "f_cajeros"
formulario.Inicializar conexion
formulario.ProcesaForm
'formulario.ListarPost

for fila = 0 to formulario.CuentaPost - 1
   caje_ccod = formulario.ObtenerValorPost (fila, "caje_ccod")
   if caje_ccod <> "" then
   else
	 formulario.EliminaFilaPost fila 
   end if
next


formulario.MantieneTablas false

'conexion.estadotransaccion false  'este es como un rollback cuando es false
response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
