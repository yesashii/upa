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
'FECHA ACTUALIZACION 	:18/06/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ORDEN DE COMPRA
'LINEA			:133
'*******************************************************************
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
prueba=request.querystring("prueba")

v_sovi_ncorr= request.Form("datos[0][sovi_ncorr]")
v_area_ccod	= request.Form("busqueda[0][area_ccod]")
v_responsable	= request.Form("busqueda[0][responsable]")
v_ccos_ncorr	= request.Form("detalle[0][ccos_ncorr]")
contador2   =request.Form("contador2")

'RESPONSE.WRITE("1 v_sovi_ncorr : "&v_sovi_ncorr&"<BR>")
'RESPONSE.WRITE("2 v_area_ccod : "&v_area_ccod&"<BR>")
'RESPONSE.WRITE("3 v_responsable : "&v_responsable&"<BR>")
'RESPONSE.WRITE("4 v_ccos_ncorr : "&v_ccos_ncorr&"<BR>")

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()
fecha_actual=conexion.consultaUno("select protic.trunc(getDate())")

set f_proveedor = new cFormulario
f_proveedor.carga_parametros "solicitud_viaticos.xml", "datos_funcionario"
f_proveedor.inicializar conexion
f_proveedor.procesaForm

'**************************** SE RECORRE LOS REGISTROS DE LA PERSONA PARA INSERTAR DATOS DE LA OC *************
for fila = 0 to f_proveedor.CuentaPost - 1
	pers_nrut 		= f_proveedor.ObtenerValorPost (fila, "pers_nrut")
	pers_xdv 		= f_proveedor.ObtenerValorPost (fila, "pers_xdv")
	pers_tnombre 	= f_proveedor.ObtenerValorPost (fila, "v_nombre")
	
	if 	pers_nrut<>"" then
		v_pers_ncorr=conexion.consultaUno("Select pers_ncorr from personas where pers_nrut="&pers_nrut)
		'inserta datos del proveedor en caso que no exista
		if EsVacio(v_pers_ncorr) or v_pers_ncorr="" then
			v_pers_ncorr=conexion.consultauno("exec obtenersecuencia 'personas'")
			sql_persona	=	" insert into personas (pers_ncorr,pers_nrut,pers_xdv,pers_tnombre,pers_tape_paterno,pers_tape_materno,pers_tfono,pers_tfax) "&_
							" values("&v_pers_ncorr&","&pers_nrut&",'"&pers_xdv&"','"&pers_tnombre&"','','', '"&pers_tfono&"', '"&pers_tfax&"') "
			
			'Response.write("1. "&sql_persona&"<br>")
			
			conexion.estadotransaccion	conexion.ejecutas(sql_persona)
		end if
	end if
next
'response.Write("<br/><b> 1: "&conexion.obtenerEstadoTransaccion&"</b>")
'******************************************************

'RESPONSE.WRITE("ACA")
'RESPONSE.END()

f_proveedor.AgregaCampoPost "pers_ncorr", v_pers_ncorr

if EsVAcio(v_sovi_ncorr) or v_sovi_ncorr="" then
	
	v_sovi_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_solicitud_viatico'")
	f_proveedor.AgregaCampoPost "sovi_ncorr", v_sovi_ncorr
	f_proveedor.AgregaCampoPost "area_ccod", v_area_ccod
	f_proveedor.AgregaCampoPost "vibo_ccod", prueba
	
else
	url_final=request.ServerVariables("HTTP_REFERER")
	sql_borra_presupuesto	= "delete from ocag_presupuesto_solicitud where tsol_ccod=4 and cod_solicitud="&v_sovi_ncorr
	
	'Response.write("2. "&sql_borra_presupuesto&"<br>")
	
	conexion.estadotransaccion	conexion.ejecutas(sql_borra_presupuesto)
end if

