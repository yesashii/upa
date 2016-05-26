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
'FECHA ACTUALIZACION 	:27/06/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ORDEN DE COMPRA
'LINEA			: 53 - 99 -148
'*******************************************************************
set pagina = new CPagina
pagina.Titulo = "Devolucion Alumno"
vibo_ccod = -1
v_dalu_ncorr	= request.querystring("busqueda[0][dalu_ncorr]")
v_rut			= request.querystring("rut")
v_dv			= request.querystring("dv")
area_ccod		= request.querystring("area_ccod")

'8888888888888888888888888888888888888888888888888888888888888888888
'ACA RESCATAMOS EL RUT DEL ALUMNO DESDE LA FUNCION "retornarut()"
rut_02 = request.FORM("rut_alumno")
'8888888888888888888888888888888888888888888888888888888888888888888

set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new cnegocio
negocio.Inicializa conectar

set conexion = new Cconexion2
conexion.Inicializar "upacifico"

set botonera = new CFormulario
botonera.carga_parametros "devolucion_alumno.xml", "botonera"

v_usuario	=	negocio.ObtenerUsuario()
v_anos_ccod	= 	conectar.consultaUno("select year(getdate())")
'vibo_ccod=0


set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "devolucion_alumno.xml", "datos_funcionario"
f_busqueda.Inicializar conectar

if  v_dalu_ncorr<>"" then

'	sql_devolucion	= " select isnull(vibo_ccod,0) as vibo_ccod,protic.trunc(dalu_fpago) as dalu_fpago, "&_
'					 " a.*,  b.pers_nrut, pers_xdv, protic.obtener_nombre_completo(a.pers_ncorr,'n') as pers_tnombre "&_   
'					 " from ocag_devolucion_alumno a, personas b  "&_
'					 " where a.pers_ncorr=b.pers_ncorr and dalu_ncorr="&v_dalu_ncorr

	sql_devolucion	= " select TOP 1 isnull(a.vibo_ccod,0) as vibo_ccod ,protic.trunc(a.dalu_fpago) as dalu_fpago "&_   
					 ", a.dalu_ncorr, a.pers_ncorr, a.dalu_mmonto_pesos, a.tdev_ccod, a.cod_pre, a.mes_ccod, a.anos_ccod, a.pers_nrut_alu, a.pers_xdv_alu "&_   
					 ", a.pers_tnombre_alu, a.carrera_alu, a.dalu_tmotivo, a.audi_tusuario, a.audi_fmodificacion, a.dalu_frecepcion, a.dalu_tobs_rechazo "&_   
					 ", a.tsol_ccod, a.area_ccod, a.ocag_fingreso, a.ocag_generador, a.ocag_frecepcion_presupuesto, a.ocag_responsable, a.ocag_baprueba "&_   
					 ", a.sede_ccod, a.ccos_ccod "&_   
					 ", b.pers_tnombre + ' ' + b.PERS_TAPE_PATERNO + ' ' + b.PERS_TAPE_MATERNO as v_nombre "&_
					 ", b.pers_tnombre + ' ' + b.PERS_TAPE_PATERNO + ' ' + b.PERS_TAPE_MATERNO as PERS_TNOMBRE "&_		
					 ", b.PERS_NCORR , b.TVIS_CCOD, b.SEXO_CCOD, b.TENS_CCOD, b.COLE_CCOD, b.ECIV_CCOD, b.PAIS_CCOD, b.PERS_BDOBLE_NACIONALIDAD "&_   
					 ", b.PERS_TAPE_PATERNO, b.PERS_TAPE_MATERNO, b.PERS_FNACIMIENTO, b.CIUD_CCOD_NACIMIENTO, b.PERS_FDEFUNCION "&_   
					 ", b.PERS_TEMPRESA, b.PERS_TFONO_EMPRESA, b.PERS_TCARGO, b.PERS_TPROFESION, b.PERS_TFONO, b.PERS_TFAX, b.PERS_TCELULAR, b.PERS_TEMAIL "&_   
					 ", b.PERS_TPASAPORTE, b.PERS_FEMISION_PAS, b.PERS_FVENCIMIENTO_PAS, b.PERS_FTERMINO_VISA, b.PERS_NNOTA_ENS_MEDIA, b.PERS_TCOLE_EGRESO "&_   
					 ", b.PERS_NANO_EGR_MEDIA, b.PERS_TRAZON_SOCIAL, b.PERS_TGIRO, b.PERS_TEMAIL_INTERNO, b.NEDU_CCOD, b.IFAM_CCOD, b.ALAB_CCOD, b.ISAP_CCOD "&_   
					 ", b.FFAA_CCOD, b.PERS_TTIPO_ENSENANZA, b.PERS_TENFERMEDADES, b.PERS_TMEDICAMENTOS_ALERGIA, b.AUDI_TUSUARIO, b.AUDI_FMODIFICACION, b.ciud_nacimiento "&_   
					 ", b.regi_particular, b.ciud_particular, b.pers_bmorosidad, b.sicupadre_ccod, b.sitocup_ccod, b.tenfer_ccod, b.descrip_tenfer, b.trabaja, b.pers_temail2 "&_   
					 ", b.pers_nrut, b.pers_xdv, asgi_tobservaciones "&_    
					 "from ocag_devolucion_alumno a "&_   
					 "INNER JOIN personas b  "&_   
					 "ON a.pers_ncorr = b.pers_ncorr  "&_   
					 "INNER JOIN ocag_autoriza_solicitud_giro oasg "&_   
					 "ON oasg.cod_solicitud = dalu_ncorr  "&_ 
					 "AND dalu_ncorr = " & v_dalu_ncorr & ""&_
					 "  and oasg.tsol_ccod = 5 ORDER BY oasg.AUDI_FMODIFICACION DESC"
				
	
	'response.write sql_devolucion
	'response.end()
	f_busqueda.Consultar sql_devolucion
	f_busqueda.Siguiente
	area_ccod=f_busqueda.obtenerValor("area_ccod")
	vibo_ccod=f_busqueda.obtenerValor("vibo_ccod")
	ocag_baprueba = f_busqueda.obtenerValor("ocag_baprueba")
	ordc_tobservacion=f_busqueda.obtenerValor("asgi_tobservaciones")
	'response.write ordc_tobservacion
	
