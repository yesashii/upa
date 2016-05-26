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
'FECHA ACTUALIZACION 	:26/06/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ORDEN DE COMPRA
'LINEA			:
'*******************************************************************
set pagina = new CPagina
pagina.Titulo = "Rendicion de Fondos a Rendir"

v_fren_ncorr	= request.querystring("cod_solicitud")
v_rfre_ncorr	= request.querystring("rfre_ncorr")

'RESPONSE.WRITE("v_fren_ncorr: "&v_fren_ncorr&"<BR>")
'RESPONSE.WRITE("v_rfre_ncorr: "&v_rfre_ncorr&"<BR>")

set botonera = new CFormulario
botonera.carga_parametros "rendicion_fondo_rendir.xml", "botonera"

set conectar = new cconexion
conectar.inicializar "upacifico"

set conexion = new CConexion2
conexion.Inicializar "upacifico"

set negocio = new cnegocio
negocio.Inicializa conectar

v_usuario=negocio.ObtenerUsuario()
v_anos_ccod	= conectar.consultaUno("select year(getdate())")

if v_rfre_ncorr="" or EsVacio(v_rfre_ncorr) then
	v_rfre_ncorr=conectar.consultaUno("select top 1 rfre_ncorr from ocag_rendicion_fondos_a_rendir where fren_ncorr="&v_fren_ncorr)

' 888888888888888888888888888888888888888888888888888888888888888888888888888888888888

	if v_rfre_ncorr<>"" then

	set f_busqueda2 = new CFormulario
	f_busqueda2.Carga_Parametros "rendicion_fondo_rendir.xml", "datos_solicitud_2"
	f_busqueda2.Inicializar conectar

	rendicion_fondos_rendir="select rfre_ncorr, ocag_baprueba, ocag_baprueba_rector, fren_ncorr, vibo_ccod from ocag_rendicion_fondos_a_rendir where rfre_ncorr="&v_rfre_ncorr
	
	f_busqueda2.Consultar rendicion_fondos_rendir
	f_busqueda2.Siguiente
						
	rfre_ncorr=f_busqueda2.obtenerValor("rfre_ncorr")		
	ocag_baprueba=f_busqueda2.obtenerValor("ocag_baprueba")	
	ocag_baprueba_rector=f_busqueda2.obtenerValor("ocag_baprueba_rector")		
	fren_ncorr=f_busqueda2.obtenerValor("fren_ncorr")	
	vibo_ccod=f_busqueda2.obtenerValor("vibo_ccod")			
	
	END IF

' 888888888888888888888888888888888888888888888888888888888888888888888888888888888888

end if

set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "rendicion_fondo_rendir.xml", "datos_solicitud"
f_busqueda.Inicializar conectar


	if  v_fren_ncorr<>"" then
	
'		sql_fondo_rendir	= " select protic.trunc(fren_fpago) as fren_fpago,protic.trunc(fren_factividad) as fren_factividad,* "&_
'						  " from ocag_fondos_a_rendir a, personas c "&_
'						  "	where a.pers_ncorr=c.pers_ncorr and a.fren_ncorr="&v_fren_ncorr

'		sql_fondo_rendir	= " select protic.trunc(a.fren_fpago) as fren_fpago, protic.trunc(a.fren_factividad) as fren_factividad "&_
'										", a.fren_ncorr, a.pers_ncorr, a.fren_mmonto, a.mes_ccod, a.anos_ccod, a.fren_tdescripcion_actividad, a.cod_pre "&_
'										", a.audi_tusuario, a.audi_fmodificacion, a.vibo_ccod, a.fren_frecepcion, a.fren_tobs_rechazo, a.tsol_ccod, a.area_ccod, a.tmon_ccod, a.pers_nrut_aut "&_
'										", a.ocag_fingreso, a.ocag_generador, a.ocag_frecepcion_presupuesto, a.ocag_responsable, a.ocag_baprueba, a.sede_ccod, a.ccos_ncorr "&_
'										", c.PERS_NCORR, c.TVIS_CCOD, c.SEXO_CCOD, c.TENS_CCOD, c.COLE_CCOD, c.ECIV_CCOD, c.PAIS_CCOD, c.PERS_BDOBLE_NACIONALIDAD, c.PERS_NRUT, c.PERS_XDV "&_
'										", c.PERS_TAPE_PATERNO, c.PERS_TAPE_MATERNO, c.PERS_TNOMBRE, c.PERS_FNACIMIENTO, c.CIUD_CCOD_NACIMIENTO, c.PERS_FDEFUNCION, c.PERS_TEMPRESA "&_
'										", c.PERS_TFONO_EMPRESA, c.PERS_TCARGO, c.PERS_TPROFESION, c.PERS_TFONO, c.PERS_TFAX, c.PERS_TCELULAR, c.PERS_TEMAIL, c.PERS_TPASAPORTE, c.PERS_FEMISION_PAS "&_
'										", c.PERS_FVENCIMIENTO_PAS, c.PERS_FTERMINO_VISA, c.PERS_NNOTA_ENS_MEDIA, c.PERS_TCOLE_EGRESO, c.PERS_NANO_EGR_MEDIA, c.PERS_TRAZON_SOCIAL, c.PERS_TGIRO "&_
'										", c.PERS_TEMAIL_INTERNO, c.NEDU_CCOD, c.IFAM_CCOD, c.ALAB_CCOD, c.ISAP_CCOD, c.FFAA_CCOD, c.PERS_TTIPO_ENSENANZA, c.PERS_TENFERMEDADES, c.PERS_TMEDICAMENTOS_ALERGIA "&_
'										", c.AUDI_TUSUARIO, c.AUDI_FMODIFICACION, c.ciud_nacimiento, c.regi_particular, c.ciud_particular, c.pers_bmorosidad, c.sicupadre_ccod, c.sitocup_ccod "&_
'										", c.tenfer_ccod, c.descrip_tenfer, c.trabaja, c.pers_temail2 "&_
'										", c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO as v_nombre "&_
'										"from ocag_fondos_a_rendir a "&_
'										"INNER JOIN personas c "&_
'										"ON a.pers_ncorr = c.pers_ncorr  "&_
'										"and a.fren_ncorr ="&v_fren_ncorr
										
		sql_fondo_rendir	= " select protic.trunc(a.fren_fpago) as fren_fpago, protic.trunc(a.fren_factividad) as fren_factividad "&_
										", a.fren_ncorr, a.pers_ncorr, a.fren_mmonto, a.mes_ccod, a.anos_ccod, a.fren_tdescripcion_actividad, a.cod_pre "&_
										", a.audi_tusuario, a.audi_fmodificacion, a.vibo_ccod, a.fren_frecepcion, a.fren_tobs_rechazo, a.tsol_ccod, a.area_ccod, a.tmon_ccod, a.pers_nrut_aut "&_
										", a.ocag_fingreso, a.ocag_generador, a.ocag_frecepcion_presupuesto, a.ocag_responsable, a.sede_ccod, a.ccos_ncorr "&_
										", c.PERS_NCORR, c.TVIS_CCOD, c.SEXO_CCOD, c.TENS_CCOD, c.COLE_CCOD, c.ECIV_CCOD, c.PAIS_CCOD, c.PERS_BDOBLE_NACIONALIDAD, c.PERS_NRUT, c.PERS_XDV "&_
										", c.PERS_TAPE_PATERNO, c.PERS_TAPE_MATERNO, c.PERS_FNACIMIENTO, c.CIUD_CCOD_NACIMIENTO, c.PERS_FDEFUNCION, c.PERS_TEMPRESA "&_
										" , LTRIM(RTRIM(c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO)) as v_nombre "&_
										" , LTRIM(RTRIM(c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO)) as PERS_TNOMBRE "&_	
										", c.PERS_TFONO_EMPRESA, c.PERS_TCARGO, c.PERS_TPROFESION, c.PERS_TFONO, c.PERS_TFAX, c.PERS_TCELULAR, c.PERS_TEMAIL, c.PERS_TPASAPORTE, c.PERS_FEMISION_PAS "&_
										", c.PERS_FVENCIMIENTO_PAS, c.PERS_FTERMINO_VISA, c.PERS_NNOTA_ENS_MEDIA, c.PERS_TCOLE_EGRESO, c.PERS_NANO_EGR_MEDIA, c.PERS_TRAZON_SOCIAL, c.PERS_TGIRO "&_
										", c.PERS_TEMAIL_INTERNO, c.NEDU_CCOD, c.IFAM_CCOD, c.ALAB_CCOD, c.ISAP_CCOD, c.FFAA_CCOD, c.PERS_TTIPO_ENSENANZA, c.PERS_TENFERMEDADES, c.PERS_TMEDICAMENTOS_ALERGIA "&_
										", c.AUDI_TUSUARIO, c.AUDI_FMODIFICACION, c.ciud_nacimiento, c.regi_particular, c.ciud_particular, c.pers_bmorosidad, c.sicupadre_ccod, c.sitocup_ccod "&_
										", c.tenfer_ccod, c.descrip_tenfer, c.trabaja, c.pers_temail2 "&_
										"from ocag_fondos_a_rendir a "&_
										"INNER JOIN personas c "&_
										"ON a.pers_ncorr = c.pers_ncorr  "&_
										"and a.fren_ncorr ="&v_fren_ncorr

		f_busqueda.Consultar sql_fondo_rendir
		f_busqueda.Siguiente
						
		area_ccod=f_busqueda.obtenerValor("area_ccod")		
		v_total_solicitado=Clng(f_busqueda.obtenerValor("fren_mmonto"))	
		
