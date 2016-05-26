<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_evalua.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Tus Datos"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

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
ruta2 = "asi_soy_yo.asp?b[0][pers_nrut]="&q_pers_nrut&"&b[0][pers_xdv]="&q_pers_xdv
ruta3 = "estilo_aprendizaje.asp?b[0][pers_nrut]="&q_pers_nrut&"&b[0][pers_xdv]="&q_pers_xdv
consulta_periodo=" select max(b.peri_ccod) "&_
                 " from alumnos a, ofertas_academicas b "&_
				 " where cast(a.pers_ncorr as varchar)= '"&pers_ncorr&"' and a.emat_ccod in (1)" &_
				 " and a.ofer_ncorr = b.ofer_ncorr "
				 

q_peri_ccod = conexion.consultaUno(consulta_periodo)

'response.Write(consulta_matr)
carrera = conexion.consultaUno("Select carr_tdesc from alumnos a, ofertas_Academicas b, especialidades c, carreras d where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast( peri_ccod as varchar)='"&q_peri_ccod&"' and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.emat_ccod=1 and c.carr_ccod=d.carr_ccod")

cod_carrera = conexion.consultaUno("Select d.carr_ccod from alumnos a, ofertas_Academicas b, especialidades c, carreras d where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast( peri_ccod as varchar)='"&q_peri_ccod&"' and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.emat_ccod=1 and c.carr_ccod=d.carr_ccod")

post_ncorr= conexion.consultaUno("select post_ncorr from postulantes where pers_ncorr='"&pers_ncorr&"'and peri_ccod=210")
codeudor=conexion.consultaUno("select pers_ncorr from codeudor_postulacion where post_ncorr in(select post_ncorr from postulantes p,personas a where p.pers_ncorr='"&pers_ncorr&"' and peri_ccod= 210 )")

pare_ccod_codeudor=conexion.consultaUno("select pare_ccod from codeudor_postulacion where post_ncorr in(select post_ncorr from postulantes p,personas a where p.pers_ncorr='"&pers_ncorr&"' and peri_ccod= 210 )")

pers_mama=conexion.consultaUno("select pers_ncorr from grupo_familiar where post_ncorr="&post_ncorr&" and pare_ccod=2")
pers_papa=conexion.consultaUno("select pers_ncorr from grupo_familiar where post_ncorr="&post_ncorr&" and pare_ccod=1")

tiene_mama=conexion.consultaUno("select case count (*) when 0 then 'NO' else 'SI' end  from grupo_familiar where post_ncorr in(select post_ncorr from postulantes p,personas a where p.pers_ncorr='"&pers_ncorr&"'and peri_ccod= 210 and pare_ccod=2 )")

'persona_existe=conexion.consultaUno("select case count (*) when 0 then 'NO' else 'SI' end  from personas where pers_ncorr =protic.obtener_pers_ncorr1(isnull('"&z1_pers_nrut&"',0))"

tiene_papa=conexion.consultaUno("select case count (*) when 0 then 'NO' else 'SI' end  from grupo_familiar where post_ncorr in(select post_ncorr from postulantes p,personas a where p.pers_ncorr='"&pers_ncorr&"'and peri_ccod= 210 and pare_ccod=1 )")
		   
'response.Write("<pre>"&codeudor&"</pre>")		   
'---------------------------------------------------------------------------------------------------

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "tus_datos.xml", "botonera"

pers_ncorr_temporal=pers_ncorr

'---------------------------------------------------------------------------------------------------
set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "tus_datos.xml", "encabezado"
f_encabezado.Inicializar conexion

consulta = " select p.pers_ncorr,cast(pers_nrut as varchar)+'-'+pers_xdv as rut, " & vbCrLf &_
		   " pers_tnombre as nombres, pers_tape_paterno as ap_paterno, pers_tape_materno as ap_materno, pers_temail,pais_ccod," & vbCrLf &_
		   " datediff(year,pers_fnacimiento,getDate()) as edad, " & vbCrLf &_
		   " pers_tfono, pers_tcelular, dire_tcalle+' #'+dire_tnro as dir " & vbCrLf &_
		   " from personas p,direcciones d  " & vbCrLf &_
		   " where cast(p.pers_ncorr as varchar)= '" & pers_ncorr & "' and p.pers_ncorr=d.pers_ncorr and tdir_ccod=1"
		   

'response.Write("<pre>"&consulta&"</pre>")
f_encabezado.Consultar consulta
f_encabezado.Siguiente
'----------------------------------------------------------------------------------------------------


