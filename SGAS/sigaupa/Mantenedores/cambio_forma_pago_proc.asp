<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
	Class controlador_forma_pago
		private isConstructed
		private forma_pago_dao
		
		private sub Class_Initialize
			Set forma_pago_dao = new dao_forma_pago
			construct()
		end sub
		
		public default function construct()
			set construct = me
			isConstructed = true
		end function
	
		public function obtener_datos(folio)
			obtener_datos = forma_pago_dao.obtener_datos(folio)
		end function
		
		public function obtener_forma_pago()
			obtener_forma_pago = forma_pago_dao.obtener_forma_pago()
		end function 
	
		public function obtener_banco()
			obtener_banco = forma_pago_dao.obtener_banco()
		end function
		
		public function obtener_plaza()
			obtener_plaza = forma_pago_dao.obtener_plaza()
		end function
		
		public function actualizar_a_debito(cuenta,banco,fecha,monto, ingreso)
			forma_pago_dao.actualizar_varios 51,cuenta, banco, fecha, monto, ingreso
		end function
		
		public function insertar_a_debito(cuenta,banco,fecha,monto, ingreso)
			forma_pago_dao.insertar_varios 51,cuenta, banco, fecha, monto, ingreso
		end function
		
		public function insertar_a_credito(cuenta,banco,fecha,monto, ingreso)
			forma_pago_dao.insertar_varios 13,cuenta, banco, fecha, monto, ingreso
		end function
		
		public function ingresar_a_cheque(cuenta,banco,fecha,monto,plaza,ingreso)
			forma_pago_dao.insertar_cheque 3,cuenta, banco, fecha, monto, plaza, ingreso
		end function
		
		public function actualizar_a_cheque(cuenta,banco,fecha,monto,plaza,ingreso)
			forma_pago_dao.actualizar_a_cheque 3,cuenta, banco, fecha, monto, plaza, ingreso
		end function
		
		public function actualizar_efectivo(monto, ingreso)
			forma_pago_dao.actualizar_efectivo monto, ingreso
		end function
		
	end class
	
	Class dao_forma_pago
		private sub Class_Initialize
			set conexion = new CConexion
			conexion.inicializar "upacifico"
		
			set negocio = new cnegocio
			negocio.inicializa conexion
			construct()
		end sub
		
		public default function construct()
			set construct = me
			isConstructed = true
		end function
		
		public function obtener_datos(folio)
			sql="SELECT ingr_ncorr FROM ingresos WHERE ingr_nfolio_referencia="&folio&";"
			
			ingr_ncorr = conexion.ConsultaUno(sql)
			
			sql="SELECT (SELECT ting_tdesc FROM tipos_ingresos WHERE ting_ccod=di.ting_ccod) AS documento, (SELECT ting_tdesc FROM tipos_ingresos WHERE ting_ccod=i.ting_ccod) AS item_pagado,	ding_nsecuencia, ding_mdocto, ding_fdocto, i.ingr_nfolio_referencia FROM detalle_ingresos di INNER JOIN ingresos i ON i.ingr_ncorr=di.ingr_ncorr WHERE di.ingr_ncorr = "&ingr_ncorr&";"
			'response.write sql
			SET formulario = new CFormulario
			formulario.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			formulario.Inicializar conexion
			formulario.Consultar sql
			
			dim arreglom()
			
			if formulario.nroFilas()=0 then
				redim arreglom(0)
				sql="SELECT ingr_mefectivo FROM ingresos WHERE ingr_nfolio_referencia="&folio&";"
				arreglom(0) = ARRAY("EFECTIVO", conexion.ConsultaUno(sql))
			else
				i=0
				while formulario.siguiente 
					redim preserve arreglom(i)
					arreglom(i) =  ARRAY(formulario.obtenerValor("documento"),formulario.obtenerValor("item_pagado"), formulario.obtenerValor("ding_nsecuencia"), formulario.obtenerValor("ding_mdocto"), formulario.obtenerValor("ding_fdocto"), formulario.obtenerValor("ingr_nfolio_referencia"))
					i=i+1
				wend
			end if
			obtener_datos = arreglom
		end function
		
		public function obtener_forma_pago()
			sql="SELECT ting_ccod, ting_tdesc FROM tipos_ingresos WHERE ting_ccod IN (SELECT DISTINCT ting_ccod FROM stipos_pagos) AND ting_ccod NOT IN (4,173,174,175,66,59,52) ORDER BY ting_tdesc;"
			
			SET formulario = new CFormulario
			formulario.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			formulario.Inicializar conexion
			formulario.Consultar sql
			
			dim arreglom()
			
			i=0
			while formulario.siguiente 
				redim preserve arreglom(i)
				arreglom(i) =  ARRAY(formulario.obtenerValor("ting_ccod"), formulario.obtenerValor("ting_tdesc"))
				i=i+1
			wend
			
			obtener_forma_pago = arreglom
		end function
		
		public function obtener_banco()
			sql="SELECT banc_ccod, banc_tdesc FROM bancos;"
			
			SET formulario = new CFormulario
			formulario.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			formulario.Inicializar conexion
			formulario.Consultar sql
			
			dim arreglom()
			
			i=0
			while formulario.siguiente 
				redim preserve arreglom(i)
				arreglom(i) =  ARRAY(formulario.obtenerValor("banc_ccod"), formulario.obtenerValor("banc_tdesc"))
				i=i+1
			wend
			
			obtener_banco = arreglom
		end function
		
		public function obtener_plaza()
			sql="SELECT plaz_ccod, plaz_tdesc FROM plazas;"
			
			SET formulario = new CFormulario
			formulario.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			formulario.Inicializar conexion
			formulario.Consultar sql
			
			dim arreglom()
			
			i=0
			while formulario.siguiente 
				redim preserve arreglom(i)
				arreglom(i) =  ARRAY(formulario.obtenerValor("plaz_ccod"), formulario.obtenerValor("plaz_tdesc"))
				i=i+1
			wend
			
			obtener_plaza = arreglom
		end function
		
		public function actualizar_efectivo(monto, ingreso)
			sql="SELECT ingr_ncorr FROM detalle_ingresos WHERE ding_nsecuencia="&ingreso&";"
			'response.write sql
			ingr_ncorr = conexion.ConsultaUno(sql)
			
			sql="DELETE FROM detalle_ingresos WHERE ding_nsecuencia="&ingreso&";"
			'response.write sql
			conexion.EjecutaS sql
			
			sql="UPDATE ingresos SET ting_ccod=6, ingr_mefectivo="&monto&", ingr_mdocto=0 WHERE ingr_ncorr="&ingr_ncorr&";"
			'response.write sql
			conexion.EjecutaS sql
		end function
		
		public function insertar_varios(tipo_ingreso, cuenta,banco,fecha,monto, ingreso)
			sql="SELECT ingr_ncorr FROM ingresos WHERE ingr_nfolio_referencia="&ingreso&";"
			ingr_ncorr = conexion.ConsultaUno(sql)
			
			sql="UPDATE ingresos SET ingr_mefectivo=0, ingr_mdocto="&monto&" WHERE ingr_ncorr="&ingr_ncorr&";"
			conexion.EjecutaS sql
			
			sql="exec ObtenerSecuencia 'detalle_ingresos';"
			secuencia = conexion.ConsultaUno(sql)
			
			sql="INSERT INTO detalle_ingresos(ting_ccod,ding_ndocto,ding_nsecuencia, ding_tcuenta_corriente,banc_ccod,ding_fdocto,ding_mdocto,ding_mdetalle,audi_tusuario,audi_fmodificacion, ingr_ncorr) VALUES ("&tipo_ingreso&", "&cuenta&", "&secuencia&", "&cuenta&", "&banco&", '"&fecha&"', "&monto&", "&monto&",  'cambiado por "&negocio.ObtenerUsuario&"',  getdate(),  "&ingr_ncorr&");"
			conexion.EjecutaS sql
		end function
		
		public function insertar_cheque(tipo_ingreso, cuenta,banco,fecha,monto, plaza, ingreso)
			sql="SELECT ingr_ncorr FROM ingresos WHERE ingr_nfolio_referencia="&ingreso&";"
			ingr_ncorr = conexion.ConsultaUno(sql)
			
			sql="UPDATE ingresos SET ingr_mefectivo=0, ingr_mdocto="&monto&" WHERE ingr_ncorr="&ingr_ncorr&";"
			conexion.EjecutaS sql
			
			sql="exec ObtenerSecuencia 'detalle_ingresos';"
			secuencia = conexion.ConsultaUno(sql)
			
			sql="INSERT INTO detalle_ingresos(ting_ccod,ding_ndocto,ding_nsecuencia, ding_tcuenta_corriente,banc_ccod,ding_fdocto,ding_mdocto,ding_mdetalle,audi_tusuario,audi_fmodificacion, ingr_ncorr, plaz_ccod) VALUES ("&tipo_ingreso&", "&secuencia&", "&secuencia&", "&cuenta&", "&banco&", '"&fecha&"', "&monto&", "&monto&",  'cambiado por "&negocio.ObtenerUsuario&"',  getdate(),  "&ingr_ncorr&", "&plaza&");"
			conexion.EjecutaS sql
		end function
		
		public function actualizar_varios(tipo_ingreso, cuenta,banco,fecha,monto, ingreso)
			sql="UPDATE detalle_ingresos SET ting_ccod="&tipo_ingreso&", ding_tcuenta_corriente="&cuenta&", banc_ccod="&banco&", ding_fdocto='"&fecha&"', ding_mdocto="&monto&", ding_mdetalle="&monto&", audi_tusuario ='cambiado por "&negocio.ObtenerUsuario&"', audi_fmodificacion = getdate() WHERE ding_nsecuencia="&ingreso&";"
			conexion.EjecutaS sql
		end function
		
		public function actualizar_a_cheque(tipo_ingreso, cuenta,banco,fecha,monto,plaza,ingreso)
			sql="UPDATE detalle_ingresos SET ting_ccod="&tipo_ingreso&", ding_tcuenta_corriente="&cuenta&", banc_ccod="&banco&", ding_fdocto='"&fecha&"', ding_mdocto="&monto&", ding_mdetalle="&monto&", audi_tusuario ='cambiado por "&negocio.ObtenerUsuario&"', audi_fmodificacion = getdate() WHERE ding_nsecuencia="&ingreso&";"
			conexion.EjecutaS sql
		end function
		
	end class
%>