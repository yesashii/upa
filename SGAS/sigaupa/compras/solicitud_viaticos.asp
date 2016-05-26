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
'FECHA ACTUALIZACION 	:19/06/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ORDEN DE COMPRA
'LINEA			:51
'*******************************************************************
set pagina = new CPagina
pagina.Titulo = "Solicitud de Viatico"
vibo_ccod = -1
v_sovi_ncorr	= request.querystring("busqueda[0][sovi_ncorr]")
v_rut			= request.querystring("rut")
v_dv			= request.querystring("dv")
area_ccod		= request.querystring("area_ccod")

'RESPONSE.WRITE("1 area_ccod : "&area_ccod&"<BR>")

set botonera = new CFormulario
botonera.carga_parametros "solicitud_viaticos.xml", "botonera"

set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new cnegocio
negocio.Inicializa conectar

set conexion = new Cconexion2
conexion.Inicializar "upacifico"

v_usuario=negocio.ObtenerUsuario()


 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "solicitud_viaticos.xml", "datos_funcionario"
 f_busqueda.Inicializar conectar


if  v_sovi_ncorr<>"" then

'	sql_viatico	=	"select isnull(vibo_ccod,0) as vibo_ccod,protic.trunc(sovi_fpago) as sovi_fpago,protic.trunc(sovi_fllegada) as sovi_fllegada,protic.trunc(sovi_fsalida) as sovi_fsalida, "&_
'				" a.*,  b.pers_nrut, pers_xdv, protic.obtener_nombre_completo(a.pers_ncorr,'n') as pers_tnombre "&_
'				" from ocag_solicitud_viatico a, personas b "&_
'				" where a.pers_ncorr=b.pers_ncorr and sovi_ncorr="&v_sovi_ncorr

	sql_viatico	=	"select isnull(a.vibo_ccod,0) as vibo_ccod, protic.trunc(a.sovi_fpago) as sovi_fpago "&_
				" , protic.trunc(a.sovi_fllegada) as sovi_fllegada "&_
				" , protic.trunc(a.sovi_fsalida) as sovi_fsalida "&_
				" , a.sovi_ncorr, a.pers_ncorr, a.anos_ccod, a.mes_ccod, a.cod_pre, a.area_ccod, a.sovi_tdetalle_presu, a.orvi_ccod, a.devi_ccod "&_
				" , a.sovi_hsalida, a.sovi_hllegada, a.sovi_mmonto_dia, a.sovi_mmonto_origen, a.sovi_mmonto_pesos, a.sovi_tmotivo "&_
				" , a.audi_tusuario, a.audi_fmodificacion, a.sovi_frecepcion, a.sovi_tobs_rechazo, a.tsol_ccod, a.ocag_fingreso, a.ocag_generador "&_
				" , a.ocag_frecepcion_presupuesto, a.ocag_responsable, a.ocag_baprueba, a.sede_ccod, a.ccos_ncorr "&_
				" , b.pers_nrut, b.pers_xdv "&_
				", b.pers_tnombre + ' ' + b.PERS_TAPE_PATERNO + ' ' + b.PERS_TAPE_MATERNO as v_nombre "&_
				", b.pers_tnombre + ' ' + b.PERS_TAPE_PATERNO + ' ' + b.PERS_TAPE_MATERNO as PERS_TNOMBRE "&_	
				" , asgi_tobservaciones  "&_
 				" from ocag_solicitud_viatico a, personas b, ocag_autoriza_solicitud_giro d "&_
 				" where a.pers_ncorr = b.pers_ncorr and d.cod_solicitud = a.sovi_ncorr"&_
 				" and a.sovi_ncorr = "&v_sovi_ncorr &"  and d.tsol_ccod = 4 ORDER BY d.audi_fmodificacion DESC"

