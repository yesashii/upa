
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
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
'FECHA ACTUALIZACION 	:29/05/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ORDEN DE COMPRA
'LINEA			: 84 - 202
'*******************************************************************

' 8888888888888888888888888888888
' FUNCION MENSAJE DE ERRORES
'set errores = new CErrores

set pagina = new CPagina
pagina.Titulo = "Orden de compra"

' 8888888888888888888888888888888888888888888888888888
vibo_ccod = -1
rut_1	= request.querystring("pers_nrut")
if rut_1 = "" then
rut	= request.querystring("busqueda[0][pers_nrut]")
else
rut = rut_1
end if

'RESPONSE.WRITE("rut: "&rut&"<BR>")

digito_1	= request.querystring("pers_xdv")
if digito_1 = "" then
digito	= request.querystring("busqueda[0][pers_xdv]")
else
digito = digito_1
end if

' 8888888888888888888888888888888888888888888888888888

ordc_ncorr_1	= request.querystring("ordc_ncorr")
if ordc_ncorr_1 = "" then
ordc_ncorr	= request.querystring("busqueda[0][ordc_ncorr]")
else
ordc_ncorr = ordc_ncorr_1
end if

area_ccod_1	= request.querystring("busqueda[0][area_ccod]")
if area_ccod_1 = "" then
area_ccod	= request.querystring("area_ccod")
else
area_ccod	= area_ccod_1
end if

'RESPONSE.WRITE("1 area_ccod : "&area_ccod&"<BR>")

' 8888888888888888888888888888888888888888888888888888

v_boleta	= request.querystring("v_boleta")

if v_boleta="" or EsVacio(v_boleta) then
	v_boleta=0	' se establece por defecto el valor de NO uso de boleta honorarios
end if 

'if rut="" then
'	rut	= 0
'end if

'if digito="" then
'	digito	= 0
'end if

'**********************************************************
set botonera = new CFormulario
botonera.carga_parametros "orden_compra.xml", "botonera"

set conectar = new cconexion
conectar.inicializar "upacifico"

set conexion = new Cconexion2
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

Periodo 	= negocio.ObtenerPeriodoAcademico("POSTULACION")
v_usuario 	= negocio.ObtenerUsuario() 
sede		= negocio.obtenerSede
v_anos_ccod	= conectar.consultaUno("select year(getdate())")

'***********************************************
' 888888888888888888888888888888
' LLENAMOS EL CODIGO DE AREA
if area_ccod="" then
	area_ccod= conexion.consultaUno ("select top 1 a.area_ccod from  presupuesto_upa.protic.area_presupuesto_usuario a, presupuesto_upa.protic.area_presupuestal b where rut_usuario ="&v_usuario&" and a.area_ccod=b.area_ccod order by area_tdesc ")
end if

'RESPONSE.WRITE("2 area_ccod : "&area_ccod&"<BR>")

' 888888888888888888888888888888
'***********************************************
set f_orden = new CFormulario
f_orden.Carga_Parametros "orden_compra.xml", "buscador_orden"
f_orden.Inicializar conexion
f_orden.Consultar "select ''"
f_orden.Siguiente

f_orden.AgregaCampoCons "ordc_ncorr", ordc_ncorr

'v_existe=0
'RESPONSE.WRITE("1: v_existe :"&v_existe&"<BR>")

' Si no ha sido ingresada una OC o el resultado 
'if ordc_ncorr<>"" then

'v_btn_buscar="disabled"

	set f_busqueda = new CFormulario
	f_busqueda.Carga_Parametros "orden_compra.xml", "datos_proveedor"
	f_busqueda.Inicializar conectar
	 
		if ordc_ncorr<>"" then
		
		resul_nombre = 1
'			sql_orden="select protic.trunc(ordc_fentrega) as ordc_fentrega,cast(ordc_bboleta_honorario as varchar) as ordc_bboleta_honorario,* from ocag_orden_compra where cast(ordc_ncorr as varchar)='"&ordc_ncorr&"'"

' 8888888888888888888888888888888888888888888888888
' ESTA ES LA CONSULTA PRINCIPAL DEL FORMULARIO
' 8888888888888888888888888888888888888888888888888

'			sql_orden="select protic.trunc(ordc_fentrega) as ordc_fentrega,cast(ordc_bboleta_honorario as varchar) as ordc_bboleta_honorario "&_
'							", ordc_n	corr, pers_ncorr, fecha_solicitud, ordc_ndocto, ordc_tatencion, ordc_mmonto, ordc_ncotizacion, ordc_tobservacion "&_
'							", ordc_tcontacto, ordc_fentrega, ordc_tfono, cpag_ccod, sede_ccod, audi_tusuario, audi_fmodificacion "&_
'							", ordc_mretencion, ordc_mhonorarios, ordc_mneto, ordc_miva, cod_pre, ordc_mexento, area_ccod, tmon_ccod, vibo_ccod, tsol_ccod "&_
'							", ocag_frecepcion_presupuesto, ocag_responsable, ocag_fingreso, ocag_generador, ordc_bestado_final, ocag_baprueba "&_
'							"from ocag_orden_compra where cast(ordc_ncorr as varchar)='"&ordc_ncorr&"'"
							
			sql_orden="select protic.trunc(A.ordc_fentrega) as ordc_fentrega, cast(A.ordc_bboleta_honorario as varchar) as ordc_bboleta_honorario , A.ordc_ncorr "&_
							" , A.pers_ncorr, A.fecha_solicitud, A.ordc_ndocto, A.ordc_tatencion, A.ordc_mmonto, A.ordc_ncotizacion, A.ordc_tobservacion , A.ordc_tcontacto, A.ordc_fentrega "&_
							" , A.ordc_tfono, A.cpag_ccod, A.sede_ccod, A.audi_tusuario, A.audi_fmodificacion , A.ordc_mretencion, A.ordc_mhonorarios, A.ordc_mneto, A.ordc_miva, A.cod_pre "&_
							" , A.ordc_mexento, A.area_ccod, A.tmon_ccod, A.vibo_ccod, A.tsol_ccod , A.ocag_frecepcion_presupuesto, A.ocag_responsable, A.ocag_fingreso, A.ocag_generador "&_
							" , A.ordc_bestado_final, A.ocag_baprueba "&_
							" , b.PERS_TFONO , b.PERS_TFAX "&_
							" , b.pers_nrut, b.pers_xdv, asgi_tobservaciones  "&_
								" , LTRIM(RTRIM(b.pers_tnombre + ' ' + b.PERS_TAPE_PATERNO + ' ' + b.PERS_TAPE_MATERNO)) as v_nombre "&_
								" , LTRIM(RTRIM(b.pers_tnombre + ' ' + b.PERS_TAPE_PATERNO + ' ' + b.PERS_TAPE_MATERNO)) as PERS_TNOMBRE "&_	
							" from ocag_orden_compra A "&_
							" INNER JOIN personas b "&_
							" ON a.pers_ncorr = b.pers_ncorr "&_
							" INNER JOIN ocag_autoriza_solicitud_giro c "&_
							" ON a.ordc_ncorr = c.cod_solicitud "&_
							"where cast(a.ordc_ncorr as varchar) ='"&ordc_ncorr&"'"&_
							"  and c.tsol_ccod = 9 ORDER BY c.audi_fmodificacion DESC"

		else
			sql_orden="select -1 as vibo_ccod,0 as ordc_mretencion, 0 as ordc_mhonorarios, 0 as ordc_mhonorarios, 0 as ordc_mneto, 0 as ordc_miva "&_
						" ,0 as ordc_mexento, 0 as ordc_mmonto , cast(2 as varchar) as ordc_bboleta_honorario"
		end if
'Response.write("1. : "&sql_orden&"<br>")
'Response.end()

	f_busqueda.Consultar sql_orden
	f_busqueda.Siguiente

'v_existe=f_busqueda.nrofilas
'RESPONSE.WRITE("2: v_existe :"&v_existe&"<BR>")

' 8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
' ESTO ES LO PRIMERO QUE HACE AL PRESIONAR EL BOTON BUSCAR
' AGREGE EL "IF" POR QUE PRODUCIA ERROR CUANDO NO ENCONTRABA NADA EN LA TABLA "ocag_orden_compra"
' 8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

'IF v_existe = 0 THEN
'session("mensaje_error")="No existe la Orden de Compra N°: "&TRIM(ordc_ncorr)&"."
'Response.Redirect(request.ServerVariables("HTTP_REFERER"))
'END IF

ordc_ndocto=f_busqueda.obtenerValor("ordc_ndocto")
area_ccod2=f_busqueda.obtenerValor("area_ccod")
audi_tusuario=f_busqueda.obtenerValor("audi_tusuario")
vibo_ccod=f_busqueda.obtenerValor("vibo_ccod")
ordc_tobservacion=f_busqueda.obtenerValor("asgi_tobservaciones")
v_tsol_ccod=f_busqueda.obtenerValor("tsol_ccod")
ocag_baprueba = f_busqueda.obtenerValor("ocag_baprueba")

'**********************************************************
'8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
'888 INICIO

	pers_tnombre=f_busqueda.obtenerValor("pers_tnombre")

	'response.Write("pers_tnombre: "&pers_tnombre&"<BR>")	
	'response.Write("pers_tnombre_aut: "&pers_tnombre_aut&"<BR>")	
				
	'Rut: YO
	pers_nrut=f_busqueda.obtenerValor("pers_nrut")

	IF pers_tnombre="" THEN
	
		set f_personas3 = new CFormulario
		f_personas3.carga_parametros "tabla_vacia.xml", "tabla_vacia"
		f_personas3.inicializar conexion
		'f_personas.inicializar conectar

	'	sql_datos_persona= " Select top 1 codaux as pers_nrut,NomAux as pers_tnombre, NomAux as v_nombre "&_
	'					   	" from softland.cwtauxi a "&_
	'					   	" where CodAux='"&v_rut&"'"

		sql_datos_persona= " select CODAUX AS pers_nrut, RIGHT(RUTAUX,1) AS pers_xdv, NOMAUX AS pers_tnombre, NOMAUX AS v_nombre "&_
											" from softland.cwtauxi where cast(CodAux as varchar)='"&pers_nrut&"'"
		
		'response.write("sql_datos_persona 1 "&sql_datos_persona&"<br>")
			
		f_personas3.consultar sql_datos_persona
		f_personas3.Siguiente

		f_busqueda.AgregaCampoCons "pers_tnombre", f_personas3.obtenerValor("pers_tnombre")
		f_busqueda.AgregaCampoCons "v_nombre", f_personas3.obtenerValor("v_nombre")
		
		nombre = f_personas3.obtenerValor("v_nombre")
		v_pers_tnombre = f_personas3.obtenerValor("pers_tnombre")

		
	END IF

