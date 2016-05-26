<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
	Class controlador_reporte_notas
		private isConstructed
		private reporte_notas_dao
		
		private sub Class_Initialize
			Set reporte_notas_dao = new dao_reporte_notas
			construct()
		end sub
		
		public default function construct()
			set construct = me
			isConstructed = true
		end function
	
		public function obtener_periodo()
			obtener_periodo = reporte_notas_dao.obtener_periodo()
		end function
	
	end class
	
	Class dao_reporte_notas
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
		
		function obtener_periodo()
			sql = "SELECT pa.PERI_CCOD, pa.PERI_TDESC FROM PERIODOS_ACADEMICOS pa INNER JOIN ACTIVIDADES_PERIODOS ap ON pa.PERI_CCOD=ap.PERI_CCOD INNER JOIN TIPOS_ACTIVIDADES_PERIODOS tap ON ap.TAPE_CCOD=tap.TAPE_CCOD WHERE TAPE_TDESC LIKE '%Postulaci%n%' AND ap.acpe_bvigente <> 'N' ORDER BY PERI_CCOD DESC;"
			SET formulario = new CFormulario
			formulario.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			formulario.Inicializar conexion
			formulario.Consultar sql
			dim arreglo(8)
			dim arreglos()
			i=0
			while formulario.siguiente
				redim preserve arreglos(i)
				arreglo(0) = formulario.obtenerValor("peri_ccod")
				arreglo(1) = formulario.obtenerValor("peri_tdesc")
				arreglos(i)=arreglo
				i=i+1
			wend
			obtener_periodo= arreglos
		end function	
	end class
%>