'RESPONSE.WRITE("1. :"&sql_viatico&"<BR>")
'RESPONSE.END()

	f_busqueda.Consultar sql_viatico
	f_busqueda.Siguiente
						
	audi_tusuario=f_busqueda.obtenerValor("audi_tusuario")
	area_ccod=f_busqueda.obtenerValor("area_ccod")
	vibo_ccod=f_busqueda.obtenerValor("vibo_ccod")					
	ocag_baprueba = f_busqueda.obtenerValor("ocag_baprueba")
	ordc_tobservacion=f_busqueda.obtenerValor("asgi_tobservaciones")
	'response.write ordc_tobservacion
	'RESPONSE.WRITE("2 audi_tusuario : "&audi_tusuario&"<BR>")
	'RESPONSE.WRITE("3 area_ccod : "&area_ccod&"<BR>")

else

	sql_viatico	=	"select ''"
	f_busqueda.Consultar sql_viatico
	f_busqueda.Siguiente

end if 

if v_rut<>"" then
	set f_personas = new CFormulario
	f_personas.carga_parametros "tabla_vacia.xml", "tabla_vacia"
	f_personas.inicializar conexion
	'f_personas.inicializar conectar

	sql_datos_persona= " select CODAUX AS pers_nrut, RIGHT(RUTAUX,1) AS pers_xdv, NOMAUX AS pers_tnombre, NOMAUX AS v_nombre "&_
										" from softland.cwtauxi where cast(CodAux as varchar)='"&v_rut&"'"

'	sql_datos_persona= " SELECT PERS_NRUT, PERS_TNOMBRE + ' ' + PERS_TAPE_PATERNO + ' ' + PERS_TAPE_MATERNO as pers_tnombre, PERS_TAPE_PATERNO + ' ' + PERS_TAPE_MATERNO as v_nombre "&_
'					   	" FROM PERSONAS "&_
'					   	" WHERE PERS_NRUT= '" &v_rut& "'" 
						
	'RESPONSE.WRITE("2. :"&sql_datos_persona&"<BR>")
		
	f_personas.consultar sql_datos_persona
	f_personas.Siguiente
	
	v_pers_tnombre = f_personas.obtenerValor("pers_tnombre")
	nombre = f_personas.obtenerValor("v_nombre")
	
	f_busqueda.AgregaCampoCons "pers_nrut", v_rut
	f_busqueda.AgregaCampoCons "pers_xdv", v_dv
	f_busqueda.AgregaCampoCons "pers_tnombre", f_personas.obtenerValor("pers_tnombre")
	f_busqueda.AgregaCampoCons "v_nombre", f_personas.obtenerValor("v_nombre")

	'8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
	'88 INICIO
	
	if v_pers_tnombre="" then
	set f_personas2 = new CFormulario
	f_personas2.carga_parametros "tabla_vacia.xml", "tabla_vacia"
	f_personas2.inicializar conectar

	sql_datos_persona= " SELECT PERS_NRUT, PERS_TNOMBRE pers_tnombre, PERS_TAPE_PATERNO + ' ' + PERS_TAPE_MATERNO as v_nombre "&_
					   	"FROM PERSONAS "&_
					   	"WHERE PERS_NRUT='"&v_rut&"'"
	
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


'*****************************************************************
'***************	Inicio bases para presupuesto	**************
set f_presupuesto = new CFormulario
f_presupuesto.Carga_Parametros "datos_presupuesto.xml", "detalle_presupuesto"
f_presupuesto.Inicializar conectar

if v_sovi_ncorr<>"" then
	
	'sql_presupuesto="select * from ocag_presupuesto_solicitud where cast(cod_solicitud as varchar)='"&v_sovi_ncorr&"' and tsol_ccod=4"
	
	sql_presupuesto="select psol_ncorr, tsol_ccod, cod_solicitud, cod_pre, mes_ccod, anos_ccod "&_
							", psol_mpresupuesto, audi_tusuario, audi_fmodificacion, psol_brendicion, cod_solicitud_origen  "&_
							"from ocag_presupuesto_solicitud where cast(cod_solicitud as varchar)='"&v_sovi_ncorr&"' and tsol_ccod=4"
							
else
	sql_presupuesto="select '' "
