<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO: MODULO TESORERO 
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:22/04/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			: 84
'*******************************************************************
q_pers_nrut = Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Emisión Notas de Crédito"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "notas_credito.xml", "botonera"


set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede

if not cajero.TieneCajaAbierta then
	conexion.MensajeError "No puede emitir notas de crédito si no tiene una caja abierta."
	Response.Redirect("../lanzadera/lanzadera.asp")
end if

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "notas_credito.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv


'---------------------------------------------------------------------------------------------------
set f_ingresos = new CFormulario
f_ingresos.Carga_Parametros "notas_credito.xml", "ingresos"
f_ingresos.Inicializar conexion

'consulta = "select a.ting_ccod as c_ting_ccod, a.ingr_nfolio_referencia as c_ingr_nfolio_referencia, a.ting_ccod, a.ingr_nfolio_referencia, a.mcaj_ncorr, trunc(a.ingr_fpago) as ingr_fpago, a.pers_ncorr, b.sede_ccod, " & vbCrLf &_
'           "       sum(a.ingr_mtotal) as total_ingreso,  " & vbCrLf &_
'		   "       sum(case when (a.eing_ccod = 1) or (c.ting_ccod is not null and nvl(c.ding_bpacta_cuota, 'N') = 'N' and nvl(c.ding_ncorrelativo, 1) > 0) then a.ingr_mtotal - total_rebajado_ingreso_nc(a.ingr_ncorr) else 0 end) as anulable	     " & vbCrLf &_
'		   "from ingresos a, movimientos_cajas b, detalle_ingresos c, personas d   " & vbCrLf &_
'		   "where a.mcaj_ncorr = b.mcaj_ncorr  " & vbCrLf &_
'		   "  and a.ingr_ncorr = c.ingr_ncorr (+)  " & vbCrLf &_
'		   "  and a.pers_ncorr = d.pers_ncorr " & vbCrLf &_
'		   "  and a.eing_ccod in (1, 4) " & vbCrLf &_
'		   "  and a.ting_ccod in (7, 16, 33, 34, 8, 10) " & vbCrLf &_
'		   "  and nvl(c.edin_ccod, 0) not in (9) " & vbCrLf &_
'		   "  and d.pers_nrut = '" & q_pers_nrut & "'  " & vbCrLf &_
'		   "group by a.ting_ccod, a.ingr_nfolio_referencia, a.mcaj_ncorr, trunc(a.ingr_fpago), a.pers_ncorr, b.sede_ccod    " & vbCrLf &_
'		   "having b.sede_ccod = '" & negocio.ObtenerSede & "'  " & vbCrLf &_
'		   "   and sum(case when (a.eing_ccod = 1) or (c.ting_ccod is not null and nvl(c.ding_bpacta_cuota, 'N') = 'N' and nvl(c.ding_ncorrelativo, 1) > 0) then a.ingr_mtotal - total_rebajado_ingreso_nc(a.ingr_ncorr) else 0 end) > 0 " & vbCrLf &_
'		   "order by trunc(a.ingr_fpago) asc, a.ingr_nfolio_referencia asc"
		   
