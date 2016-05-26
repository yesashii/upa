<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
cod_usuario = Request.QueryString("codigo")
set pagina = new CPagina
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'----------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Mant_Usuarios.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "Mant_Usuarios.xml", "f1_edicion"
formulario.Inicializar conexion
consulta = "select PERS_NCORR, SUSU_TLOGIN, SUSU_TCLAVE,  PERS_NCORR as c_pers_ncorr from sis_usuarios where pers_ncorr="  & cod_usuario

formulario.Consultar consulta
formulario.Siguiente
formulario.AgregaCampoCons "susu_fmodificacion", date()

%>


<html>
<head>
<title>Mantenedor de Usuarios</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="540" border="0" align="center" cellpadding="0" cellspacing="0">
  <%'pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	 <br>    <br>
      <table width="400" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="400" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="400" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                        <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">
                          <% 
	  						if cod_usuario = "NUEVO" then
        						Response.Write("Agrege el Nuevo Usuario <BR>")
      						else
        						Response.Write("Modifique el Usuario <BR>") 
      						end if    
      						
   						%>
                        </font></div>
                      </td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                  </table>
                </td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="400" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif"></td>
                  <td bgcolor="#D8D8DE"> &nbsp;
                      <form name="edicion">
                        <table width="100%" border="0">
                          <tr>
                            <td width="23%">Correlativo</td>
                            <td width="77%"><%formulario.DibujaCampo("pers_ncorr")
 						formulario.DibujaCampo("c_pers_ncorr")
						 %>
                            </td>
                          </tr>
                          <tr>
                            <td>Login</td>
                            <td><%formulario.DibujaCampo("susu_tlogin")  %>
                            </td>
                          </tr>
                          <tr>
                            <td>Clave</td>
                            <td><%formulario.DibujaCampo("susu_tclave")  %>
                            </td>
                          </tr>
                          <tr>
                            <td>Fecha</td>
                            <td><%formulario.DibujaCampo("susu_fmodificacion")  %>
                            </td>
                          </tr>
                        </table>
                        
                     
                      </form>
                     
                  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
              </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="176" bgcolor="#D8D8DE">
                    <table width="58%" border="0" cellpadding="0" cellspacing="0">
                      <tr>
                        <td width="32%"><%'pagina.DibujarBoton "Aceptar", "GUARDAR-edicion", "Proc_Mant_Modulos_Edicion.asp"
						botonera.dibujaboton "guardar2" %>
                        <td width="32%"><%'pagina.DibujarBoton "Cancelar", "CERRAR", ""
						botonera.dibujaboton "cancelar"%>
                      </tr>
                    </table>
                  </td>
                  <td width="47" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="184" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
              </table>
              
          </td>
        </tr>
      </table>
    <p>&nbsp;      </td>
  </tr>  
</table>
</body>
</html>
