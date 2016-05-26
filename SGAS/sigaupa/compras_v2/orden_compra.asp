<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Orden de Compra"

v_fecha_inicio 		= request.querystring("busqueda[0][mcaj_finicio]")
v_estado_caja	 	= request.querystring("busqueda[0][eren_ccod]")
v_cajero 			= request.querystring("busqueda[0][caje_ccod]")
v_sede 				= request.querystring("busqueda[0][sede_ccod]")
v_tipo_caja			= request.querystring("busqueda[0][tcaj_ccod]")
v_fecha_termino 	= request.querystring("busqueda[0][fecha_termino]")
v_num_caja			= request.querystring("busqueda[0][mcaj_ncorr]")
v_ingr_nfolio		= request.querystring("busqueda[0][ingr_nfolio]")
v_fecha_traspaso	= request.querystring("busqueda[0][fecha_traspaso]")  
 
area_ccod	= request.querystring("busqueda[0][area_ccod]")

rut 	= request.querystring("pers_nrut")
digito 	= request.querystring("pers_xdv")


set botonera = new CFormulario
botonera.carga_parametros "orden_compra.xml", "botonera"

set conectar = new cconexion
conectar.inicializar "upacifico"

set conexion = new Cconexion2
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar


if area_ccod="" then
 area_ccod= 1
end if


'**********************************************************
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
v_usuario = negocio.ObtenerUsuario()
sede=negocio.obtenerSede

'**********************************************************
set f_busqueda2 = new CFormulario
f_busqueda2.Carga_Parametros "orden_compra.xml", "buscador"
f_busqueda2.Inicializar conexion
f_busqueda2.Consultar "select ''"
f_busqueda2.Siguiente

 f_busqueda2.AgregaCampoParam "area_ccod", "filtro",  "area_ccod in ( select area_ccod from  presupuesto_upa.protic.area_presupuesto_usuario  where rut_usuario in ('"&v_usuario&"') )"
 f_busqueda2.AgregaCampoCons "area_ccod", area_ccod

set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "orden_compra.xml", "datos_proveedor"
f_busqueda.Inicializar conectar
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

f_busqueda.AgregaCampoCons "pers_nrut", rut
f_busqueda.AgregaCampoCons "pers_xdv", digito

if rut<>"" then
	set f_personas = new CFormulario
	f_personas.carga_parametros "tabla_vacia.xml", "tabla_vacia"
	f_personas.inicializar conectar
	sql_datos_persona="Select top 1 * from personas a, direcciones b where a.pers_ncorr=b.pers_ncorr and pers_nrut="&rut
	f_personas.consultar sql_datos_persona
	f_personas.Siguiente
	
	'response.Write(sql_datos_persona)
	
	f_busqueda.AgregaCampoCons "pers_tnombre", f_personas.obtenerValor("pers_tnombre")
	f_busqueda.AgregaCampoCons "dire_tcalle", f_personas.obtenerValor("dire_tcalle")
	f_busqueda.AgregaCampoCons "dire_tnro", f_personas.obtenerValor("dire_tnro")
	f_busqueda.AgregaCampoCons "pers_tfono", f_personas.obtenerValor("pers_tfono")
	f_busqueda.AgregaCampoCons "pers_tfax", f_personas.obtenerValor("pers_tfax")
	f_busqueda.AgregaCampoCons "ciud_ccod", f_personas.obtenerValor("ciud_ccod")
end if


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

set f_tipo_gasto = new CFormulario
f_tipo_gasto.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_tipo_gasto.inicializar conectar
sql_tipo_gasto= "Select * from ocag_tipo_gasto"
f_tipo_gasto.consultar sql_tipo_gasto

set f_cod_pre = new CFormulario
f_cod_pre.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_cod_pre.inicializar conexion
sql_codigo_pre="select distinct cod_pre, concepto_pre +' ('+cod_pre+')' as valor from presupuesto_upa.protic.codigos_presupuesto where cod_area in ('"&area_ccod&"')"
f_cod_pre.consultar sql_codigo_pre


set f_centro_costo = new CFormulario
f_centro_costo.carga_parametros "tabla_vacia.xml", "tabla_vacia"
f_centro_costo.inicializar conectar
sql_centro_costo="select distinct top 10 ccos_ccod,ccos_tcompuesto from centros_costo"
f_centro_costo.consultar sql_centro_costo
'*****************************************************************************************
'***************	FIN listas de seleccion para filas de tabla dinamica	**************


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

<SCRIPT language="JavaScript">