'consulta = "select a.ting_ccod as c_ting_ccod, a.ingr_nfolio_referencia as c_ingr_nfolio_referencia," & vbCrLf &_
'			"    a.ting_ccod, a.ingr_nfolio_referencia, a.mcaj_ncorr, max(protic.trunc(a.ingr_fpago)) as ingr_fpago, a.pers_ncorr, b.sede_ccod," & vbCrLf &_
'			"    sum(a.ingr_mtotal) as total_ingreso," & vbCrLf &_
'			"    sum(case when (a.eing_ccod = 1) or (c.ting_ccod is not null and isnull(c.ding_bpacta_cuota, 'N') = 'N' and isnull(c.ding_ncorrelativo, 1) > 0) then a.ingr_mtotal - protic.total_rebajado_ingreso_nc(a.ingr_ncorr,a.mcaj_ncorr) else 0 end) as anulable" & vbCrLf &_
'			"    from ingresos a,movimientos_cajas b,detalle_ingresos c,personas d" & vbCrLf &_
'			"    where a.mcaj_ncorr = b.mcaj_ncorr" & vbCrLf &_
'			"        and a.ingr_ncorr *= c.ingr_ncorr" & vbCrLf &_
'			"        and a.pers_ncorr = d.pers_ncorr" & vbCrLf &_
'			"        and a.eing_ccod in (1, 4) " & vbCrLf &_
'			"        and a.ting_ccod in (7, 16, 33, 34, 8, 10) " & vbCrLf &_
'			"        and isnull(c.edin_ccod, 0) not in (9)" & vbCrLf &_
'			"        and cast(d.pers_nrut as varchar) = '" & q_pers_nrut & "'  " & vbCrLf &_
'			"group by a.ting_ccod, a.ingr_nfolio_referencia, a.mcaj_ncorr, cast(a.ingr_fpago as numeric), a.pers_ncorr, b.sede_ccod" & vbCrLf &_
'			"having b.sede_ccod = '" & negocio.ObtenerSede & "'  " & vbCrLf &_
'			"   and sum(case when (a.eing_ccod = 1) or (c.ting_ccod is not null and isnull(c.ding_bpacta_cuota, 'N') = 'N' and isnull(c.ding_ncorrelativo, 1) > 0) then a.ingr_mtotal - protic.total_rebajado_ingreso_nc(a.ingr_ncorr,a.mcaj_ncorr) else 0 end) > 0 " & vbCrLf &_
'			"order by ingr_fpago  asc, a.ingr_nfolio_referencia asc"

consulta = "select a.ting_ccod as c_ting_ccod, a.ingr_nfolio_referencia as c_ingr_nfolio_referencia," & vbCrLf &_
			"    a.ting_ccod, a.ingr_nfolio_referencia, a.mcaj_ncorr, max(protic.trunc(a.ingr_fpago)) as ingr_fpago, a.pers_ncorr, b.sede_ccod," & vbCrLf &_
			"    sum(a.ingr_mtotal) as total_ingreso," & vbCrLf &_
			"    sum(case when (a.eing_ccod = 1) or (c.ting_ccod is not null and isnull(c.ding_bpacta_cuota, 'N') = 'N' and isnull(c.ding_ncorrelativo, 1) > 0) then a.ingr_mtotal - protic.total_rebajado_ingreso_nc(a.ingr_ncorr,a.mcaj_ncorr) else 0 end) as anulable" & vbCrLf &_
			"    from ingresos a " & vbCrLf &_
			"    INNER JOIN movimientos_cajas b " & vbCrLf &_
			"    ON a.mcaj_ncorr = b.mcaj_ncorr and a.eing_ccod in (1, 4) and a.ting_ccod in (7, 16, 33, 34, 8, 10)  " & vbCrLf &_
			"    LEFT OUTER JOIN detalle_ingresos c " & vbCrLf &_
			"    ON a.ingr_ncorr = c.ingr_ncorr and isnull(c.edin_ccod, 0) not in (9) " & vbCrLf &_
 			"   INNER JOIN personas d " & vbCrLf &_
			"    ON a.pers_ncorr = d.pers_ncorr and cast(d.pers_nrut as varchar) = '" & q_pers_nrut & "'  " & vbCrLf &_
			"group by a.ting_ccod, a.ingr_nfolio_referencia, a.mcaj_ncorr, cast(a.ingr_fpago as numeric), a.pers_ncorr, b.sede_ccod" & vbCrLf &_
			"having b.sede_ccod = '" & negocio.ObtenerSede & "'  " & vbCrLf &_
			"   and sum(case when (a.eing_ccod = 1) or (c.ting_ccod is not null and isnull(c.ding_bpacta_cuota, 'N') = 'N' and isnull(c.ding_ncorrelativo, 1) > 0) then a.ingr_mtotal - protic.total_rebajado_ingreso_nc(a.ingr_ncorr,a.mcaj_ncorr) else 0 end) > 0 " & vbCrLf &_
			"order by ingr_fpago  asc, a.ingr_nfolio_referencia asc"