'888 FIN
'8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

'response.write(v_boleta)
'response.end()

'RESPONSE.WRITE("3. v_boleta :"&v_boleta&"<BR>")

if v_boleta	=0 then
	v_boleta=f_busqueda.obtenerValor("ordc_bboleta_honorario")
end if
		
'RESPONSE.WRITE("4. v_boleta :"&v_boleta&"<BR>")

'response.write(v_boleta)
'response.end()

f_busqueda.AgregaCampoCons "ordc_bboleta_honorario", cstr(v_boleta)

'response.write(v_boleta)
'response.end()

if Cstr(v_boleta)=Cstr(1) then
	segun_boleta="Honorario Total (Liquido 0.9)"
	txt_variable="10% Retencion"
	txt_neto	="Honorarios"
	valor_neto	="ordc_mhonorarios"
	valor_variable	="ordc_mretencion"
	row_span= 3
	v_variable	=f_busqueda.obtenerValor("ordc_mretencion")
	v_neto		=f_busqueda.obtenerValor("ordc_mhonorarios")
	v_total		=f_busqueda.obtenerValor("ordc_mhonorarios")

	v_totalizado=Clng(v_neto)-Clng(v_variable)
else
	segun_boleta="Precio Neto"
	txt_variable="19% IVA"
	txt_neto	="Neto"
	valor_neto	="ordc_mneto"
	valor_variable	="ordc_miva"
	row_span= 4
	v_neto		=f_busqueda.obtenerValor("ordc_mneto")
	v_variable	=f_busqueda.obtenerValor("ordc_miva")
	v_exento	=f_busqueda.obtenerValor("ordc_mexento")
	v_total		=f_busqueda.obtenerValor("ordc_mmonto")	
	v_totalizado=v_total
end if


'if area_ccod="" then
'	area_ccod= f_busqueda.ObtenerValor("area_ccod")
'end if

'RESPONSE.WRITE("3. area_ccod : "&area_ccod&"<BR>")

'set f_busqueda2 = new CFormulario

' 8888888888888888888888888888888888888888888888888888888888888
' CUANDO SE PRESIONA EL BOTON "BUSCAR" SE VIENE HACIA ACA
' 8888888888888888888888888888888888888888888888888888888888888

'RESPONSE.WRITE("ENTRO AQUI")
'RESPONSE.END()

'f_busqueda2.Carga_Parametros "orden_compra.xml", "buscador"
'f_busqueda2.Inicializar conexion
'f_busqueda2.Consultar "select ''"
'f_busqueda2.Siguiente
'f_busqueda2.AgregaCampoParam "area_ccod", "filtro",  "area_ccod in ( select area_ccod from  presupuesto_upa.protic.area_presupuesto_usuario where rut_usuario in ('"&v_usuario&"') )"
'f_busqueda2.AgregaCampoCons "area_ccod", area_ccod

'if rut	=0 then
'RESPONSE.WRITE("ENTRO AQUI 1")
'	rut=conectar.consultaUno("select top 1 pers_nrut from personas where pers_ncorr="&f_busqueda.obtenerValor("pers_ncorr"))
'end if

'if digito	=0 then
'RESPONSE.WRITE("ENTRO AQUI 2")
'	digito=conectar.consultaUno("select top 1 pers_xdv from personas where pers_nrut="&rut)
'end if

	'RESPONSE.WRITE("rut: "&rut&"<BR>")


if rut<>"" then
	set f_personas = new CFormulario
	f_personas.carga_parametros "tabla_vacia.xml", "tabla_vacia"
	f_personas.inicializar conexion
	'f_personas.inicializar conectar

	sql_datos_persona= " select CODAUX AS pers_nrut, RIGHT(RUTAUX,1) AS pers_xdv, NOMAUX AS pers_tnombre, NOMAUX AS v_nombre "&_
										" from softland.cwtauxi where cast(CodAux as varchar)='"&rut&"'"

'	sql_datos_persona= " SELECT PERS_NRUT, PERS_TNOMBRE pers_tnombre, PERS_TAPE_PATERNO + ' ' + PERS_TAPE_MATERNO as v_nombre "&_
'					   	" ,PERS_TFONO ,PERS_TFAX "&_
'					   	" FROM PERSONAS "&_
'					   	" WHERE PERS_NRUT='"&rut&"'"
'response.write sql_datos_persona
'response.end()

	f_personas.consultar sql_datos_persona
	f_personas.Siguiente
	
	v_pers_tnombre = f_personas.obtenerValor("pers_tnombre")
	nombre = f_personas.obtenerValor("v_nombre")

	f_busqueda.AgregaCampoCons "pers_tnombre", f_personas.obtenerValor("pers_tnombre")
	'f_busqueda.AgregaCampoCons "dire_tcalle", f_personas.obtenerValor("dire_tcalle")
	'f_busqueda.AgregaCampoCons "dire_tnro", f_personas.obtenerValor("dire_tnro")
	f_busqueda.AgregaCampoCons "pers_tfono", f_personas.obtenerValor("pers_tfono")
	f_busqueda.AgregaCampoCons "pers_tfax", f_personas.obtenerValor("pers_tfax")
	f_busqueda.AgregaCampoCons "pers_nrut", f_personas.obtenerValor("pers_nrut")
	f_busqueda.AgregaCampoCons "pers_xdv", digito
	'f_busqueda.AgregaCampoCons "ciudad", f_personas.obtenerValor("ciudad")
	f_busqueda.AgregaCampoCons "v_nombre", f_personas.obtenerValor("v_nombre")

	'8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
	'88 INICIO
	
	if v_pers_tnombre="" then
	set f_personas2 = new CFormulario
	f_personas2.carga_parametros "tabla_vacia.xml", "tabla_vacia"
	f_personas2.inicializar conectar

	sql_datos_persona= " SELECT PERS_NRUT, PERS_TNOMBRE pers_tnombre, PERS_TAPE_PATERNO + ' ' + PERS_TAPE_MATERNO as v_nombre "&_
					   	"FROM PERSONAS "&_
					   	"WHERE PERS_NRUT='"&rut&"'"
	
	f_personas2.consultar sql_datos_persona
	f_personas2.Siguiente
						
	v_pers_tnombre = f_personas2.obtenerValor("pers_tnombre")
	nombre = f_personas2.obtenerValor("v_nombre")
	
	f_busqueda.AgregaCampoCons "pers_tnombre", f_personas2.obtenerValor("pers_tnombre")
	f_busqueda.AgregaCampoCons "v_nombre", f_personas2.obtenerValor("v_nombre")
	
	end if
	'88 FIN
	'8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
	
	if nombre <> "" then
		resul_nombre = 1
	else 
		resul_nombre = 0	
	end if

end if

 set f_presupuesto = new CFormulario
 	f_presupuesto.Carga_Parametros "orden_compra.xml", "detalle_presupuesto"
 	f_presupuesto.Inicializar conectar
	
	if v_tsol_ccod <> "" then
	
	' ESTA CONSULTA LLENA EL CUADRO DE PRESUPUESTO - ESTA MALA
	
 	' sql_presupuesto="select * from ocag_presupuesto_orden_compra where cast(ordc_ncorr as varchar)='"&ordc_ncorr&"'"

	' ESTA CONSULTA LLENA EL CUADRO DE PRESUPUESTO

	 sql_presupuesto="select psol_ncorr AS porc_ncorr "&_
						", tsol_ccod "&_
						", cod_solicitud AS ordc_ncorr "&_
						", cod_pre, mes_ccod, anos_ccod "&_
						", psol_mpresupuesto AS porc_mpresupuesto "&_
						", audi_tusuario, audi_fmodificacion, psol_brendicion, cod_solicitud_origen "&_
						"from ocag_presupuesto_solicitud "&_
						"where cast(cod_solicitud as varchar) = '"&ordc_ncorr&"' and tsol_ccod="&v_tsol_ccod
	
	else
	
	sql_presupuesto = "select ''"
	
	end if
	
	'RESPONSE.WRITE("4 "&sql_presupuesto&"<BR>")
	
	f_presupuesto.consultar sql_presupuesto	
	filas_presu= f_presupuesto.nrofilas
	
 set f_detalle = new CFormulario
 	f_detalle.Carga_Parametros "orden_compra.xml", "detalle_producto"
 	f_detalle.Inicializar conectar

' 	sql_detalle="select * from ocag_detalle_orden_compra where cast(ordc_ncorr as varchar)='"&ordc_ncorr&"'"

	if ordc_ncorr <> "" then

 	sql_detalle="select dorc_ncorr, ordc_ncorr, tgas_ccod, dorc_tdesc, ccos_ncorr, dorc_ncantidad, tmon_ccod, dorc_nprecio_unidad "&_
						", dorc_ndescuento, dorc_nprecio_neto, audi_tusuario, audi_fmodificacion, dorc_bafecta "&_
						" from ocag_detalle_orden_compra where cast(ordc_ncorr as varchar)='"&ordc_ncorr&"'"
						
	else
	
	sql_detalle="select 0 AS dorc_ndescuento "
	
	end if

'response.write("6. sql_detalle :"&sql_detalle&"<br>")
'response.end()
	
	f_detalle.agregaCampoParam "ccos_ncorr","filtro", "pers_nrut="&v_usuario
	f_detalle.AgregaCampoParam "tgas_ccod", "filtro", "tgas_ccod in  (select distinct b.tgas_ccod  "&_ 
														"  from ocag_perfiles_areas a, ocag_tipo_gasto_perfil b, ocag_tipo_gasto c   "&_
														"  where a.pare_ccod=b.pare_ccod   "&_
														"  and b.tgas_ccod=c.tgas_ccod   "&_
														"  and a.pare_ccod in (select pare_ccod from ocag_perfiles_areas_usuarios where pers_nrut="&v_usuario&"))"

	f_detalle.consultar sql_detalle
	filas_detalle= f_detalle.nrofilas
	

set f_responsable = new CFormulario
	f_responsable.carga_parametros "tabla_vacia.xml", "tabla_vacia"
	f_responsable.inicializar conectar

	sql_responsable= "Select pers_nrut_responsable as pers_nrut,protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre,a.PERS_TEMAIL as email"&_
					  "	from ocag_responsable_area a, personas b "&_
					  "	where a.pers_nrut_responsable=b.pers_nrut "&_
					  "	and cast(a.pers_nrut as varchar)='"&v_usuario&"'"
					  
	'response.write("7. sql_responsable :"&sql_responsable&"<br>")
	
	f_responsable.consultar sql_responsable

