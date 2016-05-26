<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_nfolio = Request.QueryString("nfolio")
q_ting_ccod = Request.QueryString("ting_ccod")


set errores = new CErrores

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Detalle Acuse de Recibo"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "detalle_acuse.xml", "botonera"

v_reimpreso=conexion.consultaUno("Select count(*) from documentos_acuse_recibo where ingr_nfolio_referencia="&q_nfolio&" and tipo_comprobante="&q_ting_ccod&" ")
v_pers_ncorr=conexion.consultaUno("Select top 1 pers_ncorr from ingresos where ingr_nfolio_referencia="&q_nfolio&" and ting_ccod="&q_ting_ccod&" ")

'response.Write("reimpreso :"&v_reimpreso)
'---------------------------------------------------------------------------------------------------
set f_contrato = new CFormulario
f_contrato.Carga_Parametros "detalle_acuse.xml", "detalle_pagos"
f_contrato.Inicializar conexion

	consulta	 =  "Select dc.tcom_ccod,dc.comp_ndocto,dc.inst_ccod,dc.dcom_ncompromiso,dc.dcom_fcompromiso, "& vbCrLf &_
					" cast(protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ding_ndocto') as varchar) as numero_docto,    "& vbCrLf &_
					" cast(protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ding_ndocto') as varchar) as ding_ndocto,    "& vbCrLf &_
					" cast(protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'monto') as varchar) as monto_documento,  "& vbCrLf &_					
					" cast(protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ting_ccod') as varchar) as ting_ccod,  "& vbCrLf &_					
					" convert(varchar,dc.DCOM_FCOMPROMISO,103) fecha_vencimiento,ii.ingr_nfolio_referencia,ii.ting_ccod as tipo_comprobante,    "& vbCrLf &_
					"  tc.tcom_tdesc as tipo_compromiso,SUM(ab.ABON_MABONO) monto_abono,upper(ti.ting_tdesc) as tipo_ingreso    "& vbCrLf &_
					"	 from ingresos ii,abonos ab,compromisos cp,detalle_compromisos dc, "& vbCrLf &_
					"		  tipos_compromisos tc,tipos_ingresos ti    "& vbCrLf &_
					"	 where ii.ingr_ncorr = ab.ingr_ncorr    "& vbCrLf &_
					"		 and ii.ingr_nfolio_referencia = "&q_nfolio&"  "& vbCrLf &_
					"		 and ii.ting_ccod = "&q_ting_ccod&"  "& vbCrLf &_
					"		 and ab.tcom_ccod = dc.tcom_ccod    "& vbCrLf &_
					"		 and ab.inst_ccod = dc.inst_ccod    "& vbCrLf &_
					"		 and ab.comp_ndocto = dc.comp_ndocto     "& vbCrLf &_
					"		 and ab.dcom_ncompromiso = dc.dcom_ncompromiso    "& vbCrLf &_
					"		 and dc.tcom_ccod = tc.tcom_ccod    "& vbCrLf &_
					"		 and dc.comp_ndocto=cp.comp_ndocto    "& vbCrLf &_
					"		 and dc.tcom_ccod=cp.tcom_ccod "& vbCrLf &_
					"		 and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ting_ccod') = ti.ting_ccod "& vbCrLf &_
					"		 and ti.ting_ccod in (3,4,38,88)  "& vbCrLf &_  
					"  GROUP BY  ii.ingr_nfolio_referencia,ii.ting_ccod,dc.tcom_ccod,dc.comp_ndocto,dc.inst_ccod,dc.dcom_ncompromiso,dc.dcom_fcompromiso,tc.tcom_tdesc,ti.ting_tdesc "
'response.Write("<pre>"&consulta&"</pre>")
f_contrato.Consultar consulta


'---------------------------------------------------------------------------------------------------
set f_datos_alumnos = new CFormulario
f_datos_alumnos.Carga_Parametros "detalle_boletas.xml", "datos_alumno"
f_datos_alumnos.Inicializar conexion


consulta= "Select protic.obtener_rut(c.pers_ncorr) as rut_alumno,  "& vbCrLf &_
		" protic.obtener_nombre_completo(c.pers_ncorr,'n') as nombre_alumno,  "& vbCrLf &_
		" b.peri_ccod,protic.obtener_nombre_carrera(b.ofer_ncorr,'CJ') as carrera  "& vbCrLf &_
		" from personas_postulante c  "& vbCrLf &_
		"    left outer join alumnos a "& vbCrLf &_
		"        on  c.pers_ncorr=a.pers_ncorr  "& vbCrLf &_
		"    left outer join  ofertas_academicas b  "& vbCrLf &_
		"        on a.ofer_ncorr=b.ofer_ncorr "& vbCrLf &_
		"        and a.emat_ccod=1 "& vbCrLf &_
		" where cast(c.pers_ncorr as varchar)='"&v_pers_ncorr&"' "& vbCrLf &_
		" order by b.peri_ccod desc  "

f_datos_alumnos.Consultar consulta
f_datos_alumnos.siguiente


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
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
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
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Forma de Pago"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%>
              <br>
                         <table width="96%"  border="0" cellspacing="0" cellpadding="0">
							 <tr>
							 	<th width="16%" align="left">Carrera : </th>
								<td width="84%" ><%f_datos_alumnos.DibujaCampo("carrera")%></td>
							 </tr>
							 <tr>
							 	<th align="left">Rut Alumno :</th>
								<td><%f_datos_alumnos.DibujaCampo("rut_alumno")%></td>
							 </tr>

						 </table>
              <br>
				<% if v_reimpreso>"1" then%>
				<font color="#0033FF"> Acuse de recibo ya fue impreso</font>
				<% end if%>
			  </div>
            <form name="edicion" action="proc_guardar_documentos_entregados.asp" method="post" >
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Detalle Documentos Pagados"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"><%f_contrato.DibujaTabla%></div></td>
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
            <td width="15%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("cerrar")%></div></td>
				  <td><% 
						if v_reimpreso>"1" then
						f_botonera.AgregaBotonParam "imprimir", "url", "imprimir_acuse_recibo.asp?nfolio="&q_nfolio&"&ting_ccod="&q_ting_ccod&" "
						end if
						f_botonera.DibujaBoton("imprimir")
					 %></td>
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
	<br>	</td>
  </tr>  
</table>
</body>
</html>
