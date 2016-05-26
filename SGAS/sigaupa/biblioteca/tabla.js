
var resultado;



function buscaElemento(n, d) { 
  var p,i,x;  
  if(!d) d=document;
  if((p=n.indexOf("?"))>0&&parent.frames.length) {
      d=parent.frames[n.substring(p+1)].document;
	  n=n.substring(0,p);
  }
  if(!(x=d[n])&&d.all)
  	x=d.all[n];
  for (i=0;!x&&i<d.forms.length;i++)
	x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++)
    x=buscaEl(n,d.layers[i].document);
  if(!x && document.getElementById)
    x=document.getElementById(n);
  return x;
}

function desenMascara(elemento) {
    numElementos = elemento.form.length;
	nombre = elemento.name.substr(1);

	for(i=0;i<numElementos;i++) {
		if(elemento.form[i].name == nombre)
		    elemento.value = elemento.form[i].value;
	}
	elemento.select();
}

function nada() {
}

function cambiaOculto(elemento, p_verdadero, p_falso) {
    numElementos = elemento.form.length;
	nombre = elemento.name.substr(1);
	for(i=0;i<numElementos;i++) {
		if(elemento.form[i].name == nombre) {
		    oculto = elemento.form[i];
		}
	}
	
	if (p_verdadero == '') {p_verdadero = '1'};
	if (p_falso == '') {p_falso = '0'};
	
	if (elemento.checked) {
		oculto.value = p_verdadero;
	}
	else {
		oculto.value = p_falso;
	}	
}
function enMascara(elemento,tipo,decimales) {
    numElementos = elemento.form.length;
	nombre = elemento.name.substr(1);
	for(i=0;i<numElementos;i++) {
		if(elemento.form[i].name == nombre) {
			if(elemento.value=='' ) {
		    	elemento.form[i].value = 0;
			}
			else if(Number(elemento.value) || elemento.value=='0') {
		    	elemento.form[i].value = elemento.value;	
			}
			else{
		    	valor = elemento.form[i].value;	
			}
		    valor = elemento.form[i].value;
		}
	}
	adicional = 0;
    switch(tipo) {
        case 'ENTERO':
		    posPto = valor.indexOf('.')==-1 ? valor.length : valor.indexOf('.');
			valor = valor.substring(0,posPto);		
		    salida = '';
			if((valor.length)%3>0)
				adicional = 1;
			iteraciones = ((valor.length)-(valor.length)%3)/3 + adicional ;
		    for(i=1;i<=iteraciones;i++) {
			    extra = valor.length-3*i < 0 ? valor.length-3*i : 0;
				if(i==1)
					salida = valor.substr(valor.length-3*i,3+extra) + salida;				
				else
					salida = valor.substr(valor.length-3*i,3+extra) + '.' + salida;
			}
			break;		    
	    case 2:
		    posPto = valor.indexOf('.')==-1 ? valor.length : valor.indexOf('.');
		    numDecimales = valor.length - posPto;
			parteDecimal = valor.indexOf('.')==-1 ? '0' : valor.substr(valor.length-numDecimales + 1);
			if(decimales<parteDecimal.length) {
				parteDecimal = parteDecimal.substr(0,decimales + 1);
				parteDecimal = Math.round(parteDecimal/10);
				if(decimales>parteDecimal.length) {
					for(i=0;i<=decimales-parteDecimal.toString().length;i++) {
						parteDecimal = '0' + parteDecimal;
					}
				}
			}
			else if(decimales>parteDecimal.length) {
			    for(i=0;i<=decimales-parteDecimal.length;i++) {
				    parteDecimal+= '0';
				}
			}
			if(decimales>0) {
		        salida = '.' + parteDecimal;
			}
			else {
				salida = '';
			}
			if((valor.length-numDecimales)%3>0)
				adicional = 1;
			iteraciones = ((valor.length-numDecimales)-(valor.length-numDecimales)%3)/3 + adicional ;
			 for(i=1;i<=iteraciones;i++) {
			    extra = valor.length-3*i-numDecimales < 0 ? valor.length-3*i-numDecimales : 0;
				if(i==1)
					salida = valor.substr(valor.length-3*i-numDecimales,3+extra) + salida;				
				else
					salida = valor.substr(valor.length-3*i-numDecimales,3+extra) + '.' + salida;
			}
			break;
	    case 'MONEDA':
		    posPto = valor.indexOf('.')==-1 ? valor.length : valor.indexOf('.');
		    numDecimales = valor.length - posPto;
			parteDecimal = valor.indexOf('.')==-1 ? '0' : valor.substr(valor.length-numDecimales + 1);
			if(decimales>=parteDecimal.length) {
			    for(i=0;i<=decimales-parteDecimal.length;i++) {
				    parteDecimal+= '0';
				}
			}
			else {
			    parteDecimal = parteDecimal.substr(0,decimales + 1);
				parteDecimal = Math.round(parteDecimal/10);
			}
			if(decimales>0) {
		        salida = '.' + parteDecimal;
			}
			else {
				salida = '';
			}
			if((valor.length-numDecimales)%3>0)
				adicional = 1;
			iteraciones = ((valor.length-numDecimales)-(valor.length-numDecimales)%3)/3 + adicional ;
		    for(i=1;i<=iteraciones;i++) {
			    extra = valor.length-3*i-numDecimales < 0 ? valor.length-3*i-numDecimales : 0;
				if(i==1)
					salida = valor.substr(valor.length-3*i-numDecimales,3+extra) + salida;				
				else
					salida = valor.substr(valor.length-3*i-numDecimales,3+extra) + '.' + salida;
			}
			if(salida=='')
				salida = 0;
			salida = '$ ' + salida;
			break;
		case 4:
			salida = valor;
			break;
		case 5:
			salida = valor;
			break;
		case 6:
			salida = valor;
			break;
	    case 7:
		    salida = valor.substr(valor.length-2);
			if((valor.length-2)%3>0)
				adicional = 1;			
			iteraciones = ((valor.length-2)-(valor.length-2)%3)/3 + adicional ;
		    for(i=1;i<=iteraciones;i++) {
			    extra = valor.length-3*i-2 < 0 ? valor.length-3*i-2 : 0;
				if(i==1)
					salida = valor.substr(valor.length-3*i-2,3+extra) + salida;				
				else
					salida = valor.substr(valor.length-3*i-2,3+extra) + '.' + salida;
			}
			break;
	}
	elemento.value=salida;
}

