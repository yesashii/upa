<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
For each k in request.form
	'response.Write(k&" = "&request.Form(k)&"<br>")
	
	cadena=left(k,8)
	if cadena="detalle[" then
			inicio=InStr(k,"[")
			fin=InStr(k,"]")
			valor=(fin-inicio)-1
			'response.Write(valor&"<br>")
			cadena2=Mid(k,inicio+1,valor)
			'response.Write(cadena2&"<br>")
			cadena3=cadena2
			if (cadena3>cadena2) then
				valor_final=cadena3
			else
				valor_final=cadena2
			end if
	end if
	'response.write("valor_final: "&valor_final&"<br>")
next
'Response.End()

v_fren_ncorr	= 	request.Form("datos[0][fren_ncorr]")
v_rfre_ncorr	= 	request.Form("rfre_ncorr")
v_diferencia	=	request.Form("diferencia")
v_responsable	= 	request.Form("busqueda[0][responsable]")
v_rendicion		=	request.Form("rendicion")
v_presupuesto	=	request.Form("total_presupuesto")
v_pers_nrut		=	request.Form("pers_nrut")
v_solicita		=	request.Form("solicita_dev")
v_tipo_gasto	= 	request.Form("devolucion[0][tgas_ccod]")

prueba=request.querystring("prueba")

'RESPONSE.WRITE("01 v_fren_ncorr. "&v_fren_ncorr&"<BR>")
'RESPONSE.WRITE("02 v_rfre_ncorr. "&v_rfre_ncorr&"<BR>")
'RESPONSE.WRITE("03 v_diferencia. "&v_diferencia&"<BR>")
'RESPONSE.WRITE("04 v_responsable. "&v_responsable&"<BR>")
'RESPONSE.WRITE("05 v_rendicion. "&v_rendicion&"<BR>")
'RESPONSE.WRITE("06 v_presupuesto. "&v_presupuesto&"<BR>")
'RESPONSE.WRITE("07 v_pers_nrut. "&v_pers_nrut&"<BR>")
'RESPONSE.WRITE("08 v_solicita. "&v_solicita&"<BR>")
'RESPONSE.WRITE("09 v_tipo_gasto. "&v_tipo_gasto&"<BR>")
'RESPONSE.WRITE("10 prueba. "&prueba&"<BR>")

'response.End()

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()

set f_solicitud = new cFormulario
f_solicitud.carga_parametros "rendicion_fondo_rendir.xml", "datos_solicitud"
f_solicitud.inicializar conexion
f_solicitud.procesaForm

v_usuario=negocio.ObtenerUsuario()
fecha_actual=conexion.consultaUno("select protic.trunc(getDate())")

'**************************** SE ELIMINAN LOS DETALLES ANTERIORES Y SE INGRESAN LOS NUEVOS DETALLES *************
v_cantidad= f_solicitud.CuentaPost

'RESPONSE.WRITE("10. "&v_cantidad&"<BR>")


if v_cantidad >=1 then

	sql_elimina_rendicion			=	"delete from ocag_rendicion_fondos_a_rendir where fren_ncorr="&v_fren_ncorr
	sql_elimina_devolucion_rendicion=	"delete from ocag_devolucion_rendicion_fondos where fren_ncorr="&v_fren_ncorr
	sql_borra_presupuesto			= 	"delete from ocag_presupuesto_solicitud where tsol_ccod=2 and psol_brendicion='S' and cod_solicitud_origen="&v_fren_ncorr
	sql_elimina_detalle_rendicion	=	"delete from ocag_detalle_rendicion_fondo_rendir where fren_ncorr="&v_fren_ncorr
	sql_reembolso_gastos			= 	"delete from ocag_reembolso_gastos where cod_solicitud_origen="&v_fren_ncorr
	sql_detalle_reembolso_gastos	=	"delete from ocag_detalle_reembolso_gasto where cod_solicitud_origen="&v_fren_ncorr
	
	'RESPONSE.WRITE("11. "&sql_elimina_rendicion&"<BR>")
	'RESPONSE.WRITE("12. "&sql_elimina_devolucion_rendicion&"<BR>")
	'RESPONSE.WRITE("13. "&sql_borra_presupuesto&"<BR>")
	'RESPONSE.WRITE("14. "&sql_elimina_detalle_rendicion&"<BR>")
	'RESPONSE.WRITE("15. "&sql_reembolso_gastos&"<BR>")
	'RESPONSE.WRITE("16. "&sql_detalle_reembolso_gastos&"<BR>")
	
	conexion.estadotransaccion	conexion.ejecutas(sql_elimina_devolucion_rendicion)
	conexion.estadotransaccion	conexion.ejecutas(sql_borra_presupuesto)
	conexion.estadotransaccion	conexion.ejecutas(sql_elimina_detalle_rendicion)
	conexion.estadotransaccion	conexion.ejecutas(sql_elimina_rendicion)
	conexion.estadotransaccion	conexion.ejecutas(sql_reembolso_gastos)
	conexion.estadotransaccion	conexion.ejecutas(sql_detalle_reembolso_gastos)
