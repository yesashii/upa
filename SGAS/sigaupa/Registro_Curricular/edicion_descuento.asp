<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO: ADMISION Y MATRICULA
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:12/02/2013
'ACTUALIZADO POR		:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			:72
'********************************************************************
q_post_ncorr = Request.QueryString("post_ncorr")
q_ofer_ncorr = Request.QueryString("ofer_ncorr")
q_stde_ccod = Request.QueryString("stde_ccod")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Modificar descuento"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "edicion_descuento.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_descuento = new CFormulario
f_descuento.Carga_Parametros "edicion_descuento.xml", "descuento"
f_descuento.Inicializar conexion

'consulta = "select d.stde_ccod, d.stde_ccod as c_stde_ccod, d.post_ncorr, d.ofer_ncorr, d.esde_ccod, f.tben_ccod, " & vbCrLf &_
'           "       d.sdes_mmatricula, d.sdes_mcolegiatura, " & vbCrLf &_
'		   "       replace(d.sdes_nporc_matricula,',','.') as sdes_nporc_matricula , replace(d.sdes_nporc_colegiatura,',','.') as sdes_nporc_colegiatura, " & vbCrLf &_
'		   "	   c.aran_mmatricula, c.aran_mcolegiatura - isnull(e.vseg_mvalor, 0) as aran_mcolegiatura, c.aran_mmatricula as c_aran_mmatricula, c.aran_mcolegiatura - isnull(e.vseg_mvalor, 0) as c_aran_mcolegiatura,  " & vbCrLf &_
'		   "       isnull(replace(f.STDE_NPTJEMATRICULA,',','.'), 0) as STDE_NPTJEMATRICULA, isnull(replace(f.STDE_NPTJECOLEGIATURA,',','.'), 0) as STDE_NPTJECOLEGIATURA   " & vbCrLf &_
'		   "from postulantes a, ofertas_academicas b, aranceles c, sdescuentos d, valores_seguro e, stipos_descuentos f " & vbCrLf &_
'		   "where a.ofer_ncorr = b.ofer_ncorr  " & vbCrLf &_
'		   "  and b.aran_ncorr = c.aran_ncorr  " & vbCrLf &_
'		   "  and a.post_ncorr = d.post_ncorr  " & vbCrLf &_
'		   "  and a.ofer_ncorr = d.ofer_ncorr  " & vbCrLf &_
'		   "  and b.peri_ccod *= e.peri_ccod  " & vbCrLf &_
'		   "  and b.sede_ccod *= e.sede_ccod  " & vbCrLf &_
'		   "  and d.stde_ccod = f.stde_ccod " & vbCrLf &_
'		   "  and a.post_ncorr = '" & q_post_ncorr & "' " & vbCrLf &_
'		   "  and d.ofer_ncorr = '" & q_ofer_ncorr & "' " & vbCrLf &_
'		   "  and d.stde_ccod = '" & q_stde_ccod & "'"

consulta = "select d.stde_ccod, d.stde_ccod as c_stde_ccod, d.post_ncorr, d.ofer_ncorr, d.esde_ccod, f.tben_ccod, " & vbCrLf &_
           "       d.sdes_mmatricula, d.sdes_mcolegiatura, " & vbCrLf &_
		   "       replace(d.sdes_nporc_matricula,',','.') as sdes_nporc_matricula , replace(d.sdes_nporc_colegiatura,',','.') as sdes_nporc_colegiatura, " & vbCrLf &_
		   "	   c.aran_mmatricula, c.aran_mcolegiatura - isnull(e.vseg_mvalor, 0) as aran_mcolegiatura, c.aran_mmatricula as c_aran_mmatricula, c.aran_mcolegiatura - isnull(e.vseg_mvalor, 0) as c_aran_mcolegiatura,  " & vbCrLf &_
		   "       isnull(replace(f.STDE_NPTJEMATRICULA,',','.'), 0) as STDE_NPTJEMATRICULA, isnull(replace(f.STDE_NPTJECOLEGIATURA,',','.'), 0) as STDE_NPTJECOLEGIATURA   " & vbCrLf &_
		   "from postulantes a INNER JOIN ofertas_academicas b " & vbCrLf &_
		   "  ON a.ofer_ncorr = b.ofer_ncorr " & vbCrLf &_
		   "  INNER JOIN aranceles c " & vbCrLf &_
		   "  ON b.aran_ncorr = c.aran_ncorr " & vbCrLf &_
		   "  INNER JOIN sdescuentos d " & vbCrLf &_
		   "  ON a.post_ncorr = d.post_ncorr and a.ofer_ncorr = d.ofer_ncorr " & vbCrLf &_
		   "  LEFT OUTER JOIN valores_seguro e " & vbCrLf &_
		   "  ON b.peri_ccod = e.peri_ccod and b.sede_ccod = e.sede_ccod " & vbCrLf &_
		   "  INNER JOIN stipos_descuentos f " & vbCrLf &_
 		   "  ON d.stde_ccod = f.stde_ccod " & vbCrLf &_
		   "  WHERE d.stde_ccod not in  (2513,2353,910,1390,1446,1537,1538,1912) "& vbCrLf &_
		   "  and a.post_ncorr = '" & q_post_ncorr & "' " & vbCrLf &_
		   "  and d.ofer_ncorr = '" & q_ofer_ncorr & "' " & vbCrLf &_
		   "  and d.stde_ccod = '" & q_stde_ccod & "'"

