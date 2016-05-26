<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->

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
'FECHA ACTUALIZACION 	:13/06/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ORDEN DE COMPRA
'LINEA			:55 - 76 - 161 -
'*******************************************************************
set pagina = new CPagina
pagina.Titulo = "Reembolso Gastos"
vibo_ccod = -1
set botonera = new CFormulario
botonera.carga_parametros "reembolso_gasto.xml", "botonera"

v_rgas_ncorr	= request.querystring("busqueda[0][rgas_ncorr]")
v_rut			= request.querystring("rut")
v_dv			= request.querystring("dv")
area_ccod		= request.querystring("area_ccod")
Item		= request.querystring("Item")
v_boleta	= request.querystring("v_boleta")

'RESPONSE.WRITE("1. area_ccod : "&area_ccod&"<BR>")
'RESPONSE.WRITE("1. Item : "&Item&"<BR>")
'RESPONSE.WRITE("1. v_boleta : "&v_boleta&"<BR>")

if v_boleta="" or EsVacio(v_boleta) then
	v_boleta=2	' se establece por defecto el valor de NO uso de boleta honorarios
end if 

'RESPONSE.WRITE("2 v_boleta : "&v_boleta&"<BR>")
 
prueba2		= request.querystring("Item")

'RESPONSE.WRITE("1. prueba2 : ) "&prueba2&"<BR>")

set negocio = new cnegocio
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set conexion = new Cconexion2
conexion.Inicializar "upacifico"

v_usuario 	= 	negocio.ObtenerUsuario()
v_anos_ccod	= 	conectar.consultaUno("select year(getdate())")


 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "reembolso_gasto.xml", "datos_proveedor" 
 f_busqueda.Inicializar conectar
 
 'RESPONSE.WRITE("a) "&v_rgas_ncorr&"<BR>")
 'RESPONSE.END()
 
' 1. CUANDO ESTA CREADA LA SOLICITUD DE GIRO, v_rgas_ncorr = NUMERO DE SOLICITUD
' 2. CUANDO ES NUEVA LA SOLICITUD DE GIRO, v_rgas_ncorr = ""

	if  v_rgas_ncorr<>"" then
	
	resul_nombre = 1
' 1. CUANDO ESTA CREADA LA SOLICITUD DE GIRO, v_rgas_ncorr = NUMERO DE SOLICITUD
	
'		sql_reembolso	=   " select isnull(vibo_ccod,0) as vibo_ccod,protic.trunc(rgas_fpago) as rgas_fpago,pers_tnombre as v_nombre,* "&_
'							" from ocag_reembolso_gastos a, personas c "&_
'						    " where a.pers_ncorr_proveedor=c.pers_ncorr and a.rgas_ncorr="&v_rgas_ncorr

		sql_reembolso	=   " select TOP 1 isnull(a.vibo_ccod,0) as vibo_ccod, protic.trunc(a.rgas_fpago) as rgas_fpago"&_
						    ", a.rgas_ncorr, a.rgas_mgiro, a.pers_ncorr_proveedor, a.tmon_ccod, a.mes_ccod, a.anos_ccod, a.cod_pre, a.audi_tusuario "&_
						    ", a.audi_fmodificacion, a.rgas_frecepcion, a.rgas_tobs_rechazo, a.tsol_ccod, a.area_ccod, a.ocag_fingreso, a.ocag_generador, a.ocag_frecepcion_presupuesto "&_
						    ", a.ocag_responsable, a.ocag_baprueba, a.sede_ccod, a.cod_solicitud_origen"&_
						    ", c.PERS_NCORR, c.TVIS_CCOD, c.SEXO_CCOD, c.TENS_CCOD, c.COLE_CCOD, c.ECIV_CCOD, c.PAIS_CCOD, c.PERS_BDOBLE_NACIONALIDAD, c.PERS_NRUT, c.PERS_XDV "&_
						    ", c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO as v_nombre "&_
						    ", c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO as PERS_TNOMBRE "&_
						    ", c.PERS_TAPE_PATERNO, c.PERS_TAPE_MATERNO, c.PERS_FNACIMIENTO, c.CIUD_CCOD_NACIMIENTO, c.PERS_FDEFUNCION, c.PERS_TEMPRESA "&_
						    ", c.PERS_TFONO_EMPRESA, c.PERS_TCARGO, c.PERS_TPROFESION, c.PERS_TFONO, c.PERS_TFAX, c.PERS_TCELULAR, c.PERS_TEMAIL, c.PERS_TPASAPORTE "&_
						    ", c.PERS_FEMISION_PAS, c.PERS_FVENCIMIENTO_PAS, c.PERS_FTERMINO_VISA, c.PERS_NNOTA_ENS_MEDIA, c.PERS_TCOLE_EGRESO, c.PERS_NANO_EGR_MEDIA "&_
						    ", c.PERS_TRAZON_SOCIAL, c.PERS_TGIRO, c.PERS_TEMAIL_INTERNO, c.NEDU_CCOD, c.IFAM_CCOD, c.ALAB_CCOD, c.ISAP_CCOD, c.FFAA_CCOD, c.PERS_TTIPO_ENSENANZA "&_
						    ", c.PERS_TENFERMEDADES, c.PERS_TMEDICAMENTOS_ALERGIA, c.AUDI_TUSUARIO, c.AUDI_FMODIFICACION, c.ciud_nacimiento, c.regi_particular, c.ciud_particular "&_
						    ", c.pers_bmorosidad, c.sicupadre_ccod, c.sitocup_ccod, c.tenfer_ccod, c.descrip_tenfer, c.trabaja, c.pers_temail2, asgi_tobservaciones "&_
						    "from ocag_reembolso_gastos a, personas c, ocag_autoriza_solicitud_giro d "&_
						    "where a.pers_ncorr_proveedor = c.pers_ncorr "&_
						    "and d.cod_solicitud = a.rgas_ncorr and a.rgas_ncorr = "&v_rgas_ncorr&"  and d.tsol_ccod = 2 ORDER BY d.audi_fmodificacion DESC"
		
		'RESPONSE.WRITE("1. "&sql_reembolso&"<BR><BR>")
		
		sql_detalle		= "SELECT protic.trunc(drga_fdocto) as drga_fdocto  "&_
							" , drga_ncorr, rgas_ncorr, tgas_ccod, tdoc_ccod, drga_ndocto  "&_
							" , drga_tdescripcion, drga_fdocto, audi_tusuario, audi_fmodificacion, cod_solicitud_origen, ccos_ncorr  "&_
							" , ISNULL(drga_mafecto,0)  AS drga_mafecto, ISNULL(drga_miva,0) AS drga_miva, ISNULL(drga_mexento, 0) AS drga_mexento "&_
							" , ISNULL(drga_mhonorarios,0) AS drga_mhonorarios, ISNULL(drga_mretencion,0) AS drga_mretencion, ISNULL(drga_mdocto,0) AS drga_mdocto "&_
							" , ISNULL(drga_bboleta_honorario,0) AS drga_bboleta_honorario "&_
							" FROM ocag_detalle_reembolso_gasto "&_
							" WHERE rgas_ncorr = "&v_rgas_ncorr
		
		f_busqueda.Consultar sql_reembolso
		f_busqueda.Siguiente
		
		area_ccod=f_busqueda.obtenerValor("area_ccod")
		ocag_baprueba = f_busqueda.obtenerValor("ocag_baprueba")
		audi_tusuario=f_busqueda.obtenerValor("audi_tusuario")
		ordc_tobservacion=f_busqueda.obtenerValor("asgi_tobservaciones")
		'RESPONSE.WRITE("2. area_ccod : "&area_ccod&"<BR>")
		'RESPONSE.WRITE("3. audi_tusuario : "&audi_tusuario&"<BR>")
		
		vibo_ccod=f_busqueda.obtenerValor("vibo_ccod")

if v_boleta="" then
	'v_boleta=f_busqueda.obtenerValor("ordc_bboleta_honorario")
	'f_busqueda.AgregaCampoCons "sogi_bboleta_honorario", cstr(v_boleta)
end if

'response.Write("Visto Bueno: "&vibo_ccod)		
	else

' 2. CUANDO ES NUEVA LA SOLICITUD DE GIRO, v_rgas_ncorr = ""

		sql_reembolso	=	"select '' "

		sql_detalle		=	"SELECT 0 AS drga_mafecto, 0 AS drga_miva, 0 AS drga_mexento "&_
							" , 0 AS drga_mhonorarios, 0 AS drga_mretencion, 0 AS drga_mdocto, 0 AS drga_bboleta_honorario"
		
		f_busqueda.Consultar sql_reembolso
		f_busqueda.Siguiente		

	end if
 
		'RESPONSE.WRITE("2. "&sql_detalle&"<BR><BR>")
		'RESPONSE.END()

