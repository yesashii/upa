<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/revisa_session_encuesta_rr_pp.asp"-->
<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO: 
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:19/08/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ENCUESTAS
'LINEA			:435 - 444
'*******************************************************************
''---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
'
set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "encuesta_rr_pp.xml", "botonera"

q_pers_nrut=negocio.obtenerUsuario

set f_encuesta = new CFormulario
f_encuesta.Carga_Parametros "encuesta_rr_pp.xml", "encuesta"
f_encuesta.Inicializar conexion

consulta = " select ''" 

'response.Write("<pre>"&consulta&"</pre>")
f_encuesta.Consultar consulta
f_encuesta.Siguiente

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Encuesta Universidad del Pac&iacute;fico</title>
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
	font-size: 36px;
	font-style: italic;
	color: #FF7F00;
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

// 888888888888888888888888888888888888888888

var preg_22 =0
function ValidaValor_22(valor22)
{
   //alert(valor22);
   if ((valor22==1)||(valor22==2)||(valor22==3)||(valor22==4))
   {
		preg_22=1
   }
   else
   {
		preg_22=0
   }
}

// 888888888888888888888888888888888888888888

var preg_23 =0
function ValidaValor_23(valor23)
{
   //alert(valor22);
   if ((valor23==1)||(valor23==2)||(valor23==3)||(valor23==4))
   {
		preg_23=1
   }
   else
   {
		preg_23=0
   }
}

// 888888888888888888888888888888888888888888

var preg_24 =0
function ValidaValor_24(valor24)
{
   //alert(valor22);
   if ((valor24==1)||(valor24==2)||(valor24==3)||(valor24==4))
   {
		preg_24=1
   }
   else
   {
		preg_24=0
   }
}

// 888888888888888888888888888888888888888888

var preg_25 =0
function ValidaValor_25(valor25)
{
   //alert(valor22);
   if ((valor25==1)||(valor25==2)||(valor25==3)||(valor25==4))
   {
		preg_25=1
   }
   else
   {
		preg_25=0
   }
}

// 888888888888888888888888888888888888888888

var preg_26 =0
function ValidaValor_26(valor26)
{
   //alert(valor22);
   if ((valor26==1)||(valor26==2)||(valor26==3)||(valor26==4))
   {
		preg_26=1
   }
   else
   {
		preg_26=0
   }
}

// 888888888888888888888888888888888888888888

