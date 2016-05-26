<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO:
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:20/03/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			:104
'*******************************************************************
set pagina = new CPagina
pagina.Titulo = "Rendición de Cajas"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "rendicion_cajas.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede



v_mcaj_ncorr = request.QueryString("mcaj_ncorr")
v_ting_ccod = request.QueryString("ting_ccod")
nombre_cajero=conexion.consultaUno("Select protic.obtener_nombre_completo(b.pers_ncorr,'n') from movimientos_cajas a, cajeros b where a.caje_ccod=b.caje_ccod and a.mcaj_ncorr='"&v_mcaj_ncorr&"'")
'---------------------------------------------------------------------------------------------------
set f_movimiento_caja = new CFormulario
f_movimiento_caja.Carga_Parametros "rendicion_cajas.xml", "movimiento_caja"
f_movimiento_caja.Inicializar conexion

   
consulta = "select protic.obtener_rut(b.pers_ncorr) as rut," & vbCrLf &_
			"        protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre_completo," & vbCrLf &_
			"        a.mcaj_ncorr, a.mcaj_ncorr as c_mcaj_ncorr," & vbCrLf &_
			"        a.mcaj_finicio, getdate() as fecha_emision, a.mcaj_mrendicion " & vbCrLf &_
			"from movimientos_cajas a, cajeros b " & vbCrLf &_
			"where a.sede_ccod = b.sede_ccod " & vbCrLf &_
			"  and a.caje_ccod = b.caje_ccod " & vbCrLf &_
			"  and a.mcaj_ncorr = '" & v_mcaj_ncorr & "'"

f_movimiento_caja.Consultar consulta


'-------------------------------------------------------------------------------------------


set f_documentos_caja = new CFormulario
f_documentos_caja.Carga_Parametros "rendicion_cajas.xml", "cheques_pagados"
f_documentos_caja.Inicializar conexion

		   
'consulta= "Select ii.ingr_nfolio_referencia, protic.obtener_nombre_completo((select pers_ncorr_codeudor from detalle_ingresos where ingr_ncorr=protic.documento_asociado_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso, 'ingr_ncorr')),'a') as deudor," & vbCrLf &_
'			 "   protic.obtener_rut(ii.pers_ncorr) as rut_alumno, " & vbCrLf &_
'			 "   protic.obtener_rut((select pers_ncorr_codeudor from detalle_ingresos where ingr_ncorr=protic.documento_asociado_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso, 'ingr_ncorr')) ) as rut_apoderado, " & vbCrLf &_
'			 "   isnull(cast(protic.documento_asociado_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso, 'ding_ndocto') as varchar),'') as numero_docto,   " & vbCrLf &_
'			 "   (select banc_ccod from detalle_ingresos where ingr_ncorr=protic.documento_asociado_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso, 'ingr_ncorr')) as banco, "& vbCrLf &_
'			 "   protic.trunc((select ding_fdocto from detalle_ingresos where ingr_ncorr=protic.documento_asociado_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso, 'ingr_ncorr'))) as fecha_vencimiento, " & vbCrLf &_
'			 "   (select ding_mdocto from detalle_ingresos where ingr_ncorr=protic.documento_asociado_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso, 'ingr_ncorr')) as monto_docto, " & vbCrLf &_
'			 "   SUM(ab.ABON_MABONO) monto_abonado,    " & vbCrLf &_
'			 "	 protic.total_recepcionar_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso)  as saldo_docto," & vbCrLf &_
'			 "   (select ting_tdesc from tipos_ingresos where ting_ccod=isnull(b.ting_ccod,6)) as pagado_con    " & vbCrLf &_
'				"	     from ingresos ii,abonos ab,tipos_ingresos ti, detalle_ingresos b    " & vbCrLf &_
'				"	     where ii.ingr_ncorr = ab.ingr_ncorr    " & vbCrLf &_
'				"	         and ii.ingr_ncorr in (select distinct ingr_ncorr from ingresos where cast(mcaj_ncorr as varchar)='" & v_mcaj_ncorr & "')    " & vbCrLf &_
'				"	         and ii.ting_ccod in (9,34) " & vbCrLf &_
'				"            and ii.ingr_ncorr*=b.ingr_ncorr    " & vbCrLf &_
'				"	         and protic.documento_asociado_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso, 'ting_ccod') = ti.ting_ccod    " & vbCrLf &_
'				"			 and ti.ting_ccod in (3,38,88) "& vbCrLf &_
'				"	  GROUP BY  b.pers_ncorr_codeudor,ii.pers_ncorr,b.ting_ccod,ii.ingr_nfolio_referencia, ab.inst_ccod,ab.tcom_ccod, ab.comp_ndocto, ab.dcom_ncompromiso,ti.ting_tdesc "& vbCrLf &_
'			" order by deudor, numero_docto " 