end if	

'response.Write("1. "&sql_presupuesto&"<br>")

f_presupuesto.consultar sql_presupuesto
filas_presu= f_presupuesto.nrofilas

v_suma_presupuesto=0
if f_presupuesto.nrofilas>=1 and v_sovi_ncorr>=1 then
	while f_presupuesto.Siguiente
		v_suma_presupuesto= Clng(v_suma_presupuesto) + Clng(f_presupuesto.obtenerValor("psol_mpresupuesto"))
	wend
end if


set f_cod_pre = new CFormulario
f_cod_pre.carga_parametros "orden_compra.xml", "codigo_presupuesto"
f_cod_pre.inicializar conexion
f_cod_pre.consultar "select '' "

'sql_codigo_pre="(select distinct cod_pre, 'Area('+cast(cast(cod_area as numeric) as varchar)+')-'+concepto +' ('+cod_pre+')' as valor "&_
'			    " from presupuesto_upa.protic.presupuesto_upa_2011 	"&_
'			    "	where cod_anio=2011 "&_
'				"	and cod_area in (   select distinct area_ccod "&_ 
'				"		 from  presupuesto_upa.protic.area_presupuesto_usuario  "&_
'				"		 where rut_usuario in ("&v_usuario&") and cast(area_ccod as varchar)= '"&area_ccod&"') "&_
'				" ) as tabla "

IF audi_tusuario <> "" THEN
v_usuario=audi_tusuario
END IF

sql_codigo_pre="(select distinct cod_pre, '('+cod_pre+') ' + 'Area('+cast(cast(cod_area as numeric) as varchar)+')-' + concepto as valor "&_
			    " from presupuesto_upa.protic.presupuesto_upa_2011 	"&_
			    "	where cod_anio=2011 "&_
				"	and cod_area in (   select distinct area_ccod "&_ 
				"		 from  presupuesto_upa.protic.area_presupuesto_usuario  "&_
				"		 where rut_usuario in ("&v_usuario&") and cast(area_ccod as varchar)= '"&area_ccod&"') "&_
				" ) as tabla "

'response.Write("2. "&sql_codigo_pre&"<br>")

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

'88888888888888888888888888888888888888888888888
' centro de costo
'88888888888888888888888888888888888888888888888

set f_centro_costo = new CFormulario
f_centro_costo.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_centro_costo.inicializar conectar

sql_centro_costo=" select a.ccos_ncorr,a.ccos_tcodigo as ccos_tcompuesto,ccos_tdesc "&_ 
					" from ocag_centro_costo a, ocag_permisos_centro_costo b "&_ 
					" where a.ccos_tcodigo=b.ccos_tcodigo "&_ 
					" and pers_nrut="&v_usuario

f_centro_costo.consultar sql_centro_costo

'88888888888888888888888888888888888888888888888
'88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
' JAIME PAINEMAL 20130910
 
 'DETALLE TIPO DE GASTOS (Cuentas Contables)
set f_mes_anio = new CFormulario
f_mes_anio.Carga_Parametros "solicitud_viaticos.xml", "busqueda"
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
							" and tsol_ccod=4 "&_
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
 'CONSULTA PARA EL ARREGLO

conectar.Ejecuta sql_mes_anio

set rec_carreras = conectar.ObtenerRS

'88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

Usuario = negocio.ObtenerUsuario()
nombre_solicitante = conectar.ConsultaUno("select protic.obtener_nombre_completo(pers_ncorr, 'n') as nombre from personas where cast(pers_nrut as varchar) = '" & Usuario & "'")
tipo_soli = "Solicitud de Viatico"
n_soli=v_sovi_ncorr


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

<script languaje="JavaScript">


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