end if
'response.Write("<br>0:<b>"&conexion.obtenerEstadoTransaccion&"</b>")
'****************************************************

for fila = 0 to f_solicitud.CuentaPost - 1
	v_fren_ncorr 	= f_solicitud.ObtenerValorPost (fila, "fren_ncorr")
	
	if 	v_rfre_ncorr="" or EsVacio(v_rfre_ncorr) then
		' clave primaria, se obtiene con la secuencia
		v_rfre_ncorr=	conexion.consultauno("exec obtenersecuencia 'ocag_rendicion_fondos_a_rendir'")
	end if	
	
	f_solicitud.AgregaCampoFilaPost fila,"rfre_ncorr", v_rfre_ncorr
	' referencia a la tabla padre
	f_solicitud.AgregaCampoFilaPost fila,"fren_ncorr", v_fren_ncorr
	f_solicitud.AgregaCampoPost "ocag_fingreso", fecha_actual	
	f_solicitud.AgregaCampoPost "ocag_generador", v_usuario
	f_solicitud.AgregaCampoPost "ocag_responsable", v_responsable
	f_solicitud.AgregaCampoPost "vibo_ccod", prueba
	f_solicitud.AgregaCampoPost "tsol_ccod", 7
	f_solicitud.AgregaCampoPost "pers_nrut", v_pers_nrut
	f_solicitud.AgregaCampoPost "rfre_mmonto", v_rendicion
		
	'else
	'	f_solicitud.EliminaFilaPost fila 
	'end if
next

f_solicitud.MantieneTablas false
'response.Write("<br>1:<b>"&conexion.obtenerEstadoTransaccion&"</b>")

'response.Write("<hr>")
set f_detalle = new cFormulario
f_detalle.carga_parametros "rendicion_fondo_rendir.xml", "detalle_rendicion"
f_detalle.inicializar conexion
f_detalle.procesaForm


