<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "desauas"

'set f_consulta = new CFormulario
'f_consulta.Carga_Parametros "parametros.xml", "tabla"
'f_consulta.Inicializar conexion
'----------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "editar_malla.xml", "f_homologaciones"
formulario.Inicializar conexion
formulario.ProcesaForm
'formulario.listarpost

for fila = 0 to formulario.CuentaPost - 1
  homo_ccod = formulario.ObtenerValorPost (fila, "homo_ccod")
  if homo_ccod <> "" then
     sql = "DELETE FROM homologacion_fuente WHERE homo_ccod=" & homo_ccod
	 response.Write("<BR>" & sql)
	 conexion.EstadoTransaccion conexion.EjecutaS(sql)
	 sql = "DELETE FROM homologacion_destino WHERE homo_ccod=" & homo_ccod
 	 response.Write("<BR>" & sql)
	 conexion.EstadoTransaccion conexion.EjecutaS(sql)
  else
     formulario.EliminaFilaPost fila 	 
  end if
next 
formulario.MantieneTablas false
'conexion.estadotransaccion false  'roolback 
response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
