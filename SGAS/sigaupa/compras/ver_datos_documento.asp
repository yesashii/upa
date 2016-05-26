<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Datos Cheque"

set botonera = new CFormulario
botonera.carga_parametros "entrega_cheques.xml", "botonera"


v_solicitud	= request.querystring("solicitud")
v_tsol_ccod	= request.querystring("tsol_ccod")


set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new cnegocio
negocio.Inicializa conectar

v_usuario=negocio.ObtenerUsuario()


 set f_doctos = new CFormulario
 f_doctos.Carga_Parametros "entrega_cheques.xml", "cheques"
 f_doctos.Inicializar conectar

select case v_tsol_ccod
	Case 1:
		sql_doctos = "select protic.obtener_rut(b.pers_ncorr) as rut, protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre, "&_
					" sogi_mgiro as valor, protic.trunc(ocag_fingreso) as fecha_solicitud,sogi_tobs_rechazo as obs_rechazo "&_
					" ,protic.trunc(a.audi_fmodificacion) as fecha_cambio "&_
					" from ocag_solicitud_giro a, personas b "&_
					" where a.pers_ncorr_proveedor=b.pers_ncorr "&_
					" and sogi_ncorr="&v_solicitud
	Case 2:
		sql_doctos = "select protic.obtener_rut(b.pers_ncorr) as rut, protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre, "&_
					" rgas_mgiro as valor, protic.trunc(ocag_fingreso) as fecha_solicitud,rgas_tobs_rechazo as obs_rechazo "&_
					" ,protic.trunc(a.audi_fmodificacion) as fecha_cambio "&_
					" from ocag_reembolso_gastos a, personas b "&_
					" where a.pers_ncorr_proveedor=b.pers_ncorr "&_
					" and rgas_ncorr="&v_solicitud
	
	Case 3:
		sql_doctos = "select protic.obtener_rut(b.pers_ncorr) as rut, protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre, "&_
					" fren_mmonto as valor, protic.trunc(ocag_fingreso) as fecha_solicitud,fren_tobs_rechazo as obs_rechazo "&_
					" ,protic.trunc(a.audi_fmodificacion) as fecha_cambio "&_
					" from ocag_fondos_a_rendir a, personas b "&_
					" where a.pers_ncorr=b.pers_ncorr "&_
					" and fren_ncorr="&v_solicitud
	Case 4:
		sql_doctos = "select protic.obtener_rut(b.pers_ncorr) as rut, protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre, "&_
					" sovi_mmonto_pesos as valor, protic.trunc(ocag_fingreso) as fecha_solicitud,sovi_tobs_rechazo as obs_rechazo "&_
					" ,protic.trunc(a.audi_fmodificacion) as fecha_cambio "&_
					" from ocag_solicitud_viatico a, personas b "&_
					" where a.pers_ncorr=b.pers_ncorr "&_
					" and sovi_ncorr="&v_solicitud
	Case 5:
		sql_doctos = "select protic.obtener_rut(b.pers_ncorr) as rut, protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre, "&_
					" dalu_mmonto_pesos as valor, protic.trunc(ocag_fingreso) as fecha_solicitud,dalu_tmotivo as obs_rechazo "&_
					" ,protic.trunc(a.audi_fmodificacion) as fecha_cambio "&_
					" from ocag_devolucion_alumno a, personas b "&_
					" where a.pers_ncorr=b.pers_ncorr "&_
					" and dalu_ncorr="&v_solicitud
	Case 6:
		sql_doctos = "select protic.obtener_rut(b.pers_ncorr) as rut, protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre, "&_
					" ffij_mmonto_pesos as valor, protic.trunc(ocag_fingreso) as fecha_solicitud,ffij_tobs_rechazo as obs_rechazo "&_
					" ,protic.trunc(a.audi_fmodificacion) as fecha_cambio "&_
					" from ocag_fondo_fijo a, personas b "&_
					" where a.pers_ncorr=b.pers_ncorr "&_
					" and ffij_ncorr="&v_solicitud
	Case 7:
		sql_doctos ="select ocag_generador as rut, protic.obtener_nombre_completo(protic.obtener_pers_ncorr2(a.pers_nrut), 'n') as nombre, " &_
					"rfre_mmonto as valor, protic.trunc(ocag_fingreso) as fecha_solicitud,'' as obs_rechazo " &_
					",protic.trunc(a.audi_fmodificacion) as fecha_cambio " &_
					"from ocag_rendicion_fondos_a_rendir a, personas b " &_
					"where a.pers_nrut=b.pers_nrut " &_
					"and rfre_ncorr="&v_solicitud	
		
	Case 8:
		sql_doctos ="select ocag_generador as rut, protic.obtener_nombre_completo(protic.obtener_pers_ncorr2(a.pers_nrut), 'n') as nombre, " &_
					"rffi_mmonto as valor, protic.trunc(ocag_fingreso) as fecha_solicitud,'' as obs_rechazo "&_
					",protic.trunc(a.audi_fmodificacion) as fecha_cambio "&_
					"from ocag_rendicion_fondo_fijo a, personas b "&_
					"where a.pers_nrut=b.pers_nrut "&_
					"and rffi_ncorr="&v_solicitud							
	Case 9:
		sql_doctos = "select protic.obtener_rut(b.pers_ncorr) as rut, protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre, "&_
					" ordc_mmonto as valor, protic.trunc(fecha_solicitud) as fecha_solicitud,ordc_tobservacion as obs_rechazo "&_
					" ,protic.trunc(a.audi_fmodificacion) as fecha_cambio "&_
					" from ocag_orden_compra a, personas b "&_
					" where a.pers_ncorr=b.pers_ncorr "&_
					" and ordc_ncorr="&v_solicitud
