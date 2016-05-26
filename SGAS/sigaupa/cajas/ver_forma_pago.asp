<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACI�N		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO: MODULO DE CAJAS
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:03/04/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:Corregir c�digo, eliminar sentencia *=
'LINEA			:51
'*******************************************************************
q_cont_ncorr = Request.QueryString("cont_ncorr")

Function SqlFormaPago(p_tcom_ccod)
'	SqlFormaPago = "select c.dcom_ncompromiso, f.ding_ndocto, isnull(f.ting_ccod,6) as ting_ccod, f.banc_ccod, f.plaz_ccod, b.comp_fdocto, isnull(f.ding_fdocto, c.dcom_fcompromiso) as ding_fdocto, c.dcom_mcompromiso " & vbCrLf &_
'	               "from contratos a, compromisos b, detalle_compromisos c, abonos d, ingresos e, detalle_ingresos f " & vbCrLf &_
'				   "where a.cont_ncorr = b.comp_ndocto " & vbCrLf &_
'				   "  and b.tcom_ccod = c.tcom_ccod " & vbCrLf &_
'				   "  and b.inst_ccod = c.inst_ccod " & vbCrLf &_
'				   "  and b.comp_ndocto = c.comp_ndocto " & vbCrLf &_
'				   "  and c.tcom_ccod = d.tcom_ccod " & vbCrLf &_
'				   "  and c.inst_ccod = d.inst_ccod " & vbCrLf &_
'				   "  and c.comp_ndocto = d.comp_ndocto " & vbCrLf &_
'				   "  and c.dcom_ncompromiso = d.dcom_ncompromiso " & vbCrLf &_
'				   "  and d.ingr_ncorr = e.ingr_ncorr " & vbCrLf &_
'				   "  and e.ingr_ncorr *= f.ingr_ncorr  " & vbCrLf &_
'				   "  and e.ting_ccod = 7 " & vbCrLf &_
'				   "  and b.tcom_ccod = '" & p_tcom_ccod & "' " & vbCrLf &_
'				   "  and a.cont_ncorr = '" & q_cont_ncorr & "'" & vbCrLf &_
'				   "order by c.dcom_fcompromiso asc"

	SqlFormaPago = "select c.dcom_ncompromiso, f.ding_ndocto, isnull(f.ting_ccod,6) as ting_ccod, f.banc_ccod, f.plaz_ccod, b.comp_fdocto, isnull(f.ding_fdocto, c.dcom_fcompromiso) as ding_fdocto, c.dcom_mcompromiso " & vbCrLf &_
	               "from contratos a " & vbCrLf &_
	               "INNER JOIN compromisos b " & vbCrLf &_
	               "ON a.cont_ncorr = b.comp_ndocto and b.tcom_ccod = '" & p_tcom_ccod & "' and a.cont_ncorr = '" & q_cont_ncorr & "' " & vbCrLf &_
	               "INNER JOIN  detalle_compromisos c " & vbCrLf &_
	               "ON b.tcom_ccod = c.tcom_ccod and b.inst_ccod = c.inst_ccod and b.comp_ndocto = c.comp_ndocto " & vbCrLf &_
	               "INNER JOIN abonos d " & vbCrLf &_
	               "ON c.tcom_ccod = d.tcom_ccod and c.inst_ccod = d.inst_ccod and c.comp_ndocto = d.comp_ndocto and c.dcom_ncompromiso = d.dcom_ncompromiso " & vbCrLf &_
	               "INNER JOIN ingresos e " & vbCrLf &_
	               "ON d.ingr_ncorr = e.ingr_ncorr and e.ting_ccod = 7 " & vbCrLf &_
	               "LEFT OUTER JOIN detalle_ingresos f " & vbCrLf &_
	               "ON e.ingr_ncorr = f.ingr_ncorr " & vbCrLf &_
				   "order by c.dcom_fcompromiso asc"
			   
End Function



'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Forma de Pago"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "ver_forma_pago.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_contrato = new CFormulario
f_contrato.Carga_Parametros "ver_forma_pago.xml", "contrato"
f_contrato.Inicializar conexion

consulta = "select a.cont_ncorr, a.econ_ccod, a.cont_fcontrato, protic.total_contrato(a.cont_ncorr) as total_contrato " & vbCrLf &_
           "from contratos a " & vbCrLf &_
		   "where a.cont_ncorr = '" & q_cont_ncorr & "'"

f_contrato.Consultar consulta

'---------------------------------------------------------------------------------------------------
set f_detalle_pagos_matricula = new CFormulario
f_detalle_pagos_matricula.Carga_Parametros "ver_forma_pago.xml", "detalle_pagos"
f_detalle_pagos_matricula.Inicializar conexion
consulta = SqlFormaPago("1")
f_detalle_pagos_matricula.Consultar consulta

set f_detalle_pagos_colegiatura = new CFormulario
f_detalle_pagos_colegiatura.Carga_Parametros "ver_forma_pago.xml", "detalle_pagos"
f_detalle_pagos_colegiatura.Inicializar conexion
consulta = SqlFormaPago("2")
f_detalle_pagos_colegiatura.Consultar consulta

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
              <br>
              <table width="96%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_contrato.DibujaRegistro%></div></td>
                </tr>
              </table>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Forma de Pago Matr�cula"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"><%f_detalle_pagos_matricula.DibujaTabla%></div></td>
                        </tr>
                      </table>
                      <br>                      <br>
                      <%pagina.DibujarSubtitulo "Forma de Pago Arancel de Colegiatura"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center">
                            <%f_detalle_pagos_colegiatura.DibujaTabla%>
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
                  <td><div align="center"><%f_botonera.DibujaBoton("cerrar")%></div></td>
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
