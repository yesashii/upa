<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Imprimir Prorroga"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set botonera = new CFormulario
botonera.Carga_Parametros "Ingreso_Prorroga.xml", "botonera"

 ting_ccod = request.querystring("ting_ccod")
 ding_ndocto = request.querystring("ding_ndocto")
 ingr_ncorr = request.querystring("ingr_ncorr")

 'response.Write(ting_ccod & "-" & ding_ndocto & "-" & ingr_ncorr )
'-------------------------------------------------------------------------------

set f_documentos = new CFormulario
 f_documentos.Carga_Parametros "Ingreso_Prorroga.xml", "f_prorrogas"
 f_documentos.Inicializar conexion
 
' sql = "select a.reca_ncorr,  x.vencimiento_original, c.ting_tdesc, b.ding_ndocto,  b.ding_ndocto as c_ding_ndocto, b.ding_fdocto as nueva_fecha,  "& vbCrLf &_
'       "e.PERS_TNOMBRE || ' ' || e.PERS_TAPE_PATERNO || ' ' || e.PERS_TAPE_MATERNO as nombre_alumno, "& vbCrLf &_
'	   "obtener_rut(d.pers_ncorr) as rut_alumno, "& vbCrLf &_
'	   "obtener_nombre_carrera(f.ofer_ncorr,'C') as carrera, "& vbCrLf &_
'	   "b.DING_TCUENTA_CORRIENTE, g.banc_tdesc, b.ding_mdocto, "& vbCrLf &_
'	   "a.reca_mmonto as interes "& vbCrLf &_
'"from referencias_cargos a, "& vbCrLf &_
'     "detalle_ingresos b, tipos_ingresos c, "& vbCrLf &_
'	 "ingresos d,  personas e, "& vbCrLf &_
'	 "postulantes f, bancos g, "& vbCrLf &_
'	 "(select ding_fdocto as vencimiento_original from detalle_ingresos_log  "& vbCrLf &_
 '       "where ting_ccod =" & ting_ccod & " "& vbCrLf &_
  '      "and ingr_ncorr =" & ingr_ncorr & " "& vbCrLf &_
'        "and ding_ndocto =" & ding_ndocto & "  "& vbCrLf &_
'        "and edin_ccod not in (8)) x "& vbCrLf &_
'"where a.edin_ccod = 8 "& vbCrLf &_
'  "and a.ting_ccod = b.ting_ccod "& vbCrLf &_
'  "and a.ding_ndocto = b.ding_ndocto "& vbCrLf &_
'  "and a.ingr_ncorr = b.ingr_ncorr "& vbCrLf &_
'  "and b.ting_ccod = c.ting_ccod "& vbCrLf &_
'  "and b.ingr_ncorr = d.ingr_ncorr "& vbCrLf &_
'  "and d.pers_ncorr = e.pers_ncorr "& vbCrLf &_
'  "and e.pers_ncorr = f.pers_ncorr "& vbCrLf &_
'  "and b.banc_ccod = g.banc_ccod (+)  "& vbCrLf &_
'  "and b.ting_ccod = " & ting_ccod & " "& vbCrLf &_
'  "and b.ding_ndocto = " & ding_ndocto & " "& vbCrLf &_ 
'  "and b.ingr_ncorr = " & ingr_ncorr 
'response.Write(sql)

'sql = "select a.reca_ncorr, b.ding_ndocto,d.ting_tdesc, x.vencimiento_original, b.ding_mdocto, ding_tcuenta_corriente, c.banc_tdesc,  "& vbCrLf &_
'      "obtener_rut (e.pers_ncorr)as rut_alumno, obtener_nombre_completo(e.pers_ncorr)as nombre_alumno,  "& vbCrLf &_
'	  "b.ding_fdocto as nueva_fecha, reca_mmonto as interes     "& vbCrLf &_
'"from referencias_cargos a, detalle_ingresos b, bancos c, tipos_ingresos d, ingresos e,   "& vbCrLf &_
'     "(select ding_fdocto as vencimiento_original, dilg_ncorr  "& vbCrLf &_
'	 " from detalle_ingresos_log  "& vbCrLf &_
'	 " ) x  "& vbCrLf &_
'"where a.reca_ncorr = x.dilg_ncorr  "& vbCrLf &_
'  "and b.ting_ccod = a.ting_ccod  "& vbCrLf &_
'  "and b.ding_ndocto = a.ding_ndocto  "& vbCrLf &_
'  "and b.ingr_ncorr = a.ingr_ncorr  "& vbCrLf &_
'  "and b.banc_ccod  = c.banc_ccod (+)  "& vbCrLf &_
'  "and b.ting_ccod = d.ting_ccod  "& vbCrLf &_
'  "and b.ingr_ncorr = e.ingr_ncorr  "& vbCrLf &_
'   "and b.ting_ccod = " & ting_ccod & " "& vbCrLf &_
'  "and b.ding_ndocto = " & ding_ndocto & " "& vbCrLf &_ 
'  "and b.ingr_ncorr = " & ingr_ncorr 
  
	sql = "select a.reca_ncorr, b.ding_ndocto,d.ting_tdesc, x.vencimiento_original, b.ding_mdocto, ding_tcuenta_corriente, c.banc_tdesc,  "& vbCrLf &_ 
		"protic.obtener_rut (e.pers_ncorr)as rut_alumno, protic.obtener_nombre_completo(e.pers_ncorr,'n')as nombre_alumno,  "& vbCrLf &_ 
		"b.ding_fdocto as nueva_fecha, reca_mmonto as interes     "& vbCrLf &_ 
		"from referencias_cargos a, detalle_ingresos b, bancos c, tipos_ingresos d, ingresos e,   "& vbCrLf &_ 
		"(select ding_fdocto as vencimiento_original, dilg_ncorr  "& vbCrLf &_ 
		" from detalle_ingresos_log  "& vbCrLf &_ 
		" ) x  "& vbCrLf &_ 
		"where a.reca_ncorr = x.dilg_ncorr  "& vbCrLf &_ 
		"and b.ting_ccod = a.ting_ccod  "& vbCrLf &_ 
		"and b.ding_ndocto = a.ding_ndocto  "& vbCrLf &_ 
		"and b.ingr_ncorr = a.ingr_ncorr  "& vbCrLf &_ 
		"and b.banc_ccod  *= c.banc_ccod   "& vbCrLf &_ 
		"and b.ting_ccod = d.ting_ccod  "& vbCrLf &_ 
		"and b.ingr_ncorr = e.ingr_ncorr  "& vbCrLf &_ 
		"and b.ting_ccod = " & ting_ccod & " "& vbCrLf &_ 
		"and b.ding_ndocto = " & ding_ndocto & " "& vbCrLf &_ 
		"and b.ingr_ncorr = " & ingr_ncorr& ""
 'response.Write("<pre>"&sql&"</pre>") 
 'response.End()
 f_documentos.Consultar sql

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
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
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
            <td><%pagina.DibujarLenguetas Array("Listado de Prorrogas"), 1 %></td>
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
                        <td> <div align="center">
                            <% f_documentos.DibujaTabla()%>
                            <br>
                          </div></td>
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
            <td width="25%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                            <% 'botonera.DibujaBoton ("imprimir")%>
                          </div></td>
                  <td><div align="center">
                            <% botonera.DibujaBoton ("salir")%>
                          </div></td>
                  <td><div align="center"></div></td>
                </tr>
              </table>
            </div></td>
            <td width="75%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
