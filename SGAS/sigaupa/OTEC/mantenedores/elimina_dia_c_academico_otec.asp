<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'----------------------------------------------*********captura de get
fecha_calendario = request.QueryString("fecha")
pcot_ncorr = request.QueryString("pcot_ncorr")
seot_ncorr = request.QueryString("seot_ncorr")
dgso_ncorr = request.QueryString("dgso_ncorr")
'----------------------------------------------*********captura de get
set pagina = new CPagina
pagina.Titulo = "Mantenedor De MÃ³dulos"

set botonera =  new CFormulario
botonera.carga_parametros "calendario_academico_otec.xml", "botonera_2"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'---------------------------------------------------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "calendario_academico_otec.xml", "edicion_modulos"
formulario.inicializar conexion
'----------------------------------------------********carga de variables al xml
consulta_1 = "" & vbCrLf & _
"select '"&pcot_ncorr&"' as pcot_ncorr,  '"&fecha_calendario&"' as fecha_calendario,  '"&seot_ncorr&"' as seot_ncorr "
formulario.consultar consulta_1 
formulario.siguiente
'----------------------------------------------********carga de variables al xml
'***************************'
'* DESTUNO DE LAS PESTAÑAS *'
'************************************************************************'
url_leng_1 = "asigna_relator_c_academico_otec.asp?fecha="& fecha_calendario &"&pcot_ncorr="& pcot_ncorr &"&seot_ncorr="& seot_ncorr &"&dgso_ncorr="& dgso_ncorr 
url_leng_2 = "elimina_dia_c_academico_otec.asp?fecha="& fecha_calendario &"&pcot_ncorr="& pcot_ncorr &"&seot_ncorr="& seot_ncorr &"&dgso_ncorr="& dgso_ncorr 
'************************************************************************'
'* DESTUNO DE LAS PESTAÑAS *'
'***************************'
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

<script type = "text/javascript" language="JavaScript">
function guardar(formulario)
{
	formulario.submit();
}	
function volver(){
	CerrarActualizar();
}

function validaCambios(){
	alert("..");
	return false;
}

</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="380" border="0" align="center" cellpadding="0" cellspacing="0">
<tr><td>&nbsp;</td>
</tr>
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
           <td><% pagina.DibujarLenguetas Array(Array("Asignar a un relator", url_leng_1), Array("Eliminaci&oacute;n del d&iacute;a: "& fecha_calendario , url_leng_2)), 2 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
              <form name="edicion" action="proc_elimina_dia_c_academico_otec.asp" method="post">
			  <table width="100%"  border="0">
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td><%pagina.DibujarSubtitulo "Ingrese el motivo de la eliminación"%></td>
				</tr>  
			</table>
            <table width="98%" align="center">
              <tr> 
              	<td><%=formulario.dibujaCampo("motivo")%></td>
              </tr>  
<tr>
<td><%=formulario.dibujaCampo("fecha_calendario")%></td>
<td><%=formulario.dibujaCampo("pcot_ncorr")%></td>
<td><%=formulario.dibujaCampo("seot_ncorr")%></td>
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
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%botonera.dibujaboton "guardar_2"%></div></td>
                  <td><div align="center"><%botonera.dibujaboton "volver_2"%></div></td>
                  <td><div align="center"></div></td>
                </tr>
              </table>
            </div></td>
            <td width="62%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	</td>
  </tr>  
</table>
</body>
</html>
