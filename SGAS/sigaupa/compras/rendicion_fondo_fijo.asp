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
'FECHA ACTUALIZACION 	:10/07/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ORDEN DE COMPRA
'LINEA			:
'*******************************************************************
set pagina = new CPagina
pagina.Titulo = "Rendicion de Fondo Fijo"

v_ffij_ncorr	= request.querystring("cod_solicitud")
v_rffi_ncorr	= request.querystring("rffi_ncorr")

'RESPONSE.WRITE("v_ffij_ncorr: "&v_ffij_ncorr&"<BR>")
'RESPONSE.WRITE("v_rffi_ncorr: "&v_rffi_ncorr&"<BR>")

set botonera = new CFormulario
botonera.carga_parametros "rendicion_fondo_fijo.xml", "botonera"

set conectar = new cconexion
conectar.inicializar "upacifico"

set conexion = new CConexion2
conexion.Inicializar "upacifico"

set negocio = new cnegocio
negocio.Inicializa conectar

v_usuario=negocio.ObtenerUsuario()
v_anos_ccod	= 	conectar.consultaUno("select year(getdate())")

' 888888888888888888888888888888888888888888888888888888888888888888888888888888888888

if v_rffi_ncorr="" or EsVacio(v_rffi_ncorr) then
	v_rffi_ncorr=conectar.consultaUno("select top 1 rffi_ncorr from ocag_rendicion_fondo_fijo where ffij_ncorr="&v_ffij_ncorr)

	if v_rffi_ncorr<>"" then

	set f_busqueda2 = new CFormulario
	f_busqueda2.Carga_Parametros "rendicion_fondo_fijo.xml", "datos_solicitud_2"
	f_busqueda2.Inicializar conectar

	rendicion_fondos_rendir="select rffi_ncorr, ffij_ncorr, vibo_ccod, ocag_baprueba , ocag_baprueba_rector from ocag_rendicion_fondo_fijo where rffi_ncorr="&v_rffi_ncorr

	
	f_busqueda2.Consultar rendicion_fondos_rendir
	f_busqueda2.Siguiente
						
	ffij_ncorr=f_busqueda2.obtenerValor("ffij_ncorr")		
	ocag_baprueba=f_busqueda2.obtenerValor("ocag_baprueba")	
	ocag_baprueba_rector=f_busqueda2.obtenerValor("ocag_baprueba_rector")		
	rffi_ncorr=f_busqueda2.obtenerValor("rffi_ncorr")	
	vibo_ccod=f_busqueda2.obtenerValor("vibo_ccod")			
	
	END IF

end if

' 888888888888888888888888888888888888888888888888888888888888888888888888888888888888

set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "rendicion_fondo_fijo.xml", "datos_solicitud"
f_busqueda.Inicializar conectar

	if  v_ffij_ncorr<>"" then
	
