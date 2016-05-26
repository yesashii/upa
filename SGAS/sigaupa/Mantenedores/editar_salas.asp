<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
sala_ccod = request.QueryString("sala_ccod")

set pagina = new CPagina
pagina.Titulo = "Mantenedor De Salas "
set botonera =  new CFormulario
botonera.carga_parametros "adm_salas.xml", "btn_editar_salas"

'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set f_salas	 		=	new cformulario
f_salas.carga_parametros 		"adm_salas.xml", "agregar_sala"
f_salas.inicializar		conectar

Sql_sala = "select * from salas where cast(sala_ccod as varchar)='"& sala_ccod &"'" 

'response.Write("consulta "&Sql_sala)
'response.End()

f_salas.consultar 		Sql_sala 
f_salas.siguiente

'---------------------------------------------------------------------------------------------------


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
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>

<script language="JavaScript">
function cerrar() {
	window.opener.location.reload();
	window.close();
}

</script>
<%
	set calendario = new FCalendario
	'calendario.Inicializa "editar","fecha_oculta"
	calendario.IniciaFuncion
	calendario.MuestraFecha "ag_s[0][sala_fini_vigencia]","1","editar","fecha_oculta_sala_fini_vigencia"
	calendario.MuestraFecha "ag_s[0][sala_ffin_vigencia]","2","editar","fecha_oculta_sala_ffin_vigencia"
	calendario.FinFuncion
	
%>
</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../__base/im&#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../__base/im&#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../__base/im&#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../__base/im&#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">	<br>
      <br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Mantenedor De Salas"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr valign="top">
            <td><br><%pagina.DibujarSubtitulo "Datos De La Sala "%>
* Campos Obligatorios            
  <form name="editar" method="post">
<table width="95%" align="center" cellpadding="0" cellspacing="0">
                        <tr> 
                          <td colspan="6" align="center">&nbsp;</td>
                        </tr>
                        <tr align="center"> 
                          <td width="23%" align="left" valign="top" nowrap>(*)<strong> 
                            Descripci&oacute;n</strong></td>
                          <td width="1%" align="left" valign="top" nowrap>:</td>
						  <td width="23%" align="left" valign="top" nowrap><%f_salas.dibujacampo("sala_tdesc")%> </td>	
                          <td width="53%" align="left" valign="top" nowrap>&nbsp;</td>
                        </tr>
                        <tr align="center"> 
                          <td align="left" valign="top" nowrap> (*)<strong> 
                            Tipo de Sala</strong> </td>
						  <td width="1%" align="left" valign="top" nowrap>:</td>	
                          <td align="left" valign="top" nowrap><%f_salas.dibujacampo("tsal_ccod")%> </td>
                          <td valign="top" nowrap>&nbsp; </td>
                        </tr>
                        <tr align="center"> 
                          <td align="left" valign="top" nowrap><strong>(*)<strong>Cupo</strong></strong></td>
						  <td width="1%" align="left" valign="top" nowrap>:</td>
                          <td align="left" valign="top" nowrap><%f_salas.dibujacampo("sala_ncupo")%></td>
                          <td valign="top" nowrap>&nbsp;</td>
                        </tr>
                        <tr align="center"> 
                          <td align="left" valign="top" nowrap><strong>C&oacute;digo Iso</strong></td>
						  <td width="1%" align="left" valign="top" nowrap>:</td>
                          <td align="left" valign="top" nowrap><%f_salas.dibujacampo("sala_ciso")%></td>
                          <td valign="top" nowrap>&nbsp;</td>
                        </tr>
                        <tr align="center"> 
                          <td align="left" valign="top" nowrap><strong>Fecha 
                            Inicio Vigencia</strong></td>
						  <td width="1%" align="left" valign="top" nowrap>:</td>	
                          <td align="left" valign="top" nowrap><%f_salas.dibujacampo("sala_fini_vigencia")%> 
                           <%calendario.DibujaImagen "fecha_oculta_sala_fini_vigencia","1","editar" %> (dd/mm/aaaa) </td>
                          <td valign="top" nowrap>&nbsp;</td>
                        </tr>
                        <tr align="center"> 
                          <td align="left" valign="top" nowrap><strong>Fecha Fin 
                            Vigencia</strong> </td>
					      <td width="1%" align="left" valign="top" nowrap>:</td>		
                          <td align="left" valign="top" nowrap><%f_salas.dibujacampo("sala_ffin_vigencia")%>
							<%calendario.DibujaImagen "fecha_oculta_sala_ffin_vigencia","2","editar" %> (dd/mm/aaaa)</td>
                          <td valign="top" nowrap><input type="hidden" name="sala" value="<%=sala_ccod%>"></td>
                        </tr>
						<tr valign="top"> 
                          <td align="left" valign="top" nowrap><strong>Equipamiento</strong></td>
						  <td width="1%" align="left" valign="top" nowrap>:</td>
                          <td align="left" valign="top" nowrap colspan="2"><%f_salas.dibujacampo("equipamiento")%></td>
                        </tr>
                        <tr> 
                          <td colspan="6" align="center" valign="top"> </td>
                        </tr>
                        <tr> 
                          <td colspan="6" align="center" valign="top"></td>
                        </tr>
                      </table>
                </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%botonera.dibujaboton "agregar"%>
                  </font>
                  </div></td>
                  <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><%botonera.dibujaboton "salir"%>
                  </font> </div></td>
                  <td><div align="center"></div></td>
                </tr>
              </table>
            </div></td>
            <td width="62%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
