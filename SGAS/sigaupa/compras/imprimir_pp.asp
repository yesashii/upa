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
'FECHA ACTUALIZACION 	:18/07/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ORDEN DE COMPRA
'LINEA			:
'*******************************************************************
v_sogi_ncorr	= request.querystring("sogi_ncorr")

set pagina = new CPagina
pagina.Titulo = "Pago Proveedores N° "&v_sogi_ncorr
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
fecha_actual= conectar.consultaUno("select protic.trunc(getDate())")

'**********************************************************

if area_ccod="" then
	area_ccod= conexion.consultaUno ("select top 1 a.area_ccod from  presupuesto_upa.protic.area_presupuesto_usuario a, presupuesto_upa.protic.area_presupuestal b where rut_usuario ="&v_usuario&" and a.area_ccod=b.area_ccod order by area_tdesc ")
end if

'**********************************************************

set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "pago_proveedor.xml", "datos_proveedor"
f_busqueda.Inicializar conectar

	if v_sogi_ncorr<>"" then

'		sql_datos_solicitud= "select protic.trunc(ocag_fingreso) as ocag_fingreso,* "&_
'							" from ocag_solicitud_giro a, personas c "&_
'						 	"	where a.pers_ncorr_proveedor=c.pers_ncorr and a.sogi_ncorr="&v_sogi_ncorr
							
		sql_datos_solicitud= "select sogi_tobservaciones,protic.trunc(a.ocag_fingreso) as ocag_fingreso "&_
						 	", a.sogi_ncorr, a.sogi_mgiro, a.ordc_ncorr, a.pers_ncorr_proveedor, a.tsol_ccod, a.cpag_ccod, protic.trunc(a.sogi_fecha_solicitud) as sogi_fecha_solicitud, a.tgas_ccod, a.mes_ccod, a.anos_ccod "&_
						 	", a.cod_pre, a.sogi_tobservaciones, a.vibo_ccod, a.audi_tusuario, a.audi_fmodificacion, a.sogi_frecepcion, a.sogi_tobs_rechazo, a.area_ccod, a.sogi_mretencion "&_
						 	", a.sogi_mhonorarios, a.sogi_mneto, a.sogi_miva, a.sogi_mexento, a.tmon_ccod, a.sogi_bboleta_honorario, a.ocag_generador, a.ocag_frecepcion_presupuesto "&_
						 	", a.ocag_responsable, a.ocag_baprueba, a.sede_ccod "&_
						 	", c.PERS_NCORR, c.TVIS_CCOD, c.SEXO_CCOD, c.TENS_CCOD, c.COLE_CCOD, c.ECIV_CCOD, c.PAIS_CCOD, c.PERS_BDOBLE_NACIONALIDAD "&_
						 	", c.PERS_NRUT, c.PERS_XDV "&_
								" , LTRIM(RTRIM(c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO)) as v_nombre "&_
								" , LTRIM(RTRIM(c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO)) as PERS_TNOMBRE "&_	
						 	", c.PERS_FNACIMIENTO, c.CIUD_CCOD_NACIMIENTO, c.PERS_FDEFUNCION, c.PERS_TEMPRESA, c.PERS_TFONO_EMPRESA, c.PERS_TCARGO, c.PERS_TPROFESION, c.PERS_TFONO "&_
						 	", c.PERS_TFAX, c.PERS_TCELULAR, c.PERS_TEMAIL, c.PERS_TPASAPORTE, c.PERS_FEMISION_PAS, c.PERS_FVENCIMIENTO_PAS, c.PERS_FTERMINO_VISA, c.PERS_NNOTA_ENS_MEDIA "&_
						 	", c.PERS_TCOLE_EGRESO, c.PERS_NANO_EGR_MEDIA, c.PERS_TRAZON_SOCIAL, c.PERS_TGIRO, c.PERS_TEMAIL_INTERNO, c.NEDU_CCOD, c.IFAM_CCOD, c.ALAB_CCOD, c.ISAP_CCOD "&_
						 	", c.FFAA_CCOD, c.PERS_TTIPO_ENSENANZA, c.PERS_TENFERMEDADES, c.PERS_TMEDICAMENTOS_ALERGIA, c.AUDI_TUSUARIO, c.AUDI_FMODIFICACION, c.ciud_nacimiento "&_
						 	", c.regi_particular, c.ciud_particular, c.pers_bmorosidad, c.sicupadre_ccod, c.sitocup_ccod, c.tenfer_ccod, c.descrip_tenfer, c.trabaja, c.pers_temail2 "&_
						 	"from ocag_solicitud_giro a "&_
						 	"INNER JOIN personas c "&_
						 	"ON a.pers_ncorr_proveedor=c.pers_ncorr "&_
						 	"and a.sogi_ncorr="&v_sogi_ncorr

	else
		sql_datos_solicitud="select ''"
	end if
				
	'RESPONSE.WRITE("1 sql_datos_solicitud : "&sql_datos_solicitud&"<BR>")
	