set f_padre = new CFormulario
f_padre.Carga_Parametros "tus_datos.xml", "papa"
f_padre.Inicializar conexion
if pare_ccod_codeudor = "1"  then 
consultap="select p.pers_ncorr, pers_nrut,pers_xdv,pers_tape_paterno,pers_tape_materno,pers_tnombre,eciv_ccod,nedu_ccod,dire_tfono,dire_tpoblacion,dire_tblock,dire_tnro,dire_tcalle,d.ciud_ccod,c.regi_ccod,nedu_ccod,sicupadre_ccod,sitocup_ccod from personas p,direcciones d,ciudades c where p.pers_ncorr='"&codeudor&"'and tdir_ccod=1 and p.pers_ncorr=d.pers_ncorr and d.ciud_ccod=c.ciud_ccod"
end if
if pare_ccod_codeudor <> "1" and  tiene_papa ="SI" then
consultap="select p.pers_ncorr, pers_nrut,pers_xdv,pers_tape_paterno,pers_tape_materno,pers_tnombre,eciv_ccod,nedu_ccod,dire_tfono,dire_tpoblacion,dire_tblock,dire_tnro,dire_tcalle,d.ciud_ccod,c.regi_ccod,nedu_ccod,sicupadre_ccod,sitocup_ccod from personas p,direcciones d,ciudades c where p.pers_ncorr='"&pers_papa&"'and tdir_ccod=1 and p.pers_ncorr=d.pers_ncorr and d.ciud_ccod=c.ciud_ccod"
end  if
if pare_ccod_codeudor <> "1" and  tiene_papa ="NO" then

consultap = "select '' "

end  if 
 
 'response.Write("<pre>" & consultap & "</pre>")

f_padre.Consultar consultap
f_padre.Siguiente

set f_madre = new CFormulario
f_madre.Carga_Parametros "tus_datos.xml", "mama"
f_madre.Inicializar conexion

if pare_ccod_codeudor = "2"  then 
consultam="select p.pers_ncorr, pers_nrut,pers_xdv,pers_tape_paterno,pers_tape_materno,pers_tnombre,eciv_ccod,nedu_ccod,dire_tfono,dire_tpoblacion,dire_tblock,dire_tnro,dire_tcalle,d.ciud_ccod,c.regi_ccod,nedu_ccod,sicupadre_ccod,sitocup_ccod from personas p,direcciones d,ciudades c where p.pers_ncorr='"&codeudor&"'and tdir_ccod=1 and p.pers_ncorr=d.pers_ncorr and d.ciud_ccod=c.ciud_ccod"
end if

if pare_ccod_codeudor <> "2" or tiene_mama ="SI"then 

consultam="select p.pers_ncorr,pers_nrut,pers_xdv,pers_tape_paterno,pers_tape_materno,pers_tnombre,eciv_ccod,nedu_ccod,dire_tfono,pers_tcelular,dire_tpoblacion,dire_tblock,dire_tnro,dire_tcalle,d.ciud_ccod,c.regi_ccod,nedu_ccod,sicupadre_ccod,sitocup_ccod from personas p,direcciones d,ciudades c where p.pers_ncorr='"&pers_mama&"' and tdir_ccod=1 and p.pers_ncorr=d.pers_ncorr and d.ciud_ccod=c.ciud_ccod"
end if


if pare_ccod_codeudor <> "2" and  tiene_mama ="NO" then
consultam = "select '' "
end  if
'response.Write("<pre>" & consultam & "</pre>")
  
f_madre.Consultar consultam
f_madre.Siguiente

set f_hermano1 = new CFormulario
f_hermano1.Carga_Parametros "tus_datos.xml", "hermano1"
f_hermano1.Inicializar conexion

consulta = "select '' "
'response.Write("<pre>" & consulta & "</pre>")
  
f_hermano1.Consultar consulta
f_hermano1.Siguiente

set f_hermano2 = new CFormulario
f_hermano2.Carga_Parametros "tus_datos.xml", "hermano2"
f_hermano2.Inicializar conexion

consulta = "select '' "
'response.Write("<pre>" & consulta & "</pre>")
  
f_hermano2.Consultar consulta
f_hermano2.Siguiente
set f_hermano3 = new CFormulario
f_hermano3.Carga_Parametros "tus_datos.xml", "hermano3"
f_hermano3.Inicializar conexion

consulta = "select '' "
'response.Write("<pre>" & consulta & "</pre>")
  
f_hermano3.Consultar consulta
f_hermano3.Siguiente


%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Tus Datos - Encuesta Universidad del Pac&iacute;fico</title>
<style type="text/css">
<!--
body {
	background-color: #dae4fa;
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
.Estilo39 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12pt;
	font-weight: bold;
	color: #FF7F00;
}
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
var trabaja;
trabaja = 0;

function valida_enfermedades()
{
//alert(document.edicion.elements["encu[0][tenfer_ccod]"].value);
	if (document.edicion.elements["encu[0][tenfer_ccod]"].value =='10')
	{
		
		document.edicion.elements["encu[0][otras]"].disabled=false;	
	}
	else
	{
			
		document.edicion.elements["encu[0][otras]"].disabled=true;
	}

}