'8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
'888 INICIO

	pers_tnombre=f_busqueda.obtenerValor("pers_tnombre")

	'response.Write("pers_tnombre: "&pers_tnombre&"<BR>")	
	'response.Write("pers_tnombre_aut: "&pers_tnombre_aut&"<BR>")	
				
	'RUT funcionario
	pers_nrut_aut=f_busqueda.obtenerValor("pers_nrut_aut") 
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
											" from softland.cwtauxi where cast(CodAux as varchar)='"&pers_nrut_aut&"'"
		
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

	else
		sql_fondo_rendir	=	"select ''"
		f_busqueda.Consultar sql_fondo_rendir
		f_busqueda.Siguiente
		v_tiene_detalle=0
		v_rfre_ncorr=null
	end if
	
'RESPONSE.WRITE("1 : "&sql_fondo_rendir&"<BR>")

'*************************************

set f_presupuesto_ant = new CFormulario
f_presupuesto_ant.Carga_Parametros "datos_presupuesto.xml", "detalle_presupuesto"
f_presupuesto_ant.Inicializar conectar
sql_presupuesto_ant="select * from ocag_presupuesto_solicitud where cast(cod_solicitud as varchar)='"&v_fren_ncorr&"' and tsol_ccod=3 and isnull(psol_brendicion,'N') ='N'"
f_presupuesto_ant.consultar sql_presupuesto_ant

'*****************************************************************
'***************	Inicio bases para presupuesto	**************

sql_presupuesto_adicional="select isnull(sum(psol_mpresupuesto),0) as total_adicional  from ocag_presupuesto_solicitud where cast(cod_solicitud_origen as varchar)='"&v_fren_ncorr&"' and tsol_ccod=2 and isnull(psol_brendicion,'S') ='S'"
v_suma_presupuesto= conectar.ConsultaUno(sql_presupuesto_adicional)

set f_presupuesto = new CFormulario
f_presupuesto.Carga_Parametros "datos_presupuesto.xml", "detalle_presupuesto"
f_presupuesto.Inicializar conectar

if Clng(v_suma_presupuesto)>0 then
	sql_presupuesto="select * from ocag_presupuesto_solicitud where cast(cod_solicitud_origen as varchar)='"&v_fren_ncorr&"' and tsol_ccod=2 and isnull(psol_brendicion,'S') ='S'"
else
	sql_presupuesto="select 0 as psol_mpresupuesto, '' "
end if	
'response.Write(sql_presupuesto)
f_presupuesto.consultar sql_presupuesto


set f_cod_pre = new CFormulario
f_cod_pre.carga_parametros "orden_compra.xml", "codigo_presupuesto"
'f_cod_pre.carga_parametros "fondos_rendir.xml", "codigo_presupuesto"
f_cod_pre.inicializar conexion
f_cod_pre.consultar "select '' "

sql_codigo_pre="(select distinct cod_pre, 'Area('+cast(cast(cod_area as numeric) as varchar)+')-'+concepto +' ('+cod_pre+')' as valor "&_
			    " from presupuesto_upa.protic.presupuesto_upa_2011 	"&_
			    "	where cod_anio=2011 "&_
				"	and cod_area in (   select distinct area_ccod "&_ 
				"		 from  presupuesto_upa.protic.area_presupuesto_usuario  "&_
				"		 where rut_usuario in ("&v_usuario&") and cast(area_ccod as varchar)= '"&area_ccod&"') "&_
				" ) as tabla "

'response.Write(sql_codigo_pre)
f_cod_pre.agregaCampoParam "cod_pre","destino", sql_codigo_pre
f_cod_pre.consultar sql_codigo_pre
'f_cod_pre.Siguiente

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

if v_fren_ncorr="" or EsVacio(v_fren_ncorr) then
	f_presupuesto_ant.AgregaCampoCons "anos_ccod", v_anos_ccod
end if	

'*****************************************************************
'***************	Fin bases para presupuesto	******************

set f_buscador = new CFormulario
f_buscador.Carga_Parametros "consultas.xml", "buscador"
f_buscador.Inicializar conectar
f_buscador.Consultar " select '' "
f_buscador.Siguiente

f_buscador.agregaCampoCons "solicitud", v_fren_ncorr

set f_tipo_docto = new CFormulario
f_tipo_docto.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_tipo_docto.inicializar conectar
sql_tipo_docto= "Select * from ocag_tipo_documento order by tdoc_tdesc"
f_tipo_docto.consultar sql_tipo_docto

set f_tipo_gasto = new CFormulario
f_tipo_gasto.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_tipo_gasto.inicializar conectar

sql_tipo_gasto= "Select b.tgas_ccod,ltrim(rtrim(tgas_tdesc )) as tgas_tdesc "&_
				"	from ocag_perfiles_areas_usuarios a, ocag_tipo_gasto_perfil b, ocag_tipo_gasto c "&_
				"	where a.pers_nrut="&v_usuario&" "&_
				"	and a.pare_ccod=b.pare_ccod "&_
				"	and b.tgas_ccod=c.tgas_ccod "&_
				"   and b.tgas_ccod not in (1,2,45,158) "
'response.Write("<pre>"&sql_tipo_gasto&"</pre>")				
f_tipo_gasto.consultar sql_tipo_gasto

set f_detalle = new CFormulario
f_detalle.Carga_Parametros "rendicion_fondo_rendir.xml", "detalle_rendicion"
f_detalle.Inicializar conectar



if v_rfre_ncorr<>"" then
'response.Write("<hr>"&ajajaja&"<hr>")
	
	'sql_detalle_pago= "select drfr_trut as pers_nrut,isnull(drfr_mretencion,0) as drfr_mretencion,protic.trunc(drfr_fdocto) as drfr_fdocto,* from ocag_detalle_rendicion_fondo_rendir where rfre_ncorr ="&v_rfre_ncorr
	
	sql_detalle_pago= "select drfr_ncorr, rfre_ncorr, drfr_trut as pers_nrut, tgas_ccod, tdoc_ccod "&_
						" , drfr_ndocto, drfr_tdesc, protic.trunc(drfr_fdocto) as drfr_fdocto, audi_tusuario, audi_fmodificacion "&_
						" , fren_ncorr, ISNULL(drfr_mafecto,0) AS drfr_mafecto, ISNULL(drfr_miva,0) AS drfr_miva, ISNULL(drfr_mexento,0) AS drfr_mexento , ISNULL(drfr_mdocto,0) AS drfr_mdocto "&_
						" , ISNULL(drfr_mhonorarios,0) AS drfr_mhonorarios, ISNULL(drfr_mretencion,0) AS drfr_mretencion, ISNULL(drfr_bboleta_honorario,0) AS drfr_bboleta_honorario "&_
						" from ocag_detalle_rendicion_fondo_rendir where rfre_ncorr ="&v_rfre_ncorr
	
else
	'sql_detalle_pago= "select 0 as drfr_mdocto, 0 as drfr_mretencion "
	
	sql_detalle_pago= "SELECT 0 AS drfr_mafecto, 0 AS drfr_miva, 0 AS drfr_mexento, 0 AS drfr_mhonorarios, 0 AS drfr_mretencion, 0 AS drfr_mdocto, 0 AS drfr_bboleta_honorario"

end if	

'RESPONSE.WRITE("1. sql_detalle_pago: "&sql_detalle_pago&"<BR>")

f_detalle.agregaCampoParam "tgas_ccod","destino", " ( Select b.tgas_ccod,ltrim(rtrim(tgas_tdesc )) as tgas_tdesc "&_
							"	from ocag_perfiles_areas_usuarios a, ocag_tipo_gasto_perfil b, ocag_tipo_gasto c "&_
							"	where a.pers_nrut="&v_usuario&" "&_
							"	and a.pare_ccod=b.pare_ccod "&_
							"	and b.tgas_ccod=c.tgas_ccod  ) as tabla "
'response.Write("<hr>"&sql_detalle_pago)			
f_detalle.Consultar sql_detalle_pago

v_indice=f_detalle.Nrofilas

'***************	Inicio bases para Responsables	**************
set f_responsable = new CFormulario
	f_responsable.carga_parametros "tabla_vacia.xml", "tabla_vacia"
	f_responsable.inicializar conectar
	sql_responsable= "Select pers_nrut_responsable as pers_nrut,protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre, a.PERS_TEMAIL as email "&_
					  "	from ocag_responsable_area a, personas b "&_
					  "	where a.pers_nrut_responsable=b.pers_nrut "&_
					  "	and cast(a.pers_nrut as varchar)='"&v_usuario&"'"
	f_responsable.consultar sql_responsable
'*****************************************************************

set f_devolucion = new CFormulario
f_devolucion.Carga_Parametros "rendicion_fondo_rendir.xml", "devolucion_rendicion"
f_devolucion.Inicializar conectar

if v_rfre_ncorr<>"" then
	sql_devolucion="select protic.trunc(dren_fcomprobante) as dren_fcomprobante, * from ocag_devolucion_rendicion_fondos where fren_ncorr="&v_fren_ncorr
else
	sql_devolucion="select '' "
end if

'response.write("sql_devolucion: "&sql_devolucion&"<br>")

f_devolucion.Consultar sql_devolucion
f_devolucion.siguiente
'*****************************************************************

sql_presupuesto_ant		=	"select sum(psol_mpresupuesto) as suma from ocag_presupuesto_solicitud where cast(cod_solicitud as varchar)='"&v_fren_ncorr&"' and tsol_ccod=3 and isnull(psol_brendicion,'N') ='N'"
v_suma_presupuesto_ant	=	conectar.ConsultaUno(sql_presupuesto_ant)

sql_dev= " select count(*) as total from ocag_devolucion_rendicion_fondos where fren_ncorr="&v_fren_ncorr
				
v_existe_devolucion= conectar.consultaUno(sql_dev)
'response.Write(sql_dev&"<hr>"&v_existe_devolucion)

'response.Write(Clng(v_suma_presupuesto))

'vibo_ccod=conectar.consultaUno("select vibo_ccod from ocag_rendicion_fondos_a_rendir where fren_ncorr = "&v_fren_ncorr)

