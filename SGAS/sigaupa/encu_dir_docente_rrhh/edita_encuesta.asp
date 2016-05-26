
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/revisa_session_encuesta_dir_docente_rr_hh.asp"-->

<%

'---------------------------------------------------------------------------------------------------
'set pagina = new CPagina
'pagina.Titulo = "Encuesta Así soy yo"
'---------------------------------------------------------------------------------------------------
secc_ccod=request.QueryString("secc")
pers_ncorr=request.QueryString("pers_ncorr")
carr_ccod=request.QueryString("carr_ccod")


'response.Write(secc_ccod)
'secc_ccod=44487
'pers_ncorr=27
'carr_ccod=14
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

peri_ccod=conexion.consultaUno("select peri_ccod from secciones where cast(secc_ccod as varchar)='"&secc_ccod&"'")
'para la variable peri_ccod si es el 1 semestre se escribe el codigo correspondiente , si el el 2° sem debe colocarse el codigo del 2° sem y el 3 trimestre separado por una 
'coma  ej. 220,221 
'//////////////////////////////



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
consulta="select derh_ncorr,secc_ccod,pers_ncorr,pers_ncorr_director,derh_preg_I_1,derh_preg_I_2,derh_preg_I_3,derh_preg_I_4,derh_preg_I_5,derh_preg_I_6,derh_preg_I_7,"& vbCrLf &_
"derh_preg_I_8,derh_preg_I_9,derh_preg_I_10,derh_preg_II_1,derh_preg_II_2,derh_preg_II_3,derh_preg_II_4,derh_preg_II_5,derh_preg_II_6,derh_preg_II_7,"& vbCrLf &_
"derh_preg_II_8,derh_preg_II_9,derh_preg_II_10,derh_preg_II_11,derh_I_foraleza_debilidad,derh_II_foraleza_debilidad,derh_III_a,derh_III_b,derh_III_c,derh_IV_fortaleza_debilidad,"& vbCrLf &_
"audi_fmodificacion"& vbCrLf &_
"from dir_encuesta_docente_hhrr "& vbCrLf &_
"where secc_ccod="&secc_ccod&""& vbCrLf &_
"and pers_ncorr="&pers_ncorr&""

set f_resultado = new CFormulario
f_resultado.Carga_Parametros "tabla_vacia.xml", "tabla" 
f_resultado.Inicializar conexion


f_resultado.Consultar consulta
f_resultado.Siguiente