'response.Write("<pre>" & consulta & "</pre>")

f_descuento.Consultar consulta
f_descuento.Siguiente

v_esde_ccod = f_descuento.ObtenerValor("esde_ccod")
v_tben_ccod = f_descuento.ObtenerValor("tben_ccod")
v_stde_ccod = f_descuento.ObtenerValor("stde_ccod")

if v_stde_ccod="2513" or v_stde_ccod="2353" or v_stde_ccod="910" or v_stde_ccod="1390" or v_stde_ccod="1446" or v_stde_ccod="1537" or v_stde_ccod="1538" or v_stde_ccod="1912" then
	v_becas_estado=true
else
	v_becas_estado=false
end if

if v_esde_ccod = "1" or v_becas_estado then 'Autorizado
	f_descuento.AgregaCampoParam "sdes_nporc_matricula", "permiso", "LECTURA"
	f_descuento.AgregaCampoParam "sdes_nporc_colegiatura", "permiso", "LECTURA"

	f_descuento.AgregaCampoParam "sdes_mmatricula", "permiso", "LECTURA"
	f_descuento.AgregaCampoParam "sdes_mcolegiatura", "permiso", "LECTURA"

	f_descuento.AgregaCampoParam "sdes_mmatricula", "formato", "MONEDA"
	f_descuento.AgregaCampoParam "sdes_mcolegiatura", "formato", "MONEDA"

	f_descuento.AgregaParam "camposObligatorios", "FALSE"
	f_botonera.AgregaBotonParam "aceptar", "accion", "CERRAR"
end if

if v_tben_ccod = "1" then 'Credito
	f_descuento.AgregaCampoParam "sdes_nporc_matricula", "soloLectura", "TRUE"
	f_descuento.AgregaCampoParam "sdes_mmatricula", "soloLectura", "TRUE"
end if


'-------------------------------------------------------------------------------------------
consulta_tipos_descuentos = "select stde_ccod, stde_tdesc, isnull(replace(stde_nptjematricula,',','.'), 0) as stde_nptjematricula, isnull(replace(stde_nptjecolegiatura,',','.'), 0) as stde_nptjecolegiatura  " & vbCrLf &_
                            "from stipos_descuentos a " & vbCrLf &_
							"where cast(stde_ccod as numeric) not in (select cast(a2.stde_ccod as numeric)  " & vbCrLf &_
							"                  from sdescuentos a2 " & vbCrLf &_
							"				  where  a2.post_ncorr = '" & q_post_ncorr & "')"

'response.Write("<pre>" & consulta_tipos_descuentos & "</pre>")

'f_descuento.AgregaCampoParam "stde_ccod", "destino", "("&consulta_tipos_descuentos&")"
%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<%pagina.GeneraDiccionarioJSClave consulta_tipos_descuentos, "stde_ccod", conexion, "d_stipos_descuentos"%>

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>


<script language="JavaScript">

function Validar()
{
	var formulario = document.forms["edicion"];
	var o_sdes_nporc_matricula = formulario.elements["descuento[0][sdes_nporc_matricula]"];
	var o_sdes_nporc_colegiatura = formulario.elements["descuento[0][sdes_nporc_colegiatura]"];
	var o_sdes_mmatricula = formulario.elements["descuento[0][sdes_mmatricula]"];
	var o_sdes_mcolegiatura = formulario.elements["descuento[0][sdes_mcolegiatura]"];
	var o_aran_mmatricula = formulario.elements["descuento[0][aran_mmatricula]"];
	var o_aran_mcolegiatura = formulario.elements["descuento[0][aran_mcolegiatura]"];

	var porc_max_matricula = <%=f_descuento.ObtenerValor("stde_nptjematricula")%>
	var por_max_colegiatura = <%=f_descuento.ObtenerValor("stde_nptjecolegiatura")%>

	if (o_sdes_nporc_matricula.value > porc_max_matricula)	{
	    alert('El valor de la matricula ingresado supera el porcentaje máximo permitido.')
		o_sdes_nporc_matricula.select();
		return false;
	}

	if (parseFloat(o_sdes_mmatricula.value) > Math.ceil((parseFloat(porc_max_matricula) * parseFloat(o_aran_mmatricula.value) / 100) ) ){
	    alert('El valor ingresado supera el máximo permitido.')
		o_sdes_mmatricula.select();
		return false;
	}

	if (o_sdes_nporc_colegiatura.value > por_max_colegiatura) {
	    alert('El valor ingresado supera el porcentaje máximo permitido.')
		o_sdes_nporc_colegiatura.select();
		return false;
	}

	if (parseFloat(o_sdes_mcolegiatura.value) > Math.ceil((parseFloat(por_max_colegiatura) * parseFloat(o_aran_mcolegiatura.value) ) / 100 ) ){

	    alert('El valor del arancel ingresado supera el máximo permitido.')
		o_sdes_mcolegiatura.select();
		return false;
	}


	if ((o_sdes_nporc_matricula.value < 0) || (o_sdes_nporc_matricula.value > 100)) {
		alert('Porcentaje de descuento debe ser entre 0 y 100.')
		o_sdes_nporc_matricula.select();
		return false;
	}

	if (o_sdes_mmatricula.value < 0) {
		alert('Descuento debe ser mayor que 0.')
		o_sdes_mmatricula.select();
		return false;
	}

	if ((o_sdes_nporc_colegiatura.value < 0) || (o_sdes_nporc_colegiatura.value > 100)) {
		alert('Porcentaje de descuento debe ser entre 0 y 100.')
		o_sdes_nporc_colegiatura.select();
		return false;
	}

	if (o_sdes_mcolegiatura.value < 0) {
		alert('Descuento debe ser mayor que 0.')
		o_sdes_mcolegiatura.select();
		return false;
	}


	return true;
}


