<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "parametros.xml", "tabla"
f_consulta.Inicializar conexion
'----------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "depositos.xml", "f_depositos"
formulario.Inicializar conexion
formulario.ProcesaForm
'tengo que buscar si tienen detalles, si tienen no los elimino
cont = 0
for fila = 0 to formulario.CuentaPost - 1
  envi_ncorr = formulario.ObtenerValorPost (fila, "envi_ncorr")
  if envi_ncorr <> "" then
     SQL = "select count(envi_ncorr) as total from detalle_envios where envi_ncorr=" & envi_ncorr
	 f_consulta.consultar SQL
	 f_consulta.siguiente
	 documentos = f_consulta.ObtenerValor ("total")
	 if documentos = 0 then
        SQL = "delete from envios where envi_ncorr=" & envi_ncorr 
		conexion.EstadoTransaccion conexion.EjecutaS(SQL) 
	 else
	    cont =cont + 1
		cad = cad & envi_ncorr & "  "
	 end if	 
  end if
next 
if cont > 0 then
  mensage = " Los siguientes depósitos no se eliminaron porque contenían Documentos..." & "\n" & cad 
  session("mensajeError")= mensage
end if
'formulario.MantieneTablas false
response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
