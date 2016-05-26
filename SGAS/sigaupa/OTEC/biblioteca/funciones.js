
Hoy = new Date();
DiaHoy = Hoy.getDate();
MesHoy = Hoy.getMonth();
AnoHoy = Hoy.getYear();
if (AnoHoy < 2000) AnoHoy += 1900; //Para Netscape

//Funcion para retornar cuantos dias hay en un mes, incluyendo un año bisiesto  //
function DiasEnMes(QueMes, QueAno)
{
  var DiasEnMes = 31;
  if (QueMes == "ABRIL" || QueMes == "JUNIO" || QueMes == "SEPTIEMBRE" || QueMes == "NOVIEMBRE") DiasEnMes = 30;
  if (QueMes == "FEBRERO" && (QueAno/4) != Math.floor(QueAno/4))	DiasEnMes = 28;
  if (QueMes == "FEBRERO" && (QueAno/4) == Math.floor(QueAno/4))	DiasEnMes = 29;
  return DiasEnMes;
}
//Funcion para cambiar los dias validos de un mes 
function CambiaOpcionDia(TipoSelect)
{
  ObjetoDia = eval("document.formulario." + TipoSelect + "Dia");
  ObjetoMes = eval("document.formulario." + TipoSelect + "Mes");
  ObjetoAno = eval("document.formulario." + TipoSelect + "Ano");

  Mes = ObjetoMes[ObjetoMes.selectedIndex].text;
  Ano = ObjetoAno[ObjetoAno.selectedIndex].text;

  DiasParaEsteMes = DiasEnMes(Mes, Ano);
  ActualesDiasEnMes = ObjetoDia.length;
  if (ActualesDiasEnMes > DiasParaEsteMes)
  {
    for (i=0; i<(ActualesDiasEnMes-DiasParaEsteMes); i++)
    {
      ObjetoDia.options[ObjetoDia.options.length - 1] = null
    }
  }
  if (DiasParaEsteMes > ActualesDiasEnMes)
  {
    for (i=0; i<(DiasParaEsteMes-ActualesDiasEnMes); i++)
    {
      NewOption = new Option(ObjetoDia.options.length + 1);
      ObjetoDia.add(NewOption);
    }
  }
    if (ObjetoDia.selectedIndex < 0) ObjetoDia.selectedIndex == 0;
}

//Funcion para iniciar los select al dia actual
function SeteaFecha(TipoSelect)
{
  ObjetoDia = eval("document.formulario." + TipoSelect + "Dia");
  ObjetoMes = eval("document.formulario." + TipoSelect + "Mes");
  ObjetoAno = eval("document.formulario." + TipoSelect + "Ano");

  ObjetoMes[MesHoy].selected = true;

  CambiaOpcionDia(TipoSelect);

  ObjetoDia[DiaHoy-1].selected = true;
}

//Funcion para escribir el rango dee años que apareceran en el select
function RangoDeAnos(RangoAnos)
{
  AnoInicial= 2002;
  linea = "";
  for (i=0; i<RangoAnos; i++)
  {
  AnoTemp = AnoInicial+i
    if (AnoHoy == (AnoTemp)){
	 opcion="Selected";
	}
	else{
	 opcion= "" ;
	 }
    linea += "<OPTION "+opcion+" >";
    linea += AnoInicial - i;
  }
  return linea;
}
function bloquearTeclas(codigo,campo) {
		if(codigo != 219){
			return codigo;
		}
		return false;
	}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}




//  End  

/* FUNCIONES AGREGADAS POR PAULO */

function  prueba() {
	var conta = cont(document.buscador)
	var j
i=0;
repe=0;
	for(i=0;i<=conta-1;i++){
		for (j=1;j<=conta-1;j++){
			var a =MM_findObj('esec['+i+'][secc_tdesc]')
			var a1=a.value
			var b =MM_findObj('esec['+j+'][secc_tdesc]')
			var b1=b.value
			if( a1 == b1){
				repe=repe+1;
			}
		}
	}
	if (repe>(conta-1))	{
		alert('Repetido');
	}
	else{
		alert('no repetido');
	}
}

function cont(formulario)
{
cont=0;
var num_elementos=formulario.length
for (i=0;i < num_elementos;i++){
	 if (formulario.elements[i].name=(MM_findObj('esec['+i+'][secc_tdesc]'))){
	    cont=cont+1;
		}
	}
	alert(cont);
}

