<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
	Class controlador_rut
		private isConstructed
		private rut_dao
		
		private sub Class_Initialize
			Set rut_dao = new dao_rut
			construct()
		end sub
		
		public default function construct()
			set construct = me
			isConstructed = true
		end function
		
		public function obtener_persona(rut, digito)
			obtener_persona =  rut_dao.obtener_persona(rut, digito)
		end function
		
		public function cambiar_rut(arreglo)
			rut_dao.cambiar_rut(arreglo)
		end function
	end class
	
	Class dao_rut
	
		dim conexion
		dim	 negocio
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
		
		public function obtener_persona(rut, digito)
			sql="SELECT TOP 1 * FROM (SELECT pers_ncorr, pers_nrut, pers_xdv, pers_tnombre, pers_tape_paterno, pers_tape_materno, 'personas_postulante' AS tabla FROM personas_postulante WHERE pers_nrut="&rut&" AND pers_xdv="&digito&vbCrLf &_
			"UNION"&vbCrLf &_
			"SELECT pers_ncorr, pers_nrut, pers_xdv, pers_tnombre, pers_tape_paterno, pers_tape_materno, 'personas' AS tabla FROM personas WHERE pers_nrut="&rut&" AND pers_xdv="&digito&") AS tabla;"
			
			SET formulario = new CFormulario
			formulario.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			formulario.Inicializar conexion
			formulario.Consultar sql
			dim arreglo(6)
			while formulario.siguiente 
				arreglo(0) = formulario.obtenerValor("pers_ncorr")
				arreglo(1) = formulario.obtenerValor("pers_nrut")
				arreglo(2) = formulario.obtenerValor("pers_xdv")
				arreglo(3) = formulario.obtenerValor("pers_tnombre")
				arreglo(4) = formulario.obtenerValor("pers_tape_paterno")
				arreglo(5) = formulario.obtenerValor("pers_tape_materno")
				arreglo(6) = formulario.obtenerValor("tabla")
			wend
			obtener_persona = arreglo
		end function
		
		public function cambiar_rut(arreglo)
			sql="SELECT TOP 1 * FROM (SELECT pers_ncorr, pers_nrut, pers_xdv, pers_tnombre, pers_tape_paterno, pers_tape_materno, 'personas_postulante' AS tabla FROM personas_postulante WHERE pers_ncorr = "&arreglo(3)&vbCrLf &_
			"UNION"&vbCrLf &_
			"SELECT pers_ncorr, pers_nrut, pers_xdv, pers_tnombre, pers_tape_paterno, pers_tape_materno, 'personas' AS tabla FROM personas WHERE pers_ncorr = "&arreglo(3)&") AS tabla;"
			
			SET formulario = new CFormulario
			formulario.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			formulario.Inicializar conexion
			formulario.Consultar sql
			dim antiguo(2)
			while formulario.siguiente 
				antiguo(0) = formulario.obtenerValor("pers_ncorr")
				antiguo(1) = formulario.obtenerValor("pers_nrut")
				antiguo(2) = formulario.obtenerValor("pers_xdv")
			wend

			sql2="UPDATE "&arreglo(2)&" SET pers_nrut="&arreglo(0)&", pers_xdv='"&arreglo(1)&"'	 WHERE pers_ncorr = "&arreglo(3)&";"
			
			conexion.EjecutaS sql2
			
			sql3="INSERT log_cambio_rut(pers_ncorr, rut_antiguo, digito_antiguo, rut_nuevo, digito_nuevo, audi_tusuario, audi_fmodificacion) VALUES("&antiguo(0)&", "&antiguo(1)&",'"&antiguo(2)&"',"&arreglo(0)&", '"&arreglo(1)&"', '"&negocio.obtenerusuario()&"', GETDATE());"
			
			
			conexion.EjecutaS sql3
			
			
		end function
		
	end class
%>