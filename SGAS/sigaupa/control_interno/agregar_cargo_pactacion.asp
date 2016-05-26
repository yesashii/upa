<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut = Request.QueryString("pers_nrut")
q_pers_ncorr_codeudor = Request.QueryString("pers_ncorr_codeudor")

set pagina = new CPagina
pagina.Titulo = "Agregar cargo"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "agregar_cargo_pactacion.xml", "botonera"


'---------------------------------------------------------------------------------------------------
set persona = new CPersona
persona.Inicializar conexion, q_pers_nrut

'---------------------------------------------------------------------------------------------------
set f_cargo = new CFormulario
f_cargo.Carga_Parametros "agregar_cargo_pactacion.xml", "cargo"
f_cargo.Inicializar conexion

f_cargo.Consultar "select ''"
f_cargo.AgregaCampoCons "comp_mneto", "0"
f_cargo.AgregaCampoCons "comp_mdescuento", "0"
f_cargo.AgregaCampoCons "comp_mdocumento", "0"
f_cargo.AgregaCampoCons "pers_ncorr", conexion.ConsultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)= '" & q_pers_nrut & "'")
f_cargo.AgregaCampoCons "pers_ncorr_codeudor", q_pers_ncorr_codeudor


'---------------------------------------------------------------------------------------------------
sql_tipos_detalle = "select a.tcom_ccod, a.tdet_ccod, a.tdet_tdesc, a.tdet_mvalor_unitario " & vbCrLf &_
                    "from tipos_detalle a, tipos_compromisos b " & vbCrLf &_
					"where a.tcom_ccod = b.tcom_ccod " & vbCrLf &_
					"  and b.tcom_ccod = '7' " & vbCrLf &_
					"  and a.tdet_bvigente = 'S' " & vbCrLf &_
					"order by a.tcom_ccod, a.tdet_tdesc"

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

<%pagina.GeneraDiccionarioJSClave sql_tipos_detalle, "tdet_ccod", conexion, "d_tipos_detalle_c"%>

<script language="JavaScript">

function Validar()
{
	if (t_cargo.filas[0].campos["comp_mdescuento"].objeto.value < 0 ) {
		alert('Descuento no puede ser negativo.');
		t_alt_cargo.filas[0].campos["comp_mdescuento"].objeto.select();
		return false;
	}
	
	if (t_cargo.filas[0].campos["comp_mdocumento"].objeto.value < 0 ) {
		alert('Total a pagar no puede ser negativo.');
		t_alt_cargo.filas[0].campos["comp_mdocumento"].objeto.select();
		return false;
	}
	
	return true;
}


function CalcularSubTotal(p_fila)
{
	t_cargo.AsignarValor(p_fila, "comp_mdocumento", t_cargo.ObtenerValor(p_fila, "comp_mneto") - t_cargo.ObtenerValor(p_fila, "comp_mdescuento"));
	t_alt_cargo.filas[p_fila].campos["comp_mdocumento"].objeto.focus(); t_alt_cargo.filas[p_fila].campos["comp_mdocumento"].objeto.blur();
}


function tdet_ccod_change(p_objeto)
{
	var fila = _FilaCampo(p_objeto);
	
	if (!isEmpty(p_objeto.value)) {
		t_cargo.AsignarValor(fila, "comp_mneto", d_tipos_detalle_c.Item(p_objeto.value).Item("tdet_mvalor_unitario"));
	}
	else {
		t_cargo.AsignarValor(fila, "comp_mneto", "0");
	}
	
	t_alt_cargo.filas[fila].campos["comp_mneto"].objeto.focus(); t_alt_cargo.filas[fila].campos["comp_mneto"].objeto.blur();	
	
	CalcularSubTotal(fila);
}

function comp_mdescuento_blur(p_objeto)
{
	CalcularSubTotal(_FilaCampo(p_objeto));
}


var t_cargo;
var t_alt_cargo;
function InicioPagina()
{
	t_cargo = new CTabla("cargo");
	t_alt_cargo = new CTabla("_cargo");	
}

</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
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
            <td><%pagina.DibujarLenguetas Array("Ingresar codeudor", "Seleccionar curso", "Pactaci&oacute;n"), 2 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center">
              <br>
              <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td><div align="center">
                        <%persona.DibujaDatos%>
                  </div></td>
                </tr>
              </table>
              </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Nuevo cargo"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><%f_cargo.DibujaTabla%></td>
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
                  <td><div align="center"><%f_botonera.DibujaBoton "siguiente"%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton "cancelar"%>
                  </div></td>
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
