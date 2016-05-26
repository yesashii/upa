<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

libr_ncorr=request.Form("libr_ncorr")
bloq_ccod=request.Form("bloq_ccod")
estado_prestamo=request.Form("estado_prestamo")
observacion=request.Form("observacion")
diferencia_prestamo=request.Form("diferencia_prestamo")

set conectar = new cconexion
set formulario = new cformulario
conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

usuario = negocio.obtenerUsuario

if diferencia_prestamo="" then
	diferencia_prestamo = 0
end if

if diferencia_prestamo < "1" and diferencia_prestamo >= "0" then
	estado_prestamo = "1"
end if

if diferencia_prestamo < "0" then
	estado_prestamo = "8"
end if

'debemos actualizar el estado del libro en la tabla libros clases con estado=2 para informar que ahora esta prestado
consulta_actualizacion = "Update libros_clases set libr_nestado=2 where cast(libr_ncorr as varchar)='"&libr_ncorr&"'"
pres_ncorr=conectar.consultauno("execute obtenersecuencia 'prestamos_libros'")
'ahora debemos hacer una inserción en la tabla prestamos_libros para este nuevo prestamo
consulta_insercion = " Insert into prestamos_libros (pres_ncorr,libr_ncorr,bloq_ccod,pres_fprestamo,pres_estado_prestamo,"&_
                     " pres_tobservacion_prestamo,pres_nminutos_atraso,pres_fdevolucion,pres_estado_devolucion,pres_tobservacion_devolucion,pres_nminutos_adelanto,audi_tusuario,audi_fmodificacion,prestamo_correcto) values "&_
					 " ("&pres_ncorr&","&libr_ncorr&","&bloq_ccod&",getDate(),1,'"&observacion&"',"&diferencia_prestamo&",null,null,'',null,'prestado por "&usuario&"' ,getDate(),'S') "
'response.Write(consulta_insercion&"<br>")
'response.End()
'response.Write("1 "&conectar.obtenerestadotransaccion)
conectar.ejecutaS consulta_actualizacion
'response.Write("2 "&conectar.obtenerestadotransaccion)
conectar.ejecutaS consulta_insercion
'response.Write("3 "&conectar.obtenerestadotransaccion)
'response.End()
%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>