Usuario = negocio.ObtenerUsuario()
nombre_solicitante = conectar.ConsultaUno("select protic.obtener_nombre_completo(pers_ncorr, 'n') as nombre from personas where cast(pers_nrut as varchar) = '" & Usuario & "'")
tipo_soli = "Rendicion de Fondos a Rendir"
n_soli=v_fren_ncorr

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
<script type="text/javascript" src="http://code.jquery.com/jquery-1.10.1.min.js"></script>

<script language="JavaScript">

function Enviar() {
	//validar campos vacios
	v_rendido= datos.rendicion.value;
	v_solicitado=datos.monto_total.value;
	v_diferencia=datos.diferencia.value;
	//alert(v_diferencia);
	v_total_presupuesto=datos.total_presupuesto.value;
	v_gastado=(v_diferencia)*-1
	
	//88888888888888888888888888888888888888888888888888888888888888
	diferencia=datos.diferencia.value;
	//alert(diferencia);

	if (typeof datos.elements["devolucion[0][dren_mmonto]"] == "undefined"){
		saldo=datos.elements["devolucion[-1][dren_mmonto]"].value;
		//alert(saldo);
		//alert("alert 1");
	}else{
		saldo=datos.elements["devolucion[0][dren_mmonto]"].value;
		//alert(saldo);
		//alert("alert 2");
	}	
	
	if ((saldo=="Bloqueado")||(saldo=="")) {
			return true; 
	}else{
		if (diferencia!=saldo)
		{
			alert("El Monto de la devolucion tiene que ser igual al saldo")
			return false; 
		}
	}
	//88888888888888888888888888888888888888888888888888888888888888
	
	if(v_solicitado>v_rendido){
		alert("Si va a rendir un monto ("+v_rendido+") inferior a lo solicitado  ("+v_solicitado+"), la diferencia debe ser devuelta en caja previamente");
	}
	if(v_solicitado<v_rendido){
	//validar contra el presupuesto
		if(datos.solicita.value=="No Solicitar"){ 
			if(v_gastado==v_total_presupuesto){
				return true;
			}else{
				alert(" El presupuesto debe coincidir con el total extra gastado");
				return false;
			}
		}else{
			return true
		}
	}	
	return true;
}

function Solicitar(valor){
	if (valor=='Solicitar'){
		alert("Esta rindiendo un monto mayor a lo solicitado, por lo tanto, la diferencia debe ser agregada al presupuesto\nSe generará una autorización de giro asociada al monto extra gastado");
		datos.solicita.value="No Solicitar";
		datos.solicita_dev.value="N";
		ActivarPresupuesto();
	}else{
		alert("Ha seleccionado no volver a rendir el monto extra gastado, por lo tanto, este no sera reemblosado");
		datos.solicita.value="Solicitar";
		datos.solicita_dev.value="S";
		DesactivarPresupuesto();
	}
}


function crearAjax()
{
    var xmlhttp=false;
    try
    { // para navegadores que no sean Micro$oft
        xmlhttp=new ActiveXObject("Msxml2.XMLHTTP");
    }
    catch(e)
    {
        try
        { // para iexplore.exe XD
            xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
        }
        catch(E) { xmlhttp=false; }
    }
    if (!xmlhttp && typeof XMLHttpRequest!='undefined') { xmlhttp=new XMLHttpRequest(); }
    return xmlhttp;
}

function funsion_completa(Objeto)
{
var jaime=Objeto.value;
//alert(jaime);

//88888888888888888888888888888888888888888888888888888888888
	
	var ajax=crearAjax();
	
    ajax.open("POST", "datos_comprobante.asp", true);
    ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    ajax.send("valor="+jaime);

    ajax.onreadystatechange=function()
    {
	
	//alert("aca 1");
	
        if (ajax.readyState==4)
        {
		
		//alert("aca 2");
		
            var respuesta=ajax.responseXML;
			
            comprobante=respuesta.getElementsByTagName("comprobante")[0].childNodes[0].data;
            fecha=respuesta.getElementsByTagName("fecha")[0].childNodes[0].data;
            rut=respuesta.getElementsByTagName("rut")[0].childNodes[0].data;
            monto=respuesta.getElementsByTagName("monto")[0].childNodes[0].data;

			//alert(comprobante);
			//alert(fecha);
			//alert(rut);
			//alert(monto);
			
			if (comprobante=='')
			{
			alert("No existe deposito en caja para el comprobante N° "+jaime)
			
			datos.elements["devolucion[0][pers_nrut]"].value='';
			datos.elements["devolucion[0][dren_fcomprobante]"].value='';
			datos.elements["devolucion[0][dren_tglosa]"].value='';
			datos.elements["devolucion[0][dren_mmonto]"].value='';

			}
			else
			{
			
			datos.elements["devolucion[0][pers_nrut]"].value=rut;
			datos.elements["devolucion[0][dren_fcomprobante]"].value=fecha;
			datos.elements["devolucion[0][dren_mmonto]"].value=monto;
																
			}
		}
	}

//88888888888888888888888888888888888888888888888888888888888

}


function Valida_Rut( Objeto )
{
	var tmpstr = "";
	var intlargo = Objeto.value
	if (intlargo.length> 0)
	{
		crut = Objeto.value
		largo = crut.length;
		if ( largo <5 )
		{
			alert('Rut inválido')
			Objeto.value="";
			return false;
		}
		for ( i=0; i <crut.length ; i++ )
		if ( crut.charAt(i) != ' ' && crut.charAt(i) != '.' && crut.charAt(i) != '-' )
		{
			tmpstr = tmpstr + crut.charAt(i);
		}
		rut = tmpstr;
		crut=tmpstr;
		largo = crut.length;
	
		if ( largo> 2 )
			rut = crut.substring(0, largo - 1);
		else
			rut = crut.charAt(0);
	
		dv = crut.charAt(largo-1);
	
		if ( rut == null || dv == null )
		return 0;
	
		var dvr = '0';
		suma = 0;
		mul  = 2;
	
		for (i= rut.length-1 ; i>= 0; i--)
		{
			suma = suma + rut.charAt(i) * mul;
			if (mul == 7)
				mul = 2;
			else
				mul++;
		}
	
		res = suma % 11;
		if (res==1)
			dvr = 'k';
		else if (res==0)
			dvr = '0';
		else
		{
			dvi = 11-res;
			dvr = dvi + "";
		}
	
		if ( dvr != dv.toLowerCase() )
		{
			alert('El Rut ingresado no es válido')
			Objeto.value="";
			return false;
		}
		/*alert('El Rut Ingresado es Correcto!')
		Objeto.focus()*/
		return true;
	}
}



function ImprimirRendicionFondoRendir(){
	
	v_rendido= datos.rendicion.value;
	v_solicitado=datos.monto_total.value;
	v_diferencia=datos.diferencia.value;
	v_total_presupuesto=datos.total_presupuesto.value;
	v_rindio=1;
	if ((v_diferencia<0) && (v_rindio==1)){
	url2="imprimir_devolucion_fr.asp?fren_ncorr=<%=v_fren_ncorr%>";
	window.open(url2,'ImpresionDevFR', 'scrollbars=yes, menubar=no, resizable=yes, width=700,height=700');
	}
	
	url="imprimir_rendicion_fr.asp?fren_ncorr="+<%=v_fren_ncorr%>+"&v_rfre_ncorr="+<%=v_fren_ncorr%>;
	if(url){
	window.open(url,'ImpresionRFR', 'scrollbars=yes, menubar=no, resizable=yes, top=50, left=50 width=700,height=700');
	}

}

// ESTA FUNCION YA NO LA OCUPO MAS
// 8888888888888888888888888888888888
function Habilita(objeto){
	v_valor=objeto.value;
	v_indice=extrae_indice(objeto.name);
	//alert(v_valor+ " indice: "+v_indice+" objeto = "+objeto);
	document.datos.elements["detalle["+v_indice+"][tipo_doc]"].value=v_valor;
	
	if ((v_valor==5)){
		document.datos.elements["detalle["+v_indice+"][pers_nrut]"].disabled=true;
	}else{
		document.datos.elements["detalle["+v_indice+"][pers_nrut]"].disabled=false;
	}
	if (v_valor==1 || v_valor==11 ){
		document.datos.elements["detalle["+v_indice+"][drfr_mretencion]"].disabled=false;
	}else{
		document.datos.elements["detalle["+v_indice+"][drfr_mretencion]"].value=0;
		document.datos.elements["detalle["+v_indice+"][drfr_mretencion]"].disabled=true;
	}

}

//************************************************************
//************** detalle de rendiciones **********************
<%if cint(f_detalle.nrofilas) >1 then%>
var contador=<%=f_detalle.nrofilas-1%>;
<%else%>
var contador=0;
<%end if%>


function validaFila(id, nro,boton)
{
	if (document.datos.elements["detalle["+nro+"][drfr_mdocto]"].value == '')
      {alert('Debe ingresar un monto válido');}

	if (document.datos.elements["detalle["+nro+"][drfr_ndocto]"].value != '')
	  {addRow(id, nro, boton );habilitaUltimoBoton();}
     else
      {alert('Debe completar las filas del  para ingresar una rendicion valida');}

//addRow(id, nro, boton );bloqueaFila(nro);
}

function eliminaFilas()
{
var check=document.datos.getElementsByTagName('input');
//alert(check);
var cantidadCheck=0;
var checkbox=new Array();
var tabla = document.getElementById('tb_busqueda_');
//alert(tabla);
var Count = 0;

 for (y=0;y<check.length;y++){if (check[y].type=="checkbox"){checkbox[cantidadCheck++]=check[y];}}
 //alert(cantidadCheck);
	for (x=0;x<cantidadCheck;x++){
		  if (checkbox[x].checked) {
			  deleterow(checkbox[x]);
			  Count++;
		}
	 }
	 if(Count==0){
		alert("Debe seleccionar una fila para eliminar");
	}
	 
 if (tabla.tBodies[0].rows.length < 2)
    {addRow('tb_busqueda_', cantidadCheck, 0 );}

 habilitaUltimoBoton();

}

