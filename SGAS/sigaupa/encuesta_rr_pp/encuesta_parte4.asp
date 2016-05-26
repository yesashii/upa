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
'LINEA			:
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

function valida_trabajo(valor)
{
//alert("valor "+valor);
	if (valor ==1)
	{
		
		document.edicion.elements["encu[0][preg_34_cual]"].disabled=false;	
		
	}
	else
	{
			
		document.edicion.elements["encu[0][preg_34_cual]"].disabled=true;
	}

}
//Número máximo de casillas marcadas por cada fila 
var maxi=3; 

//El contador es un arrayo de forma que cada posición del array es una linea del formulario 
var contador=new Array(0,0); 

function validarcheckbo(preg,grupo) { 

   //Compruebo si la casilla está marcada
   elemento=preg.name;
   //alert(elemento);
   check=document.edicion.elements[elemento];
   //alert(check.checked);

//ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
//ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

if (elemento=="encu[0][preg_34_9]")
	
    if ((elemento=="encu[0][preg_34_9]")&&(check.checked==true))
   { 
   
	document.edicion.elements["encu[0][preg_34_1]"].disabled=true;	
	document.edicion.elements["encu[0][preg_34_2]"].disabled=true;	
	document.edicion.elements["encu[0][preg_34_3]"].disabled=true;	
	document.edicion.elements["encu[0][preg_34_4]"].disabled=true;	
	document.edicion.elements["encu[0][preg_34_5]"].disabled=true;	
	document.edicion.elements["encu[0][preg_34_6]"].disabled=true;	
	document.edicion.elements["encu[0][preg_34_7]"].disabled=true;	
	document.edicion.elements["encu[0][preg_34_8]"].disabled=true;
	
	document.edicion.elements["encu[0][preg_34_cual]"].disabled=true;
	}
	else
	{
	document.edicion.elements["encu[0][preg_34_1]"].disabled=false;	
	document.edicion.elements["encu[0][preg_34_2]"].disabled=false;	
	document.edicion.elements["encu[0][preg_34_3]"].disabled=false;	
	document.edicion.elements["encu[0][preg_34_4]"].disabled=false;	
	document.edicion.elements["encu[0][preg_34_5]"].disabled=false;	
	document.edicion.elements["encu[0][preg_34_6]"].disabled=false;	
	document.edicion.elements["encu[0][preg_34_7]"].disabled=false;	
	document.edicion.elements["encu[0][preg_34_8]"].disabled=false;	
	
		var var1=document.edicion.elements["encu[0][preg_34_8]"];
		
		if (var1.checked==true)
		{
			document.edicion.elements["encu[0][preg_34_cual]"].disabled=false;
		}
}
else
{	

//ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
//ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
 
   if (check.checked==true){ 
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
  }else { 
       //si la casilla no estaba marcada, resto uno al contador de grupo 
       contador[grupo]--; 
  
    } 
	var elemento2=document.edicion.elements["encu[0][preg_34_8]"];
	
	
	if ((elemento=="encu[0][preg_34_8]") &&(check.checked==true))
	{
	var valor=1
	//alert('1');
	valida_trabajo(valor);
	
	}
	//alert(elemento);
	if ((elemento!="encu[0][preg_34_8]") &&(elemento2.checked==false))
	{
	//alert('0');
	//var valor=0
	valida_trabajo(valor);
	
	}
		if ((elemento=="encu[0][preg_34_8]") &&(check.checked==false))
	{
	//alert('0');
	//var valor=0
	valida_trabajo(valor);
	
	}
	
//ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
//ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
}
//ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
//ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo


} 


function validarmarcados()
{
var preg_30;
var preg_31;
var preg_32;
var preg_33;
var preg_34;

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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_30]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_30=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 30.");
   
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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_31]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_31=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 31.");
   
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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_32]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_32=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 32.");
   
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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_33]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_33=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 33.");
   
  }
}

//888888888888888888888888888888888888888888888888888888888888888888

{ 

//ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
//ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

  var elemento1;
  
   elemento1=document.edicion.elements["encu[0][preg_34_9]"];
   //alert(elemento1);
   
if (elemento1.checked==true)
{
   preg_34=1
}
else
{

//ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
//ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

  var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  var respuestas
  var respondidas
  contestada=0;
  cant_radios=0;
  divisor=25;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="checkbox") )
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==3)
  { 
	 preg_34=1
  }
  else
  {
  respuestas=3
  respondidas=respuestas-contestada
   alert('Te faltan  '+ respondidas +' opciones por selecionar en la pregunta 34.');
   preg_34=0
  }
  
//ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
//ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
}
//ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
//ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

}

//888888888888888888888888888888888888888888888888888888888888888888

