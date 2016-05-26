<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set cajero = new CCajero
cajero.inicializar conexion, negocio.obtenerUsuario, negocio.obtenerSede

'---------------------------------------------------------------------
' asigando tipo de caja: "control interno"
cajero.AsignarTipoCaja "1002"
caja_abierta = cajero.obtenerCajaAbierta

usuario = negocio.ObtenerUsuario()
'---------------------------------------------------------------------
'response.Write("<pre> Usuario: "&usuario&"-> Caja Abierta: "&caja_abierta&"</pre>")
'response.end

set f_compromisos = new CFormulario
f_compromisos.Carga_Parametros "parametros.xml", "tabla"


set f_documentos = new CFormulario
f_documentos.Carga_Parametros "parametros.xml", "tabla"
'---------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "conciliacion.xml", "f_cheques"
formulario.Inicializar conexion
formulario.ProcesaForm



'formulario.listarpost

for fila = 0 to formulario.CuentaPost - 1
   tipo_ingreso =   formulario.ObtenerValorPost (fila, "ting_ccod")
   num_doc = formulario.ObtenerValorPost (fila, "ding_ndocto")
   banco   = formulario.ObtenerValorPost (fila, "banc_ccod")
   cuenta = formulario.ObtenerValorPost (fila, "ding_tcuenta_corriente")

   cajero  = caja_abierta
   
   if esVacio(num_doc) = false then
	
	nuevo_folio_referencia = conexion.ConsultaUno("execute obtenersecuencia 'ingresos_referencia'")
	'response.Write("folio ref: " & nuevo_folio_referencia & "<br><BR>")
    'response.Write("FILA : " & fila &  "  Ndoc: " & num_doc & "  Banco: " & banco &  " cuenta: " & cuenta  & " tipo_ingreso = " & tipo_ingreso & "<BR><BR>")
	
	   '---------------- ACTUALIZAR ESTADO DETALLE_INGRESOS = 6 -----------------
	   sql = "UPDATE detalle_ingresos "& vbCrLf  &_ 
			 "SET edin_ccod = 6, "& vbCrLf  &_ 
			 "    audi_tusuario = '" & usuario & "', "& vbCrLf  &_ 
			 "    audi_fmodificacion = getdate() "& vbCrLf  &_ 
			 "WHERE ding_ncorrelativo > 0   "& vbCrLf  &_ 
			 "  and ting_ccod = '" & tipo_ingreso & "'  "& vbCrLf  &_ 
             "  and ding_ndocto = '" & num_doc & "' "& vbCrLf  &_ 
             "  and banc_ccod = '" & banco & "' "& vbCrLf  &_ 
             "  and isnull(ding_tcuenta_corriente, ' ') = isnull('" & cuenta & "', ' ') "& vbCrLf 

	   'response.Write("<PRE>" & sql & "<PRE><BR><BR>")
	   conexion.EstadoTransaccion conexion.EjecutaS(sql)
	   
	   'response.Write("<br><b>estado : " & conexion.ObtenerEstadoTRansaccion & "</b>")
   
	   '-------------- BUSCO HERMANOS DEL DOCUMENTO -------------------
	
		 sql = " select a.ding_tcuenta_corriente, a.ding_nsecuencia, a.ding_ncorrelativo, c.tcom_ccod, " & vbCrLf  &_
		 		" c.inst_ccod, c.comp_ndocto, c.dcom_ncompromiso, c.abon_mabono, c.pers_ncorr, c.peri_ccod, isnull(b.inem_ccod,0) as inem_ccod "& vbCrLf  &_  
				" from detalle_ingresos a, ingresos b, abonos c "& vbCrLf  &_ 
				" where a.ingr_ncorr = b.ingr_ncorr "& vbCrLf  &_ 
				"  and b.ingr_ncorr = c.ingr_ncorr   "& vbCrLf  &_ 
				"  and a.ding_ncorrelativo > 0   "& vbCrLf  &_ 
				"  and cast(a.ting_ccod as varchar)= '" & tipo_ingreso & "'  "& vbCrLf  &_ 
             	"  and cast(a.ding_ndocto as varchar)= '" & num_doc & "' "& vbCrLf  &_ 
             	"  and cast(a.banc_ccod as varchar)= '" & banco & "' "& vbCrLf  &_ 
             	"  and isnull(ding_tcuenta_corriente, ' ') = isnull('" & cuenta & "', ' ') "& vbCrLf 
	   
	   'response.Write("<PRE>" & sql & "<PRE><BR><BR>")
	   f_documentos.Inicializar conexion
	   f_documentos.consultar sql
       'response.Write("<br><b>estado : " & conexion.ObtenerEstadoTRansaccion & "</b>")   	   
	   '--------- POR CADA HERMANO DEL DOCUMENTO -------
	   while f_documentos.Siguiente    
	  
	     '---------------- NUEVO INGR_NCORR -------------------
					   nuevo_ingr_ncorr = conexion.ConsultaUno("execute obtenersecuencia 'ingresos'")
		  '------------------------------------------------------------------		  
		   sql = "INSERT INTO ingresos(ingr_ncorr, mcaj_ncorr, eing_ccod, ingr_fpago, ingr_mdocto, ingr_mtotal, ingr_nestado, ingr_nfolio_referencia, ting_ccod, inst_ccod, pers_ncorr,  inem_ccod, audi_tusuario, audi_fmodificacion) "& vbCrLf  &_  
							 "(SELECT " & nuevo_ingr_ncorr & ",'" & cajero & "' ,1 , getdate() ,'" &  f_documentos.obtenervalor("abon_mabono") & "','" & f_documentos.obtenervalor("abon_mabono") & "','1'," & nuevo_folio_referencia  & ", 8, '" & f_documentos.obtenervalor("inst_ccod") & "','" & f_documentos.obtenervalor("pers_ncorr") & "','" & f_documentos.obtenervalor("inem_ccod") & "'," & usuario & ", getdate())"& vbCrLf
				
						conexion.EstadoTransaccion conexion.EjecutaS(sql)						
						'response.Write("<BR><BR><PRE>" & sql & "</PRE><BR><BR>")
						'response.Write("<br><b>estado : " & conexion.ObtenerEstadoTRansaccion & "</b>") 
						
		   sql = "INSERT INTO abonos (ingr_ncorr, tcom_ccod, inst_ccod, comp_ndocto, dcom_ncompromiso, abon_fabono, abon_mabono, pers_ncorr, peri_ccod, inem_ccod, audi_tusuario, audi_fmodificacion) "& vbCrLf &_
				      "(SELECT " & nuevo_ingr_ncorr & ",'" & f_documentos.obtenervalor("tcom_ccod") & "','" & f_documentos.obtenervalor("inst_ccod")  & "','" & f_documentos.obtenervalor("comp_ndocto")  & "','"& f_documentos.obtenervalor("dcom_ncompromiso") & "', getdate() ,'" &  f_documentos.obtenervalor("abon_mabono") & "','" & f_documentos.obtenervalor("pers_ncorr") & "','" & f_documentos.obtenervalor("peri_ccod") & "','" & f_documentos.obtenervalor("inem_ccod") & "','" & usuario & "', getdate())"& vbCrLf
			
				conexion.EstadoTransaccion conexion.EjecutaS(sql)
				'response.Write("<BR><BR><PRE>" & sql & "</PRE><BR>")		  
				'response.Write("<br><b>estado : " & conexion.ObtenerEstadoTRansaccion & "</b>")


    			ding_nsecuencia = conexion.ConsultaUno("execute obtenersecuencia 'detalle_ingresos'")
             sql = "INSERT INTO detalle_ingresos (ingr_ncorr, ting_ccod, ding_ndocto, ding_nsecuencia, ding_ncorrelativo, ding_fdocto, ding_mdetalle, ding_mdocto, ding_tcuenta_corriente, edin_ccod, audi_tusuario, audi_fmodificacion) "& vbCrLf &_
							   "(SELECT " & nuevo_ingr_ncorr & ", 8, '" & f_documentos.obtenervalor("ding_nsecuencia") & "', "&ding_nsecuencia&",'" & f_documentos.obtenervalor("ding_ncorrelativo") & "', getdate() ,'" &  f_documentos.obtenervalor("abon_mabono") & "','" & f_documentos.obtenervalor("abon_mabono") & "','" & cuenta & "', 16 ," & usuario & ", getdate())"& vbCrLf
							   
						conexion.EstadoTransaccion conexion.EjecutaS(sql) 
 		                'response.Write("<BR><BR><PRE>" & sql & "</PRE><BR><BR>")	
						'response.Write("<br><b>estado : " & conexion.ObtenerEstadoTRansaccion & "</b>")
		  
		 'response.Write("<HR>")			
	   wend  ' FIN DE WHILE HERMANOS
  else
     formulario.EliminaFilaPost fila    
  end if 
next
'formulario.ListarPost

'conexion.estadotransaccion false     'roolback  
'response.End()

if conexion.ObtenerEstadoTRansaccion then
	session("mensaje_error")="El documento fue conciliado correctamente"
else
	session("mensaje_error")="Ocurrio un error al intentar conciliar el cheque, vuelva a intentarlo."
end if
'f_documentos.MantieneTablas true
'formulario.MantieneTablas true
'f_compromisos.MantieneTablas true
response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
