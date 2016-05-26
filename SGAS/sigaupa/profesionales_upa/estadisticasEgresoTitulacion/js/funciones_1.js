var x = $(document);
x.ready(inicio);
function inicio()
{
	inicioDePagina();
	cargaAnioPromo();
	cargaAnioTitu();
	cargaAnioEgre();
}

//-----------------------------------------------------------------------Carga de combos años>>
function cargaAnioPromo()
{		
  	var url = 'estadisticasEgresoTitulacion/trozosHtml/anioPromo.asp'	
  	$.ajax({
			  async:true,
			  type: "GET",
			  contentType: "application/x-www-form-urlencoded",
			  url: url,
			  success:cargaAnioPromo_2
			}); 
  	return false;
}
function cargaAnioPromo_2(datos)
{			
	var x = $("#anioPromo");
	x.html(datos);
	return false;
}
function cargaAnioTitu()
{			
  	var url = 'estadisticasEgresoTitulacion/trozosHtml/anioTitu.asp'	
  	$.ajax({
			  async:true,
			  type: "GET",
			  contentType: "application/x-www-form-urlencoded",
			  url: url,
			  success:cargaAniotitu_2
			}); 
  	return false;
}
function cargaAniotitu_2(datos)
{			
	var x = $("#anioTitu");
	x.html(datos);
	return false;
}
function cargaAnioEgre()
{			
  	var url = 'estadisticasEgresoTitulacion/trozosHtml/anioEgre.asp'	
  	$.ajax({
			  async:true,
			  type: "GET",
			  contentType: "application/x-www-form-urlencoded",
			  url: url,
			  success:cargaAnioEgre_2
			}); 
  	return false;
}
function cargaAnioEgre_2(datos)
{			
	var x = $("#anioEgre");
	x.html(datos);
	return false;
}
//-----------------------------------------------------------------------Carga de combos años<<
//---------------------------------------------------->>Control de opciones de búsqueda
function inicioDePagina()
{
	inabilitaEstado();
	inabilitaCombos();
	inabilitaGeneros();
}
//--------->>Control de los clicks en institución
function controlClikPregrado()
{
	inicioDePagina();
	//--
	$("#chkUpaPosGrado").attr('checked', false); 
	$("#chkinstiprofe").attr('checked', false); 
	//-----------
	$("#chKEstaEgre").attr('disabled', false);	
	$("#chKEstaTitu").attr('disabled', false);		
	$("#chkSalInter").attr('disabled', false);		
}
function controlClikPostgrado()
{
	inicioDePagina();	
	$("#chkUpaPreGrado").attr('checked', false); 
	$("#chkinstiprofe").attr('checked', false); 
	//---------
	$("#chKEstaEgre").attr('disabled', true);
	$("#chKEstaTitu").attr('disabled', true);
	$("#chkSalInter").attr('disabled', true);
	$("#chKEstaEgre").attr('checked', false); 
	$("#chKEstaTitu").attr('checked', false); 
	$("#chkSalInter").attr('checked', false); 
	//---------
	$("#chKEstaGradu").attr('disabled', false);		
}
function controlClikInstituto()
{
	inicioDePagina();	
	$("#chkUpaPreGrado").attr('checked', false); 
	$("#chkUpaPosGrado").attr('checked', false); 
	//----
	$("#chKEstaGradu").attr('disabled', true);
	$("#chkSalInter").attr('disabled', true);
	$("#chKEstaGradu").attr('checked', false); 
	$("#chkSalInter").attr('checked', false); 
	//----
	$("#chKEstaEgre").attr('disabled', false);	
	$("#chKEstaTitu").attr('disabled', false);	
	if(soloInstituto())
	{
		inabilitaCombos();
	}	
}
function soloInstituto()
{
	var estaChequeadoInstituto = $("#chkinstiprofe").is(':checked');
	if(estaChequeadoInstituto)
	{
		var retorno = true;	
		var UpaPregrado = $("#chkUpaPreGrado").is(':checked');
		var UpaPosgrado = $("#chkUpaPosGrado").is(':checked');
		var almenosUnoDeLosOtrosDos = (UpaPregrado||UpaPosgrado);
		if(almenosUnoDeLosOtrosDos)
		{
			retorno = false;
		}
	}else{
		var retorno = false;	
	}
	return retorno;
}
//---------<<Control de los clicks en institución