'for fila = 0 to f_detalle.CuentaPost - 1
for fila = 0 to valor_final

	v_drfr_fdocto		= f_detalle.ObtenerValorPost (fila, "drfr_fdocto")
	v_drfr_ndocto 		= f_detalle.ObtenerValorPost (fila, "drfr_ndocto")
	v_tgas_ccod 		= f_detalle.ObtenerValorPost (fila, "tgas_ccod")
	v_tdoc_ccod 		= f_detalle.ObtenerValorPost (fila, "tdoc_ccod")
	'v_drfr_mdocto 		= f_detalle.ObtenerValorPost (fila, "drfr_mdocto")
	'v_drfr_mretencion	= f_detalle.ObtenerValorPost (fila, "drfr_mretencion")
	v_drfr_tdescripcion	= f_detalle.ObtenerValorPost (fila, "drfr_tdesc")
	v_drfr_trut				= f_detalle.ObtenerValorPost (fila, "pers_nrut")
	
	v_drfr_mafecto 		= f_detalle.ObtenerValorPost (fila, "drfr_mafecto")
	v_drfr_miva				= f_detalle.ObtenerValorPost (fila, "drfr_miva")
	v_drfr_mexento 		= f_detalle.ObtenerValorPost (fila, "drfr_mexento")
	v_drfr_mhonorarios= f_detalle.ObtenerValorPost (fila, "drfr_mhonorarios")
	v_drfr_mretencion 	= f_detalle.ObtenerValorPost (fila, "drfr_mretencion")
	v_drfr_mdocto		= f_detalle.ObtenerValorPost (fila, "drfr_mdocto")
	v_drfr_bboleta_honorario	= f_detalle.ObtenerValorPost (fila, "drfr_bboleta_honorario")
	
	'if v_drfr_mretencion="" or EsVacio(v_drfr_mretencion) then
	'	v_drfr_mretencion=0
	'end if
	
	'RESPONSE.WRITE("13 v_drfr_fdocto. "&v_drfr_fdocto&"<BR>")
	'RESPONSE.WRITE("14 v_drfr_ndocto. "&v_drfr_ndocto&"<BR>")
	'RESPONSE.WRITE("15 v_drfr_mdocto. "&v_drfr_mdocto&"<BR>")
	'RESPONSE.WRITE("16 v_drfr_bboleta_honorario. "&v_drfr_bboleta_honorario&"<BR>")

	
	if v_drfr_fdocto<>"" and v_drfr_ndocto <>"" and v_drfr_mdocto <>"" and v_drfr_bboleta_honorario<>"" then
		
		v_drfr_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_det_rendicion_fondorendir'")	
		
		'sql_detalle_reembolso= " Insert into ocag_detalle_rendicion_fondo_rendir (drfr_ncorr,rfre_ncorr,drfr_trut,fren_ncorr,tgas_ccod,tdoc_ccod,drfr_ndocto,drfr_mdocto,drfr_mretencion,drfr_tdesc,drfr_fdocto,audi_tusuario,audi_fmodificacion) "&_  
		'			 " values("&v_drfr_ncorr&","&v_rfre_ncorr&",'"&v_drfr_trut&"',"&v_fren_ncorr&","&v_tgas_ccod&","&v_tdoc_ccod&","&v_drfr_ndocto&","&v_drfr_mdocto&","&v_drfr_mretencion&",'"&v_drfr_tdescripcion&"','"&v_drfr_fdocto&"','"&v_usuario&"', getdate())"
		
		if cstr(v_drfr_bboleta_honorario)=cstr(1) then
		'BOLETA
		
		sql_detalle_reembolso= "Insert into ocag_detalle_rendicion_fondo_rendir "&_ 
									" ( drfr_ncorr, rfre_ncorr, drfr_trut, fren_ncorr, tgas_ccod "&_ 
									" , tdoc_ccod, drfr_ndocto, drfr_tdesc, drfr_fdocto, audi_tusuario "&_ 
									" , audi_fmodificacion, drfr_mhonorarios, drfr_mretencion, drfr_mdocto, drfr_bboleta_honorario )   "&_ 
									"  values "&_ 
									" ( "&v_drfr_ncorr&", "&v_rfre_ncorr&", '"&v_drfr_trut&"', "&v_fren_ncorr&", "&v_tgas_ccod&" "&_ 
									" , "&v_tdoc_ccod&", "&v_drfr_ndocto&", '"&v_drfr_tdescripcion&"', '"&v_drfr_fdocto&"', '"&v_usuario&"' "&_ 
									" , getdate(), "&v_drfr_mhonorarios&", "&v_drfr_mretencion&", "&v_drfr_mdocto&", "&v_drfr_bboleta_honorario&" )"
	
		end if
		'FACTURA

		if cstr(v_drfr_bboleta_honorario)=cstr(2) then

		sql_detalle_reembolso= "Insert into ocag_detalle_rendicion_fondo_rendir  "&_ 
									" ( drfr_ncorr, rfre_ncorr, drfr_trut, fren_ncorr, tgas_ccod "&_ 
									" , tdoc_ccod, drfr_ndocto, drfr_tdesc, drfr_fdocto, audi_tusuario "&_ 
									" , audi_fmodificacion, drfr_mafecto, drfr_miva, drfr_mexento, drfr_mdocto "&_ 
									" , drfr_bboleta_honorario )    "&_ 
 									" values "&_ 
									" ( "&v_drfr_ncorr&", "&v_rfre_ncorr&", '"&v_drfr_trut&"', "&v_fren_ncorr&", "&v_tgas_ccod&"  "&_ 
									" , "&v_tdoc_ccod&", "&v_drfr_ndocto&", '"&v_drfr_tdescripcion&"', '"&v_drfr_fdocto&"', '"&v_usuario&"'  "&_ 
									" , getdate(), "&v_drfr_mafecto&", "&v_drfr_miva&", "&v_drfr_mexento&", "&v_drfr_mdocto&"  "&_ 
									" , "&v_drfr_bboleta_honorario&" )"

		end if

		'RESPONSE.WRITE("17 sql_detalle_reembolso. "&sql_detalle_reembolso&"<BR>")
		
		conexion.estadotransaccion	conexion.ejecutas(sql_detalle_reembolso)
	end if
	'response.Write("<hr>")