function Validar_rut_papa()
{
	formulario = document.edicion;
	rut_alumno = formulario.elements["fpapa[0][pers_nrut]"].value + "-" + formulario.elements["fpapa[0][pers_xdv]"].value;	
	if (formulario.elements["fpapa[0][pers_nrut]"].value  != ''){
	  	  if (!valida_rut(rut_alumno)) {
		formulario.elements["fpapa[0][pers_nrut]"].focus();
		formulario.elements["fpapa[0][pers_nrut]"].select();
		return false;
	  }
	}

	return true;
}
function Validar_rut_mama()
{
	formulario = document.edicion;
	
	rut_alumno = formulario.elements["fmama[0][pers_nrut]"].value + "-" + formulario.elements["fmama[0][pers_xdv]"].value;	
	if (formulario.elements["fmama[0][pers_nrut]"].value  != ''){
  	  if (!valida_rut(rut_alumno)) {
		formulario.elements["fmama[0][pers_nrut]"].focus();
		formulario.elements["fmama[0][pers_nrut]"].select();
		return false;
	  }
	}

	return true;
}

function Validar_rut_her1()
{
	formulario = document.edicion;
	
	rut_alumno = formulario.elements["fhermano1[0][pers_nrut]"].value + "-" + formulario.elements["fhermano1[0][pers_xdv]"].value;	
	if (formulario.elements["fhermano1[0][pers_nrut]"].value  != ''){
  	  if (!valida_rut(rut_alumno)) {
		alert("Ingrese un RUT válido");
		formulario.elements["fhermano1[0][pers_nrut]"].focus();
		formulario.elements["fhermano1[0][pers_nrut]"].select();
		return false;
	  }
	}

	return true;
}
function Validar_rut_her2()
{
	formulario = document.edicion;
	
	rut_alumno = formulario.elements["fhermano2[0][pers_nrut]"].value + "-" + formulario.elements["fhermano2[0][pers_xdv]"].value;	
	if (formulario.elements["fhermano2[0][pers_nrut]"].value  != ''){
  	  if (!valida_rut(rut_alumno)) {
		alert("Ingrese un RUT válido");
		formulario.elements["fhermano2[0][pers_nrut]"].focus();
		formulario.elements["fhermano2[0][pers_nrut]"].select();
		return false;
	  }
	}

	return true;
}
function Validar_rut_her3()
{
	formulario = document.edicion;
	
	rut_alumno = formulario.elements["fhermano3[0][pers_nrut]"].value + "-" + formulario.elements["fhermano3[0][pers_xdv]"].value;	
	if (formulario.elements["fhermano3[0][pers_nrut]"].value  != ''){
  	  if (!valida_rut(rut_alumno)) {
		alert("Ingrese un RUT válido");
		formulario.elements["fhermano3[0][pers_nrut]"].focus();
		formulario.elements["fhermano3[0][pers_nrut]"].select();
		return false;
	  }
	}

	return true;
}






function activar_variable(valor)
{
    if(valor=='S')
	{trabaja = 1;}
	else
	{trabaja = 2;}
}

function validar()
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
  	if ((elemento.type=="radio") && (elemento.name!="encu[0][estudia_trabaja]"))
  		{cant_radios++;
		  if(elemento.checked){contestada++;}
  		}
  }

  if (contestada==((cant_radios)/divisor))
  { 
	 return true;
  }
  else
  {
   alert("Debe responder la encuesta antes de grabar,\n aún faltan preguntas por contestar.");
   return false;
  }
}

