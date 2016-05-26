<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO:COMPRAS Y AUT. DE GIRO
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:26/05/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ORDEN DE COMPRA
'LINEA			:120
'*******************************************************************
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()
fecha_actual=conexion.consultaUno("select protic.trunc(getDate())")

set f_validacion = new cFormulario
f_validacion.carga_parametros "validacion_contable.xml", "detalle_pago_validacion"
f_validacion.inicializar conexion
f_validacion.procesaForm

set f_solicitud = new cFormulario
f_solicitud.carga_parametros "vb_finanzas.xml", "autoriza_solicitud_giro"
f_solicitud.inicializar conexion
f_solicitud.procesaForm

for fila = 0 to f_solicitud.CuentaPost - 1

	v_cod_solicitud	= f_solicitud.ObtenerValorPost (fila, "cod_solicitud")
	v_aprueba		= f_solicitud.ObtenerValorPost (fila, "aprueba")
	v_tsol_ccod		= f_solicitud.ObtenerValorPost (fila, "tsol_ccod")
	v_observaciones	= f_solicitud.ObtenerValorPost (fila, "asgi_tobservaciones")
	asgi_nestado	= f_solicitud.ObtenerValorPost (fila, "asgi_nestado")

	if v_cod_solicitud<>"" then

		if EsVacio(asgi_nestado) or asgi_nestado="" then
			asgi_nestado=1
		end if
	
		if v_aprueba="2" then
			' Rechaza la solicitud, Valores asgi_nestado (1= Aprobado, 3 = Rechazado, 5 = Observado)
			' validar si es con observaciones o no
			if asgi_nestado = "5" then
				vibo_ccod = 10
			else
				vibo_ccod=4
			end if
			f_solicitud.AgregaCampoFilaPost fila, "vibo_ccod", vibo_ccod
			f_solicitud.AgregaCampoFilaPost fila, "asgi_nestado", asgi_nestado
			f_solicitud.AgregaCampoFilaPost fila, "asgi_observaciones", v_observaciones
			f_solicitud.AgregaCampoFilaPost fila, "asgi_fautorizado", fecha_actual		
			
		else
			' Aprueba la solicitud, estado finanzas 4 = aprobado finanzas
			vibo_ccod=4
			f_solicitud.AgregaCampoFilaPost fila,"vibo_ccod", vibo_ccod
			f_solicitud.AgregaCampoFilaPost fila,"asgi_nestado", asgi_nestado
			f_solicitud.AgregaCampoFilaPost fila,"asgi_fautorizado", fecha_actual
		end if
		
		Select Case Cint(v_tsol_ccod)
			Case 1:
				sql_update	=	"update ocag_solicitud_giro set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&" where sogi_ncorr="&v_cod_solicitud	
			Case 2:
				sql_update	=	"update ocag_reembolso_gastos set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&" where rgas_ncorr="&v_cod_solicitud	
			Case 3:
				sql_update	=	"update ocag_fondos_a_rendir set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&" where fren_ncorr="&v_cod_solicitud	
			Case 4:
				sql_update	=	"update ocag_solicitud_viatico set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&" where sovi_ncorr="&v_cod_solicitud	
			Case 5:
				sql_update	=	"update ocag_devolucion_alumno set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&" where dalu_ncorr="&v_cod_solicitud	
			Case 6:
				sql_update	=	"update ocag_fondo_fijo set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&" where ffij_ncorr="&v_cod_solicitud
			Case 7:
				'sql_update	=	"update ocag_rendicion_fondos_a_rendir set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&" where fren_ncorr="&v_cod_solicitud
				sql_update	=	"update ocag_rendicion_fondos_a_rendir set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&" where rfre_ncorr="&v_cod_solicitud
			Case 8:
				'sql_update	=	"update ocag_rendicion_fondo_fijo set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&" where ffij_ncorr ="&v_cod_solicitud				
				sql_update	=	"update ocag_rendicion_fondo_fijo set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&" where rffi_ncorr ="&v_cod_solicitud		
			Case 9:
				sql_update	=	"update ocag_orden_compra set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&" where ordc_ncorr="&v_cod_solicitud					
		End Select
		'response.Write(sql_update)
		conexion.estadotransaccion  conexion.ejecutaS(sql_update)

		estado = asgi_nestado
	end if

next

f_solicitud.MantieneTablas false

for fila = 0 to f_solicitud.CuentaPost - 1
	v_dpva_ncorr	= f_solicitud.ObtenerValorPost (fila, "dpva_ncorr")
	v_vcon_ncorr		= f_solicitud.ObtenerValorPost (fila, "vcon_ncorr")
	v_fecha_propuesta	= f_solicitud.ObtenerValorPost (fila, "asgi_fpropuesta_finanzas")

	if v_dpva_ncorr<>"" then
		f_validacion.AgregaCampoFilaPost fila,"dpva_fpago", v_fecha_propuesta
	end if

next
f_validacion.MantieneTablas false

'response.Write("<br/><b> 2: "&conexion.obtenerEstadoTransaccion&"</b>")
'conexion.estadotransaccion false
'response.End()

v_estado_transaccion = conexion.ObtenerEstadoTransaccion
	
if v_estado_transaccion=false  then
'response.Write("<br>Todo MAL")
	session("mensaje_error")="No se pudo aprobar solicitud de giro.\nVuelva a intentarlo."
else	
'response.Write("<br>Todo bien"&asgi_nestado)
	if estado = 1 then
'response.Write("<br>Todo bien"&estado)
			session("mensaje_error")="La solicitud fue aprobada correctamente."
		else
			session("mensaje_error")="La solicitud fue rechazada correctamente."
		end if
end if
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>