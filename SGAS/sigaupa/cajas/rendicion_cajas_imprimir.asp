<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO: CONTROL INTERNO
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:03/04/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			:93,97,104
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
v_inst_ccod = "1"

set f_documentos_caja = new CFormulario
f_documentos_caja.Carga_Parametros "rendicion_cajas.xml", "documentos_caja_impresion"
f_documentos_caja.Inicializar conexion

		   
'consulta = "select a.mcaj_ncorr, a.inst_ccod, a.tdoc_ccod, a.tdoc_tdesc, " & vbCrLf &_
'			"      isnull(b.mcaj_mtotal, 0) as mcaj_mtotal, isnull(b.mcaj_mneto, 0) as mcaj_mneto, " & vbCrLf &_
'			"	   isnull(b.mcaj_mexento, 0) as mcaj_mexento, isnull(b.mcaj_miva, 0) as mcaj_miva," & vbCrLf &_
'			"      isnull(b.mcaj_ncantidad, 0) as mcaj_ncantidad, " & vbCrLf &_
'			"	   b.mcaj_desde, b.mcaj_hasta " & vbCrLf &_
'			"from (select a.mcaj_ncorr, b.inst_ccod, b.tdoc_ccod, b.tdoc_tdesc " & vbCrLf &_
'			"      from movimientos_cajas a, " & vbCrLf &_
'			"	       (select a.inst_ccod, a.tdoc_ccod, b.tdoc_tdesc " & vbCrLf &_
'			"		    from documentos_instituciones a, tipos_documentos_mov_cajas b " & vbCrLf &_
'			"			where a.tdoc_ccod = b.tdoc_ccod " & vbCrLf &_
'			"			  and a.inst_ccod = '" & v_inst_ccod & "') b " & vbCrLf &_
'			"	  where a.mcaj_ncorr = '" & v_mcaj_ncorr & "') a, detalle_mov_cajas b " & vbCrLf &_
'			"where a.mcaj_ncorr *= b.mcaj_ncorr " & vbCrLf &_
'			"  and a.inst_ccod *= b.inst_ccod " & vbCrLf &_
'			"  and a.tdoc_ccod *= b.tdoc_ccod 	" & vbCrLf &_
'			"order by a.tdoc_ccod asc "

consulta = "select a.mcaj_ncorr, a.inst_ccod, a.tdoc_ccod, a.tdoc_tdesc, " & vbCrLf &_
			"      isnull(b.mcaj_mtotal, 0) as mcaj_mtotal, isnull(b.mcaj_mneto, 0) as mcaj_mneto, " & vbCrLf &_
			"	   isnull(b.mcaj_mexento, 0) as mcaj_mexento, isnull(b.mcaj_miva, 0) as mcaj_miva," & vbCrLf &_
			"      isnull(b.mcaj_ncantidad, 0) as mcaj_ncantidad, " & vbCrLf &_
			"	   b.mcaj_desde, b.mcaj_hasta " & vbCrLf &_
			"from " & vbCrLf &_
			"	( " & vbCrLf &_
			"		select a.mcaj_ncorr, b.inst_ccod, b.tdoc_ccod, b.tdoc_tdesc " & vbCrLf &_
			"		from movimientos_cajas a " & vbCrLf &_
			"		INNER JOIN " & vbCrLf &_
			"			( " & vbCrLf &_
			"				select a.inst_ccod, a.tdoc_ccod, b.tdoc_tdesc " & vbCrLf &_
			"				from documentos_instituciones a " & vbCrLf &_
			"				INNER JOIN tipos_documentos_mov_cajas b " & vbCrLf &_
			"				ON a.tdoc_ccod = b.tdoc_ccod " & vbCrLf &_
			"				and a.inst_ccod = '" & v_inst_ccod & "' " & vbCrLf &_
			"			) b " & vbCrLf &_
			"		ON a.mcaj_ncorr = '" & v_mcaj_ncorr & "' " & vbCrLf &_
			"	) a " & vbCrLf &_
			"LEFT OUTER JOIN detalle_mov_cajas b " & vbCrLf &_
			"ON a.mcaj_ncorr = b.mcaj_ncorr " & vbCrLf &_
			"and a.inst_ccod = b.inst_ccod " & vbCrLf &_
			"and a.tdoc_ccod = b.tdoc_ccod " & vbCrLf &_
			"order by a.tdoc_ccod asc "

'response.Write("<pre>"&consulta&"</pre>")
'response.End()

f_documentos_caja.Consultar consulta


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
						<b><font color="#666677" size="2">Detalle de documentos</font></b>
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
