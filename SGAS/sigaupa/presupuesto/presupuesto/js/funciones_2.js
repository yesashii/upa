var x = $(document);
x.ready(inicio);
function inicio()
{
	var x = $("#conceptoP");
	x.attr("disabled", "disabled");
	//return false;
}
//
//Funciones para los combos----------
function traeComboFoco(valor)
{
controlDeCampos();
traeComboPrograma(0);
traeComboProyecto(0);
	urlAux="presupuesto/trozosHtml/comboFoco.asp?valor="+valor;
	 $.ajax({
			  async:true,
			  type: "GET",			  
			  url: urlAux,
			  //beforeSend:inicioEnvioCombo_1,
			  success:llegadaCombo_1,
			  error:problemasCombo_1
			}); 
  return false;
}
function inicioEnvioCombo_1()
{
  var x=$("#ComboFoco");
  x.html('Cargando...');  
}
function llegadaCombo_1(datos)
{
	
	var x = $("#ComboFoco");
	x.html(datos);
	return false;
}
function problemasCombo_1()
{
  $("#ComboFoco").text('Problemas en el servidor.');
  return false;
}
function traeComboPrograma(valor)
{
controlDeCampos();
traeComboProyecto(0);
traeComboObjetivo(0);
	urlAux="presupuesto/trozosHtml/comboPrograma.asp?valor="+valor;
	 $.ajax({
			  async:true,
			  type: "GET",			  
			  url: urlAux,
			  //beforeSend:inicioEnvioCombo_2,
			  success:llegadaCombo_2,
			  error:problemasCombo_2
			}); 
  return false;
}	
function inicioEnvioCombo_2()
{
  var x=$("#ComboPrograma");
  x.html('Cargando...');  
}
function llegadaCombo_2(datos)
{
	
	var x = $("#ComboPrograma");
	x.html(datos);
	return false;
}
function problemasCombo_2()
{
  $("#ComboPrograma").text('Problemas en el servidor.');
  return false;
}
//---
function traeComboProyecto(valor)
{
traeDetaProyecto(0);//resetea el valor del detalle del proyecto.
	urlAux="presupuesto/trozosHtml/comboProyecto.asp?valor="+valor;
	 $.ajax({
			  async:true,
			  type: "GET",			  
			  url: urlAux,
			  //beforeSend:inicioEnvioCombo_3,
			  success:llegadaCombo_3,
			  error:problemasCombo_3
			}); 
  return false;
}	
function inicioEnvioCombo_3()
{
  var x=$("#ComboProyecto");
  x.html('Cargando...');  
}
function llegadaCombo_3(datos)
{
	
	var x = $("#ComboProyecto");
	x.html(datos);	
	return false;
}
function problemasCombo_3()
{
  $("#ComboProyecto").text('Problemas en el servidor.');
  return false;
}
//-------
function traeDetaProyecto(valor)
{
	urlAux="presupuesto/trozosHtml/detaProyecto.asp?valor="+valor;
	 $.ajax({
			  async:true,
			  type: "GET",			  
			  url: urlAux,
			  //beforeSend:inicioEnvioDeta,
			  success:llegadaDeta,
			  error:problemasDeta
			}); 
  return false;
}
function inicioEnvioDeta()
{
  var x=$("#detalleProyecto");
  x.html('Cargando...');  
}
function llegadaDeta(datos)
{
	
	var x = $("#detalleProyecto");
	x.css("display","none");
	x.fadeIn("slow").html(datos);
	return false;
}
function problemasDeta()
{
  $("#detalleProyecto").text('Problemas en el servidor.');
  return false;
}	
//---
function traeComboObjetivo(valor)
{
	traeDetaObjetivo(0);//resetea el valor del detalle del Objetivo.
	urlAux="presupuesto/trozosHtml/comboObjetivo.asp?valor="+valor;
	 $.ajax({
			  async:true,
			  type: "GET",			  
			  url: urlAux,
			  //beforeSend:inicioEnvioCombo_3,
			  success:llegadaCombo_5,
			  error:problemasCombo_5
			}); 
  return false;
}	
function inicioEnvioCombo_5()
{
  var x=$("#ComboObjetivo");
  x.html('Cargando...');  
}
function llegadaCombo_5(datos)
{
	
	var x = $("#ComboObjetivo");
	x.html(datos);	
	return false;
}
function problemasCombo_5()
{
  $("#ComboObjetivo").text('Problemas en el servidor.');
  return false;
}
//---------------
//-------
function traeDetaObjetivo(valor)
{
	urlAux="presupuesto/trozosHtml/detaObjetivo.asp?valor="+valor;
	 $.ajax({
			  async:true,
			  type: "GET",			  
			  url: urlAux,
			  //beforeSend:inicioEnvioDeta,
			  success:llegadaDetaO,
			  error:problemasDetaO
			}); 
  return false;
}
function inicioEnvioDetaO()
{
  var x=$("#detalleObjetivo");
  x.html('Cargando...');  
}
function llegadaDetaO(datos)
{
	
	var x = $("#detalleObjetivo");
	x.css("display","none");
	x.fadeIn("slow").html(datos);
	return false;
}
function problemasDetaO()
{
  $("#detalleObjetivo").text('Problemas en el servidor.');
  return false;
}	
//-------------------------------------------------
function cambiaComboConcepto( a, b)
{
//alert("prueba");
traeNuevoDetalle(0);
	urlAux="presupuesto/trozosHtml/comboDetalle.asp?valor="+b;
	 $.ajax({
			  async:true,
			  type: "GET",			  
			  url: urlAux,
			  //beforeSend:inicioEnvioDeta,
			  success:llegadaConcepto,
			  error:problemasConcepto
			}); 
  return false;

}
function llegadaConcepto(datos)
{
	var y = $("#tablaTotal");
	y.css("display","none");
	var z = $("#estado_1");
	z.css("display","none");
	var x = $("#detPresupuesto");
	x.css("display","none");
	x.fadeIn("slow").html(datos);
	return false;
}
function problemasConcepto()
{
  $("#detPresupuesto").text('Problemas en el servidor.');
  return false;
}	
//Funciones para los combos----------
//
function traeNuevoDetalle(valor_a)
{
	if(valor_a != 0)
	{
		var concepto	= document.solicitud.elements['busqueda[0][codcaja]'].value
		traeTablaMeses(concepto);
	}		
	urlAux="presupuesto/trozosHtml/agregaDetalle.asp?valor="+valor_a;
	$.ajax({
			async:true,
			type: "GET",			  
			url: urlAux,
			//beforeSend:inicioEnvioDeta,
			success:llegadatraeNuevoDetalle,
			error:problemastraeNuevoDetalle
			}); 
			return false;
}
function llegadatraeNuevoDetalle(datos)
{
	
	var x = $("#agregarDetalle");
	x.css("display","none");
	x.fadeIn("slow").html(datos);
	return false;
}
function problemastraeNuevoDetalle()
{
  $("#agregarDetalle").text('Problemas en el servidor.');
  return false;
}	