function valida_papa(valor)
{

	if (valor =='1')
	{
		
		document.edicion.elements["fpapa[0][ciud_ccod]"].disabled=true;
		document.edicion.elements["fpapa[0][regi_ccod]"].disabled=true;
		document.edicion.elements["fpapa[0][pers_tnombre]"].disabled=true;
		document.edicion.elements["fpapa[0][pers_tape_paterno]"].disabled=true;
		document.edicion.elements["fpapa[0][pers_tape_materno]"].disabled=true;
		document.edicion.elements["fpapa[0][pers_nrut]"].disabled=true;
		document.edicion.elements["fpapa[0][pers_xdv]"].disabled=true;	
		document.edicion.elements["fpapa[0][dire_tcalle]"].disabled=true;
		document.edicion.elements["fpapa[0][dire_tnro]"].disabled=true;
		document.edicion.elements["fpapa[0][dire_tblock]"].disabled=true;
		document.edicion.elements["fpapa[0][dire_tpoblacion]"].disabled=true;
		document.edicion.elements["fpapa[0][dire_tfono]"].disabled=true;
		document.edicion.elements["fpapa[0][pers_tcelular]"].disabled=true;
		document.edicion.elements["fpapa[0][eciv_ccod]"].disabled=true;	
		
	}
	else
	{
			
		document.edicion.elements["fpapa[0][ciud_ccod]"].disabled=false;
		document.edicion.elements["fpapa[0][regi_ccod]"].disabled=false;
		document.edicion.elements["fpapa[0][pers_tnombre]"].disabled=false;
		document.edicion.elements["fpapa[0][pers_tape_paterno]"].disabled=false;
		document.edicion.elements["fpapa[0][pers_tape_materno]"].disabled=false;
		document.edicion.elements["fpapa[0][pers_nrut]"].disabled=false;
		document.edicion.elements["fpapa[0][pers_xdv]"].disabled=false;
		document.edicion.elements["fpapa[0][dire_tcalle]"].disabled=false;
		document.edicion.elements["fpapa[0][dire_tnro]"].disabled=false;
		document.edicion.elements["fpapa[0][dire_tblock]"].disabled=false;
		document.edicion.elements["fpapa[0][dire_tpoblacion]"].disabled=false;
		document.edicion.elements["fpapa[0][dire_tfono]"].disabled=false;
		document.edicion.elements["fpapa[0][pers_tcelular]"].disabled=false;
		document.edicion.elements["fpapa[0][eciv_ccod]"].disabled=false;
		
			
	}

}
function valida_mama(valor)
{
	if (valor =='2')
	{
		
		document.edicion.elements["fmama[0][ciud_ccod]"].disabled=true;
		document.edicion.elements["fmama[0][regi_ccod]"].disabled=true;
		document.edicion.elements["fmama[0][pers_tnombre]"].disabled=true;
		document.edicion.elements["fmama[0][pers_tape_paterno]"].disabled=true;
		document.edicion.elements["fmama[0][pers_tape_materno]"].disabled=true;
		document.edicion.elements["fmama[0][pers_nrut]"].disabled=true;
		document.edicion.elements["fmama[0][pers_xdv]"].disabled=true;	
		document.edicion.elements["fmama[0][dire_tcalle]"].disabled=true;
		document.edicion.elements["fmama[0][dire_tnro]"].disabled=true;
		document.edicion.elements["fmama[0][dire_tblock]"].disabled=true;
		document.edicion.elements["fmama[0][dire_tpoblacion]"].disabled=true;
		document.edicion.elements["fmama[0][dire_tfono]"].disabled=true;
		document.edicion.elements["fmama[0][pers_tcelular]"].disabled=true;
		document.edicion.elements["fmama[0][eciv_ccod]"].disabled=true;	
		
	}
	else
	{
			
		document.edicion.elements["fmama[0][ciud_ccod]"].disabled=false;
		document.edicion.elements["fmama[0][regi_ccod]"].disabled=false;
		document.edicion.elements["fmama[0][pers_tnombre]"].disabled=false;
		document.edicion.elements["fmama[0][pers_tape_paterno]"].disabled=false;
		document.edicion.elements["fmama[0][pers_tape_materno]"].disabled=false;
		document.edicion.elements["fmama[0][pers_nrut]"].disabled=false;
		document.edicion.elements["fmama[0][pers_xdv]"].disabled=false;
		document.edicion.elements["fmama[0][dire_tcalle]"].disabled=false;
		document.edicion.elements["fmama[0][dire_tnro]"].disabled=false;
		document.edicion.elements["fmama[0][dire_tblock]"].disabled=false;
		document.edicion.elements["fmama[0][dire_tpoblacion]"].disabled=false;
		document.edicion.elements["fmama[0][dire_tfono]"].disabled=false;
		document.edicion.elements["fmama[0][pers_tcelular]"].disabled=false;
		document.edicion.elements["fmama[0][eciv_ccod]"].disabled=false;
				
	}
	
	
	
	

}
function vivo_papa(valor)
{
//alert("valor "+valor);
	if (valor =='N')
	{
		
		
		document.edicion.elements["fpapa[0][eciv_ccod]"].id="TO-S";
	}
	else
	{
			
		
		document.edicion.elements["fpapa[0][eciv_ccod]"].id="TO-N";	
	}
	
	
	
	

}
function vivo_mama(valor)
{
//alert("valor "+valor);
	if (valor =='N')
	{
		
	
		document.edicion.elements["fmama[0][eciv_ccod]"].id="TO-S";
	}
	else
	{
			
	
		document.edicion.elements["fmama[0][eciv_ccod]"].id="TO-N";	
	}
	
	
	
	

}
function PopWindow()
{

window.open('situaciones_ocupacional.asp','ocupaciones','width=600,height=500,menubar=n,scrollbars=yes,toolbar=no,location=no,directories=no,resizable=yes,top=0,left=0');

}

//-->
</script>
</head>

