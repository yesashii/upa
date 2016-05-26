<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_director = new CFormulario
f_director.Carga_Parametros "adm_directores_carrera.xml", "edicion_director"
f_director.Inicializar conexion
f_director.ProcesaForm
f_director.MantieneTablas false
'conexion.estadoTransaccion false
'response.End()
%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>
