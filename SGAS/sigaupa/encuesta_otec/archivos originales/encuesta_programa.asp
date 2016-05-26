<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/revisa_session_encuesta_otec.asp"-->

<%

'---------------------------------------------------------------------------------------------------
'set pagina = new CPagina
'pagina.Titulo = "Encuesta Así soy yo"
'---------------------------------------------------------------------------------------------------
dcurr_ncorr=request.QueryString("dcur_ncorr")
'secc_ccod=request.Form("secc")
set conexion = new CConexion
conexion.Inicializar "upacifico"
'
set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "encuesta_docente_rr_hh.xml", "botonera"

set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "encuesta_docente_rr_hh.xml", "encabezado"
f_encabezado.Inicializar conexion

'pers_ncorr=conexion.ConsultaUno("select protic.obtener_pers_ncorr("&q_pers_nrut&")")
consulta ="select dcur_tdesc from diplomados_cursos a where a.dcur_ncorr="&dcurr_ncorr&""

' "select dcur_tdesc,mote_tdesc,d.seot_ncorr,pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre,g.pers_ncorr"& vbCrLf &_
'"from diplomados_cursos a,"& vbCrLf &_
'"mallas_otec b,"& vbCrLf &_
'"modulos_otec c,"& vbCrLf &_
'"secciones_otec d,"& vbCrLf &_
'"bloques_horarios_otec e,"& vbCrLf &_
'"bloques_relatores_otec f,"& vbCrLf &_
'"personas g"& vbCrLf &_
'"where a.dcur_ncorr=b.dcur_ncorr"& vbCrLf &_ 
'"and b.mote_ccod=c.mote_ccod"& vbCrLf &_
'"and a.dcur_ncorr="&dcurr_ncorr&""& vbCrLf &_
'"and g.pers_ncorr="&pers_ncorr&""& vbCrLf &_
'"and d.seot_ncorr="&seot_ncorr&""& vbCrLf &_
'"and b.maot_ncorr=d.maot_ncorr"& vbCrLf &_
'"and d.seot_ncorr=e.seot_ncorr"& vbCrLf &_
'"and e.bhot_ccod=f.bhot_ccod"& vbCrLf &_
'"and f.pers_ncorr=g.pers_ncorr"& vbCrLf &_
'"group by mote_tdesc,d.seot_ncorr,pers_tape_paterno,pers_tape_materno,pers_tnombre,g.pers_ncorr,dcur_tdesc"

'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_encabezado.Consultar consulta
f_encabezado.Siguiente

rut_alumn=negocio.ObtenerUsuario
pers_ncorr_alums=conexion.ConsultaUno("select pers_ncorr from personas where pers_nrut="&rut_alumn&"")


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
window.location=("programas.asp")
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
var II_preg_1
var II_preg_2
var II_preg_3
var II_preg_4
var II_preg_5
var II_preg_6
var II_preg_7
var III_preg
var IV_preg
var V_preg
var VI_preg


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
  aviso=aviso+"6 de la parte I.\r";
   
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
  aviso=aviso+"7 de la parte I.\r";
   
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
  divisor=4;//cantidad de alternativas de respuesta por pregunta
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
  divisor=4;//cantidad de alternativas de respuesta por pregunta
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
  divisor=4;//cantidad de alternativas de respuesta por pregunta
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
  aviso=aviso+"4 de la parte II.\r";
   
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
  divisor=4;//cantidad de alternativas de respuesta por pregunta
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
  divisor=4;//cantidad de alternativas de respuesta por pregunta
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
  divisor=3;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.edicion.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.edicion.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][III_preg]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 III_preg=1
  }
  else
  {
  aviso=aviso+"de la parte III \r";
   
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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][IV_preg]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 IV_preg=1
  }
  else
  {
  aviso=aviso+"de la parte IV \r";
   
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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][V_preg]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 V_preg=1
  }
  else
  {
  aviso=aviso+"de la parte V \r";
   
  }
}

