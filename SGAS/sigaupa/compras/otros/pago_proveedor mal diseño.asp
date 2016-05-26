<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Solicitud de Pago a Proveedor"

v_ordc_ndocto	= request.querystring("busqueda[0][ordc_ndocto]")
v_sogi_ncorr	= request.querystring("busqueda[0][sogi_ncorr]")
area_ccod		= request.querystring("area_ccod")
v_rut			= request.querystring("rut")
v_dv			= request.querystring("dv")
 
set botonera = new CFormulario
botonera.carga_parametros "pago_proveedor.xml", "botonera"


set negocio 	= new Cnegocio
set formulario 	= new Cformulario

set conectar 	= new Cconexion
conectar.inicializar "upacifico"

set conexion = new Cconexion2
conexion.Inicializar "upacifico"

negocio.inicializa conectar
sede=negocio.obtenerSede
v_usuario = negocio.ObtenerUsuario()




'******************************************************
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "pago_proveedor.xml", "datos_proveedor"
 f_busqueda.Inicializar conectar
 sql_datos_solicitud= "select ''"

	v_boleta=2	
 	
	if v_sogi_ncorr <>"" then

		sql_datos_solicitud= "select protic.trunc(sogi_fecha_solicitud) as sogi_fecha_solicitud,* from ocag_solicitud_giro a, personas c "&_
						 "	where a.pers_ncorr_proveedor=c.pers_ncorr and a.sogi_ncorr="&v_sogi_ncorr
	
		f_busqueda.Consultar sql_datos_solicitud
		f_busqueda.Siguiente

		sql_detalle_pago= "select b.* from ocag_solicitud_giro a, ocag_detalle_solicitud_giro b "&_
					 "	where a.sogi_ncorr=b.sogi_ncorr "&_
					 "	and a.sogi_ncorr="&v_sogi_ncorr

	else
		if v_ordc_ndocto <>"" then
			sql_datos_orden= " Select top 1 protic.trunc(fecha_solicitud) as sogi_fecha_solicitud,pers_nrut,pers_xdv,* "&_
							 " from ocag_orden_compra a, personas b where a.pers_ncorr=b.pers_ncorr and a.ordc_ndocto="&v_ordc_ndocto
	
			f_busqueda.Consultar sql_datos_orden
			
			f_busqueda.Siguiente
			f_busqueda.AgregaCampoCons "pers_tnombre", f_busqueda.obtenerValor("pers_tnombre")
			f_busqueda.AgregaCampoCons "sogi_mgiro", f_busqueda.obtenerValor("ordc_mmonto")
			f_busqueda.AgregaCampoCons "cpag_ccod", f_busqueda.obtenerValor("cpag_ccod")
			f_busqueda.AgregaCampoCons "tmon_ccod", f_busqueda.obtenerValor("tmon_ccod")
			v_boleta=f_busqueda.obtenerValor("ordc_bboleta_honorario")
			area_ccod=f_busqueda.obtenerValor("area_ccod")
		else
			  f_busqueda.Consultar "select '' "
			  f_busqueda.Siguiente
		end if
	
		sql_detalle_pago="select ''"
	
	end if



if v_rut<>"" then
	set f_personas = new CFormulario
	f_personas.carga_parametros "tabla_vacia.xml", "tabla_vacia"
	f_personas.inicializar conexion
	sql_datos_persona= " Select top 1 codaux as pers_nrut,NomAux as pers_tnombre, NomAux as v_nombre "&_
					   	" from softland.cwtauxi a "&_
					   	" where CodAux='"&v_rut&"'"
		
	'response.Write(		sql_datos_persona)			
	f_personas.consultar sql_datos_persona
	f_personas.Siguiente
	
	f_busqueda.AgregaCampoCons "pers_nrut", v_rut
	f_busqueda.AgregaCampoCons "pers_xdv", v_dv
	f_busqueda.AgregaCampoCons "pers_tnombre", f_personas.obtenerValor("pers_tnombre")
	f_busqueda.AgregaCampoCons "v_nombre", f_personas.obtenerValor("v_nombre")
end if

 
if f_busqueda.nroFilas >=1 then
	v_ordc_ndocto=f_busqueda.obtenerValor("ordc_ncorr")
end if

 set f_buscador = new CFormulario
 f_buscador.Carga_Parametros "pago_proveedor.xml", "buscador"
 f_buscador.Inicializar conectar
 f_buscador.Consultar " select '' "
 f_buscador.Siguiente
 f_buscador.AgregaCampoCons "ordc_ndocto", v_ordc_ndocto



