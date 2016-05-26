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
rut_1	= request.querystring("pers_nrut")
if rut_1 = "" then
rut	= request.querystring("busqueda[0][pers_nrut]")
else
rut = rut_1
end if
'RESPONSE.WRITE("1. rut :"&rut&"<BR>")

digito_1	= request.querystring("pers_xdv")
if digito_1 = "" then
digito	= request.querystring("busqueda[0][pers_xdv]")
else
digito = digito_1
end if
'RESPONSE.WRITE("2. digito :"&digito&"<BR>")
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
botonera.carga_parametros "buscar_OC.xml", "botonera"

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
' 888888888888888888888888888888
'***********************************************
set f_orden = new CFormulario
f_orden.Carga_Parametros "buscar_OC.xml", "buscador_orden"
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
	f_busqueda.Carga_Parametros "buscar_OC.xml", "datos_proveedor"
	f_busqueda.Inicializar conectar
	 
		if ordc_ncorr<>"" then

'			sql_orden="select protic.trunc(ordc_fentrega) as ordc_fentrega,cast(ordc_bboleta_honorario as varchar) as ordc_bboleta_honorario,* from ocag_orden_compra where cast(ordc_ncorr as varchar)='"&ordc_ncorr&"'"

' 8888888888888888888888888888888888888888888888888
' ESTA ES LA CONSULTA PRINCIPAL DEL FORMULARIO
' 8888888888888888888888888888888888888888888888888

'			sql_orden="select protic.trunc(ordc_fentrega) as ordc_fentrega,cast(ordc_bboleta_honorario as varchar) as ordc_bboleta_honorario "&_
'							", ordc_ncorr, pers_ncorr, fecha_solicitud, ordc_ndocto, ordc_tatencion, ordc_mmonto, ordc_ncotizacion, ordc_tobservacion "&_
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
							" , b.pers_nrut, b.pers_xdv  "&_
							" , b.pers_tnombre , b.PERS_TAPE_PATERNO + ' ' + b.PERS_TAPE_MATERNO as v_nombre  "&_
							" from ocag_orden_compra A "&_
							" INNER JOIN personas b "&_
							" ON a.pers_ncorr = b.pers_ncorr where cast(a.ordc_ncorr as varchar) ='"&ordc_ncorr&"'"

		else
			sql_orden="select 0 as ordc_mretencion, 0 as ordc_mhonorarios, 0 as ordc_mhonorarios, 0 as ordc_mneto, 0 as ordc_miva "&_
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

vibo_ccod=f_busqueda.obtenerValor("vibo_ccod")
v_tsol_ccod=f_busqueda.obtenerValor("tsol_ccod")

'response.Write("<hr> Visto Bueno: "&vibo_ccod)	
'response.Write("<hr> Visto Bueno: "&v_tsol_ccod)	
'RESPONSE.END()

'**********************************************************
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


if area_ccod="" then
	area_ccod= f_busqueda.ObtenerValor("area_ccod")
end if

'RESPONSE.WRITE("5. area_ccod :"&area_ccod&"<BR>")

set f_busqueda2 = new CFormulario

' 8888888888888888888888888888888888888888888888888888888888888
' CUANDO SE PRESIONA EL BOTON "BUSCAR" SE VIENE HACIA ACA
' 8888888888888888888888888888888888888888888888888888888888888

'RESPONSE.WRITE("ENTRO AQUI")
'RESPONSE.END()

f_busqueda2.Carga_Parametros "buscar_OC.xml", "buscador"
f_busqueda2.Inicializar conexion
f_busqueda2.Consultar "select ''"
f_busqueda2.Siguiente
f_busqueda2.AgregaCampoParam "area_ccod", "filtro",  "area_ccod in ( select area_ccod from  presupuesto_upa.protic.area_presupuesto_usuario where rut_usuario in ('"&v_usuario&"') )"
f_busqueda2.AgregaCampoCons "area_ccod", area_ccod

'if rut	=0 then
'RESPONSE.WRITE("ENTRO AQUI 1")
'	rut=conectar.consultaUno("select top 1 pers_nrut from personas where pers_ncorr="&f_busqueda.obtenerValor("pers_ncorr"))
'end if