function habilitaUltimoBoton()
{
var objetos=document.datos.getElementsByTagName('input');
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
//alert(contador);

$("#tb_busqueda_").append("<tr><td align=\"center\"><INPUT TYPE=\"checkbox\" name=\"check\" value=\""+ contador +"\"  ></td>"+
"<td><INPUT TYPE=\"text\" name=\"detalle["+ contador +"][drfr_fdocto]\" size=\"10\" maxlength=\"10\"></td>"+
"<td><select name= \"detalle["+ contador +"][tdoc_ccod]\" onchange=\"CambiaValor(this);\">"+
"<%f_tipo_docto.primero%>"+
"	<%while f_tipo_docto.Siguiente %>"+
"<option value=\"<%=f_tipo_docto.ObtenerValor("tdoc_ccod")%>\" ><%=f_tipo_docto.ObtenerValor("tdoc_tdesc")%></option>"+
"<%wend%>"+
"</select></td>"+
"<td><INPUT TYPE=\"text\" name=\"detalle["+ contador +"][drfr_ndocto]\" size=\"10\" maxlength=\"10\"></td>"+
"<td><INPUT TYPE=\"text\" name=\"detalle["+ contador +"][pers_nrut]\" id=\"TO-N\" size=\"10\" OnBlur=\"Valida_Rut(this);\" maxlength=\"10\"></td>"+
"<td><select name= \"detalle["+ contador +"][tgas_ccod]\">"+ 
"<%f_tipo_gasto.primero%>"+
"	<%while f_tipo_gasto.Siguiente%>"+
"<option value=\"<%=f_tipo_gasto.ObtenerValor("tgas_ccod")%>\" ><%=f_tipo_gasto.ObtenerValor("tgas_tdesc")%></option>"+
"<%wend%>"+
"</select>  </td>"+
"<td><INPUT TYPE=\"text\" name=\"detalle["+ contador +"][drfr_tdesc]\" size=\"20\" ></td>"+
"<td><INPUT TYPE=\"text\" name=\"detalle["+ contador +"][drfr_mafecto]\" id=\"NU-S\" value=\"\" size=\"10\" onblur=\"ConviertePesos_Factura(this);SumaTotalGiro(this);\" maxlength=\"10\"></td>"+
"<td><INPUT TYPE=\"text\" name=\"detalle["+ contador +"][drfr_miva]\" size=\"10\" maxlength=\"10\" readonly=\"yes\"></td>"+
"<td><INPUT TYPE=\"text\" name=\"detalle["+ contador +"][drfr_mexento]\" id=\"NU-S\" onblur=\"ConviertePesos_Factura(this);SumaTotalGiro(this);\" value=\"\" size=\"10\" maxlength=\"10\"></td>"+
"<td><INPUT TYPE=\"text\" name=\"detalle["+ contador +"][drfr_mhonorarios]\" id=\"NU-S\" size=\"10\" maxlength=\"10\" onblur=\"ConviertePesos_Boleta(this);SumaTotalGiro(this);\"></td>"+
"<td><INPUT TYPE=\"text\" name=\"detalle["+ contador +"][drfr_mretencion]\" id=\"NU-N\" value=\"\" size=\"10\" maxlength=\"10\" readonly=\"yes\"></td>"+
"<td><INPUT TYPE=\"text\" name=\"detalle["+ contador +"][drfr_mdocto]\" id=\"NU-N\" onblur=\"SumaTotalGiro(this);\" value=\"\" size=\"10\" maxlength=\"10\">"+
"<INPUT TYPE=\"hidden\" name=\"detalle["+ contador +"][drfr_bboleta_honorario]\" value=\"\" size=\"1\" id=\"NU-S\"></td>"+
"<td align=\"center\"><INPUT class=boton TYPE=\"button\" name=\"agregarlinea\" value=\"+\" onclick=\"validaFila('tb_busqueda_',"+contador+",this)\">&nbsp;"+
"<INPUT class=boton TYPE=\"button\" name=\"quitarlinea\" value=\"-\" onclick=\"eliminaFilas()\"></td>"+
"<INPUT TYPE=\"hidden\" name=\"detalle["+ contador +"][tipo_doc]\" value=\"\" size=\"10\" maxlength=\"10\"></tr>");

}
function deleterow(node) {
var tr = node.parentNode;
while (tr.tagName.toLowerCase() != "tr")
tr = tr.parentNode;

tr.parentNode.removeChild(tr);
}

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
//************************************************************************

/*****************************************************************************/
//******* SEGUNDA TABLA DINAMICA   *********//
<%if cint(f_presupuesto.nrofilas) >1 then%>
var contador2=<%=f_presupuesto.nrofilas-1%>;
<%else%>
var contador2=0;
<%end if%>


function validaFila2(id, nro,boton){
	if (document.datos.elements["presupuesto["+nro+"][psol_mpresupuesto]"].value >0){ 
		addRow2(id, nro, boton );habilitaUltimoBoton2(); 
	}else{
		alert('Debe ingresar todos los campos del presupuesto que usará');
		return false;
	}
}

function addRow2(id, nro, boton ){

contador2++;

$("#tb_presupuesto").append("<tr><td align=\"center\"><INPUT TYPE=\"checkbox\" name=\"presupuesto["+ contador2 +"][check]\" value=\""+ contador2 +"\"  ></td>"+
"<td><select name= \"presupuesto["+ contador2 +"][cod_pre]\">"+
"	<%f_cod_pre.primero%> "+
" <%while f_cod_pre.Siguiente %>"+
"<option value=\"<%=f_cod_pre.ObtenerValor("cod_pre")%>\" ><%=f_cod_pre.ObtenerValor("valor")%></option>"+
"<%wend%>"+
"</select></td>"+
"<td><select name= \"presupuesto["+ contador2 +"][mes_ccod]\">"+
"<%f_meses.primero%>"+
"	<%while f_meses.Siguiente %>"+
"<option value=\"<%=f_meses.ObtenerValor("mes_ccod")%>\" ><%=f_meses.ObtenerValor("mes_tdesc")%></option>"+
"<%wend%>"+
"</select></td>"+
"<td><select name= \"presupuesto["+ contador2 +"][anos_ccod]\">"+ 
"<%f_anos.primero%>"+
"	<%while f_anos.Siguiente%>"+
"<option value=\"<%=f_anos.ObtenerValor("anos_ccod")%>\" ><%=f_anos.ObtenerValor("anos_ccod")%></option>"+
"<%wend%>"+
"</select>  </td>"+
"<td><INPUT TYPE=\"text\" name=\"presupuesto["+ contador2 +"][psol_mpresupuesto]\" size=\"10\" onblur=\"SumaTotalPresupuesto(this);\" ></td>"+
"<td><INPUT class=boton TYPE=\"button\" name=\"agregarlinea2\" value=\"+\" onclick=\"validaFila2('tb_presupuesto',"+contador2+",this)\">&nbsp;"+
"<INPUT class=boton TYPE=\"button\" name=\"quitarlinea2\" value=\"-\" onclick=\"eliminaFilas2()\"></td></tr>");

}

function eliminaFilas2()
{
var check=document.datos.getElementsByTagName('input');
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
    if (tabla2.tBodies[0].rows.length < 2){
		addRow2('tb_presupuesto', cantidadCheck, 0 );
	}
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
	SumaTotalPresupuesto(objetos2);	
}

function deleterow2(node){
var tr2 = node.parentNode;
while (tr2.tagName.toLowerCase() != "tr")
	tr2 = tr2.parentNode;
	tr2.parentNode.removeChild(tr2);
}


function SumaTotalPresupuesto(valor){


	var formulario = document.forms["datos"];
	v_total_presupuesto = 0;
	for (var i = 0; i <= contador2; i++) {
		if(formulario.elements["presupuesto["+i+"][psol_mpresupuesto]"]){
			v_valor	=	formulario.elements["presupuesto["+i+"][psol_mpresupuesto]"].value;
			//alert(formulario.elements["detalle["+i+"][dorc_nprecio_neto]"].value);
			if (v_valor){
				v_total_presupuesto = v_total_presupuesto + parseInt(v_valor);
			}
		}
	}
	formulario.elements["total_presupuesto"].value=v_total_presupuesto;
}

//******* FIN SEGUNDA TABLA DINAMICA *******//
/*****************************************************************************/

