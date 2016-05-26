<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<% 
'------------------------------------------------------
 q_npag	= Request.QueryString("npag")
 traspaso 	= Request.QueryString("traspaso")
 if traspaso = "" then
 	tipo_traspaso="0"
 else
 	tipo_traspaso="1"
 end if	

 
 set conexion = new CConexion
 conexion.Inicializar "upacifico"
 set errores = new CErrores

 set negocio = new CNegocio
 negocio.Inicializa conexion

  q_idal_ncorr = Request.QueryString("idal_ncorr")
 
    response.write(q_idio_ncorr)
	
  if esVacio(q_pers_nrut) then
	 q_pers_nrut = negocio.obtenerUsuario
	 q_pers_xdv = conexion.consultaUno("Select pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
  end if

 
 periodo_actual = "210"

 '-- Botones de la pagina -----------

 

 
 set f_encuesta = new CFormulario
 f_encuesta.Carga_Parametros "encuesta_biblioteca.xml", "encuesta"
 f_encuesta.Inicializar conexion
				
 			muestra="select '' "

	f_encuesta.Consultar muestra
 f_encuesta.Siguiente

 '------------------------------------------------------------------------------------------ 


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Encuesta Biblioteca</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function ValidarMarcados(){

var preg_1
var preg_2 
var preg_3
var preg_4
var preg_5
var preg_6
var preg_7_a
var preg_7_b
var preg_7_c
var preg_7_d
var preg_7_f
var preg_7_g
var preg_7_h
var preg_7_i
var preg_8_a
var preg_8_b
var preg_8_c
var preg_8_d
var preg_8_f
var preg_8_g
var preg_8_h
var preg_8_i
var preg_9_a
var preg_9_b
var preg_9_c
var preg_9_d
var preg_9_f
var preg_9_g
var preg_9_h
var preg_9_i
var preg_10
var preg_11
var preg_12
var preg_13
var preg_14
var preg_15
var preg_16
var preg_17
var preg_18

{ 
  var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  contestada=0;
  cant_radios=0;
  divisor=6;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
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
   alert("Debes selecionar una opcion en la pregunta 1.");
   
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
  divisor=6;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="checkbox")&& 
	(elemento.name!="encu[0][preg_10_a]")&& 
	(elemento.name!="encu[0][preg_10_b]")&& 
	(elemento.name!="encu[0][preg_10_c]")&& 
	(elemento.name!="encu[0][preg_10_d]")&& 
	(elemento.name!="encu[0][preg_10_e]")&& 
	(elemento.name!="encu[0][preg_10_f]")&& 
	(elemento.name!="encu[0][preg_10_g]")&& 
	(elemento.name!="encu[0][preg_14_a]")&& 
	(elemento.name!="encu[0][preg_14_b]")&& 
	(elemento.name!="encu[0][preg_14_c]")&& 
	(elemento.name!="encu[0][preg_14_d]")&& 
	(elemento.name!="encu[0][preg_14_e]")&& 
	(elemento.name!="encu[0][preg_14_f]")&& 
	(elemento.name!="encu[0][preg_14_g]")&& 
	(elemento.name!="encu[0][preg_17_1]")&& 
	(elemento.name!="encu[0][preg_17_2]")&& 
	(elemento.name!="encu[0][preg_17_3]")&&
	(elemento.name!="encu[0][preg_17_4]")&& 
	(elemento.name!="encu[0][preg_17_5]")&& 
	(elemento.name!="encu[0][preg_17_6]")&& 
	(elemento.name!="encu[0][preg_17_7]")&& 
	(elemento.name!="encu[0][preg_17_8]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==2)
  { 
	 preg_2=1
  }
  else
  {
 
  respondidas=2-contestada
   alert('Te faltan  '+ respondidas +' opciones por selecionar en la pregunta 2.');
   preg_2=0
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
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_3]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_3=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 3.");
   
  }
}
//
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
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_4]"))
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
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
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
  divisor=4;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
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
  divisor=3;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_7_a]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_7_a=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 7 letra a.");
   
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
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_7_b]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_7_b=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 7 letra b.");
   
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
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_7_c]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_7_c=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 7 letra c.");
   
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
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_7_d]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_7_d=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 7 letra d.");
   
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
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_7_e]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_7_e=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 7 letra e.");
   
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
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_7_f]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_7_f=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 7 letra f.");
   
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
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_7_g]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_7_g=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 7 letra g.");
   
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
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_7_h]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_7_h=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 7 letra h.");
   
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
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_7_i]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_7_i=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 7 letra i.");
   
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
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_8_a]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_8_a=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 8 letra a.");
   
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
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_8_b]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_8_b=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 8 letra b.");
   
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
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_8_c]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_8_c=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 8 letra c.");
   
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
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_8_d]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_8_d=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 8 letra d.");
   
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
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_8_e]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_8_e=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 8 letra e.");
   
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
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_8_f]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_8_f=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 8 letra f.");
   
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
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_8_g]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_8_g=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 8 letra g.");
   
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
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_9_a]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_9_a=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 9 letra a.");
   
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
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_9_b]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_9_b=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 9 letra b.");
   
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
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_9_c]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_9_c=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 9 letra c.");
   
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
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_9_d]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_9_d=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 9 letra d.");
   
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
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_9_e]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_9_e=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 9 letra e.");
   
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
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_9_f]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_9_f=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 9 letra f.");
   
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
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_9_g]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_9_g=1
  }
  else
  {
   alert("Debes selecionar una opcion en la pregunta 9 letra g.");
   
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
  divisor=7;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="checkbox")&& 
	(elemento.name!="encu[0][preg_2_1]")&& 
	(elemento.name!="encu[0][preg_2_2]")&& 
	(elemento.name!="encu[0][preg_2_3]")&& 
	(elemento.name!="encu[0][preg_2_4]")&& 
	(elemento.name!="encu[0][preg_2_5]")&& 
	(elemento.name!="encu[0][preg_2_6]")&& 
	(elemento.name!="encu[0][preg_14_a]")&& 
	(elemento.name!="encu[0][preg_14_b]")&& 
	(elemento.name!="encu[0][preg_14_c]")&& 
	(elemento.name!="encu[0][preg_14_d]")&& 
	(elemento.name!="encu[0][preg_14_e]")&& 
	(elemento.name!="encu[0][preg_14_f]")&& 
	(elemento.name!="encu[0][preg_14_g]")&& 
	(elemento.name!="encu[0][preg_17_1]")&& 
	(elemento.name!="encu[0][preg_17_2]")&& 
	(elemento.name!="encu[0][preg_17_3]")&&
	(elemento.name!="encu[0][preg_17_4]")&& 
	(elemento.name!="encu[0][preg_17_5]")&& 
	(elemento.name!="encu[0][preg_17_6]")&& 
	(elemento.name!="encu[0][preg_17_7]")&& 
	(elemento.name!="encu[0][preg_17_8]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada>0)
  { 
	 preg_10=1
  }
  else
  {
 
  respondidas=2-contestada
   alert('Debes selecionar al menos una opcion en la pregunta 10.');
   preg_10=0
  }
  if (elemento.name!="encu[0][preg_10_g]")
  {
  var valor;
  valor=7
  validarcheckbo3(valor);
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
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_11]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_11=1
  }
  else
  {
  alert("Debes selecionar una opcion en la pregunta 11.");
   
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
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_12]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_12=1
  }
  else
  {
  alert("Debes selecionar una opcion en la pregunta 12.");
   
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
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_13]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_13=1
  }
  else
  {
  alert("Debes selecionar una opcion en la pregunta 13.");
   
  }
}

