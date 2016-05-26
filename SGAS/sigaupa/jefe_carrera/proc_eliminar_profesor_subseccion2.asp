<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file="../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_profesor = new CFormulario
f_profesor.Carga_Parametros "edicion_plan_acad.xml", "profesores"
f_profesor.Inicializar conexion
f_profesor.ProcesaForm

'---------------------------------------agregado para bloquear checkbox de profesores cuando estos tengan no nulo el campo bloque anexo
'--------------------------------------------Agregado por M. Sandoval 03-03-05---------------------------------------------------------
for i=0 to f_profesor.cuentaPost - 1
	anexo=f_profesor.obtenerValorPost(i,"bloq_anexo")
	if esVacio(anexo) then
	   bloq_ccod = f_profesor.obtenerValorPost(i,"bloq_ccod")	
	   pers_ncorr = f_profesor.obtenerValorPost(i,"pers_ncorr")	
	   consulta_delete="Delete from bloques_profesores where cast(bloq_ccod as varchar)='"&bloq_ccod&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"'"
	   conexion.ejecutaS consulta_delete
	else
		conexion.estadotransaccion false	
	    conexion.MensajeError "No se pudo eliminar por que ya es parte de un contrato "
	    response.Redirect(request.ServerVariables("HTTP_REFERER"))
	end if
next
'--------------------------------------------------------------------------------------------------------------------------------------
'f_profesor.MantieneTablas false
'response.End()

'-----------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>