next


'response.Write("<br>2:<b>"&conexion.obtenerEstadoTransaccion&"</b>")

if v_diferencia>0 then
	set f_devolucion = new cFormulario
	f_devolucion.carga_parametros "rendicion_fondo_rendir.xml", "devolucion_rendicion"
	f_devolucion.inicializar conexion
	f_devolucion.procesaForm
	
	for fila = 0 to f_devolucion.CuentaPost - 1
	
		v_dren_mmonto 	= f_devolucion.ObtenerValorPost (fila, "dren_mmonto")
		
		rut=f_devolucion.ObtenerValorPost (fila, "pers_nrut")
		
		if rut <> "" then
		v_rut	=	left(f_devolucion.ObtenerValorPost (fila, "pers_nrut"),len(f_devolucion.ObtenerValorPost (fila, "pers_nrut"))-2)
		else
		v_rut=""
		end if
		
		'response.write("<hr> Monto: "&v_dren_mmonto)		
		
		if 	v_dren_mmonto<>"" then
			' clave primaria, se obtiene con la secuencia
			v_dren_ncorr=	conexion.consultauno("exec obtenersecuencia 'ocag_devolucion_rendicion_fondos'")
			f_devolucion.AgregaCampoFilaPost fila,"dren_ncorr", v_dren_ncorr
			' referencia a la tabla padre
			f_devolucion.AgregaCampoFilaPost fila,"fren_ncorr", v_fren_ncorr
			f_devolucion.AgregaCampoFilaPost fila,"pers_nrut", v_rut
		else
			f_devolucion.EliminaFilaPost fila 
		end if
		
	next
	
	' LA SIGUIENTE  LINEA INSERTA REGISTROS EN LA TABLA "ocag_devolucion_rendicion_fondos"
	f_devolucion.MantieneTablas false
end if

'response.Write("<br>3:<b>"&conexion.obtenerEstadoTransaccion&"</b>")


'************** INSERTA EL HISTORIAL DEL AUTORIZACIONES ***************
	set f_solicitud_vb = new cFormulario
	f_solicitud_vb.carga_parametros "vb_presupuesto.xml", "autoriza_solicitud_giro"
	f_solicitud_vb.inicializar conexion
	f_solicitud_vb.procesaForm
	
	f_solicitud_vb.AgregaCampoPost "cod_solicitud",v_fren_ncorr
	f_solicitud_vb.AgregaCampoPost "vibo_ccod", prueba
	f_solicitud_vb.AgregaCampoPost "asgi_nestado", 1
	f_solicitud_vb.AgregaCampoPost "tsol_ccod", 7
	f_solicitud_vb.AgregaCampoPost "asgi_fautorizado", fecha_actual
	
	' LA SIGUIENTE  LINEA INSERTA REGISTROS EN LA TABLA "ocag_autoriza_solicitud_giro"
	f_solicitud_vb.MantieneTablas false	

