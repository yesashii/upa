<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each x in request.form
'	response.Write("<br>"&x&"->"&request.Form(x)&"<br>")
'next

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'---------------------------------------------------------------------
v_usuario=negocio.ObtenerUsuario&"-corrige_doc"


set formulario = new CFormulario
formulario.Carga_Parametros "genera_contrato_4.xml", "f_cheque"
formulario.Inicializar conexion
formulario.ProcesaForm


ding_ndocto=formulario.ObtenerValorPost (0,"ding_ndocto")
ting_ccod=formulario.ObtenerValorPost (0,"ting_ccod")
banc_ccod=formulario.ObtenerValorPost (0,"banc_ccod")
ding_tcuenta_corriente=formulario.ObtenerValorPost (0,"ding_tcuenta_corriente")
ding_fdocto=formulario.ObtenerValorPost (0,"ding_fdocto")
ingr_ncorr=formulario.ObtenerValorPost (0,"ingr_ncorr")


pacta_cuota=formulario.ObtenerValorPost (0,"pacta_cuota")
ding_tcuenta_corriente_c = formulario.ObtenerValorPost (0,"ding_tcuenta_corriente_c")
ding_ndocto_c=formulario.ObtenerValorPost (0,"ding_ndocto_c")
banc_ccod_c	=formulario.ObtenerValorPost (0,"banc_ccod_c")



if (ding_tcuenta_corriente_c<>"") then 
	consulta = "UPDATE detalle_ingresos SET ding_ndocto = "& ding_ndocto_c & ", ding_tcuenta_corriente='"& ding_tcuenta_corriente_c & "' , banc_ccod=" & banc_ccod_c &",ding_fdocto='"&ding_fdocto&"' WHERE banc_ccod=" & banc_ccod &" and  ding_ndocto="& ding_ndocto & " and ting_ccod="&ting_ccod & " and ingr_ncorr="&ingr_ncorr   
          
else 
	consulta = "UPDATE detalle_ingresos SET ding_ndocto = "& ding_ndocto_c & ", ding_tcuenta_corriente='"& ding_tcuenta_corriente_c & "' , banc_ccod=" & banc_ccod_c &",ding_fdocto='"&ding_fdocto&"' WHERE banc_ccod=" & banc_ccod &" and  ding_ndocto="& ding_ndocto & " and ting_ccod="&ting_ccod &" " 
end if   
 conexion.EstadoTransaccion conexion.EjecutaS(consulta)
'response.Write("<br>Consulta<br>"&consulta)

sql_actualiza_correlativo="exec corrige_correlativo_cheque "&ding_ndocto_c&","&banc_ccod_c&",'"&ding_tcuenta_corriente_c&"','"&ding_fdocto&"','"&v_usuario&"'"
conexion.EstadoTransaccion conexion.EjecutaP(sql_actualiza_correlativo)
'response.Write("<hr>"&sql_actualiza_correlativo)
'response.End()


if pacta_cuota="1" then
	sql_datos_compromisos="select * from abonos where ingr_ncorr="&ingr_ncorr
	
	set datos_compromiso = new CFormulario
	datos_compromiso.carga_parametros "consulta.xml", "consulta"
	datos_compromiso.Inicializar conexion	
	datos_compromiso.Consultar sql_datos_compromisos
		
		while datos_compromiso.Siguiente
		
				v_comp_ndocto		=	datos_compromiso.ObtenerValor("comp_ndocto")
				v_tcom_ccod			=	datos_compromiso.ObtenerValor("tcom_ccod")
				v_dcom_ncompromiso	=	datos_compromiso.ObtenerValor("dcom_ncompromiso")
				v_inst_ccod			=	datos_compromiso.ObtenerValor("inst_ccod")
				
				sql_update_dcomp="update detalle_compromisos set dcom_fcompromiso='"&ding_fdocto&"' "& vbCrLf &_
								 " where comp_ndocto="&v_comp_ndocto&" and tcom_ccod="&v_tcom_ccod&" " & vbCrLf &_
								 " and inst_ccod="&v_inst_ccod&" and dcom_ncompromiso="&v_dcom_ncompromiso&" "
 				
				conexion.EstadoTransaccion conexion.EjecutaS(sql_update_dcomp)
			'response.Write("<pre>"&sql_update_dcomp&"</pre>")  
		wend
		
end if
'response.Write("Transaccion: <b>"&conexion.ObtenerEstadoTransaccion&"</b>" )
'response.End()
%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
window.close();
window.opener.parent.top.location.reload();

</script>