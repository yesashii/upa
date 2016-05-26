<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

'conexion.EstadoTransaccion false

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
Usuario = negocio.ObtenerUsuario
Sede = negocio.ObtenerSede
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
msj_error=""

set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede
v_mcaj_ncorr = CStr(cajero.ObtenerCajaAbierta)



v_fecha_actual = conexion.ConsultaUno("select protic.trunc(getdate()) as fecha")

'---------------------------------------------------------------------
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "parametros.xml", "tabla"
'---------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "Ingreso_Protestos.xml", "f_documentos"
formulario.Inicializar conexion
formulario.ProcesaForm

'formulario.AgregaCampoPost "edin_ccod", 6 ' se da por pagado el cheque 
formulario.AgregaCampoPost "tcom_ccod", 5
formulario.AgregaCampoPost "ecom_ccod", 1
formulario.AgregaCampoPost "comp_fdocto", date
formulario.AgregaCampoPost "comp_ncuotas", 1
formulario.AgregaCampoPost "sede_ccod", Sede
formulario.AgregaCampoPost "dcom_fcompromiso", date
formulario.AgregaCampoPost "dcom_ncompromiso", 1
'formulario.AgregaCampoPost "peri_ccod", Periodo
formulario.AgregaCampoPost "deta_ncantidad", 1
formulario.AgregaCampoPost "inst_ccod", 1

'formulario.ListarPost



set f_detalle_cheque_protestado = new CFormulario
f_detalle_cheque_protestado.Carga_Parametros "Ingreso_Protestos.xml", "detalle_cheque_protestado"
f_detalle_cheque_protestado.Inicializar conexion
f_detalle_cheque_protestado.ProcesaForm

set f_abono_cheque_protestado = new CFormulario
f_abono_cheque_protestado.Carga_Parametros "Ingreso_Protestos.xml", "abono_cheque_protestado"
f_abono_cheque_protestado.Inicializar conexion
f_abono_cheque_protestado.ProcesaForm

set f_detalle_abono_cheque_protestado = new CFormulario
f_detalle_abono_cheque_protestado.Carga_Parametros "Ingreso_Protestos.xml", "detalle_abono_cheque_protestado"
f_detalle_abono_cheque_protestado.Inicializar conexion
f_detalle_abono_cheque_protestado.ProcesaForm



for fila = 0 to formulario.CuentaPost - 1
'Response.Write("Fila: "&fila)
   num_doc = formulario.ObtenerValorPost (fila, "ding_ndocto")
   ting_ccod  = formulario.ObtenerValorPost (fila, "ting_ccod")
   num_secuencia = formulario.ObtenerValorPost (fila, "ding_nsecuencia")
   pers_ncorr = formulario.ObtenerValorPost (fila, "pers_ncorr")
   valor_multa = formulario.ObtenerValorPost (fila, "multa")   
   
   v_ding_bpacta_cuota = formulario.ObtenerValorPost (fila, "ding_bpacta_cuota")
   
   
  ' response.Write(inst_ccod_ref & " " & tcom_ccod_ref  & " " & comp_ndocto_ref & "<BR><BR>")
   if num_doc = "" or esVacio(num_doc)  then

     formulario.EliminaFilaPost fila	 
	 

	 f_abono_cheque_protestado.EliminaFilaPost fila
	 f_detalle_abono_cheque_protestado.EliminaFilaPost fila
	 
   else
       if valor_multa = "0" or  valor_multa = "" then
	      valor_multa = "0"
		  formulario.AgregaCampoFilaPost fila, "tcom_ccod", ""       'para que no haga el cargo por la multa x cero pesos
	   end if	  
	   
	    
	      
	   reca_ncorr = conexion.ConsultaUno("execute obtenersecuencia 'referencias_cargos'")
	  
	   formulario.AgregaCampofilaPost fila, "comp_ndocto", reca_ncorr
	  
	   if ting_ccod = 3 or ting_ccod=38 or ting_ccod=88 then
         formulario.AgregaCampoFilaPost fila, "tdet_ccod", 12
		 formulario.AgregaCampoFilaPost fila, "edin_ccod", 6 'se da por pagado el cheque o cheque protestado
	   else
	     formulario.AgregaCampoFilaPost fila, "tdet_ccod", 13
		 formulario.AgregaCampoFilaPost fila, "edin_ccod", 9 ' protesto (para letras)
	   end if
	   
       formulario.AgregaCampoFilaPost fila, "pers_ncorr", pers_ncorr
       formulario.AgregaCampoFilaPost fila, "comp_mneto", valor_multa
       formulario.AgregaCampoFilaPost fila, "comp_mdocumento", valor_multa 
	   formulario.AgregaCampoFilaPost fila, "dcom_mneto", valor_multa 
	   formulario.AgregaCampoFilaPost fila, "dcom_mcompromiso", valor_multa 
	   formulario.AgregaCampoFilaPost fila, "deta_mvalor_unitario", valor_multa 
	   formulario.AgregaCampoFilaPost fila, "deta_mvalor_detalle", valor_multa 
	   formulario.AgregaCampoFilaPost fila, "deta_msubtotal", valor_multa 

   	   formulario.AgregaCampoFilaPost fila, "reca_ncorr", reca_ncorr
	   formulario.AgregaCampoFilaPost fila, "reca_mmonto", valor_multa


	   if ting_ccod = "3" or ting_ccod = "38" or ting_ccod = "88" then

				if EsVacio(v_mcaj_ncorr) then
				
					conexion.EstadoTransaccion false
					msj_error = msj_error & "- Para protestar el cheque Nº " & num_doc & " debe tener una caja abierta.\n"
					
				end if				
			' obtiene cuenta corriente
			sql_cuenta_corriente="select top 1 ding_tcuenta_corriente from detalle_ingresos where cast(ding_nsecuencia as varchar)='"&num_secuencia&"'"
			v_cuenta_corriente=conexion.consultaUno(sql_cuenta_corriente)
			' obtiene banco
			sql_banco="select top 1 banc_ccod from detalle_ingresos where cast(ding_nsecuencia as varchar)='"&num_secuencia&"'"
			v_banco=conexion.consultaUno(sql_banco)

