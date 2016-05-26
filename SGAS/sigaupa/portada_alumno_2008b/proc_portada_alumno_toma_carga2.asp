<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%'response.End()
Session.Contents.RemoveAll()
v_hora_sys	=	Hour(now())
v_minuto_sys=	Minute(now())
v_dia_sys	=	WeekDay(now())
v_dia_actual 	= 	Day(now())
v_mes_actual	= 	Month(now())

v_numero_alumnos=30 ' numero por defecto

if (v_dia_actual=25 and v_mes_actual=12 )or (v_dia_actual=1 and v_mes_actual=1) then
	v_numero_alumnos=105
else
	' si el dia es 1=domingo o 7= sabado, se amplia el numero de alumnos permitidos
	if v_dia_sys=1 or v_dia_sys=7 then
		v_numero_alumnos=100
	else
	' se restringe el numero entre las 8:00 hrs. de la mañana y las 20:00 hrs. de la noche (dias de semana)
		if cint(v_hora_sys)<20 and cint(v_hora_sys)>8 then
			v_numero_alumnos=30
			'v_numero_alumnos=0
		else
			v_numero_alumnos=60
			'v_numero_alumnos=0
		end if
	end if
end if
 '------------------------------------------------------------
 login = request("datos[0][login]")
 clave_alumno = request("datos[0][clave]")


set conexion_logeo = new CLogin
conexion_logeo.Inicializa

if login <> "16573523-4" then
	conexion_logeo.ControlaNumeroAlumnos v_numero_alumnos
end if
conexion_logeo.CierraConexionesInactivasAlumnos

 'Conexión para el servidor de producción
 set conexion = new CConexion
 conexion.Inicializar "upacifico"
 

' response.Write("<hr>"&v_cantidad&"<hr>")
' response.End()
 'set negocio = new CNegocio
 'negocio.Inicializa conexion
'-----------------------------------------------------------------------


 set f_login = new CFormulario
 f_login.Carga_Parametros "parametros.xml", "tabla"
 f_login.Inicializar conexion 


  sql_login = "SELECT * FROM sis_usuarios WHERE upper(susu_tlogin) ='" & Ucase(login) & "'"

  f_login.Consultar sql_login
  f_login.Siguiente
  
  password 		= f_login.ObtenerValor ("susu_tclave")
  pers_ncorr 	= f_login.ObtenerValor ("pers_ncorr")
  