if ( (preg_30==1)&& (preg_31==1) && (preg_32==1) && (preg_33==1)&& (preg_34==1))
{
 	return true;
}
else
{
	
	return false;
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
<p align="center"><span class="Estilo34">  </span></p>
<table width="100%" border="0">
<tr valign="top">
<td width="100%" align="center">
<form name="edicion">
<input type="hidden" name="encu[0][pers_nrut]" value="<%=q_pers_nrut%>">
<input type="hidden" name="encu[0][carr_ccod]" value="<%=cod_carrera%>">
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
			
		
			
			
			
				
			 
				
				
			  <p class="Estilo31"><strong><em>30) </em></strong>&quot;Los  egresados de la carrera de Relaciones P&uacute;blicas de la Universidad del Pac&iacute;fico  tenemos un perfil identificable”. </p>
			  <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				<tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("preg_30")%></td>
				</tr>
			  </table>
			  <br />
				<hr align="left" width="550" size="1" noshade="noshade" />
				<p class="Estilo31"><strong><em> 31) </em></strong>En el mercado existe interés por contratar a los egresados de la carrera</p>
				<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("preg_31")%></td>
				  </tr>
				</table>
			  <br />
				<br />
				<hr size="1" noshade="noshade" />
			  <p class="Estilo31"><strong><em> 32) </em></strong>"Al egresar de la carrera, fui contratado(a) de acuerdo a mis expectativas profesionales y de renta". </p>
			  <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("preg_32")%></td>
				  </tr>
				</table>
			  <br />
				<hr align="left" width="100%" size="1" noshade="noshade" />
			  <p class="Estilo31"><strong><em> 33) </em></strong>&quot;A  los egresados de mi carrera nos resulta favorable la comparaci&oacute;n, en t&eacute;rminos  profesionales, con los de otras instituciones acad&eacute;micas&quot;. </p>
			   <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("preg_33")%></td>
				  </tr>
				</table>
			  <br />
			  <hr align="left" width="100%" size="1" noshade="noshade" />
			  <p class="Estilo31"><strong><em> 3<strong><em>4)</em></strong> </em></strong>Las principales características que identifican al Relacionador/a Público de la Universidad del Pacífico son:<br />
<strong>(marca solo 3)</strong></p>
			   <table width="100%" border="1" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
				    <td width="19%" align="left" valign="top" bgcolor="#ffffff" class="Estilo31"><font size="2" color="#000000">Excelente formación teórica y conceptual</font></td>
				    <td width="3%" align="left" valign="top" bgcolor="#CCCCCC"class="Estilo31"><font size="2" color="#000000">
				      <input type="checkbox" name="encu[0][preg_34_1]" value="1" onclick='validarcheckbo(this,0)' ></font></td>
					<td width="22%" align="left" valign="top" bgcolor="#ffffff" class="Estilo31"><p>Define con rigor y profesionalismo, estrategias de comunicación</p></td>
					<td width="3%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" color="#000000">
					  <input type="checkbox" name="encu[0][preg_34_2]" value="2" onclick='validarcheckbo(this,0)'></font></td>
					<td width="22%" align="left" valign="top" bgcolor="#ffffff"class="Estilo31"><p>Diagnostica, diseña y ejecuta planes y programas de Relaciones Públicas.</font></p>					  </td>
				    <td width="3%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" color="#000000">
				      <input type="checkbox" name="encu[0][preg_34_3]" value="3" onclick='validarcheckbo(this,0)'></font></td>
					<td width="25%" align="left" valign="top" bgcolor="#ffffff" class="Estilo31"><p>Selecciona y maneja  los mensajes y Medios de Comunicación más adecuados para la organización que asesora</p></td>
					<td width="3%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" color="#000000">
					  <input type="checkbox" name="encu[0][preg_34_4]" value="4" onclick='validarcheckbo(this,0)'></font></td>
  			     </tr>
				  <tr>
				    <td width="19%" align="left" valign="top" bgcolor="#ffffff"class="Estilo31"><p>Realiza eficaz y eficientemente  acciones de Comunicación Aplicada, tales como eventos, seminarios y congresos.</p></td>
				    <td width="3%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" color="#000000">
				      <input type="checkbox" name="encu[0][preg_34_5]" value="5" onclick='validarcheckbo(this,0)'></font></td>
					<td width="22%" align="left" valign="top" bgcolor="#ffffff"class="Estilo31"><p>Maneja  t&eacute;cnicas de investigaci&oacute;n aplicada, tales como encuestas de mercado y opini&oacute;n  p&uacute;blica.</p></td>
					<td width="3%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" color="#000000">
					  <input type="checkbox" name="encu[0][preg_34_6]" value="6" onclick='validarcheckbo(this,0)'></font></td>
					<td width="22%" align="left" valign="top" bgcolor="#ffffff"class="Estilo31"><p>Maneja una excelente red de contactos</p></td>
				    <td width="3%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" color="#000000">
				      <input type="checkbox" name="encu[0][preg_34_7]" value="7" onclick='validarcheckbo(this,0)'></font></td>
					<td width="25%" align="left" valign="top" bgcolor="#ffffff"class="Estilo31"><p>Otro  &iquest;cu&aacute;l?</p></td>
					<td width="3%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" color="#000000">
					  <input type="checkbox" name="encu[0][preg_34_8]" value="8" onclick='validarcheckbo(this,0)'></font></td>
  			     </tr>
				  <tr>
				    <td width="19%" align="left" valign="top" bgcolor="#ffffff"class="Estilo31"><p>No contesta</p></td>
				    <td width="3%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" color="#000000">
				      <input type="checkbox" name="encu[0][preg_34_9]" value="9" onclick='validarcheckbo(this,0)'></font></td>
					<td width="22%" align="left" valign="top" bgcolor="#ffffff"class="Estilo31"><p></p></td>
					<td width="3%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" color="#000000">
					  <!--<input type="checkbox" name="encu[0][preg_34_10]" value="6" onclick='validarcheckbo(this,0)'>--></font></td>
					<td width="22%" align="left" valign="top" bgcolor="#ffffff"class="Estilo31"><p></p></td>
				    <td width="3%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" color="#000000">
				      <!--<input type="checkbox" name="encu[0][preg_34_11]" value="7" onclick='validarcheckbo(this,0)'>--></font></td>
					<td width="25%" align="left" valign="top" bgcolor="#ffffff"class="Estilo31"><p></p></td>
					<td width="3%" align="left" valign="top" bgcolor="#CCCCCC"><font size="2" color="#000000">
					  <!--<input type="checkbox" name="encu[0][preg_34_12]" value="8" onclick='validarcheckbo(this,0)'>--></font></td>
  			     </tr>
				</table>
				  <br />
  <br />
			  <table width="505">
				
				  <tr>
				    <td width="21%" align="left" valign="top" bgcolor="#ffffff"class="Estilo31"><p> Especificar Otro </p></td>
				  <td width="79%" align="left" class="Estilo31"><%f_encuesta.DibujaCampo("preg_34_cual")%></td>
				  </tr>
				  </table>
				  
			  <%end if%>			  </td>
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

  <br />
  <br />
  <br />
   <p align="center"><strong>&nbsp;<span class="Estilo45">SUGERENCIAS Y COMENTARIOS </span></strong><span class="Estilo45"><br />


