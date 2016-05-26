<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Administrador de Tipos de Compromisos"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores = new CErrores


'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "adm_tipos_compromisos.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_tipos_compromisos = new CFormulario
f_tipos_compromisos.Carga_Parametros "adm_tipos_compromisos.xml", "tipos_compromisos"
f_tipos_compromisos.Inicializar conexion

		   
consulta = "select a.tcom_ccod, a.tcom_ccod as c_tcom_ccod, a.tcom_tdesc, count(b.tdet_ccod) as nitems" & vbCrLf &_
		"    from tipos_compromisos a,tipos_detalle b" & vbCrLf &_
		"    where a.tcom_ccod *= b.tcom_ccod" & vbCrLf &_
		"        and a.tcom_bcargo = 'S'" & vbCrLf &_
		"group by a.tcom_ccod, a.tcom_tdesc " & vbCrLf &_
		"order by a.tcom_tdesc asc "
		
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_tipos_compromisos.Consultar consulta

'---------------------------------------------------------------------------------------------------
' **************** BENEFICIOS ******************

set f_tipos_beneficios = new CFormulario
f_tipos_beneficios.Carga_Parametros "adm_tipos_compromisos.xml", "tipos_beneficios"
f_tipos_beneficios.Inicializar conexion


consulta_beneficios =  " Select a.tben_ccod, a.tben_ccod as c_tben_ccod, a.tben_tdesc, count(b.tdet_ccod) as nitems " & vbCrLf &_
						"    From tipos_beneficios a,tipos_detalle b " & vbCrLf &_
						"    Where a.tben_ccod *= b.tben_ccod " & vbCrLf &_
						"    and a.tben_ccod in (1,2,3) " & vbCrLf &_
						" Group by a.tben_ccod, a.tben_tdesc  "
			
f_tipos_beneficios.Consultar consulta_beneficios
			
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
            <td><%pagina.DibujarLenguetas Array("Tipos de compromisos"), 1 %></td>
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
                    <td><%pagina.DibujarSubtitulo "Tipos de compromisos"%>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"><%f_tipos_compromisos.DibujaTabla%></div></td>
                        </tr>
						<tr>
							<td><br><%pagina.DibujarSubtitulo "Tipos de Beneficios"%></td>
						</tr>
						<tr>
							<td><div align="center"><%f_tipos_beneficios.DibujaTabla%></div></td>
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
                  <td><div align="center"><%f_botonera.DibujaBoton("agregar")%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("eliminar")%>
                  </div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("salir")%>
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
