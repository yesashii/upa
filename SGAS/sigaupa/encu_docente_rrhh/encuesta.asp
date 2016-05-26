<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/revisa_session_encuesta_docente_rr_hh.asp"-->

<%

'---------------------------------------------------------------------------------------------------
'set pagina = new CPagina
'pagina.Titulo = "Encuesta Así soy yo"
'---------------------------------------------------------------------------------------------------
secc_ccod=request.QueryString("secc")
pers_ncorr=request.QueryString("pers_ncorr")
'secc_ccod=request.Form("secc")
set conexion = new CConexion
conexion.Inicializar "upacifico"
'
set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "encuesta_docente_rr_hh.xml", "botonera"

peri_ccod= conexion.consultaUno("select peri_ccod from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")

set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "encuesta_docente_rr_hh.xml", "encabezado"
f_encabezado.Inicializar conexion

'pers_ncorr=conexion.ConsultaUno("select protic.obtener_pers_ncorr("&q_pers_nrut&")")
consulta = "select asig_tdesc,b.asig_ccod,b.secc_ccod,secc_tdesc,carr_tdesc,pers_tnombre+' '+pers_tape_paterno as nombre from asignaturas a, secciones b, bloques_horarios c, bloques_profesores d,carreras e,personas f"& vbCrLf &_
			"where a.asig_ccod=b.asig_ccod"& vbCrLf &_
			"and b.secc_ccod=c.secc_ccod"& vbCrLf &_
			"and b.peri_ccod in ("&peri_ccod&")"& vbCrLf &_
			"and c.bloq_ccod=d.bloq_ccod"& vbCrLf &_
			"and d.pers_ncorr="&pers_ncorr&""& vbCrLf &_
			"and b.secc_ccod="&secc_ccod&""& vbCrLf &_
			"and b.carr_ccod=e.carr_ccod"& vbCrLf &_
			"and d.pers_ncorr=f.pers_ncorr"& vbCrLf &_
			"group by asig_tdesc,b.asig_ccod,b.secc_ccod,secc_tdesc,carr_tdesc,pers_tnombre,pers_tape_paterno"& vbCrLf &_
			"order by secc_tdesc" 
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_encabezado.Consultar consulta
f_encabezado.Siguiente



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
<form name="edicion">
<input type="hidden" name="encu[0][pers_ncorr]" value="<%=pers_ncorr%>">
<input type="hidden" name="encu[0][secc_ccod]" value="<%=secc_ccod%>">
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
                    <td width="19%">C&oacute;digo Asignatura  </td>
                    <td width="1%">:</td>
                    <td  align="left"><%f_encabezado.DibujaCampo("asig_ccod")%></td>
                  </tr>
                  <tr>
                    <td  width="19%">Secci&oacute;n</td>
                    <td  width="1%">:</td>
                    <td lign="left"><%f_encabezado.DibujaCampo("secc_tdesc")%></td>
                  </tr>
				   
                  <tr>
                    <td colspan="3"><p>&nbsp;</p></td>
                  </tr>
			    
			      </table>
				    <br/>
			   <table width="90%" border="0" bgcolor="#FFFFFF">
                  <tr>
                    <td class="Estilo31">Estimado(a)  profesor(a):</td>
                   </tr>
                  <tr>
                    <td class="Estilo31">Este cuestionario de autoevaluación forma parte del Sistema de Evaluación del Desempeño Docente, y requiere que responda un conjunto de preguntas agrupadas en cinco dimensiones; Planificación de la Docencia, Enseñanza para el Aprendizaje, Evaluación para el Aprendizaje, Ambiente para el Aprendizaje y Responsabilidad formal. </td>
                   </tr>
				  <tr>
                    <td class="Estilo31">Para responder encontrará una escala graduada de acuerdo a cada pregunta y deberá marcar con la opción que considere mejor refleja su opinión. 

