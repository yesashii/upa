<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
	Class controlador_jornada
		private isConstructed
		private jornada_dao
		
		private sub Class_Initialize
			Set jornada_dao = new dao_jornada
			construct()
		end sub
		
		public default function construct()
			set construct = me
			isConstructed = true
		end function
	
		public function obtener_asignatura(seccion)
			obtener_asignatura = jornada_dao.obtener_asignatura(seccion)
		end function
		
		public function obtener_tabla(seccion)
			obtener_tabla = jornada_dao.obtener_tabla(seccion)
		end function
		
		public function cambiar_jornada(seccion, jornada)
			jornada_dao.cambiar_jornada seccion, jornada
		end function
	
	end class
	
	Class dao_jornada
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
		
		public function obtener_asignatura(seccion)
			sql="SELECT a.asig_tdesc, a.asig_ccod, j.jorn_tdesc, se.sede_tdesc FROM asignaturas a INNER JOIN secciones s ON a.asig_ccod=s.asig_ccod INNER JOIN sedes se ON s.sede_ccod=se.sede_ccod INNER JOIN jornadas j ON s.jorn_ccod=j.jorn_ccod WHERE secc_ccod="&seccion&";"
			SET formulario = new CFormulario
			formulario.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			formulario.Inicializar conexion
			formulario.Consultar sql
			dim arreglo(3)
			while formulario.siguiente 
				arreglo(0) = formulario.obtenerValor("asig_tdesc")
				arreglo(1) = formulario.obtenerValor("asig_ccod")
				arreglo(2) = formulario.obtenerValor("jorn_tdesc")
				arreglo(3) = formulario.obtenerValor("sede_tdesc")
			wend
			obtener_asignatura= arreglo
		end function
		
		public function obtener_tabla(seccion)
			sql="SELECT DISTINCT e.espe_tdesc, s.secc_ccod, RTRIM(LTRIM(a.asig_ccod))+' '+RTRIM(LTRIM(s.secc_tdesc)) AS seccion, a.asig_tdesc FROM secciones s INNER JOIN asignaturas a ON s.asig_ccod=a.asig_ccod INNER JOIN malla_curricular mc ON s.mall_ccod=mc.mall_ccod INNER JOIN planes_estudio pe ON mc.plan_ccod=pe.plan_ccod INNER JOIN especialidades e ON pe.espe_ccod=e.espe_ccod INNER JOIN bloques_horarios bh ON s.secc_ccod=bh.secc_ccod WHERE s.secc_ccod="&seccion&";"
			'response.write sql
			SET formulario = new CFormulario
			formulario.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			formulario.Inicializar conexion
			formulario.Consultar sql
			dim arreglom()
			i=0
			while formulario.siguiente 
				redim preserve arreglom(i)
				arreglom(i) =  ARRAY(formulario.obtenerValor("espe_tdesc"),formulario.obtenerValor("secc_ccod"), formulario.obtenerValor("seccion"), formulario.obtenerValor("asig_tdesc"), "FALTA POR HACER")
				i=i+1
			wend
			obtener_tabla= arreglom
		end function
		
		public function cambiar_jornada(seccion, jornada)
			select case jornada
				case 1
					cambio = "REPLACE(secc_tdesc, 'V', 'D')"
				case 2
					cambio = "REPLACE(secc_tdesc, 'D', 'V')"
			end select
			sql="UPDATE secciones SET JORN_CCOD="&jornada&", SECC_TDESC="&cambio&", audi_tusuario ='cambiado por "&negocio.ObtenerUsuario&"', audi_fmodificacion = getdate() WHERE secc_ccod="&seccion&";"
			'response.write sql
			conexion.EjecutaS sql
			sql2 ="UPDATE SUB_SECCIONES SET JORN_CCOD="&jornada&", audi_tusuario ='cambiado por "&negocio.ObtenerUsuario&"', audi_fmodificacion = getdate()  WHERE secc_ccod="&seccion&";"
			'response.write sql2
			conexion.EjecutaS sql2
		end function
		
	end class
%>