set f_detalle_pago = new CFormulario
f_detalle_pago.carga_parametros "pago_proveedor.xml", "detalle_giro"
f_detalle_pago.inicializar conectar
f_detalle_pago.Consultar sql_detalle_pago


 set f_detalle = new CFormulario
 	f_detalle.Carga_Parametros "pago_proveedor.xml", "detalle_producto"
 	f_detalle.Inicializar conectar
 	if v_ordc_ndocto<>"" then
		sql_detalle="select dorc_nprecio_neto-protic.ocag_total_pago_proveedor(ordc_ncorr,tgas_ccod,ccos_ncorr,dorc_tdesc) as dorc_nprecio_neto,"&_
					" dorc_nprecio_neto-protic.ocag_total_pago_proveedor(ordc_ncorr,tgas_ccod,ccos_ncorr,dorc_tdesc) as saldo, "&_ 
					" dorc_nprecio_neto-protic.ocag_total_pago_proveedor(ordc_ncorr,tgas_ccod,ccos_ncorr,dorc_tdesc) as v_saldo, * "&_
					" from ocag_detalle_orden_compra where cast(ordc_ncorr as varchar)='"&v_ordc_ndocto&"'"
	else
		sql_detalle="select 0 as dorc_nprecio_neto,0 as dorc_nprecio_unidad, 0 as dorc_ndescuento,0 as saldo "
	end if
	f_detalle.agregaCampoParam "ccos_ncorr","filtro", "pers_nrut="&v_usuario
	f_detalle.consultar sql_detalle
	filas_detalle= f_detalle.nrofilas

'*****************************************************************
'***************	Inicio bases para presupuesto	**************
set f_presupuesto = new CFormulario
f_presupuesto.Carga_Parametros "pago_proveedor.xml", "detalle_presupuesto"
f_presupuesto.Inicializar conectar

if v_ordc_ndocto<>"" then
	sql_presupuesto="select porc_mpresupuesto as psol_mpresupuesto,* from ocag_presupuesto_orden_compra where cast(ordc_ncorr as varchar)='"&v_ordc_ndocto&"'"
	f_busqueda.AgregaCampoParam "pers_nrut", "script", "Readonly"
	f_busqueda.AgregaCampoParam "pers_xdv", "script", "Readonly"
	f_busqueda.AgregaCampoParam "cpag_ccod", "deshabilitado", "true"
else
	sql_presupuesto="select '' "
end if

f_presupuesto.consultar sql_presupuesto

if v_ordc_ndocto="" then ' setea los años por defecto en el año actual en caso de no venir con OC
	f_presupuesto.AgregaCampoCons "anos_ccod", 2011
	f_presupuesto.AgregaCampoParam "psol_mpresupuesto", "script", ""
	f_presupuesto.AgregaCampoParam "psol_mpresupuesto", "deshabilitado", "false"
	f_presupuesto.AgregaCampoParam "anos_ccod", "deshabilitado", "false"
	f_presupuesto.AgregaCampoParam "mes_ccod", "deshabilitado", "false"
	f_presupuesto.AgregaCampoParam "cod_pre", "deshabilitado", "false"

	f_detalle.AgregaCampoParam "tgas_ccod", "deshabilitado", "false"
	f_detalle.AgregaCampoParam "dorc_tdesc", "deshabilitado", "false"
	f_detalle.AgregaCampoParam "dorc_tdesc", "script", ""
	f_detalle.AgregaCampoParam "ccos_ncorr", "deshabilitado", "false"
	f_detalle.AgregaCampoParam "dorc_ncantidad", "deshabilitado", "false"
	f_detalle.AgregaCampoParam "dorc_bafecta", "deshabilitado", "false"
	f_detalle.AgregaCampoParam "dorc_nprecio_unidad", "deshabilitado", "false"
	f_detalle.AgregaCampoParam "dorc_ndescuento", "deshabilitado", "false"
	f_detalle.AgregaCampoParam "dorc_nprecio_neto", "deshabilitado", "false"
	f_detalle.AgregaCampoParam "dorc_nprecio_neto", "script", "CalculaTotal(this)"
	
end if

filas_presu= f_presupuesto.nrofilas


set f_cod_pre = new CFormulario
f_cod_pre.carga_parametros "orden_compra.xml", "codigo_presupuesto"
f_cod_pre.inicializar conexion
f_cod_pre.consultar "select '' "

sql_codigo_pre="(select distinct cod_pre, 'Area('+cast(cast(cod_area as numeric) as varchar)+')-'+concepto +' ('+cod_pre+')' as valor "&_
			    " from presupuesto_upa.protic.presupuesto_upa_2011 	"&_
			    "	where cod_anio=2011 "&_
				"	and cod_area in (   select distinct area_ccod "&_ 
				"		 from  presupuesto_upa.protic.area_presupuesto_usuario  "&_
				"		 where rut_usuario in ("&v_usuario&") and cast(area_ccod as varchar)= '"&area_ccod&"') "&_
				" ) as tabla "

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
'##################################################################