La escala de opciones está graduada en forma creciente desde el número 1 al 6. Si piensa que no puede opinar, marque en la columna, señalada  “No se aplica”.
</td>
                   </tr>
			      </table>
				  <br />
					<hr align="left" width="100%" size="1" noshade="noshade" />
			<br />
			  <p class="Estilo31"><strong><em>1&deg; Dimensión Planificación de la Docencia </em></strong>: Esta dimensión se relaciona con los momentos, actividades, materiales y otros que deben considerarse para planificar la docencia, de modo que ésta pueda influir en el aprendizaje de todos los estudiantes.</p>
				<table width="100%" border="1" cellpadding="0" cellspacing="0">
				  <tr align="center">
				  		<td width="264"></td>
				  		<td width="102"></td>
						<td width="29" valign="top" bgcolor="#CCCCCC"><p align="center">1</p></td>
						<td width="29" valign="top" ><p align="center" >2</p></td>
						<td width="29" valign="top" bgcolor="#CCCCCC"><p align="center">3</p></td>
						<td width="29" valign="top"  ><p align="center">4</p></td>
						
						<td width="29" valign="top"  bgcolor="#CCCCCC"><p align="center">5</p></td>
						<td width="29" valign="top"><p align="center">6</p></td>
						<td width="149"></td>
						<td width="40" align="justify">No se  aplica</td>
				  </tr>
				  <tr align="justify">
				  		<td width="264" align="justify">1.  Considero en la preparaci&oacute;n del cronograma los objetivos generales y  espec&iacute;ficos, metodolog&iacute;as, criterios de evaluaciones y calificaciones,  bibliograf&iacute;a. </td>
				  		<td width="102">Considero  muy pocos de estos elementos </td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_1]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"  ><p align="center">
						<input name="encu[0][I_preg_1]" type="radio" value="2"/></p></td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_1]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle" ><p align="center">
							<input name="encu[0][I_preg_1]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle"  bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][I_preg_1]" type="radio" value="5"/>
						</p></td>
						<td width="29" valign="middle"><p align="center">
							<input name="encu[0][I_preg_1]" type="radio" value="6"/>
						</p></td>
						<td width="149">Considero  la mayor&iacute;a o la totalidad de &eacute;stos elementos </td>
						<td width="39" valign="middle"><p align="center">
							<input name="encu[0][I_preg_1]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="264" align="justify">2.  Planifico clase a clase. </td>
				  		<td width="102">Planifica  muy pocas clases </td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_2]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"   ><p align="center">
						<input name="encu[0][I_preg_2]" type="radio" value="2"/></p></td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_2]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle" ><p align="center">
							<input name="encu[0][I_preg_2]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle"  bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][I_preg_2]" type="radio" value="5"/>
						</p></td>
						<td width="29" valign="middle"><p align="center">
							<input name="encu[0][I_preg_2]" type="radio" value="6"/>
						</p></td>
						<td width="149">Planifica  todas o la mayor&iacute;a de las clases. &nbsp;</td>
						<td width="39" valign="middle"><p align="center">
							<input name="encu[0][I_preg_2]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="264" align="justify">3. Mi planificaci&oacute;n est&aacute; ligada  con los objetivos generales y espec&iacute;ficos propuestos en el programa. </td>
				  		<td width="102">Muy poco  ligada a los objetivos </td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_3]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"   ><p align="center">
						<input name="encu[0][I_preg_3]" type="radio" value="2"/></p></td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_3]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle"  ><p align="center">
							<input name="encu[0][I_preg_3]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle"  bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][I_preg_3]" type="radio" value="5"/>
						</p></td>
						<td width="29" valign="middle"><p align="center">
							<input name="encu[0][I_preg_3]" type="radio" value="6"/>
						</p></td>
						<td width="149">Muy  ligada a los objetivos </td>
						<td width="39" valign="middle"><p align="center">
							<input name="encu[0][I_preg_3]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="264" align="justify">4.&nbsp;&nbsp; Existe coherencia entre lo que planifico y  los aprendizajes esperados en el perfil de egreso de la carrera. </td>
				  		<td width="102">Muy poca  coherencia con el perfil </td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_4]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"   ><p align="center">
						<input name="encu[0][I_preg_4]" type="radio" value="2"/></p></td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_4]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle"  ><p align="center">
							<input name="encu[0][I_preg_4]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle"  bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][I_preg_4]" type="radio" value="5"/>
						</p></td>
						<td width="29"valign="middle"><p align="center">
							<input name="encu[0][I_preg_4]" type="radio" value="6"/>
						</p></td>
						<td width="149">Bastante  coherencia con el perfil </td>
						<td width="39" valign="middle"><p align="center">
							<input name="encu[0][I_preg_4]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="264" align="justify">5.&nbsp; Planifico y solicito con la debida antelaci&oacute;n  los materiales necesarios para mis &nbsp;clases.</td>
				  		<td width="102">Muy pocas  veces me preocupo de esto.&nbsp; </td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_5]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"  ><p align="center">
						<input name="encu[0][I_preg_5]" type="radio" value="2"/></p></td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_5]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle" ><p align="center">
							<input name="encu[0][I_preg_5]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle"bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][I_preg_5]" type="radio" value="5"/>
						</p></td>
						<td width="29"valign="middle"><p align="center">
							<input name="encu[0][I_preg_5]" type="radio" value="6"/>
						</p></td>
						<td width="149">Siempre  me preocupo de esto.&nbsp; </td>
						<td width="39" valign="middle"><p align="center">
							<input name="encu[0][I_preg_5]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="264" height="75" align="justify">6. El  tiempo que planifico para cada actividad es el necesario para alcanzar los  objetivos propuestos. </td>
				  		<td width="102">Frecuentemente  no me alcanza el tiempo </td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_6]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"><p align="center">
						<input name="encu[0][I_preg_6]" type="radio" value="2"/></p></td>
						<td width="29"valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_6]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle"><p align="center">
							<input name="encu[0][I_preg_6]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][I_preg_6]" type="radio" value="5"/>
						</p></td>
						<td width="29" valign="middle"><p align="center">
							<input name="encu[0][I_preg_6]" type="radio" value="6"/>
						</p></td>
						<td width="149">Siempre  me alcanza el tiempo </td>
						<td width="39" valign="middle"><p align="center">
							<input name="encu[0][I_preg_6]" type="radio" value="99"/>
						</p></td>
				  </tr>
				 
			  </table> 
			   <br />
			   <table width="100%">
			   <tr>
			    <td width="100%">Creo que mis fortalezas y debilidades en esta dimensión son:</td>
			   </tr>
			   <tr>
			      <td width="95%" align="center"><textarea name="encu[0][I_foraleza_debilidad]" cols="145" rows="4" class="Estilo25" id="TO-N"></textarea>
				</tr>
				</table>
				<br />
				<hr align="left" width="100%" size="1" noshade="noshade" />
				<br />
				<p ><strong><em> 2º Dimensión Enseñanza para el aprendizaje </em></strong>: Esta dimensión se refiere a la forma en que el docente desarrolla sus clases. Incluye la comunicación de información sobre el desarrollo del curso, la estructuración de las clases, la claridad en el tratamiento de los temas, entre otros.
				<table width="100%" border="1" cellpadding="0" cellspacing="0">
				  <tr align="justify">
				  		<td width="267">&nbsp;</td>
				  		<td width="102"></td>
						<td width="29" valign="top" bgcolor="#CCCCCC"><p align="center">1</p></td>
						<td width="29" valign="top" ><p align="center" >2</p></td>
						<td width="29" valign="top" bgcolor="#CCCCCC"><p align="center">3</p></td>
						<td width="29" valign="top"  ><p align="center">4</p></td>
						
						<td width="29" valign="top"  bgcolor="#CCCCCC"><p align="center">5</p></td>
						<td width="27"valign="top" ><p align="center">6</p></td>
						<td width="147"></td>
						<td width="40" align="justify">No se  aplica</td>
				  </tr>
				  <tr align="justify">
				  		<td width="267" align="justify">1.  Expliqu&eacute; clara y oportunamente los&nbsp;  objetivos, contenidos, materiales a utilizar y&nbsp; bibliograf&iacute;a al inicio del curso.</td>
				  		<td width="102">En forma  poco clara y oportuna</td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_1]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"  ><p align="center">
						<input name="encu[0][II_preg_1]" type="radio" value="2"/></p></td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_1]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle" ><p align="center">
							<input name="encu[0][II_preg_1]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle"  bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][II_preg_1]" type="radio" value="5"/>
						</p></td>
						<td width="27" valign="middle"><p align="center">
							<input name="encu[0][II_preg_1]" type="radio" value="6"/>
						</p></td>
						<td width="147">En forma  muy clara y oportuna</td>
						<td width="40" valign="middle"><p align="center">
							<input name="encu[0][II_preg_1]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="267" align="justify">2. &iquest;Qu&eacute;  tan significativos, para el&nbsp; aprendizaje  de mis estudiantes, son las actividades que&nbsp;&nbsp;  propongo o desarrollo en clases?</td>
				  		<td width="102">Muy poco significativas</td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_2]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"   ><p align="center">
						<input name="encu[0][II_preg_2]" type="radio" value="2"/></p></td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_2]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle" ><p align="center">
							<input name="encu[0][II_preg_2]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle"  bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][II_preg_2]" type="radio" value="5"/>
						</p></td>
						<td width="27" valign="middle"><p align="center">
							<input name="encu[0][II_preg_2]" type="radio" value="6"/>
						</p></td>
						<td width="147">Muy significativas</td>
						<td width="40" valign="middle"><p align="center">
							<input name="encu[0][II_preg_2]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="267" align="justify">3.  &iquest;Propongo en mis clases&nbsp; actividades que  le den al estudiante la posibilidad de pensar, observar, investigar, practicar  y sacar sus&nbsp; propias conclusiones?</td>
				  		<td width="102">Casi  nunca</td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_3]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"   ><p align="center">
						<input name="encu[0][II_preg_3]" type="radio" value="2"/></p></td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_3]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle"  ><p align="center">
							<input name="encu[0][II_preg_3]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle"  bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][II_preg_3]" type="radio" value="5"/>
						</p></td>
						<td width="27" valign="middle"><p align="center">
							<input name="encu[0][II_preg_3]" type="radio" value="6"/>
						</p></td>
						<td width="147">Muy  frecuentemente</td>
						<td width="40" valign="middle"><p align="center">
							<input name="encu[0][II_preg_3]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="267" align="justify">4. &iquest;De  qu&eacute; manera respondo las&nbsp; consultas que  los estudiantes realizan en clases?</td>
				  		<td width="102">En forma  poco &nbsp;clara o poco satisfactoria</td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_4]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"   ><p align="center">
						<input name="encu[0][II_preg_4]" type="radio" value="2"/></p></td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_4]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle"  ><p align="center">
							<input name="encu[0][II_preg_4]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle"  bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][II_preg_4]" type="radio" value="5"/>
						</p></td>
						<td width="27"valign="middle"><p align="center">
							<input name="encu[0][II_preg_4]" type="radio" value="6"/>
						</p></td>
						<td width="147">En forma  clara y &nbsp;satisfactoria</td>
						<td width="40" valign="middle"><p align="center">
							<input name="encu[0][II_preg_4]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="267" align="justify">5. &iquest;Con  qu&eacute; frecuencia relaciono los contenidos tratados con el futuro desempe&ntilde;o  profesional de los estudiantes? </td>
				  		<td width="102">Casi  nunca </td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_5]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"  ><p align="center">
						<input name="encu[0][II_preg_5]" type="radio" value="2"/></p></td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_5]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle" ><p align="center">
							<input name="encu[0][II_preg_5]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle"bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][II_preg_5]" type="radio" value="5"/>
						</p></td>
						<td width="27"valign="middle"><p align="center">
							<input name="encu[0][II_preg_5]" type="radio" value="6"/>
						</p></td>
						<td width="147">Muy  frecuentemente </td>
						<td width="40" valign="middle"><p align="center">
							<input name="encu[0][II_preg_5]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="267" align="justify">6. Las  actividades que he desarrollado en clases &iquest;han sido coherentes con los  objetivos de aprendizaje de la asignatura? </td>
				  		<td width="102">Poco  coherentes </td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_6]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"><p align="center">
						<input name="encu[0][II_preg_6]" type="radio" value="2"/></p></td>
						<td width="29"valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_6]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle"><p align="center">
							<input name="encu[0][II_preg_6]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][II_preg_6]" type="radio" value="5"/>
						</p></td>
						<td width="27" valign="middle"><p align="center">
							<input name="encu[0][II_preg_6]" type="radio" value="6"/>
						</p></td>
						<td width="147">Muy  coherentes </td>
						<td width="40" valign="middle"><p align="center">
							<input name="encu[0][II_preg_6]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="267" align="justify">7. Las  actividades desarrolladas &iquest;facilitan la innovaci&oacute;n y creatividad en el hacer  disciplinario?</td>
				  		<td width="102">Casi&nbsp; nunca</td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_7]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"><p align="center">
						<input name="encu[0][II_preg_7]" type="radio" value="2"/></p></td>
						<td width="29"valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_7]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle"><p align="center">
							<input name="encu[0][II_preg_7]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][II_preg_7]" type="radio" value="5"/>
						</p></td>
						<td width="27" valign="middle"><p align="center">
							<input name="encu[0][II_preg_7]" type="radio" value="6"/>
						</p></td>
						<td width="147">Muy  frecuentemente</td>
						<td width="40" valign="middle"><p align="center">
							<input name="encu[0][II_preg_7]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="267" align="justify">8. Mis  expectativas sobre el aprendizaje de mis estudiantes son&hellip; </td>
				  		<td width="102">Muy bajas </td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_8]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"><p align="center">
						<input name="encu[0][II_preg_8]" type="radio" value="2"/></p></td>
						<td width="29"valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_8]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle"><p align="center">
							<input name="encu[0][II_preg_8]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][II_preg_8]" type="radio" value="5"/>
						</p></td>
						<td width="27" valign="middle"><p align="center">
							<input name="encu[0][II_preg_8]" type="radio" value="6"/>
						</p></td>
						<td width="147">Muy altas </td>
						<td width="40" valign="middle"><p align="center">
							<input name="encu[0][II_preg_8]" type="radio" value="99"/>
						</p></td>
				  </tr>
			  </table>
			     <br />
			   <table width="100%">
			   <tr>
			    <td width="100%">Creo que mis fortalezas y debilidades en esta dimensión son:</td>
			   </tr>
			   <tr>
			      <td width="95%" align="center"><textarea name="encu[0][II_foraleza_debilidad]" cols="145" rows="4" class="Estilo25" id="TO-N"></textarea>
				</tr>
				</table>
				<br />
				<hr align="left" width="100%" size="1" noshade="noshade" />
				<br />
			  <p class="Estilo31"><strong><em> 3º Dimensión Evaluación para el aprendizaje </em></strong>: En esta dimensión se considera el proceso que el/la docente desarrolla para que sus estudiantes evidencien sus aprendizajes y la forma en que utiliza esa información, tanto para mejorar el aprendizaje y la enseñanza, como para otorgar calificaciones. </p>
			  <table width="100%" border="1" cellpadding="0" cellspacing="0">
				  <tr align="justify">
				  		<td width="270"></td>
				  		<td width="102"></td>
						<td width="29" valign="top" bgcolor="#CCCCCC"><p align="center">1</p></td>
						<td width="29" valign="top" ><p align="center" >2</p></td>
						<td width="29" valign="top" bgcolor="#CCCCCC"><p align="center">3</p></td>
						<td width="29" valign="top"  ><p align="center">4</p></td>
						
						<td width="29" valign="top"  bgcolor="#CCCCCC"><p align="center">5</p></td>
						<td width="24" valign="top"><p align="center">6</p></td>
						<td width="147"></td>
						<td width="40" align="justify">No se aplica</td>
				  </tr>
				  <tr align="justify">
				  		<td width="270" align="justify">1. &iquest;Comuniqu&eacute;  claramente los criterios de evaluaci&oacute;n y calificaci&oacute;n con los que evaluar&eacute; a  mis estudiantes?</td>
				  		<td width="102">No  comuniqu&eacute;</td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][III_preg_1]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"  ><p align="center">
						<input name="encu[0][III_preg_1]" type="radio" value="2"/></p></td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][III_preg_1]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle" ><p align="center">
							<input name="encu[0][III_preg_1]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle"  bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][III_preg_1]" type="radio" value="5"/>
						</p></td>
						<td width="24" valign="middle"><p align="center">
							<input name="encu[0][III_preg_1]" type="radio" value="6"/>
						</p></td>
						<td width="147">Comuniqu&eacute;  con total claridad</td>
						<td width="40" valign="middle"><p align="center">
						  <input name="encu[0][III_preg_1]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="270" align="justify">2. Los  procedimientos de evaluaci&oacute;n que utilizo &iquest;son coherentes con los contenidos,  nivel de exigencia de las clases y actividades desarrolladas durante el  curso?&nbsp; </td>
				  		<td width="102">Poco  coherentes </td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][III_preg_2]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"   ><p align="center">
						<input name="encu[0][III_preg_2]" type="radio" value="2"/></p></td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][III_preg_2]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle"  ><p align="center">
							<input name="encu[0][III_preg_2]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle"  bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][III_preg_2]" type="radio" value="5"/>
						</p></td>
						<td width="24" valign="middle"><p align="center">
							<input name="encu[0][III_preg_2]" type="radio" value="6"/>
						</p></td>
						<td width="147">Muy  coherentes&nbsp; </td>
						<td width="40" valign="middle"><p align="center">
							<input name="encu[0][III_preg_2]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="270" align="justify">3. Las  instrucciones e indicaciones dadas en los instrumentos de evaluaci&oacute;n que  aplico, &iquest;han sido claras y precisas para su desarrollo?</td>
				  		<td width="102">Poco  claras e imprecisas</td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][III_preg_3]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"   ><p align="center">
						<input name="encu[0][III_preg_3]" type="radio" value="2"/></p></td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][III_preg_3]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle"  ><p align="center">
							<input name="encu[0][III_preg_3]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle"  bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][III_preg_3]" type="radio" value="5"/>
						</p></td>
						<td width="24"valign="middle"><p align="center">
							<input name="encu[0][III_preg_3]" type="radio" value="6"/>
						</p></td>
						<td width="147">Muy  claras y precisas</td>
						<td width="40" valign="middle"><p align="center">
							<input name="encu[0][III_preg_3]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="270" align="justify">4. El  an&aacute;lisis y comentarios de los resultados de las evaluaciones &iquest;es entregado a  tiempo y contribuye a mejorar los aprendizajes de mis estudiantes?</td>
				  		<td width="102">Se otorga  fuera de tiempo y/o es poco valiosa </td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][III_preg_4]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"  ><p align="center">
						<input name="encu[0][III_preg_4]" type="radio" value="2"/></p></td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][III_preg_4]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle" ><p align="center">
							<input name="encu[0][III_preg_4]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle"bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][III_preg_4]" type="radio" value="5"/>
						</p></td>
						<td width="24"valign="middle"><p align="center">
							<input name="encu[0][III_preg_4]" type="radio" value="6"/>
						</p></td>
						<td width="147">Es  oportuna y valiosa </td>
						<td width="40" valign="middle"><p align="center">
							<input name="encu[0][III_preg_4]" type="radio" value="99"/>
						</p></td>
				  </tr>
			  </table>
			  <br />
			   <table width="100%">
			   <tr>
			    <td width="100%">Creo que mis fortalezas y debilidades en esta dimensión son:</td>
			   </tr>
			   <tr>
			      <td width="95%" align="center"><textarea name="encu[0][III_foraleza_debilidad]" cols="145" rows="4" class="Estilo25" id="TO-N"></textarea>
				</tr>
				</table>
				<br />
		  <hr align="left" width="100%" size="1" noshade="noshade" />
			   <br />
			  
			      <p class="Estilo31"><strong><em> 4º Dimensión Ambiente para el Aprendizaje:  </em></strong>Se refiere a la creación de un ambiente agradable y propicio por parte del/la docente tanto para la enseñanza como para el aprendizaje. </p>
				  <table width="100%" border="1" cellpadding="0" cellspacing="0">
				  <tr align="justify">
				  		<td width="268"></td>
				  		<td width="102"></td>
						<td width="29" valign="top" bgcolor="#CCCCCC"><p align="center">1</p></td>
						<td width="29" valign="top" ><p align="center" >2</p></td>
						<td width="29" valign="top"bgcolor="#CCCCCC"><p align="center">3</p></td>
						<td width="29" valign="top"  ><p align="center">4</p></td>
						
						<td width="29" valign="top"  bgcolor="#CCCCCC"><p align="center">5</p></td>
						<td width="26"valign="top"><p align="center">6</p></td>
						<td width="147"></td>
						<td width="40"><p align="justify">No se aplica </p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="268" align="justify">1. &iquest;Creo  un ambiente de confianza que incentiva la participaci&oacute;n en el aula?&nbsp; </td>
				  		<td width="102">Creo un  ambiente poco apropiado </td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][IV_preg_1]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"  ><p align="center">
						<input name="encu[0][IV_preg_1]" type="radio" value="2"/></p></td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][IV_preg_1]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle" ><p align="center">
							<input name="encu[0][IV_preg_1]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle"  bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][IV_preg_1]" type="radio" value="5"/>
						</p></td>
						<td width="26" valign="middle"><p align="center">
							<input name="encu[0][IV_preg_1]" type="radio" value="6"/>
						</p></td>
						<td width="147">Creo un  ambiente muy apropiado</td>
						<td width="40" valign="middle"><p align="center">
							<input name="encu[0][IV_preg_1]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="268" align="justify">2. &iquest;Establezco  una interacci&oacute;n o di&aacute;logo con mis estudiantes&nbsp;  que facilita su aprendizaje?</td>
				  		<td width="102">La  interacci&oacute;n no facilita el aprendizaje </td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][IV_preg_2]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"   ><p align="center">
						<input name="encu[0][IV_preg_2]" type="radio" value="2"/></p></td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][IV_preg_2]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle" ><p align="center">
							<input name="encu[0][IV_preg_2]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle"  bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][IV_preg_2]" type="radio" value="5"/>
						</p></td>
						<td width="26" valign="middle"><p align="center">
							<input name="encu[0][IV_preg_2]" type="radio" value="6"/>
						</p></td>
						<td width="147">La interacci&oacute;n  facilita el aprendizaje&nbsp; </td>
						<td width="40" valign="middle"><p align="center">
							<input name="encu[0][IV_preg_2]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="268" align="justify">3. &iquest;Considero  los puntos de vista de mis estudiantes, aunque sean distintos a los m&iacute;os?</td>
				  		<td width="102">Pocas  veces </td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][IV_preg_3]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"   ><p align="center">
						<input name="encu[0][IV_preg_3]" type="radio" value="2"/></p></td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][IV_preg_3]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle"  ><p align="center">
							<input name="encu[0][IV_preg_3]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle"  bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][IV_preg_3]" type="radio" value="5"/>
						</p></td>
						<td width="26" valign="middle"><p align="center">
							<input name="encu[0][IV_preg_3]" type="radio" value="6"/>
						</p></td>
						<td width="147">La  mayor&iacute;a de las veces </td>
						<td width="40" valign="middle"><p align="center">
							<input name="encu[0][IV_preg_3]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="268" align="justify">4.  &iquest;Estimulo el inter&eacute;s de mis estudiantes por aprender m&aacute;s de su disciplina y en  su &aacute;rea laboral? </td>
				  		<td width="102">Creo que  mis estudiantes se estimulan poco </td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][IV_preg_4]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"   ><p align="center">
						<input name="encu[0][IV_preg_4]" type="radio" value="2"/></p></td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][IV_preg_4]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle"  ><p align="center">
							<input name="encu[0][IV_preg_4]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle"  bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][IV_preg_4]" type="radio" value="5"/>
						</p></td>
						<td width="26"valign="middle"><p align="center">
							<input name="encu[0][IV_preg_4]" type="radio" value="6"/>
						</p></td>
						<td width="147">Creo que  mis estudiantes se estimulan bastante </td>
						<td width="40" valign="middle"><p align="center">
							<input name="encu[0][IV_preg_4]" type="radio" value="99"/>
						</p></td>
				  </tr>
				 
			  </table>
			   <br />
			   <table width="100%">
			   <tr>
			    <td width="100%">Creo que mis fortalezas y debilidades en esta dimensión son:</td>
			   </tr>
			   <tr>
			      <td width="95%" align="center"><textarea name="encu[0][IV_foraleza_debilidad]" cols="145" rows="4" class="Estilo25" id="TO-N"></textarea>
				</tr>
				</table>
				<br />
				<hr align="left" width="100%" size="1" noshade="noshade" />
			  <br />
			  <p class="Estilo31"><strong><em> 5º Dimensión Responsabilidad Formal:</em></strong>Dimensión relacionada con el cumplimiento de aspectos administrativos básicos del quehacer docente para optimizar los procesos de enseñanza y aprendizaje. Se incluyen aquí la puntualidad, asistencia, entrega de trabajos en un plazo prudente u otros.</p>
				<table width="100%" border="1" cellpadding="0" cellspacing="0">
				  <tr align="justify">
				  		<td width="264"></td>
				  		<td width="102"></td>
						<td width="29" valign="top" bgcolor="#CCCCCC"><p align="center">1</p></td>
						<td width="29" valign="top" ><p align="center" >2</p></td>
						<td width="29" valign="top"bgcolor="#CCCCCC"><p align="center">3</p></td>
						<td width="29" valign="top"  ><p align="center">4</p></td>
						
						<td width="29" valign="top"  bgcolor="#CCCCCC"><p align="center">5</p></td>
						<td width="29"valign="top"><p align="center">6</p></td>
						<td width="148"></td>
						<td width="40"><p align="justify">No se aplica </p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="264" align="justify">1. &iquest;He  sido puntual al comenzar y al finalizar las sesiones de clases? </td>
				  		<td width="102">Pocas  veces soy puntual </td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][V_preg_1]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"  ><p align="center">
						<input name="encu[0][V_preg_1]" type="radio" value="2"/></p></td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][V_preg_1]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle" ><p align="center">
							<input name="encu[0][V_preg_1]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle"  bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][V_preg_1]" type="radio" value="5"/>
						</p></td>
						<td width="29" valign="middle"><p align="center">
							<input name="encu[0][V_preg_1]" type="radio" value="6"/>
						</p></td>
						<td width="148">La  mayor&iacute;a de las veces soy puntual </td>
						<td width="40" valign="middle"><p align="center">
							<input name="encu[0][V_preg_1]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  
				  <tr align="justify">
				  		<td width="264" align="justify">2. &iquest;Comuniqu&eacute;  a mis estudiantes informaci&oacute;n del curso referida a fechas importantes, horarios  de inicio y t&eacute;rmino de clases, salas o espacios f&iacute;sicos a utilizar? </td>
				  		<td width="102">No  comuniqu&eacute; la informaci&oacute;n </td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][V_preg_2]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"   ><p align="center">
						<input name="encu[0][V_preg_2]" type="radio" value="2"/></p></td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][V_preg_2]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle"  ><p align="center">
							<input name="encu[0][V_preg_2]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle"  bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][V_preg_2]" type="radio" value="5"/>
						</p></td>
						<td width="29" valign="middle"><p align="center">
							<input name="encu[0][V_preg_2]" type="radio" value="6"/>
						</p></td>
						<td width="148">Comuniqu&eacute;  toda o la mayor&iacute;a de la informaci&oacute;n </td>
						<td width="40" valign="middle"><p align="center">
							<input name="encu[0][V_preg_2]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="264" align="justify">3.  &iquest;Cumplo con los plazos acordados para la entrega de trabajos y pruebas? </td>
				  		<td width="102">Frecuentemente no cumplo con los plazos </td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][V_preg_3]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"   ><p align="center">
						<input name="encu[0][V_preg_3]" type="radio" value="2"/></p></td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][V_preg_3]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle"  ><p align="center">
							<input name="encu[0][V_preg_3]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle"  bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][V_preg_3]" type="radio" value="5"/>
						</p></td>
						<td width="29"valign="middle"><p align="center">
							<input name="encu[0][V_preg_3]" type="radio" value="6"/>
						</p></td>
						<td width="148">Cumplo  con los plazos </td>
						<td width="40" valign="middle"><p align="center">
							<input name="encu[0][V_preg_3]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  
			  </table>
				<br />
				<table width="100%">
			   <tr>
			    <td width="100%">Creo que mis fortalezas y debilidades en esta dimensión son:</td>
			   </tr>
			   <tr>
			      <td width="95%" align="center"><textarea name="encu[0][V_foraleza_debilidad]" cols="145" rows="4" class="Estilo25" id="TO-N"></textarea>
				</tr>
				</table>
			
			  <br />
				<hr align="left" width="100%" size="1" noshade="noshade" />
				
				 
				
				<br />
			 	<br />
			 <br />
			  <table width="100%">
			   <tr>
			   <td width="36%" align="rigth" valign="top" class="Estilo31"></td>
					
				
					<td width="10%" align="center" valign="top" class="Estilo31">
					 
						<a href="javascript:vovler();">
												
						<img src="Images/vovler1.png" border="0" width="65" height="65" alt="¿Cómo funciona?">					</td>
					
					<td width="11%" align="center" valign="top" class="Estilo31">
					 
						<a href="javascript:_Guardar(this, document.forms['edicion'], 'encuesta_proc.asp','', 'ValidarMarcados();', 'Recuerde que una vez guardada la encuesta usted no podra hacer cambios', 'FALSE');">
												
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
