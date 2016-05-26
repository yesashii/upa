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
'FECHA ACTUALIZACION 	:19/07/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ORDEN DE COMPRA
'LINEA			:
'*******************************************************************

ordc_ncorr	= request.querystring("ordc_ncorr")
area_ccod	= request.querystring("area_ccod")
rut 		= request.querystring("pers_nrut")
digito 		= request.querystring("pers_xdv")
v_boleta	= request.querystring("v_boleta")

'RESPONSE.WRITE("rut: "&rut&"<BR")

if ordc_ncorr="" then
	ordc_ncorr	= request.querystring("orden[0][ordc_ncorr]")
end if

set pagina = new CPagina
pagina.Titulo = "Orden de Compra N°"&ordc_ncorr
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
'***********************************************

set f_orden = new CFormulario
f_orden.Carga_Parametros "orden_compra.xml", "buscador_orden"
f_orden.Inicializar conexion
f_orden.Consultar "select ''"
f_orden.Siguiente

f_orden.AgregaCampoCons "ordc_ncorr", ordc_ncorr



' Si no ha sido ingresada una OC
if ordc_ncorr<>"" then
	ini_com= "<!--"
	fin_com= "-->"


'**********************************************************
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "orden_compra.xml", "datos_proveedor"
f_busqueda.Inicializar conectar
	if ordc_ncorr<>"" then
	
	'	sql_orden="select isnull(tmon_ccod,1) as tmon_ccod, protic.trunc(ordc_fentrega) as ordc_fentrega,protic.trunc(ocag_fingreso) as ocag_fingreso,* from ocag_orden_compra where cast(ordc_ncorr as varchar)='"&ordc_ncorr&"'"
		
		sql_orden="select isnull(tmon_ccod,1) as tmon_ccod, protic.trunc(ordc_fentrega) as ordc_fentrega "&_
						" ,protic.trunc(ocag_fingreso) as ocag_fingreso "&_
						" , ordc_ncorr, pers_ncorr, fecha_solicitud, ordc_ndocto, ordc_tatencion, ordc_mmonto, ordc_ncotizacion, ordc_tobservacion, ordc_tcontacto "&_
						" , ordc_tfono, ordc_bboleta_honorario, cpag_ccod, sede_ccod, audi_tusuario, audi_fmodificacion, ordc_mretencion, ordc_mhonorarios "&_
						" , ordc_mneto, ordc_miva, cod_pre, ordc_mexento, area_ccod "&_
						" , vibo_ccod, tsol_ccod, ocag_frecepcion_presupuesto, ocag_responsable "&_
						" , ocag_generador, ordc_bestado_final, ocag_baprueba "&_
						" from ocag_orden_compra where cast(ordc_ncorr as varchar)='"&ordc_ncorr&"'"
	else
		sql_orden="select ''"
	end if
	
'RESPONSE.WRITE("1. sql_orden "&sql_orden&"<BR>")
	
f_busqueda.Consultar sql_orden
f_busqueda.Siguiente

v_tsol_ccod=f_busqueda.obtenerValor("tsol_ccod")

if v_boleta	="" then
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

