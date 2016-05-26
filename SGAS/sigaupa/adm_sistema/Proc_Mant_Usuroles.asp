<!-- #include file = "../biblioteca/_conexion.asp" -->
<%

set conexion = new CConexion
conexion.Inicializar "upacifico"

set formulario = new CFormulario
formulario.Carga_Parametros "Mant_Usuroles.xml", "fconsultalarga"
formulario.Inicializar conexion
formulario.ProcesaForm
	
fecha = date()
for fila = 0 to formulario.CuentaPost - 1
   persona = formulario.ObtenerValorPost(fila, "pers_ncorr")	
   rol = formulario.ObtenerValorPost(fila, "srol_ncorr")
   asignar = formulario.ObtenerValorPost(fila, "tiene_rol")
   
   consulta = "DELETE FROM sis_roles_usuarios where pers_ncorr =" & persona & " and srol_ncorr=" & rol	
   conexion.EstadoTransaccion conexion.EjecutaS(consulta)

   if asignar = 1 then
	  consulta = "INSERT INTO sis_roles_usuarios (pers_ncorr, srol_ncorr, srus_fmodificacion) values ( " & persona & "," & rol & ",'" & fecha & "')"	
      conexion.EstadoTransaccion conexion.EjecutaS(consulta)
  end if
next
'formulario.ListarPost
'formulario.MantieneTablas false
'conexion.estadotransaccion false  'este es como un rollback cuando es false

response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>

