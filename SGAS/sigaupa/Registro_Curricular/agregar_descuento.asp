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
'FECHA ACTUALIZACION 	:31/01/2013
'ACTUALIZADO POR		:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			:61 - 103,104
'********************************************************************
q_post_ncorr = Request.QueryString("post_ncorr")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Agregar descuento"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "agregar_descuento.xml", "botonera"

usuario 	= negocio.ObtenerUsuario()

'---------------------------------------------------------------------------------------------------
set f_descuento = new CFormulario
f_descuento.Carga_Parametros "agregar_descuento.xml", "descuento"
f_descuento.Inicializar conexion

'consulta = "select a.post_ncorr, a.ofer_ncorr, " & vbCrLf &_
'           "       c.aran_mmatricula, c.aran_mcolegiatura - isnull(d.vseg_mvalor, 0) as aran_mcolegiatura, " & vbCrLf &_
'		   "	   c.aran_mmatricula as c_aran_mmatricula, c.aran_mcolegiatura - isnull(d.vseg_mvalor, 0) as c_aran_mcolegiatura  " & vbCrLf &_
'		   "from postulantes a, ofertas_academicas b, aranceles c, valores_seguro d  " & vbCrLf &_
'		   "where a.ofer_ncorr = b.ofer_ncorr  " & vbCrLf &_
'		   "  and b.aran_ncorr = c.aran_ncorr " & vbCrLf &_
'		   "  and b.peri_ccod *= d.peri_ccod  " & vbCrLf &_
'		   "  and b.sede_ccod *= d.sede_ccod  " & vbCrLf &_
'		   "  and a.post_ncorr = '" & q_post_ncorr & "'"

consulta = "select a.post_ncorr, a.ofer_ncorr, " & vbCrLf &_
           "       c.aran_mmatricula, c.aran_mcolegiatura - isnull(d.vseg_mvalor, 0) as aran_mcolegiatura, " & vbCrLf &_
		   "	   c.aran_mmatricula as c_aran_mmatricula, c.aran_mcolegiatura - isnull(d.vseg_mvalor, 0) as c_aran_mcolegiatura  " & vbCrLf &_
		   "from postulantes a INNER JOIN ofertas_academicas b " & vbCrLf &_
		   "  ON a.ofer_ncorr = b.ofer_ncorr " & vbCrLf &_
		   "  INNER JOIN aranceles c " & vbCrLf &_
		   "  ON b.aran_ncorr = c.aran_ncorr " & vbCrLf &_
		   "  LEFT OUTER JOIN  valores_seguro d " & vbCrLf &_
		   "  ON b.peri_ccod = d.peri_ccod and b.sede_ccod = d.sede_ccod " & vbCrLf &_
		   "  WHERE a.post_ncorr = '" & q_post_ncorr & "'"

'response.Write("<pre>"&consulta&"</pre>")
f_descuento.Consultar consulta
f_descuento.AgregaCampoCons "esde_ccod", "2"



'filtros directores de magister

'Sonia Soler. (Magíster en Comunicación Estratégica)
if usuario="6939582" then
	sql_filtro="and a.stde_ccod in (1276,1385,1694,1695,1696)"
end if

'Ana susana Arancibia (Magíster Infancia y Adolescencia 1ª versión)
if usuario="6289563" or usuario="12863241"  then
	sql_filtro="and a.stde_ccod in (1276,1385,1863,1694,1695,1696)"
end if

'Patrick Laureau (Magíster en MKT y Negocios Internacionales)
if usuario="14461680" then
	sql_filtro="and a.stde_ccod in (1276,1385,1694,1695,1696)"
end if


'-------------------------------------------------------------------------------------------
'consulta_tipos_descuentos = "select stde_ccod, stde_tdesc, isnull(replace(stde_nptjematricula,',','.'), 0) as stde_nptjematricula, isnull(replace(stde_nptjecolegiatura,',','.'), 0) as stde_nptjecolegiatura, tben_ccod " & vbCrLf &_
'                            "from stipos_descuentos a " & vbCrLf &_
'							"where a.stde_ccod not in (select isnull(b2.stde_ccod,0) " & vbCrLf &_
'							"                  from postulantes a2, sdescuentos b2 " & vbCrLf &_
'							"				  where a2.post_ncorr *= b2.post_ncorr " & vbCrLf &_
'							"				    and a2.ofer_ncorr *= b2.ofer_ncorr " & vbCrLf &_
'							"					and a2.post_ncorr = '" & q_post_ncorr & "') "& vbCrLf &_
'							"	and a.stde_ccod not in  (2353,910,1390,1446,1537,1538,1912) "& vbCrLf &_
'							" "&sql_filtro&" "

consulta_tipos_descuentos = "select stde_ccod, stde_tdesc, isnull(replace(stde_nptjematricula,',','.'), 0) as stde_nptjematricula, isnull(replace(stde_nptjecolegiatura,',','.'), 0) as stde_nptjecolegiatura, tben_ccod " & vbCrLf &_
                            "from stipos_descuentos a " & vbCrLf &_
							"where a.stde_ccod not in (select isnull(b2.stde_ccod,0) " & vbCrLf &_
							"                  from postulantes a2 LEFT OUTER JOIN sdescuentos b2 " & vbCrLf &_
							"				    ON a2.post_ncorr = b2.post_ncorr " & vbCrLf &_
							"				    and a2.ofer_ncorr = b2.ofer_ncorr " & vbCrLf &_
							"					WHERE a2.post_ncorr = '" & q_post_ncorr & "') "& vbCrLf &_
							"	and a.stde_ccod not in  (2513,2353,910,1390,1446,1537,1538,1912) "& vbCrLf &_
							" "&sql_filtro&" "
							


