<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
homo_ccod = request.QueryString("homo_ccod")

set pagina = new CPagina
pagina.Titulo = "Detalle Homologacion"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new CNegocio
negocio.Inicializa conexion

destino =  request.QueryString("destino")
'---------------------------------------------------------------------------------------------------
if homo_ccod = "NUEVA" then
  response.Redirect("Homologacion_Agregar.asp?homo_ccod=NUEVA&destino=" & destino)
end if

set botonera =  new CFormulario
botonera.carga_parametros "editar_malla.xml", "btn_edita_malla"


set f_detalle = new CFormulario
f_detalle.Carga_Parametros "editar_malla.xml", "f_detalle_homologacion"
f_detalle.Inicializar conexion
consulta = "select a.homo_ccod, a.homo_ccod as  c_homo_ccod, a.asig_ccod, a.asig_ccod as c_asig_ccod, "&_ 
			"	   a.hfue_nponderacion,  b.asig_tdesc  "&_
			"from homologacion_fuente a, asignaturas b "&_
			"where a.asig_ccod = b.asig_ccod "&_
			" and a.homo_ccod =" & homo_ccod & " "&_ 
			"order by b.asig_tdesc"
f_detalle.consultar consulta

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
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
    <td valign="top" bgcolor="#EAEAEA"> <br> <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
        <tr> 
          <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
          <td height="8" background="../imagenes/top_r1_c2.gif"></td>
          <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
        </tr>
        <tr> 
          <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
          <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td>
                  <%pagina.dibujarLenguetas array (array("Detalle Homologacion","Homologacion_Editar.asp"),array("Búsqueda de Asignaturas","Homologacion_Agregar.asp?homo_ccod="& homo_ccod)),1 %>
                </td>
              </tr>
              <tr> 
                <td height="2" background="../imagenes/top_r3_c2.gif"></td>
              </tr>
              <tr> 
                <td><div align="center"><br>
                    <%pagina.DibujarTituloPagina%>
                    <br>
                  </div>
                  <form name="edicion">
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td><div align="center"> 
                            <%pagina.DibujarSubtitulo "Asignaturas de la Homologación"%>
                            <br>
                            <BR>
                            <%f_detalle.DibujaTabla %>
                          </div></td>
                      </tr>
                    </table>
                    <br>
                  </form></td>
              </tr>
            </table></td>
          <td width="7" background="../imagenes/der.gif">&nbsp;</td>
        </tr>
        <tr> 
          <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
          <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="30%" height="20"><div align="center"> 
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td><div align="center"> 
                            <%
							if f_detalle.nroFilas > 0 then
							   botonera.agregaBotonParam "eliminar_detalle_homologacion", "deshabilitado", "FALSE"
							else
							   botonera.agregaBotonParam "eliminar_detalle_homologacion", "deshabilitado", "TRUE"
							end if
							botonera.dibujaBoton "eliminar_detalle_homologacion"%>
                          </div></td>                       
                        <td><div align="center"><% botonera.agregaBotonParam "salir", "funcion", "CerrarActualizar();"
												   botonera.dibujaBoton "salir"
												%>
						</div></td>
                      </tr>
                    </table>
                  </div></td>
                <td width="70%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