'response.Write(sql_responsable)
'*****************************************************************************************
'***************	listas de seleccion para filas de tabla dinamica	******************	
set f_monedas = new CFormulario
f_monedas.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_monedas.inicializar conectar
sql_monedas= "Select * from ocag_tipo_moneda"
f_monedas.consultar sql_monedas

set f_meses = new CFormulario
f_meses.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_meses.inicializar conectar
sql_meses= "Select * from meses"
f_meses.consultar sql_meses


set f_anos = new CFormulario
f_anos.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_anos.inicializar conectar

'sql_anos= "select anos_ccod, case when anos_ccod=year(getdate()) then 1 else 0 end as orden "&_
'			" from anos where anos_ccod between year(getdate())-1 and year(getdate())+1 "&_
'			" order by orden desc "

sql_anos= "SELECT mes_ccod, mes_tdesc "&_
				" , CASE WHEN mes_ccod = 1 AND MONTH(GETDATE()) = 12 THEN YEAR(DATEADD(YEAR,1,GETDATE())) "&_
				" WHEN mes_ccod = 12 AND MONTH(GETDATE()) = 1 THEN YEAR(DATEADD(YEAR,-1,GETDATE())) "&_
				" ELSE YEAR(GETDATE()) END anos_ccod "&_
				" , case when "&_
				" CASE WHEN mes_ccod = 1 AND MONTH(GETDATE()) = 12 THEN YEAR(DATEADD(YEAR,1,GETDATE())) "&_
				" WHEN mes_ccod = 12 AND MONTH(GETDATE()) = 1 THEN YEAR(DATEADD(YEAR,-1,GETDATE())) "&_
				" ELSE YEAR(GETDATE()) END=year(getdate()) then 1 else 0 end as orden "&_
				" FROM meses WHERE mes_ccod = MONTH(DATEADD(month,1,GETDATE())) OR mes_ccod = MONTH(GETDATE()) OR mes_ccod = MONTH(DATEADD(month,-1,GETDATE())) "

f_anos.consultar sql_anos
'f_anos.AgregaCampoCons "anos_ccod", Year(Date())

'set f_tipo_gasto = new CFormulario
'f_tipo_gasto.carga_parametros "tabla_vacia.xml", "tabla_vacia"
'f_tipo_gasto.inicializar conectar
'sql_tipo_gasto= "Select top 5  tgas_ccod, ltrim(rtrim(tgas_tdesc)) as tgas_tdesc,pare_ccod from ocag_tipo_gasto"
'f_tipo_gasto.consultar sql_tipo_gasto


set f_tipo_gasto = new CFormulario
f_tipo_gasto.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_tipo_gasto.inicializar conectar

'sql_tipo_gasto= "Select  tgas_ccod, ltrim(rtrim(tgas_tdesc)) as tgas_tdesc,pare_ccod from ocag_tipo_gasto "

sql_tipo_gasto= "  select distinct b.tgas_ccod, ltrim(rtrim(tgas_tdesc)) as tgas_tdesc, tgas_cod_cuenta, a.pare_ccod  "&_ 
				"  from ocag_perfiles_areas a, ocag_tipo_gasto_perfil b, ocag_tipo_gasto c   "&_
				"  where a.pare_ccod=b.pare_ccod   "&_
				"  and b.tgas_ccod=c.tgas_ccod   "&_
				"  and a.pare_ccod in (select pare_ccod from ocag_perfiles_areas_usuarios where pers_nrut="&v_usuario&") order by tgas_tdesc"

'response.write("8. sql_tipo_gasto :"&sql_tipo_gasto&"<br>")
				
'response.write(sql_tipo_gasto)
'response.end()

f_tipo_gasto.consultar sql_tipo_gasto


set f_cod_pre = new CFormulario
f_cod_pre.carga_parametros "orden_compra.xml", "codigo_presupuesto"
f_cod_pre.inicializar conexion
f_cod_pre.consultar "select '' "

'sql_codigo_pre="(select distinct cod_pre, concepto_pre as valor from presupuesto_upa.protic.codigos_presupuesto where cod_area in ('"&area_ccod&"')) as tabla"

' ESTA CONSULTA ARMA EL CODIGO DE PRESUPUESTO

IF area_ccod2 <> "" THEN
area_ccod=area_ccod2
END IF

if audi_tusuario <> "" then
v_usuario=audi_tusuario
end if

sql_codigo_pre="(select distinct cod_pre, '('+cod_pre+')' + ' Area('+cast(cast(cod_area as numeric) as varchar)+')-'+concepto as valor "&_
			    " from presupuesto_upa.protic.presupuesto_upa_2011 	"&_
			    "	where cod_anio=2011 "&_
				"	and cod_area in (   select distinct area_ccod "&_ 
				"		 from  presupuesto_upa.protic.area_presupuesto_usuario  "&_
				"		 where rut_usuario in ("&v_usuario&") and cast(area_ccod as varchar)= '"&area_ccod&"') "&_
				" ) as tabla "

'RESPONSE.WRITE("5. sql_codigo_pre : "&sql_codigo_pre&"<BR>")
'Response.end()

f_cod_pre.agregaCampoParam "cod_pre","destino", sql_codigo_pre
f_cod_pre.consultar sql_codigo_pre
f_cod_pre.Siguiente


set f_centro_costo = new CFormulario
f_centro_costo.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_centro_costo.inicializar conectar

sql_centro_costo=" select a.ccos_ncorr,a.ccos_tcodigo as ccos_tcompuesto,ccos_tdesc "&_ 
					" from ocag_centro_costo a, ocag_permisos_centro_costo b "&_ 
					" where a.ccos_tcodigo=b.ccos_tcodigo "&_ 
					" and pers_nrut="&v_usuario

'response.write("10. sql_centro_costo :"&sql_centro_costo&"<br>")
'response.end()

f_centro_costo.consultar sql_centro_costo
'*****************************************************************************************
'***************	FIN listas de seleccion para filas de tabla dinamica	**************
'end if

'1. 88888888888888888888888888888888 ** MUESTRA EL SALDO DISPONIBLE ** 88888888888888888888888888888888 
set f_control_presupuesto = new CFormulario
f_control_presupuesto.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_control_presupuesto.inicializar conectar

sql_control_presupuesto= 	" select isnull(pr.cajcod,pa.cajcod) as cod_pre,pa.mes_ccod as mes_presu,isnull(ejecutado,0) as ejecutado,isnull(presupuestado,0) as presupuestado, isnull(presupuestado,0)-isnull(ejecutado,0) as saldo   "&_
							" from "&_
							" (select sum(valor) as presupuestado,cod_pre as cajcod, mes as mes_ccod    "&_
							"     from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2013      "&_
							"     where cod_pre in (select distinct cod_pre from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2013 where cod_area= '"&area_ccod&"' )   "&_
							"     group by cod_pre,mes    "&_
							" ) as pa  "&_
							" left outer join "&_
							" (select  isnull(sum(cast(psol_mpresupuesto as numeric)),0) as ejecutado, cod_pre as cajcod, mes_ccod    "&_
							"  from ocag_presupuesto_solicitud  "&_
							" where anos_ccod=2013 "&_
							" and tsol_ccod=9 "&_
							" and cod_pre in (select distinct cod_pre COLLATE SQL_Latin1_General_CP1_CI_AI from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2013 where cod_area= '"&area_ccod&"' ) "&_
							" group by cod_pre, mes_ccod "&_
							" ) as  pr   "&_
							" on pa.cajcod=pr.cajcod COLLATE SQL_Latin1_General_CP1_CI_AI "&_
							" and pa.mes_ccod= pr.mes_ccod "&_
							" order by cod_pre, mes_presu "

f_control_presupuesto.consultar sql_control_presupuesto

'response.Write("1. sql_control_presupuesto : "&sql_control_presupuesto&"<br>")

'1. 88888888888888888888888888888888 ** MUESTRA EL SALDO DISPONIBLE ** 88888888888888888888888888888888 

'88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
' JAIME PAINEMAL 20130910
 
 'DETALLE TIPO DE GASTOS (Cuentas Contables)
set f_mes_anio = new CFormulario
f_mes_anio.Carga_Parametros "fondo_fijo.xml", "busqueda"
f_mes_anio.Inicializar conectar

sql_mes_anio = " SELECT mes_ccod, mes_tdesc "&_ 
						" , CASE "&_ 
						" WHEN mes_ccod = 1 AND MONTH(GETDATE()) = 12 THEN YEAR(DATEADD(YEAR,1,GETDATE())) "&_ 
						" WHEN mes_ccod = 12 AND MONTH(GETDATE()) = 1 THEN YEAR(DATEADD(YEAR,-1,GETDATE())) "&_ 
						" ELSE YEAR(GETDATE()) "&_ 
						" END anos_ccod "&_ 
						" FROM meses "&_ 
						" WHERE mes_ccod = MONTH(DATEADD(month,1,GETDATE())) "&_ 
						" OR mes_ccod = MONTH(GETDATE()) "&_ 
						" OR mes_ccod = MONTH(DATEADD(month,-1,GETDATE()))" 
						
'RESPONSE.WRITE("2. sql_mes_anio "&sql_mes_anio&"<BR>")

f_mes_anio.Consultar sql_mes_anio					

 '88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
 'CONSULTA PARA EL ARREGLO

conectar.Ejecuta sql_mes_anio

set rec_carreras = conectar.ObtenerRS

'88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

rut= f_responsable.ObtenerValor("pers_nrut")

Usuario = negocio.ObtenerUsuario()
nombre_solicitante = conectar.ConsultaUno("select protic.obtener_nombre_completo(pers_ncorr, 'n') as nombre from personas where cast(pers_nrut as varchar) = '" & Usuario & "'")
tipo_soli = "Orden de Compra"
n_soli=ordc_ncorr
%>

