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
formulario.Carga_Parametros "Ingreso_Letras_Legalizadas.xml", "f_letras"
formulario.Inicializar conexion
formulario.ProcesaForm
formulario.AgregaCampoPost "edin_ccod" , 3
formulario.AgregaCampoPost "denv_fretorno" , date()
'formulario.ListarPost

'actualizar a "en cartera legalizada (3)" la letra
for fila = 0 to formulario.CuentaPost - 1
   letra = formulario.ObtenerValorPost (fila, "ding_ndocto")
   ting_ccod = formulario.ObtenerValorPost (fila, "ting_ccod")
   ingr_ncorr = formulario.ObtenerValorPost (fila, "ingr_ncorr")
   if letra = "" then
        formulario.EliminaFilaPost fila
   end if 
next
formulario.MantieneTablas false
response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
