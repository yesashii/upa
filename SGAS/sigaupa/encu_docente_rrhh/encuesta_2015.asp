<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/revisa_session_encuesta_docente_rr_hh.asp"-->

<%

'---------------------------------------------------------------------------------------------------
'set pagina = new CPagina
'pagina.Titulo = "Encuesta Así soy yo"
'---------------------------------------------------------------------------------------------------
'secc_ccod=request.QueryString("secc")

peri_ccod=request.QueryString("peri")
pers_ncorr=request.QueryString("pers_ncorr")

sedes_filtro = "1,4,9"
'secc_ccod=request.Form("secc")
set conexion = new CConexion
conexion.Inicializar "upacifico"
'
set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "encuesta_docente_rr_hh.xml", "botonera"

'peri_ccod= conexion.consultaUno("select peri_ccod from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")

set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "encuesta_docente_rr_hh.xml", "encabezado"
'f_encabezado.Carga_Parametros "tabla_vacia.xml", "tabla"
f_encabezado.Inicializar conexion

'pers_ncorr=conexion.ConsultaUno("select protic.obtener_pers_ncorr("&q_pers_nrut&")")
consulta = "select asig_tdesc,b.asig_ccod,b.secc_ccod,secc_tdesc,carr_tdesc,pers_tnombre+' '+pers_tape_paterno as nombre from asignaturas a, secciones b, bloques_horarios c, bloques_profesores d,carreras e,personas f"& vbCrLf &_
			"where a.asig_ccod=b.asig_ccod"& vbCrLf &_
			"and b.secc_ccod=c.secc_ccod"& vbCrLf &_
			"and b.peri_ccod in ("&peri_ccod&")"& vbCrLf &_
			"and c.bloq_ccod=d.bloq_ccod"& vbCrLf &_
			"and d.pers_ncorr="&pers_ncorr&""& vbCrLf &_
			"and b.carr_ccod=e.carr_ccod"& vbCrLf &_
			"and d.pers_ncorr=f.pers_ncorr"& vbCrLf &_
			"group by asig_tdesc,b.asig_ccod,b.secc_ccod,secc_tdesc,carr_tdesc,pers_tnombre,pers_tape_paterno"& vbCrLf &_
			"order by secc_tdesc" 


'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_encabezado.Consultar consulta
f_encabezado.Siguiente

realizo_encuesta = conexion.consultaUno("select distinct peri_ccod from autoevaluacion_docente_2015 where peri_ccod="&peri_ccod&" and pers_ncorr="&pers_ncorr)

if realizo_encuesta <> "" then
	Response.Redirect("encuesta_2015_fin.asp?origen=1")
