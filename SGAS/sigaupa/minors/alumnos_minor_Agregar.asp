<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

minr_ncorr = request.querystring("minr_ncorr")

pagina.Titulo = "Agregar Alumno al Minor"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'----------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "alumnos_minor.xml", "botonera"
'----------------------------------------------------------------



minr_tdesc = conexion.consultauno("SELECT minr_tdesc FROM minors WHERE cast(minr_ncorr as varchar) = '" & minr_ncorr & "'")
'----------------------------------------------------------------
set f_nueva = new CFormulario
f_nueva.Carga_Parametros "alumnos_minor.xml", "f_nueva"
f_nueva.Inicializar conexion
   consulta = "select '' as pers_nrut , '' as pers_xdv, '" & minr_ncorr & "' as minr_ncorr"

f_nueva.Consultar consulta
f_nueva.Siguiente
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
function Validar()
{
	formulario = document.edicion;
	
	rut_alumno = formulario.elements["a[0][pers_nrut]"].value + "-" + formulario.elements["a[0][pers_xdv]"].value;	
	if (formulario.elements["a[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["a[0][pers_xdv]"].focus();
		formulario.elements["a[0][pers_xdv]"].select();
		return false;
	  }
	
	
	return true;
}
</script>


</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="450" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  
  <tr> 
    <td valign="top" bgcolor="#EAEAEA"> <br> <br> <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
        <tr> 
          <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
          <td height="8" background="../imagenes/top_r1_c2.gif"></td>
          <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
        </tr>
        <tr> 
          <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
          <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td><%pagina.DibujarLenguetas Array("Agregar Alumno"), 1 %></td>
              </tr>
              <tr> 
                <td height="2" background="../imagenes/top_r3_c2.gif"></td>
              </tr>
              <tr> 
                <td><div align="center"><br>
                    <%pagina.DibujarTituloPagina%>
                    <br><BR>
                  </div>
				   
                  <form name="edicion">
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td><%pagina.DibujarSubtitulo minr_tdesc %>
						
                          <table width="100%" border="0">
                            <tr> 
                              <td width="21%">&nbsp;</td>
                              <td width="5%"><div align="center"></div></td>
                              <td colspan="3">
                                <%'=carrera%>
                              </td>
                            </tr>
                            <tr> 
                              <td>Rut alumno </td>
                              <td><div align="center">:</div></td>
                              <td colspan="3"> 
                                <% f_nueva.DibujaCampo "pers_nrut"%> - <% f_nueva.DibujaCampo "pers_xdv"%>
                              </td>
                            </tr>
							<tr> 
                              <td colspan="3" align="center">Ingrese el rut del alumno que desea agregar al minor y presione el botón guadar.<br>Debe considerar que el alumno debe tener una matricula para el presente año académico.</td>
                            </tr>
   
                          </table>
                          </td>
                      </tr>
                    </table>
                    
                  </form></td>
              </tr>
            </table></td>
          <td width="7" background="../imagenes/der.gif">&nbsp;</td>
        </tr>
        <tr> 
          <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
          <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="19%" height="20"><div align="center"> 
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td width="47%"><div align="center">
                            <%
							botonera.agregaBotonParam "guardar_nueva2", "url", "proc_alumnos_minor_agregar.asp?minr_ncorr=" & minr_ncorr 
							botonera.dibujaBoton "guardar_nueva2" %>
                          </div></td>
                        <td width="53%"><div align="center">
                            <%botonera.dibujaBoton "cancelar" %>
                          </div></td>
                      </tr>
                    </table>
                  </div></td>
                <td width="81%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
              </tr>
              <tr> 
                <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
              </tr>
            </table></td>
          <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
        </tr>
      </table>
      <br> </td>
  </tr>
</table>
</body>
</html>
