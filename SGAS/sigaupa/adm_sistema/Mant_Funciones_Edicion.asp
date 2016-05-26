<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Mantener Funciones"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Mant_Funciones.xml", "botonera"

'---------------------------------------------------------------------------------------------------
cod_funcion = Request.QueryString("codigo_funcion")
cod_modulo = Request.QueryString("codigo_modulo")

'response.Write("codigo mod : " & cod_modulo & "<BR>")
'response.Write("codigo fun : " & cod_funcion & "<BR>")

set formulario = new CFormulario
formulario.Carga_Parametros "Mant_Funciones.xml", "f1_edicion"
formulario.Inicializar conexion

if cod_funcion = "NUEVO" then
	 sfun_ccod  = conexion.consultauno("EXEC ObtenerSecuencia 'sis_funciones_modulos'")
   consulta = "select "&sfun_ccod&" as sfun_ccod, " & cod_modulo & " as smod_ccod, '' as sfunc_tdesc, '' sfun_link "
else  'modificar
  consulta = "select smod_ccod,sfun_ccod,sfun_tdesc,sfun_link from sis_funciones_modulos where sfun_ccod = " & cod_funcion & " and smod_ccod = "  & cod_modulo
end if

formulario.Consultar consulta
formulario.Siguiente


%>


<html>
<head>
<title>Mantenedor de Funciones</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">



</script>

</head>
<body  onBlur="revisaVentana()" bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="552" height="268" border="0" align="center" cellpadding="0" cellspacing="0">
  <%'pagina.DibujarEncabezado()%>  
  <tr>
    <td height="268" valign="top" bgcolor="#EAEAEA">
	<BR>
	<BR>			
	
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
                      <td width="9" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="205" valign="middle" background="../imagenes/fondo1.gif">
					  <font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">
					  <% if cod_funcion = "NUEVO" then
        Response.Write("Agrege la Nueva Funcion <BR>")
      else
        Response.Write("Modifique la Funcion <BR>") 
      end if %>
	  </font>
	  <div align="left"></div></td>
                      <td width="186" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
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
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  
                <td bgcolor="#D8D8DE"> <div align="center">&nbsp; <BR>
                    <%pagina.DibujarTituloPagina%>
                  </div>
                  <form name="edicion">
					
				      <% 
	     
      formulario.DibujaCampo("smod_ccod")
      formulario.DibujaCampo("sfun_ccod")
   %>
					<table width="100%" border="0">
                      <tr> 
                        <td><strong>Descripci&oacute;n</strong></td>
                        <td><strong>:</strong></td>
                        <td><%formulario.DibujaCampo("sfun_tdesc")  %> </td>
                      </tr>
                      <tr> 
                        <td width="21%"><strong>Link</strong></td>
                        <td width="6%"><strong>:</strong></td>
                        <td width="73%"><%formulario.DibujaCampo("sfun_link")  %></td>
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
                  <td width="123" bgcolor="#D8D8DE"> <div align="left"></div> 
		            <div align="left">                       <table width="100%" border="0" cellpadding="0" cellspacing="0">
                         <tr>
                           <td width="16%"><% 'pagina.DibujarBoton "Aceptar", "GUARDAR-edicion", "Proc_Mant_Funciones_Edicion.asp"
						   botonera.dibujaboton "guardar"%>
                           </td>
                           <td width="84%"><% 'pagina.DibujarBoton "Cancelar", "CERRAR", ""
						   botonera.dibujaboton "cancelar"%>
                           </td>
                         </tr>
                       </table>
</div></td>
                  <td width="139" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="145" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
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