end if
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>- Encuesta Universidad del Pac&iacute;fico</title>
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
	font-size: 16pt;
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
	font-size: 16px;
	font-style: italic;
	color: #000000;
}
.Estilo36 {font-family: Arial, Helvetica, sans-serif; font-size: 10pt; font-style: italic; }
.Estilo37 {font-family: Arial, Helvetica, sans-serif; font-size: 10pt; font-style: italic; font-weight: bold; }
.Estilo42 {font-size: 10pt; color: #000000; font-family: Arial, Helvetica, sans-serif;}
.Estilo43 {font-family: Arial, Helvetica, sans-serif; font-size: 10pt; color: #333333; }
.Estilo45 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; }
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
function validar_ingreso(){
	
	cantidad=document.edicion.length;
	contador = 0;
	//cantidad=cantidad/4;
	//alert(cantidad);
	for(i=0;i<cantidad;i++)
  	{
  		elemento=document.edicion.elements[i];
		if ((elemento.type=="radio")){
				//alert(elemento.checked);
				//cant_radios++;
		  	if(elemento.checked){
				//contestada++;
				contador++;	
			}
  		}
  	}
	no_contestadas = 13 - contador;
	if (contador<13){
		alert("Tienes "+no_contestadas+" preguntas de calificación sin contestar");	
	}
	else if ((valida_caracter(document.edicion.texto1_mejora)) && (valida_caracter(document.edicion.texto2_mejora))){
		//envio=true;	
		document.edicion.submit();
		}
		else{
			//envio=false;
			alert("No puedes ingresar el caracter Comilla Simple en tu respuesta.");	
		}	
	
}
function valida_caracter(elemento){
//  var charRegExp = /'[a-zA-Z0-9¡!"#$%&()¿?+$*¨][.-]/ 
  var charRegExp = /'/; 
  
  var firstName = elemento.value; 
//  alert(firstName.search(charRegExp))
  if (firstName.search(charRegExp)!=-1 ){ 
	return false;
	} 
	else{
	return true;
	}
}
function vovler()
{

valor2=<%=pers_ncorr%>;
window.location=("asignaturas.asp?pers_ncorr="+valor2+"")
}



 


function ValidarMarcados()
{
var I_preg_1
var I_preg_2
var I_preg_3
var I_preg_4
var I_preg_5
var I_preg_6
var II_preg_1
var II_preg_2
var II_preg_3
var II_preg_4
var II_preg_5
var II_preg_6
var II_preg_7
var II_preg_8
var III_preg_1
var III_preg_2
var III_preg_3
var III_preg_4
var IV_preg_1
var IV_preg_2
var IV_preg_3
var IV_preg_4
var V_preg_1
var V_preg_2
var V_preg_3
var V_preg_4


aviso="Debes seleccionar una opcion en la pregunta\r";


{ 
  var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor=7;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][I_preg_1]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 I_preg_1=1
  }
  else
  {
   aviso=aviso+"1 de la parte I.\r";
   
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
  divisor=7;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][I_preg_2]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 I_preg_2=1
  }
  else
  {
   aviso=aviso+"2 de la parte I.\r";
   
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
  divisor=7;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][I_preg_3]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 I_preg_3=1
  }
  else
  {
   aviso=aviso+"3 de la parte I.\r";
   
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
  divisor=7;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio")&& (elemento.name=="encu[0][I_preg_4]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 I_preg_4=1
  }
  else
  {
 aviso=aviso+"4 de la parte I.\r";
   I_preg_4=0
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
  divisor=7;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][I_preg_5]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 I_preg_5=1
  }
  else
  {
   aviso=aviso+"5 de la parte I.\r";
   
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
  divisor=7;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][I_preg_6]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 I_preg_6=1
  }
  else
  {
  aviso=aviso+"6 de la parte I.\r";
   
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
  divisor=7;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][II_preg_1]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 II_preg_1=1
  }
  else
  {
   aviso=aviso+"1 de la parte II.\r";
   
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
  divisor=7;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][II_preg_2]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 II_preg_2=1
  }
  else
  {
   aviso=aviso+"2 de la parte II.\r";
   
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
  divisor=7;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][II_preg_3]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 II_preg_3=1
  }
  else
  {
   aviso=aviso+"3 de la parte II.\r";
   
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
  divisor=7;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio")&& (elemento.name=="encu[0][II_preg_4]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 II_preg_4=1
  }
  else
  {
 aviso=aviso+"4 de la parte II.\r";
   II_preg_4=0
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
  divisor=7;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][II_preg_5]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 II_preg_5=1
  }
  else
  {
   aviso=aviso+"5 de la parte II.\r";
   
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
  divisor=7;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][II_preg_6]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 II_preg_6=1
  }
  else
  {
  aviso=aviso+"6 de la parte II.\r";
   
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
  divisor=7;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][II_preg_7]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 II_preg_7=1
  }
  else
  {
  aviso=aviso+"7 de la parte II.\r";
   
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
  divisor=7;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][II_preg_8]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 II_preg_8=1
  }
  else
  {
  aviso=aviso+"8 de la parte II.\r";
   
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
  divisor=7;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][III_preg_1]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 III_preg_1=1
  }
  else
  {
   aviso=aviso+"1 de la parte III.\r";
   
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
  divisor=7;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][III_preg_2]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 III_preg_2=1
  }
  else
  {
   aviso=aviso+"2 de la parte III.\r";
   
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
  divisor=7;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][III_preg_3]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 III_preg_3=1
  }
  else
  {
   aviso=aviso+"3 de la parte III.\r";
   
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
  divisor=7;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio")&& (elemento.name=="encu[0][III_preg_4]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 III_preg_4=1
  }
  else
  {
 aviso=aviso+"4 de la parte III.\r";
   III_preg_4=0
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
  divisor=7;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][V_preg_1]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 IV_preg_1=1
  }
  else
  {
   aviso=aviso+"1 de la parte IV.\r";
   
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
  divisor=7;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][IV_preg_2]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 IV_preg_2=1
  }
  else
  {
   aviso=aviso+"2 de la parte IV.\r";
   
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
  divisor=7;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][IV_preg_3]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 IV_preg_3=1
  }
  else
  {
   aviso=aviso+"3 de la parte IV.\r";
   
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
  divisor=7;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio")&& (elemento.name=="encu[0][IV_preg_4]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 IV_preg_4=1
  }
  else
  {
 aviso=aviso+"4 de la parte IV.\r";
   IV_preg_4=0
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
  divisor=7;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][V_preg_1]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 V_preg_1=1
  }
  else
  {
   aviso=aviso+"1 de la parte V.\r";
   
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
  divisor=7;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][V_preg_2]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 V_preg_2=1
  }
  else
  {
   aviso=aviso+"2 de la parte V.\r";
   
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
  divisor=7;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][V_preg_3]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 V_preg_3=1
  }
  else
  {
   aviso=aviso+"3 de la parte V.\r";
   
  }
}