function llenaDatos()
{
	/*formulario = document.forms["datos"];
   var devi_ccod=document.getElementsByTagName("datos[0][devi_ccod]").value;
    var devi_mmonto=document.getElementsByTagName("datos[0][sovi_mmonto_dia]");
	var moneda=document.getElementsByTagName("moneda");*/
	 formulario = document.datos;
	var devi_ccod=formulario.elements["datos[0][devi_ccod]"].value;
    var devi_mmonto=formulario.elements["datos[0][sovi_mmonto_dia]"];
	var moneda=formulario.elements["moneda"];
    var ajax=crearAjax();
    ajax.open("POST", "tabla_viaticos.asp", true);
    ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    ajax.send("devi_ccod="+devi_ccod);
    ajax.onreadystatechange=function()
    {
        if (ajax.readyState==4)
        {
            var respuesta=ajax.responseXML;
            devi_mmonto.value=respuesta.getElementsByTagName("devi_mmonto")[0].childNodes[0].data;
            moneda.value=respuesta.getElementsByTagName("moneda")[0].childNodes[0].data;
			dias=DiferenciaFechas();
			if (dias>0){ 
				ConvierteMoneda(dias,devi_mmonto.value,moneda.value);
			}else{
			   alert("Debe seleccionar un rango de dias mayor a cero dias");
			   formulario.elements["datos[0][sovi_mmonto_pesos]"].value=0;
			}
			
			
	   }
    }
}

function ActualizaMontos(){
   formulario = document.forms["datos"];
   devi_mmonto = formulario.elements["datos[0][sovi_mmonto_dia]"].value;
   moneda = formulario.moneda.value;
   dias=DiferenciaFechas();
	if (dias>0){ 
		ConvierteMoneda(dias,devi_mmonto,moneda);
	}
}

function DiferenciaFechas () {  
   formulario = document.forms["datos"];
   //Obtiene los datos del formulario  
   CadenaFecha1 = formulario.elements["datos[0][sovi_fllegada]"].value;
   CadenaFecha2 = formulario.elements["datos[0][sovi_fsalida]"].value;
     
   //Obtiene dia, mes y año  
   var fecha1 = new fecha( CadenaFecha1 )     
   var fecha2 = new fecha( CadenaFecha2 )  
     
   //Obtiene objetos Date  
   var miFecha1 = new Date( fecha1.anio, fecha1.mes, fecha1.dia )  
   var miFecha2 = new Date( fecha2.anio, fecha2.mes, fecha2.dia )  
  
   //Resta fechas y redondea  
   var diferencia = miFecha1.getTime() - miFecha2.getTime()  
   var dias = Math.floor(diferencia / (1000 * 60 * 60 * 24))  
   //var segundos = Math.floor(diferencia / 1000)  
   
   return dias;  
}  
  
function fecha( cadena ) {  
   //Separador para la introduccion de las fechas  
   var separador = "/"  
  
   //Separa por dia, mes y año  
   if ( cadena.indexOf( separador ) != -1 ) {  
        var posi1 = 0  
        var posi2 = cadena.indexOf( separador, posi1 + 1 )  
        var posi3 = cadena.indexOf( separador, posi2 + 1 )  
        this.dia = cadena.substring( posi1, posi2 )  
        this.mes = cadena.substring( posi2 + 1, posi3 )  
        this.anio = cadena.substring( posi3 + 1, cadena.length )  
   } else {  
        this.dia = 0  
        this.mes = 0  
        this.anio = 0     
   }  
}  

function ConvierteMoneda(dias,monto_dia,moneda){
//DiferenciaFechas();
var formulario = document.forms["datos"];
var v_monto_pesos=0;
var v_monto_origen=0;
var valor_euro=760;
var valor_dolar=552;
//alert("entra");
	switch(moneda){
		case 'Peso':
			v_monto_pesos=eval(monto_dia*dias);
			v_monto_origen=eval(monto_dia*dias);
		break;
		case 'Dolar':
			v_monto_pesos=eval((monto_dia*dias)*valor_dolar);
			v_monto_origen=eval(monto_dia*dias);
		break;
		case 'Euro':
			v_monto_pesos=eval((monto_dia*dias)*valor_euro);
			v_monto_origen=eval(monto_dia*dias);
	}

		formulario.elements["datos[0][sovi_mmonto_pesos]"].value=v_monto_pesos;
		formulario.elements["datos[0][sovi_mmonto_origen]"].value=v_monto_origen;
		formulario.dias.value='Equivalen a :'+dias+' días';
}