<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<style>
.Mimetismo { background-color:#ADADAD;border: 1px #ADADAD solid; font-size:10px; font-style:oblique; font:bold;}
</style>
<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.10.1.min.js"></script>

<SCRIPT language="JavaScript">

/* 3. 88888888888888888888888888888888 ** MUESTRA EL SALDO DISPONIBLE ** 88888888888888888888888888888888 */
/*################################################################################*/
/* Genera un arreglo con el monto del presupuesto para cada codigo presupuestario */
//### Genera un arreglo con el monto del presupuesto para cada codigo presupuestario 
arr_presupuesto = new Array();
<%
i=0

f_control_presupuesto.primero
while f_control_presupuesto.Siguiente 

%>
arr_presupuesto[<%=i%>] = new Array();
arr_presupuesto[<%=i%>]["cod_pre"] = '<%=Cstr(f_control_presupuesto.ObtenerValor("cod_pre"))%>';
arr_presupuesto[<%=i%>]["mes_presu"] = '<%=Cstr(f_control_presupuesto.ObtenerValor("mes_presu"))%>';
arr_presupuesto[<%=i%>]["presupuestado"] = '<%=Cstr(f_control_presupuesto.ObtenerValor("presupuestado"))%>';
arr_presupuesto[<%=i%>]["ejecutado"] = '<%=Cstr(f_control_presupuesto.ObtenerValor("ejecutado"))%>';
arr_presupuesto[<%=i%>]["saldo"] = '<%=Cstr(f_control_presupuesto.ObtenerValor("saldo"))%>';
<%
i=i+1
wend%>


function Escribir(f){
	CalculaTotal(f);
}
//### Actualiza el presupuesto cada vez que cambia de codigo en el select de los codigos presupuestarios
function RevisaPresupuesto(cod_pre, nombre) {
ind	= extrae_indice(nombre);
mes_presu	=	document.detalle.elements["busqueda["+ind+"][mes_ccod]"].value;
// recorriendo el arreglo
	for (x=0;x<arr_presupuesto.length;x++){
		
		if((arr_presupuesto[x]["cod_pre"]==cod_pre)&&(arr_presupuesto[x]["mes_presu"]==mes_presu)){
			document.detalle.elements["busqueda["+ind+"][saldo]"].value = arr_presupuesto[x]["saldo"];
			document.detalle.elements["presupuesto["+ind+"][porc_mpresupuesto]"].value=0;
		}
	}
}

//### Actualiza el presupuesto cada vez que cambia de codigo en el select de los codigos presupuestarios 
function RevisaPresupuestoMes(mes_presu, nombre) {
ind	= extrae_indice(nombre);
cod_pre	=	document.detalle.elements["presupuesto["+ind+"][cod_pre]"].value;
// recorriendo el arreglo
	for (x=0;x<arr_presupuesto.length;x++){
		
		if((arr_presupuesto[x]["cod_pre"]==cod_pre)&&(arr_presupuesto[x]["mes_presu"]==mes_presu)){
			document.detalle.elements["busqueda["+ind+"][saldo]"].value = arr_presupuesto[x]["saldo"];
			document.detalle.elements["presupuesto["+ind+"][porc_mpresupuesto]"].value=0;
		}
	}
}

//### Obtiene el saldo de un presupuesto segun su codigo presupuestario y el mes del año ##
function ObtienePresupuesto(cod_pre, mes_presu) {
var saldo;
// recorriendo el arreglo
	for (x=0;x<arr_presupuesto.length;x++){
		
		if((arr_presupuesto[x]["cod_pre"]==cod_pre)&&(arr_presupuesto[x]["mes_presu"]==mes_presu)){
			saldo = arr_presupuesto[x]["saldo"];
		}
	}
	return saldo;
}

//### Carga el presupuesto disponible por cada codigo+area al momento de cargar la pagina 
function RecorrePresupuesto(){
   form = document.detalle;
   nombre_campo='cod_pre';
   variable='presupuesto';
   expr = variable + '\\[[0-9]+\\]\\['+nombre_campo+'\\]';
   exp_reg = new RegExp(expr, 'g') ;
   nro = form.elements.length;
   num =0;
   // busca todos los select cargados en la fila presupuesto
   for( i = 0; i < nro; i++ ) {
	  comp = form.elements[i];
	  str  = form.elements[i].name;

		if(m=str.match(exp_reg)!= null){
	   		ind=extrae_indice(str);
			mes_presu	=	document.detalle.elements["busqueda["+ind+"][mes_ccod]"].value;
			v_cod_pre	=	comp.options[form.elements["presupuesto["+ind+"][cod_pre]"].selectedIndex].value;
			document.detalle.elements["busqueda["+ind+"][saldo]"].value=ObtienePresupuesto(v_cod_pre, mes_presu);
   		}
	     num += 1;
	  }
}

// Valida que tenga presupuesto disponible para el codigo presupuestario seleccionado
function TienePresupuesto(indice){
	var formulario = document.forms["detalle"];

	v_valor	    =	formulario.elements["presupuesto["+indice+"][porc_mpresupuesto]"].value;
	v_saldo	    =	formulario.elements["busqueda["+indice+"][saldo]"].value;
	v_cod_pre	=	formulario.elements["presupuesto["+indice+"][cod_pre]"].options[formulario.elements["presupuesto["+indice+"][cod_pre]"].selectedIndex].text;
//document.myform.opttwo.options[document.myform.opttwo.selectedIndex].text;
	if (parseInt(v_valor)>=parseInt(v_saldo)){
		alert("El saldo de presupuesto para el codigo "+v_cod_pre+" es inferior al monto que intenta adjudicar");
		formulario.elements["presupuesto["+indice+"][porc_mpresupuesto]"].value=0;
		return false;
	}
	

}

/*################################################################################*/
/*----------------- FIN ARREGLO PRESUPUESTO --------------------*/
/* 3. 88888888888888888888888888888888 ** MUESTRA EL SALDO DISPONIBLE ** 88888888888888888888888888888888 */


arr_mes_anio = new Array();

<%
rec_carreras.MoveFirst
i = 0
while not rec_carreras.Eof
%>
arr_mes_anio[<%=i%>] = new Array();
arr_mes_anio[<%=i%>]["mes_ccod"] = '<%=rec_carreras("mes_ccod")%>';
arr_mes_anio[<%=i%>]["anos_ccod"] = '<%=rec_carreras("anos_ccod")%>';
<%	
	rec_carreras.MoveNext
	i = i + 1
wend
%>

function Cargar_codigos(formulario, mes_ccod, num)
{

		formulario.elements["busqueda["+num+"][anos_ccod]"].length = 0;

		for (i = 0; i < arr_mes_anio.length; i++)
		{ 
			if (arr_mes_anio[i]["mes_ccod"] == mes_ccod)
			 {
				op = arr_mes_anio[i]["anos_ccod"];
				formulario.elements["busqueda["+num+"][anos_ccod]"].value=op;
			   
			 }
		}
}


function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if%>

//document.detalle.elements["_detalle[0][dorc_bafecta]"].checked = false;
document.detalle.elements["detalle[0][dorc_ndescuento]"].value = 0;
}

function Validar(){
	return true;
}

function GuardarEnviar(){
	//
		//88888888888888888888888888888888888888888888888888888888888888888888888888
			
			//validar campos vacios
			formulario = document.detalle;
			
			// Monto Orden (*)
			v_valor	= formulario.elements["busqueda[0][ordc_mmonto]"].value;
			
			//Total Presupuestado 
			v_presupuesto= formulario.total_presupuesto.value;	
			
			//Total
			v_total	= formulario.total.value;
			
			//Fecha entrega
			if(document.detalle.elements["busqueda[0][ordc_fentrega]"].value.length == "0")
			{	
				alert("Ingrese Fecha");
				return false;
			}
			
			//N° Cotizacion 
			//if(document.detalle.elements["busqueda[0][ordc_ncotizacion]"].value.length == "0")
			//{	
			//	alert("Ingrese N° Cotizacion");
			//	return false;
			//}
			
			//Monto Orden
			if(document.detalle.elements["busqueda[0][ordc_mmonto]"].value.length == "0")
			{	
				alert("Ingrese Monto Orden");
				return false;
			}

			<% if Cstr(v_boleta)=1 then %>
				//Precio Unitario
				//v_total	= formulario.ordc_mhonorarios.value;
				
				//if((v_total>v_valor)||(v_total<v_valor)||(v_total>v_presupuesto)||(v_total<v_presupuesto)){	
				if((v_total!=v_valor)||(v_total>v_presupuesto)||(v_valor>v_presupuesto)) {	
				
					//alert("El monto de la Orden de Compra ingresada debe coincidir con el total de: \nA) Detalle de Honorarios ingresados y \nB) Total de presupuesto asignado");
					alert("El Monto Líquido de la Orden debe coincidir con el Total de Gasto y \nTotal Presupuestado debe coincidir con Honorarios" );
					return false;
				}
			<%else%>
				if((v_total>v_valor)||(v_total<v_valor)||(v_total>v_presupuesto)||(v_total<v_presupuesto)){	
				
					alert("El monto de la Orden de Compra ingresada debe coincidir con el total de: \nA) Detalle de productos ingresados y \nB) Total de presupuesto asignado");
					return false;
				}
			<%end if%>

		//88888888888888888888888888888888888888888888888888888888888888888888888888
		var f = new Date(); 
		miFecha =(f.getDate() + "/" + (f.getMonth() +1) + "/" + f.getFullYear());	
		//email=prompt('Ingrese Correo electronico Jefe Directo:  (Ejemplo: jefe@upacifico.cl)','');
		
		if(document.detalle.elements["busqueda[0][ordc_fentrega]"].value.length == "0")
		{	
			alert("Ingrese Fecha");
			return false;
		}
		if (document.detalle.elements["email"].value.length<5) {
			email=prompt('Ingrese Correo electronico Jefe Directo:  (Ejemplo: jefe@upacifico.cl)','');
		}
		else{
			if (confirm("Se enviara un correo a: " + document.detalle.elements["email"].value)){
				email=document.detalle.elements["email"].value;
			}
			else{
				email=prompt('Ingrese Correo electronico Jefe Directo:  (Ejemplo: jefe@upacifico.cl)','');
			}
		}
		
		var re  = /^([a-zA-Z0-9_.-])+@((upacifico)+.)+(cl)+$/; 
		
		if (!re.test(email)) { 
			
			alert ("Dirección de email inválida "); 
			return false; 
		} 
		
		
		if((email != "")&&(email != null)){
	
		window.open("http://admision.upacifico.cl/postulacion/www/proc_envio_solicitud_giro.php?nombre=<%=nombre_solicitante%>&solicitud=<%=tipo_soli%>&n_soli=<%=n_soli%>&fecha="+miFecha+"&correo="+email)
		//return false;
		return true;
		}else{
			alert("Debe Ingresar un Correo Electronico.")
			return false;	
		}

}

function ImprimirOC(){
	url="imprimir_oc.asp?ordc_ncorr=<%=ordc_ncorr%>&pers_nrut=<%=pers_nrut%>";
	window.open(url,'ImpresionOC', 'scrollbars=yes, menubar=no, resizable=yes, width=700,height=700');	
}

