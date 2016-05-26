<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
dgso_ncorr = request.querystring("dgso_ncorr")
pote_ncorr = request.QueryString("pote_ncorr")


set pagina = new CPagina
pagina.Titulo = "Agregar Observaciones a alumnos"

set botonera =  new CFormulario
botonera.carga_parametros "detalle_postulacion_new.xml", "botonera"
'response.End()
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores 	= new cErrores

rut = conexion.consultaUno("select cast(pers_nrut as varchar)+'-'+pers_xdv from postulacion_otec a, personas b where a.pers_ncorr=b.pers_ncorr and cast(a.pote_ncorr as varchar)='"&pote_ncorr&"'")

nombre = conexion.consultaUno("select pers_tnombre + ' ' + pers_tape_paterno from postulacion_otec a, personas b where a.pers_ncorr=b.pers_ncorr and cast(a.pote_ncorr as varchar)='"&pote_ncorr&"'")

programa = conexion.consultaUno("select dcur_tdesc from datos_generales_secciones_otec a, diplomados_cursos b where a.dcur_ncorr=b.dcur_ncorr and cast(a.dgso_ncorr as varchar)='"&dgso_ncorr&"'")

set f_observacion = new cformulario
f_observacion.carga_parametros "detalle_postulacion_new.xml","f_detalle_otec_extension"
f_observacion.inicializar conexion

f_observacion.Consultar "select "&dgso_ncorr&" as dgso_ncorr, "&pote_ncorr&" as pote_ncorr"
f_observacion.siguiente
	

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

<script language="JavaScript">
function enviar(formulario){
    var dcur_ncorr = '<%=dcur_ncorr%>';
	formulario.action = 'editar_programas_dcurso.asp';
  	if(preValidaFormulario(formulario)){	
		formulario.submit();
		
	}
}
function abrir() {
	
	direccion = "editar_modulos.asp?codigo=<%=mote_ccod%>";
	resultado=window.open(direccion, "ventana1","width=400,height=200,scrollbars=no, left=380, top=350");
	
 // window.close();
}
function salir(){
window.close()
}

</script>

</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="500" height="100%">
<tr>
	<td bgcolor="#EAEAEA">
     <table width="500" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
         <td valign="top" bgcolor="#EAEAEA" align="center"></td>
	  </tr>
	
	
   <td valign="top" bgcolor="#EAEAEA" align="left">
	<table width="93%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr valign="top">
            <td>
                <table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <tr>
                    <td><div align="center"><%pagina.DibujarTituloPagina%> <br></div></td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <tr>
                    <td align="center">
                        <form name="edicion">
                        <%f_observacion.dibujaCampo("pote_ncorr")%>
                        <%f_observacion.dibujaCampo("dgso_ncorr")%>
                    	<table width="98%">
                        	<tr>
                                <td width="20%" align="left"><strong>Rut</strong></td>
                                <td width="3%" align="center"><strong>:</strong></td>
                                <td width="77%" align="left"><%=rut%></td>
                            </tr>
                            <tr>
                                <td width="20%" align="left"><strong>Nombre</strong></td>
                                <td width="3%" align="center"><strong>:</strong></td>
                                <td width="77%" align="left"><%=nombre%></td>
                            </tr>
                            <tr>
                                <td width="20%" align="left"><strong>Programa</strong></td>
                                <td width="3%" align="center"><strong>:</strong></td>
                                <td width="77%" align="left"><%=programa%></td>
                            </tr>
                            <tr>
                                <td width="20%" align="left"><strong>Estado</strong></td>
                                <td width="3%" align="center"><strong>:</strong></td>
                                <td width="77%" align="left"><%f_observacion.dibujaCampo("eopo_ccod")%></td>
                            </tr>
                            <tr>
                                <td width="20%" align="left"><strong>Observación</strong></td>
                                <td width="3%" align="center"><strong>:</strong></td>
                                <td width="77%" align="left"><%f_observacion.dibujaCampo("obpo_tobservacion")%></td>
                            </tr>
                        </table>
                        </form>
                    </td>
                  </tr> 
				</table>
                <br>
            </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="28%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%botonera.dibujaboton "guardar"%></div></td>
                  <td><div align="center"><%botonera.dibujaboton "cancelar"%></div></td>
                </tr>
              </table>
            </div></td>
            <td width="72%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
</td>
</tr>
</table>
</body>
</html>