function CalculaTotal_20140929(){
	//alert(valor)
	var formulario = document.forms["datos"];
	v_total_solicitud = 0;
		for (i=0;i <= contador; i++){
		
			if(formulario.elements["detalle["+i+"][drfr_mdocto]"]){
			//alert("Indice: "+formulario.elements["detalle["+i+"][tgas_ccod]"].name);
			//objeto_dom=document.getElementsByName("detalle["+i+"][tgas_ccod]");
			//var v_valor = objeto_dom[0];
			//alert(objeto_dom);
			//v_tipo_docto=	v_valor.value;
				 v_monto		=	formulario.elements["detalle["+i+"][drfr_mdocto]"].value;
				 v_tipo_docto	=	formulario.elements["detalle["+i+"][tdoc_ccod]"].value;
				 v_retencion	=	0;
				 //alert(v_tipo_docto)
				if (!v_monto){
					v_monto=0;
					formulario.elements["detalle["+i+"][drfr_mdocto]"].value=0;
				}else{
					if(v_tipo_docto==1 || v_tipo_docto==11){
						//v_retencion=(v_monto*0.1);
						v_retencion=eval(Math.round(v_monto*0.1));
						//v_mretencion	=	eval(Math.round(v_honorarios*1.10)-v_honorarios);
						formulario.elements["detalle["+i+"][drfr_mretencion]"].value=v_retencion;
					}else{
						formulario.elements["detalle["+i+"][drfr_mretencion]"].value=0;
					}
				}
				
				v_neto		=	eval(parseInt(v_monto) - parseInt(v_retencion));
				formulario.elements["detalle["+i+"][drfr_mtotal]"].value=v_neto;
				//alert("Neto:"+ v_neto)
				if (v_neto){
					v_total_solicitud = v_total_solicitud + parseInt(v_neto);
				}
			}
	}

	datos.rendicion.value	=	eval(v_total_solicitud);
	datos.diferencia.value  =   datos.monto_total.value- datos.rendicion.value

	if(datos.diferencia.value>0){
	/*	formulario.elements["devolucion[0][dren_ncomprobante]"].value="";
		formulario.elements["devolucion[0][dren_fcomprobante]"].value="";
		formulario.elements["devolucion[0][pers_nrut]"].value="";
		formulario.elements["devolucion[0][dren_tglosa]"].value="";
		formulario.elements["devolucion[0][dren_mmonto]"].value="";*/
		
		formulario.elements["devolucion[0][dren_ncomprobante]"].disabled=false;
		formulario.elements["devolucion[0][dren_fcomprobante]"].disabled=false;
		formulario.elements["devolucion[0][pers_nrut]"].disabled=false;
		formulario.elements["devolucion[0][dren_tglosa]"].disabled=false;
		formulario.elements["devolucion[0][dren_mmonto]"].disabled=false;
		formulario.elements["devolucion[0][dren_mmonto]"].value=datos.diferencia.value;
		formulario.elements["solicita"].disabled=true;

		DesactivarPresupuesto();
		
	}else{
		formulario.elements["devolucion[0][dren_ncomprobante]"].value="Bloqueado";
		formulario.elements["devolucion[0][dren_fcomprobante]"].value="Bloqueado";
		formulario.elements["devolucion[0][pers_nrut]"].value="Bloqueado";
		formulario.elements["devolucion[0][dren_tglosa]"].value="Bloqueado";
		formulario.elements["devolucion[0][dren_mmonto]"].value="Bloqueado";
	
		formulario.elements["devolucion[0][dren_ncomprobante]"].disabled=true;
		formulario.elements["devolucion[0][dren_fcomprobante]"].disabled=true;
		formulario.elements["devolucion[0][pers_nrut]"].disabled=true;
		formulario.elements["devolucion[0][dren_tglosa]"].disabled=true;
		formulario.elements["devolucion[0][dren_mmonto]"].disabled=true;
		if (datos.diferencia.value==0){
			formulario.elements["solicita"].disabled=true;
			DesactivarPresupuesto();
			formulario.elements["total_presupuesto"].value=0;
		}else{
			formulario.elements["solicita"].disabled=false;
		}
	}
//DesactivarPresupuesto()	

}

function DesactivarPresupuesto(){
	var formulario = document.forms["datos"];
	
	for (var i = 0; i <= contador2; i++) {
		if(formulario.elements["presupuesto["+i+"][psol_mpresupuesto]"]){
			formulario.elements["presupuesto["+i+"][mes_ccod]"].disabled=true;
			formulario.elements["presupuesto["+i+"][anos_ccod]"].disabled=true;
			formulario.elements["presupuesto["+i+"][psol_mpresupuesto]"].disabled=true;
			formulario.elements["presupuesto["+i+"][psol_mpresupuesto]"].value='';
			formulario.elements["presupuesto["+i+"][cod_pre]"].disabled=true;
			formulario.elements["presupuesto["+i+"][checkbox]"].disabled=true;
		}
	}
}

function ActivarPresupuesto(){
	var formulario = document.forms["datos"];
	
	for (var i = 0; i <= contador2; i++) {
		if(formulario.elements["presupuesto["+i+"][psol_mpresupuesto]"]){
			formulario.elements["presupuesto["+i+"][mes_ccod]"].disabled=false;
			formulario.elements["presupuesto["+i+"][anos_ccod]"].disabled=false;
			formulario.elements["presupuesto["+i+"][psol_mpresupuesto]"].disabled=false;
			formulario.elements["presupuesto["+i+"][cod_pre]"].disabled=false;
			formulario.elements["presupuesto["+i+"][checkbox]"].disabled=false;
		}
	}
}


function GuardarEnviar(){
	var f = new Date(); 
	
	//88888888888888888888888888888888888888888888888888888888888888
	diferencia=datos.diferencia.value;
	//alert(diferencia);
	
	if (typeof datos.elements["devolucion[0][dren_mmonto]"] == "undefined"){
		saldo=datos.elements["devolucion[-1][dren_mmonto]"].value;
		//alert(saldo);
		//alert("alert 1");
	}else{
		saldo=datos.elements["devolucion[0][dren_mmonto]"].value;
		//alert(saldo);
		//alert("alert 2");
	}				
	
	if ((saldo=="Bloqueado")||(saldo=="")) {
			return true; 
	}else{
		if (diferencia!=saldo)
		{
			alert("El Monto de la devolucion tiene que ser igual al saldo")
			return false; 
		}
	}
		
	//88888888888888888888888888888888888888888888888888888888888888

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
	//return false;
	return true;
	}else{
		alert("Debe Ingresar un Correo Electronico.")
		return false;	
	}
}

//8888888888888888888888888888888888888888888888888888888888888888888888888

function CambiaValor(obj){

	var formulario = document.forms["datos"];
	v_valor=obj.value;
	indice		=	extrae_indice(obj.name);
	
	//alert(v_valor);
	//alert(indice);
	
	formulario.elements["detalle["+indice+"][tipo_doc]"].value=v_valor;
		
	if ((v_valor==1)||(v_valor==11)){
		//BOLETAS

		formulario.elements["detalle["+indice+"][pers_nrut]"].disabled=false;
				
		formulario.elements["detalle["+indice+"][drfr_mafecto]"].value="";
		formulario.elements["detalle["+indice+"][drfr_miva]"].value="";
		formulario.elements["detalle["+indice+"][drfr_mexento]"].value=0;
		
		formulario.elements["detalle["+indice+"][drfr_mafecto]"].disabled=true;
		formulario.elements["detalle["+indice+"][drfr_miva]"].disabled=true;
		formulario.elements["detalle["+indice+"][drfr_mexento]"].disabled=true;
		
		formulario.elements["detalle["+indice+"][drfr_mhonorarios]"].value="";
		formulario.elements["detalle["+indice+"][drfr_mretencion]"].value="";
		formulario.elements["detalle["+indice+"][drfr_mdocto]"].value="";
		
		formulario.elements["detalle["+indice+"][drfr_mhonorarios]"].disabled=false;
		formulario.elements["detalle["+indice+"][drfr_mretencion]"].disabled=false;
		formulario.elements["detalle["+indice+"][drfr_mdocto]"].disabled=false;

		formulario.elements["detalle["+indice+"][drfr_bboleta_honorario]"].value=1;
		
	}else{
		//FACTURAS
		
			if ((v_valor==5)){
				formulario.elements["detalle["+indice+"][pers_nrut]"].disabled=true;
			}else{
				formulario.elements["detalle["+indice+"][pers_nrut]"].disabled=false;
			}

		formulario.elements["detalle["+indice+"][drfr_mafecto]"].value="";
		formulario.elements["detalle["+indice+"][drfr_miva]"].value="";
		formulario.elements["detalle["+indice+"][drfr_mexento]"].value=0;
		
		formulario.elements["detalle["+indice+"][drfr_mafecto]"].disabled=false;
		formulario.elements["detalle["+indice+"][drfr_miva]"].disabled=false;
		formulario.elements["detalle["+indice+"][drfr_mexento]"].disabled=false;
		
		formulario.elements["detalle["+indice+"][drfr_mhonorarios]"].value="";
		formulario.elements["detalle["+indice+"][drfr_mretencion]"].value="";
		formulario.elements["detalle["+indice+"][drfr_mdocto]"].value="";

		formulario.elements["detalle["+indice+"][drfr_mhonorarios]"].disabled=true;
		formulario.elements["detalle["+indice+"][drfr_mretencion]"].disabled=true;
		formulario.elements["detalle["+indice+"][drfr_mdocto]"].disabled=false;
		
		formulario.elements["detalle["+indice+"][drfr_bboleta_honorario]"].value=2;
		
	}

}

//8888888888888888888888888888888888888888888888888888888888888888888888888
//8888888888888888888888888888888888888888888888888888888888888888888888888

function ConviertePesos_Factura(objeto){
	var formulario = document.forms["datos"];
	indice		=	extrae_indice(objeto.name);

		v_exento	=	formulario.elements["detalle["+indice+"][drfr_mexento]"].value;
		v_afecto	=	formulario.elements["detalle["+indice+"][drfr_mafecto]"].value;

		formulario.elements["detalle["+indice+"][drfr_mhonorarios]"].value=0;

		if(v_afecto){
			v_iva	=	eval(Math.round(v_afecto*1.19)-parseInt(v_afecto));
		}else{
			v_iva	= 0
		}
		
		formulario.elements["detalle["+indice+"][drfr_miva]"].value=v_iva
		v_valor		= 	parseInt(v_iva)+parseInt(v_exento)+parseInt(v_afecto);
		
		formulario.elements["detalle["+indice+"][drfr_mdocto]"].value=v_valor

}

//8888888888888888888888888888888888888888888888888888888888888888888888888

function ConviertePesos_Boleta(objeto){
	var formulario = document.forms["datos"];
	indice		=	extrae_indice(objeto.name);

		v_honorarios=	formulario.elements["detalle["+indice+"][drfr_mhonorarios]"].value;
		v_mretencion	=	eval(Math.round(v_honorarios*1.10)-v_honorarios);
		formulario.elements["detalle["+indice+"][drfr_mexento]"].value=0;
		formulario.elements["detalle["+indice+"][drfr_mafecto]"].value=0;
		formulario.elements["detalle["+indice+"][drfr_mretencion]"].value=v_mretencion;
		v_valor		= 	parseInt(v_honorarios)-parseInt(v_mretencion);
		formulario.elements["detalle["+indice+"][drfr_mdocto]"].value=v_valor

}

