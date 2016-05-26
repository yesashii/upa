<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
set botonera = new CFormulario
botonera.Carga_Parametros "edicion_envios_cobranza.xml", "btn_edicion_envios_cobranza"

'---------------------------------------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")

'---------------------------------------------------------------------------------------------------
'-----------------------------------------------------------------------
pagina.Titulo = "Detalles de Envíos a Cobranza"

'-----------------------------------------------------------------------
folio_envio = request.QueryString("folio_envio")
empresa_envio = request.QueryString("empresa_envio")
tipo_empresa = request.QueryString("tipo_empresa")
tipo_envio = request.QueryString("tipo_envio")
fecha_get = request.QueryString("fecha")
'---------------------------- OBTEBER EL ESTADO DEL FOLIO ----------------
cc_enviado="SELECT envios.eenv_ccod "&_
                "FROM envios, instituciones_envio "&_
                "WHERE envios.inen_ccod = instituciones_envio.inen_ccod "&_
                "AND cast(envios.envi_ncorr as varchar)='" & folio_envio &"'"
estado_envio = conexion.consultaUno(cc_enviado)
'---------------------------PARA SABER SI HAY O NO DOC ASOCIADOS AL FOLIO -------
cc_cantidad="SELECT count (*) as cantidad FROM detalle_envios  WHERE cast(envi_ncorr as varchar)='" & folio_envio&"'"
cantidad_doc = conexion.consultaUno(cc_cantidad)
'------------------------------------------------------------------------------
set f_listado = new CFormulario
f_listado.Carga_Parametros "edicion_envios_cobranza.xml", "f_listado"
f_listado.Inicializar conexion



consulta = "select a.envi_ncorr, c.ting_ccod, d.ting_tdesc, c.ding_ndocto as c_ding_ndocto, c.ingr_ncorr, c.ding_ndocto, c.ding_mdocto,  "& vbCrLf &_
           "       protic.trunc(e.ingr_fpago) as fecha_envio, protic.tiene_multa_protesto(c.ting_ccod, c.ding_ndocto, c.ingr_ncorr) as multa_protesto, "& vbCrLf &_
		   "	   protic.trunc(c.ding_fdocto) as ding_fdocto, c.ding_tcuenta_corriente, f.edin_tdesc, "& vbCrLf &_
		   "	   protic.obtener_nombre_completo(isnull(c.pers_ncorr_codeudor, protic.ultimo_aval(e.pers_ncorr)),'N') as nombre_apoderado, "& vbCrLf &_
		   "	   protic.obtener_rut(e.pers_ncorr) as rut_alumno, "& vbCrLf &_
		   "	   protic.obtener_rut(isnull(c.pers_ncorr_codeudor, protic.ultimo_aval(e.pers_ncorr))) as rut_apoderado "& vbCrLf &_
		   "from envios a, detalle_envios b, detalle_ingresos c, tipos_ingresos d, ingresos e, estados_detalle_ingresos f "& vbCrLf &_
		   "where a.envi_ncorr = b.envi_ncorr "& vbCrLf &_
		   "  and b.ting_ccod = c.ting_ccod "& vbCrLf &_
		   "  and b.ingr_ncorr = c.ingr_ncorr "& vbCrLf &_
		   "  and b.ding_ndocto = c.ding_ndocto "& vbCrLf &_
		   "  and c.ting_ccod = d.ting_ccod "& vbCrLf &_
		   "  and c.ingr_ncorr = e.ingr_ncorr "& vbCrLf &_
		   "  and c.edin_ccod = f.edin_ccod "& vbCrLf &_
		   "  and cast(a.envi_ncorr as varchar)= '" & folio_envio & "'"& vbCrLf &_
		   " Order by c.ding_ndocto asc,c.ting_ccod asc"

'response.Write("<pre>" & consulta & "</pre>")
'response.Flush()
'response.End()
f_listado.Consultar consulta




botonera.AgregaBotonUrlParam "anterior", "busqueda[0][envi_ncorr]", folio_envio
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

function eliminar(){
}

function agregar(){
}

</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>
  <tr>
    <td align="center" valign="top" bgcolor="#EAEAEA"> <br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><%pagina.dibujarLenguetas array (array("Detalle de Documentos","Envios_Cobranza_Agregar1.asp")),1 %>
                </td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				     <div align="center">&nbsp; <br>
                    <%pagina.DibujarTituloPagina%>
                    <br>
                    <br>
                  </div>
                    <table width="100%" border="0">
                      <tr>
                        <td>N&ordm; Folio</td>
                        <td>:</td>

                      <td width="18%"><%=folio_envio%></td>
                        <td width="4%">Tipo</td>
                        <td width="2%">:</td>

                      <td width="24%"><%=tipo_envio%></td>
                        <td width="6%">Fecha</td>
                        <td width="2%">:</td>

                      <td><%=fecha_get%></td>
                      </tr>
                      <tr>
                        <td width="20%">Empresa de Cobranza</td>
                        <td width="1%">:</td>

                      <td colspan="2"><%=empresa_envio%></td>

                      <td colspan="2">&nbsp; </td>
                        <td colspan="2">&nbsp;</td>
                        <td width="23%">&nbsp;</td>
                      </tr>
                    </table>

                  <br>
                  <table width="665" border="0">
                    <tr>
                      <td width="116">&nbsp;</td>
                      <td width="511"><div align="right">P&aacute;ginas: &nbsp;
                          <%f_listado.AccesoPagina%>
                        </div></td>
                      <td width="24"> <div align="right"> </div></td>
                    </tr>
                  </table>
                  <form name="edicion">
                    <div align="center">
                      <%f_listado.dibujatabla%>
                    </div>
                  </form>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="431" bgcolor="#D8D8DE"><table width="97%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="13%" align="center"> <% botonera.DibujaBoton "anterior"%> </td>
                      <td width="27%" align="center">
					  <% if estado_envio <> "2" then
					    botonera.agregabotonparam "agregar_letras", "url" ,"Envios_Cobranza_Buscar.asp?folio_envio="& folio_envio &"&tipo_empresa="& tipo_empresa
					    botonera.DibujaBoton "agregar_letras"
						end if	  %> </td>
                      <td width="22%" align="center"> <%if (estado_envio <> "2" and cantidad_doc>0) then
					                       botonera.agregabotonparam "eliminar", "url", "Proc_Cobranza_Eliminar_Doc.asp"
						                   botonera.dibujaboton "eliminar"
										end if %> </td>
                      <td width="19%" align="center">
                        <% if cantidad_doc>0 then
          botonera.AgregaBotonParam "excel","url","envios_cobranza_excel.asp?folio_envio=" & folio_envio &"&empresa_envio=" & empresa_envio &"&fecha=" &fecha_get
          botonera.DibujaBoton "excel"
		  end if  %>
                      </td>
                      <td width="19%" align="center">
                        <% if cantidad_doc>0 then
          'botonera.AgregaBotonParam "pdf","url","../REPORTESNET/envios_cobranza.aspx?periodo="&Periodo&"&folio_envio=" & folio_envio &"&empresa=" & empresa_envio &"&fecha=" &fecha_get
          'botonera.DibujaBoton "pdf"
		  end if  %>
                      </td>
                    </tr>
                  </table>
                </td>
                  <td width="12" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="234" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<BR>
		  </td>
        </tr>
      </table>
   </td>
  </tr>
</table>
</body>
</html>
