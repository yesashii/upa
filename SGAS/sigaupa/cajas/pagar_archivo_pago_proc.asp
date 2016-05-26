<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%

'for each x in request.Form
'	response.Write(x&"->"&request.Form(x)&"<br>")
'next
'response.End()


'----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set cajero = new CCajero
cajero.inicializar conexion, negocio.obtenerUsuario, negocio.obtenerSede

'---------------------------------------------------------------------
caja_abierta = cajero.obtenerCajaAbierta

usuario 	= negocio.ObtenerUsuario()
peri_ccod 	= negocio.ObtenerPeriodoAcademico("POSTULACION")
'----------------------------------------------------------------------  

if caja_abierta <>"" then

  set formulario = new CFormulario
  formulario.Carga_Parametros "archivo_pago_electronico.xml", "pago_electronico_letras"
  formulario.Inicializar conexion
  formulario.ProcesaForm
  

	for fila = 0 to formulario.CuentaPost - 1
		
		v_pele_ccod		= formulario.ObtenerValorPost (fila, "pele_ccod")
	
		v_num_letra		= formulario.ObtenerValorPost (fila, "num_letra")
		v_monto_letra	= formulario.ObtenerValorPost (fila, "monto_letra")
		v_pers_ncorr	= formulario.ObtenerValorPost (fila, "pers_ncorr")
	
		dcom_ncompromiso= formulario.ObtenerValorPost (fila, "dcom_ncompromiso")
		comp_ndocto		= formulario.ObtenerValorPost (fila, "comp_ndocto")
		tcom_ccod		= formulario.ObtenerValorPost (fila, "tcom_ccod")
	
	
	v_pagado = conexion.consultaUno("select protic.total_recepcionar_cuota("&tcom_ccod&",1,"&comp_ndocto&","&dcom_ncompromiso&") as saldo")
	
	   if v_num_letra<>"" and v_monto_letra <>"" and v_pers_ncorr <>"" and Clng(v_pagado)=Clng(v_monto_letra) then
	
		  
			  ' ---------------- NUEVO INGR_NCORR -------------------
				nuevo_ingr_ncorr = conexion.ConsultaUno("execute obtenersecuencia 'ingresos'")
				nuevo_folio_referencia = conexion.ConsultaUno("execute obtenersecuencia 'ingresos_referencia'")
				
			  ' ------------------------------------------------------------------		  
			   sql = "INSERT INTO ingresos(ingr_ncorr, mcaj_ncorr, eing_ccod, ingr_fpago, ingr_mefectivo, ingr_mdocto, ingr_mtotal, ingr_nestado, ingr_nfolio_referencia, ting_ccod, inst_ccod, pers_ncorr,  audi_tusuario, audi_fmodificacion) " & vbCrLf &_
					 "(SELECT " & nuevo_ingr_ncorr & ",'" & caja_abierta & "' ,1 , getdate() ,'" &  v_monto_letra& "','" &  v_monto_letra& "','" & v_monto_letra & "',1," & nuevo_folio_referencia  & ", 16, 1,'" & v_pers_ncorr & "','" & usuario & "', getdate()) "
			
					conexion.EstadoTransaccion conexion.EjecutaS(sql)						
					'response.Write("<BR><BR><PRE>" & sql & "</PRE><BR><BR>")
					'response.Write("<br><b>Estado Ingresos: " & conexion.ObtenerEstadoTransaccion & "</b>") 
							
			   sql = "INSERT INTO abonos (ingr_ncorr, tcom_ccod, inst_ccod, comp_ndocto, dcom_ncompromiso, abon_fabono, abon_mabono, pers_ncorr, peri_ccod,  audi_tusuario, audi_fmodificacion) "& vbCrLf &_
					 "(SELECT " & nuevo_ingr_ncorr & ",'" & tcom_ccod & "',1,'" & comp_ndocto & "','"& dcom_ncompromiso& "', getdate() ,'" &  v_monto_letra & "','" & v_pers_ncorr & "','" & peri_ccod & "','" & usuario & "', getdate())"
				
					conexion.EstadoTransaccion conexion.EjecutaS(sql)
					'response.Write("<BR><BR><PRE>" & sql & "</PRE><BR>")		  
					'response.Write("<br><b>Estado Abonos: " & conexion.ObtenerEstadoTransaccion & "</b>")
	
	
				 ding_nsecuencia = conexion.ConsultaUno("execute obtenersecuencia 'detalle_ingresos'")
				 
				 sql = "INSERT INTO detalle_ingresos (ingr_ncorr, ting_ccod, ding_ndocto, ding_nsecuencia, ding_ncorrelativo, ding_fdocto, ding_mdetalle, ding_mdocto, edin_ccod, audi_tusuario, audi_fmodificacion) "& vbCrLf &_
					   "(SELECT " & nuevo_ingr_ncorr & ", 63, '" & v_num_letra & "', "&ding_nsecuencia&",1, getdate() ,'" &  v_monto_letra & "','" & v_monto_letra & "', 6 ," & usuario & ", getdate())"
								   
					conexion.EstadoTransaccion conexion.EjecutaS(sql) 
					'response.Write("<BR><BR><PRE>" & sql & "</PRE><BR><BR>")	
					'response.Write("<br><b>Estado Detalles: " & conexion.ObtenerEstadoTransaccion & "</b>")
			 
			 ' Vincula cada letra con el comprobante generado 
			 sql_actualiza="update pago_electronico_letras set ingr_nfolio_referencia="&nuevo_folio_referencia&", pele_fpago=getdate() where pele_nidentificacion="&v_num_letra&" and pele_ccod="&v_pele_ccod
			 conexion.EstadoTransaccion conexion.EjecutaS(sql_actualiza) 
			 'response.Write("<BR><BR><PRE>" & sql_actualiza & "</PRE><BR><BR>")
			 'response.Write("<br><b>Estado Actualizacion: " & conexion.ObtenerEstadoTransaccion & "</b>")
			 
			 ' Actualiza el estado de cada letra a PAGADO
			 sql_actualiza_estado="update detalle_ingresos set edin_ccod=6, audi_tusuario='PAGO ELECTRONICO' where ding_ndocto="&v_num_letra&" and edin_ccod=1 and ting_ccod=4"
			 conexion.EstadoTransaccion conexion.EjecutaS(sql_actualiza_estado) 
			 		
	   end if
	next   

	if nuevo_ingr_ncorr <>"" or nuevo_folio_referencia<>"" then
		sql_actualiza_estado="update pago_electronico_letras set epel_ccod=4 where  pele_ccod="&v_pele_ccod
		'response.Write("<BR><PRE>" & sql_actualiza_estado & "</PRE><BR>")
		conexion.EstadoTransaccion conexion.EjecutaS(sql_actualiza_estado) 
	end if

else
	session("mensaje_error")="No tiene Caja abierta, para realizar esta carga debe tener una caja habilitada"
	response.Redirect(request.ServerVariables("HTTP_REFERER"))
end if  

  
'Response.Write("<br> Transaccion :"&conexion.ObtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'Response.End()  
  

response.Redirect("comprobante_archivo_pago_electronico.asp?q_leng=4&pele_ccod="&v_pele_ccod)
%>