<!-- #include file="../biblioteca/_conexion.asp" -->

<%
gpro_ncorr=request.Form("gpro_ncorr")

set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"


formulario.carga_parametros "grado_academico.xml", "agregar_grado"
formulario.inicializar conectar



formulario.procesaForm
if gpro_ncorr="" then
	gpro_ncorr=conectar.consultauno("execute obtenersecuencia 'grados_profesor'")
end if	
formulario.agregacampopost "gpro_ncorr", gpro_ncorr

formulario.mantienetablas false
%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>