//-------------------------

//alert(I_preg_1+'\r'+I_preg_2+'\r'+I_preg_3+'\r'+I_preg_4+'\r'+I_preg_5+'\r'+I_preg_6+'\r'+II_preg_1+'\r'+II_preg_2+'\r'+II_preg_3+'\r'+II_preg_4+'\r'+II_preg_5+'\r'+II_preg_6+'\r'+II_preg_7+'\r'+II_preg_8+'\r'+III_preg_1+'\r'+III_preg_2+'\r'+III_preg_3+'\r'+III_preg_4+'\r'+IV_preg_1+'\r'+IV_preg_2+'\r'+IV_preg_3+'\r'+IV_preg_4+'\r'+V_preg_1+'\r'+V_preg_2+'\r'+V_preg_3);
if ((I_preg_1==1) && (I_preg_2==1) && (I_preg_3==1) && (I_preg_4==1)&& (I_preg_5==1) && (I_preg_6==1)&& (I_preg_7==1)&& (II_preg_1==1)&& (II_preg_2==1)&& (II_preg_3==1)&& (II_preg_4==1)&& (II_preg_5==1)&& (II_preg_6==1)&& (II_preg_7==1)&& (III_preg==1)&& (IV_preg==1)&& (V_preg==1))
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
							<p align="center"><strong>Cuestionario de  Opini&oacute;n del Programa e Infraestructura</strong><strong> </strong></p>
							<p class="Estilo35">&nbsp;</p>
						</td>
					</tr>
				</table>
					<br />
					<table width="90%" border="0" bgcolor="#FFFFFF">
                  <tr class="Estilo27">
                    <td width="12%">Programa</td>
                    <td width="2%">:</td>
                    <td width="86%" align="left"><%f_encabezado.DibujaCampo("dcur_tdesc")%>
                    </td>
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
				  <table width="665">
				  <tr><td class="Estilo31"> 
				      <strong>I.C&oacute;mo calificar&iacute;a usted los siguientes  elementos en relaci&oacute;n a los CONTENIDOS del Programa</strong></td>
				  </tr>
				  </table>
				  <br />
				  <table border="1">
				  	<tr><td class="Estilo31">1.DEFICIENTE</p></td></tr>
					<tr><td class="Estilo31">2.REGULAR</p></td></tr>
					<tr><td class="Estilo31">3.BUENO</p></td></tr>
					<tr><td class="Estilo31">4.MUY BUENO</p></td></tr>
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
				  		
				  		<td width="587" align="justify">1. Este curso ha aumentado mi inter&eacute;s por la materia.</td>
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
				  		<td width="587" align="justify">2.  Este curso ha sido una herramienta de gran utilidad  para mi desarrollo profesional . </td>
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
				  		<td width="587" align="justify">3.Se cumplieron en gran medida mis expectativas  respecto al programa y la universidad. </td>
				  		
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
				  		<td width="587" align="justify">4.&nbsp;El curso ha sido muy valioso para mi desempe&ntilde;o  laboral. </td>
				  		
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
				  		<td width="587" align="justify">5.&nbsp;Los objetivos definidos se cumplieron .</td>
				  		
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
				  		<td width="587" height="22" align="justify">6. Los contenidos son actuales y adecuados al programa .  </td>
				  		
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
				  		<td width="587" align="justify">7. La Bibliograf&iacute;a utilizada es actualizada.</td>
				  		
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
				  		
			  </table> 
			   
				<hr align="left" width="100%" size="1" noshade="noshade" />
				<br />
				
				  <br />
				  <table width="665">
				  <tr><td class="Estilo31"><strong>II. En  relaci&oacute;n a aspectos de INFRAESTRUCTURA, marque la alternativa que corresponda</strong></td>
				  </tr>
				  </table>
				  <br />
				  <table width="100%" border="1" cellpadding="0" cellspacing="0">
				  <tr align="center">
				  		<td width="587" align="left"><strong>OPINI&Oacute;N</strong></td>
				  		
						<td width="31" valign="top" bgcolor="#CCCCCC"><p align="center">Si</p></td>
						<td width="31" valign="top" ><p align="center" ><strong>A veces </strong></p></td>
						<td width="31" valign="top" bgcolor="#CCCCCC"><p align="center"><strong>No</strong></p></td>
						<td width="31" valign="top"  ><p align="center"><strong>No aplica</strong></p></td>
					  </tr>
				  <tr align="justify">
				  		
				  		<td width="587" align="justify">1. El curso cont&oacute; con los medios audiovisuales  requeridos.</td>
						<td width="31" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_1]" type="radio" value="1"/></p></td>
						<td width="31" valign="middle"  ><p align="center">
						<input name="encu[0][II_preg_1]" type="radio" value="2"/></p></td>
						<td width="31" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_1]" type="radio" value="3"/></p></td>
						<td width="31" valign="middle" ><p align="center">
							<input name="encu[0][II_preg_1]" type="radio" value="0"/>
						</p></td>
					  </tr>
				  <tr align="justify">
				  		<td width="587" align="justify">2.  Existe una plataforma virtual de apoyo amigable . </td>
				  		<td width="31" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_2]" type="radio" value="1"/></p></td>
						<td width="31" valign="middle"   ><p align="center">
						<input name="encu[0][II_preg_2]" type="radio" value="2"/></p></td>
						<td width="31" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_2]" type="radio" value="3"/></p></td>
						<td width="31" valign="middle" ><p align="center">
							<input name="encu[0][II_preg_2]" type="radio" value="0"/>
						</p></td>
					  </tr>
				  <tr align="justify">
				  		<td width="587" align="justify">3.La Sala en que se imparti&oacute; el curso era confortable. </td>
				  		
						<td width="31" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_3]" type="radio" value="1"/></p></td>
						<td width="31" valign="middle"   ><p align="center">
						<input name="encu[0][II_preg_3]" type="radio" value="2"/></p></td>
						<td width="31" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_3]" type="radio" value="3"/></p></td>
						<td width="31" valign="middle"  ><p align="center">
							<input name="encu[0][II_preg_3]" type="radio" value="0"/>
						</p></td>
					  </tr>
				  <tr align="justify">
				  		<td width="587" align="justify">4.&nbsp;El acceso a la Biblioteca fue adecuado. </td>
				  		
						<td width="31" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_4]" type="radio" value="1"/></p></td>
						<td width="31" valign="middle"   ><p align="center">
						<input name="encu[0][II_preg_4]" type="radio" value="2"/></p></td>
						<td width="31" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_4]" type="radio" value="3"/></p></td>
						<td width="31" valign="middle"  ><p align="center">
							<input name="encu[0][II_preg_4]" type="radio" value="0"/>
						</p></td>
					  </tr>
				  <tr align="justify">
				  		<td width="587" align="justify">5.&nbsp;El n&uacute;mero de ejemplares de libros y documentos es  &oacute;ptimo .</td>
				  		
						<td width="31" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_5]" type="radio" value="1"/></p></td>
						<td width="31" valign="middle"  ><p align="center">
						<input name="encu[0][II_preg_5]" type="radio" value="2"/></p></td>
						<td width="31" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_5]" type="radio" value="3"/></p></td>
						<td width="31" valign="middle" ><p align="center">
							<input name="encu[0][II_preg_5]" type="radio" value="0"/>
						</p></td>
					  </tr>
				  <tr align="justify">
				  		<td width="587" height="22" align="justify">6. El apoyo de la coordinaci&oacute;n del Programa fue  adecuado.  </td>
				  		
						<td width="31" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_6]" type="radio" value="1"/></p></td>
						<td width="31" valign="middle"><p align="center">
						<input name="encu[0][II_preg_6]" type="radio" value="2"/></p></td>
						<td width="31"valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_6]" type="radio" value="3"/></p></td>
						<td width="31" valign="middle"><p align="center">
							<input name="encu[0][II_preg_6]" type="radio" value="0"/>
						</p></td>
					  </tr>
				 <tr align="justify">
				  		<td width="587" align="justify">7. El servicio   de cafeter&iacute;a es de buena calidad.</td>
				  		
						<td width="31" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_7]" type="radio" value="1"/></p></td>
						<td width="31" valign="middle"><p align="center">
						<input name="encu[0][II_preg_7]" type="radio" value="2"/></p></td>
						<td width="31"valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_7]" type="radio" value="3"/></p></td>
						<td width="31" valign="middle"><p align="center">
							<input name="encu[0][II_preg_7]" type="radio" value="0"/>
						</p></td>
					  </tr>
				  <tr align="justify">
				  		
			  </table>
				  <br />
				   <br />
				  <table width="665">
				  <tr><td class="Estilo31"><p><strong>III. Su dedicaci&oacute;n al programa fue.</strong></p></td>
				  </tr>
				  </table>
				  <br />
				  <table border="1">
				  		<tr>
				  			<td>Alta</td><td><p align="center"><input name="encu[0][III_preg]" type="radio" value="1"/></p></td>
							<td>Media</td><td><p align="center"><input name="encu[0][III_preg]" type="radio" value="2"/></p></td>
							<td>Baja</td><td><p align="center"><input name="encu[0][III_preg]" type="radio" value="3"/></p></td>
						</tr>
				  </table>
				    <br />
				  <table width="665">
				  <tr><td class="Estilo31"><p><strong>IV. Recomendar&iacute;a este curso a otras personas.</strong></p></td>
				  </tr>
				  </table>
				  <br />
				  <table width="110" border="1">
				  		<tr>
				  			<td>Si</td>
				  			<td><p align="center"><input name="encu[0][IV_preg]" type="radio" value="1"/></p></td>
							<td>No</td>
							<td><p align="center"><input name="encu[0][IV_preg]" type="radio" value="2"/></p></td>
							
						</tr>
				  </table>
				  <br/>
				  <table width="665">
				  <tr><td class="Estilo31"><p><strong>V. Est&aacute; interesado en cursar nuevamente un programa  de capacitaci&oacute;n y/o especializaci&oacute;n en la Universidad del Pac&iacute;fico</strong>.</p></td>
				  </tr>
				  </table>
				  <br />
				  <table border="1">
				  		<tr>
				  			<td><p><strong>1. MUY INTERESADO</strong></p></td>
				  			<td><p align="center"><input name="encu[0][V_preg]" type="radio" value="1"/></p></td>
							<td><strong>2.  INTERESADO</strong></td>
							<td><p align="center"><input name="encu[0][V_preg]" type="radio" value="2"/></p></td>
							<td><strong>3. POCO  INTERESADO</strong></td>
							<td><p align="center"><input name="encu[0][V_preg]" type="radio" value="3"/></p></td>
							<td><strong>4. SIN  INTER&Eacute;S</strong></td>
							<td><p align="center"><input name="encu[0][V_preg]" type="radio" value="4"/></p></td>
						</tr>
				  </table>
				  <br/>
				  <br/>
				  <table width="665">
				  <tr><td class="Estilo31"><p><strong>VI. Escriba sus comentarios, observaciones y/o  sugerencia</strong></p></td>
				  </tr>
				  </table>
				  <br />
			   <table width="100%">
			   <tr>
			      <td width="100%" align="center"><textarea name="encu[0][sug]" cols="145" rows="4" class="Estilo25" id="TO-N"></textarea>				</tr>
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
					 
						<a href="javascript:_Guardar(this, document.forms['edicion'], 'encuesta_programa_proc.asp','', 'ValidarMarcados()', 'Recuerde que una vez guardada la encuesta usted no podra hacer cambios', 'FALSE');">
												
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
