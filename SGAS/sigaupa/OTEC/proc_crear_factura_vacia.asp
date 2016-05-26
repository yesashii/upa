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

v_tipo_factura=request.Form("tipo_factura")
v_num_caja=request.Form("num_caja")


set formulario = new CFormulario
formulario.Carga_Parametros "factura.xml", "f_facturas"
formulario.Inicializar conexion
formulario.ProcesaForm		

			
  v_nuevo_fact_ncorr = conexion.ConsultaUno("execute obtenersecuencia 'facturas'")  
		

'********************************************************************************************			
'  Obtiene el numero actual de la boleta

        sql_actual="select isnull(rfca_nactual,rfca_ninicio) as actual from rangos_facturas_cajeros "& vbCrLf &_ 
							" where pers_ncorr=(select top 1 pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"') "& vbCrLf &_ 
							" and tfac_ccod="&v_tipo_factura&" "& vbCrLf &_ 
							" and sede_ccod="&sede_ccod&" "& vbCrLf &_ 
							" and erfa_ccod=1 "		
		
'response.Write("<pre>"&sql_actual&"</pre>") 
'response.End()
		v_numero_actual = conexion.ConsultaUno(sql_actual)

if	v_numero_actual="" or EsVAcio(v_numero_actual) then
	session("mensajeError")="El cajero, No registra rango activo de facturas"
	response.Redirect(Request.ServerVariables("HTTP_REFERER"))	
end if

		
'********************************************************************************************			
'  Inserta nuevo registro para una boleta Vacia

		sql_inserta_factura= "Insert into facturas  "& vbCrLf &_ 
		"select  "&v_nuevo_fact_ncorr&" as fact_ncorr,"&v_numero_actual&" as fact_nfactura,4 as efac_ccod,"&v_tipo_factura&" as tfac_ccod,getdate() as fact_ffactura, "& vbCrLf &_ 
		" null as fact_mtotal,null as fact_miva, null as fact_mneto,null as ingr_nfolio_referencia,null as folio_abono_factura, 0 as pers_ncorr_alumno, null as empr_ncorr,"& vbCrLf &_ 
		" '"&v_num_caja&"' as mcaj_ncorr,getdate() as audi_fmodificacion,'"&usuario&"' as audi_tusuario,'"&sede_ccod&"' as sede_ccod "
		
'response.Write("<pre>"&sql_inserta_factura&"</pre>") 
'response.End()
		conexion.EjecutaS(sql_inserta_factura)
		


'********************************************************************************************
' Actualiza el numero de boleta

			v_numero_actual=Clng(v_numero_actual) + 1
			sql_actualiza_numero=" Update rangos_facturas_cajeros set rfca_nactual="&v_numero_actual&"  "& vbCrLf &_ 
									" where pers_ncorr in (select top 1 pers_ncorr from personas where pers_nrut='"&usuario&"') "& vbCrLf &_ 
									" and tfac_ccod="&v_tipo_factura&" "& vbCrLf &_ 
									" and sede_ccod="&sede_ccod&" "& vbCrLf &_ 
									" and erfa_ccod=1"
			
			'response.Write("<pre>"&sql_actualiza_numero&"</pre>")											
			'conexion.EjecutaS(sql_actualiza_numero)
			
'********************************************************************************************

				
'Response.Write("<br> Transaccion :"&conexion.ObtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'Response.End()

if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="Las Facturas selecionados fueron guardadas correctamente "
else
	session("mensajeError")="Ocurrio un error al intentar actualizar una o mas facturas.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
'response.End()
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>