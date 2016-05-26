<!-- #include file = "../biblioteca/_conexion.asp" -->


<%

'---------------------------------------------------------------------------------------------------
'set pagina = new CPagina
'pagina.Titulo = "Encuesta Así soy yo"
'---------------------------------------------------------------------------------------------------
'secc_ccod=request.Form("secc")
set conexion = new CConexion
conexion.Inicializar "upacifico"
'
'set negocio = new CNegocio
'negocio.Inicializa conexion
set errores =new CErrores
session("rut_usuario") = "15964262"
set f_encuesta = new CFormulario
f_encuesta.Carga_Parametros "encuesta_ccpp.xml", "encuesta"
f_encuesta.Inicializar conexion
f_encuesta.Consultar "select ''"
f_encuesta.Siguiente


%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>- Encuesta Corporaci&oacute;n de Profesionales del Pac&iacute;fico</title>
<style type="text/css">
<!--
.Estilo25 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
}
body {
	background-color: #dae4fa;
}
.Estilo26 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10pt;
}
.Estilo27 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10pt;
	font-weight: bold;
	color: #FF7F00;
}
.Estilo31 {
	font-size: 10pt;
	font-family: Arial, Helvetica, sans-serif;
}
.Estilo34 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; font-weight: bold; }
.Estilo35 {
	font-weight: bold;
	font-size: 12px;
	font-style: italic;
	color: #000000;
}
.Estilo36 {font-family: Arial, Helvetica, sans-serif; font-size: 10pt; font-style: italic; }
.Estilo37 {font-family: Arial, Helvetica, sans-serif; font-size: 10pt; font-style: italic; font-weight: bold; }
.Estilo42 {font-size: 10pt; color: #000000; font-family: Arial, Helvetica, sans-serif;}
.Estilo43 {font-family: Arial, Helvetica, sans-serif; font-size: 10pt; color: #333333; }
.Estilo45 {font-family: Arial, Helvetica, sans-serif; font-size: 16px; }
.Estilo46 {
	color: #FF6600;
	font-weight: bold;
}
-->
</style>

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
var respuesta_8

function deshabilitar9(valor)
{
respuesta_8=valor
}
function validarRut()
{

rut=document.edicion.elements["encu[0][pers_nrut]"].value+'-'+document.edicion.elements["encu[0][pers_xdv]"].value

resultado=valida_rut(rut);

	if (!resultado)
	{
		document.edicion.elements["encu[0][pers_nrut]"].focus
		document.edicion.elements["encu[0][pers_xdv]"].value='' 
		document.edicion.elements["encu[0][pers_nrut]"].select();
		alert('Debes  ingresar un rut válido');

		
	}
}


 


function ValidarMarcados()
{
var preg_1
var preg_2
var preg_3
var preg_4
var preg_5
var preg_6_1
var preg_6_2
var preg_6_3
var preg_6_4
var preg_6_5
var preg_6_6
var preg_6_7
var preg_6_8
var preg_6_9
var preg_6_10
var preg_6_11
var preg_6_12
var preg_6_13
var preg_7
var preg_8
var preg_9
var sexo
var edad
var eciv
 
aviso="";
{ 
  var cantidad2;
  var elemento2;
  var contestada2;
  var cant_radios;
  var divisor2;
  var i; 
  var respuestas2
  var respondidas2
  contestada2=0;
  cant_radios=0;
  divisor=24;//cantidad de alternativas de respuesta por pregunta
  cantidad2=document.edicion.length;
  for(i=0;i<cantidad2;i++)
  {
  elemento2=document.edicion.elements[i];
  	if ((elemento2.type=="checkbox")&& (elemento2.name=="encu[0][preg_1_1]")|| (elemento2.name=="encu[0][preg_1_2]")|| (elemento2.name=="encu[0][preg_1_3]")||(elemento2.name=="encu[0][preg_1_4]")|| (elemento2.name=="encu[0][preg_1_5]")|| (elemento2.name=="encu[0][preg_1_6]")|| (elemento2.name=="encu[0][preg_1_7]")|| (elemento2.name=="encu[0][preg_1_8]")|| (elemento2.name=="encu[0][preg_1_9]")|| (elemento2.name=="encu[0][preg_1_9]"))
  		{cant_radios++;
		  if(elemento2.checked)
		  {
		  	contestada2++;
		  }
  		}
  }
//alert(contestada2)
  if (((contestada2*1)>0)&&((contestada2*1)<4))
  { 
	 preg_1=1
  }
  else
  {
  aviso=aviso+"1 debes seleccionar al menos una opción  \r"; 
  }
} 
 //----------------------------
{ 
  var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor=5;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_2]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }
 
  if (contestada==((cant_radios)/divisor))
  { 
	 preg_2=1
  }
  else
  {
   aviso=aviso+"2 Debes seleccionar  una opción.\r";
   
  }
}
 //----------------------------
{ 
  var cantidad2;
  var elemento2;
  var contestada2;
  var cant_radios;
  var divisor2;
  var i; 
  var respuestas2
  var respondidas2
  contestada2=0;
  cant_radios=0;
  divisor=24;//cantidad de alternativas de respuesta por pregunta
  cantidad2=document.edicion.length;
  for(i=0;i<cantidad2;i++)
  {
  elemento2=document.edicion.elements[i];
  	if ((elemento2.type=="checkbox")&& (elemento2.name=="encu[0][preg_3_1]")|| (elemento2.name=="encu[0][preg_3_2]")|| (elemento2.name=="encu[0][preg_3_3]")||(elemento2.name=="encu[0][preg_3_4]")|| (elemento2.name=="encu[0][preg_3_5]")|| (elemento2.name=="encu[0][preg_3_6]")|| (elemento2.name=="encu[0][preg_3_7]")|| (elemento2.name=="encu[0][preg_3_8]"))
  		{cant_radios++;
		  if(elemento2.checked)
		  {
		  	contestada2++;
		  }
  		}
  }
//alert(contestada2)
  if (((contestada2*1)>0)&&((contestada2*1)<4))
  { 
	 preg_3=1
  }
  else
  {
  aviso=aviso+"3 Debes seleccionar al menos una opción\r"; 
  }
} 
 //----------------------------
 
 { 
  var cantidad2;
  var elemento2;
  var contestada2;
  var cant_radios;
  var divisor2;
  var i; 
  var respuestas2
  var respondidas2
  contestada2=0;
  cant_radios=0;
  divisor=24;//cantidad de alternativas de respuesta por pregunta
  cantidad2=document.edicion.length;
  for(i=0;i<cantidad2;i++)
  {
  elemento2=document.edicion.elements[i];
  	if ((elemento2.type=="checkbox")&& (elemento2.name=="encu[0][preg_4_1]")|| (elemento2.name=="encu[0][preg_4_2]")|| (elemento2.name=="encu[0][preg_4_3]")||(elemento2.name=="encu[0][preg_4_4]")|| (elemento2.name=="encu[0][preg_4_5]")|| (elemento2.name=="encu[0][preg_4_6]")|| (elemento2.name=="encu[0][preg_4_7]")|| (elemento2.name=="encu[0][preg_4_8]"))
  		{cant_radios++;
		  if(elemento2.checked)
		  {
		  	contestada2++;
		  }
  		}
  }
//alert(contestada2)
  if (((contestada2*1)>0)&&((contestada2*1)<4))
  { 
	 preg_4=1
  }
  else
  {
  aviso=aviso+"4 Debes seleccionar al menos una opción\r"; 
  }
}
  //----------------------------
  { 
  var cantidad2;
  var elemento2;
  var contestada2;
  var cant_radios;
  var divisor2;
  var i; 
  var respuestas2
  var respondidas2
  contestada2=0;
  cant_radios=0;
  divisor=24;//cantidad de alternativas de respuesta por pregunta
  cantidad2=document.edicion.length;
  for(i=0;i<cantidad2;i++)
  {
  elemento2=document.edicion.elements[i];
  	if ((elemento2.type=="checkbox")&& (elemento2.name=="encu[0][preg_5_1]")|| (elemento2.name=="encu[0][preg_5_2]")|| (elemento2.name=="encu[0][preg_5_3]")||(elemento2.name=="encu[0][preg_5_4]")|| (elemento2.name=="encu[0][preg_5_5]")|| (elemento2.name=="encu[0][preg_5_6]"))
  		{cant_radios++;
		  if(elemento2.checked)
		  {
		  	contestada2++;
		  }
  		}
  }
//alert(contestada2)
  if (((contestada2*1)>0)&&((contestada2*1)<4))
  { 
	 preg_5=1
  }
  else
  {
  aviso=aviso+"5 Debes seleccionar al menos una opción\r"; 
  }
} 
  
    //----------------------------
{ 
  var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor=4;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_6_1]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }
 
  if (contestada==((cant_radios)/divisor))
  { 
	 preg_6_1=1
  }
  else
  {
   aviso=aviso+"6 1 Debes seleccionar una opción.\r";
   
  }
}
 
