<!-- #include file="../biblioteca/_conexion.asp" -->

<%
cpro_ncorr=request.Form("cpro_ncorr")

set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"


formulario.carga_parametros "capacitacion_docente.xml", "agregar_capacitacion"
formulario.inicializar conectar



formulario.procesaForm
if cpro_ncorr="" then
	cpro_ncorr=conectar.consultauno("execute obtenersecuencia 'capacitacion_profesor'")
end if	
formulario.agregacampopost "cpro_ncorr", cpro_ncorr

formulario.mantienetablas false
%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>