{ 
  var cantidad;
  var elemento;
  var contestada;
  var cant_radios;
  var divisor;
  var i; 
  var respuestas;
  var respondidas;
  contestada=0;
  cant_radios=0;
  divisor=7;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.encuesta.length;
  valor=elemento.value;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="checkbox")&& 
	(elemento.name!="encu[0][preg_2_1]")&& 
	(elemento.name!="encu[0][preg_2_2]")&& 
	(elemento.name!="encu[0][preg_2_3]")&& 
	(elemento.name!="encu[0][preg_2_4]")&& 
	(elemento.name!="encu[0][preg_2_5]")&& 
	(elemento.name!="encu[0][preg_2_6]")&& 
	(elemento.name!="encu[0][preg_10_a]")&& 
	(elemento.name!="encu[0][preg_10_b]")&& 
	(elemento.name!="encu[0][preg_10_c]")&& 
	(elemento.name!="encu[0][preg_10_d]")&& 
	(elemento.name!="encu[0][preg_10_e]")&& 
	(elemento.name!="encu[0][preg_10_f]")&& 
	(elemento.name!="encu[0][preg_10_g]")&& 
	(elemento.name!="encu[0][preg_17_1]")&& 
	(elemento.name!="encu[0][preg_17_2]")&& 
	(elemento.name!="encu[0][preg_17_3]")&&
	(elemento.name!="encu[0][preg_17_4]")&& 
	(elemento.name!="encu[0][preg_17_5]")&& 
	(elemento.name!="encu[0][preg_17_6]")&& 
	(elemento.name!="encu[0][preg_17_7]")&& 
	(elemento.name!="encu[0][preg_17_8]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada>0)
  { 
	 preg_14=1
	 
  }
  else
  {
 
  respondidas=2-contestada
   alert('Debes selecionar al menos una opcion en la pregunta 14.');
   preg_14=0
  }
  
  if (elemento.name!="encu[0][preg_14_g]")
  {
  var valor;
  valor=7
  validarcheckbo4(valor);
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
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_15]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_15=1
  }
  else
  {
  alert("Debes selecionar una opcion en la pregunta 15.");
   
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
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_16]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_16=1
  }
  else
  {
  alert("Debes selecionar una opcion en la pregunta 16.");
   
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
  divisor=7;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="checkbox")&& 
	(elemento.name!="encu[0][preg_2_1]")&& 
	(elemento.name!="encu[0][preg_2_2]")&& 
	(elemento.name!="encu[0][preg_2_3]")&& 
	(elemento.name!="encu[0][preg_2_4]")&& 
	(elemento.name!="encu[0][preg_2_5]")&& 
	(elemento.name!="encu[0][preg_2_6]")&& 
	(elemento.name!="encu[0][preg_10_a]")&& 
	(elemento.name!="encu[0][preg_10_b]")&& 
	(elemento.name!="encu[0][preg_10_c]")&& 
	(elemento.name!="encu[0][preg_10_d]")&& 
	(elemento.name!="encu[0][preg_10_e]")&& 
	(elemento.name!="encu[0][preg_10_f]")&& 
	(elemento.name!="encu[0][preg_10_g]")&& 
	(elemento.name!="encu[0][preg_14_a]")&& 
	(elemento.name!="encu[0][preg_14_b]")&& 
	(elemento.name!="encu[0][preg_14_c]")&&
	(elemento.name!="encu[0][preg_14_e]")&& 
	(elemento.name!="encu[0][preg_14_d]")&& 
	(elemento.name!="encu[0][preg_14_f]")&& 
	(elemento.name!="encu[0][preg_14_g]")&& 
	(elemento.name!="encu[0][preg_14_h]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==2)
  { 
	 preg_17=1
  }
  else
  {
 
  respondidas=2-contestada
   alert('Te faltan  '+ respondidas +' opciones por selecionar en la pregunta 17.');
   preg_17=0
  }
}


if ((preg_1==1) && (preg_2==1)&& (preg_3==1)&& (preg_4==1)&& (preg_5==1)&& (preg_6==1)&& (preg_7_a==1)&& (preg_7_b==1)&& (preg_7_c==1)&& (preg_7_d==1)&& (preg_7_e==1)&& (preg_7_f==1)&& (preg_7_g==1)&& (preg_7_h==1)&& (preg_7_i==1)&& (preg_8_a==1)&& (preg_8_b==1)&& (preg_8_c==1)&& (preg_8_d==1)&& (preg_8_e==1)&& (preg_8_f==1)&& (preg_8_g==1)&& (preg_9_a==1)&& (preg_9_b==1)&& (preg_9_c==1)&& (preg_9_d==1)&& (preg_9_e==1)&& (preg_9_f==1)&& (preg_9_g==1)&& (preg_10==1)&& (preg_11==1)&& (preg_12==1)&& (preg_13==1)&& (preg_14==1)&& (preg_15==1)&& (preg_16==1)&& (preg_17==1))
{
//alert('aaaaaa');
 	return true;
}
else
{
	//alert('bbbbbb');
	return false;
}

}





var maxi2=2;
var maxi=2;
//El contador es un arrayo de forma que cada posición del array es una linea del formulario 

var contador=new Array(0,0); 
var contador2=new Array(0,0); 

function validarcheckbo(preg,grupo) { 
   //Compruebo si la casilla está marcada
   
   elemento=preg.name;

    //alert(elemento);
    check=document.encuesta.elements[elemento];
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

function validarcheckbo2(preg2,grupo2) { 
   //Compruebo si la casilla está marcada
   
   elemento2=preg2.name;

    //alert(elemento);
    check=document.encuesta.elements[elemento2];
   //alert(check.checked);
   if (check.checked==true ){ 
       //está marcada, entonces aumento en uno el contador del grupo 
      contador2[grupo2]++; 
       //compruebo si el contador ha llegado al máximo permitido 
       if (contador2[grupo2]>maxi2) { 
          //si ha llegado al máximo, muestro mensaje de error 
        alert('No se pueden elegir más de '+maxi2+' casillas a la vez.'); 
          //desmarco la casilla, porque no se puede permitir marcar 
         check.checked=false; 
          //resto una unidad al contador de grupo, porque he desmarcado una casilla 
          contador2[grupo2]--; 
       } 
  }else { 
       //si la casilla no estaba marcada, resto uno al contador de grupo 
       contador2[grupo2]--; 
   } 
   
    
}

function valida_preg_3_otro(valor)
{
//alert("valor "+valor);
	if (valor ==7)
	{
		
		document.encuesta.elements["encu[0][preg_3_otro]"].disabled=false;	
		
	}
	else
	{
			
		document.encuesta.elements["encu[0][preg_3_otro]"].disabled=true;
	}

}
function valida_preg_4_otro(valor)
{
//alert("valor "+valor);
	if (valor ==7)
	{
		
		document.encuesta.elements["encu[0][preg_4_otro]"].disabled=false;	
		
	}
	else
	{
			
		document.encuesta.elements["encu[0][preg_4_otro]"].disabled=true;
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
  divisor=7;//cantidad de alternativas de respuesta por pregunta
  cantidad=document.encuesta.length;
  for(i=0;i<cantidad;i++)
  {
  elemento=document.encuesta.elements[i];
  	if ((elemento.type=="checkbox")&& 
	(elemento.name!="encu[0][preg_2_1]")&& 
	(elemento.name!="encu[0][preg_2_2]")&& 
	(elemento.name!="encu[0][preg_2_3]")&& 
	(elemento.name!="encu[0][preg_2_4]")&& 
	(elemento.name!="encu[0][preg_2_5]")&& 
	(elemento.name!="encu[0][preg_2_6]")&& 
	(elemento.name!="encu[0][preg_10_a]")&& 
	(elemento.name!="encu[0][preg_10_b]")&& 
	(elemento.name!="encu[0][preg_10_c]")&& 
	(elemento.name!="encu[0][preg_10_d]")&& 
	(elemento.name!="encu[0][preg_10_e]")&& 
	(elemento.name!="encu[0][preg_10_f]")&& 
	(elemento.name!="encu[0][preg_10_g]")&& 
	(elemento.name!="encu[0][preg_14_a]")&& 
	(elemento.name!="encu[0][preg_14_b]")&& 
	(elemento.name!="encu[0][preg_14_c]")&&
	(elemento.name!="encu[0][preg_14_e]")&& 
	(elemento.name!="encu[0][preg_14_d]")&& 
	(elemento.name!="encu[0][preg_14_f]")&& 
	(elemento.name!="encu[0][preg_14_g]")&& 
	(elemento.name!="encu[0][preg_14_h]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==2)
  { 
	 preg_17=1
  }
  else
  {
 
  respondidas=2-contestada
   alert('Te faltan  '+ respondidas +' opciones por selecionar en la pregunta 17.');
   preg_17=0
  }
}

function validarcheckbo3(valor) { 
   
   //alert("valor "+valor);
   if (valor==7)
   
   {
   document.encuesta.elements["encu[0][preg_10_a]"].checked=true;
   document.encuesta.elements["encu[0][preg_10_b]"].checked=true;
   document.encuesta.elements["encu[0][preg_10_c]"].checked=true;
   document.encuesta.elements["encu[0][preg_10_d]"].checked=true;
   document.encuesta.elements["encu[0][preg_10_e]"].checked=true;
   document.encuesta.elements["encu[0][preg_10_f]"].checked=true;
   
   }
   else
   {
   }
}

function validarcheckbo4(valor) { 
   
   //alert("valor "+valor);
   if (valor==7)
   
   {
      
   }
   else
   {
   }
}
</script>
<style type="text/css">
#menu div.barraMenu,
#menu div.barraMenu a.botonMenu {
font-family: sans-serif, Verdana, Arial;
font-size: 8pt;
color: white;
}

#menu div.barraMenu {
text-align: left;
}

#menu div.barraMenu a.botonMenu {
background-color: #4b73a6;
border-bottom-style:double;
border-color:#FFFFFF;
color: white;
cursor: pointer;
padding: 4px 6px 2px 5px;
text-decoration: none;
}

#menu div.barraMenu a.botonMenu:hover {
background-color: #FFFFFF;
color:#4b73a6;
}

#menu div.barraMenu a.botonMenu:active {
background-color: #637D4D;
color: black;
}
</style>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#CC6600" background="imagenes/fondo.jpg">
<center>