derh_preg_I_1=f_resultado.ObtenerValor("derh_preg_I_1")
if derh_preg_I_1="99" then
derh_preg_I_1=7
end if
derh_preg_I_2=f_resultado.ObtenerValor("derh_preg_I_2")
if derh_preg_I_2="99" then
derh_preg_I_2=7
end if
derh_preg_I_3=f_resultado.ObtenerValor("derh_preg_I_3")
if derh_preg_I_3="99" then
derh_preg_I_3=7
end if
derh_preg_I_4=f_resultado.ObtenerValor("derh_preg_I_4")
if derh_preg_I_4="99" then
derh_preg_I_4=7
end if
derh_preg_I_5=f_resultado.ObtenerValor("derh_preg_I_5")
if derh_preg_I_5="99" then
derh_preg_I_5=7
end if
derh_preg_I_6=f_resultado.ObtenerValor("derh_preg_I_6")
if derh_preg_I_6="99" then
derh_preg_I_6=7
end if
derh_preg_I_7=f_resultado.ObtenerValor("derh_preg_I_7")
if derh_preg_I_7="99" then
derh_preg_I_7=7
end if
derh_preg_I_8=f_resultado.ObtenerValor("derh_preg_I_8")
if derh_preg_I_8="99" then
derh_preg_I_8=7
end if
derh_preg_I_9=f_resultado.ObtenerValor("derh_preg_I_9")
if derh_preg_I_9="99" then
derh_preg_I_9=7
end if
derh_preg_I_10=f_resultado.ObtenerValor("derh_preg_I_10")
if derh_preg_I_10="99" then
derh_preg_I_10=7
end if
'---------------------------------------------------------------------------------------------------------------------------------------
derh_preg_II_1=f_resultado.ObtenerValor("derh_preg_II_1")
if derh_preg_II_1="99" then
derh_preg_II_1=7
end if
derh_preg_II_2=f_resultado.ObtenerValor("derh_preg_II_2")
if derh_preg_II_2="99" then
derh_preg_II_2=7
end if
derh_preg_II_3=f_resultado.ObtenerValor("derh_preg_II_3")
if derh_preg_II_3="99" then
derh_preg_II_3=7
end if
derh_preg_II_4=f_resultado.ObtenerValor("derh_preg_II_4")
if derh_preg_II_4="99" then
derh_preg_II_4=7
end if
derh_preg_II_5=f_resultado.ObtenerValor("derh_preg_II_5")
if derh_preg_II_5="99" then
derh_preg_II_5=7
end if
derh_preg_II_6=f_resultado.ObtenerValor("derh_preg_II_6")
if derh_preg_II_6="99" then
derh_preg_II_6=7
end if
derh_preg_II_7=f_resultado.ObtenerValor("derh_preg_II_7")
if derh_preg_II_7="99" then
derh_preg_II_7=7
end if
derh_preg_II_8=f_resultado.ObtenerValor("derh_preg_II_8")
if derh_preg_II_8="99" then
derh_preg_II_8=7
end if
derh_preg_II_9=f_resultado.ObtenerValor("derh_preg_II_9")
if derh_preg_II_9="99" then
derh_preg_II_9=7
end if
derh_preg_II_10=f_resultado.ObtenerValor("derh_preg_II_10")
if derh_preg_II_10="99" then
derh_preg_II_10=7
end if
derh_preg_II_11=f_resultado.ObtenerValor("derh_preg_II_11")
if derh_preg_II_11="99" then
derh_preg_II_11=7
end if
'---------------------------------------------------------------------------------------------------------------------------------------
derh_I_foraleza_debilidad=f_resultado.ObtenerValor("derh_I_foraleza_debilidad")
derh_II_foraleza_debilidad=f_resultado.ObtenerValor("derh_II_foraleza_debilidad")
derh_III_a=f_resultado.ObtenerValor("derh_III_a")
derh_III_b=f_resultado.ObtenerValor("derh_III_b")
derh_III_c=f_resultado.ObtenerValor("derh_III_c")
derh_IV_foraleza_debilidad=f_resultado.ObtenerValor("derh_IV_fortaleza_debilidad")
derh_ncorr=f_resultado.ObtenerValor("derh_ncorr")
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

valor2=<%=pers_ncorr%>;
valor3='<%=carr_ccod%>'
window.location=("asignaturas.asp?pers_ncorr="+valor2+"&carr_ccod="+valor3+"")
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
var II_preg_1
var II_preg_2
var II_preg_3
var II_preg_4
var II_preg_5
var II_preg_6
var II_preg_7
var II_preg_8
var II_preg_9
var II_preg_10
var II_preg_11


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
  divisor=7;//cantidad de alternativas de respuesta por pregunta
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
  aviso=aviso+"8 de la parte I.\r";
   
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
  aviso=aviso+"9 de la parte I.\r";
   
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
  aviso=aviso+"10 de la parte I.\r";
   
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
//---------------------------------
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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][II_preg_9]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 II_preg_9=1
  }
  else
  {
  aviso=aviso+"8 de la parte II.\r";
   
  }
}
//---------------------------------
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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][II_preg_9]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 II_preg_9=1
  }
  else
  {
  aviso=aviso+"9 de la parte II.\r";
   
  }
}
//---------------------------------
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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][II_preg_10]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 II_preg_10=1
  }
  else
  {
  aviso=aviso+"10 de la parte II.\r";
   
  }
}
//---------------------------------
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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][II_preg_11]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 II_preg_11=1
  }
  else
  {
  aviso=aviso+"11 de la parte II.\r";
   
  }
}
//-------------------------

