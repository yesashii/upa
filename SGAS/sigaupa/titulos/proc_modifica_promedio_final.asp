<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next
'response.End()

v_pers_ncorr	= request.Form("datos[0][pers_ncorr]")
v_promedio_final	= request.Form("datos[0][promedio_final]")
v_promedio_cambio	= request.Form("datos[0][promedio_cambio]")

set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

		SQL="UPDATE detalles_titulacion_carrera SET promedio_final  = "&v_promedio_cambio&", audi_tusuario='cambio por "&negocio.ObtenerUsuario&"',AUDI_FMODIFICACION = getdate() WHERE pers_ncorr="&v_pers_ncorr&" and promedio_final="&v_promedio_final&""
		conectar.EstadoTransaccion conectar.EjecutaS(SQL)
		'response.Write("<br>"&SQL)
		'response.End()
session("mensaje_error") = "Se Realizo el Cambio con Exito"
%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>