/* FIN FUNCIONES AGREGADAS POR PAULO */


function CerrarActualizar()
{
opener.location.reload();
close();
}


msj_confirma_eliminar = '¿Está seguro que desea eliminar los registros seleccionados?';
msj_no_seleccionados = 'No ha seleccionado ningún registro para eliminar.'
msj_confirma_actualizar = '¿Está seguro que desea actualizar estos registros?';
directorio_botones = "../imagenes/botones/";


function _OverBoton(p_tabla)
{
	nombreBoton = p_tabla.id;

	document.all[nombreBoton + "c11"].src = directorio_botones + "boton1_2.gif";
	document.all[nombreBoton + "c12"].src = directorio_botones + "boton2_2.gif";
	document.all[nombreBoton + "c13"].src = directorio_botones + "boton4_2.gif";	
	document.all[nombreBoton + "c21"].bgColor = "#52525F";
	document.all[nombreBoton + "f21"].color = "#FFFFFF";	
	document.all[nombreBoton + "c31"].src = directorio_botones + "boton3_2.gif";
}

function _OutBoton(p_tabla)
{
	nombreBoton = p_tabla.id;
	
	document.all[nombreBoton + "c11"].src = directorio_botones + "boton1.gif";
	document.all[nombreBoton + "c12"].src = directorio_botones + "boton2.gif";
	document.all[nombreBoton + "c13"].src = directorio_botones + "boton4.gif";	
	document.all[nombreBoton + "c21"].bgColor = "#EEEEF0";	
	document.all[nombreBoton + "f21"].color = "#333333";
	document.all[nombreBoton + "c31"].src = directorio_botones + "boton3.gif";
}


function _CuentaSeleccionados(formulario)
{
	return 1;
}

function _HabilitarBoton(p_boton, p_habilitado)
{

	var o_boton = document.all[p_boton.id];

	if (!p_habilitado) {
		o_boton.className = 'noclick';
		o_boton.onmouseover = null;
		o_boton.onclick = null;		
		document.all[p_boton.id + "f21"].innerHTML = '<i>' + document.all[p_boton.id + "f21"].innerHTML + '...</i>';
	}
}


function _Eliminar(p_boton, formulario, p_url, p_mensaje_confirmacion, p_soloUnClick)
{
	var mensaje = (isEmpty(p_mensaje_confirmacion)) ? msj_confirma_eliminar : p_mensaje_confirmacion;
	var v_soloUnClick = (p_soloUnClick.toUpperCase() == 'TRUE') ? true : false;
	
//	if (_CuentaSeleccionados(formulario) > 0 ) {
	if (verifica_check(formulario)) {	
		//if (confirm(mensaje)) {				
			formulario.action = p_url;
			formulario.method = "post";
			formulario.submit();
			
			_HabilitarBoton(p_boton, !v_soloUnClick);
		//}
	}
/*	else {
		alert(_ObtenerMsjNoSeleccionados(p_texto_boton));
	}*/
}

function _Agregar(p_boton, p_url, p_izquierda, p_arriba, p_ancho, p_alto, p_scroll, p_soloUnClick)
{
	var v_soloUnClick = (p_soloUnClick.toUpperCase() == 'TRUE') ? true : false;
	
	str_scroll = (p_scroll == 'TRUE') ? 'yes' : 'no';	
	
	str_parametros = "resizable, top=" + p_arriba + ", left=" + p_izquierda + ", width=" + p_ancho + ", height=" + p_alto + ", scrollbars=" + str_scroll;
	resultado = window.open(p_url, "ventana", str_parametros);
	
	_HabilitarBoton(p_boton, !v_soloUnClick);
}


function _Buscar(p_boton, formulario, p_url, p_funcion_validacion, p_soloUnClick)
{
	var v_soloUnClick = (p_soloUnClick.toUpperCase() == 'TRUE') ? true : false;
	
	if (preValidaFormulario(formulario)) {		
		if (p_funcion_validacion != "")	{	
			eval("_form_valido = " + p_funcion_validacion);
		}
		else
			_form_valido = true;			
		
		if (_form_valido) {
			formulario.action = p_url;
			formulario.method = "get";
			formulario.submit();
			
			_HabilitarBoton(p_boton, !v_soloUnClick);
		}		
	}
	
}


function _CerrarVentana()
{
	window.close();
}