//alert(I_preg_1+'\r'+I_preg_2+'\r'+I_preg_3+'\r'+I_preg_4+'\r'+I_preg_5+'\r'+I_preg_6+'\r'+II_preg_1+'\r'+II_preg_2+'\r'+II_preg_3+'\r'+II_preg_4+'\r'+II_preg_5+'\r'+II_preg_6+'\r'+II_preg_7+'\r'+II_preg_8+'\r'+III_preg_1+'\r'+III_preg_2+'\r'+III_preg_3+'\r'+III_preg_4+'\r'+IV_preg_1+'\r'+IV_preg_2+'\r'+IV_preg_3+'\r'+IV_preg_4+'\r'+V_preg_1+'\r'+V_preg_2+'\r'+V_preg_3);
if ((I_preg_1==1) && (I_preg_2==1) && (I_preg_3==1) && (I_preg_4==1)&& (I_preg_5==1) && (I_preg_6==1)&& (I_preg_7==1)&& (I_preg_8==1)&& (I_preg_9==1)&& (I_preg_10==1)     && (II_preg_1==1) && (II_preg_2==1) && (II_preg_3==1) && (II_preg_4==1)&& (II_preg_5==1) && (II_preg_6==1)&& (II_preg_7==1)&& (II_preg_8==1)&& (II_preg_9==1)&& (II_preg_10==1)&& (II_preg_11==1) )
{
 	return true;
	
}
else
{
	alert(aviso);
}

}


function carga_datos()
{
I_preg_1=<%=derh_preg_I_1%>+3;
I_preg_2=<%=derh_preg_I_2%>+10;
I_preg_3=<%=derh_preg_I_3%>+17;
I_preg_4=<%=derh_preg_I_4%>+24;
I_preg_5=<%=derh_preg_I_5%>+31;
I_preg_6=<%=derh_preg_I_6%>+38;
I_preg_7=<%=derh_preg_I_7%>+45;
I_preg_8=<%=derh_preg_I_8%>+52;
I_preg_9=<%=derh_preg_I_9%>+59;
I_preg_10=<%=derh_preg_I_10%>+66;
//-------------------------------------------
II_preg_1=<%=derh_preg_II_1%>+74;
II_preg_2=<%=derh_preg_II_2%>+81;
II_preg_3=<%=derh_preg_II_3%>+88;
II_preg_4=<%=derh_preg_II_4%>+95;
II_preg_5=<%=derh_preg_II_5%>+102;
II_preg_6=<%=derh_preg_II_6%>+109;
II_preg_7=<%=derh_preg_II_7%>+116;
II_preg_8=<%=derh_preg_II_8%>+123;
II_preg_9=<%=derh_preg_II_9%>+130;
II_preg_10=<%=derh_preg_II_10%>+137;
II_preg_11=<%=derh_preg_II_11%>+144;
//-------------------------------------------

document.edicion.elements[I_preg_1].checked=true;
document.edicion.elements[I_preg_2].checked=true;
document.edicion.elements[I_preg_3].checked=true;
document.edicion.elements[I_preg_4].checked=true;
document.edicion.elements[I_preg_5].checked=true;
document.edicion.elements[I_preg_6].checked=true;
document.edicion.elements[I_preg_7].checked=true;
document.edicion.elements[I_preg_8].checked=true;
document.edicion.elements[I_preg_9].checked=true;
document.edicion.elements[I_preg_10].checked=true;

document.edicion.elements[II_preg_1].checked=true;
document.edicion.elements[II_preg_2].checked=true;
document.edicion.elements[II_preg_3].checked=true;
document.edicion.elements[II_preg_4].checked=true;
document.edicion.elements[II_preg_5].checked=true;
document.edicion.elements[II_preg_6].checked=true;
document.edicion.elements[II_preg_7].checked=true;
document.edicion.elements[II_preg_8].checked=true;
document.edicion.elements[II_preg_9].checked=true;
document.edicion.elements[II_preg_10].checked=true;
document.edicion.elements[II_preg_11].checked=true;

//document.edicion.elements['encu[0][I_foraleza_debilidad]'].value=derh_I_foraleza_debilidad;
//document.edicion.elements['encu[0][II_foraleza_debilidad]'].value=derh_II_foraleza_debilidad  
//document.edicion.elements['encu[0][III_a]'].value=derh_III_a  
//document.edicion.elements['encu[0][III_b]'].value=derh_III_b
//document.edicion.elements['encu[0][III_c]'].value=derh_III_c    

//document.edicion.elements['encu[0][IV_foraleza_debilidad]'].value=derh_IV_foraleza_debilidad  
//document.edicion.elements['encu[0][I_preg_1]'].value =I_preg_1;

//var elementnr = radio * 4 + value;
//document.forms[0].elements[elementnr].checked = true;

}

</script>
</head>