function BuscarPersona(){

	formulario = document.detalle;
	v_rut	=	formulario.elements["busqueda[0][pers_nrut]"].value;
	v_xdv	=	formulario.elements["busqueda[0][pers_xdv]"].value;
	rut_alumno = formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value;	
	if (formulario.elements["busqueda[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].focus();
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	  }
	location.href="orden_compra.asp?pers_nrut="+v_rut+"&pers_xdv="+v_xdv;
}

function Enviar(){
	
	//validar campos vacios
	return true;
}
//var contador={contador};
var contador=1;

function validaFila(id, nro,boton)
{
	if (document.detalle.elements["detalle["+nro+"][dorc_tdesc]"].value == '')
      {alert('Debe ingresar una descripcion valida');}

	if (document.detalle.elements["detalle["+nro+"][dorc_nprecio_unitario]"].value != '')
	  {addRow(id, nro, boton );habilitaUltimoBoton();}
     else
      {alert('Debe completar las filas del detalle para ingresar a la orden de compra');}

//addRow(id, nro, boton );bloqueaFila(nro);
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
var aElement=document.createElement("<INPUT TYPE=\"checkbox\" name=\"check\" value=\""+ contador +"\"  >");
td1.appendChild (aElement);

//********tgas_ccod********************
var td2 = document.createElement("TD");
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
td2.appendChild (iElement);

//********dorc_tdesc********************
var td3 = document.createElement("TD");
var iElement=document.createElement("<INPUT TYPE=\"text\" name=\"detalle["+ contador +"][dorc_tdesc]\" size=\"10\" >");
td3.appendChild (iElement)


//********ccos_ccod********************
var td4 = document.createElement("TD");

var iElement=document.createElement("select");
iElement.name="detalle["+ contador +"][ccos_ccod]";
i=0;
<%	while f_centro_costo.Siguiente %>
i=i+1;
	var v_option=document.createElement("Option");
	v_option.value='<%=f_centro_costo.ObtenerValor("ccos_ccod")%>';// Valor del option
	v_option.innerHTML="<%=f_centro_costo.ObtenerValor("ccos_tcompuesto")%>"; // texto del option
	iElement.appendChild(v_option);	
<%wend%>
td4.appendChild (iElement)

//********cod_pre********************
var td5 = document.createElement("TD");
var iElement=document.createElement("select");
iElement.name="detalle["+ contador +"][cod_pre]";
i=0;
<%	while f_cod_pre.Siguiente %>
i=i+1;
	var v_option=document.createElement("Option");
	v_option.value='<%=f_cod_pre.ObtenerValor("cod_pre")%>';// Valor del option
	v_option.innerHTML="<%=f_cod_pre.ObtenerValor("valor")%>"; // texto del option
	iElement.appendChild(v_option);	
<%wend%>	
td5.appendChild (iElement);

//********mes_ccod********************
var td6 = document.createElement("TD");
var iElement=document.createElement("select");
iElement.name="detalle["+ contador +"][mes_ccod]";
i=0;
<%	while f_meses.Siguiente %>
i=i+1;
	var v_option=document.createElement("Option");
	v_option.value=<%=f_meses.ObtenerValor("mes_ccod")%>;// Valor del option
	v_option.innerHTML='<%=f_meses.ObtenerValor("mes_tdesc")%>'; // texto del option
	iElement.appendChild(v_option);	
<%wend%>	
td6.appendChild (iElement)

//********dorc_ncantidad********************
var td7 = document.createElement("TD");
var iElement=document.createElement("<INPUT TYPE=\"text\" name=\"detalle["+ contador +"][dorc_ncantidad]\" size=\"10\" maxlength=\"10\">");
td7.appendChild (iElement)

//********tmon_ccod********************
var td8 = document.createElement("TD");
var iElement=document.createElement("select");
iElement.name="detalle["+ contador +"][tmon_ccod]";
i=0;
<%	while f_monedas.Siguiente %>
i=i+1;
	var v_option=document.createElement("Option");
	v_option.value=<%=f_monedas.ObtenerValor("tmon_ccod")%>;// Valor del option
	v_option.innerHTML='<%=f_monedas.ObtenerValor("tmon_tdesc")%>'; // texto del option
	iElement.appendChild(v_option);
<%wend%>	
td8.appendChild (iElement)

//********dorc_nprecio_unitario********************
var td9 = document.createElement("TD");
var iElement=document.createElement("<INPUT TYPE=\"text\" name=\"detalle["+ contador +"][dorc_nprecio_unitario]\" size=\"10\" maxlength=\"10\">");
td9.appendChild (iElement)

//********dorc_ndescuento********************
var td10 = document.createElement("TD");
var iElement=document.createElement("<INPUT TYPE=\"text\" name=\"detalle["+ contador +"][dorc_ndescuento]\" size=\"10\" onblur=\"CalculaTotal(this)\" maxlength=\"10\">");
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
row.appendChild(td5);
row.appendChild(td6);
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


function RecalcularTotales()
{
	
	//alert("aaaaaa");
	var formulario = document.forms["detalle"];
	v_total_solicitud = 0;
	for (var i = 1; i <= contador; i++) {
	//alert("eeeeeeeeee");
		v_valor	=	formulario.elements["detalle["+i+"][dorc_nprecio_neto]"].value;
		//alert(formulario.elements["detalle["+i+"][dorc_nprecio_neto]"].value);
		if (v_valor){
			v_total_solicitud = v_total_solicitud + parseInt(v_valor);
		}
	}
	
	detalle.neto.value	=	eval(v_total_solicitud);
	detalle.total.value	=	Math.round(v_total_solicitud*1.19)
	detalle.iva.value	=	eval(Math.round(v_total_solicitud*1.19)-v_total_solicitud);

}


function CalculaTotal(objeto){

	indice=extrae_indice(objeto.name);
	if(indice!=""){
		v_cantidad	=	detalle.elements["detalle["+indice+"][dorc_ncantidad]"].value;
		v_unidad	=	detalle.elements["detalle["+indice+"][dorc_nprecio_unitario]"].value;		
		v_descuento	=	detalle.elements["detalle["+indice+"][dorc_ndescuento]"].value;	
		v_neto		=	eval(v_cantidad*(v_unidad-v_descuento));
		
		detalle.elements["detalle["+indice+"][dorc_nprecio_neto]"].value=v_neto;
	}

RecalcularTotales()
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
              <td height="8" background="../imagenes/top_r1_c2.gif"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
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
              <td background="../imagenes/top_r3_c2.gif"><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
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
                <td valign="top" bgcolor="#D8D8DE" background="../imagenes/base2.gif"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>	
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Orden de compra </font></div></td>
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
					<form name="detalle">	
						<table width="100%" border="1">
						  <tr> 
							<td width="11%">Rut</td>
							<td width="27%"> <%f_busqueda.dibujaCampo("pers_nrut")%>
							  -<%f_busqueda.dibujaCampo("pers_xdv")%> <input type="button" value="Buscar" onClick="javascript:BuscarPersona();"/></td>
							<td width="14%">Atenci&oacute;n</td>
							<td colspan="3"> <%f_busqueda.dibujaCampo("ordc_tatencion")%></td>
						  </tr>
						  <tr> 
							<td> Se&ntilde;ores </td>
							<td> <%f_busqueda.dibujaCampo("pers_tnombre")%> </td>
							<td> N&deg; Cotizacion </td>
							<td width="48%"> <%f_busqueda.dibujaCampo("ordc_ncotizacion")%></td>
						  </tr>
						  <tr> 
							<td>Direccion</td>
							<td> <%f_busqueda.dibujaCampo("dire_tcalle")%> N°:<%f_busqueda.dibujaCampo("dire_tnro")%></td>
							<td> Cond. Pago </td>
							<td> <%f_busqueda.dibujaCampo("cpag_ccod")%> </td>
						  </tr>
						  <tr> 
							<td>Ciudad</td>
							<td><%f_busqueda.dibujaCampo("ciud_ccod")%></td>
							<td>Observacion</td>
							<td><%f_busqueda.dibujaCampo("ordc_tobservacion")%></td>
						  </tr>
						  <tr>
							<td>Telefono</td>
							<td><%f_busqueda.dibujaCampo("pers_tfono")%></td>
							<td>Fax</td>
							<td><%f_busqueda.dibujaCampo("pers_tfax")%></td>
						  </tr>
						</table>
					
                      <table width="100%" border="0">
                        <tr> 
                          <td><hr/></td>
                        </tr>
                        <tr> 
                          <td align="center">
								<table width="100%" border="1">
									<tr> 
										<td width="11%">Solicitado por </td>
										<td width="27%"> <%f_busqueda.dibujaCampo("ordc_tcontacto")%>
										  </td>
										<td width="14%">Lugar Entrega</td>
										<td colspan="3"> <%f_busqueda.dibujaCampo("sede_ccod")%></td>
									</tr>
									<tr> 
										<td> Telefono </td>
										<td> <%f_busqueda.dibujaCampo("ordc_tfono")%> </td>
										<td>Fecha entrega </td>
										<td width="48%"> <%f_busqueda.dibujaCampo("ordc_fentrega")%> 
										(dd/mm/aaaa) </td>
										<td><%f_busqueda.dibujaCampo("ordc_bole_honorario")%> Boleta</td>
									</tr>
								</table>
						  </td>
                        </tr>
                        <tr>
                              <td align="right"><hr/></td>
                        </tr>
						<tr>
							<td>
							
								
								<table class="v1" border='1' bordercolor='#999999' bgcolor='#ADADAD' cellpadding='0' cellspacing='0' id=tb_busqueda_detalle>
								<tr bgcolor='#C4D7FF' bordercolor='#999999'>
									<th>N°</th>
									<th>Tipo Gasto</th>
									<th>Descripcion</th>
									<th>C. Costo</th>
									<th>Cod. Presupuesto </th>
									<th>mes/año</th>
									<th>Cantidad</th>
									<th>Moneda</th>
									<th>Precio Unitario</th>
									<th>Descuento($)</th>
									<th>Precio Neto</th>
									<th>(+/-)</th>
								</tr>
								<tr bgcolor='#FFFFFF'>
									<td><input type="checkbox" name="detalle[1][checkbox]" value=""></td>
									<td>
										<select name="detalle[1][tgas_ccod]">
										<%f_tipo_gasto.primero%>
										<%while f_tipo_gasto.Siguiente %>
											<option value="<%=f_tipo_gasto.ObtenerValor("tgas_ccod")%>" ><%=f_tipo_gasto.ObtenerValor("tgas_tdesc")%></option>
										<%wend%>
										</select>
									</td>
									<td><input type="text" name="detalle[1][dorc_tdesc]" value="" size="10" id='TO-N'/>  </td>
									<td>
										<select name="detalle[1][ccos_ccod]">
										<%f_centro_costo.primero%>
										<%while f_centro_costo.Siguiente %>
											<option value="<%=f_centro_costo.ObtenerValor("ccos_ccod")%>" ><%=f_centro_costo.ObtenerValor("ccos_tcompuesto")%></option>
										<%wend%>
										</select>
									</td>
									<td><select name="detalle[1][cod_pre]">
										<%f_cod_pre.primero%>
										<%while f_cod_pre.Siguiente %>
											<option value="<%=f_cod_pre.ObtenerValor("cod_pre")%>" ><%=f_cod_pre.ObtenerValor("valor")%></option>
										<%wend%>
										</select>
									</td>
									<td>
										<select name="detalle[1][mes_ccod]">
										<%f_meses.primero%>
										<%while f_meses.Siguiente %>
											<option value="<%=f_meses.ObtenerValor("mes_ccod")%>" ><%=f_meses.ObtenerValor("mes_tdesc")%></option>
										<%wend%>
										</select>
									</td>
									<td><input type="text" name="detalle[1][dorc_ncantidad]" value="" size="10" id='NU-N'/> </td>
									<td>
										<select name="detalle[1][tmon_ccod]">
										<%f_monedas.primero%>
										<%while f_monedas.Siguiente %>
											<option value="<%=f_monedas.ObtenerValor("tmon_ccod")%>" ><%=f_monedas.ObtenerValor("tmon_tdesc")%></option>
										<%wend%>
										</select>
									</td>
									<td><input type="text" name="detalle[1][dorc_nprecio_unitario]" value="" size="10" id='NU-N'/> </td>
									<td><input type="text" name="detalle[1][dorc_ndescuento]" value="" size="10" id='NU-N' onBlur="CalculaTotal(this);"/> </td>
									<td><input type="text" name="detalle[1][dorc_nprecio_neto]" value="" size="10" id='NU-N' readonly="yes"/> </td>
									<td><INPUT alt="agregar una nueva fila" class=boton TYPE="button" name="agregarlinea" value="+" onClick="validaFila('tb_busqueda_detalle','1',this)">&nbsp;<INPUT alt="quitar una fila existente" class=boton TYPE="button" name="quitarlinea" value="-" onClick="eliminaFilas()"></td>
								</tr>
								</table>
								<br>
								
							</td>
						</tr>
						<tr>
						<td>
						<table border="1" >
							<tr>
								<td><strong><font color="000000" size="1">La factura debe ser extendida en detalle, desglosandose por servicio o articulo con sus respectivos valores unitarios y cantidades, ademas debe incluir una copia de la orden de compra o incluir el numero de esta en la factura.</font></strong></td>
								<td>
								<input type="text" name="neto" value="" size="10" id='NU-N'/>
								<br>
								<input type="text" name="iva" value="" size="10" id='NU-N'/>
								<br>
								<input type="text" name="total" value="" size="10" id='NU-N'/>
								</td>	
							</tr>
							</table>
						
						</td>
						</tr>
                      </table>
					  
					  </form>
					  
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
					  <td><%botonera.dibujaboton "excel"%></td>
                    </tr>
                  </table>                </td>
                  <td width="430" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="7" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
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