else

	sql_devolucion	=	"select ''"
	
	f_busqueda.Consultar sql_devolucion
	f_busqueda.Siguiente
end if 

	'RESPONSE.WRITE("1. "&sql_devolucion&"<BR>")

f_busqueda.Consultar sql_devolucion
f_busqueda.Siguiente

if v_rut<>"" then
	set f_personas = new CFormulario
	f_personas.carga_parametros "tabla_vacia.xml", "tabla_vacia"
	f_personas.inicializar conexion
	'f_personas.inicializar conectar
						
	sql_datos_persona= " select CODAUX AS pers_nrut, RIGHT(RUTAUX,1) AS pers_xdv, NOMAUX AS pers_tnombre, NOMAUX AS v_nombre "&_
										" from softland.cwtauxi where cast(CodAux as varchar)='"&v_rut&"'"

'	sql_datos_persona= " SELECT PERS_NRUT, PERS_TNOMBRE pers_tnombre, PERS_TAPE_PATERNO + ' ' + PERS_TAPE_MATERNO as v_nombre "&_
'					   	" FROM PERSONAS "&_
'					   	" WHERE PERS_NRUT= '" &v_rut& "'" 
	
	'RESPONSE.WRITE("2. "&sql_datos_persona&"<BR>")
		
	f_personas.consultar sql_datos_persona
	f_personas.Siguiente

	v_pers_tnombre = f_personas.obtenerValor("pers_tnombre")
	nombre = f_personas.obtenerValor("pers_tnombre")
	
	f_busqueda.AgregaCampoCons "pers_nrut", v_rut
	f_busqueda.AgregaCampoCons "pers_xdv", v_dv
	f_busqueda.AgregaCampoCons "pers_tnombre", f_personas.obtenerValor("pers_tnombre")
	f_busqueda.AgregaCampoCons "v_nombre", f_personas.obtenerValor("v_nombre")
	
	'8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
	'88 INICIO
	
	if v_pers_tnombre="" then
	set f_personas2 = new CFormulario
	f_personas2.carga_parametros "tabla_vacia.xml", "tabla_vacia"
	'f_personas2.inicializar conexion
	f_personas2.inicializar conectar

	sql_datos_persona= " SELECT PERS_NRUT, PERS_TNOMBRE pers_tnombre, PERS_TAPE_PATERNO + ' ' + PERS_TAPE_MATERNO as v_nombre "&_
					   	"FROM PERSONAS "&_
					   	"WHERE PERS_NRUT='"&v_rut&"'"
	
	f_personas2.consultar sql_datos_persona
	f_personas2.Siguiente
						
	v_pers_tnombre = f_personas2.obtenerValor("pers_tnombre")
	nombre = f_personas2.obtenerValor("pers_tnombre")
						
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

