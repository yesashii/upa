<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Orden de Compra"

ordc_ncorr	= request.querystring("ordc_ncorr")
area_ccod	= request.querystring("busqueda[0][area_ccod]")
rut 		= request.querystring("pers_nrut")
digito 		= request.querystring("pers_xdv")
v_boleta	= request.querystring("v_boleta")

if v_boleta="" then
	mensaje_boleta="<CENTER>Debe seleccionar si la orden de compra es con boleta de honorarios o no.</CENTER>"
	ini_com="<!--"
	fin_com="-->"
' 	bloquear datos de registro
end if
'**********************************************************
set botonera = new CFormulario
botonera.carga_parametros "orden_compra.xml", "botonera"

set conectar = new cconexion
conectar.inicializar "upacifico"

set conexion = new Cconexion2
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

v_usuario 	= negocio.ObtenerUsuario()
sede		= negocio.obtenerSede
v_anos_ccod	= conectar.consultaUno("select year(getdate())")
'***********************************************

if area_ccod="" then
	area_ccod= conexion.consultaUno ("select top 1 a.area_ccod from  presupuesto_upa.protic.area_presupuesto_usuario a, presupuesto_upa.protic.area_presupuestal b where rut_usuario ="&v_usuario&" and a.area_ccod=b.area_ccod order by area_tdesc ")
end if

if v_boleta=1 then
	segun_boleta="Honorario Total (Liquido 0.9)"
	txt_variable="10% Retencion"
	txt_neto	="Honorarios"
	valor_neto	="ordc_mhonorarios"
	valor_variable	="ordc_mretencion"
	row_span= 3
else
	segun_boleta="Precio Neto"
	txt_variable="19% IVA"
	txt_neto	="Neto"
	valor_neto	="ordc_mneto"
	valor_variable	="ordc_miva"
	row_span= 4
end if

'**********************************************************
set f_busqueda2 = new CFormulario
f_busqueda2.Carga_Parametros "orden_compra.xml", "buscador"
f_busqueda2.Inicializar conexion
f_busqueda2.Consultar "select ''"
f_busqueda2.Siguiente

 f_busqueda2.AgregaCampoParam "area_ccod", "filtro",  "area_ccod in ( select area_ccod from  presupuesto_upa.protic.area_presupuesto_usuario where rut_usuario in ('"&v_usuario&"') )"
 f_busqueda2.AgregaCampoCons "area_ccod", area_ccod

set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "orden_compra.xml", "datos_proveedor"
f_busqueda.Inicializar conectar
	if ordc_ncorr<>"" then
		sql_orden="select * from ocag_orden_compra where ordc_ncorr="&ordc_ncorr
	else
		sql_orden="select ''"
	end if
f_busqueda.Consultar sql_orden
f_busqueda.Siguiente

f_busqueda.AgregaCampoCons "pers_nrut", rut
f_busqueda.AgregaCampoCons "pers_xdv", digito

f_busqueda.AgregaCampoCons "ordc_bboleta_honorario", cstr(v_boleta)

if rut<>"" then
	set f_personas = new CFormulario
	f_personas.carga_parametros "tabla_vacia.xml", "tabla_vacia"
	f_personas.inicializar conexion
	sql_datos_persona= " Select top 1 codaux as pers_nrut,NomAux as pers_tnombre, DirAux as dire_tcalle, DirNum as dire_tnro,CiuDes as ciudad,  "&_
						" NomAux as v_nombre,isnull(isnull(FonAux1,Fonaux2),FonAux3) as pers_tfono, isnull(FaxAux1,FaxAux2) as pers_tfax "&_
					   	" from softland.cwtauxi a left outer join softland.cwtciud b on CiuAux=CiuCod "&_
					   	" where CodAux='"&rut&"'"
		
	'response.Write(		sql_datos_persona)			
	f_personas.consultar sql_datos_persona
	f_personas.Siguiente
	
	f_busqueda.AgregaCampoCons "pers_tnombre", f_personas.obtenerValor("pers_tnombre")
	f_busqueda.AgregaCampoCons "dire_tcalle", f_personas.obtenerValor("dire_tcalle")
	f_busqueda.AgregaCampoCons "dire_tnro", f_personas.obtenerValor("dire_tnro")
	f_busqueda.AgregaCampoCons "pers_tfono", f_personas.obtenerValor("pers_tfono")
	f_busqueda.AgregaCampoCons "pers_tfax", f_personas.obtenerValor("pers_tfax")
	f_busqueda.AgregaCampoCons "ciudad", f_personas.obtenerValor("ciudad")
	f_busqueda.AgregaCampoCons "v_nombre", f_personas.obtenerValor("v_nombre")
