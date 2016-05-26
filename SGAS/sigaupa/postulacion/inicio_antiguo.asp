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
f_botonera.Carga_Parametros "matricula-inicio2.xml", "botonera"

set errores = new CErrores
'---------------Realizado para diferenciar las CARRERAS de Pregrado y Postgrado
tipo = request.QueryString("tipo")

if	not EsVacio(tipo) then
	session("tipo") = tipo
	if tipo = "1" then
	    ano_muestra="2007"
	else
		ano_muestra="2007"  
	end if		
end if

if esVacio(ano_muestra) then
	ano_muestra="2007"   
end if
'response.Write("tipo :" & session("tipo"))
'---------------------------------------------------------------------------------------------------
'----------------------iniciamos una variable de session para el periodo 1er sem 2006 --------------
session("periodo_postulacion") = "206"
%>
<html>
<head>
<title>Ficha de creaci&oacute;n de claves</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>
<script language="JavaScript">
function clave() {
  direccion = "olvido_clave.asp";
  window.open(direccion ,"ventana1","width=370,height=205,scrollbars=no, left=313, top=200");
}
function salir() {
  window.close();
}
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%'pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<br>		
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="100%" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td width="9"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="100%" height="8" border="0" alt=""></td>
              <td width="7"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="11" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="309" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><strong><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">UNIVERSIDAD DEL PACÍFICO ADMISIÓN <%=ano_muestra%> </font></strong></div></td>
                      <td width="339" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="100%" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				    
				    <form name="edicion" id="edicion">
				      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td height="40"><div align="center"> <b><font size="2" color="#000066">Bienvenido 
                            al Proceso de Admisi&oacute;n <%=ano_muestra%>, de Postulaci&oacute;n 
                            On Line de la Universidad del Pac&iacute;fico</font></b> 
                          </div></td>
                        </tr>
						<tr>
                            <td height="15"><center><font size="2">&nbsp;</font></center></td>
                        </tr>
                        <tr>
                        <td valign="top">
						     <table width="99%"  border="0">
                              <tr>
                                   <td><center><font size="2">Te invitamos a ingresar tus datos a la <strong>Ficha de Postulación</strong></font></center></td>
                              </tr>
					          <tr>
                                   <td height="30"><center><%f_botonera.DibujaBoton("registrarse")%></center></td>
                              </tr>
							  <tr>
                                   <td height="30"><center><font size="2">Es muy importante la veracidad de de los datos que ingreses, ya que estos te permitir&aacute;n
								                   agilizar todos los procesos asociados a la postulaci&oacute;n en nuestra Universidad.</font></center></td>
                              </tr>
							  <tr>
                                   <td height="30"><center><font size="2">&nbsp;</font></center></td>
                              </tr>
							  <tr>
                                   <td height="30"><center><font size="2">Si ya te encuentras <strong>"Registrado"</strong> y deseas completar tu postulaci&oacute;n
								                                         o verificar el estado de esta, ingresa tus datos a continuaci&oacute;n</font></center></td>
                              </tr>
							  <tr>
                                   <td height="30"><center><font size="2">&nbsp;</font></center></td>
                              </tr>
							   <tr>
                                   <td><center>
									  <table width="70%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
                                            <td>
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
                                                              <td><input name="clave" type="password" id="TO-N" size="25" maxlength="6"></td>
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
                                                       <td><div align="left">
                                                           <%f_botonera.DibujaBoton("olvido_clave")%>
                                                           </div></td>
                                                       </tr>
                                                      </table></td>
                                                   <td>&nbsp;</td>
                                            </tr>
                                       </table>
                                      </td>
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
									</center></td>
                              </tr>
                            </table>
                        </tr>
                       </table>
		            </form>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="184" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><div align="center">
                        <%f_botonera.DibujaBoton("Salir")%>
                      </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="172" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="310" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
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
