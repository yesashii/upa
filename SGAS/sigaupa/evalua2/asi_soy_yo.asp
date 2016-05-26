<!-- #include file = "../biblioteca/de_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_evalua.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Encuesta Así soy yo"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set errores = new CErrores
set negocio = new CNegocio
negocio.Inicializa conexion
q_pers_nrut = Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")

if esVacio(q_pers_nrut) then
	q_pers_nrut = negocio.obtenerUsuario
	q_pers_xdv = conexion.consultaUno("Select pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
end if
pers_ncorr = conexion.consultaUno("Select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
ruta = "test.asp?b[0][pers_nrut]="&q_pers_nrut&"&b[0][pers_xdv]="&q_pers_xdv
ruta2 = "tus_datos.asp?b[0][pers_nrut]="&q_pers_nrut&"&b[0][pers_xdv]="&q_pers_xdv
ruta3 = "estilo_aprendizaje.asp?b[0][pers_nrut]="&q_pers_nrut&"&b[0][pers_xdv]="&q_pers_xdv

consulta_periodo=" select max(b.peri_ccod) "&_
                 " from alumnos a, ofertas_academicas b "&_
				 " where cast(a.pers_ncorr as varchar)= '"&pers_ncorr&"' and a.emat_ccod in (1)" &_
				 " and a.ofer_ncorr = b.ofer_ncorr "
				 

q_peri_ccod = conexion.consultaUno(consulta_periodo)

'response.Write(consulta_matr)
carrera = conexion.consultaUno("Select carr_tdesc from alumnos a, ofertas_Academicas b, especialidades c, carreras d where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast( peri_ccod as varchar)='"&q_peri_ccod&"' and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.emat_ccod=1 and c.carr_ccod=d.carr_ccod")

cod_carrera = conexion.consultaUno("Select d.carr_ccod from alumnos a, ofertas_Academicas b, especialidades c, carreras d where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast( peri_ccod as varchar)='"&q_peri_ccod&"' and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.emat_ccod=1 and c.carr_ccod=d.carr_ccod")

'---------------------------------------------------------------------------------------------------

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "asi_soy_yo.xml", "botonera"

pers_ncorr_temporal=pers_ncorr

'---------------------------------------------------------------------------------------------------
set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "asi_soy_yo.xml", "encabezado"
f_encabezado.Inicializar conexion

consulta = " select pers_ncorr,cast(pers_nrut as varchar)+'-'+pers_xdv as rut, " & vbCrLf &_
		   " pers_tnombre as nombres, pers_tape_paterno as ap_paterno, pers_tape_materno as ap_materno, pers_temail," & vbCrLf &_
		   " datediff(year,pers_fnacimiento,getDate()) as edad, " & vbCrLf &_
		   " pers_tfono, pers_tcelular  " & vbCrLf &_
		   " from personas  " & vbCrLf &_
		   " where cast(pers_ncorr as varchar)= '" & pers_ncorr & "' "
		   

'response.Write("<pre>"&consulta&"</pre>")
f_encabezado.Consultar consulta
f_encabezado.Siguiente
'----------------------------------------------------------------------------------------------------
'debemos ver si el alumno ya contestó la encuesta.
c_contestada = " select case count (*) when 0 then 'N' else 'S' end " & vbCrLf &_
		     " from encuesta_asi_soy_yo b  " & vbCrLf &_
		     " where cast(pers_ncorr as varchar)= '"&pers_ncorr&"'" 
contestada = conexion.consultaUno(c_contestada)
set f_encuesta = new CFormulario
f_encuesta.Carga_Parametros "asi_soy_yo.xml", "encuesta"
f_encuesta.Inicializar conexion
if contestada = "S" then
consulta = " select a.pers_ncorr, b.* " & vbCrLf &_
		   " from personas a left outer join encuesta_asi_soy_yo b  " & vbCrLf &_
		   "  on a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
		   " where cast(a.pers_ncorr as varchar)= '"&pers_ncorr&"'" 
else
	consulta = " select '"&pers_ncorr&"' as pers_ncorr,'"&cod_carrera&"' as carr_ccod "
end if		   

'response.Write("<pre>"&consulta&"</pre>")
f_encuesta.Consultar consulta
f_encuesta.Siguiente



%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Asi soy yo 2007 - Encuesta Universidad del Pac&iacute;fico</title>
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
var va_preg_11
var trabaja
trabaja = 0
function valida_ciudad(valor)
{
//alert("valor "+valor);
	if (valor =='S')
	{
		
		document.edicion.elements["encu[0][ciud_ccod]"].disabled=false;	
	}
	else
	{
			
		document.edicion.elements["encu[0][ciud_ccod]"].disabled=true;
	}

}
function valida_va_preg_11(valor)
{
//alert("valor "+valor);
	if (valor ==4 || valor==5)
	{
		
		va_preg_11='1';	
	}
	else
	{
			
		va_preg_11='0';
	}

}
function valida_preg_14(valor)
{
//alert("valor "+valor);
	if (valor =='1')
	{
		
		document.edicion.elements["encu[0][preg_14_si]"].disabled=false;	
	}
	else
	{
			
		document.edicion.elements["encu[0][preg_14_si]"].disabled=true;
	}

}



//function activar_variable(valor)
//{
//    if(valor=='S')
//	{trabaja = 1;}
//	else
//	{trabaja = 2;}
//}

function validar()
{ 
var aviso;
var preg_1;
var preg_2;
var preg_3;
var preg_4;
var preg_5;
var preg_6;
var preg_7;
var preg_8;
var preg_9;
var preg_10;
var preg_11;
var preg_12;
var preg_13;
var preg_14_em_leng;
var preg_14_em_mat;
var preg_14_egb_leng;
var preg_14_egb_mat;
var preg_15;
var var_preg_11;
aviso="Te faltan por responder:";
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
	 preg_1="0";
	 
  }
  else
  {
  aviso=aviso+"\r La pregunta 1.";
   
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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_2]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_2="0";
	 
  }
  else
  {
  aviso=aviso+"\r La pregunta 2.";
  
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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_3]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_3="0";
	 
  }
  else
  {
  aviso=aviso+"\r La pregunta 3.";
  
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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_4]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_4="0";
	 
  }
  else
  {
  aviso=aviso+"\r La pregunta 4.";
  
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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_5]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_5="0";
	 
  }
  else
  {
  aviso=aviso+"\r La pregunta 5.";
  
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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_6]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_6="0";
	 
  }
  else
  {
  aviso=aviso+"\r La pregunta 6.";
  
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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_7]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_7="0";
	 
  }
  else
  {
  aviso=aviso+"\r La pregunta 7.";
  
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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_8]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_8="0";
	 
  }
  else
  {
  aviso=aviso+"\r La pregunta 8.";
  
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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_9]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_9="0";
	 
  }
  else
  {
  aviso=aviso+"\r La pregunta 9.";
  
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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_10]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_10="0";
	 
  }
  else
  {
  aviso=aviso+"\r La pregunta 10.";
  
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
  
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_11]"))
  		{cant_radios++;
		
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_11="0";
	 
  }
  else
  {
  aviso=aviso+"\r La pregunta 11.";
  
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
 
  if (va_preg_11=='1')
  {
  		for(i=0;i<cantidad;i++)
  			{
  				elemento=document.edicion.elements[i];
  				if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_12]"))
  					{cant_radios++;
		 			 if(elemento.checked){contestada++;}
  						}
  					}

  				if (contestada==((cant_radios)/divisor))
  				{ 
	 			preg_12="0";
	 
  				}
  				else
  				{
   				aviso=aviso+"\r La pregunta 12.";
  				}
  			}
  else
  {
   preg_12="0";
  }
 }