/*function enMascara(elemento,tipo,decimales,d) {

var valor;

    numElementos = elemento.form.length;
	nombre = d+elemento.name.substr(1);

	for(i=0;i<numElementos;i++) {
		if(elemento.form[i].name == nombre) {
			if(elemento.value=='' ) {
		    	elemento.form[i].value = 0;
			}
			else if(Number(elemento.value) || elemento.value=='0') {
		    	elemento.form[i].value = elemento.value;	
			}
			else{
		    	valor = elemento.form[i].value;	
			}
		    valor = elemento.form[i].value;
		}
	}
	adicional = 0;

    switch(tipo) {
        case 'ENTERO':
		    posPto = valor.indexOf('.')==-1 ? valor.length : valor.indexOf('.');
			valor = valor.substring(0,posPto);		
		    salida = '';
			if((valor.length)%3>0)
				adicional = 1;
			iteraciones = ((valor.length)-(valor.length)%3)/3 + adicional ;
		    for(i=1;i<=iteraciones;i++) {
			    extra = valor.length-3*i < 0 ? valor.length-3*i : 0;
				if(i==1)
					salida = valor.substr(valor.length-3*i,3+extra) + salida;				
				else
					salida = valor.substr(valor.length-3*i,3+extra) + '.' + salida;
			}
			break;		    
	    
		case 'DECIMAL':
		    posPto = valor.indexOf('.')==-1 ? valor.length : valor.indexOf('.');
		    numDecimales = valor.length - posPto;
			parteDecimal = valor.indexOf('.')==-1 ? '0' : valor.substr(valor.length-numDecimales + 1);
			if(decimales<parteDecimal.length) {
				parteDecimal = parteDecimal.substr(0,decimales + 1);
				parteDecimal = Math.round(parteDecimal/10);
				if(decimales>parteDecimal.length) {
					for(i=0;i<=decimales-parteDecimal.toString().length;i++) {
						parteDecimal = '0' + parteDecimal;
					}
				}
			}
			else if(decimales>parteDecimal.length) {
			    for(i=0;i<=decimales-parteDecimal.length;i++) {
				    parteDecimal+= '0';
				}
			}
			if(decimales>0) {
		        salida = '.' + parteDecimal;
			}
			else {
				salida = '';
			}
			if((valor.length-numDecimales)%3>0)
				adicional = 1;
			iteraciones = ((valor.length-numDecimales)-(valor.length-numDecimales)%3)/3 + adicional ;
		    for(i=1;i<=iteraciones;i++) {
			    extra = valor.length-3*i-numDecimales < 0 ? valor.length-3*i-numDecimales : 0;
				if(i==1)
					salida = valor.substr(valor.length-3*i-numDecimales,3+extra) + salida;				
				else
					salida = valor.substr(valor.length-3*i-numDecimales,3+extra) + '.' + salida;
			}
			break;
		
		case 2:
			
		    posPto = valor.indexOf('.')==-1 ? valor.length : valor.indexOf('.');
		    numDecimales = valor.length - posPto;
			parteDecimal = valor.indexOf('.')==-1 ? '0' : valor.substr(valor.length-numDecimales + 1);
			if(decimales<parteDecimal.length) {
				parteDecimal = parteDecimal.substr(0,decimales + 1);
				parteDecimal = Math.round(parteDecimal/10);
				if(decimales>parteDecimal.length) {
					for(i=0;i<=decimales-parteDecimal.toString().length;i++) {
						parteDecimal = '0' + parteDecimal;
					}
				}
			}
			else if(decimales>parteDecimal.length) {
			    for(i=0;i<=decimales-parteDecimal.length;i++) {
				    parteDecimal+= '0';
				}
			}
			if(decimales>0) {
		        salida = '.' + parteDecimal;
			}
			else {
				salida = '';
			}
			if((valor.length-numDecimales)%3>0)
				adicional = 1;
			iteraciones = ((valor.length-numDecimales)-(valor.length-numDecimales)%3)/3 + adicional ;
		    for(i=1;i<=iteraciones;i++) {
			    extra = valor.length-3*i-numDecimales < 0 ? valor.length-3*i-numDecimales : 0;
				if(i==1)
					salida = valor.substr(valor.length-3*i-numDecimales,3+extra) + salida;				
				else
					salida = valor.substr(valor.length-3*i-numDecimales,3+extra) + '.' + salida;
			}
			break;
	    
		case 'MONEDA':

		    posPto = valor.indexOf('.')==-1 ? valor.length : valor.indexOf('.');
		    numDecimales = valor.length - posPto;
			parteDecimal = valor.indexOf('.')==-1 ? '0' : valor.substr(valor.length-numDecimales + 1);
			if(decimales>=parteDecimal.length) {
			    for(i=0;i<=decimales-parteDecimal.length;i++) {
				    parteDecimal+= '0';
				}
			}
			else {
			    parteDecimal = parteDecimal.substr(0,decimales + 1);
				parteDecimal = Math.round(parteDecimal/10);
			}
			if(decimales>0) {
		        salida = '.' + parteDecimal;
			}
			else {
				salida = '';
			}
			if((valor.length-numDecimales)%3>0)
				adicional = 1;
			iteraciones = ((valor.length-numDecimales)-(valor.length-numDecimales)%3)/3 + adicional ;
		    for(i=1;i<=iteraciones;i++) {
			    extra = valor.length-3*i-numDecimales < 0 ? valor.length-3*i-numDecimales : 0;
				if(i==1)
					salida = valor.substr(valor.length-3*i-numDecimales,3+extra) + salida;				
				else
					salida = valor.substr(valor.length-3*i-numDecimales,3+extra) + '.' + salida;
			}
			if(salida=='')
				salida = 0;
			salida = '$ ' + salida;
			break;
		case 4:
			salida = valor;
			break;
		case 5:
			salida = valor;
			break;
		case 6:
			salida = valor;
			break;
	    case 7:
		    salida = valor.substr(valor.length-2);
			if((valor.length-2)%3>0)
				adicional = 1;			
			iteraciones = ((valor.length-2)-(valor.length-2)%3)/3 + adicional ;
		    for(i=1;i<=iteraciones;i++) {
			    extra = valor.length-3*i-2 < 0 ? valor.length-3*i-2 : 0;
				if(i==1)
					salida = valor.substr(valor.length-3*i-2,3+extra) + salida;				
				else
					salida = valor.substr(valor.length-3*i-2,3+extra) + '.' + salida;
			}
			break;
	}
	elemento.value=salida;
}*/

