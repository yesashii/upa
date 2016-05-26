<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-------------------------------------------------------------------------------------------------
set f_enfermedades = new CFormulario
f_enfermedades.Carga_Parametros "ant_salud_familiar.xml", "datos_enfermos"
f_enfermedades.Inicializar conexion
f_enfermedades.ProcesaForm
v_enfp_ncorr = request("enfermo[0][enfp_ncorr]")     
	    if v_enfp_ncorr="" then
		v_enfp_ncorr =  conexion.consultaUno("execute obtenerSecuencia 'enfermedades_persona'")
		end if
		'----------------- INGRESO DEL PARENTESCO -----------------------------------------------------
		
		f_enfermedades.AgregaCampoPost "enfp_ncorr", v_enfp_ncorr
		f_enfermedades.MantieneTablas false


'conexion.estadotransaccion false
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