function Enviar(){
	
	//validar campos vacios
	formulario = document.detalle;
	
	// Monto Orden (*)
	v_valor	= formulario.elements["busqueda[0][ordc_mmonto]"].value;
	
	//Total Presupuestado 
	v_presupuesto= formulario.total_presupuesto.value;	
	
	//Total
	v_total	= formulario.total.value;
		
	//Fecha entrega
	if(document.detalle.elements["busqueda[0][ordc_fentrega]"].value.length == "0")
	{	
		alert("Ingrese Fecha");
		return false;
	}
	
	//N° Cotizacion 
	//if(document.detalle.elements["busqueda[0][ordc_ncotizacion]"].value.length == "0")
	//{	
	//	alert("Ingrese N° Cotizacion");
	//	return false;
	//}
	
	//Monto Orden
	if(document.detalle.elements["busqueda[0][ordc_mmonto]"].value.length == "0")
	{	
		alert("Ingrese Monto Orden");
		return false;
	}

	<% if Cstr(v_boleta)=1 then %>
	
		//Precio Unitario
		//v_total	= formulario.ordc_mhonorarios.value;
		
		//if((v_total>v_valor)||(v_total<v_valor)||(v_total>v_presupuesto)||(v_total<v_presupuesto)){	
		if((v_total!=v_valor)||(v_total>v_presupuesto)||(v_valor>v_presupuesto)) {	

			//alert("El monto de la Orden de Compra ingresada debe coincidir con el total de: \nA) Detalle de Honorarios ingresados y \nB) Total de presupuesto asignado");
			alert("El Monto Líquido de la Orden debe coincidir con el Total de Gasto y \nTotal Presupuestado debe coincidir con Honorarios" );
			return false;
		}
	<%else%>
		if((v_total>v_valor)||(v_total<v_valor)||(v_total>v_presupuesto)||(v_total<v_presupuesto)){	

			alert("El monto de la Orden de Compra ingresada debe coincidir con el total de: \nA) Detalle de productos ingresados y \nB) Total de presupuesto asignado");
			return false;
		}
	<%end if%>
	return true;
}

function RecalcularTotales(){
	var formulario = document.forms["detalle"];
	v_total_solicitud = 0;
	v_total_iva = 0;
	v_total_neto = 0;
	v_total_exento = 0;
// Boleta de honorarios
	<% if v_boleta=1 then %>
		//alert("boleta si");
		for (var i = 0; i <= contador; i++) {
			if(formulario.elements["detalle["+i+"][dorc_nprecio_neto]"]){		
				v_valor	=	formulario.elements["detalle["+i+"][dorc_nprecio_neto]"].value;
				if (v_valor){
					v_total_solicitud = v_total_solicitud + parseInt(v_valor);
				}
			}
		}
		detalle.ordc_mhonorarios.value	=	eval(v_total_solicitud);
		detalle.total.value				=	Math.round(v_total_solicitud*0.9)
		detalle.ordc_mretencion.value	=	eval(Math.round(v_total_solicitud*1.10)-v_total_solicitud);
	<%else%>
	//alert("boleta no");
// Sin boletas de Honorarios, se considera el check para valores exentos y afectos
		for (var i = 0; i <= contador; i++) {
			if(formulario.elements["detalle["+i+"][dorc_nprecio_neto]"]){
				v_valor	=	formulario.elements["detalle["+i+"][dorc_nprecio_neto]"].value;
				if (v_valor){
					if (formulario.elements["_detalle["+i+"][dorc_bafecta]"].checked){ // Producto afecto, se calcula Iva
						v_total_neto=	parseInt(v_total_neto) + parseInt(v_valor);
						v_iva		=	eval(Math.round(v_valor*1.19)-parseInt(v_valor));
						v_total_iva	=	eval(v_total_iva+v_iva);
					}else{
						//v_total_iva=v_total_iva+v_iva
						v_total_exento=v_total_exento+parseInt(v_valor);
					}	
					v_total_solicitud = v_total_solicitud + parseInt(v_valor);
				}
			}
		}	
		detalle.ordc_mneto.value	=	parseInt(v_total_neto);
		detalle.ordc_miva.value		=	parseInt(v_total_iva);
		detalle.exento.value		=	parseInt(v_total_exento);
		detalle.total.value			=	parseInt(v_total_solicitud)+parseInt(v_total_iva);
	<%end if%>
}

function CalculaTotal(objeto){

	indice=extrae_indice(objeto.name);
	if(indice!=""){
		v_cantidad	=	detalle.elements["detalle["+indice+"][dorc_ncantidad]"].value;
		v_unidad	=	detalle.elements["detalle["+indice+"][dorc_nprecio_unidad]"].value;		
		v_descuento	=	detalle.elements["detalle["+indice+"][dorc_ndescuento]"].value;	
		v_neto		=	eval(v_cantidad*(v_unidad-v_descuento));
		detalle.elements["detalle["+indice+"][dorc_nprecio_neto]"].value=v_neto;
	}
RecalcularTotales()
}

function ChequeaValor(obj){
	v_name=obj.name;
	v_valor=obj.value;
	indice=extrae_indice(v_name);
	if(document.detalle.elements["busqueda[0][ordc_bboleta_honorario]"][0].checked){
		alert("Cuando seleccione Boleta de Honorario no puede incluir productos exentos de Iva");
		document.detalle.elements["_detalle["+indice+"][dorc_bafecta]"].checked=true;
	}
CalculaTotal(obj);	
}

/*****************************************************************************/
/*// PRIMERA TABLA DINAMICA //*/
<%if filas_detalle >0 then%>
var contador=<%=filas_detalle%>-1;
<%else%>
var contador=0;
<%end if%>
function validaFila(id, nro,boton)
{
	if (document.detalle.elements["detalle["+nro+"][dorc_tdesc]"].value == ''){
	  alert('Debe ingresar una descripcion valida');
	  return false;
	}
	if(document.detalle.elements["detalle["+nro+"][dorc_nprecio_unidad]"].value != ''){
		addRow(id, nro, boton );habilitaUltimoBoton();
	}else{
		alert('Debe completar las filas del detalle para ingresar a la orden de compra');
	}
}

function eliminaFilas()
{/*
var check=document.detalle.getElementsByTagName('input');
var cantidadCheck=0;
var checkbox=new Array();
var tabla = document.getElementById('tb_busqueda_detalle');

 for (y=0;y<check.length;y++){if (check[y].type=="checkbox"){checkbox[cantidadCheck++]=check[y];}}
	for (x=0;x<cantidadCheck;x++){
		  if (checkbox[x].checked) {deleterow(checkbox[x]);}
	 }
 if (tabla.tBodies[0].rows.length < 2)
    {addRow('tb_busqueda_detalle', cantidadCheck, 0 );}

 habilitaUltimoBoton();*/
 
 var Count = 0
$('.remove').each(function(){
   var checkbox = $(this);
   if(checkbox.is(':checked')==true){
	Count++;
   }
});

	if(Count==0){
		alert("Debe seleccionar una fila para eliminar");
	}else{
	deleterow(Count)		
	}
	
	
	habilitaUltimoBoton();

}

function habilitaUltimoBoton()
{
var objetos=document.detalle.getElementsByTagName('input');
var cantidadBoton=0;
var botones=new Array();

 for (y=0;y<objetos.length;y++){
	 if (objetos[y].type=="button" && objetos[y].name=="agregarlinea"){
	 	cantidadBoton=cantidadBoton+1;
		botones[cantidadBoton]=objetos[y];
		botones[cantidadBoton].disabled=true;
	 }
 }
	botones[cantidadBoton].disabled=false;
	//alert("cantidad "+cantidadBoton);
	if(cantidadBoton>=10){
		botones[cantidadBoton].disabled=true;
	}
}

function addRow(id, nro, boton ){
contador++;
$("#tb_busqueda_detalle").append("<tr><td><INPUT TYPE=\"checkbox\" class=\"remove\" name=\"detalle["+ contador +"][checkbox]\" value=\""+ contador +"\"  ></td>"+
"<td><select name= \"detalle["+ contador +"][tgas_ccod]\">"+
"	<%f_tipo_gasto.primero%> "+
" <%while f_tipo_gasto.Siguiente %>"+
"<option value=\"<%=f_tipo_gasto.ObtenerValor("tgas_ccod")%>\" ><%=f_tipo_gasto.ObtenerValor("tgas_tdesc")%></option>"+
"<%wend%>"+
"</select></td>"+
"<td><INPUT TYPE=\"text\" name=\"detalle["+ contador +"][dorc_tdesc]\" size=\"10\" ></td>"+
"<td><select name= \"detalle["+ contador +"][ccos_ncorr]\">"+
"<%f_centro_costo.primero%>"+
"	<%while f_centro_costo.Siguiente %>"+
"<option value=\"<%=f_centro_costo.ObtenerValor("ccos_ncorr")%>\" ><%=f_centro_costo.ObtenerValor("ccos_tcompuesto")%></option>"+
"<%wend%>"+
"</select></td>"+
"<td align=\"center\"><INPUT TYPE=\"text\" name=\"detalle["+ contador +"][dorc_ncantidad]\" value=\"0\" size=\"5\" onblur=\"CalculaTotal(this)\" maxlength=\"5\"></td>"+
"<td align=\"center\"><INPUT TYPE=\"checkbox\" name=\"_detalle["+ contador +"][dorc_bafecta]\" value=\"1\" size=\"10\" checked=\"checked\" onClick=\"ChequeaValor(this);\" maxlength=\"10\"><input name=\"detalle["+ contador +"][dorc_bafecta]\" type=\"HIDDEN\" value=\"1\"/></td>"+
"<td><INPUT TYPE=\"text\" name=\"detalle["+ contador +"][dorc_nprecio_unidad]\" value=\"0\" size=\"10\" onblur=\"CalculaTotal(this)\" maxlength=\"10\"></td>"+
"<td><INPUT TYPE=\"text\" name=\"detalle["+ contador +"][dorc_ndescuento]\" value=\"0\" size=\"10\" onblur=\"CalculaTotal(this)\" maxlength=\"10\"></td>"+
"<td><INPUT TYPE=\"text\" name=\"detalle["+ contador +"][dorc_nprecio_neto]\" onblur=\"Escribir(this)\" size=\"10\" maxlength=\"10\"></td>"+
"<td><INPUT class=boton TYPE=\"button\" id=\"agregarlinea\" name=\"agregarlinea\" value=\"+\" onclick=\"validaFila('tb_busqueda_detalle',"+contador+",this)\">&nbsp;"+
"<INPUT class=boton TYPE=\"button\" name=\"quitarlinea\" value=\"-\" onclick=\"eliminaFilas()\"></td></tr>");

document.detalle.elements["contador"].value = contador;
}