function comparaFechas(fecha1,fecha2) {
	var fecha_array = fecha1.split('/');
	valor1 =  Date.parse(fecha_array[1] + '/' + fecha_array[0] + '/' + fecha_array[2]);
	if(isNaN(valor1) || fecha1=='') {
		esFecha1 = false;
	}
	else {
		f1 = new Date(valor1);
		esFecha1 = f1.getDate() == fecha_array[0] && (f1.getMonth() + 1) == fecha_array[1] && f1.getFullYear() == fecha_array[2];
	}
	var fecha_array = fecha2.split('/');
	valor2 =  Date.parse(fecha_array[1] + '/' + fecha_array[0] + '/' + fecha_array[2]);
	if(isNaN(valor1) || fecha1=='') {
		esFecha1 = false;
	}
	else {
		f2 = new Date(valor2);
		esFecha2 = f2.getDate() == fecha_array[0] && (f2.getMonth() + 1) == fecha_array[1] && f2.getFullYear() == fecha_array[2];
	}
	return ( valor1 >= valor2 && esFecha1 && esFecha2 );
}

function validaFecha(fecha) {
	var fecha_array = fecha.split('/');
	valor1 =  Date.parse(fecha_array[1] + '/' + fecha_array[0] + '/' + fecha_array[2]);
	if(isNaN(valor1) || fecha=='') {
		esFecha1 = false;
	}
	else {
		f1 = new Date(valor1);
		esFecha1 = f1.getDate() == fecha_array[0] && (f1.getMonth() + 1) == fecha_array[1] && f1.getFullYear() == fecha_array[2];
	}
	return ( esFecha1 );
}