function _Navegar(p_boton, p_url, p_soloUnClick)
{
	var v_soloUnClick = (p_soloUnClick.toUpperCase() == 'TRUE') ? true : false;
	navigate(p_url);
	_HabilitarBoton(p_boton, !v_soloUnClick);
}


function _Actualizar(p_boton, formulario, p_url, p_funcion_validacion, p_mensaje_confirmacion, p_soloUnClick)
{
	var mensaje = (isEmpty(p_mensaje_confirmacion)) ? msj_confirma_actualizar : p_mensaje_confirmacion;
	var v_soloUnClick = (p_soloUnClick.toUpperCase() == 'TRUE') ? true : false;
	
	if (confirm(mensaje)) {
		if (preValidaFormulario(formulario)) {
			
			if (p_funcion_validacion != "")			
				eval("_form_valido = " + p_funcion_validacion);
			else
				_form_valido = true;
				
			if (_form_valido) {
				formulario.action = p_url;
				formulario.method = "post";
				formulario.submit();
				
				_HabilitarBoton(p_boton, !v_soloUnClick);
			}			
		}
	}
}


function _Guardar(p_boton, formulario, p_url, p_target, p_funcion_validacion, p_mensaje_confirmacion, p_soloUnClick)
{
	var continuar = true;
	var v_soloUnClick = (p_soloUnClick.toUpperCase() == 'TRUE') ? true : false;
	
	
	if (p_mensaje_confirmacion != "") {
		continuar = confirm(p_mensaje_confirmacion);
	}	
	
	if (continuar) {
		if (preValidaFormulario(formulario)) {			
			if (p_funcion_validacion != "")			
				eval("_form_valido = " + p_funcion_validacion);
			else
				_form_valido = true;			
			
			if (_form_valido) {
				formulario.action = p_url;
				formulario.method = "post";
				formulario.target = p_target;
				formulario.submit();
				
				_HabilitarBoton(p_boton, !v_soloUnClick);
			}			
		}		
	}
}


function _ProcesaBoton(p_boton, p_accion, p_url)
{
	arr_accion = p_accion.split(/-/);		
	v_accion = arr_accion[0].toUpperCase();

	switch (v_accion) {
		case 'ELIMINAR' :			
			formulario = document.forms[arr_accion[1]];
			texto_boton = document.all[p_boton.id + "f21"].innerText.toLowerCase().replace(/ +$/, "");
			_Eliminar(formulario, p_url, texto_boton);
			break;
			
		case 'AGREGAR' :
			_Agregar(p_url, arr_accion[1], arr_accion[2], arr_accion[3], arr_accion[4], arr_accion[5]);
			break;
			
		case 'ACTUALIZAR' :
			formulario = document.forms[arr_accion[1]];
			_Actualizar(formulario, p_url);
			break;
			
		case 'GUARDAR' :
			formulario = document.forms[arr_accion[1]];
			_Guardar(formulario, p_url);
			break;			
			
		case 'BUSCAR' :
			formulario = document.forms[arr_accion[1]];
			_Buscar(formulario);
			break;
			
		case 'CERRAR' :
			_CerrarVentana();
			break;
			
		case 'NAVEGAR' :
			_Navegar(p_url);
			break;
	
		default :
			eval(p_url);
			break;
	}
}





function _ProcesaBotonXML(p_boton, p_accion, p_url, p_parametros)
{
	arr_parametros = p_parametros.split(/-/);	

	switch (p_accion) {
		case 'ELIMINAR' :			
			formulario = document.forms[arr_accion[0]];
			_Eliminar(formulario, p_url);
			break;
			
		case 'AGREGAR' :
			_Agregar(p_url, arr_accion[0], arr_accion[1], arr_accion[2], arr_accion[3]);
			break;
			
		case 'ACTUALIZAR' :
			formulario = document.forms[arr_accion[0]];
			_Actualizar(formulario, p_url);
			break;
			
		case 'GUARDAR' :
			formulario = document.forms[arr_accion[0]];
			_Guardar(formulario, p_url);
			break;			
			
		case 'BUSCAR' :
			formulario = document.forms[arr_accion[0]];
			_Buscar(formulario);
			break;
			
		case 'CERRAR' :
			_CerrarVentana();
			break;
			
		case 'NAVEGAR' :
			_Navegar(p_url);
			break;
	
		default :
			eval(p_url);
			break;
	}
}



