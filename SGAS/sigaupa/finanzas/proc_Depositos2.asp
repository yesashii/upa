<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new Cnegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "parametros.xml", "tabla"
f_consulta.Inicializar conexion
'---------------------------------------------------------------------

audi_tusuario = negocio.ObtenerUsuario

set formulario = new CFormulario
formulario.Carga_Parametros "Depositos.xml", "f_depositar"
formulario.Inicializar conexion
formulario.ProcesaForm
formulario.AgregaCampoPost "eenv_ccod" , 2
'formulario.ListarPost

for fila = 0 to formulario.CuentaPost - 1
   envio = formulario.ObtenerValorPost (fila, "envi_ncorr")
   if envio <> "" then
      SQL = "select count(a.envi_ncorr) as total_doc from envios a,  detalle_envios b where a.envi_ncorr = b.envi_ncorr "&_  
            "and a.envi_ncorr =" & envio
	   f_consulta.consultar  SQL
	   f_consulta.siguiente
	   cantidad = f_consulta.ObtenerValor("total_doc") 
	   if cantidad <> 0 then
	 	  consulta = "UPDATE detalle_envios SET edin_ccod = 12, AUDI_TUSUARIO='" & audi_tusuario  & "', audi_fmodificacion = sysdate  WHERE envi_ncorr='" & envio & "'"
          conexion.EstadoTransaccion conexion.EjecutaS(consulta)
		  consulta = "UPDATE detalle_ingresos SET edin_ccod = 12, AUDI_TUSUARIO='" & audi_tusuario  & "', audi_fmodificacion = sysdate  WHERE envi_ncorr='" & envio & "'"
          conexion.EstadoTransaccion conexion.EjecutaS(consulta)		  
	   else
	     formulario.EliminaFilaPost fila 
	   end if
	end if 
  next
formulario.MantieneTablas false
'conexion.estadotransaccion false  'roolback  
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