//-------------------------

//alert(I_preg_1+'\r'+I_preg_2+'\r'+I_preg_3+'\r'+I_preg_4+'\r'+I_preg_5+'\r'+I_preg_6+'\r'+II_preg_1+'\r'+II_preg_2+'\r'+II_preg_3+'\r'+II_preg_4+'\r'+II_preg_5+'\r'+II_preg_6+'\r'+II_preg_7+'\r'+II_preg_8+'\r'+III_preg_1+'\r'+III_preg_2+'\r'+III_preg_3+'\r'+III_preg_4+'\r'+IV_preg_1+'\r'+IV_preg_2+'\r'+IV_preg_3+'\r'+IV_preg_4+'\r'+V_preg_1+'\r'+V_preg_2+'\r'+V_preg_3);
if ((I_preg_1==1) && (I_preg_2==1) && (I_preg_3==1) && (I_preg_4==1)&& (I_preg_5==1) && (I_preg_6==1) && (II_preg_1==1) && (II_preg_2==1) && (II_preg_3==1) && (II_preg_4==1)&& (II_preg_5==1) && (II_preg_6==1)&& (II_preg_7==1)&& (II_preg_8==1) && (III_preg_1==1) && (III_preg_2==1) && (III_preg_3==1) && (III_preg_4==1)&& (IV_preg_1==1) && (IV_preg_2==1) && (IV_preg_3==1) && (IV_preg_4==1)&& (V_preg_1==1) && (V_preg_2==1) && (V_preg_3==1))
{
 	return true;
	
}
else
{
	alert(aviso);
}

}

</script>
</head>

<body>
<!--<p align="center" class="Estilo35">&quot;Encuesta Egresados de RR PP&quot;</p>-->
<p align="center"><span class="Estilo34">  </span></p>
<table width="100%" border="0">
<tr valign="top">
<td width="100%" align="center">
<form name="edicion" action="responder_encuesta_2015.asp" method="post">
<input type="hidden" name="pers_ncorr" value="<%=pers_ncorr%>">
<input type="hidden" name="peri_ccod" value="<%=peri_ccod%>">
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
				<table width="298">
					<tr>
						<td align="center">
							<p class="Estilo35">VICERRECTORÍA ACADÉMCIA DIRECCIÓN DE DOCENCIA</p>
						</td>
					</tr>
				</table>
				<br />
				<table width="654">
					<tr>
						<td align="center">
							<p class="Estilo35">CUESTIONARIO DE AUTO EVALUACIÓN DOCENTE</p>
						</td>
					</tr>
				</table>
					
					<br />
					<table width="90%" border="0" bgcolor="#FFFFFF">
                  <tr>
                    <td width="19%">Nombre </td>
                    <td width="1%">:</td>
                    <td width="80%" align="left"><%f_encabezado.DibujaCampo("nombre")%>
                    </td>
                  </tr>
				  <tr>
                    <td width="19%">Carrera</td>
                    <td width="1%">:</td>
                    <td align="left"><%f_encabezado.DibujaCampo("carr_tdesc")%> 
                    </td>
                  </tr>
                  <tr>
                    <td width="19%">Nombre Asignatura </td>
                    <td width="1%">:</td>
                    <td align="left"><%f_encabezado.DibujaCampo("asig_tdesc")%></td>
                  </tr>
                  <tr>
                    <td  width="19%">Fecha</td>
                    <td  width="1%">:</td>
                    <td lign="left"><%=Date()%></td>
                  </tr>
				   
                  </table>
				    <br/>
			   <table width="90%" border="0" bgcolor="#FFFFFF">
                  <tr>
                    <td class="Estilo31">Estimado(a)  profesor(a):</td>
                   </tr>
                  <tr>
                    <td class="Estilo31"><p>La siguiente r&uacute;brica tiene como  prop&oacute;sito recoger informaci&oacute;n acerca de su percepci&oacute;n sobre la docencia que  imparte en el presente semestre. La idea central es que usted pueda focalizar  en qu&eacute; nivel de desempe&ntilde;o se encuentra su desempe&ntilde;o &nbsp;e identificar los aspectos a mejorar. Esperamos  que esta informaci&oacute;n sea &uacute;til para la mejora de su docencia. </p>
