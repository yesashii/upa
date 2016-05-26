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


v_duplica=request.Form("duplica")

set formulario = new CFormulario
formulario.Carga_Parametros "notacredito.xml", "f_notacredito"
formulario.Inicializar conexion
formulario.ProcesaForm		

for fila = 0 to formulario.CuentaPost - 1
   v_ndcr_ncorr			= formulario.ObtenerValorPost (fila, "ndcr_ncorr")
   v_ndcr_nnota_credito	= formulario.ObtenerValorPost (fila, "ndcr_nnota_credito")
   v_encr_ccod			= formulario.ObtenerValorPost (fila, "encr_ccod")
'response.Write("codigo: "&v_ndcr_ncorr)
'response.Write("Numero: "&v_ndcr_nnota_credito&"<hr>")
   if v_ndcr_ncorr <> "" and v_ndcr_nnota_credito <> "" then
		
		formulario.AgregaCampoFilaPost fila, "encr_ccod", "3"
		
		sql_consulta_rango 	=	"Select count(*) as pertenece "& vbCrLf &_ 
								" from rangos_notas_credito_sedes "& vbCrLf &_ 
								" where sede_ccod="&sede_ccod&" "& vbCrLf &_ 
								" and "&v_ndcr_nnota_credito&" between rncr_ninicio and rncr_nfin "& vbCrLf &_
								" order by pertenece "
'response.End()	
		v_pertenece_rango	=	conexion.consultaUno(sql_consulta_rango)
		
		v_pertenece_rango="1" 		' modificado por el constante movimiento de cajeros	
		if v_pertenece_rango = "1" then
			sql_nc_existe=	"select count(ndcr_nnota_credito) from notas_de_credito where sede_ccod="&sede_ccod&" and ndcr_nnota_credito="&v_ndcr_nnota_credito&" And ndcr_ncorr <> "&v_ndcr_ncorr
			v_nc_existe	=	conexion.consultaUno(sql_nc_existe)
			'response.Write("<hr>"&sql_boleta_existe&"<hr>")
			
			if v_nc_existe >="1" then
					'response.Write("<hr>entre<hr>")
					conexion.EstadoTransaccion false
					session("mensajeError")="el numero ingresado para la Nota de Credito ya existe"
					response.Redirect(Request.ServerVariables("HTTP_REFERER"))
			end if

			
			if v_encr_ccod<>"4" and v_duplica = "SI" then
				
				v_nuevo_ndcr_ncorr = conexion.ConsultaUno("execute obtenersecuencia 'notas_credito'")  

					  
'********************************************************************************************			
'  Obtiene el numero actual de la boleta, para asignarla al nuevo registro
						sql_nuevo_numero="  select isnull(rncc_nactual,rncc_ninicio) as num "& vbCrLf &_ 
										" from rangos_notas_credito_cajeros "& vbCrLf &_ 
										" where pers_ncorr in (select top 1 pers_ncorr from personas where pers_nrut='"&usuario&"') "& vbCrLf &_ 
										" and sede_ccod="&sede_ccod&" "& vbCrLf &_ 
										" and ernc_ccod=1"
					
						v_nuevo_numero=conexion.ConsultaUno(sql_nuevo_numero)

						if Esvacio(v_nuevo_numero) then
							v_nuevo_numero="null"
						end if

'********************************************************************************************			
'  Inserta nuevo registro para una factura

					
					sql_inserta_nc= "Insert into notas_de_credito  "& vbCrLf &_ 
							"select  "&v_nuevo_ndcr_ncorr&" as ndcr_ncorr,"&v_nuevo_numero&" as ndcr_nnota_credito,encr_ccod,ndcr_mtotal,ndcr_miva, "& vbCrLf &_ 
							"ndcr_fnota_credito,ingr_nfolio_referencia,,sede_ccod pers_ncorr, pers_ncorr_aval,mcaj_ncorr,"& vbCrLf &_ 
							"audi_tusuario,audi_fmodificacion from notas_de_credito where ndcr_ncorr="&v_ndcr_ncorr

					'response.Write("<pre>"&sql_inserta_factura&"</pre>")
					conexion.EjecutaS(sql_inserta_nc)

					' inserta detalle
					sql_inserta_detalle_nc= "Insert into detalle_notas_de_credito  "& vbCrLf &_ 
												"select  "&v_nuevo_ndcr_ncorr&" as ndcr_ncorr,comp_ndocto,tcom_ccod,inst_ccod,dco_ncompromiso,dncr_mdetalle,"& vbCrLf &_ 
												"audi_tusuario,audi_fmodificacion from detalle_notas_de_credito where ndcr_ncorr="&v_ndcr_ncorr
			
					'response.Write("<pre>"&sql_inserta_detalle_factura&"</pre>")
					conexion.EjecutaS(sql_inserta_detalle_nc)


'********************************************************************************************
				if v_nuevo_numero<>"null"  then
					' Actualiza el numero de boleta
					v_nuevo_numero=Clng(v_nuevo_numero) + 1
					sql_actualiza_numero=" Update rangos_notas_credito_cajeros set rncc_nactual="&v_nuevo_numero&"  "& vbCrLf &_ 
											" where pers_ncorr in (select top 1 pers_ncorr from personas where pers_nrut='"&usuario&"') "& vbCrLf &_ 
											" and sede_ccod="&sede_ccod&" "& vbCrLf &_ 
											" and ernc_ccod=1"
					'response.Write("<pre>"&sql_actualiza_numero&"</pre>")											
					conexion.EjecutaS(sql_actualiza_numero)
				end if			
				
			end if
'********************************************************************************************
		else
			conexion.EstadoTransaccion false
			session("mensajeError")="el numero de nota de credito ingresado, no esta dentro del rango permitido para su sede."	
			response.Redirect(Request.ServerVariables("HTTP_REFERER"))
		end if
											
   end if
next

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