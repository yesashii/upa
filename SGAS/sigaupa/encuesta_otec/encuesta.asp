<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/revisa_session_encuesta_otec.asp"-->

<%

'---------------------------------------------------------------------------------------------------
'set pagina = new CPagina
'pagina.Titulo = "Encuesta Así soy yo"
'---------------------------------------------------------------------------------------------------
seot_ncorr=request.QueryString("seot_ncorr")
pers_ncorr=request.QueryString("pers_ncorr")
dcurr_ncorr=request.QueryString("dcurr_ncorr")
'secc_ccod=request.Form("secc")
set conexion = new CConexion
conexion.Inicializar "upacifico"
'
set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "encuesta_docente_rr_hh.xml", "botonera"


rut_alumn=negocio.ObtenerUsuario
pers_ncorr_alums=conexion.ConsultaUno("select pers_ncorr from personas where pers_nrut="&rut_alumn&"")
programa=conexion.ConsultaUno("select dcur_tdesc from diplomados_cursos where dcur_ncorr="&dcurr_ncorr&"")
sel_modulo="select mote_tdesc from secciones_otec a,mallas_otec  b ,modulos_otec c"& vbCrLf &_
			"where a.maot_ncorr=b.maot_ncorr"& vbCrLf &_
			"and b.mote_ccod=c.mote_ccod"& vbCrLf &_
			"and a.seot_ncorr="&seot_ncorr&""
modulo=conexion.ConsultaUno(sel_modulo)
relator=conexion.ConsultaUno("select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno from personas where pers_ncorr="&pers_ncorr&"")
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

function vovler()
{

valor=<%=dcurr_ncorr%>
window.location=("modulos.asp?dcur_ncorr="+valor)
}



 


function ValidarMarcados()
{
var I_preg_1
var I_preg_2
var I_preg_3
var I_preg_4
var I_preg_5
var I_preg_6
var I_preg_7
var I_preg_8
var I_preg_9
var I_preg_10
var I_preg_11
var I_preg_12
var I_preg_13


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
  divisor=4;//cantidad de alternativas de respuesta por pregunta
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
   aviso=aviso+"1.\r";
   
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
   aviso=aviso+"2.\r";
   
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
   aviso=aviso+"3.\r";
   
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
 aviso=aviso+"4.\r";
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
  divisor=4;//cantidad de alternativas de respuesta por pregunta
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
   aviso=aviso+"5.\r";
   
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
  aviso=aviso+"6.\r";
   
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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][I_preg_7]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 I_preg_7=1
  }
  else
  {
  aviso=aviso+"7.\r";
   
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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][I_preg_8]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 I_preg_8=1
  }
  else
  {
  aviso=aviso+"8.\r";
   
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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][I_preg_9]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 I_preg_9=1
  }
  else
  {
  aviso=aviso+"9.\r";
   
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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][I_preg_10]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 I_preg_10=1
  }
  else
  {
  aviso=aviso+"10.\r";
   
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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][I_preg_11]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 I_preg_11=1
  }
  else
  {
  aviso=aviso+"11.\r";
   
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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][I_preg_12]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 I_preg_12=1
  }
  else
  {
  aviso=aviso+"12 .\r";
   
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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][I_preg_13]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 I_preg_13=1
  }
  else
  {
  aviso=aviso+"13 \r";
   
  }
}
//-------------------------


//-------------------------