'response.Write("<pre>"&sql_datos_persona&"</pre>")


'*****************************************************************
'***************	Inicio bases para presupuesto	**************
'set f_presupuesto = new CFormulario
'f_presupuesto.Carga_Parametros "datos_presupuesto.xml", "detalle_presupuesto"
'f_presupuesto.Inicializar conectar

'if v_dalu_ncorr<>"" then
'	sql_presupuesto="select * from ocag_presupuesto_solicitud where cast(cod_solicitud as varchar)='"&v_dalu_ncorr&"' and tsol_ccod=5"
'else
'	sql_presupuesto="select '' "
'end if	
'response.Write(sql_presupuesto)
'f_presupuesto.consultar sql_presupuesto

'v_suma_presupuesto=0
'if f_presupuesto.nrofilas>=1 and v_dalu_ncorr>=1 then
'	while f_presupuesto.Siguiente
'		v_suma_presupuesto= Clng(v_suma_presupuesto) + Clng(f_presupuesto.obtenerValor("psol_mpresupuesto"))
'	wend
'end if


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

sql_codigo_pre="(select distinct cod_pre, ' ('+cod_pre+')  ' + 'Area('+cast(cast(cod_area as numeric) as varchar)+')- '+concepto as valor "&_
			    " from presupuesto_upa.protic.presupuesto_upa_2011 	"&_
			    "	where cod_anio=2011 "&_
				"	and cod_area in (   select distinct area_ccod "&_ 
				"		 from  presupuesto_upa.protic.area_presupuesto_usuario  "&_
				"		 where rut_usuario in ("&v_usuario&") and cast(area_ccod as varchar)= '"&area_ccod&"') "&_
				" ) as tabla "

'response.Write(sql_codigo_pre)
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
sql_anos= "select anos_ccod, case when anos_ccod=year(getdate()) then 1 else 0 end as orden "&_
			" from anos where anos_ccod between year(getdate())-1 and year(getdate())+1 "&_
			" order by orden desc "
f_anos.consultar sql_anos

'if v_dalu_ncorr="" or EsVacio(v_dalu_ncorr) then
'	f_presupuesto.AgregaCampoCons "anos_ccod", v_anos_ccod
'end if	

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


 '888888888888888888888888888888888888888888888888888888888888888888
 '18-07-2013
 
set f_rut = new cFormulario
f_rut.carga_parametros "tabla_vacia.xml", "tabla_vacia"
'f_rut.inicializar conexion
f_rut.inicializar conectar

if rut_02 <> "" then

sql_datos_persona= "select isnull(protic.obtener_nombre_carrera(protic.ultima_oferta_matriculado(pers_ncorr),'CJ'), 'sin carrera') as carrera, "&_
					" protic.obtener_nombre_completo(pers_ncorr,'n') as nombre, pers_nrut, pers_xdv as digito "&_
					" from personas "&_
					" where pers_nrut="&rut_02
					
else

sql_datos_persona = "select ''"
					
end if
						
'RESPONSE.WRITE("5. :"&sql_datos_persona&"<BR>")
'RESPONSE.END()
	
f_rut.consultar sql_datos_persona
f_rut.Siguiente	
					
v_nombre	=f_rut.obtenerValor("nombre")
v_nrut		=f_rut.obtenerValor("pers_nrut")
v_xdv		=f_rut.obtenerValor("digito")
v_carrera	=f_rut.obtenerValor("carrera")

 '888888888888888888888888888888888888888888888888888888888888888888

'##################################################################
'########### agregar lista carreras y cursos + centro costo	################
 '888888888888888888888888888888888888888888888888888888888888888888
' JAIME PAINEMAL 20130717
 
 'DETALLE TIPO DE GASTOS (Cuentas Contables)