'response.Write("<pre>"&consulta_tipos_descuentos&"</pre>")						
f_descuento.AgregaCampoParam "stde_ccod", "destino", "("&consulta_tipos_descuentos&") a"

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

<%pagina.GeneraDiccionarioJSClave consulta_tipos_descuentos, "stde_ccod", conexion, "d_stipos_descuentos"%>

<script language="JavaScript">
var porc_max_matricula = 0;
var por_max_colegiatura = 0;

function Validar()
{
	var formulario = document.forms["edicion"];
	var o_sdes_nporc_matricula = formulario.elements["descuento[0][sdes_nporc_matricula]"];
	var o_sdes_nporc_colegiatura = formulario.elements["descuento[0][sdes_nporc_colegiatura]"];
	var o_sdes_mmatricula = formulario.elements["descuento[0][sdes_mmatricula]"];
	var o_sdes_mcolegiatura = formulario.elements["descuento[0][sdes_mcolegiatura]"];
	var o_aran_mmatricula = formulario.elements["descuento[0][aran_mmatricula]"];
	var o_aran_mcolegiatura = formulario.elements["descuento[0][aran_mcolegiatura]"];
		
	if (parseFloat(o_sdes_nporc_matricula.value) > parseFloat(porc_max_matricula)) {
	    alert('El valor ingresado supera el porcentaje máximo permitido.')
		o_sdes_nporc_matricula.select();
		return false;
	}
	
	if (parseFloat(o_sdes_mmatricula.value) > Math.ceil((parseFloat(porc_max_matricula) * parseFloat(o_aran_mmatricula.value) / 100) ) ){
	    alert('El valor ingresado supera el máximo permitido.')
		o_sdes_mmatricula.select();
		return false;
	}
	 
	if (parseFloat(o_sdes_nporc_colegiatura.value) > parseFloat(por_max_colegiatura)) {
	    alert('El valor ingresado supera el porcentaje máximo permitido.')
		o_sdes_nporc_colegiatura.select();
		return false;
	}
	
	
	if (parseFloat(o_sdes_mcolegiatura.value) > Math.ceil((parseFloat(por_max_colegiatura) * parseFloat(o_aran_mcolegiatura.value) ) / 100 )) {
	    alert('El valor ingresado supera el máximo permitido.')
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


function stde_ccod_change()
{
	var formulario = document.forms["edicion"];
	var o_stde_ccod = formulario.elements["descuento[0][stde_ccod]"];	
	var o_sdes_nporc_matricula = formulario.elements["descuento[0][sdes_nporc_matricula]"];
	var o_sdes_nporc_colegiatura = formulario.elements["descuento[0][sdes_nporc_colegiatura]"];
	var o_sdes_mmatricula = formulario.elements["descuento[0][sdes_mmatricula]"];
	var o_sdes_mcolegiatura = formulario.elements["descuento[0][sdes_mcolegiatura]"];
	var o_aran_mmatricula = formulario.elements["descuento[0][aran_mmatricula]"];
	var o_aran_mcolegiatura = formulario.elements["descuento[0][aran_mcolegiatura]"];
	
	if (!isEmpty(o_stde_ccod.value)) {
		//o_sdes_nporc_matricula.value = d_stipos_descuentos.Item(o_stde_ccod.value).Item("stde_nptjematricula");
		//o_sdes_nporc_colegiatura.value = d_stipos_descuentos.Item(o_stde_ccod.value).Item("stde_nptjecolegiatura");
		
		o_sdes_nporc_matricula.value = 0;
		o_sdes_nporc_colegiatura.value = 0;
		
		porc_max_matricula = d_stipos_descuentos.Item(o_stde_ccod.value).Item("stde_nptjematricula");
		por_max_colegiatura = d_stipos_descuentos.Item(o_stde_ccod.value).Item("stde_nptjecolegiatura");
		
		formulario.elements["descuento[0][stde_nptjematricula]"].value = porc_max_matricula;
		formulario.elements["descuento[0][stde_nptjecolegiatura]"].value = por_max_colegiatura;
			
		if (d_stipos_descuentos.Item(o_stde_ccod.value).Item("tben_ccod") == "1")
		{
			o_sdes_nporc_matricula.value = "0";
			o_sdes_nporc_matricula.setAttribute("readOnly", true);
			
			o_sdes_mmatricula.value = "0";
			o_sdes_mmatricula.setAttribute("readOnly", true);
		}
		else
		{
			o_sdes_nporc_matricula.setAttribute("readOnly", false);
			o_sdes_mmatricula.setAttribute("readOnly", false);
		}
			
				
		CalcularMontosDescuento();
	}	
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


var t_descuento;
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
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
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
          <td><%pagina.DibujarLenguetas Array("Agregar descuento"), 1 %></td>
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