//-----------------------------------------------------delSistema
function GrabarRegistro() //se activa cuando se da a grabar registros
{	
	enviar_1();
	//formulario=document.forms['solicitud'];
	//formulario.action = "proc_grabar_solicitud.asp";
	//formulario.method = "post";
	//formulario.submit(); 

}
function enviar_1()
{	
 //alert("enviar_1");
 urlAux="presupuesto/proc/procesaPresu_1.asp";
 $.ajax({
			  async:true,
			  type: "POST",
			  //dataType: "asp",
			  data: $("form#solicitud").serialize(),
			  contentType: "application/x-www-form-urlencoded",
			  url: urlAux,
			  //beforeSend:inicioEnvio,
			  success:llegada,
			  //timeout:10000,
			  error:problemas
			}); 
 return false;
}
function inicioEnvio()
{
  var x=$("#estado_1");
  x.html(
 '<div id="contieneCarga">'+ 
 '<div id="cargando">Cargando...</div>'+
 '</div>'
  );  
}
function problemas()
{
  $("#estado_1").text('Problemas en el servidor.');
  return false;
}
function llegada(datos)
{

	var x = $("#estado_1");
	x.css("display","none");
	//x.fadeOut("fast");
	//x.fadeIn("slow").html(datos);
	x.slideDown( 900).html(datos);
	//x.delay(4000).fadeOut("slow");	
	//x.hide();	
  	//x.fadeOut("slow").hide().html(datos).fadeIn("slow").show();
	return false;
}