'		sql_fondo_rendir	= " select protic.trunc(ffij_fpago) as ffij_fpago,* "&_
'							  " from ocag_fondo_fijo a, personas c "&_
'							  "	where a.pers_ncorr=c.pers_ncorr and a.ffij_ncorr="&v_ffij_ncorr

		sql_fondo_rendir	= " select protic.trunc(a.ffij_fpago) as ffij_fpago "&_
							  ", a.ffij_ncorr, a.pers_ncorr, a.ffij_mmonto_pesos, a.area_ccod, a.cod_pre, a.ffij_tdetalle_presu, a.mes_ccod, a.anos_ccod "&_
							  ", a.audi_tusuario, a.audi_fmodificacion, a.vibo_ccod, a.ffij_frecepcion, a.ffij_tobs_rechazo, a.tsol_ccod, a.pers_nrut_aut, a.tmon_ccod "&_
							  ", a.ocag_fingreso, a.ocag_generador, a.ocag_frecepcion_presupuesto, a.ocag_responsable, a.ocag_baprueba, a.sede_ccod "&_
							  ", c.PERS_NCORR, c.TVIS_CCOD, c.SEXO_CCOD, c.TENS_CCOD, c.COLE_CCOD, c.ECIV_CCOD, c.PAIS_CCOD, c.PERS_BDOBLE_NACIONALIDAD, c.PERS_NRUT "&_ 
							" , LTRIM(RTRIM(c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO)) as v_nombre "&_
							" , LTRIM(RTRIM(c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO + ' ' + c.PERS_TAPE_MATERNO)) as PERS_TNOMBRE "&_	
							  ", c.PERS_XDV, c.PERS_TAPE_PATERNO, c.PERS_TAPE_MATERNO, c.PERS_FNACIMIENTO, c.CIUD_CCOD_NACIMIENTO, c.PERS_FDEFUNCION "&_
							  ", c.PERS_TEMPRESA, c.PERS_TFONO_EMPRESA, c.PERS_TCARGO, c.PERS_TPROFESION, c.PERS_TFONO, c.PERS_TFAX, c.PERS_TCELULAR, c.PERS_TEMAIL "&_
							  ", c.PERS_TPASAPORTE, c.PERS_FEMISION_PAS, c.PERS_FVENCIMIENTO_PAS, c.PERS_FTERMINO_VISA, c.PERS_NNOTA_ENS_MEDIA, c.PERS_TCOLE_EGRESO "&_
							  ", c.PERS_NANO_EGR_MEDIA, c.PERS_TRAZON_SOCIAL, c.PERS_TGIRO, c.PERS_TEMAIL_INTERNO, c.NEDU_CCOD, c.IFAM_CCOD, c.ALAB_CCOD, c.ISAP_CCOD "&_
							  ", c.FFAA_CCOD, c.PERS_TTIPO_ENSENANZA, c.PERS_TENFERMEDADES, c.PERS_TMEDICAMENTOS_ALERGIA, c.AUDI_TUSUARIO, c.AUDI_FMODIFICACION "&_
							  ", c.ciud_nacimiento, c.regi_particular, c.ciud_particular, c.pers_bmorosidad, c.sicupadre_ccod, c.sitocup_ccod, c.tenfer_ccod "&_
							  ", c.descrip_tenfer, c.trabaja, c.pers_temail2 "&_
							  ", c.pers_tnombre + ' ' + c.PERS_TAPE_PATERNO as pers_tnombre_aut "&_
							  "from ocag_fondo_fijo a "&_
							  "INNER JOIN personas c  "&_
							  "ON a.pers_ncorr = c.pers_ncorr  "&_
							  "and a.ffij_ncorr = "&v_ffij_ncorr

		f_busqueda.Consultar sql_fondo_rendir
		f_busqueda.Siguiente
				
		'vibo_ccod=conectar.consultaUno("select vibo_ccod from ocag_rendicion_fondo_fijo where ffij_ncorr = "&v_ffij_ncorr)
						 
	area_ccod=f_busqueda.obtenerValor("area_ccod")
	area_tdesc=conectar.consultaUno("select area_tdesc from presupuesto_upa.protic.area_presupuestal where area_ccod="&area_ccod)
		
	v_tiene_detalle=conectar.consultaUno("select count(*) from ocag_detalle_rendicion_fondo_fijo where ffij_ncorr ="&v_ffij_ncorr)
		
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
		sql_fondo_rendir	=	" select '' "
		f_busqueda.Consultar sql_fondo_rendir
		f_busqueda.Siguiente

		v_tiene_detalle=0
	end if
	
	'RESPONSE.WRITE("1. :"&sql_fondo_rendir&"<BR>")

'*****************************************************************
'***************	Inicio bases para presupuesto	**************
set f_presupuesto = new CFormulario
f_presupuesto.Carga_Parametros "datos_presupuesto.xml", "detalle_presupuesto"
f_presupuesto.Inicializar conectar

if v_ffij_ncorr<>"" then
	
	'sql_presupuesto="select * from ocag_presupuesto_solicitud where cast(cod_solicitud as varchar)=' " &v_ffij_ncorr&"' and tsol_ccod=6"
	
	sql_presupuesto="select psol_ncorr, tsol_ccod, cod_solicitud, cod_pre, mes_ccod, anos_ccod, psol_mpresupuesto "&_
							  ", audi_tusuario, audi_fmodificacion, psol_brendicion, cod_solicitud_origen "&_
							  "from ocag_presupuesto_solicitud "&_
							  "where cast(cod_solicitud as varchar)= '" &v_ffij_ncorr&"'"&_
							  "and tsol_ccod=6"
		
else
	sql_presupuesto="select '' "
end if	

'RESPONSE.WRITE("2. :"&sql_presupuesto&"<BR>")