<body onLoad="valida_papa('<%=pare_ccod_codeudor%>');valida_mama('<%=pare_ccod_codeudor%>')">
<p align="center" class="Estilo35">&quot;Mis Datos &quot;</p>
<table width="100%" border="0">
<tr valign="top">
<td width="100%" align="center">
<form name="edicion">
<input type="hidden" name="encu[0][pers_ncorr]" value="<%=pers_ncorr%>">
<input type="hidden" name="encu[0][codeudor]" value="<%=codeudor%>">
<input type="hidden" name="encu[0][carr_ccod]" value="<%=cod_carrera%>">
<input type="hidden" name="fpapa[0][post_ncorr]" value="<%=post_ncorr%>">
<input type="hidden" name="fmama[0][post_ncorr]" value="<%=post_ncorr%>">
<input type="hidden" name="fhermano1[0][post_ncorr]" value="<%=post_ncorr%>">
<input type="hidden" name="fhermano2[0][post_ncorr]" value="<%=post_ncorr%>">
<input type="hidden" name="fhermano3[0][post_ncorr]" value="<%=post_ncorr%>">
<table width="700" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="25" height="24" background="images/borde_superior.jpg"><img width="25" height="24" src="images/superior_izquierda.jpg"></td>
	<td width="646" height="24">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr valign="bottom">
				<td width="100" height="24" background="images/borde_superior.jpg"><font size="3" color="#666666" face="Courier New, Courier, mono"><a href="<%=ruta2%>">Así soy yo</a></font></td>
			    <td width="29" height="24"><img width="29" height="24" src="images/superior_derecha.jpg"></td>
				<td width="25" height="24" background="images/borde_superior.jpg"><img width="25" height="24" src="images/superior_izquierda.jpg"></td>
			    <td width="100" height="24" background="images/borde_superior.jpg"><font size="3" color="#666666" face="Courier New, Courier, mono"><a href="<%=ruta%>"> Test</a></font></td>
				<td width="29" height="24"><img width="29" height="24" src="images/superior_derecha.jpg"></td>
				<td width="25" height="24" background="images/borde_superior.jpg"><img width="25" height="24" src="images/superior_izquierda.jpg"></td>
			    <td width="100" height="24" background="images/borde_superior.jpg"><font size="3" color="#666666" face="Courier New, Courier, mono"><a href="<%=ruta3%>"> Encuesta</a></font></td>
				<td width="29" height="24"><img width="29" height="24" src="images/superior_derecha.jpg"></td>
					<td width="25" height="24" background="images/borde_superior.jpg"><img width="25" height="24" src="images/superior_izquierda.jpg"></td>

				<td width="100" height="24" background="images/borde_superior.jpg"><span class="Estilo46">Mis Datos</span></td>
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
			<td align="left"><p class="Estilo27">::  Mis Datos </p>
				<p class="Estilo31">Por favor Completa estos datos .</p>
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
				  
				  <tr>
					<td class="Estilo31" width="20%">Carrera</td>
					<td class="Estilo31" width="2%">:</td>
					<td class="Estilo31" align="left"><%=carrera%></td>
				  </tr>
				  
				  <tr>
					<td class="Estilo31" width="20%">Direccion</td>
					<td class="Estilo31" width="2%">:</td>
					<td class="Estilo31" align="left"><%f_encabezado.DibujaCampo("dir")%></td>
				  </tr>
				  
				 
			  </table>
			  <p class="Estilo34">¿Tu direccion es correcta?</p>
			<table width="24%" border="0" cellpadding="0" cellspacing="0">
			  
			      <tr>
					<td width="27" valign="top" class="Estilo31"><p align="center">
						<input name="encu[0][dire_corr]" type="radio" value="S"  checked/>
					</p></td>
					<td width="26" valign="top" class="Estilo31">Si</td>
					<td width="43" valign="top" class="Estilo31"><p align="center">
						<input name="encu[0][dire_corr]" type="radio" value="N"  />
					</p></td>
					<td width="74" valign="top" class="Estilo31">No</td>
				  </tr>
				   </table>
				
				<p class="Estilo39">Situaci&oacute;n Ocupacional del Alumno</p>
			  
			    <table width="50%" border="0" cellpadding="0" cellspacing="0">
			  
			      <tr>
					<td width="38" valign="top" class="Estilo31"><p align="center">
						<input name="encu[0][estudia_trabaja]" type="radio" value="S"  checked/>
					</p></td>
					<td width="103" valign="top" class="Estilo31">Solo Estudia</td>
					<td width="43" valign="top" class="Estilo31"><p align="center">
						<input name="encu[0][estudia_trabaja]" type="radio" value="N"  />
					</p></td>
					<td width="120" valign="top" class="Estilo31">Estudia y Trabaja</td>
				  </tr>
				   </table>
				   <p class="Estilo39">Antecedentes Medicos</p>
			  
			  <table width="50%" border="0" cellpadding="0" cellspacing="0">
			  
			      <tr>
					<td width="32%">Tipos Enfermedades<br />
          <%f_encabezado.DibujaCampo("tenfer_ccod")%></td>
		  
				  </tr>
				  <tr><td width="32%">Detalla aqui<br />
          <%f_encabezado.DibujaCampo("otras")%></td></tr>
				   </table>
				  <p><font color="red">* RELLENA LOS DATOS AUNQUE NO SEPAS EL RUT</font></p>   
			   <p class="Estilo39">Antecedentes Grupo Familiar</p>
			  
			   	<table width="421" height="48">
                  <tr >PAPÁ</tr >
				  
  <td width="32%">R.U.T.<br />
          <%f_padre.DibujaCampo("pers_nrut")%>
    -
    <%f_padre.DibujaCampo("pers_xdv")%>
  </td>
  
  <td>
  <table width="155" height="26" valign="center">
  <td width="51" valign="top" class="Estilo31">¿Vive?</td>
     <td width="20" valign="top" class="Estilo31"><p align="center">
						<input name="fpapa[0][papa_vive]" type="radio" value="S" onClick="vivo_papa(this.value);" checked />
					</p></td>
					<td width="21" valign="top" class="Estilo31">Si</td>
					<td width="20" valign="top" class="Estilo31"><p align="center">
						<input name="fpapa[0][papa_vive]" type="radio" value="N" onClick="vivo_papa(this.value);" />
					</p></td>					
					<td width="147" valign="top" class="Estilo31">No</td>
					
      </table></td>
                </table>
			   	<table width="96%" height="38" border="0" cellpadding="0" cellspacing="0">
    <td>Apellido Paterno <br />
        <%f_padre.DibujaCampo("pers_tape_paterno")%></td>
		<td width="9%"></td>
    <td width="32%">Apellido Materno <br />
        <%f_padre.DibujaCampo("pers_tape_materno")%></td>
		<td width="9%"></td>
    <td width="36%">Nombres<br />
        <%f_padre.DibujaCampo("pers_tnombre")%></td>
  </tr>
   </table>
  <table width="82%" height="37" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td width="36%">Regi&oacute;n<br />
        <%f_padre.DibujaCampo("regi_ccod")%>    </td>
		<td width="18%"></td>
    <td width="46%">Ciudad <br />
        <%f_padre.DibujaCampo("ciud_ccod")%></td>
		
    
  </tr>
  </table>
    <table width="100%" height="37" border="0" cellpadding="0" cellspacing="0">
  <tr>
   
    <td width="26%">Est. Civil<br />
        <%f_padre.DibujaCampo("eciv_ccod")%></td>
  </tr>
  </table>
  <table width="86%" height="38" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td width="22%">Calle<br />
        <%f_padre.DibujaCampo("dire_tcalle")%></td>
		<td width="9%"></td>
    <td width="10%">N&uacute;mero<br />
        <%f_padre.DibujaCampo("dire_tnro")%></td>
		<td width="9%"></td>
    <td width="50%"> Depto<br />
        <%f_padre.DibujaCampo("dire_tblock")%>    </td>
  </tr>
  </table>
  <table width="80%" height="38" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td width="34%">Condominio/Conjunto<br />
        <%f_padre.DibujaCampo("dire_tpoblacion")%></td>
		<td width="3%"></td>
    <td width="27%">Tel&eacute;fono<br />
        <%f_padre.DibujaCampo("dire_tfono")%></td>
		<td width="3%"></td>
		<td width="33%">Celular<br />
        <%f_padre.DibujaCampo("pers_tcelular")%></td>
		
  </tr>
   </table>
   <table width="86%" height="38" border="0" cellpadding="0" cellspacing="0">
  <tr>
    
    <td width="70%" colspan="2">Email<br />
        <%f_padre.DibujaCampo("pers_temail")%></td>
  </tr>
 </table>			