<body onLoad="carga_datos()">
<!--<p align="center" class="Estilo35">&quot;Encuesta Egresados de RR PP&quot;</p>-->
<p align="center"><span class="Estilo34">  </span></p>
<table width="100%" border="0">
<tr valign="top">
<td width="100%" align="center">
<form name="edicion">
<input type="hidden" name="encu[0][pers_ncorr]" value="<%=pers_ncorr%>">
<input type="hidden" name="encu[0][secc_ccod]" value="<%=secc_ccod%>">
<input type="hidden" name="encu[0][carr_ccod]" value="<%=carr_ccod%>">
<input type="hidden" name="encu[0][derh_ncorr]" value="<%=derh_ncorr%>">
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
			      </table>
				<br/>
			   <table width="90%" border="0" bgcolor="#FFFFFF">
                  <tr>
                    <td class="Estilo31">Estimado(a)  director(a):</td>
                   </tr>
                  <tr>
                    <td class="Estilo31">El presente instrumento corresponde a su opinión, referida al desempeño del docente identificado en el cuestionario y en relación a la asignatura y sección que se indica. </td>
                   </tr>
				  <tr>
                    <td class="Estilo31">Para responder las dimensiones; Planificación de la Docencia y Responsabilidad  Formal, encontrará una escala graduada de acuerdo a cada pregunta y deberá marcar con la opción que considere mejor refleja su opinión. 