<table width="818" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="25" height="24" background="images/borde_superior.jpg"><img width="25" height="24" src="images/superior_izquierda.jpg"></td>
	<td width="646" height="24" background="images/borde_superior.jpg">&nbsp;</td>
	<td width="29" height="24"><img width="29" height="24" src="images/superior_derecha.jpg"></td>
</tr>
<tr>
    <td width="25" background="images/lado_izquierda.jpg" align="right">&nbsp;</td>
	<td bgcolor="#FFFFFF" align="center" width="646">
	
	
		<table width="646" border="0" align="center" cellpadding="10" cellspacing="10" bgcolor="#FFFFFF">
		  <tr>
			<td width="617"><p align="left" class="Estilo31"><em>1.¿Qué contenidos no me fueron entregados y hoy me doy cuenta de que me sería muy favorable conocer? &nbsp;&nbsp;</em>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <strong>
			<%f_encuesta.DibujaCampo("come_1")%>
			</strong></p>    </td>
		  </tr>
		  <tr>
			<td width="617"><p align="center" class="Estilo31"></p>    </td>
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
 <br />
    <br />
<table width="818" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="25" height="24" background="images/borde_superior.jpg"><img width="25" height="24" src="images/superior_izquierda.jpg"></td>
	<td width="646" height="24" background="images/borde_superior.jpg">&nbsp;</td>
	<td width="29" height="24"><img width="29" height="24" src="images/superior_derecha.jpg"></td>
</tr>
<tr>
    <td width="25" background="images/lado_izquierda.jpg" align="right">&nbsp;</td>
	<td bgcolor="#FFFFFF" align="center" width="646">
		<table width="646" border="0" align="center" cellpadding="10" cellspacing="10" bgcolor="#FFFFFF">
		  <tr>
			<td width="617"><p align="left" class="Estilo31"><em>2.	¿Qué sugerencias le haría usted a las autoridades de la carrera para mejorar la calidad de la formación? </em>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>
			 <%f_encuesta.DibujaCampo("come_2")%>
			</strong></p>    </td>
		  </tr>
		  <tr>
			<td width="617"><p align="center" class="Estilo31"><%f_botonera.dibujaBoton "guardar4"%></p>    </td>
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
