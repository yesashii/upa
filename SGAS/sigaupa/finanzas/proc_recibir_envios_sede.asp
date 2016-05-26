<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new Cnegocio
negocio.Inicializa conexion
'---------------------------------------------------------------------
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "parametros.xml", "tabla"
f_consulta.Inicializar conexion

audi_tusuario = negocio.ObtenerUsuario

'---------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "envios_sedes.xml", "f_enviar"
formulario.Inicializar conexion
formulario.ProcesaForm
formulario.AgregaCampoPost "eenv_ccod" , 6
'eenv_ccod=6 Recibido

'ACTUALIZA LOS DETALLES DEL INGRESO A 'RECIBIDO'

for fila = 0 to formulario.CuentaPost - 1
   envio = formulario.ObtenerValorPost (fila, "esed_ncorr")
   if envio <> "" then
      SQL = " select count(a.esed_ncorr) as total_doc, a.sede_destino "& vbCrLf &_
			"  from envios_sedes a,  detalle_envios_sedes b where a.esed_ncorr = b.esed_ncorr "& vbCrLf &_
            " and a.esed_ncorr =" & envio &" "& vbCrLf &_
			" group by a.sede_destino"
'response.Write("<pre>"&SQL&"</pre>")
	  f_consulta.consultar  SQL
	  f_consulta.siguiente
	  cantidad = f_consulta.ObtenerValor("total_doc") 
	  sede_destino = f_consulta.ObtenerValor("sede_destino") 

      if cantidad <> 0 then
	     consulta = "UPDATE detalle_ingresos SET sede_actual = "&sede_destino&", AUDI_TUSUARIO='" & audi_tusuario  & "', audi_fmodificacion = getdate()  WHERE esed_ncorr='" & envio & "'"
         conexion.EstadoTransaccion conexion.EjecutaS(consulta)	
	     'consulta = "UPDATE detalle_envios SET edin_ccod = 2, AUDI_TUSUARIO='" & audi_tusuario  & "', audi_fmodificacion = getdate()  WHERE esed_ncorr='" & envio & "'"
         'conexion.EstadoTransaccion conexion.EjecutaS(consulta)			
	  else
	     formulario.EliminaFilaPost fila
	  end if
   end if 
next

formulario.MantieneTablas false
'conexion.estadotransaccion false  'roolback  
response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
