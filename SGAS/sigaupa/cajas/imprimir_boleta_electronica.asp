<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file = "../documentos_electronicos/boleta/boleta_proc.asp" -->

<%

'for each x in request.querystring
'	response.Write("<br>"&x&" : "&request.querystring(x))
'next

'response.Write("<br> valor: "&valor)
'response.End()
total = request.querystring("monto")
detalle = request.querystring("detalle")
montos = request.querystring("montos")
'f_emision = request.querystring("f_emision")
f_emision = date()
sssusuario = request.querystring("usuario")
bole_ncorr = request.querystring("bole_ncorr")
pers_ncorr = request.querystring("pers_ncorr")
v_pers_ncorr_aval = Request.QueryString("pers_ncorr_aval")
carrera = Request.QueryString("carrera")
'tipo_boleta = request.querystring("tipo_boleta")
'tipo_boleta = "AFECTA"
cantidad = 0
dim cadena
dim detalle_montos

detalle_montos = split(montos,",",-1,1)
detalle_item = split(detalle,",",-1,1)
'response.Write(detalle_item(0)&"<br>"&detalle_item(1))
'response.Write(detalle_montos(0)&"<br>"&detalle_montos(1))



'response.End()
'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
	'response.End()	
set conexion = new cconexion
conexion.inicializar "upacifico"	

set negocio = new CNegocio
negocio.Inicializa conexion

set f_detalle = new CFormulario
f_detalle.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_detalle.inicializar conexion

v_usuario 	= negocio.ObtenerUsuario()
peri_ccod 	= negocio.ObtenerPeriodoAcademico("CLASES18")

'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
tipo_detalle = conexion.consultaUno("select tdet_tdesc from TIPOS_DETALLE where TDET_CCOD=(select top 1 TDET_CCOD from DETALLE_BOLETAS where BOLE_NCORR="&bole_ncorr&")")
'response.Write(tipo_detalle)
'response.End()
'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
	'"controlador.asp"
sql_tipo_boleta="Select b.tbol_tdesc from boletas a, tipos_boletas b where a.tbol_ccod=b.tbol_ccod and a.bole_ncorr="&bole_ncorr
tipo_boleta=conexion.consultaUno(sql_tipo_boleta)

if tipo_boleta = "EXENTA" then
	tipo = 41
else
	tipo = 39
end if

'response.Write("tipo"&tipo_boleta&" "&tipo)
'response.End()
 sql_tipo_pago="select count(*) from detalle_boletas a, tipos_detalle b " & vbCrLf &_
				" where a.tdet_ccod=b.tdet_ccod" & vbCrLf &_
				" and b.tcom_ccod=5  " & vbCrLf &_
				" and bole_ncorr='" & bole_ncorr & "'"
'v_tipo_pago= conexion.consultaUno(sql_tipo_pago)
'response.Write(sql_tipo_pago)
'response.End()	
'--------------------------------Datos Apoderado-------------------------------------------------
set f_consulta_aval = new CFormulario
f_consulta_aval.Carga_Parametros "parametros.xml", "tabla"
f_consulta_aval.inicializar conexion



consulta = "select distinct ba.PERS_NCORR, protic.obtener_rut(pers.pers_ncorr) as rut_aval, " & vbCrLf &_  
"protic.obtener_nombre_completo(pers.pers_ncorr,'n') as nombre_aval," & vbCrLf &_
"c.CIUD_TCOMUNA, c.CIUD_TDESC, protic.obtener_direccion_letra(pers.pers_ncorr,1,'CNPB') as direccion, " & vbCrLf &_
" a.PERS_NCORR as alumno, a.POST_FPOSTULACION from postulantes a, codeudor_postulacion ba, PERSONAS pers" & vbCrLf &_
"left outer join direcciones d " & vbCrLf &_
"On pers.PERS_NCORR=d.PERS_NCORR " & vbCrLf &_
"and d.TDIR_CCOD = 1 " & vbCrLf &_
"left outer join ciudades c " & vbCrLf &_
"on d.CIUD_CCOD = c.CIUD_CCOD " & vbCrLf &_
"where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'" & vbCrLf &_
" and a.post_ncorr=ba.post_ncorr " & vbCrLf &_
" and ba.PERS_NCORR=pers.PERS_NCORR " & vbCrLf &_
" order by a.PERS_NCORR,a.POST_FPOSTULACION desc"		 

