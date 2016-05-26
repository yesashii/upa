<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

carr_ccod = request.QueryString("carr_ccod")
viene = request.QueryString("viene")

set pagina = new CPagina
pagina.Titulo = "Mantenedor De Carrera "
set botonera =  new CFormulario
botonera.carga_parametros "adm_carreras.xml", "btn_agregar_carrera"

'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

consulta="select area_ccod,inst_ccod,ecar_ccod,carr_tdesc,convert(varchar,carr_fini_vigencia,103) as carr_fini_vigencia,convert(varchar,carr_ffin_vigencia,103) as  carr_ffin_vigencia from carreras where carr_ccod = '"&carr_ccod&"'"
set formulario 		= 		new cFormulario
formulario.carga_parametros	"adm_carreras.xml",	"tabla_valores"
formulario.inicializar		conectar
formulario.consultar 		consulta
formulario.siguientef
filas = formulario.nrofilas

'---------------------------------------------------------------------------------------------------


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
	formulario.action = 'proc_agrega_carrera.asp';
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

</script>
<%
	set calendario = new FCalendario
	'calendario.Inicializa "editar","fecha_oculta"
	calendario.IniciaFuncion
	calendario.MuestraFecha "em[0][CARR_FINI_VIGENCIA]","1","editar","fecha_oculta_CARR_FINI_VIGENCIA"
	calendario.MuestraFecha "em[0][CARR_FFIN_VIGENCIA]","2","editar","fecha_oculta_CARR_FFIN_VIGENCIA"
	calendario.FinFuncion
%>
</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
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
                    <td width="31%"> C&oacute;digo</td>
                    <td width="69%">: <strong><%response.Write(carr_ccod)%></strong></td>
                  </tr>
                  <tr>
                    <td><font color="#CC3300">*</font> Escuela</td>
                    <td>:<%formulario.dibujacampo("area_ccod")%></td>
                  </tr>
                  <tr>
                    <td><font color="#CC3300">*</font> Instituci&oacute;n</td>
                    <td>:<%formulario.dibujacampo("inst_ccod")%></td>
                  </tr>
                  <tr>
                    <td><font color="#CC3300">*</font> Estado</td>
                    <td>:<%formulario.dibujacampo("ECAR_CCOD")%></td>
                  </tr>
                  <tr>
                    <td><font color="#CC3300">*</font> Nombre</td>
                    <td>:<%formulario.dibujacampo("carr_tdesc")%></td>
                  </tr>
                  <tr>
                    <td> Fecha Inicio </td>
                    <td>:<%formulario.dibujacampo("CARR_FINI_VIGENCIA")%> 
						<%calendario.DibujaImagen "fecha_oculta_CARR_FINI_VIGENCIA","1","editar" %>
						(dd/mm/aaaa)
					</td>
                  </tr>
                  <tr>
                    <td>Fecha Termino </td>
                    <td>:<%formulario.dibujacampo("CARR_FFIN_VIGENCIA")%>
						<%calendario.DibujaImagen "fecha_oculta_CARR_FFIN_VIGENCIA","2","editar" %>(dd/mm/aaaa)
					</td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                  </tr>
                </table>
				<input type="hidden" name="em[0][carr_ccod]" value="<%=carr_ccod%>">
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
                  <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%botonera.dibujaboton "GUARDAR"%>
                  </font>
                  </div></td>
                  <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%botonera.dibujaboton "SALIR"%>
                  </font> </div></td>
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
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