//alert(I_preg_1+'\r'+I_preg_2+'\r'+I_preg_3+'\r'+I_preg_4+'\r'+I_preg_5+'\r'+I_preg_6+'\r'+II_preg_1+'\r'+II_preg_2+'\r'+II_preg_3+'\r'+II_preg_4+'\r'+II_preg_5+'\r'+II_preg_6+'\r'+II_preg_7+'\r'+II_preg_8+'\r'+III_preg_1+'\r'+III_preg_2+'\r'+III_preg_3+'\r'+III_preg_4+'\r'+IV_preg_1+'\r'+IV_preg_2+'\r'+IV_preg_3+'\r'+IV_preg_4+'\r'+V_preg_1+'\r'+V_preg_2+'\r'+V_preg_3);
if ((I_preg_1==1) && (I_preg_2==1) && (I_preg_3==1) && (I_preg_4==1)&& (I_preg_5==1) && (I_preg_6==1)&& (I_preg_7==1)&& (I_preg_8==1)&& (I_preg_9==1)&& (I_preg_10==1)     && (I_preg_11==1) && (I_preg_12==1) && (I_preg_13==1))
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
		  
			<td width="723" align="left"><table width="654">
					<tr>
						<td align="center">
							<p class="Estilo35"><strong>CUESTIONARIO DE OPINIÓN DOCENTE</strong></p>
						</td>
					</tr>
				</table>
					<br />
					<table width="90%" border="0" bgcolor="#FFFFFF">
                  <tr>
                    <td width="12%">Programa</td>
                    <td width="2%">:</td>
                    <td width="86%" align="left"><%=programa%>
                    </td>
                  </tr>
				  <tr>
                    <td width="12%">M&oacute;dulo</td>
                    <td width="2%">:</td>
                    <td align="left"><%=modulo%> 
                    </td>
                  </tr>
                  <tr>
                    <td width="12%">Relator</td>
                    <td width="2%">:</td>
                    <td align="left"><%=relator%></td>
                  </tr>
                 
			      </table>
				<br/>
			   <table width="90%" border="0" bgcolor="#FFFFFF">
                  <tr>
                    <td class="Estilo31">INSTRUCCIONES:</td>
                   </tr>
                  <tr>
                    <td class="Estilo31"><p>Este  cuestionario tiene el prop&oacute;sito de conocer su apreciaci&oacute;n respecto del curso  realizado. S<strong>u opini&oacute;n contribuir&aacute; a  mejorar la calidad del proceso educativo de nuestra Universidad. </strong>Por esta  raz&oacute;n, es importante que lo responda <strong>cuidadosamente,&nbsp; </strong>con <strong>objetividad  y seriedad</strong>.&nbsp; Su respuesta ser&aacute;  totalmente an&oacute;nima.</p></td>
                   </tr>
				   </table>
				  <br />
				  <table>
				  <tr><td class="Estilo31">I. Señale su nivel de acuerdo o desacuerdo con las siguientes afirmaciones respecto de la DOCENCIA</p></td></tr>
				  </table>
				  <table border="1">
				  	<tr><td class="Estilo31">1. Totalmente en desacuerdo</p></td></tr>
					<tr><td class="Estilo31">2. En desacuerdo</p></td></tr>
					<tr><td class="Estilo31">3. De acuerdo</p></td></tr>
					<tr><td class="Estilo31">4. Totalmente de acuerdo</p></td></tr>
				  </table>
				   <br />
					<hr align="left" width="100%" size="1" noshade="noshade" />
				<table width="100%" border="1" cellpadding="0" cellspacing="0">
				  <tr align="center">
				  		<td width="587" align="left"><strong>OPINI&Oacute;N</strong></td>
				  		
						<td width="31" valign="top" bgcolor="#CCCCCC"><p align="center">1</p></td>
						<td width="31" valign="top" ><p align="center" >2</p></td>
						<td width="31" valign="top" bgcolor="#CCCCCC"><p align="center">3</p></td>
						<td width="31" valign="top"  ><p align="center">4</p></td>
					  </tr>
				  <tr align="justify">
				  		
				  		<td width="587" align="justify">1. El profesor dio a conocer los objetivos del  programa.</td>
						<td width="31" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_1]" type="radio" value="1"/></p></td>
						<td width="31" valign="middle"  ><p align="center">
						<input name="encu[0][I_preg_1]" type="radio" value="2"/></p></td>
						<td width="31" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_1]" type="radio" value="3"/></p></td>
						<td width="31" valign="middle" ><p align="center">
							<input name="encu[0][I_preg_1]" type="radio" value="4"/>
						</p></td>
					  </tr>
				  <tr align="justify">
				  		<td width="587" align="justify">2.  El profesor prepara, organiza y estructura bien las  clases. </td>
				  		<td width="31" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_2]" type="radio" value="1"/></p></td>
						<td width="31" valign="middle"   ><p align="center">
						<input name="encu[0][I_preg_2]" type="radio" value="2"/></p></td>
						<td width="31" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_2]" type="radio" value="3"/></p></td>
						<td width="31" valign="middle" ><p align="center">
							<input name="encu[0][I_preg_2]" type="radio" value="4"/>
						</p></td>
					  </tr>
				  <tr align="justify">
				  		<td width="587" align="justify">3. Los contenidos fueron expresados de modo  comprensible. </td>
				  		
						<td width="31" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_3]" type="radio" value="1"/></p></td>
						<td width="31" valign="middle"   ><p align="center">
						<input name="encu[0][I_preg_3]" type="radio" value="2"/></p></td>
						<td width="31" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_3]" type="radio" value="3"/></p></td>
						<td width="31" valign="middle"  ><p align="center">
							<input name="encu[0][I_preg_3]" type="radio" value="4"/>
						</p></td>
					  </tr>
				  <tr align="justify">
				  		<td width="587" align="justify">4.&nbsp;&nbsp;Los textos y material bibliogr&aacute;fico fueron  adecuados para los aprendizajes. </td>
				  		
						<td width="31" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_4]" type="radio" value="1"/></p></td>
						<td width="31" valign="middle"   ><p align="center">
						<input name="encu[0][I_preg_4]" type="radio" value="2"/></p></td>
						<td width="31" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_4]" type="radio" value="3"/></p></td>
						<td width="31" valign="middle"  ><p align="center">
							<input name="encu[0][I_preg_4]" type="radio" value="4"/>
						</p></td>
					  </tr>
				  <tr align="justify">
				  		<td width="587" align="justify">5.&nbsp;Planifica  y solicita los materiales necesarios para las clases.</td>
				  		
						<td width="31" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_5]" type="radio" value="1"/></p></td>
						<td width="31" valign="middle"  ><p align="center">
						<input name="encu[0][I_preg_5]" type="radio" value="2"/></p></td>
						<td width="31" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_5]" type="radio" value="3"/></p></td>
						<td width="31" valign="middle" ><p align="center">
							<input name="encu[0][I_preg_5]" type="radio" value="4"/>
						</p></td>
					  </tr>
				  <tr align="justify">
				  		<td width="587" height="22" align="justify">6. El profesor aplica diversas estrategias de  ense&ntilde;anza para facilitar el aprendizaje.  </td>
				  		
						<td width="31" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_6]" type="radio" value="1"/></p></td>
						<td width="31" valign="middle"><p align="center">
						<input name="encu[0][I_preg_6]" type="radio" value="2"/></p></td>
						<td width="31"valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_6]" type="radio" value="3"/></p></td>
						<td width="31" valign="middle"><p align="center">
							<input name="encu[0][I_preg_6]" type="radio" value="4"/>
						</p></td>
					  </tr>
				 <tr align="justify">
				  		<td width="587" height="33" align="justify">7. El profesor se muestra accesible y est&aacute; dispuesto a  atender las consultas y sugerencias de los alumnos.</td>
				  		
						<td width="31" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_7]" type="radio" value="1"/></p></td>
						<td width="31" valign="middle"><p align="center">
						<input name="encu[0][I_preg_7]" type="radio" value="2"/></p></td>
						<td width="31"valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_7]" type="radio" value="3"/></p></td>
						<td width="31" valign="middle"><p align="center">
							<input name="encu[0][I_preg_7]" type="radio" value="4"/>
						</p></td>
					  </tr>
				  <tr align="justify">
				  		<td width="587" align="justify">8. El profesor cumple efectivamente con el Plan de  Evaluaci&oacute;n se&ntilde;alado.</td>
				  		
						<td width="31" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_8]" type="radio" value="1"/></p></td>
						<td width="31" valign="middle"><p align="center">
						<input name="encu[0][I_preg_8]" type="radio" value="2"/></p></td>
						<td width="31"valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_8]" type="radio" value="3"/></p></td>
						<td width="31" valign="middle"><p align="center">
							<input name="encu[0][I_preg_8]" type="radio" value="4"/>
						</p></td>
					  </tr>
				  <tr align="justify">
				  		<td width="587"  align="justify">9. El profesor cumple adecuadamente con el Programa</td>
				  		
						<td width="31" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_9]" type="radio" value="1"/></p></td>
						<td width="31" valign="middle"><p align="center">
						<input name="encu[0][I_preg_9]" type="radio" value="2"/></p></td>
						<td width="31"valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_9]" type="radio" value="3"/></p></td>
						<td width="31" valign="middle"><p align="center">
							<input name="encu[0][I_preg_9]" type="radio" value="4"/>
						</p></td>
					  </tr>
				  <tr align="justify">
				  		<td width="587"  align="justify">10. El profesor entrega oportunamente (dentro de 15  d&iacute;as) los resultados de la evaluaci&oacute;n. </td>
				  		
						<td width="31" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_10]" type="radio" value="1"/></p></td>
						<td width="31" valign="middle"><p align="center">
						<input name="encu[0][I_preg_10]" type="radio" value="2"/></p></td>
						<td width="31"valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_10]" type="radio" value="3"/></p></td>
						<td width="31" valign="middle"><p align="center">
							<input name="encu[0][I_preg_10]" type="radio" value="4"/>
						</p></td>
					  </tr>
				    <tr align="justify">
				  		<td width="587"  align="justify">11. El profesor realiza retroalimentaci&oacute;n de los  aprendizajes. </td>
				  		
						<td width="31" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_11]" type="radio" value="1"/></p></td>
						<td width="31" valign="middle"><p align="center">
						<input name="encu[0][I_preg_11]" type="radio" value="2"/></p></td>
						<td width="31"valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_11]" type="radio" value="3"/></p></td>
						<td width="31" valign="middle"><p align="center">
							<input name="encu[0][I_preg_11]" type="radio" value="4"/>
						</p></td>
					  </tr>
				    <tr align="justify">
				  		<td width="587"  align="justify">12. El profesor&nbsp;  promueve un ambiente de aprendizaje acorde a las necesidades de los  estudiantes. </td>
				  		
						<td width="31" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_12]" type="radio" value="1"/></p></td>
						<td width="31" valign="middle"><p align="center">
						<input name="encu[0][I_preg_12]" type="radio" value="2"/></p></td>
						<td width="31"valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_12]" type="radio" value="3"/></p></td>
						<td width="31" valign="middle"><p align="center">
							<input name="encu[0][I_preg_12]" type="radio" value="4"/>
						</p></td>
					  </tr>
				    <tr align="justify">
				  		<td width="587"  align="justify">13. El profesor cumple con el horario y aspectos  formales . </td>
				  		
						<td width="31" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_13]" type="radio" value="1"/></p></td>
						<td width="31" valign="middle"><p align="center">
						<input name="encu[0][I_preg_13]" type="radio" value="2"/></p></td>
						<td width="31"valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_13]" type="radio" value="3"/></p></td>
						<td width="31" valign="middle"><p align="center">
							<input name="encu[0][I_preg_13]" type="radio" value="4"/>
						</p></td>
					  </tr>
			  </table> 
			   
				<hr align="left" width="100%" size="1" noshade="noshade" />
				<br />
			   <table width="100%">
			   <tr>
			    <td width="100%"><p>Escriba sus comentarios,  observaciones y/o sugerencias:</p>
			      </td>
			   </tr>
			   <tr>
			      <td width="95%" align="center"><textarea name="encu[0][sug]" cols="145" rows="4" class="Estilo25" id="TO-N"></textarea>
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
					
				
					<td width="10%" align="center" valign="top" class="Estilo31">
					 
						<a href="javascript:vovler();">
												
						<img src="Images/vovler1.png" border="0" width="55" height="55" alt="¿Cómo funciona?">					</td>
					
					<td width="11%" align="center" valign="top" class="Estilo31">
					 
						<a href="javascript:_Guardar(this, document.forms['edicion'], 'encuesta_proc.asp','', 'ValidarMarcados()', 'Recuerde que una vez guardada la encuesta usted no podra hacer cambios', 'FALSE');">
												
						<img src="Images/guardar1.png" border="0" width="55" height="55" alt="¿Cómo funciona?"></td>
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
