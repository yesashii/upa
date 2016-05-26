<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

set conectar = new cconexion
set formulario = new cformulario
set negocio = new CNegocio

conectar.inicializar "upacifico"

negocio.inicializa conectar
formulario.carga_parametros "horario_sala.xml", "salas"

sala_ccod= request.QueryString("sala_ccod")
sede_ccod = negocio.obtenersede
sede_tdesc= conectar.consultauno("select sede_tdesc from sedes where cast(sede_ccod as varchar) = '"&sede_ccod&"'")

formulario.agregaCampoParam "sala_ccod", "filtro", "sede_ccod = " & sede_ccod

formulario.inicializar conectar

sql = "select getDate()"
formulario.consultar sql
if not Esvacio(sala_ccod) then
formulario.agregaCampoCons "sala_ccod" , sala_ccod
end if
formulario.siguiente

set errores = new CErrores
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "horario_sala.xml", "botonera"


%>



<html>
<head>
<title>Revisión horario de Salas</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function abrir(formulario){

formulario.action = 'horario_sala.asp';
formulario.submit();

}
function abrir2(formulario){

formulario.action = 'horario_sala_periodo.asp';
formulario.submit();

}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
            <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
            <tr>
              <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="5"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="278" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Horario Salas Sede <%=sede_tdesc%> </font></div></td>
                    <td width="10"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="381" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                  </tr>
              </table></td>
              <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>              
            </tr>
            <tr>
              <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
          </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"><div align="center">
				<form name="buscador" method="get">
				  <div align="left"><br>
                  </div>
				  <table width="98%"  border="0">
                    <tr>
                      <td width="79%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="0%" height="12" valign="top" nowrap><div align="center"></div></td>
                          <td width="4%" valign="top"><div align="left"> &nbsp;&nbsp;&nbsp;&nbsp; 
                                  </div></td>
                          <td width="74%" valign="top">
                                    <div align="left">&nbsp;&nbsp;&nbsp;Seleccione 
                                    una Sala : 
                                    <%formulario.dibujacampo("sala_ccod")%>
                                  </div> 
                            </td>
                          <td width="22%" valign="top" colspan="2"><div align="left"></div>                            
                                  <div align="left">
                                    <% f_botonera.DibujaBoton("horario") %>
                                  </div></td>
                       </tr>
					   <tr>
					   <td colspan="2">&nbsp;</td>
                      <td width="74%" align="right"><div align="right"> </div></td>
					  <td width="22%"><div align="left"> 
                                    <%'f_botonera.DibujaBoton("horario_periodo") %>
                      </div>
					  </td>
                      </tr>
                      </table></td>
					  </tr>
					  
                  </table>
				</form>
                </div></td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>			
          </td>
      </tr>
    </table>	
	<br>		
	</td>
  </tr>  
</table>
</body>
</html>