f_busqueda.Consultar sql_datos_solicitud
f_busqueda.Siguiente

if v_boleta	="" or EsVacio(v_boleta) then
	v_boleta=f_busqueda.obtenerValor("ordc_bboleta_honorario")
end if
f_busqueda.AgregaCampoCons "ordc_bboleta_honorario", v_boleta

if Cstr(v_boleta)=Cstr(1) then
	segun_boleta="Honorario Total (Liquido 0.9)"
	txt_variable="10% Retencion"
	txt_neto	="Honorarios"
	valor_neto	="ordc_mhonorarios"
	valor_variable	="ordc_mretencion"
	row_span= 3
	v_variable	=f_busqueda.obtenerValor("sogi_mretencion")
	v_neto		=f_busqueda.obtenerValor("sogi_mhonorarios")
	v_total		=f_busqueda.obtenerValor("sogi_mhonorarios")
	v_totalizado=Cint(v_neto)-Cint(v_variable)
else
	segun_boleta="Precio Neto"
	txt_variable="19% IVA"
	txt_neto	="Neto"
	valor_neto	="ordc_mneto"
	valor_variable	="ordc_miva"
	row_span= 4
	v_neto		=f_busqueda.obtenerValor("sogi_mneto")
	v_variable	=f_busqueda.obtenerValor("sogi_miva")
	v_exento	=f_busqueda.obtenerValor("sogi_mexento")
	v_total		=f_busqueda.obtenerValor("sogi_mmonto")
	v_totalizado=v_total	
end if


if area_ccod="" then
	area_ccod= f_busqueda.ObtenerValor("area_ccod")
end if

'RESPONSE.WRITE(" area_ccod : "&area_ccod&"<BR>")	

'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
v_pers_tnombre = f_busqueda.obtenerValor("pers_tnombre")
v_rut=f_busqueda.obtenerValor("pers_nrut")
	'8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
	'88 INICIO
	
	if v_pers_tnombre="" then
	
	set f_personas2 = new CFormulario
	f_personas2.carga_parametros "tabla_vacia.xml", "tabla_vacia"
	f_personas2.inicializar conexion

	sql_datos_persona= " select CODAUX AS pers_nrut, RIGHT(RUTAUX,1) AS pers_xdv, NOMAUX AS pers_tnombre, NOMAUX AS v_nombre "&_
											" from softland.cwtauxi where cast(CodAux as varchar)='"&v_rut&"'"
	
	f_personas2.consultar sql_datos_persona
	f_personas2.Siguiente
						
	v_pers_tnombre = f_personas2.obtenerValor("pers_tnombre")
						
	f_busqueda.AgregaCampoCons "pers_tnombre", f_personas2.obtenerValor("pers_tnombre")
	
	end if
	'88 FIN
	'8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
	
'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

set f_oc = new CFormulario
f_oc.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_oc.inicializar conectar

sql_oc= " select b.ordc_ncorr,ordc_fentrega,ordc_mmonto,tmon_tdesc "&_
		" from ocag_solicitud_giro a, ocag_orden_compra b, ocag_tipo_moneda c "&_
		" where a.ordc_ncorr=b.ordc_ncorr "&_
		" and a.tmon_ccod=c.tmon_ccod "&_
		" and a.sogi_ncorr="&v_sogi_ncorr

'RESPONSE.WRITE("8 sql_oc : "&sql_oc&"<BR>")

f_oc.consultar sql_oc
f_oc.siguiente

v_ordc_ndocto		=f_oc.obtenerValor("ordc_ncorr")

if f_oc.nroFilas >=1 then
	msg_oc=" (Total aprobado por OC)"
end if


 set f_presupuesto = new CFormulario
 	f_presupuesto.Carga_Parametros "orden_compra.xml", "detalle_presupuesto"
 	f_presupuesto.Inicializar conectar

