<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
	   
set pagina = new CPagina

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.InicializaPortal conexion

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
<!-- 
function EncuadraVentana(){
	if(parent.location != self.location)parent.location = self.location;
}
//--> 
</script>

<script language="JavaScript">
function clave() {
  direccion = "olvido_clave.asp";
  window.open(direccion ,"ventana1","width=370,height=205,scrollbars=no, left=313, top=200");
}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="EncuadraVentana();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table  width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td colspan="2" height="72"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <tr>
   <td width="305" valign="top" bgcolor="#EAEAEA">
	  <br>
	  <br>
	  <table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#EAEAEA">
        <tr>
		    <td><p>Bienvenido al Proceso 2005 de Postulación On Line de la Universidad 
              del Pacífico.</p>
            <p> Te invitamos a ingresar tus datos en la <strong>Ficha de Postulación</strong>, 
              para lo cual debes presionar el bot&oacute;n <strong>&quot;Registrarse&quot;</strong>. 
              Los datos aquí ingresados, serán requeridos cuando te matricules 
              en nuestra Universidad.</p>
            <p>Es muy importante la veracidad de los datos que ingreses, ya que 
              éstos te permitirán agilizar todos los procesos asociados a tu postulación 
              y posterior matrícula en nuestra Universidad.</p>
            <p> Para hacer efectiva tu matrícula, te deberás dirigir a la Oficina 
              de Admisión y Matrícula de la sede de la Universidad del Pacífico, 
              más cercana. </p>
            <p>&nbsp;</p></td>
		</tr>
	  </table>
	</td>  
    <td width="445" valign="top" bgcolor="#EAEAEA">
	  <br>
	  <br>
	  <br>
	  <br>
	  <br>
	  <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
        <tr>
          <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
          <td height="8" background="../imagenes/top_r1_c2.gif"></td>
          <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
        </tr>
        <tr>
          <td width="9" background="../imagenes/izq.gif"></td>
          <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td><%pagina.DibujarLenguetas Array("INGRESO"), 1 %></td>
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
                              <td><strong>CLAVE</strong></td>
                              <td>:</td>
                              <td><input name="clave" type="password" id="TO-N" size="25" maxlength="25"></td>
                            </tr>
                          </table>
                          </div></td>
                        <td width="14%"><div align="center">
                          <%f_botonera.DibujaBoton("aceptar")%>
                        </div></td>
                      </tr>
                      <tr>
                        <td><br>
                          <br>
                          <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                          <tr>
						    <td width="20%"><div align="right"><img src="../imagenes/flecha041.gif" width="33" height="19"> 
                                             </div></td>
                            <td width="40%"><div align="center"> 
                                  <%f_botonera.DibujaBoton("registrarse")%>
                                </div></td>
                            <td width="40%"><div align="center">
                                <%f_botonera.DibujaBoton("olvido_clave")%>
                            </div></td>
                          </tr>
                        </table></td>
                        <td>&nbsp;</td>
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
