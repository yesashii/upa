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

pers_corr_caj=conexion.consultaUno("select pers_ncorr from personas where pers_nrut ="&usuario&" ")	

v_duplica=request.Form("duplica")

set formulario = new CFormulario
formulario.Carga_Parametros "factura.xml", "f_facturas"
formulario.Inicializar conexion
formulario.ProcesaForm		

for fila = 0 to formulario.CuentaPost - 1
   v_fact_ncorr		= formulario.ObtenerValorPost (fila, "fact_ncorr")
   v_fact_nfactura	= formulario.ObtenerValorPost (fila, "fact_nfactura")
   v_tfac_ccod		= formulario.ObtenerValorPost (fila, "c_tfac_ccod")
   v_efac_ccod		= formulario.ObtenerValorPost (fila, "efac_ccod")
   v_inst_ccod		= formulario.ObtenerValorPost (fila, "inst_ccod")
   



'response.Write(v_inst_ccod)
'response.End()

   if v_fact_ncorr <> "" and v_fact_nfactura <> "" then

'response.Write("select inst_ccod from rangos_facturas_cajeros rfc where rfc.tfac_ccod="&v_tfac_ccod&" and rfc.sede_ccod="&sede_ccod&" and rfc.pers_ncorr="&pers_corr_caj&" and  "&v_fact_nfactura&" between rfca_ninicio and rfca_nfin")
'response.End()

		v_inst_ccod=conexion.consultaUno("select inst_ccod from rangos_facturas_cajeros rfc where rfc.tfac_ccod="&v_tfac_ccod&" and rfc.sede_ccod="&sede_ccod&" and rfc.pers_ncorr="&pers_corr_caj&" and  "&v_fact_nfactura&" between rfca_ninicio and rfca_nfin")
		v_inst_ccod=1
	if(v_inst_ccod<>"") then
		
			formulario.AgregaCampoFilaPost fila, "efac_ccod", "3"
			
			sql_consulta_rango 	=	"Select count(*) as pertenece "& vbCrLf &_ 
									" from rangos_facturas_sedes "& vbCrLf &_ 
									" where sede_ccod="&sede_ccod&" "& vbCrLf &_ 
									" and inst_ccod="&v_inst_ccod&" "& vbCrLf &_
									" and tfac_ccod="&v_tfac_ccod&" "& vbCrLf &_ 
									" and "&v_fact_nfactura&" between rfac_ninicio and rfac_nfin "& vbCrLf &_
									" order by pertenece "
									
	'Response.Write("<br> Transaccion 1:"&sql_consulta_rango)
	
			v_pertenece_rango	=	conexion.consultaUno(sql_consulta_rango)
	'Response.Write("<br> Transaccion 1:"&conexion.ObtenerEstadoTransaccion)		
'	conexion.EstadoTransaccion false		
'	Response.Write("<br> Transaccion 1:"&conexion.ObtenerEstadoTransaccion)		
'	response.End()		
	v_pertenece_rango="1" 		' modificado por el constante movimiento de cajeros	
			if v_pertenece_rango = "1" then
				sql_factura_existe=	"select count(fact_nfactura) from facturas where sede_ccod="&sede_ccod&" and tfac_ccod="&v_tfac_ccod&" and fact_nfactura="&v_fact_nfactura&" And fact_ncorr <> "&v_fact_ncorr&" "
				
				v_factura_existe=conexion.consultaUno(sql_factura_existe)
				'response.Write("<hr>"&sql_boleta_existe&"<hr>")
				
				if v_factura_existe >="1" then
						'response.Write("<hr>entre<hr>")
						conexion.EstadoTransaccion false
						session("mensajeError")="el numero ingresado para la factura ya existe"
						response.Redirect(Request.ServerVariables("HTTP_REFERER"))
				end if
	
	'Response.Write("<br> Transaccion 2:"&conexion.ObtenerEstadoTransaccion)				
				if v_efac_ccod<>"4" and v_duplica = "SI" then
					
					v_nuevo_fact_ncorr = conexion.ConsultaUno("execute obtenersecuencia 'facturas'")  
	
						  
	'********************************************************************************************			
	'  Obtiene el numero actual de la factura, para asignarla al nuevo registro
							sql_nuevo_numero="  select isnull(rfca_nactual,rfca_ninicio) as num "& vbCrLf &_ 
											" from rangos_facturas_cajeros "& vbCrLf &_ 
											" where pers_ncorr in (select top 1 pers_ncorr from personas where pers_nrut='"&usuario&"') "& vbCrLf &_ 
											" and tfac_ccod="&v_tfac_ccod&" "& vbCrLf &_ 
											" and sede_ccod="&sede_ccod&" "& vbCrLf &_ 
											" and inst_ccod="&v_inst_ccod&" "& vbCrLf &_ 
											" and erfa_ccod=1"
		'Response.Write("<br> Transaccion 2.0:"&conexion.ObtenerEstadoTransaccion)					
							v_nuevo_numero=conexion.ConsultaUno(sql_nuevo_numero)