if v_ordc_ndocto<>"" then

	sql_presupuesto="select psol_mpresupuesto as psol_mpresupuesto, "&_
									"psol_ncorr AS porc_ncorr, cod_solicitud AS ordc_ncorr, s.cod_pre,(select distinct '('+p.cod_pre+') ' + 'Area('+cast(cast(p.cod_area as numeric) as varchar)+')-' + concepto as valor from presupuesto_upa.protic.presupuesto_upa_2011 p where p.cod_pre collate SQL_Latin1_General_CP1_CI_AS= s.cod_pre) as valor, " &_
					 "mes_ccod, anos_ccod, audi_tusuario, audi_fmodificacion " &_
								" from ocag_presupuesto_solicitud s where cast(cod_solicitud as varchar)='"&v_ordc_ndocto&"' and tsol_ccod=9  "

else
	if v_sogi_ncorr<>"" then

		sql_presupuesto="select isnull(psol_mpresupuesto,0) as psol_mpresupuesto "&_
								", psol_ncorr, tsol_ccod, cod_solicitud, cod_pre, mes_ccod, anos_ccod, psol_mpresupuesto, audi_tusuario "&_
								", audi_fmodificacion, psol_brendicion, cod_solicitud_origen "&_
								"from ocag_presupuesto_solicitud "&_
								"where cast(cod_solicitud as varchar)='"&v_sogi_ncorr&"' and tsol_ccod=1"
		
	else
		sql_presupuesto="select 0 as psol_mpresupuesto, '' "
	end if	
end if
	
	'RESPONSE.WRITE("2 sql_presupuesto : "&sql_presupuesto&"<BR>")
	
	f_presupuesto.consultar sql_presupuesto	
	filas_presu= f_presupuesto.nrofilas

	
 set f_detalle = new CFormulario
 	f_detalle.Carga_Parametros "orden_compra.xml", "detalle_producto"
 	f_detalle.Inicializar conectar
	
 	'sql_detalle="select * from ocag_detalle_solicitud_ag where cast(sogi_ncorr as varchar)='"&v_sogi_ncorr&"'"
	
	if v_ordc_ndocto<>"" then

		 if v_sogi_ncorr<>"" then
		 
		'	sql_detalle="select dorc_nprecio_neto,"&_
		'				" dorc_nprecio_neto-protic.ocag_total_pago_proveedor(ordc_ncorr,tgas_ccod,ccos_ncorr,dorc_tdesc,'"&v_sogi_ncorr&"','T') as saldo, "&_ 
		'				" dorc_nprecio_neto-protic.ocag_total_pago_proveedor(ordc_ncorr,tgas_ccod,ccos_ncorr,dorc_tdesc,'"&v_sogi_ncorr&"','T') as v_saldo, * "&_
		'				" from ocag_detalle_orden_compra where cast(ordc_ncorr as varchar)='"&v_ordc_ndocto&"'"
	
			sql_detalle=" SELECT  "&_
  						" MAX(sogi_ncorr) AS sogi_ncorr "&_
						" , ordc_ncorr "&_
						" , MAX(cod_solicitud) AS cod_solicitud "&_
						" , tgas_ccod, dorc_tdesc, ccos_ncorr , dorc_ncantidad, tmon_ccod  "&_
						" , MAX(dorc_nprecio_unidad) AS dorc_nprecio_unidad , dorc_ndescuento  "&_
						" , MAX(dorc_nprecio_neto) AS dorc_nprecio_neto , dorc_bafecta, dorc_abono  "&_
						" , SUM(ISNULL(dorc_monto_abono, 0)) AS dorc_monto_abono  "&_
						" , (MAX(dorc_nprecio_neto) - SUM(ISNULL(dorc_monto_abono, 0))) AS saldo  "&_
						" , (MAX(dorc_nprecio_neto) - SUM(ISNULL(dorc_monto_abono, 0))) AS v_saldo  "&_
						" FROM ocag_detalle_solicitud_ag where cast(ordc_ncorr as varchar)='"&v_ordc_ndocto&"' "&_		
						" GROUP BY ordc_ncorr, tgas_ccod, dorc_tdesc, ccos_ncorr , dorc_ncantidad, tmon_ccod  "&_
						" , dorc_ndescuento ,dorc_nprecio_neto,  dorc_bafecta, dorc_abono "

			'Response.Write("1. "&sql_detalle&"</pre>")	
				
		end if 			
		
	else

		if v_sogi_ncorr<>"" then
			'sql_detalle="select * from ocag_detalle_solicitud_ag where cast(sogi_ncorr as varchar)='"&v_sogi_ncorr&"'"

		'	sql_detalle="select dsag_ncorr, sogi_ncorr, ordc_ncorr, cod_solicitud, tgas_ccod, dorc_tdesc, ccos_ncorr, dorc_ncantidad, tmon_ccod "&_
		'					" , dorc_nprecio_unidad, dorc_ndescuento, dorc_nprecio_neto, audi_tusuario, audi_fmodificacion, dorc_bafecta "&_
 		'					" from ocag_detalle_solicitud_ag where cast(sogi_ncorr as varchar) ='"&v_sogi_ncorr&"'"
							
			sql_detalle=" SELECT  "&_
  						" MAX(sogi_ncorr) AS sogi_ncorr "&_
						" , ordc_ncorr "&_
						" , MAX(cod_solicitud) AS cod_solicitud "&_
						" , tgas_ccod, dorc_tdesc, ccos_ncorr , dorc_ncantidad, tmon_ccod  "&_
						" , MAX(dorc_nprecio_unidad) AS dorc_nprecio_unidad , dorc_ndescuento  "&_
						" , MAX(dorc_nprecio_neto) AS dorc_nprecio_neto , dorc_bafecta, dorc_abono  "&_
						" , SUM(ISNULL(dorc_monto_abono, 0)) AS dorc_monto_abono  "&_
						" , (MAX(dorc_nprecio_neto) - SUM(ISNULL(dorc_monto_abono, 0))) AS saldo  "&_
						" , (MAX(dorc_nprecio_neto) - SUM(ISNULL(dorc_monto_abono, 0))) AS v_saldo  "&_
						" FROM ocag_detalle_solicitud_ag where cast(sogi_ncorr as varchar)='"&v_sogi_ncorr&"' "&_		
						" GROUP BY ordc_ncorr, tgas_ccod, dorc_tdesc, ccos_ncorr , dorc_ncantidad, tmon_ccod  "&_
						" , dorc_ndescuento ,dorc_nprecio_neto,  dorc_bafecta, dorc_abono "
			
			'Response.Write("3. "&sql_detalle&"</pre>")	
		
		end if
	end if
	
	'RESPONSE.WRITE("3 sql_detalle : "&sql_detalle&"<BR>")
	
	f_detalle.agregaCampoParam "ccos_ncorr","filtro", "pers_nrut="&v_usuario
	f_detalle.consultar sql_detalle
	filas_detalle= f_detalle.nrofilas
	