A continuaci&oacute;n encontrara un conjunto de  aspectos relacionados con la docencia que imparte. Los aspectos sobre los  cuales debe reflexionar se encuentran agrupados en tres dimensiones: <u>Proceso  de ense&ntilde;anza y aprendizaje, clima para el aprendizaje y proceso de evaluaci&oacute;n</u>.<br /></td>
                   </tr>
				  <tr>
                    <td class="Estilo31"><p>Para esta autoevaluaci&oacute;n se ha  construido una r&uacute;brica con dimensiones,&nbsp;  criterios o categor&iacute;as con sus respectivos niveles de desempe&ntilde;o. En el  extremo inferior derecho de cada celda encontrar&aacute; un recuadro para clasificar  su desempe&ntilde;o con una cruz. Al final de las tres dimensiones se solicita que  usted identifique un aspecto que puede mejorar concretamente en su desempe&ntilde;o  docente.</p></td>
                   </tr>
			      </table>
				  <br />
					<hr align="left" width="100%" size="1" noshade="noshade" />
			<br />
			  <p class="Estilo31"><strong>DIMENSI&Oacute;N:</strong> <strong><u>Proceso  de ense&ntilde;anza y aprendizaje</u></strong>. Comprende aspectos que usted considera para  dise&ntilde;ar, organizar y desarrollar su docencia. Incluye los factores que pueden  influir en el aprendizaje de los estudiantes. </p>
				<table width="100%" border="1" cellpadding="0" cellspacing="0">
				  <tr align="center">
				  		<td width="146">Criterios</td>
				  		<td width="147">Requiero apoyo (1)</td>
						<td width="150" valign="top" ><p align="center" >Podr&iacute;a hacerlo mejor (2)</p></td>
						<td width="148" valign="top"  ><p align="center">Tengo un buen desempe&ntilde;o (3)</p></td>
						
						<td width="147" valign="top"><p align="center">Tengo un excelente desempe&ntilde;o (4)</p></td>
					  </tr>
				  <tr align="justify">
				  		<td width="146" height="63" align="left">1.Planificaci&oacute;n y preparaci&oacute;n de la ense&ntilde;anza.</td>
				  		<td width="147" align="left" title="En la preparación de la asignatura considero los objetivos y contenidos del programa."><p align="center"> <input name="nota[1]" type="radio" value="1"/></p></td>
						<td width="150" align="left" title="En la preparación de la asignatura considero los elementos que me parecen relevantes como los objetivos, contenidos y evaluación. "><p align="center"><input name="nota[1]" type="radio" value="2"/></p></td>
						<td width="148" align="left" title="En la preparación de la asignatura tomé como base el programa, los objetivos, contenidos, metodologías, proceso de evaluación y bibliografía."><p align="center"><input name="nota[1]" type="radio" value="3"/>
						</p></td>
						
						<td width="147" align="left" title="En la preparación de la asignatura consideré el programa y todos los elementos necesarios para asegurar el aprendizaje de los estudiantes como: objetivos, contenidos, características de los estudiantes, conocimientos previos, metodologías, proceso de evaluación y bibliografía."><p align="center"><input name="nota[1]" type="radio" value="4"/>
						</p></td>
					  </tr>
				  <tr align="justify">
				  		<td width="146" align="left">2.Actualizaci&oacute;n &nbsp;en la disciplina. </td>
				  		<td width="147" title="En la planificación de la docencia considero los contenidos disciplinares adquiridos en mi formación profesional."><p align="center"> <input name="nota[2]" type="radio" value="1"/></p> </td>
						<td width="150" valign="middle" title="En la planificación y en el trabajo con los estudiantes  incorporo los contenidos disciplinares trabajados en mi formación profesional y algunos conocimientos que han sido actualizados en mi área."  ><p align="center">
					    <input name="nota[2]" type="radio" value="2"/></p></td>
						<td width="148" valign="middle" title="En la planificación y docencia considero los conocimientos actualizados en mi área, sin embargo solo logro concretar en algunas actividades en clases los avances de la disciplina." ><p align="center">
							<input name="nota[2]" type="radio" value="3"/>
						</p></td>
						
						<td width="147" valign="middle" title="En la planificación y en el trabajo con los estudiantes siempre considero los conocimientos de mi formación profesional, los conocimientos 