var preg27
function validarmarcados()
{

// 888888888888888888888888888888888888888888
if (preg_22==0) 
{
 alert("Debes selecionar una opcion en la pregunta 22.");
}
if (preg_23==0) 
{
 alert("Debes selecionar una opcion en la pregunta 23.");
}
if (preg_24==0) 
{
 alert("Debes selecionar una opcion en la pregunta 24.");
}
if (preg_25==0) 
{
 alert("Debes selecionar una opcion en la pregunta 25.");
}
if (preg_26==0) 
{
 alert("Debes selecionar una opcion en la pregunta 26.");
}

// 888888888888888888888888888888888888888888


var preg_27=0
var preg_28=0

//{ 
//  var cantidad;
//  var elemento;
//  var contestada;
//  var cant_radios;
//  var divisor;
//  var i; 
//  contestada=0;
//  cant_radios=0;
//  divisor=4;//cantidad de alternativas de respuesta por pregunta
//  cantidad=document.edicion.length;
//  for(i=0;i<cantidad;i++)
//  {
//  elemento=document.edicion.elements[i];
//  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_22]"))
//  		{cant_radios++;
//		  if(elemento.checked){contestada++;}
//  		}
//  }

//  if (contestada==((cant_radios)/divisor))
//  { 
//	 preg_22=1
//  }
//  else
//  {
//   alert("Debes selecionar una opcion en la pregunta 22.");
//   
//  }
//}

//{ 
//  var cantidad;
//  var elemento;
//  var contestada;
//  var cant_radios;
//  var divisor;
//  var i; 
//  contestada=0;
//  cant_radios=0;
//  divisor=4;//cantidad de alternativas de respuesta por pregunta
//  cantidad=document.edicion.length;
//  for(i=0;i<cantidad;i++)
//  {
//  elemento=document.edicion.elements[i];
//  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_23]"))
//  		{cant_radios++;
//		  if(elemento.checked){contestada++;}
//  		}
//  }
//
//  if (contestada==((cant_radios)/divisor))
//  { 
//	 preg_23=1
//  }
//  else
//  {
//   alert("Debes selecionar una opcion en la pregunta 23.");
//   
//  }
//}
//
//{ 
//  var cantidad;
//  var elemento;
//  var contestada;
//  var cant_radios;
//  var divisor;
//  var i; 
//  contestada=0;
//  cant_radios=0;
//  divisor=4;//cantidad de alternativas de respuesta por pregunta
//  cantidad=document.edicion.length;
//  for(i=0;i<cantidad;i++)
//  {
//  elemento=document.edicion.elements[i];
//  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_24]"))
//  		{cant_radios++;
//		  if(elemento.checked){contestada++;}
//  		}
//  }
//
//  if (contestada==((cant_radios)/divisor))
//  { 
//	 preg_24=1
//  }
//  else
//  {
//   alert("Debes selecionar una opcion en la pregunta 24.");
//   
//  }
//}
//
//{ 
//  var cantidad;
//  var elemento;
//  var contestada;
//  var cant_radios;
//  var divisor;
//  var i; 
//  contestada=0;
//  cant_radios=0;
//  divisor=4;//cantidad de alternativas de respuesta por pregunta
//  cantidad=document.edicion.length;
//  for(i=0;i<cantidad;i++)
//  {
//  elemento=document.edicion.elements[i];
//  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_25]"))
//  		{cant_radios++;
//		  if(elemento.checked){contestada++;}
//  		}
//  }
//
//  if (contestada==((cant_radios)/divisor))
//  { 
	// preg_25=1
//  }
//  else
//  {
//   alert("Debes selecionar una opcion en la pregunta 25.");
//   
//  }
//}

//88888888888888888888888888888888888888888888888888888888888888888

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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_27]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_27=1
	 
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 27.");
   
  }
}

//88888888888888888888888888888888888888888888888888888888888888888

  //alert(preg27);

{ 
 
  if (preg27=='N')
  {
  var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor=8;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_28]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_28=1
  }
  else
  	{
   alert("Debes selecionar una opcion en la pregunta 28.");
   
  	}
  }
   else
   {
      
   preg_28=1
   }
}

//88888888888888888888888888888888888888888888888888888888888888888

{ 
  var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor=12;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_29]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_29=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 29.");
   
  }
 
}

if ( (preg_22==1) &&(preg_23==1) && (preg_24==1) &&(preg_25==1) && (preg_26==1) &&(preg_27==1) && (preg_28==1) && (preg_29==1) )
{
 	return true;
}
else
{
	return false;
}

}

function valida_trabajo(valor)
{
//alert("valor "+valor);
	if (valor =='S')
	{
		
		document.edicion.elements["encu[0][preg_27_tipo]"].disabled=false;	
		preg27=valor;
	}
	else
	{
			
		document.edicion.elements["encu[0][preg_27_tipo]"].disabled=true;
		preg27=valor;
	}

}

function valida_otro_29(valor)
{
//alert("valor "+valor);
	if (valor =='24')
	{
		
		document.edicion.elements["encu[0][preg_29_otro]"].disabled=false;	
		
	}
	else
	{
			
		document.edicion.elements["encu[0][preg_29_otro]"].disabled=true;
	}

}

function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if%>
}

</script>
</head>

