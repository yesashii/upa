<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_ding_ndocto = Request.QueryString("b[0][ding_ndocto]")
q_ting_ccod = Request.QueryString("b[0][ting_ccod]")


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Historial de Documentos"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "historial_documento.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "historial_documento.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "ding_ndocto", q_ding_ndocto
f_busqueda.AgregaCampoCons "ting_ccod", q_ting_ccod
'---------------------------------------------------------------------------------------------------
set f_cheques = new CFormulario
f_cheques.Carga_Parametros "historial_documento.xml", "cheques"
f_cheques.Inicializar conexion


		   
sql_historial=  " select distinct ingr_ncorr_origen,a.ding_ndocto_origen, " & vbCrLf &_
				" b.edin_tdesc+' - '+isnull(cast(g.sede_tdesc as varchar),case  " & vbCrLf &_
				"			when d.ingr_fpago < '03/12/2006' then (select sede_tdesc from sedes where sede_ccod=1) " & vbCrLf &_
				"			else f.sede_tdesc end) as estado_origen, " & vbCrLf &_
				" c.edin_tdesc+' - '+isnull(cast(g.sede_tdesc as varchar),case " & vbCrLf &_
				"			when d.ingr_fpago < '03/12/2006' then (select sede_tdesc from sedes where sede_ccod=1) " & vbCrLf &_
				"			else f.sede_tdesc end)  as estado_destino, " & vbCrLf &_
				" protic.trunc(a.ding_fdocto_origen) as fecha_origen,protic.trunc(a.ding_fdocto_destino) as fecha_destino, " & vbCrLf &_
				" a.ding_mdocto_origen,a.ding_mdocto_destino,d.mcaj_ncorr,(select top 1 pers_tnombre+' '+pers_tape_paterno as nombre from cajeros caj,MOVIMIENTOS_CAJAS mc, personas p" & vbCrLf &_
"where mcaj_ncorr in (d.mcaj_ncorr)" & vbCrLf &_
"and mc.caje_ccod =caj.caje_ccod" & vbCrLf &_
"and caj.pers_ncorr=p.pers_ncorr)as nombre_cajero,  " & vbCrLf &_
				" edin_ccod_origen,edin_ccod_destino,audi_tusuario_origen,audi_tusuario_destino,dist_ncorr, a.dist_fhistorial, protic.trunc(a.dist_fhistorial) as fecha_mod, " & vbCrLf &_
				" envi_ncorr_origen,envi_ncorr_destino " & vbCrLf &_
				" from detalle_ingresos_historial a, estados_detalle_ingresos b, estados_detalle_ingresos c, ingresos d, movimientos_cajas e, sedes f, sedes g " & vbCrLf &_
				" where a.ingr_ncorr_origen=d.ingr_ncorr " & vbCrLf &_
				" 	and d.mcaj_ncorr=e.mcaj_ncorr " & vbCrLf &_
				" 	and e.sede_ccod=f.sede_ccod " & vbCrLf &_
				" 	and a.sede_actual_destino*=g.sede_ccod " & vbCrLf &_
				" 	and a.edin_ccod_origen=b.edin_ccod " & vbCrLf &_
				" 	and a.edin_ccod_destino=c.edin_ccod " & vbCrLf &_
				" 	and ding_ncorrelativo_destino=1 " & vbCrLf &_
				" 	and cast(ding_ndocto_origen as varchar)='"&q_ding_ndocto&"' " & vbCrLf &_
				" 	and cast(ting_ccod_origen as varchar)='"&q_ting_ccod&"' " & vbCrLf &_
				" 	order by dist_ncorr asc, ingr_ncorr_origen desc"

'response.Write("<pre>"&consulta&"</pre>")
'response.End()
consulta="select '' "
f_cheques.Consultar sql_historial

if f_cheques.NroFilas = 0 then
	f_botonera.AgregaBotonParam "ok", "deshabilitado", "TRUE"
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
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
					<td width="25%"><strong>N° Documento :</strong></td>
                  	<td width="18%"><div align="center"><%f_busqueda.DibujaCampo("ding_ndocto")%></div></td>
					<td width="16%"><strong>Tipo Documento :</strong></td>
				  	<td width="31%"><div align="left"><%f_busqueda.DibujaCampo("ting_ccod")%></div>
                  	<td width="10%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td>
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
                    <td><%pagina.DibujarSubtitulo "Datos documento"%>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><div align="center"><%f_cheques.DibujaTabla%></div></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><p><br> </p>
                            </td>
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
                  <td><div align="center"><%f_botonera.DibujaBoton("ok")%></div></td>
                  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
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