//
function traeTablaMeses(cod_pre)
{
var area_ccod	= document.solicitud.elements['busqueda[0][area_ccod]'].value
var eje_ccod  	= document.solicitud.elements['selCombo'].value
var foco_ccod	= document.solicitud.elements['selCombo2'].value
var prog_ccod   = document.solicitud.elements['selCombo3'].value
var proye_ccod 	= document.solicitud.elements['selCombo4'].value
var obje_ccod   = document.solicitud.elements['selCombo5'].value

	
//alert("prueba="+cod_pre);// +"&eje_ccod="+eje_ccod
	urlAux="presupuesto/trozosHtml/tablaMeses.asp?valor="+cod_pre+"&eje_ccod="+eje_ccod+"&foco_ccod="+foco_ccod+"&prog_ccod="+prog_ccod+"&proye_ccod="+proye_ccod+"&obje_ccod="+obje_ccod+"&area_ccod="+area_ccod;
	$.ajax({
			async:true,
			type: "GET",			  
			url: urlAux,
			//beforeSend:inicioEnvioDeta,
			success:llegadaMeses,
			error:llegadaMesesError
			}); 
			return false;
}
function llegadaMeses(datos)
{	
	var x = $("#tablaTotal");
	x.css("display","none");
	x.fadeIn("slow").html(datos);
	return false;
}
function llegadaMesesError()
{
  $("#tablaTotal").text('Problemas en el servidor.');
  return false;
}
//-------------------------------------------------------------
function FormatoMoneda(valor){
//alert(valor.length);
//	var x=document.getElementsByName(valor);
//	
//	salida = '';	
//		while( valor.length > 3 )		
//		{		
//		 salida = '.' + valor.substr(valor.length - 3) + salida;		
//		 valor = valor.substring(0, valor.length - 3);		
//		}		
//		salida = valor + salida;
//		salida = '$ ' + salida;
//	return salida;
}

//---------------------
function GuardarDetalle()
{
var v_area_ccod		= document.solicitud.elements['busqueda[0][area_ccod]'].value //v_area_ccod
var codcaja			= document.solicitud.elements['busqueda[0][codcaja]'].value //codcaja
var v_nuevo_detalle = document.solicitud.elements['busqueda[0][nuevo_detalle]'].value//v_nuevo_detalle
var v_dpre_ncorr	= document.solicitud.elements['selCombo6'].value

	urlAux="presupuesto/proc/proc_agrega_detalle.asp?v_area_ccod="+v_area_ccod+"&codcaja="+codcaja+"&v_nuevo_detalle="+v_nuevo_detalle+"&v_dpre_ncorr="+v_dpre_ncorr;
	//alert(urlAux);
	$.ajax({
			async:true,
			type: "GET",			  
			url: urlAux,
			//beforeSend:inicioEnvioDeta,
			success:llegadaGuardarDetalle,
			error:GuardarDetallesError
			}); 
			return false;

}
function llegadaGuardarDetalle(datos)
{	
	alert("detalle guardado");
	var x = $("#estado_1");
	x.css("display","none");
	x.fadeIn("slow").html(datos);
	//x.delay(4000).fadeOut("slow");	
	//--------------------------------reseteando comboDetalle
	var codcaja			= document.solicitud.elements['busqueda[0][codcaja]'].value
	cambiaComboConcepto( 0, codcaja)
	
	return false;
}
function GuardarDetallesError()
{
  $("#estado_1").text('Problemas en el servidor.');
  return false;
}
//------------------------------------------------------------>>funciones de control>>
function controlDeCampos()
{
	var eje			= document.solicitud.elements['selCombo'].value //codcaja
	var programa	= document.solicitud.elements['selCombo2'].value
	if( eje == 100)
	{
		var x = $("#conceptoP");
		x.removeAttr("disabled");
	}
	if( programa != 0)
	{
		var x = $("#conceptoP");
		x.removeAttr("disabled");
	}
}
//------------------------------------------------------------>>funciones de control<<






