<table width="50%" border="0" cellpadding="0" cellspacing="0">
	<td>Nivel Educacional  <font color="red">(Obligatorio)</font> <br />
        <%f_padre.DibujaCampo("nedu_ccod")%></td>		
</table>

<table width="21%" border="0" cellpadding="0" cellspacing="0">
	  <td> Situacion Ocupacional  <font color="red">(Obligatorio)</font> <br />
        <%f_padre.DibujaCampo("sicupadre_ccod")%></td>		
</table>
<br />
<table width="89%" border="0" cellpadding="0" cellspacing="0">


</table>
<table width="89%" border="0" cellpadding="0" cellspacing="0">
	  <td>Ocupacion Principal  <font color="red">(Obligatorio)</font>  <br />
	(Ocupación actual o la última que tuvo,si acaso actualmente no trabaja o fallecio )<br />
         <%f_botonera.dibujaBoton "ventana"%>
		 <%f_padre.DibujaCampo("sitocup_ccod")%></td>
		 		
</table>
<table width="89%" border="0" cellpadding="0" cellspacing="0">
	
		 <td width="20%">Parentesco <br />	
		<%f_padre.DibujaCampo("pare_ccod")%></td>
		  <td width="80%"> <br /> <%f_padre.DibujaCampo("pers_ncorr")%> </td>
		</tr>		
</table>