end select
 
'RESPONSE.WRITE("1. sql_doctos"&sql_doctos&"<BR>")

'response.Write("<pre>"&sql_cheques&"</pre>")
'response.End()

f_doctos.Consultar sql_doctos
 
 
 if v_tsol_ccod = "7" or v_tsol_ccod = "8" then
set f_boletas = new CFormulario
f_boletas.Carga_Parametros "tabla_vacia.xml", "tabla"
f_boletas.Inicializar conectar


select case v_tsol_ccod
	'cambiar no es el 7
	case 7: sql_boletas = "select * from ("&_
						  "select rfre_ncorr,BOLE_NBOLETA as n_documento, BOLE_MTOTAL as total_documento,'BOLETA' as documento "&_
						  "	from boletas b, ocag_detalle_rendicion_fondo_rendir fj "&_
						  "	where fj.drfr_ndocto = ingr_nfolio_referencia "&_
						  "	and protic.obtener_pers_ncorr2(fj.audi_tusuario) = b.pers_ncorr "&_
						  "	union "&_
						  "	select rfre_ncorr,fact_nfactura as n_documento, fact_mtotal as total_documento,'FACTURA' as documento "&_
						  "	from facturas f, ocag_detalle_rendicion_fondo_rendir fr "&_
						  "	where fr.drfr_ndocto = ingr_nfolio_referencia "&_
						  "	and (protic.obtener_pers_ncorr2(fr.audi_tusuario) = f.pers_ncorr_alumno or protic.obtener_pers_ncorr2(fr.audi_tusuario) = f.empr_ncorr )"&_
						  ") as tabla "&_
						  " where tabla.rfre_ncorr ="&v_solicitud
	
	case 8: sql_boletas = "select * from ("&_
						  "select BOLE_NBOLETA as n_documento, BOLE_MTOTAL as total_documento,'BOLETA' as documento "&_
						  "	from boletas b, ocag_rendicion_fondo_fijo fj "&_
						  "	where fj.rffi_ndocto = ingr_nfolio_referencia "&_
						  "	and protic.obtener_pers_ncorr2(ocag_generador) = b.pers_ncorr "&_
						  "	union "&_
						  "	select fact_nfactura as n_documento, fact_mtotal as total_documento,'FACTURA' as documento "&_
						  "	from facturas f, ocag_rendicion_fondo_fijo fr "&_
						  "	where fr.rffi_ndocto = ingr_nfolio_referencia "&_
						  "	and (protic.obtener_pers_ncorr2(ocag_generador) = f.pers_ncorr_alumno or protic.obtener_pers_ncorr2(ocag_generador) = f.empr_ncorr )"&_
						  ")as tabla "&_
						  "where rff.rffi_ncorr ="&v_solicitud

