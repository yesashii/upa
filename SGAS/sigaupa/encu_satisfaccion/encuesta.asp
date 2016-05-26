<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/revisa_session_encuesta_satisfaccion.asp"-->

<%

'---------------------------------------------------------------------------------------------------
'set pagina = new CPagina
'pagina.Titulo = "Encuesta Así soy yo"
'---------------------------------------------------------------------------------------------------

set conexion = new CConexion
conexion.Inicializar "upacifico"
'
set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "encuesta_satifaccion.xml", "botonera"

set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "encuesta_satifaccion.xml", "encabezado"
f_encabezado.Inicializar conexion

q_pers_nrut=negocio.obtenerUsuario

consulta = " select ''" 
		   
		   

'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_encabezado.Consultar consulta
f_encabezado.Siguiente

set f_encuesta = new CFormulario
f_encuesta.Carga_Parametros "encuesta_satifaccion.xml", "encuesta"
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

function valida_trabajo(valor)
{
//alert("valor "+valor);
	if (valor =='8')
	{
		
		document.edicion.elements["encu[0][preg_4_otro]"].disabled=false;	
		
	}
	else
	{
			
		document.edicion.elements["encu[0][preg_4_otro]"].disabled=true;
	}

}
function valida_8(valor)
{
//alert("valor "+valor);
	if (valor =='8')
	{
		
		document.edicion.elements["encu[0][preg_8_otro]"].disabled=false;	
		
	}
	else
	{
			
		document.edicion.elements["encu[0][preg_8_otro]"].disabled=true;
	}

}
function valida_trabajo2(valor)
{
//alert("valor "+valor);
	if (valor =='S')
	{
		
		document.edicion.elements["encu[0][preg_3]"].disabled=false;	
		
	}
	else
	{
			
		document.edicion.elements["encu[0][preg_3]"].disabled=true;
	}

}

function valida_III(valor)
{
//alert("valor "+valor);
//if (valor=='4')
		
	//{	
		if (document.edicion.elements["encu[0][III_preg_1_4]"].checked==true)
		{
		
			document.edicion.elements["encu[0][preg_III_1_otro]"].disabled=false;	
		
		}
		else
		{
			
			document.edicion.elements["encu[0][preg_III_1_otro]"].disabled=true;
		}
		
	//}
	//else
	//{
	//document.edicion.elements["encu[0][preg_III_1_otro]"].disabled=true;
	//}	

}


//Número máximo de casillas marcadas por cada fila 
var maxi=1; 

//El contador es un arrayo de forma que cada posición del array es una linea del formulario 
var contador=new Array(0,0); 
//checkb,

function validarcheckbo(preg,grupo) { 
   //Compruebo si la casilla está marcada
   
   elemento=preg.name;

    //alert(elemento);
    check=document.edicion.elements[elemento];
   //alert(check.checked);
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
} 


function ValidarMarcados()
{
var I_preg_1
var I_preg_2
var I_preg_3
var I_preg_4
var I_preg_5
var preg_II_1
var preg_II_2
var II_preg_3
var II_preg_4
var II_preg_5
var II_preg_6
var II_preg_7
var III_preg_1

aviso="Te falta";


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
   aviso=aviso+"\rDebes selecionar una opcion en la pregunta 1 de la parte I.\r";
   
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
  divisor=2;//cantidad de alternativas de respuesta por pregunta
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
   aviso=aviso+"Debes selecionar una opcion en la pregunta 2 de la parte I.\r";
   
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
  divisor=2;//cantidad de alternativas de respuesta por pregunta
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
   aviso=aviso+"Debes selecionar una opcion en la pregunta 3 de la parte I.\r";
   
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
  divisor=2;//cantidad de alternativas de respuesta por pregunta
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
 aviso=aviso+"Debes selecionar una opcion en la pregunta 4 de la parte I.\r";
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
  divisor=2;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio")&& (elemento.name=="encu[0][I_preg_5]"))
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
 aviso=aviso+"Debes selecionar una opcion en la pregunta 4 de la parte I.\r";
   I_preg_5s=0
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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_II_1]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_II_1=1
  }
  else
  {
   aviso=aviso+"Debes selecionar una opcion en la pregunta 1 de la parte II.\r";
   
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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_II_2]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_II_2=1
  }
  else
  {
  aviso=aviso+"Debes selecionar una opcion en la pregunta 2 de la parte II.\r";
   
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
  divisor=2;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  //alert(cantidad);
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") &&  (elemento.name=="encu[0][II_preg_3]"))
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
   aviso=aviso+"Debes selecionar una opcion en la pregunta 3 de la parte II.\r";
   
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
  divisor=2;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][II_preg_4]"))
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
   aviso=aviso+"Debes selecionar una opcion en la pregunta 4 de la parte II.\r";
   
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
  divisor=2;//cantidad de alternativas de respuesta por pregunta
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
	 II_preg_4=1
	 
  }
  else
  {
   aviso=aviso+"Debes selecionar una opcion en la pregunta 5 de la parte II.\r";
   
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
  divisor=2;//cantidad de alternativas de respuesta por pregunta
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
   aviso=aviso+"Debes selecionar una opcion en la pregunta 5 de la parte II.\r";
   
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
  divisor=2;//cantidad de alternativas de respuesta por pregunta
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
   aviso=aviso+"Debes selecionar una opcion en la pregunta 6 de la parte II.\r";
   
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
  divisor=2;//cantidad de alternativas de respuesta por pregunta
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
   aviso=aviso+"Debes selecionar una opcion en la pregunta 7 de la parte II.\r";
   
  }
}