<table width="398" height="48">
<hr size="5" noshade="noshade" />
                              <tr >MAMÁ</tr >
  <td width="32%">R.U.T.<br />
          <%f_madre.DibujaCampo("pers_nrut")%>
    -
    <%f_madre.DibujaCampo("pers_xdv")%></td>
  <td>
  <table width="155" height="26" valign="center">
  <td width="51" valign="top" class="Estilo31">¿Vive?</td>
     <td width="20" valign="top" class="Estilo31"><p align="center">
						<input name="fmama[0][mama_vive]" type="radio" value="S" onClick="vivo_mama(this.value);" checked />
					</p></td>
					<td width="21" valign="top" class="Estilo31">Si</td>
					<td width="20" valign="top" class="Estilo31"><p align="center">
						<input name="fmama[0][mama_vive]" type="radio" value="N" onClick="vivo_mama(this.value);" />
					</p></td>					
					<td width="147" valign="top" class="Estilo31">No</td>
					
      </table></td>
   			        </table>
			   			    <table width="96%" height="38" border="0" cellpadding="0" cellspacing="0">
    <td>Apellido Paterno <br />
        <%f_madre.DibujaCampo("pers_tape_paterno")%></td>
		<td width="9%"></td>
    <td width="32%">Apellido Materno <br />
        <%f_madre.DibujaCampo("pers_tape_materno")%></td>
		<td width="9%"></td>
    <td width="36%">Nombres<br />
        <%f_madre.DibujaCampo("pers_tnombre")%></td>
  </tr>
   </table>
  <table width="82%" height="37" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td width="36%">Regi&oacute;n<br />
        <%f_madre.DibujaCampo("regi_ccod")%>    </td>
		<td width="18%"></td>
    <td width="46%">Ciudad <br />
        <%f_madre.DibujaCampo("ciud_ccod")%></td>
		
    
  </tr>
  </table>
    <table width="100%" height="37" border="0" cellpadding="0" cellspacing="0">
  <tr>
   
    <td width="26%">Est. Civil<br />
        <%f_madre.DibujaCampo("eciv_ccod")%></td>
  </tr>
  </table>
  <table width="86%" height="38" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td width="22%">Calle<br />
        <%f_madre.DibujaCampo("dire_tcalle")%></td>
		<td width="9%"></td>
    <td width="10%">N&uacute;mero<br />
        <%f_madre.DibujaCampo("dire_tnro")%></td>
		<td width="9%"></td>
    <td width="50%"> Depto<br />
        <%f_madre.DibujaCampo("dire_tblock")%>    </td>
  </tr>
  </table>
  <table width="80%" height="38" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td width="34%">Condominio/Conjunto<br />
        <%f_madre.DibujaCampo("dire_tpoblacion")%></td>
		<td width="3%"></td>
    <td width="27%">Tel&eacute;fono<br />
        <%f_madre.DibujaCampo("dire_tfono")%></td>
		<td width="3%"></td>
		<td width="33%">Celular<br />
        <%f_madre.DibujaCampo("pers_tcelular")%></td>
		
  </tr>
   </table>
   <table width="86%" height="38" border="0" cellpadding="0" cellspacing="0">
  <tr>
    
    <td width="70%" colspan="2">Email<br />
        <%f_madre.DibujaCampo("pers_temail")%></td>
  </tr>
 </table>			
<table width="64%" border="0" cellpadding="0" cellspacing="0">
	    <td>Nivel Educacional     <font color="red">(Obligatorio)</font><br />
        <%f_madre.DibujaCampo("nedu_ccod")%></td>		
</table>

<table width="26%" border="0" cellpadding="0" cellspacing="0">
	    <td> Situacion Ocupacional    <font color="red">(Obligatorio)</font><br />
        <%f_madre.DibujaCampo("sicupadre_ccod")%></td>		
</table>
<br />
<table width="89%" border="0" cellpadding="0" cellspacing="0">


</table>
<table width="89%" border="0" cellpadding="0" cellspacing="0">
	<td>Ocupacion Principal    <font color="red">(Obligatorio)</font><br />
	(Ocupación actual o la última que tuvo,si acaso actualmente no trabaja o fallecio )<br />
         <%f_botonera.dibujaBoton "ventana"%>
		 <%f_madre.DibujaCampo("sitocup_ccod")%></td>
		
		</tr>		
</table>
<table width="89%" border="0" cellpadding="0" cellspacing="0">

		 <td>Parentesco <br />	
		<%f_madre.DibujaCampo("pare_ccod")%></td>
		<td width="80%"> <br /> <%f_madre.DibujaCampo("pers_ncorr")%> </td>
		</tr>		
</table>
<table width="490" height="48">
<hr size="5" noshade="noshade" />
<tr >
  <td width="482"><font color="red">ESCRIBE LOS DATOS DE AQUELLOS HERMANOS QUE NO ESTUDIEN EN ESTA UNIVERSIDAD</font> </td>
