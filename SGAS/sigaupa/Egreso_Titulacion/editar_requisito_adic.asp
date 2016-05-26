<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_repl_ncorr = Request.QueryString("repl_ncorr")

set pagina = new CPagina
pagina.Titulo = "Editar requisito adicional"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new CNegocio
negocio.Inicializa conexion



'---------------------------------------------------------------------------------------------------
set f_botonera_g = new CFormulario
f_botonera_g.Carga_Parametros "botonera_generica.xml", "botonera"

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "adm_requisitos_adicionales.xml", "botonera"


'---------------------------------------------------------------------------------------------------
set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "adm_requisitos_adicionales.xml", "encabezado"
f_encabezado.Inicializar conexion

SQL = " select a.plan_ccod, b.espe_ccod, c.carr_ccod, a.peri_ccod, d.tspl_tdesc, a.sapl_tdesc, e.carr_tdesc, c.espe_tdesc, b.plan_ncorrelativo,"
SQL = SQL &  "        f.peri_tdesc, a.sapl_npond_asignaturas,"
SQL = SQL &  " 	   sum(g.repl_nponderacion) as pond_adicionales,"
SQL = SQL &  " 	   nvl(a.sapl_npond_asignaturas, 0) + nvl(sum(g.repl_nponderacion), 0) as pond_total "
SQL = SQL &  " from salidas_plan a, planes_estudio b, especialidades c, tipos_salidas_plan d, carreras e, periodos_academicos f,"
SQL = SQL &  "      requisitos_plan g,"
SQL = SQL &  " 	 requisitos_plan h"
SQL = SQL &  " where a.plan_ccod = b.plan_ccod"
SQL = SQL &  "   and b.espe_ccod = c.espe_ccod"
SQL = SQL &  "   and a.tspl_ccod = d.tspl_ccod"
SQL = SQL &  "   and c.carr_ccod = e.carr_ccod "
SQL = SQL &  "   and a.peri_ccod = f.peri_ccod"
SQL = SQL &  "   and a.sapl_ncorr = g.sapl_ncorr (+)"
SQL = SQL &  "   and a.sapl_ncorr = h.sapl_ncorr"
SQL = SQL &  "   and h.repl_ncorr = '" & q_repl_ncorr & "'"
SQL = SQL &  " group by a.plan_ccod, b.espe_ccod, c.carr_ccod, a.peri_ccod, d.tspl_tdesc, a.sapl_tdesc, e.carr_tdesc, c.espe_tdesc, b.plan_ncorrelativo,"
SQL = SQL &  "        f.peri_tdesc, a.sapl_npond_asignaturas"



f_encabezado.Consultar SQL
f_encabezado.Siguiente


'---------------------------------------------------------------------------------------------------
set f_requisito = new CFormulario
f_requisito.Carga_Parametros "adm_requisitos_adicionales.xml", "requisito"
f_requisito.Inicializar conexion

SQL = " select a.repl_ncorr, b.treq_tdesc, c.teva_tdesc, a.repl_nponderacion, a.treq_ccod, b.teva_ccod "
SQL = SQL &  " from requisitos_plan a, tipos_requisitos_titulo b, tipos_evaluacion_requisitos c"
SQL = SQL &  " where a.treq_ccod = b.treq_ccod"
SQL = SQL &  "   and b.teva_ccod = c.teva_ccod"
SQL = SQL &  "   and a.repl_ncorr = '" & q_repl_ncorr & "'"


f_requisito.Consultar SQL

f_requisito.Siguiente
v_teva_ccod = f_requisito.ObtenerValor("teva_ccod")

if v_teva_ccod = "2" then
	f_requisito.AgregaCampoParam "repl_nponderacion", "permiso", "LECTURA"
end if

f_requisito.Primero


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
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">	  <br>
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
            <td><%pagina.DibujarLenguetas Array("Editar"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><br>
              <table width="98%"  border="0" align="center">
              <tr>
                <td><div align="center"><%f_encabezado.DibujaRegistro%></div></td>
              </tr>
            </table>
              <br>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Requisito"%>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><div align="center"><%f_requisito.DibujaTabla%></div></td>
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
                  <td><div align="center"><%f_botonera.DibujaBoton "aceptar"%></div></td>
                  <td><div align="center"><%f_botonera_g.DibujaBoton "cancelar"%></div></td>
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