<form name="encuesta">
<input type="hidden" name="encu[0][pers_nrut]" value="<%=q_pers_nrut%>">
<table align="center" width="700">
	<tr>
		<td width="100%" align="left">
			<table width="685" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6" align="center">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="98%" border="0" bgcolor="#f7faff">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="40%" height="21"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Encuesta</strong></font></td>
										   <td><hr></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="97%" border="0" cellpadding="1" cellspacing="3">
									  <tr> 
										<td height="20" colspan="2"><p class="Estilo31"><strong><font size="3" face="Courier New, Courier, mono" color="#496da6">Estimado alumno: 

Agradecemos destines algunos minutos para responder la Encuesta del Sistema de Bibliotecas.

La información que nos proporciones, nos permitirá, evaluar el servicio que te ofrecemos y contribuir a mejorar la calidad del mismo
<br>
<br>Sistema de Bibliotecas

</font></strong></p></td>
										<td width="10%" height="38" colspan="4">
										        <%POS_IMAGEN = 0%>
								        <a href="javascript:ayuda(1)"
												onMouseOver="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda2.png';return true "
												onMouseOut="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/ayuda1.png';return true "><img src="imagenes/ayuda1.png" border="0" width="38" height="38" alt="¿Cómo funciona?"></a></td>
									  </tr>
									  
									  <tr>
									  <td colspan="6">
									  
									  </td>
									   </tr>
									   <tr>
									   <td height="31" colspan="6">&nbsp;</td>
									   </tr>
									  <tr> 
										
										<td colspan="6" ><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>1.	¿Con qué frecuencia vas a la biblioteca?</strong></font></td>
									  </tr>
									  <tr valign="top"> 
											<td colspan="6" height="20"> 
												<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#f7faff" align="center">
				 
					 	<tr>
						<td width="2%"></td>
					<td width="62%" align="left" valign="top" ><font size="2" face="Courier New, Courier, mono" color="#496da6">a) Una vez al semestre</font> </td>
					<td width="3%" align="center" valign="top" bgcolor="#f7faff"><font size="2" color="#ffffff">
					  <input type="radio" name="encu[0][preg_1]" value="1" /></font></td>
					  <td width="33%" colspan="3"></td>
					    </tr>
						<tr>
						<td></td>
					<td width="62%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">b) Una vez al mes</font></td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_1]" value="2"  />
					</font></td>
					<td width="33%" colspan="3"></td>
					 	</tr>
						 <tr>
						 <td></td>
					<td width="62%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">c)	Una vez a la semana</font></td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_1]" value="3" />
					</font></td>
					<td width="33%" colspan="3"></td>
						 </tr>
						  <tr>
						  <td></td>
						<td width="62%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">d)	Entre dos o tres veces a la semana</font></td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_1]" value="4" /></font></td>
					   <td width="33%" colspan="3"></td>
					</tr>
				 			  
				    <tr>
					<td></td>
					<td width="62%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">e)	Prácticamente todos los días</font></td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_1]" value="5" /></font></td>
					   <td width="33%" colspan="3"></td>
					 </tr>
					  <tr>
					  <td></td>
					<td width="62%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">f)	Nunca</font></td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_1]" value="6" /></font></td>
					   <td width="33%" colspan="3"></td>
					  </tr>
				</table>											</td>
									  </tr>
									    <tr> 
										<td colspan="6" height="10">&nbsp;</td>
									  </tr>
                                      <tr> 
										<td colspan="6" height="10"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>2.	¿ A qué vas a biblioteca?. Elige las dos que más te representen. </strong></font></td>
									  </tr>
									   <tr valign="top"> 
											<td colspan="6" height="20"> 
												<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#f7faff">
                  <tr>
				   <td width="2%" align="left" valign="top" bgcolor="#f7faff"></td>
                    <td width="62%" align="left" valign="top" bgcolor="#f7faff" ><font size="2" face="Courier New, Courier, mono" color="#496da6">a)	Solicitar material bibliográfico</font></td>
					
                    <td width="3%" align="left" valign="top" bgcolor="#f7faff"><font size="2" color="#000000">
                      <input type="checkbox" name="encu[0][preg_2_1]" value="1" onclick='validarcheckbo2(this,0)'  />
                    </font></td>
					<td width="33%" colspan="3"></td>
					</tr>
					<tr>
					<td width="2%" align="left" valign="top" bgcolor="#f7faff"></td>
                    <td width="62%" align="left" valign="top" bgcolor="#f7faff" ><font size="2" face="Courier New, Courier, mono" color="#496da6">b)	A estudiar solo</font></td>
                    <td width="3%" align="left" valign="top" bgcolor="#f7faff"><font size="2" color="#000000">
                      <input type="checkbox" name="encu[0][preg_2_2]" value="2" onclick='validarcheckbo2(this,0)'   />
                    </font></td>
                   
                   <td width="33%" colspan="3"></td>
                  </tr>
                  <tr>
				   <td width="2%" align="left" valign="top" bgcolor="#f7faff"></td>
                    <td width="62%" align="left" valign="top" bgcolor="#f7faff" ><font size="2" face="Courier New, Courier, mono" color="#496da6">c)	A estudiar en grupo</font></td>
                    <td width="3%" align="left" valign="top" bgcolor="#f7faff"><font size="2" color="#000000">
                      <input type="checkbox" name="encu[0][preg_2_3]" value="3" onclick='validarcheckbo2(this,0)'    />
                    </font></td>
					<td width="33%" colspan="3"></td>
					</tr>
                  <tr>
					  <td width="2%" align="left" valign="top" bgcolor="#f7faff"></td>
                    <td width="62%" align="left" valign="top" bgcolor="#f7faff" ><font size="2" face="Courier New, Courier, mono" color="#496da6">d)	A buscar información en diarios,Internet,etc.</font></td>
                    <td width="3%" align="left" valign="top" bgcolor="#f7faff"><font size="2" color="#000000">
                      <input type="checkbox" name="encu[0][preg_2_4]" value="4" onclick='validarcheckbo2(this,0)'  />
                    </font></td>
                  
                   <td width="33%" colspan="3"></td>
                  </tr>
                  <tr>
				   <td width="2%" align="left" valign="top" bgcolor="#f7faff"></td>
                    <td width="62%" align="left" valign="top" bgcolor="#f7faff" ><font size="2" face="Courier New, Courier, mono" color="#496da6">e)	A hacer trabajos</font></td>
                    <td width="3%" align="left" valign="top" bgcolor="#f7faff"class="Estilo31"><font size="2" color="#000000">
                      <input type="checkbox" name="encu[0][preg_2_5]" value="5" onclick='validarcheckbo2(this,0)'  />
                    </font></td>
					<td width="33%" colspan="3"></td>
					</tr>
                  <tr>
					<td width="2%" align="left" valign="top" bgcolor="#f7faff"></td>
                    <td width="62%" align="left" valign="top" bgcolor="#f7faff" ><font size="2" face="Courier New, Courier, mono" color="#496da6">f)	A descansar y recrearme</font></td>
					
                    <td width="3%" align="left" valign="top" bgcolor="#f7faff"><font size="2" color="#000000">
                      <input type="checkbox" name="encu[0][preg_2_6]" value="6" onclick='validarcheckbo2(this,0)'   />
                    </font></td>
                    
                    <td width="33%" colspan="3"></td>
                  </tr>
                </table>											</td>
									  </tr>
									  <tr> 
										<td height="23" colspan="6"></td>
									  </tr>
									  <tr valign="top"> 
											<td height="20" colspan="6"> 
												 <table width="100%" border="0" cellpadding="0" cellspacing="0">
													<tr> 
													 <td height="20" bordercolor="#CCCCCC" ><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>3.	En caso de no ser usuario habitual ¿Por qué razón no vas más seguido?</strong></font></td>
													</tr>
											  </table>											</td>
									  </tr>
									   <tr valign="top"> 
											<td colspan="6" height="20"> 
												<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#f7faff" align="center">
				 
					 	<tr>
						<td width="2%"></td>
					<td width="62%" align="left" valign="top" ><font size="2" face="Courier New, Courier, mono" color="#496da6">a) Por falta de tiempo</font> </td>
					<td width="3%" align="center" valign="top" bgcolor="#f7faff"><font size="2" color="#ffffff">
					  <input type="radio" name="encu[0][preg_3]" value="1" onclick='valida_preg_3_otro(this.value);' /></font></td>
					 <td width="33%" colspan="3"></td>
					    </tr>
						<tr>
						<td></td>
					<td width="62%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">b) Porque no lo necesito</font></td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_3]" value="2"  onclick='valida_preg_3_otro(this.value);'/>
					</font></td>
					 <td width="33%" colspan="3"></td>
					 	</tr>
						 <tr>
						 <td></td>
					<td width="62%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">c)	No me gusta la biblioteca</font></td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_3]" value="3" onclick='valida_preg_3_otro(this.value);'/>
					</font></td>
					 <td width="33%" colspan="3"></td>
						 </tr>
						  <tr>
						  <td></td>
						<td width="62%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">d)	Porque no me satisface la colección</font></td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_3]" value="4" onclick='valida_preg_3_otro(this.value);'/></font></td>
					   <td width="33%" colspan="3"></td>
					</tr>
				 			  
				    <tr>
					<td></td>
					<td width="62%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">e)	Porque no dan buena atención</font></td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_3]" value="5" onclick='valida_preg_3_otro(this.value);'/></font></td>
					   <td width="33%" colspan="3"></td>
					 </tr>
					  <tr>
					  <td></td>
					<td width="62%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">f)	Consigo los libros en otras partes</font></td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_3]" value="6" onclick='valida_preg_3_otro(this.value);'/></font></td>
					   <td width="33%" colspan="3"></td>
					  </tr>
					    <tr>
					  <td></td>
					<td width="62%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">g)	Otras (especificar)</font></td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_3]" value="7" onclick='valida_preg_3_otro(this.value);'/></font></td>
					   <td width="33%" colspan="3"></td>
					  </tr>
				</table>											</td>
									  </tr>
									   <tr> 
										<td width="3%" colspan="1"></td>
										<td width="87%" colspan="1" > <%f_encuesta.DibujaCampo("preg_3_otro")%></td>
										<td colspan="4"></td>
									  </tr>
									   <tr> 
										<td colspan="6" height="10">&nbsp;</td>
									  </tr>
                                      <tr> 
										<td colspan="6" height="10"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>4.	¿ Qué problemas has tenido al buscar los libros? </strong></font></td>
									  </tr>
									    <tr> 
										<td colspan="6" height="10"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#f7faff" align="center">
				 
					 	<tr>
						<td width="2%"></td>
					<td width="62%" align="left" valign="top" ><font size="2" face="Courier New, Courier, mono" color="#496da6">a) No sé como buscar en el computador</font> </td>
					<td width="3%" align="center" valign="top" bgcolor="#f7faff"><font size="2" color="#ffffff">
					  <input type="radio" name="encu[0][preg_4]" value="1" onclick='valida_preg_4_otro(this.value);'/></font></td>
					  <td width="33%" colspan="3"></td>
					    </tr>
						<tr>
						<td></td>
					<td width="62%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">b) No aparece el libro en la base de datos</font></td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_4]" value="2" onclick='valida_preg_4_otro(this.value);'  />
					</font></td>
					 <td width="33%" colspan="3"></td>
					 	</tr>
						 <tr>
						 <td></td>
					<td width="62%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">c)	El libro no se puede llevar</font></td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_4]" value="3" onclick='valida_preg_4_otro(this.value);'/>
					</font></td>
					 <td width="33%" colspan="3"></td>
						 </tr>
						  <tr>
						  <td></td>
						<td width="62%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">d)	No hay suficientes copias de los libros</font></td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_4]" value="4"onclick='valida_preg_4_otro(this.value);' /></font></td>
					   <td width="33%" colspan="3"></td>
					</tr>
				 			  
				    <tr>
					<td></td>
					<td width="62%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">e)	Porque no dan buena atención</font></td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_4]" value="5" onclick='valida_preg_4_otro(this.value);'/></font></td>
					   <td width="33%" colspan="3"></td>
					 </tr>
					  <tr>
					  <td></td>
					<td width="62%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">f)	No he tenido problemas</font></td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_4]" value="6" onclick='valida_preg_4_otro(this.value);'/></font></td>
					   <td width="33%" colspan="3"></td>
					  </tr>
					    <tr>
					  <td></td>
					<td width="62%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">g)	Otras (especificar)</font></td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_4]" value="7" onclick='valida_preg_4_otro(this.value);' /></font></td>
					   <td width="33%" colspan="3"></td>
					  </tr>
					  
				    
				</table></td>
									  </tr>
									 
									    <tr> 
										<td width="3%" colspan="1"></td>
										<td width="87%" colspan="1" > <%f_encuesta.DibujaCampo("preg_4_otro")%></td>
										<td colspan="4"></td>
									  </tr>
									  <tr> 
										<td colspan="6" height="10">&nbsp;</td>
									  </tr>
                                      <tr> 
										<td colspan="6" height="10"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>5.	¿Cuánto tiempo te toma un trámite de préstamo en biblioteca? </strong></font></td>
									  </tr>
									   <tr> 
										<td colspan="6" height="10"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#f7faff" align="center">
				 
					 	<tr>
						<td width="2%"></td>
					<td width="62%" align="left" valign="top" ><font size="2" face="Courier New, Courier, mono" color="#496da6">a) Menos de un minuto</font> </td>
					<td width="3%" align="center" valign="top" bgcolor="#f7faff"><font size="2" color="#ffffff">
					  <input type="radio" name="encu[0][preg_5]" value="1" /></font></td>
					  <td width="33%" colspan="3"></td>
					    </tr>
						<tr>
						<td></td>
					<td width="62%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">b) Menos de 5 minutos</font></td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_5]" value="2"  />
					</font></td>
					 <td width="33%" colspan="3"></td>
					 	</tr>
						 <tr>
						 <td></td>
					<td width="62%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">c)	Entre 5 y 10 minutos</font></td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_5]" value="3" />
					</font></td>
					 <td width="33%" colspan="3"></td>
						 </tr>
						  <tr>
						  <td></td>
						<td width="62%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">d)	Más de 10 minutos</font></td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_5]" value="4" /></font></td>
					   <td width="33%" colspan="3"></td>
					</tr>
				</table></td>
									  </tr>
									  
									   <tr> 
										<td colspan="6" height="10">&nbsp;</td>
									  </tr>
                                      <tr> 
										<td colspan="6" height="10"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>6.	¿Cuáles son las sanciones que se aplican por retraso en la devolución? </strong></font></td>
									  </tr>
									    <tr> 
										<td colspan="6" height="10"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#f7faff" align="center">
				 
					 	<tr>
						<td width="2%"></td>
					<td width="62%" align="left" valign="top" ><font size="2" face="Courier New, Courier, mono" color="#496da6">a) Multa</font> </td>
					<td width="3%" align="center" valign="top" bgcolor="#f7faff"><font size="2" color="#ffffff">
					  <input type="radio" name="encu[0][preg_6]" value="1" /></font></td>
					  <td width="33%" colspan="3"></td>
					    </tr>
						<tr>
						<td></td>
					<td width="62%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">b) Suspensión</font></td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_6]" value="2"  />
					</font></td>
					   <td width="33%" colspan="3"></td>
					 	</tr>
						 <tr>
						 <td></td>
					<td width="62%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">c)	Multa y suspensión</font></td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_6]" value="3" />
					</font></td>
					   <td width="33%" colspan="3"></td>
						 </tr>
						  <tr>
						  <td></td>
						<td width="62%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">d)	Ninguna</font></td>
					<td width="3%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
					  <input type="radio" name="encu[0][preg_6]" value="4" /></font></td>
					     <td width="33%" colspan="3"></td>
					</tr>
				 			  
				    
					  
				    
				</table></td>
									  </tr>
									  
									  <tr> 
										<td colspan="6" height="10">&nbsp;</td>
									  </tr>
                                      <tr> 
										<td colspan="6" height="10"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>7.	¿Cómo evalúas las condiciones de la sala de lectura? </strong></font></td>
									  </tr>
									  <tr>
									  	<td colspan="6">
											<table>
												<tr>
										 <td width="3" ></td>
				 <td width="380" align="left" valign="top" bgcolor="f7faff" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong></font></td>
				  	<td width="40" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">Bueno</font></td>
						<td width="56" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">Regular</font></td>
						<td width="32" align="left" valign="top"  bgcolor="#f7faff"class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">Malo</font></td>
                        <td width="98"></td>
				 </tr>
									    <tr>
										 <td width="3"></td>
				 <td width="380" align="left" valign="top" bgcolor="f7faff" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>a.	Mobiliario</font></td>
				  	<td width="40" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_7_a]" type="radio" value="1"  />
					</p></td>
						<td width="56" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_7_a]" type="radio" value="2"  />
					</p></td>
						<td width="32" align="left" valign="top"  bgcolor="#f7faff"class="Estilo31"><p align="center">
						<input name="encu[0][preg_7_a]" type="radio" value="3"  />
					</p></td>
 <td width="98"></td>
				 </tr>
				 <tr>
				  <td width="3"></td>
				 <td width="380" align="left" valign="top" bgcolor="f7faff" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>b.	Espacio	</font></td>
				  	<td width="40" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
				  	  <input name="encu[0][preg_7_b]" type="radio" value="1"  />
				  	</p></td>
						<td width="56" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_7_b]" type="radio" value="2"  />
					</p></td>
						<td width="32" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_7_b]" type="radio" value="3"  />
					</p></td>
					 <td width="98"></td>
				 </tr>
				  <tr>
				   <td width="3"></td>
				 <td width="380" align="left" valign="top" bgcolor="f7faff"class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>c.	Capacidad</font></td>
				  	<td width="40" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_7_c]" type="radio" value="1"  />
					</p></td>
						<td width="56" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_7_c]" type="radio" value="2"  />
					</p></td>
						<td width="32" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_7_c]" type="radio" value="3"  />
					</p></td>
 <td width="98"></td>
				 </tr>
				  <tr>
				   <td width="3"></td>
				 <td width="380" align="left" valign="top" bgcolor="f7faff" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>d.	Luz natural </font></td>
				  
				  	<td width="40" align="center" valign="top"bgcolor="#f7faff"  class="Estilo31"><p align="center">
				  	  <input name="encu[0][preg_7_d]" type="radio" value="1"  />
				  	</p></td>
						<td width="56" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						  <input name="encu[0][preg_7_d]" type="radio" value="2"  />
						</p></td>
						<td width="32" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_7_d]" type="radio" value="3"  />
					</p></td>
				 <td width="98"></td>
				 </tr>
				  <tr>
				   <td width="3"></td>
				 <td width="380" align="left" valign="top" bgcolor="f7faff" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>e.	Luz artificial</font></td>
				  	<td width="40" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_7_e]" type="radio" value="1"  />
					</p></td>
						<td width="56" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_7_e]" type="radio" value="2"  />
					</p></td>
						<td width="32" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_7_e]" type="radio" value="3"  />
					</p></td>
				 <td width="98"></td>
				 </tr>
				  <tr>
				   <td width="3"></td>
				 <td width="380" align="left" valign="top" bgcolor="f7faff" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong> f.	Ventilación</font></td>
				  	<td width="40" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_7_f]" type="radio" value="1"  />
					</p></td>
						<td width="56" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_7_f]" type="radio" value="2"  />
					</p></td>
						<td width="32" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_7_f]" type="radio" value="3"  />
					</p></td>
				 <td width="98"></td>
				 </tr>
				  <tr>
				   <td width="3"></td>
				 <td width="380" align="left" valign="top" bgcolor="f7faff" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>g.	Temperatura</font></td>
				  	<td width="40" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_7_g]" type="radio" value="1"  />
					</p></td>
						<td width="56" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_7_g]" type="radio" value="2"  />
					</p></td>
						<td width="32" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_7_g]" type="radio" value="3"  />
					</p></td>
				 <td width="98"></td>
				 </tr>
				  <tr>
				   <td width="3"></td>
				 <td width="380" align="left" valign="top" bgcolor="f7faff" class="Estilo31" ><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>h.	Nivel de ruido</font></td>
				  	<td width="40" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_7_h]" type="radio" value="1"  />
					</p></td>
						<td width="56" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_7_h]" type="radio" value="2"  />
					</p></td>
						<td width="32" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_7_h]" type="radio" value="3"  />
					</p></td>
					 <td width="98"></td>
				 </tr>
				  <tr>
				   <td width="3"></td>
				 <td width="380" align="left" valign="top" bgcolor="f7faff" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>i.	Aseo	</font></td>
				  	<td width="40" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_7_i]" type="radio" value="1"  />
					</p></td>
						<td width="56" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_7_i]" type="radio" value="2"  />
					</p></td>
						<td width="32" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_7_i]" type="radio" value="3"  />
					</p></td>
				 <td width="98"></td>
				 </tr>
												
											</table>
										</td>
									  </tr>
									  <tr> 
										<td height="23" colspan="6"></td>
									  </tr>
									  <tr> 
										<td colspan="6" height="10"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>8.	¿Cómo evalúas al personal? </strong></font></td>
									  </tr>
									     <tr>
										 	<td colspan="6">
										 		<table>
										 			<tr>
										 <td width="3"></td>
				 <td width="381" align="left" valign="top" bgcolor="f7faff" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong></font></td>
				  	<td width="40" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">Bueno</font></td>
						<td width="56" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">Regular</font></td>
						<td width="32" align="left" valign="top"  bgcolor="#f7faff"class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">Malo</font></td>
                        <td width="97"></td>
				 </tr>
									    <tr>
										 <td width="3"></td>
				 <td width="381" align="left" valign="top" bgcolor="f7faff" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>a.	Atención</font></td>
				  	<td width="40" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_8_a]" type="radio" value="1"  />
					</p></td>
						<td width="56" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_8_a]" type="radio" value="2"  />
					</p></td>
						<td width="32" align="left" valign="top"  bgcolor="#f7faff"class="Estilo31"><p align="center">
						<input name="encu[0][preg_8_a]" type="radio" value="3"  />
					</p></td>
 <td width="97"></td>
				 </tr>
				 <tr>
				  <td width="3"></td>
				 <td width="381" align="left" valign="top" bgcolor="f7faff" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>b.	Rapidez	</font></td>
				  	<td width="40" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
				  	  <input name="encu[0][preg_8_b]" type="radio" value="1"  />
				  	</p></td>
						<td width="56" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_8_b]" type="radio" value="2"  />
					</p></td>
						<td width="32" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_8_b]" type="radio" value="3"  />
					</p></td>
					 <td width="97"></td>
				 </tr>
				  <tr>
				   <td width="3"></td>
				 <td width="381" align="left" valign="top" bgcolor="f7faff"class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>c.	Presentación</font></td>
				  	<td width="40" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_8_c]" type="radio" value="1"  />
					</p></td>
						<td width="56" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_8_c]" type="radio" value="2"  />
					</p></td>
						<td width="32" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_8_c]" type="radio" value="3"  />
					</p></td>
 <td width="97"></td>
				 </tr>
				  <tr>
				   <td width="3"></td>
				 <td width="381" align="left" valign="top" bgcolor="f7faff" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>d.	Conocimiento de la colección
 </font></td>
				  
				  	<td width="40" align="center" valign="top"bgcolor="#f7faff"  class="Estilo31"><p align="center">
				  	  <input name="encu[0][preg_8_d]" type="radio" value="1"  />
				  	</p></td>
						<td width="56" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						  <input name="encu[0][preg_8_d]" type="radio" value="2"  />
						</p></td>
						<td width="32" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_8_d]" type="radio" value="3"  />
					</p></td>
				 <td width="97"></td>
				 </tr>
				  <tr>
				   <td width="3"></td>
				 <td width="381" align="left" valign="top" bgcolor="f7faff" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>e.	Disposición a ayudar</font></td>
				  	<td width="40" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_8_e]" type="radio" value="1"  />
					</p></td>
						<td width="56" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_8_e]" type="radio" value="2"  />
					</p></td>
						<td width="32" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_8_e]" type="radio" value="3"  />
					</p></td>
				 <td width="97"></td>
				 </tr>
				  <tr>
				   <td width="3"></td>
				 <td width="381" align="left" valign="top" bgcolor="f7faff" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>f.	Mantención del orden</font></td>
				  	<td width="40" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_8_f]" type="radio" value="1"  />
					</p></td>
						<td width="56" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_8_f]" type="radio" value="2"  />
					</p></td>
						<td width="32" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_8_f]" type="radio" value="3"  />
					</p></td>
				 <td width="97"></td>
				 </tr>
				  <tr>
				   <td width="3"></td>
				 <td width="381" align="left" valign="top" bgcolor="f7faff" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>g.	Capacidad de orientar</font></td>
				  	<td width="40" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_8_g]" type="radio" value="1"  />
					</p></td>
						<td width="56" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_8_g]" type="radio" value="2"  />
					</p></td>
						<td width="32" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_8_g]" type="radio" value="3"  />
					</p></td>
				 <td width="97"></td>
				 </tr>	
										 
										 		</table>
										 	</td>
										 </tr>
										 		  
									  <tr> 
										<td height="23" colspan="6"></td>
									  </tr>
									  <tr> 
										<td colspan="6" height="10"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>9.	¿ Cómo evalúas la colección?</strong></font></td>
									  </tr>
									   <tr>
										 <td colspan="6">
										 	<table>
											<tr>
												<td width="3"></td>
				 <td width="378" align="left" valign="top" bgcolor="f7faff" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong></font></td>
				  	<td width="40" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">Bueno</font></td>
						<td width="56" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">Regular</font></td>
						<td width="32" align="left" valign="top"  bgcolor="#f7faff"class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">Malo</font></td>
                        <td width="100"></td>
				 </tr>
									    <tr>
										 <td width="3"></td>
				 <td width="378" align="left" valign="top" bgcolor="f7faff" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>a.	Cantidad de copias</font></td>
				  	<td width="40" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_9_a]" type="radio" value="1"  />
					</p></td>
						<td width="56" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_9_a]" type="radio" value="2"  />
					</p></td>
						<td width="32" align="left" valign="top"  bgcolor="#f7faff"class="Estilo31"><p align="center">
						<input name="encu[0][preg_9_a]" type="radio" value="3"  />
					</p></td>
 <td width="100"></td>
				 </tr>
				 <tr>
				  <td width="3"></td>
				 <td width="378" align="left" valign="top" bgcolor="f7faff" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>b.	Variedad temática	</font></td>
				  	<td width="40" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
				  	  <input name="encu[0][preg_9_b]" type="radio" value="1"  />
				  	</p></td>
						<td width="56" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_9_b]" type="radio" value="2"  />
					</p></td>
						<td width="32" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_9_b]" type="radio" value="3"  />
					</p></td>
					 <td width="100"></td>
				 </tr>
				  <tr>
				   <td width="3"></td>
				 <td width="378" align="left" valign="top" bgcolor="f7faff"class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>c.	Actualización</font></td>
				  	<td width="40" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_9_c]" type="radio" value="1"  />
					</p></td>
						<td width="56" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_9_c]" type="radio" value="2"  />
					</p></td>
						<td width="32" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_9_c]" type="radio" value="3"  />
					</p></td>
 <td width="100"></td>
				 </tr>
				  <tr>
				   <td width="3"></td>
				 <td width="378" align="left" valign="top" bgcolor="f7faff" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>d.	Estado físico del material
 </font></td>
				  
				  	<td width="40" align="center" valign="top"bgcolor="#f7faff"  class="Estilo31"><p align="center">
				  	  <input name="encu[0][preg_9_d]" type="radio" value="1"  />
				  	</p></td>
						<td width="56" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						  <input name="encu[0][preg_9_d]" type="radio" value="2"  />
						</p></td>
						<td width="32" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_9_d]" type="radio" value="3"  />
					</p></td>
				 <td width="100"></td>
				 </tr>
				  <tr>
				   <td width="3"></td>
				 <td width="378" align="left" valign="top" bgcolor="f7faff" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>e.	Cobertura en relación a las bibliografías de los ramos</font></td>
				  	<td width="40" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_9_e]" type="radio" value="1"  />
					</p></td>
						<td width="56" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_9_e]" type="radio" value="2"  />
					</p></td>
						<td width="32" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_9_e]" type="radio" value="3"  />
					</p></td>
				 <td width="100"></td>
				 </tr>
				  <tr>
				   <td width="3"></td>
				 <td width="378" align="left" valign="top" bgcolor="f7faff" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>f.	Cantidad de títulos</font></td>
				  	<td width="40" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_9_f]" type="radio" value="1"  />
					</p></td>
						<td width="56" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_9_f]" type="radio" value="2"  />
					</p></td>
						<td width="32" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_9_f]" type="radio" value="3"  />
					</p></td>
				 <td width="100"></td>
				 </tr>
				  <tr>
				   <td width="3"></td>
				 <td width="378" align="left" valign="top" bgcolor="f7faff" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>g.	Cobertura en relación a lecturas para cultura personal</font></td>
				  	<td width="40" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_9_g]" type="radio" value="1"  />
					</p></td>
						<td width="56" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_9_g]" type="radio" value="2"  />
					</p></td>
						<td width="32" align="center" valign="top" bgcolor="#f7faff" class="Estilo31"><p align="center">
						<input name="encu[0][preg_9_g]" type="radio" value="3"  />
					</p></td>
				 <td width="100"></td>
											</tr>											
											</table>
										 </td>
				 					   </tr>
									  <tr> 
										<td height="23" colspan="6"></td>
									  </tr>
									  <tr> 
										<td colspan="6" height="10"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>10.	¿Cuál de estos materiales bibliográficos tiene la biblioteca? Marca más de una opción si es necesario.</strong></font></td>
									  </tr>
									     <tr>
				   							<td colspan="6">
												<table width="626">
													<tr>
														<td width="4" align="left" valign="top" bgcolor="#f7faff"></td>
                    <td width="376" align="left" valign="top" bgcolor="#f7faff" ><font size="2" face="Courier New, Courier, mono" color="#496da6">a)	Videos y dvd </font></td>
					
                    <td width="41" align="center" valign="top" bgcolor="#f7faff"><font size="2" color="#000000">
                      <input type="checkbox" name="encu[0][preg_10_a]" value="1" onclick='validarcheckbo3(this.value)'   />
                    </font></td>
					<td width="185" colspan="3"></td>
					</tr>
					<tr>
					<td width="4" align="center" valign="top" bgcolor="#f7faff"></td>
                    <td width="376" align="left" valign="top" bgcolor="#f7faff" ><font size="2" face="Courier New, Courier, mono" color="#496da6">b)	CDS </font></td>
                    <td width="41" align="center" valign="top" bgcolor="#f7faff"><font size="2" color="#000000">
                      <input type="checkbox" name="encu[0][preg_10_b]" value="2" onclick='validarcheckbo3(this.value)'   />
                    </font></td>
                   
                   <td colspan="3"></td>
                  </tr>
                  <tr>
				   <td width="4" align="center" valign="top" bgcolor="#f7faff"></td>
                    <td width="376" align="left" valign="top" bgcolor="#f7faff" ><font size="2" face="Courier New, Courier, mono" color="#496da6">c)	Revistas </font></td>
                    <td width="41" align="center" valign="top" bgcolor="#f7faff"><font size="2" color="#000000">
                      <input type="checkbox" name="encu[0][preg_10_c]" value="3" onclick='validarcheckbo3(this.value)'   />
                    </font></td>
					<td colspan="3"></td>
					</tr>
                  <tr>
					  <td width="4" align="center" valign="top" bgcolor="#f7faff"></td>
                    <td width="376" align="left" valign="top" bgcolor="#f7faff" ><font size="2" face="Courier New, Courier, mono" color="#496da6">d)	Tesis </font></td>
                    <td width="41" align="center" valign="top" bgcolor="#f7faff"><font size="2" color="#000000">
                      <input type="checkbox" name="encu[0][preg_10_d]" value="4" onclick='validarcheckbo3(this.value)'   />
                    </font></td>
                  
                   <td colspan="3"></td>
                  </tr>
                  <tr>
				   <td width="4" align="center" valign="top" bgcolor="#f7faff"></td>
                    <td width="376" align="left" valign="top" bgcolor="#f7faff" ><font size="2" face="Courier New, Courier, mono" color="#496da6">e)	Apuntes </font></td>
                    <td width="41" align="center" valign="top" bgcolor="#f7faff"class="Estilo31"><font size="2" color="#000000">
                      <input type="checkbox" name="encu[0][preg_10_e]" value="5" onclick='validarcheckbo3(this.value)'   />
                    </font></td>
					<td colspan="3"></td>
					</tr>
                  <tr>
					<td width="4" align="center" valign="top" bgcolor="#f7faff"></td>
                    <td width="376" align="left" valign="top" bgcolor="#f7faff" ><font size="2" face="Courier New, Courier, mono" color="#496da6">f)	Bases de datos </font></td>
					
                    <td width="41" align="center" valign="top" bgcolor="#f7faff"><font size="2" color="#000000">
                      <input type="checkbox" name="encu[0][preg_10_f]" value="6" onclick='validarcheckbo3(this.value)'   />
                    </font></td>
                    
                    <td colspan="3"></td>
                  </tr>
				  <tr>
					<td width="4" align="center" valign="top" bgcolor="#f7faff"></td>
                    <td width="376" align="left" valign="top" bgcolor="#f7faff" ><font size="2" face="Courier New, Courier, mono" color="#496da6">g)	Todas  </font></td>
					
                    <td width="41" align="center" valign="top" bgcolor="#f7faff"><font size="2" color="#000000">
                      <input type="checkbox" name="encu[0][preg_10_g]" value="7" onclick='validarcheckbo3(this.value)'   />
                    </font></td>
                    
                    <td colspan="3"></td>
												  </tr>
											  </table>
											</td>
                  						</tr>
									  <tr> 
										<td height="23" colspan="6"></td>
									  </tr>
									  <tr> 
										<td colspan="6" height="10"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>11.	¿Utilizas los servicios de la página de la biblioteca? </strong></font></td>
									  </tr>
									    <tr>
                                          <td colspan="6" height="10"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#f7faff" align="center">
                                              <tr>
                                                <td width="2%"></td>
                                                <td width="60%" align="left" valign="top" ><font size="2" face="Courier New, Courier, mono" color="#496da6">a) Si</font> </td>
                                                <td width="5%" align="center" valign="top" bgcolor="#f7faff"><font size="2" color="#ffffff">
                                                  <input type="radio" name="encu[0][preg_11]" value="1" />
                                                </font></td>
                                                <td width="33%" colspan="3"></td>
                                              </tr>
                                              <tr>
                                                <td></td>
                                                <td width="60%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">b) No</font></td>
                                                <td width="5%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
                                                  <input type="radio" name="encu[0][preg_11]" value="2"  />
                                                </font></td>
                                                <td width="33%" colspan="3"></td>
                                              </tr>
                                              <tr>
                                                <td></td>
                                                <td width="60%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">c)	Rara vez</font></td>
                                                <td width="5%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
                                                  <input type="radio" name="encu[0][preg_11]" value="3" />
                                                </font></td>
                                                <td width="33%" colspan="3"></td>
                                              </tr>
                                              
                                          </table></td>
								      </tr>
									  <tr> 
										<td height="23" colspan="6"></td>
									  </tr>
									  <tr> 
										<td colspan="6" height="10"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>12.	¿Cómo evalúas la página? </strong></font></td>
									  </tr>
									    <tr> 
										<td colspan="6" height="10"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#f7faff" align="center">
                                              <tr>
                                                <td width="2%"></td>
                                                <td width="60%" align="left" valign="top" ><font size="2" face="Courier New, Courier, mono" color="#496da6">a) Bien </font> </td>
                                                <td width="5%" align="center" valign="top" bgcolor="#f7faff"><font size="2" color="#ffffff">
                                                  <input type="radio" name="encu[0][preg_12]" value="1" />
                                                </font></td>
                                                <td width="33%" colspan="3"></td>
                                              </tr>
                                              <tr>
                                                <td></td>
                                                <td width="60%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">b) Regular</font></td>
                                                <td width="5%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
                                                  <input type="radio" name="encu[0][preg_12]" value="2"  />
                                                </font></td>
                                                <td width="33%" colspan="3"></td>
                                              </tr>
                                              <tr>
                                                <td></td>
                                                <td width="60%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">c)	Mal</font></td>
                                                <td width="5%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
                                                  <input type="radio" name="encu[0][preg_12]" value="3" />
                                                </font></td>
                                                <td width="33%" colspan="3"></td>
                                              </tr>
                                              
                                          </table></td>
									  </tr>
									  <tr> 
										<td height="23" colspan="6"></td>
									  </tr>
									  <tr> 
										<td colspan="6" height="10"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>13.	¿Conoces el reglamento de la biblioteca?</strong></font></td>
									  </tr>
									      <tr> 
										<td colspan="6" height="10"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#f7faff" align="center">
                                              <tr>
                                                <td width="2%"></td>
                                                <td width="60%" align="left" valign="top" ><font size="2" face="Courier New, Courier, mono" color="#496da6">a) Si </font> </td>
                                                <td width="5%" align="center" valign="top" bgcolor="#f7faff"><font size="2" color="#ffffff">
                                                  <input type="radio" name="encu[0][preg_13]" value="1" />
                                                </font></td>
                                                <td width="33%" colspan="3"></td>
                                              </tr>
                                              <tr>
                                                <td></td>
                                                <td width="60%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">b) No </font></td>
                                                <td width="5%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
                                                  <input type="radio" name="encu[0][preg_13]" value="2"  />
                                                </font></td>
                                                <td width="33%" colspan="3"></td>
                                              </tr>
                                              <tr>
                                                <td></td>
                                                <td width="60%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">c) A medias	</font></td>
                                                <td width="5%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
                                                  <input type="radio" name="encu[0][preg_13]" value="3" />
                                                </font></td>
                                                <td width="33%" colspan="3"></td>
                                              </tr>
                                              
                                          </table></td>
									  </tr>
									  <tr> 
										<td height="23" colspan="6"></td>
									  </tr>
									  <tr> 
										<td colspan="6" height="10"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>14.	¿ Cuál de estos servicios has utilizado? (puedes marcar cuantas opciones consideres) </strong></font></td>
									  </tr>
									     <tr>
				   							<td colspan="6">
												<table width="626">
													<tr>
														<td width="4" align="left" valign="top" bgcolor="#f7faff"></td>
                    <td width="376" align="left" valign="top" bgcolor="#f7faff" ><font size="2" face="Courier New, Courier, mono" color="#496da6">a)	Préstamo </font></td>
					
                    <td width="41" align="center" valign="top" bgcolor="#f7faff"><font size="2" color="#000000">
                      <input type="checkbox" name="encu[0][preg_14_a]" value="1" onclick='validarcheckbo4(this.value)'   />
                    </font></td>
					<td width="185" colspan="3"></td>
					</tr>
					<tr>
					<td width="4" align="center" valign="top" bgcolor="#f7faff"></td>
                    <td width="376" align="left" valign="top" bgcolor="#f7faff" ><font size="2" face="Courier New, Courier, mono" color="#496da6">b)	Préstamo inter-bibliotecario  </font></td>
                    <td width="41" align="center" valign="top" bgcolor="#f7faff"><font size="2" color="#000000">
                      <input type="checkbox" name="encu[0][preg_14_b]" value="2"  onclick='validarcheckbo4(this.value)'  />
                    </font></td>
                   
                   <td colspan="3"></td>
                  </tr>
                  <tr>
				   <td width="4" align="center" valign="top" bgcolor="#f7faff"></td>
                    <td width="376" align="left" valign="top" bgcolor="#f7faff" ><font size="2" face="Courier New, Courier, mono" color="#496da6">c)	Reserva  </font></td>
                    <td width="41" align="center" valign="top" bgcolor="#f7faff"><font size="2" color="#000000">
                      <input type="checkbox" name="encu[0][preg_14_c]" value="3"  onclick='validarcheckbo4(this.value)' />
                    </font></td>
					<td colspan="3"></td>
					</tr>
                  <tr>
					  <td width="4" align="center" valign="top" bgcolor="#f7faff"></td>
                    <td width="376" align="left" valign="top" bgcolor="#f7faff" ><font size="2" face="Courier New, Courier, mono" color="#496da6">d)	Renovación  </font></td>
                    <td width="41" align="center" valign="top" bgcolor="#f7faff"><font size="2" color="#000000">
                      <input type="checkbox" name="encu[0][preg_14_d]" value="4"  onclick='validarcheckbo4(this.value)' />
                    </font></td>
                  
                   <td colspan="3"></td>
                  </tr>
                  <tr>
				   <td width="4" align="center" valign="top" bgcolor="#f7faff"></td>
                    <td width="376" align="left" valign="top" bgcolor="#f7faff" ><font size="2" face="Courier New, Courier, mono" color="#496da6">e)	Solicitud de bibliografías  </font></td>
                    <td width="41" align="center" valign="top" bgcolor="#f7faff"class="Estilo31"><font size="2" color="#000000">
                      <input type="checkbox" name="encu[0][preg_14_e]" value="5" onclick='validarcheckbo4(this.value)'  />
                    </font></td>
					<td colspan="3"></td>
					</tr>
                  <tr>
					<td width="4" align="center" valign="top" bgcolor="#f7faff"></td>
                    <td width="376" align="left" valign="top" bgcolor="#f7faff" ><font size="2" face="Courier New, Courier, mono" color="#496da6">f)	Consulta en sala  </font></td>
					
                    <td width="41" align="center" valign="top" bgcolor="#f7faff"><font size="2" color="#000000">
                      <input type="checkbox" name="encu[0][preg_14_f]" value="6"  onclick='validarcheckbo4(this.value)'  />
                    </font></td>
                    
                    <td colspan="3"></td>
                  </tr>
				  <tr>
					<td width="4" align="center" valign="top" bgcolor="#f7faff"></td>
                    <td width="376" align="left" valign="top" bgcolor="#f7faff" ><font size="2" face="Courier New, Courier, mono" color="#496da6">g)	Ninguno   </font></td>
					
                    <td width="41" align="center" valign="top" bgcolor="#f7faff"><font size="2" color="#000000">
                      <input type="checkbox" name="encu[0][preg_14_g]" value="7" onclick='validarcheckbo4(this.value)'  />
                    </font></td>
                    
                    <td colspan="3"></td>
												  </tr>
											  </table>
											</td>
                  						</tr>
									  <tr> 
										<td height="23" colspan="6"></td>
									  </tr>
									  <tr> 
										<td colspan="6" height="10"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>15.	¿ Qué te parece el horario de atención de la biblioteca?</strong></font></td>
									  </tr>
									    <tr> 
										<td colspan="6" height="10"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#f7faff" align="center">
                                              <tr>
                                                <td width="2%"></td>
                                                <td width="60%" align="left" valign="top" ><font size="2" face="Courier New, Courier, mono" color="#496da6">a) Adecuado  </font> </td>
                                                <td width="5%" align="center" valign="top" bgcolor="#f7faff"><font size="2" color="#ffffff">
                                                  <input type="radio" name="encu[0][preg_15]" value="1" />
                                                </font></td>
                                                <td width="33%" colspan="3"></td>
                                              </tr>
                                              <tr>
                                                <td></td>
                                                <td width="60%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">b) Inadecuado  </font></td>
                                                <td width="5%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
                                                  <input type="radio" name="encu[0][preg_15]" value="2"  />
                                                </font></td>
                                                <td width="33%" colspan="3"></td>
                                              </tr>
                                              
                                              
                                          </table></td>
									  </tr>
									  <tr> 
										<td height="23" colspan="6"></td>
									  </tr>
									  <tr> 
										<td colspan="6" height="10"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>16.	En general el servicio de la biblioteca es : </strong></font></td>
									  </tr>
									    <tr> 
										<td colspan="6" height="10"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#f7faff" align="center">
                                              <tr>
                                                <td width="2%"></td>
                                                <td width="60%" align="left" valign="top" ><font size="2" face="Courier New, Courier, mono" color="#496da6">a) Bueno </font> </td>
                                                <td width="5%" align="center" valign="top" bgcolor="#f7faff"><font size="2" color="#ffffff">
                                                  <input type="radio" name="encu[0][preg_16]" value="1" />
                                                </font></td>
                                                <td width="33%" colspan="3"></td>
                                              </tr>
                                              <tr>
                                                <td></td>
                                                <td width="60%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">b) Regular</font></td>
                                                <td width="5%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
                                                  <input type="radio" name="encu[0][preg_16]" value="2"  />
                                                </font></td>
                                                <td width="33%" colspan="3"></td>
                                              </tr>
                                              <tr>
                                                <td></td>
                                                <td width="60%" align="left" valign="top" class="Estilo31"><font size="2" face="Courier New, Courier, mono" color="#496da6">c)	Malo</font></td>
                                                <td width="5%" align="center" valign="top" class="Estilo31"bgcolor="#f7faff"><font size="2" color="#000000">
                                                  <input type="radio" name="encu[0][preg_16]" value="3" />
                                                </font></td>
                                                <td width="33%" colspan="3"></td>
                                              </tr>
                                              
                                          </table></td>
									  </tr>
									  <tr> 
										<td height="23" colspan="6"></td>
									  </tr>
									  <tr> 
										<td colspan="6" height="10"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>17.	¿Cuáles de estas opciones te parecen adecuadas para mejorar el servicio?. Elige 2.</strong></font></td>
									  </tr>
									    <tr> 
										<td colspan="6" height="10"><table width="626">
													<tr>
														<td width="4" align="left" valign="top" bgcolor="#f7faff"></td>
                    <td width="376" align="left" valign="top" bgcolor="#f7faff" ><font size="2" face="Courier New, Courier, mono" color="#496da6">a)	Aumentar la cantidad de la colección </font></td>
					
                    <td width="41" align="center" valign="top" bgcolor="#f7faff"><font size="2" color="#000000">
                      <input type="checkbox" name="encu[0][preg_17_1]" value="1" onclick='validarcheckbo(this,0)'   />
                    </font></td>
					<td width="185" colspan="3"></td>
					</tr>
					<tr>
					<td width="4" align="center" valign="top" bgcolor="#f7faff"></td>
                    <td width="376" align="left" valign="top" bgcolor="#f7faff" ><font size="2" face="Courier New, Courier, mono" color="#496da6">b)	Actualizar más la colección </font></td>
                    <td width="41" align="center" valign="top" bgcolor="#f7faff"><font size="2" color="#000000">
                      <input type="checkbox" name="encu[0][preg_17_2]" value="2" onclick='validarcheckbo(this,0)'   />
                    </font></td>
                   
                   <td colspan="3"></td>
                  </tr>
                  <tr>
				   <td width="4" align="center" valign="top" bgcolor="#f7faff"></td>
                    <td width="376" align="left" valign="top" bgcolor="#f7faff" ><font size="2" face="Courier New, Courier, mono" color="#496da6">c)	Dar una atención más personalizada </font></td>
                    <td width="41" align="center" valign="top" bgcolor="#f7faff"><font size="2" color="#000000">
                      <input type="checkbox" name="encu[0][preg_17_3]" value="3" onclick='validarcheckbo(this,0)'   />
                    </font></td>
					<td colspan="3"></td>
					</tr>
                  <tr>
					  <td width="4" align="center" valign="top" bgcolor="#f7faff"></td>
                    <td width="376" align="left" valign="top" bgcolor="#f7faff" ><font size="2" face="Courier New, Courier, mono" color="#496da6">d)	Difundir mejor los servicios existentes </font></td>
                    <td width="41" align="center" valign="top" bgcolor="#f7faff"><font size="2" color="#000000">
                      <input type="checkbox" name="encu[0][preg_17_4]" value="2" onclick='validarcheckbo(this,0)'   />
                    </font></td>
                  
                   <td colspan="3"></td>
                  </tr>
                  <tr>
				   <td width="4" align="center" valign="top" bgcolor="#f7faff"></td>
                    <td width="376" align="left" valign="top" bgcolor="#f7faff" ><font size="2" face="Courier New, Courier, mono" color="#496da6">e)	Aumentar la cantidad de computadores </font></td>
                    <td width="41" align="center" valign="top" bgcolor="#f7faff"class="Estilo31"><font size="2" color="#000000">
                      <input type="checkbox" name="encu[0][preg_17_5]" value="4" onclick='validarcheckbo(this,0)'   />
                    </font></td>
					<td colspan="3"></td>
					</tr>
                  <tr>
					<td width="4" align="center" valign="top" bgcolor="#f7faff"></td>
                    <td width="376" align="left" valign="top" bgcolor="#f7faff" ><font size="2" face="Courier New, Courier, mono" color="#496da6">f)	Ampliar el horario de atención </font></td>
					
                    <td width="41" align="center" valign="top" bgcolor="#f7faff"><font size="2" color="#000000">
                      <input type="checkbox" name="encu[0][preg_17_6]" value="5" onclick='validarcheckbo(this,0)'   />
                    </font></td>
                    
                    <td colspan="3"></td>
                  </tr>
				  <tr>
					<td width="4" align="center" valign="top" bgcolor="#f7faff"></td>
                    <td width="376" align="left" valign="top" bgcolor="#f7faff" ><font size="2" face="Courier New, Courier, mono" color="#496da6">g)	Capacitar a los usuarios en el uso de los servicios  </font></td>
					
                    <td width="41" align="center" valign="top" bgcolor="#f7faff"><font size="2" color="#000000">
                      <input type="checkbox" name="encu[0][preg_17_7]" value="6" onclick='validarcheckbo(this,0)'   />
                    </font></td>
                    
                    <td colspan="3"></td>
												  </tr>
												   <tr>
					<td width="4" align="center" valign="top" bgcolor="#f7faff"></td>
                    <td width="376" align="left" valign="top" bgcolor="#f7faff" ><font size="2" face="Courier New, Courier, mono" color="#496da6">h)	Contar con mayor personal para la atención de público  </font></td>
					
                    <td width="41" align="center" valign="top" bgcolor="#f7faff"><font size="2" color="#000000">
                      <input type="checkbox" name="encu[0][preg_17_8]" value="7" onClick='validarcheckbo(this,0)'   />
                    </font></td>
                    
                    <td colspan="3"></td>
												  </tr>
											  </table></td>
									  </tr>
									  <tr> 
										<td height="23" colspan="6"></td>
									  </tr>
									  <tr> 
										<td colspan="6" height="10"><font size="2" face="Courier New, Courier, mono" color="#496da6"><strong>18.	Escribe aquí tus sugerencias, quejas o comentarios para mejorar el servicio de la biblioteca:</strong></font></td>
									  </tr>
									    <tr> 
										<td width="3%" colspan="1"></td>
										<td width="87%" colspan="1" > <%f_encuesta.DibujaCampo("preg_18")%></td>
										<td colspan="4"></td>
									  </tr>
									  <tr> 
										<td height="23" colspan="6"></td>
									  </tr>
                                      <tr> 
										 <td height="10" colspan="6">&nbsp;</td>
									  </tr>
									    <tr> 
																		
										<td height="10" colspan="6"><hr></td>
									  </tr>
								  </table>
								  <table>
								   <tr> 
										<td height="10" colspan="4">&nbsp;</td>
										<td height="10" align="right">
															<%POS_IMAGEN = POS_IMAGEN + 1%>
															<a href="javascript:_Guardar(this, document.forms['encuesta'], 'encuesta_proc.asp','','ValidarMarcados();', '', 'FALSE');"
																onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/GUARDAR2.png';return true "
																onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='imagenes/GUARDAR1.png';return true ">
																<img src="imagenes/GUARDAR1.png" border="0" width="70" height="70" alt="Guardar Encuesta">															</a>										</td>
										<td height="10" align="left"> 
										                    <%POS_IMAGEN = POS_IMAGEN + 1%>
															<a href="javascript:_Navegar(this, 'curriculum.asp?npag=2', 'FALSE');"
																onmouseover="window.status='botón pulsado';document.images[<%=POS_IMAGEN%>].src='imagenes/SALIR2.png';return true "
																onmouseout="window.status='';document.images[<%=POS_IMAGEN%>].src='/imagenes/SALIR1.png';return true ">
																<img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="VOLVER AL HOME">															</a>										</td>
								    </tr>
								  </table>
                  
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
		  </table>
		</td>
	</tr>
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>

	<tr>
		<td width="100%" align="left">
			
		</td>
	</tr>
</table>
</form>
</center>
</body>
</html>

