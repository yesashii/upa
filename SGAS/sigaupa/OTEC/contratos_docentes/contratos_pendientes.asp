<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Contratacion de Docentes"
'----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "contrato_pendiente.xml", "botonera"

'-----------------------------------------------------------------------
  set f_valor_documentos  = new cformulario
f_valor_documentos.carga_parametros "tabla_vacia.xml", "tabla" 
f_valor_documentos.inicializar conexion	
sql="select ''"						
f_valor_documentos.consultar sql
f_valor_documentos.Siguiente
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

<style type="text/css">
<!--
body {
	background-color: #D8D8DE;
}
-->
</style></head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">


<table width="650" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
    <td valign="top" bgcolor="#EAEAEA">
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td width="581" height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="10" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td> <table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td align="left"><form name="buscador">
                
<table width="98%"  border="0">
                    <tr>
                      <td width="81%"><table cellspacing=0 cellpadding=0 width="100%" border=0>
                        <tbody>
                          <tr>
                            <td width="88%" height=40 align=middle valign=top colspan="2">
                              <div align="center"><strong><font size="3">Listado
                                    de profesores con contrato pendiente </font></strong><br>
                                  Presione bot&oacute;n para generar archivo</div></td>
                            </tr>
                          <tr>
                            <td valign=top align="right">&nbsp;</td>
                             <td><%'f_busqueda.DibujaCampo("mes_ccod")%></td>
                          </tr>
                        </tbody>
                      </table>
					  </td>
                      <td width="19%">
					  <table>
						  <tr>
							<td>
							 <div align="center">
							  <!--
							
--><br></div>
							</td>
						  </tr>
						  <tr>
							<td><div align="center">
							<%botonera.AgregaBotonParam "excel", "url", "contratos_pendientes_excel.asp"
							  botonera.DibujaBoton "excel"%>
							</div></td>
						  </tr>
					  </table>
					 
					  </td>
                    </tr>
                  </table>
            </form></td>
          </tr>
        </table></td>
        <td width="10" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="10" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	
	
	</table>
</body>
</html>
