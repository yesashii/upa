<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_postulante = new CFormulario
f_postulante.Carga_Parametros "genera_contrato_3.xml", "tabla_valores"
f_postulante.Inicializar conexion
f_postulante.ProcesaForm

v_post_ncorr = f_postulante.ObtenerValorPost(0, "post_ncorr")

sentencia = " EXEC genera_contrato '" & v_post_ncorr & "', '" & negocio.ObtenerSede & "' "
'response.Write(sentencia)
'RESPONSE.Write(SENTENCIA)
'RESPONSE.End()
conexion.ejecutapsql(sentencia)
'v_error_proc=conexion.ConsultaUno(sentencia)
'if v_error_proc>0 then
'	if v_error_proc =1 then
'		session("mensaje_error")=" Ocurrio un error inesperado al generar el contrato. No tiene simulación para la oferta especificada."
'	elseif v_error_proc=2 then
'		session("mensaje_error")=" Ocurrio un error inesperado al generar el contrato. \n Asegurece de tener un valor actualizado de la U.F."
'	elseif v_error_proc=3 then
'		session("mensaje_error")=" Ocurrio un error inesperado al generar el contrato. \n Se detecto que existen cheques que ya fueron enviados."
'	else
'		session("mensaje_error")=" Ocurrio un error inesperado al generar el contrato. \n El Postulante ya tiene un contrato vigente y activo."
'	end if
'session("mensaje_error")=session("mensaje_error") &"\n !! El contrato no fue Generado ¡¡"	
'	conexion.EstadoTransaccion false
'end if

'conexion.MensajeError(negocio.ObtenerErrorOracle(Err.Description))


'Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
'response.End()
%>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
   location.reload("genera_contrato_3.asp?post_ncorr=<%=v_post_ncorr%>") 
</script>
