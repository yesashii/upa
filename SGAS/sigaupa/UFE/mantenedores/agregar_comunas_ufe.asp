<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

UHCIU_CCOD = request.QueryString("UHCIU_CCOD")
viene = request.QueryString("viene")

set pagina = new CPagina
pagina.Titulo = "Mantenedor De Carrera "
set botonera =  new CFormulario
botonera.carga_parametros "adm_comunas_ufe.xml", "btn_agregar_comunas"

'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

if UHCIU_CCOD <>"" then
consulta ="  select UHCIU_CCOD, UHCIU_CCOD as eliminar ,CODIGO_REGION, NOMBRE_REGION,  " & vbCrlf & _
		   " CODIGO_COMUNA, NOMBRE_COMUNA, CODIGO_CIUDAD, NOMBRE_CIUDAD  " & vbCrlf & _
 			" from  ufe_ciudades" & vbCrlf & _
			" where UHCIU_CCOD ="&UHCIU_CCOD & vbCrlf & _	
			" order  by CODIGO_REGION" 
else
consulta= "select ''"
end if
'response.Write(consulta)
'response.end()
set formulario 		= 		new cFormulario
formulario.carga_parametros	"adm_comunas_ufe.xml",	"tabla_valores"
formulario.inicializar		conectar
formulario.consultar 		consulta
formulario.siguientef
filas = formulario.nrofilas

'titulo_grado = formulario.obtenerValor("tgra_ccod")
'if titulo_grado <> "6" and titulo_grado <> "7" and titulo_grado <> "8" and titulo_grado <> "9"   then
'	formulario.agregaCampoParam "titulo_grado","deshabilitado","true"
'	formulario.agregaCampoParam "titulo_grado","id","TO-S"
'end if
''---------------------------------------------------------------------------------------------------
''---------------------------------------------------------------------------------------------------
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "adm_comunas_ufe.xml", "datos_extras"
 f_busqueda.inicializar conectar

 consulta="Select '"&formulario.obtenerValor("acar_ccod")&"' as acar_ccod, '"&formulario.obtenerValor("saca_ccod")&"' as saca_ccod"
 f_busqueda.consultar consulta

consulta =  " select a.acar_ccod,a.acar_tdesc, saca_ccod,saca_tdesc  " & vbCrLf & _
			" from areas_carreras a, sub_areas_carreras b  " & vbCrLf & _
			" where a.acar_ccod=b.acar_ccod " 
'response.Write("<pre>"&consulta&"</pre>")	
f_busqueda.inicializaListaDependiente "lBusqueda", consulta

f_busqueda.siguiente

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
	formulario.action = 'proc_agrega_comunas_ufe.asp';
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

function ExisteCodigo(v_car_ing_ccod){
//alert(v_car_ing_ccod)
	ajax=objetoAjax();
	ajax.open("POST", "existe_codigo_carr_ing.asp");
    ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    ajax.send("cod_carrera_ing="+v_car_ing_ccod+"");
    ajax.onreadystatechange=function()
    {
        
		if (ajax.readyState==4)
        {
            var XmlDatosCarrera=ajax.responseXML;
            XmlDatosCarrera = XmlDatosCarrera.getElementsByTagName('carrera');
			existe=XmlDatosCarrera[0].getAttribute('existe')
			cod=XmlDatosCarrera[0].getAttribute('cod_carrera_ing')
			descripccion=XmlDatosCarrera[0].getAttribute('nom_carrera_ing')
			ncorr=XmlDatosCarrera[0].getAttribute('car_ing_ncorr')
	
			if (existe=="S")
			{
				document.editar.elements["em[0][cod_carrera_ing]"].value=cod
				document.editar.elements["em[0][nom_carrera_ing]"].value=descripccion
				document.editar.elements["em[0][car_ing_ncorr]"].value=ncorr
				alert("Este Codigo ya existe")
			}

	     }
     }
	
}




//****************************************************************************************************************************************************
</script>
</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="650" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
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
                <table width="90%" border="0" align="center">
                  <tr>
                    <td width="21%"><font color="#CC3300">*</font> C&oacute;d Region</td>
                    <td width="79%">:<%formulario.dibujacampo("CODIGO_REGION")%></td>
                  </tr>
                  <tr>
                    <td><font color="#CC3300">*</font> Nom Region</td>
                    <td>:<%formulario.dibujacampo("NOMBRE_REGION")%></td>
                  </tr>
                   
                  <tr>
                    <td><font color="#CC3300">*</font> Cod Comuna</td>
                    <td>:<%formulario.dibujacampo("CODIGO_COMUNA")%></td>
                  </tr>
                  <tr>
                    <td><font color="#CC3300">*</font> Nom Comuna</td>
                    <td>:<%formulario.dibujacampo("NOMBRE_COMUNA")%></td>
                  </tr>
                  <tr>
                    <td><font color="#CC3300">*</font> Cod Ciudad</td>
                    <td>:<%formulario.dibujacampo("CODIGO_CIUDAD")%></td>
                  </tr>
                  <tr>
                    <td><font color="#CC3300">*</font> Nom Ciudad</td>
                    <td>:<%formulario.dibujacampo("NOMBRE_CIUDAD")%></td>
                  </tr>
                  
                  
                  <tr>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                  </tr>
                </table>
				<input type="hidden" name="em[0][UHCIU_CCOD]" value="<%=UHCIU_CCOD%>">
				<input type="hidden" name="inserta" value="<%=viene%>">

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