f_presupuesto.consultar sql_presupuesto

v_suma_presupuesto=0
if f_presupuesto.nrofilas>=1 and v_ffij_ncorr>=1 then
	while f_presupuesto.Siguiente
		v_suma_presupuesto= Clng(v_suma_presupuesto) + Clng(f_presupuesto.obtenerValor("psol_mpresupuesto"))
	wend
end if

set f_cod_pre = new CFormulario
f_cod_pre.carga_parametros "orden_compra.xml", "codigo_presupuesto"
'f_cod_pre.carga_parametros "fondos_rendir.xml", "codigo_presupuesto"
f_cod_pre.inicializar conexion
f_cod_pre.consultar "select '' "

'sql_codigo_pre="(select distinct cod_pre, 'Area('+cast(cast(cod_area as numeric) as varchar)+')-'+concepto +' ('+cod_pre+')' as valor "&_
'			    " from presupuesto_upa.protic.presupuesto_upa_2011 	"&_
'			    "	where cod_anio=2011 "&_
'				"	and cod_area in (   select distinct area_ccod "&_ 
'				"		 from  presupuesto_upa.protic.area_presupuesto_usuario  "&_
'				"		 where rut_usuario in ("&v_usuario&") and cast(area_ccod as varchar)= '"&area_ccod&"') "&_
'				" ) as tabla "

sql_codigo_pre="(select distinct cod_pre, ' ('+cod_pre+') '  + 'Area('+cast(cast(cod_area as numeric) as varchar)+')-'+concepto as valor "&_
			    " from presupuesto_upa.protic.presupuesto_upa_2011 	"&_
			    "	where cod_anio=2011 "&_
				"	and cod_area in (   select distinct area_ccod "&_ 
				"		 from  presupuesto_upa.protic.area_presupuesto_usuario  "&_
				"		 where rut_usuario in ("&v_usuario&") and cast(area_ccod as varchar)= '"&area_ccod&"') "&_
				" ) as tabla "

'RESPONSE.WRITE("3. :"&sql_codigo_pre&"<BR>")

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

'*****************************************************************
'***************	Fin bases para presupuesto	******************

set f_buscador = new CFormulario
f_buscador.Carga_Parametros "consultas.xml", "buscador"
f_buscador.Inicializar conectar
f_buscador.Consultar " select '' "
f_buscador.Siguiente

f_buscador.agregaCampoCons "solicitud", v_ffij_ncorr

set f_tipo_docto = new CFormulario
f_tipo_docto.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_tipo_docto.inicializar conectar
sql_tipo_docto= "Select * from ocag_tipo_documento where tdoc_ccod not in (1) order by tdoc_tdesc asc"
f_tipo_docto.consultar sql_tipo_docto

set f_tipo_gasto = new CFormulario
f_tipo_gasto.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_tipo_gasto.inicializar conectar
sql_tipo_gasto= "Select * from ocag_tipo_gasto order by tgas_tdesc desc"
f_tipo_gasto.consultar sql_tipo_gasto

set f_detalle = new CFormulario
f_detalle.Carga_Parametros "rendicion_fondo_fijo.xml", "detalle_rendicion"
f_detalle.Inicializar conectar

if v_ffij_ncorr<>"" and v_tiene_detalle>=1 then
	
	'sql_detalle_pago= "select protic.trunc(rffi_fdocto) as rffi_fdocto, * from ocag_rendicion_fondo_fijo where ffij_ncorr ="&v_ffij_ncorr

	sql_detalle_pago= "select protic.trunc(rffi_fdocto) as drff_fdocto  "&_
									" , rffi_ncorr as rffi_ncorr, tdoc_ccod, rffi_ndocto as drff_ndocto, pers_nrut, pers_xdv, tgas_ccod, rffi_tdesc as drff_tdesc, "&_ 
									" rffi_mretencion as drff_mretencion , cast(rffi_mmonto as numeric) as drff_mdocto, ffij_ncorr, audi_tusuario, audi_fmodificacion "&_
									" , ocag_fingreso, ocag_generador, ocag_responsable, vibo_ccod, ocag_baprueba, tsol_ccod, ocag_frecepcion_presupuesto, sede_ccod   "&_
									" from ocag_rendicion_fondo_fijo  "&_
									" where ffij_ncorr = "&v_ffij_ncorr

