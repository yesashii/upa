<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
'for each x in request.form
	'response.Write("<br>"&x&"->"&request.Form(x)&"<br>")
'next

set conexion = new CConexion
conexion.Inicializar "upacifico"
'---------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "corregir_tarjetas.xml", "f_tarjeta"
formulario.Inicializar conexion
formulario.ProcesaForm
'formulario.ListarPost

ding_ndocto_ant=formulario.ObtenerValorPost (0,"ding_ndocto_ant")
ting_ccod_ant=formulario.ObtenerValorPost (0,"ting_ccod_ant")
ingr_ncorr=formulario.ObtenerValorPost (0,"ingr_ncorr")

ding_ndocto=formulario.ObtenerValorPost (0,"ding_ndocto")
ting_ccod=formulario.ObtenerValorPost (0,"ting_ccod")
fecha_pago=formulario.ObtenerValorPost (0,"DING_FDOCTO")

if ingr_ncorr="" then
	response.Write("Error al intentar modificar los datos")
	response.End()
else
	consulta = " UPDATE detalle_ingresos SET ding_ndocto = "& ding_ndocto & ", DING_FDOCTO='"&fecha_pago&"', ting_ccod='"&ting_ccod&"' "& vbCrLf &_
				"  WHERE ingr_ncorr="&ingr_ncorr&" and ding_ndocto="&ding_ndocto_ant &" and ting_ccod="&ting_ccod_ant 
end if
          

 conexion.EstadoTransaccion conexion.EjecutaS(consulta)
'formulario.MantieneTablas true
'conexion.estadotransaccion false  'roolback  
'response.Write("<hr>"&consulta)
'response.End()
'response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
//CerrarActualizar();
window.close();
window.opener.parent.top.location.reload();

</script>