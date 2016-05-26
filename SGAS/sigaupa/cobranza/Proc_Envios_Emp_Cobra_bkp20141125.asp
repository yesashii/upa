<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO:COBRANZA EXTERNA
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:28/03/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			:93
'*******************************************************************
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new Cnegocio
negocio.Inicializa conexion

set f_consulta = new CFormulario
f_consulta.Carga_Parametros "parametros.xml", "tabla"
f_consulta.Inicializar conexion
'----------------------------------------------------
' contiene los documentos dle envio que son cheques o cheques protestados
set f_documentos = new CFormulario
f_documentos.Carga_Parametros "tabla_vacia.xml", "tabla"
'-----------------------------------------------------------------------
' contiene los hermanos de los documentos que son cheques o cheques protestados
set formulario_origen = new CFormulario
formulario_origen.Carga_Parametros "consulta.xml", "consulta"
'------------------------------------------------------------------------

audi_tusuario = negocio.ObtenerUsuario

set formulario = new CFormulario
formulario.Carga_Parametros "envios_cobranza.xml", "f_enviar"
formulario.Inicializar conexion
formulario.ProcesaForm

'formulario.ListarPost


'ACTUALIZA LOS DETALLES DEL INGRESO A 'EN COBRANZA'
for fila = 0 to formulario.CuentaPost - 1

   envio = formulario.ObtenerValorPost (fila, "envi_ncorr")


   if envio <> "" then
     SQL = "select count(envi_ncorr) as total from detalle_envios where cast(envi_ncorr as varchar)='" & envio &"'"
	 f_consulta.consultar SQL
	 f_consulta.siguiente
	 documentos = f_consulta.ObtenerValor ("total")
	 
	 if documentos > 0 then
   
		  '#####################################################################################################
		  '#################	Marcar todos como depositados. cheque correlativo 1 y sus hermanos    ##########
		  