</script>


<script language="JavaScript">

function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if%>
}

function Enviar(){
	formulario = document.datos;
	v_valor			= formulario.elements["datos[0][sovi_mmonto_pesos]"].value; // SOLICITUD DE GIRO
	v_presupuesto	= formulario.total_presupuesto.value;	// PRESUPUESTO

	if(v_valor==v_presupuesto){
		return true;
	}else{
		alert("El monto de la Solicitud de Viaticos ingresado debe coincidir con el total del Presupuesto");
		return false;
	}
}

function ImprimirSolicitudViatico(){
	url="imprimir_sv.asp?sovi_ncorr=<%=v_sovi_ncorr%>";
	window.open(url,'ImpresionSV', 'scrollbars=yes, menubar=no, resizable=yes, width=700,height=700');	
}


function Eshora(v_hora){
v_name=v_hora.name;
var a_hora 	= v_hora.value.split(':');
var hora 	= a_hora[0];
var minuto 	= a_hora[1];


	if(v_hora.value){
		if((!hora)||(!minuto)){
			alert('La hora no ingresada es válida, ingrese con un formato (hh:mm)'); 
			document.datos.elements[v_name].value="";
			return false;
		}else{
			if ((hora<0)||(hora>23)||(minuto<0)|(minuto>59)){
				alert('La hora no ingresada es válida, ingrese con un formato (hh:mm)'); 
				document.datos.elements[v_name].value="";
				return false;
			}
		}
	}
	return true;
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
   if (rut.length==7) rut = '0' + rut; 

   IgStringVerificador = '32765432';
   IgSuma = 0;
   for( IgN = 0; IgN < 8 && IgN < rut.length; IgN++)
      IgSuma = eval(IgSuma + '+' + rut.substr(IgN, 1) + '*' + IgStringVerificador.substr(IgN, 1) + ';');
   	IgDigito = 11 - IgSuma % 11;
   	IgDigitoVerificador = IgDigito==10?'K':IgDigito==11?'0':IgDigito;
   	datos.elements["datos[0][pers_xdv]"].value=IgDigitoVerificador;
   	document.datos.action= "solicitud_viaticos.asp?rut="+texto_rut+"&dv="+IgDigitoVerificador+"&area_ccod="+v_area;
	document.datos.method = "post";
	document.datos.submit();
}

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
	if (document.datos.elements["presupuesto["+nro+"][psol_mpresupuesto]"].value >0){ 
		addRow2(id, nro, boton );habilitaUltimoBoton2(); 
	}else{
		alert('Debe ingresar todos los campos del presupuesto que usará');
		return false;
	}
}

//8888888888888888888888888888888888888888888888888888888888888888
	/*formulario = document.forms["datos"];
   var devi_ccod=document.getElementsByTagName("datos[0][devi_ccod]").value;
    var devi_mmonto=document.getElementsByTagName("datos[0][sovi_mmonto_dia]");
	var moneda=document.getElementsByTagName("moneda");*/
	
	/*formulario = document.datos;
	var devi_ccod=formulario.elements["datos[0][devi_ccod]"].value;
    var devi_mmonto=formulario.elements["datos[0][sovi_mmonto_dia]"];
	var moneda=formulario.elements["moneda"];*/
//8888888888888888888888888888888888888888888888888888888888888888