'response.Write("<PRE>" & consulta & "</PRE>")
'response.End()
f_consulta_aval.consultar consulta
f_consulta_aval.siguiente

'response.Write(f_consulta_aval.nrofilas)
'response.End()

if f_consulta_aval.nrofilas > 0 then
	v_nombre_aval	=	f_consulta_aval.ObtenerValor ("nombre_aval")
	v_rut_aval		=	f_consulta_aval.ObtenerValor ("rut_aval")
	v_comuna_aval	=	f_consulta_aval.ObtenerValor ("ciud_tdesc")
	v_ciudad_aval	=	f_consulta_aval.ObtenerValor ("ciud_tcomuna")
	v_direccion_aval=	f_consulta_aval.ObtenerValor ("direccion")
else
	consulta = "select a.PERS_NCORR, isnull(protic.obtener_rut(a.pers_ncorr),'11111111-1') as rut_aval, " & vbCrLf &_ 
	"isnull(protic.obtener_nombre_completo(a.pers_ncorr,'n'),'Sin Nombre') as nombre_aval, " & vbCrLf &_
 "isnull(c.CIUD_TCOMUNA,'Sin Comuna') as CIUD_TCOMUNA, isnull(c.CIUD_TDESC,'Sin Ciudad') as CIUD_TDESC, " & vbCrLf &_
 "isnull(protic.obtener_direccion_letra(a.pers_ncorr,1,'CNPB'),'Sin Direccion') as direccion " & vbCrLf &_
 "from PERSONAS a " & vbCrLf &_
" left outer join direcciones d " & vbCrLf &_
" On a.PERS_NCORR=d.PERS_NCORR " & vbCrLf &_
" and d.TDIR_CCOD = 1 " & vbCrLf &_
" left outer join ciudades c " & vbCrLf &_
" on d.CIUD_CCOD = c.CIUD_CCOD " & vbCrLf &_
" where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'"
 
 	f_consulta_aval.consultar consulta
	f_consulta_aval.siguiente
	
	v_nombre_aval	=	f_consulta_aval.ObtenerValor ("nombre_aval")
	v_rut_aval		=	f_consulta_aval.ObtenerValor ("rut_aval")
	v_comuna_aval	=	f_consulta_aval.ObtenerValor ("ciud_tdesc")
	v_ciudad_aval	=	f_consulta_aval.ObtenerValor ("ciud_tcomuna")
	v_direccion_aval=	f_consulta_aval.ObtenerValor ("direccion")

end if

'response.Write("<PRE>" & consulta & "</PRE>")
'response.End()


'---------------------------------------------------------------------------------

response.Write("Por favor espere mientras se carga el documento...")
	
	Set control_carga = new Controlador_Boleta
	Dim itemfactura()
	suma_montos = 0

'Preparo datos para enviar al Controlador

	'boleta_electronica	=	conexion.consultaUno("execute obtenersecuencia 'boletas_electronicas'")
	'folio_boleta	=	control_carga.BuscarFolio(tipo)
	'boleta_electronica = cint(folio_boleta) + 1
	'boleta_electronica = conexion.consultauno("select foel_nact from folios_electronicos where foel_ccod=3")
	boleta_electronica = conexion.consultauno("Select a.bole_nboleta from boletas a where a.bole_ncorr="&bole_ncorr)
	'response.Write("bol: "&boleta_electronica)
	'response.End()
	' setea el receptor completo
	'1.- Nombre, Direccion
	'2.- Rut, Fecha Emision, Giro
	'5.- Comuna, ciudad
	arr_datos_persona = control_carga.BuscarPersona(pers_ncorr)
	arr_datos_direccion = control_carga.BuscarDireccion(pers_ncorr)
	arr_ciudad	=	control_carga.BuscarCiudad(arr_datos_direccion(2))
	'print_r arr_datos_persona, 0
	'response.write(ubound(detalle_item)-1)
	'response.End()
	for i=0 to ubound(detalle_item)-1
		redim PRESERVE itemfactura(i)
		'3.- Cantidad, Descripcion, Total, Abonos, Saldos
		cantidad = 1
		ding_mdocto = detalle_montos(i)
		if i=ubound(detalle_item)-1 then
			if carrera <> "" then
				dncr_tdesc1 = detalle_item(i) & "@@Rut Alumno: "& arr_datos_persona(0)&"-"&arr_datos_persona(5) & "@Carrera: "& carrera
			else
				dncr_tdesc1 = detalle_item(i) & "@@Rut Alumno: "& arr_datos_persona(0)&"-"&arr_datos_persona(5)
			end if
		else
			dncr_tdesc1 = detalle_item(i)	
		end if
		'suma montos
		suma_montos = suma_montos + ding_mdocto
		'response.Write(dncr_tdesc1)
		'response.End()
		ptotal = clng(cantidad) * clng(ding_mdocto)
		item = Array(clng(cantidad), cstr(dncr_tdesc1), clng(ding_mdocto), clng(ptotal), "ON")
		itemfactura(i) = item
	next
	
	
	'print_r itemfactura, 0
	'response.Write(itemfactura(0))
	'response.End()
		
	
	'rut = "17230398-6"
	'nombre = "NN"
	'ciudad = "Santiago"
	'comuna = "Providencia"
	'direccion = "Providencia 1515"
	
	rut = v_rut_aval
	'response.Write(rut)
	'response.End()
	nombre = arr_datos_persona(1)&" "&arr_datos_persona(2)&" "&arr_datos_persona(3)
	ciudad = arr_ciudad(0)
	comuna = arr_ciudad(1)
	direccion = arr_datos_direccion(0)&" "&arr_datos_direccion(1)
	'************** se modifican datos del Aval  04/09/2015