//8888888888888888888888888888888888888888888888888888888888888888888888888

function SumaTotalGiro(valor){
	var formulario = document.forms["datos"];
	v_total_solicitud = 0;
	v_drfr_mhonorarios=0;
	v_drfr_mafecto=0;
	v_neto=0;
	//indice		=	extrae_indice(valor.name);
	//alert(contador);         
		 
	for (var i = 0; i <= contador; i++) {
	
		if (typeof formulario.elements["detalle["+i+"][drfr_mdocto]"] == "undefined"){
					//alert("Variable no definida");
		}else{
				v_tdoc_ccod		=	formulario.elements["detalle["+i+"][tdoc_ccod]"].value;
				//alert(v_tdoc_ccod);
				
				if ((v_tdoc_ccod==1) || (v_tdoc_ccod==11))
				{
					//alert("aca 1");
					v_drfr_mhonorarios		=	formulario.elements["detalle["+i+"][drfr_mhonorarios]"].value;
					v_drfr_mafecto=0;
				}else{
					//alert("aca 2");
					v_drfr_mhonorarios=0
					v_drfr_mafecto	=	formulario.elements["detalle["+i+"][drfr_mafecto]"].value;
				}
				
				if (!v_drfr_mhonorarios){
					v_drfr_mhonorarios=0;
					formulario.elements["detalle["+i+"][drfr_mhonorarios]"].value=0;
				}
				
				if (!v_drfr_mafecto){
					v_drfr_mafecto=0;
					formulario.elements["detalle["+i+"][drfr_mafecto]"].value=0;
				}

				v_neto		=	eval(parseInt(v_drfr_mhonorarios) + parseInt(v_drfr_mafecto));
				
				if (v_neto){
					v_total_solicitud = v_total_solicitud + parseInt(v_neto);
				}
		}
	}
	
	//alert(v_total_solicitud);
	
	//formulario.total_detalle.value	=	eval(v_total_solicitud);
	//formulario.rendicion.value	=	eval(v_total_solicitud);
	
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	formulario.rendicion.value	=	eval(v_total_solicitud);
	formulario.diferencia.value  =   formulario.monto_total.value- formulario.rendicion.value
	
	if (typeof formulario.elements["devolucion[0][dren_ncomprobante]"]== "undefined"){
	
					if(formulario.diferencia.value>0){
						
						formulario.elements["devolucion[-1][dren_ncomprobante]"].disabled=false;
						formulario.elements["devolucion[-1][dren_fcomprobante]"].disabled=false;
						formulario.elements["devolucion[-1][pers_nrut]"].disabled=false;
						formulario.elements["devolucion[-1][dren_tglosa]"].disabled=false;
						formulario.elements["devolucion[-1][dren_mmonto]"].disabled=false;
						formulario.elements["devolucion[-1][dren_mmonto]"].value=formulario.diferencia.value;
						formulario.elements["solicita"].disabled=true;

						DesactivarPresupuesto();

					}else{
						formulario.elements["devolucion[-1][dren_ncomprobante]"].value="Bloqueado";
						formulario.elements["devolucion[-1][pers_nrut]"].value="Bloqueado";
						formulario.elements["devolucion[-1][dren_fcomprobante]"].value="Bloqueado";
						formulario.elements["devolucion[-1][dren_tglosa]"].value="Bloqueado";
						formulario.elements["devolucion[-1][dren_mmonto]"].value="Bloqueado";
					
						formulario.elements["devolucion[-1][dren_ncomprobante]"].disabled=true;
						formulario.elements["devolucion[-1][pers_nrut]"].disabled=true;
						formulario.elements["devolucion[-1][dren_fcomprobante]"].disabled=true;
						formulario.elements["devolucion[-1][dren_tglosa]"].disabled=true;
						formulario.elements["devolucion[-1][dren_mmonto]"].disabled=true;
						
						if (formulario.diferencia.value==0){
							formulario.elements["solicita"].disabled=true;
							
							DesactivarPresupuesto();
							
							formulario.elements["total_presupuesto"].value=0;
						}else{
							formulario.elements["solicita"].disabled=false;
						}
					}

	}else{
	
					if(formulario.diferencia.value>0){
						
						formulario.elements["devolucion[0][dren_ncomprobante]"].disabled=false;
						formulario.elements["devolucion[0][dren_fcomprobante]"].disabled=false;
						formulario.elements["devolucion[0][pers_nrut]"].disabled=false;
						formulario.elements["devolucion[0][dren_tglosa]"].disabled=false;
						formulario.elements["devolucion[0][dren_mmonto]"].disabled=false;
						formulario.elements["devolucion[0][dren_mmonto]"].value=formulario.diferencia.value;
						formulario.elements["solicita"].disabled=true;

						DesactivarPresupuesto();

					}else{
						formulario.elements["devolucion[0][dren_ncomprobante]"].value="Bloqueado";
						formulario.elements["devolucion[0][pers_nrut]"].value="Bloqueado";
						formulario.elements["devolucion[0][dren_fcomprobante]"].value="Bloqueado";
						formulario.elements["devolucion[0][dren_tglosa]"].value="Bloqueado";
						formulario.elements["devolucion[0][dren_mmonto]"].value="Bloqueado";
					
						formulario.elements["devolucion[0][dren_ncomprobante]"].disabled=true;
						formulario.elements["devolucion[0][pers_nrut]"].disabled=true;
						formulario.elements["devolucion[0][dren_fcomprobante]"].disabled=true;
						formulario.elements["devolucion[0][dren_tglosa]"].disabled=true;
						formulario.elements["devolucion[0][dren_mmonto]"].disabled=true;
						
						if (formulario.diferencia.value==0){
							formulario.elements["solicita"].disabled=true;
							
							DesactivarPresupuesto();
							
							formulario.elements["total_presupuesto"].value=0;
						}else{
							formulario.elements["solicita"].disabled=false;
						}
					}

	}	

/*
					if(formulario.diferencia.value>0){
						
						formulario.elements["devolucion[0][dren_ncomprobante]"].disabled=false;
						formulario.elements["devolucion[0][dren_fcomprobante]"].disabled=false;
						formulario.elements["devolucion[0][pers_nrut]"].disabled=false;
						formulario.elements["devolucion[0][dren_tglosa]"].disabled=false;
						formulario.elements["devolucion[0][dren_mmonto]"].disabled=false;
						formulario.elements["devolucion[0][dren_mmonto]"].value=formulario.diferencia.value;
						formulario.elements["solicita"].disabled=true;

						DesactivarPresupuesto();

					}else{
						formulario.elements["devolucion[0][dren_ncomprobante]"].value="Bloqueado";
						formulario.elements["devolucion[0][pers_nrut]"].value="Bloqueado";
						formulario.elements["devolucion[0][dren_fcomprobante]"].value="Bloqueado";
						formulario.elements["devolucion[0][dren_tglosa]"].value="Bloqueado";
						formulario.elements["devolucion[0][dren_mmonto]"].value="Bloqueado";
					
						formulario.elements["devolucion[0][dren_ncomprobante]"].disabled=true;
						formulario.elements["devolucion[0][pers_nrut]"].disabled=true;
						formulario.elements["devolucion[0][dren_fcomprobante]"].disabled=true;
						formulario.elements["devolucion[0][dren_tglosa]"].disabled=true;
						formulario.elements["devolucion[0][dren_mmonto]"].disabled=true;
						
						if (formulario.diferencia.value==0){
							formulario.elements["solicita"].disabled=true;
							
							DesactivarPresupuesto();
							
							formulario.elements["total_presupuesto"].value=0;
						}else{
							formulario.elements["solicita"].disabled=false;
						}
					}
*/

}

