<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

q_pers_nrut 	= Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv 		= Request.QueryString("busqueda[0][pers_xdv]")
q_ding_ndocto   = Request.QueryString("busqueda[0][ding_ndocto]")
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Facturas Otic disponibles para redistribuir segun nueva O.C."

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

'set errores = new CErrores

'nombre de la Empresa
nombre = conexion.consultauno("select pers_tnombre from personas where cast(pers_nrut as varchar) ='"&q_pers_nrut&"' and cast(pers_xdv as varchar) = '"&q_pers_xdv&"'")
v_pers_ncorr = conexion.consultauno("select pers_ncorr from personas where cast(pers_nrut as varchar) ='"&q_pers_nrut&"' and cast(pers_xdv as varchar) = '"&q_pers_xdv&"'")

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "anulacion_facturas.xml", "botonera"


'---------------------------------------------------------------------------------------------------


'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "anulacion_facturas.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.AgregaCampoCons "ding_ndocto", q_ding_ndocto

'---------------------------------------------------------------------------------------------------
set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede

'if not cajero.TieneCajaAbierta then
'		msg_alert="No puede facturar si no tiene una caja abierta."
'		ini_ocultar="<!--"
'		fin_ocultar="-->"
'else
'	msg_alert=""
'end if


'----------------------------------------------------------------------------------------------------
set persona = new CPersona
persona.Inicializar conexion, q_pers_nrut
set f_datos = persona

'--------------------------------------------------------------------------------------
f_botonera.AgregaBotonUrlParam "agregar", "pers_ncorr", persona.ObtenerPersNCorr

if EsVacio(persona.ObtenerPersNCorr) then
	f_botonera.AgregaBotonParam "agregar", "deshabilitado", "TRUE"
end if


if q_ding_ndocto <>"" then
	sql_filtro= " and c.ding_ndocto="&q_ding_ndocto&" "
end if

set f_formulario = new CFormulario
f_formulario.Carga_Parametros "anulacion_facturas.xml", "ordenes_compra"
f_formulario.Inicializar conexion


'--------------------------------------------------------------------------------------
' **** LISTA LAS ORDENES DE COMPRA ASOCIADAS A LA OTIC QUE DESEA REBAJAR COSTOS (PENDIENTES O PAGADAS)
sql_ordenes = "select a.ingr_ncorr,a.ingr_mtotal,a.ingr_mtotal as monto_orden, b.pers_ncorr,ding_ndocto,edin_ccod, pers_tnombre, " & vbCrLf &_
			"  mcaj_ncorr,a.ingr_nfolio_referencia as comprobante, ding_ndocto as num_orden, " & vbCrLf &_
			" (select top 1 isnull(ocot_monto_empresa,0) from ordenes_compras_otec where nord_compra=ding_ndocto and fpot_ccod=4 and empr_ncorr=a.pers_ncorr) as monto_empresa," & vbCrLf &_
			" (select top 1 protic.obtener_rut(empr_ncorr_2) from ordenes_compras_otec where nord_compra=ding_ndocto and fpot_ccod=4 and empr_ncorr=a.pers_ncorr) as rut_empresa, " & vbCrLf &_
			" (select top 1 protic.obtener_nombre(empr_ncorr_2,'n') from ordenes_compras_otec where nord_compra=ding_ndocto and fpot_ccod=4 and empr_ncorr=a.pers_ncorr) as nombre_empresa, " & vbCrLf &_
			" (select top 1 empr_ncorr_2 from ordenes_compras_otec where nord_compra=ding_ndocto and fpot_ccod=4 and empr_ncorr=a.pers_ncorr) as pers_ncorr_empresa " & vbCrLf &_
			" from ingresos a, personas b,detalle_ingresos c " & vbCrLf &_
			" where a.ingr_ncorr=c.ingr_ncorr " & vbCrLf &_
			" and a.pers_ncorr=b.pers_ncorr " & vbCrLf &_
			" "&sql_filtro&" " & vbCrLf &_
			" and cast(b.pers_nrut as varchar)='"&q_pers_nrut&"' " & vbCrLf &_
			" and c.ting_ccod=5 " & vbCrLf &_
			" and c.ding_bpacta_cuota='S' " & vbCrLf &_
			" and c.edin_ccod in (1,6)  " & vbCrLf &_
			" and exists (select top 1 pote_ncorr from postulacion_otec where empr_ncorr_otic=a.pers_ncorr) "& vbCrLf &_
			" order by a.ingr_ncorr desc "