set f_detalle_tg_0 = new CFormulario
f_detalle_tg_0.Carga_Parametros "devolucion_alumno.xml", "busqueda"
f_detalle_tg_0.Inicializar conectar

f_detalle_tg_0.Consultar "select ''"
 
 
if v_nrut = "" then
rut_02=f_busqueda.obtenervalor("pers_nrut_alu")
end if

if rut_02 <> "" then

 					sql_detalle_tipo_0 = " SELECT DISTINCT "&_ 
					" a.PERS_NCORR, a.PERS_NRUT, a.PERS_XDV, a.PERS_TNOMBRE "&_ 
					", a.PERS_TAPE_PATERNO + ' ' + a.PERS_TAPE_MATERNO as v_nombre "&_ 
					", g.CARR_TDESC + ' (' + RTRIM(LTRIM(f.JORN_TDESC_CORTA)) + ')' AS CARR_CURSO "&_ 
					", H.CCOS_CCOD, I.CCOS_TCOMPUESTO, I.CCOS_TDESC "&_ 
					"FROM PERSONAS a "&_ 
					"INNER JOIN ALUMNOS b  "&_ 
					"ON a.PERS_NCORR = b.PERS_NCORR AND a.PERS_NRUT = "&rut_02&" AND b.EMAT_CCOD in (1,2,4,8,10,13) "&_ 
					"INNER JOIN ESTADOS_MATRICULAS c "&_ 
					"ON b.EMAT_CCOD = c.EMAT_CCOD "&_ 
					"INNER JOIN OFERTAS_ACADEMICAS d "&_ 
					"ON b.OFER_NCORR = d.OFER_NCORR "&_ 
					"INNER JOIN ESPECIALIDADES e "&_ 
					"ON d.ESPE_CCOD = e.ESPE_CCOD "&_ 
					"INNER JOIN JORNADAS f  "&_ 
					"ON d.JORN_CCOD = f.JORN_CCOD "&_ 
					"INNER JOIN CARRERAS g "&_ 
					"ON e.CARR_CCOD = g.CARR_CCOD "&_ 
					"INNER JOIN centros_costos_asignados H "&_ 
					"ON E.CARR_CCOD = H.cenc_ccod_carrera "&_ 
					"AND d.SEDE_CCOD = H.cenc_ccod_sede AND d.JORN_CCOD = H.cenc_ccod_jornada "&_ 
					"INNER JOIN CENTROS_COSTO I "&_ 
					"ON H.ccos_ccod = I.CCOS_CCOD "&_ 
					"UNION  "&_ 
					"SELECT DISTINCT "&_ 
  					"a.PERS_NCORR "&_ 
					", a.PERS_NRUT, a.PERS_XDV, a.PERS_TNOMBRE  "&_ 
					", a.PERS_TAPE_PATERNO + ' ' + a.PERS_TAPE_MATERNO as v_nombre "&_ 
					", H.TDET_TDESC + ' (' + RTRIM(LTRIM(E.JORN_TDESC_CORTA)) + ')' AS CARR_CURSO "&_ 
					", J.CCOS_CCOD, J.CCOS_TCOMPUESTO, J.CCOS_TDESC "&_ 
					"FROM PERSONAS a  "&_ 
					"INNER JOIN ALUMNOS b "&_ 
					"ON a.PERS_NCORR = b.PERS_NCORR AND a.PERS_NRUT = "&rut_02&" AND b.EMAT_CCOD in (1,2,4,8,10,13) "&_ 
					"INNER JOIN ESTADOS_MATRICULAS c "&_ 
					"ON b.EMAT_CCOD = c.EMAT_CCOD  "&_ 
					"INNER JOIN OFERTAS_ACADEMICAS D "&_ 
					"ON B.OFER_NCORR = D.OFER_NCORR "&_ 
					"INNER JOIN JORNADAS E "&_ 
					"ON D.JORN_CCOD = E.JORN_CCOD "&_ 
					"INNER JOIN COMPROMISOS F "&_ 
					"ON b.PERS_NCORR = F.PERS_NCORR AND F.TCOM_CCOD = 7 "&_ 
					"INNER JOIN DETALLES G "&_ 
					"ON F.COMP_NDOCTO = G.COMP_NDOCTO "&_ 
					"AND F.TCOM_CCOD = G.TCOM_CCOD AND G.inst_ccod=1 "&_ 
					"INNER JOIN TIPOS_DETALLE H "&_ 
					"ON G.TDET_CCOD = H.TDET_CCOD "&_ 
					"INNER JOIN centros_costos_asignados I "&_ 
					"ON H.TDET_CCOD = I.TDET_CCOD "&_ 
					"INNER JOIN CENTROS_COSTO J "&_ 
					"ON I.ccos_ccod = J.CCOS_CCOD "&_ 
					"UNION "&_ 
					"SELECT  0 PERS_NCORR , 0 PERS_NRUT, '' PERS_XDV, '' PERS_TNOMBRE , '' v_nombre  "&_ 
					", 'sin carrera' CARR_CURSO , 0 CCOS_CCOD, 'sin cc' CCOS_TCOMPUESTO, '' CCOS_TDESC  "

