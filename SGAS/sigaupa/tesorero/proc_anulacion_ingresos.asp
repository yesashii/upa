<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

'for each x in request.Form
'	response.Write("<br>"&x&"->"&request.Form(x))
'next

'response.End()

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede


set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede

if not cajero.TieneCajaAbierta then
	cajero.AsignarTipoCaja "1001"
	
	if not cajero.TieneCajaAbierta then
		conexion.MensajeError "No puede anular ingresos si no tiene una caja abierta."
		Response.Redirect("../lanzadera/lanzadera.asp")
	end if
end if


set f_ingreso = new CFormulario
f_ingreso.Carga_Parametros "anulacion_ingresos.xml", "ingreso"
f_ingreso.Inicializar conexion
f_ingreso.ProcesaForm


msj_error = ""
anular = false

for i_ = 0 to f_ingreso.CuentaPost - 1 
	v_eing_ccod = f_ingreso.ObtenerValorPost(i_, "eing_ccod")
	v_tipo_ingreso=f_ingreso.ObtenerValorPost(i_, "ting_ccod")

	if v_tipo_ingreso="15" then
		'response.Write("Anula Repactacion")
		sentencia = "exec ANULA_REPACTACION "&f_ingreso.ObtenerValorPost(i_, "ingr_nfolio_referencia")&", '" & negocio.ObtenerUsuario & "'"
	else
		sentencia = "exec anula_ingreso " & f_ingreso.ObtenerValorPost(i_, "ting_ccod") & " , " & f_ingreso.ObtenerValorPost(i_, "ingr_nfolio_referencia") & ", " & f_ingreso.ObtenerValorPost(i_, "pers_ncorr") & ", " & cajero.ObtenerCajaAbierta & ", '" & negocio.ObtenerUsuario & "'"
	end if	
'response.Write("<br>"&sentencia)
'conexion.EstadoTransaccion false
'response.End()


		v_salida_proc = conexion.ConsultaUno(sentencia)
		if v_salida_proc <> "" then
			v_det_errores = v_det_errores&" \n "&v_salida_proc
		end if
		anular = true
	
	'###################### ANULA BOLETA ASOCIADA ###############
		v_folio_referencia=f_ingreso.ObtenerValorPost(i_, "ingr_nfolio_referencia")
		sql_anula="Update boletas set ebol_ccod=3 where ingr_nfolio_referencia="&v_folio_referencia
		conexion.ejecutaS(sql_anula)
	'###################### ANULA BOLETA ASOCIADA ###############
next


if v_det_errores<>"" then
	conexion.EstadoTransaccion false
	session("mensaje_error")= "El o los ingresos no ha podido ser anulados por los siguientes motivos: \n\n "&v_det_errores
else
	session("mensaje_error")=" El o los ingresos han sido anulados correctamente. "
end if

'--------------------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