set f_busqueda2 = new CFormulario
f_busqueda2.Carga_Parametros "orden_compra.xml", "buscador"
f_busqueda2.Inicializar conexion
f_busqueda2.Consultar "select area_ccod from  presupuesto_upa.protic.area_presupuesto_usuario where area_ccod="&area_ccod
f_busqueda2.Siguiente



	set f_personas = new CFormulario
	f_personas.carga_parametros "tabla_vacia.xml", "tabla_vacia"
	f_personas.inicializar conectar
	
	'sql_datos_persona="Select top 1 * from personas a, direcciones b where a.pers_ncorr=b.pers_ncorr and cast(a.pers_ncorr as  varchar)='"&f_busqueda.obtenerValor("pers_ncorr")&"'"
	
	sql_datos_persona="Select top 1  "&_
								"a.PERS_NCORR ,a.TVIS_CCOD ,a.SEXO_CCOD ,a.TENS_CCOD ,a.COLE_CCOD ,a.ECIV_CCOD ,a.PAIS_CCOD ,a.PERS_BDOBLE_NACIONALIDAD "&_
								" , LTRIM(RTRIM(a.pers_tnombre + ' ' + a.PERS_TAPE_PATERNO + ' ' + a.PERS_TAPE_MATERNO)) as v_nombre "&_
								" , LTRIM(RTRIM(a.pers_tnombre + ' ' + a.PERS_TAPE_PATERNO + ' ' + a.PERS_TAPE_MATERNO)) as PERS_TNOMBRE "&_	
								",a.PERS_NRUT ,a.PERS_XDV ,a.PERS_FNACIMIENTO "&_
								",a.CIUD_CCOD_NACIMIENTO ,a.PERS_FDEFUNCION ,a.PERS_TEMPRESA ,a.PERS_TFONO_EMPRESA ,a.PERS_TCARGO ,a.PERS_TPROFESION "&_
								",a.PERS_TFONO ,a.PERS_TFAX ,a.PERS_TCELULAR ,a.PERS_TEMAIL ,a.PERS_TPASAPORTE ,a.PERS_FEMISION_PAS ,a.PERS_FVENCIMIENTO_PAS "&_
								",a.PERS_FTERMINO_VISA ,a.PERS_NNOTA_ENS_MEDIA ,a.PERS_TCOLE_EGRESO ,a.PERS_NANO_EGR_MEDIA ,a.PERS_TRAZON_SOCIAL ,a.PERS_TGIRO "&_
								",a.PERS_TEMAIL_INTERNO ,a.NEDU_CCOD ,a.IFAM_CCOD ,a.ALAB_CCOD ,a.ISAP_CCOD ,a.FFAA_CCOD ,a.PERS_TTIPO_ENSENANZA ,a.PERS_TENFERMEDADES "&_
								",a.PERS_TMEDICAMENTOS_ALERGIA ,a.AUDI_TUSUARIO ,a.AUDI_FMODIFICACION ,a.ciud_nacimiento ,a.regi_particular ,a.ciud_particular "&_
								",a.pers_bmorosidad ,a.sicupadre_ccod ,a.sitocup_ccod ,a.tenfer_ccod ,a.descrip_tenfer ,a.trabaja ,a.pers_temail2  "&_
								",b.TDIR_CCOD ,b.CIUD_CCOD ,b.DIRE_CPOSTAL ,b.DIRE_TCALLE ,b.DIRE_TNRO ,b.DIRE_TPOBLACION ,b.DIRE_TBLOCK ,b.DIRE_TDEPTO "&_
								",b.DIRE_TLOCALIDAD ,b.DIRE_TFONO ,b.DIRE_TCELULAR ,b.AUDI_TUSUARIO ,b.AUDI_FMODIFICACION "&_
								"from personas a "&_
								"INNER JOIN direcciones b  "&_
								"ON a.pers_ncorr=b.pers_ncorr  "&_
								"and cast(a.pers_ncorr as varchar)='"&f_busqueda.obtenerValor("pers_ncorr")&"'"
	
	
	'RESPONSE.WRITE("4. sql_datos_persona : "&sql_datos_persona&"<BR>")
	
	f_personas.consultar sql_datos_persona
	f_personas.Siguiente
	
	f_busqueda.AgregaCampoCons "pers_tnombre", f_personas.obtenerValor("pers_tnombre")
	f_busqueda.AgregaCampoCons "dire_tcalle", f_personas.obtenerValor("dire_tcalle")
	f_busqueda.AgregaCampoCons "dire_tnro", f_personas.obtenerValor("dire_tnro")
	f_busqueda.AgregaCampoCons "pers_tfono", f_personas.obtenerValor("pers_tfono")
	f_busqueda.AgregaCampoCons "pers_tfax", f_personas.obtenerValor("pers_tfax")
	f_busqueda.AgregaCampoCons "ciud_ccod", f_personas.obtenerValor("ciud_ccod")
	f_busqueda.AgregaCampoCons "pers_nrut", f_personas.obtenerValor("pers_nrut")
	f_busqueda.AgregaCampoCons "pers_xdv", f_personas.obtenerValor("pers_xdv")

'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
v_pers_tnombre = f_personas.obtenerValor("pers_tnombre")
v_rut=f_personas.obtenerValor("pers_nrut")

IF v_rut="" THEN
v_rut=rut
END IF

	'8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
	'88 INICIO
	
	if v_pers_tnombre="" then
	
	set f_personas2 = new CFormulario
	f_personas2.carga_parametros "tabla_vacia.xml", "tabla_vacia"
	f_personas2.inicializar conexion

	sql_datos_persona= " select CODAUX AS pers_nrut, RIGHT(RUTAUX,1) AS pers_xdv, NOMAUX AS pers_tnombre, NOMAUX AS v_nombre "&_
											" from softland.cwtauxi where cast(CodAux as varchar)='"&v_rut&"'"
											
	'RESPONSE.WRITE("sql_datos_persona: "&sql_datos_persona&"<BR>")
	
	f_personas2.consultar sql_datos_persona
	f_personas2.Siguiente
						
	v_pers_tnombre = f_personas2.obtenerValor("pers_tnombre")
						
	f_busqueda.AgregaCampoCons "pers_tnombre", f_personas2.obtenerValor("pers_tnombre")
	f_busqueda.AgregaCampoCons "pers_nrut", f_personas2.obtenerValor("pers_nrut")
	f_busqueda.AgregaCampoCons "pers_xdv", f_personas2.obtenerValor("pers_xdv")
	
	end if
	'88 FIN
	'8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
	