set f_responsable = new CFormulario
	f_responsable.carga_parametros "tabla_vacia.xml", "tabla_vacia"
	f_responsable.inicializar conectar
	
	sql_responsable= "Select pers_nrut_responsable as pers_nrut,protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre "&_
					  "	from ocag_responsable_area a, personas b "&_
					  "	where a.pers_nrut_responsable=b.pers_nrut "&_
					  "	and cast(a.pers_nrut as varchar)='"&v_usuario&"'"
					  
	'RESPONSE.WRITE("3 sql_responsable : "&sql_responsable&"<BR>")
	
	f_responsable.consultar sql_responsable
	
'*****************************************************************************************
'***************	listas de seleccion para filas de tabla dinamica	******************	


set f_detalle_pago = new CFormulario
f_detalle_pago.carga_parametros "pago_proveedor.xml", "detalle_giro"
f_detalle_pago.inicializar conectar

'		sql_detalle_pago= 	 " select b.*, b.dsgi_mdocto as dsgi_mpesos from ocag_solicitud_giro a, ocag_detalle_solicitud_giro b "&_
'							 "	where a.sogi_ncorr=b.sogi_ncorr "&_
'							 "	and a.sogi_ncorr="&v_sogi_ncorr
							 
		sql_detalle_pago= 	 " select b.dsgi_ncorr, b.sogi_ncorr, b.tmon_ccod, b.tdoc_ccod AS tdoc_ccod2, b.dsgi_ndocto, b.audi_tusuario, b.audi_fmodificacion, b.dsgi_fpago "&_
							 ", b.dsgi_mexento, b.dsgi_mafecto, ISNULL(b.dsgi_mhonorarios,0) AS dsgi_mhonorarios, b.dsgi_miva, ISNULL(b.dsgi_mretencion,0) AS dsgi_mretencion"&_
							 ", b.dsgi_mdocto as dsgi_mpesos "&_
							 "from ocag_solicitud_giro a "&_
							 "INNER JOIN ocag_detalle_solicitud_giro b "&_
							 "ON a.sogi_ncorr=b.sogi_ncorr and a.sogi_ncorr="&v_sogi_ncorr
							 
		'RESPONSE.WRITE("4 sql_detalle_pago : "&sql_detalle_pago&"<BR>")

