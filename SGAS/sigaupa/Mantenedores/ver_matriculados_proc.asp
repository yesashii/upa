<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
	Class controlador_matricula
		private isConstructed
		private matricula_dao
		
		private sub Class_Initialize
			Set matricula_dao = new dao_matricula
			construct()
		end sub
		
		public default function construct()
			set construct = me
			isConstructed = true
		end function
	
		public function obtener_matriculador(periodo, nuevo)
			obtener_matriculador = matricula_dao.obtener_matriculador(periodo, nuevo)
		end function
		
		public function obtener_periodo()
			obtener_periodo = matricula_dao.obtener_periodo()
		end function
	
	end class
	
	Class dao_matricula
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
		
		public function obtener_matriculador(periodo, nuevo)
			sql="SELECT b.pers_ncorr, protic.obtener_rut(b.pers_ncorr) as rut_alumno, a.cont_ncorr, protic.trunc(a.cont_fcontrato) as f_contrato, e.carr_tdesc as carrera," & vbCrLf &_
				" 			protic.ano_ingreso_carrera(b.pers_ncorr, e.carr_ccod) as ano_ingreso," & vbCrLf &_
				" 			f.PERS_TAPE_PATERNO as paterno_alumno, f.PERS_TAPE_MATERNO as materno_alumno, f.PERS_TNOMBRE as nombres_alumno," & vbCrLf &_
				" 			s.sede_tdesc" & vbCrLf &_
				" FROM contratos a " & vbCrLf &_
				" 		join alumnos b" & vbCrLf &_
				" 				on a.matr_ncorr = b.matr_ncorr" & vbCrLf &_
				" 		join ofertas_academicas c" & vbCrLf &_
				" 				on b.ofer_ncorr = c.ofer_ncorr" & vbCrLf &_
				" 		join especialidades d" & vbCrLf &_
				" 				on c.ESPE_CCOD = d.espe_ccod" & vbCrLf &_
				" 		join carreras e" & vbCrLf &_
				" 				on d.CARR_CCOD = e.carr_ccod" & vbCrLf &_
				" 		join personas f" & vbCrLf &_
				" 				on  b.pers_ncorr = f.pers_ncorr" & vbCrLf &_
				" 		join sedes s" & vbCrLf &_
				" 				on s.sede_ccod=c.sede_ccod" & vbCrLf &_
				" WHERE a.cont_ncorr in (" & vbCrLf &_
				" 		select e.cont_ncorr nro_contrato" & vbCrLf &_
				" 			from personas_postulante a  (nolock) " & vbCrLf &_
				" 				join alumnos d  (nolock) " & vbCrLf &_
				" 					on a.pers_ncorr = d.pers_ncorr  " & vbCrLf &_
				" 				join ofertas_academicas c " & vbCrLf &_
				" 					on c.ofer_ncorr = d.ofer_ncorr   " & vbCrLf &_
				" 				join contratos e (nolock) " & vbCrLf &_
				" 					on d.matr_ncorr = e.matr_ncorr     " & vbCrLf &_    
				" 			where e.econ_ccod = 1 " & vbCrLf &_
				" 				and d.emat_ccod not in (9) " & vbCrLf &_
				" 				and c.peri_ccod =  "&periodo & vbCrLf &_
				" 				and exists (select 1 from contratos cont1 (nolock), compromisos comp1  (nolock) " & vbCrLf &_
				" 					where d.post_ncorr = cont1.post_ncorr " & vbCrLf &_
				" 						and d.matr_ncorr = cont1.matr_ncorr " & vbCrLf &_
				" 						and cont1.cont_ncorr = comp1.comp_ndocto " & vbCrLf &_
				" 						and tcom_ccod in (1,2)))"
				if nuevo = "S" then
				sql= sql &" 	and protic.ano_ingreso_carrera(b.pers_ncorr, e.carr_ccod) = (SELECT anos_ccod FROM periodos_academicos WHERE peri_ccod= "&periodo &")"
				else
					if nuevo = "V" then
						sql= sql &" 	and protic.ano_ingreso_carrera(b.pers_ncorr, e.carr_ccod) <> (SELECT anos_ccod FROM periodos_academicos WHERE peri_ccod= "&periodo &")"
					end if
				end if
				sql= sql & " ORDER BY a.cont_fcontrato ASC;"
			
			SET formulario = new CFormulario
			formulario.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			formulario.Inicializar conexion
			formulario.Consultar sql
			dim arreglo(9)
			dim arreglos()
			i=0
			while formulario.siguiente
				redim preserve arreglos(i)
				arreglo(0) = formulario.obtenerValor("pers_ncorr")
				arreglo(1) = formulario.obtenerValor("rut_alumno")
				arreglo(2) = formulario.obtenerValor("cont_ncorr")
				arreglo(3) = formulario.obtenerValor("f_contrato")
				arreglo(4) = formulario.obtenerValor("carrera")
				arreglo(5) = formulario.obtenerValor("ano_ingreso")
				arreglo(6) = formulario.obtenerValor("nombres_alumno")
				arreglo(7) = formulario.obtenerValor("paterno_alumno")
				arreglo(8) = formulario.obtenerValor("materno_alumno")
				arreglo(9) = formulario.obtenerValor("sede_tdesc")
				arreglos(i)=arreglo
				i=i+1
			wend
			obtener_matriculador= arreglos
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