consulta= "Select ii.ingr_nfolio_referencia, protic.obtener_nombre_completo((select pers_ncorr_codeudor from detalle_ingresos where ingr_ncorr=protic.documento_asociado_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso, 'ingr_ncorr')),'a') as deudor," & vbCrLf &_
			 "   protic.obtener_rut(ii.pers_ncorr) as rut_alumno, " & vbCrLf &_
			 "   protic.obtener_rut((select pers_ncorr_codeudor from detalle_ingresos where ingr_ncorr=protic.documento_asociado_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso, 'ingr_ncorr')) ) as rut_apoderado, " & vbCrLf &_
			 "   isnull(cast(protic.documento_asociado_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso, 'ding_ndocto') as varchar),'') as numero_docto,   " & vbCrLf &_
			 "   (select banc_ccod from detalle_ingresos where ingr_ncorr=protic.documento_asociado_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso, 'ingr_ncorr')) as banco, "& vbCrLf &_
			 "   protic.trunc((select ding_fdocto from detalle_ingresos where ingr_ncorr=protic.documento_asociado_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso, 'ingr_ncorr'))) as fecha_vencimiento, " & vbCrLf &_
			 "   (select ding_mdocto from detalle_ingresos where ingr_ncorr=protic.documento_asociado_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso, 'ingr_ncorr')) as monto_docto, " & vbCrLf &_
			 "   SUM(ab.ABON_MABONO) monto_abonado,    " & vbCrLf &_
			 "	 protic.total_recepcionar_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso)  as saldo_docto," & vbCrLf &_
			 "   (select ting_tdesc from tipos_ingresos where ting_ccod=isnull(b.ting_ccod,6)) as pagado_con    " & vbCrLf &_
				"	     from ingresos ii " & vbCrLf &_
				"    INNER JOIN abonos ab " & vbCrLf &_
				"    ON ii.ingr_ncorr = ab.ingr_ncorr " & vbCrLf &_
				"    and ii.ingr_ncorr in (select distinct ingr_ncorr from ingresos where cast(mcaj_ncorr as varchar) = '" & v_mcaj_ncorr & "') " & vbCrLf &_
				"    and ii.ting_ccod in (9,34) " & vbCrLf &_
				"    LEFT OUTER JOIN detalle_ingresos b " & vbCrLf &_
				"    ON ii.ingr_ncorr = b.ingr_ncorr " & vbCrLf &_
				"    INNER JOIN tipos_ingresos ti " & vbCrLf &_
				"    ON protic.documento_asociado_cuota(ab.tcom_ccod, ab.inst_ccod, ab.comp_ndocto, ab.dcom_ncompromiso, 'ting_ccod') = ti.ting_ccod " & vbCrLf &_
				"    and ti.ting_ccod in (3,38,88) "& vbCrLf &_
				"	  GROUP BY  b.pers_ncorr_codeudor,ii.pers_ncorr,b.ting_ccod,ii.ingr_nfolio_referencia, ab.inst_ccod,ab.tcom_ccod, ab.comp_ndocto, ab.dcom_ncompromiso,ti.ting_tdesc "& vbCrLf &_
			" order by deudor, numero_docto " 

f_documentos_caja.Consultar consulta

'response.Write("<pre>"&consulta&"</pre>")
'--------------------------------------------------------------------------------------------------
set f_suma = new CFormulario
f_suma.Carga_Parametros "rendicion_cajas.xml", "suma"
f_suma.Inicializar conexion
f_suma.Consultar "select 0 as total"
f_suma.Siguiente
%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_inicial.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">


<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script>
function imprimir()
{
  window.print();  
}
</script>
</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<style>
@media print{ .noprint {visibility:hidden; }}
</style>

<table width="600" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
     
  <tr>
    <td valign="top" >
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" >
      <tr>
        <td width="9" height="8"></td>
        <td height="8" ></td>
        <td width="7" height="8"></td>
      </tr>
      <tr>
        <td width="9" >&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%>
              <br>
              </div>
             
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><div align="center">
                        <%f_movimiento_caja.DibujaRegistro%>
                    </div></td>
                  </tr>
                </table>
                <br>
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>
					<b><font color="#666677" size="2">Detalle de Cheques pagados</font></b>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"><%f_documentos_caja.DibujaTabla%></div></td>
                        </tr>
                      </table>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td width="80%">&nbsp;</td>
                          <td width="20%">&nbsp;</td>
                        </tr>
                      </table></td>
                  </tr>
                </table>
                          <br>
            </td></tr>
        </table></td>
        <td width="7" >&nbsp;</td>
      </tr>
	  <tr>
		<td colspan="2"><br></td>
	</tr>
	  <tr>
		<td colspan="2"><center>___________________________________<br><%=nombre_cajero%></center></td>
	</tr>
      <tr>
        <td width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="31%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center" class="noprint">
                    <%f_botonera.DibujaBoton("imprimir")%>
                  </div></td>
                  
                  </tr>
              </table>
            </div></td>
            <td width="69%" rowspan="2"></td>
            </tr>
			
          <tr>
            <td height="8"></td>
          </tr>
        </table></td>
        <td width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
