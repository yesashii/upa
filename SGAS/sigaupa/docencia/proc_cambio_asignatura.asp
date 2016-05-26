<!--Versión 1.0 creada por Sinezio da Silva fecha 22-05-2015 supervisionada por Michael Shaw
hay tres paginas que estan viculadas a este XML cambio_asignatura.xml, modifica_asignatura y cambio_asignatura.asp todos los archivos estan dentro del directorio "docencia"-->

<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next
'response.End()
'---------------------------------------------

BLOQ_CCOD	= request.Form("test[0][BLOQ_CCOD]")
HORA_CCOD	= request.Form("test[0][HORA_CCOD]")
SALA_CCOD	= request.Form("test[0][SALA_CCOD]")
DIAS_CCOD	= request.Form("test[0][DIAS_CCOD]")

set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set formulario = new CFormulario
formulario.Carga_Parametros "cambio_asignatura.xml", "datos_formulario"
formulario.ProcesaForm
rut_usuario = negocio.ObtenerUsuario


if BLOQ_CCOD <> "" and  HORA_CCOD<> "" and SALA_CCOD<> "" then

sql1="update bloques_horarios set dias_ccod = "&DIAS_CCOD&",hora_ccod='"&HORA_CCOD&"',sala_ccod='"&SALA_CCOD&"', AUDI_TUSUARIO='"&rut_usuario&"', AUDI_FMODIFICACION=getdate()  WHERE  bloq_ccod in("&BLOQ_CCOD&")"


conectar.EstadoTransaccion conectar.EjecutaS(sql1)


end if





session("mensaje_error") = "Se Realizo el Cambio con Exito"

%>
<script language = "javascript" src = "../biblioteca/funciones.js" ></script>
<script languaje= "javascript">
CerrarActualizar();
</script>