function irAjorge(pagina, donde) {
servidor=document.domain
origen=document.referrer

a=pagina.replace(/&/g,"*")

url="http://"+servidor+"/protic/sigadesa/biblioteca/validar_url.asp?pagina="+a+"&origen="+origen

	switch(donde) {	
		case '1':	
			resultado = open(url,'wAgregar','width=800px, height=400px, scrollbars=yes, resizable=yes');
			resultado.focus();
			break;
		case '2':
		default:
			self.location=url
			break;
	}
}

function irA(pagina,donde, ancho, alto){
switch(donde) {	
		case '1':	
			resultado = open(pagina,'wAgregar','width='+ancho+'px, height='+alto+'px, scrollbars=yes, resizable=yes');
			resultado.focus();
			break;
		case '2':
		default:
			self.location=pagina;
			break;
	}
}


function resaltar(campo) {
    campo.bgcolor = campo.parentElement.style.backgroundColor;
    campo.parentElement.style.backgroundColor = colores[1];
}

function desResaltar(campo) {
    campo.parentElement.style.backgroundColor = campo.bgcolor;
}

function recorrerRadio(d,variable,numFilas) {
    for(i=0;i<d.all.length;i++) {
	    if(d.all.item(i).name==variable) {
		    seleccionar(d.all.item(i));
		}
	}    
}

function seleccionar(campo) {
    if(campo.checked)
    	campo.parentElement.parentElement.style.backgroundColor = colores[2];
	else
    	campo.parentElement.parentElement.style.backgroundColor = colores[0];
}