{ 
  var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor=4;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_6_2]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }
 
  if (contestada==((cant_radios)/divisor))
  { 
	 preg_6_2=1
  }
  else
  {
   aviso=aviso+"6 2 Debes seleccionar una opción.\r";
   
  }
}
 
{ 
  var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor=4;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio")&& (elemento.name=="encu[0][preg_6_3]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }
 
  if (contestada==((cant_radios)/divisor))
  { 
	 preg_6_3=1
  }
  else
  {
 aviso=aviso+"6 3 Debes seleccionar una opción.\r";
  }
}
 
{ 
  var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor=4;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_6_4]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }
 
  if (contestada==((cant_radios)/divisor))
  { 
	 preg_6_4=1
  }
  else
  {
   aviso=aviso+"6 4 Debes seleccionar una opción.\r";
   
  }
}
 
{ 
  var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor=4;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_6_5]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }
 
  if (contestada==((cant_radios)/divisor))
  { 
	 preg_6_5=1
  }
  else
  {
  aviso=aviso+"6 5 Debes seleccionar una opción.\r";
   
  }
}
 
{ 
  var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor=4;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_6_6]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }
 
  if (contestada==((cant_radios)/divisor))
  { 
	 preg_6_6=1
  }
  else
  {
  aviso=aviso+"6 6 Debes seleccionar una opción.\r";
   
  }
}
{ 
  var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor=4;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_6_7]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }
 
  if (contestada==((cant_radios)/divisor))
  { 
	 preg_6_7=1
  }
  else
  {
  aviso=aviso+"6 7 Debes seleccionar una opción.\r";
   
  }
}
{ 
  var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor=4;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_6_8]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }
 
  if (contestada==((cant_radios)/divisor))
  { 
	 preg_6_8=1
  }
  else
  {
  aviso=aviso+"6 8 Debes seleccionar una opción.\r";
   
  }
}
 