'*****************************************************************
'***************	Inicio bases para detalle	******************

set f_tipo_gasto = new CFormulario
f_tipo_gasto.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_tipo_gasto.inicializar conectar
sql_tipo_gasto= "Select top 5  tgas_ccod, ltrim(rtrim(tgas_tdesc)) as tgas_tdesc,pare_ccod from ocag_tipo_gasto"
f_tipo_gasto.consultar sql_tipo_gasto


set f_centro_costo = new CFormulario
f_centro_costo.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_centro_costo.inicializar conectar
sql_centro_costo=" select a.ccos_ncorr,a.ccos_tcodigo as ccos_tcompuesto,ccos_tdesc "&_ 
					" from ocag_centro_costo a, ocag_permisos_centro_costo b "&_ 
					" where a.ccos_tcodigo=b.ccos_tcodigo "&_ 
					" and pers_nrut="&v_usuario
f_centro_costo.consultar sql_centro_costo


'##################################################################

'*****************************************************************
'***************	Inicio bases para Responsables	**************
set f_responsable = new CFormulario
	f_responsable.carga_parametros "tabla_vacia.xml", "tabla_vacia"
	f_responsable.inicializar conectar
	sql_responsable= "Select pers_nrut_responsable as pers_nrut,protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre "&_
					  "	from ocag_responsable_area a, personas b "&_
					  "	where a.pers_nrut_responsable=b.pers_nrut "&_
					  "	and cast(a.pers_nrut as varchar)='"&v_usuario&"'"
	f_responsable.consultar sql_responsable
'##################################################################	

if Cstr(v_boleta)=Cstr(1) then
	segun_boleta	="Honorario Total (Liquido 0.9)"
	txt_variable	="10% Retencion"
	txt_neto		="Honorarios"
	valor_neto		="ordc_mhonorarios"
	valor_variable	="ordc_mretencion"
	row_span	=3
	v_variable	=f_busqueda.obtenerValor("ordc_mretencion")
	v_neto		=f_busqueda.obtenerValor("ordc_mhonorarios")
	v_total		=f_busqueda.obtenerValor("ordc_mhonorarios")
	v_totalizado=Cint(v_neto)-Cint(v_variable)
else
	segun_boleta	="Precio Neto"
	txt_variable	="19% IVA"
	txt_neto		="Neto"
	valor_neto		="ordc_mneto"
	valor_variable	="ordc_miva"
	row_span	=4
	v_neto		=f_busqueda.obtenerValor("ordc_mneto")
	v_variable	=f_busqueda.obtenerValor("ordc_miva")
	v_exento	=f_busqueda.obtenerValor("ordc_mexento")
	v_total		=f_busqueda.obtenerValor("ordc_mmonto")	
	v_totalizado=v_total
end if


%>


<html>
<head>
<title>Solicitud de Giro</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

function ImprimirPagoProveedor(){
	url="imprimir_pp.asp?sogi_ncorr=<%=sogi_ncorr%>";
	window.open(url,'ImpresionPP', 'scrollbars=yes, menubar=no, resizable=yes, width=700,height=700');	
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
	//alert(rut+IgDigitoVerificador);
	//_Buscar(this, document.forms['datos'],'', 'Enviar()', 'TRUE');
			document.datos.action= "pago_proveedor.asp?area_ccod="+v_area+"&rut="+rut+"&dv="+IgDigitoVerificador;
			document.datos.method = "post";
			document.datos.submit();
}


function AgregarDetalle(formu){

	formulario = document.datos;
	v_dsgi_ndocto	= formulario.elements["datos[0][dsgi_ndocto]"].value;
	v_dsgi_mdocto	= formulario.elements["datos[0][dsgi_mdocto]"].value;		
	if((v_dsgi_ndocto)&&(v_dsgi_mdocto)){
		document.datos.action="pago_proveedor_detalle_proc.asp";
		document.datos.method="post";
		document.datos.submit();
	}else{
		alert("Debe ingresar un numero y monto de documento valido para agregar un nuevo pago");
	}
}

function EliminaDetalle(){
	document.detalle_doctos.action="pago_proveedor_detalle_elimina_proc.asp";
	document.detalle_doctos.method="post";
	document.detalle_doctos.submit();
}

