<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_saca_ncorr = Request.QueryString("saca_ncorr")


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Asignaturas requisito para la salida"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "predictivo_dir_escuela.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "predictivo_dir_escuela.xml", "encabezado"
f_encabezado.Inicializar conexion

SQL = " select a.plan_ccod, b.espe_ccod, a.carr_ccod, d.tsca_tdesc, a.saca_tdesc, e.carr_tdesc, c.espe_tdesc, b.plan_tdesc, " & vbCrLf &_
      " a.saca_npond_asignaturas, (select count(*) from asignaturas_salidas_carrera tt where tt.saca_ncorr=a.saca_ncorr) as total  " & vbCrLf &_
	  " from salidas_carrera a  " & vbCrLf &_
      "      left outer join planes_estudio b " & vbCrLf &_
      "        on a.plan_ccod = b.plan_ccod " & vbCrLf &_ 
      "      left outer join especialidades c " & vbCrLf &_
      "        on b.espe_ccod = c.espe_ccod " & vbCrLf &_
      "      join tipos_salidas_carrera d " & vbCrLf &_
      "        on a.tsca_ccod = d.tsca_ccod " & vbCrLf &_
      "      join carreras e " & vbCrLf &_
      "        on a.carr_ccod = e.carr_ccod " & vbCrLf &_
      "   where cast(a.saca_ncorr as varchar)= '" & q_saca_ncorr & "'"


f_encabezado.Consultar SQL
f_encabezado.Siguiente
'response.Write("<pre>"&SQL&"</pre>")
v_plan_ccod = f_encabezado.ObtenerValor("plan_ccod")
v_espe_ccod = f_encabezado.ObtenerValor("espe_ccod")
v_carr_ccod = f_encabezado.ObtenerValor("carr_ccod")



'------------------------------------------------------------------------------------------------------------
set f_asignaturas = new CFormulario
f_asignaturas.Carga_Parametros "predictivo_dir_escuela.xml", "asignaturas"
f_asignaturas.Inicializar conexion

SQL = " select a.saca_ncorr, a.mall_ccod, d.asig_ccod, d.asig_tdesc, c.nive_ccod, " & vbCrLf &_
      " (select carr_tdesc from planes_estudio tt, especialidades t2, carreras t3 " & vbCrLf &_
	  "      where tt.plan_ccod=c.plan_ccod and tt.espe_ccod=t2.espe_ccod and t2.carr_ccod=t3.carr_ccod) as carr_tdesc" & vbCrLf &_
      " from asignaturas_salidas_carrera a, salidas_carrera b, malla_curricular c, asignaturas d" & vbCrLf &_
      " where a.saca_ncorr = b.saca_ncorr" & vbCrLf &_
      "   and a.mall_ccod = c.mall_ccod" & vbCrLf &_
      "   and c.asig_ccod = d.asig_ccod" & vbCrLf &_
      "   and a.saca_ncorr = '" & q_saca_ncorr & "'" & vbCrLf &_
      " order by c.nive_ccod asc, d.asig_tdesc asc"

f_asignaturas.Consultar SQL
lenguetas = Array(Array("Asignaturas Requisito", "adm_asignaturas_salidas_carrera.asp?saca_ncorr=" & q_saca_ncorr))
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
            <td><%pagina.DibujarLenguetas lenguetas, 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
              <br>
              <table width="98%"  border="0">
                <tr>
                  <td scope="col"><div align="center"><%f_encabezado.DibujaRegistro%></div></td>
                </tr>
              </table>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Asignaturas requisito"%>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td scope="col"><div align="right">P&aacute;ginas : <%f_asignaturas.AccesoPagina%></div></td>
                        </tr>
                        <tr>
                          <td scope="col"><div align="center"><%f_asignaturas.DibujaTabla%></div></td>
                        </tr>
                        <tr>
                          <td scope="col"><div align="center"><%f_asignaturas.Pagina%></div></td>
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
            <td width="20%" height="20"><div align="center"><%f_botonera.DibujaBoton "cerrar"%></div></td>
            <td width="80%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