{ 
  var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor=4;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_6_9]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }
 
  if (contestada==((cant_radios)/divisor))
  { 
	 preg_6_9=1
  }
  else
  {
  aviso=aviso+"6 9 Debes seleccionar una opción.\r";
   
  }
}
//-------------------------
{ 
  var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor=4;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_6_10]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }
 
  if (contestada==((cant_radios)/divisor))
  { 
	 preg_6_10=1
  }
  else
  {
  aviso=aviso+"6 10 Debes seleccionar una opción.\r";
   
  }
}
//-------------------------
{ 
  var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor=4;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_6_11]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }
 
  if (contestada==((cant_radios)/divisor))
  { 
	 preg_6_11=1
  }
  else
  {
  aviso=aviso+"6 11 Debes seleccionar una opción.\r";
   
  }
}
{ 
  var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor=4;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_6_12]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }
 
  if (contestada==((cant_radios)/divisor))
  { 
	 preg_6_12=1
  }
  else
  {
  aviso=aviso+"6 12 Debes seleccionar una opción.\r";
   
  }
}
{ 
  var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor=4;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_6_13]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }
 
  if (contestada==((cant_radios)/divisor))
  { 
	 preg_6_13=1
  }
  else
  {
  aviso=aviso+"6 13 Debes seleccionar una opción.\r";
   
  }
}
//-------------------------
{ 
  var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor=3;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_8]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }
 
  if (contestada==((cant_radios)/divisor))
  { 
	 preg_8=1
  }
  else
  {
  aviso=aviso+"Debes selecionar una opción de ¿Tu situación laboral es?  \r";
   
  }
}
//-------------------------

if(respuesta_8!=3)
{
	{ 
	  var cantidad;
	  var elemento;
	  var contestada;
	  var cant_radios;
	  var divisor;
	  var i; 
	  contestada=0;
	  cant_radios=0;
	  divisor=3;//cantidad de alternativas de respuesta por pregunta
	  cantidad=document.edicion.length;
	  for(i=0;i<cantidad;i++)
	  {
	  elemento=document.edicion.elements[i];
		if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_9]"))
			{cant_radios++;
			  if(elemento.checked){contestada++;}
			}
	  }
	 
	  if (contestada==((cant_radios)/divisor))
	  { 
		 preg_9=1
	  }
	  else
	  {
	  aviso=aviso+"Debes indicar como trabajas \r";
	   
	  }
	}
}
else
{
preg_9=1
}
 //-------------------------
{ 
  var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor=2;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][sexo]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }
 
  if (contestada==((cant_radios)/divisor))
  { 
	 sexo=1
  }
  else
  {
  aviso=aviso+"sexo Debes seleccionar una opción\r";
   
  }
}
  //-------------------------
{ 
  var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor=5;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][edad]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }
 
  if (contestada==((cant_radios)/divisor))
  { 
	 edad=1
  }
  else
  {
  aviso=aviso+"edad Debes seleccionar una opción\r";
   
  }
}

  //-------------------------
{ 
  var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor=2;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][eciv]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }
 
  if (contestada==((cant_radios)/divisor))
  { 
	 eciv=1
  }
  else
  {
  aviso=aviso+"estado civil Debes seleccionar una opcion\r";
   
  }
}
//-------------------------


	if ((preg_1==1) && (preg_2==1) && (preg_3==1) && (preg_4==1)&& (preg_5==1) && (preg_6_1==1)&& (preg_6_2==1)&& (preg_6_3==1)&& (preg_6_4==1)&& (preg_6_5==1)&& (preg_6_6==1)&& (preg_6_7==1)&& (preg_6_8==1)&& (preg_6_9==1)&& (preg_6_10==1)&& (preg_6_11==1)&& (preg_6_12==1)&& (preg_6_13==1)&& (preg_8==1)&& (preg_9==1)&& (sexo==1) && (edad==1) && (eciv==1))
	{
		return true;
		
	}
	else
	{
		alert(aviso);
	}

}

