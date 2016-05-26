<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

folio=request.QueryString("folio_envio")
set negocio = new CNegocio
negocio.Inicializa conexion

set cajero = new CCajero
cajero.inicializar conexion, negocio.obtenerUsuario, negocio.obtenerSede

'---------------------------------------------------------------------
caja_abierta = cajero.obtenerCajaAbierta
'response.Write("caja:"&caja_abierta)
usuario = negocio.ObtenerUsuario()
'---------------------------------------------------------------------


'-----------------------------------------------------------------------------
set f_documentos = new CFormulario
f_documentos.Carga_Parametros "parametros.xml", "tabla"

set formulario = new CFormulario
formulario.Carga_Parametros "consulta.xml", "consulta"
'-----------------------------------------------------------------------------		 
set f_formulario = new CFormulario
f_formulario.Carga_Parametros "Depositos.xml", "f_depositar"
f_formulario.Inicializar conexion
f_formulario.ProcesaForm


for fila = 0 to f_formulario.CuentaPost - 1
   envio = f_formulario.ObtenerValorPost (fila, "envi_ncorr")
   v_estado_envio = f_formulario.ObtenerValorPost (fila, "eenv_ccod")
	if envio <> "" and v_estado_envio=2 then
	 'response.Write("<hr>"&v_estado_envio&"<->"&envio&"<hr>")	
	
		consulta = "select  c.ingr_ncorr,c.ting_ccod,c.ding_ndocto,g.banc_ccod,c.ding_tcuenta_corriente  " & vbCrLf &_
				" from envios a,detalle_envios b,detalle_ingresos c, " & vbCrLf &_
				" ingresos d,estados_detalle_ingresos c1,bancos g " & vbCrLf &_
				" where a.envi_ncorr = b.envi_ncorr " & vbCrLf &_
				" and b.ting_ccod = c.ting_ccod   " & vbCrLf &_
				" and b.ding_ndocto = c.ding_ndocto   " & vbCrLf &_
				" and b.ingr_ncorr = c.ingr_ncorr " & vbCrLf &_
				" and c.ingr_ncorr = d.ingr_ncorr   " & vbCrLf &_
				" and b.edin_ccod = c1.edin_ccod " & vbCrLf &_
				" and c.banc_ccod *= g.banc_ccod " & vbCrLf &_
				" and c.DING_NCORRELATIVO > 0 " & vbCrLf &_
				" and a.envi_ncorr="&envio
				
			formulario.Inicializar conexion
			formulario.consultar consulta

 
		while formulario.siguiente
		   
		   tipo_ingreso =   formulario.ObtenerValor("ting_ccod")
		   num_doc = formulario.ObtenerValor("ding_ndocto")
		   banco   = formulario.ObtenerValor("banc_ccod")
		   cuenta = formulario.ObtenerValor("ding_tcuenta_corriente")
		   
		   v_ingr_ncorr   	= 	formulario.ObtenerValor("ingr_ncorr")
		   v_cuenta 		= 	formulario.ObtenerValor("ding_tcuenta_corriente")
		
		   
		   v_cajero  = caja_abierta
		   if v_cajero="" then
				v_cajero=0
		   end if
		  ' response.Write("<br>tipo_ingreso "&tipo_ingreso&" num_doc "&num_doc&" banco "&banco&" cuenta "& cuenta &" cajero "&cajero)
		   
		   if esVacio(num_doc) = false then
		
		   nuevo_folio_referencia = conexion.ConsultaUno("execute obtenersecuencia 'ingresos_referencia'")
		 
			   '---------------- ACTUALIZAR ESTADO DETALLE_INGRESOS = 6 -----------------
			   sql_update = "UPDATE detalle_ingresos "& vbCrLf  &_ 
					 "SET edin_ccod = 6, "& vbCrLf  &_ 
					 "    audi_tusuario = '" & usuario & "', "& vbCrLf  &_ 
					 "    audi_fmodificacion = getdate() "& vbCrLf  &_ 
					 "WHERE ingr_ncorr = "&v_ingr_ncorr 
			 conexion.EstadoTransaccion conexion.EjecutaS(sql_update)
			   
			   '-------------- BUSCO HERMANOS DEL DOCUMENTO -------------------
			
				 sql_datos = " select a.ding_tcuenta_corriente, a.ding_nsecuencia, a.ding_ncorrelativo, c.tcom_ccod, c.inst_ccod,"& vbCrLf  &_
					" c.comp_ndocto, c.dcom_ncompromiso, c.abon_mabono, c.pers_ncorr, c.peri_ccod, isnull(b.inem_ccod,0) as inem_ccod "& vbCrLf  &_  
					" from detalle_ingresos a, ingresos b, abonos c "& vbCrLf  &_ 
					" where a.ingr_ncorr = b.ingr_ncorr "& vbCrLf  &_ 
					"  and b.ingr_ncorr = c.ingr_ncorr   "& vbCrLf  &_ 
					"  and a.ingr_ncorr ="& v_ingr_ncorr			

					f_documentos.Inicializar conexion
					f_documentos.consultar sql_datos
		 
			   '--------- POR CADA HERMANO DEL DOCUMENTO -------
			while f_documentos.Siguiente       
			'---------------- NUEVO INGR_NCORR -------------------
			 nuevo_ingr_ncorr = conexion.ConsultaUno("execute obtenersecuencia 'ingresos'")
				  '------------------------------------------------------------------		  
				   sql = "INSERT INTO ingresos(ingr_ncorr, mcaj_ncorr, eing_ccod, ingr_fpago, ingr_mdocto, ingr_mtotal, ingr_nestado, ingr_nfolio_referencia, ting_ccod, inst_ccod, pers_ncorr,  inem_ccod, audi_tusuario, audi_fmodificacion) "& vbCrLf  &_  
						 "(SELECT " & nuevo_ingr_ncorr & ",'" & v_cajero & "' ,1 , getdate() ,'" &  f_documentos.obtenervalor("abon_mabono") & "','" & f_documentos.obtenervalor("abon_mabono") & "','1'," & nuevo_folio_referencia  & ", 8, '" & f_documentos.obtenervalor("inst_ccod") & "','" & f_documentos.obtenervalor("pers_ncorr") & "','" & f_documentos.obtenervalor("inem_ccod") & "'," & usuario & ", getdate())"& vbCrLf
			
						'response.Write("<br><pre>"&sql&"</pre>")
						conexion.EstadoTransaccion conexion.EjecutaS(sql)						
													
				   sql = "INSERT INTO abonos (ingr_ncorr, tcom_ccod, inst_ccod, comp_ndocto, dcom_ncompromiso, abon_fabono, abon_mabono, pers_ncorr, peri_ccod, inem_ccod, audi_tusuario, audi_fmodificacion) "& vbCrLf &_
						  "(SELECT " & nuevo_ingr_ncorr & ",'" & f_documentos.obtenervalor("tcom_ccod") & "','" & f_documentos.obtenervalor("inst_ccod")  & "','" & f_documentos.obtenervalor("comp_ndocto")  & "','"& f_documentos.obtenervalor("dcom_ncompromiso") & "', getdate() ,'" &  f_documentos.obtenervalor("abon_mabono") & "','" & f_documentos.obtenervalor("pers_ncorr") & "','" & f_documentos.obtenervalor("peri_ccod") & "','" & f_documentos.obtenervalor("inem_ccod") & "','" & usuario & "', getdate())"& vbCrLf
						'response.Write("<br><pre>"&sql&"</pre>")		
						conexion.EstadoTransaccion conexion.EjecutaS(sql)
					
					ding_nsecuencia = conexion.ConsultaUno("execute obtenersecuencia 'detalle_ingresos'")
					sql = "INSERT INTO detalle_ingresos (ingr_ncorr, ting_ccod, ding_ndocto, ding_nsecuencia, ding_ncorrelativo, ding_fdocto, ding_mdetalle, ding_mdocto, ding_tcuenta_corriente, edin_ccod, audi_tusuario, audi_fmodificacion) "& vbCrLf &_
						   "(SELECT " & nuevo_ingr_ncorr & ", 8, '" & f_documentos.obtenervalor("ding_nsecuencia") & "', "&ding_nsecuencia&",'" & f_documentos.obtenervalor("ding_ncorrelativo") & "', getdate() ,'" &  f_documentos.obtenervalor("abon_mabono") & "','" & f_documentos.obtenervalor("abon_mabono") & "','" & cuenta & "', 16 ," & usuario & ", getdate())"& vbCrLf
						'response.Write("<br><pre>"&sql&"</pre>")						   
						conexion.EstadoTransaccion conexion.EjecutaS(sql) 
				
			  wend  ' FIN DE WHILE HERMANOS
			   consulta_estado = "UPDATE detalle_envios SET edin_ccod = 6, AUDI_TUSUARIO='" & audi_tusuario  & "', audi_fmodificacion = getdate()  WHERE envi_ncorr='" & envio & "'"
			   conexion.EstadoTransaccion conexion.EjecutaS(consulta_estado)

		  end if 
		  
		wend
		'response.Write("<br><b>estado : " & conexion.ObtenerEstadoTRansaccion & "</b>") 
   end if 
next

f_formulario.AgregaCampoPost "eenv_ccod" , 4
f_formulario.MantieneTablas FALSE

if conexion.ObtenerEstadoTransaccion then
	session("mensaje_error")="Los documentos fueron conciliados correctamente"
else
	session("mensaje_error")="Ocurrio un error al intentar conciliar los documentos, vuelva a intentarlo."
end if

'response.Write("<br><b>estado : " & conexion.ObtenerEstadoTransaccion & "</b>")  
'conexion.EstadoTransaccion false
'response.End()
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
