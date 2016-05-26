<!-- #include file="../biblioteca/_conexion.asp" -->

<%
cudo_ncorr=request.Form("cudo_ncorr")

set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"


formulario.carga_parametros "experiancia_laboral.xml", "agregar_experiancia_laboral"
formulario.inicializar conectar



formulario.procesaForm
if cudo_ncorr="" then
	cudo_ncorr=conectar.consultauno("execute obtenersecuencia 'curriculum_docente'")
end if	
formulario.agregacampopost "cudo_ncorr", cudo_ncorr

formulario.mantienetablas false
'conectar.estadoTransaccion false
'response.End()
%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>