'response.Write("<pre>"&sql_ordenes&"</pre>")

f_formulario.Consultar sql_ordenes
v_filas= f_formulario.nrofilas



if request.QueryString()="" then
	ini_ocultar="<!--"
	fin_ocultar="-->"
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
function ValidaBusqueda()
{
	rut=document.buscador.elements['busqueda[0][pers_nrut]'].value+'-'+document.buscador.elements['busqueda[0][pers_xdv]'].value
	
	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido');		
		document.buscador.elements['busqueda[0][pers_xdv]'].focus()
		document.buscador.elements['busqueda[0][pers_xdv]'].select()
		return false;
	}
	
	return true;	
}


nrofilasdibujadas=0

function existe(arreglo,valor){
	for (x=0;x<arreglo.length;x++){
		if (arreglo[x] == valor){
			return true
		}
	}
	return false
}

function valida_pagos(miformulario) {
	
	tabla_c = new CTabla("oc")

	miformulario = document.edicion
	ar = new Array()
	nreg=0
	if ( tabla_c.CuentaSeleccionados('ingr_ncorr') == 1 ){
		
		return true;
	}
	alert('Debe seleccionar solo 1 registro para anular facturas por cambio de documento.')
	return false
		
}

var t_busqueda;
function InicioPagina()
{
	t_busqueda = new CTabla("busqueda");
}

function mensaje(){
<%if session("mensajeError") <> "" then%>
alert('<%=session("mensajeError")%>');
<% session("mensajeError")="" %>
<%end if%>
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
<table width="700" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" align="left" bgcolor="#EAEAEA">
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                    <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td><div align="right"><strong>RUT Otic  </strong></div></td>
                        <td width="50"><div align="center">:</div></td>
                        <td><%f_busqueda.DibujaCampo("pers_nrut")%> 
                        - 
                          <%f_busqueda.DibujaCampo("pers_xdv")%> <%pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]"%></td>
						  <td><strong>N° OC </strong></td>
						  <td><%f_busqueda.DibujaCampo("ding_ndocto")%> </td>
                      </tr>
                    </table>
                  </div></td>
                  <td width="19%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td>
                </tr>
              </table>
            </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
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
					<td width="88%"><%=q_pers_nrut&"-"&q_pers_xdv%></td>
                </tr>
                <tr>
                  	<td><strong>Nombre</strong></td>
					<td><strong>:</strong></td>
					<td><%=nombre%></td>
                </tr>

              </table>
                </div>
              <form name="edicion">
                <input type="hidden" name="rut" value="<%=q_pers_nrut&"-"&q_pers_xdv%>">
				<input type="hidden" name="nombre" value="<%=nombre%>">
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Facturas disponibles"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"><%f_formulario.DibujaTabla%>
						  <script language="javascript">
						    nrofilasdibujadas=<%=v_filas%>
						  </script>
						  </div></td>
                        </tr>
                        <tr>
                          <td><div align="right">

								  <table width="100%" border="0">
                                    <tr>
                                      <td></td>
                                      <td></td>
                                      <td width="20%">
                                        <%%>
										<% if v_filas = 0 then 
											f_botonera.agregabotonparam "anular_x_compartido","deshabilitado","true"
										  end if
										  f_botonera.DibujaBoton("anular_x_compartido")
										%>
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