'if digito	=0 then
'RESPONSE.WRITE("ENTRO AQUI 2")
'	digito=conectar.consultaUno("select top 1 pers_xdv from personas where pers_nrut="&rut)
'end if

if rut<>"" then
	set f_personas = new CFormulario
	f_personas.carga_parametros "tabla_vacia.xml", "tabla_vacia"
	'f_personas.inicializar conexion
	f_personas.inicializar conectar

'	sql_datos_persona= " Select top 1 codaux as pers_nrut,NomAux as pers_tnombre, DirAux as dire_tcalle, DirNum as dire_tnro,CiuDes as ciudad,  "&_
'						" NomAux as v_nombre,isnull(isnull(FonAux1,Fonaux2),FonAux3) as pers_tfono, isnull(FaxAux1,FaxAux2) as pers_tfax "&_
'					   	" from softland.cwtauxi a left outer join softland.cwtciud b on CiuAux=CiuCod "&_
'					   	" where CodAux='"&rut&"'"

	sql_datos_persona= " SELECT PERS_NRUT, PERS_TNOMBRE pers_tnombre, PERS_TAPE_PATERNO + ' ' + PERS_TAPE_MATERNO as v_nombre "&_
					   	" ,PERS_TFONO ,PERS_TFAX "&_
					   	" FROM PERSONAS "&_
					   	" WHERE PERS_NRUT='"&rut&"'"

'response.end()

	f_personas.consultar sql_datos_persona
	f_personas.Siguiente
	
	f_busqueda.AgregaCampoCons "pers_tnombre", f_personas.obtenerValor("pers_tnombre")
	'f_busqueda.AgregaCampoCons "dire_tcalle", f_personas.obtenerValor("dire_tcalle")
	'f_busqueda.AgregaCampoCons "dire_tnro", f_personas.obtenerValor("dire_tnro")
	f_busqueda.AgregaCampoCons "pers_tfono", f_personas.obtenerValor("pers_tfono")
	f_busqueda.AgregaCampoCons "pers_tfax", f_personas.obtenerValor("pers_tfax")
	f_busqueda.AgregaCampoCons "pers_nrut", f_personas.obtenerValor("pers_nrut")
	f_busqueda.AgregaCampoCons "pers_xdv", digito
	'f_busqueda.AgregaCampoCons "ciudad", f_personas.obtenerValor("ciudad")
	f_busqueda.AgregaCampoCons "v_nombre", f_personas.obtenerValor("v_nombre")
end if

 set f_presupuesto = new CFormulario
 	f_presupuesto.Carga_Parametros "buscar_OC.xml", "detalle_presupuesto"
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
 	f_detalle.Carga_Parametros "buscar_OC.xml", "detalle_producto"
 	f_detalle.Inicializar conectar

' 	sql_detalle="select * from ocag_detalle_orden_compra where cast(ordc_ncorr as varchar)='"&ordc_ncorr&"'"

	if ordc_ncorr <> "" then

 	sql_detalle="select dorc_ncorr, ordc_ncorr, tgas_ccod, dorc_tdesc, ccos_ncorr, dorc_ncantidad, tmon_ccod, dorc_nprecio_unidad "&_
						", dorc_ndescuento, dorc_nprecio_neto, audi_tusuario, audi_fmodificacion, dorc_bafecta "&_
						" from ocag_detalle_orden_compra where cast(ordc_ncorr as varchar)='"&ordc_ncorr&"'"
						
	else
	
	sql_detalle="select '' "
	
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

	sql_responsable= "Select pers_nrut_responsable as pers_nrut,protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre "&_
					  "	from ocag_responsable_area a, personas b "&_
					  "	where a.pers_nrut_responsable=b.pers_nrut "&_
					  "	and cast(a.pers_nrut as varchar)='"&v_usuario&"'"
					  
	'response.write("7. sql_responsable :"&sql_responsable&"<br>")
	
	f_responsable.consultar sql_responsable


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

sql_anos= "select anos_ccod, case when anos_ccod=year(getdate()) then 1 else 0 end as orden "&_
			" from anos where anos_ccod between year(getdate())-1 and year(getdate())+1 "&_
			" order by orden desc "

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