'response.end()
  if ucase(password) =  ucase(clave_alumno) then
     sql = "SELECT pers_nrut FROM personas WHERE pers_ncorr=" & pers_ncorr
	 RUT =  conexion.ConsultaUno(sql)

	 if RUT <> "" then
       'debemos ver si la persona que ingresa es estudiante, sino no puede entrar
	   es_alumno= conexion.consultaUno("select isnull(count(*),0) from sis_roles_usuarios where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and srol_ncorr=4")
	   
	   if es_alumno <> "0" then
	     'habilitación  de toma de carga por carrera
		 c_carr_ccod = " select ltrim(rtrim(carr_ccod)) from alumnos a, ofertas_academicas b, especialidades c "&_
		               " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod "&_
					   " and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and b.peri_ccod=218 and a.emat_ccod = 1 "'solo matricula 1er semestre 2009
		 carr_ccod = conexion.consultaUno(c_carr_ccod)
		 anio_ingreso = conexion.consultaUno("select protic.ano_ingreso_carrera_egresa2("&pers_ncorr&",'"&carr_ccod&"')")
		 facu_ccod    = conexion.consultaUno("select facu_ccod from carreras a, areas_academicas b where a.area_ccod=b.area_ccod and a.carr_ccod='"&carr_ccod&"'")
		 crear_acceso=false
		 es_carrera = false
		 
		 if carr_ccod ="45" and v_mes_actual=3 then 'Para la Carrera de Publicidad
		    es_carrera = true
		 	crear_acceso = true
		 end if
		 
		 if carr_ccod = "16" or carr_ccod ="14" or carr_ccod ="8" or carr_ccod ="800" or carr_ccod ="41" or carr_ccod ="51" or carr_ccod ="980" or carr_ccod ="990" or carr_ccod ="99" or carr_ccod ="950" or carr_ccod ="940" or carr_ccod ="43" or carr_ccod ="49" or carr_ccod ="33" or carr_ccod ="850" or carr_ccod ="47" then
		 	es_carrera = true	
			if v_mes_actual=1 and v_dia_actual >= 15 then
				crear_acceso = true
			elseif v_mes_actual=2 and v_dia_actual <= 28 then
				crear_acceso = true
			end if
		 end if
		 if (carr_ccod ="870" or carr_ccod="880") and (anio_ingreso="2007" or anio_ingreso="2008" ) then 'Para la Carrera de PEGB y PEP
		    es_carrera = true	
			if v_mes_actual=1 and v_dia_actual >= 15 then
				crear_acceso = true
			elseif v_mes_actual=2 and v_dia_actual <= 28 then
				crear_acceso = true
			end if
		 end if
		 
		'en caso de cumplir alguna condición de calendario de toma de carga cargamos la variable de sesion
		session("autorizacion_carga_2009") = crear_acceso
		if not crear_acceso and es_carrera then
			session("autorizacion_carga_2009") = false
			session("mensajeerror")= "Aún no se encuentra disponible la toma de carga académica para tu programa de estudios, favor consultar calendario de dicha actividad"
		    response.Redirect("portada_alumno.asp") 
		end if
		'las siguientes carreras harán toma de carga en la escuela
		if not es_carrera then
			session("autorizacion_carga_2009") = false
			session("mensajeerror")= "La toma de carga debe ser realizada directamente en tu escuela a partir del día 15 de enero."
		    response.Redirect("portada_alumno.asp") 
		end if
		
		
		'vemos si el alumno presenta bloqueos de matrícula
		c_bloqueo_notas = " select case count(*) when 0 then 'Libre' else 'Bloqueado' end  "& vbCrLf &_
			     		  " from causal_eliminacion where cast(rut as varchar)='"&RUT&"' "

        bloqueo_notas = conexion.consultaUno(c_bloqueo_notas)  
		if bloqueo_notas = "Bloqueado" then
			 mensaje_bloqueo_notas = "El alumno presenta un bloqueo académico en el sistema, lo que inpide la toma de carga, haga el favor de comunicarse con su escuela para solucionar la situación."
			 session("autorizacion_carga_2009")=false
			 session("mensajeerror")= mensaje_bloqueo_notas
		     response.Redirect("portada_alumno.asp") 
		end if
		
		'############################################################################################
			'********** 	maneja usuarios conectados 		**********
			sql_pers_ncorr = "SELECT pers_ncorr FROM personas WHERE pers_nrut=" & RUT
			v_pers_ncorr =  conexion.ConsultaUno(sql_pers_ncorr)
			
			sql_login="Select count(*) from login_usuarios where elog_ccod=1 and pers_ncorr="&v_pers_ncorr
			v_existe=conexion.ConsultaUno(sql_login)
			
			if v_existe >0 then ' el usuario ya tenia una sesion , pero debe validarse que no haya exedido los 10 minutos de conexion
					
					sql_atualiza="update login_usuarios set lusu_factualiza=getdate() where pers_ncorr="&v_pers_ncorr&" and elog_ccod=1"
					conexion.ejecutaS(sql_atualiza)
    		else
			' el usuario no tenia una sesion activa, se crea un nuevo registro
				v_num_logeo=conexion.ConsultaUno("exec ObtenerSecuencia 'numero_logeo'")
			
				sql_inserta_login=  " Insert into login_usuarios "&_
									" (lusu_ncorr,pers_ncorr, elog_ccod,lusu_flogeo,lusu_factualiza,lusu_tusuario) "&_
									" values ("&v_num_logeo&","&v_pers_ncorr&",1,getdate(),getdate(),'A') "
				conexion.ejecutaS(sql_inserta_login)
			end if
		'############################################################################################

	   		session("rut_usuario") = RUT	
	   		response.Redirect("../informacion_alumno_2008_evaluacion/portada_ponline.asp")
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
	'response.session("mensajeerror")
  end if 
 
 %>