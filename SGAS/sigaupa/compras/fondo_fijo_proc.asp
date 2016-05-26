<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
prueba=request.querystring("prueba")


v_ffij_ncorr= request.Form("datos[0][ffij_ncorr]")
v_area_ccod	= request.Form("busqueda[0][area_ccod]")
v_rut_aut	= request.Form("rut_autorizador")
v_nom_aut	= request.Form("funcionario")
v_xdv_aut	= request.Form("digito")
v_responsable	= request.Form("busqueda[0][responsable]")
contador2 =request.Form("contador2")

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()

set f_proveedor = new cFormulario
f_proveedor.carga_parametros "fondo_fijo.xml", "datos_funcionario"
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
'response.Write("<br/><b> 1: "&conexion.obtenerEstadoTransaccion&"</b>")
	if 	v_rut_aut<>"" then
		v_pers_ncorr_aut=conexion.consultaUno("Select pers_ncorr from personas where pers_nrut="&v_rut_aut)
		'inserta datos del proveedor en caso que no exista
		if EsVacio(v_pers_ncorr_aut) or v_pers_ncorr_aut="" then
			v_pers_ncorr_aut=conexion.consultauno("exec obtenersecuencia 'personas'")
			sql_persona_aut	=	" insert into personas (pers_ncorr,pers_nrut,pers_xdv,pers_tnombre) "&_
							" values("&v_pers_ncorr_aut&","&v_rut_aut&",'"&v_xdv_aut&"','"&v_nom_aut&"') "
			conexion.estadotransaccion	conexion.ejecutas(sql_persona_aut)
		end if
	end if
'response.Write("<br/><b> 2: "&conexion.obtenerEstadoTransaccion&"</b>")

next


if EsVAcio(v_ffij_ncorr) or v_ffij_ncorr="" then

	v_ffij_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_fondo_fijo'")
	f_proveedor.AgregaCampoPost "ffij_ncorr", v_ffij_ncorr
	f_proveedor.AgregaCampoPost "pers_ncorr", v_pers_ncorr
	f_proveedor.AgregaCampoPost "area_ccod", v_area_ccod
	f_proveedor.AgregaCampoPost "pers_nrut_aut", v_rut_aut
	f_proveedor.AgregaCampoPost "vibo_ccod", prueba
	
		
else
	url_final=request.ServerVariables("HTTP_REFERER")
	sql_borra_presupuesto	= "delete from ocag_presupuesto_solicitud where tsol_ccod=6 and cod_solicitud="&v_ffij_ncorr
	conexion.estadotransaccion	conexion.ejecutas(sql_borra_presupuesto)
	f_proveedor.AgregaCampoPost "pers_nrut_aut", v_rut_aut
	
end if
	f_proveedor.AgregaCampoPost "vibo_ccod", prueba
	f_proveedor.AgregaCampoPost "ocag_baprueba", "NULL"
	f_proveedor.AgregaCampoPost "ocag_fingreso", fecha_actual	
	f_proveedor.AgregaCampoPost "ocag_generador", v_usuario
	f_proveedor.AgregaCampoPost "ocag_responsable", v_responsable

f_proveedor.MantieneTablas false
'response.Write("<br/><b> 3: "&conexion.obtenerEstadoTransaccion&"</b>")
'************** INSERTA EL HISTORIAL DEL AUTORIZACIONES ***************
	set f_solicitud = new cFormulario
	f_solicitud.carga_parametros "vb_jefe_directo.xml", "autoriza_solicitud_giro"
	f_solicitud.inicializar conexion
	f_solicitud.procesaForm
	
	f_solicitud.AgregaCampoPost "cod_solicitud",v_ffij_ncorr
	f_solicitud.AgregaCampoPost "vibo_ccod", prueba
	f_solicitud.AgregaCampoPost "ocag_baprueba", "NULL"
	f_solicitud.AgregaCampoPost "asgi_nestado", 1
	f_solicitud.AgregaCampoPost "tsol_ccod", 6
	f_solicitud.AgregaCampoPost "asgi_fautorizado", fecha_actual
	
	f_solicitud.MantieneTablas false


'response.Write("<br/><b> 4: "&conexion.obtenerEstadoTransaccion&"</b>")



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
	
	if cod_pre <> "" then
	v_psol_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_presupuesto_solicitud'")
	
	sql_detalle_presupuesto= " Insert into ocag_presupuesto_solicitud (psol_ncorr,tsol_ccod,cod_solicitud,cod_pre,anos_ccod,psol_mpresupuesto,mes_ccod, audi_tusuario, audi_fmodificacion) "&_  
				 " values("&v_psol_ncorr&",6,"&v_ffij_ncorr&",'"&cod_pre&"',"&anos_ccod&","&psol_mpresupuesto&","&mes_ccod&",'"&v_usuario&"', getdate())"
	'response.Write("<br>"&sql_detalle_presupuesto)
	conexion.estadotransaccion	conexion.ejecutas(sql_detalle_presupuesto)
	'response.Write("<br/><b> 5: "&conexion.obtenerEstadoTransaccion&"</b>")
	end if
next

'******************************************************************************

'response.Write("<br/><b> Final : "&conexion.obtenerEstadoTransaccion&"</b>")
'conexion.estadotransaccion false
'response.End()

if conexion.ObtenerEstadoTransaccion=false  then
'response.Write("<br>Todo MAL")
	url_final=request.ServerVariables("HTTP_REFERER")
	session("mensaje_error")="No se pudo ingresar la solicitud de Fondo Fijo.\nVuelva a intentarlo."
else	
'response.Write("<br>Todo bien")
	url_final="autorizacion_giros.asp"
	session("mensaje_error")="La solicitud de Fondo Fijo N°: "&v_ffij_ncorr&" fue ingresada correctamente."
end if

if url_final ="" then
	'url_final="fondo_fijo.asp?busqueda[0][ffij_ncorr]="&v_ffij_ncorr
	url_final="autorizacion_giros.asp"
end if

response.Redirect(url_final)

%>