if v_rut<>"" then
	set f_personas = new CFormulario
	f_personas.carga_parametros "tabla_vacia.xml", "tabla_vacia"
	f_personas.inicializar conexion
	'f_personas.inicializar conectar
	
	sql_datos_persona= " select CODAUX AS pers_nrut, RIGHT(RUTAUX,1) AS pers_xdv, NOMAUX AS pers_tnombre, NOMAUX AS v_nombre "&_
										" from softland.cwtauxi where cast(CodAux as varchar)='"&v_rut&"'"

	'sql_datos_persona= " SELECT PERS_NRUT, PERS_TNOMBRE pers_tnombre, PERS_TAPE_PATERNO + ' ' + PERS_TAPE_MATERNO as v_nombre "&_
	'				   	"FROM PERSONAS "&_
	'				   	"WHERE PERS_NRUT='"&v_rut&"'"
						
	'RESPONSE.WRITE("3. "&sql_datos_persona&"<BR><BR>")

		
	f_personas.consultar sql_datos_persona
	f_personas.Siguiente
	
	f_busqueda.AgregaCampoCons "pers_nrut", v_rut
	f_busqueda.AgregaCampoCons "pers_xdv", v_dv
	f_busqueda.AgregaCampoCons "pers_tnombre", f_personas.obtenerValor("pers_tnombre")
	f_busqueda.AgregaCampoCons "v_nombre", f_personas.obtenerValor("v_nombre")
	
	v_pers_tnombre = f_personas.obtenerValor("pers_tnombre")
	nombre = f_personas.obtenerValor("v_nombre")
	
	'8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
	'88 INICIO
	'RESPONSE.WRITE("v_pers_tnombre: "&v_pers_tnombre&"<BR>")
	
	if v_pers_tnombre="" then
	set f_personas2 = new CFormulario
	f_personas2.carga_parametros "tabla_vacia.xml", "tabla_vacia"
	'f_personas2.inicializar conexion
	f_personas2.inicializar conectar


	sql_datos_persona= " SELECT PERS_NRUT, PERS_TNOMBRE pers_tnombre, PERS_TAPE_PATERNO + ' ' + PERS_TAPE_MATERNO as v_nombre "&_
					   	"FROM PERSONAS "&_
					   	"WHERE PERS_NRUT='"&v_rut&"'"
	
	'RESPONSE.WRITE("sql_datos_persona: "&sql_datos_persona&"<BR>")
	
	f_personas2.consultar sql_datos_persona
	f_personas2.Siguiente
						
	v_pers_tnombre = f_personas2.obtenerValor("pers_tnombre")
	nombre = f_personas2.obtenerValor("v_nombre")
						
	f_busqueda.AgregaCampoCons "pers_tnombre", f_personas2.obtenerValor("pers_tnombre")
	f_busqueda.AgregaCampoCons "v_nombre", f_personas2.obtenerValor("v_nombre")
	
	'RESPONSE.WRITE("v_pers_tnombre 2: "&v_pers_tnombre&"<BR>")
	
	end if
	'88 FIN
	'8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
	
	if nombre <> "" then
		resul_nombre = 1
	else 
		resul_nombre = 0	
	end if
	
end if

'response.Write(sql_detalle)
'response.End()

set f_detalle = new CFormulario
f_detalle.Carga_Parametros "reembolso_gasto.xml", "detalle_reembolso"
f_detalle.Inicializar conectar
f_detalle.Consultar sql_detalle
f_detalle.agregaCampoParam "tgas_ccod","destino", " ( Select b.tgas_ccod,ltrim(rtrim(tgas_tdesc )) as tgas_tdesc "&_
			"	from ocag_perfiles_areas_usuarios a, ocag_tipo_gasto_perfil b, ocag_tipo_gasto c "&_
			"	where a.pers_nrut="&v_usuario&" "&_
			"	and a.pare_ccod=b.pare_ccod "&_
			"	and b.tgas_ccod=c.tgas_ccod  ) as tabla "

set f_tipo_gasto = new CFormulario
f_tipo_gasto.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_tipo_gasto.inicializar conectar
sql_tipo_gasto= "Select b.tgas_ccod,ltrim(rtrim(tgas_tdesc )) as tgas_tdesc "&_
				"	from ocag_perfiles_areas_usuarios a, ocag_tipo_gasto_perfil b, ocag_tipo_gasto c "&_
				"	where a.pers_nrut="&v_usuario&" "&_
				"	and a.pare_ccod=b.pare_ccod "&_
				"	and b.tgas_ccod=c.tgas_ccod "&_
				"   order by tgas_tdesc asc "
				
f_tipo_gasto.consultar sql_tipo_gasto

set f_tipo_docto = new CFormulario
f_tipo_docto.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_tipo_docto.inicializar conectar
'sql_tipo_docto= "Select * from ocag_tipo_documento where tdoc_ccod not in(1,11) order by tdoc_tdesc asc "
sql_tipo_docto= "Select * from ocag_tipo_documento order by tdoc_tdesc asc "
f_tipo_docto.consultar sql_tipo_docto

' CENTRO COSTO
' ********************
set f_centro_costo= new CFormulario
f_centro_costo.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_centro_costo.inicializar conectar

sql_centro_costo= "select b.pers_nrut,a.ccos_ncorr,a.ccos_tcodigo as ccos_tcompuesto,ccos_tdesc "&_
						" from ocag_centro_costo a, ocag_permisos_centro_costo b "&_
						" where a.ccos_tcodigo=b.ccos_tcodigo "&_
						" and pers_nrut = "&v_usuario	
						
'RESPONSE.WRITE(sql_centro_costo)
'RESPONSE.END()

f_centro_costo.consultar sql_centro_costo

'*****************************************************************
'***************	Inicio bases para presupuesto	**************
set f_presupuesto = new CFormulario
f_presupuesto.Carga_Parametros "datos_presupuesto.xml", "detalle_presupuesto"
f_presupuesto.Inicializar conectar

if v_rgas_ncorr<>"" then

'	sql_presupuesto="select * from ocag_presupuesto_solicitud where cast(cod_solicitud as varchar)= ' "&v_rgas_ncorr&" ' and tsol_ccod=2"

	sql_presupuesto="select psol_ncorr, tsol_ccod, cod_solicitud, cod_pre, mes_ccod, anos_ccod "&_
						 ", psol_mpresupuesto, audi_tusuario, audi_fmodificacion, psol_brendicion, cod_solicitud_origen "&_
						 "from ocag_presupuesto_solicitud "&_
						 "where cast(cod_solicitud as varchar)=  '"&v_rgas_ncorr&"'  "&_
						 "and tsol_ccod = 2"
	
	'RESPONSE.WRITE("4. "&sql_presupuesto&"<BR><BR>")
	
else
	sql_presupuesto="select '' "
end if	

'response.Write(sql_presupuesto)

f_presupuesto.consultar sql_presupuesto

v_suma_presupuesto=0
if f_presupuesto.nrofilas>=1 and v_rgas_ncorr>=1 then
	while f_presupuesto.Siguiente
		v_suma_presupuesto= Clng(v_suma_presupuesto) + Clng(f_presupuesto.obtenerValor("psol_mpresupuesto"))
	wend
end if


set f_cod_pre = new CFormulario
f_cod_pre.carga_parametros "datos_presupuesto.xml", "codigo_presupuesto"
f_cod_pre.inicializar conexion
f_cod_pre.consultar "select '' "

'sql_codigo_pre="(select distinct cod_pre, 'Area('+cast(cast(cod_area as numeric) as varchar)+')-'+concepto +' ('+cod_pre+')' as valor "&_
'			    " from presupuesto_upa.protic.presupuesto_upa_2011 	"&_
'			    "	where cod_anio=2011 "&_
'				"	and cod_area in (   select distinct area_ccod "&_ 
'				"		 from  presupuesto_upa.protic.area_presupuesto_usuario  "&_
'				"		 where rut_usuario in ("&v_usuario&") and cast(area_ccod as varchar)= '"&area_ccod&"') "&_
'				" ) as tabla "

if audi_tusuario <> "" then
v_usuario=audi_tusuario
end if

sql_codigo_pre="(select distinct cod_pre, '('+cod_pre+') ' + 'Area('+cast(cast(cod_area as numeric) as varchar)+')-'+concepto as valor  "&_
			    " from presupuesto_upa.protic.presupuesto_upa_2011 	"&_
			    "	where cod_anio=2011 "&_
				"	and cod_area in (   select distinct area_ccod "&_ 
				"		 from  presupuesto_upa.protic.area_presupuesto_usuario  "&_
				"		 where rut_usuario in ("&v_usuario&") and cast(area_ccod as varchar)= '"&area_ccod&"') "&_
				" ) as tabla "