end if
'response.End()

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
				"		 where rut_usuario in ("&v_usuario&") and area_ccod= "&area_ccod&") "&_
				" ) as tabla "

'response.Write(sql_codigo_pre)
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

set f_responsable = new CFormulario
	f_responsable.carga_parametros "tabla_vacia.xml", "tabla_vacia"
	f_responsable.inicializar conectar
	sql_responsable= "Select pers_nrut_responsable as pers_nrut,protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre "&_
					  "	from ocag_responsable_area a, personas b "&_
					  "	where a.pers_nrut_responsable=b.pers_nrut "&_
					  "	and cast(a.pers_nrut as varchar)='"&v_usuario&"'"
	f_responsable.consultar sql_responsable

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

function Validar(){
	return true;
}
function Enviar(){
	//validar campos vacios
	formulario = document.detalle;
	v_valor	= formulario.elements["busqueda[0][ordc_mmonto]"].value;
	v_presupuesto= formulario.total_presupuesto.value;	
	v_total	= formulario.total.value;
	

	<% if v_boleta=1 then %>
		v_total	= formulario.ordc_mhonorarios.value;
		if((v_total>v_valor)||(v_total<v_valor)||(v_total>v_presupuesto)||(v_total<v_presupuesto)){	
			alert("El monto de la Orden de Compra ingresada debe coincidir con el total de: \nA) Detalle de Honorarios ingresados y \nB) Total de presupuesto asignado");
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
//**************************************************************/
function BuscarPersona(){

	formulario = document.detalle;
	v_rut	=	formulario.elements["busqueda[0][pers_nrut]"].value;
	v_xdv	=	formulario.elements["busqueda[0][pers_xdv]"].value;
	rut_alumno 	= formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value;
	v_area		=	buscador.elements["busqueda[0][area_ccod]"].value;
	<% if v_boleta=1 then %>
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
	location.href="orden_compra.asp?busqueda[0][area_ccod]="+v_area+"&v_boleta="+v_valor+"&pers_nrut="+v_rut+"&pers_xdv="+v_xdv;
}


//**************************************************************/

/*****************************************************************************/
/*// PRIMERA TABLA DINAMICA //*/
var contador=0;

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
{
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
contador= contador + 1;
var tbody = document.getElementById(id).getElementsByTagName("TBODY")[0];
var row = document.createElement("TR");
row.align="center";

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
var iElement=document.createElement("<INPUT TYPE=\"text\" name=\"detalle["+ contador +"][dorc_ncantidad]\" value=\"0\" size=\"5\" onblur=\"CalculaTotal(this)\" maxlength=\"5\">");
td7.appendChild (iElement)

//********dorc_bafecta********************
var td8 = document.createElement("TD");
var iElement=document.createElement("<INPUT TYPE=\"checkbox\" name=\"detalle["+ contador +"][dorc_bafecta]\" value=\"1\" size=\"10\" checked=\"checked\" onClick=\"ChequeaValor(this);\" maxlength=\"10\">");
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
	if (document.detalle.elements["presupuesto["+nro+"][porc_mpresupuesto]"].value >0){ 
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
tbody.appendChild(row);

}

function eliminaFilas2()
{
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
var tr2 = node.parentNode;
while (tr2.tagName.toLowerCase() != "tr")
	tr2 = tr2.parentNode;
	tr2.parentNode.removeChild(tr2);
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


function RecalcularTotales(){
	var formulario = document.forms["detalle"];
	v_total_solicitud = 0;
	v_total_iva = 0;
	v_total_neto = 0;
	v_total_exento = 0;
// Boleta de honorarios
	<% if v_boleta=1 then %>
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
// Sin boletas de Honorarios, se considera el check para valores exentos y afectos
		for (var i = 0; i <= contador; i++) {
			if(formulario.elements["detalle["+i+"][dorc_nprecio_neto]"]){
				v_valor	=	formulario.elements["detalle["+i+"][dorc_nprecio_neto]"].value;
				if (v_valor){
					if (formulario.elements["detalle["+i+"][dorc_bafecta]"].checked){ // Producto afecto, se calcula Iva
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


function SumaTotalPresupuesto(valor){

	var formulario = document.forms["detalle"];
	v_total_presupuesto = 0;
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


function CambiaValor(obj){
	v_name=obj.name;
	v_valor=obj.value;
	filtro="";
	v_area		=	document.buscador.elements["busqueda[0][area_ccod]"].value;
	if (v_area!=""){
		filtro= "&busqueda[0][area_ccod]="+v_area;	
	}
<% if v_boleta<>"" then %>
	v_pers_nrut	=	document.detalle.elements["busqueda[0][pers_nrut]"].value;
	v_pers_xdv	=	document.detalle.elements["busqueda[0][pers_xdv]"].value;
	if (v_pers_nrut!=""){
		filtro= filtro+"&pers_nrut="+v_pers_nrut;	
	}
	if (v_pers_xdv!=""){
		filtro= filtro+"&pers_xdv="+v_pers_xdv;	
	}
<%end if%>
	document.detalle.action= "orden_compra.asp?v_boleta="+v_valor+""+filtro;
	document.detalle.method = "post";
	document.detalle.submit();
}

function ChequeaValor(obj){
	v_name=obj.name;
	v_valor=obj.value;
	indice=extrae_indice(v_name);
	if(document.detalle.elements["busqueda[0][ordc_bboleta_honorario]"][0].checked){
		alert("Cuando seleccione Boleta de Honorario no puede incluir productos exentos de Iva");
		document.detalle.elements["detalle["+indice+"][dorc_bafecta]"].checked=true;
	}
CalculaTotal(obj);	
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
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="100" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador</font></div></td>
                    <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                  </tr>
              </table></td>
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
				<form name="buscador">                
                      <table width="100%" border="0" align="left">
                        <tr>
                          <td width="35"></td>
						  <td width="190"><div align="left"><strong>Area Presupuesto</strong>  </div></td>
						  <td width="482"><% f_busqueda2.DibujaCampo ("area_ccod") %></td>
						  <td width="183"><div align="center"><%botonera.DibujaBoton "buscar" %></div></td>
                        </tr>
                      </table>
				</form>
                </td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE" background="../imagenes/base2.gif"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>	
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
          <td>
		  <table border="0" cellpadding="0" cellspacing="0" width="100%">
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Orden de compra </font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td ><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
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
				  
                   <table width="100%" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
                    <td><strong><font color="000000" size="1"> </font></strong>
					<form name="detalle">
					<input type="hidden" name="busqueda[0][area_ccod]" value="<%=area_ccod%>" />
					<center>
					<div   style=" width:400px; border:1px solid blue; color: #0000FF; margin:'margin-right:-20px;'">	
					<table align="center" width="100%" class="tabactivo">
						<tr>
							<th>Boleta Honorarios</th>
							<th>Tipo Moneda</th>
						</tr>
						<tr>
							<td align="center"><%f_busqueda.dibujaBoleano("ordc_bboleta_honorario")%></td>
						<td align="center"><select name="tmon_ccod">
							<%f_monedas.primero
							while f_monedas.Siguiente %>
							<option value="<%=f_monedas.ObtenerValor("tmon_ccod")%>" ><%=f_monedas.ObtenerValor("tmon_tdesc")%></option>
							<%wend%>
							</select>
						</td>
						</tr>
					</table>
					</div>
					</center>
					<br/>
					<font color="#FF0000" size="2"><%=mensaje_boleta%></font>
					<%=ini_com%>
						<table width="100%" border="1">
						  <tr> 
							<td width="11%">Rut (<font color="#FF0000">*</font>)</td>
							<td width="27%"> <%f_busqueda.dibujaCampo("pers_nrut")%>
							  -<%f_busqueda.dibujaCampo("pers_xdv")%> <input type="button" value="Buscar" onClick="javascript:BuscarPersona();" /></td>
							<td width="14%">Atenci&oacute;n </td>
							<td> <%f_busqueda.dibujaCampo("ordc_tatencion")%></td>
						  </tr>
						  <tr> 
							<td> Se&ntilde;ores </td>
							<td> <%f_busqueda.dibujaCampo("pers_tnombre")%> <%f_busqueda.dibujaCampo("v_nombre")%></td>
							<td> N&deg; Cotizacion </td>
							<td width="48%"> <%f_busqueda.dibujaCampo("ordc_ncotizacion")%></td>
						  </tr>
						  <tr> 
							<td>Direccion</td>
							<td> <%f_busqueda.dibujaCampo("dire_tcalle")%>&nbsp;<%f_busqueda.dibujaCampo("dire_tnro")%></td>
							<td> Cond. Pago (<font color="#FF0000">*</font>)</td>
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
							<td>Monto Orden (<font color="#FF0000">*</font>)</td>
							<td><%f_busqueda.dibujaCampo("ordc_mmonto")%></td>
						  </tr>
						  <tr>
						    <td>Fax</td>
						    <td><%f_busqueda.dibujaCampo("pers_tfax")%></td>
						    <td>Total Presupuestado </td>
						    <td><input type="text" style="background-color:#D8D8DE;border: 1px #D8D8DE solid; font-size:10px; font-style:oblique; font:bold; "  name="total_presupuesto" value="0" size="12" id='total_presupuesto' readonly="yes"/></td>
						    </tr>
						  <tr>
						    <td colspan="4">
							
								<table width="100%" class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' id=tb_presupuesto>
									<tr bgcolor='#C4D7FF' bordercolor='#999999'>
										<th width="5%">N°</th>
										<th width="50%">Cod. Presupuesto</th>
										<th width="12%">Mes</th>
										<th width="12%">Año</th>
										<th width="16%">Valor</th>
										<th width="5%">(+/-)</th>
									</tr>
									<tr>
										<td><input type="checkbox" name="presupuesto[0][check]" value=""></td>
										<td>
										<select name="presupuesto[0][cod_pre]">
											<%f_cod_pre.primero%>
											<%while f_cod_pre.Siguiente %>
												<option value="<%=f_cod_pre.ObtenerValor("cod_pre")%>" ><%=f_cod_pre.ObtenerValor("valor")%></option>
											<%wend%>
										</select>	
										</td>
										<td>
											<select name="presupuesto[0][mes_ccod]">
											  <%f_meses.primero%>
											  <%while f_meses.Siguiente %>
											  <option value="<%=f_meses.ObtenerValor("mes_ccod")%>" ><%=f_meses.ObtenerValor("mes_tdesc")%></option>
											  <%wend%>
											</select>
										</td>
										<td>
											<select name="presupuesto[0][anos_ccod]">
												<%f_anos.primero%>
												<%while f_anos.Siguiente %>
												<option value="<%=f_anos.ObtenerValor("anos_ccod")%>" ><%=f_anos.ObtenerValor("anos_ccod")%></option>
												<%wend%>
											</select>	
										</td>
										<td><input type="text" name="presupuesto[0][porc_mpresupuesto]" value="0" size="10" id='NU-N' onBlur="SumaTotalPresupuesto(this);" /> </td>
										<td><INPUT alt="agregar fila" class=boton TYPE="button" name="agregarlinea2" value="+" onClick="validaFila2('tb_presupuesto','0',this);">&nbsp;<INPUT alt="quitar una fila existente" class="boton" TYPE="button" name="quitarlinea2" value="-" onClick="eliminaFilas2()"></td>
									</tr>
								</table>
							  </td>
						    </tr>
						</table>
						<br/>
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
										<td>Fecha entrega </td>
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
								<tr  align="center" >
									<td><input type="checkbox" name="detalle[0][checkbox]" value=""></td>
									<td>
										<select name="detalle[0][tgas_ccod]">
										<%f_tipo_gasto.primero%>
										<%while f_tipo_gasto.Siguiente %>
											<option value="<%=f_tipo_gasto.ObtenerValor("tgas_ccod")%>" ><%=f_tipo_gasto.ObtenerValor("tgas_tdesc")%></option>
										<%wend%>
										</select>									</td>
									<td><input type="text" name="detalle[0][dorc_tdesc]" value="" size="10" id='TO-N'/>  </td>
									<td>
										<select name="detalle[0][ccos_ncorr]">
										<%f_centro_costo.primero%>
										<%while f_centro_costo.Siguiente %>
											<option value="<%=f_centro_costo.ObtenerValor("ccos_ncorr")%>" ><%=f_centro_costo.ObtenerValor("ccos_tcompuesto")%></option>
										<%wend%>
										</select>									</td>

									<td><input type="text" name="detalle[0][dorc_ncantidad]" value="" size="5" id='NU-N' onBlur="CalculaTotal(this);"/> </td>
									<td><input type="checkbox" name="detalle[0][dorc_bafecta]" value="1" checked="checked" onClick="ChequeaValor(this);"></td>
									<td><input type="text" name="detalle[0][dorc_nprecio_unidad]" value="0" size="10" id='NU-N' onBlur="CalculaTotal(this);"/> </td>
									<td><input type="text" name="detalle[0][dorc_ndescuento]" value="0" size="10" id='NU-N' onBlur="CalculaTotal(this);"/> </td>
									<td><input type="text" name="detalle[0][dorc_nprecio_neto]" value="0" size="10" id='NU-N' readonly="yes"/> </td>
									<td><INPUT alt="agregar una nueva fila" class=boton TYPE="button" name="agregarlinea" value="+" onClick="validaFila('tb_busqueda_detalle','0',this)">&nbsp;<INPUT alt="quitar una fila existente" class=boton TYPE="button" name="quitarlinea" value="-" onClick="eliminaFilas()"></td>
								</tr>
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
								<td width="10%"><input type="text" name="<%=valor_neto%>" value="" size="10" id='NU-N'/></td>	
							</tr>
							<tr>
								<th><%=txt_variable%></th>
								<td><input type="text" name="<%=valor_variable%>" value="" size="10" id='NU-N'/></td>
							</tr>
							<% if v_boleta=2 then %>
							<tr>
								<th>Exento</th>
								<td><input type="text" name="exento" value="" size="10" id='NU-N'/></td>
							</tr>
							<%end if%>
							<tr>
								<th>Total</th>
								<td><input type="text" name="total" value="" size="10" id='NU-N'/></td>
							</tr>
							</table>
						</td>
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
					  </form>
					  <%=fin_com%>
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
                  <td width="240" bgcolor="#D8D8DE">
					  <table width="49%" height="19"  border="0" align="center" cellpadding="0" cellspacing="0">
						<tr>
						  <td width="30%"> <%botonera.dibujaboton "guardar"%> </td>
						  <td><%botonera.dibujaboton "salir"%></td>
						</tr>
					  </table>
				  </td>
                  <td  rowspan="2" align="left" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28" align="left"></td>
                  <td  rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28" align="right"></td>
                </tr>
                <tr>
                  <td height="8" valign="bottom" bgcolor="#D8D8DE" background="../imagenes/abajo_r2_c2.gif"></td>
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