//--------->>Control de los clicks en estado
function controlClickEgresados()
{
	if(existeAlgunEstado())
	{
		habilitaGeneros();
		if( !$("#chkinstiprofe").is(':checked') )
		{
			habilitaCombos();
		}
	}else{		
		inabilitaGeneros();
		inabilitaCombos();
	}
}
function controlClickTitulados()
{
	if(existeAlgunEstado())
	{
		habilitaGeneros();
		if( !$("#chkinstiprofe").is(':checked') )
		{
			habilitaCombos();
		}
	}else{		
		inabilitaGeneros();
		inabilitaCombos();
	}
}
function controlClickGraduados()
{
	if(existeAlgunEstado())
	{
		habilitaGeneros();
		habilitaCombos();
	}else{		
		inabilitaGeneros();
		inabilitaCombos();
	}
}
function controlClickSalInter()
{
	if(existeAlgunEstado())
	{
		habilitaGeneros();
		habilitaCombos();
	}else{		
		inabilitaGeneros();
		inabilitaCombos();
	}
}
function existeAlgunEstado()
{
	var retorno = false;
	var egresados = $("#chKEstaEgre").is(':checked');
	var titulados = $("#chKEstaTitu").is(':checked');
	var graduados = $("#chKEstaGradu").is(':checked');
	var salInter = $("#chkSalInter").is(':checked');
	var total = egresados||titulados||graduados||salInter;
	if(total)
	{
		retorno = true;
	}
	return retorno;
}
//---------<<Control de los clicks en estado

//--------->>Control de los clicks en los generos
function controlClickFeme()
{
	var estaMascuTiqueado = $("#chekMascu").is(':checked');
	if(!estaMascuTiqueado)
	{
		 $("#chekMascu").attr('checked',true);
	}
}
function controlClickMascu()
{
	var estaFemeTiqueado = $("#chekFeme").is(':checked');
	if(!estaFemeTiqueado)
	{
		 $("#chekFeme").attr('checked',true);
	}
}
//---------<<Control de los clicks en los generos

function inabilitaEstado()
{
	$("#chKEstaEgre").attr('disabled', true);	
	$("#chKEstaTitu").attr('disabled', true);
	$("#chKEstaGradu").attr('disabled', true);
	$("#chkSalInter").attr('disabled', true);
	//---------
	$("#chKEstaEgre").attr('checked', false);
	$("#chKEstaTitu").attr('checked', false);
	$("#chKEstaGradu").attr('checked', false);
	$("#chkSalInter").attr('checked', false);
}
function reseteaCombos()
{
	$("#selectFacultad").val("0");
	$("#selectCarrera").val("0");
}
function inabilitaCombos()
{
	$("#comboCarrera").attr('disabled', true);
	$("#comboFacultad").attr('disabled', true);
	reseteaCombos();
}
function habilitaCombos()
{
	$("#comboCarrera").attr('disabled', false);
	$("#comboFacultad").attr('disabled', false);
}
function inabilitaGeneros()//---desactiva el boton buscar
{
	$("#chekMascu").attr('disabled', true);
	$("#chekFeme").attr('disabled', true);
	$("#chekMascu").attr('checked', false);
	$("#chekFeme").attr('checked', false);	
	desabilitaBotonBuscar()
}
function habilitaGeneros()//---activa el boton buscar
{
	$("#chekMascu").attr('disabled', false);
	$("#chekFeme").attr('disabled', false);
	//--
	$("#chekMascu").attr('checked', true);
	$("#chekFeme").attr('checked', true);	
	//--
	habilitaBotonBuscar();
	
}
function desabilitaBotonBuscar()
{
	$("#bt_buscar").css('display','none');
}
function habilitaBotonBuscar()
{
	$("#bt_buscar").css('display','block');
}
//---------------------------------------------------->>Control de opciones de búsqueda
function enviar(formulario)
{
	//******************
	var upa_pregrado = document.getElementById("chkUpaPreGrado").checked;
	var upa_postgrado = document.getElementById("chkUpaPosGrado").checked;
	var instituto = document.getElementById("chkinstiprofe").checked;
	//--
	var Egresados 			= document.getElementById("chKEstaEgre").checked;
	var Titulados 			= document.getElementById("chKEstaTitu").checked;
	var Graduados			= document.getElementById("chKEstaGradu").checked;
	//------------------	
	envio = "no";
	if(upa_pregrado)
	{
		envio = "si";
	}
	if(instituto)
	{
		if( ( Egresados || Titulados ) )
		{
			envio = "si";
		}else{	
			envio = "no";
			alert("Se pretende buscar por 'Instituto'\n y no se tiene seleccionado ni egresados ni titulados");
		}
	}
	if(upa_postgrado)
	{
		if( Graduados )
		{
			envio = "si"
		}else{
			envio = "no";
			alert("Se pretende buscar por 'UPA Postgrado'\n y no se tiene seleccionado Graduados");
		}
	}	
	if(envio == "si")
	{
		enviar_2();
	}else{
		return false;
	}		
}
function irA2(auxUrl,valorCelda)
{
	 //onclick="window.open('pagina.html','window','params')
	 //alert(auxUrl);
//var x=$("#tResutados1");
//x.html(auxUrl); 

	if(valorCelda != "0")
	{
		 $.ajax({
			  async:true,
			  type: "GET",
			  url: auxUrl,
			  //url:"resultado_1.asp",
			  beforeSend:inicioEnvio,
			  success:llegada
			  //timeout:10000,
			 // error:problemas
			}); 
  return false;
	}else{
		alert("Esta facultad no presenta resultados");
	}	
	return false;
}
function irA2_1(auxUrl,valorCelda)
{
//alert(auxUrl);
//var x=$("#tResutados1");
//x.html(auxUrl); 
		 $.ajax({
			  async:true,
			  type: "GET",
			  url: auxUrl,
			  //url:"resultado_1.asp",
			  beforeSend:inicioEnvio,
			  success:llegada,
			  //timeout:10000,
			  error:problemas
			});   
	return false;
}
function enviar_2()
{
  $.ajax({
			  async:true,
			  type: "POST",
			  //dataType: "asp",
			  data: $("form#miForm").serialize(),
			  contentType: "application/x-www-form-urlencoded",
			  url: "estadisticasEgresoTitulacion/vistas/resultado_1.asp",
			  //url:"resultado_1.asp",
			  beforeSend:inicioEnvio,
			  success:llegada,
			  //timeout:10000,
			  error:problemas
			}); 
  return false;
}
function debugProblemas(datos)
{
var x = $("#tResutados1");
	x.html(datos);
	return false;
}
function inicioEnvio()
{
  var x=$("#tResutados1");
  x.html(
 '<div id="contieneCarga">'+ 
 '<div id="cargando">Cargando...</div>'+
 '</div>'
  );  
}
function esconde()
{
	var x=$("#tResutados1");
  	x.hide('fast');
}
function problemas()
{
  $("#tResutados1").text('Problemas en el servidor.');
  return false;
}					
function llegada(datos)
{

	var x = $("#tResutados1");
	x.css("display","none");
	//x.fadeOut("fast");
	//x.fadeIn("slow").html(datos);
	x.slideDown( 900).html(datos);
	//x.hide();	
  	//x.fadeOut("slow").hide().html(datos).fadeIn("slow").show();
	return false;
}
			