function Enviar(){
	//validar campos vacios
	
	var select = document.getElementsByTagName("select");
    var select_actuales = select.length -1; //numero de select ya añadidos
		
	var formulario = document.forms["datos"];
	for (var i = 0; i < select_actuales; i++) {
		if(formulario.elements["detalle["+i+"][tgas_ccod]"]){
			formulario.elements["detalle["+i+"][tgas_ccod]"].disabled=false;
			formulario.elements["detalle["+i+"][ccos_ncorr]"].disabled=false;
			formulario.elements["detalle["+i+"][dorc_tdesc]"].disabled=false;
			formulario.elements["detalle["+i+"][dorc_ncantidad]"].disabled=false;
			formulario.elements["detalle["+i+"][dorc_ndescuento]"].disabled=false;
			formulario.elements["detalle["+i+"][dorc_nprecio_unidad]"].disabled=false;
			//formulario.elements["detalle["+i+"][dorc_bafecta]"].disabled=false;
		}
		if(formulario.elements["presupuesto["+i+"][cod_pre]"]){
			formulario.elements["presupuesto["+i+"][cod_pre]"].disabled=false;
			formulario.elements["presupuesto["+i+"][mes_ccod]"].disabled=false;
			formulario.elements["presupuesto["+i+"][anos_ccod]"].disabled=false;
			formulario.elements["presupuesto["+i+"][psol_mpresupuesto]"].disabled=false;
		}
		
	}
	return true;
}
function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if
%>
}

/*****************************************************************************/
/*// PRIMERA TABLA DINAMICA //*/
<%if filas_detalle >0 then%>
var contador=<%=filas_detalle%>;
<%else%>
var contador=0;
<%end if%>

function validaFila(id, nro,boton)
{
	if (document.datos.elements["detalle["+nro+"][dorc_tdesc]"].value == ''){
	  alert('Debe ingresar una descripcion valida');
	  return false;
	}
	if(document.datos.elements["detalle["+nro+"][dorc_nprecio_unidad]"].value != ''){
		addRow(id, nro, boton );habilitaUltimoBoton();
	}else{
		alert('Debe completar las filas del detalle para ingresar a la orden de compra');
	}
}

function eliminaFilas()
{
var check=document.datos.getElementsByTagName('input');
var cantidadCheck=0;
var checkbox=new Array();
var tabla = document.getElementById('tb_busqueda_detalle');

 for (y=0;y<check.length;y++){if (check[y].type=="checkbox"){checkbox[cantidadCheck++]=check[y];}}
	for (x=0;x<cantidadCheck;x++){
		  if (checkbox[x].checked) {deleterow(checkbox[x]);}
	 }
 if (tabla.tBodies[0].rows.length < 2)
    {addRow('tb_busqueda_detalle', cantidadCheck, 0 );}

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
contador= contador + 1;
var tbody = document.getElementById(id).getElementsByTagName("TBODY")[0];
var row = document.createElement("TR");
row.align="left";

//********Nro de detalle********************
var td1 = document.createElement("TD");
var aElement=document.createElement("<INPUT TYPE=\"checkbox\" name=\"detalle["+ contador +"][checkbox]\" value=\""+ contador +"\"  >");
td1.appendChild (aElement);

//********tgas_ccod********************
var td2 = document.createElement("TD");
var iElement=document.createElement("Select");
iElement.name="detalle["+ contador +"][tgas_ccod]";
i=0;
<%	
f_tipo_gasto.primero
while f_tipo_gasto.Siguiente 
%>
i=i+1;
	var v_option=document.createElement("Option");
	v_option.value=<%=f_tipo_gasto.ObtenerValor("tgas_ccod")%>;// Valor del option
	v_option.innerHTML='<%=f_tipo_gasto.ObtenerValor("tgas_tdesc")%>'; // texto del option
	iElement.appendChild(v_option);	
<%wend%>	
td2.appendChild (iElement);

//********dorc_tdesc********************
var td3 = document.createElement("TD");
var iElement=document.createElement("<INPUT TYPE=\"text\" name=\"detalle["+ contador +"][dorc_tdesc]\" size=\"10\" >");
td3.appendChild (iElement)


//********ccos_ncorr********************
var td4 = document.createElement("TD");

var iElement=document.createElement("select");
iElement.name="detalle["+ contador +"][ccos_ncorr]";
i=0;
<% 
f_centro_costo.primero
while f_centro_costo.Siguiente 
%>
i=i+1;
	var v_option=document.createElement("Option");
	v_option.value='<%=f_centro_costo.ObtenerValor("ccos_ncorr")%>';// Valor del option
	v_option.innerHTML="<%=f_centro_costo.ObtenerValor("ccos_tcompuesto")%>"; // texto del option
	iElement.appendChild(v_option);	
<%wend%>
td4.appendChild (iElement)


//********dorc_ncantidad********************
var td7 = document.createElement("TD");
var iElement=document.createElement("<INPUT TYPE=\"text\" name=\"detalle["+ contador +"][dorc_ncantidad]\" value=\"0\" size=\"4\" onblur=\"CalculaTotal(this)\" maxlength=\"5\">");
td7.appendChild (iElement)

//********dorc_bafecta********************
var td8 = document.createElement("TD");
var iElement=document.createElement("<INPUT TYPE=\"checkbox\" name=\"_detalle["+ contador +"][dorc_bafecta]\" value=\"1\" size=\"10\" checked=\"checked\" onClick=\"ChequeaValor(this);\" maxlength=\"10\">");
td8.appendChild (iElement)

//********dorc_nprecio_unidad********************
var td9 = document.createElement("TD");
var iElement=document.createElement("<INPUT TYPE=\"text\" name=\"detalle["+ contador +"][dorc_nprecio_unidad]\" value=\"0\" size=\"10\" onblur=\"CalculaTotal(this)\" maxlength=\"10\">");
td9.appendChild (iElement)

//********dorc_ndescuento********************
var td10 = document.createElement("TD");
var iElement=document.createElement("<INPUT TYPE=\"text\" name=\"detalle["+ contador +"][dorc_ndescuento]\" value=\"0\" size=\"10\" onblur=\"CalculaTotal(this)\" maxlength=\"10\">");
td10.appendChild (iElement)

//********dorc_nprecio_neto********************
var td11 = document.createElement("TD");
var iElement=document.createElement("<INPUT TYPE=\"text\" name=\"detalle["+ contador +"][dorc_nprecio_neto]\" size=\"10\" maxlength=\"10\">");
td11.appendChild (iElement)

//********Agregar********************
var td12 		= 	document.createElement("TD");
var iElement 	=	document.createElement("<INPUT class=boton TYPE=\"button\" name=\"agregarlinea\" value=\"+\" onclick=\"validaFila('tb_busqueda_detalle',"+contador+",this)\">");
var iElement2 	=	document.createElement("<INPUT class=boton TYPE=\"button\" name=\"quitarlinea\" value=\"-\" onclick=\"eliminaFilas()\">");
td12.appendChild (iElement)
td12.appendChild (iElement2)


row.appendChild(td1);
row.appendChild(td2);
row.appendChild(td3);
row.appendChild(td4);
row.appendChild(td7);
row.appendChild(td8);
row.appendChild(td9);
row.appendChild(td10);
row.appendChild(td11);
row.appendChild(td12);
tbody.appendChild(row);
}