f_detalle_pago.Consultar sql_detalle_pago


set f_tipo_gasto = new CFormulario
f_tipo_gasto.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_tipo_gasto.inicializar conectar
sql_tipo_gasto= "Select top 5  tgas_ccod, ltrim(rtrim(tgas_tdesc)) as tgas_tdesc,pare_ccod from ocag_tipo_gasto"

'RESPONSE.WRITE("5 sql_tipo_gasto : "&sql_tipo_gasto&"<BR>")

f_tipo_gasto.consultar sql_tipo_gasto


set f_cod_pre = new CFormulario
f_cod_pre.carga_parametros "orden_compra.xml", "codigo_presupuesto"
f_cod_pre.inicializar conexion
f_cod_pre.consultar "select '' "

'sql_codigo_pre="(select distinct cod_pre, concepto_pre as valor from presupuesto_upa.protic.codigos_presupuesto where cod_area in ('"&area_ccod&"')) as tabla"

sql_codigo_pre="(select distinct cod_pre, '('+cod_pre+') ' + 'Area('+cast(cast(cod_area as numeric) as varchar)+')-' + concepto as valor "&_
			    " from presupuesto_upa.protic.presupuesto_upa_2011 	"&_
			    "	where cod_anio=2011 "&_
				"	and cod_area in (   select distinct area_ccod "&_ 
				"		 from  presupuesto_upa.protic.area_presupuesto_usuario  "&_
				"		 where rut_usuario in ("&v_usuario&") and cast(area_ccod as varchar)= '"&area_ccod&"') "&_
				" ) as tabla "
			
'RESPONSE.WRITE("6 sql_codigo_pre : "&sql_codigo_pre&"<BR>")

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

					'RESPONSE.WRITE("7 sql_centro_costo : "&sql_centro_costo&"<BR>")
					
f_centro_costo.consultar sql_centro_costo


set f_datos_area = new CFormulario
f_datos_area.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_datos_area.inicializar conexion

sql_datos_area= " select * from presupuesto_upa.protic.area_presupuestal where area_ccod="&area_ccod

f_datos_area.consultar sql_datos_area
f_datos_area.siguiente

v_generador=conectar.consultaUno("select protic.obtener_nombre_completo(pers_ncorr,'n') as generador from personas where pers_nrut="&f_busqueda.ObtenerValor("audi_tusuario"))

'RESPONSE.WRITE("9 v_generador : "&v_generador&"<BR>")

'*****************************************************************************************
'***************	FIN listas de seleccion para filas de tabla dinamica	**************

%>
<style>
table{
	font-family:Verdana, Arial, Helvetica, sans-serif;
    font-size: 0.9em;
}
p.encabezado{
    font-size: 0.725em;
}
table.membrete{
    font-size: 0.725em;
}
</style>