function _FiltrarCombobox(p_combobox, p_valor_referencia, p_diccionario, p_campo_referencia, p_campo_clave, p_campo_salida, p_seleccionado, p_mensaje_nulo)
{	
	p_combobox.length = 0;
	op = new Option((p_mensaje_nulo) ? p_mensaje_nulo : "Seleccionar", "");	
	p_combobox.add(op);
	
	for (i in (new VBArray(p_diccionario.Keys())).toArray()) {
		if (p_diccionario.Item(i).Item(p_campo_referencia) == p_valor_referencia) {			
			op = new Option(p_diccionario.Item(i).Item(p_campo_salida), p_diccionario.Item(i).Item(p_campo_clave));
			
			if (p_diccionario.Item(i).Item(p_campo_clave) == p_seleccionado)
				op.selected = true;
				
			p_combobox.add(op);
		}		
	}
}


function ValorRadioButton(p_radio)
{
	for (var i = 0; i < p_radio.length; i++) {
		if (p_radio[i].checked) {
			return p_radio[i].value;
		}
	}
	
	return "";
}

function getRadioValue(p_radio)
{
	return (ValorRadioButton(p_radio));
}

function setRadioValue(p_radio, p_valor)
{
	for (var i = 0; i < p_radio.length; i++) {
		if (p_radio[i].value == p_valor) {
			p_radio[i].checked = true;
			return;
		}
	}
}


function Redondear(num, dec) {
    num = parseFloat(num);
    dec = parseFloat(dec);
    return Math.round(num * Math.pow(10, dec)) / Math.pow(10, dec);
}

/*function obtener_fecha(objeto)
{
var fecha = document.edicion.fecha_oculta.value;
  if (objeto == "1") 
	{
	  document.edicion.elements["m[0][asig_fini_vigencia_p]"].value = fecha
    }
  else
    {
	  document.edicion.elements["m[0][asig_ffin_vigencia]"].value = fecha 
    }
}*/



function verifica_check(form,msg){
// Creada: 16-06-2004 ; Autor : Luis O.
// Desc: Funcion que, dado un formulario FORM, cuenta entre sus elementos todas las 
//       variables tipo CHECKBOX. Si confirma el ALERT de eliminación, retorna TRUE; si no, FALSE.
//agregado mensaje variable :> Mario Riffo. 
 if (!msg){
 	msg_accion	="anular";
 }else{
 	if (msg==1){
		msg_accion="Depositar";
	}else if (msg==2){
		msg_accion="Conciliar";
	}else{
 		msg_accion= msg;
	}
 }
   nro = form.elements.length;
   num =0;
   for( i = 0; i < nro; i++ ) {
	  comp = form.elements[i];
	  str  = form.elements[i].name;
	  if((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo')){
	     num += 1;
	  }
   }
   if( num > 0 ) {
		if(confirm('Ud. ha seleccionado '+ num +' registros para '+ msg_accion +'. ¿Desea continuar?')){
			return true;
		}
		else{
			return false;
		}
   }
   else{
      alert('Ud. no ha seleccionado ningún registro para '+ msg_accion +' ');
	  return false;
   }	
}

function LTrim(s){
        // Devuelve una cadena sin los espacios o caracteres especiales del principio
        var i=0;
        var j=0;
		
        // Busca el primer caracter <> de un espacio, salto o tabulador
        for(i=0; i<=s.length-1; i++)
                if((s.substring(i,i+1) != ' ')||(s.substring(i,i+1) != '\n')||(s.substring(i,i+1) != '\t')){
                        j=i;
                        break;
                }
        return s.substring(j, s.length);
}
function RTrim(s){
        // Devuelve una cadena sin los espacios o caracteres especiales del final de la cadena
        var j=0;
        // Busca el último caracter <> de un espacio, salto o tabulador
        for(var i=s.length-1; i>-1; i--)
                if((s.substring(i,i+1) != ' ')||(s.substring(i,i+1) != '\n')||(s.substring(i,i+1) != '\t')){
                        j=i;
                        break;
                }
        return s.substring(0, j+1);
}

function Trim(s){
        // Quita los caracteres especiales al inicio y al final
        return LTrim(RTrim(s));
}


function  extrae_indice(cadena){
	var posicion1 = cadena.indexOf("[",0)+1;
	var posicion2 = cadena.indexOf("]",0);
	var indice=cadena.substring(posicion1, posicion2);
	return indice;
}