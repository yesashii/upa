<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO: FINANZAS
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:07/02/2013
'ACTUALIZADO POR		:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			:101
'********************************************************************
q_pers_nrut = Request.QueryString("pers_nrut")
'---------------------------------------------------------------------------------------------------


set pagina = new CPagina
pagina.Titulo = "Codeudor - Repactación"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set variables = new CVariables
variables.ProcesaForm
'variables.Listar

if EsVacio(q_pers_nrut) then
	v_pers_ncorr_codeudor = variables.ObtenerValor("detalles_repactacion", 0, "pers_ncorr_codeudor")
else
	v_pers_ncorr_codeudor = conexion.ConsultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar) = '" & q_pers_nrut & "'")
end if


set f_botonera = new CFormulario
f_botonera.Carga_Parametros "cambiar_codeudor_repactacion.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_detalles_repactacion = new CFormulario
f_detalles_repactacion.Carga_Parametros "cambiar_codeudor_repactacion.xml", "detalles_repactacion"
f_detalles_repactacion.Inicializar conexion
f_detalles_repactacion.Consultar "select ''"

j_ = 0
for i_ = 0 to variables.NroFilas("DETALLES_REPACTACION") - 1
	if variables.ObtenerValor("detalles_repactacion", i_, "bcambia_codeudor") = "S" then		
		f_detalles_repactacion.AgregaCampoFilaCons j_, "repa_ncorr",  variables.ObtenerValor("detalles_repactacion", i_, "repa_ncorr")
		f_detalles_repactacion.AgregaCampoFilaCons j_, "sdrp_ncuota",  variables.ObtenerValor("detalles_repactacion", i_, "sdrp_ncuota")		
		f_detalles_repactacion.AgregaCampoFilaCons j_, "bcambia_codeudor",  "S"
		
		j_ = j_ + 1	
	end if	
next

'response.Write(f_detalles_repactacion.NroFilas)


'---------------------------------------------------------------------------------------------------
set f_datos_codeudor = new CFormulario
f_datos_codeudor.Carga_Parametros "cambiar_codeudor_repactacion.xml", "datos_codeudor"
f_datos_codeudor.Inicializar conexion

set f_rut_codeudor = new CFormulario
f_rut_codeudor.Carga_Parametros "cambiar_codeudor_repactacion.xml", "rut_codeudor"
f_rut_codeudor.Inicializar conexion

'consulta = "SELECT a.pers_ncorr, a.pers_nrut, a.pers_xdv, a.pers_tape_paterno, a.pers_tape_materno, a.pers_tnombre, a.pers_tfono, " & vbCrLf &_
'           "       b.dire_tcalle, b.dire_tnro, b.ciud_ccod, b.dire_tblock,b.dire_tdepto,b.dire_tpoblacion " & vbCrLf &_
'		   "FROM personas a, direcciones b " & vbCrLf &_
'		   "WHERE a.pers_ncorr *= b.pers_ncorr " & vbCrLf &_
'		   "  AND b.tdir_ccod = 1 " & vbCrLf &_
'		   "  AND cast(a.pers_ncorr as varchar)= '" & v_pers_ncorr_codeudor & "'"& vbCrLf &_
'		  " Union "& vbCrLf &_
'		   "SELECT a.pers_ncorr, a.pers_nrut, a.pers_xdv, a.pers_tape_paterno, a.pers_tape_materno, a.pers_tnombre, a.pers_tfono, " & vbCrLf &_
'           "      b.dire_tcalle, b.dire_tnro, b.ciud_ccod, b.dire_tblock,b.dire_tdepto,b.dire_tpoblacion  " & vbCrLf &_
'		   "FROM personas_postulante a, direcciones_publica b " & vbCrLf &_
'		   "WHERE a.pers_ncorr *= b.pers_ncorr " & vbCrLf &_
'		   "  AND b.tdir_ccod  = 1 " & vbCrLf &_
'		   "  AND cast(a.pers_ncorr as varchar)= '" & v_pers_ncorr_codeudor & "'"

consulta = "SELECT a.pers_ncorr, a.pers_nrut, a.pers_xdv, a.pers_tape_paterno, a.pers_tape_materno, a.pers_tnombre, a.pers_tfono, " & vbCrLf &_
           "       b.dire_tcalle, b.dire_tnro, b.ciud_ccod, b.dire_tblock,b.dire_tdepto,b.dire_tpoblacion " & vbCrLf &_
		   "FROM personas a LEFT OUTER JOIN direcciones b " & vbCrLf &_
		   "  ON a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
		   "  WHERE b.tdir_ccod = 1 " & vbCrLf &_
		   "  AND cast(a.pers_ncorr as varchar)= '" & v_pers_ncorr_codeudor & "'"& vbCrLf &_
		  " Union "& vbCrLf &_
		   "SELECT a.pers_ncorr, a.pers_nrut, a.pers_xdv, a.pers_tape_paterno, a.pers_tape_materno, a.pers_tnombre, a.pers_tfono, " & vbCrLf &_
           "      b.dire_tcalle, b.dire_tnro, b.ciud_ccod, b.dire_tblock,b.dire_tdepto,b.dire_tpoblacion  " & vbCrLf &_
		   "FROM personas_postulante a LEFT OUTER JOIN direcciones_publica b " & vbCrLf &_
		   "  ON a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
		   "  WHERE b.tdir_ccod  = 1 " & vbCrLf &_
		   "  AND cast(a.pers_ncorr as varchar)= '" & v_pers_ncorr_codeudor & "'"

'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_datos_codeudor.Consultar consulta
f_datos_codeudor.SiguienteF

f_rut_codeudor.Consultar consulta
f_rut_codeudor.SiguienteF


if f_datos_codeudor.NroFilas = 0 then
	f_rut_codeudor.AgregaCampoCons "pers_nrut", q_pers_nrut
	f_rut_codeudor.AgregaCampoCons "pers_xdv", conexion.ConsultaUno("select dbo.dv('" & q_pers_nrut & "')")
	f_datos_codeudor.AgregaCampoCons "x", "x"
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


window.resizeTo(600, 500);

function pers_nrut_change()
{
	url = "cambiar_codeudor_repactacion.asp?pers_nrut=" + t_codeudor.ObtenerValor(0, "pers_nrut");
	formulario.action = url;
	formulario.method = "post";
	formulario.submit();
}


function Validar()
{
	rut = t_codeudor.ObtenerValor(0, "pers_nrut") + '-' + t_codeudor.ObtenerValor(0, "pers_xdv");
	if (!valida_rut(rut)) {
		alert('Ingrese un R.U.T. válido.');
		t_codeudor.filas[0].campos["pers_xdv"].objeto.select();
		return false;
	}
	
	return true;
}

function InicioPagina()
{	
	t_codeudor = new CTabla("codeudor");	
	t_codeudor.filas[0].campos["pers_nrut"].objeto.focus();
	
	formulario = t_codeudor.formulario;
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
            <td><%pagina.DibujarLenguetas Array("Cambiar codeudor"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><br>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Codeudor"%>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="50"><div align="center" class="Estilo1">(*)</div></td>
                          <td><strong>R.U.T.</strong></td>
                          <td width="50"><div align="center"><strong>:</strong></div></td>
                          <td><%f_rut_codeudor.DibujaCampo "pers_nrut"%> 
                          - 
                            <%f_rut_codeudor.DibujaCampo "pers_xdv"%></td>
                        </tr>
                      </table>                      
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"><%f_datos_codeudor.DibujaRegistro%></div></td>
                        </tr>
                      </table></td>
                  </tr>
                </table>
                          <%f_detalles_repactacion.DibujaTabla%><br>
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
