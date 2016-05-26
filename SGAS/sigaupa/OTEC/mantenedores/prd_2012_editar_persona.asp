<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'q_pers_ncorr = Request.QueryString("pers_ncorr")
q_pers_nrut = Request.QueryString("persona[0][pers_nrut]")
q_pers_xdv = Request.QueryString("persona[0][pers_xdv]")


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Persona"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


set f_botonera = new CFormulario
f_botonera.Carga_Parametros "m_personas.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_datos = new CFormulario
f_datos.Carga_Parametros "m_personas.xml", "datos_persona"
f_datos.Inicializar conexion

set f_rut = new CFormulario
f_rut.Carga_Parametros "m_personas.xml", "rut_persona"
f_rut.Inicializar conexion

consulta = "SELECT a.pers_ncorr, a.pers_nrut, a.pers_xdv, a.pers_tape_paterno, a.pers_tape_materno, a.pers_tnombre, a.pers_tfono, " & vbCrLf &_
           "       b.dire_tcalle, b.dire_tpoblacion, b.dire_tnro, b.ciud_ccod " & vbCrLf &_
		   "FROM personas a, direcciones b " & vbCrLf &_
		   "WHERE a.pers_ncorr *= b.pers_ncorr " & vbCrLf &_
		   "  AND b.tdir_ccod  = 1 " & vbCrLf &_
		   "  AND a.pers_nrut = '" & q_pers_nrut & "'"


f_datos.Consultar consulta
f_datos.SiguienteF

f_rut.Consultar consulta
f_rut.SiguienteF

if f_datos.NroFilas = 0 then
	f_rut.AgregaCampoCons "pers_nrut", q_pers_nrut
	f_rut.AgregaCampoCons "pers_xdv", conexion.ConsultaUno("select dbo.dv(" & q_pers_nrut & ")")
	
	f_datos.AgregaCampoCons "pers_nrut", q_pers_nrut
	f_datos.AgregaCampoCons "pers_xdv", conexion.ConsultaUno("select dbo.dv(" & q_pers_nrut & ") ")
	'f_datos.AgregaCampoCons "x", "x"
end if

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
var t_codeudor;
var formulario;

window.resizeTo(450, 400);

function pers_nrut_change()
{
	url = "editar_persona.asp?pers_ncorr=" + t_persona.ObtenerValor(0, "pers_ncorr");
	formulario.action = url;
	formulario.method = "post";
	formulario.submit();
}


function Validar()
{
	rut = t_persona.ObtenerValor(0, "pers_nrut") + '-' + t_persona.ObtenerValor(0, "pers_xdv");
	if (!valida_rut(rut)) {
		alert('Ingrese un R.U.T. válido.');
		t_persona.filas[0].campos["pers_xdv"].objeto.select();
		return false;
	}
	
	return true;
}

function InicioPagina()
{	
	t_persona = new CTabla("persona");	
	//t_codeudor.filas[0].campos["pers_nrut"].objeto.focus();
	
	formulario = t_persona.formulario;
}

</script>

<style type="text/css">
<!--
.Estilo1 {
	color: #FF0000;
	font-weight: bold;
}
-->
</style>
</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
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
            <td><%pagina.DibujarLenguetas Array("Editar persona"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><br>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Persona"%>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr >
                          <td width="18" ><div align="left" class="Estilo1">(*)</div></td>
                          <td width="164" align="left"><strong>R.U.T.</strong></td>
                          <td width="10" align="left"><div align="center"><strong>:</strong></div></td>
                          <td width="470" align="left">&nbsp;<%f_rut.DibujaCampo "pers_nrut"%> 
                          - 
                            <%f_rut.DibujaCampo "pers_xdv"%></td>
                        </tr>
                      </table>                      
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"><%f_datos.DibujaRegistro%></div></td>
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
              <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton "aceptar"%></div></td>
                  <td><div align="center"><%f_botonera.DibujaBoton "cancelar"%></div></td>
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