function buscaItem(elemento,tipo) {
	if(elemento.tagName == 'HTML') {
		alert('Error: ' + tipo + ' no está disponible');
		return(false);
	}
	else if(elemento.tagName == tipo.toUpperCase()) {
			return(elemento);
	}
	else {
		elemento = elemento.parentElement;
		resp = buscaItem(elemento,tipo)
		return(resp);
	}
}

function accion1(idFormulario,boton,mensaje,accion) {
	formulario = boton.form;
    respuesta = true;
    if( mensaje != '' ) {
		respuesta=confirm(mensaje);
	}
	if(respuesta && formulario) {
		if( accion == '' ) {
			accion='include/eliminar.php?idFormulario=' + idFormulario;
		}
		formulario.action = accion;
		formulario.method = 'POST';
		formulario.submit();
	}
	return(false);
}

function accion2(idFormulario,boton,mensaje,accion) {
	formulario = boton.form;
    respuesta = true;
    if( mensaje != '' ) {
		respuesta=confirm(mensaje);
	}
	if(respuesta && formulario) {
		if( accion == '' ) {
			pagina='include/agregar.php?idFormulario=' + idFormulario;
			resultado = open(pagina,'wAgregar','width=800px, height=400px, scrollbars=yes, resizable=yes');
			resultado.focus();
		}
		else {
			formulario.action = accion;
			formulario.method = 'POST';
			formulario.submit();
		}
	}
	return(false);
}

function accion3(variable,campo,formulario) {
    patron = '_' + variable + '_' + campo; 
	var patronElemento = new RegExp(patron,"gi");
    for(i=0;i<formulario.length;i++) {
		elemento = formulario.elements[i];
		if(patronElemento.test(elemento.id)) {
			if(elemento.checked) {
				elemento.checked=false;
				seleccionar(elemento);
			}
		}
	}
}

function accion4(variable,campo,formulario) {
    patron = '_' + variable + '_' + campo; 
	var patronElemento = new RegExp(patron,"gi");
    for(i=0;i<formulario.length;i++) {
		elemento = formulario.elements[i];
		if(patronElemento.test(elemento.id)) {
			if(!elemento.checked) {
				elemento.checked=true;
				seleccionar(elemento);
			}
		}
	}
}

function accion5(idFormulario,boton,mensaje,accion,validacion) {
    formulario = boton.form;
    resp = true;
    if( mensaje != '' ) {
		resp=confirm(mensaje);
	}
	if(resp && formulario) {
		if( accion == '' ) {
			accion='include/modificar.php?idFormulario=' + idFormulario;
		}
		formulario.action = accion;
		formulario.method = 'POST';
		if( validacion != '' ) {
		   res = eval(validacion);
		   if(res) {
		      formulario.submit();
		   }
		}
        else {
			formulario.submit();
		}
	}
	return(false);
}

function accion8(boton,mensaje,accion) {
	formulario = boton.form;
    respuesta = true;
    if( mensaje != '' ) {
		respuesta=confirm(mensaje);
	}
	if(respuesta && formulario) {
		if( accion == '' ) {
			accion='guardar_salir.php';
		}
		formulario.action = accion;
		formulario.method = 'POST';
		formulario.submit();
	}
	return(false);
}

function accion9(boton,mensaje,accion) {
	formulario = boton.form;
    respuesta = true;
    if( mensaje != '' ) {
		respuesta=confirm(mensaje);
	}
	close();
	return(false);
}

function revisaVentana() {
    if(resultado != undefined ) {
		if(!resultado.closed) {
			resultado.focus();
		}
	}
}

function completaSelect(destino,clave){ 
//alert(destino+"-->"+clave);
   if(d.count==0)
   	  return(false);
	  
   argumentos = arguments.length;
   totalElementos = document.all.length; 
   for(i=0; i < totalElementos ; i++) {
   		if(document.all.item(i).name == destino) {
			elemento=document.all.item(i);
		}
   }
   base = d;
   for(i=2;i<argumentos;i++) {
	   for(j=0; j<totalElementos ; j ++) {
			if(document.all.item(j).name == arguments[i]) {
				prdc=document.all.item(j);
			}
	   }
   		base = base(prdc.value);	
   }
   paso = base;
   
   
   elemento.length = paso.count - 1;
   a = (new VBArray(paso.Keys())).toArray();
   j=0;
   for (i in a) {	   
      if(a[i]!='_valor') {
		elementoNuevo = new Option(paso(a[i])('_valor'),a[i]);
		elemento.options[j] = elementoNuevo
		if( a[i] == clave ) {
			elemento.options[j].selected = true;
		}
		j++;
	  }
   } 
}

