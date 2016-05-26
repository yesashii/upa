<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

'response.End()

v_cuenta			=	request.Form("em[0][cuenta]")
v_nom_cuenta		=	request.Form("em[0][nombre_cuenta_soft]")
v_control_doc		=	request.Form("em[0][usa_controla_doc]")
v_centro_costo		=	request.Form("em[0][usa_centro_costo]")
v_auxiliar			=	request.Form("em[0][usa_auxiliar]")
v_det_gasto			=	request.Form("em[0][usa_detalle_gasto]")
v_conciliacion		=	request.Form("em[0][usa_conciliacion]")
v_pto_caja			=	request.Form("em[0][usa_pto_caja]")
v_csof_ncorr		=	request.Form("em[0][csof_ncorr]")
v_inserta			=	request.Form("inserta")


set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


set f_mantiene_carreras = new CFormulario
f_mantiene_carreras.Carga_Parametros "adm_cuentas.xml", "mantiene_cuentas"
f_mantiene_carreras.Inicializar conexion
f_mantiene_carreras.ProcesaForm

if v_inserta ="1" then
'obtiene secuencia
	v_csof_ncorr=conexion.consultaUno("exec obtenersecuencia 'cuentas_softland' ")
	sql_carrera= " Insert Into cuentas_softland (csof_ncorr, cuenta, nombre_cuenta, usa_controla_doc, usa_centro_costo, usa_auxiliar, usa_detalle_gasto,usa_conciliacion, usa_pto_caja, AUDI_FMODIFICACION, AUDI_TUSUARIO) " &_
				" Values ("&v_csof_ncorr&", '"&v_cuenta&"','"&v_nom_cuenta&"','"&v_control_doc&"','"&v_centro_costo&"','"&v_auxiliar&"','"&v_det_gasto&"','"&v_conciliacion&"', '"&v_pto_caja&"',getdate(), '"&negocio.ObtenerUsuario&"')"
else
	sql_carrera= " Update cuentas_softland set cuenta='"&v_cuenta&"',nombre_cuenta='"&v_nom_cuenta&"',usa_controla_doc='"&v_control_doc&"', "&_
				" usa_centro_costo='"&v_centro_costo&"',usa_auxiliar='"&v_auxiliar&"',usa_detalle_gasto='"&v_det_gasto&"',usa_conciliacion='"&v_conciliacion&"'," &_
				" usa_pto_caja='"&v_pto_caja&"',AUDI_FMODIFICACION=getdate(),AUDI_TUSUARIO='"&negocio.ObtenerUsuario&"' "&_
				" where csof_ncorr="&v_csof_ncorr
end if

'response.Write("<br>"&sql_carrera&"<br>")
'response.End()
v_estado_transaccion=conexion.ejecutaS(sql_carrera)

'v_estado_transaccion=f_mantiene_carreras.MantieneTablas (true)
'response.Write("<br><b>estado:</b>"&conexion.obtenerEstadoTransaccion)


if v_estado_transaccion=false  then
'response.Write("<br>Todo MAL")
	session("mensaje_error")="La cuenta no pudo ser ingresada correctamente.\nVuelva a intentarlo."
else	
'response.Write("<br>Todo bien")
	session("mensaje_error")="La cuenta fue ingresada correctamente."
end if

'conexion.estadoTransaccion false
'response.End()

response.Redirect(request.ServerVariables("HTTP_REFERER"))



%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
	//self.opener.location.reload();
	//window.close();
</script>
