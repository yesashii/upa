<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
usuario = negocio.obtenerUsuario
'---------------------------------------------------------------------
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "parametros.xml", "tabla"
f_consulta.Inicializar conexion
'---------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "Letras_devueltas_notaria.xml", "f_letras"
formulario.Inicializar conexion
formulario.ProcesaForm
formulario.AgregaCampoPost "edin_ccod" , 50
formulario.AgregaCampoPost "denv_fretorno" , conexion.consultaUno("Select getDate()")
'formulario.ListarPost

'actualizar a "en devuelta por notaria (50)" la letra
for fila = 0 to formulario.CuentaPost - 1
   letra = formulario.ObtenerValorPost (fila, "ding_ndocto")
   ting_ccod = formulario.ObtenerValorPost (fila, "ting_ccod")
   ingr_ncorr = formulario.ObtenerValorPost (fila, "ingr_ncorr")
   envi_ncorr = formulario.ObtenerValorPost (fila, "envi_ncorr")
   
   if ingr_ncorr <> "" and letra <> "" then
   		consulta = "update detalle_ingresos set edin_ccod = 1,AUDI_TUSUARIO = '"&usuario&"',	AUDI_FMODIFICACION = getdate() where DING_NDOCTO ="&letra&" and INGR_NCORR ="&ingr_ncorr&" and TING_CCOD ="&ting_ccod&" and envi_ncorr ="&envi_ncorr&""		
		response.Write(consulta)
		conexion.ejecutaS consulta
  end if
   
   if letra = "" then
        formulario.EliminaFilaPost fila
   end if 
next
'formulario.MantieneTablas false
'response.End()
'conexion.estadotransaccion false  'roolback  
response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