'response.Write("<br/>4:<b>"&conexion.obtenerEstadoTransaccion&"</b>")


'************** INSERTA EL DETALLE DEL PRESUPUESTO ASOCIADO a la nueva rendicion***************
if v_presupuesto > 0 then


	'**************** NUEVO REEMBOLSO GASTOS ***************
	set f_proveedor = new cFormulario
	f_proveedor.carga_parametros "reembolso_gasto.xml", "datos_proveedor"
	f_proveedor.inicializar conexion
	f_proveedor.procesaForm
	
	v_diferencia=v_diferencia* -1
	
	v_rgas_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_reembolso_gastos'")
	v_pers_ncorr_pre=conexion.consultaUno("Select pers_ncorr from personas where pers_nrut="&v_pers_nrut)

	f_proveedor.AgregaCampoPost "vibo_ccod", prueba
	f_proveedor.AgregaCampoPost "rgas_ncorr", v_rgas_ncorr
	f_proveedor.AgregaCampoPost "pers_ncorr_proveedor", v_pers_ncorr_pre
	f_proveedor.AgregaCampoPost "area_ccod", v_area_ccod
	f_proveedor.AgregaCampoPost "ocag_fingreso", fecha_actual	
	f_proveedor.AgregaCampoPost "ocag_generador", v_usuario
	f_proveedor.AgregaCampoPost "ocag_responsable", v_responsable
	f_proveedor.AgregaCampoPost "rgas_mgiro", v_diferencia
	f_proveedor.AgregaCampoPost "cod_solicitud_origen", v_fren_ncorr
	
	' LA SIGUIENTE  LINEA INSERTA REGISTROS EN LA TABLA "ocag_reembolso_gastos"
	f_proveedor.MantieneTablas false
	
	'**************** DETALLE REEMBOLSO ***************
	set f_detalle_rg = new cFormulario
	f_detalle_rg.carga_parametros "rendicion_fondo_rendir.xml", "detalle_rendicion"
	f_detalle_rg.inicializar conexion
	f_detalle_rg.procesaForm
	
	
	for fila = 0 to f_detalle.CuentaPost - 1
	
		v_drga_fdocto		= f_detalle.ObtenerValorPost (fila, "drfr_fdocto")
		v_drga_ndocto 		= f_detalle.ObtenerValorPost (fila, "drfr_ndocto")
		v_drga_mdocto 		= f_detalle.ObtenerValorPost (fila, "drfr_mdocto")
		v_tgas_ccod 		= f_detalle.ObtenerValorPost (fila, "tgas_ccod")
		v_tdoc_ccod 		= f_detalle.ObtenerValorPost (fila, "tdoc_ccod")
		v_drga_mretencion	= f_detalle.ObtenerValorPost (fila, "drfr_mretencion")
		v_drga_tdescripcion	= f_detalle.ObtenerValorPost (fila, "drfr_tdesc")
		v_drfr_trut			= f_detalle.ObtenerValorPost (fila, "pers_nrut")
		
		
		if v_drga_mretencion="" or EsVacio(v_drga_mretencion) then
			v_drga_mretencion=0
		end if
	
		if v_drga_fdocto<>"" and v_drga_ndocto <>"" and v_drga_mdocto <>"" then
			
			v_drga_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_detalle_reembolso_gasto'")	
			
			sql_detalle_reembolso= " Insert into ocag_detalle_reembolso_gasto (cod_solicitud_origen,drga_ncorr,rgas_ncorr,tgas_ccod,tdoc_ccod,drga_ndocto,drga_mdocto,drga_mretencion,drga_tdescripcion,drga_fdocto,audi_tusuario,audi_fmodificacion) "&_  
						 " values("&v_fren_ncorr&","&v_drga_ncorr&","&v_rgas_ncorr&","&v_tgas_ccod&","&v_tdoc_ccod&","&v_drga_ndocto&","&v_drga_mdocto&","&v_drga_mretencion&",'"&v_drga_tdescripcion&"','"&v_drga_fdocto&"','"&v_usuario&"', getdate())"
			
			'RESPONSE.WRITE("18. "&sql_detalle_reembolso&"<BR>")
			
			conexion.estadotransaccion	conexion.ejecutas(sql_detalle_reembolso)
			
		end if
		'response.Write("<hr>")
	next
	'***************************************************************
	
	'response.Write("<br>5:<b>"&conexion.obtenerEstadoTransaccion&"</b>")	
	'************** INSERTA EL HISTORIAL DEL AUTORIZACIONES ***************
		set f_historial_rg = new cFormulario
		f_historial_rg.carga_parametros "vb_presupuesto.xml", "autoriza_solicitud_giro"
		f_historial_rg.inicializar conexion
		f_historial_rg.procesaForm
		
		f_historial_rg.AgregaCampoPost "cod_solicitud",v_rgas_ncorr
		f_historial_rg.AgregaCampoPost "vibo_ccod", prueba
		f_historial_rg.AgregaCampoPost "asgi_nestado", 1
		f_historial_rg.AgregaCampoPost "tsol_ccod", 2
		f_historial_rg.AgregaCampoPost "asgi_fautorizado", fecha_actual
		
		' LA SIGUIENTE  LINEA INSERTA REGISTROS EN LA TABLA "ocag_autoriza_solicitud_giro"
		f_historial_rg.MantieneTablas false	
	'**********************************************************************
		set detalle_presupuesto = new cFormulario
		detalle_presupuesto.carga_parametros "datos_presupuesto.xml", "detalle_presupuesto"
		detalle_presupuesto.inicializar conexion
		detalle_presupuesto.procesaForm
		
		for fila = 0 to detalle_presupuesto.CuentaPost-1
			
			v_psol_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_presupuesto_solicitud'")
			
			cod_pre 		= detalle_presupuesto.ObtenerValorPost (fila, "cod_pre")
			anos_ccod 		= detalle_presupuesto.ObtenerValorPost (fila, "anos_ccod")
			mes_ccod 		= detalle_presupuesto.ObtenerValorPost (fila, "mes_ccod")
			psol_mpresupuesto 		= detalle_presupuesto.ObtenerValorPost (fila, "psol_mpresupuesto")
		
			sql_detalle_presupuesto= " Insert into ocag_presupuesto_solicitud (psol_ncorr,tsol_ccod,cod_solicitud,cod_pre,anos_ccod,psol_mpresupuesto,mes_ccod, audi_tusuario, audi_fmodificacion, psol_brendicion,cod_solicitud_origen) "&_  
						 " values("&v_psol_ncorr&",2,"&v_rgas_ncorr&",'"&cod_pre&"',"&anos_ccod&","&psol_mpresupuesto&","&mes_ccod&",'"&v_usuario&"', getdate(), 'S',"&v_fren_ncorr&")"
			
			'RESPONSE.WRITE("19. "&sql_detalle_presupuesto&"<BR>")
			
			conexion.estadotransaccion	conexion.ejecutas(sql_detalle_presupuesto)
		next
		
	'Inserta nueva solicitud de fondo a rendir	
	end if
	'******************************************************************************


'response.Write("<br><b>"&conexion.obtenerEstadoTransaccion&"</b>")
'conexion.estadotransaccion false


v_estado_transaccion=conexion.ObtenerEstadoTransaccion

if v_estado_transaccion=false  then
'response.Write("<br>Todo MAL")
	session("mensaje_error")="No se pudo ingresar la rendicion de fondo a rendir.\nVuelva a intentarlo."
else	
'response.Write("<br>Todo bien")
	'session("mensaje_error")="La rendicion de fondo a rendir N°: "&v_fren_ncorr&" fue ingresada correctamente."
	session("mensaje_error")="La rendicion de fondo a rendir N°: "&v_rfre_ncorr&" fue ingresada correctamente."
end if

if url_final ="" then
	'url_final="rendicion_fondo_rendir.asp?cod_solicitud="&v_fren_ncorr&"&rfre_ncorr="&v_rfre_ncorr
	url_final="AUTORIZACION_GIROS.ASP"
end if

'response.End()

response.Redirect(url_final)

%>