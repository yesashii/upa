<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

'for each x in request.Form
'	response.Write("<br>"& x &"->"&request.Form(x))
'next
'response.End()

set conexion = new CConexion
conexion.Inicializar "upacifico"

'conexion.EstadoTransaccion false

set negocio = new CNegocio
negocio.Inicializa conexion

set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede


set f_contratos = new CFormulario
f_contratos.Carga_Parametros "anulacion_contratos.xml", "contratos"
f_contratos.Inicializar conexion
f_contratos.ProcesaForm

msjError = ""
for i_ = 0 to f_contratos.CuentaPost - 1
	v_contrato= f_contratos.ObtenerValorPost(i_, "cont_ncorr")
	
	if v_contrato <> "" then
		

		'###################### ANULA BOLETA ASOCIADA ###############
	
		sql_folio="select  top 1 ingr_nfolio_referencia " & vbCrLf &_
					" from detalle_compromisos a, abonos b, ingresos c " & vbCrLf &_
					" where a.tcom_ccod in (1,2) " & vbCrLf &_
					"  and a.comp_ndocto = " & v_contrato & " " & vbCrLf &_
					"  and a.tcom_ccod = b.tcom_ccod " & vbCrLf &_
					"  and a.inst_ccod = b.inst_ccod " & vbCrLf &_
					"  and a.comp_ndocto = b.comp_ndocto  " & vbCrLf &_
					"  and a.dcom_ncompromiso = b.dcom_ncompromiso " & vbCrLf &_
					"  and b.ingr_ncorr = c.ingr_ncorr " & vbCrLf &_
					"  group by ingr_nfolio_referencia "					
		
		v_folio_referencia=conexion.ConsultaUno(sql_folio)
		'******************************************************************
		'*****chequea si la caja ya esta traspasada a softland  ***********
					sql_traspaso ="select mcaj_btraspasada_softland " & vbCrLf &_
								"	from ingresos a, movimientos_cajas b " & vbCrLf &_
								"	where CAST(a.ingr_nfolio_referencia AS VARCHAR)='" & v_folio_referencia & "'   " & vbCrLf &_                    
								"	and a.mcaj_ncorr=b.mcaj_ncorr " & vbCrLf &_
								"	group by mcaj_btraspasada_softland " 
				v_traspasada=conexion.ConsultaUno(sql_traspaso)
				

				if 	v_traspasada="S" then
						cajero.AsignarTipoCaja "1001"
	
						if not cajero.TieneCajaAbierta then
							conexion.MensajeError "El contrato seleccionado ha sido traspasado a la contabilidad. \nDebe abrir una caja de Anulación de Ingresos para anularlo."
							conexion.EstadoTransaccion false
							Response.Redirect("../lanzadera/lanzadera.asp")
						end if
					v_caja=cajero.ObtenerCajaAbierta	
					v_anular=1 ' asigna a una caja de anulacion de ingresos
				else
					v_anular=2
					if not cajero.TieneCajaAbierta then
						v_caja=0
					else
						v_caja=cajero.ObtenerCajaAbierta
					end if
				end if							
		'******************************************************************
		
		sentencia = "exec anula_contrato " & v_contrato & ", '" & negocio.ObtenerUsuario & "' , " & v_caja & ", " & v_anular & " "
		'response.Write("<br/>"&sentencia&"<br/>")
		v_salida_proc=conexion.ConsultaUno(sentencia)
		
		sql_anula_boleta="Update boletas set ebol_ccod=3, audi_tusuario=cast(audi_tusuario as varchar)+'- anula_contrato' where CAST(ingr_nfolio_referencia AS VARCHAR)="&v_folio_referencia
		conexion.EstadoTransaccion (conexion.ejecutaS(sql_anula_boleta))
	'###################### ANULA BOLETA ASOCIADA ###############
		'response.Write("Entro")
	end if
	
next

'conexion.EstadoTransaccion false
'response.Write("<pre> En pruebas ...</pre>")
'response.End()
if v_salida_proc<>"0" then
	conexion.EstadoTransaccion false
	session("mensaje_error")=" El contrato no puede ser anulado ya que tiene pagos asociados. "
else
	session("mensaje_error")=" El contrato fue anulado correctamente. "
end if

'response.Write("<br> Estado Transaccion <b>"&conexion.obtenerEstadoTransaccion&"</b>")
'conexion.EstadoTransaccion false
'response.End()
'--------------------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>