sql_tipo_gasto= "Select  tgas_ccod, ltrim(rtrim(tgas_tdesc)) as tgas_tdesc,pare_ccod from ocag_tipo_gasto "

sql_tipo_gasto= "  select distinct b.tgas_ccod, ltrim(rtrim(tgas_tdesc)) as tgas_tdesc, tgas_cod_cuenta, a.pare_ccod  "&_ 
				"  from ocag_perfiles_areas a, ocag_tipo_gasto_perfil b, ocag_tipo_gasto c   "&_
				"  where a.pare_ccod=b.pare_ccod   "&_
				"  and b.tgas_ccod=c.tgas_ccod   "&_
				"  and a.pare_ccod in (select pare_ccod from ocag_perfiles_areas_usuarios where pers_nrut="&v_usuario&")"

'response.write("8. sql_tipo_gasto :"&sql_tipo_gasto&"<br>")
				
'response.write(sql_tipo_gasto)
'response.end()

f_tipo_gasto.consultar sql_tipo_gasto


set f_cod_pre = new CFormulario
f_cod_pre.carga_parametros "buscar_OC.xml", "codigo_presupuesto"
f_cod_pre.inicializar conexion
f_cod_pre.consultar "select '' "

'sql_codigo_pre="(select distinct cod_pre, concepto_pre as valor from presupuesto_upa.protic.codigos_presupuesto where cod_area in ('"&area_ccod&"')) as tabla"

' ESTA CONSULTA ARMA EL CODIGO DE PRESUPUESTO

sql_codigo_pre="(select distinct cod_pre, '('+cod_pre+')' + ' Area('+cast(cast(cod_area as numeric) as varchar)+')-'+concepto as valor "&_
			    " from presupuesto_upa.protic.presupuesto_upa_2011 	"&_
			    "	where cod_anio=2011 "&_
				"	and cod_area in (   select distinct area_ccod "&_ 
				"		 from  presupuesto_upa.protic.area_presupuesto_usuario  "&_
				"		 where rut_usuario in ("&v_usuario&") and cast(area_ccod as varchar)= '"&area_ccod&"') "&_
				" ) as tabla "

'response.write("9. sql_codigo_pre :"&sql_codigo_pre&"<br>")
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

%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<SCRIPT language="JavaScript">


</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
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
                   <table width="100%" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
                    <td>
