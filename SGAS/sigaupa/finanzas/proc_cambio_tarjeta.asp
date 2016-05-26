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


pacta_cuota=formulario.ObtenerValorPost (0,"pacta_cuota")
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


if pacta_cuota="1" then
	sql_datos_compromisos="select * from abonos where ingr_ncorr="&ingr_ncorr
	
	set datos_compromiso = new CFormulario
	datos_compromiso.carga_parametros "consulta.xml", "consulta"
	datos_compromiso.Inicializar conexion	
	datos_compromiso.Consultar sql_datos_compromisos
		
		while datos_compromiso.Siguiente
		
				v_comp_ndocto		=	datos_compromiso.ObtenerValor("comp_ndocto")
				v_tcom_ccod			=	datos_compromiso.ObtenerValor("tcom_ccod")
				v_dcom_ncompromiso	=	datos_compromiso.ObtenerValor("dcom_ncompromiso")
				v_inst_ccod			=	datos_compromiso.ObtenerValor("inst_ccod")
				
				sql_update_dcomp="update detalle_compromisos set dcom_fcompromiso='"&fecha_pago&"' "& vbCrLf &_
								 " where comp_ndocto="&v_comp_ndocto&" and tcom_ccod="&v_tcom_ccod&" " & vbCrLf &_
								 " and inst_ccod="&v_inst_ccod&" and dcom_ncompromiso="&v_dcom_ncompromiso&" "
 				
				conexion.EstadoTransaccion conexion.EjecutaS(sql_update_dcomp)
			'response.Write("<pre>"&sql_update_dcomp&"</pre>")  
		wend
		
end if

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