'response.Write("<br/><b> 2: "&conexion.obtenerEstadoTransaccion&"</b>")
	f_proveedor.AgregaCampoPost "vibo_ccod", prueba
	f_proveedor.AgregaCampoPost "ocag_fingreso", fecha_actual	
	f_proveedor.AgregaCampoPost "ocag_generador", v_usuario
	f_proveedor.AgregaCampoPost "ocag_responsable", v_responsable
	f_proveedor.AgregaCampoPost "ocag_baprueba", "NULL"
	
	' ACA ESTA EL CAMPO CENTRO DE COSTO, QUE FUE AGREGADO
	f_proveedor.AgregaCampoPost "ccos_ncorr", v_ccos_ncorr

f_proveedor.MantieneTablas false

'************** INSERTA EL HISTORIAL DEL AUTORIZACIONES ***************
	set f_solicitud = new cFormulario
	f_solicitud.carga_parametros "vb_presupuesto.xml", "autoriza_solicitud_giro"
	f_solicitud.inicializar conexion
	f_solicitud.procesaForm
	
	f_solicitud.AgregaCampoPost "cod_solicitud",v_sovi_ncorr
	f_solicitud.AgregaCampoPost "vibo_ccod", prueba
	f_solicitud.AgregaCampoPost "ocag_baprueba", "NULL"
	f_solicitud.AgregaCampoPost "asgi_nestado", 1
	f_solicitud.AgregaCampoPost "tsol_ccod", 4
	f_solicitud.AgregaCampoPost "asgi_fautorizado", fecha_actual
	
	' LA SIGUIENTE ISTRUCCION GRABA REGISTROS EN LA TABLA "ocag_solicitud_viatico"	
	f_solicitud.MantieneTablas false	
'response.Write("<br/><b> 3: "&conexion.obtenerEstadoTransaccion&"</b>")

'************** INSERTA EL DETALLE DEL PRESUPUESTO ASOCIADO ***************
set detalle_presupuesto = new cFormulario
detalle_presupuesto.carga_parametros "datos_presupuesto.xml", "detalle_presupuesto"
detalle_presupuesto.inicializar conexion
detalle_presupuesto.procesaForm

for fila = 0 to contador2'detalle_presupuesto.CuentaPost-1

	cod_pre 		= detalle_presupuesto.ObtenerValorPost (fila, "cod_pre")
	'anos_ccod 		= detalle_presupuesto.ObtenerValorPost (fila, "anos_ccod")
	'mes_ccod 		= detalle_presupuesto.ObtenerValorPost (fila, "mes_ccod")
	mes_ccod =  request.Form("busqueda["&fila&"][mes_ccod]")  
	anos_ccod = request.Form("busqueda["&fila&"][anos_ccod]")   
	
	psol_mpresupuesto 		= detalle_presupuesto.ObtenerValorPost (fila, "psol_mpresupuesto")
	
	if cod_pre <> ""then
	v_psol_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_presupuesto_solicitud'")
	
	sql_detalle_presupuesto= " Insert into ocag_presupuesto_solicitud (psol_ncorr,tsol_ccod,cod_solicitud,cod_pre,anos_ccod,psol_mpresupuesto,mes_ccod, audi_tusuario, audi_fmodificacion) "&_  
				 " values("&v_psol_ncorr&",4,"&v_sovi_ncorr&",'"&cod_pre&"',"&anos_ccod&","&psol_mpresupuesto&","&mes_ccod&",'"&v_usuario&"', getdate())"
	
	'Response.write("3. "&sql_detalle_presupuesto&"<br>")
	'response.end()
	
	conexion.estadotransaccion	conexion.ejecutas(sql_detalle_presupuesto)
	end if
next

'******************************************************************************

v_estado_transaccion=conexion.ObtenerEstadoTransaccion

if v_estado_transaccion=false  then
	url_final=request.ServerVariables("HTTP_REFERER")
	session("mensaje_error")="No se pudo ingresar la solicitud de Viatico.\nVuelva a intentarlo."
else	
	url_final="autorizacion_giros.asp"
	session("mensaje_error")="La solicitud de Viatico N° "&v_sovi_ncorr&" fue ingresada correctamente."
end if

if url_final ="" then
	'url_final="solicitud_viaticos.asp?busqueda[0][sovi_ncorr]="&v_sovi_ncorr
	url_final="autorizacion_giros.asp"
end if

'response.end()
response.Redirect(url_final)

%>