function CalcularMontosDescuento()
{
	var formulario = document.forms["edicion"];
	var o_stde_ccod = formulario.elements["descuento[0][stde_ccod]"];
	var o_sdes_nporc_matricula = formulario.elements["descuento[0][sdes_nporc_matricula]"];
	var o_sdes_nporc_colegiatura = formulario.elements["descuento[0][sdes_nporc_colegiatura]"];
	var o_sdes_mmatricula = formulario.elements["descuento[0][sdes_mmatricula]"];
	var o_sdes_mcolegiatura = formulario.elements["descuento[0][sdes_mcolegiatura]"];
	var o_aran_mmatricula = formulario.elements["descuento[0][aran_mmatricula]"];
	var o_aran_mcolegiatura = formulario.elements["descuento[0][aran_mcolegiatura]"];


	o_sdes_mmatricula.value = Redondear(o_aran_mmatricula.value * (o_sdes_nporc_matricula.value / 100), 0);
	o_sdes_mcolegiatura.value = Redondear(o_aran_mcolegiatura.value * (o_sdes_nporc_colegiatura.value / 100), 0);
}


function CalcularPorcentajesDescuento()
{
	var formulario = document.forms["edicion"];
	var o_stde_ccod = formulario.elements["descuento[0][stde_ccod]"];
	var o_sdes_nporc_matricula = formulario.elements["descuento[0][sdes_nporc_matricula]"];
	var o_sdes_nporc_colegiatura = formulario.elements["descuento[0][sdes_nporc_colegiatura]"];
	var o_sdes_mmatricula = formulario.elements["descuento[0][sdes_mmatricula]"];
	var o_sdes_mcolegiatura = formulario.elements["descuento[0][sdes_mcolegiatura]"];
	var o_aran_mmatricula = formulario.elements["descuento[0][aran_mmatricula]"];
	var o_aran_mcolegiatura = formulario.elements["descuento[0][aran_mcolegiatura]"];


	o_sdes_nporc_matricula.value = Redondear((o_sdes_mmatricula.value * 100) / o_aran_mmatricula.value, 2);
	o_sdes_nporc_colegiatura.value = Redondear((o_sdes_mcolegiatura.value * 100) / o_aran_mcolegiatura.value, 2);
}


function sdes_nporc_matricula_change()
{
	CalcularMontosDescuento();
}

function sdes_nporc_colegiatura_change()
{
	CalcularMontosDescuento();
}

function sdes_mmatricula_change()
{
	CalcularPorcentajesDescuento();
}

function sdes_mcolegiatura_change()
{
	CalcularPorcentajesDescuento();
}

function InicioPagina()
{
	t_descuento = new CTabla("descuento");
	t_descuento.filas[0].campos["stde_nptjematricula"].objeto.className = 'suma';
	t_descuento.filas[0].campos["stde_nptjecolegiatura"].objeto.className = 'suma';
}


</script>
<style type="text/css">
input.suma {
background-color:#D8D8DE;
border:0;
text-align:left;
}
</style>

<style type="text/css">
<!--
body {
	background-color: #EAEAEA;
}
.style1 {
	color: #FF0000;
	font-weight: bold;
}
-->
</style></head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');InicioPagina();" onBlur="revisaVentana();">
<br>
<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
  <tr>
    <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
    <td height="8" background="../imagenes/top_r1_c2.gif"></td>
    <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
  </tr>
  <tr>
    <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
    <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><%pagina.DibujarLenguetas Array("Modificar descuento"), 1 %></td>
        </tr>
        <tr>
          <td height="2" background="../imagenes/top_r3_c2.gif"></td>
        </tr>
        <tr>
          <td><div align="center"></div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><br>
                      <%f_descuento.DibujaRegistro%>
                    </td></tr>
                </table>
<br>
            </form></td>
        </tr>
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
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("aceptar")%>
                  </div></td>
                  <td><div align="center"><%f_botonera.DibujaBoton("cancelar")%></div></td>
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
</body>
</html>