function deleterow(node) {
/*var tr = node.parentNode;
while (tr.tagName.toLowerCase() != "tr")
	tr = tr.parentNode;
	tr.parentNode.removeChild(tr);*/
			if (node >=1){
	$('#tb_busqueda_detalle').delegate('input:button', 'click', function () {
    $(this).closest('tr').remove();
		habilitaUltimoBoton();
	});
	}
	
}

//******* FIN PRIMERA TABLA DINAMICA *******//
/*****************************************************************************/


/*****************************************************************************/
//******* SEGUNDA TABLA DINAMICA   *********//
<%if filas_presu >0 then%>
var contador2=<%=filas_presu%>-1;
<%else%>
var contador2=0;
<%end if%>

<%f_cod_pre.primero
f_cod_pre.Siguiente%>
valor_saldo=ObtienePresupuesto('<%=f_cod_pre.obtenerValor("cod_pre")%>');

function validaFila2(id, nro,boton){
	if (document.detalle.elements["presupuesto["+nro+"][porc_mpresupuesto]"].value >0){ 
		addRow2(id, nro, boton );habilitaUltimoBoton2(); 
	}else{
		alert('Debe ingresar todos los campos del presupuesto que usará');
		return false;
	}
}

function addRow2(id, nro, boton ){
	/*
contador2= contador2 + 1;
var tbody = document.getElementById(id).getElementsByTagName("TBODY")[0];
var row = document.createElement("TR");
row.align="left";

//********Nro de detalle********************
var td1 = document.createElement("TD");
var aElement=document.createElement("<INPUT TYPE=\"checkbox\" name=\"presupuesto["+ contador2 +"][check]\" value=\""+ contador2 +"\"  >");
td1.appendChild (aElement);

//******** cod_pre ***************
var td2 = document.createElement("TD");
var iElement=document.createElement("Select");
iElement.name="presupuesto["+ contador2 +"][cod_pre]";
i=0;
	<%	
	f_cod_pre.primero
	while f_cod_pre.Siguiente 
	%>
	i=i+1;
		var v_option=document.createElement("Option");
		v_option.value='<%=f_cod_pre.ObtenerValor("cod_pre")%>';// Valor del option
		v_option.innerHTML='<%=f_cod_pre.ObtenerValor("valor")%>'; // texto del option
		iElement.appendChild(v_option);	
	<%wend%>	
td2.appendChild (iElement);

//******** mes_ccod ****************
var td3 = document.createElement("TD");
var iElement=document.createElement("Select");
iElement.name="presupuesto["+ contador2 +"][mes_ccod]";
i=0;
	<%	
	f_meses.primero
	while f_meses.Siguiente 
	%>
	i=i+1;
		var v_option=document.createElement("Option");
		v_option.value=<%=f_meses.ObtenerValor("mes_ccod")%>;// Valor del option
		v_option.innerHTML='<%=f_meses.ObtenerValor("mes_tdesc")%>'; // texto del option
		iElement.appendChild(v_option);	
	<%wend%>	
td3.appendChild (iElement)

//******** anos_ccod ***************
var td4 = document.createElement("TD");
var iElement=document.createElement("Select");
iElement.name="presupuesto["+ contador2 +"][anos_ccod]";
i=0;
	<%	
	f_anos.primero
	while f_anos.Siguiente 
	%>
	i=i+1;
		var v_option=document.createElement("Option");
		v_option.value=<%=f_anos.ObtenerValor("anos_ccod")%>;// Valor del option
		v_option.innerHTML='<%=f_anos.ObtenerValor("anos_ccod")%>'; // texto del option
		iElement.appendChild(v_option);	
	<%wend%>	
td4.appendChild (iElement)

//******** porc_mpresupuesto ***************
var td5 = document.createElement("TD");
var iElement=document.createElement("<INPUT TYPE=\"text\" name=\"presupuesto["+ contador2 +"][porc_mpresupuesto]\" size=\"10\" onblur=\"SumaTotalPresupuesto(this);\" >");
td5.appendChild (iElement)


//********Agregar********************
var td6 		= 	document.createElement("TD");
var iElement 	=	document.createElement("<INPUT class=boton TYPE=\"button\" name=\"agregarlinea2\" value=\"+\" onclick=\"validaFila2('tb_presupuesto',"+contador2+",this)\">");
var iElement2 	=	document.createElement("<INPUT class=boton TYPE=\"button\" name=\"quitarlinea2\" value=\"-\" onclick=\"eliminaFilas2()\">");
td6.appendChild (iElement)
td6.appendChild (iElement2)

row.appendChild(td1);
row.appendChild(td2);
row.appendChild(td3);
row.appendChild(td4);
row.appendChild(td5);
row.appendChild(td6);
tbody.appendChild(row);*/

contador2++;
$("#tb_presupuesto").append("<tr><td align=\"center\"><INPUT TYPE=\"checkbox\" class=\"remove2\" align=\"center\" name=\"presupuesto["+ contador2 +"][checkbox]\" value=\""+ contador2 +"\"  ></td>"+
"<td><select name= \"presupuesto["+ contador2 +"][cod_pre]\" onChange=\"RevisaPresupuesto(this.value,this.name);\">"+
"<%f_cod_pre.primero%> "+
"<%while f_cod_pre.Siguiente %>"+
"<option value=\"<%=f_cod_pre.ObtenerValor("cod_pre")%>\" ><%=f_cod_pre.ObtenerValor("valor")%></option>"+
"<%wend%>"+
"</select></td>"+
//"<td><select name= \"presupuesto["+ contador2 +"][mes_ccod]\">"+
//"<%f_meses.primero%>"+
//"	<%while f_meses.Siguiente %>"+
//"<option value=\"<%=f_meses.ObtenerValor("mes_ccod")%>\" ><%=f_meses.ObtenerValor("mes_tdesc")%></option>"+
//"<%wend%>"+
//"</select></td>"+
//"<td><select name= \"presupuesto["+ contador2 +"][anos_ccod]\">"+ 
//"<%f_anos.primero%>"+
//"	<%while f_anos.Siguiente%>"+
//"<option value=\"<%=f_anos.ObtenerValor("anos_ccod")%>\" ><%=f_anos.ObtenerValor("anos_ccod")%></option>"+
//"<%wend%>"+
//"</select>  </td>"+
"<td><select name= \"busqueda["+ contador2 +"][mes_ccod]\" onChange=\"Cargar_codigos(this.form, this.value, " +contador2+ "); RevisaPresupuestoMes(this.value,this.name);\">"+
"<%f_anos.primero%>"+
"	<%while f_anos.Siguiente %>"+
"<option value=\"<%=f_anos.ObtenerValor("mes_ccod")%>\" ><%=f_anos.ObtenerValor("mes_tdesc")%></option>"+
"<%wend%>"+
"</select></td>"+
"<td>"+ 
"<%f_anos.primero%>"+
"<%f_anos.Siguiente%>"+
"<input type=\"text\" name=\"busqueda["+ contador2 +"][anos_ccod]\" value=\"<%=f_anos.ObtenerValor("anos_ccod")%>\" >"+
"</td>"+
"<td><INPUT TYPE=\"text\" name=\"presupuesto["+ contador2 +"][porc_mpresupuesto]\" size=\"10\" onblur=\"SumaTotalPresupuesto(this);\" ></td>"+
"<td><INPUT TYPE=\"text\" class=\"Mimetismo\" name=\"busqueda["+ contador2 +"][saldo]\" size=\"10\" value="+valor_saldo+" readonly ></td>"+
"<td><INPUT class=boton TYPE=\"button\" name=\"agregarlinea2\" value=\"+\" onclick=\"validaFila2('tb_presupuesto',"+contador2+",this)\">&nbsp;"+
"<INPUT class=boton TYPE=\"button\" name=\"quitarlinea2\" value=\"-\" onclick=\"eliminaFilas2()\"></td></tr>");

document.detalle.elements["contador2"].value = contador2;
}

function eliminaFilas2()
{/*
var check=document.detalle.getElementsByTagName('input');
var objetos=document.detalle.getElementsByTagName('input');
var cantidadCheck=0;
var checkbox=new Array();
var tabla2 = document.getElementById('tb_presupuesto');
var Count = 0
	for(i=0;i<objetos.length;i++)
	{
	// si es un checkbox y corresponde al checkbox delantero y no al de boleta afecta
		if((objetos[i].type == "checkbox")&&(objetos[i].name.indexOf("check") >=1)&&(objetos[i].name.indexOf("presupuesto") ==0)){
			if(document.getElementsByTagName("input")[i].checked){
				deleterow2(objetos[i]);
				Count++;
			}
		}
	}
	if(Count==0){
		alert("Debe seleccionar una fila para eliminar");
	}
    if (tabla2.tBodies[0].rows.length < 2){
		addRow2('tb_presupuesto', cantidadCheck, 0 );
	}
	habilitaUltimoBoton2();*/
	
	var Count = 0
$('.remove2').each(function(){
   var checkbox = $(this);
   if(checkbox.is(':checked')==true){
	Count++;
   }
});

	if(Count==0){
		alert("Debe seleccionar una fila para eliminar");
	}else{
	deleterow2(Count)		
	}
	
	
	habilitaUltimoBoton2();
}

function habilitaUltimoBoton2(){
var objetos2=document.detalle.getElementsByTagName('input');
var cantidadBoton=0;
var botones2=new Array();

 for (y=0;y<objetos2.length;y++){
	 if (objetos2[y].type=="button" && objetos2[y].name=="agregarlinea2"){
	 	cantidadBoton=cantidadBoton+1;
		botones2[cantidadBoton]=objetos2[y];
		botones2[cantidadBoton].disabled=true;
	 }
 }
	botones2[cantidadBoton].disabled=false;
	//alert("cantidad "+cantidadBoton);
	if(cantidadBoton>=10){
		botones2[cantidadBoton].disabled=true;
	}
}

function deleterow2(node){
/*var tr2 = node.parentNode;
while (tr2.tagName.toLowerCase() != "tr")
	tr2 = tr2.parentNode;
	tr2.parentNode.removeChild(tr2);*/
	
	    if (node >=1){
	$('#tb_presupuesto').delegate('input:button', 'click', function () {
    $(this).closest('tr').remove();
		habilitaUltimoBoton2();
	});
	}
}