<!-- INICIO FORM PRINCIPAL-->
					<form name="detalle">
					<input type="hidden" value="<%=ordc_ncorr%>" name="ordc_ncorr" />
					<input type="hidden" name="busqueda[0][area_ccod]" value="<%=area_ccod%>" />	
                    <input type="hidden" name="contador" value="0"/>
                    <input type="hidden" name="contador2" value="0"/>			
					<br/>
					
					      </p>
					    <table width="100%" border="1">
						  <tr class="tabactivo"> 
							<th>Boleta Honorarios</th>
							<td><%f_busqueda.dibujaCampo("ordc_bboleta_honorario")%></td>
							<th> Tipo Moneda </th>
							<td width="48%"><%f_busqueda.dibujaCampo("tmon_ccod")%></td>
						  </tr>						

						  <tr> 
							<td width="11%">Rut </td>
							<td width="27%"> <%f_busqueda.dibujaCampo("pers_nrut")%>-<%f_busqueda.dibujaCampo("pers_xdv")%></td>
							
							<td width="14%">Atenci&oacute;n </td>
							<td> <%f_busqueda.dibujaCampo("ordc_tatencion")%></td>
						  </tr>
						  <tr> 
							<td> Se&ntilde;ores </td>
							<td> <%f_busqueda.dibujaCampo("pers_tnombre")%>&nbsp;<%f_busqueda.dibujaCampo("v_nombre")%> </td>
							<td> N&deg; Cotizacion </td>
							<td width="48%"> <%f_busqueda.dibujaCampo("ordc_ncotizacion")%></td>
						  </tr>
						  <tr> 
							<td>Direccion</td>
							<td> <%f_busqueda.dibujaCampo("dire_tcalle")%>&nbsp;<%f_busqueda.dibujaCampo("dire_tnro")%></td>
							<td> Forma Pago </td>
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
							<td>Monto Orden </td>
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
										<th width="50%">Cod. Presupuesto</th>
										<th width="12%">Mes</th>
										<th width="12%">Año</th>
										<th width="16%">Valor</th>
									</tr>
									<%
										if f_presupuesto.nrofilas >=1 then
											ind=0
											while f_presupuesto.Siguiente 
											v_cod_pre=f_presupuesto.ObtenerValor("cod_pre")
											
											%>
											
											<tr>
												
												<td>
													<select name="presupuesto[<%=ind%>][cod_pre]" disabled>
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
												<td><%f_presupuesto.DibujaCampo("mes_ccod")%> </td>
												<td><%f_presupuesto.DibujaCampo("anos_ccod")%> </td>
												<td><%f_presupuesto.DibujaCampo("porc_mpresupuesto")%> </td>
												
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
										<td width="10%">Solicitado por </td>
									  <td width="25%"><%f_busqueda.dibujaCampo("ordc_tcontacto")%></td>
										<td width="13%">Lugar Entrega </td>
										<td> <%f_busqueda.dibujaCampo("sede_ccod")%></td>
									</tr>
									<tr> 
										<td> Telefono </td>
										<td> <%f_busqueda.dibujaCampo("ordc_tfono")%> </td>
										<td>Fecha entrega </td>
										<td width="30%"> <%f_busqueda.dibujaCampo("ordc_fentrega")%> 
									  (dd/mm/aaaa) </td>
									</tr>
									<tr>
									  <td colspan="4" align="left">&nbsp;</td>
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
									<th>Tipo Gasto</th>
									<th>Descripcion</th>
									<th>C. Costo</th>
									<th>Cantidad</th>
									<th>Afecta</th>
									<th>Precio Unitario</th>
									<th>Descuento($)</th>
									<th><%=segun_boleta%></th>
								</tr>
									<%
										if f_detalle.nrofilas >=1 then
											ind_d=0
											while f_detalle.Siguiente %>
											
											<tr>												
												<td><%f_detalle.DibujaCampo("tgas_ccod")%></td>
												<td><%f_detalle.DibujaCampo("dorc_tdesc")%></td>
												<td><%f_detalle.DibujaCampo("ccos_ncorr")%> </td>
												<td><%f_detalle.DibujaCampo("dorc_ncantidad")%> </td>
												<td align="center"><%f_detalle.dibujaBoleano("dorc_bafecta")%></td>
										      	<td><%f_detalle.DibujaCampo("dorc_nprecio_unidad")%></td>
												<td><%f_detalle.DibujaCampo("dorc_ndescuento")%> </td>
												<td><%f_detalle.DibujaCampo("dorc_nprecio_neto")%> </td>
												
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
								<td width="10%"><input type="text" name="<%=valor_neto%>" value="<%=v_neto%>" size="10" disabled id='NU-N' readonly/></td>	
							</tr>
							<tr>
								<th><%=txt_variable%></th>
								<td><input type="text" name="<%=valor_variable%>" value="<%=v_variable%>" size="10" disabled id='NU-N' readonly/></td>
							</tr>
							<% if Cstr(v_boleta)=2 then %>
							<tr>
								<th>Exento</th>
								<td><input type="text" name="exento" value="<%=v_exento%>" size="10" disabled id='NU-N' readonly/></td>
							</tr>
							<%end if%>
							<tr>
								<th>Total</th>
								<td><input type="text" name="total" value="<%=v_totalizado%>" size="10" disabled id='NU-N' readonly/></td>
							</tr>
							</table></td>
						</tr>
                      </table>
                 
					
					<strong>V°B° Responsable:</strong>
					  <select name="busqueda[0][responsable]" disabled>
					  <%
						f_responsable.primero
						while f_responsable.Siguiente
					  %>
					  <option value="<%f_responsable.DibujaCampo("pers_nrut")%>"><%f_responsable.DibujaCampo("nombre")%></option>
					  <%wend%>
					  </select>
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
					  <td><%botonera.dibujaboton "cerrar"%></td>
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