{
var valor;
valor=document.edicion.elements["encu[0][preg_13_egb_leng]"].value;
if (valor>0 && valor<=7.0)
{
preg_13_egb_len="0";
}
else
{
aviso=aviso+"\r La nota promedio de Lenguaje EGB  no es válida.";

}


}
{
var valor;
valor=document.edicion.elements["encu[0][preg_13_egb_mat]"].value;
if (valor>0 && valor<=7.0)
{
preg_13_egb_mat="0";
}
else
{
aviso=aviso+"\r La nota promedio de Matemática EGB  no es válida.";
preg_13_egb_mat="1";
}


}

{
var valor;
valor=document.edicion.elements["encu[0][preg_13_em_leng]"].value;
if (valor>0 && valor<=7.0)
{
preg_13_em_len="0";

}
else
{
aviso=aviso+"\r La nota promedio de Lenguaje EM  no es válida.";
preg_13_em_len="1";
}


}
{
var valor;
valor=document.edicion.elements["encu[0][preg_13_em_mat]"].value;
if (valor>0 && valor<=7.0)
{
preg_13_em_mat="0";
}
else
{
aviso=aviso+"\r La nota promedio de Matemática EM  no es válida.";
preg_13_em_mat="1";
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
  	if ((elemento.type=="radio") && (elemento.name=="encu[0][preg_14]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 preg_14="0";
	 
  }
  else
  {
  aviso=aviso+"\r La pregunta 14.";
   preg_14="1";
  }
}

}
//alert("preg_1= "+preg_1+"\r preg_2="+preg_2+"\r preg_3="+preg_3+"\r preg_4="+preg_4+"\r  preg_5="+preg_5+"\r preg_6="+preg_6+"\r preg_7="+preg_7+"\r preg_8="+preg_8+"\r preg_9="+preg_9+"\r preg_10="+preg_10+"\r preg_11="+preg_11+"\r preg_12="+preg_12+"\r preg_13_egb_len="+preg_13_egb_len+"\r preg_13_egb_mat="+preg_13_egb_mat+"\r preg_13_em_len="+preg_13_em_len+"\r preg_13_em_mat="+preg_13_em_mat+"\r preg_14="+preg_14+"\r")


  if ((preg_1=="0") && (preg_2=="0") && (preg_3=="0") && (preg_4=="0")&& (preg_5=="0")&& (preg_6=="0")&&(preg_7=="0")&& (preg_8=="0")&& (preg_9=="0")&& (preg_10=="0")&& (preg_11=="0")&& (preg_12=="0")&& (preg_13_egb_len=="0")&& (preg_13_egb_mat=="0")&& (preg_13_em_len=="0")&& (preg_13_em_mat=="0")&&(preg_14=="0")  )
 
  { 
	 //alert("preg_1= "+preg_1+"\r preg_2="+preg_2+"\r preg_3="+preg_3+"\r preg_4="+preg_4+"\r preg_5="+preg_5+"\r preg_6="+preg_6+"\r preg_7="+preg_7+"\r preg_8="+preg_8+"\r preg_9="+preg_9+"\r preg_10="+preg_10+"\r preg_11="+preg_11+"\r preg_12="+preg_12+"\r preg_13="+preg_13+"\r preg_14_egb_len="+preg_14_egb_len+"\r preg_14_egb_mat="+preg_14_egb_mat+"\r preg_14_em_len="+preg_14_em_len+"\r preg_14_em_mat="+preg_14_em_mat+"\r preg_15="+preg_15+"\r")
//	 	 alert("true");
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
<p align="center" class="Estilo35">&quot;As&iacute; soy yo&quot;</p>
<p align="center"><span class="Estilo34">CUESTIONARIO SOBRE CARACTERISTICAS  <br />
   PERSONALES Y ESTRATEGIAS DE ESTUDIO  </span></p>
<table width="100%" border="0">
<tr valign="top">
<td width="100%" align="center">
<form name="edicion">
<input type="hidden" name="encu[0][pers_ncorr]" value="<%=pers_ncorr%>">
<input type="hidden" name="encu[0][carr_ccod]" value="<%=cod_carrera%>">
<table width="700" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="25" height="24" background="images/borde_superior.jpg"><img width="25" height="24" src="images/superior_izquierda.jpg"></td>
	<td width="646" height="24">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr valign="bottom">
				<td width="100" height="24" background="images/borde_superior.jpg"><span class="Estilo46">Así soy yo</span></td>
			    <td width="29" height="24"><img width="29" height="24" src="images/superior_derecha.jpg"></td>
				<td width="25" height="24" background="images/borde_superior.jpg"><img width="25" height="24" src="images/superior_izquierda.jpg"></td>
			    <td width="100" height="24" background="images/borde_superior.jpg"><font size="3" color="#666666" face="Courier New, Courier, mono"><a href="<%=ruta%>"> Test</a></font></td>
				<td width="29" height="24"><img width="29" height="24" src="images/superior_derecha.jpg"></td>
				<td width="25" height="24" background="images/borde_superior.jpg"><img width="25" height="24" src="images/superior_izquierda.jpg"></td>
			    <td width="100" height="24" background="images/borde_superior.jpg"><font size="3" color="#666666" face="Courier New, Courier, mono"><a href="<%=ruta3%>"> Chaea</a></font></td>
				<td width="29" height="24"><img width="29" height="24" src="images/superior_derecha.jpg"></td>


				<td bgcolor="#FFFFFF">&nbsp;</td>
			</tr>
		</table>
	</td>
	<td width="29" height="24" bgcolor="#FFFFFF">&nbsp;</td>
</tr>
<tr>
	<td width="25" height="24" background="images/lado_izquierda.jpg" align="right"><img width="18" height="24" src="images/borde_superior.jpg"></td>
	<td width="646" height="24" background="images/borde_superior.jpg">&nbsp;</td>
	<td width="29" height="24"><img width="29" height="24" src="images/superior_derecha.jpg"></td>
</tr>
<tr>
    <td width="25" background="images/lado_izquierda.jpg" align="right">&nbsp;</td>
	<td bgcolor="#FFFFFF" aling="left" width="646">
		<table width="646" border="0" align="left" cellpadding="10" cellspacing="10" bgcolor="#FFFFFF">
		  <tr>
			<td align="left"><p class="Estilo27">::  Introducci&oacute;n </p>
				<p class="Estilo31">El objetivo de esta encuesta es conocerte un poco más, para entregarte una atención más personalizada. A continuación te pedimos que contestes las siguientes preguntas. Requiere alrededor de 5 minutos de tu tiempo.</p>
			    <table width="90%" border="0" bgcolor="#FFFFFF">
				  <tr>
					<td class="Estilo31" width="20%">Nombres</td>
					<td class="Estilo31" width="2%">:</td>
					<td class="Estilo31" align="left"><%f_encabezado.DibujaCampo("nombres")%></td>
				  </tr>
				  <tr>
					<td class="Estilo31" width="20%">Apellido Paterno</td>
					<td class="Estilo31" width="2%">:</td>
					<td class="Estilo31" align="left"><%f_encabezado.DibujaCampo("ap_paterno")%></td>
				  </tr>
				  <tr>
					<td class="Estilo31" width="20%">Apellido Materno</td>
					<td class="Estilo31" width="2%">:</td>
					<td class="Estilo31" align="left"><%f_encabezado.DibujaCampo("ap_materno")%></td>
				  </tr>
				  <% if contestada <> "S" then %>
				  <tr>
					<td class="Estilo31" width="20%">Carrera</td>
					<td class="Estilo31" width="2%">:</td>
					<td class="Estilo31" align="left"><%=carrera%></td>
				  </tr>
				  <tr>
					<td class="Estilo31" width="20%">Edad</td>
					<td class="Estilo31" width="2%">:</td>
					<td class="Estilo31" align="left"><%f_encabezado.DibujaCampo("edad")%></td>
				  </tr>
				  <tr>
					<td class="Estilo31" width="20%">Fono Fijo</td>
					<td class="Estilo31" width="2%">:</td>
					<td class="Estilo31" align="left"><%f_encabezado.DibujaCampo("pers_tfono")%></td>
				  </tr>
				  <tr>
					<td class="Estilo31" width="20%">Fono Celular  </td>
					<td class="Estilo31" width="2%">:</td>
					<td class="Estilo31" align="left"><%f_encabezado.DibujaCampo("pers_tcelular")%></td>
				  </tr>
				   <tr>
					<td class="Estilo31" width="20%">E-mail</td>
					<td class="Estilo31" width="2%">:</td>
					<td class="Estilo31" align="left"><%f_encabezado.DibujaCampo("pers_temail")%></td>
				  </tr>
				  <%else%>
				  <tr><td colspan="3" align="center"><p class="Estilo31"><span class="Estilo27">Tus Respuestas fueron grabadas Correctamente.<br> Muchas Gracias.</span></p></td></tr>
				  <%end if%>
			  </table>
			 <% if contestada <> "S" then %>
			  <br />
			
				<br />
				<hr size="1" noshade="noshade" />
				<p class="Estilo27">:: Manejo del Estrés</p>
				<p class="Estilo43">Marca la alternativa que corresponda, recordando cómo ha sido tu <strong> último año escolar</strong> </p>

				<p class="Estilo31"><strong><em> 1) </em></strong>&ldquo;Me cuesta manejar mi ansiedad frente a pruebas y  ex&aacute;menes&rdquo;:</p>
				<table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
				  	<td width="4%" align="center" valign="top" class="Estilo31"></td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_1]" value="1" /></td>
					<td width="13%" align="center" valign="top" class="Estilo31">nunca</td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_1]" value="2" /></td>
					<td width="12%" align="center" valign="top" class="Estilo31">rara vez </td>
					<td width="4%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_1]" value="3" /></td>
					<td width="12%" align="center" valign="top" class="Estilo31">a veces </td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_1]" value="4" /></td>
					<td width="18%" align="center" valign="top" class="Estilo31">frecuentemente</td>
					<td width="3%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_1]" value="5" /></td>
					<td width="19%" align="center" valign="top" class="Estilo31">siempre</td>
				  </tr>	
			  </table>
			  <br />
				<br />
			  <p class="Estilo31"><strong><em> 2) </em></strong>&ldquo;Tengo facilidad para hacer preguntas en clase y dar  mi opini&oacute;n&rdquo;:</p>
			  <table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
				  	<td width="4%" align="center" valign="top" class="Estilo31"></td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_2]" value="5" /></td>
					<td width="13%" align="center" valign="top" class="Estilo31">siempre</td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_2]" value="4" /></td>
					<td width="17%" align="center" valign="top" class="Estilo31">frecuentemente</td>
					<td width="3%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_2]" value="3" /></td>
					<td width="10%" align="center" valign="top" class="Estilo31">a veces </td>
					<td width="4%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_2]" value="2" /></td>
					<td width="17%" align="center" valign="top" class="Estilo31">rara vez</td>
					<td width="4%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_2]" value="1" /></td>
					<td width="18%" align="center" valign="top" class="Estilo31">nunca</td>
				  </tr>	
			  </table>
			  <br />
				<hr align="left" width="550" size="1" noshade="noshade" />
				<p class="Estilo31"><strong><em> 3) </em></strong>&ldquo;Tengo dificultades para realizar presentaciones  orales y/o hablar en p&uacute;blico&rdquo;:</p>
					<table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
				  	<td width="4%" align="center" valign="top" class="Estilo31"></td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_3]" value="1" /></td>
					<td width="13%" align="center" valign="top" class="Estilo31">nunca</td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_3]" value="2" /></td>
					<td width="12%" align="center" valign="top" class="Estilo31">rara vez </td>
					<td width="4%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_3]" value="3" /></td>
					<td width="12%" align="center" valign="top" class="Estilo31">a veces </td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_3]" value="4" /></td>
					<td width="18%" align="center" valign="top" class="Estilo31">frecuentemente</td>
					<td width="3%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_3]" value="5" /></td>
					<td width="19%" align="center" valign="top" class="Estilo31">siempre</td>
				  </tr>	
			  </table>
			
			  <br />
				<br />
				<hr align="left" width="550" size="1" noshade="noshade" />
				<p class="Estilo27">:: Emociones  </p>
				<p class="Estilo43">Responde considerando las <strong>&uacute;ltimas 2 semanas</strong>. </p>
			  <p class="Estilo31"><strong><em> 4) </em></strong>&ldquo;Me siento enojada/o o agresiva/o, la mayor parte  del d&iacute;a, casi todos los d&iacute;as&rdquo;:</p>
			  <table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
				  	<td width="4%" align="center" valign="top" class="Estilo31"></td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_4]" value="1" /></td>
					<td width="13%" align="center" valign="top" class="Estilo31">nunca</td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_4]" value="2" /></td>
					<td width="12%" align="center" valign="top" class="Estilo31">rara vez </td>
					<td width="4%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_4]" value="3" /></td>
					<td width="12%" align="center" valign="top" class="Estilo31">a veces </td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_4]" value="4" /></td>
					<td width="18%" align="center" valign="top" class="Estilo31">frecuentemente</td>
					<td width="3%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_4]" value="5" /></td>
					<td width="19%" align="center" valign="top" class="Estilo31">siempre</td>
				  </tr>	
			  </table>
			  				<br />
				<hr size="1" noshade="noshade" />
			  <p class="Estilo31"><strong><em> 5) </em></strong>&ldquo;Me he sentido triste y/o desanimado/a la mayor parte del día, casi todos los días&rdquo;</p>
			  <table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
				  	<td width="4%" align="center" valign="top" class="Estilo31"></td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_5]" value="1" /></td>
					<td width="13%" align="center" valign="top" class="Estilo31">nunca</td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_5]" value="2" /></td>
					<td width="12%" align="center" valign="top" class="Estilo31">rara vez </td>
					<td width="4%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_5]" value="3" /></td>
					<td width="12%" align="center" valign="top" class="Estilo31">a veces </td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_5]" value="4" /></td>
					<td width="18%" align="center" valign="top" class="Estilo31">frecuentemente</td>
					<td width="3%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_5]" value="5" /></td>
					<td width="19%" align="center" valign="top" class="Estilo31">siempre</td>
				  </tr>	
			  </table>
			  <br />
				<hr align="left" width="550" size="1" noshade="noshade" />
			  <p class="Estilo31"><strong><em> 6) </em></strong>&ldquo;Siento que he perdido la capacidad de disfrutar con  las actividades que antes me satisfac&iacute;an&rdquo;</p>
			   <table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
				  	<td width="4%" align="center" valign="top" class="Estilo31"></td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_6]" value="1" /></td>
					<td width="13%" align="center" valign="top" class="Estilo31">nunca</td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_6]" value="2" /></td>
					<td width="12%" align="center" valign="top" class="Estilo31">rara vez </td>
					<td width="4%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_6]" value="3" /></td>
					<td width="12%" align="center" valign="top" class="Estilo31">a veces </td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_6]" value="4" /></td>
					<td width="18%" align="center" valign="top" class="Estilo31">frecuentemente</td>
					<td width="3%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_6]" value="5" /></td>
					<td width="19%" align="center" valign="top" class="Estilo31">siempre</td>
				  </tr>	
			  </table>
			  <br />
			  <hr align="left" width="550" size="1" noshade="noshade" />
			  <p class="Estilo31"><strong><em> 7) </em></strong>&ldquo;Duermo bien y me siento descansada/o&rdquo;</p>
			    <table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
				  	<td width="4%" align="center" valign="top" class="Estilo31"></td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_7]" value="5" /></td>
					<td width="13%" align="center" valign="top" class="Estilo31">siempre</td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_7]" value="4" /></td>
					<td width="17%" align="center" valign="top" class="Estilo31">frecuentemente</td>
					<td width="3%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_7]" value="3" /></td>
					<td width="10%" align="center" valign="top" class="Estilo31">a veces </td>
					<td width="4%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_7]" value="2" /></td>
					<td width="17%" align="center" valign="top" class="Estilo31">rara vez</td>
					<td width="4%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_7]" value="1" /></td>
					<td width="18%" align="center" valign="top" class="Estilo31">nunca</td>
				  </tr>	
			  </table>
			  
			  <br />
				<hr align="left" width="550" size="1" noshade="noshade" />
				<p class="Estilo27">:: Estilo de Trabajo  </p>
				
			  <p class="Estilo31"><strong><em> 8) </em></strong>Cuando tengo que hacer un trabajo, prefiero hacerlo solo/a:</p>
			  <table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
				  	<td width="4%" align="center" valign="top" class="Estilo31"></td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_8]" value="1" /></td>
					<td width="13%" align="center" valign="top" class="Estilo31">nunca</td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_8]" value="2" /></td>
					<td width="12%" align="center" valign="top" class="Estilo31">rara vez </td>
					<td width="4%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_8]" value="3" /></td>
					<td width="12%" align="center" valign="top" class="Estilo31">a veces </td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_8]" value="4" /></td>
					<td width="18%" align="center" valign="top" class="Estilo31">frecuentemente</td>
					<td width="3%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_8]" value="5" /></td>
					<td width="19%" align="center" valign="top" class="Estilo31">siempre</td>
				  </tr>	
			  </table>
			  <br />
				<hr align="left" width="550" size="1" noshade="noshade" />
				<p class="Estilo31"><strong><em> 9) </em></strong>Trabajando en grupo consigo los mejores resultados</p>
				<table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
				  	<td width="4%" align="center" valign="top" class="Estilo31"></td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_9]" value="5" /></td>
					<td width="13%" align="center" valign="top" class="Estilo31">siempre</td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_9]" value="4" /></td>
					<td width="17%" align="center" valign="top" class="Estilo31">frecuentemente</td>
					<td width="3%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_9]" value="3" /></td>
					<td width="10%" align="center" valign="top" class="Estilo31">a veces </td>
					<td width="4%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_9]" value="2" /></td>
					<td width="17%" align="center" valign="top" class="Estilo31">rara vez</td>
					<td width="4%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_9]" value="1" /></td>
					<td width="18%" align="center" valign="top" class="Estilo31">nunca</td>
				  </tr>	
			  </table>
			  <br />
				<br />
				<hr size="1" noshade="noshade" />
			  <p class="Estilo31"><strong><em> 10) </em></strong>Digo y hago cosas sin considerar las consecuencias</p>
			  <table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
				  	<td width="4%" align="center" valign="top" class="Estilo31"></td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_10]" value="1" /></td>
					<td width="13%" align="center" valign="top" class="Estilo31">nunca</td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_10]" value="2" /></td>
					<td width="12%" align="center" valign="top" class="Estilo31">rara vez </td>
					<td width="4%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_10]" value="3" /></td>
					<td width="12%" align="center" valign="top" class="Estilo31">a veces </td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_10]" value="4" /></td>
					<td width="18%" align="center" valign="top" class="Estilo31">frecuentemente</td>
					<td width="3%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_10]" value="5" /></td>
					<td width="19%" align="center" valign="top" class="Estilo31">siempre</td>
				  </tr>	
			  </table>
			  <br />
				<hr align="left" width="550" size="1" noshade="noshade" />
			  <p class="Estilo31"><strong><em> 11) </em></strong>Me distraigo fácilmente en clases y/o cuando estudio</p>
			   <table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
				  	<td width="4%" align="center" valign="top" class="Estilo31"></td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_11]" value="1" onClick=" valida_va_preg_11(this.value);"/></td>
					<td width="13%" align="center" valign="top" class="Estilo31">nunca</td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_11]" value="2" onClick=" valida_va_preg_11(this.value);" /></td>
					<td width="12%" align="center" valign="top" class="Estilo31">rara vez </td>
					<td width="4%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_11]" value="3" onClick=" valida_va_preg_11(this.value);"/></td>
					<td width="12%" align="center" valign="top" class="Estilo31">a veces </td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_11]" value="4" onClick=" valida_va_preg_11(this.value);" /></td>
					<td width="18%" align="center" valign="top" class="Estilo31">frecuentemente</td>
					<td width="3%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_11]" value="5" onClick=" valida_va_preg_11(this.value);" /></td>
					<td width="19%" align="center" valign="top" class="Estilo31">siempre</td>
				  </tr>	
			  </table>
			  <br />
			  
			  <hr align="left" width="550" size="1" noshade="noshade" />
			  <p class="Estilo43"><strong>Contesta la pregunta 12, sólo si respondiste siempre o frecuentemente en la pregunta 11 </strong>. </p>
			  <p class="Estilo31"><strong><em>12)  </em></strong>Pienso que mi tendencia a distraerme afecta de forma importante mi rendimiento académico</p>
			  
			  <table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
				  	<td width="4%" align="center" valign="top" class="Estilo31"></td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_12]" value="1" /></td>
					<td width="13%" align="center" valign="top" class="Estilo31">nunca</td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_12]" value="2" /></td>
					<td width="12%" align="center" valign="top" class="Estilo31">rara vez </td>
					<td width="4%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_12]" value="3" /></td>
					<td width="12%" align="center" valign="top" class="Estilo31">a veces </td>
					<td width="5%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_12]" value="4" /></td>
					<td width="18%" align="center" valign="top" class="Estilo31">frecuentemente</td>
					<td width="3%" align="center" valign="top" class="Estilo31"><input type="radio" name="encu[0][preg_12]" value="5" /></td>
					<td width="19%" align="center" valign="top" class="Estilo31">siempre</td>
				  </tr>	
			  </table>
			    <br />
				<hr align="left" width="550" size="1" noshade="noshade" />
				<p class="Estilo27">:: Matemáticas y Lenguaje  </p>
				 <br />
			   <p class="Estilo31"><strong><em>13)  </em></strong>Cómo fue tu rendimiento académico en lenguaje y matemática durante la enseñanza básica y media .En los siguientes recuadros registra tu promedio de notas seg&uacute;n corresponda.<strong><em> Ejemplo 5.5   </em></strong> </p>
			   <br />
			   
			   <table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#ffffff">
				  <tr>
				  <td width="4%" align="left" valign="top" class="Estilo31"></td>
				  	<td width="96%" align="left" valign="top" class="Estilo31">Promedio EGB Lenguaje: <%f_encuesta.DibujaCampo("preg_13_egb_leng")%> - Matemática: <%f_encuesta.DibujaCampo("preg_13_egb_mat")%> </td>
					
				  </tr>	
			  </table>
			    <table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#ffffff">
				  <tr>
				  <td width="4%" align="left" valign="top" class="Estilo31"></td>
				  	<td width="96%" align="left" valign="top" class="Estilo31">Promedio EM Lenguaje: <%f_encuesta.DibujaCampo("preg_13_em_leng")%> - Matemática: <%f_encuesta.DibujaCampo("preg_13_em_mat")%> </td>
					
				  </tr>	
			  </table>
			   <p class="Estilo31">Si no lo recuerdas con exactitud, señala un promedio aproximado.  </p>
			     <hr align="left" width="550" size="1" noshade="noshade" />
			   <p class="Estilo31"><strong><em>14)  </em></strong> Durante tu etapa escolar básica y media, necesitaste algún tipo de apoyo en estas áreas (lenguaje y matemática): </p>
			  
			   <table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#CCCCCC">
				  <tr>
				  <td width="21" align="center" valign="top" class="Estilo31"></td>
				  <td width="20" valign="top" class="Estilo31"><p align="center">
						<input name="encu[0][preg_14]" type="radio" value="1"  onclick="valida_preg_14(this.value);"/>
					</p></td>
					<td width="33" valign="top" class="Estilo31">Si</td>
					<td width="20" valign="top" class="Estilo31"><p align="center">
						<input name="encu[0][preg_14]" type="radio" value="2" onClick="valida_preg_14(this.value);"  />
					</p></td>
					<td width="38" valign="top" class="Estilo31">No</td>
					<td width="418" align="center" valign="top" class="Estilo31" bgcolor="#ffffff"></td>
				  </tr>	
			  </table>
			  <p class="Estilo31">Si la respuesta es si, describe el tipo de apoyo recibido y el momento en que lo utilizaste (EGB o EM).</p>
			    <table width="550" border="0" cellpadding="0" cellspacing="0" bgcolor="#ffffff">
				  <tr>
				  <td width="4%" align="left" valign="top" class="Estilo31"></td>
				  	<td width="96%" align="left" valign="top" class="Estilo31"> <%f_encuesta.DibujaCampo("preg_14_si")%> </td>
					
				  </tr>	
			  </table>
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
<%if contestada <> "S" then %>
<table width="700" border="0" cellpadding="0" cellspacing="0">
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
			<td width="617"><p align="left" class="Estilo31"><em>Comentarios&nbsp;&nbsp;</em>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>
			  <textarea name="encu[0][comentarios]" cols="100" rows="4" class="Estilo25" id="TO-S"></textarea>
			</strong></p>    </td>
		  </tr>
		  <tr>
			<td width="617"><p align="center" class="Estilo31"><%f_botonera.dibujaBoton "guardar"%></p>    </td>
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
<%end if%>
</form>
<p align="center"><strong>&nbsp;<span class="Estilo45">&iexcl;Muchas gracias por  tu colaboraci&oacute;n! </span></strong><span class="Estilo45"><br />
  Para conversar los temas de la  encuesta y resolver dudas ac&eacute;rcate a la <br />
  <span class="Estilo46">DAE (Direcci&oacute;n de Asuntos  Estudiantiles)</span> en el 3er piso o llamando al 3665366-3665350</span></p>
<p align="center" class="Estilo31">&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
</td>
</tr>
</table>
</body>

</html>
