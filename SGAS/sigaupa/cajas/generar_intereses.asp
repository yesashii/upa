<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each x in request.Form
'	response.Write("<br>clave:"&x&"->"&request.Form(x))
'next
'response.end()

f_nrut 			= Request.Form("rut")
f_nombre 		= Request.Form("nombre")
v_nro_docto 	= Request.Form("nro_docto")
v_sint_ccod 	= Request.Form("v_sint_ccod")

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


	secuencia= conexion.consultaUno("select comp_ndocto_referencia from simulacion_interes where sint_ccod="&v_sint_ccod)

	sql_actualiza_compromiso= 	" Update compromisos set ecom_ccod=1 "& vbCrLf &_ 
								" Where comp_ndocto="&secuencia&" and tcom_ccod=6 and inst_ccod=1 " 

	sql_actualiza_detalle_compromiso= 	" Update detalle_compromisos set ecom_ccod=1  "& vbCrLf &_ 
										" Where comp_ndocto="&secuencia&"  and tcom_ccod=6 and inst_ccod=1 and dcom_ncompromiso=1 " 

	sql_actualiza_simulacion=" Update simulacion_interes set esin_ccod=3 where sint_ccod="&v_sint_ccod


	conexion.EstadoTransaccion conexion.EjecutaS(sql_actualiza_compromiso)
	conexion.EstadoTransaccion conexion.EjecutaS(sql_actualiza_detalle_compromiso)
	conexion.EstadoTransaccion conexion.EjecutaS(sql_actualiza_simulacion)
'response.Write("EstadoConexion: "&conexion.ObtenerEstadoTransaccion)
%>
<html>
<head>
<script language="JavaScript">
function ReCargarPagina(formulario){
	formulario.submit();
}
</script>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
            <form name="edicion" action="edicion_pago.asp" method="post">
			<input type="hidden" name="nro_docto" value="<%=v_nro_docto%>" />
			<input type="hidden" name="nombre" value="<%=f_nombre%>" />
			<input type="hidden" name="rut" value="<%=f_nrut%>" />
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<%


set formulario = new CFormulario
formulario.Carga_Parametros "calcular_intereses.xml", "detalle_pagos"
formulario.Inicializar conexion
formulario.ProcesaForm		

for fila = 0 to formulario.CuentaPost - 1

   	v_tcom_ccod		= formulario.ObtenerValorPost (fila, "tcom_ccod")
   	v_inst_ccod		= formulario.ObtenerValorPost (fila, "inst_ccod")
   	v_comp_ndocto		= formulario.ObtenerValorPost (fila, "comp_ndocto")   
   	v_dcom_ncompromiso	= formulario.ObtenerValorPost (fila, "dcom_ncompromiso")
 
%>
<tr>
	<td height="10">
		<input type="hidden" name="cc_compromisos_pendientes[<%=fila%>][tcom_ccod]" value="<%=v_tcom_ccod%>" />
		<input type="hidden" name="cc_compromisos_pendientes[<%=fila%>][comp_ndocto]" value="<%=v_comp_ndocto%>"/>
		<input type="hidden" name="cc_compromisos_pendientes[<%=fila%>][inst_ccod]" value="<%=v_inst_ccod%>" />
	    <input type="hidden" name="cc_compromisos_pendientes[<%=fila%>][dcom_ncompromiso]" value="<%=v_dcom_ncompromiso%>" />	
	</td>
</tr>
<%
next

if conexion.ObtenerEstadoTransaccion=false  then
	session("mensajeError")="Ocurrio un error al intentar actualizar los cobros de intereses.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
%>
<tr><td align="center"><b><font color="#0033FF" size="3">Procesando...</font></b></td></tr>
<tr><td></td></tr>
</table>
<script language="javascript">
	ReCargarPagina(document.edicion);
</script>

</body>
</html>