'	rut = arr_datos_persona(0)&"-"&arr_datos_persona(5)
	rut = v_rut_aval
	nombre = mid(v_nombre_aval,1,40)
	ciudad = v_ciudad_aval
	comuna = v_comuna_aval
	direccion = mid(v_direccion_aval,1,70)
	'response.write(ciudad & comuna & direccion)
	'response.End()
	'response.Write(direccion)
	'response.End()
	control_carga.SetReceptor rut, nombre, ciudad, comuna, direccion
'response.Write(rut&"-"& nombre&"-"& CIUDAD&"-"& COMUNA&"-"& dire_tcalle)


'response.End()
	' setea el registro (NOTA DE CREDITO)
	'codigo=61; Nota de Credito electronica
	folio = boleta_electronica
	fecha_format = split(f_emision, "-")
	fecha_emision = fecha_format(2) & "-" & fecha_format(1) & "-" & fecha_format(0)
	'fecha_emision = "2015-03-09"
	fecha_vmto = fecha_emision
	'fecha_emision = "2015-03-09"
	'fecha_vmto = "2015-03-09"
	'tipo = 39
	control_carga.SetRegistro tipo, folio, fecha_emision, fecha_vmto
'response.Write(fecha_vmto)
	control_carga.SetMontoTotal itemfactura
	'print_r itemfactura, 0
	'response.End()
'Envia XML a Cargar Boleta
'Antes de Ingresar boleta, consulta si existe
	
	arr_boleta = control_carga.BuscarBoleta(bole_ncorr)
	'print_r arr_boleta, 0
	'response.Write(bole_ncorr)
	'response.End()
	'control_carga.IngresarBoleta folio,rut,tipo,ding_mdocto,fecha_emision,itemfactura,sssusuario,bole_ncorr
	'response.End()
	'response.Write(arr_boleta(6))
	'response.End()
	'control_carga.IngresarBoleta folio,rut,tipo,ding_mdocto,fecha_emision,itemfactura,sssusuario,bole_ncorr

'comentar
'control_carga.IngresarBoleta folio,rut,tipo,ding_mdocto,fecha_emision,itemfactura,sssusuario,bole_ncorr
	'control_carga.IngresarBoleta folio,rut,tipo,ding_mdocto,fecha_emision,itemfactura,sssusuario,bole_ncorr
	if arr_boleta(0) <> "" then
	'response.Write("if")
	'response.End()
		control_carga.GenerarPDF rut, arr_boleta(4), tipo, arr_boleta(5), arr_boleta(6), "false"
	else
	
	'response.End()
		control_carga.IngresarBoleta folio,rut,tipo,ding_mdocto,fecha_emision,itemfactura,sssusuario,bole_ncorr
		control_carga.GenerarPDF rut, folio, tipo, suma_montos, fecha_emision, "false"
	end if


'Consulta y obtiene el PDF
	

'response.Write("esto="&IngresarBoleta)
%>
