<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_ingr_nfolio_referencia = Request.QueryString("busqueda[0][ingr_nfolio_referencia]")
q_ting_ccod = Request.QueryString("busqueda[0][ting_ccod]")
q_mcaj_ncorr = Request.QueryString("busqueda[0][mcaj_ncorr]")

'response.Write("<hr>"&q_ting_ccod&"<hr>")
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Anulación de ingresos cajas del Dia"


'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "anulacion_ingresos.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede


'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "anula_ingreso_interno.xml", "busqueda"
f_busqueda.Inicializar conexion

f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "ingr_nfolio_referencia", q_ingr_nfolio_referencia
f_busqueda.AgregaCampoCons "ting_ccod", q_ting_ccod
f_busqueda.AgregaCampoCons "mcaj_ncorr", q_mcaj_ncorr

sql_cajas_dia ="(select a.mcaj_ncorr, cast(a.mcaj_ncorr as varchar)+'-> '+protic.obtener_nombre(b.pers_ncorr,'c') as cajero" & vbCrLf &_
				 " from movimientos_cajas a, cajeros b " & vbCrLf &_
				 "       where a.caje_ccod=b.caje_ccod " & vbCrLf &_
				 "       and a.sede_ccod=b.sede_ccod " & vbCrLf &_
				 "       and a.tcaj_ccod=1000 " & vbCrLf &_
				 "       and a.eren_ccod=1 " & vbCrLf &_
				 "       and protic.trunc(a.mcaj_finicio) = protic.trunc(getdate())" & vbCrLf &_
				 " )a " 

f_busqueda.AgregaCampoParam "mcaj_ncorr", "destino", sql_cajas_dia


'-------------------------------------------------------------------------------------------------
set f_ingreso = new CFormulario
f_ingreso.Carga_Parametros "anula_ingreso_interno.xml", "ingreso"
f_ingreso.Inicializar conexion

	
if q_ting_ccod=15 or q_ting_ccod=33 then
	sql_having="and sum(case when (a.eing_ccod = 1) or (c.ting_ccod is not null and isnull(c.ding_bpacta_cuota, 'S') = 'S' and isnull(c.ding_ncorrelativo, 1) > 0) then a.ingr_mtotal - protic.total_rebajado_ingreso_nc(a.ingr_ncorr,a.mcaj_ncorr) else 0 end) > 0"	
else
	sql_having="and sum(case when (a.eing_ccod = 1) or (c.ting_ccod is not null and isnull(c.ding_bpacta_cuota, 'N') = 'N' and isnull(c.ding_ncorrelativo, 1) > 0) then a.ingr_mtotal - protic.total_rebajado_ingreso_nc(a.ingr_ncorr,a.mcaj_ncorr) else 0 end) > 0"
end if
	
		   
consulta = "select a.mcaj_ncorr,a.ting_ccod as c_ting_ccod, a.ingr_nfolio_referencia as c_ingr_nfolio_referencia," & vbCrLf &_
			"        a.ting_ccod, a.ingr_nfolio_referencia, a.mcaj_ncorr, cast(a.ingr_fpago as numeric) as ingr_fpago," & vbCrLf &_
			"        a.pers_ncorr, b.sede_ccod, protic.obtener_rut(a.pers_ncorr) as rut_alumno," & vbCrLf &_
			"        protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_alumno," & vbCrLf &_
			"        sum(a.ingr_mtotal) as total_ingreso," & vbCrLf &_
			"        sum(case when (a.eing_ccod = 1) or (c.ting_ccod is not null and isnull(c.ding_bpacta_cuota, 'N') = 'N' and isnull(c.ding_ncorrelativo, 1) > 0) then a.ingr_mtotal - protic.total_rebajado_ingreso_nc(a.ingr_ncorr,a.mcaj_ncorr) else 0 end) as anulable" & vbCrLf &_
			"    from ingresos a,movimientos_cajas b,detalle_ingresos c" & vbCrLf &_
			"    where a.mcaj_ncorr = b.mcaj_ncorr" & vbCrLf &_
			"        and a.ingr_ncorr *= c.ingr_ncorr" & vbCrLf &_
			"        and a.eing_ccod in (1, 4)" & vbCrLf &_
			"        and cast(a.ting_ccod  as varchar) = '" & q_ting_ccod & "'" & vbCrLf &_
			"        and cast(a.mcaj_ncorr  as varchar) = '" & q_mcaj_ncorr & "'" & vbCrLf &_
			"        and cast(a.ingr_nfolio_referencia as varchar) = '" & q_ingr_nfolio_referencia & "' " & vbCrLf &_
			" group by a.ting_ccod, a.ingr_nfolio_referencia, a.mcaj_ncorr, CAST(a.ingr_fpago as numeric), a.pers_ncorr, b.sede_ccod" & vbCrLf &_
			" having b.sede_ccod = '" & negocio.ObtenerSede & "' " & vbCrLf &_
			" "&sql_having
			
'response.Write("<pre>" & consulta & "</pre>")
'response.End()   
f_ingreso.Consultar consulta




'--------------------------------------------------------------------------------------------------
if f_ingreso.NroFilas = 0 then
	f_botonera.AgregaBotonParam "anular", "deshabilitado", "TRUE"
end if



set errores = new CErrores
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

function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if%>
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr>
                        <th width="6%">Folio : </th>
						<td width="16%"><%f_busqueda.DibujaCampo("ingr_nfolio_referencia")%></td>
                        <th width="7%">Tipo :</th>
						<td width="23%"><%f_busqueda.DibujaCampo("ting_ccod")%></td>
                        <th width="6%">Caja:</th>
						<td width="42%"><%f_busqueda.DibujaCampo("mcaj_ncorr")%></td>
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
                <%pagina.DibujarTituloPagina%>
                <br>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Ingreso"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"><%f_ingreso.DibujaTabla%></div></td>
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
            <td width="31%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("anular")%></div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton("salir")%>
                  </div></td>
                  </tr>
              </table>
            </div></td>
            <td width="69%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
