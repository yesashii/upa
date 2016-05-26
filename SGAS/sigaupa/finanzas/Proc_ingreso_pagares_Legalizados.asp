<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"
'---------------------------------------------------------------------
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "parametros.xml", "tabla"
f_consulta.Inicializar conexion
'---------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "Ingreso_Pagares_Legalizados.xml", "f_letras"
formulario.Inicializar conexion
formulario.ProcesaForm
formulario.AgregaCampoPost "epag_ccod" , 3
formulario.AgregaCampoPost "depa_fretorno" , date()
'formulario.ListarPost

'actualizar a "en cartera legalizada (3)" la letra
for fila = 0 to formulario.CuentaPost - 1
   paga_ncorr = formulario.ObtenerValorPost (fila, "paga_ncorr")
   'ting_ccod = formulario.ObtenerValorPost (fila, "ting_ccod")
   enpa_ncorr = formulario.ObtenerValorPost (fila, "enpa_ncorr")
   if enpa_ncorr = "" then
        formulario.EliminaFilaPost fila
   end if 
next


	formulario.MantieneTablas false

'conexion.estadotransaccion false  'roolback  
response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