function addRow2(id, nro, boton ){
	/*
contador2= contador2 + 1;

var tbody = document.getElementById(id).getElementsByTagName("TBODY")[0];
var row = document.createElement("TR");

row.align="left";

//********Nro de detalle********************

var td1 = document.createElement("TD");
var aElement=document.createElement("<INPUT TYPE=\"checkbox\" name=\"presupuesto["+ contador2 +"][check]\" value=\""+ contador2 +"\"  >");

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

//******** psol_mpresupuesto ***************

var td5 = document.createElement("TD");
var iElement=document.createElement("<INPUT TYPE=\"text\" name=\"presupuesto["+ contador2 +"][psol_mpresupuesto]\" size=\"10\" onblur=\"SumaTotalPresupuesto(this);\" >");


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
tbody.appendChild(row);
*/
contador2++;

$("#tb_presupuesto").append("<tr><td align=\"center\"><INPUT TYPE=\"checkbox\" align=\"center\" name=\"presupuesto["+ contador2 +"][check]\" value=\""+ contador2 +"\"  ></td>"+
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
"<td><INPUT TYPE=\"text\" name=\"presupuesto["+ contador2 +"][psol_mpresupuesto]\" size=\"10\" value=0 onblur=\"SumaTotalPresupuesto(this);\" ></td>"+
"<td><INPUT TYPE=\"text\" class=\"Mimetismo\" name=\"busqueda["+ contador2 +"][saldo]\" size=\"10\" value="+valor_saldo+" readonly ></td>"+
"<td><INPUT class=boton TYPE=\"button\" name=\"agregarlinea2\" value=\"+\" onclick=\"validaFila2('tb_presupuesto',"+contador2+",this)\">&nbsp;"+
"<INPUT class=boton TYPE=\"button\" name=\"quitarlinea2\" value=\"-\" onclick=\"eliminaFilas2()\"></td></tr>");

//desabilitarUltimoBoton2();
document.datos.elements["contador2"].value = contador2;
}

//8888888888888888888888888888888888888888888888888888888888888888

