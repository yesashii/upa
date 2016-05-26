<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_tben_ccod = Request.QueryString("tben_ccod")


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Tipos de Ítemes"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores = new CErrores

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "edicion_tipos_compromisos.xml", "botonera"

f_botonera.AgregaBotonUrlParam "agregar", "tben_ccod", q_tben_ccod

'---------------------------------------------------------------------------------------------------
set f_tipos_detalle = new CFormulario
f_tipos_detalle.Carga_Parametros "edicion_tipos_compromisos.xml", "tipos_beneficios"
f_tipos_detalle.Inicializar conexion

	   
consulta = "select a.tdet_ccod, a.tdet_tdesc, a.tdet_mvalor_unitario, isnull(a.tdet_bvigente,'Nulo') as tdet_bvigente," & vbCrLf &_
			"        a.tdet_cuenta_softland, a.tdet_detalle_softland, a.tdet_ccod as c_tdet_ccod, a.tdet_ccod as c2_tdet_ccod, " & vbCrLf &_
			"		isnull(a.tdet_bdescuento,'N') as tdet_bdescuento , isnull(a.tdet_bboleta,'N') as tdet_bboleta, isnull(udes_ccod,1) as udes_ccod,  " & vbCrLf &_
			"  		isnull(tdet_nptjematricula,0) as tdet_nptjematricula, isnull(tdet_nptjecolegiatura,0) as tdet_nptjecolegiatura, '"&q_tben_ccod&"' as tben_ccod " & vbCrLf &_
			"    from tipos_detalle a" & vbCrLf &_
			"    where a.tben_ccod = '"&q_tben_ccod&"' " & vbCrLf &_
			" order by a.tdet_bvigente desc ,a.tdet_tdesc asc"
			
'response.Write("<pre>"&consulta&"</pre>")		   
'response.End()
f_tipos_detalle.Consultar consulta


'---------------------------------------------------------------------------------------------------
v_tben_tdesc = conexion.ConsultaUno("	select tben_tdesc from tipos_beneficios where cast(tben_ccod as varchar) = '"&q_tben_ccod&"'")
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

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
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
            <td><%pagina.DibujarLenguetas Array("Tipos de Ítemes"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Ítemes : " & v_tben_tdesc%>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
					  <tr>
					  <td><div align="right"> <%f_tipos_detalle.AccesoPagina%></div></td>
					  </tr>
                        <tr>
                          <td><div align="center"><%f_tipos_detalle.DibujaTabla%></div></td>
                        </tr>
                      </table></td>
                  </tr>
                </table>
                          <br>
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
                  <td><div align="center"><%f_botonera.DibujaBoton "anterior"%></div></td>
                  <td><div align="center">
					<%f_botonera.AgregaBotonParam "agregar_beneficio", "url", "agregar_tipos_beneficios.asp?tben_ccod="&q_tben_ccod&" " %>
                    <%f_botonera.DibujaBoton "agregar_beneficio"%>
                  </div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton "eliminar"%>
                  </div></td>
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
