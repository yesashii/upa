<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
	Class controlador_encuesta
		private isConstructed
		private encuesta_dao
		
		private sub Class_Initialize
			Set encuesta_dao = new dao_encuesta
			construct()
			
		end sub
		
		public default function construct()
			set construct = me
			isConstructed = true
		end function
		
		
		public function obtener_persona(pers_ncorr)
			if isConstructed then
				obtener_persona =  encuesta_dao.obtener_persona(pers_ncorr)
			end if
			
		end function
		
		public function promedio_autoevaluacion(pers_ncorr, peri_ccod)
			if isConstructed then
				promedio_autoevaluacion = encuesta_dao.promedio_autoevaluacion(pers_ncorr, peri_ccod)
			end if
		end function
		
		public function esDocente()
			if isConstructed then
				esDocente = encuesta_dao.esDocente()
			end if
		end function
		
		public function promedio_alumno(pers_ncorr, peri_ccod)
			if isConstructed then
				promedio_alumno = encuesta_dao.promedio_alumno(pers_ncorr, peri_ccod)
			end if
		end function
		
		public function promedio_director(pers_ncorr, peri_ccod)
			if isConstructed then
				promedio_director = encuesta_dao.promedio_director(pers_ncorr, peri_ccod)
			end if
		end function 
		
		public function obtener_observaciones_alumnos(rut)
			if isConstructed then
				obtener_observaciones_alumnos = encuesta_dao.obtener_observaciones_alumnos(rut)
			end if
		end function 
		
		public function obtener_observaciones_propias(rut)
			if isConstructed then
				obtener_observaciones_propias = encuesta_dao.obtener_observaciones_propias(rut)
			end if
		end function 
		
		public function obtener_asignatura(pers_ncorr, peri_ccod)
			if isConstructed then
				obtener_asignatura = encuesta_dao.obtener_asignatura(pers_ncorr, peri_ccod)
			end if
		end function 
		
		public function obtener_periodo()
			if isConstructed then
				obtener_periodo = encuesta_dao.obtener_periodo()
			end if
		end function
		
		public function nombre_periodo(periodo)
			if isConstructed then
				nombre_periodo = encuesta_dao.nombre_periodo(periodo)
			end if
		end function
		public function valores(rut)
			valores = encuesta_dao.valores(rut)
		end function
		
		public function Usuario()
			if isConstructed then
				Usuario= encuesta_dao.Usuario()
			end if
		end function
		
	end class
	
	Class dao_encuesta
	
		dim isConstructed2
		dim conexion
		dim negocio
		private sub Class_Initialize
			set conexion = new CConexion
			conexion.inicializar "upacifico"
			
			set negocio = new cnegocio
			negocio.inicializa conexion
			construct()
			
		end sub
		
		public default function construct()
			set construct = me
			 isConstructed2 = true
		end function
		
		public function valores(rut)
			dim retorno(1)
			
			retorno(0)=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&rut&"';")
	
			retorno(1) = negocio.obtenerPeriodoAcademico("PLANIFICACION")
			if retorno(1) = "" then
				retorno(1) = negocio.obtenerPeriodoAcademico("TOMACARGA")
				if retorno(1) = "" then
					retorno(1) = negocio.obtenerPeriodoAcademico("CLASES18")
					if retorno(1) = "" then
						retorno(1) = negocio.obtenerPeriodoAcademico("POSTULACION")
					end if
				end if
			end if
			
			valores = retorno
		end function
		
		public function obtener_persona(pers_ncorr)
			if isConstructed2 then
				sql="SELECT * FROM personas WHERE pers_ncorr="&pers_ncorr&";"
				
				SET formulario = new CFormulario
				formulario.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
				formulario.Inicializar conexion
				formulario.Consultar sql
				dim arreglo(1)
				while formulario.siguiente 
					arreglo(0) = formulario.obtenerValor("pers_nrut") & "-"&formulario.obtenerValor("pers_xdv")
					arreglo(1) = formulario.obtenerValor("pers_tnombre") & " " & formulario.obtenerValor("pers_tape_paterno") & " " & formulario.obtenerValor("pers_tape_materno")
				wend
				obtener_persona = arreglo
			end if
		end function
		
		public function promedio_autoevaluacion(pers_ncorr, peri_ccod)
			if isConstructed2 then
				sql="SELECT ISNULL(Str(AVG(promedio),3,1),0) AS promedio FROM (SELECT CONVERT(FLOAT,ROUND((aued_nota1+aued_nota2+aued_nota3+aued_nota4+aued_nota5+aued_nota6+aued_nota7+aued_nota8+aued_nota9+aued_nota10+aued_nota11+aued_nota12+aued_nota13)/13,2)) AS promedio FROM autoevaluacion_docente_2015 WHERE pers_ncorr="&pers_ncorr&" AND peri_ccod="&peri_ccod&") AS tabla;"
				'response.write "<br>"&sql
				SET formulario = new CFormulario
				formulario.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
				formulario.Inicializar conexion
				
				formulario.Consultar sql
				autoevaluacion=0
				while formulario.siguiente 
					autoevaluacion = formulario.obtenerValor("promedio")
				wend
				promedio_autoevaluacion = autoevaluacion
			end if
		end function
		
		public function esDocente()
			if isConstructed2 then
				sql="SELECT COUNT(*) AS cuenta FROM sis_roles_usuarios sru INNER JOIN personas p ON p.pers_ncorr=sru.pers_ncorr WHERE srol_ncorr IN (1,3,347) AND pers_nrut="&negocio.ObtenerUsuario&";"
				'response.write "<br>"&sql
				SET formulario = new CFormulario
				formulario.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
				formulario.Inicializar conexion
				formulario.Consultar sql
				
				cantidad = 0
				retorno = false
				
				while formulario.siguiente 
					cantidad = formulario.obtenerValor("cuenta")
				wend
				if cantidad = 1 then
					retorno = true
				end if
				esDocente = retorno
			end if
		end function
		
		public function Usuario()
			if isConstructed2 then
				Usuario= negocio.ObtenerUsuario
			end if
		end function
		
		
		public function promedio_alumno(pers_ncorr, peri_ccod)
			if isConstructed2 then
				sql="SELECT ISNULL(Str(AVG(promedio),3,1),0) AS promedio FROM (SELECT s.peri_ccod, eda.secc_ccod, pers_ncorr_profesor,CONVERT(FLOAT,ROUND((edal_nota1+edal_nota2+edal_nota3+edal_nota4+edal_nota5+edal_nota6+edal_nota7+edal_nota8+edal_nota9+edal_nota10+edal_nota11+edal_nota12+edal_nota13+edal_nota14+edal_nota15+edal_nota16+edal_nota17+edal_nota18+edal_nota19+edal_nota20)/20,2)) AS promedio FROM evaluacion_docente_alumnos_2015 eda INNER JOIN secciones s ON eda.secc_ccod=s.secc_ccod WHERE pers_ncorr_profesor="&pers_ncorr&" AND s.peri_ccod="&peri_ccod&") AS tabla;"
				'response.write "<br>"&sql
				SET formulario = new CFormulario
				formulario.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
				formulario.Inicializar conexion
				formulario.Consultar sql
				alumno=0
				while formulario.siguiente 
					alumno = formulario.obtenerValor("promedio")
				wend
				promedio_alumno = alumno
			end if
		end function
		
		public function promedio_director(pers_ncorr, peri_ccod)
			if isConstructed2 then
				sql="SELECT ISNULL(Str(AVG(promedio),3,1),0) AS promedio FROM (SELECT peri_ccod, pers_ncorr_prof, CONVERT(FLOAT,ROUND((eddi_nota1+eddi_nota2+eddi_nota3+eddi_nota4+eddi_nota5+eddi_nota6+eddi_nota7+eddi_nota8+eddi_nota9+eddi_nota10+eddi_nota11)/11,2)) AS promedio FROM evaluacion_docente_directores_2015 WHERE pers_ncorr_prof="&pers_ncorr&" AND peri_ccod="&peri_ccod&") AS tabla;"
				'response.write "<br>"&sql
				SET formulario = new CFormulario
				formulario.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
				formulario.Inicializar conexion
				formulario.Consultar sql
				director=0
				while formulario.siguiente 
					director = formulario.obtenerValor("promedio")
				wend
				promedio_director = director
			end if
		end function
		
		public function obtener_asignatura(pers_ncorr, peri_ccod)
			if isConstructed2 then
				sql="SELECT DISTINCT c.CARR_TDESC AS carrera FROM evaluacion_docente_alumnos_2015 eda INNER JOIN secciones s ON s.secc_ccod= eda.secc_ccod INNER JOIN CARRERAS c ON s.CARR_CCOD=c.CARR_CCOD WHERE eda.pers_ncorr_profesor="&pers_ncorr&" AND s.PERI_CCOD="&peri_ccod&";"
				'response.write "<br>"&sql
				'response.end
				SET formulario = new CFormulario
				formulario.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
				formulario.Inicializar conexion
				formulario.Consultar sql
				redim arreglo(formulario.nroFilas-1)
				i=0
				while formulario.siguiente
					arreglo(i) = formulario.obtenerValor("carrera")
					i=i+1
				wend
				obtener_asignatura = arreglo
			end if
		end function
		
		public function obtener_periodo()
			if isConstructed2 then
				sql="SELECT peri_ccod, peri_tdesc FROM periodos_academicos WHERE peri_ccod>237;"
				'response.write sql
				SET formulario = new CFormulario
				formulario.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
				formulario.Inicializar conexion
				formulario.Consultar sql
				
				redim arreglo(formulario.nroFilas-1, 1)
				i=0
				while formulario.siguiente
					
					arreglo(i,0) = formulario.obtenerValor("peri_ccod")
					arreglo(i,1) = formulario.obtenerValor("peri_tdesc")
					i=i+1
				wend
				obtener_periodo = arreglo
			end if
		end function
		public function nombre_periodo(periodo)
			if isConstructed2 then
				sql="SELECT peri_tdesc FROM periodos_academicos WHERE peri_ccod="&periodo&";"
				'response.write sql
				
				SET formulario = new CFormulario
				formulario.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
				formulario.Inicializar conexion
				formulario.Consultar sql
				formulario.siguiente
				arreglo= formulario.obtenerValor("peri_tdesc")
				nombre_periodo = arreglo
			end if
		end function
		
		public function obtener_observaciones_alumnos(rut)
			if isConstructed2 then
				sql="SELECT distinct edal_observacion FROM evaluacion_docente_alumnos_2015 WHERE pers_ncorr_profesor=(SELECT pers_ncorr FROM personas WHERE pers_nrut="&rut&") and edal_observacion <> ''"
				SET formulario = new CFormulario
				formulario.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
				formulario.Inicializar conexion
				formulario.Consultar sql
				
				observaciones = ""
				while formulario.siguiente
					
					observaciones = observaciones&" - "&formulario.obtenerValor("edal_observacion")+"<br><br><br><br>"
				wend
				obtener_observaciones_alumnos = observaciones
			end if
		end function
		
		public function obtener_observaciones_propias(rut)
			if isConstructed2 then
				sql="SELECT case when aued_obs1 <> '' then aued_obs1+'<br><br><br><br>' else '' end +case when aued_obs2 <> '' then '<br><br><br><br>-'+aued_obs2+'<br><br><br><br>' else '' end AS observaciones FROM autoevaluacion_docente_2015 WHERE pers_ncorr=(SELECT pers_ncorr FROM personas WHERE pers_nrut="&rut&") and (aued_obs1 <> '' OR aued_obs2 <> '')"
				'response.write sql
				SET formulario = new CFormulario
				formulario.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
				formulario.Inicializar conexion
				formulario.Consultar sql
				
				observaciones = ""
				while formulario.siguiente
					
					observaciones = observaciones&" - "&formulario.obtenerValor("observaciones")&"<br><br><br><br>"
				wend
				obtener_observaciones_propias = observaciones
			end if
		end function
	end class
%>