'RESPONSE.WRITE("5. "&sql_codigo_pre&"<BR><BR>")
'RESPONSE.END

f_cod_pre.agregaCampoParam "cod_pre","destino", sql_codigo_pre
f_cod_pre.consultar sql_codigo_pre
f_cod_pre.Siguiente

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

if v_rgas_ncorr="" or EsVacio(v_rgas_ncorr) then
	f_presupuesto.AgregaCampoCons "anos_ccod", v_anos_ccod
end if	

'1. 88888888888888888888888888888888 ** MUESTRA EL SALDO DISPONIBLE ** 88888888888888888888888888888888 
set f_control_presupuesto = new CFormulario
f_control_presupuesto.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_control_presupuesto.inicializar conectar

'sql_control_presupuesto= " select isnull(pr.cajcod,pa.cajcod) as cod_pre, isnull(ejecutado,0) as ejecutado,isnull(presupuestado,0) as presupuestado, isnull(presupuestado,0)-isnull(ejecutado,0) as saldo  "&_
'						 "	from   "&_
'						"		(select sum(valor) as presupuestado,cod_pre as cajcod      "&_
'						"			from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2011     "&_
'						"			where cod_pre in (select distinct cod_pre from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2011 where cod_area= '"&area_ccod&"' )  "&_
'						"			group by cod_pre  "&_
'						"		) as pa  "&_
'						"		left outer join      "&_
'						"		(select isnull(sum(cast(movhaber as numeric)),0) as ejecutado, a.cajcod as cajcod    "&_
'						"		from  softland.cwmovim a, softland.cwmovef b      "&_
'						"		where a.cpbnum=b.cpbnum  "&_
'						"		and a.movnum=b.movnum   "&_
'						"		and a.movhaber=b.efmontohaber   "&_
'						"		and	substring(b.efcodi,3,4)=2011    "&_ 
'						"		and a.cajcod in (select distinct cod_pre COLLATE SQL_Latin1_General_CP1_CI_AI from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2011 where cod_area= '"&area_ccod&"' )    "&_
'						"		and a.movhaber <> 0       "&_
'						"		and a.pctcod like '2-10-070-10-000004'      "&_
'						"		and a.cpbnum>0   "&_
'						"		group by a.cajcod "&_
'						"		) as pr    "&_
'						"	on pa.cajcod=pr.cajcod COLLATE SQL_Latin1_General_CP1_CI_AI "

'response.Write("1. sql_control_presupuesto : "&sql_control_presupuesto&"<br>")

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
							" and tsol_ccod=2 "&_
							" and cod_pre in (select distinct cod_pre COLLATE SQL_Latin1_General_CP1_CI_AI from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2013 where cod_area= '"&area_ccod&"' ) "&_
							" group by cod_pre, mes_ccod "&_
							" ) as  pr   "&_
							" on pa.cajcod=pr.cajcod COLLATE SQL_Latin1_General_CP1_CI_AI "&_
							" and pa.mes_ccod= pr.mes_ccod "&_
							" order by cod_pre, mes_presu "
							

f_control_presupuesto.consultar sql_control_presupuesto

'response.Write("1. sql_control_presupuesto : "&sql_control_presupuesto&"<br>")

'1. 88888888888888888888888888888888 ** MUESTRA EL SALDO DISPONIBLE ** 88888888888888888888888888888888 

'*****************************************************************
'***************	Fin bases para presupuesto	******************

'*****************************************************************
'***************	Inicio bases para Responsables	**************
set f_responsable = new CFormulario
	f_responsable.carga_parametros "tabla_vacia.xml", "tabla_vacia"
	f_responsable.inicializar conectar
	sql_responsable= "Select pers_nrut_responsable as pers_nrut,protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre,a.PERS_TEMAIL as email "&_
					  "	from ocag_responsable_area a, personas b "&_
					  "	where a.pers_nrut_responsable=b.pers_nrut "&_
					  "	and cast(a.pers_nrut as varchar)='"&v_usuario&"'"
	f_responsable.consultar sql_responsable
'*****************************************************************
'***************	Fin de bases para Responsables	**************	

prueba =request.form("detalle[0][numero]")

prueba = prueba2

'RESPONSE.WRITE("1. prueba : ) "&prueba&"<BR>")

if prueba = 10 then
 selected10= "selected=""selected"""
end if

if prueba = 15 then
 selected15= "selected=""selected"""
end if

if prueba = 5 then
selected5= "selected=""selected"""
end if
prueba = prueba - 2

'88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
' JAIME PAINEMAL 20130910
 
 'DETALLE TIPO DE GASTOS (Cuentas Contables)
set f_mes_anio = new CFormulario
f_mes_anio.Carga_Parametros "reembolso_gasto.xml", "busqueda"
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

Usuario = negocio.ObtenerUsuario()
nombre_solicitante = conectar.ConsultaUno("select protic.obtener_nombre_completo(pers_ncorr, 'n') as nombre from personas where cast(pers_nrut as varchar) = '" & Usuario & "'")
tipo_soli = "Reembolso de Gastos"
n_soli=v_rgas_ncorr

%>
<html>
<head>
<title>Reembolso de Gastos</title>
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

<script language="JavaScript">

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

//### Actualiza el presupuesto cada vez que cambia de codigo en el select de los codigos presupuestarios
function RevisaPresupuesto(cod_pre, nombre) {
ind	= extrae_indice(nombre);
mes_presu	=	document.datos.elements["busqueda["+ind+"][mes_ccod]"].value;
// recorriendo el arreglo
	for (x=0;x<arr_presupuesto.length;x++){
		
		if((arr_presupuesto[x]["cod_pre"]==cod_pre)&&(arr_presupuesto[x]["mes_presu"]==mes_presu)){
			document.datos.elements["busqueda["+ind+"][saldo]"].value = arr_presupuesto[x]["saldo"];
			document.datos.elements["presupuesto["+ind+"][psol_mpresupuesto]"].value=0;
		}
	}
}

//### Actualiza el presupuesto cada vez que cambia de codigo en el select de los codigos presupuestarios 
function RevisaPresupuestoMes(mes_presu, nombre) {
ind	= extrae_indice(nombre);
cod_pre	=	document.datos.elements["presupuesto["+ind+"][cod_pre]"].value;
// recorriendo el arreglo
	for (x=0;x<arr_presupuesto.length;x++){
		
		if((arr_presupuesto[x]["cod_pre"]==cod_pre)&&(arr_presupuesto[x]["mes_presu"]==mes_presu)){
			document.datos.elements["busqueda["+ind+"][saldo]"].value = arr_presupuesto[x]["saldo"];
			document.datos.elements["presupuesto["+ind+"][psol_mpresupuesto]"].value=0;
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
   form = document.datos;
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
			mes_presu	=	document.datos.elements["busqueda["+ind+"][mes_ccod]"].value;
			v_cod_pre	=	comp.options[form.elements["presupuesto["+ind+"][cod_pre]"].selectedIndex].value;
			document.datos.elements["busqueda["+ind+"][saldo]"].value=ObtienePresupuesto(v_cod_pre, mes_presu);
   		}
	     num += 1;
	  }
}

