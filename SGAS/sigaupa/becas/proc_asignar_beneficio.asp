<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next
'response.End()

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-------------------------------------------------------------------------------------------------
set f_beneficios = new CFormulario
f_beneficios.Carga_Parametros "listado_postulaciones_becas.xml", "datos_asignacion"
f_beneficios.Inicializar conexion
f_beneficios.ProcesaForm
pobe_ncorr = request("pobe_ncorr")     
if pobe_ncorr <>"" then			
	f_beneficios.AgregaCampoPost "pobe_ncorr", pobe_ncorr
	f_beneficios.MantieneTablas false
end if

conexion.estadotransaccion true
'response.End()
'---------------------------------------------------------------------------------------------------------------
'Response.Redirect("postulacion_4.asp")
%>
<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript" >
CerrarActualizar();
</script>

