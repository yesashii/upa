<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Facturación Otec"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

'nombre del alumno
nombre = conexion.consultauno("select pers_tnombre from personas where cast(pers_nrut as varchar) ='"&q_pers_nrut&"' and cast(pers_xdv as varchar) = '"&q_pers_xdv&"'")
v_pers_ncorr = conexion.consultauno("select pers_ncorr from personas where cast(pers_nrut as varchar) ='"&q_pers_nrut&"' and cast(pers_xdv as varchar) = '"&q_pers_xdv&"'")

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "facturar_otec.xml", "botonera"


'---------------------------------------------------------------------------------------------------
set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede

if not cajero.TieneCajaAbierta then
	conexion.MensajeError "No puede recibir pagos si no tiene una caja abierta."
	Response.Redirect("../lanzadera/lanzadera.asp")
end if

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "facturar_otec.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv

'---------------------------------------------------------------------------------------------------


'----------------------------------------------------------------------------------------------------
set persona = new CPersona
persona.Inicializar conexion, q_pers_nrut
set f_datos = persona

'--------------------------------------------------------------------------------------
f_botonera.AgregaBotonUrlParam "agregar", "pers_ncorr", persona.ObtenerPersNCorr

if EsVacio(persona.ObtenerPersNCorr) then
	f_botonera.AgregaBotonParam "agregar", "deshabilitado", "TRUE"
end if


set f_formulario = new CFormulario
f_formulario.Carga_Parametros "facturar_otec.xml", "compromisos_por_pagar"
f_formulario.Inicializar conexion


'--------------------------------------------------------------------------------------

	sql_compromisos_pagar = " select  "& vbCrLf &_
							"     case " & vbCrLf &_
							"   when b.tcom_ccod=25 or b.tcom_ccod=4 or b.tcom_ccod=5 or b.tcom_ccod=8 or b.tcom_ccod=10 or b.tcom_ccod=26 or b.tcom_ccod=34 or b.tcom_ccod=35" & vbCrLf &_
        					"		then " & vbCrLf &_
						    "       (Select a1.tdet_tdesc from tipos_detalle a1,detalles a2 where a2.tcom_ccod=a.tcom_ccod and a2.inst_ccod=a.inst_ccod " & vbCrLf &_
						    "        and a2.comp_ndocto=a.comp_ndocto and a1.tdet_ccod=a2.tdet_ccod) " & vbCrLf &_
						    " 	when b.tcom_ccod=37 then (select a3.tcom_tdesc from tipos_compromisos a3 where a3.tcom_ccod=a.tcom_ccod)+'-'+protic.obtener_nombre_carrera(a.ofer_ncorr,'CJ') "& vbCrLf &_
							"   else " & vbCrLf &_
						    "        (select a3.tcom_tdesc from tipos_compromisos a3 where a3.tcom_ccod=a.tcom_ccod) " & vbCrLf &_
						    "    end as tcom_tdesc, " & vbCrLf &_
							"			b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, b.comp_ndocto as c_comp_ndocto, b.tcom_ccod as c_tcom_ccod, cast(b.dcom_ncompromiso as varchar) + ' / '+ cast(a.comp_ncuotas as varchar) as ncuota, a.comp_fdocto, b.dcom_fcompromiso, b.dcom_mcompromiso, "& vbCrLf &_
							"			protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as ting_ccod,"& vbCrLf &_   
							"			protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') as ding_ndocto,  "& vbCrLf &_ 
							"			protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as abonos, "& vbCrLf &_
    						"			protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as documentado, "& vbCrLf &_
							"			 protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo, "& vbCrLf &_
     						"		   d.edin_ccod, d.edin_tdesc, d.udoc_ccod   "& vbCrLf &_
							"		   "& vbCrLf &_
							"	 from "& vbCrLf &_
							"		compromisos a "& vbCrLf &_
							"		join detalle_compromisos b "& vbCrLf &_
							"			on a.tcom_ccod = b.tcom_ccod   "& vbCrLf &_ 
							"			and a.inst_ccod = b.inst_ccod    "& vbCrLf &_
							"			and a.comp_ndocto = b.comp_ndocto "& vbCrLf &_
							"		left outer join detalle_ingresos c "& vbCrLf &_
							"			on protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') = c.ting_ccod   "& vbCrLf &_
							"			   and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto  "& vbCrLf &_
							"			   and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') = c.ingr_ncorr    "& vbCrLf &_
							"		left join estados_detalle_ingresos d   "& vbCrLf &_
							"			on c.edin_ccod = d.edin_ccod "& vbCrLf &_
							"	 where protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0  "& vbCrLf &_
							"	   and isnull(d.udoc_ccod, 1) = 1  "& vbCrLf &_
							"	   and ( (c.ting_ccod is null) or  "& vbCrLf &_
							"			 (c.ting_ccod = 5 and d.edin_ccod not in (6) ) "& vbCrLf &_
							"			)  "& vbCrLf &_
							"	   and a.ecom_ccod = '1'  "& vbCrLf &_
							"	   and b.ecom_ccod = '1'  "& vbCrLf &_
							"	 --  and a.tcom_ccod = '7'  "& vbCrLf &_
							"  	and cast(a.pers_ncorr  as varchar)= '" & v_pers_ncorr & "'"& vbCrLf &_
							"	order by b.dcom_fcompromiso asc, b.dcom_ncompromiso asc, b.tcom_ccod asc "