{ 
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
  divisor=4;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="checkbox") )
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }
//alert(contestada);
  if (contestada >0)
  { 
	 III_preg_1=1
	
  }
  else
  {
  
  aviso=aviso+"Debes selecionar al menos opcion en la pregunta 1 de la parte III.\r";
   III_preg_1=0
   
  }
}



if ((I_preg_1==1) && (I_preg_2==1) && (I_preg_3==1) && (I_preg_4==1)&& (I_preg_5==1)&& (preg_II_1==1) && (preg_II_2==1) && (II_preg_3==1) && (II_preg_4==1)&& (II_preg_5==1)&& (II_preg_6==1)&& (III_preg_1==1))
{
 	return true;
	
}
else
{
	alert(aviso)
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
		  
			<td width="723" align="left"><p class="Estilo27">
				
				<table width="654">
					<tr>
						<td align="center">
							<p class="Estilo35">Favor de responder de acuerdo a su experiencia .</p>

                			<p class="Estilo35">Atte.
							<br />Direcci&oacute;n de Desarrollo y Emprendimiento.
							<br /> Departamento de Informática.</p>

						</td>
					</tr>
				</table>
					<br /> 
					<br />


			    <table width="90%" border="0" bgcolor="#FFFFFF">
                  <tr>
                    <td class="Estilo31" width="26%">&Aacute;rea de Procedencia </td>
                    <td class="Estilo31" width="2%">:</td>
                    <td class="Estilo31" align="left"><%f_encuesta.DibujaCampo("area")%>
                    </strong></td>
                  </tr>
                  <tr>
                    <td class="Estilo31" width="26%">Nombre del Proyecto </td>
                    <td class="Estilo31" width="2%">:</td>
                    <td class="Estilo31" align="left"><%f_encuesta.DibujaCampo("nombre")%></td>
                  </tr>
                  <tr>
                    <td class="Estilo31" width="26%">Responsable de la Petici&oacute;n </td>
                    <td class="Estilo31" width="2%">:</td>
                    <td class="Estilo31" align="left"><%f_encuesta.DibujaCampo("responsable")%></td>
                  </tr>
                  <tr>
                    <td class="Estilo31" width="26%">Fecha de la Petición </td>
                    <td class="Estilo31" width="2%">:</td>
                    <td class="Estilo31" align="left"><%f_encuesta.DibujaCampo("fecha")%> 
                    <strong>dd/mm/aaaa</strong></td>
                  </tr>
                  <tr>
                    <td class="Estilo31" colspan="3"><p class="Estilo31">&nbsp;</p></td>
                  </tr>
			    
			      </table>
			  
			    <br />
			   <table>
			   <tr>
			    <td align="left"><p class="Estilo27">I Proceso. </p>				</td>
				</tr>
				</table>
			  <br />
			
			  <p class="Estilo31"><strong><em> 1) </em></strong>¿Su Solicitud inicial fue atendida en el marco de 48 horas h&aacute;biles?</p>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
				  <tr align="center">
				  <td width="38"></td>
					<td width="30" valign="top" bgcolor="#CCCCCC"class="Estilo31"><p align="center">
						<input name="encu[0][I_preg_1]" type="radio" value="S"/>
					</p></td>
					<td width="33" valign="top"  class="Estilo31" >Si</td>
					<td width="57"></td>
					<td width="30" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="encu[0][I_preg_1]" type="radio" value="N"/>
					</p></td>
					
					<td width="33" valign="top" class="Estilo31">No</td>
					<td width="209"></td>
					<td width="280"></td>
				  </tr>
			  </table>  
				<hr align="left" width="100%" size="1" noshade="noshade" />
				<p class="Estilo31"><strong><em> 2) </em></strong>¿Recibió usted una Carta Gantt con el calendario y actividades definidas para darle servicio?
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
				  <tr align="center">
				  <td width="38"></td>
					<td width="30" valign="top" bgcolor="#CCCCCC"class="Estilo31"><p align="center">
						<input name="encu[0][I_preg_2]" type="radio" value="S"/>
					</p></td>
					<td width="33" valign="top"  class="Estilo31" >Si</td>
					<td width="57"></td>
					<td width="30" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="encu[0][I_preg_2]" type="radio" value="N"/>
					</p></td>
					
					<td width="33" valign="top" class="Estilo31">No</td>
					<td width="209"></td>
					<td width="280"></td>
				  </tr>
			  </table>
				<hr align="left" width="100%" size="1" noshade="noshade" />
								<p class="Estilo31"><strong><em> 3) </em></strong>¿Los Tiempos propuestos en la carta gantt se cumplieron? 
				                <table width="100%" border="0" cellpadding="0" cellspacing="0">
				  <tr align="center">
				  <td width="38"></td>
					<td width="30" valign="top" bgcolor="#CCCCCC"class="Estilo31"><p align="center">
						<input name="encu[0][I_preg_3]" type="radio" value="S"/>
					</p></td>
					<td width="33" valign="top"  class="Estilo31" >Si</td>
					<td width="57"></td>
					<td width="30" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="encu[0][I_preg_3]" type="radio" value="N"/>
					</p></td>
					
					<td width="33" valign="top" class="Estilo31">No</td>
					<td width="209"></td>
					<td width="280"></td>
				  </tr>
			  </table>
				<hr align="left" width="100%" size="1" noshade="noshade" />
			  <p class="Estilo31"><strong><em> 4) </em></strong>¿Las Reuniones de coordinación, durante el desarrollo informático precisaron sus dudas y acuerdos?</p>
			  <table width="100%" border="0" cellpadding="0" cellspacing="0">
				  <tr align="center">
				  <td width="38"></td>
					<td width="30" valign="top" bgcolor="#CCCCCC"class="Estilo31"><p align="center">
						<input name="encu[0][I_preg_4]" type="radio" value="S"/>
					</p></td>
					<td width="33" valign="top"  class="Estilo31" >Si</td>
					<td width="57"></td>
					<td width="30" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="encu[0][I_preg_4]" type="radio" value="N"/>
					</p></td>
					
					<td width="33" valign="top" class="Estilo31">No</td>
					<td width="209"></td>
					<td width="280"></td>
				  </tr>
			  </table>
		  <hr align="left" width="100%" size="1" noshade="noshade" />
			   <br />
			  
			      <p class="Estilo31"><strong><em> 5) </em></strong>¿El &aacute;rea de inform&aacute;tica logr&oacute; hacer una propuesta t&eacute;cnica que  respondiera a su solicitud?</p>
				  <table width="100%" border="0" cellpadding="0" cellspacing="0">
				  <tr align="center">
				  <td width="38"></td>
					<td width="30" valign="top" bgcolor="#CCCCCC"class="Estilo31"><p align="center">
						<input name="encu[0][I_preg_5]" type="radio" value="S"/>
					</p></td>
					<td width="33" valign="top"  class="Estilo31" >Si</td>
					<td width="57"></td>
					<td width="30" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="encu[0][I_preg_5]" type="radio" value="N"/>
					</p></td>
					
					<td width="33" valign="top" class="Estilo31">No</td>
					<td width="209"></td>
					<td width="280"></td>
				  </tr>
			  </table>
		          <hr align="left" width="100%" size="1" noshade="noshade" />
			   <br />
			   <table>
			   <tr>
			    <td align="left"><p class="Estilo27">II Expectativa del servicio. </p>				</td>
				</tr>
				</table>
			  
			  <br />
			  <p class="Estilo31"><strong><em> 1) </em></strong>¿Cu&aacute;l fue el trato del personal que prest&oacute; la Unidad Inform&aacute;tica?</p>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
				  <tr align="center">
				  <td width="37"></td>
					<td width="31" valign="top" bgcolor="#CCCCCC"class="Estilo31"><p align="center">
						<input name="encu[0][preg_II_1]" type="radio" value="1"/></p></td>
					<td width="51" valign="top"  class="Estilo31" >Malo</td>
					
					<td width="31" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="encu[0][preg_II_1]" type="radio" value="2"/></p></td>
					
					<td width="51" valign="top" class="Estilo31">Regular</td>
					
					<td width="31" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="encu[0][preg_II_1]" type="radio" value="3"/></p></td>
					
					<td width="46" valign="top" class="Estilo31">Bueno</td>
						<td width="31" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="encu[0][preg_II_1]" type="radio" value="4"/></p></td>
					
					<td width="88" valign="top" class="Estilo31">Muy Bueno </td>
					
					<td width="240" valign="top" ></td>
					
					<td width="86" valign="top"></td>
				  </tr>
				   				  
			  </table>
				  <hr align="left" width="100%" size="1" noshade="noshade" />
				<br />
				<p class="Estilo31"><strong><em> 2)  </em></strong>¿En general cu&aacute;l nivel de satisfacci&oacute;n tiene el servicio recibido?</p>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
				  <tr align="center">
				  <td width="37"></td>
					<td width="31" valign="top" bgcolor="#CCCCCC"class="Estilo31"><p align="center">
						<input name="encu[0][preg_II_2]" type="radio" value="1"/></p></td>
					<td width="51" valign="top"  class="Estilo31" >Malo</td>
					
					<td width="31" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="encu[0][preg_II_2]" type="radio" value="2"/></p></td>
					
					<td width="51" valign="top" class="Estilo31">Regular</td>
					
					<td width="31" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="encu[0][preg_II_2]" type="radio" value="3"/></p></td>
					
					<td width="46" valign="top" class="Estilo31">Bueno</td>
						<td width="31" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="encu[0][preg_II_2]" type="radio" value="4"/></p></td>
					
					<td width="86" valign="top" class="Estilo31">Muy Bueno</td>
					
					<td width="242" valign="top" ></td>
					
					<td width="86" valign="top"></td>
				  </tr>
				   				  
			  </table>
			    <br />
			
			  <br />
				
				<hr align="left" width="100%" size="1" noshade="noshade" />
				<p class="Estilo31"><strong><em> 3) </em></strong>Como Usuario, recib&iacute; instrucciones para utilizar el desarrollo inform&aacute;tico solicitado. </p>
				 
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
				  <tr align="center">
				  <td width="38"></td>
					<td width="30" valign="top" bgcolor="#CCCCCC"class="Estilo31"><p align="center">
						<input name="encu[0][II_preg_3]" type="radio" value="S"/>
					</p></td>
					<td width="33" valign="top"  class="Estilo31" >Si</td>
					<td width="57"></td>
					<td width="30" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="encu[0][II_preg_3]" type="radio" value="N"/>
					</p></td>
					
					<td width="33" valign="top" class="Estilo31">No</td>
					<td width="209"></td>
					<td width="280"></td>
				  </tr>
			  </table>
				<br />
				<hr align="left" width="100%" size="1" noshade="noshade" />
				<br />
				<p class="Estilo31"><strong><em> 4) </em></strong>¿Cuando acudo al Departamento de informatica, contacto f&aacute;cilmente con una persona que pueda responder mi inqueitudes?</p>
				
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
				  <tr align="center">
				  <td width="38"></td>
					<td width="30" valign="top" bgcolor="#CCCCCC"class="Estilo31"><p align="center">
						<input name="encu[0][II_preg_4]" type="radio" value="S"/>
					</p></td>
					<td width="33" valign="top"  class="Estilo31" >Si</td>
					<td width="57"></td>
					<td width="30" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="encu[0][II_preg_4]" type="radio" value="N"/>
					</p></td>
					
					<td width="33" valign="top" class="Estilo31">No</td>
					<td width="209"></td>
					<td width="280"></td>
				  </tr>
			  </table>
				<br />
				<hr align="left" width="100%" size="1" noshade="noshade" />
				<p class="Estilo31"><strong><em> 5) </em></strong>¿
				El Horario del Departamento asegura que  pueda acudir a &eacute;l siempre que se necesite?</p>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
				  <tr align="center">
				  <td width="38"></td>
					<td width="30" valign="top" bgcolor="#CCCCCC"class="Estilo31"><p align="center">
						<input name="encu[0][II_preg_5]" type="radio" value="S"/>
					</p></td>
					<td width="33" valign="top"  class="Estilo31" >Si</td>
					<td width="57"></td>
					<td width="30" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="encu[0][II_preg_5]" type="radio" value="N"/>
					</p></td>
					
					<td width="33" valign="top" class="Estilo31">No</td>
					<td width="209"></td>
					<td width="280"></td>
				  </tr>
			  </table>
			    <br />
				<hr align="left" width="100%" size="1" noshade="noshade" />
				<p class="Estilo31"><strong><em> 6) </em></strong>¿El Departamento recoge de forma adecuada las quejas y sugerencias de los usuarios?</p>
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
				  <tr align="center">
				  <td width="38"></td>
					<td width="30" valign="top" bgcolor="#CCCCCC"class="Estilo31"><p align="center">
						<input name="encu[0][II_preg_6]" type="radio" value="S"/>
					</p></td>
					<td width="33" valign="top"  class="Estilo31" >Si</td>
					<td width="57"></td>
					<td width="30" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="encu[0][II_preg_6]" type="radio" value="N"/>
					</p></td>
					
					<td width="33" valign="top" class="Estilo31">No</td>
					<td width="209"></td>
					<td width="280"></td>
				  </tr>
				
				   <tr>
						<td colspan="8">
						  <br />
							<table width="385">
					  <td width="40%" align="left" class="Estilo31">Especifique Como </td>
			  		    <td width="60%">
						
					<%f_encuesta.DibujaCampo("II_preg_6_como")%>
			  		</td>
						  </table>
						</td>	
			  	</tr>
				
			  </table>
				<hr align="left" width="100%" size="1" noshade="noshade" />
			    <br />
				<table>
			   <tr>
			    <td align="left"><p class="Estilo27">III Aspectos Generales. </p>				
			    </tr>
				</table>
				<br />
			  <p class="Estilo31"><strong><em> 1) </em></strong>En Cuanto a su experiencia &iquest;Cuales son los aspectos que deben mejorar? </p>
				<br />
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
				  <tr align="center">
				  <td width="37"></td>
					<td width="30" align="left" bgcolor="#CCCCCC"class="Estilo31"><p align="center">
						<input name="encu[0][III_preg_1_1]" type="checkbox" value="1" onClick="valida_III(this.value);"/>
					</p></td>
					 
					
					<td width="197" align="left"  class="Estilo31" >Rapidez</td>
					</tr>
					 <tr align="center">
					<td width="37"></td>
					<td width="30" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="encu[0][III_preg_1_2]" type="checkbox" value="2" onClick="valida_III(this.value);"/>
					</p></td>
					
					<td width="197" align="left" class="Estilo31">Informaci&oacute;n del servicio prestado </td>
					<td width="459"></td>
				  </tr>
				  <tr align="center">
					<td width="37"></td>
					<td width="30" align="left" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="encu[0][III_preg_1_3]" type="checkbox" value="3"onclick="valida_III(this.value);" />
					</p></td>
					
					<td width="197" align="left" class="Estilo31">Atenci&oacute;n</td>
					<td width="459"></td>
				  </tr>
				  <tr align="center">
					<td width="37"></td>
					<td width="30" align="left" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
					  <input name="encu[0][III_preg_1_4]" type="checkbox" value="4" onClick="valida_III(this.value);"/>
					</p></td>
					
					<td width="197" align="left" class="Estilo31">Otro</td>
					<td width="459"></td>
				  </tr>
			  </table>
			  <br/>
			  <table>
			  	<tr>
				<td align="left" class="Estilo31">Especifique Otro </td>
			  		<td>
					<%f_encuesta.DibujaCampo("preg_III_1_otro")%>
			  		</td>
			  	</tr>
			  </table> 
				  <hr align="left" width="100%" size="1" noshade="noshade" />
				<br />
				<p class="Estilo31"><strong><em> 2) </em></strong>Sugerencias y/o Observaciones </p>
				
				<table width="564">
			   <tr>
			   <td width="32"></td>
			    <td width="520" align="left"><textarea name="encu[0][comentarios]" cols="100" rows="4" class="Estilo25" id="TO-S" onBlur="this.value=this.value.toUpperCase();"></textarea>
				</tr>
				</table>
			    <br />
			
			  <br />
				<hr align="left" width="100%" size="1" noshade="noshade" />
				<br />
			 	<br />
			 <br />
			  <table width="100%">
			   <tr>
			   <td width="28%" align="rigth" valign="top" class="Estilo31"></td>
					<td width="38%" align="center" valign="top" class="Estilo31"><%f_botonera.dibujaboton("guardar4")%></td>
					<td width="34%" align="left" valign="top" class="Estilo31">&nbsp;</td>
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