<body  onLoad="Mensaje();">
<!--<p align="center" class="Estilo35">&quot;Encuesta Egresados de RR PP&quot;</p>-->
<p align="center"><span class="Estilo34"> </span></p>
<table width="100%" border="0">
<tr valign="top">
<td width="100%" align="center">
<form name="edicion">
<input type="hidden" name="encu[0][pers_nrut]" value="<%=q_pers_nrut%>">

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
			
			    <% if contestada <> "S" then %>

				<p class="Estilo43">Usted encontrará en esta sección  un conjunto de afirmaciones respecto a las cuales podrá expresar su grado de acuerdo o desacuerdo.</p> <p class="Estilo43">Si considera que manifestarse sobre algún punto en particular no corresponde pues carece de la información adecuada para emitir un juicio, bastará con <strong> omitir la respuesta</strong>. </p>
			    <p class="Estilo31"><strong><em> 22) </em></strong>La carrera de relaciones Públicas de la Universidad del Pacífico, actualmente ofrece programas y mecanismos para el perfeccionamiento y/o actualización de los egresados”. </p>
			  <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				<tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("preg_22")%></td>
				</tr>
			  </table>
			  <br />
				<hr align="left" width="550" size="1" noshade="noshade" />
				<p class="Estilo31"><strong><em> 23) </em></strong>“Existe un proceso eficiente de seguimiento de los egresados". </p>
				<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("preg_23")%></td>
				  </tr>
				</table>
			  <br />
				<br />
				<hr size="1" noshade="noshade" />
			  <p class="Estilo31"><strong><em> 24) </em></strong>&ldquo;La carrera de relaciones Públicas de la Universidad del Pacífico disponen de una buena política de colocación laboral&rdquo;</p>
			  <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("preg_24")%></td>
				  </tr>
				</table>
			  <br />
				<hr align="left" width="550" size="1" noshade="noshade" />
			  <!--<p class="Estilo31"><strong><em> 25) </em></strong>&ldquo;La  carrera de relaciones P&uacute;blicas de la Universidad del Pac&iacute;fico fomenta y  facilita la participaci&oacute;n de egresados en seminarios y/o charlas sobre la  disciplina&rdquo;</p>-->
			  <p class="Estilo31"><strong><em> 25) </em></strong>"La formación que recibí fue suficiente para desempeñar satisfactoriamente mi práctica profesional y para enfrentarme al mundo laboral".</p>
			   <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("preg_25")%></td>
				  </tr>
				</table>
				<br />
				<hr align="left" width="550" size="1" noshade="noshade" />
			  <!--<p class="Estilo31"><strong><em> 26) </em></strong>"La formación que recibí fue suficiente para desempeñar satisfactoriamente mi práctica profesional y para enfrentarme al mundo laboral". </p>-->
			  <p class="Estilo31"><strong><em> 26) </em></strong>&ldquo;La  carrera de relaciones P&uacute;blicas de la Universidad del Pac&iacute;fico fomenta y  facilita la participaci&oacute;n de egresados en seminarios y/o charlas sobre la  disciplina&rdquo;</p>
			   <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("preg_26")%></td>
				  </tr>
				</table>
			  <br />
			  <hr align="left" width="100%" size="1" noshade="noshade" />
			  <p class="Estilo31"><em><strong><em> 27 </em></strong>&ldquo;Luego de su formación profesional en la Universidad del Pacífico usted ¿ha continuado perfeccionándose en la Universidad u otras instituciones?&rdquo;</p>
			  
			  <CENTER>
			   <table width="60%" border="0" cellpadding="0" cellspacing="0">
				  <tr align="center">
					<td width="3%" valign="top" bgcolor="#CCCCCC"class="Estilo31"><p align="center">
						<input name="encu[0][preg_27]" type="radio" value="S" onClick="valida_trabajo(this.value);"  />
					</p></td>
					<td width="47%" valign="top"  class="Estilo31" >Si <BR>(marcar el que corresponda)</td>
					<td width="3%" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="encu[0][preg_27]" type="radio" value="N"  onclick="valida_trabajo(this.value);"  />
					</p></td>
					<td width="47%" valign="top" class="Estilo31">No <BR><strong>(contestar pregunta 28)</strong></td>
				  </tr>
				 </table>
				 </CENTER>
				 
				   <br />
				 <table>
				   <tr>
				   <td width="24"></td>
				  <td width="151"><%f_encuesta.dibujaCampo("preg_27_tipo")%></td>
				  </tr>
				 </table>
			    <br />
			  <hr align="left" width="100%" size="1" noshade="noshade" />
			  <p class="Estilo31"><em><strong><em> 28) </em></strong>Por favor, señale el principal obstáculo que le dificultan o impiden realizar un curso o activad de perfeccionamiento</p>
			   <table width="99%" border="1" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
                 <tr>
                   <td width="27%" align="left" valign="top" bgcolor="#FFFFFF" class="Estilo31"><p>No tengo tiempo laboral (demasiado trabajo) </p></td>
                   <td width="3%" align="left" valign="top" bgcolor="#CCCCCC"class="Estilo31"><font size="2" color="#000000">
                     <input type="radio" value="1" name="encu[0][preg_28]">
                   </font></td>
                   <td width="27%" align="left" valign="top" bgcolor="#FFFFFF" class="Estilo31"><p>No tengo tiempo personal </p></td>
                   <td width="3%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" color="#000000">
                     <input type="radio" value="2" name="encu[0][preg_28]">
                   </font></td>
                   <td width="27%" align="left" valign="top" bgcolor="#FFFFFF"class="Estilo31"><p>El costo de los cursos es muy elevado</p></td>
                   <td width="3%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" color="#000000">
                     <input type="radio" value="3" name="encu[0][preg_28]">
                   </font></td>
                 </tr>
                 <tr>
                   <td width="27%" align="left" valign="top" bgcolor="#FFFFFF"class="Estilo31"><p>Es imposible cuando supone desplazamiento geográfico</p></td>
                   <td width="3%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" color="#000000">
                     <input type="radio" value="4" name="encu[0][preg_28]">
                   </font></td>
                   <td width="27%" align="left" valign="top" bgcolor="#FFFFFF"class="Estilo31"><p>La empresa no me da facilidades</p></td>
                   <td width="3%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" color="#000000">
                     <input type="radio" value="5" name="encu[0][preg_28]">
                   </font></td>
                   <td width="27%" align="left" valign="top" bgcolor="#FFFFFF"class="Estilo31"><p>No encuentro cursos que me interesen</p></td>
                   <td width="3%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" color="#000000">
                     <input type="radio" value="6" name="encu[0][preg_28]">
                   </font></td>
                 </tr>
                 <tr>
                   <td width="27%" align="left" valign="top" bgcolor="#FFFFFF"class="Estilo31"><p>No encuentro ninguna dificultad ni obstáculo</p></td>
                   <td width="3%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" color="#000000">
                     <input type="radio" value="7" name="encu[0][preg_28]">
                   </font></td>
                   <td width="27%" align="left" valign="top" bgcolor="#FFFFFF"class="Estilo31"><p>No contesta</p></td>
                   <td width="3%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" color="#000000">
                     <input type="radio" value="8" name="encu[0][preg_28]">
                   </font></td>
                   <td width="27%" align="left" valign="top" bgcolor="#FFFFFF"class="Estilo31"><p> </p></td>
                   <td width="3%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" color="#000000">
                     <!--<input type="radio" value="9" name="encu[0][preg_28]">-->
                   </font></td>
                 </tr>
                 
               </table>
			   <br />
			  <hr align="left" width="100%" size="1" noshade="noshade" />
			  <p class="Estilo31"><em><strong><em> 29) </em></strong>De las siguientes áreas de interés, seleccione aquella  que le permitiría perfeccionarse y mejorar su actual desempeño profesional :  <strong>(marque solo una)</strong></p>
			  <table width="99%" border="1" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
				    <td width="22%" align="left" valign="top" bgcolor="#FFFFFF" class="Estilo31"><p>Ceremonial y Protocolo </p></td>
				    <td width="3%" align="left" valign="top" bgcolor="#CCCCCC"class="Estilo31"><font size="2" color="#000000"><input type="radio" value="1" name="encu[0][preg_29]"  onclick="valida_otro_29(this.value);"></font></td>
					<td width="22%" align="left" valign="top" bgcolor="#FFFFFF" class="Estilo31"><p>Producción de Eventos</p></td>
					<td width="3%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" color="#000000"><input type="radio" value="2" name="encu[0][preg_29]"  onclick="valida_otro_29(this.value);"></font></td>
					<td width="22%" align="left" valign="top" bgcolor="#FFFFFF"class="Estilo31"><p>Administración de Empresas</p></td>
				    <td width="3%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" color="#000000"><input type="radio" value="3" name="encu[0][preg_29]" onclick="valida_otro_29(this.value);"></font></td>
					<td width="22%" align="left" valign="top" bgcolor="#FFFFFF" class="Estilo31"><p>Planificación de Medios y Media Training</p></td>
					<td width="3%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" color="#000000"><input type="radio" value="4" name="encu[0][preg_29]" onclick="valida_otro_29(this.value);"></font></td>
  			     </tr>
				  <tr>
				    <td width="22%" align="left" valign="top" bgcolor="#FFFFFF"class="Estilo31"><p>Marketing</p></td>
				    <td width="3%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" color="#000000"><input type="radio" value="5" name="encu[0][preg_29]" onclick="valida_otro_29(this.value);"></font></td>
					<td width="22%" align="left" valign="top" bgcolor="#FFFFFF"class="Estilo31"><p>Idiomas (inglés u otro)</p></td>
					<td width="3%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" color="#000000"><input type="radio" value="6" name="encu[0][preg_29]" onclick="valida_otro_29(this.value);"></font></td>
					<td width="22%" align="left" valign="top" bgcolor="#FFFFFF"class="Estilo31"><p>Diseño y Evaluación de Proyectos</p></td>
				    <td width="3%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" color="#000000"><input type="radio" value="7" name="encu[0][preg_29]" onclick="valida_otro_29(this.value);"></font></td>
					<td width="22%" align="left" valign="top" bgcolor="#FFFFFF"class="Estilo31"><p>Tecnologías de la Información</p></td>
					<td width="3%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" color="#000000"><input type="radio" value="8" name="encu[0][preg_29]" onclick="valida_otro_29(this.value);"></font></td>
  			     </tr>
				  <tr>
				    <td width="22%" align="left" valign="top" bgcolor="#FFFFFF"class="Estilo31"><p>Gestión de Personas</p></td>
				    <td width="3%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" color="#000000"><input type="radio" value="9" name="encu[0][preg_29]" onclick="valida_otro_29(this.value);"></font></td>
					<td width="22%" align="left" valign="top" bgcolor="#FFFFFF"class="Estilo31"><p>Liderazgo y Gestión de Conflictos</p></td>
					<td width="3%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" color="#000000"><input type="radio" value="10" name="encu[0][preg_29]" onclick="valida_otro_29(this.value);"></font></td>
					<td width="22%" align="left" valign="top" bgcolor="#FFFFFF"class="Estilo31"><p>Comunicación Estratégica y Creatividad</p></td>
				    <td width="3%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" color="#000000"><input type="radio" value="11" name="encu[0][preg_29]" onclick="valida_otro_29(this.value);"></font></td>
					<td width="22%" align="left" valign="top" bgcolor="#FFFFFF"class="Estilo31"><p>Otro, se&ntilde;alar</p></td>
					<td width="3%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" color="#000000"><input type="radio" value="24" name="encu[0][preg_29]" onclick="valida_otro_29(this.value);"></font></td>
  			     </tr>
				 	 
				 
				</table>
				<br />
				 <table width="100%" border="0" cellpadding="0" cellspacing="0" >
				  <tr>
				  <td width="12%" align="left" valign="top" class="Estilo31" ><p>Indicar Otro</p></td>
					<td width="88%" align="left" valign="top" class="Estilo31" ><%f_encuesta.dibujaCampo("preg_29_otro")%></td>
				  </tr>
			  </table>
				 <br />
				 
			   <br />
				  <table width="100%">
			   <tr>
			  	   <td width="79%" align="rigth" valign="top" class="Estilo31"></td>
					<td width="79%" align="center" valign="top" class="Estilo31"><%f_botonera.dibujaboton("guardar3")%></td>
					<td width="79%" align="left" valign="top" class="Estilo31">&nbsp;</td>
				  </tr>
			  </table>
			  <%end if%>
			  </td>
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
<p align="center"><strong>&nbsp;<span class="Estilo45">&iexcl;Muchas gracias por  tu colaboraci&oacute;n! </span></strong><span class="Estilo45"><br /></p>
<p align="center" class="Estilo31">&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
</td>
</tr>
</table>
</body>

</html>