f_formulario.Consultar sql_compromisos_pagar
v_filas= f_formulario.nrofilas
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
	rut = t_busqueda.ObtenerValor(0, "pers_nrut") + '-' + t_busqueda.ObtenerValor(0, "pers_xdv").toUpperCase();
	
	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido.');		
		t_busqueda.filas[0].campos["pers_xdv"].objeto.select();
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
	
	tabla_c = new CTabla("cc_compromisos_pendientes")

	miformulario = document.edicion
	ar = new Array()
	nreg=0
	
	if ( tabla_c.CuentaSeleccionados('dcom_ncompromiso') > 0 ){
		for (i=0;i<nrofilasdibujadas;i++){
			if (miformulario.elements["cc_compromisos_pendientes["+i+"][dcom_ncompromiso]"].checked){
				if (!existe(ar,miformulario.elements["cc_compromisos_pendientes["+i+"][tcom_ccod]"].value)){
					ar[nreg] = miformulario.elements["cc_compromisos_pendientes["+i+"][tcom_ccod]"].value
					nreg++
				}		
			}
		}
		lineas_detalle = nreg + 1 + parseInt(miformulario.elements["nro_docto"].value)
		if (lineas_detalle >= 14){
			alert('Error: No podra imprimir Comprobante de Ingresos.\nEl detalle a generar es mas grande que el comprobante.')
			return false
		}
		resultado = window.open('','ventana','scrollbars=yes width=800,height=550, menubar = no, top = 10, left = 10, resizable')
		return true
	}
	alert('Debe seleccionar al menos un compromiso.')
	return false
		
}

var t_busqueda;
function InicioPagina()
{
	t_busqueda = new CTabla("busqueda");
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
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
                        <td><div align="right"><strong>R.U.T. Alumno </strong></div></td>
                        <td width="50"><div align="center">:</div></td>
                        <td><%f_busqueda.DibujaCampo("pers_nrut")%> 
                        - 
                          <%f_busqueda.DibujaCampo("pers_xdv")%> <%pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]"%></td>
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
                    <input type="hidden" name="nro_campos" value="<%=nro_campos%>">
					<input type="hidden" name="nro_campos2" value="<%=nro_campos2%>">
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Compromisos pendientes"%>
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
                                  <% if v_filas = 0 then 
								  	f_botonera.agregabotonparam "pagar","deshabilitado","true"
								  end if
								  %>
								  <table width="100%" border="0">
                                    <tr>
                                      <td>&nbsp;</td>
                                      <td>&nbsp;</td>
                                      <td><div align="right">
                                          <input type="hidden" name="nro_docto" value="1">
                                        </div></td>
                                      <td width="20%">
                                        <%f_botonera.DibujaBoton("pagar")%>
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
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
