<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set formulario = new CFormulario
formulario.Carga_Parametros "Mant_Permisos.xml", "fpermisos"
formulario.Inicializar conexion
formulario.ProcesaForm
'formulario.ListarPost
for fila = 0 to formulario.CuentaPost - 1
   srol_ncorr = formulario.ObtenerValorPost (fila, "srol_ncorr")
    if srol_ncorr = "" then
       formulario.EliminaFilaPost fila
	end if   
next   

formulario.MantieneTablas false
'conexion.estadotransaccion false  'roolback   
response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