var b_checked = false;
/*function SeleccionarTodo(formulario)
{   
    b_checked = b_checked ? false : true;
	
	for (i = 0; i < formulario.elements.length; i++) {	    
		if ( (formulario.elements[i].type == 'checkbox') && (formulario.elements[i].name != 'chk_selTodo') && (!formulario.elements[i].disabled)) {
		    formulario.elements[i].checked = b_checked;
			seleccionar(formulario.elements[i]);
		}
	}
}*/

function _SeleccionarTodo(formulario, p_variable, p_clave, p_nReg)
{	
	b_checked = !b_checked;
	
	for (i = 0; i < p_nReg; i++) {
		str_elemento = p_variable + "[" + i + "][" + p_clave + "]";		
		if (!formulario.elements[str_elemento].disabled) {			
		    formulario.elements[str_elemento].checked = b_checked;
			seleccionar(formulario.elements[str_elemento]);
		}
	}
}





/**************************** FUNCIONES PARA TABLAS FORMULARIO *********************************/
function _VariableCampo(objeto)
{
	var arr = objeto.name.split(/[\[\]]/);	
	return arr[0];	
}


function _ObtenerVariableCampo(objeto)
{
	var variable = _VariableCampo(objeto);		
	
	if (variable.charAt(0) == '_') {
		variable = variable.substr(1);
	}	
		
	return variable;
}

function _FilaCampo(objeto)
{
	var arr = objeto.name.split(/[\[\]]/);	
	return arr[1];
}

function _NombreCampo(objeto)
{
	var arr = objeto.name.split(/[\[\]]/);	
	return arr[2];
}


function NombreObjetoParalelo(nombre_campo, objeto)
{
	return(_ObtenerVariableCampo(objeto) + "[" + _FilaCampo(objeto) + "][" + nombre_campo + "]");	
}


function NroFilas(p_variable)
{
	var formulario;
	var reg = new RegExp("^" + p_variable + "\\[.+\\]\\[.+\\]$");
	
	var nmayor = -1;
	var nfila;
	
	for (var i = 0; i < document.forms.length; i++) {
		formulario = document.forms[i];
		
		for (var j = 0; j < formulario.elements.length; j++) {
			if (formulario.elements[j].name.search(reg) >= 0) {
				nfila = _FilaCampo(formulario.elements[j]);
				
				if (parseInt(nfila) >= parseInt(nmayor)) {
					nmayor = nfila;
				}
			}
		}
	}
	
	return parseInt(nmayor) + 1;
}


function _HabilitarFila(p_habilitado)
{
	for (var i = 0; i < this.campos.length; i++) {
		if (this.campos[i].objeto.type != 'hidden') {
			this.campos[i].objeto.setAttribute("disabled", !p_habilitado);		
		}
	}
	
}

function _HabilitarFilaPorCampo(p_habilitado, p_campo)
{
	for (var i = 0; i < this.campos.length; i++) {
		if (this.campos[i].objeto.type != 'hidden') {
			if (this.campos[i].nombreCampo != p_campo) {
				this.campos[i].objeto.setAttribute("disabled", !p_habilitado);		
			}
		}
	}
	
}


function _BuscarCamposFila(p_fila)
{
	var p_variable = p_fila.tabla.variable;
	var p_nfila = p_fila.fila;
	var formulario;
	var reg = new RegExp("^" + p_variable + "\\[" + p_nfila + "\\]\\[.+\\]$");	
	var ncampos = 0;
	var nombre_campo;
	
	for (var i = 0; i < document.forms.length; i++) {
		formulario = document.forms[i];
		
		for (var j = 0; j < formulario.elements.length; j++) {
			if (formulario.elements[j].name.search(reg) >= 0) {
				nombre_campo = _NombreCampo(formulario.elements[j]);
				p_fila.campos[nombre_campo] = new CCampoTabla(p_fila, ncampos, formulario.elements[j]);
				p_fila.campos[ncampos] = new CCampoTabla(p_fila, ncampos, formulario.elements[j]);
				ncampos++;								
				
				p_fila.tabla.formulario = formulario;
			}
		}
	}
	
	return ncampos;
}