'	Response.Write("<br> Transaccion 2.01:"&conexion.ObtenerEstadoTransaccion)	
							if Esvacio(v_nuevo_numero) then
								v_nuevo_numero="null"
							end if
	
	'********************************************************************************************			
	'  Inserta nuevo registro para una factura
	
						
						sql_inserta_factura= "Insert into facturas  "& vbCrLf &_ 
								"select  "&v_nuevo_fact_ncorr&" as fact_ncorr,"&v_nuevo_numero&" as fact_nboleta,efac_ccod,tfac_ccod,fact_ffactura, "& vbCrLf &_ 
								"fact_mtotal,fact_miva,fact_mneto,ingr_nfolio_referencia,folio_abono_factura, pers_ncorr_alumno, empr_ncorr,mcaj_ncorr,"& vbCrLf &_ 
								"audi_fmodificacion,audi_tusuario,sede_ccod,fact_ncorrelativo,fact_nhoras from facturas where fact_ncorr="&v_fact_ncorr
	
					'	response.Write("<pre>"&sql_inserta_factura&"</pre>")
						conexion.EjecutaS(sql_inserta_factura)
	'Response.Write("<br> Transaccion 2.1:"&conexion.ObtenerEstadoTransaccion)	
						' inserta detalle
						sql_inserta_detalle_factura= "Insert into detalle_factura  "& vbCrLf &_ 
													"select  "&v_nuevo_fact_ncorr&" as fact_ncorr,comp_ndocto,tcom_ccod,inst_ccod,dcom_ncompromiso,dfac_mdetalle,"& vbCrLf &_ 
													"audi_tusuario,audi_fmodificacion from detalle_factura where fact_ncorr="&v_fact_ncorr
				
						'response.Write("<pre>"&sql_inserta_detalle_factura&"</pre>")
						conexion.EjecutaS(sql_inserta_detalle_factura)
	'Response.Write("<br> Transaccion 2.2:"&conexion.ObtenerEstadoTransaccion)						
						sql_actualiza_cargos= "update postulantes_cargos_factura set fact_ncorr="&v_nuevo_fact_ncorr&" where fact_ncorr="&v_fact_ncorr
						conexion.EjecutaS(sql_actualiza_cargos)
	
	'Response.Write("<br> Transaccion 3:"&conexion.ObtenerEstadoTransaccion)	
	'********************************************************************************************
					if v_nuevo_numero<>"null"  then
						' Actualiza el numero de boleta
						v_nuevo_numero=Clng(v_nuevo_numero) + 1
						sql_actualiza_numero=" Update rangos_facturas_cajeros set rfca_nactual="&v_nuevo_numero&"  "& vbCrLf &_ 
												" where pers_ncorr in (select top 1 pers_ncorr from personas where pers_nrut='"&usuario&"') "& vbCrLf &_ 
												" and tfac_ccod="&v_tfac_ccod&" "& vbCrLf &_ 
												" and sede_ccod="&sede_ccod&" "& vbCrLf &_ 
												" and inst_ccod="&v_inst_ccod&" "& vbCrLf &_ 
												" and erfa_ccod=1"
						'response.Write("<pre>"&sql_actualiza_numero&"</pre>")											
						conexion.EjecutaS(sql_actualiza_numero)
					end if			
					
				end if
	'********************************************************************************************
			else
				conexion.EstadoTransaccion false
				session("mensajeError")="el numero de factura ingresado, no esta dentro del rango permitido para su sede."	
				response.Redirect(Request.ServerVariables("HTTP_REFERER"))
			end if
		else
			conexion.EstadoTransaccion false
			session("mensajeError")="El tipo de factura que desea anular, no ha sido asociada al cajero."	
			response.Redirect(Request.ServerVariables("HTTP_REFERER"))
		end if											
   end if
next

'Response.Write("<br> Transaccion 4:"&conexion.ObtenerEstadoTransaccion)	

formulario.MantieneTablas false
'Response.Write("<br> Transaccion :"&conexion.ObtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'Response.End()

if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="Las Facturas selecionados fueron guardadas correctamente "
else
	session("mensajeError")="Ocurrio un error al intentar actualizar una o mas Facturas.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
'response.End()
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>