actualizados en mi área disciplinar y los integro en las actividades de clase. 
"><p align="center">
							<input name="nota[2]" type="radio" value="4"/>
						</p></td>
					  </tr>
				  <tr align="justify">
				  		<td width="146" align="left">3.Estrategias de enseñanza y aprendizaje. </td>
				  		<td width="147"><p align="center" title="Planifico y desarrollo mis clases desde una perspectiva expositiva, me cuesta planificar actividades que impliquen la reflexión e indagación  por parte de los estudiantes. "> <input name="nota[3]" type="radio" value="1"/></p></td>
						<td width="150" valign="middle" title="Planifico actividades que promuevan la indagación, reflexión y creatividad, sin embargo me cuesta su aplicación en clases. " ><p align="center">
					    <input name="nota[3]" type="radio" value="2"/></p></td>
						<td width="148" valign="middle" title="Planifico y desarrollo en  clases actividades que  promueven la indagación, la reflexión y la creatividad, pero hay aspectos de las actividades que podría hacer mejor. "><p align="center">
							<input name="nota[3]" type="radio" value="3"/>
						</p></td>
						
						<td width="147" valign="middle" title="Planifico y desarrollo siempre actividades en clases que permiten la indagación,  reflexión y la creatividad. "><p align="center">
							<input name="nota[3]" type="radio" value="4"/>
						</p></td>
					  </tr>
				  <tr align="justify">
				  		<td width="146" align="left">4.Relaci&oacute;n entre las disciplinas </td>
				  		<td width="147" title="Me cuesta establecer relaciones entre  los principios y conceptos propios de la disciplina que enseño con otras áreas afines del conocimiento. "><p align="center"> <input name="nota[4]" type="radio" value="1"/></p></td>
						<td width="150" valign="middle" title="En mi asignatura relaciono ideas, conceptos y principios de la disciplina  con otras áreas afines. "><p align="center">
					    <input name="nota[4]" type="radio" value="2"/></p></td>
						<td width="148" valign="middle" title="En mi asignatura relaciono ideas, conceptos y principios de la disciplina con  otras áreas afines y promuevo esta relación a través de actividades o trabajos. "  ><p align="center">
							<input name="nota[4]" type="radio" value="3"/>
						</p></td>
						
						<td width="147"valign="middle" title="En mi asignatura siempre relaciono ideas, conceptos y principios con las de otras disciplinas con el propósito de visualizar relaciones más amplias en el campo disciplinar y poder solucionar problemas, realizar actividades y/o trabajos. "><p align="center">
							<input name="nota[4]" type="radio" value="4"/>
						</p></td>
					  </tr>
				  <tr align="justify">
				  		<td width="146" align="left">5.Integraci&oacute;n de habilidades, conocimientos y  actitudes.</td>
				  		<td width="147" title="Por el tipo de asignatura que imparto tiendo a generar actividades más centradas en los conceptos. "><p align="center"> <input name="nota[5]" type="radio" value="1"/></p></td>
						<td width="150" valign="middle" title="Diseño actividades que integran habilidades, conocimientos y actitudes, sin embargo me es difícil implementarlas en el aula." ><p align="center">
					    <input name="nota[5]" type="radio" value="2"/></p></td>
						<td width="148" valign="middle" title="Promuevo el trabajo en grupo y talleres para la integración de habilidades, conceptos y actitudes."><p align="center">
							<input name="nota[5]" type="radio" value="3"/>
						</p></td>
						
						<td width="147"valign="middle" title="Me preocupo siempre de realizar diversas actividades, talleres o trabajos en grupo que faciliten el aprendizaje integral de habilidades, conceptos y actitudes en los estudiantes. "><p align="center">
							<input name="nota[5]" type="radio" value="4"/>
						</p></td>
					  </tr>
				  </table> 
			   <br />
			   <hr align="left" width="100%" size="1" noshade="noshade" />
			   <p class="Estilo31" ><strong>DIMENSI&Oacute;N: <u>Clima para el aprendizaje</u></strong>.&nbsp; Se refiere  a la creaci&oacute;n, por parte del docente, de un ambiente adecuado que promueva el  aprendizaje de los estudiantes.
			   <table width="100%" border="1" cellpadding="0" cellspacing="0">
			     <tr align="center">
			       <td width="146">Criterios</td>
			       <td width="147">Requiero apoyo (1)</td>
			       <td width="150" valign="top" ><p align="center" >Podr&iacute;a hacerlo mejor (2)</p></td>
			       <td width="148" valign="top"  ><p align="center">Tengo un buen desempe&ntilde;o (3)</p></td>
			       <td width="147" valign="top"><p align="center">Tengo un excelente desempe&ntilde;o (4)</p></td>
			       </tr>
			     <tr align="justify">
			       <td width="146" height="63" align="left">6.Respeto a puntos de vista divergentes </td>
			       <td width="147" align="left" title="Respeto los puntos de vista y opiniones de los estudiantes, pero me cuesta promover instancias de díalogo entre los estudiantes. "><p align="center">
			         <input name="nota[6]" type="radio" value="1"/>
			         </p></td>
			       <td width="150" align="left" title="Promuevo espacios de diálogo entre los estudiantes, sin embargo me cuesta mantener un ambiente de respeto a las ideas divergentes."><p align="center">
			         <input name="nota[6]" type="radio" value="2"/>
			         </p></td>
			       <td width="148" align="left" title="Respeto el punto de vista de los estudiantes, aunque sean distintos a los míos y  promuevo el respeto entre ellos frente a las ideas divergentes."><p align="center">
			         <input name="nota[6]" type="radio" value="3"/>
			         </p></td>
			       <td width="147" align="left" title="Siempre respeto los puntos de vista de los estudiantes, aunque no sean coincidentes con los míos  y promuevo espacios de diálogo en clases sobre los distintos puntos de vista manteniendo un ambiente de respeto."><p align="center">
			         <input name="nota[6]" type="radio" value="4"/>
			         </p></td>
			       </tr>
			     <tr align="justify">
			       <td width="146" align="left">7.Clima de aula</td>
			       <td width="147" title="Promuevo espacios de participación de los estudiantes, pero me cuesta mantener un ambiente de respeto que favorezca el desarrollo de las actividades. "><p align="center">
			         <input name="nota[7]" type="radio" value="1"/>
			         </p></td>
			       <td width="150" valign="middle" title="Me cuesta generar un ambiente  propicio para que todos los estudiantes participen en un clima de respeto. "  ><p align="center">
			         <input name="nota[7]" type="radio" value="2"/>
			         </p></td>
			       <td width="148" valign="middle" title="En la mayoría de las actividades de mi  asignatura el ambiente es propicio para que todos los estudiantes participen en un clima de respeto. " ><p align="center">
			         <input name="nota[7]" type="radio" value="3"/>
			         </p></td>
			       <td width="147" valign="middle" title="En todas las actividades de la asignatura el ambiente es propicio para que todos los estudiantes participen activamente en un ambiente  de confianza y respeto. "><p align="center">
			         <input name="nota[7]" type="radio" value="4"/>
			         </p></td>
			       </tr>
			     <tr align="justify">
			       <td width="146" align="left">8.Respuestas a preguntas </td>
			       <td width="147" title=" Respondo las dudas o inquietudes de los estudiantes, pero no siempre sé si se han aclarado sus dudas. "><p align="center">
			         <input name="nota[8]" type="radio" value="1"/>
			         </p></td>
			       <td width="150" valign="middle" title="Trato de aclarar las dudas formuladas  por los estudiantes. " ><p align="center">
			         <input name="nota[8]" type="radio" value="2"/>
			         </p></td>
			       <td width="148" valign="middle" title="Estoy dispuesto y atento a responder con claridad todas las inquietudes de los estudiantes."><p align="center">
			         <input name="nota[8]" type="radio" value="3"/>
			         </p></td>
			       <td width="147" valign="middle" title="Estoy dispuesto y atento a responder o resolver todas las inquietudes de los estudiantes, y me aseguro que han comprendido. "><p align="center">
			         <input name="nota[8]" type="radio" value="4"/>
			         </p></td>
			       </tr>
			     <tr align="justify">
			       <td width="146" align="left">9.Aspectos &eacute;ticos de la profesi&oacute;n </td>
			       <td width="147" title="Vinculo algunas temáticas con los aspectos éticos de la profesión. "><p align="center">
			         <input name="nota[9]" type="radio" value="1"/>
			         </p></td>
			       <td width="150" valign="middle" title="Vinculo temas trabajados en la asignatura con los aspectos éticos de la profesión y a veces logro integrar este aspecto a las actividades de la asignatura."><p align="center">
			         <input name="nota[9]" type="radio" value="2"/>
			         </p></td>
			       <td width="148" valign="middle" title="Durante las clases vinculo algunos temas trabajados en la asignatura los aspectos éticos de la profesión, integrando este aspecto a las actividades desarrolladas en la asignatura."  ><p align="center">
			         <input name="nota[9]" type="radio" value="3"/>
			         </p></td>
			       <td width="147"valign="middle" title="Durante las clases siempre vinculo los temas trabajados con los aspectos éticos de la profesión, integrando este aspecto y dando ejemplos en las actividades desarrolladas en clases."><p align="center">
			         <input name="nota[9]" type="radio" value="4"/>
			         </p></td>
			       </tr>
			     </table>
			   <br />
			   <hr align="left" width="100%" size="1" noshade="noshade" />
			   <p class="Estilo31"><strong>DIMENSI&Oacute;N: <u>Proceso de evaluaci&oacute;n</u></strong>. Se refiere al proceso que el docente  desarrolla para que los estudiantes evidencien sus aprendizajes y c&oacute;mo est&eacute; es  utilizado en la mejora del proceso ense&ntilde;anza-aprendizaje.</p>
			   <table width="100%" border="1" cellpadding="0" cellspacing="0">
			     <tr align="center">
			       <td width="146">Criterios</td>
			       <td width="147">Requiero apoyo (1)</td>
			       <td width="150" valign="top" ><p align="center" >Podr&iacute;a hacerlo mejor (2)</p></td>
			       <td width="148" valign="top"  ><p align="center">Tengo un buen desempe&ntilde;o (3)</p></td>
			       <td width="147" valign="top"><p align="center">Tengo un excelente desempe&ntilde;o (4)</p></td>
			       </tr>
			     <tr align="justify">
			       <td width="146" height="63" align="left">10.Procedimientos de evaluaci&oacute;n </td>
			       <td width="147" align="left" title="Los procedimientos de evaluación de la asignatura son coherentes con los contenidos. "><p align="center">
			         <input name="nota[10]" type="radio" value="1"/>
			         </p></td>
			       <td width="150" align="left" title="Los procedimientos de evaluación son coherentes con los objetivos y contenidos del curso. "><p align="center">
			         <input name="nota[10]" type="radio" value="2"/>
			         </p></td>
			       <td width="148" align="left" title="Los procedimientos de evaluación son coherentes con el programa de asignatura, los objetivos y los contenidos. "><p align="center">
			         <input name="nota[10]" type="radio" value="3"/>
			         </p></td>
			       <td width="147" align="left" title="Los procedimientos de evaluación son coherentes con el programa se asignatura, los objetivos,  contenidos y la metodología utilizada en el curso. "><p align="center">
			         <input name="nota[10]" type="radio" value="4"/>
			         </p></td>
			       </tr>
			     <tr align="justify">
			       <td width="146" align="left">11.Comunicaci&oacute;n de criterios de evaluaci&oacute;n</td>
			       <td width="147" title="A veces explico los criterios o aspectos que serán evaluados. "><p align="center">
			         <input name="nota[11]" type="radio" value="1"/>
			         </p></td>
			       <td width="150" valign="middle" title="Explico los criterios de evaluación pero no siempre me aseguro que los estudiantes lo comprendan."  ><p align="center">
			         <input name="nota[11]" type="radio" value="2"/>
			         </p></td>
			       <td width="148" valign="middle" title="Explico oralmente y entrego por escrito los criterios de las pruebas  solemnes, trabajos  o evaluaciones más importantes. " ><p align="center">
			         <input name="nota[11]" type="radio" value="3"/>
			         </p></td>
			       <td width="147" valign="middle" title="Explico claramente, por escrito y oral,  los criterios para todas las evaluaciones, y me aseguro de que los estudiantes los comprendan."><p align="center">
			         <input name="nota[11]" type="radio" value="4"/>
			         </p></td>
			       </tr>
			     <tr align="justify">
			       <td width="146" align="left">12.Instrucciones para los procesos de evaluaci&oacute;n.<strong> &nbsp;</strong></td>
			       <td width="147" title="No siempre  entrego instrucciones claras para poder desarrollar los procedimientos de evaluación propuestos. "><p align="center">
			         <input name="nota[12]" type="radio" value="1"/>
			         </p></td>
			       <td width="150" valign="middle" title="Entrego instrucciones en forma oral   para que los estudiantes puedan desarrollar los procedimientos de evaluación propuestos. " ><p align="center">
			         <input name="nota[12]" type="radio" value="2"/>
			         </p></td>
			       <td width="148" valign="middle" title="Entrego instrucciones en forma oral y escrita,   para que los estudiantes puedan desarrollar los procedimientos de evaluación propuestos. "><p align="center">
			         <input name="nota[12]" type="radio" value="3"/>
			         </p></td>
			       <td width="147" valign="middle" title="Siempre entrego instrucciones claras y por escrito, para poder desarrollar los procedimientos de evaluación propuestos. Me aseguro de que sean comprendidos por los estudiantes."><p align="center">
			         <input name="nota[12]" type="radio" value="4"/>
			         </p></td>
			       </tr>
			     <tr align="justify">
			       <td width="146" align="left">13.Comunicaci&oacute;n de resultados y retroalimentaci&oacute;n. </td>
			       <td width="147" title="No siempre comento los resultados de la evaluación."><p align="center">
			         <input name="nota[13]" type="radio" value="1"/>
			         </p></td>
			       <td width="150" valign="middle" title="Realizo comentarios de las pruebas solemnes o los trabajos  más importantes, sobre los aspectos más débiles que los estudiantes tienen que mejorar. "><p align="center">
			         <input name="nota[13]" type="radio" value="2"/>
			         </p></td>
			       <td width="148" valign="middle" title="Realizo análisis de las evaluaciones  y comentarios sobre los aspectos más débiles de forma constructiva con el fin de retroalimentar el aprendizaje."  ><p align="center">
			         <input name="nota[13]" type="radio" value="3"/>
			         </p></td>
			       <td width="147"valign="middle" title="Siempre realizo análisis de las evaluaciones  y comentarios, (personales y colectivos)  sobre los aspectos bien logrados y los más débiles de forma constructiva."><p align="center">
			         <input name="nota[13]" type="radio" value="4"/>
			         </p></td>
			       </tr>
			     </table>
			   <br />
			   <table width="100%">
			   <tr>
			    <td width="100%">Con  relaci&oacute;n a mi desempe&ntilde;o docente creo que podr&iacute;a mejorar concretamente en:</td>
			   </tr>
			   <tr>
			      <td width="95%" align="center"><textarea name="texto1_mejora" cols="145" rows="4" class="Estilo25" id="TO-N"></textarea>
				</tr>
				</table>
				<br />
		  <hr align="left" width="100%" size="1" noshade="noshade" />
		  <table width="100%">
		    <tr>
			    <td width="100%">En  esta apartado puede escribir el o los  aspectos externos que pueden haber influido en su quehacer docente y que han  implicado realizar adecuaciones en las estrategias metodol&oacute;gicas planificadas  para el curso.</td>
			   </tr>
			   <tr>
			      <td width="95%" align="center"><textarea name="texto2_mejora" cols="145" rows="4" class="Estilo25" id="TO-N"></textarea>
				</tr>
				</table>
		  <br />
			  <table width="100%">
			   <tr>
			   <td width="36%" align="rigth" valign="top" class="Estilo31"></td>
					
				
					<td width="10%" align="center" valign="top" class="Estilo31">
					 
						<a href="javascript:vovler();">
												
						<img src="Images/vovler1.png" border="0" width="65" height="65" alt="¿Cómo funciona?">					</td>
					
					<td width="11%" align="center" valign="top" class="Estilo31">
					 
						<a href="javascript:validar_ingreso();">
												
						<img src="Images/guardar1.png" border="0" width="65" height="65" alt="¿Cómo funciona?">					</td>
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