function deleterow(node) {
var tr = node.parentNode;
while (tr.tagName.toLowerCase() != "tr")
	tr = tr.parentNode;
	tr.parentNode.removeChild(tr);
}

//******* FIN PRIMERA TABLA DINAMICA *******//
/*****************************************************************************/



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
	datos.elements["total_presupuesto"].value=v_total_presupuesto;

}

//******* FIN SEGUNDA TABLA DINAMICA *******//
/*****************************************************************************/

function ValidaSaldo(objeto){
	var formulario = document.forms["datos"];
	indice=extrae_indice(objeto.name);
<%if v_ordc_ndocto<>"" then%>
		v_valor	=	formulario.elements["detalle["+indice+"][dorc_nprecio_neto]"].value;
		v_saldo	=	formulario.elements["detalle["+indice+"][v_saldo]"].value;
		v_diferencia= v_saldo-v_valor;
		if (v_diferencia<0){
			alert("No puede pagar un monto superior al saldo");
			formulario.elements["detalle["+indice+"][dorc_nprecio_neto]"].focus();
			return false;
		}
<%else%>	
	if(indice!=""){
		v_cantidad	=	detalle.elements["detalle["+indice+"][dorc_ncantidad]"].value;
		v_unidad	=	detalle.elements["detalle["+indice+"][dorc_nprecio_unidad]"].value;		
		v_descuento	=	detalle.elements["detalle["+indice+"][dorc_ndescuento]"].value;	
		v_neto		=	eval(v_cantidad*(v_unidad-v_descuento));
		detalle.elements["detalle["+indice+"][dorc_nprecio_neto]"].value=v_neto;
	}
	
<%end if%>	
RecalcularTotales();
}

function CalculaTotal(objeto){
	var formulario = document.forms["datos"];
	indice=extrae_indice(objeto.name);
	if(indice!=""){
		v_cantidad	=	formulario.elements["detalle["+indice+"][dorc_ncantidad]"].value;
		v_unidad	=	formulario.elements["detalle["+indice+"][dorc_nprecio_unidad]"].value;		
		v_descuento	=	formulario.elements["detalle["+indice+"][dorc_ndescuento]"].value;	
		v_neto		=	eval(v_cantidad*(v_unidad-v_descuento));
		formulario.elements["detalle["+indice+"][dorc_nprecio_neto]"].value=v_neto;
	}
RecalcularTotales()
}

