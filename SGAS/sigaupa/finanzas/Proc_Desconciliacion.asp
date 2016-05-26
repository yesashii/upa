<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario = negocio.ObtenerUsuario()
'---------------------------------------------------------------------

set f_compromisos = new CFormulario
f_compromisos.Carga_Parametros "desconciliacion.xml", "tabla"

set f_documentos = new CFormulario
f_documentos.Carga_Parametros "desconciliacion.xml", "tabla"

set f_doctos_ingr = new CFormulario
f_doctos_ingr.Carga_Parametros "desconciliacion.xml", "tabla"
'---------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "desconciliacion.xml", "f_cheques"
formulario.Inicializar conexion
formulario.ProcesaForm



'formulario.listarpost
'response.End()

for fila = 0 to formulario.CuentaPost - 1
   tipo_ingreso =   formulario.ObtenerValorPost (fila, "ting_ccod")
   num_doc = formulario.ObtenerValorPost (fila, "ding_ndocto")
   banco   = formulario.ObtenerValorPost (fila, "banc_ccod")
   cuenta = formulario.ObtenerValorPost (fila, "ding_tcuenta_corriente")

   if esVacio(num_doc) = false then
	
	   '-------------- BUSCO HERMANOS DEL DOCUMENTO -------------------
		 sql = " select a.ding_nsecuencia " & vbCrLf  &_
				" from detalle_ingresos a, ingresos b, abonos c "& vbCrLf  &_ 
				" where a.ingr_ncorr = b.ingr_ncorr "& vbCrLf  &_ 
				"  and b.ingr_ncorr = c.ingr_ncorr   "& vbCrLf  &_ 
				"  and a.ding_ncorrelativo > 0   "& vbCrLf  &_ 
				"  and cast(a.ting_ccod as varchar)= '" & tipo_ingreso & "'  "& vbCrLf  &_ 
				"  and a.edin_ccod ='6' "& vbCrLf  &_ 
             	"  and cast(a.ding_ndocto as varchar)= '" & num_doc & "' "& vbCrLf  &_ 
             	"  and cast(a.banc_ccod as varchar)= '" & banco & "' "& vbCrLf  &_ 
             	"  and isnull(ding_tcuenta_corriente, ' ') = isnull('" & cuenta & "', ' ') "& vbCrLf &_ 
				"  and b.eing_ccod not in (3,6)" & vbCrLf
	   
	   'response.Write("<PRE>" & sql & "<PRE><BR><BR>")
	   f_documentos.Inicializar conexion
	   f_documentos.consultar sql
       'response.Write("<br><b>estado : " & conexion.ObtenerEstadoTRansaccion & "</b>")   	   
	   '--------- POR CADA HERMANO DEL DOCUMENTO -------
	   while	f_documentos.Siguiente    
	   			sql_det_conciliacion = " select a.ingr_ncorr from ingresos a, detalle_ingresos b, abonos c " & vbcrlf & _
    							   " where b.ding_ndocto ='"&f_documentos.obtenervalor("ding_nsecuencia")&"' " & vbcrlf & _
    							   " and b.ting_ccod='8' " & vbcrlf & _
							       " and b.edin_ccod='16' " & vbcrlf & _
    							   " and a.ingr_ncorr=b.ingr_ncorr " & vbcrlf & _
								   " and c.ingr_ncorr=b.ingr_ncorr " & vbcrlf 
				'response.Write("<pre>" & sql_det_conciliacion & "</pre>")
				f_doctos_ingr.Inicializar conexion
				f_doctos_ingr.consultar sql_det_conciliacion
				While	f_doctos_ingr.Siguiente
						' borrar abonos de la conciliacion
						sql = "Delete from abonos where ingr_ncorr='" & f_doctos_ingr.obtenervalor("ingr_ncorr") & "' "
						conexion.EstadoTransaccion conexion.EjecutaS(sql)						
						'response.Write("<pre>" & sql & "</pre>")
						' borrar abonos de la conciliacion
						sql = "Delete from detalle_ingresos where ingr_ncorr='" & f_doctos_ingr.obtenervalor("ingr_ncorr") & "' "
						conexion.EstadoTransaccion conexion.EjecutaS(sql)						
						'response.Write("<pre>" & sql & "</pre>")
						' borrar abonos de la conciliacion
						sql = "Delete from ingresos where ingr_ncorr='" & f_doctos_ingr.obtenervalor("ingr_ncorr") & "' "
						conexion.EstadoTransaccion conexion.EjecutaS(sql)						
						'response.Write("<pre>" & sql & "</pre>")
						'response.Write("Transaccion:" & conexion.ObtenerEstadoTRansaccion)
				wend	  
	   wend  ' FIN DE WHILE HERMANOS
	   sql = " Update detalle_ingresos set edin_ccod=1 where ting_ccod='" & tipo_ingreso & "' and cast(ding_ndocto as varchar)= '" & num_doc & "' "& vbCrLf  &_ 
   			 "  and cast(banc_ccod as varchar)= '" & banco & "' "& vbCrLf  &_ 
           	 "  and isnull(ding_tcuenta_corriente, ' ') = isnull('" & cuenta & "', ' ') "& vbCrLf 
	   conexion.EstadoTransaccion conexion.EjecutaS(sql)	
	   'response.Write("Transaccion:" & conexion.ObtenerEstadoTRansaccion)					
  else
     formulario.EliminaFilaPost fila    
  end if 
next
'formulario.ListarPost

'conexion.estadotransaccion false     'roolback  
'response.End()

if conexion.ObtenerEstadoTRansaccion then
	session("mensaje_error")="El documento fue desconciliado correctamente"
else
	session("mensaje_error")="Ocurrio un error al intentar desconciliar el cheque, vuelva a intentarlo."
end if
'f_documentos.MantieneTablas true
'formulario.MantieneTablas true
'f_compromisos.MantieneTablas true
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>