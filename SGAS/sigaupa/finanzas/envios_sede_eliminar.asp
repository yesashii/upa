<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
'for each x in request.Form
'	response.Write(x&"->"&request.Form(x)&"<br>")
'next
'response.End()

set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_consulta = new CFormulario
f_consulta.Carga_Parametros "parametros.xml", "tabla"
f_consulta.Inicializar conexion
'----------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "envios_sedes.xml", "f_envios"
formulario.Inicializar conexion
formulario.ProcesaForm
'tengo que buscar si tienen detalles, si tienen no los elimino
cont = 0
for fila = 0 to formulario.CuentaPost - 1
  esed_ncorr = formulario.ObtenerValorPost (fila, "esed_ncorr")
  if esed_ncorr <> "" then
     SQL = "select count(esed_ncorr) as total from detalle_envios_sedes where esed_ncorr=" & esed_ncorr
	 f_consulta.consultar SQL
	 f_consulta.siguiente
	 documentos = f_consulta.ObtenerValor ("total")
	 if documentos = 0 then
        SQL = "delete from envios_sedes where esed_ncorr=" & esed_ncorr 
		conexion.EstadoTransaccion conexion.EjecutaS(SQL) 
	 else
	    cont =cont + 1
		cad = cad & esed_ncorr & "  "
	 end if	 
  end if
next 
if cont > 0 then
  mensage = " Los siguientes envios no se eliminaron porque contenían documentos asociados..." & "\n" & cad 
  session("mensajeError")= mensage
end if
'formulario.MantieneTablas true
response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
