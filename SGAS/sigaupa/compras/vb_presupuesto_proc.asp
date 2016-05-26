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
'LINEA			: 111
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

set f_solicitud = new cFormulario
f_solicitud.carga_parametros "vb_presupuesto.xml", "autoriza_solicitud_giro"
f_solicitud.inicializar conexion
f_solicitud.procesaForm

for fila = 0 to f_solicitud.CuentaPost - 1

	v_cod_solicitud	= f_solicitud.ObtenerValorPost (fila, "cod_solicitud")
	v_aprueba		= f_solicitud.ObtenerValorPost (fila, "aprueba")
	v_aprueba_r		= f_solicitud.ObtenerValorPost (fila, "aprueba_r")
	v_tsol_ccod		= f_solicitud.ObtenerValorPost (fila, "tsol_ccod")
	v_observaciones	= f_solicitud.ObtenerValorPost (fila, "asgi_tobservaciones")
	v_fecha_recepcion= f_solicitud.ObtenerValorPost (fila, "asgi_frecepcion_presupuesto")
	asgi_nestado	= f_solicitud.ObtenerValorPost (fila, "asgi_nestado")

	if v_cod_solicitud<>"" then
		
		if EsVacio(asgi_nestado) or asgi_nestado="" then
			asgi_nestado=1
		end if
	
		if v_aprueba="2" then
			' Rechaza la solicitud, Valores asgi_nestado (1= Aprobado, 3 = Rechazado, 5 = Observado)
						if asgi_nestado = "5" then
				vibo_ccod = 10
			else
				vibo_ccod=2
			end if

			' validar si es con observaciones o no
			f_solicitud.AgregaCampoFilaPost fila, "vibo_ccod", vibo_ccod
			f_solicitud.AgregaCampoFilaPost fila, "asgi_nestado", asgi_nestado
			f_solicitud.AgregaCampoFilaPost fila, "asgi_observaciones", v_observaciones
			f_solicitud.AgregaCampoFilaPost fila, "asgi_fautorizado", fecha_actual
		else
			' Aprueba la solicitud, estado 2 = aprobado presupuesto
			vibo_ccod=2
			f_solicitud.AgregaCampoFilaPost fila,"vibo_ccod", vibo_ccod
			f_solicitud.AgregaCampoFilaPost fila,"asgi_nestado", asgi_nestado
			f_solicitud.AgregaCampoFilaPost fila,"asgi_fautorizado", fecha_actual
		end if
		
		Select Case Cint(v_tsol_ccod)
			Case 1:
				sql_update	=	"update ocag_solicitud_giro set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&",ocag_frecepcion_presupuesto='"&v_fecha_recepcion&"' , ocag_baprueba_rector='"&v_aprueba_r&"' where sogi_ncorr="&v_cod_solicitud	
			Case 2:
				sql_update	=	"update ocag_reembolso_gastos set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&",ocag_frecepcion_presupuesto='"&v_fecha_recepcion&"' , ocag_baprueba_rector='"&v_aprueba_r&"' where rgas_ncorr="&v_cod_solicitud	
			Case 3:
				sql_update	=	"update ocag_fondos_a_rendir set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&",ocag_frecepcion_presupuesto='"&v_fecha_recepcion&"' , ocag_baprueba_rector='"&v_aprueba_r&"' where fren_ncorr="&v_cod_solicitud	
			Case 4:
				sql_update	=	"update ocag_solicitud_viatico set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&",ocag_frecepcion_presupuesto='"&v_fecha_recepcion&"' , ocag_baprueba_rector='"&v_aprueba_r&"' where sovi_ncorr="&v_cod_solicitud	
			Case 5:
				sql_update	=	"update ocag_devolucion_alumno set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&",ocag_frecepcion_presupuesto='"&v_fecha_recepcion&"' , ocag_baprueba_rector='"&v_aprueba_r&"' where dalu_ncorr="&v_cod_solicitud	
			Case 6:
				sql_update	=	"update ocag_fondo_fijo set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&",ocag_frecepcion_presupuesto='"&v_fecha_recepcion&"' , ocag_baprueba_rector='"&v_aprueba_r&"' where ffij_ncorr="&v_cod_solicitud
			Case 7:
				'sql_update	=	"update ocag_rendicion_fondos_a_rendir set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&",ocag_frecepcion_presupuesto='"&v_fecha_recepcion&"' , ocag_baprueba_rector='"&v_aprueba_r&"' where fren_ncorr="&v_cod_solicitud
				sql_update	=	"update ocag_rendicion_fondos_a_rendir set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&",ocag_frecepcion_presupuesto='"&v_fecha_recepcion&"' , ocag_baprueba_rector='"&v_aprueba_r&"' where rfre_ncorr="&v_cod_solicitud
			Case 8:
				'sql_update	=	"update ocag_rendicion_fondo_fijo set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&",ocag_frecepcion_presupuesto='"&v_fecha_recepcion&"' , ocag_baprueba_rector='"&v_aprueba_r&"' where ffij_ncorr="&v_cod_solicitud
				sql_update	=	"update ocag_rendicion_fondo_fijo set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&",ocag_frecepcion_presupuesto='"&v_fecha_recepcion&"' , ocag_baprueba_rector='"&v_aprueba_r&"' where rffi_ncorr="&v_cod_solicitud
			Case 9:
				sql_update	=	"update ocag_orden_compra set vibo_ccod="&vibo_ccod&",ocag_baprueba="&asgi_nestado&",ocag_frecepcion_presupuesto='"&v_fecha_recepcion&"' , ocag_baprueba_rector='"&v_aprueba_r&"' where ordc_ncorr="&v_cod_solicitud					
		End Select
		
		'response.Write(fila&" sql_update : "&sql_update&"<BR>")
		conexion.estadotransaccion  conexion.ejecutaS(sql_update)

		'v_cvso_ncorr=conexion.consultaUno("exec obtenersecuencia 'ocag_ciclo_vida_solicitud'")
		'sql_insert_ciclo=   "Insert into ocag_ciclo_vida_solicitud(cvso_ncorr, cod_solicitud,tsol_ccod,vibo_ccod,cvso_fvalida,audi_tusuario,audi_fmodificacion) "&_
		'					" Values("&v_cvso_ncorr&","&v_cod_solicitud&","&v_tsol_ccod&","&vibo_ccod&",'"&fecha_actual&"','"&v_usuario&"', getdate())"
		'response.Write(sql_insert_ciclo)
		'conexion.estadotransaccion  conexion.ejecutaS(sql_insert_ciclo)

		'RESPONSE.WRITE("1. sql_update : "&sql_update&"<BR>")
	    estado=asgi_nestado
	end if

next

'response.End()

f_solicitud.MantieneTablas false

'response.Write("<br/><b> 2: "&conexion.obtenerEstadoTransaccion&"</b>")
'conexion.estadotransaccion false
'response.Write("prueba"&estado)
'response.End()

v_estado_transaccion = conexion.ObtenerEstadoTransaccion
	
if v_estado_transaccion=false  then
'response.Write("<br>Todo MAL")
	session("mensaje_error")="No se pudo aprobar solicitud de giro.\nVuelva a intentarlo."
else	
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