<!-- #include file = "../biblioteca/_conexion.asp" -->

<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

'---------------------------------------------------------------------------------------------------
set errores = new CErrores

set pagina = new CPagina
pagina.Titulo = "Convenios Internacionales"


'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "genera_pdf_rrii.xml", "botonera"



set datos = new CFormulario
datos.Carga_Parametros "genera_pdf_rrii.xml", "busqueda"
datos.Inicializar conexion
sql_descuentos="select ''"				
datos.Consultar sql_descuentos
datos.siguiente


%>

<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />

<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript" src="jquery-1.6.2.min.js"></script>

<script language="JavaScript">

function abre_ventana()
{
nrut=document.pdf.elements['b[0][pers_nrut]'].value
peri=document.pdf.elements['b[0][peri_ccod]'].value
carr=document.pdf.elements['b[0][carr_ccod]'].value


	if ((nrut!='')&&(peri=!'')&&(carr=!''))
	{
			datos_envi= $("form").serialize();
			window.open('datos_postulante_pdf.asp?'+datos_envi+'','popup','width=1240,height=768')
	}
	else
	{
		alert("Debes ingresar el rut del alumno y seleccionar un periodo académico y la carrera")
	
	}
}

function revisa_activa()
{
rut=document.pdf.elements['b[0][pers_nrut]'].value+'-'+document.pdf.elements['b[0][pers_xdv]'].value
//alert(rut)
resul=valida_rut(rut)
//alert(resul)
	if (resul)
	{
		es_alumno_periodo()
	
	}
	else
	{
		document.pdf.elements['b[0][pers_nrut]'].focus()
		document.pdf.elements['b[0][pers_nrut]'].select()
		datos='';
		$("#carr_ccod").html(datos);
		alert('Debes ingresar un rut Válido')
	}

}
	
function es_alumno_periodo()
{

			datos_envi= $("form").serialize();
			//alert(datos_envi)
			//location.href="genera_link.asp?"+datos_envi
		$.ajax({
				url: "es_alumno_periodo.asp",
				beforeSend: function(objeto){
					$("#foto").css("display","inline");  
				},
				complete: function(objeto, exito){
					$("#foto").css("display","none");
					if(exito=="success"){}
				},
				data: datos_envi, 
				dataType: "json",
				error: function(objeto, quepaso, otroobj){
					alert("Error: "+quepaso+" "+otroobj);
				},
				success: function(datos){
					
					//alert(datos.esalumno)
					
					if(datos.esalumno=='N')
					{
					  datos='';
					  $("#carr_ccod").html(datos);
					  alert("El alumno no tiene tiene matricula activa para el periodo academico seleccionado")
					} 
					else if(datos.esalumno=='S')
					{
						carrera_alumno()
					}
					
				},
				type: "POST"
		});
	

}					

function carrera_alumno()
{

			datos_envi= $("form").serialize();
			//alert(datos_envi)
			//location.href="genera_link.asp?"+datos_envi
	
		$.ajax({
				url: "carreras_alumno.asp",
				beforeSend: function(objeto){
					$("#foto").css("display","inline");  
				},
				complete: function(objeto, exito){
					$("#foto").css("display","none");
					if(exito=="success"){
						$("#link").css("display","inline");
						$("#fex").css("display","inline");
					}
				},
				data: datos_envi, 
				dataType: "html",
				error: function(objeto, quepaso, otroobj){
					alert("Error: "+quepaso+" "+otroobj);
				},
				success: function(datos){
				//alert(datos)
					$("#carr_ccod").html(datos);
				},
				type: "POST"
		});
	

}	


function activa_rut()
{
	peri=document.pdf.elements['b[0][peri_ccod]'].value
	if (peri!='')
	{
		document.pdf.elements['b[0][pers_nrut]'].disabled=false
		document.pdf.elements['b[0][pers_xdv]'].disabled=false
		
		rut=document.pdf.elements['b[0][pers_nrut]'].value
		xdv=document.pdf.elements['b[0][pers_xdv]'].value
		
		if ((rut!='')&&(xdv!=''))
		{
			es_alumno_periodo()
		}
	}
}
			
</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');" onBlur="revisaVentana();">
<table width="750"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td><%pagina.DibujarLenguetas Array("Impresion Datos Alumnos"), 1 %></td>
				  </tr>
				  <tr>
					<td height="2" background="../imagenes/top_r3_c2.gif"></td>
				  </tr>
				  <tr>
					<td>
						 
						<form name="pdf" id="form">
							<br>
							
							<table align="center" width="100%">
								<tr>
								  <td width="29%"><strong>Periodo Acad&eacute;mico Intercambio </strong></td>
								  <td width="71%"><%datos.DibujaCampo("peri_ccod")%></td>
								</tr>
								<tr>
								  <td width="29%"><strong>Rut Alumno </strong></td>
								  <td width="71%"><%datos.DibujaCampo("pers_nrut")%>-<%datos.DibujaCampo("pers_xdv")%></td>
								</tr>
								<tr>
								  <td width="29%"><strong>Carrera </strong></td>
								  <td width="71%"><select name="b[0][carr_ccod]" id="carr_ccod" ></select></td>
								</tr>
								
							</table>
						 </form>
					</td>
				  </tr>
        	</table>
		</td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
     <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="31%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
				 <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>	
                  <td><div align="center">
					<%f_botonera.DibujaBoton"imprimir"%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="69%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>

	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>