else

sql_detalle_tipo_0 = "SELECT  0 PERS_NCORR , 0 PERS_NRUT, '' PERS_XDV, '' PERS_TNOMBRE , '' v_nombre , 'sin carrera' CARR_CURSO , 0 CCOS_CCOD, 'sin cc' CCOS_TCOMPUESTO, '' CCOS_TDESC "
					
end if

'RESPONSE.WRITE("6: ."&sql_detalle_tipo_0&"<BR>")

f_detalle_tg_0.InicializaListaDependiente "busqueda", sql_detalle_tipo_0


 '##################################################################
Usuario = negocio.ObtenerUsuario()
nombre_solicitante = conectar.ConsultaUno("select protic.obtener_nombre_completo(pers_ncorr, 'n') as nombre from personas where cast(pers_nrut as varchar) = '" & Usuario & "'")
tipo_soli = "Devolucion Alumno"
n_soli=v_dalu_ncorr
 
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

<script language="JavaScript">


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
	var rut=document.getElementById("to_rut").value;
	var nombre	=document.getElementById("to_alumno");
	var digito	=document.getElementById("to_digito");
	var carrera	=document.getElementById("to_carrera");
	
	var ajax=crearAjax();
	
    ajax.open("POST", "datos_alumno.asp", true);
    ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    ajax.send("rut="+rut);
	
    ajax.onreadystatechange=function()
    {
        if (ajax.readyState==4)
        {
            var respuesta=ajax.responseXML;
            nombre.value=respuesta.getElementsByTagName("nombre")[0].childNodes[0].data;
			carrera.value=respuesta.getElementsByTagName("carrera")[0].childNodes[0].data;
			digito.value=respuesta.getElementsByTagName("digito")[0].childNodes[0].data;
			if(!nombre.value){
				alert("No existen datos asociados al rut ingresado");
				rut.value="";
				nombre.value="";
				carrera.value="";
				digito.value="";
			}
	   }
    }
}


function retornarut()
{
	document.datos.submit();
}

function solonumero(e){
       key = e.keyCode || e.which;
       tecla = String.fromCharCode(key).toLowerCase();
       letras = "1234567890";
       especiales = "8-37-39-46";

       tecla_especial = false
       for(var i in especiales){
            if(key == especiales[i]){
                tecla_especial = true;
                break;
            }
        }

        if(letras.indexOf(tecla)==-1 && !tecla_especial){
            return false;
        }
    }

function Enviar(){
	formulario = document.datos;
	v_valor			= formulario.elements["datos[0][dalu_mmonto_pesos]"].value; // SOLICITUD DE GIRO
	v_presupuesto	= formulario.total_presupuesto.value;	// PRESUPUESTO

	if(v_valor==v_presupuesto){
		return true;
	}else{
		alert("El monto de la Devolucion Alumnos ingresado debe coincidir con el total del Presupuesto");
		return false;
	}
}


function ImprimirDevolucionAlumno(){
	url="imprimir_da.asp?dalu_ncorr=<%=v_dalu_ncorr%>";
	window.open(url,'ImpresionDA', 'scrollbars=yes, menubar=no, resizable=yes, width=700,height=700');	
}


function genera_digito(rut){
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
   	document.datos.action= "devolucion_alumno.asp?rut="+texto_rut+"&dv="+IgDigitoVerificador+"&area_ccod="+v_area;
	document.datos.method = "post";
	document.datos.submit();
}



/*****************************************************************************/
//******* SEGUNDA TABLA DINAMICA   *********//
var contador2=0;