'response.write("<hr> antes protesto: "&conexion.ObtenerEstadoTransaccion)			
			sql_crea_compromisos="exec PROTESTO_CHEQUE "&ting_ccod&","&num_doc&","&v_banco&" ,'"&v_cuenta_corriente&"',"&v_mcaj_ncorr&","&Periodo&",'"&Usuario&"'"
			conexion.EjecutaP(sql_crea_compromisos)			
'conexion.EstadoTransaccion conexion.EjecutaS(sql_crea_compromisos)
		'response.Write("<pre>"&sql_crea_compromisos&"</pre>")
'response.write("<hr> despues protesto: "&conexion.ObtenerEstadoTransaccion)
				'--------------------------------------------------------------------------------------------------------
				'-------- Abonar para saldar el cargo por el cheque protestado  -----------------------------------------
				consulta = "select a.ding_mdocto, a.ding_mdetalle, b.ingr_mtotal, c.tcom_ccod, c.inst_ccod, c.comp_ndocto, c.dcom_ncompromiso, c.abon_mabono, a.ingr_ncorr, a.ding_ndocto, a.ting_ccod " & vbCrLf &_
				           "from detalle_ingresos a, ingresos b, abonos c, " & vbCrLf &_
						   "     detalle_ingresos d " & vbCrLf &_
						   "where a.ingr_ncorr = b.ingr_ncorr " & vbCrLf &_
						   "   and b.eing_ccod not in (3,6) "& vbCrLf &_
						   "  and b.ingr_ncorr = c.ingr_ncorr " & vbCrLf &_
						   "  and a.ding_ndocto = d.ding_ndocto " & vbCrLf &_
						   "  and a.banc_ccod = d.banc_ccod " & vbCrLf &_
						   "  and a.ting_ccod = d.ting_ccod " & vbCrLf &_
						   "  and isnull(a.ding_tcuenta_corriente, ' ') = isnull(d.ding_tcuenta_corriente, ' ') " & vbCrLf &_
						   "  and a.audi_tusuario not like '%Protesto_Cheque%' "& vbCrLf &_
						   "  and d.ding_nsecuencia = '" & num_secuencia & "'"
				
				'response.Write("<pre>"&consulta&"</pre>")
						   
				f_consulta.Inicializar conexion
				f_consulta.Consultar consulta
				
				i_ = 0
				while f_consulta.Siguiente
					if i_ > 0 then
						v_fila = f_abono_cheque_protestado.ClonaFilaPost(fila)
						f_detalle_abono_cheque_protestado.ClonaFilaPost(fila)
					else
						v_fila = fila
					end if
					
					v_ingr_ncorr = conexion.ConsultaUno("execute obtenersecuencia 'ingresos'")
					v_ding_nsecuencia = conexion.ConsultaUno("execute obtenersecuencia 'detalle_ingresos'")
					v_ingr_nfolio_referencia = conexion.ConsultaUno("execute obtenersecuencia 'ingresos_referencia'")
					v_monto_abono = CLng(f_consulta.ObtenerValor("abon_mabono"))
					
				   '###################################################
				   '****		Datos  para la Tabla Ingresos  	   ****
				   '###################################################						
					f_abono_cheque_protestado.AgregaCampoFilaPost v_fila, "ingr_ncorr", v_ingr_ncorr
					f_abono_cheque_protestado.AgregaCampoFilaPost v_fila, "mcaj_ncorr", v_mcaj_ncorr
					f_abono_cheque_protestado.AgregaCampoFilaPost v_fila, "eing_ccod", "1"
					f_abono_cheque_protestado.AgregaCampoFilaPost v_fila, "ingr_fpago", v_fecha_actual
					f_abono_cheque_protestado.AgregaCampoFilaPost v_fila, "ingr_mefectivo", "0"
					f_abono_cheque_protestado.AgregaCampoFilaPost v_fila, "ingr_mdocto", v_monto_abono
					f_abono_cheque_protestado.AgregaCampoFilaPost v_fila, "ingr_mtotal", v_monto_abono
					f_abono_cheque_protestado.AgregaCampoFilaPost v_fila, "ingr_nfolio_referencia", v_ingr_nfolio_referencia
					f_abono_cheque_protestado.AgregaCampoFilaPost v_fila, "ting_ccod", "39"

				   '###################################################
				   '****	Datos necesarios para la Tabla Abonos  ****
				   '###################################################												
					f_abono_cheque_protestado.AgregaCampoFilaPost v_fila, "tcom_ccod", CInt(f_consulta.ObtenerValor("tcom_ccod"))
					f_abono_cheque_protestado.AgregaCampoFilaPost v_fila, "inst_ccod", CInt(f_consulta.ObtenerValor("inst_ccod"))
					f_abono_cheque_protestado.AgregaCampoFilaPost v_fila, "comp_ndocto", CLng(f_consulta.ObtenerValor("comp_ndocto"))
					f_abono_cheque_protestado.AgregaCampoFilaPost v_fila, "dcom_ncompromiso", CInt(f_consulta.ObtenerValor("dcom_ncompromiso"))
					f_abono_cheque_protestado.AgregaCampoFilaPost v_fila, "abon_fabono", v_fecha_actual
					f_abono_cheque_protestado.AgregaCampoFilaPost v_fila, "abon_mabono", v_monto_abono
					f_abono_cheque_protestado.AgregaCampoFilaPost v_fila, "peri_ccod", Cstr(negocio.ObtenerPeriodoAcademico("POSTULACION"))
					
					
				   '###################################################
				   '****	Datos  para la Tabla Detalle_ingresos  ****
				   '###################################################						
					f_detalle_abono_cheque_protestado.AgregaCampoFilaPost v_fila, "ingr_ncorr", v_ingr_ncorr
					f_detalle_abono_cheque_protestado.AgregaCampoFilaPost v_fila, "ting_ccod", "39"
					f_detalle_abono_cheque_protestado.AgregaCampoFilaPost v_fila, "ding_ndocto", num_doc
					f_detalle_abono_cheque_protestado.AgregaCampoFilaPost v_fila, "ding_nsecuencia", v_ding_nsecuencia
					f_detalle_abono_cheque_protestado.AgregaCampoFilaPost v_fila, "ding_bpacta_cuota", "N"
					f_detalle_abono_cheque_protestado.AgregaCampoFilaPost v_fila, "ding_ncorrelativo", "1"
					f_detalle_abono_cheque_protestado.AgregaCampoFilaPost v_fila, "ding_mdocto", v_monto_abono
					f_detalle_abono_cheque_protestado.AgregaCampoFilaPost v_fila, "ding_mdetalle", v_monto_abono
					f_detalle_abono_cheque_protestado.AgregaCampoFilaPost v_fila, "ding_fdocto", v_fecha_actual
					'f_detalle_abono_cheque_protestado.AgregaCampoFilaPost v_fila, "peri_ccod", negocio.ObtenerPeriodoAcademico("POSTULACION")
