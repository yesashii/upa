<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_reti_ncorr = Request.QueryString("reti_ncorr")


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Editar requisito"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "adm_requisitos_titulacion.xml", "botonera"

set f_botonera_g = new CFormulario
f_botonera_g.Carga_Parametros "botonera_generica.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_requisito = new CFormulario
f_requisito.Carga_Parametros "adm_requisitos_titulacion.xml", "edicion_requisito"
f_requisito.Inicializar conexion

SQL = " select a.reti_ncorr, a.repl_ncorr, a.ereq_ccod, a.reti_ftermino, trim(to_char(a.reti_nnota, '0.0')) as reti_nnota, "
SQL = SQL &  "        b.treq_ccod, b.repl_nponderacion,		"
SQL = SQL &  " 	   d.treq_tdesc, e.teva_tdesc, h.carr_tdesc, g.espe_tdesc, f.plan_ncorrelativo,"
SQL = SQL &  " 	   obtener_rut(a.pers_ncorr) as rut, obtener_nombre_completo(a.pers_ncorr) as nombre,"
SQL = SQL &  " 	   c.sapl_tdesc, i.peri_tdesc, j.tspl_tdesc, d.teva_ccod "
SQL = SQL &  " from requisitos_titulacion a, requisitos_plan b, salidas_plan c, tipos_requisitos_titulo d, tipos_evaluacion_requisitos e,"
SQL = SQL &  "      planes_estudio f, especialidades g, carreras h, periodos_academicos i, tipos_salidas_plan j"
SQL = SQL &  " where a.repl_ncorr = b.repl_ncorr"
SQL = SQL &  "   and b.sapl_ncorr = c.sapl_ncorr"
SQL = SQL &  "   and b.treq_ccod = d.treq_ccod"
SQL = SQL &  "   and d.teva_ccod = e.teva_ccod"
SQL = SQL &  "   and c.plan_ccod = f.plan_ccod"
SQL = SQL &  "   and f.espe_ccod = g.espe_ccod"
SQL = SQL &  "   and g.carr_ccod = h.carr_ccod"
SQL = SQL &  "   and c.peri_ccod = i.peri_ccod"
SQL = SQL &  "   and c.tspl_ccod = j.tspl_ccod"
SQL = SQL &  "   and a.reti_ncorr = '" & q_reti_ncorr & "'"

f_requisito.Consultar SQL

f_requisito.Siguiente
v_teva_ccod = f_requisito.ObtenerValor("teva_ccod")
if v_teva_ccod = "2" then
	f_requisito.AgregaCampoParam "reti_nnota", "permiso", "LECTURA"
end if
f_requisito.Primero

'---------------------------------------------------------------------------------------------------
set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "adm_requisitos_titulacion.xml", "encabezado"
f_encabezado.Inicializar conexion
f_encabezado.Consultar SQL

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

var v_nota_aprobacion = parseFloat('<%=negocio.ObtenerParametroSistema("NOTA_APROBACION")%>');

function reti_nnota_change(p_objeto)
{
	var v_reti_nnota = p_objeto.value;
	
	if (isNumber(v_reti_nnota)) {		
		if (parseFloat(v_reti_nnota) >= v_nota_aprobacion) {
			t_requisitos.AsignarValor(_FilaCampo(p_objeto), "ereq_ccod", 1);
		}
		else {
			t_requisitos.AsignarValor(_FilaCampo(p_objeto), "ereq_ccod", 2);
		}
	}
}

var t_requisitos;

function Inicio()
{
	t_requisitos = new CTabla("rt");	
}

</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); Inicio();" onBlur="revisaVentana();">
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
            <td width="23%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton "aceptar"%></div></td>
                  <td><div align="center"><%f_botonera_g.DibujaBoton "cancelar"%></div></td>
                </tr>
              </table>
            </div></td>
            <td width="77%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