function validaFila2(id, nro,boton){
	if (document.datos.elements["presupuesto["+nro+"][psol_mpresupuesto]"].value >0){ 
		addRow2(id, nro, boton );habilitaUltimoBoton2(); 
	}else{
		alert('Debe ingresar todos los campos del presupuesto que usará');
		return false;
	}
}

function addRow2(id, nro, boton ){
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

//******** psol_mpresupuesto ***************
var td5 = document.createElement("TD");
var iElement=document.createElement("<INPUT TYPE=\"text\" name=\"presupuesto["+ contador2 +"][psol_mpresupuesto]\" size=\"10\" onblur=\"SumaTotalPresupuesto(this);\" >");
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
tbody.appendChild(row);

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
		v_valor	=	formulario.elements["presupuesto["+i+"][psol_mpresupuesto]"].value;
		//alert(formulario.elements["detalle["+i+"][dorc_nprecio_neto]"].value);
		if (v_valor){
			v_total_presupuesto = v_total_presupuesto + parseInt(v_valor);
		}
	}
	formulario.elements["total_presupuesto"].value=v_total_presupuesto;
}


  function reloadPage()
  {
    window.location.reload()
  }
  
   function RefreshPage()
  {
    window.location.reload()
  }
  
//******* FIN SEGUNDA TABLA DINAMICA *******//
/*****************************************************************************/