'response.write("<hr> while: "&conexion.ObtenerEstadoTransaccion)					
					if f_consulta.ObtenerValor("ting_ccod") = "3" or f_consulta.ObtenerValor("ting_ccod") = "38" then
						sentencia = "update detalle_ingresos set edin_ccod = 6, audi_tusuario = '" & negocio.ObtenerUsuario & "', audi_fmodificacion = getdate() where ingr_ncorr = '" & f_consulta.ObtenerValor("ingr_ncorr") & "' "
						'response.Write("<br>"&sentencia)
						conexion.EstadoTransaccion conexion.EjecutaS(sentencia)
					end if
					
					i_ = i_ + 1
				wend
		  ' end if		   
	  end if
	   
   end if 
next

if msj_error <> "" and  conexion.ObtenerEstadoTransaccion="Falso" then
	session("mensaje_error")="Error:\n"&msj_error
else
	formulario.MantieneTablas false
	'response.write("<hr> formulario: "&conexion.ObtenerEstadoTransaccion)
	f_abono_cheque_protestado.MantieneTablas false
	'response.write("<hr> f_abono_cheque_protestado: "&conexion.ObtenerEstadoTransaccion)
	f_detalle_abono_cheque_protestado.MantieneTablas false
	'response.write("<hr> f_detalle_abono_cheque_protestado: "&conexion.ObtenerEstadoTransaccion)
end if

'response.write("<hr>"&conexion.ObtenerEstadoTransaccion)
'response.Flush()
'conexion.EstadoTransaccion false  'roolback  
'response.End()

'--------------------------------------------------------------------------------------------------------------
response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
