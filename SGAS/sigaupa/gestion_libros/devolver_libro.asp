<!-- #include file="../biblioteca/_conexion.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

pres_ncorr=request.Form("pres_ncorr")
libr_ncorr=request.Form("libr_ncorr")
bloq_ccod=request.Form("bloq_ccod")
estado_devolucion=request.Form("estado_devolucion")
observacion=request.Form("observacion")
diferencia_devolucion = request.Form("diferencia_devolucion")
opli_ccod=request.Form("ob[0][opli_ccod]")

set conectar = new cconexion
set formulario = new cformulario
conectar.inicializar "upacifico"

opli_tdesc = conectar.consultaUno("select opli_tdesc from observaciones_prestamos_libros where cast(opli_ccod as varchar)='"&opli_ccod&"'")

if opli_ccod="" then
	opli_ccod=0
	opli_tdesc=""
end if	

if (diferencia_devolucion="") then
diferencia_devolucion = 0
end if
'debemos actualizar el estado del libro en la tabla libros_clases con estado=1 para informar que ahora esta disponible
consulta_actualizacion = "Update libros_clases set libr_nestado=1 where cast(libr_ncorr as varchar)='"&libr_ncorr&"'"
'ahora debemos hacer una actualizacion en la tabla prestamos_libros para devolver el prestamo realizado
actualizar_prestamo = " Update prestamos_libros set pres_fdevolucion=getDate(), pres_estado_devolucion="&estado_devolucion&","&_
                      " pres_tobservacion_devolucion='"&opli_tdesc&"', opli_ccod_devolucion="&opli_ccod&", pres_nminutos_adelanto="&diferencia_devolucion&" where cast(pres_ncorr as varchar)='"&pres_ncorr&"'"

'response.Write(consulta_actualizacion)
'response.Write(actualizar_prestamo)
'response.End()
conectar.ejecutaS consulta_actualizacion
conectar.ejecutaS actualizar_prestamo
'response.End()
%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>