//8888888888888888888888888888888888888888888888888888888888888888888888888

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="<% if (v_rfre_ncorr="" or EsVAcio(v_rfre_ncorr)) and Clng(v_suma_presupuesto)<=0 then%>DesactivarPresupuesto();<%end if%> onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
		<br>
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
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  	<tr>
            		<td><%pagina.DibujarLenguetas Array("Rendicion Fondo a Rendir"), 1 %></td>
          		</tr>
				<tr>
					<td height="2" background="../imagenes/top_r3_c2.gif"></td>
				</tr>				
                <tr>
                  <td bgcolor="#D8D8DE">
				  <br>
                    <div align="center"><font size="+1">
                      <%pagina.DibujarTituloPagina()%> 
                      </font>                    </div>
					  <br/>
					  <form name="datos">
					  <input type="hidden" name="pers_nrut" value="<%=f_busqueda.ObtenerValor("pers_nrut")%>">
					  <input type="hidden" name="area_ccod" value="<%=f_busqueda.ObtenerValor("area_ccod")%>">
					  <input type="hidden" name="fren_mmonto" value="<%=f_busqueda.ObtenerValor("fren_mmonto")%>">
					  <input type="hidden" name="rfre_ncorr" value="<%=v_rfre_ncorr%>">
						<table width="85%" border="1" align="center">
							  <tr> 
								<td width="11%"><strong>Rut funcionario</strong> </td>
								<td width="27%"> <%f_busqueda.dibujaCampo("pers_nrut")%>-<%f_busqueda.dibujaCampo("pers_xdv")%></td>
								<td width="14%"><strong>Fecha actividad</strong></td>
								<td ><%f_busqueda.dibujaCampo("fren_factividad")%></td>
							  </tr>
							  <tr> 
								<td> <strong>Nombre funcionario</strong> </td>
								<td>
								<%
								f_busqueda.dibujaCampo("pers_tnombre")
								%>&nbsp;<%
								'f_busqueda.dibujaCampo("v_nombre")
								%></td>
								<td><strong>Total Presupuesto</strong> </td>
								<td><input type="text" style="background-color:#D8D8DE;border: 1px #D8D8DE solid; font-size:10px; font-style:oblique; font:bold; "  name="total_presupuesto_ant" value="<%=v_suma_presupuesto_ant%>" size="12" id='total_presupuesto_ant' readonly/></td>
							  </tr>
							  <tr> 
								<td><strong>Monto Solicitado </strong> </td>
								<td><%f_busqueda.dibujaCampo("fren_mmonto")%></td>
								<td><strong>Presupuesto Adicional</strong> </td>
								<td><input type="text" style="background-color:#D8D8DE;border: 1px #D8D8DE solid; font-size:10px; font-style:oblique; font:bold; "  name="total_presupuesto" value="<%=v_suma_presupuesto%>" size="12" id='total_presupuesto' readonly/></td>
							  </tr>
							  <tr> 
								<td><strong>C. Costo</strong> </td>
								<td> 
									<%f_busqueda.dibujaCampo("ccos_ncorr")%>
								</td>
								<td> </td>
								<td> </td>
							  </tr>
							  <tr>
							    <td colspan="4">
								<table width="100%" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' >
                                  <tr bgcolor='#C4D7FF' bordercolor='#999999'>
                                    <th width="50%">Cod. Presupuesto</th>
                                    <th width="12%">Mes</th>
                                    <th width="12%">A&ntilde;o</th>
                                    <th width="16%">Valor</th>
                                  </tr>
                                  <% ind=0
											f_presupuesto_ant.primero
											while f_presupuesto_ant.Siguiente 
											v_cod_pre=f_presupuesto_ant.ObtenerValor("cod_pre")
											%>
                                  <tr align="left">
                                    <td>
                                        <%
											f_cod_pre.primero
											while f_cod_pre.Siguiente 
												if Cstr(f_cod_pre.ObtenerValor("cod_pre"))=Cstr(v_cod_pre) then
													response.Write(f_cod_pre.ObtenerValor("valor"))
												end if
											wend
										%>                                    </td>
                                    <td><%
										f_presupuesto_ant.AgregaCampoParam "mes_ccod", "permiso", "LECTURA"
										f_presupuesto_ant.DibujaCampo("mes_ccod")
										%>                                    </td>
                                    <td><%
										f_presupuesto_ant.AgregaCampoParam "anos_ccod", "permiso", "LECTURA"
										f_presupuesto_ant.DibujaCampo("anos_ccod")
										%>                                    </td>
                                    <td><%
										f_presupuesto_ant.AgregaCampoParam "psol_mpresupuesto", "permiso", "LECTURA"
										f_presupuesto_ant.DibujaCampo("psol_mpresupuesto")
										%>
									</td>
                                  </tr>
                                  <%
										ind=ind+1
										wend 
								  %>
                                </table>								</td>
					      	  </tr>							  
					</table>
							<br>
								
					  <%f_busqueda.dibujaCampo("fren_ncorr")%>											  
                    <table width="98%" align="center" cellpadding="0" cellspacing="0" >
					  <tr> 
						<td>
						  <table width="100%" border="0">
							<tr> 
							  <td>
							  <table width="100%" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' id=tb_busqueda_>
									<tr>
										<td colspan=10>
										Detalle Gasto 
										<td>
									</tr>

									<tr bgcolor='#C4D7FF' bordercolor='#999999'>
										<th>N°</th>
										<th>Fecha Docto </th>
										<th>Tipo Docto </th>
										<th>N&deg;Docto</th>
										<th>Rut</th>	
										<th>Tipo Gasto</th>
										<th>Descripcion Gasto</th>
                                        <th>Neto</th>
										<th>Iva</th>
										<th>Exento</th>
										<th>Honorarios</th>
										<th>Retencion</th>
										<th>Líquido</th>

										<th>(+/-)</th>
									</tr>
									<%
								if f_detalle.nrofilas >=1 then
									ind=0
									v_total_rendido=0
									while f_detalle.Siguiente 
									
									 v_tipo=f_detalle.ObtenerValor("tdoc_ccod")
									 
									'response.write("1 tipo_doc: "&v_tipo&"<br>")
									
									if cstr(v_tipo)=cstr(5) then
										f_detalle.AgregaCampoParam "pers_nrut", "deshabilitado", true
									else
										f_detalle.AgregaCampoParam "pers_nrut", "deshabilitado", false
									end if
									
									%>
									<tr>
										<th><input type="checkbox" name="detalle[<%=ind%>][checkbox]" value=""></th>
										<td align="center"><%f_detalle.DibujaCampo("drfr_fdocto")%></td>
										<td align="center">
										<%f_detalle.DibujaCampo("tdoc_ccod")
										
										f_detalle.DibujaCampo("tipo_doc")
										v_tdoc_ccod=f_detalle.ObtenerValor("tdoc_ccod")
										'RESPONSE.WRITE("v_tdoc_ccod: "&v_tdoc_ccod)
										if v_tdoc_ccod="" then
											v_tdoc_ccod=0
										end if

										%></td>
										<td align="center"><%f_detalle.DibujaCampo("drfr_ndocto")%> </td>
										<td align="center"><%f_detalle.DibujaCampo("pers_nrut")%> </td>
										<td align="center"><%f_detalle.DibujaCampo("tgas_ccod")%> </td>
										<td align="center"><%f_detalle.DibujaCampo("drfr_tdesc")%> </td>
										
										<%
										V_BOLETA=f_detalle.ObtenerValor("drfr_bboleta_honorario")
										IF V_BOLETA="" THEN
											V_BOLETA=0
										END IF
										
										'RESPONSE.WRITE("V_BOLETA: "&V_BOLETA)
										
										if cstr(V_BOLETA)=cstr(0) then
										'NUEVO FORMULARIO
										%>

                                        <td align="center"><%f_detalle.DibujaCampo("drfr_mafecto")%> </td>
										<td align="center"><%f_detalle.DibujaCampo("drfr_miva")%> </td>										
                                        <td align="center"><%f_detalle.DibujaCampo("drfr_mexento")%> </td>
                                        <td align="center"><%f_detalle.DibujaCampo("drfr_mhonorarios")%> </td>
										<td align="center"><%f_detalle.DibujaCampo("drfr_mretencion")%> </td>										
                                        <td align="center"><%f_detalle.DibujaCampo("drfr_mdocto")%> 
										<input type="hidden" name="detalle[<%=ind%>][drfr_bboleta_honorario]" value="<%=f_detalle.ObtenerValor("drfr_bboleta_honorario")%>" size="1"  id="NU-S"/>
										
										<%
										else
										
												if cstr(V_BOLETA)=cstr(1) then
												' BOLETA
												f_detalle.AgregaCampoParam "drfr_mafecto", "deshabilitado", "true"
												f_detalle.AgregaCampoParam "drfr_miva", "deshabilitado", "true"
												f_detalle.AgregaCampoParam "drfr_mexento", "deshabilitado", "true"

												f_detalle.AgregaCampoParam "drfr_mhonorarios", "deshabilitado", "false"
												f_detalle.AgregaCampoParam "drfr_mretencion", "deshabilitado", "false"

												%>

												<td align="center"><%f_detalle.DibujaCampo("drfr_mafecto")%> </td>
												<td align="center"><%f_detalle.DibujaCampo("drfr_miva")%> </td>										
												<td align="center"><%f_detalle.DibujaCampo("drfr_mexento")%> </td>
												<td align="center"><%f_detalle.DibujaCampo("drfr_mhonorarios")%> </td>
												<td align="center"><%f_detalle.DibujaCampo("drfr_mretencion")%> </td>										
												<td align="center"><%f_detalle.DibujaCampo("drfr_mdocto")%> 
												<input type="hidden" name="detalle[<%=ind%>][drfr_bboleta_honorario]" value="<%=f_detalle.ObtenerValor("drfr_bboleta_honorario")%>" size="1"  id="NU-S"/>

												<%
												'f_detalle.AgregaCampoCons "drfr_mhonorarios", f_detalle.ObtenerValor("drfr_mhonorarios")
												v_drga_mhonorarios=Clng(v_drga_mhonorarios) + Clng(f_detalle.ObtenerValor("drfr_mhonorarios"))
												
												'RESPONSE.WRITE("1. v_drga_mhonorarios: "&v_drga_mhonorarios&"<BR>")

												else
												' FACTURA
												f_detalle.AgregaCampoParam "drfr_mafecto", "deshabilitado", "false"
												f_detalle.AgregaCampoParam "drfr_miva", "deshabilitado", "false"
												f_detalle.AgregaCampoParam "drfr_mexento", "deshabilitado", "false"

												f_detalle.AgregaCampoParam "drfr_mhonorarios", "deshabilitado", "true"
												f_detalle.AgregaCampoParam "drfr_mretencion", "deshabilitado", "true"

												%>
												
												<td align="center"><%f_detalle.DibujaCampo("drfr_mafecto")%> </td>
												<td align="center"><%f_detalle.DibujaCampo("drfr_miva")%> </td>										
												<td align="center"><%f_detalle.DibujaCampo("drfr_mexento")%> </td>
												<td align="center"><%f_detalle.DibujaCampo("drfr_mhonorarios")%> </td>
												<td align="center"><%f_detalle.DibujaCampo("drfr_mretencion")%> </td>										
												<td align="center"><%f_detalle.DibujaCampo("drfr_mdocto")%> 
												<input type="hidden" name="detalle[<%=ind%>][drfr_bboleta_honorario]" value="<%=f_detalle.ObtenerValor("drfr_bboleta_honorario")%>" size="1"  id="NU-S"/>
												
												<%

												end if

									end if
									%>
										
										</td>
										<td align="center"><INPUT alt="agregar una nueva fila" class=boton TYPE="button" name="agregarlinea" value="+" onClick="validaFila('tb_busqueda_','<%=ind%>',this)">&nbsp;<INPUT alt="quitar una fila existente" class=boton TYPE="button" name="quitarlinea" value="-" onClick="eliminaFilas()"></td>							
									</tr>	
									<%

												  if (Clng(v_tdoc_ccod)=Clng(1) or Clng(v_tdoc_ccod)=Clng(11)) then
													  v_drfr_mafecto		=Clng(v_drfr_mafecto) + Clng(0)
													  v_drfr_mhonorarios		=Clng(v_drfr_mhonorarios) + Clng(f_detalle.ObtenerValor("drfr_mhonorarios"))
												  else
													  v_drfr_mafecto		=Clng(v_drfr_mafecto) + Clng(f_detalle.ObtenerValor("drfr_mafecto"))
													  v_drfr_mhonorarios		=Clng(v_drfr_mhonorarios) + Clng(0)
												  end if

												  v_total_rendido= v_drfr_mafecto+v_drfr_mhonorarios
												  
									ind=ind+1
									wend
								end if
								%>									
								</table>
							  </td>
							</tr>
						  </table>
					    </td>
					  </tr>
					  <tr>
						<td>				
						  	<table border="0" width="100%" >
								<tr>
									<th width="92%" align="right">Total Rendido</th>
									<td width="8%" align="right"><input type="text" name="rendicion" value="<%=v_total_rendido%>" size="10" id='NU-N' readonly/></td>	
								</tr>
								<tr>
									<th align="right">Monto solicitado</th>
									<td align="right"><input type="text" name="monto_total" value="<%f_busqueda.dibujaCampo("fren_mmonto")%>" size="10" id='NU-N' readonly/></td>						
							  </tr>
							  <tr>
									<th align="right">Saldo</th>
									<%
									'RESPONSE.WRITE("3. v_total_rendido: "&v_total_rendido&"<BR>")
									v_diferencia=Clng(v_total_solicitado - v_total_rendido)
									'RESPONSE.WRITE("4. v_diferencia: "&v_diferencia&"<BR>")
									
									if v_diferencia>0 then
										v_deshabilita=false
									else
										v_deshabilita=true
									end if
									%>
									<td align="right">
									 <input type="text" name="diferencia" value="<%=v_diferencia%>" size="10" id='NU-N'/>
									</td>
								</tr>
								<tr>
										<th align="right">Solicita dev. x diferencia</th>	
										<td>
										<input type="button" value="Solicitar" name="solicita" onClick="javascript:Solicitar(this.value);" disabled="disabled">
										<input type="hidden" name="solicita_dev" value="N" size="10" />

										</td>						
								</tr>
								<tr>
									<td colspan="2">
										<strong>Detalle devolucion de dinero sobrante</strong><br/>
										
										<table align="center" width="70%" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' id=tb_busqueda_>
											<tr bgcolor='#C4D7FF' bordercolor='#999999'>
												<th>N° Comprobante</th>
												<th>Rut</th>
												<th>Fecha docto </th>	
												<th>Descripcion devolucion</th>
												<th>Monto</th>
											</tr>
											<tr>
												<td><%
												if v_deshabilita then
													f_devolucion.AgregaCampoParam "dren_ncomprobante", "deshabilitado", true
												end if
												f_devolucion.DibujaCampo("dren_ncomprobante")
												%></td>
												<td><%
												if v_deshabilita then
													f_devolucion.AgregaCampoParam "pers_nrut", "deshabilitado", true
												end if
												f_devolucion.DibujaCampo("pers_nrut")
												%></td>
												<td><%
												if v_deshabilita then
													f_devolucion.AgregaCampoParam "dren_fcomprobante", "deshabilitado", true
												end if
												f_devolucion.DibujaCampo("dren_fcomprobante")
												%></td>
												<td><%
												if v_deshabilita then
													f_devolucion.AgregaCampoParam "dren_tglosa", "deshabilitado", true
												end if
												f_devolucion.DibujaCampo("dren_tglosa")
												%></td>
												<td><%
												if v_deshabilita then
													f_devolucion.AgregaCampoParam "dren_mmonto", "deshabilitado", true
												end if
												f_devolucion.DibujaCampo("dren_mmonto")%></td>
											</tr>
										</table>
								  </td>
								</tr>
								<tr>
									  <td colspan="4">
									  <hr>
											<h5>Detalle presupuesto para diferencia solicitada </h5>
			
											<table width="100%" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' id=tb_presupuesto>
												<tr bgcolor='#C4D7FF' bordercolor='#999999'>
													<th width="5%">N°</th>
													<th width="50%">Cod. Presupuesto</th>
													<th width="12%">Mes</th>
													<th width="12%">Año</th>
													<th width="16%">Valor</th>
													<th width="5%">(+/-)</th>
												</tr>
											<% ind=0
											f_presupuesto.primero
											while f_presupuesto.Siguiente 
											v_cod_pre=f_presupuesto.ObtenerValor("cod_pre")
											%>
											<tr align="left">
												<th><input type="checkbox" name="presupuesto[<%=ind%>][checkbox]" value=""></th>
												<td>
													<select name="presupuesto[<%=ind%>][cod_pre]" >
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
													</select>
												</td>
												<td><%
												if clng(v_suma_presupuesto)>=1 then
													f_presupuesto.AgregaCampoParam "mes_ccod", "deshabilitado", false
													f_presupuesto.AgregaCampoParam "anos_ccod", "deshabilitado", false
													f_presupuesto.AgregaCampoParam "psol_mpresupuesto", "deshabilitado", false
												end if
												f_presupuesto.DibujaCampo("mes_ccod")%> </td>
												<td><%f_presupuesto.DibujaCampo("anos_ccod")%> </td>
												<td><%f_presupuesto.DibujaCampo("psol_mpresupuesto")%> </td>
												<td>
												<INPUT alt="agregar fila" class=boton TYPE="button" name="agregarlinea2" value="+" onClick="validaFila2('tb_presupuesto','<%=ind%>',this);">&nbsp;<INPUT alt="quitar una fila existente" class="boton" TYPE="button" name="quitarlinea2" value="-" onClick="eliminaFilas2()">	
												</td>
											</tr>	
											<%
											ind=ind+1
											wend 
											%>
										</table>
									</td>
							  </tr>													
							</table>
					</td>
				  </tr>
                </table>
				<br/>
						<fieldset>
							<legend><strong>Responsable</strong></legend> 				
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
						</fieldset>						
				    </form>
					  <br>	
					</td>
				</tr>
			</table>  
			<!--  Inicio margen inferior -->
		</td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="18%" height="20">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
					  <%

				IF rfre_ncorr="" AND ocag_baprueba="" AND ocag_baprueba_rector="" AND fren_ncorr="" AND vibo_ccod="" THEN

				botonera.AgregaBotonParam "guardar2", "deshabilitado", "false"
				botonera.AgregaBotonParam "guardarenviar", "deshabilitado", "false"
				botonera.AgregaBotonParam "imprimir", "deshabilitado", "true"
				ELSE	
				'IF v_rfre_ncorr="" OR ((vibo_ccod="11" and ocag_baprueba="1" and ocag_baprueba_rector="1") or (vibo_ccod="6" and ocag_baprueba="1" and ocag_baprueba_rector="2"))  or vibo_ccod="12" THEN
				IF v_rfre_ncorr="" or vibo_ccod="7" or vibo_ccod="12" THEN
					botonera.AgregaBotonParam "guardar2", "deshabilitado", "false"
					botonera.AgregaBotonParam "guardarenviar", "deshabilitado", "false"
					botonera.AgregaBotonParam "imprimir", "deshabilitado", "true"
					ELSE
						IF vibo_ccod>="0" AND ocag_baprueba="5"	then

						botonera.AgregaBotonParam "guardar2", "deshabilitado", "false"
						botonera.AgregaBotonParam "guardarenviar", "deshabilitado", "false"
						botonera.AgregaBotonParam "imprimir", "deshabilitado", "true"
						ELSE
