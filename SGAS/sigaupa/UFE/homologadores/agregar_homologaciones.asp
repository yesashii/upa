<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

carr_ccod = request.QueryString("carr_ccod")
viene = request.QueryString("viene")

set pagina = new CPagina
pagina.Titulo = "Mantenedor De Carrera "
set botonera =  new CFormulario
botonera.carga_parametros "adm_homologaciones.xml", "btn_agregar_carrera"

'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

if carr_ccod <>"" then
consulta =  "SELECT CARRERAS.CARR_CCOD,CARRERAS.CARR_TDESC, ufe_carreras_ingresa.cod_carrera_ing,ttie_ccod, " & vbCrlf & _             
            " ufe_carreras_mineduc.cod_carrera_min, ufe_carreras_homologadas.car_ing_ncorr, ufe_carreras_homologadas.car_min_ncorr,car_duracion_semestres,car_duracion_anos  " & vbCrlf & _
            "FROM         ufe_carreras_homologadas LEFT OUTER JOIN " & vbCrlf & _
            "CARRERAS ON ufe_carreras_homologadas.carr_ccod COLLATE Modern_Spanish_CI_AS = CARRERAS.CARR_CCOD LEFT OUTER JOIN " & vbCrlf & _
            "ufe_carreras_ingresa ON ufe_carreras_homologadas.car_ing_ncorr = ufe_carreras_ingresa.car_ing_ncorr LEFT OUTER JOIN "& vbCrlf & _
            "ufe_carreras_mineduc ON ufe_carreras_homologadas.car_min_ncorr = ufe_carreras_mineduc.car_min_ncorr "& vbCrlf & _
			" where CARRERAS.carr_ccod ="&carr_ccod& vbCrlf & _	
			" order  by CARRERAS.CARR_TDESC" 
	'response.Write(consulta)
	'	response.end()
else
consulta= "select ''"
end if
'response.Write(consulta)
'response.end()

consulta_carrera=	"(select distinct d.carr_ccod,d.carr_tdesc " & vbCrlf & _ 
				  	"from alumnos a, ofertas_academicas b, especialidades c, carreras d, periodos_academicos e " & vbCrlf & _ 
				  	"where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod " & vbCrlf & _ 
				  	"and b.peri_ccod=e.peri_ccod and a.emat_ccod = 1 and a.alum_nmatricula <> 7777 " & vbCrlf & _ 
				  	"and e.anos_ccod >= 2008 and d.tcar_ccod = 1 " & vbCrlf & _ 
				  	"and not exists (select 1 from ufe_carreras_homologadas tt " & vbCrlf & _ 
                	"where tt.carr_ccod collate Modern_Spanish_CI_AS = d.carr_ccod)) a"

set formulario 		= 		new cFormulario
formulario.carga_parametros	"adm_homologaciones.xml",	"tabla_valores"

formulario.inicializar		conectar
formulario.agregacampoparam "carr_ccod", "destino", consulta_carrera

formulario.consultar 		consulta
formulario.siguientef

filas = formulario.nrofilas



%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>

<script language="JavaScript">
function agregar(formulario){
	formulario.action = 'proc_agrega_homologacion.asp';
  	if(preValidaFormulario(formulario)){	
		formulario.submit();
	}
 }
 
function salir(){
viene ='<%=viene%>'
if (viene !=1){
	self.opener.location.reload();
}
else{
	self.opener.close();
	self.opener.opener.location.reload();
}	
window.close();
}

function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if%>
}

function habilita (valor, formulario)
{
var titulo_grado = MM_findObj('em[0][titulo_grado]', document);
	
 	if ((valor == '6') || (valor == '7') || (valor == '8') || (valor == '9')){
		
        titulo_grado.disabled = false; 
		titulo_grado.id = "TO-N"; 
	 }
	 else
	 {
	 	titulo_grado.disabled = true; 
		titulo_grado.id = "TO-S";
	 }
}
//*****************************************NO BORRAR EN LA PARTE AJAX*********************************************************************************

function objetoAjax(){
	var xmlhttp=false;
	try {
		xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
	} catch (e) {
		try {
		   xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
		} catch (E) {
			xmlhttp = false;
  		}
	}

	if (!xmlhttp && typeof XMLHttpRequest!='undefined') {
		xmlhttp = new XMLHttpRequest();
	}
	return xmlhttp;
}

function ExisteCodigo(v_car_min_ccod){
//alert(v_car_ing_ccod)
	ajax=objetoAjax();
	ajax.open("POST", "existe_codigo_carr_min.asp");
    ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    ajax.send("cod_carrera_min="+v_car_min_ccod+"");
    ajax.onreadystatechange=function()
    {
        
		if (ajax.readyState==4)
        {
            var XmlDatosCarrera=ajax.responseXML;
            XmlDatosCarrera = XmlDatosCarrera.getElementsByTagName('carrera');
			existe=XmlDatosCarrera[0].getAttribute('existe')
			cod=XmlDatosCarrera[0].getAttribute('cod_carrera_min')
			descripccion=XmlDatosCarrera[0].getAttribute('nom_carrera_min')
			ncorr=XmlDatosCarrera[0].getAttribute('car_min_ncorr')
	
				// alert(existe)
			if (existe=="S")
			{
				document.editar.elements["em[0][cod_carrera_min]"].value=cod
				document.editar.elements["em[0][nom_carrera_min]"].value=descripccion
				document.editar.elements["em[0][car_min_ncorr]"].value=descripccion
				alert("Este Codigo ya existe")
				
			}

	     }
     }
	
}





//****************************************************************************************************************************************************
</script>
</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="700" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">	<br>
      <br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Mantenedor De Carrera"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><br><%pagina.DibujarSubtitulo "Datos De La Carrera "%>
<font color="#CC3300">*</font>Campos Obligatorios            
  <form name="editar" method="post">
                <table width="100%" border="0" align="center">
                  <tr>
                    <td width="15%">C&oacute;digo</td>
                    <td width="85%">: <%
					if carr_ccod <> "" then
					formulario.dibujacampo("CARR_TDESC") 
					%>
					<input type="hidden" value="<%=carr_ccod%>" name="em[0][carr_ccod]" />
					<%else
					formulario.dibujacampo("carr_ccod")
					
					end if
					%></td>
                  </tr>
                  <tr>
                    <td>Cod Ingresa</td>
                    <td>:<%formulario.dibujacampo("car_ing_ncorr")%></td>
                  </tr>
                  <tr>
                    <td>Cod Mineduc</td>
                    <td>:<%formulario.dibujacampo("car_min_ncorr")%></td>
                  </tr>
                </table>
			

                </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="21%" height="20"><div align="center">
              <table width="82%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%botonera.dibujaboton "GUARDAR"%>
                  </font>
                  </div></td>
                  <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%botonera.dibujaboton "SALIR"%>
                  </font> </div></td>
                  <td><div align="center"></div></td>
                </tr>
              </table>
            </div></td>
            <td width="79%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