'888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

 set f_presupuesto = new CFormulario
 
 	f_presupuesto.Carga_Parametros "orden_compra.xml", "detalle_presupuesto"
 	f_presupuesto.Inicializar conectar
	
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
	
	'RESPONSE.WRITE("2. sql_presupuesto "&sql_presupuesto&"<BR>")
	'RESPONSE.END()
	
	f_presupuesto.consultar sql_presupuesto	
	filas_presu= f_presupuesto.nrofilas
	
 set f_detalle = new CFormulario
 	f_detalle.Carga_Parametros "orden_compra.xml", "detalle_producto"
 	f_detalle.Inicializar conectar
 	sql_detalle="select * from ocag_detalle_orden_compra where cast(ordc_ncorr as varchar)='"&ordc_ncorr&"'"
	
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
	f_responsable.consultar sql_responsable
	
'*****************************************************************************************
'***************	listas de seleccion para filas de tabla dinamica	******************	




set f_tipo_gasto = new CFormulario
f_tipo_gasto.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_tipo_gasto.inicializar conectar
sql_tipo_gasto= "Select top 5  tgas_ccod, ltrim(rtrim(tgas_tdesc)) as tgas_tdesc,pare_ccod from ocag_tipo_gasto"
f_tipo_gasto.consultar sql_tipo_gasto


set f_cod_pre = new CFormulario
f_cod_pre.carga_parametros "orden_compra.xml", "codigo_presupuesto"
f_cod_pre.inicializar conexion
f_cod_pre.consultar "select '' "

'sql_codigo_pre="(select distinct cod_pre, concepto_pre as valor from presupuesto_upa.protic.codigos_presupuesto where cod_area in ('"&area_ccod&"')) as tabla"

sql_codigo_pre="(select distinct cod_pre, 'Area('+cast(cast(cod_area as numeric) as varchar)+')-'+concepto +' ('+cod_pre+')' as valor "&_
			    " from presupuesto_upa.protic.presupuesto_upa_2011 	"&_
			    "	where cod_anio=2011 "&_
				"	and cod_area in (   select distinct area_ccod "&_ 
				"		 from  presupuesto_upa.protic.area_presupuesto_usuario  "&_
				"		 where rut_usuario in ("&v_usuario&") and cast(area_ccod as varchar)= '"&area_ccod&"') "&_
				" ) as tabla "
				
'RESPONSE.WRITE("3. sql_codigo_pre"&sql_codigo_pre&"<BR>")

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

f_centro_costo.consultar sql_centro_costo
'*****************************************************************************************
'***************	FIN listas de seleccion para filas de tabla dinamica	**************

area_ccod = conexion.ConsultaUno("select area_tdesc from presupuesto_upa.protic.area_presupuestal where area_ccod="& area_ccod)



