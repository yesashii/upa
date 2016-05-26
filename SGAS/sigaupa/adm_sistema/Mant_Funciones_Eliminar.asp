<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set formulario = new CFormulario
formulario.Carga_Parametros "Mant_Funciones.xml", "f1"
formulario.Inicializar conexion
formulario.ProcesaForm
'formulario.ListarPost
formulario.agregacampopost "smet_ccod" ,"1"

for fila = 0 to formulario.CuentaPost - 1
   sfun_ccod = formulario.ObtenerValorPost (fila, "sfun_ccod")
   if sfun_ccod <> "" then
   else
	 formulario.EliminaFilaPost fila 
   end if
next


formulario.MantieneTablas false


'codigo = request.Form("modulos[0][smod_ccod]")
'conexion.estadotransaccion false  'este es como un rollback cuando es false
response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
