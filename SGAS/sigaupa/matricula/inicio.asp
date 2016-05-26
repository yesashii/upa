<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
ip_usuario=Request.ServerVariables("REMOTE_ADDR")


'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

periodo = negocio.obtenerPeriodoAcademico("Postulacion")
peri_tdesc = conexion.consultaUno("select peri_tdesc from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
plec_ccod = conexion.consultaUno("select plec_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")

'response.Write(peri_tdesc)
'if periodo > "205" then'-----------------------------solo actualizará los estados cuando se busque inf. del 2007.
'	conexion.ejecutaS "execute calificar_test_ingreso"
'end if

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "matricula-inicio.xml", "botonera"

set errores = new CErrores

'---------------------------------------------------------------------------------------------------

%>
<html>
<head>
<title>Inicio</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function clave() {
  direccion = "olvido_clave.asp";
  window.open(direccion ,"ventana1","width=370,height=205,scrollbars=no, left=313, top=200");
}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td  height="62"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  

  <tr>
     <td valign="top" bgcolor="#EAEAEA">
      <br>
	  <br>
	  <table width="60%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
        <tr>
          <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
          <td height="8" background="../imagenes/top_r1_c2.gif"></td>
          <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
        </tr>
        <tr>
          <td width="9" background="../imagenes/izq.gif"></td>
          <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td><%pagina.DibujarLenguetas Array("<font color='#0033CC'><b>INGRESO " & peri_tdesc &"</b></font>"), 1 %></td>
              </tr>
              <tr>
                <td height="2" background="../imagenes/top_r3_c2.gif"></td>
              </tr>
              <tr>
                <td><form name="edicion" id="edicion">
                    <br>
                    <table width="98%"  border="0" align="center">
                      <tr>
                        <td width="86%"><div align="center">
                            <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="49%"><strong>USUARIO </strong>(Ej:12345678-9)<strong> 
                                  </strong></td>
                              <td width="2%">:</td>
                              <td width="49%"><input name="usuario" type="text" id="TO-N" size="25" maxlength="25" onBlur="this.value=this.value.toUpperCase();"></td>
                            </tr>
                            <tr>
                              <td><font color="#EAEAEA"><%'=ip_usuario%></font></td>
                              <td></td>
                              <td>
							  <!--<strong>CLAVE</strong>:<input name="clave" type="password" id="TO-N" size="25" maxlength="6"> --></td>
                            </tr>
                          </table>
                          </div></td>
                        <td width="14%"><div align="center">
                          <%f_botonera.DibujaBoton("aceptar")%><br>
                        </div></td>
                      </tr>
                      <tr>
                        <td><br>
                          <br>
                          <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                          <tr>
                            <td><div align="center">
                                <%'f_botonera.DibujaBoton("olvido_clave")%>
                                <%f_botonera.DibujaBoton("salir")%>
                            </div></td>
                            <td><div align="center">
                                <%f_botonera.DibujaBoton("registrarse")%>
                            </div></td>
                          </tr>
                        </table></td>
                        <td>&nbsp;</td>
                      </tr>
					   <tr>
					        <td colspan="2">&nbsp; </td>
					  </tr>
					  <tr>
					  	 
                        <td colspan="2"> <font color="#0033CC"><b>Atenci&oacute;n 
                          :</b></font> La postulaci&oacute;n que realices, será enlazada 
                          al <b><%=peri_tdesc%></b>. <br>
						  <%if plec_ccod = "2" then%>
						  Si ya has cursado el 1er Semestre <b>NO DEBES</b> realizar una nueva postulación.</td>
						  <%end if%>
					  </tr>
                    </table>
                </form></td>
              </tr>
          </table></td>
          <td width="7" background="../imagenes/der.gif"></td>
        </tr>
        <tr>
          <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
          <td height="13" background="../imagenes/base2.gif"></td>
          <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
        </tr>
      </table>
	  </td>
  </tr>  
</table>
</body>
</html>