end if

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
					<td width="182"><img src="../imagenes/logo_upa_2011.jpg" height="100"  alt="Logo"></td>
					<td width="408" valign="top">Vicerrectoria de Administración y Finanzas <br/> 
				  Direccion de Finanzas</td>
					<td width="170">Rut:71.704.700-1<br/>
					CP:7591010-Las Condes<br/>
					Casilla:27012-Santiago/Chile<br/>
					Email:info@upacifico.cl<br/>
				  Pagina Web:www.upacifico.cl<br/></td>
				</tr>
			</table>
		  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td>
                      <center><%pagina.DibujarTituloPagina()%></center>
                <table width="760" align="center">
				<tr>
					<td>
					<p class="encabezado">CASA CENTRAL:<br/>
					Av. Las Condes 11.121 - Teléfono:8625300 - Fax:8625318<br/>
					SEDE MELIPILLA:<br/>
					Av. Jose Massoud 533 - Teléfono:3524900 - Fax:6524943<br/>
					<!--
					CAMPUS BAQUEDANO:<br/>
					Ramon Carnicer 51 y 65 - Teléfono 3526900 - Fax:3526920<br/>
					Ramon Carnicer 67 - Teléfono 3526901<br/>
					OFICINA DE CONCEPCION:<br/>
					Victor Lamas 917 Fono/Fax (41)2224016
					-->
					</p>
					</td>
					<td valign="bottom" align="right"><table>
					<tr><td align="left">Fecha solicitud:</td><td style="border: 1px solid black">&nbsp;<%=f_busqueda.ObtenerValor("ocag_fingreso")%></td></tr>
					<tr><td align="left">Fecha de impresión:</td><td style="border: 1px solid black">&nbsp;<%=fecha_actual%></td>
					</tr>
					</table>
					
					</td>
				</tr>
				</table>
                  <table width="760" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
                    <td>
						<table width="100%" border="0">
						  <tr >
						    <td width="15%"> Se&ntilde;ores </td>
						    <td style="border: 1px solid black" width="35%">&nbsp;<%=f_busqueda.ObtenerValor("pers_tnombre")%> </td> 
							<td width="15%"> N&deg; Cotizaci&oacute;n </td>
							<td style="border: 1px solid black" width="35%">&nbsp;<%=f_busqueda.ObtenerValor("ordc_ncotizacion")%></td>
						  </tr>						
						  <tr> 
							<td width="11%">Rut </td>
							<td style="border: 1px solid black" width="27%">&nbsp;<%=f_busqueda.ObtenerValor("pers_nrut")%>
						    -<%=f_busqueda.ObtenerValor("pers_xdv")%></td>
							<td>Fecha entrega </td>
							<td style="border: 1px solid black">&nbsp;<%=f_busqueda.ObtenerValor("ordc_fentrega")%></td>
						  </tr>
						  <tr>
						    <td>Direcci&oacute;n</td>
						    <td style="border: 1px solid black">&nbsp;<%=f_busqueda.ObtenerValor("dire_tcalle")%> N&deg;:<%=f_busqueda.ObtenerValor("dire_tnro")%></td> 
							<td>Lugar entrega </td>
							<td style="border: 1px solid black">&nbsp;<%f_busqueda.AgregaCampoParam "sede_ccod", "permiso", "ESCRITURA"
							f_busqueda.dibujaCampo("sede_ccod")%></td>
						  </tr>
						  <tr>
						    <td>Ciudad</td>
						    <td style="border: 1px solid black">&nbsp;<%f_busqueda.AgregaCampoParam "ciud_ccod", "permiso", "ESCRITURA"
							f_busqueda.dibujaCampo("ciud_ccod")%></td> 
							<td>Cond. Pago </td>
							<td style="border: 1px solid black">&nbsp;<%f_busqueda.AgregaCampoParam "cpag_ccod", "permiso", "ESCRITURA"
							f_busqueda.dibujaCampo("cpag_ccod")%></td>
						  </tr>
						  <tr>
						    <td>Tel&eacute;fono</td>
						    <td style="border: 1px solid black">&nbsp;<%=f_busqueda.ObtenerValor("pers_tfono")%></td> 
							<td >Atenci&oacute;n a </td>
							<td  style="border: 1px solid black">&nbsp;<%=f_busqueda.ObtenerValor("ordc_tatencion")%></td>
						  </tr>
						  <tr>
						    <td>Fax</td>
						    <td style="border: 1px solid black">&nbsp;<%=f_busqueda.ObtenerValor("pers_tfax")%></td>
							 <td >Descripci&oacute;n Moneda </td>
						     <!--<td style="border: 1px solid black">&nbsp;<%
							 'f_busqueda.dibujaCampo("tmon_ccod")
							 %></td>-->
						     <td style="border: 1px solid black">&nbsp;<%
							f_busqueda.AgregaCampoParam "tmon_ccod", "permiso", "ESCRITURA"
							f_busqueda.DibujaCampo("tmon_ccod")
							 %></td>
						  </tr>
						  <tr>
						    <td>Observaci&oacute;n general </td>
						    <td colspan="3" style="border: 1px solid black">&nbsp;<%=f_busqueda.ObtenerValor("ordc_tobservacion")%></td>
						  </tr>
						</table>
						<p><strong>Datos Presupuesto</strong></p>
								<table width="100%" border='1' bordercolor='#999999' cellpadding='0' cellspacing='0' id=tb_presupuesto>
									<tr>
										<th width="50%">Descripcion</th>
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
														<%
														f_cod_pre.primero
														while f_cod_pre.Siguiente 
															if Cstr(f_cod_pre.ObtenerValor("cod_pre"))=Cstr(v_cod_pre) then
																response.Write(f_cod_pre.ObtenerValor("valor"))
															end if
														wend%>
											  </td>
												<td><%
												f_presupuesto.AgregaCampoParam "mes_ccod", "permiso", "ESCRITURA"
												f_presupuesto.DibujaCampo("mes_ccod")%> </td>
												<td><%
												f_presupuesto.AgregaCampoParam "anos_ccod", "permiso", "ESCRITURA"
												f_presupuesto.DibujaCampo("anos_ccod")%> </td>
												<td><%=formatnumber(f_presupuesto.ObtenerValor("porc_mpresupuesto"),0)%> </td>
											</tr>	
											<%
											
											ind=ind+1
											wend
										end if 
									%>
								</table>								
						<p><strong>Datos solicitante</strong></p>
                      <table width="100%" border="0">
                        <tr> 
                          <td align="center">
                          
                          <table width="100%" border="0">
									<tr> 
										<td width="16%" height="37">Solicitado por </td>
									  <td width="33%" style="border: 1px solid black">&nbsp;<%=f_busqueda.ObtenerValor("ordc_tcontacto")%></td>
									  <td width="16%">&nbsp;</td>
										<td width="35%" rowspan="3" align="center" valign="bottom"><img src="../imagenes/autorizado.png"  width="185" height="105"  ><br>_______________________<br>
									  Firma y Timbre solicitante</td>
									</tr>
									<tr> 
										<td width="16%" height="37">Lugar Entrega </td>
									  <td width="33%" colspan="1" style="border: 1px solid black"><%
										f_busqueda.AgregaCampoParam "sede_ccod", "permiso", "ESCRITURA"
										f_busqueda.dibujaCampo("sede_ccod")%></td>
									</tr>
                                    <tr> 
										<td width="16%" height="37">Unidad Solicitante </td>
										<td colspan="2" style="border: 1px solid black"><%=area_ccod%></td>
									</tr>
								</table>						  
						  </td>
                        </tr>
						<tr>
							<td>
							
							<p><strong>Identificacion de gastos</strong></p>
								<table width="100%" border='1' bordercolor='#999999' cellpadding='0' cellspacing='0' id=tb_busqueda_detalle>
								<tr>
									<th>Tipo Gasto</th>
									<th>Afecta</th>
									<th>Descripcion</th>
									<th>Cantidad</th>
									<th>Precio Unitario</th>
									<th>Descuento($)</th>
									<th><%=segun_boleta%></th>
								</tr>
									<%
										if f_detalle.nrofilas >=1 then
											ind_d=0
											while f_detalle.Siguiente %>
											
											<tr>
												<td><%
												f_detalle.AgregaCampoParam "tgas_ccod", "permiso", "ESCRITURA"
												f_detalle.DibujaCampo("tgas_ccod")%></td>
												<td><% if f_detalle.ObtenerValor("dorc_bafecta")="1" then response.Write("SI") else response.Write("NO") end if%></td>
												<td><%=f_detalle.ObtenerValor("dorc_tdesc")%></td>
												<td><%=f_detalle.ObtenerValor("dorc_ncantidad")%> </td>
										      	<td><%=f_detalle.ObtenerValor("dorc_nprecio_unidad")%></td>
												<td><%=f_detalle.ObtenerValor("dorc_ndescuento")%> </td>
												<td><%=f_detalle.ObtenerValor("dorc_nprecio_neto")%> </td>
											</tr>	
											<%
											ind_d=ind_d+1
											wend
										end if 
									%>
								</table>
								<br>							</td>
						</tr>
						<tr>
						<td>
						<table border="0" width="100%" >
							<tr align="right">
								<td width="80%" rowspan="<%=row_span%>">&nbsp;</td>
								<th width="10%"><%=txt_neto%></th>
								<td width="10%" style="border: 1px solid black"><%=v_neto%></td>	
							</tr>
							<tr align="right">
								<th><%=txt_variable%></th>
								<td style="border: 1px solid black"><%=v_variable%></td>
							</tr>
							<% if Cstr(v_boleta)=2 then %>
							<tr align="right">
								<th>Exento</th>
								<td style="border: 1px solid black"><%=v_exento%></td>
							</tr>
							<%end if%>
							<tr align="right">
								<th>Total</th>
								<td style="border: 1px solid black"><%=v_totalizado%></td>
							</tr>
						  </table>
						  </td>
						</tr>
                      </table>
					  <br/>
					<table align="center" width="100%" border="0"  cellspacing="10">
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