function CCampoTabla(p_fila, p_icampo, p_objeto)
{
	this.fila = p_fila;
	this.columna = p_icampo;	
	this.objeto = p_objeto;	
	this.nombreCampo = _NombreCampo(p_objeto);
	this.valorInicial = p_objeto.value;
}

function CFilaTabla(p_tabla, p_fila)
{
	this.tabla = p_tabla;
	this.fila = p_fila;		
	this.campos = new Array();		
	_BuscarCamposFila(this);	
	
	this.Habilitar = _HabilitarFila;
	this.HabilitarPorCampo = _HabilitarFilaPorCampo;
	this.ExisteCampo = _ExisteCampoFila;
	
}


function _ExisteCampoFila(p_nombrecampo)
{
	for (var i = 0; i < this.campos.length; i++) {
		if (this.campos[i].nombreCampo == p_nombrecampo) {
			return true;
		}
	}
	return false;
}

function _ExisteCampoTabla(p_fila, p_nombrecampo)
{
	if ( (p_fila < 0) || (p_fila >= this.filas.length) ) {
		return false;
	}
	
	for (var i = 0; i < this.filas[p_fila].campos.length; i++) {
		if (this.filas[p_fila].campos[i].nombreCampo == p_nombrecampo) {
			return true;
		}
	}
	
	return false;
}

function _CuentaSeleccionadosTabla(p_campo)
{
	var nseleccionados = 0;
	//var tabla_alt = new CTabla("_" + this.variable);
	
	for (var i = 0; i < this.filas.length; i++) {		
		switch (this.filas[i].campos[p_campo].objeto.type) {
			case 'hidden' :
				/*if (tabla_alt.filas[i].campos[p_campo].objeto.checked)
					nseleccionados++;*/
				if ((this.filas[i].campos[p_campo].objeto.value == 'S') || ((this.filas[i].campos[p_campo].objeto.value == '1')))
					nseleccionados++;					
				break;
				
			case 'checkbox' :
				if (this.filas[i].campos[p_campo].objeto.checked)
					nseleccionados++;
				break;
		}
		
	}
			
	return nseleccionados;
}

function _ObtenerValorTabla(p_fila, p_campo)
{
	var valor = "";
			
	if (this.ExisteCampo(p_fila, p_campo)) {
		valor = this.filas[p_fila].campos[p_campo].objeto.value;
	}
	
	return valor;
}


function _SumarColumnaTabla(p_columna)
{
	var suma = 0;
	var valor;
	
	for (var i = 0; i < this.filas.length; i++) {
		valor = this.ObtenerValor(i, p_columna);
		
		if (valor == '')
			valor = 0;
			
		suma += parseFloat(valor);
	}
	
	return suma;
}

function _AsignarValorTabla(p_fila, p_campo, p_valor)
{
	if (this.ExisteCampo(p_fila, p_campo)) {
		this.filas[p_fila].campos[p_campo].objeto.value = p_valor;
	}
}

function CTabla(p_variable)
{
	this.variable = p_variable;
	this.formulario = null;
	
	var nfilas = NroFilas(p_variable);	
	this.filas = new Array(nfilas);	
	
	for (var i = 0; i < nfilas; i++) {
		this.filas[i] = new CFilaTabla(this, i);
	}
	
	this.ExisteCampo = _ExisteCampoTabla;
	this.CuentaSeleccionados = _CuentaSeleccionadosTabla;
	this.ObtenerValor = _ObtenerValorTabla;
	this.SumarColumna = _SumarColumnaTabla;
	this.AsignarValor = _AsignarValorTabla;
}
/***********************************************************************************************************/