'response.Write("<pre>"&consulta&"</pre>")
					   
f_ingresos.Consultar consulta

if f_ingresos.NroFilas = 0 then
	f_botonera.AgregaBotonParam "aceptar", "deshabilitado", "TRUE"
end if

'---------------------------------------------------------------------------------------------------
set f_notas_credito = new CFormulario
f_notas_credito.Carga_Parametros "notas_credito.xml", "lista_notas_credito"
f_notas_credito.Inicializar conexion

consulta = "select b.ting_ccod as c_ting_ccod, b.ingr_nfolio_referencia as c_ingr_nfolio_referencia, b.pers_ncorr, b.ting_ccod, b.ingr_nfolio_referencia, protic.trunc(b.ingr_fpago) as ingr_fpago, sum(b.ingr_mtotal) as ingr_mtotal, protic.str_origen_notacredito(b.ting_ccod, b.ingr_nfolio_referencia, b.pers_ncorr) as origen, protic.total_utilizado_notacredito(b.ingr_nfolio_referencia, b.pers_ncorr) as utilizado " & vbCrLf &_
           "from notascreditos_documentos a, ingresos b, personas c " & vbCrLf &_
		   "where a.ingr_ncorr_notacredito = b.ingr_ncorr " & vbCrLf &_
		   "  and b.pers_ncorr = c.pers_ncorr " & vbCrLf &_
		   "  and b.ting_ccod <> 30 " & vbCrLf &_
		   "  and b.eing_ccod = 1 " & vbCrLf &_
		   "  and cast(c.pers_nrut as varchar) = '" & q_pers_nrut & "' " & vbCrLf &_
		   "group by b.ting_ccod, b.ingr_nfolio_referencia, protic.trunc(b.ingr_fpago), b.pers_ncorr"

'response.Write("<pre>"&consulta&"</pre>")
		   
		   
f_notas_credito.Consultar consulta

if f_notas_credito.NroFilas > 0 then
	f_notas_credito.AgregaCampoCons "peri_ccod", negocio.ObtenerPeriodoAcademico("POSTULACION")
end if



'----------------------------------------------------------------------------------------------------------------
set f_tipos_notascredito = new CFormulario
f_tipos_notascredito.Carga_Parametros "notas_credito.xml", "tipos_notas_credito"
f_tipos_notascredito.Inicializar conexion
f_tipos_notascredito.Consultar "select '' "
f_tipos_notascredito.Siguiente

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
function ValidarEmision()
{
	if (t_ingresos.CuentaSeleccionados("ingr_nfolio_referencia") == 0 ) {
		alert('Debe seleccionar uno o más ingresos para emitir nota de crédito.');
		return false;
	}
	
	return true;
}


var t_ingresos;

function InicioPagina()
{
	t_ingresos = new CTabla("ingresos")
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
                        <td width="50"><div align="center"><strong>:</strong></div></td>
                        <td><%f_busqueda.DibujaCampo("pers_nrut")%> 
                          - 
                            <%f_busqueda.DibujaCampo("pers_xdv")%> <%pagina.DibujarBuscaPersonas "b[0][pers_nrut]", "b[0][pers_xdv]"%></td>
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
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Ingresos"%>
                      <input type="hidden" name="notas_credito[0][zzz]">                      
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"><%f_ingresos.DibujaTabla%></div></td>
                          </tr>
                        <tr>
                          <td><div align="right">
                                <br>
                                <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                  <tr>
                                    <td width="82%"><div align="right">
                                          <%f_tipos_notascredito.DibujaCampo "ting_ccod"%>
                                    </div></td>
                                    <td width="18%"><div align="center">
                                          <%f_botonera.DibujaBoton("aceptar")%>
                                    </div></td>
                                  </tr>
                                </table>
                          </div></td>
                        </tr>
                      </table>
                      <br>
                      <%pagina.DibujarSubtitulo "Notas de crédito"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center">
                                <%f_notas_credito.DibujaTabla%>
                          </div></td>
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
            <td width="15%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("salir")%>
                  </div></td>
                  </tr>
              </table>
            </div></td>
            <td width="85%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
