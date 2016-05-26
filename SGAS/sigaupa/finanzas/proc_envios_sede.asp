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

audi_tusuario = negocio.ObtenerUsuario

'---------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "envios_sedes.xml", "f_enviar"
formulario.Inicializar conexion
formulario.ProcesaForm
formulario.AgregaCampoPost "eenv_ccod" , 2

'ACTUALIZO LOS DETALLES DEL INGRESO A 'ENVIADO'

formulario.MantieneTablas false
'conexion.estadotransaccion false  'roolback  
response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