function SumaTotalPresupuesto(valor){

	var formulario = document.forms["detalle"];
	v_total_presupuesto = 0;
	v_indice=extrae_indice(valor.name);
	
	TienePresupuesto(v_indice);

	for (var i = 0; i <= contador2; i++) {
		if(formulario.elements["presupuesto["+i+"][porc_mpresupuesto]"]){
			v_valor	=	formulario.elements["presupuesto["+i+"][porc_mpresupuesto]"].value;
			if (v_valor){
				v_total_presupuesto = v_total_presupuesto + parseInt(v_valor);
			}
		}
	}
	detalle.elements["total_presupuesto"].value=v_total_presupuesto;
}


//******* FIN SEGUNDA TABLA DINAMICA *******//
/*****************************************************************************/

function NumeroValido(elemento){
	if (elemento.value>=0) {
			return true;
	}else{
		//alert("Debe ingresar un valor numerico mayor a cero!!");
		elemento.value="";
		elemento.focus();
		return false;
	}
	return true;
}

<%if ordc_ncorr<>"" then%>

function CambiaValor(obj){
	v_name=obj.name;
	v_valor=obj.value;
	
	filtro="";
	v_area	=	<%=area_ccod%>;
	ordc_ncorr	=	document.detalle.ordc_ncorr.value;
	if (v_area!=""){
		filtro= "&busqueda[0][area_ccod]="+v_area;	
	}
<% if Cstr(v_boleta)<>"" then %>
	v_pers_nrut	=	document.detalle.elements["busqueda[0][pers_nrut]"].value;
	v_pers_xdv	=	document.detalle.elements["busqueda[0][pers_xdv]"].value;
	if (v_pers_nrut!=""){
		filtro= filtro+"&pers_nrut="+v_pers_nrut;	
	}
	if (v_pers_xdv!=""){
		filtro= filtro+"&pers_xdv="+v_pers_xdv;	
	}
<%end if%>
	document.detalle.action= "buscar_orden_compra.asp?ordc_ncorr="+ordc_ncorr+"&v_boleta="+v_valor+""+filtro;
	document.detalle.method = "post";
	document.detalle.submit();
}