var maxi=3; 

//El contador es un arrayo de forma que cada posición del array es una linea del formulario 
var contador=new Array(0,0,0,0); 

function validarcheckbo(preg,grupo) { 
   //Compruebo si la casilla está marcada
   
   elemento=preg.name;

   // alert(elemento);
    check=document.edicion.elements[elemento];
   //alert(check.checked);
   if (check.checked==true)
  { 
       //está marcada, entonces aumento en uno el contador del grupo 
      contador[grupo]++; 
       //compruebo si el contador ha llegado al máximo permitido 
       if (contador[grupo]>maxi) { 
          //si ha llegado al máximo, muestro mensaje de error 
        alert('No se pueden elegir más de '+maxi+' casillas a la vez.'); 
          //desmarco la casilla, porque no se puede permitir marcar 
         check.checked=false; 
          //resto una unidad al contador de grupo, porque he desmarcado una casilla 
          contador[grupo]--; 
       } 
  }
  else { 
       //si la casilla no estaba marcada, resto uno al contador de grupo 
       contador[grupo]--; 
  
    } 

} 


function detectar_navegador()
{
	var navegador = navigator.appName 
	if (navegador != "Microsoft Internet Explorer") 
	{
		alert('Debes Utilizar Internet Explorer 6 o superior')
	}
 	

}

</script>
</head>

<body onload="detectar_navegador()">
<!--<p align="center" class="Estilo35">&quot;Encuesta Egresados de RR PP&quot;</p>-->
<p align="center"><span class="Estilo34">  </span></p>
<table width="100%" border="0">
<tr valign="top">
<td width="100%" align="center">
<form name="edicion">
<input type="hidden" name="encu[0][pers_ncorr_alumno]" value="<%=pers_ncorr_alums%>">
<input type="hidden" name="encu[0][pers_ncorr_relator]" value="<%=pers_ncorr%>">
<input type="hidden" name="encu[0][seot_ncorr]" value="<%=seot_ncorr%>">
<input type="hidden" name="encu[0][dcur_ncorr]" value="<%=dcurr_ncorr%>">
<table width="700" border="0" cellpadding="0" cellspacing="0">

<tr>
	<td width="25" height="24" background="images/lado_izquierda.jpg" align="right"><img width="25" height="24" src="images/superior_izquierda.jpg"></td>
	<td width="646" height="24" background="images/borde_superior.jpg">&nbsp;</td>
	<td width="29" height="24"><img width="29" height="24" src="images/superior_derecha.jpg"></td>
