<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "desauas"

'----------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "editar_malla.xml", "f_detalle_homologacion"
formulario.Inicializar conexion
formulario.ProcesaForm
'formulario.listarpost

for fila = 0 to formulario.CuentaPost - 1
   homo_ccod = formulario.ObtenerValorPost (fila, "homo_ccod")
  if homo_ccod <> "" then
  else
     formulario.EliminaFilaPost fila 	 
  end if
next 
formulario.MantieneTablas false
'conexion.estadotransaccion false  'roolback 
response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
