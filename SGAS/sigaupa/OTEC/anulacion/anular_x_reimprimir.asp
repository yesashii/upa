<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

q_pers_nrut 	= Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv 		= Request.QueryString("busqueda[0][pers_xdv]")
q_fact_nfactura = Request.QueryString("busqueda[0][fact_nfactura]")
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Facturas disponibles para anular y volver a reimprimir en sistema Otec"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

'set errores = new CErrores

'nombre del alumno
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
f_busqueda.AgregaCampoCons "fact_nfactura", q_fact_nfactura

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


if q_fact_nfactura <>"" then
	sql_filtro= " and a.fact_nfactura="&q_fact_nfactura&" "
end if

set f_formulario = new CFormulario
f_formulario.Carga_Parametros "anulacion_facturas.xml", "facturas"
f_formulario.Inicializar conexion


'--------------------------------------------------------------------------------------

	sql_facturas = " select distinct fact_mtotal as monto,pers_ncorr_alumno as pers_ncorr,fact_ncorr,fact_nfactura,fact_mtotal,efac_ccod, " & vbCrLf &_
					" tfac_ccod, pers_tnombre, mcaj_ncorr, ingr_nfolio_referencia as comprobante,fact_nfactura as num_factura " & vbCrLf &_
					" from facturas a, personas b,detalle_ingresos c " & vbCrLf &_
					" where a.pers_ncorr_alumno=b.pers_ncorr " & vbCrLf &_
					" and a.efac_ccod in (1,2) " & vbCrLf &_
					" "&sql_filtro&" " & vbCrLf &_
					" and cast(pers_nrut as varchar)='"&q_pers_nrut&"'" & vbCrLf &_
					" and a.fact_nfactura=c.ding_ndocto "& vbCrLf &_
					" and c.ting_ccod=49" & vbCrLf &_
					" and c.ding_bpacta_cuota='S'" & vbCrLf &_
					" and edin_ccod=1" 

'response.Write("<pre>"&sql_facturas&"</pre>")

f_formulario.Consultar sql_facturas
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
		document.buscador.elements['busqueda[0][pers_nrut]'].focus()
		document.buscador.elements['busqueda[0][pers_nrut]'].select()
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
/*
function valida_pagos(miformulario) {
	
	tabla_c = new CTabla("fact")

	miformulario = document.edicion
	ar = new Array()
	nreg=0
	//alert(tabla_c.filas[0].campos["ting_ccod"].objeto.value);
	if (tabla_c.filas[0].campos["ting_ccod"].objeto.value == -1 ){
		alert('Debe seleccionar una opcion de anulación válida.')
		return false;
	}
	if ( tabla_c.CuentaSeleccionados('fact_ncorr') == 1 ){
		
		return true;
	}
	alert('Debe seleccionar solo 1 registro para anular facturas por cambio de documento.')
	return false
		
}*/

function valida_pagos(miformulario) {
	
	if (document.edicion.elements["fact[0][ting_ccod]"].value == -1 ){
		alert('Debe seleccionar una opcion de anulación válida.')
		return false;
	}

	if (CuentaSeleccionados(document.edicion,'fact_ncorr') == 1 ){
		
		return true;
	}

	alert('Debe seleccionar solo 1 registro para anular facturas por cambio de documento.');
	return false
		
}

function CuentaSeleccionados(form, nombre){
	nombre=nombre;
	nro = form.elements.length;
   	num =0;
	for( i = 0; i < nro; i++ ) {
	  comp = form.elements[i];
	  str  = form.elements[i].name;
	  indice=extrae_indice(str);
	  campo='fact['+indice+']['+nombre+']';
	  if((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo') && (str == campo)){
		 num += 1;
	  }
	}	
	return num;
}

function mensaje(){
<%if session("mensajeError") <> "" then%>
alert('<%=session("mensajeError")%>');
<% session("mensajeError")="" %>
<%end if%>
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');" onBlur="revisaVentana();">
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
                        <td><div align="right"><strong>RUT a facturar </strong></div></td>
                        <td width="50"><div align="center">:</div></td>
                        <td><%f_busqueda.DibujaCampo("pers_nrut")%> 
                        - 
                          <%f_busqueda.DibujaCampo("pers_xdv")%> <%pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]"%></td>
						  <td><strong>N° Factura</strong></td>
						  <td><%f_busqueda.DibujaCampo("fact_nfactura")%> </td>
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
                                      <td width="11%"><strong>Opcion :</strong></td>
                                      <td width="69%">						  
									  <select name="fact[0][ting_ccod]">
										<option value="-1">Seleccione opcion para anular las facturas</option>
										<option value="123">Anulación Administrativa de facturas por Cursos</option>
										<option value="124">Anulación Administrativa de facturas por Diplomados</option>
										<option value="125">Anulación Administrativa de facturas por Postítulos</option>
			  							</select>
									  </td>
									  <td><input type="checkbox" value="1" name="no_print"><strong> No Reimprimir</strong></td>
                                      <td width="20%">
										<% if v_filas = 0 then 
											f_botonera.agregabotonparam "anular_x_reimprimir","deshabilitado","true"
										  end if
										  f_botonera.DibujaBoton("anular_x_reimprimir")
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
