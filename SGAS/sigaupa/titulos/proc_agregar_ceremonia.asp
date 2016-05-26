<!-- #include file = "../biblioteca/_conexion.asp" -->

<%

set conexion = new CConexion
conexion.Inicializar "upacifico"

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
id_ceremonia = request.Form("em[0][id_ceremonia]")

if id_ceremonia = "" then
	id_ceremonia = conexion.consultaUno("execute obtenerSecuencia 'ceremonias_titulacion'")
end if

set f_mantiene_carreras = new CFormulario
f_mantiene_carreras.Carga_Parametros "adm_fecha_ceremonia.xml", "mantiene_ceremonia"
f_mantiene_carreras.Inicializar conexion
f_mantiene_carreras.ProcesaForm
f_mantiene_carreras.agregacampopost "id_ceremonia", id_ceremonia

v_estado_transaccion = f_mantiene_carreras.MantieneTablas (false)

fecha = request.Form("em[0][fecha_ceremonia]")
id_ceremonia = request.Form("em[0][id_ceremonia]")

c_update_alumnos = "update detalles_titulacion_carrera set fecha_ceremonia=convert(datetime,'"&fecha&"',103) where cast(id_ceremonia as varchar)='"&id_ceremonia&"'"

conexion.ejecutaS c_update_alumnos

if v_estado_transaccion=false  then
	session("mensaje_error")="La ceremonia no pudo ser ingresada correctamente.\nVuelva a intentarlo."
else	
	session("mensaje_error")="La ceremonia fue ingresada correctamente."
end if
%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>