'response.Write(sql_detalle_pago)
	sql_detalle_pago= "select protic.trunc(drff_fdocto) as drff_fdocto  "&_
									" ,rffi_ncorr, tdoc_ccod, drff_ndocto, pers_nrut, pers_xdv, tgas_ccod, drff_tdesc, drff_mretencion, cast(drff_mdocto as numeric) drff_mdocto, ffij_ncorr, audi_tusuario, audi_fmodificacion "&_
									" from ocag_detalle_rendicion_fondo_fijo  "&_
									" where ffij_ncorr = "&v_ffij_ncorr
	
else
	sql_detalle_pago= "select 0 as drff_mdocto "
end if	

'RESPONSE.WRITE("4. :"&sql_detalle_pago&"<BR>")

f_detalle.Consultar sql_detalle_pago
'response.End()

if v_ffij_ncorr="" or EsVacio(v_ffij_ncorr) then
	f_presupuesto.AgregaCampoCons "anos_ccod", v_anos_ccod
end if


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
'response.Write(sql_responsable)
Usuario = negocio.ObtenerUsuario()
nombre_solicitante = conectar.ConsultaUno("select protic.obtener_nombre_completo(pers_ncorr, 'n') as nombre from personas where cast(pers_nrut as varchar) = '" & Usuario & "'")
tipo_soli = "Rendicion de Fondo Fijo"
n_soli=v_ffij_ncorr
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

function Enviar(){
	//validar campos vacios
	return true;
}

function ImprimirRendicionFondoFijo(){
	url="imprimir_rendicion_ff.asp?ffij_ncorr=<%=v_ffij_ncorr%>";
	window.open(url,'ImpresionRFF', 'scrollbars=yes, menubar=no, resizable=yes, width=700,height=700');	
}