</tr>
<tr>
    <td width="25" background="images/lado_izquierda.jpg" align="right">&nbsp;</td>
	<td bgcolor="#FFFFFF" aling="left" width="646">
		<table width="763" border="0" align="left" cellpadding="10" cellspacing="10" bgcolor="#FFFFFF">
		  <tr>
		  
			<td width="723" align="left">
				  <table>
				  	<tr>
						<td>
							<p><font size="+1">Gracias por estar participando y recuerda que al enviarla podrás ganar una de las 4 Gift Card  de $20.000 de Almacene Paris.</font></p>
						</td>
					</tr>
				  </table>
				  <br />
				  <table>
				  <tr>
				    <td class="Estilo31">1.- Se&ntilde;ala cu&aacute;les son las 3 principales redes sociales de  Internet que utilizas con mayor frecuencia.</p></td>
				  </tr>
				  </table>
				  <table>
				  	<tr>
						<td>
							<input type="checkbox" name="encu[0][preg_1_1]" value="1" onclick='validarcheckbo(this,0)'/>
						</td>
						<td>
							Linkedin
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="encu[0][preg_1_2]" value="1" onclick='validarcheckbo(this,0)'/>
						</td>
						<td>
							Flickr
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="encu[0][preg_1_3]" value="1" onclick='validarcheckbo(this,0)'/>
						</td>
						<td>
							Badoo
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="encu[0][preg_1_4]" value="1" onclick='validarcheckbo(this,0)'/>
						</td>
						<td>Facebook</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="encu[0][preg_1_5]" value="1" onclick='validarcheckbo(this,0)'/>
						</td>
						<td>
							Foursquare
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="encu[0][preg_1_6]" value="1" onclick='validarcheckbo(this,0)'/>
						</td>
						<td>
							Hi 5
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="encu[0][preg_1_7]" value="1" onclick='validarcheckbo(this,0)'/>
						</td>
						<td>
							Twitter
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="encu[0][preg_1_8]" value="1" onclick='validarcheckbo(this,0)'/>
						</td>
						<td>
							You Tube
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="encu[0][preg_1_9]" value="1" onclick='validarcheckbo(this,0)'/>
						</td>
						<td>
							Blogg
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="encu[0][preg_1_10]" value="1" onclick='validarcheckbo(this,0)'/>
						</td>
						<td>
							Fotolog
						</td>
					</tr>
				  </table>
				   <br />
					<hr align="left" width="100%" size="1" noshade="noshade" />
					<br />
				  <table>
				  <tr>
				    <td>2.-&iquest;Con qu&eacute; frecuencia te  conectas a Facebook?</td>
				  </tr>
				  </table>
				  <table>
					 <tr>
						<td>
							<input type="radio" name="encu[0][preg_2]" value="1" />
						</td>
						<td>
							Casi nunca
						</td>
					 </tr>
					 <tr>
						<td>
							<input type="radio" name="encu[0][preg_2]" value="2" />
						</td>
						<td>
							1 ó 2 veces por mes
						</td>
					 </tr>
					 <tr>
						<td>
							<input type="radio" name="encu[0][preg_2]" value="3" />
						</td>
						<td>
							1 ó 2 veces por semana
						</td>
					 </tr>
					 <tr>
						<td>
							<input type="radio" name="encu[0][preg_2]" value="4" />
						</td>
						<td>
							1 a 2 veces por día
						</td>
					 </tr>
					 <tr>
						<td>
							<input type="radio" name="encu[0][preg_2]" value="5" />
						</td>
						<td>
							3 veces o más por día
						</td>
					 </tr>
				  </table>
					<hr align="left" width="100%" size="1" noshade="noshade" />
					<br />
				  <table>
				  <tr>
				    <td>3.- &iquest;Cu&aacute;les son las 3 principales actividades  que realizas en Facebook? </td>
				  </tr>
				  </table>
				  <table>
				  	<tr>
						<td>
							<input type="checkbox" name="encu[0][preg_3_1]" value="1" onclick='validarcheckbo(this,1)' />
						</td>
						<td>Contactar personas</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="encu[0][preg_3_2]"  value="1" onclick='validarcheckbo(this,1)'/>
						</td>
						<td>
							Compartir fotos y videos
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="encu[0][preg_3_3]" value="1" onclick='validarcheckbo(this,1)'/>
						</td>
						<td>
							Buscar trabajo
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="encu[0][preg_3_4]" value="1" onclick='validarcheckbo(this,1)'/>
						</td>
						<td>
							Participar en grupos
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="encu[0][preg_3_5]"value="1" onclick='validarcheckbo(this,1)'/>
						</td>
						<td>
							Promocionar Productos
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="encu[0][preg_3_6]" value="1" onclick='validarcheckbo(this,1)'/>
						</td>
						<td>Organizar Actividades</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="encu[0][preg_3_7]" value="1" onclick='validarcheckbo(this,1)'/>
						</td>
						<td>
							Conocer cómo están mis amigos y familiares
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="encu[0][preg_3_8]" value="1" onclick='validarcheckbo(this,1)'/>
						</td>
						<td>
							Conocer sobre eventos para participar
						</td>
					</tr>
					
				  </table>
				  <hr align="left" width="100%" size="1" noshade="noshade" />
					<br />
				  <table>
				  <tr>
				    <td>4.-&iquest;Qui&eacute;nes son los 3 principales  grupos de inter&eacute;s que conforman tu comunidad en Facebook?</td>
				  </tr>
				  </table>
				  <table width="614">
				  	<tr>
						<td width="21">
							<input type="checkbox" name="encu[0][preg_4_1]" value="1" onclick='validarcheckbo(this,2)'/>
						</td>
						<td width="581">La familia</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="encu[0][preg_4_2]" value="1" onclick='validarcheckbo(this,2)'/>
						</td>
						<td>Compa&ntilde;eros del trabajo</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="encu[0][preg_4_3]" value="1" onclick='validarcheckbo(this,2)'/>
						</td>
						<td>Ex compa&ntilde;eros del colegio</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="encu[0][preg_4_4]" value="1" onclick='validarcheckbo(this,2)'/>
						</td>
						<td>Ex compa&ntilde;eros de la  Universidad</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="encu[0][preg_4_5]" value="1" onclick='validarcheckbo(this,2)'/>
						</td>
						<td>Grupos de inter&eacute;s</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="encu[0][preg_4_6]" value="1" onclick='validarcheckbo(this,2)'/>
						</td>
						<td>Personalidades; como por ejemplo: m&uacute;sicos, pol&iacute;ticos, escritores  u otros.</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="encu[0][preg_4_7]" value="1" onclick='validarcheckbo(this,2)'/>
						</td>
						<td>P&aacute;ginas de empresas.</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="encu[0][preg_4_8]" value="1" onclick='validarcheckbo(this,2)'/>
						</td>
						<td>Otros amigos</td>
					</tr>
					
				  </table>
				  <hr align="left" width="100%" size="1" noshade="noshade" />
					<br />
				  <table>
				  <tr>
				    <td>5.-&iquest;Cu&aacute;les fueron las 3 principales  motivaciones en aceptar &ldquo;como  amigo&rdquo; a la comunidad virtual de la CPP?</td>
				  </tr>
				  </table>
				  <br />
				  <table width="452">
				    <tr>
						<td>
							<input type="checkbox" name="encu[0][preg_5_1]" value="1" onclick='validarcheckbo(this,3)'/>
						</td>
						<td>Mantener contacto con tus ex  compa&ntilde;eros de la Universidad</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="encu[0][preg_5_2]" value="1" onclick='validarcheckbo(this,3)'/>
						</td>
						<td>Obtener contactos laborales</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="encu[0][preg_5_3]" value="1" onclick='validarcheckbo(this,3)'/>
						</td>
						<td>Conocer los beneficios como ex alumnos</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="encu[0][preg_5_4]" value="1" onclick='validarcheckbo(this,3)'/>
						</td>
						<td>Estar informado de las CPP</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="encu[0][preg_5_5]" value="1" onclick='validarcheckbo(this,3)'/>
						</td>
						<td>Estar informados de las  actividades de la Universidad</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="encu[0][preg_5_6]" value="1" onclick='validarcheckbo(this,3)'/>
						</td>
						<td>Interactuar fotos, videos y otro material con tus ex  compa&ntilde;eros</td>
					</tr>
				  </table>
				   
				<br />
				 <hr align="left" width="100%" size="1" noshade="noshade" />
				<br />
					<table>
						<tr>
							<td>
								6.- &iquest;Cu&aacute;l es tu grado de inter&eacute;s,  respecto a las actividades que debiera promocionar la Corporaci&oacute;n de  Profesionales del Pac&iacute;fico, a trav&eacute;s de la comunidad virtual en Facebook?</td>
						</tr>
					</table>
					<table border="1">
						<tr>
							<td width="307" align="center">
								<strong>Actividades</strong>							</td>
							<td width="100" align="center">
								<strong>Muy Interesante</strong>							</td>
							<td width="88" align="center">
								<strong>Interesante</strong>							</td>
							<td width="101" align="center">
								<strong>Poco Interesante</strong>							</td>
							<td width="93" align="center">
								<strong>Nada Interesante</strong>							</td>
						</tr>
						<tr>
							<td>
								Encuentros sociales de Ex alumnos
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_1]" value="1"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_1]"  value="2" />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_1]" value="3"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_1]" value="4"  />
							</td>
						</tr>
						<tr>
							<td>Actividades de Responsabilidad  Social </td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_2]" value="1"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_2]" value="2"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_2]" value="3"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_2]" value="4"  />
							</td>
						</tr>
						<tr>
							<td>Actividades Art&iacute;stico  Culturales</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_3]" value="1"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_3]" value="2"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_3]" value="3"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_3]" value="4"  />
							</td>
						</tr>
						<tr>
							<td>Promociones y Descuentos  Comerciales</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_4]" value="1"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_4]" value="2"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_4]"  value="3" />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_4]" value="4"  />
							</td>
						</tr>
						<tr>
							<td>Recuerdos Fotogr&aacute;ficos y de  Videos</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_5]" value="1"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_5]" value="2"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_5]" value="3"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_5]" value="4"  />
							</td>
						</tr>
						<tr>
							<td>Actividades Deportivas para ex  alumnos</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_6]" value="1"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_6]" value="2"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_6]" value="3"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_6]" value="4"  />
							</td>
						</tr>
						<tr>
							<td>Charlas, seminarios gratuitos  que ofrece la Universidad</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_7]" value="1"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_7]" value="2"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_7]" value="3"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_7]" value="4"  />
							</td>
						</tr>
						<tr>
							<td>Cursos, Diplomados que ofrece  la Universidad</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_8]" value="1"   />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_8]" value="2"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_8]" value="3"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_8]" value="4"  />
							</td>
						</tr>
						<tr>
							<td>Licenciaturas y Mag&iacute;ster que  ofrece la Universidad</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_9]" value="1"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_9]" value="2"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_9]" value="3"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_9]" value="4"  />
							</td>
						</tr>
						<tr>
							<td>Ofertas Laborales</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_10]" value="1"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_10]" value="2"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_10]" value="3"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_10]" value="4"  />
							</td>
						</tr>
						<tr>
							<td>Actividades de Emprendimiento</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_11]" value="1"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_11]" value="2"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_11]" value="3"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_11]" value="4"  />
							</td>
						</tr>
						<tr>
							<td>Noticias sobre ex alumnos</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_12]" value="1"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_12]" value="2"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_12]" value="3"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_12]" value="4"  />
							</td>
						</tr>
						<tr>
							<td>Ferias y talleres laborales.</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_13]" value="1"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_13]" value="2"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_13]" value="3"  />
							</td>
							<td align="center">
								<input type="radio" name="encu[0][preg_6_13]" value="4"  />
							</td>
						</tr>
					</table>
					<hr align="left" width="100%" size="1" noshade="noshade" />
					<br />
				  <!--<table>
				  <tr>
				    <td>7.-&iquest;De que carrera egresaste?</td>
				  </tr>
				  <tr>
				  	<td><%'f_encuesta.DibujaCampo("carr_ccod")%></td>
				  </tr>
				  </table>
				  <br />
					<hr align="left" width="100%" size="1" noshade="noshade" />-->
					<br />
				  <table>
				  <tr>
				    <td>&iquest;Tu situaci&oacute;n laboral es?				      </p></td>
				  </tr>
				  </table>
				  <table>
					 <tr>
						<td>
							<input type="radio" name="encu[0][preg_8]" value="1" onclick="deshabilitar9(this.value)" />
						</td>
						<td>
							Trabajando tiempo completo
						</td>
					 </tr>
					 <tr>
						<td>
							<input type="radio" name="encu[0][preg_8]" value="2" onclick="deshabilitar9(this.value)"/>
						</td>
						<td>
							Trabajando tiempo parcial
						</td>
					 </tr>
					 <tr>
						<td>
							<input type="radio" name="encu[0][preg_8]" value="3" onclick="deshabilitar9(this.value)"/>
						</td>
						<td>
							No estás trabajando
						</td>
					 </tr>
					
				  </table>
				  <br />
					<hr align="left" width="100%" size="1" noshade="noshade" />
					<br />
				  <table>
				  <tr>
				    <td>Si est&aacute;s trabajando, lo haces:</td>
				  </tr>
				  </table>
				  <table>
					 <tr>
						<td>
							<input type="radio" name="encu[0][preg_9]" value="1" />
						</td>
						<td>En forma independiente</td>
					 </tr>
					 <tr>
						<td>
							<input type="radio" name="encu[0][preg_9]" value="2" />
						</td>
						<td>En forma dependiente</td>
					 </tr>
					 <tr>
						<td>
							<input type="radio" name="encu[0][preg_9]" value="3" />
						</td>
						<td>&nbsp;Ambas</td>
					 </tr>
				  </table>
				 <!-- <br />
					<hr align="left" width="100%" size="1" noshade="noshade" />
					<br />
				  <table>
				  <tr>
				    <td>Sexo:</td>
				  </tr>
				  </table>
				  <table>
					 <tr>
						<td>
							<input type="radio" name="encu[0][sexo]" value="1"/>
						</td>
						<td>Masculino</td>
					 </tr>
					 <tr>
						<td>
							<input type="radio" name="encu[0][sexo]" value="2" />
						</td>
						<td>Femenino</td>
					 </tr>
				  </table>-->
				  <br />
					<hr align="left" width="100%" size="1" noshade="noshade" />
					<br />
				  <table>
				  <tr>
				    <td>Edad<br />
						Marcar según rango </td>
				  </tr>
				  </table>
				  <table>
					 <tr>
						<td>
							<input type="radio" name="encu[0][edad]" value="20-24" />
						</td>
						<td>20 a 24 a&ntilde;os</td>
					 </tr>
					 <tr>
						<td>
							<input type="radio" name="encu[0][edad]" value="25-29" />
						</td>
						<td>25 a 29 a&ntilde;os</td>
					 </tr>
					 <tr>
						<td>
							<input type="radio" name="encu[0][edad]" value="30-34" />
						</td>
						<td>30 a 34 a&ntilde;os</td>
					 </tr>
					 <tr>
						<td>
							<input type="radio" name="encu[0][edad]" value="35-39" />
						</td>
						<td>&nbsp;35 a 39 a&ntilde;os</td>
					 </tr>
					 <tr>
						<td>
							<input type="radio" name="encu[0][edad]" value="40+" />
						</td>
						<td>&nbsp;40 &oacute; m&aacute;s</td>
					 </tr>
				  </table>
				  <br />
					<hr align="left" width="100%" size="1" noshade="noshade" />
					<br />
				  <table>
				  <tr>
				    <td>Actualmente t&uacute; est&aacute;s</td>
				  </tr>
				  </table>
				  <table>
					 <tr>
						<td>
							<input type="radio" name="encu[0][eciv]" value="1" />
						</td>
						<td>Soltero(a)</td>
					 </tr>
					 <tr>
						<td>
							<input type="radio" name="encu[0][eciv]" value="2" />
						</td>
						<td>Casado(a) o en pareja</td>
					 </tr>
				  </table>
				<hr align="left" width="100%" size="1" noshade="noshade" />
				<br />
				  <table>
				  	<tr>
						<td colspan="2">
							Ingresa tu Rut  para participar en las cuatro Gift Card de $20.000  que se sortearán entre los que hayan contestado la encuesta hasta el día jueves 9 de diciembre de 2010; sorteo que ser&aacute; publicado el miercoles 15 de diciembre por Facebook, Email, WEB www.cppacifico.cl.						</td>
					</tr>
					<tr>
						<td width="56">
							Rut						</td>
						<td width="655">
							<input type="text" name="encu[0][pers_nrut]" maxlength="8"  size="9" id="NU-N"/>-<input type="text" name="encu[0][pers_xdv]" maxlength="1"  size="2" id="TO-N" onblur="validarRut();" onkeyup="this.value=this.value.toUpperCase()" /> 
						</td>
					</tr>
					<tr>
						<td>
							Email
						</td>
						<td>
							<input type="text" name="encu[0][email]" maxlength="50"  size="50" id="EM-S"/>
							(opcional)
						</td>
					</tr>
				  </table>
				<hr align="left" width="100%" size="1" noshade="noshade" />
				<br />
			  <table width="100%">
			   <tr>
			      <td width="100%" align="center">			   </tr>
				</table>
			 
			 <br />
			  <table width="100%">
			   <tr>
			   <td width="36%" align="rigth" valign="top" class="Estilo31"></td>
					<td width="11%" align="center" valign="top" class="Estilo31">
						<input type="button" value="Enviar Encuesta" onclick="_Guardar(this, document.forms['edicion'], 'encuesta_proc.asp','', 'ValidarMarcados()', 'Recuerde que una vez guardada la encuesta usted no podra hacer cambios', 'FALSE');" />
						<td width="43%" align="left" valign="top" class="Estilo31">&nbsp;</td>
				  </tr>
			  </table>
				
				<br />
				<br />
				<br />
				<hr size="1" noshade="noshade" />
				<br /></td>
		  </tr>
		</table>
</td>
	<td width="29" background="images/lado_derecha.gif"></td>
</tr>
<tr>
	<td width="25" height="27" background="images/borde_inferior.jpg"><img width="25" height="27" src="images/inferior_izquierda.jpg"></td>
	<td width="646" height="27" background="images/borde_inferior.jpg">&nbsp;</td>
	<td width="29" height="27"><img width="29" height="27" src="images/inferior_derecha.jpg"></td>
</tr>
</table>

</form>
<p align="center"><strong>&nbsp;<span class="Estilo45">&iexcl;Muchas gracias por  tu colaboraci&oacute;n! </span></strong><span class="Estilo45"><br />
  
<p>&nbsp;</p>
<p>&nbsp;</p>
</td>
</tr>
</table>
</body>

</html>
