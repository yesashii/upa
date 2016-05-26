<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()


'------------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

'conexion.EstadoTransaccion false

set f_salidas = new CFormulario
f_salidas.Carga_Parametros "adm_titulados.xml", "salidas_alumnos"
f_salidas.Inicializar conexion
f_salidas.ProcesaForm

for i_ = 0 to f_salidas.CuentaPost - 1
	pers_ncorr = f_salidas.ObtenerValorPost(i_, "pers_ncorr")
	sapl_ncorr = f_salidas.ObtenerValorPost(i_, "sapl_ncorr")
	if pers_ncorr <> "" and sapl_ncorr <> "" then
		consulta = "delete from salidas_alumnos where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(sapl_ncorr as varchar)='"&sapl_ncorr&"'"
		plan_ccod = conexion.consultaUno("select plan_ccod from salidas_plan where cast(sapl_ncorr as varchar)='"&sapl_ncorr&"'")
        tiene_detalle = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from detalles_titulacion where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(plan_ccod as varchar)='"&plan_ccod&"'")		
	end if
next
	if tiene_detalle = "S" then
		conexion.MensajeError "Imposible eliminar el registro del alumno, ya existe información adicional de su egreso y titulación"	
		response.Redirect(request.ServerVariables("HTTP_REFERER"))
	else
	    conexion.ejecutaS consulta 	
		%>
		<script language="javascript" src="../biblioteca/funciones.js"></script>
		<script language="javascript">
		CerrarActualizar();
		</script>
		<%
	end if

'response.End()
%>