function crearAjax(){
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

function ValidaRut(objeto)
{
    var run=objeto.value;
    var ajax=crearAjax();
    ajax.open("POST", "procesador.asp", true);
    ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    ajax.send("run="+run);
    ajax.onreadystatechange=function()
    {
        if (ajax.readyState==4)
        {
            var respuesta=ajax.responseXML;
            if(!respuesta.getElementsByTagName("funcionario")[0].childNodes[0].data){
				alert("El rut ingresado ("+objeto.value+") no existe en el sistema Softland. \nDebe solicitar que se ingrese antes de emitir esta solicitud");
				objeto.value="";
			}
	   }
    }
}

function Habilita(objeto){
	v_valor=objeto.value;
	v_indice=extrae_indice(objeto.name);
	if ((v_valor==2)||(v_valor==3)){
		document.datos.elements["detalle["+v_indice+"][pers_nrut]"].disabled=true;
		document.datos.elements["detalle["+v_indice+"][pers_xdv]"].disabled=true;
	}else{
		document.datos.elements["detalle["+v_indice+"][pers_nrut]"].disabled=false;
		document.datos.elements["detalle["+v_indice+"][pers_xdv]"].disabled=false;
	}
}

//************************************************************************
<%
v_indice=f_detalle.nrofilas
if v_indice=0 then
	v_indice=v_indice+1
end if
%>
var contador=<%=v_indice-1%>;

function validaFila(id, nro,boton)
{
	if (document.datos.elements["detalle["+nro+"][drff_mdocto]"].value == '')
      {alert('Debe ingresar un monto válido en el detalle');}

	if (document.datos.elements["detalle["+nro+"][drff_ndocto]"].value != '')
	  {addRow(id, nro, boton );habilitaUltimoBoton();}
     else
      {alert('Debe completar las filas del detalle para ingresar una rendición válida');}

//addRow(id, nro, boton );bloqueaFila(nro);
}

function eliminaFilas()
{
var check=document.datos.getElementsByTagName('input');
var cantidadCheck=0;
var checkbox=new Array();
var tabla = document.getElementById('tb_busqueda_');

 for (y=0;y<check.length;y++){if (check[y].type=="checkbox"){checkbox[cantidadCheck++]=check[y];}}
	for (x=0;x<cantidadCheck;x++){
		  if (checkbox[x].checked) {deleterow(checkbox[x]);}
	 }
 /*if (tabla.tBodies[0].rows.length < 2)
    {addRow('tb_busqueda_', cantidadCheck, 0 );}
*/
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
/*contador= contador + 1;
var tbody = document.getElementById(id).getElementsByTagName("TBODY")[0];
var row = document.createElement("TR");
row.align="center";

//********  1 Nro de ********************
var td1 = document.createElement("TD");
var aElement=document.createElement("<INPUT TYPE=\"checkbox\" name=\"check\" value=\""+ contador +"\"  >");
td1.appendChild (aElement);

//******** 2 drff_fdocto********************
var td2 = document.createElement("TD");
var iElement=document.createElement("<INPUT TYPE=\"text\" name=\"detalle["+ contador +"][drff_fdocto]\" size=\"10\" maxlength=\"10\">");
td2.appendChild (iElement)

//******** 3 tdoc_ccod********************
var td3 = document.createElement("TD");
var iElement=document.createElement("select");
iElement.name="detalle["+ contador +"][tdoc_ccod]";
i=0;
<%	while f_tipo_docto.Siguiente %>
i=i+1;
	var v_option=document.createElement("Option");
	v_option.value=<%=f_tipo_docto.ObtenerValor("tdoc_ccod")%>;// Valor del option
	v_option.innerHTML='<%=f_tipo_docto.ObtenerValor("tdoc_tdesc")%>'; // texto del option
	iElement.appendChild(v_option);
<%wend%>	
td3.appendChild (iElement)


//******** 4 drff_ndocto********************
var td4 = document.createElement("TD");
var iElement=document.createElement("<INPUT TYPE=\"text\" name=\"detalle["+ contador +"][drff_ndocto]\" size=\"10\" maxlength=\"10\">");
td4.appendChild (iElement)



//********tgas_ccod********************
var td6 = document.createElement("TD");
var iElement=document.createElement("Select");
iElement.name="detalle["+ contador +"][tgas_ccod]";
i=0;
<%	while f_tipo_gasto.Siguiente %>
i=i+1;
	var v_option=document.createElement("Option");
	v_option.value=<%=f_tipo_gasto.ObtenerValor("tgas_ccod")%>;// Valor del option
	v_option.innerHTML='<%=f_tipo_gasto.ObtenerValor("tgas_tdesc")%>'; // texto del option
	iElement.appendChild(v_option);	
<%wend%>	
td6.appendChild (iElement);

//********drff_tdesc********************
var td7 = document.createElement("TD");
var iElement=document.createElement("<INPUT TYPE=\"text\" name=\"detalle["+ contador +"][drff_tdesc]\" size=\"30\" >");
td7.appendChild (iElement)

//********drff_mdocto********************
var td8 = document.createElement("TD");
var iElement=document.createElement("<INPUT TYPE=\"text\" name=\"detalle["+ contador +"][pers_nrut]\" size=\"10\" onblur=\"ValidaRut(this)\" maxlength=\"10\">");
td8.appendChild (iElement)

//********drff_mdocto********************
var td9 = document.createElement("TD");
var iElement=document.createElement("<INPUT TYPE=\"text\" name=\"detalle["+ contador +"][drff_mdocto]\" size=\"10\" onblur=\"CalculaTotal(this)\" maxlength=\"10\">");
td9.appendChild (iElement)

//********Agregar********************
var td10 		= 	document.createElement("TD");
var iElement 	=	document.createElement("<INPUT class=boton TYPE=\"button\" name=\"agregarlinea\" value=\"+\" onclick=\"validaFila('tb_busqueda_',"+contador+",this)\">");
var iElement2 	=	document.createElement("<INPUT class=boton TYPE=\"button\" name=\"quitarlinea\" value=\"-\" onclick=\"eliminaFilas()\">");
td10.appendChild (iElement)
td10.appendChild (iElement2)


row.appendChild(td1);
row.appendChild(td2);
row.appendChild(td3);
row.appendChild(td4);
row.appendChild(td6);
row.appendChild(td7);
row.appendChild(td8);
row.appendChild(td9);
row.appendChild(td10);
tbody.appendChild(row);*/
contador++;

$("#tb_busqueda_detalle").append("<tr><td><INPUT TYPE=\"checkbox\" name=\"check\" value=\""+ contador +"\"  ></td>"+
"<td><INPUT TYPE=\"text\" name=\"detalle["+ contador +"][drff_fdocto]\" size=\"10\" maxlength=\"10\"></td>"+
"<td><select name= \"detalle["+ contador +"][tdoc_ccod]\">"+
"	<%f_tipo_docto.primero%> "+
" <%while f_tipo_docto.Siguiente %>"+
"<option value=\"<%=f_tipo_docto.ObtenerValor("tdoc_ccod")%>\" ><%=f_tipo_docto.ObtenerValor("tdoc_tdesc")%></option>"+
"<%wend%>"+
"</select></td>"+
"<td><INPUT TYPE=\"text\" name=\"detalle["+ contador +"][drff_ndocto]\" size=\"10\" maxlength=\"10\"></td>"+
"<td><select name= \"detalle["+ contador +"][tgas_ccod]\">"+
"<%f_tipo_gasto.primero%>"+
"	<%while f_tipo_gasto.Siguiente %>"+
"<option value=\"<%=f_tipo_gasto.ObtenerValor("tgas_ccod")%>\" ><%=f_tipo_gasto.ObtenerValor("tgas_tdesc")%></option>"+
"<%wend%>"+
"</select></td>"+
"<td align=\"center\"><INPUT TYPE=\"text\" name=\"detalle["+ contador +"][drff_tdesc]\" size=\"30\" ></td>"+
"<td align=\"center\"><INPUT TYPE=\"text\" name=\"detalle["+ contador +"][pers_nrut]\" size=\"10\" onblur=\"ValidaRut(this);genera_digito(this.value,"+ contador +");CopiaNombre(this.form)\" maxlength=\"8\"></td>"+
"<td align=\"center\"><input name=\"detalle["+ contador +"][pers_xdv]\" id=\"TO-N\" onBlur=\"CopiaNombre(this.form);\" type=\"text\" size=\"2\" maxlength=\"1\"></td>"+
"<td><INPUT TYPE=\"text\" name=\"detalle["+ contador +"][drff_mdocto]\" size=\"10\" onblur=\"CalculaTotal(this)\" maxlength=\"10\"></td>"+
"<td align=\"center\"><INPUT class=boton TYPE=\"button\" id=\"agregarlinea\" name=\"agregarlinea\" value=\"+\" onclick=\"validaFila('tb_busqueda_detalle',"+contador+",this)\">&nbsp;"+
"<INPUT class=boton TYPE=\"button\" name=\"quitarlinea\" value=\"-\" onclick=\"eliminaFilas()\"></td></tr>");


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

function CalculaTotal(valor)
{
	//alert("aaaaaa");
	var formulario = document.forms["datos"];
	v_total_solicitud = 0;
	for (i=0;i <= contador; i++){

			 v_monto		=	formulario.elements["detalle["+i+"][drff_mdocto]"].value;
		 	if (!v_monto){
				v_monto=0;
				formulario.elements["detalle["+i+"][drff_mdocto]"].value=0;
			}
			if (v_monto){
				v_total_solicitud = v_total_solicitud + parseInt(v_monto);
			}
	}
	
	datos.rendicion.value	=	eval(v_total_solicitud);
}

// 10-07-2013
//88888888888888888888888888888888888888888888888888888

function genera_digito (rut,contador){

	if(contador ==undefined){
		contador = 0;
	}
	
 var IgStringVerificador, IgN, IgSuma, IgDigito, IgDigitoVerificador, rut;
 var texto_rut = new String(rut);
 var posicion_guion = 0;
 v_area		=	'<%=area_ccod%>';
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
	
		datos.elements["detalle["+ contador +"][pers_xdv]"].value=IgDigitoVerificador;
		//document.datos.action= "rendicion_fondo_fijo.asp?rut="+texto_rut+"&dv="+IgDigitoVerificador+"&area_ccod="+v_area;
		//document.datos.method = "post";
		//document.datos.submit();
}

function CopiaNombre(){
	/*var formulario = document.forms["datos"];
	formulario.pers_nrut.value=formulario.elements["datos[0][pers_nrut]"].value;
	formulario.pers_xdv.value=formulario.elements["datos[0][pers_xdv]"].value;
	formulario.funcionario.value=formulario.elements["datos[0][pers_tnombre]"].value;
	*/
}

function GuardarEnviar(){
	//alert(document.datos.elements["email"].value);
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

//88888888888888888888888888888888888888888888888888888

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
            		<td><%pagina.DibujarLenguetas Array("Rendicion Fondo Fijo"), 1 %></td>
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
                        
                          <input type="hidden" name="rffi_ncorr" value="<%=v_rffi_ncorr%>">	
                          <input type="hidden" name="pers_nrut" value="<%=f_busqueda.ObtenerValor("pers_nrut")%>">	
						  

						<table width="95%" border="1" align="center">
							  <tr> 
								<td width="11%"><strong>Rut funcionario</strong> </td>
								<td width="27%"> <%f_busqueda.dibujaCampo("pers_nrut")%>-<%f_busqueda.dibujaCampo("pers_xdv")%></td>
								<td width="14%"><strong>Area</strong></td>
								<td><%=area_tdesc%></td>
							  </tr>
							  <tr> 
								<td> <strong>Nombre funcionario</strong> </td>
								<td>
								<%
								f_busqueda.dibujaCampo("pers_tnombre")
								%>&nbsp;<%
								'f_busqueda.dibujaCampo("v_nombre")
								%>
								</td>
								<td><strong>Fecha Pago</strong></td>
								<td width="48%"><%f_busqueda.dibujaCampo("ffij_fpago")%></td>
							  </tr>
							  <tr> 
								<td><strong>Monto Solicitado </strong> </td>
								<td><%f_busqueda.dibujaCampo("ffij_mmonto_pesos")%></td>
								<td><strong>Total Presupuesto</strong> </td>
								<td><input type="text" style="background-color:#D8D8DE;border: 1px #D8D8DE solid; font-size:10px; font-style:oblique; font:bold; "  name="total_presupuesto" value="<%=v_suma_presupuesto%>" size="12" id='total_presupuesto' readonly/></td>
							  </tr>
							  <tr>
							  <td colspan="4">
							  
							  		<h5>Detalle presupuesto</h5>					
									<table width="100%" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' id=tb_presupuesto>
										<tr bgcolor='#C4D7FF' bordercolor='#999999'>
											<th width="50%">Cod. Presupuesto</th>
											<th width="12%">Mes</th>
											<th width="12%">Año</th>
											<th width="16%">Valor</th>
										</tr>
									<% ind=0
									f_presupuesto.primero
									while f_presupuesto.Siguiente 
									v_cod_pre=f_presupuesto.ObtenerValor("cod_pre")
									%>
									<tr align="left" bgcolor="#FFFFFF">
										<td>
												<%
												f_cod_pre.primero
												while f_cod_pre.Siguiente 
													if Cstr(f_cod_pre.ObtenerValor("cod_pre"))=Cstr(v_cod_pre) then
														response.Write(f_cod_pre.ObtenerValor("valor"))
													end if
												wend
												%>
											</td>
										<td><% 
										f_presupuesto.AgregaCampoParam "mes_ccod", "permiso", "ESCRITURA"
										f_presupuesto.DibujaCampo("mes_ccod")%> </td>
										<td><%
										f_presupuesto.AgregaCampoParam "anos_ccod", "permiso", "ESCRITURA"
										f_presupuesto.DibujaCampo("anos_ccod")%> </td>
										<td><%
										f_presupuesto.AgregaCampoParam "psol_mpresupuesto", "permiso", "ESCRITURA"
										f_presupuesto.DibujaCampo("psol_mpresupuesto")%> </td>
									</tr>	
									<%
									ind=ind+1
									wend 
									%>
									</table>							  </td>
							  </tr>
							</table>
							<br>
							<hr>	
						  
                  
                     <%f_busqueda.dibujaCampo("ffij_ncorr")%>											  
                    <table width="100%" align="center" cellpadding="0" cellspacing="0" >
					  <tr> 
						<td>
						  <table width="100%" border="0">
							<tr> 
							  <td>
							  <table width="100%" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' id=tb_busqueda_detalle>
									<tr bgcolor='#C4D7FF' bordercolor='#999999'>
										<th>N°</th>
										<th>Fecha Docto </th>
										<th>Tipo Docto </th>
										<th>N&deg;Docto</th>
										<th>Tipo Gasto</th>
										<th>Descripcion Gasto</th>
										<th>Rut proveedor</th>
										<th>Dv proveedor</th>
										<th>Monto</th>
										<th>(+/-)</th>
									</tr>
									<%
								if f_detalle.nrofilas >=1 then
									ind=0
									v_total_rendido=0
									while f_detalle.Siguiente %>
									<tr>
										<th><input type="checkbox" name="detalle[<%=ind%>][checkbox]" value=""></th>
										<td align="center"><%f_detalle.DibujaCampo("drff_fdocto")%></td>
										<td align="center"><%f_detalle.DibujaCampo("tdoc_ccod")%> </td>
										<td align="center"><%f_detalle.DibujaCampo("drff_ndocto")%> </td>
										<td align="center"><%f_detalle.DibujaCampo("tgas_ccod")%> </td>
										<td align="center"><%f_detalle.DibujaCampo("drff_tdesc")%> </td>
										<td align="center"><%f_detalle.DibujaCampo("pers_nrut")%> </td>
										<td align="center"><%f_detalle.DibujaCampo("pers_xdv")%> </td>
										<td align="center"><%f_detalle.DibujaCampo("drff_mdocto")%> </td>
										<td align="center">
                                        		<INPUT alt="agregar una nueva fila" class=boton TYPE="button" name="agregarlinea" value="+" onClick="validaFila('tb_busqueda_','<%=ind%>',this)">
												<INPUT alt="quitar una fila existente" class=boton TYPE="button" name="quitarlinea" value="-" onClick="eliminaFilas()"></td>							
									</tr>	
									<%
									'v_total_rendido=v_total_rendido+Cint(f_detalle.ObtenerValor("drff_mdocto"))
									v_total_rendido=v_total_rendido+cDbl(f_detalle.ObtenerValor("drff_mdocto"))
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
									<td width="8%" align="right"><input type="text" name="rendicion" value="<%=v_total_rendido%>"  size="10" id='NU-N'/></td>	
								</tr>
								<tr>
									<th width="92%" align="right">Total Asignado</th>
									<td width="8%" align="right"><input type="text" name="asignado" value="<%=f_busqueda.ObtenerValor("ffij_mmonto_pesos")%>" size="10" id='NU-N'/></td>	
								</tr>					
							</table>

					</td>
				  </tr>
                </table>
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
				 </form>
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
					  
					'if vibo_ccod="0" then
					'	botonera.AgregaBotonParam "imprimir", "deshabilitado", "true"
					'end if
						
					'if vibo_ccod>"0" then
					'	botonera.AgregaBotonParam "guardar2", "deshabilitado", "true"
					'end if	
						
					'if vibo_ccod = "12" then
					'	botonera.AgregaBotonParam "guardar2", "deshabilitado", "false"
					'end if	
					  
					'if vibo_ccod>"0" then
					'	botonera.AgregaBotonParam "guardarenviar", "deshabilitado", "true"
					'end if					
						
					'if vibo_ccod = "12" then
					'	botonera.AgregaBotonParam "guardarenviar", "deshabilitado", "false"
					'end if
						
				IF rfre_ncorr="" AND ocag_baprueba="" AND ocag_baprueba_rector="" AND rffi_ncorr="" AND vibo_ccod="" THEN

				botonera.AgregaBotonParam "guardar2", "deshabilitado", "false"
				botonera.AgregaBotonParam "guardarenviar", "deshabilitado", "false"
				botonera.AgregaBotonParam "imprimir", "deshabilitado", "true"
				ELSE	
				IF v_rffi_ncorr="" or vibo_ccod="7" or vibo_ccod="12" THEN

					botonera.AgregaBotonParam "guardar2", "deshabilitado", "false"
					botonera.AgregaBotonParam "guardarenviar", "deshabilitado", "false"
					botonera.AgregaBotonParam "imprimir", "deshabilitado", "true"
					ELSE
						IF vibo_ccod>="0" AND ocag_baprueba="5"	then

						botonera.AgregaBotonParam "guardar2", "deshabilitado", "false"
						botonera.AgregaBotonParam "guardarenviar", "deshabilitado", "false"
						botonera.AgregaBotonParam "imprimir", "deshabilitado", "true"
						ELSE

						botonera.AgregaBotonParam "guardar2", "deshabilitado", "true"
						botonera.AgregaBotonParam "guardarenviar", "deshabilitado", "true"
						botonera.AgregaBotonParam "imprimir", "deshabilitado", "true"
						END IF
					END IF
				END IF
						%>
                        <td width="21%">&nbsp;</td>
						<td width="31%"><% botonera.dibujaboton "guardar2"%> </td>
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