</tr >
</table>
<table width="157" height="48">


                              <tr ><td>HERMANO</td></tr >
  <td width="32%">R.U.T.<br />
          <%f_hermano1.DibujaCampo("pers_nrut")%>
    -
    <%f_hermano1.DibujaCampo("pers_xdv")%></td>
  <tr> </tr>
   			        </table>
			   			    <table width="96%" height="38" border="0" cellpadding="0" cellspacing="0">
    <td>Apellido Paterno <br />
        <%f_hermano1.DibujaCampo("pers_tape_paterno")%></td>
		<td width="9%"></td>
    <td width="32%">Apellido Materno <br />
        <%f_hermano1.DibujaCampo("pers_tape_materno")%></td>
		<td width="9%"></td>
    <td width="36%">Nombres<br />
        <%f_hermano1.DibujaCampo("pers_tnombre")%></td>
  </tr>
   </table>
  
 <table width="89%" border="0" cellpadding="0" cellspacing="0">
	<td>Fecha de nacimiento <br />
	
         <%f_hermano1.DibujaCampo("pers_fnacimiento")%></td><td width="76%"><br />dd/mm/aaaa</td>		
</table>
<table width="31%" border="0" cellpadding="0" cellspacing="0">
	      <td>Situacion Ocupacional <br />
        <%f_hermano1.DibujaCampo("sicupadre_ccod")%></td>
		<tr>
		<td>Parentesco <br />	
		<%f_hermano1.DibujaCampo("pare_ccod")%></td>
		</tr>
		<td width="80%"> <br /> <%f_hermano1.DibujaCampo("pers_ncorr")%> </td>	
</table>

<table width="157" height="48">
<hr size="5" noshade="noshade" />
                              <tr ><td>HERMANO 2</td></tr >
  <td width="32%">R.U.T.<br />
          <%f_hermano2.DibujaCampo("pers_nrut")%>
    -
    <%f_hermano2.DibujaCampo("pers_xdv")%></td>
  <tr> </tr>
   			        </table>
			   			    <table width="96%" height="38" border="0" cellpadding="0" cellspacing="0">
    <td>Apellido Paterno <br />
        <%f_hermano2.DibujaCampo("pers_tape_paterno")%></td>
		<td width="9%"></td>
    <td width="32%">Apellido Materno <br />
        <%f_hermano2.DibujaCampo("pers_tape_materno")%></td>
		<td width="9%"></td>
    <td width="36%">Nombres<br />
        <%f_hermano2.DibujaCampo("pers_tnombre")%></td>
  </tr>
   </table>
  
 <table width="89%" border="0" cellpadding="0" cellspacing="0">
	<td>Fecha de nacimiento <br />
	
         <%f_hermano2.DibujaCampo("pers_fnacimiento")%></td><td width="76%"><br />dd/mm/aaaa</td>		
</table>
<table width="31%" border="0" cellpadding="0" cellspacing="0">
	      <td>Situacion Ocupacional <br />
        <%f_hermano2.DibujaCampo("sicupadre_ccod")%></td>
		<tr>
		<td>Parentesco <br />	
		<%f_hermano2.DibujaCampo("pare_ccod")%></td>
		</tr>
		<td width="80%"> <br />
		  <%f_hermano2.DibujaCampo("pers_ncorr")%></td>	
</table>
<table width="157" height="48">
<hr size="5" noshade="noshade" />
                              <tr >HERMANO</tr >
  <td width="32%">R.U.T.<br />
          <%f_hermano3.DibujaCampo("pers_nrut")%>
    -
    <%f_hermano3.DibujaCampo("pers_xdv")%></td>
  <tr> </tr>
   			        </table>
			   			    <table width="96%" height="38" border="0" cellpadding="0" cellspacing="0">
    <td>Apellido Paterno <br />
        <%f_hermano3.DibujaCampo("pers_tape_paterno")%></td>
		<td width="9%"></td>
    <td width="32%">Apellido Materno <br />
        <%f_hermano3.DibujaCampo("pers_tape_materno")%></td>
		<td width="9%"></td>
    <td width="36%">Nombres<br />
        <%f_hermano3.DibujaCampo("pers_tnombre")%></td>
  </tr>
   </table>
  
 <table width="89%" border="0" cellpadding="0" cellspacing="0">
	<td>Fecha de nacimiento <br />
	
         <%f_hermano3.DibujaCampo("pers_fnacimiento")%></td><td width="76%"><br />dd/mm/aaaa</td>		
</table>
<table width="31%" border="0" cellpadding="0" cellspacing="0">
	      <td>Situacion Ocupacional <br />
        <%f_hermano3.DibujaCampo("sicupadre_ccod")%></td>
		<tr>
		<td>Parentesco <br />	
		<%f_hermano3.DibujaCampo("pare_ccod")%></td>
		</tr>	
		<td width="80%"> <br /> <%f_hermano3.DibujaCampo("pers_ncorr")%> </td>
</table>
</tr>

 <tr>
			<td width="617"><p align="center" class="Estilo31">
			  <%f_botonera.dibujaBoton "guardar"%>
			</p></td>
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