function GuardarEnviar(){
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
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Devolución ALUMNO</font></div></td>
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
                    <table width="100%" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
                    <td><strong><font color="000000" size="1"> </font></strong>
				
				<!-- INICIO DEL FORM -->
				
				<form name="datos" method="post">	
				
				<%f_busqueda.dibujaCampo("dalu_ncorr")%>
				<% if vibo_ccod="10" then %>
					<p style="font-size:12px; color=#FF0000"><strong>OBSERVACI&Oacute;N.- <%=ordc_tobservacion%></strong></p>
					<% else
						response.write "<br/></p>"
					end if %>
				<input type="HIDDEN" name="datos[0][tsol_ccod]" value="5">
				<input type="HIDDEN" name="busqueda[0][area_ccod]" value="<%=area_ccod%>" />
					<table width="100%" border="1">
                      <tr> 
                        <td width="11%">Rut a girar </td>
                        <td COLSPAN=3 width="27%"> <%f_busqueda.dibujaCampo("pers_nrut")%>-<%f_busqueda.dibujaCampo("pers_xdv")%></td>
                      </tr>
                      <tr> 
                        <td> Nombre a girar </td>
                        <td COLSPAN=3 ><%f_busqueda.dibujaCampo("pers_tnombre")%></td>
                      </tr>

					  <tr>
					  <td COLSPAN=4><br></td>
					  </tr>

                      <tr> 
                        <td><em><strong>Rut Alumno </strong></em></td>
                        <td COLSPAN=3> 
								<%
									if v_nrut = "" then
										'f_busqueda.dibujaCampo("pers_nrut_alu")
										v_nrut=f_busqueda.obtenervalor("pers_nrut_alu")
									end if
								%>
								<%
									if v_xdv = "" then
										'f_busqueda.dibujaCampo("pers_xdv_alu")
										v_xdv=f_busqueda.obtenervalor("pers_xdv_alu")
									end if
								%> 
								<input type="text" name="rut_alumno" size="10" id='to_rut' value="<%=v_nrut%>" onChange="retornarut();" onKeyPress="return solonumero(event)" >-
								<input type="text" name="digito" size="2" id='to_digito' value="<%=v_xdv%>" readonly>
                        </td>
					<TR>
					</TR>
                        <td><em><strong>Nombre Alumno</strong></em></td>
						<td COLSPAN=3>
								<%
									if v_nombre = "" then
										'f_busqueda.dibujaCampo("pers_tnombre_alu")
										v_nombre=f_busqueda.obtenervalor("pers_tnombre_alu")
									end if
								%>
								<input type="text" name="alumno" size="50" id='to_alumno' value="<%=v_nombre%>" readonly>
						</td>
                      </tr>

					<tr> 
                        <td><em><strong>Carrera</strong></em></td>
						<%
									' 8888888888888888888888888888888888888888888888888888888888888888888888
									' JAIME PAINEMAL 20130717
									
									'RESPONSE.WRITE("1. :"&v_carrera&"<BR>")
									
									IF v_carrera= "" THEN
										'f_busqueda.dibujaCampo("carrera_alu")
										v_carrera_02=f_busqueda.obtenervalor("carrera_alu")
										f_detalle_tg_0.agregacampocons "CARR_CURSO", v_carrera_02
									ELSE
										f_detalle_tg_0.agregacampocons "CARR_CURSO", v_carrera
										f_detalle_tg_0.agregacampocons "CCOS_CCOD", 0
									END IF
									f_detalle_tg_0.GeneraJS
									f_detalle_tg_0.siguiente
								
									 ' 8888888888888888888888888888888888888888888888888888888888888888888888
						%>
                        <td>
								<input type="hidden" name="carrera" size="50" id='to_carrera' value="<%=v_carrera%>" readonly>
								<%
								f_detalle_tg_0.DibujaCampoLista "busqueda", "CARR_CURSO"
								%>
						</td>
						<td><em><strong>C. Costo</strong></em></td>
						<td>
								<%
								'f_busqueda.dibujaCampo("ccos_ccod")
								%>
								<%
								f_detalle_tg_0.DibujaCampoLista "busqueda", "CCOS_CCOD"
								%>
						</td> 
					</tr>
					
					  <tr>
					  <td COLSPAN=4><br></td>
					  </tr>

					<tr>
					    <td width="14%">A&ntilde;o</td>
                        <td ><%f_busqueda.dibujaCampo("anos_ccod")%></td>
						
					   <td>Monto a girar</td>
					   <td><%f_busqueda.dibujaCampo("dalu_mmonto_pesos")%></td> 
					   
					<!--
						<td>Total Presupuesto</td>
						<td width="48%"><input type="text" style="background-color:#D8D8DE;border: 1px #D8D8DE solid; font-size:10px; font-style:oblique; font:bold; "  name="total_presupuesto" value="
						<%
						'=v_suma_presupuesto
						%>" size="12" id='total_presupuesto' readonly="yes"/></td>
					-->
					
					</tr>
					<tr>
                        <td>Tipo devolucion</td>
                        <td colspan=3><%f_busqueda.dibujaCampo("tdev_ccod")%></td>   
                      </tr>
                      <tr>
                        <td>Motivo de devolución </td>
                        <td colspan="3"><%f_busqueda.dibujatextarea("dalu_tmotivo")%></td>
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
					
					<!-- FIN DEL FORM -->
					
                      </td>
                  </tr>
                </table>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="241" bgcolor="#D8D8DE">
				  <table width="49%" height="19"  border="0" align="center" cellpadding="0" cellspacing="0">
					<tr>
					  <td width="30%"> <%
					  
						if vibo_ccod="0" then
							botonera.AgregaBotonParam "imprimir", "deshabilitado", "true"
						end if
						
						'if vibo_ccod = "12" or vibo_ccod = "10" or vibo_ccod = "-1" then
						
						if ((bestado_final= "S" and vibo_ccod="11" and ocag_baprueba="1" and ocag_baprueba_rector="1") or (bestado_final= "S" and vibo_ccod="6" and ocag_baprueba="1" and ocag_baprueba_rector="2")) or vibo_ccod = "12" or vibo_ccod = "10" or vibo_ccod = "-1" then
						
							botonera.AgregaBotonParam "guardar", "deshabilitado", "false"
							botonera.AgregaBotonParam "guardarenviar", "deshabilitado", "false"
							botonera.AgregaBotonParam "imprimir", "deshabilitado", "true"
						elseif vibo_ccod>="0" or resul_nombre <> "1" then
							botonera.AgregaBotonParam "guardarenviar", "deshabilitado", "true"
							botonera.AgregaBotonParam "guardar", "deshabilitado", "true"
						end if
						
					  botonera.dibujaboton "guardar"%> </td>
                      <td><%
											
						botonera.dibujaboton "guardarenviar"%></td>
					  <td><%botonera.dibujaboton "salir"%></td>
					  <td><%botonera.dibujaboton "imprimir"%></td>
					</tr>
				  </table>               </td>
                  <td width="121" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="317" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td height="8" valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<p><br>
			<p><br>
			<p><br>
		  </td>
        </tr>
      </table>	
  
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
</script>