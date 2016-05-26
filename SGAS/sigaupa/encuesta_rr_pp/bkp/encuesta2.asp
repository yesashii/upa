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
'LINEA			:33 - 49 - 73
'*******************************************************************
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
f_botonera.Carga_Parametros "encuesta_rr_pp.xml", "botonera"

set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "encuesta_rr_pp.xml", "encabezado"
f_encabezado.Inicializar conexion

q_pers_nrut=negocio.obtenerUsuario

consulta = " select nombres ,apellidos from titulados_egresados_rrpp where pers_nrut="&q_pers_nrut&"" 

'response.Write("<pre>"&consulta&"</pre>")
'response.End()

f_encabezado.Consultar consulta
f_encabezado.Siguiente

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
	if (valor =='11')
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

function valida_5(valor)
{
//alert("valor "+valor);
	if (valor =='9')
	{
		
		document.edicion.elements["encu[0][preg_5_otro]"].disabled=false;	
		
	}
	else
	{
			
		document.edicion.elements["encu[0][preg_5_otro]"].disabled=true;
	}

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
var preg_1 
var preg_2
var preg_4
var preg_5
var preg_6
var preg_7
var preg_8
var sexo



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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][sexo_ccod]"))
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
   alert("Debe Selecionar un Sexo.");
   
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
  divisor=5;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_1]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_1=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 2.");
   
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
   alert("Debes selecionar una opcion en la pregunta 3.");
   
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
  divisor=11;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio")&& (elemento.name=="encu[0][preg_4]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_4=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 4.");
   preg_4=0
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
  divisor=9;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_5]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_5=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 5.");
   
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
  divisor=10;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_6]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_6=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 6.");
   
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
  divisor=5;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  //alert(cantidad);
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") &&  (elemento.name=="encu[0][preg_7]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_7=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 7.");
   
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
  divisor=8;//cantidad de alternativas de respuesta por pregunta
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
   alert("Debes selecionar una opcion en la pregunta 8.");
   
  }
}


 