function eliminaFilas2()
{
var check=document.datos.getElementsByTagName('input');
var objetos=document.datos.getElementsByTagName('input');
var cantidadCheck=0;
var checkbox=new Array();
//var tabla2 = document.getElementById('tb_presupuesto');
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
  /*  if (tabla2.tBodies[0].rows.length < 2){
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

/*function desabilitarUltimoBoton2(){
var objetos1=document.datos.getElementsByTagName('input');
var cantidadBoton=0;
var botones=new Array();

 for (y=0;y<objetos1.length;y++){
	 if (objetos1[y].type=="button" && objetos1[y].name=="quitarlinea2"){
	 	cantidadBoton=cantidadBoton+1;
		botones[cantidadBoton]=objetos1[y];
		botones[cantidadBoton].disabled=true;	
		//alert("de"+cantidadBoton)
	 }
 }
	botones[cantidadBoton].disabled=false;
	//alert("Dcantidad "+cantidadBoton);

	if(cantidadBoton == 1){
		botones[cantidadBoton].disabled=false;		
	}
}*/

function deleterow2(node){
var tr2 = node.parentNode;
while (tr2.tagName.toLowerCase() != "tr")
	tr2 = tr2.parentNode;
	tr2.parentNode.removeChild(tr2);
	
	//desabilitarUltimoBoton2();
	habilitaUltimoBoton2();
	//contador2--;	
}

function SumaTotalPresupuesto(valor){

	var formulario = document.forms["datos"];
	v_total_presupuesto = 0;
	v_indice=extrae_indice(valor.name);
	
	TienePresupuesto(v_indice);
	
	for (var i = 0; i <= contador2; i++) {
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

/*888888888888888888888888888888888888888888888888888888888888888888*/

/*888888888888888888888888888888888888888888888888888888888888888888*/

//******* FIN SEGUNDA TABLA DINAMICA *******//
/*****************************************************************************/

function GuardarEnviar(){
	//alert("guardarenviar");
	formulario = document.datos;
	v_valor			= formulario.elements["datos[0][sovi_mmonto_pesos]"].value; // SOLICITUD DE GIRO
	v_presupuesto	= formulario.total_presupuesto.value;	// PRESUPUESTO

	if(v_valor==v_presupuesto){
		email();
		return true;
	}else{
		alert("El monto de la Solicitud de Viaticos ingresado debe coincidir con el total del Presupuesto");
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
	//return false;
	return true;
	}else{
		alert("Debe Ingresar un Correo Electronico.")
		return false;	
	}
	
}

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
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Solicitud de viaticos</font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				  <br>
                    <div align="center"><font size="+1">
                      <%pagina.DibujarTituloPagina()%> 
                      </font>                    </div>
					  <% if vibo_ccod="10" then %>
					<p style="font-size:12px; color=#FF0000"><strong>OBSERVACI&Oacute;N.- <%=ordc_tobservacion%></strong></p>
					<% else
						response.write "<br/></p>"
					end if %>
                    <table width="100%" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
                    <td><strong><font color="000000" size="1"> </font></strong>
				<form name="datos">
				<%f_busqueda.dibujaCampo("sovi_ncorr")%>
				<input type="hidden" name="datos[0][tsol_ccod]" value="4">
				<input type="hidden" name="busqueda[0][area_ccod]" value="<%=area_ccod%>" />	
                <input type="hidden" name="contador2" value="0"/>
				
					<table width="100%" border="1">
                      <tr> 
                        <td width="15%">Rut funcionario </td>
                        <td width="35%"> <%f_busqueda.dibujaCampo("pers_nrut")%>-<%f_busqueda.dibujaCampo("pers_xdv")%></td>
                        <td>Fecha. Pago </td>
                        <td><%f_busqueda.dibujaCampo("sovi_fpago")%> dd/mm/aaaa</td>
                      </tr>
                      <tr> 
                        <td width="15%"> Nombre funcionario </td>
                        <td width="35%"><%f_busqueda.dibujaCampo("pers_tnombre")%></td>
                        <td>Total Presupuesto </td>
                        <td><input type="text" style="background-color:#D8D8DE;border: 1px #D8D8DE solid; font-size:10px; font-style:oblique; font:bold; "  name="total_presupuesto" value="<%=v_suma_presupuesto%>" size="12" id='total_presupuesto' readonly/></td>
                      </tr>
						  <tr>
							   <td colspan="4">
										<h6>Detalle presupuesto</h6>					
									<table width="100%" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' id='tb_presupuesto'>
										<tr bgcolor='#C4D7FF' bordercolor='#999999'>
																			<th width="5%">N°</th>
																			<th width="40%">Cod. Presupuesto</th>
																			<th width="10%">Mes</th>
																			<th width="10%">Año</th>
																			<th width="15%">Valor</th>
                                                                            <th width="15%">Saldo presu</th>
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
											
<!-- 888888888888888888888888888888888888888888888888888888888888888888 -->

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
										
<!-- 888888888888888888888888888888888888888888888888888888888888888888 -->

										<td><%f_presupuesto.DibujaCampo("psol_mpresupuesto")%> </td>
<!--  888888 ** EN LA SIGUIENTE LINEA VA EL SALDO DEL PRESUPUESTO ** 88888888888888888888888888 -->	
										<td><input type="text" class="Mimetismo" name="busqueda[<%=ind%>][saldo]" size="8" value="" readonly ></td>
										<td>
												<INPUT alt="agregar fila" class=boton TYPE="button" name="agregarlinea2" value="+" onClick="validaFila2('tb_presupuesto','<%=ind%>',this);">
											    <INPUT alt="quitar una fila existente" class="boton" TYPE="button" name="quitarlinea2" value="-" onClick="eliminaFilas2()">	</td>
									</tr>	
									<%
									ind=ind+1
									wend 
									%>
									</table>
									</td>
						  </tr>	
                      <tr> 
                        <td><em><strong>Origen </strong></em></td>
                        <td><%f_busqueda.dibujaCampo("orvi_ccod")%></td>
                        <td><em><strong>Destino </strong></em></td>
                        <td><%f_busqueda.dibujaCampo("devi_ccod")%></td>
                      </tr>
                      <tr> 
                        <td><em><strong>Fecha Salida </strong></em></td>
                        <td><%f_busqueda.dibujaCampo("sovi_fsalida")%></td>
                        <td><em><strong>Fecha llegada </strong></em></td>
                        <td><%f_busqueda.dibujaCampo("sovi_fllegada")%></td>
                      </tr>
                      <tr> 
                        <td><em><strong>Hora salida </strong></em></td>
                        <td><%f_busqueda.dibujaCampo("sovi_hsalida")%>
                          (hh:mm)</td>
                        <td><em><strong>Hora llegada </strong></em></td>
                        <td><%f_busqueda.dibujaCampo("sovi_hllegada")%>
                          (hh:mm)  </td>
                      </tr>					  					  
					  
                      <tr>
                        <td><em><strong>Monto día </strong></em></td>
                        <td><%f_busqueda.dibujaCampo("sovi_mmonto_dia")%>
						<!--<input type="text" name="moneda" value="" style="background-color:#D8D8DE;border: 1px #D8D8DE solid; font-size:10px; font-style:oblique; font:bold;"></td> -->
						<input type="hidden" name="moneda" value="" style="background-color:#D8D8DE;border: 1px #D8D8DE solid; font-size:10px; font-style:oblique; font:bold;"></td> 
						<TD><em><strong>C. Costo</strong></em></TD>
						<TD>
						
						<%
						
						valor_1=f_busqueda.ObtenerValor("ccos_ncorr")
						'response.write(valor_1)
						
						%>
						
						<!-- inicio centro de costo -->
							<select name="detalle[0][ccos_ncorr]">
											<%f_centro_costo.primero%>
											<%
												while f_centro_costo.Siguiente 
												
													valor_2=f_centro_costo.ObtenerValor("ccos_ncorr")
													if trim(valor_1) = trim(valor_2) then
											%>
												<option value="<%=f_centro_costo.ObtenerValor("ccos_ncorr")%>"  selected><%=f_centro_costo.ObtenerValor("ccos_tcompuesto")%></option>
											<%
													else
											%>
												<option value="<%=f_centro_costo.ObtenerValor("ccos_ncorr")%>" ><%=f_centro_costo.ObtenerValor("ccos_tcompuesto")%></option>
											<%
													end if
											
												wend
											%>
							</select>	
						<!-- fin centro de costo -->
							
						</TD>
                      </tr>
					  
                      <tr>
                        <td><em><strong>Monto girar Origen </strong></em></td>
                        <td colspan="3"><%f_busqueda.dibujaCampo("sovi_mmonto_origen")%>
						 <!--<input type="text" name="dias" size="40" style="background-color:#D8D8DE;border: 1px #D8D8DE solid; font-size:10px; font-style:oblique; font:bold;">-->
						 <input type="hidden" name="dias" size="40" style="background-color:#D8D8DE;border: 1px #D8D8DE solid; font-size:10px; font-style:oblique; font:bold;">
						</td>
                      </tr>
                      <tr>
                        <td><em><strong>Monto a girar Pesos</strong> </em></td>
                        <td colspan="3"><%f_busqueda.dibujaCampo("sovi_mmonto_pesos")%></td>
                      </tr>
                      <tr>
                        <td><em><strong>Motivo de viatico</strong> </em></td>
                        <td colspan="3"><%f_busqueda.dibujatextarea("sovi_tmotivo")%></td>
                      </tr>					  
                    </table>
                    <br/>
					<table width="100%" border="0">
						<tr>
							<td>
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
							</td>
						</tr>
                      </table>
					</form>
                      </td>
                  </tr>
                </table>
	  <br/>
				  
				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="241" bgcolor="#D8D8DE">
				  <table width="49%" height="19"  border="0" align="center" cellpadding="0" cellspacing="0">
					<tr> <%
					'response.Write("vibo_ccod: "&vibo_ccod)
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
                  <td width="121" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="317" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td height="8" valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
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

<SCRIPT language="JavaScript">
document.datos.elements["contador2"].value = contador2;

var resul_nom='<%=resul_nombre%>'
if (resul_nom == "0") {
	alert("No existe el RUT en Softland.")	
}

</script>