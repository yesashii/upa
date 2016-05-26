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
'FECHA ACTUALIZACION 	:27/06/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ORDEN DE COMPRA
'LINEA			:
'*******************************************************************
for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next
'response.End()

	'12/07/2013
prueba=request.querystring("prueba")	

v_rut_alumno= request.Form("rut_alumno")
v_digito = request.Form("digito")
v_alumno = request.Form("alumno")

v_carrera= request.Form("b[0][CARR_CURSO]")
'v_carrera= request.Form("carrera")

v_dalu_ncorr= request.Form("datos[0][dalu_ncorr]")
v_area_ccod	= request.Form("busqueda[0][area_ccod]")
v_responsable	= request.Form("busqueda[0][responsable]")

v_ccos_ncorr	= request.Form("b[0][CCOS_CCOD]")
'v_ccos_ncorr	= request.Form("detalle[0][ccos_ncorr]")

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


set f_proveedor = new cFormulario
f_proveedor.carga_parametros "devolucion_alumno.xml", "datos_funcionario"
f_proveedor.inicializar conexion
f_proveedor.procesaForm

v_usuario=negocio.ObtenerUsuario()
fecha_actual=conexion.consultaUno("select protic.trunc(getDate())")

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
			conexion.estadotransaccion	conexion.ejecutas(sql_persona)
		end if
	end if
next
'response.Write("<br/><b> 1: "&conexion.obtenerEstadoTransaccion&"</b>")
'******************************************************

f_proveedor.AgregaCampoPost "pers_ncorr", v_pers_ncorr

if EsVAcio(v_dalu_ncorr) or v_dalu_ncorr="" then
	
	v_dalu_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_devolucion_alumno'")
	f_proveedor.AgregaCampoPost "dalu_ncorr", v_dalu_ncorr
	f_proveedor.AgregaCampoPost "area_ccod", v_area_ccod
	f_proveedor.AgregaCampoPost "vibo_ccod", prueba
	
else
	'url_final=request.ServerVariables("HTTP_REFERER")
	
	'sql_borra_presupuesto	= "delete from ocag_presupuesto_solicitud where tsol_ccod=5 and cod_solicitud="&v_dalu_ncorr
	
	'conexion.estadotransaccion	conexion.ejecutas(sql_borra_presupuesto)
end if

	f_proveedor.AgregaCampoPost "ocag_fingreso", fecha_actual	
	f_proveedor.AgregaCampoPost "ocag_generador", v_usuario
	f_proveedor.AgregaCampoPost "ocag_responsable", v_responsable
	f_proveedor.AgregaCampoPost "vibo_ccod", prueba
	f_proveedor.AgregaCampoPost "ocag_baprueba", "NULL"
	'12/07/2013
	f_proveedor.AgregaCampoPost "pers_nrut_alu", v_rut_alumno	
	f_proveedor.AgregaCampoPost "pers_xdv_alu", v_digito
	f_proveedor.AgregaCampoPost "pers_tnombre_alu", v_alumno
	f_proveedor.AgregaCampoPost "carrera_alu", v_carrera
	
	' ACA ESTA EL CAMPO CENTRO DE COSTO, QUE FUE AGREGADO
	f_proveedor.AgregaCampoPost "ccos_ccod", v_ccos_ncorr
	
	'LA SIGUIENTE LINEA INSERTA REGISTROS EN LA TABLA "ocag_devolucion_alumno"
	f_proveedor.MantieneTablas false


'************** INSERTA EL HISTORIAL DEL AUTORIZACIONES ***************
	set f_solicitud = new cFormulario
	f_solicitud.carga_parametros "vb_presupuesto.xml", "autoriza_solicitud_giro"
	f_solicitud.inicializar conexion
	f_solicitud.procesaForm
	
	f_solicitud.AgregaCampoPost "cod_solicitud",v_dalu_ncorr
	f_solicitud.AgregaCampoPost "vibo_ccod", prueba
	f_solicitud.AgregaCampoPost "ocag_baprueba", "NULL"
	f_solicitud.AgregaCampoPost "asgi_nestado", 1
	f_solicitud.AgregaCampoPost "tsol_ccod", 5
	f_solicitud.AgregaCampoPost "asgi_fautorizado", fecha_actual
	
	'LA SIGUIENTE LINEA INSERTA REGISTROS EN LA TABLA "ocag_autoriza_solicitud_giro"
	f_solicitud.MantieneTablas false	

'************** INSERTA EL DETALLE DEL PRESUPUESTO ASOCIADO ***************
'set detalle_presupuesto = new cFormulario
'detalle_presupuesto.carga_parametros "datos_presupuesto.xml", "detalle_presupuesto"
'detalle_presupuesto.inicializar conexion
'detalle_presupuesto.procesaForm

'for fila = 0 to detalle_presupuesto.CuentaPost-1
	
	'v_psol_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_presupuesto_solicitud'")
	
	'cod_pre 		= detalle_presupuesto.ObtenerValorPost (fila, "cod_pre")
	'anos_ccod 		= detalle_presupuesto.ObtenerValorPost (fila, "anos_ccod")
	'mes_ccod 		= detalle_presupuesto.ObtenerValorPost (fila, "mes_ccod")
	'psol_mpresupuesto 		= detalle_presupuesto.ObtenerValorPost (fila, "psol_mpresupuesto")

	'sql_detalle_presupuesto= " Insert into ocag_presupuesto_solicitud (psol_ncorr,tsol_ccod,cod_solicitud,cod_pre,anos_ccod,psol_mpresupuesto,mes_ccod, audi_tusuario, audi_fmodificacion) "&_  
	'			 " values("&v_psol_ncorr&",5,"&v_dalu_ncorr&",'"&cod_pre&"',"&anos_ccod&","&psol_mpresupuesto&","&mes_ccod&",'"&v_usuario&"', getdate())"
				 
	'response.Write("<br>"&sql_detalle_presupuesto)
	
	'conexion.estadotransaccion	conexion.ejecutas(sql_detalle_presupuesto)
'next
'response.Write("<br/><b> 4: "&conexion.obtenerEstadoTransaccion&"</b>")
'******************************************************************************


'response.Write("<br/><b> 2: "&conexion.obtenerEstadoTransaccion&"</b>")
'response.Write("<br/><b> 2: "&url_final&"</b>")
'conexion.estadotransaccion false
'response.End()

v_estado_transaccion=conexion.ObtenerEstadoTransaccion
'v_estado_transaccion=TRUE

if v_estado_transaccion=false  then
	session("mensaje_error")="No se pudo ingresar la solicitud de devolucion.\nVuelva a intentarlo."
else	
	session("mensaje_error")="La solicitud de devolucion N°: "&v_dalu_ncorr&" fue ingresada correctamente."
end if

if url_final ="" then
	'url_final="devolucion_alumno.asp?busqueda[0][dalu_ncorr]="&v_dalu_ncorr
	url_final="autorizacion_giros.asp"
end if

response.Redirect(url_final)
%>