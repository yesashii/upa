<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

sede_ccod= negocio.obtenerSede

usuario = negocio.ObtenerUsuario()

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next




v_num_caja=request.Form("num_caja")


set formulario = new CFormulario
formulario.Carga_Parametros "notas_credito.xml", "notas_de_credito"
formulario.Inicializar conexion
formulario.ProcesaForm		

			
		

'********************************************************************************************			
'  Obtiene el numero actual de la boleta

        sql_actual="select isnull(rncc_nactual,rncc_ninicio) as actual from rangos_notas_credito_cajeros "& vbCrLf &_ 
							" where pers_ncorr=(select top 1 pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"') "& vbCrLf &_ 
							" and sede_ccod="&sede_ccod&" "& vbCrLf &_ 
							" and ernc_ccod=1 "		
		

		v_numero_actual = conexion.ConsultaUno(sql_actual)

'response.Write("<pre>"&sql_actual&"</pre>") 
'response.End()

if	v_numero_actual="" or EsVAcio(v_numero_actual) then
	session("mensajeError")="El cajero, No registra rango activo de notas de credito"
	response.Redirect(Request.ServerVariables("HTTP_REFERER"))	
end if

		
'********************************************************************************************			
'  Inserta nuevo registro para una boleta Vacia

  v_nuevo_ndcr_ncorr = conexion.ConsultaUno("execute obtenersecuencia 'notas_credito'")  


		sql_inserta_factura= "Insert into notas_de_credito  "& vbCrLf &_ 
		"select  "&v_nuevo_ndcr_ncorr&" as ndcr_ncorr,"&v_numero_actual&" as ndcr_nnota_credito,4 as encr_ccod,null as ndcr_mtotal,null as ndcr_miva, "& vbCrLf &_ 
		" protic.trunc(getdate()) as ndcr_fnota_credito, null as ingr_nfolio_referencia,'"&sede_ccod&"' as sede_ccod, 0 as pers_ncorr, null as pers_ncorr_aval,"& vbCrLf &_ 
		" '"&v_num_caja&"' as mcaj_ncorr,'"&usuario&"' as audi_tusuario,getdate() as audi_fmodificacion "
		

		conexion.EjecutaS(sql_inserta_factura)
		
'response.Write("<pre>"&sql_inserta_factura&"</pre>") 
'response.End()

'********************************************************************************************
' Actualiza el numero de boleta

			v_numero_actual=Clng(v_numero_actual) + 1
			sql_actualiza_numero=" Update rangos_notas_credito_cajeros set rncc_nactual="&v_numero_actual&"  "& vbCrLf &_ 
									" where pers_ncorr in (select top 1 pers_ncorr from personas where pers_nrut='"&usuario&"') "& vbCrLf &_ 
									" and sede_ccod="&sede_ccod&" "& vbCrLf &_ 
									" and ernc_ccod=1"
			
			'response.Write("<pre>"&sql_actualiza_numero&"</pre>")											
			conexion.EjecutaS(sql_actualiza_numero)
			
'********************************************************************************************

				
'Response.Write("<br> Transaccion :"&conexion.ObtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'Response.End()

if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="Las notas de credito selecionadas fueron guardadas correctamente "
else
	session("mensajeError")="Ocurrio un error al intentar actualizar una o mas notas de credito.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
'response.End()
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>