function BuscarPersona(){

	formulario = document.detalle;
	v_rut	=	formulario.elements["busqueda[0][pers_nrut]"].value;
	v_xdv	=	formulario.elements["busqueda[0][pers_xdv]"].value;
	rut_alumno 	= formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value;
	v_area		=	formulario.elements["busqueda[0][area_ccod]"].value;
	ordc_ncorr		=	document.detalle.ordc_ncorr.value;
	<% if Cstr(v_boleta)=1 then %>
		v_valor=1
	<%else%>
		v_valor=2
	<%end if%>
	if (formulario.elements["busqueda[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].focus();
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	  }
	location.href="buscar_orden_compra.asp?ordc_ncorr=<%=ordc_ncorr%>&busqueda[0][area_ccod]="+v_area+"&v_boleta="+v_valor+"&pers_nrut="+v_rut+"&pers_xdv="+v_xdv;
}


<%else%>

function CambiaValor(obj){
	v_name=obj.name;
	v_valor=obj.value;
	filtro="";
	v_area	=	<%=area_ccod%>;

	if (v_area!=""){
		filtro= "&busqueda[0][area_ccod]="+v_area;	
	}
<% if Cstr(v_boleta)<>"" then %>
	v_pers_nrut	=	document.detalle.elements["busqueda[0][pers_nrut]"].value;
	v_pers_xdv	=	document.detalle.elements["busqueda[0][pers_xdv]"].value;
	if (v_pers_nrut!=""){
		filtro= filtro+"&pers_nrut="+v_pers_nrut;	
	}
	if (v_pers_xdv!=""){
		filtro= filtro+"&pers_xdv="+v_pers_xdv;	
	}
<%end if%>
	document.detalle.action= "buscar_orden_compra.asp?v_boleta="+v_valor+""+filtro;
	document.detalle.method = "post";
	document.detalle.submit();
}


//**************************************************************/

function BuscarPersona(){

	formulario = document.detalle;
	v_rut	=	formulario.elements["busqueda[0][pers_nrut]"].value;
	v_xdv	=	formulario.elements["busqueda[0][pers_xdv]"].value;
	rut_alumno 	= formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value;
	v_area		=	formulario.elements["busqueda[0][area_ccod]"].value;

	<% if Cstr(v_boleta)=1 then %>
		v_valor=1
	<%else%>
		v_valor=2
	<%end if%>
	
	if (formulario.elements["busqueda[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].focus();
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	  }
	location.href="buscar_orden_compra.asp?busqueda[0][area_ccod]="+v_area+"&v_boleta="+v_valor+"&pers_nrut="+v_rut+"&pers_xdv="+v_xdv;
}

//**************************************************************/

<%end if%>
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="RecorrePresupuesto();Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">

<!-- 88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888 -->		

<!--
<table border="0" cellpadding="0" cellspacing="0" width="80%" align="center">
            <tr>
              <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8" background="../imagenes/top_r1_c2.gif"></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td>

INICIO SUB-TABLA 1 	  
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="100" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador</font></div></td>
                    <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                  </tr>
				</table>
FIN SUB-TABLA 1 

			  </td>
              <td align="left"><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>              
            </tr>
            <tr>
              <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td background="../imagenes/top_r3_c2.gif"></td>
              <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE">
			<BR>

INICIO SUB-TABLA 2 ** AQUI ESTA TODO EL BUSCADOR **

				<form name="buscador">                

                      <table width="100%" border="0" align="left">
                        <tr>
                          <td width="35"></td>
						  <td width="190"><div align="left"><strong>N° Orden Compra</strong>  </div></td>
						  <td width="482">
						  <%
						  'f_orden.DibujaCampo("ordc_ncorr") 
						  %></td>
						  <td width="183"><div align="center">
						  <%
						  'botonera.DibujaBoton "buscar" 
						  %> </div></td>
						  <td width="183"><div align="center">
						  <%
						  'botonera.DibujaBoton "volver" 
						  %></div></td>
                        </tr>
                      </table>
				</form>

FIN SUB-TABLA 2 

                </td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE" background="../imagenes/base2.gif"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>	

-->
<!-- 88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888 -->	

	<br>
<%
'RESPONSE.WRITE("3: v_existe :"&v_existe&"<BR>")
'if v_existe>0 then
%>
	<!--  Inicio margen superior -->
	  <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td>
		<!--  Fin margen superior -->
		 <!-- Inicio Contenido -->	
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		    <tr>
            	<td><%pagina.DibujarLenguetas Array("Orden Compra"), 1 %></td>
          	</tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
            <tr>
                <td bgcolor="#D8D8DE">
				  <br>
                    <div align="center"><font size="+1">
                      <%pagina.DibujarTituloPagina()%> 
                      </font>                    
					</div>
				  <% if vibo_ccod="10" then %>
					<p style="font-size:12px; color=#FF0000"><strong>OBSERVACI&Oacute;N.- <%=ordc_tobservacion%></strong></p>
					<% else
						response.write "<br/></p>"
					end if %>
                   <table width="100%" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
                    <td>
<!-- INICIO FORM PRINCIPAL-->
					<form name="detalle">
					<input type="hidden" value="<%=ordc_ncorr%>" name="ordc_ncorr" />
					<input type="hidden" name="busqueda[0][area_ccod]" value="<%=area_ccod%>" />	
                    <input type="hidden" name="contador" value="0"/>
                    <input type="hidden" name="contador2" value="0"/>			
					
					
					      <table width="100%" border="1">
						  <tr class="tabactivo"> 
							<th>Boleta Honorarios</th>
							<td><%f_busqueda.dibujaCampo("ordc_bboleta_honorario")%></td>
							<th> Tipo Moneda </th>
							<td width="48%"><%f_busqueda.dibujaCampo("tmon_ccod")%></td>
						  </tr>						

						  <tr> 
							<td width="11%">Rut (<font color="#FF0000">*</font>)</td>
							<td width="27%"> <%f_busqueda.dibujaCampo("pers_nrut")%>-<%f_busqueda.dibujaCampo("pers_xdv")%> 
							
							<input type="button" value="Buscar" onClick="javascript:BuscarPersona();" <%=v_btn_buscar%> /></td>
							
							<td width="14%">Atenci&oacute;n </td>
							<td> <%f_busqueda.dibujaCampo("ordc_tatencion")%></td>
						  </tr>
						  <tr> 
							<td> Se&ntilde;ores </td>
							<td>
							<%
								f_busqueda.dibujaCampo("pers_tnombre")
								'f_busqueda.dibujaCampo("v_nombre")
							%> </td>
							<td> N&deg; Cotizacion </td>
							<td width="48%"> <%f_busqueda.dibujaCampo("ordc_ncotizacion")%></td>
						  </tr>
						  <tr> 
							<td>Direccion</td>
							<td> <%f_busqueda.dibujaCampo("dire_tcalle")%>&nbsp;<%f_busqueda.dibujaCampo("dire_tnro")%></td>
							<td> Forma Pago (<font color="#FF0000">*</font>)</td>
							<td> <%f_busqueda.dibujaCampo("cpag_ccod")%> </td>
						  </tr>
						  <tr> 
							<td>Ciudad</td>
							<td><%f_busqueda.dibujaCampo("ciudad")%></td>
							<td>Observacion</td>
							<td><%f_busqueda.dibujaCampo("ordc_tobservacion")%></td>
						  </tr>
						  <tr>
							<td>Telefono</td>
							<td><%f_busqueda.dibujaCampo("pers_tfono")%></td>
							<td>Monto Líquido (<font color="#FF0000">*</font>)</td>
							<td><%f_busqueda.dibujaCampo("ordc_mmonto")%></td>
						  </tr>
						  <tr>
						    <td>Fax</td>
						    <td><%f_busqueda.dibujaCampo("pers_tfax")%></td>
						    <td>Total Presupuestado </td>
						    <td><input type="text" style="background-color:#D8D8DE;border: 1px #D8D8DE solid; font-size:10px; font-style:oblique; font:bold; "  name="total_presupuesto" value="<%=v_total%>" size="12" id='total_presupuesto' readonly/></td>
						    </tr>
						  <tr>
						    <td colspan="4">
							
								<table width="100%" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' id=tb_presupuesto>
									<tr bgcolor='#C4D7FF' bordercolor='#999999'>
																			<th width="5%">N°</th>
																			<th width="40%">Cod. Presupuesto</th>
																			<th width="10%">Mes</th>
																			<th width="10%">Año</th>
																			<th width="15%">Valor</th>
                                                                            <th width="15%">Saldo presu</th>
																			<th width="5%">(+/-)</th>
									</tr>
									<%
										if f_presupuesto.nrofilas >=1 then
											ind=0
											while f_presupuesto.Siguiente 
											v_cod_pre=f_presupuesto.ObtenerValor("cod_pre")
											
											%>
											
											<tr>
												<th><input type="checkbox" name="presupuesto[<%=ind%>][checkbox]" value=""></th>
												
												<td>
													<select name="presupuesto[<%=ind%>][cod_pre]" onChange="RevisaPresupuesto(this.value,this.name);" >
														<%
														f_cod_pre.primero
														while f_cod_pre.Siguiente 
															if Cstr(f_cod_pre.ObtenerValor("cod_pre"))=Cstr(v_cod_pre) then
																checkeado="selected"
															else
																checkeado=""
															end if
														%>
														<option value="<%=f_cod_pre.ObtenerValor("cod_pre")%>"  <%=checkeado%> ><%=f_cod_pre.ObtenerValor("valor")%></option>
														<%wend%>
													</select>												</td>
													
<!-- 88888888888888888888888888888888888888888888888888888888888888888888888 -->

												<td>
												<%
												'f_presupuesto.DibujaCampo("mes_ccod")

										' JAIME PAINEMAL 20130910

										variable_0=f_presupuesto.ObtenerValor("mes_ccod")
										variable_1=f_presupuesto.ObtenerValor("anos_ccod")

														if variable_1<>"" then
															f_mes_anio.agregacampocons "anos_ccod", variable_1
														end if

														%> 
														<select name="busqueda[<%=ind%>][mes_ccod]" onChange="Cargar_codigos(this.form, this.value, <%=ind%>); RevisaPresupuestoMes(this.value,this.name);">
														<%
														f_mes_anio.primero
															while f_mes_anio.Siguiente 
																if Cstr(f_mes_anio.ObtenerValor("mes_ccod"))=Cstr(variable_0) then
																	checkeado="selected"
																else
																	checkeado=""
																end if
														%>
														<option value="<%=f_mes_anio.ObtenerValor("mes_ccod")%>"  <%=checkeado%> ><%=f_mes_anio.ObtenerValor("mes_tdesc")%></option>
														<%wend%>
														</select>	
												</td>
												<td>
												<%
												'f_presupuesto.DibujaCampo("anos_ccod")

														f_mes_anio.primero
														f_mes_anio.Siguiente 
														%> 
														<input type="text" name="busqueda[<%=ind%>][anos_ccod]" value="<%=f_mes_anio.ObtenerValor("anos_ccod")%>" >
												</td>
												
<!-- 88888888888888888888888888888888888888888888888888888888888888888888888 -->

												<td><%f_presupuesto.DibujaCampo("porc_mpresupuesto")%> </td>
<!--  888888 ** EN LA SIGUIENTE LINEA VA EL SALDO DEL PRESUPUESTO ** 88888888888888888888888888 -->	
												<td><input type="text" class="Mimetismo" name="busqueda[<%=ind%>][saldo]" size="8" value="" readonly ></td>
												<td><INPUT alt="agregar fila" class=boton TYPE="button" name="agregarlinea2" value="+" onClick="validaFila2('tb_presupuesto','<%=ind%>',this);">&nbsp;
												       <INPUT alt="quitar una fila existente" class="boton" TYPE="button" name="quitarlinea2" value="-" onClick="eliminaFilas2()"></td>
											</tr>	
											<%
											
											ind=ind+1
											wend
										end if 
									%>
								</table>								</td>
						    </tr>
						</table>
						<hr>
                      <table width="100%" border="0">
                        <tr> 
                          <td align="center">
								<table width="100%" border="1">
									<tr> 
										<td width="10%">Solicitado por (<font color="#FF0000">*</font>)</td>
									  <td width="25%"><%f_busqueda.dibujaCampo("ordc_tcontacto")%></td>
										<td width="13%">Lugar Entrega (<font color="#FF0000">*</font>)</td>
										<td> <%f_busqueda.dibujaCampo("sede_ccod")%></td>
									</tr>
									<tr> 
										<td> Telefono </td>
										<td> <%f_busqueda.dibujaCampo("ordc_tfono")%> </td>
										<td>Fecha entrega (<font color="#FF0000">*</font>)</td>
										<td width="30%"> <%f_busqueda.dibujaCampo("ordc_fentrega")%> 
									  (dd/mm/aaaa) </td>
									</tr>
									<tr>
									  <td colspan="4" align="left">(<font color="#FF0000">*</font>) Campos obligatorios</td>
								  </tr>
								</table>
						  </td>
                        </tr>
                        <tr>
                              <td align="right"><hr/></td>
                        </tr>
						<tr>
							<td>
								<table width="100%" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' id=tb_busqueda_detalle>
								<tr bgcolor='#C4D7FF' bordercolor='#999999'>
									<th>N°</th>
									<th>Tipo Gasto</th>
									<th>Descripcion</th>
									<th>C. Costo</th>
									<th>Cantidad</th>
									<th>Afecta</th>
									<th>Precio Unitario</th>
									<th>Descuento($)</th>
									<th><%=segun_boleta%></th>
									<th>(+/-)</th>
								</tr>
									<%
										if f_detalle.nrofilas >=1 then
											ind_d=0
											while f_detalle.Siguiente %>
											
											<tr>
												<th><input type="checkbox" name="detalle[<%=ind_d%>][checkbox]" value=""></th>
												<td><%f_detalle.DibujaCampo("tgas_ccod")%></td>
												<td><%f_detalle.DibujaCampo("dorc_tdesc")%></td>
												<td><%f_detalle.DibujaCampo("ccos_ncorr")%> </td>
												<td><%f_detalle.DibujaCampo("dorc_ncantidad")%> </td>
												<td align="center"><%f_detalle.dibujaBoleano("dorc_bafecta")%></td>
										      	<td><%f_detalle.DibujaCampo("dorc_nprecio_unidad")%></td>
												<td><%f_detalle.DibujaCampo("dorc_ndescuento")%> </td>
												<td><%f_detalle.DibujaCampo("dorc_nprecio_neto")%> </td>
												<td><INPUT alt="agregar una nueva fila" class=boton TYPE="button" name="agregarlinea" value="+" onClick="validaFila('tb_busqueda_detalle','<%=ind_d%>',this)">&nbsp;<INPUT alt="quitar una fila existente" class=boton TYPE="button" name="quitarlinea" value="-" onClick="eliminaFilas()"></td>
											</tr>	
											<%
											ind_d=ind_d+1
											wend
										end if 
									%>
								</table>
								<br>
							</td>
						</tr>
						<tr>
						<td>
						<table border="1" width="100%" >
							<tr>
								<td width="80%" rowspan="<%=row_span%>"><strong><font color="000000" size="1">La factura debe ser extendida en detalle, desglosandose por servicio o articulo con sus respectivos valores unitarios y cantidades, ademas debe incluir una copia de la orden de compra o incluir el numero de esta en la factura.</font></strong></td>
								<th width="10%"><%=txt_neto%></th>
								<td width="10%"><input type="text" name="<%=valor_neto%>" value="<%=v_neto%>" size="10" id='NU-N' readonly/></td>	
							</tr>
							<tr>
								<th><%=txt_variable%></th>
								<td><input type="text" name="<%=valor_variable%>" value="<%=v_variable%>" size="10" id='NU-N' readonly/></td>
							</tr>
							<% if Cstr(v_boleta)=2 then %>
							<tr>
								<th>Exento</th>
								<td><input type="text" name="exento" value="<%=v_exento%>" size="10" id='NU-N' readonly/></td>
							</tr>
							<%end if%>
							<tr>
								<th>Total</th>
								<td><input type="text" name="total" value="<%=v_totalizado%>" size="10" id='NU-N' readonly/></td>
							</tr>
							</table></td>
						</tr>
                      </table>
                 
					
					<strong>V°B° Responsable:</strong>
					  <select name="busqueda[0][responsable]">
					  <%
						f_responsable.primero
						while f_responsable.Siguiente
					  %>
					  <option value="<%f_responsable.DibujaCampo("pers_nrut")%>"><%f_responsable.DibujaCampo("nombre")%></option>
					  <%wend%>
					  </select>
                      <input name="email" type="hidden" value="<%f_responsable.DibujaCampo("email")%>"/>
					  </form>
					  <%=fin_com%>
<!-- FIN FORM PRINCIPAL-->
                      </td>
                  </tr>
                </table>
				   <br>				  
				  </td>
                </tr>
            </table>
		 <!-- Fin Contenido -->		
		</td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="18%" height="20">
				<table width="49%" height="19"  border="0" align="center" cellpadding="0" cellspacing="0">
					<tr>
                    <%
						if vibo_ccod = "12" or vibo_ccod = "10" or vibo_ccod = "-1" then
							botonera.AgregaBotonParam "guardar", "deshabilitado", "false"
							botonera.AgregaBotonParam "guardarenviar", "deshabilitado", "false"
							botonera.AgregaBotonParam "imprimir", "deshabilitado", "true"
						ElseIf vibo_ccod >= "0" or resul_nombre <> "1" then
							botonera.AgregaBotonParam "guardarenviar", "deshabilitado", "true"
  							botonera.AgregaBotonParam "guardar", "deshabilitado", "true"
						end if
						
						if vibo_ccod="0" then
							botonera.AgregaBotonParam "imprimir", "deshabilitado", "true"
						end if
						%>
					  <td width="30%"><%botonera.dibujaboton "guardar"%> </td>
                      <td><%botonera.dibujaboton "guardarenviar"%></td>
					  <td><%botonera.dibujaboton "salir1"%></td>
					  <td><%botonera.dibujaboton "imprimir"%></td>
					</tr>
				  </table>
           	</td>
            <td width="82%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
          </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<!--  fin margen inferior -->
<% 
'else
%>
<!--
		<p align="center" style="font-size:medium; color:#0033CC">No existen ordenes de compra asociadas al numero buscado</p>
-->
<% 
'end if
%>		
   </td>
  </tr>  
</table>
</body>
</html>

<SCRIPT language="JavaScript">
var resul_nom='<%=resul_nombre%>'
if (resul_nom == "0") {
	alert("No existe el RUT en Softland.")	
}

document.detalle.elements["contador"].value = contador;
document.detalle.elements["contador2"].value = contador2;
</script>