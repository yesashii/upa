<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
aran_ccor = request.QueryString("aran_ccor")
viene = request.QueryString("viene")

set pagina = new CPagina
pagina.Titulo = "Mantenedor De Carrera "
set botonera =  new CFormulario
botonera.carga_parametros "adm_aranceles_ext.xml", "btn_agregar_carrera"

'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

if aran_ccor <>"" then

consulta= 	"select a.aran_ccor,c.carr_tdesc,c.carr_ccod, b.jorn_tdesc,b.jorn_ccod, a.anos_ccod, a.arancel_ext " & vbCrlf & _	
			" from ufe_aranceles_ext a, jornadas b, carreras c  " & vbCrlf & _	
			" where a.jorn_ccod=b.jorn_ccod and a.carr_ccod COLLATE Modern_Spanish_CI_AS= c.carr_ccod" & vbCrlf & _	
			" and a.aran_ccor ="&aran_ccor 
'response.Write(consulta)
'	response.end()
else
consulta= "select ''"
end if
'response.Write(consulta)
'response.end()

set formulario 		= 		new cFormulario
formulario.carga_parametros	"adm_aranceles_ext.xml",	"tabla_valores"
formulario.inicializar		conectar
formulario.consultar 		consulta
formulario.siguientef

filas = formulario.nrofilas

 set f_ingreso = new CFormulario
 f_ingreso.Carga_Parametros "adm_aranceles_ext.xml", "f_ingreso"
 
 f_ingreso.Inicializar conectar
 
 consulta = "Select '"&anos_ccod&"' as anos_ccod, '"&jorn_ccod&"' as jorn_ccod, '"&carr_ccod&"' as carr_ccod "
 f_ingreso.consultar consulta

 consulta = "select c.carr_ccod,c.carr_tdesc,d.jorn_ccod,d.jorn_tdesc,anos_ccod" & vbCrlf & _
			"from  ofertas_academicas a, especialidades b ,carreras c, jornadas d, periodos_Academicos e" & vbCrlf & _
			"where a.espe_ccod=b.espe_ccod" & vbCrlf & _
			"and b.carr_ccod=c.carr_ccod" & vbCrlf & _
			"and a.jorn_ccod=d.jorn_ccod " & vbCrlf & _
			"and a.peri_ccod=e.peri_ccod" & vbCrlf & _
			"and c.carr_ccod not in (820,001)" & vbCrlf & _
			"and anos_ccod >2005" & vbCrlf & _
			"and (select count(*) from ufe_aranceles_ext zz where zz.jorn_ccod=a.jorn_ccod and zz.carr_ccod COLLATE Modern_Spanish_CI_AS=b.carr_ccod and zz.anos_ccod=e.anos_ccod)< 1 " & vbCrlf & _
			"group by c.carr_ccod,c.carr_tdesc,d.jorn_ccod,d.jorn_tdesc,anos_ccod" & vbCrlf & _
			"order by anos_ccod,c.carr_tdesc"

'response.Write(consulta)		

 f_ingreso.inicializaListaDependiente "lBusqueda", consulta
 
 f_ingreso.Siguiente
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
	formulario.action = 'proc_agrega_aranceles_ext.asp';
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
<% f_ingreso.generaJS %>
</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="800" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
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
                    <td width="15%">A&ntilde;o</td>
                    <td width="85%">:
                      <%
									if aran_ccor <> "" then 
										 formulario.agregacampoparam "anos_ccod", "permiso", "lectura"
										 formulario.dibujacampo("anos_ccod")
									else
									    f_ingreso.dibujaCampoLista "lBusqueda", "anos_ccod" 	 
									end if
									 %>
					<input type="hidden" value="<%=aran_ccor%>" name="em[0][aran_ccor]" />					</td>
                  </tr>
                   <tr>
                    <td>Jornada</td>
                    <td>: <%
							if aran_ccor <> "" then 
							 	formulario.agregacampoparam "jorn_ccod", "permiso", "lectura"
								formulario.dibujacampo("jorn_ccod")
							else
									     f_ingreso.dibujaCampoLista "lBusqueda", "jorn_ccod" 	 
							end if				
							
						%></td>
                  </tr>
				  <tr>
                  <tr>
                    <td>Carrera</td>
                    <td>: <%
							if aran_ccor <> "" then 
								 formulario.agregacampoparam "carr_ccod", "permiso", "lectura"
								 formulario.dibujacampo("carr_ccod")
							else
								 f_ingreso.dibujaCampoLista "lBusqueda", "carr_ccod" 	 
							end if
							
						%></td>
                  </tr>
                 
                    <td>Arancel REF.</td>
                    <td>: <%formulario.dibujacampo("arancel_ext")%></td>
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