<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
          <td>
		  	<table class="membrete" align="center" width="760" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="142" align="left"><img src="../imagenes/logo_upa_2011.jpg" height="100"  alt="Logo"></td>
					<td width="455" valign="top"><p>Vicerrectoria de Administración y Finanzas </p>
					  <p>Dirección de Finanzas</p></td>
				  <td width="163"><br/></td>
				</tr>
			</table>
		  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td>
					  <br/>
                      <center><%pagina.DibujarTituloPagina()%></center>
					  <br/>
                <table width="760" align="center">
				<tr>
					<td>
					<p class="encabezado">&nbsp;</p>
					</td>
					<td valign="bottom" align="right"><table>
					<tr><td align="left">Fecha solicitud:</td><td style="border: 1px solid black">&nbsp;<%=f_busqueda.ObtenerValor("ocag_fingreso")%></td></tr>
                    <tr><td align="left">Fecha Documento:</td><td style="border: 1px solid black">&nbsp;<%=f_busqueda.ObtenerValor("sogi_fecha_solicitud")%></td></tr>
					<tr><td align="left">Fecha de impresión:</td><td style="border: 1px solid black">&nbsp;<%=fecha_actual%></td>
					</tr>
					</table>
					
					</td>
				</tr>
				</table>
                  <table width="760" align="center" cellpadding="0" cellspacing="0" border ="0">
                  <tr> 
                    <td>
						<table width="100%" border="0">
						  <tr >
						    <td width="15%"> Girar a nombre de </td>
						    <td align="right" style="border: 1px solid black" width="35%"><%=f_busqueda.ObtenerValor("pers_tnombre")%> </td> 
							<td width="15%">&nbsp;</td>
							<td></td>
						  </tr>						
						  <tr> 
							<td width="11%">Rut </td>
							<td align="right" style="border: 1px solid black" width="27%"> <%=f_busqueda.ObtenerValor("pers_nrut")%>-<%=f_busqueda.ObtenerValor("pers_xdv")%></td>
							<td>Boleta de Honorarios</td>
							<%
							boleta_honor=f_busqueda.ObtenerValor("sogi_bboleta_honorario")
							if Cstr(boleta_honor)=Cstr(1) then marca="Si" else marca= "No" end if
							
							%> 
							<td align="right" style="border: 1px solid black"><%=marca%></td>
						  </tr>
						  <tr>
						    <td>Monto a Girar </td>
						    <td align="right" style="border: 1px solid black"><%=formatnumber(f_busqueda.ObtenerValor("sogi_mgiro"),0)%></td> 
							<td > Descripcion Moneda </td>
							<td align="right" style="border: 1px solid black">&nbsp;<%
							f_busqueda.AgregaCampoParam "tmon_ccod", "permiso", "ESCRITURA"
							f_busqueda.DibujaCampo("tmon_ccod")%></td>
						  </tr>
						</table>
                        <%if f_oc.nroFilas >=1 then%>
						<p><strong>Datos de la Orden de Compra</strong></p>
						<table width="100%" border="0" cellspacing="1" cellpadding="1">
						  <tr >
						    <td>N° de la OC </td>
						    <td>Fecha OC</td> 
							<td>Valor OC</td> 
							<td>Tipo Moneda</td>
						  </tr>						
						  <tr> 
						  	<td style="border: 1px solid black">&nbsp;<%=f_oc.ObtenerValor("ordc_ncorr")
							%> </td>
							<td style="border: 1px solid black">&nbsp;<%=f_oc.ObtenerValor("ordc_fentrega")
							%> </td>
							<td style="border: 1px solid black">&nbsp;<%=f_oc.ObtenerValor("ordc_mmonto")
							%> </td>
							<td style="border: 1px solid black">&nbsp;<%=f_oc.ObtenerValor("tmon_tdesc")
							%> </td>
						  </tr>
						</table>
                        <%else%>
                        <p><strong>Datos de la Solicitud</strong></p>
						<table width="100%" border="0" cellspacing="1" cellpadding="1">
						  <tr >
						    <td>N° de la Solicitud </td>
						    <td>Fecha Solicitud</td> 
							<td>Valor Solicitud</td> 
							<td>Tipo Moneda</td>
						  </tr>						
						  <tr> 
							<td style="border: 1px solid black">&nbsp;<%=f_busqueda.ObtenerValor("sogi_ncorr")%></td>
							<td style="border: 1px solid black">&nbsp;<%=f_busqueda.ObtenerValor("ocag_fingreso")%></td>
							<td style="border: 1px solid black">&nbsp;<%=formatnumber(f_busqueda.ObtenerValor("sogi_mgiro"),0)%></td>
							<td style="border: 1px solid black">&nbsp;<%
																								f_busqueda.AgregaCampoParam "tmon_ccod", "permiso", "ESCRITURA"
																								f_busqueda.DibujaCampo("tmon_ccod")
																							%> </td>
							
						  </tr>
						</table>
                        
                        
                        <%end if%>
						<p><strong>Datos Presupuesto</strong> <font color="#0033FF"><%=msg_oc%></font></p>
								<table width="100%" border='0' cellpadding='1' cellspacing='1' >
									<tr>
										<th width="50%">Descripcion</th>
										<th width="12%">Codigo</th>
										<th width="12%">Mes</th>
										<th width="12%">Año</th>
										<th width="16%">Valor</th>
									</tr>
									<%
										if f_presupuesto.nrofilas >=1 then
											ind=0
											v_totalizado=0
											while f_presupuesto.Siguiente 
											v_cod_pre=f_presupuesto.ObtenerValor("cod_pre")
											
											%>
											<tr>
												<td style="border: 1px solid black"> 
														<%
														f_cod_pre.primero
														while f_cod_pre.Siguiente 
															if Cstr(f_cod_pre.ObtenerValor("cod_pre"))=Cstr(v_cod_pre) then
																response.Write(f_cod_pre.ObtenerValor("valor"))
															end if
														wend%>
											  </td>
												<td style="border: 1px solid black"><%=v_cod_pre%></td>
												<td style="border: 1px solid black"><%
												f_presupuesto.AgregaCampoParam "mes_ccod", "permiso", "ESCRITURA"
												f_presupuesto.DibujaCampo("mes_ccod")%> </td>
												<td style="border: 1px solid black"><%
												f_presupuesto.AgregaCampoParam "anos_ccod", "permiso", "ESCRITURA"
												f_presupuesto.DibujaCampo("anos_ccod")%> </td>
												<td style="border: 1px solid black" align="right"><%=formatnumber(f_presupuesto.ObtenerValor("psol_mpresupuesto"),0)%> </td>
											</tr>	
											<%
											v_totalizado=v_totalizado+clng(f_presupuesto.ObtenerValor("psol_mpresupuesto"))
											ind=ind+1
											wend
										end if 
									%>
									<tr>
										<th colspan="4" align="right">Total presupuesto</th>
										<td width="10%" style="border: 1px solid black" align="right"><%=formatnumber(v_totalizado,0)%></td>
									</tr>
								</table>								
						<p><strong>Datos solicitante</strong></p>
                      <table width="100%" border="0">
                        <tr> 
                          <td align="center">
								<table width="100%" border="0">
									<tr> 
										<td width="16%" height="37">Solicitado por </td>
									  <td width="33%" style="border: 1px solid black">&nbsp;<%=f_datos_area.ObtenerValor("nombre_responsable")%></td>
									  <td width="16%">&nbsp;</td>
										<td width="35%" rowspan="3" align="center" valign="bottom"><img src="../imagenes/autorizado.png"  width="185" height="105"  ><br>_______________________<br>
									  Firma y Timbre solicitante</td>
									</tr>
									<tr> 
										<td width="16%" height="37">Generada por </td>
									  <td width="33%" colspan="1" style="border: 1px solid black"><%=Ucase(v_generador)%></td>
									</tr>
                                    <tr> 
										<td width="16%" height="37">Unidad Solicitante </td>
										<td colspan="2" style="border: 1px solid black"><%=f_datos_area.ObtenerValor("area_tdesc")%></td>
									</tr>
								</table>					  
						  </td>
                        </tr>
						<tr>
							<td>
							
							<p><strong>Identificacion de gastos</strong></p>
								<table width="100%" border='0' cellpadding='0' cellspacing='2'>
								<tr>
									<th width="30%">Tipo Gasto</th>
									<th width="30%">Descripcion</th>
									<th width="8%">Abonado</th>
									<th width="8%">Cantidad</th>
									<th width="8%">Valor<br>Unitario</th>
									<th width="8%">Descuento</th>
									<th width="8%">Valor<br>Neto</th>
								</tr>
									<%
										if f_detalle.nrofilas >=1 then
											ind_d=0
											v_totalizado=0
											while f_detalle.Siguiente %>
											<tr>
												<td style="border: 1px solid black"><%
												f_detalle.AgregaCampoParam "tgas_ccod", "permiso", "ESCRITURA"
												f_detalle.DibujaCampo("tgas_ccod")
												%></td>
												<td style="border: 1px solid black"><%=f_detalle.ObtenerValor("dorc_tdesc")%></td>
												<%
												v_dorc_abono=f_detalle.ObtenerValor("dorc_abono")
												
												'RESPONSE.WRITE("v_dorc_abono: "&v_dorc_abono&"<BR>")
												
												if Cstr(v_dorc_abono)=Cstr(0) then v_etiqueta="No" else v_etiqueta="Si" end if
												
												%>
												<td style="border: 1px solid black"><%=v_etiqueta%></td>
												<td style="border: 1px solid black"><%=f_detalle.ObtenerValor("dorc_ncantidad")%></td>
												<td style="border: 1px solid black"><%=f_detalle.ObtenerValor("dorc_nprecio_unidad")%></td>
												<td style="border: 1px solid black"><%=f_detalle.ObtenerValor("dorc_ndescuento")%></td>
												<td style="border: 1px solid black"><%=f_detalle.ObtenerValor("dorc_nprecio_neto")%> </td>
											</tr>	
											<%
											ind_d=ind_d+1
											v_totalizado=v_totalizado+clng(f_detalle.ObtenerValor("dorc_nprecio_neto"))
											wend
											v_total_sumado=clng(v_totalizado)+clng(v_variable)
										end if 
									%>
								<tr>
										<th colspan="6" align="right">Total gastos</th>
										<td width="10%" style="border: 1px solid black"><%=v_total_sumado%></td>
								</tr>	
                                <br><br><br>
                                <tr>
                                <td width="16%" height="37">Detalle de Gasto   :</td>
										<td colspan="2" style="border: 1px solid black"><%=f_busqueda.ObtenerValor("sogi_tobservaciones")%></td>
                                </tr>								
								</table>
								<br>							
						  </td>
						</tr>
						<tr>
							<td>
							<p><strong>Datos de la Factura o Boleta</strong></p>
								<table width="100%" align="center" cellpadding='1' cellspacing='1'>
                                    <tr>
									  <th width="44%" >Tipo Docto </th>
                                      <th width="8%" >N&deg; Docto </th>
                                      <th width="8%" >Exento</th>
                                      <th width="8%" >Neto</th>
                                      <th width="8%" >Iva</th>
                                      <th width="8%" >Honorarios</th>
                                      <th width="8%" >Retencion</th>
                                      <th width="8%" >Total</th>
                                    </tr>
                                    <%
										indice=0
										v_totalizado=0
										while f_detalle_pago.Siguiente 
									%>
                                    <tr align="left">
                                      <td style="border: 1px solid black" ><%
									  f_detalle_pago.AgregaCampoParam "tdoc_ccod2", "permiso", "ESCRITURA"
									  f_detalle_pago.DibujaCampo("tdoc_ccod2")%></td>
                                      <td style="border: 1px solid black" ><%=f_detalle_pago.ObtenerValor("dsgi_ndocto")%></td>
									  
                                      <td style="border: 1px solid black" ><%=f_detalle_pago.ObtenerValor("dsgi_mexento")%></td>
                                      <td style="border: 1px solid black" ><%=f_detalle_pago.ObtenerValor("dsgi_mafecto")%></td>
									  
                                      <td style="border: 1px solid black" ><%=f_detalle_pago.ObtenerValor("dsgi_miva")%></td>
                                      <td style="border: 1px solid black" ><%=f_detalle_pago.ObtenerValor("dsgi_mhonorarios")%></td>
                                      <td style="border: 1px solid black" ><%=f_detalle_pago.ObtenerValor("dsgi_mretencion")%></td>
									  
                                      <td style="border: 1px solid black" ><%=f_detalle_pago.ObtenerValor("dsgi_mpesos")%></td>
                                    </tr>
                                    <%
										indice=indice+1
										v_totalizado=v_totalizado+clng(f_detalle_pago.ObtenerValor("dsgi_mpesos"))
										wend
									%>
									<tr>
										<th colspan="7" align="right">Total doctos</th>
										<td width="10%" style="border: 1px solid black"><%=v_totalizado%></td>
									</tr>
                                </table>
									
							</td>
						</tr>
                      </table>
					  <br/>
					<table align="center" width="98%" border="0"  cellspacing="10">
						<tr>
							<td style="border: 1px solid black" valign="bottom" width="25%"><br><br><br>V°B° Presupuesto</td>
							<td style="border: 1px solid black" valign="bottom" width="25%"><br><br><br>V°B° Direccion de Finanzas</td>
							<td style="border: 1px solid black" valign="bottom" width="25%"><br><br><br>V°B° Vicerrector Adm. y Finanzas</td>
                            <td style="border: 1px solid black" valign="bottom" width="25%"><br><br><br>V°B° Rector</td>
						</tr>
					</table>
				    </td>
                  </tr>
                </table>
					</td>
                </tr>
            </table>
		  </td>
        </tr>
      </table>	
</body>
</html>