function RecalcularTotales(){
	var formulario = document.forms["datos"];
	v_total_solicitud = 0;
	v_total_iva = 0;
	v_total_neto = 0;
	v_total_exento = 0;
// Boleta de honorarios
	<% if Cstr(v_boleta)=1 then %>
		for (var i = 0; i < contador; i++) {
			if(formulario.elements["detalle["+i+"][dorc_nprecio_neto]"]){
				v_valor	=	formulario.elements["detalle["+i+"][dorc_nprecio_neto]"].value;
				if (v_valor){
					v_total_solicitud = v_total_solicitud + parseInt(v_valor);
				}
			}
		}
		formulario.ordc_mhonorarios.value	=	eval(v_total_solicitud);
		formulario.total.value				=	Math.round(v_total_solicitud*0.9)
		formulario.ordc_mretencion.value	=	eval(Math.round(v_total_solicitud*1.10)-v_total_solicitud);
	<%else%>
// Sin boletas de Honorarios, se considera el check para valores exentos y afectos
		for (var i = 0; i < contador; i++) {
			if(formulario.elements["detalle["+i+"][dorc_nprecio_neto]"]){
				v_valor	=	formulario.elements["detalle["+i+"][dorc_nprecio_neto]"].value;
				if (v_valor>0){
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
		formulario.ordc_mneto.value	=	parseInt(v_total_neto);
		formulario.ordc_miva.value	=	parseInt(v_total_iva);
		formulario.exento.value		=	parseInt(v_total_exento);
		formulario.total.value		=	parseInt(v_total_solicitud)+parseInt(v_total_iva);
	<%end if%>
}

function ChequeaValor(obj){
	var formulario = document.forms["datos"];
	v_name=obj.name;
	v_valor=obj.value;
	indice=extrae_indice(v_name);
	if(formulario.elements["busqueda[0][ordc_bboleta_honorario]"]==1){
		alert("Cuando seleccione Boleta de Honorario no puede incluir productos exentos de Iva");
		formulario.elements["_detalle["+indice+"][dorc_bafecta]"].checked=true;
	}
CalculaTotal(obj);	
}

/*****************************************************************************/

</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Pago a Proveedor </font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
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
                    <div align="center"><font size="+1">
                      <%pagina.DibujarTituloPagina()%> 
                      </font>                    </div>
					  <br/>
                    <table width="100%" align="center" cellpadding="0" cellspacing="0" >
                  <tr> 
                    <td>
					<form name="buscador"> 
					<table width="90%">
					<tr>
						<td>Extrae datos desde Orden de Compra:</td>
						<td><%f_buscador.dibujaCampo("ordc_ndocto")%></td>
						<td><%botonera.DibujaBoton "buscar" %></td>
					</tr>
					</table>
					  </form>
</td>
<tr><td>			 
					  <form name="datos" action="pago_proveedor_proc.asp" method="post" onSubmit="alert();">
					  <%f_busqueda.dibujaCampo("sogi_ncorr")%>
					  <input type="hidden" name="busqueda[0][tsol_ccod]" value="1">
					  <input type="hidden" name="busqueda[0][area_ccod]" value="<%=area_ccod%>" />
					  <input type="hidden" name="busqueda[0][ordc_ndocto]" value="<%=v_ordc_ndocto%>" />
					  <input type="hidden" name="busqueda[0][ordc_bboleta_honorario]" value="<%=v_boleta%>" />
					<table width="100%" height="100%" border='1' bordercolor='#999999' >
                      <tr> 
                        <td width="11%">Rut proveedor </td>
                        <td width="27%"> <%f_busqueda.dibujaCampo("pers_nrut")%>-<%f_busqueda.dibujaCampo("pers_xdv")%></td>
					    <td> Fecha docto </td>
                        <td width="48%"><%f_busqueda.dibujaCampo("sogi_fecha_solicitud")%></td>
                      </tr>
                      <tr> 
                        <td> Nombre proveedor </td>
                        <td> <%f_busqueda.dibujaCampo("pers_tnombre")%></td>
						<td colspan="2" rowspan="3" valign="top" align="left"><p>Detalle de gasto</p>
						    <%f_busqueda.dibujatextarea("sogi_tobservaciones")%>						   </td>
                      </tr>
                      <tr>
                        <td>Monto girar </td>
                        <td><%f_busqueda.dibujaCampo("sogi_mgiro")%></td> 
                      </tr>					  
					  <tr>
					    <td>Cond. Pago </td>
					    <td><%f_busqueda.dibujaCampo("cpag_ccod")%></td>
					  </tr>
					  <tr>
							<td colspan="4">
								  <table width="100%" align="center" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0'>
									  <tr bgcolor='#C4D7FF' bordercolor='#999999'>
										<th><strong>Tipo moneda</strong></th>
										<th><strong>Tipo documento</strong></th>
										<th><strong>Numero docto</strong></th>
										<th><strong>Monto docto</strong></th>
									  </tr>
									  <tr>
										<td><%f_busqueda.dibujaCampo("tmon_ccod")%></td>
										<td><%f_busqueda.dibujaCampo("tdoc_ccod")%></td>
										<td><strong>
										  <%f_busqueda.dibujaCampo("dsgi_ndocto")%>
										</strong></td>
										<td><%f_busqueda.dibujaCampo("dsgi_mdocto")%></td>
									  </tr>
								  </table>							
								  <input type="button" onClick="AgregarDetalle(this.form)" name="agrega_pago" value="Agregar pago">
							</td>
						</tr>
	  						  					  
					  <tr>
					  <td colspan="4">
						<legend><strong>Detalle Presupuesto</strong></legend> 
						<table width="100%" align="center" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' id=tb_presupuesto>
							<tr bgcolor='#C4D7FF' bordercolor='#999999'>
								<%if v_ordc_ndocto="" then%><th width="5%">N°</th><%end if%>
								<th width="50%">Cod. Presupuesto</th>
								<th width="12%">Mes</th>
								<th width="12%">Año</th>
								<th width="16%">Valor</th>
								<%if v_ordc_ndocto="" then%><th width="5%">(+/-)</th><%end if%>
							</tr>
							<%
									ind=0
									while f_presupuesto.Siguiente 
									v_cod_pre=f_presupuesto.ObtenerValor("cod_pre")
									%>
									<tr align="left">
										<%if v_ordc_ndocto="" then%><th><input type="checkbox" name="presupuesto[<%=ind%>][checkbox]" value=""></th><%end if%>
										<td>
											<select name="presupuesto[<%=ind%>][cod_pre]" <%if v_ordc_ndocto<>"" then%>disabled="yes"<%end if%>>
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
										<td><%f_presupuesto.DibujaCampo("mes_ccod")%> </td>
										<td><%f_presupuesto.DibujaCampo("anos_ccod")%> </td>
										<td><%f_presupuesto.DibujaCampo("psol_mpresupuesto")%> </td>
										<%if v_ordc_ndocto="" then%>
										<td><INPUT alt="agregar fila" class=boton TYPE="button" name="agregarlinea2" value="+" onClick="validaFila2('tb_presupuesto','<%=ind%>',this);"><INPUT alt="quitar una fila existente" class="boton" TYPE="button" name="quitarlinea2" value="-" onClick="eliminaFilas2()">										</td>
										<%end if%>
									</tr>	
									<%
									ind=ind+1
									wend %>
						</table>
						<br/>&nbsp;					  </td>
					  </tr>
					  	<tr>
					  		<td colspan="4">
								<legend><strong>Detalle Gasto</strong></legend> 							
								<table width="100%" align="center" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' id=tb_busqueda_detalle>
									<tr bgcolor='#C4D7FF' bordercolor='#999999'>
										<%if v_ordc_ndocto="" then%><th>N°</th><%end if%>
										<th>Tipo Gasto</th>
										<th>Descripcion</th>
										<th>C. Costo</th>
										<th>Cantidad</th>
										<th>Afecta</th>
										<th>Precio Unitario</th>
										<th>Descuento($)</th>
										<th>monto</th>
										<%if v_ordc_ndocto="" then%><th>(+/-)</th><%end if%>
										<%if v_ordc_ndocto<>"" then%><th>saldo</th><%end if%>
									</tr>
										<%
											if filas_detalle >=1 then
												ind_d=0
												v_totalizado=0
												f_detalle.primero
												while f_detalle.Siguiente 
												f_detalle.DibujaCampo("ordc_ncorr")
												
												%>
												<tr align="left">
													<%if v_ordc_ndocto="" then%><th><input type="checkbox" name="detalle[<%=ind_d%>][checkbox]" value=""></th><%end if%>
													<td><%f_detalle.DibujaCampo("tgas_ccod")%></td>
													<td><%f_detalle.DibujaCampo("dorc_tdesc")%></td>
													<td><%f_detalle.DibujaCampo("ccos_ncorr")%> </td>
													<td><%f_detalle.DibujaCampo("dorc_ncantidad")%> </td>
													<td><%f_detalle.dibujaBoleano("dorc_bafecta")%></td>
													<td><%f_detalle.DibujaCampo("dorc_nprecio_unidad")%></td>
													<td><%f_detalle.DibujaCampo("dorc_ndescuento")%> </td>
													<td><%f_detalle.DibujaCampo("dorc_nprecio_neto")%> </td>
													<%if v_ordc_ndocto="" then%>
													<td><INPUT alt="agregar una nueva fila" class=boton TYPE="button" name="agregarlinea" value="+" onClick="validaFila('tb_busqueda_detalle','<%=ind_d%>',this)"><INPUT alt="quitar una fila existente" class=boton TYPE="button" name="quitarlinea" value="-" onClick="eliminaFilas()"></td>
													<%end if%>
													<%if v_ordc_ndocto<>"" then%><td><%f_detalle.DibujaCampo("saldo")%><%f_detalle.DibujaCampo("v_saldo")%></td><%end if%>													
												</tr>	
												<%
												ind_d=ind_d+1
												v_totalizado=clng(v_totalizado)+ clng(f_detalle.obtenerValor("saldo"))
												wend
											end if 
										%>
								</table>								</td>
						</tr>
						<tr>
							<td colspan="4">
								<table border="0" width="100%" >
									  <tr>
										<td width="80%" rowspan="<%=row_span%>">&nbsp;</td>
										<th width="10%"><%=txt_neto%></th>
										<td width="10%"><input type="text" name="<%=valor_neto%>" value="<%=v_neto%>" size="10" id='NU-N' readonly="yes"/></td>
									  </tr>
									  <tr>
										<th><%=txt_variable%></th>
										<td><input type="text" name="<%=valor_variable%>" value="<%=v_variable%>" size="10" id='NU-N' readonly="yes"/></td>
									  </tr>
									  <% if Cstr(v_boleta)=2 then %>
									  <tr>
										<th>Exento</th>
										<td><input type="text" name="exento" value="<%=v_exento%>" size="10" id='NU-N' readonly="yes"/></td>
									  </tr>
									  <%end if%>
									  <tr>
										<th>Total</th>
										<td><input type="text" name="total" value="<%=v_totalizado%>" size="10" id='NU-N' readonly="yes"/></td>
									  </tr>
								</table>							
								</td>
						</tr>	
                    </table>
<br/>
<p></p>
	
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
		</fieldset>						  					
		</form>
</td>
<tr><td>
<br>
				<fieldset>
					<legend><strong>Detalle de pagos </strong></legend> 
							<table border ="0" align="center" width="90%">
								<tr valign="top">
								<td>
								<form name="detalle_doctos" method="post">
								  <table class="v1" align="center" width="100%" border='0' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0'>
                                    <tr bgcolor='#C4D7FF' bordercolor='#999999'>
                                      <th></th>
                                      <th>Tipo Docto </th>
                                      <th>N&deg; Docto </th>
                                      <th>Tipo Moneda </th>
                                      <th>Valor Original </th>
                                      <th>Valor Pesos </th>
                                    </tr>
                                    <%
										indice=0
										while f_detalle_pago.Siguiente 
										%>
                                    <tr bgcolor='#FFFFFF'>
                                      <td><%f_detalle_pago.DibujaCampo("sogi_ncorr")%>
                                          <input type="checkbox" value="<%=f_detalle_pago.ObtenerValor("dsgi_ncorr")%>" name="datos[<%=indice%>][dsgi_ncorr]"/></td>
                                      <td><%f_detalle_pago.dibujacampo("tdoc_ccod")%></td>
                                      <td><%f_detalle_pago.dibujacampo("dsgi_ndocto")%></td>
                                      <td><%f_detalle_pago.dibujacampo("tmon_ccod")%></td>
                                      <td><%f_detalle_pago.dibujacampo("dsgi_mdocto")%></td>
                                      <td><%f_detalle_pago.dibujacampo("dsgi_mdocto")%></td>
                                    </tr>
                                    <%
										indice=indice+1
										wend
										%>
                                  </table>
								  <%botonera.dibujaboton "eliminar"%>
								</form>								  
								</td>
								</tr>
							</table>
</fieldset>							
							</td>
						</tr>
						<tr>
						<td>
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
                      <td width="30%"> <%botonera.dibujaboton "salir"%> </td>
					  <td><%botonera.dibujaboton "guardar"%></td>
					  <td><%botonera.dibujaboton "imprimir"%></td>
                    </tr>
                  </table>                </td>
                  <td  rowspan="2" align="left" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28" align="left"></td>
                  <td  rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28" align="right"></td>
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