'							IF vibo_ccod="0" then

'							botonera.AgregaBotonParam "guardar2", "deshabilitado", "false"
'							botonera.AgregaBotonParam "guardarenviar", "deshabilitado", "false"
'							botonera.AgregaBotonParam "imprimir", "deshabilitado", "true"
'							ELSE

							botonera.AgregaBotonParam "guardar2", "deshabilitado", "true"
							botonera.AgregaBotonParam "guardarenviar", "deshabilitado", "true"
							botonera.AgregaBotonParam "imprimir", "deshabilitado", "true"
'							END IF
						END IF
					END IF
				END IF
						%>
						
                        <td width="21%">&nbsp;</td>
                        <td width="31%"><%botonera.dibujaboton "guardar2"%></td>
						<td><%botonera.dibujaboton "guardarenviar"%></td>
						<td width="26%"><%botonera.dibujaboton "salir"%></td>
						<td width="22%"><%botonera.dibujaboton "imprimir"%></td>
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
   </td>
  </tr>  
</table>
</body>
</html>
<script>

<% if clng(v_suma_presupuesto)=0 and v_rfre_ncorr<>"" then %>
	DesactivarPresupuesto();
	var formulario = document.forms["datos"];
	formulario.elements["solicita"].disabled=false;
	formulario.elements["solicita"].value="Solicitar";
<% end if%>
<% if clng(v_suma_presupuesto)>0 and v_rfre_ncorr<>"" then %>
	ActivarPresupuesto();
	var formulario = document.forms["datos"];
	formulario.elements["solicita"].disabled=false;
	formulario.elements["solicita"].value="No Solicitar";
<% end if%>
if(datos.diferencia.value>=0){
	DesactivarPresupuesto();
	var formulario = document.forms["datos"];
	formulario.elements["solicita"].disabled=true;
}
</script>