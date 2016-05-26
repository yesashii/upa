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

sede_ccod= negocio.obtenerSede

usuario = negocio.ObtenerUsuario()
%>
<html>
<head>
<script language="JavaScript">
function ReCargarPagina(formulario){
	formulario.submit();
}
</script>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
            <form name="edicion" action="calcular_intereses.asp" method="post">
			<input type="hidden" name="nro_docto" value="<%=v_nro_docto%>" />
			<input type="hidden" name="nombre" value="<%=f_nombre%>" />
			<input type="hidden" name="rut" value="<%=f_nrut%>" />
			<input type="hidden" name="v_sint_ccod" value="<%=v_sint_ccod%>" >
			<input type="hidden" name="v_simu_ccod" value="1" >
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<%

set formulario = new CFormulario
formulario.Carga_Parametros "calcular_intereses.xml", "detalle_pagos"
formulario.Inicializar conexion
formulario.ProcesaForm		
for fila = 0 to formulario.CuentaPost - 2

   	v_tcom_ccod		= formulario.ObtenerValorPost (fila, "tcom_ccod")
   	v_inst_ccod		= formulario.ObtenerValorPost (fila, "inst_ccod")
   	v_comp_ndocto		= formulario.ObtenerValorPost (fila, "comp_ndocto")   
   	v_dcom_ncompromiso	= formulario.ObtenerValorPost (fila, "dcom_ncompromiso")
	v_saldo			= clng(formulario.ObtenerValorPost (fila, "saldo"))
	v_dias_mora		= clng(formulario.ObtenerValorPost (fila, "dias_mora"))
	v_factor		= replace(formulario.ObtenerValorPost (fila, "factor"),".",",")

'response.Write("Factor :"&v_factor&" -->v_dias_mora :"&v_dias_mora&" -->v_saldo :"&v_saldo)
'response.Flush()

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

		if v_dias_mora > 0 and v_factor<>"" then

			redondeo=	replace((v_saldo*v_factor*v_dias_mora)/30,",",".")
			'query = "select round("&redondeo&",0) "
			query = "select round(cast("&redondeo&" as money),0)"
			'---------------DEBUG->>>>>>>>>>
			'response.Write("<pre>"&query&"</pre>")	
			'response.end()
			'---------------DEBUG-<<<<<<<<<<
			v_monto_interes=conexion.consultaUno(query)
			v_factor=replace(v_factor,",",".")

			
			sql_actualiza_simulacion= 	" Update simulacion_interes set sint_minteres="&v_monto_interes&" , sint_nfactor='"&v_factor&"', esin_ccod=2 "& vbCrLf &_ 
										" Where sint_ccod="&v_sint_ccod&" and comp_ndocto="&v_comp_ndocto&"  and tcom_ccod="&v_tcom_ccod&" and inst_ccod="&v_inst_ccod&" and dcom_ncompromiso="&v_dcom_ncompromiso&" " 

			conexion.EstadoTransaccion conexion.EjecutaS(sql_actualiza_simulacion)
		end if

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