end select

'RESPONSE.WRITE("2. sql_boletas"&sql_boletas&"<BR>")

'response.Write(sql_boletas)
f_boletas.Consultar sql_boletas
nfila = f_boletas.NroFilas

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

function Enviar(){
	return true;
}

</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
<tr>
  <td valign="top" bgcolor="#EAEAEA"><table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
      <td><table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td valign="top" bgcolor="#EAEAEA"><br>
            <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
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
                    <td background="../imagenes/top_r1_c2.gif"></td>
                    <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
                  </tr>
                  <tr>
                    <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                    <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                        <td width="209" valign="middle" background="../imagenes/fondo1.gif"><div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Datos Solicitud</font></div></td>
                        <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                      </tr>
                    </table></td>
                    <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
                  </tr>
                  <tr>
                    <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                    <td background="../imagenes/top_r3_c2.gif"></td>
                    <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
                  </tr>
                </table>
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                      <td bgcolor="#D8D8DE"><br>
                        <div align="center"><font size="+1">
                          <%pagina.DibujarTituloPagina()%>
                        </font></div>
                        <table width="100%" align="center" cellpadding="0" cellspacing="0">
                          <tr>
                            <td><br/>
                              <strong><font color="000000" size="1"> </font></strong>
                              <form name="datos" method="post">
                                <table width="98%"  border="0" align="center">
                                  <tr bgcolor='#C4D7FF'>
                                    <th width="11%">Rut Beneficiario </th>
                                    <th width="27%">Nombre</th>
                                    <th width="9%">Valor</th>
                                    <th width="29%">Motivo observación</th>
                                    <th width="13%">Fecha ultimo estado</th>
                                    <th width="11%">Fecha solicitud</th>
                                  </tr>
                                  <%
								  ind=0
								  v_total=0
								  while f_doctos.Siguiente 
								  %>
                                  <tr bgcolor='#FFFFFF'>
                                    <td><div align="right"><%=f_doctos.obtenerValor("rut")%></div></td>
                                    <td><div align="right"><%=f_doctos.obtenerValor("nombre")%></div></td>
                                    <td><div align="right"><%=f_doctos.obtenerValor("valor")%></div></td>
                                    <td><div align="center"><%=f_doctos.obtenerValor("obs_rechazo")%></div></td>
                                    <td><div align="right"><%=f_doctos.obtenerValor("fecha_cambio")%></div></td>
                                    <td><div align="center"><%=f_doctos.obtenerValor("fecha_solicitud")%></div></td>
                                  </tr>
                                  <%
								  ind=ind+1
								  wend%>
                                </table>
                                <br>
                                <br>
                                <% if v_tsol_ccod = "7" or v_tsol_ccod = "8" then%>
                                <%if nfila <> "0" then%>
                                <table width="50%"  border="0" align="center">
                                  <tr bgcolor='#C4D7FF'>
                                    <td><strong>Tipo Documento</strong></td>
                                    <td><strong>N° Documento</strong></td>
                                    <td><strong>Total Documento</strong></td>
                                  </tr>
                                  <tr bgcolor='#FFFFFF'>
                                    <td><%=f_boletas.obtenerValor("documento")%></td>
                                    <td><%=f_boletas.obtenerValor("n_documento")%></td>
                                    <td><%=f_boletas.obtenerValor("total_documento")%></td>
                                  </tr>
                                </table>
                                <%end if%>
                                <%end if%>
                              </form></td>
                          </tr>
                        </table>
                        <br/></td>
                      <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                    </tr>
                  </table>
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                      <td width="241" bgcolor="#D8D8DE"><table width="49%" height="19"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="30%"></td>
                          <td width="30%"><%botonera.dibujaboton "cerrar"%></td>
                        </tr>
                      </table></td>
                      <td width="121" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                      <td width="317" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                    </tr>
                    <tr>
                      <td height="8" valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                    </tr>
                  </table>
                  <p><br>
                  </td>
              </tr>
            </table></td>
        </tr>
      </table>        <p></td>
      </tr>
  </table></td>
</tr>
</table>
</body>
</html>