function abreEcxel(url)
{
	alert(	"Se está por generar un archivo Excel,"+
			"dependiendo de la cantidad de datos, este "+
			"documento podría tomar unos minutos en generarse.");
	window.open(url);//, '_blank');
    return false;
}
//Método encargado de actualizar el combo box--------------------------------------->>
function traeComboCarreras(valor)
{
	urlAux="estadisticasEgresoTitulacion/trozosHtml/comboCarreras.asp?valor="+valor;
	 $.ajax({
			  async:true,
			  type: "GET",			  
			  url: urlAux,
			  beforeSend:inicioEnvioCombo,
			  success:llegadaCombo,
			  error:problemasCombo
			}); 
  return false;
}
function llegadaCombo(datos)
{
	
	var x = $("#comboCarrera");
	x.css("display","none");
	x.fadeIn("slow").html(datos);
	return false;
}
function inicioEnvioCombo()
{
  var x=$("#comboCarrera");
  x.html('Cargando...');  
}

function problemasCombo()
{
  $("#selectCarrera").text('Problemas en el servidor.');
  return false;
}	
//Método encargado de actualizar el combo box---------------------------------------<<

//Función validadora del Rut Alumni-----------------------------------------------
function validaRut()
{
	var parte_1 = $("#rut_alumni_1").val();
	var parte_2 = $("#digito_verificador").val();
	var rutFormateado = $.Rut.formatear(parte_1+parte_2); 
	//alert(rutFormateado);
	var esValido = $.Rut.validar(rutFormateado); 		
  	if(esValido)
	{
		//Válido
	}else{
		//No Válido
	}
}
function generaDigito()
{
	var aux = $("#rut_alumni_1").val();	
	var p_1 = $.Rut.getDigito(aux); 
	if(p_1 == 'k')
	{
		var p_2 = p_1.toUpperCase();
	}else{
		var p_2 = p_1;
	}	
	$("#digito_verificador").val(p_2); 
	//$("#digito_verificador").select();	
}
function verificarNan()
{
	var aux = $("#rut_alumni_1").val();	
	var neun = isNaN(aux);
	if(neun)
	{
		$("#rut_alumni_1").val('');
	}else{
		generaDigito();
	}
}
//Función validadora del Rut Alumni----------------------------------------------->>

function ValidarDatos_l()//esta funcion es la que abre la ventana de ingreso de rut alumni.
{
	var ancho 	= (screen.width/2) - 150;
	var alto 	= 0;//(screen.height/2);
	url="rut_alumni.asp";
	window.open(url,"rut_alumni","top="+alto+",left="+ancho+",resizable=no,width=300,height=200,scrollbars=yes");

}
function submit_1()
{
	$('form#edicion').submit();
}
function envio_alumni()
{
	var valorAux = $("#rut_alumni_1").val(); 			
  	var url = 'estadisticasEgresoTitulacion/trozosHtml/comprueba_alumni.asp?rut_persona='+valorAux		
  	$.ajax({
			  async:true,
			  type: "GET",
			  contentType: "application/x-www-form-urlencoded",
			  url: url,
			  beforeSend:inicioEnvio,
			  success:pre_paso
			}); 
  	return false;
}
function pre_paso(datos)
{
	var respuesta = datos;
	if(respuesta=='ok')
	{
		submit_1();
	}else
	{
		alert('No existen registros en alumni de esta persona.');
		$("#rut_alumni_1").select(); 
	}
	return false;
}

//Función validadora del Rut Alumni----------------------------------------------->>











