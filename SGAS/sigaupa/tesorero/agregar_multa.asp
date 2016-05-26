<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_ncorr = Request.QueryString("pers_ncorr")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Cargo en Cuenta Corriente"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_pers_ncorr_cajera=negocio.ObtenerUsuario
'response.Write(v_pers_ncorr_cajera)
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "agregar_cargo_cc.xml", "botonera"


v_inst_ccod = "1"
'---------------------------------------------------------------------------------------------------
set f_cargo = new CFormulario
f_cargo.Carga_Parametros "agregar_cargo_cc.xml", "cargo"
f_cargo.Inicializar conexion

f_cargo.Consultar "select ''"

f_cargo.AgregaCampoCons "pers_ncorr", q_pers_ncorr
f_cargo.AgregaCampoCons "inst_ccod", v_inst_ccod
f_cargo.AgregaCampoCons "deta_ncantidad", "1"
f_cargo.AgregaCampoCons "deta_mvalor_unitario", "0"
f_cargo.AgregaCampoCons "deta_msubtotal", "0"



'---------------------------------------------------------------------------------------------------
set persona = new CPersona
persona.Inicializar conexion, conexion.ConsultaUno("select pers_nrut from personas where cast(pers_ncorr as varchar) = '"&q_pers_ncorr&"'")

set alumno = new CAlumno
alumno.Inicializar conexion, persona.ObtenerMatrNCorr(negocio.ObtenerPeriodoAcademico("CLASES18"))

if EsVacio(persona.ObtenerMatrNCorr(negocio.ObtenerPeriodoAcademico("CLASES18"))) then
	set f_datos = persona
else
	set f_datos = alumno
end if


f_cargo.AgregaCampoParam "tdet_ccod", "filtro", " tdet_ccod in (1223,1246)"

'---------------------------------------------------------------------------------------------------
sql_tipos_detalle = "select a.tcom_ccod, a.tdet_ccod, a.tdet_tdesc, a.tdet_mvalor_unitario " & vbCrLf &_
                    "from tipos_detalle a, tipos_compromisos b " & vbCrLf &_
					"where a.tcom_ccod = b.tcom_ccod " & vbCrLf &_
					"  and a.tdet_bvigente = 'S' " & vbCrLf &_
					"  and a.tdet_bcargo = 'S' " & vbCrLf &_
					" and a.tcom_ccod in (5) "& vbCrLf &_
					" "&filtro&" "& vbCrLf &_
					"order by a.tcom_ccod, a.tdet_tdesc"
					
					
'response.Write("<pre>"&sql_tipos_detalle&"</pre>")					
'response.End()					
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

<%pagina.GeneraDiccionarioJS sql_tipos_detalle, conexion, "d_tipos_detalle"%>
<%pagina.GeneraDiccionarioJSClave sql_tipos_detalle, "tdet_ccod", conexion, "d_tipos_detalle_c"%>

<script language="JavaScript">

function ValidarCargos()
{
	if (t_cargo.SumarColumna("deta_msubtotal") <= 0) {
		alert('El cargo debe ser generado por un monto mayor que $0.');
		return false;			
	}	
		
	return true;
}

function HabilitarFila(p_fila, p_habilitado)
{	
	t_cargo.filas[p_fila].HabilitarPorCampo(p_habilitado, "tdet_ccod");
}

function tcom_ccod_change(p_objeto)
{
	var fila = _FilaCampo(p_objeto);	
	//alert("objeto2 "+p_objeto);	
	HabilitarFila(fila, !isEmpty(p_objeto.value));
		
	_FiltrarCombobox(t_cargo.filas[fila].campos["tdet_ccod"].objeto,
	                 p_objeto.value,
					 d_tipos_detalle,
					 'tcom_ccod',
					 'tdet_ccod',
					 'tdet_tdesc',
					 "", "Seleccione Ítem");
}


function tdet_ccod_change(p_objeto)
{	var fila = _FilaCampo(p_objeto);
	//alert("objeto "+p_objeto.value);
	HabilitarFila(fila, !isEmpty(p_objeto.value));
	
	if (!isEmpty(p_objeto.value)) {
		t_cargo.AsignarValor(fila, "deta_mvalor_unitario", d_tipos_detalle_c.Item(p_objeto.value).Item("tdet_mvalor_unitario"));
	}
	else {
		t_cargo.AsignarValor(fila, "deta_mvalor_unitario", "0");
	}
	
	CalcularSubTotal(fila);
}

function deta_ncantidad_change(p_objeto)
{
	var fila = _FilaCampo(p_objeto);
	CalcularSubTotal(fila);
}

function deta_mvalor_unitario_change(p_objeto)
{
	var fila = _FilaCampo(p_objeto);
	CalcularSubTotal(fila);
}


function CalcularSubTotal(p_fila)
{
	var v_sub_total;		
	
	v_sub_total = t_cargo.ObtenerValor(p_fila, "deta_ncantidad") * t_cargo.ObtenerValor(p_fila, "deta_mvalor_unitario");	
	t_cargo.AsignarValor(p_fila, "deta_msubtotal", v_sub_total);
	
	CalcularTotal();
}


function CalcularTotal()
{
	//alert(t_cargo.SumarColumna("deta_msubtotal"));
}


var t_cargo;
function InicioPagina()
{
	t_cargo = new CTabla("cargo");
	
	for (var i = 0; i < t_cargo.filas.length; i++)
		t_cargo.filas[i].HabilitarPorCampo(false, "tdet_ccod");
}

</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
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
            <td><%pagina.DibujarLenguetas Array("Cargo en Cuenta Corriente"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%>
              <br>
              <br>
              <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                    <%f_datos.DibujaDatos%></div></td>
                </tr>
              </table>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Nuevos cargos"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"><%f_cargo.DibujaTabla%></div></td>
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
                  <td><div align="center"><%f_botonera.DibujaBoton("aceptar_multa")%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("cancelar")%>
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