// Valida que tenga presupuesto disponible para el codigo presupuestario seleccionado
function TienePresupuesto(indice){
	var formulario = document.forms["datos"];

	v_valor	    =	formulario.elements["presupuesto["+indice+"][psol_mpresupuesto]"].value;
	v_saldo	    =	formulario.elements["busqueda["+indice+"][saldo]"].value;
	v_cod_pre	=	formulario.elements["presupuesto["+indice+"][cod_pre]"].options[formulario.elements["presupuesto["+indice+"][cod_pre]"].selectedIndex].text;
//document.myform.opttwo.options[document.myform.opttwo.selectedIndex].text;
	if (parseInt(v_valor)>=parseInt(v_saldo)){
		alert("El saldo de presupuesto para el codigo "+v_cod_pre+" es inferior al monto que intenta adjudicar");
		formulario.elements["presupuesto["+indice+"][psol_mpresupuesto]"].value=0;
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

var miArray = new Array()
function valida_numero(valor,num)
{

//alert(valor);
//alert(num);

//pers_nrut		=	datos.elements["datos[0][pers_nrut]"].value;
tdoc_ccod		=	datos.elements["detalle["+num+"][tdoc_ccod]"].value;

//alert(tdoc_ccod);

	if ( (tdoc_ccod==3) || (tdoc_ccod==10) || (tdoc_ccod==2) || (tdoc_ccod==9) )
	{
		miArray[num]=valor
	}
	else
	{
		miArray[num]=""
	}
	
	if ( (tdoc_ccod==3) || (tdoc_ccod==10) || (tdoc_ccod==2) || (tdoc_ccod==9) )
	{

		for (i=0;i<num;i++)
		{
			caso1=miArray[i]
				if ( (caso1==valor) && (caso1!="") )
				{
					alert("No puede ingresar el mismo número de Factura");
					datos.elements["detalle["+num+"][drga_ndocto]"].value="";
				}
		} 
	}
}

function calcular(){
	
	prueba = document.datos.elements["detalle[0][numero]"].value;
	num_cantidad = prueba-1;	
}

function Mensaje()
{
	<% 
		if session("mensaje_error")<>"" then
	%>
		alert("<%=session("mensaje_error")%>");
	<%
		session("mensaje_error")=""
		end if
	%>
}

function Enviar(){
	//validar campos vacios
	formulario = document.datos;
	v_valor			= formulario.elements["datos[0][rgas_mgiro]"].value; // SOLICITUD DE GIRO
	v_presupuesto	= formulario.total_presupuesto.value;	// PRESUPUESTO
	v_detalle		= formulario.total_detalle.value;		// DETALLE GASTO

	if((v_valor==v_presupuesto)&&(v_valor==v_detalle)){
		return true;
	}else{
		alert("El monto de la Solicitud de Reembolso ingresado debe coincidir con el total del presupuesto y el detalle de documentos");
		return false;
	}	
}

function ImprimirReembolsoGastos(){
	url="imprimir_rg.asp?rgas_ncorr=<%=v_rgas_ncorr%>";
	window.open(url,'ImpresionRG', 'scrollbars=yes, menubar=no, resizable=yes, width=700,height=700');	
}

function genera_digito (rut){
 var IgStringVerificador, IgN, IgSuma, IgDigito, IgDigitoVerificador, rut;
 var texto_rut = new String(rut);
 var posicion_guion = 0;
 v_area		=	datos.elements["busqueda[0][area_ccod]"].value;
 posicion_guion = texto_rut.indexOf("-");
 if (posicion_guion != -1)
 {
    texto_rut = texto_rut.substring(0,posicion_guion);
    document.datos.elements["datos[0][pers_nrut]"].value= texto_rut;
	rut = texto_rut;
 }
// texto_rut.
 //alert(texto_rut);
   if (rut.length==7) rut = '0' + rut; 
	
	   IgStringVerificador = '32765432';
	   IgSuma = 0;
	   for( IgN = 0; IgN < 8 && IgN < rut.length; IgN++)
		  	IgSuma = eval(IgSuma + '+' + rut.substr(IgN, 1) + '*' + IgStringVerificador.substr(IgN, 1) + ';');
	   		IgDigito = 11 - IgSuma % 11;
	   		IgDigitoVerificador = IgDigito==10?'K':IgDigito==11?'0':IgDigito;
	   //alert(IgDigitoVerificador);
			datos.elements["datos[0][pers_xdv]"].value=IgDigitoVerificador;
			document.datos.action= "reembolso_gastos.asp?rut="+texto_rut+"&dv="+IgDigitoVerificador+"&area_ccod="+v_area+"&Item="+prueba;
			document.datos.method = "post";
			document.datos.submit();
}

function CalculaTotal(){
	var formulario = document.forms["datos"];
	v_total_solicitud = 0;
	for (var i = 0; i <= num_cantidad; i++) {
	//alert("eeeeeeeeee");
		v_monto		=	formulario.elements["detalle["+i+"][drga_mdocto]"].value;
		v_retencion	=	formulario.elements["detalle["+i+"][drga_mretencion]"].value;
		if (!v_monto){
			v_monto=0;
			formulario.elements["detalle["+i+"][drga_mdocto]"].value=0;
		}
		if (!v_retencion){
			v_retencion=0;
			formulario.elements["detalle["+i+"][drga_mretencion]"].value=0;
		}
		v_neto		=	eval(parseInt(v_monto) + parseInt(v_retencion));
		//alert(formulario.elements["detalle["+i+"][dorc_nprecio_neto]"].value);
		if (v_neto){
			v_total_solicitud = v_total_solicitud + parseInt(v_neto);
		}
	}
	
	formulario.total_detalle.value	=	eval(v_total_solicitud);
}
/*****************************************************************************/
//******* SEGUNDA TABLA DINAMICA   *********//
<%if cint(f_presupuesto.nrofilas) >1 then%>
var contador=<%=f_presupuesto.nrofilas-1%>;
<%else%>
var contador=0;
<%end if%>

<%f_cod_pre.primero
f_cod_pre.Siguiente%>
valor_saldo=ObtienePresupuesto('<%=f_cod_pre.obtenerValor("cod_pre")%>');

function validaFila2(id, nro,boton){
	if (document.datos.elements["presupuesto["+nro+"][psol_mpresupuesto]"].value >0){ 
		addRow2(id, nro, boton );habilitaUltimoBoton2(); 
	}else{
		alert('Debe ingresar todos los campos del presupuesto que usará');
		return false;
	}
}

function addRow2(id, nro, boton ){
contador++;

$("#tb_presupuesto").append("<tr><td align=\"left\"><INPUT TYPE=\"checkbox\" align=\"center\" name=\"presupuesto["+ contador +"][check]\" value=\""+ contador +"\"  ></td>"+
"<td><select name= \"presupuesto["+ contador +"][cod_pre]\" onChange=\"RevisaPresupuesto(this.value,this.name);\">"+
"<%f_cod_pre.primero%> "+
"<%while f_cod_pre.Siguiente %>"+
"<option value=\"<%=f_cod_pre.ObtenerValor("cod_pre")%>\" ><%=f_cod_pre.ObtenerValor("valor")%></option>"+
"<%wend%>"+
"</select></td>"+

"<td><select name= \"busqueda["+ contador +"][mes_ccod]\" onChange=\"Cargar_codigos(this.form, this.value, " +contador+ "); RevisaPresupuestoMes(this.value,this.name);\">"+
"<%f_anos.primero%>"+
"	<%while f_anos.Siguiente %>"+
"<option value=\"<%=f_anos.ObtenerValor("mes_ccod")%>\" ><%=f_anos.ObtenerValor("mes_tdesc")%></option>"+
"<%wend%>"+
"</select></td>"+
"<td>"+ 
"<%f_anos.primero%>"+
"<%f_anos.Siguiente%>"+
"<input type=\"text\" name=\"busqueda["+ contador +"][anos_ccod]\" value=\"<%=f_anos.ObtenerValor("anos_ccod")%>\" >"+
"</td>"+
"<td><INPUT TYPE=\"text\" name=\"presupuesto["+ contador +"][psol_mpresupuesto]\" size=\"10\" value=0 onblur=\"SumaTotalPresupuesto(this);\" ></td>"+
"<td><INPUT TYPE=\"text\" class=\"Mimetismo\" name=\"busqueda["+ contador +"][saldo]\" size=\"10\" value="+valor_saldo+" readonly ></td>"+
"<td><INPUT class=boton TYPE=\"button\" name=\"agregarlinea2\" value=\"+\" onclick=\"validaFila2('tb_presupuesto',"+contador+",this)\">&nbsp;"+
"<INPUT class=boton TYPE=\"button\" name=\"quitarlinea2\" value=\"-\" onclick=\"eliminaFilas2()\"></td></tr>");
//desabilitarUltimoBoton();

document.datos.elements["contador"].value = contador;
}

function eliminaFilas2()
{
	//contador--;
//var check=document.datos.getElementsByTagName('input');
var objetos=document.datos.getElementsByTagName('input');
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
   /* if (tabla2.tBodies[0].rows.length < 2){
		addRow2('tb_presupuesto', cantidadCheck, 0 );
	}*/
	habilitaUltimoBoton2();
}

function habilitaUltimoBoton2(){
var objetos2=document.datos.getElementsByTagName('input');
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
	
	var tr2 = node.parentNode;
	while (tr2.tagName.toLowerCase() != "tr")
	tr2 = tr2.parentNode;
	tr2.parentNode.removeChild(tr2);
	
	//desabilitarUltimoBoton();
	habilitaUltimoBoton2();
	//contador--;
}

function SumaTotalPresupuesto(valor){
	
	var formulario = document.forms["datos"];
	v_total_presupuesto = 0;
	v_indice=extrae_indice(valor.name);
	
	TienePresupuesto(v_indice);
	
	for (var i = 0; i <= contador; i++) {
		if(formulario.elements["presupuesto["+i+"][psol_mpresupuesto]"]){
			v_valor	=	formulario.elements["presupuesto["+i+"][psol_mpresupuesto]"].value;
		//alert(formulario.elements["detalle["+i+"][dorc_nprecio_neto]"].value);
			if (v_valor){
				v_total_presupuesto = v_total_presupuesto + parseInt(v_valor);
			}
		}
	}
	datos.elements["total_presupuesto"].value=v_total_presupuesto;
}


//******* FIN SEGUNDA TABLA DINAMICA *******//
/*****************************************************************************/


function GuardarEnviar(){
	formulario = document.datos;
	v_valor			= formulario.elements["datos[0][rgas_mgiro]"].value; // SOLICITUD DE GIRO
	v_presupuesto	= formulario.total_presupuesto.value;	// PRESUPUESTO
	v_detalle		= formulario.total_detalle.value;		// DETALLE GASTO

	if((v_valor==v_presupuesto)&&(v_valor==v_detalle)){
		email();
		return true;
	}else{
		alert("El monto de la Solicitud de Reembolso ingresado debe coincidir con el total del presupuesto y el detalle de documentos");
		return false;
	}	
}

function email(){
	var f = new Date(); 
	miFecha =(f.getDate() + "/" + (f.getMonth() +1) + "/" + f.getFullYear());	
	//email=prompt('Ingrese Correo electronico Jefe Directo:  (Ejemplo: jefe@upacifico.cl)','');
	
		//-----------Carga email de Responsable desde BD, condiciona si el correo es el correcto, si no da opción de ingreso. Rpavez 06/05/2014	
	if (document.datos.elements["email"].value.length<5) {
		email=prompt('Ingrese Correo electronico Jefe Directo:  (Ejemplo: jefe@upacifico.cl)','');
	}
	else{
		if (confirm("Se enviara un correo a: " + document.datos.elements["email"].value)){
			email=document.datos.elements["email"].value;
		}
		else{
			email=prompt('Ingrese Correo electronico Jefe Directo:  (Ejemplo: jefe@upacifico.cl)','');
		}
	}
//-------------------------------------	
	var re  = /^([a-zA-Z0-9_.-])+@((upacifico)+.)+(cl)+$/; 
	if (!re.test(email)) { 
		alert ("Dirección de email inválida"); 
		return false; 
	} 
	
	
	if((email != "")&&(email != null)){
	window.open("http://admision.upacifico.cl/postulacion/www/proc_envio_solicitud_giro.php?nombre=<%=nombre_solicitante%>&solicitud=<%=tipo_soli%>&n_soli=<%=n_soli%>&fecha="+miFecha+"&correo="+email)
	return false;
	//return true;
	}else{
		alert("Debe Ingresar un Correo Electronico.")
		return false;	
	}
}

//8888888888888888888888888888888888888888888888888888888888888888888888888

function CambiaValor(obj,indice){

	var formulario = document.forms["datos"];
	v_valor=obj.value;
	//alert(v_valor);
	//alert(indice);
	
	indice		=	extrae_indice(obj.name);
	
	//alert(indice);
	
	v_area	=	<%=area_ccod%>;
	//alert(v_area);
	v_item	=	<%=item%>;
	//alert(v_item);
		
	if ((v_valor==1)||(v_valor==11)){
		//BOLETAS
		
		formulario.elements["detalle["+indice+"][drga_mafecto]"].value="";
		formulario.elements["detalle["+indice+"][drga_miva]"].value="";
		formulario.elements["detalle["+indice+"][drga_mexento]"].value=0;
		
		formulario.elements["detalle["+indice+"][drga_mafecto]"].disabled=true;
		formulario.elements["detalle["+indice+"][drga_miva]"].disabled=true;
		formulario.elements["detalle["+indice+"][drga_mexento]"].disabled=true;
		
		formulario.elements["detalle["+indice+"][drga_mhonorarios]"].value="";
		formulario.elements["detalle["+indice+"][drga_mretencion]"].value="";
		formulario.elements["detalle["+indice+"][drga_mdocto]"].value="";
		
		formulario.elements["detalle["+indice+"][drga_mhonorarios]"].disabled=false;
		formulario.elements["detalle["+indice+"][drga_mretencion]"].disabled=false;
		formulario.elements["detalle["+indice+"][drga_mdocto]"].disabled=false;

		formulario.elements["detalle["+indice+"][drga_bboleta_honorario]"].value=1;
		
	}else{
		//FACTURAS
		formulario.elements["detalle["+indice+"][drga_mafecto]"].value="";
		formulario.elements["detalle["+indice+"][drga_miva]"].value="";
		formulario.elements["detalle["+indice+"][drga_mexento]"].value=0;
		
		formulario.elements["detalle["+indice+"][drga_mafecto]"].disabled=false;
		formulario.elements["detalle["+indice+"][drga_miva]"].disabled=false;
		formulario.elements["detalle["+indice+"][drga_mexento]"].disabled=false;
		
		formulario.elements["detalle["+indice+"][drga_mhonorarios]"].value="";
		formulario.elements["detalle["+indice+"][drga_mretencion]"].value="";
		formulario.elements["detalle["+indice+"][drga_mdocto]"].value="";

		formulario.elements["detalle["+indice+"][drga_mhonorarios]"].disabled=true;
		formulario.elements["detalle["+indice+"][drga_mretencion]"].disabled=true;
		formulario.elements["detalle["+indice+"][drga_mdocto]"].disabled=false;
		
		formulario.elements["detalle["+indice+"][drga_bboleta_honorario]"].value=2;
		
	}
	
}

//8888888888888888888888888888888888888888888888888888888888888888888888888

function CambiaValor_02(value,indice){

	var formulario = document.forms["datos"];
	//alert(value);
	//alert(indice);
	
	v_area	=	<%=area_ccod%>;
	//alert(v_area);
	v_item	=	<%=item%>;
	//alert(v_item);
	
	if ((value==1)||(value==11)){
		//BOLETAS

		formulario.elements["detalle["+indice+"][drga_mafecto]"].value="";
		formulario.elements["detalle["+indice+"][drga_miva]"].value="";
		formulario.elements["detalle["+indice+"][drga_mexento]"].value=0;
		
		formulario.elements["detalle["+indice+"][drga_mafecto]"].disabled=true;
		formulario.elements["detalle["+indice+"][drga_miva]"].disabled=true;
		formulario.elements["detalle["+indice+"][drga_mexento]"].disabled=true;
		
		formulario.elements["detalle["+indice+"][drga_mhonorarios]"].value="";
		formulario.elements["detalle["+indice+"][drga_mretencion]"].value="";
		formulario.elements["detalle["+indice+"][drga_mdocto]"].value="";

		formulario.elements["detalle["+indice+"][drga_mhonorarios]"].disabled=false;
		formulario.elements["detalle["+indice+"][drga_mretencion]"].disabled=false;
		formulario.elements["detalle["+indice+"][drga_mdocto]"].disabled=false;

		formulario.elements["detalle["+indice+"][drga_bboleta_honorario]"].value=1;
	}else{
		//FACTURAS
		formulario.elements["detalle["+indice+"][drga_mafecto]"].value="";
		formulario.elements["detalle["+indice+"][drga_miva]"].value="";
		formulario.elements["detalle["+indice+"][drga_mexento]"].value=0;
		
		formulario.elements["detalle["+indice+"][drga_mafecto]"].disabled=false;
		formulario.elements["detalle["+indice+"][drga_miva]"].disabled=false;
		formulario.elements["detalle["+indice+"][drga_mexento]"].disabled=false;

		formulario.elements["detalle["+indice+"][drga_mhonorarios]"].value="";
		formulario.elements["detalle["+indice+"][drga_mretencion]"].value="";
		formulario.elements["detalle["+indice+"][drga_mdocto]"].value="";
		
		formulario.elements["detalle["+indice+"][drga_mhonorarios]"].disabled=true;
		formulario.elements["detalle["+indice+"][drga_mretencion]"].disabled=true;
		formulario.elements["detalle["+indice+"][drga_mdocto]"].disabled=false;
		
		formulario.elements["detalle["+indice+"][drga_bboleta_honorario]"].value=2;
	}	
	
}

//8888888888888888888888888888888888888888888888888888888888888888888888888

function ConviertePesos_Factura(objeto){
	var formulario = document.forms["datos"];
	indice		=	extrae_indice(objeto.name);

		v_exento	=	formulario.elements["detalle["+indice+"][drga_mexento]"].value;
		v_afecto	=	formulario.elements["detalle["+indice+"][drga_mafecto]"].value;

		formulario.elements["detalle["+indice+"][drga_mhonorarios]"].value=0;

		if(v_afecto){
			v_iva	=	eval(Math.round(v_afecto*1.19)-parseInt(v_afecto));
		}else{
			v_iva	= 0
		}
		
		formulario.elements["detalle["+indice+"][drga_miva]"].value=v_iva
		v_valor		= 	parseInt(v_iva)+parseInt(v_exento)+parseInt(v_afecto);
		
		formulario.elements["detalle["+indice+"][drga_mdocto]"].value=v_valor

}

//8888888888888888888888888888888888888888888888888888888888888888888888888

function ConviertePesos_Boleta(objeto){
	var formulario = document.forms["datos"];
	indice		=	extrae_indice(objeto.name);

		v_honorarios=	formulario.elements["detalle["+indice+"][drga_mhonorarios]"].value;
		v_mretencion	=	eval(Math.round(v_honorarios*1.10)-v_honorarios);
		formulario.elements["detalle["+indice+"][drga_mexento]"].value=0;
		formulario.elements["detalle["+indice+"][drga_mafecto]"].value=0;
		formulario.elements["detalle["+indice+"][drga_mretencion]"].value=v_mretencion;
		v_valor		= 	parseInt(v_honorarios)-parseInt(v_mretencion);
		formulario.elements["detalle["+indice+"][drga_mdocto]"].value=v_valor

}

//8888888888888888888888888888888888888888888888888888888888888888888888888

function ConviertePesos_Factura_02(indice){
	var formulario = document.forms["datos"];
	//indice		=	extrae_indice(objeto.name);

		v_exento	=	formulario.elements["detalle["+indice+"][drga_mexento]"].value;
		v_afecto	=	formulario.elements["detalle["+indice+"][drga_mafecto]"].value;

		formulario.elements["detalle["+indice+"][drga_mhonorarios]"].value=0;

		if(v_afecto){
			v_iva	=	eval(Math.round(v_afecto*1.19)-parseInt(v_afecto));
		}else{
			v_iva	= 0
		}
		
		formulario.elements["detalle["+indice+"][drga_miva]"].value=v_iva
		v_valor		= 	parseInt(v_iva)+parseInt(v_exento)+parseInt(v_afecto);
		
		formulario.elements["detalle["+indice+"][drga_mdocto]"].value=v_valor

}

//8888888888888888888888888888888888888888888888888888888888888888888888888

function ConviertePesos_Boleta_02(indice){
	var formulario = document.forms["datos"];
	//indice		=	extrae_indice(objeto.name);

		v_honorarios=	formulario.elements["detalle["+indice+"][drga_mhonorarios]"].value;
		v_mretencion	=	eval(Math.round(v_honorarios*1.10)-v_honorarios);
		formulario.elements["detalle["+indice+"][drga_mexento]"].value=0;
		formulario.elements["detalle["+indice+"][drga_mafecto]"].value=0;
		formulario.elements["detalle["+indice+"][drga_mretencion]"].value=v_mretencion;
		v_valor		= 	parseInt(v_honorarios)-parseInt(v_mretencion);
		formulario.elements["detalle["+indice+"][drga_mdocto]"].value=v_valor

}

//8888888888888888888888888888888888888888888888888888888888888888888888888

function SumaTotalGiro_20140924(valor){
	
	var formulario = document.forms["datos"];
	v_total_doctos = 0;
	for (var i = 0; i <= contador3; i++) {
		if(formulario.elements["detalle["+i+"][drga_mdocto]"]){
			v_valor	=	formulario.elements["detalle["+i+"][drga_mdocto]"].value;
			//alert(formulario.elements["detalle["+i+"][dorc_nprecio_neto]"].value);
			if (v_valor){
				v_total_doctos = v_total_doctos + parseInt(v_valor);
			}
		}
	}
	//datos.elements["total_doctos"].value=v_total_doctos;
	//formulario.total_detalle.value=v_total_doctos;
	//formulario.elements["total_detalle"].value=v_total_doctos;
}

function SumaTotalGiro(valor){
	var formulario = document.forms["datos"];
	v_total_solicitud = 0;
	for (var i = 0; i <= num_cantidad; i++) {
	//alert("eeeeeeeeee");
		v_monto		=	formulario.elements["detalle["+i+"][drga_mdocto]"].value;
		v_retencion	=	formulario.elements["detalle["+i+"][drga_mretencion]"].value;
		if (!v_monto){
			v_monto=0;
			formulario.elements["detalle["+i+"][drga_mdocto]"].value=0;
		}
		if (!v_retencion){
			v_retencion=0;
			formulario.elements["detalle["+i+"][drga_mretencion]"].value=0;
		}
		v_neto		=	eval(parseInt(v_monto) + parseInt(v_retencion));
		//alert(formulario.elements["detalle["+i+"][dorc_nprecio_neto]"].value);
		if (v_neto){
			v_total_solicitud = v_total_solicitud + parseInt(v_neto);
		}
	}
	
	formulario.total_detalle.value	=	eval(v_total_solicitud);
}

</script>
</head>

<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="RecorrePresupuesto();calcular();Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="calcular();"onClick="calcular();">

	<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
			<td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
		</tr>
			<%pagina.DibujarEncabezado()%>  
		<tr>
			<td valign="top" bgcolor="#EAEAEA">
				<br>
		
				<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
					<tr>
						<td>
							<table border="0" cellpadding="0" cellspacing="0" width="100%">
								<!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
								<tr>
									<td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
									<td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
									<td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
								</tr>
								<tr>
									<td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
									<td background="../imagenes/top_r1_c2.gif"></td>
									<td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
								</tr>
								<tr>
									<td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
									<td>
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
												<td width="209" valign="middle" background="../imagenes/fondo1.gif">
													<div align="left">
														<font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Reembolso de Gastos </font>
													</div>
												</td>
												<td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
											</tr>
										</table>
									</td>
									<td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
								</tr>
								<tr>
									<td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
									<td background="../imagenes/top_r3_c2.gif"></td>
									<td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
								</tr>
							</table>
							
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
									<td bgcolor="#D8D8DE">
										<br>
										<div align="center">
											<font size="+1"><%pagina.DibujarTituloPagina()%></font>
											
										</div>
										<% if vibo_ccod="10" then %>
					<p style="font-size:12px; color=#FF0000"><strong>OBSERVACI&Oacute;N.- <%=ordc_tobservacion%></strong></p>
					<% else
						response.write "<br>"
					end if %>
                                        <div align="left"><strong>* Ingrese la cantidad de detalles de gastos antes de completar mas datos.</strong></div>

			<!-- INICIO TABLA CONTENEDORA -->
			
			
			
							
										<table width="100%" align="center" cellpadding="0" cellspacing="0">	
												  <tr> 
													<td>
													<form name="datos" method="post" />
													<%f_busqueda.dibujaCampo("rgas_ncorr")%>
													<input type="hidden" name="datos[0][tsol_ccod]" value="2">	
													<input type="hidden" name="busqueda[0][area_ccod]" value="<%=area_ccod%>" />
                                                    <input type="hidden" name="contador" value="0"/>				
													  <table width="100%" border="1">

														  <tr> 
															<td width="6%">Rut funcionario </td>
															<td width="38%"> <%f_busqueda.dibujaCampo("pers_nrut")%>-<%f_busqueda.dibujaCampo("pers_xdv")%></td>
															<td width="10%"><!--Boleta Honorarios--></td>
															<td><%'f_busqueda.dibujaCampo("ordc_bboleta_honorario")
															%></td>
														  </tr>
														  <tr> 
															<td> Nombre funcionario </td>
															<td> 
															<%
															f_busqueda.dibujaCampo("pers_tnombre")
															'f_busqueda.dibujaCampo("v_nombre")
															%></td>
															<td>Tipo moneda</td>
															<td><%f_busqueda.dibujaCampo("tmon_ccod")%></td>
														  </tr>
														  <tr> 
															<td>Monto girar </td>
															<td> <%f_busqueda.dibujaCampo("rgas_mgiro")%></td>
															<td>Total Presupuesto </td>
															<td><input type="text" style="background-color:#D8D8DE;border: 1px #D8D8DE solid; font-size:10px; font-style:oblique; font:bold; "  name="total_presupuesto" value="<%=v_suma_presupuesto%>" size="12" id='total_presupuesto' readonly/></td>
														  </tr>
														  <tr>
															<td colspan="4">
																	<h5>Detalle presupuesto</h5>					
																	<table width="100%" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' id='tb_presupuesto'>
																		<tr bgcolor='#C4D7FF' bordercolor='#999999'>
																			<th width="6%">N°</th>
																			<th width="38%">Cod. Presupuesto</th>
																			<th width="10%">Mes</th>
																			<th width="37%">Año</th>
																			<th width="3%">Valor</th>
                                                                            <th width="4%">Saldo presu</th>
																			<th width="2%">(+/-)</th>
																		</tr>
																		<%
																				ind=0
																				f_presupuesto.primero
																				while f_presupuesto.Siguiente 
																				v_cod_pre=f_presupuesto.ObtenerValor("cod_pre")
																				%>
																				<tr align="left">
																					<th><input type="checkbox"  align="left" name="presupuesto[<%=ind%>][checkbox]" value=""></th>
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
																						</select>										</td>
<!--  888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888 -->
																					<td>
																					<%
																					'f_presupuesto.DibujaCampo("mes_ccod")
																					
																					' JAIME PAINEMAL 20130909

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
																					
<!--  888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888 -->	
																					<td><%f_presupuesto.DibujaCampo("psol_mpresupuesto")%> </td>																				
<!--  888888 ** EN LA SIGUIENTE LINEA VA EL SALDO DEL PRESUPUESTO ** 88888888888888888888888888 -->	
																					<td><input type="text" class="Mimetismo" name="busqueda[<%=ind%>][saldo]" size="8" value="" readonly ></td>
																					<td><INPUT alt="agregar fila" class=boton TYPE="button" name="agregarlinea2" value="+" onClick="validaFila2('tb_presupuesto','<%=ind%>',this);">&nbsp;<INPUT alt="quitar una fila existente" class="boton" TYPE="button" name="quitarlinea2" value="-" onClick="eliminaFilas2()">	</td>
																				</tr>	
																				<%
																				ind=ind+1
																				wend %>
                                                                                
																	</table>										
														  </td>
                                                          </tr>
														</table>
													<br>
													
															<table width="100%" border="0">
																<tr> 
																  <td><hr></td>
																</tr>
																<tr>
																	<td>
																	
																	<!-- 88888888888888888888888888888888888888888888 -->

																		<table border ="1" align="center" width="100%">
																				<tr valign="top">
																					<td width="100%" >
																					
																					<p>
																					  <!-- INICIO TABLA DOCUMENTOS -->
																					 
                                                                                      <table width="22%" >
																					  <tr>
                                                                                   		<td width="60%">
                                                                                            	 <B>Detalle Gasto</B>
                                                                                            </td>
                                                                                      		<td width="40%">
                                                                                            <select name="detalle[0][numero]" onChange=location.href="reembolso_gastos.asp?rut=<%=v_usuario%>&area_ccod=<%=area_ccod%>&Item="+this.value>
                                                                                            <option value="5" <%=selected5%>>5</option>
                                                                                            <option value="10" <%=selected10%>>10</option>
                                                                                            <option value="15" <%=selected15%>>15</option>
                                                                                            </select>
                                                                                            </td>
                                                                                        </tr>   
                                                                                      </table>	
                            														<table class="v1" border='2' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0'> 
																					
																						<tr bgcolor='#C4D7FF' bordercolor='#999999'>
																							
																							<th width="10%">Tipo Docto</th>
																							<th width="10%">Fecha Docto</th>
																							<th width="10%">N&deg; Docto</th>
																							<th width="10%">Tipo Gasto</th>
																							<th width="10%">Descripcion Gasto</th>
																							<th width="10%">C. Costo</th>
																							
																							<th width="10%">Neto</th>
																							<th width="10%">Iva</th>
																							<th width="10%">Exento</th>
																							<th width="10%">Honorarios</th>
																							<th width="10%">Retencion</th>

																							<th width="10%">Líquido</th>
																							
																					  </tr>

																						<%
																								ind=0
																								v_total=0
																								v_retencion=0
																								v_bruto=0

																								if f_detalle.nrofilas >=1 and prueba > 0 then
																								indi=0
																								
																								while f_detalle.Siguiente 
																						%>
																						
																						<tr>
																						
																							<td width="10%"><%f_detalle.DibujaCampo("tdoc_ccod")%></td>
																							<td width="10%"><%f_detalle.DibujaCampo("drga_fdocto")%></td>
																							<td width="10%"><%f_detalle.DibujaCampo("drga_ndocto")%></td>
																							<td width="10%"><%f_detalle.DibujaCampo("tgas_ccod")%></td>
																							<td width="10%"><%f_detalle.DibujaCampo("drga_tdescripcion")%></td>
																							<td width="10%">	
																							<%

																							valor_1=f_detalle.ObtenerValor("ccos_ncorr")
																							
																							%>
																									<select name="detalle[<%=indi%>][ccos_ncorr]">
																									<%
																									f_centro_costo.primero
																									while f_centro_costo.Siguiente 
																									
																									valor_2=f_centro_costo.ObtenerValor("ccos_ncorr")
																										if trim(valor_1) <> trim(valor_2) then
																										%>
																											<option value="<%=f_centro_costo.ObtenerValor("ccos_ncorr")%>" ><%=f_centro_costo.ObtenerValor("ccos_tcompuesto")%></option>
																										<%
																										else
																											if trim(valor_1) = trim(valor_2) then
																										%>
																											<option value="<%=f_centro_costo.ObtenerValor("ccos_ncorr")%>" selected><%=f_centro_costo.ObtenerValor("ccos_tcompuesto")%></option>
																										<%
																											end if
																										end if																								
																									wend
																									%>
																									</select>
																							<%
																							'indi=indi+1

																							%>
																							</td>
																							<%
																							V_BOLETA=f_detalle.ObtenerValor("drga_bboleta_honorario")
																							'RESPONSE.WRITE(V_BOLETA)
																							if cstr(V_BOLETA)=cstr(0) then
																							'NUEVO FORMULARIO
																							%>
																							<td width="10%"><%f_detalle.DibujaCampo("drga_mafecto")%> </td>	
																							<td width="10%"><%f_detalle.DibujaCampo("drga_miva")%> </td>																				
																							<td width="10%"><%f_detalle.DibujaCampo("drga_mexento")%> </td>	
																							<td width="10%"><%f_detalle.DibujaCampo("drga_mhonorarios")%> </td>		

																							<td width="10%"><%f_detalle.DibujaCampo("drga_mretencion")%> </td>	
																							<td width="10%"><%f_detalle.DibujaCampo("drga_mdocto")%> 
																							<input type="hidden" name="detalle[<%=indi%>][drga_bboleta_honorario]" value=<%=f_detalle.ObtenerValor("drga_bboleta_honorario")%> size="1"  id="NU-S"/>
																							
																							<%
																							else
																							
																									if cstr(V_BOLETA)=cstr(1) then
																									' BOLETA
																									
																									f_detalle.AgregaCampoParam "drga_mafecto", "deshabilitado", "true"
																									f_detalle.AgregaCampoParam "drga_miva", "deshabilitado", "true"
																									f_detalle.AgregaCampoParam "drga_mexento", "deshabilitado", "true"

																									f_detalle.AgregaCampoParam "drga_mhonorarios", "deshabilitado", "false"
																									f_detalle.AgregaCampoParam "drga_mretencion", "deshabilitado", "false"
																									
																									%>
																							
																									<td width="10%"><%f_detalle.DibujaCampo("drga_mafecto")%> </td>	
																									<td width="10%"><%f_detalle.DibujaCampo("drga_miva")%> </td>																				
																									<td width="10%"><%f_detalle.DibujaCampo("drga_mexento")%> </td>	
																									<td width="10%"><%f_detalle.DibujaCampo("drga_mhonorarios")%> </td>		

																									<td width="10%"><%f_detalle.DibujaCampo("drga_mretencion")%> </td>	
																									<td width="10%"><%f_detalle.DibujaCampo("drga_mdocto")%> 
																									<input type="hidden" name="detalle[<%=indi%>][drga_bboleta_honorario]" value=<%=f_detalle.ObtenerValor("drga_bboleta_honorario")%>  size="1"  id="NU-S"/>
																									
																									<%
																									v_drga_mhonorarios=Clng(v_drga_mhonorarios) + Clng(f_detalle.ObtenerValor("drga_mhonorarios"))
																									'v_bruto=Clng(v_bruto) + Clng(f_detalle.ObtenerValor("drga_mdocto"))
																									'v_retencion=Clng(v_retencion) + Clng(f_detalle.ObtenerValor("drga_mretencion"))
																									
																									else
																									' FACTURA
																									f_detalle.AgregaCampoParam "drga_mafecto", "deshabilitado", "false"
																									f_detalle.AgregaCampoParam "drga_miva", "deshabilitado", "false"
																									f_detalle.AgregaCampoParam "drga_mexento", "deshabilitado", "false"
																									
																									f_detalle.AgregaCampoParam "drga_mhonorarios", "deshabilitado", "true"
																									f_detalle.AgregaCampoParam "drga_mretencion", "deshabilitado", "true"
																									
																									%>
																									
																									<td width="10%"><%f_detalle.DibujaCampo("drga_mafecto")%> </td>	
																									<td width="10%"><%f_detalle.DibujaCampo("drga_miva")%> </td>																				
																									<td width="10%"><%f_detalle.DibujaCampo("drga_mexento")%> </td>	
																									<td width="10%"><%f_detalle.DibujaCampo("drga_mhonorarios")%> </td>		

																									<td width="10%"><%f_detalle.DibujaCampo("drga_mretencion")%> </td>	
																									<td width="10%"><%f_detalle.DibujaCampo("drga_mdocto")%> 
																									<input type="hidden" name="detalle[<%=indi%>][drga_bboleta_honorario]" value=<%=f_detalle.ObtenerValor("drga_bboleta_honorario")%>  size="1"  id="NU-S"/>

																									<%
																									
																									v_bruto=Clng(v_bruto) + Clng(f_detalle.ObtenerValor("drga_mdocto"))
																									'v_drga_miva=Clng(v_drga_miva) + Clng(f_detalle.ObtenerValor("drga_miva"))
																									
																									end if
																							
																							%>
																							
																							<%
																							end if
																							%>
																							
																							</td>		
																						</tr>
																						<%
																							'v_bruto=Clng(v_bruto) + Clng(f_detalle.ObtenerValor("drga_mdocto"))
																							'v_retencion=Clng(v_retencion) + Clng(f_detalle.ObtenerValor("drga_mretencion"))
																							indi=indi+1
																							ind=ind+1
																							wend
																							
																							'v_total=(v_bruto-v_retencion)+v_drga_miva
																							v_total=v_bruto+v_drga_mhonorarios
																							
																						end if

																						indice=ind
																						cont=0
																						%>
																						
																						<!-- 8888888888888888888888888888  FILAS DE ABAJO-->
																						
																						<%
																						while cont<= prueba
																						cont=cont+1
																						%>
																						<tr bgcolor='#FFFFFF'>
																						
																							<!-- Tipo Docto -->
																							<td>
																								<!--<select name="detalle[<%'=indice
																								%>][tdoc_ccod]"  id="TO-N">-->
																								
																								<select name="detalle[<%=indice%>][tdoc_ccod]"  id="TO-N" onChange="CambiaValor_02(this.value,<%=indice%>)" onBlur="CambiaValor_02(this.value,<%=indice%>)">
																								<%
																								f_tipo_docto.primero
																								while f_tipo_docto.Siguiente 
																								%>
																								<option value="<%=f_tipo_docto.ObtenerValor("tdoc_ccod")%>" ><%=f_tipo_docto.ObtenerValor("tdoc_tdesc")%></option>
																								<%
																								wend
																								%>
																								</select>
																							</td>

																							<td><input type="text" name="detalle[<%=indice%>][drga_fdocto]" value="" size="10" id="FE-S"/></td>
																							<td><input type="text" name="detalle[<%=indice%>][drga_ndocto]" value="" size="10" onBlur="valida_numero(this.value,<%=indice%>);"  id="NU-S"/></td>
																							
																							<!-- Tipo Gasto -->
																							<td>
																								<select name="detalle[<%=indice%>][tgas_ccod]"  id="TO-S">
																								<%
																								f_tipo_gasto.primero
																								while f_tipo_gasto.Siguiente 
																								%>
																								<option value="<%=f_tipo_gasto.ObtenerValor("tgas_ccod")%>" ><%=f_tipo_gasto.ObtenerValor("tgas_tdesc")%></option>
																								<%
																								wend
																								%>
																								</select>
																							</td>
																							
																							<td><input type="text" name="detalle[<%=indice%>][drga_tdescripcion]" value="" size="20" /></td>
																							
																							<!-- C. Costo -->
																							<td>
																								<select name="detalle[<%=indice%>][ccos_ncorr]"  id="TO-N">
																								<%
																								f_centro_costo.primero
																								while f_centro_costo.Siguiente 
																								%>
																								<option value="<%=f_centro_costo.ObtenerValor("ccos_ncorr")%>" ><%=f_centro_costo.ObtenerValor("ccos_tcompuesto")%></option>
																								<%
																								wend
																								%>
																								</select>
																							</td>
																							<td><input type="text" name="detalle[<%=indice%>][drga_mafecto]" value="" size="10"  id="NU-S" onBlur="ConviertePesos_Factura_02(<%=indice%>);SumaTotalGiro(this.value);" /></td>
																							<td><input type="text" name="detalle[<%=indice%>][drga_miva]" value="" size="10"  id="NU-S"/></td>
																							<td><input type="text" name="detalle[<%=indice%>][drga_mexento]" value="" size="10" id="NU-S" onBlur="ConviertePesos_Factura_02(<%=indice%>);SumaTotalGiro(this.value);" /></td>
																							<td><input type="text" name="detalle[<%=indice%>][drga_mhonorarios]" value="" size="10" id="NU-S" onBlur="ConviertePesos_Boleta_02(<%=indice%>);SumaTotalGiro(this.value);" /></td>
																							
																							<td><input type="text" name="detalle[<%=indice%>][drga_mretencion]" value="" size="10"  id="NU-S"/></td>
																							<td><input type="text" name="detalle[<%=indice%>][drga_mdocto]" value="" size="10" onBlur="CalculaTotal()"  id="NU-S"/>
																									<input type="hidden" name="detalle[<%=indice%>][drga_bboleta_honorario]" size="1"  id="NU-S"/>
																							</td>
																						</tr>
																						<%
																						indice=indice +1
																						wend
																						
																						<!-- 8888888888888888888888888888  FILAS DE ABAJO-->

																						%><!-- Fin While suplementario -->
																						<tr>
																							<td colspan="11" align="right"><strong>Total a Girar: &nbsp;</strong></td>
																							<td ><input type="text" name="total_detalle" value="<%=v_total%>" size="10" readonly/></td>
																						</tr>																																									
																					</table>			
																					
																					<!-- FIN TABLA DOCUMENTOS -->
																					
																				  </td>
																				</tr>
																				
																				<tr valign="top">
																					<td> 
																						<strong>V°B° Responsable:</strong>
																						<select name="busqueda[0][responsable]">
																						<%
																							f_responsable.primero
																							while f_responsable.Siguiente
																						%>
																						<option value="<%f_responsable.DibujaCampo("pers_nrut")%>"><%f_responsable.DibujaCampo("nombre")%></option>
																						<%
																						wend
																						%>
																						</select>
                                                                                        <input name="email" type="hidden" value="<%f_responsable.DibujaCampo("email")%>"/>	
																					</td>
																				</tr>
																		</table>

																		<!-- 88888888888888888888888888888888888888888888 -->

																  </td>
															    </tr>
															</table>
                                                            </td>
												  </tr>
										</table>
				
				
				
							
			<!-- FIN TABLA CONTENEDORA -->
										<br>
									</td>
									<td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
								</tr>
							</table>

							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
									<td width="240" bgcolor="#D8D8DE">
										<table width="49%" height="19"  border="0" align="center" cellpadding="0" cellspacing="0">
                                        <tr> <%
											
											if vibo_ccod="-1" OR vibo_ccod="0" OR vibo_ccod="10" OR vibo_ccod="12" then
												botonera.AgregaBotonParam "imprimir", "deshabilitado", "true"
											end if
											
											if vibo_ccod = "12" or vibo_ccod = "10" or vibo_ccod = "-1" then
												botonera.AgregaBotonParam "guardar", "deshabilitado", "false"
												botonera.AgregaBotonParam "guardarenviar", "deshabilitado", "false"
											elseif vibo_ccod>="0" or resul_nombre <> "1" then
												botonera.AgregaBotonParam "guardarenviar", "deshabilitado", "true"
												botonera.AgregaBotonParam "guardar", "deshabilitado", "true"
											end if
						
											%>
										  <td width="30%"><%botonera.dibujaboton "guardar"%> </td>
										  <td><%botonera.dibujaboton "guardarenviar"%></td>
										  <td><%botonera.dibujaboton "salir"%></td>
										  <td><%botonera.dibujaboton "imprimir"%></td>
                                        </tr>
                                      </table>
									</td>
									<td width="429" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
									<td width="10" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
							  </tr>
								<tr>
									<td height="8" valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
								</tr>
						  </table>
							<p>
							<br>
						</td>
					</tr>
				  </table>	
			</td>
		</tr>  

</body>

</html>
<script language="JavaScript">
var resul_nom='<%=resul_nombre%>'
if (resul_nom == "0") {
	alert("No existe el RUT en Softland.")	
}

document.datos.elements["contador"].value = contador;

</script>
