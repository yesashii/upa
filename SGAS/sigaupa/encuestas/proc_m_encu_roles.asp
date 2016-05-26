<!-- #include file = "../biblioteca/_conexion.asp" -->
<%

set conexion = new CConexion
conexion.Inicializar "upacifico"

set formulario = new CFormulario
formulario.Carga_Parametros "m_encu_roles.xml", "fconsultalarga"
formulario.Inicializar conexion
formulario.ProcesaForm
	
fecha = date()
for fila = 0 to formulario.CuentaPost - 1
   encuesta = formulario.ObtenerValorPost(fila, "encu_ncorr")	
   rol = formulario.ObtenerValorPost(fila, "srol_ncorr")
   asignar = formulario.ObtenerValorPost(fila, "tiene_rol")
   
   consulta = "DELETE FROM roles_encuestas where cast(encu_ncorr as varchar)='" & encuesta & "' and cast(srol_ncorr as varchar)='" &rol&"'"	
   conexion.EstadoTransaccion conexion.EjecutaS(consulta)

   if asignar = 1 then
	  consulta = "INSERT INTO roles_encuestas (encu_ncorr, srol_ncorr, srus_fmodificacion) values ( " & encuesta & "," & rol & ",'" & fecha & "')"	
      conexion.EstadoTransaccion conexion.EjecutaS(consulta)
  end if
next
'formulario.ListarPost
'formulario.MantieneTablas false
'conexion.estadotransaccion false  'este es como un rollback cuando es false

response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>