'		  consulta_origen = "select  c.ingr_ncorr,c.ting_ccod,c.ding_ndocto,g.banc_ccod,c.ding_tcuenta_corriente  " & vbCrLf &_
'							" from envios a,detalle_envios b,detalle_ingresos c, ingresos d,bancos g " & vbCrLf &_
'							" where a.envi_ncorr = b.envi_ncorr " & vbCrLf &_
'							" and b.ting_ccod = c.ting_ccod   " & vbCrLf &_
'							" and b.ding_ndocto = c.ding_ndocto   " & vbCrLf &_
'							" and b.ingr_ncorr = c.ingr_ncorr " & vbCrLf &_
'							" and c.ingr_ncorr = d.ingr_ncorr   " & vbCrLf &_
'							" and c.banc_ccod *= g.banc_ccod " & vbCrLf &_
'							" and c.DING_NCORRELATIVO = 1 " & vbCrLf &_
'							" and c.edin_ccod not in (6) " & vbCrLf &_
'							" and c.ting_ccod in (3,38) " & vbCrLf &_
'							" and a.envi_ncorr="&envio

		  consulta_origen = "select  c.ingr_ncorr,c.ting_ccod,c.ding_ndocto,g.banc_ccod,c.ding_tcuenta_corriente  " & vbCrLf &_
							" from envios a " & vbCrLf &_
							" INNER JOIN detalle_envios b " & vbCrLf &_
							" ON a.envi_ncorr = b.envi_ncorr and a.envi_ncorr = "&envio&" " & vbCrLf &_
							" INNER JOIN detalle_ingresos c " & vbCrLf &_
							" ON b.ting_ccod = c.ting_ccod " & vbCrLf &_
							" and b.ding_ndocto = c.ding_ndocto " & vbCrLf &_
							" and b.ingr_ncorr = c.ingr_ncorr " & vbCrLf &_
							" and c.DING_NCORRELATIVO = 1 " & vbCrLf &_
							" and c.edin_ccod not in (6) " & vbCrLf &_
							" and c.ting_ccod in (3,38) " & vbCrLf &_
							" INNER JOIN ingresos d " & vbCrLf &_
							" ON c.ingr_ncorr = d.ingr_ncorr " & vbCrLf &_
							" LEFT OUTER JOIN bancos g " & vbCrLf &_
							" ON c.banc_ccod = g.banc_ccod "
				
			formulario_origen.Inicializar conexion
			formulario_origen.consultar consulta_origen

 
		while formulario_origen.siguiente
				'response.Write("<br><pre>"&consulta_origen&"</pre>")	

		   tipo_ingreso =   formulario_origen.ObtenerValor("ting_ccod")
		   num_doc 		= 	formulario_origen.ObtenerValor("ding_ndocto")
		   banco   		= 	formulario_origen.ObtenerValor("banc_ccod")
		   cuenta 		= 	formulario_origen.ObtenerValor("ding_tcuenta_corriente")
		   
		   if esVacio(num_doc) = false then
		
			   '-------------- BUSCO HERMANOS DEL DOCUMENTO -------------------
				 sql_datos = " select a.ingr_ncorr,a.ding_tcuenta_corriente, a.ting_ccod, a.ding_ncorrelativo"& vbCrLf  &_
							" from detalle_ingresos a, ingresos b "& vbCrLf  &_ 
							" where a.ingr_ncorr = b.ingr_ncorr "& vbCrLf  &_ 
							"  and a.ding_ncorrelativo > 1   "& vbCrLf  &_ 
							"  and a.edin_ccod not in (6) "& vbCrLf  &_
							"  and a.ting_ccod = '" & tipo_ingreso & "'  "& vbCrLf  &_
							"  and b.eing_ccod not in (3,6) "& vbCrLf  &_ 
							"  and a.ding_ndocto = '" & num_doc & "' "& vbCrLf  &_ 
							"  and ISNULL(cast(a.banc_ccod AS varchar), '') = '" & banco & "' "& vbCrLf  &_ 
							"  and ISNULL(cast(a.ding_tcuenta_corriente AS varchar), '') = '" & cuenta & "'" 			

					f_documentos.Inicializar conexion
					f_documentos.consultar sql_datos
		 
			  '--------- POR CADA HERMANO DEL DOCUMENTO -------
			  while f_documentos.Siguiente       
					'response.Write("<br><pre>"&sql_datos&"</pre>")	
					v_ingreso_hermano=f_documentos.obtenervalor("ingr_ncorr")
					consulta_hmno = "UPDATE detalle_ingresos SET edin_ccod = 10, AUDI_FMODIFICACION = getdate(), AUDI_TUSUARIO='" & audi_tusuario  & "'  WHERE edin_ccod not in (6,10) and cast(ingr_ncorr as varchar)='" & v_ingreso_hermano & "'"
          			'response.Write("<br><pre>"&consulta_hmno&"</pre>")	
					conexion.EstadoTransaccion conexion.EjecutaS(consulta_hmno)
							
			  wend  ' FIN DE WHILE HERMANOS
			
			end if 
			
		 wend 
	  '##############################################################################################
	  '#################	Fin Marcado de hermanos de cheque con correlativo 1     ################# 
	  		
			
		  'formulario.AgregaCampoPost "eenv_ccod" , 2
		   consulta = 	"Update ENVIOS set EENV_CCOD = 2, AUDI_FMODIFICACION = getdate(), AUDI_TUSUARIO='" & audi_tusuario  & "' WHERE cast(envi_ncorr as varchar)='" & envio & "'"
		   'response.Write("<br>"&consulta)
           conexion.EstadoTransaccion conexion.EjecutaS(consulta)
           consulta = "UPDATE detalle_ingresos SET edin_ccod = 10 , AUDI_FMODIFICACION = getdate(), AUDI_TUSUARIO='" & audi_tusuario  & "' WHERE cast(envi_ncorr as varchar)='" & envio & "'"
		   'response.Write("<br>"&consulta)
           conexion.EstadoTransaccion conexion.EjecutaS(consulta)	
	       consulta = 	"UPDATE detalle_envios SET edin_ccod = 10 , AUDI_FMODIFICACION = getdate(), AUDI_TUSUARIO='" & audi_tusuario  & "' WHERE cast(envi_ncorr as varchar)='" & envio & "'"
		   				
		   'response.Write("<br>"&consulta)
           conexion.EstadoTransaccion conexion.EjecutaS(consulta)

	 else
	    cont =cont + 1
        cad = cad & envio & "  "	
	 end if	 	
	 
   end if 

next
  

if cont > 0 then
  mensage = " Los siguientes Envios a Cobranza no se enviaron porque no contenían Documentos Asociados ..." & "\nFolios: " & cad 
  session("mensajeError")= mensage
end if
'formulario.MantieneTablas TRUE
'response.Write("Estado Transaccion: <b>"&conexion.obtenerEstadoTransaccion&"</b>")
'conexion.estadotransaccion false  'roolback  
'response.End()
response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
