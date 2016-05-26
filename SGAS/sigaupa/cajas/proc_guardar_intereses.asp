<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each x in request.Form
'	response.Write("<br>clave:"&x&"->"&request.Form(x))
'next


rut = request.Form("pers_nrut")
digito = request.Form("pers_xdv")

set conexion = new CConexion
conexion.Inicializar "upacifico"


set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()

set formulario = new CFormulario
formulario.Carga_Parametros "calcular_intereses.xml", "detalle_intereses"
formulario.Inicializar conexion
formulario.ProcesaForm		

for fila = 0 to formulario.CuentaPost - 1

	v_tcom_ccod		= formulario.ObtenerValorPost (fila, "tcom_ccod")
   	v_inst_ccod		= formulario.ObtenerValorPost (fila, "inst_ccod")
   	v_comp_ndocto		= formulario.ObtenerValorPost (fila, "comp_ndocto")   
   	v_dcom_ncompromiso	= formulario.ObtenerValorPost (fila, "dcom_ncompromiso")
   	v_saldo			= clng(formulario.ObtenerValorPost (fila, "deuda"))
	v_dias_mora		= cint(formulario.ObtenerValorPost (fila, "dias_mora"))
   	v_monto_int		= clng(formulario.ObtenerValorPost (fila, "interes"))
	v_factor		= replace(formulario.ObtenerValorPost (fila, "sint_nfactor"),".",",") 
	v_sint_ccod		= formulario.ObtenerValorPost (fila, "sint_ccod")
	v_opcion_calc	= formulario.ObtenerValorPost (fila, "segun")
  

	if v_dias_mora > 0 then

if v_opcion_calc="1" then
'CALCULO SEGUN FACTOR ELEGIDO
		v_monto_interes=	round((v_saldo*(v_factor)*v_dias_mora)/30)
		v_factor=replace(v_factor,",",".")
else
'CALCULO SEGUN MONTO
		v_factor=replace(round((30*v_monto_int)/(v_saldo*v_dias_mora),4),",",".")
		v_monto_interes=	v_monto_int
end if

		sql_actualiza_simulacion= 	" Update simulacion_interes set sint_minteres="&v_monto_interes&" , sint_nfactor='"&v_factor&"', "& vbCrLf &_ 
									" esin_ccod=2, audi_tusuario='"&v_usuario&"', audi_fmodificacion=getdate() "& vbCrLf &_ 
								    " Where sint_ccod="&v_sint_ccod&" and comp_ndocto="&v_comp_ndocto&"  and tcom_ccod="&v_tcom_ccod&" and inst_ccod="&v_inst_ccod&" and dcom_ncompromiso="&v_dcom_ncompromiso&" " 
'response.Write("<pre>"&sql_actualiza_simulacion&"</pre>")	
'response.End()
		conexion.EstadoTransaccion conexion.EjecutaS(sql_actualiza_simulacion)
		suma_intereses=v_monto_interes+suma_intereses
	end if
next
'conexion.EstadoTransaccion false
'response.end()

		secuencia= conexion.consultaUno("select comp_ndocto_referencia from simulacion_interes where sint_ccod="&v_sint_ccod)

		sql_actualiza_compromiso= 	" Update compromisos set comp_mneto="&suma_intereses&" , comp_mdocumento="&suma_intereses&" "& vbCrLf &_ 
									" Where comp_ndocto="&secuencia&" and tcom_ccod=6 and inst_ccod=1 " 
	
	'response.Write("<pre>"&sql_actualiza_compromiso&"</pre>")
		sql_actualiza_detalle_compromiso= 	" Update detalle_compromisos set dcom_mneto="&suma_intereses&" , dcom_mcompromiso="&suma_intereses&" "& vbCrLf &_ 
											" Where comp_ndocto="&secuencia&"  and tcom_ccod=6 and inst_ccod=1 and dcom_ncompromiso=1 " 
	'response.Write("<pre>"&sql_actualiza_detalle_compromiso&"</pre>")
	
		sql_actualiza_detalles= 	" Update detalles set deta_mvalor_unitario="&suma_intereses&" , deta_mvalor_detalle="&suma_intereses&", deta_msubtotal="&suma_intereses&" "& vbCrLf &_ 
									" Where  comp_ndocto="&secuencia&"  and tcom_ccod=6 and inst_ccod=1  " 
	'response.Write("<pre>"&sql_actualiza_detalles&"</pre>")
	
	
		conexion.EstadoTransaccion conexion.EjecutaS(sql_actualiza_compromiso)
	'response.Write("<br> Estado Transaccion 6: "&conexion.obtenerEstadoTransaccion)
		conexion.EstadoTransaccion conexion.EjecutaS(sql_actualiza_detalle_compromiso)
	'response.Write("<br> Estado Transaccion 7: "&conexion.obtenerEstadoTransaccion)
		conexion.EstadoTransaccion conexion.EjecutaS(sql_actualiza_detalles)
	'response.Write("<br> Estado Transaccion 8: "&conexion.obtenerEstadoTransaccion)


'formulario.MantieneTablas true
'conexion.estadoTransaccion false
'response.End()

%>
<script language="JavaScript">
   location.reload("activar_intereses.asp?busqueda[0][pers_nrut]=<%=rut%>&busqueda[0][pers_xdv]=<%=digito%>&sint_ccod=<%=v_sint_ccod%>") 
</script>
