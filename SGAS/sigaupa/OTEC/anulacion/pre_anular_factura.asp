<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

nombre 			= Request.Form("nombre")
rut				= Request.Form("rut")


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Facturas para cambio de pago"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

'set errores = new CErrores

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next


set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "anulacion_facturas.xml", "botonera"


'---------------------------------------------------------------------------------------------------
set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede

if not cajero.TieneCajaAbierta then
		session("mensajeError")="No puede anular la factura seleccionada si no tiene una caja abierta."
		ini_ocultar="<!--"
		fin_ocultar="-->"
		response.Redirect(Request.ServerVariables("HTTP_REFERER"))
else
	msg_alert=""
end if


'--------------------------------------------------------------------------------------


set formulario = new CFormulario
formulario.Carga_Parametros "anulacion_facturas.xml", "f_facturas"
formulario.Inicializar conexion
formulario.ProcesaForm		

for fila = 0 to formulario.CuentaPost - 1

	fact_ncorr		= formulario.ObtenerValorPost (fila, "fact_ncorr")

	if fact_ncorr <> "" then
		v_monto_fact	= formulario.ObtenerValorPost (fila, "monto")
		v_pers_ncorr	= formulario.ObtenerValorPost (fila, "pers_ncorr")
		v_fact_ncorr	= fact_ncorr
		v_pote_ncorr	= conexion.consultaUno("select top 1 pote_ncorr from postulantes_cargos_factura where fact_ncorr="&fact_ncorr)
	end if
next

'--------------------------------------------------------------------------------------
set f_formulario = new CFormulario
f_formulario.Carga_Parametros "anulacion_facturas.xml", "facturas_ralacionadas"
f_formulario.Inicializar conexion

	sql_facturas = "select c.comp_ndocto,a.ingr_nfolio_referencia as comprobante,fact_ncorr,efac_ccod,protic.obtener_rut(pers_ncorr_alumno) as rut_empresa,"& vbCrLf &_
					" fact_mtotal as monto_factura, fact_nfactura as num_factura, efac_ccod, tfac_ccod, a.mcaj_ncorr as num_caja "& vbCrLf &_
					" from facturas a, ingresos b, abonos c  "& vbCrLf &_
					" where fact_ncorr in (select fact_ncorr from postulantes_cargos_factura where pote_ncorr="&v_pote_ncorr&") "& vbCrLf &_
					" and efac_ccod not in (3)"& vbCrLf &_
					" and a.ingr_nfolio_referencia=b.ingr_nfolio_referencia"& vbCrLf &_
					" and b.ingr_ncorr=c.ingr_ncorr "
					

f_formulario.Consultar sql_facturas
v_filas= f_formulario.nrofilas

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

<script language="JavaScript">


function valida_pagos(miformulario) {

formu		= 	document.edicion;
v_select	=	formu.elements("fact[0][ting_ccod]").value;
//fact[0][ting_ccod]
if(v_select>1){
	return true;
}else{
	alert("No puede continuar si no ha seleccionado una opción de anulacion");
	formu.elements("fact[0][ting_ccod]").focus();
	return false;
}

	
		
}

var t_busqueda;
function InicioPagina()
{
	t_busqueda = new CTabla("busqueda");
}

function mensaje(){
<%if msg_alert <> "" then%>
alert('<%=msg_alert%>');
<%end if%>
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
<table width="700" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" align="left" bgcolor="#EAEAEA">
	<br>
	<%=ini_ocultar%>
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
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
              <br>
              <table width="96%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  	<td width="10%"><strong>Rut</strong></td>
					<td width="2%"><strong>:</strong></td>
					<td width="88%"><%=rut%></td>
                </tr>
                <tr>
                  	<td><strong>Nombre</strong></td>
					<td><strong>:</strong></td>
					<td><%=nombre%></td>
                </tr>

              </table>
			  <br/>
					<center><div class="MsgError" > 
				   <table border="0"  cellspacing="2"  cellpadding="5"  align="center"> 
				   <tr> 
				   <td> Las facturas listadas mas abajo, estan asociadas entre si y seran anuladas conjuntamente. </td>
				   </tr>
				   </table>
	   			   </div></center> 
				   
              <form name="edicion">

                <input type="hidden" name="fact[0][fact_ncorr]" value="<%=v_fact_ncorr%>">
				<input type="hidden" name="fact[0][monto]" value="<%=v_monto_fact%>">
				<input type="hidden" name="fact[0][pers_ncorr]" value="<%=v_pers_ncorr%>">
				<input type="hidden" name="nombre" value="<%=nombre%>">
 
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Facturas asociadas para anular"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td>
						  <div align="center"><%f_formulario.DibujaTabla%> </div></td>
                        </tr>
                        <tr>
                          <td>
						  <br/>
						  <strong>Opcion de anulación:</strong>
						  <select name="fact[0][ting_ccod]">
							<option value="-1">-->Seleccione opcion para anular las facturas<--</option>
							<option value="123">Anulación Administrativa de facturas por Cursos</option>
							<option value="124">Anulación Administrativa de facturas por Diplomados</option>
							<option value="125">Anulación Administrativa de facturas por Postítulos</option>
			  			</select>
						  <div align="right">
                                  <% if v_filas = 0 then 
								  	f_botonera.agregabotonparam "continuar","deshabilitado","true"
								  end if
								  %>
								  <table width="100%" border="0">
                                    <tr>
                                      <td>&nbsp;</td>
                                      <td>&nbsp;</td>
                                      <td></td>
                                      <td width="20%">
                                        <%f_botonera.DibujaBoton("continuar")%>
                                      </td>
                                    </tr>
                                  </table>
                                </div></td>
                        </tr>
                      </table>
					</td>
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
            <td width="16%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="84%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<%=fin_ocultar%>
	<br>
	<br>
</td>
  </tr>  
</table>
</body>
</html>