if ((preg_1==1) && (preg_2==1) && (preg_4=1) && (preg_5=1)&& (preg_6=1) && (preg_7=1) && (preg_8=1) && (sexo=1))
{
 	return true;
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
				<p class="Estilo31">La Carrera de Relaciones Públicas de la Universidad del Pacífico está desarrollando una investigación para evaluar y diagnosticar  la realidad de empleabilidad e inserción laboral de sus ex –alumnos/as.</p>

<p class="Estilo31">Su aporte, al responder este cuestionario, será muy valioso para nuestra institución y carrera, nos permitirá mejorar en los aspectos deficitarios y fortalecer en aquellos mejor evaluados. La encuesta está diseñada para que solo a través del RUT del egresado/a pueda ser contestada y enviada a una base de datos para su procesamiento.</p>

<p class="Estilo31">Así mismo agradecemos su sincera opinión y le invitamos a evaluar a través de su experiencia profesional los aspectos más relevantes del proceso de empleabilidad de los egresados/as de Relaciones Públicas de la Universidad.</p>

			    <table width="90%" border="0" bgcolor="#FFFFFF">
				  <tr>
					<td class="Estilo31" width="19%">Nombres</td>
					<td class="Estilo31" width="2%">:</td>
					<td class="Estilo31" align="left"><strong><%f_encabezado.DibujaCampo("nombres")%></strong></td>
				  </tr>
				  <tr>
					<td class="Estilo31" width="19%">Apellidos</td>
					<td class="Estilo31" width="2%">:</td>
					<td class="Estilo31" align="left"><strong><%f_encabezado.DibujaCampo("apellidos")%></strong></td>
				  </tr>
				 
				  <% if contestada <> "S" then %>
				  <tr>
					<td class="Estilo31" width="19%">Carrera</td>
					<td class="Estilo31" width="2%">:</td>
					<td class="Estilo31" align="left">Relaciones P&uacute;blicas </td>
				  </tr>
				  <tr>
				  
					<td class="Estilo31" width="19%">Edad</td>
					<td class="Estilo31" width="2%">:</td>
					<td class="Estilo31" align="left"><%f_encuesta.DibujaCampo("edad")%></td>
				  </tr>
				    <tr>
				  
					<td class="Estilo31" width="19%" colspan="3"><p class="Estilo31">&nbsp;</p></td>
					
				  </tr>
				  <tr>
				  
					<td class="Estilo31"  colspan="3"><p class="Estilo31">+ Período en el que estudió la carrera:</p></td>
					
				  </tr>
					  <tr>
				
					<td class="Estilo31" width="19%"><p class="Estilo31">Año Inicio</p></td>
					<td class="Estilo31" width="2%">:</td>
					<td class="Estilo31" width="79%"><%f_encuesta.dibujaCampo("fecha_ini")%></td>
				</tr>
				<tr>
					<td class="Estilo31" width="19%"><p class="Estilo31">Año Fin</p></td>
					<td class="Estilo31" width="2%">:</td>
					<td class="Estilo31" width="79%"><%f_encuesta.dibujaCampo("fecha_fin")%>
					  <hr align="left" width="100%" size="1" noshade="noshade" /></td>
				</tr>
				  <%else%>
				 
				  <%end if%>
			  </table>
			 <% if contestada <> "S" then %>
			 
			   <br />
			     <br />
				 
			  <p class="Estilo31"><strong><em> 1) </em></strong>Sexo</p>
			 
				<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr align="center">
					<!--<td width="79" bgcolor="#ffffff"><p class="Estilo31"><strong><em> 1) </em></strong>Sexo</p></td>-->
					<td width="644" align="left" class="Estilo31"><%f_encuesta.DibujaCampo("sexo_ccod")%></td>
				  </tr>
			  </table> 
			  
			  <br/>
			  <hr align="left" width="100%" size="1" noshade="noshade" />			  
			  <p class="Estilo31"><strong><em> 2) </em></strong>Desde que  comenz&oacute; a buscar trabajo, luego de egresar, &iquest;cu&aacute;nto tiempo se demor&oacute; en  encontrar su primer trabajo?</p>
			  
				<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("preg_1")%></td>
				  </tr>
				</table>  
				
				<br/>
				<hr align="left" width="100%" size="1" noshade="noshade" />
				<p class="Estilo31"><strong><em> 3) </em></strong>Actualmente,  &iquest;est&aacute; usted trabajando? (considere por trabajo cualquier actividad remunerada  de por lo menos media jornada de dedicaci&oacute;n) </p>
				
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
				  <tr align="center">
				  <td width="155"></td>
					<td width="25" valign="top" bgcolor="#CCCCCC"class="Estilo31"><p align="center">
						<input name="encu[0][preg_2]" type="radio" value="S"  />
					</p></td>
					<td width="28" valign="top"  class="Estilo31" >Si</td>
					<td width="147"></td>
					<td width="25" valign="top" bgcolor="#CCCCCC" class="Estilo31"><p align="center">
						<input name="encu[0][preg_2]" type="radio" value="N"  />
					</p></td>
					
					<td width="41" valign="top" class="Estilo31">No</td>
					<td width="22"></td>
					<td width="280"></td>
				  </tr>
			  </table> 
				
				<!--
				<hr align="left" width="100%" size="1" noshade="noshade" />
				<p class="Estilo31"><strong><em> 3) </em></strong>Si está trabajando actualmente, señale el nombre de la Empresa</p>
				
				<table width="100%" border="0" cellpadding="0" cellspacing="0" >
					<tr>
						<td width="100%" align="left" valign="top" class="Estilo31" ><%
						'f_encuesta.dibujaCampo("preg_3")
						%>
						</td>
					</tr>
				</table>
				-->
	
			  <hr align="left" width="100%" size="1" noshade="noshade" />
			  <br />
			  <p class="Estilo31"><strong><em> 4) </em></strong>La  Empresa u Organismo donde usted trabaja se encuentra en el &aacute;rea de:</p>
				<br />
				<table width="100%" border="1" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
                <tr>
                  <td width="22%" height="50" align="center" valign="center" bgcolor="#FFFFFF" class="Estilo31">Producciones y Eventos</td>
                  <td width="3%" align="center" valign="center" bgcolor="#CCCCCC"class="Estilo31"><font size="2" color="#000000">
                    <input type="radio" name="encu[0][preg_4]" value="1" onClick="valida_trabajo(this.value);"  /></font></td>
                  <td width="22%" align="center" valign="center" bgcolor="#FFFFFF" class="Estilo31"><p>Financieras y Bancos</p></td>
                  <td width="3%" align="left" valign="center" bgcolor="#CCCCCC"><font size="2" color="#000000">
                    <input type="radio" name="encu[0][preg_4]" value="2" onClick="valida_trabajo(this.value);"  /></font></td>
                  <td width="22%" align="center" valign="center" bgcolor="#FFFFFF"class="Estilo31"><p>Salud</p></td>
                  <td width="3%" align="left" valign="center" bgcolor="#CCCCCC"><font size="2" color="#000000">
                    <input type="radio" name="encu[0][preg_4]" value="3" onClick="valida_trabajo(this.value);"   /></font></td>
                  <td width="22%" align="center" valign="center" bgcolor="#FFFFFF" class="Estilo31"><p>Retail</p></td>
                  <td width="3%" align="left" valign="center" bgcolor="#CCCCCC"><font size="2" color="#000000">
                    <input type="radio" name="encu[0][preg_4]" value="4" onClick="valida_trabajo(this.value);"   /></font></td>
                </tr>
                <tr>
                  <td width="22%" align="center" valign="center" bgcolor="#FFFFFF"class="Estilo31"><p>Ingeniería y Construcción</p></td>
                  <td width="3%" align="center" valign="center" bgcolor="#CCCCCC"><font size="2" color="#000000">
                    <input type="radio" name="encu[0][preg_4]" value="5"onclick="valida_trabajo(this.value);"  /></font></td>
                  <td width="22%" align="center" valign="center" bgcolor="#FFFFFF"class="Estilo31"><p>Repartición del Estado</p></td>
                  <td width="3%" align="left" valign="center" bgcolor="#CCCCCC"><font size="2" color="#000000">
                    <input type="radio" name="encu[0][preg_4]" value="6"  onclick="valida_trabajo(this.value);"  /></font></td>
                  <td width="22%" align="center" valign="center" bgcolor="#FFFFFF"class="Estilo31"><p>Publicidad y Marketing</td>
                  <td width="3%" align="left" valign="center" bgcolor="#CCCCCC"><font size="2" color="#000000">
                    <input type="radio" name="encu[0][preg_4]" value="7"  onclick="valida_trabajo(this.value);" /></font></td>
                  <td width="22%" align="center" valign="center" bgcolor="#FFFFFF"class="Estilo31"><p>Educación</p></td>
                  <td width="3%" align="left" valign="center" bgcolor="#CCCCCC"><font size="2" color="#000000">
                    <input type="radio" name="encu[0][preg_4]" value="8" onClick="valida_trabajo(this.value);"   /></font></td>
                </tr>
                <tr>
                  <td width="22%" align="center" valign="center" bgcolor="#FFFFFF"class="Estilo31"><p>Servicios</p></td>
                  <td width="3%" align="center" valign="center" bgcolor="#CCCCCC"><font size="2" color="#000000">
                    <input type="radio" name="encu[0][preg_4]" value="9"onclick="valida_trabajo(this.value);"  /></font></td>
                  <td width="22%" align="center" valign="center" bgcolor="#FFFFFF"class="Estilo31"><p>Comercio</p></td>
                  <td width="3%" align="left" valign="center" bgcolor="#CCCCCC"><font size="2" color="#000000">
                    <input type="radio" name="encu[0][preg_4]" value="10"  onclick="valida_trabajo(this.value);"  /></font></td>
                  <td width="22%" align="center" valign="center" bgcolor="#FFFFFF"class="Estilo31"><p>Otro, señalar</td>
                  <td width="3%" align="left" valign="center" bgcolor="#CCCCCC"><font size="2" color="#000000">
                    <input type="radio" name="encu[0][preg_4]" value="11"  onclick="valida_trabajo(this.value);" /></font></td>
                  <td width="22%" align="center" valign="center" bgcolor="#FFFFFF"class="Estilo31"><p> </p></td>
                  <td width="3%" align="left" valign="center" bgcolor="#CCCCCC"><font size="2" color="#000000">
                    <!--<input type="radio" name="encu[0][preg_4]" value="12" onClick="valida_trabajo(this.value);"   />--></font></td>
                </tr>

              </table>
				<br />
				 <table width="100%" border="0" cellpadding="0" cellspacing="0" >
				  <tr>
				  <td width="12%" align="left" valign="top" class="Estilo31" ><p>Indicar Otro</p></td>
					<td width="88%" align="left" valign="top" class="Estilo31" ><%f_encuesta.dibujaCampo("preg_4_otro")%></td>
				  </tr>
			  </table>
			  <p class="Estilo31"><strong><em> 5) </em></strong>&iquest;Cu&aacute;l es su cargo en la Empresa que actualmente se  desempe&ntilde;a?</p>
			  <table width="100%" border="1" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
				  <tr>
				    <td width="17%" height="50" align="center" valign="center" bgcolor="#FFFFFF" class="Estilo31">Relacionador/a  P&uacute;blico/a</td>
				    <td width="3%" align="left" valign="center" bgcolor="#CCCCCC"class="Estilo31"><font size="2" color="#000000">
				      <input type="radio" name="encu[0][preg_5]"   value="1" onClick="valida_5(this.value);"></font></td>
					<td width="17%" align="center" valign="center" bgcolor="#FFFFFF" class="Estilo31"><p>Jefe/a de  Comunicaciones</p></td>
					<td width="3%" align="left" valign="center" bgcolor="#CCCCCC"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_5]"   value="2" onClick="valida_5(this.value);"></font></td>
					<td width="17%" align="center" valign="center" bgcolor="#FFFFFF"class="Estilo31"><p>Asistente  de Comunicaciones</p>					  </td>
				    <td width="3%" align="left" valign="center" bgcolor="#CCCCCC"><font size="2" color="#000000">
				      <input type="radio" name="encu[0][preg_5]" value="3" onClick="valida_5(this.value);"></font></td>
					<td width="17%" align="center" valign="center" bgcolor="#FFFFFF" class="Estilo31"><p>Gerente/a  de Comunicaciones</p></td>
					<td width="3%" align="left" valign="center" bgcolor="#CCCCCC"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_5]"  value="4" onClick="valida_5(this.value);"></font></td>
				    <td width="17%" align="center" valign="center" bgcolor="#FFFFFF"class="Estilo31"><p>Ejecutivo/a</p></td>
				    <td width="3%" align="left" valign="center" bgcolor="#CCCCCC"><font size="2" color="#000000">
				      <input type="radio" name="encu[0][preg_5]"  value="5" onClick="valida_5(this.value);"></font></td>
  			     </tr>
				  <tr>
				    <td width="17%" height="50" align="center" valign="center" bgcolor="#FFFFFF" class="Estilo31">Product Manager</td>
				    <td width="3%" align="left" valign="center" bgcolor="#CCCCCC"class="Estilo31"><font size="2" color="#000000">
				      <input type="radio" name="encu[0][preg_5]"   value="6" onClick="valida_5(this.value);"></font></td>
					<td width="17%" align="center" valign="center" bgcolor="#FFFFFF" class="Estilo31"><p>Asistente de Marketing</p></td>
					<td width="3%" align="left" valign="center" bgcolor="#CCCCCC"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_5]"   value="7" onClick="valida_5(this.value);"></font></td>
					<td width="17%" align="center" valign="center" bgcolor="#FFFFFF"class="Estilo31"><p>Coordinación Administrativa</p>					  </td>
				    <td width="3%" align="left" valign="center" bgcolor="#CCCCCC"><font size="2" color="#000000">
				      <input type="radio" name="encu[0][preg_5]" value="8" onClick="valida_5(this.value);"></font></td>
					<td width="17%" align="center" valign="center" bgcolor="#FFFFFF" class="Estilo31"><p>Otro, señalar</p></td>
					<td width="3%" align="left" valign="center" bgcolor="#CCCCCC"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_5]"  value="9" onClick="valida_5(this.value);"></font></td>
				    <td width="17%" align="center" valign="center" bgcolor="#FFFFFF"class="Estilo31"><p> </p></td>
				    <td width="3%" align="left" valign="center" bgcolor="#CCCCCC"><font size="2" color="#000000">
				      <!--<input type="radio" name="encu[0][preg_5]"  value="10" onClick="valida_5(this.value);">--></font></td>
  			     </tr>
				</table>
				<br />
				 <table width="100%" border="0" cellpadding="0" cellspacing="0" >
				  <tr>
				  <td width="12%" align="left" valign="top" class="Estilo31" ><p>Indicar Otro</p></td>
					<td width="88%" align="left" valign="top" class="Estilo31" ><%f_encuesta.dibujaCampo("preg_5_otro")%></td>
				  </tr>
			  </table>
			  <br />
				<hr align="left" width="100%" size="1" noshade="noshade" />
				<p class="Estilo31"><strong><em> 6) </em></strong>Se&ntilde;ale  los a&ntilde;os de antig&uuml;edad en su actual trabajo</p>
				<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
					<td width="100%" align="center" valign="top" class="Estilo31"><%f_encuesta.dibujaCampo("preg_6")%></td>
				  </tr>
				</table>  
				
				<br />
				<hr align="left" width="100%" size="1" noshade="noshade" />
				<p class="Estilo31"><strong><em> 7) </em></strong>Si está trabajando actualmente, señale la renta promedio (líquida) mensual que está obteniendo, de acuerdo a los rangos indicados: </p>
				<table width="99%" border="1" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" align="center">
				  <tr>
					
					<td width="27%" align="center" valign="top" class="Estilo31">Menos de $200.000 </td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#CCCCCC"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_7]" value="1"/></font></td>
					<td width="27%" align="center" valign="top" class="Estilo31">Entre  $200.001 Y $500.000 </td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#CCCCCC"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_7]" value="2"/></font></td>
					<td width="27%" align="center" valign="top" class="Estilo31">Entre $500.001  y 1.000.000 </td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#CCCCCC"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_7]" value="3"/></font></td>
				  </tr>
				   <tr>
					<td width="27%" align="center" valign="top" class="Estilo31">Entre $1.000.001  y $1.500.000 </td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#CCCCCC"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_7]" value="4"/></font></td>
					<td width="27%" align="center" valign="top" class="Estilo31">M&aacute;s de  1.500.001 </td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#CCCCCC"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_7]" value="5"/></font></td>
					<td width="27%" align="center" valign="top" class="Estilo31"> </td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#CCCCCC"><font size="2" color="#000000">
					  <!--<input type="radio" name="encu[0][preg_7]" value="6"/>--></font></td>
				  </tr>
				</table> 
				<br />
				<hr align="left" width="100%" size="1" noshade="noshade" />
				<p class="Estilo31"><strong><em> 8) </em></strong>Señale la forma de acceso al trabajo actual:</p>
			    <table width="99%" border="1" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" align="center">
				  <tr>
					
					<td width="22%" align="center" valign="top" class="Estilo31">Contactos personales / familiares </td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#CCCCCC"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_8]" value="1" onClick="valida_8(this.value);"/></font></td>
					<td width="22%" align="center" valign="top" class="Estilo31">Autoempleo</td>
					<td width="4%" align="center" valign="top" class="Estilo31"bgcolor="#CCCCCC"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_8]" value="2" onClick="valida_8(this.value);" />
					</font></td>
					<td width="22%" align="center" valign="top" class="Estilo31">Pr&aacute;cticas  de estudios</td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#CCCCCC"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_8]" value="3" onClick="valida_8(this.value);"/>
					</font></td>
						<td width="22%" align="center" valign="top" class="Estilo31">Anuncios  (prensa, internet, etc)</td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#CCCCCC"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_8]" value="4" onClick="valida_8(this.value);"/></font></td>
					</tr>
				 			  
				    <tr>
					<td width="22%" align="center" valign="top" class="Estilo31">Concursos p&uacute;blicos</td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#CCCCCC"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_8]" value="5" onClick="valida_8(this.value);"/></font></td>
					
					<td width="22%" align="center" valign="top" class="Estilo31">Iniciativa  personal (curriculum, empresas de selecci&oacute;n)</td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#CCCCCC"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_8]" value="6" onClick="valida_8(this.value);"/></font></td>
						
					<td width="22%" align="center" valign="top" class="Estilo31">Bolsa de  trabajo </td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#CCCCCC"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_8]" value="7" onClick="valida_8(this.value);"/></font></td>
					
						<td width="22%" align="center" valign="top" class="Estilo31"><p>Otro, se&ntilde;alar</p></td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#CCCCCC"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_8]" value="8" onClick="valida_8(this.value);"/></font></td>
				  </tr>
				    
				</table>
				<br />
				 <table width="100%" border="0" cellpadding="0" cellspacing="0" >
				  <tr>
				  <td width="12%" align="left" valign="top" class="Estilo31" ><p>Indicar Otro</p></td>
					<td width="88%" align="left" valign="top" class="Estilo31" ><%f_encuesta.dibujaCampo("preg_8_otro")%></td>
				  </tr>
			  </table>
			 	<br />
			 <br />
			  <table width="100%">
			   <tr>
			   <td width="79%" align="rigth" valign="top" class="Estilo31"></td>
					<td width="79%" align="center" valign="top" class="Estilo31"><%f_botonera.dibujaboton("guardar1")%></td>
					<td width="79%" align="left" valign="top" class="Estilo31">&nbsp;</td>
				  </tr>
			  </table>
				
				<br />
				<br />
				<br />
				<hr size="1" noshade="noshade" />
			  <%end if%>
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
