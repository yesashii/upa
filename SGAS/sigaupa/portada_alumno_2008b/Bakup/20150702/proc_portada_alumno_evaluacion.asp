<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%'response.End()
Session.Contents.RemoveAll()
 '------------------------------------------------------------
 login = request("datos[0][login]")
 clave_alumno = request("datos[0][clave]")


 'Conexión para el servidor sbd02 alumnos
 set conexion2 = new CConexion
 conexion2.Inicializar "upacifico"
 
'-----------------------------------------------------------------------
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "parametros.xml", "tabla"
 f_busqueda.Inicializar conexion2 


  sql = "SELECT * FROM sis_usuarios WHERE upper(susu_tlogin) ='" & Ucase(login) & "'"
'response.Write("<br>"&sql)
'response.End()
  f_busqueda.Consultar sql
  f_busqueda.Siguiente
  
  password 		= f_busqueda.ObtenerValor ("susu_tclave")
  pers_ncorr 	= f_busqueda.ObtenerValor ("pers_ncorr")

  if ucase(password) =  ucase(clave_alumno) then
     sql = "SELECT pers_nrut FROM personas WHERE pers_ncorr=" & pers_ncorr
	 RUT =  conexion2.ConsultaUno(sql)

	 if RUT <> "" then

	   'debemos ver si la persona que ingresa es estudiante, sino no puede entrar
	   es_alumno= conexion2.consultaUno("select isnull(count(*),0) from sis_roles_usuarios where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and srol_ncorr=4")
	   if es_alumno <> "0" then
		'############################################################################################
			'********** 	maneja usuarios conectados 		**********
			sql_pers_ncorr = "SELECT pers_ncorr FROM personas WHERE pers_nrut=" & RUT
			v_pers_ncorr =  conexion2.ConsultaUno(sql_pers_ncorr)
			
			
			sql_carr_ccod = "SELECT ltrim(rtrim(carr_ccod)) FROM alumnos a, ofertas_academicas b, especialidades c WHERE a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"' and b.peri_ccod in (236) and a.emat_ccod in (1,4)"
            carr_ccod = conexion2.consultaUno(sql_carr_ccod)
			sql_sede_ccod = "SELECT sede_ccod FROM alumnos a, ofertas_academicas b WHERE a.ofer_ncorr=b.ofer_ncorr and cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"' and b.peri_ccod in (238) and a.emat_ccod=1"
            sede_ccod = conexion2.consultaUno(sql_sede_ccod)
			v_dia_actual 	= 	Day(now())
			v_mes_actual	= 	Month(now())
			cerrar_proceso  = true
			'if sede_ccod = "4" then 
			'	if v_mes_actual = 05 and v_dia_actual > 16 then
			'		cerrar_proceso  = false
			'	elseif v_mes_actual = 06 and v_dia_actual <= 6 then
			'		cerrar_proceso  = false	
			'	end if
			'else 'para el resto de las sedes
			'	if v_mes_actual = 04 and v_dia_actual <= 30 then
			'		cerrar_proceso  = false
			'	elseif v_mes_actual = 05 and v_dia_actual <= 16 then
			'		cerrar_proceso  = false
			'	end if
			'end if
			'if sede_ccod <> "4" then 
				'if sede_ccod = "9" and ((v_mes_actual = 4 and v_dia_actual >= 07)  or  (v_mes_actual = 5 and v_dia_actual <= 5))  then
				'		cerrar_proceso  = false
				'end if
'*****************  PARA LA ARAUCANA ***************	
				'if sede_ccod = "9" and v_mes_actual = 5 and v_dia_actual >= 28 then
				'		cerrar_proceso  = false
				'end if
				'if sede_ccod = "9" and v_mes_actual = 6 and v_dia_actual <= 30 then
				'		cerrar_proceso  = false
				'end if
'*****************  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ***************	
				'if sede_ccod <> "9" and v_mes_actual = 4 and v_dia_actual >= 28 then
				'		cerrar_proceso  = false
				'end if
'*****************  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ***************	
				'if sede_ccod <> "9" and v_mes_actual = 5 and v_dia_actual <= 31 then
				'		cerrar_proceso  = false
				'end if
'*****************  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ***************	
				'if sede_ccod <> "9" and v_mes_actual = 6 and v_dia_actual <= 23 then
				'		cerrar_proceso  = false
				'end if
'*****************  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ***************	
				'if v_mes_actual = 10 and  v_dia_actual <= 17  then
				'		cerrar_proceso  = false
				'end if
			'else
				'if v_mes_actual = 10 and  v_dia_actual <= 24  then
				'		cerrar_proceso  = false
				'end if
'*****************  PRORROGA LA EVALUACION DOCENTE 2DO SEMESTRE 2014 POR PARES EVALUADORES. SOL.: MA. TERESA MERINO ***************	
				'if v_mes_actual = 10 and  v_dia_actual >= 6  then
				'		cerrar_proceso  = false
				'end if
'*****************  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ***************	
				'if v_mes_actual = 7 then
				'		cerrar_proceso  = false
				'end if
'***************** SI ES ENERO SE HABILITA LA ENCUESTA ****************	
				'if v_mes_actual = 01 and v_dia_actual >= 5 and v_dia_actual <= 31 then
				'		cerrar_proceso  = false
				'end if
'***************** SI ES MARZO SE HABILITA LA ENCUESTA ****************
				'if v_mes_actual = 03 and v_dia_actual >= 1 and v_dia_actual <= 27 then
				'		cerrar_proceso  = false
				'end if
'***************** SI ES JUNIO SE HABILITA LA ENCUESTA (1° SEMESTRE)****************
				if v_mes_actual = 6 and v_dia_actual >= 01 then
						cerrar_proceso  = false
				end if
				if v_mes_actual = 8 and v_dia_actual <= 14 then
						cerrar_proceso  = false
				end if
				
				'if v_mes_actual = 8 and v_dia_actual >= 1 and v_dia_actual <= 23 and sede_ccod = "9" then
				'		cerrar_proceso  = false
				'end if
				
			'end if	
			'RESPONSE.Write(cerrar_proceso)
			'response.End()
			'cerrar_proceso  = false
			'############################################################################################
            if cerrar_proceso then
		   		session("mensajeerror")= "Lo Sentimos pero el proceso de evaluación docente se encuentra cerrado."
		    	response.Redirect("portada_alumno.asp") 		
			else
				session("rut_usuario") = RUT	
		   		response.Redirect("../informacion_alumno_2008_evaluacion/inicio.html")
			end if	
	   else
	   		session("mensajeerror")= "Esta persona no se encuentra registrada como Alumno en el sistema"
		    response.Redirect("portada_alumno.asp") 
	   end if
	 else
	   session("mensajeerror")= "Nombre de Usuario o Clave incorrecta.\nAsegurece de ingresar los datos reales."
	   response.Redirect("portada_alumno.asp") 
	 end if
  else
    session("mensajeerror")= "Nombre de Usuario o Clave incorrecta.\nAsegurece de ingresar los datos reales."
    response.Redirect("portada_alumno.asp")
  end if 
 
 %>