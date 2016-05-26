<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Acuse de recibo"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set errores = new CErrores

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "rendicion_cajas.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede



v_folio = request.QueryString("nfolio")
v_ting_ccod = request.QueryString("ting_ccod")
'---------------------------------------------------------------------------------------------------

set f_documentos_caja = new CFormulario
f_documentos_caja.Carga_Parametros "detalle_acuse.xml", "detalle_pagos_acuse"
f_documentos_caja.Inicializar conexion

		   
consulta	 =  "select "& vbCrLf &_
				" distinct convert(varchar,dc.DCOM_FCOMPROMISO,103) fecha_vencimiento,upper(ti.ting_tdesc) as tipo_ingreso,tc.tcom_tdesc as tipo_compromiso, "& vbCrLf &_
				" cast(protic.documento_asociado_cuota(a.tcom_ccod, a.inst_ccod, a.comp_ndocto, a.dcom_ncompromiso, 'ding_ndocto') as varchar) as numero_docto, "& vbCrLf &_      
				" cast(protic.documento_asociado_cuota(a.tcom_ccod, a.inst_ccod, a.comp_ndocto, a.dcom_ncompromiso, 'monto') as varchar) as monto_documento "& vbCrLf &_
				" from documentos_acuse_recibo a,detalle_compromisos dc ,tipos_compromisos tc,tipos_ingresos ti  "& vbCrLf &_   
				"  where cast(ingr_nfolio_referencia as varchar) = '"&v_folio&"'  "& vbCrLf &_     
				"  and cast(tipo_comprobante as varchar) = '"&v_ting_ccod&"'  "& vbCrLf &_
				"   and a.tcom_ccod = dc.tcom_ccod  "& vbCrLf &_     
				"   and a.inst_ccod = dc.inst_ccod  "& vbCrLf &_     
				"   and a.comp_ndocto = dc.comp_ndocto  "& vbCrLf &_      
				"   and a.dcom_ncompromiso = dc.dcom_ncompromiso "& vbCrLf &_
				"   and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ting_ccod') = ti.ting_ccod   "& vbCrLf &_             
				"   and dc.tcom_ccod = tc.tcom_ccod"

f_documentos_caja.Consultar consulta
'response.Write("<pre>"&consulta&"</pre>")
'--------------------------------------------------------------------------------------------------

'response.Write(Day(una_fecha)& "-" &Month(una_fecha)& "-" & Year(una_fecha))
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
        <td>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr>
              	<td valign="top">
					<table width="100%">
						<tr>
							<td width="15%"><img src="../imagenes/logo_upa.jpg" /></td>
							<td width="75%"> <div align="center"><%pagina.DibujarTituloPagina%></div></td>
							<td width="10%"></td>
						</tr>
					</table>  
				</td>
            </tr>
            <tr>
              <td><div align="left">
                  <p><br>
                  </p>
                  <br>
                  <br>
                  	<p><font size="2" style="text-align:left;">Yo _____________________________________________________ </font></p>
					<p><font size="2" style="text-align:left;">Numero de Rut  _______________________</font></p>
                  <p><font size="2">Con fecha <%=date()%> acuso haber recibido conforme los documentos que se detallan a continuaci&oacute;n :</font> </p>
                </div>
                  <b><font color="#666677" size="2">Detalle de documentos recibidos </font></b> <br>
                  <div align="center">
                    <%f_documentos_caja.DibujaTabla%>
                  </div>
                  <br>
              </td>
            </tr>
        </table></td>
      </tr>
      <tr>
        <td><br/><br/><br/><br/><center>___________________________________<br/> Firma </center><br/></td>
      </tr>
      <tr>
        <td align="center" class="noprint" ><%f_botonera.DibujaBoton("imprimir")%></td>
      </tr>
    </table>
	</td>
  </tr>  
</table>
</body>
</html>