La escala de opciones está graduada en forma creciente desde el número 1 al 6. Si piensa que no puede opinar, marque en la columna, señalada  “No se aplica”.</td>
                   </tr>
			      </table>
				  <br />
					<hr align="left" width="100%" size="1" noshade="noshade" />
			<br />
			  <p class="Estilo31"><strong><em>1&deg; Dimensión Planificación de la Docencia</em></strong></p>
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
						<td width="40" align="center">No se  aplica</td>
				  </tr>
				  <tr align="justify">
				  		<td width="264" align="justify">1.  En la elaboración del cronograma considera los objetivos generales y específicos, metodologías, criterios de evaluaciones y calificaciones, bibliografía.  </td>
				  		<td width="102" align="center">Considera  muy pocos de estos elementos </td>
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
						<td width="149" align="center">Considera  la mayor&iacute;a o la totalidad de &eacute;stos elementos </td>
						<td width="39" valign="middle"><p align="center">
							<input name="encu[0][I_preg_1]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="264" align="justify">2.  Planifica clase a clase. </td>
				  		<td width="102" align="center">Planifico  muy pocas clases </td>
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
						<td width="149" align="center">Planifico  todas o la mayor&iacute;a de las clases. &nbsp;</td>
						<td width="39" valign="middle"><p align="center">
							<input name="encu[0][I_preg_2]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="264" align="justify">3. La  planificaci&oacute;n est&aacute; ligada con los objetivos generales y espec&iacute;ficos propuestos  en el programa. </td>
				  		<td width="102" align="center">Muy poco  ligada a los objetivos </td>
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
						<td width="149" align="center">Muy  ligada a los objetivos </td>
						<td width="39" valign="middle"><p align="center">
							<input name="encu[0][I_preg_3]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="264" align="justify">4.&nbsp;&nbsp;Existe coherencia  entre lo que planifica y los aprendizajes esperados en el perfil de egreso de  la carrera. </td>
				  		<td width="102" align="center">Muy poca  coherencia con el perfil </td>
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
						<td width="149" align="center">Bastante  coherencia con el perfil </td>
						<td width="39" valign="middle"><p align="center">
							<input name="encu[0][I_preg_4]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="264" align="justify">5.&nbsp;Planifica  y solicita los materiales necesarios para las clases.</td>
				  		<td width="102" align="center">Muy pocas  veces se preocupo de esto.&nbsp; </td>
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
						<td width="149" align="center">Siempre  se preocupo de esto.&nbsp; </td>
						<td width="39" valign="middle"><p align="center">
							<input name="encu[0][I_preg_5]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="264" height="75" align="justify">6. El tiempo  que planifica para cada actividad es el necesario para alcanzar los objetivos  propuestos.  </td>
				  		<td width="102" align="center">Frecuentemente  no le alcanza el tiempo </td>
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
						<td width="149" align="center">Siempre  le alcanza el tiempo </td>
						<td width="39" valign="middle"><p align="center">
							<input name="encu[0][I_preg_6]" type="radio" value="99"/>
						</p></td>
				  </tr>
				 <tr align="justify">
				  		<td width="264" height="75" align="justify">7. Muestra  inter&eacute;s por actualizar contenidos de su asignatura.</td>
				  		<td width="102" align="center">Muy poco  inter&eacute;s</td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_7]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"><p align="center">
						<input name="encu[0][I_preg_7]" type="radio" value="2"/></p></td>
						<td width="29"valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_7]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle"><p align="center">
							<input name="encu[0][I_preg_7]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][I_preg_7]" type="radio" value="5"/>
						</p></td>
						<td width="29" valign="middle"><p align="center">
							<input name="encu[0][I_preg_7]" type="radio" value="6"/>
						</p></td>
						<td width="149" align="center">Mucho  inter&eacute;s</td>
						<td width="39" valign="middle"><p align="center">
							<input name="encu[0][I_preg_7]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="264" height="75" align="justify">8. Actualiza  m&eacute;todos y/o estrategias de aprendizajes utilizados en sus clases.</td>
				  		<td width="102" align="center">Muy poca  actualizaci&oacute;n</td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_8]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"><p align="center">
						<input name="encu[0][I_preg_8]" type="radio" value="2"/></p></td>
						<td width="29"valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_8]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle"><p align="center">
							<input name="encu[0][I_preg_8]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][I_preg_8]" type="radio" value="5"/>
						</p></td>
						<td width="29" valign="middle"><p align="center">
							<input name="encu[0][I_preg_8]" type="radio" value="6"/>
						</p></td>
						<td width="149" align="center">Se actualiza en forma constante </td>
						<td width="39" valign="middle"><p align="center">
							<input name="encu[0][I_preg_8]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="264" height="75" align="justify">9. Revisa y  actualiza la bibliograf&iacute;a de su asignatura, cada dos a&ntilde;os.</td>
				  		<td width="102" align="center">Muy poca  actualizaci&oacute;n </td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_9]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"><p align="center">
						<input name="encu[0][I_preg_9]" type="radio" value="2"/></p></td>
						<td width="29"valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_9]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle"><p align="center">
							<input name="encu[0][I_preg_9]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][I_preg_9]" type="radio" value="5"/>
						</p></td>
						<td width="29" valign="middle"><p align="center">
							<input name="encu[0][I_preg_9]" type="radio" value="6"/>
						</p></td>
						<td width="149" align="center">Se actualiza en forma constante</td>
						<td width="39" valign="middle"><p align="center">
							<input name="encu[0][I_preg_9]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="264" height="75" align="justify">10. Manifiesta  inter&eacute;s en la actualizaci&oacute;n de conocimientos a trav&eacute;s de cursos de  perfeccionamiento y/o obtenci&oacute;n de grados acad&eacute;micos superiores a los que  tiene. </td>
				  		<td width="102" align="center">Muy poco  inter&eacute;s</td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_10]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"><p align="center">
						<input name="encu[0][I_preg_10]" type="radio" value="2"/></p></td>
						<td width="29"valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][I_preg_10]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle"><p align="center">
							<input name="encu[0][I_preg_10]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][I_preg_10]" type="radio" value="5"/>
						</p></td>
						<td width="29" valign="middle"><p align="center">
							<input name="encu[0][I_preg_10]" type="radio" value="6"/>
						</p></td>
						<td width="149" align="center">Mucho  inter&eacute;s</td>
						<td width="39" valign="middle"><p align="center">
							<input name="encu[0][I_preg_10]" type="radio" value="99"/>
						</p></td>
				  </tr>
			  </table> 
			   <br />
			   <table width="100%">
			   <tr>
			    <td width="100%">Creo que las  fortalezas y debilidades en esta dimensi&oacute;n son</td>
			   </tr>
			   <tr>
			      <td width="95%" align="center"><textarea  name="encu[0][I_foraleza_debilidad]" cols="145" rows="4" class="Estilo25" id="TO-N"><%=derh_I_foraleza_debilidad%></textarea>
				</tr>
				</table>
				<br />
				<hr align="left" width="100%" size="1" noshade="noshade" />
				<br />
				<p ><strong><em> 2º Dimensión Responsabilidad Formal:  </em></strong>: 
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
						<td width="40" align="center">No se  aplica</td>
				  </tr>
				  <tr align="justify">
				  		<td width="267" align="justify">1.  &iquest;Ha sido  puntual al comenzar y al finalizar las sesiones de clases? </td>
				  		<td width="102" align="center">Pocas  veces es puntual </td>
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
						<td width="147" align="center">La  mayor&iacute;a de las veces es puntual </td>
						<td width="40" valign="middle"><p align="center">
							<input name="encu[0][II_preg_1]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="267" align="justify">2. Asiste a  reuniones&nbsp; a las que convoca la Direcci&oacute;n  de Escuela.</td>
				  		<td width="102" align="center">Rara vez</td>
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
						<td width="147" align="center">Casi  siempre</td>
						<td width="40" valign="middle"><p align="center">
							<input name="encu[0][II_preg_2]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="267" align="justify">3.  Mantiene  buenas relaciones con el personal administrativo.</td>
				  		<td width="102" align="center">Casi  nunca</td>
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
						<td width="147" align="center">Casi  siempre</td>
						<td width="40" valign="middle"><p align="center">
							<input name="encu[0][II_preg_3]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="267" align="justify">4. Se  relaciona e interact&uacute;a con sus alumnos.</td>
				  		<td width="102" align="center">Casi  nunca</td>
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
						<td width="147" align="center">Casi  siempre</td>
						<td width="40" valign="middle"><p align="center">
							<input name="encu[0][II_preg_4]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="267" align="justify">5. Se  relaciona e interact&uacute;a con el cuerpo acad&eacute;mico de la Escuela. </td>
				  		<td width="102" align="center">Casi  nunca </td>
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
						<td width="147" align="center">Casi  siempre</td>
						<td width="40" valign="middle"><p align="center">
							<input name="encu[0][II_preg_5]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="267" align="justify">6. Tiene  iniciativas para realizar actividades complementarias a la docencia, dentro de  la Escuela.</td>
				  		<td width="102" align="center">Muy poca  iniciativa</td>
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
						<td width="147" align="center">Mucha  iniciativa</td>
						<td width="40" valign="middle"><p align="center">
							<input name="encu[0][II_preg_6]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="267" align="justify">7. Realiza  sugerencias para mejorar la labor administrativa de la Escuela.</td>
				  		<td width="102" align="center">Muy poca  sugerencias</td>
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
						<td width="147" align="center">Muchas  sugerencias</td>
						<td width="40" valign="middle"><p align="center">
							<input name="encu[0][II_preg_7]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="267" align="justify">8. Es  receptivo a las sugerencias de la Direcci&oacute;n de Escuela para mejorar los  aspectos administrativos y acad&eacute;micos.</td>
				  		<td width="102" align="center">Muy poco  receptivo</td>
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
						<td width="147" align="center">Muy  receptivo</td>
						<td width="40" valign="middle"><p align="center">
							<input name="encu[0][II_preg_8]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="267" align="justify">9. Cumple  con los plazos acordados para la entrega de evaluaciones como trabajos y  pruebas de los alumnos.   </td>
				  		<td width="102" align="center"><p>Frecuentemente no cumple con los  plazos </p>
			  		    </td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_9]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"><p align="center">
						<input name="encu[0][II_preg_9]" type="radio" value="2"/></p></td>
						<td width="29"valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_9]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle"><p align="center">
							<input name="encu[0][II_preg_9]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][II_preg_9]" type="radio" value="5"/>
						</p></td>
						<td width="27" valign="middle"><p align="center">
							<input name="encu[0][II_preg_9]" type="radio" value="6"/>
						</p></td>
						<td width="147" align="center">Cumple  con los plazos </td>
						<td width="40" valign="middle"><p align="center">
							<input name="encu[0][II_preg_9]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="267" align="justify">10. Ingresa  las calificaciones al sistema en los plazos establecidos. </td>
				  		<td width="102" align="center">Frecuentemente  no cumple con los plazos</td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_10]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"><p align="center">
						<input name="encu[0][II_preg_10]" type="radio" value="2"/></p></td>
						<td width="29"valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_10]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle"><p align="center">
							<input name="encu[0][II_preg_10]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][II_preg_10]" type="radio" value="5"/>
						</p></td>
						<td width="27" valign="middle"><p align="center">
							<input name="encu[0][II_preg_10]" type="radio" value="6"/>
						</p></td>
						<td width="147" align="center">Cumple  con los plazos</td>
						<td width="40" valign="middle"><p align="center">
							<input name="encu[0][II_preg_10]" type="radio" value="99"/>
						</p></td>
				  </tr>
				  <tr align="justify">
				  		<td width="267" align="justify">11. Entrega a  tiempo documentaci&oacute;n solicitada por la Direcci&oacute;n de Escuela como informes  acad&eacute;micos, calendarizaciones semestrales, etc. </td>
				  		<td width="102" align="center">Frecuentemente  no cumple con los plazos</td>
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_11]" type="radio" value="1"/></p></td>
						<td width="29" valign="middle"><p align="center">
						<input name="encu[0][II_preg_11]" type="radio" value="2"/></p></td>
						<td width="29"valign="middle" bgcolor="#CCCCCC"><p align="center">
						<input name="encu[0][II_preg_11]" type="radio" value="3"/></p></td>
						<td width="29" valign="middle"><p align="center">
							<input name="encu[0][II_preg_11]" type="radio" value="4"/>
						</p></td>
						
						<td width="29" valign="middle" bgcolor="#CCCCCC"><p align="center">
							<input name="encu[0][II_preg_11]" type="radio" value="5"/>
						</p></td>
						<td width="27" valign="middle"><p align="center">
							<input name="encu[0][II_preg_11]" type="radio" value="6"/>
						</p></td>
						<td width="147" align="center">Cumple  con los plazos</td>
						<td width="40" valign="middle"><p align="center">
							<input name="encu[0][II_preg_11]" type="radio" value="99"/>
						</p></td>
				  </tr>
			  </table>
			     <br />
			   <table width="100%">
			   <tr>
			    <td width="100%"><p>Creo  que las fortalezas y debilidades en esta dimensi&oacute;n son:</p></td>
			   </tr>
			   <tr>
			      <td width="95%" align="center"><textarea name="encu[0][II_foraleza_debilidad]" cols="145" rows="4" class="Estilo25" id="TO-N"><%=derh_II_foraleza_debilidad%></textarea>
				</tr>
				</table>
				<br />
				<hr align="left" width="100%" size="1" noshade="noshade" />
				<br />
			  <p class="Estilo31"><strong><em> 3º Dimensión  Aspectos cualitativos</em></strong>: Señale las observaciones que recibe por parte de los estudiantes sobre este docente. Si considera necesario describa las situaciones. </p>
			  <table width="100%">
			   <tr>
			    <td width="100%"><p>a)</p></td>
			   </tr>
			   <tr>
			      <td width="95%" align="center"><textarea name="encu[0][III_a]" cols="145" rows="4" class="Estilo25" id="TO-S"><%=derh_III_a%></textarea>
				</tr>
				</table>
			  <br />
			   <table width="100%">
			   <tr>
			    <td width="100%">b)</td>
			   </tr>
			   <tr>
			      <td width="95%" align="center"><textarea name="encu[0][III_b]" cols="145" rows="4" class="Estilo25" id="TO-S"><%=derh_III_b%></textarea>
				</tr>
				</table>
				<br />
				<table width="100%">
			   <tr>
			    <td width="100%">c)</td>
			   </tr>
			   <tr>
			      <td width="95%" align="center"><textarea name="encu[0][III_c]" cols="145" rows="4" class="Estilo25" id="TO-S"><%=derh_III_c%></textarea>
				</tr>
				</table>
				<br />
		  <hr align="left" width="100%" size="1" noshade="noshade" />
			   <br />
			  
			      <p class="Estilo31"><strong><em> Realice un breve resumen de su opinión acerca del desempeño académico y administrativo de este docente </em></strong></p>
				  
			   <table width="100%">
			   <tr>
			    <td width="100%">&nbsp;</td>
			   </tr>
			   <tr>
			      <td width="95%" align="center"><textarea name="encu[0][IV_foraleza_debilidad]" cols="145" rows="4" class="Estilo25" id="TO-N"><%=derh_IV_foraleza_debilidad%></textarea>
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
												
						<img src="Images/vovler1.png" border="0" width="55" height="55" alt="¿Cómo funciona?">					</td>
					
					<td width="11%" align="center" valign="top" class="Estilo31">
					 
						<a href="javascript:_Guardar(this, document.forms['edicion'], 'edita_encuesta_proc.asp','', 'ValidarMarcados()', '', 'FALSE');">
												
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
