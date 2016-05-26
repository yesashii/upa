<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%'response.End()

Session.Contents.RemoveAll()
v_hora_sys	 =	Hour(now())
v_minuto_sys =	Minute(now())
v_dia_sys	 =	WeekDay(now())
v_dia_actual = 	Day(now())
v_mes_actual = 	Month(now())

'numero de conexion permitido por defecto
'v_numero_alumnos = 40 
'A partir del 02/07/2015 seran 500
v_numero_alumnos = 500 

'A partir del 02/07/2015: se comenta todo, desde INICIO y FIN
'----------------INICIO---------------------------------------------------------------------------------------------
'numero de conexion permitido segun dias especiales y horario especial
'Si es 25/12 o 01/01 se permiten 105
'if (v_dia_actual=25 and v_mes_actual=12 ) or (v_dia_actual=1 and v_mes_actual=1) then
'	v_numero_alumnos=105
'else
	' si el dia es 1=domingo o 7= sabado, se amplia el numero de alumnos permitidos, se permiten 500
'	if v_dia_sys=1 or v_dia_sys=7 then
'		v_numero_alumnos=500   '100
'	else
'	' se restringe el numero entre las 8:00 hrs. de la mañana y las 20:00 hrs. de la noche (dias de semana), se permiten 500
'		if cint(v_hora_sys)>8 and cint(v_hora_sys)<20 then
'			v_numero_alumnos=500   '100
'			'v_numero_alumnos=0
'		else
'			v_numero_alumnos=500   '100 , se permiten 500
'			'v_numero_alumnos=0
'		end if
'	end if
'end if
'----------------FIN---------------------------------------------------------------------------------------------


'----------------------------------------------------------------------------------------------------------------
'Se almacena login y clave al ingresar
 login = request("datos[0][login]")
 clave_alumno = request("datos[0][clave]")
'response.Write("login:"&login)
'response.End()

set conexion_logeo = new CLogin
conexion_logeo.Inicializa

'LEIVA ROA FELIPE ANDRES RUT: 15315448-1
if  login <> "15315448-1" then 
	conexion_logeo.ControlaNumeroAlumnos v_numero_alumnos
end if

conexion_logeo.CierraConexionesInactivasAlumnos

'Conexión para el servidor de producción
set conexion = new CConexion
conexion.Inicializar "upacifico"

'response.Write("<hr>"&v_cantidad&"<hr>")
'response.End()
'set negocio = new CNegocio
'negocio.Inicializa conexion
'----------------------------------------------------------------------------------------------------------------

'carga parametros de tabla
set f_login = new CFormulario
f_login.Carga_Parametros "parametros.xml", "tabla"
f_login.Inicializar conexion 

''consultadmos los datos del usuario conectado
sql_login = " SELECT * FROM sis_usuarios WHERE upper(susu_tlogin) = '" & Ucase(login) & "'"

f_login.Consultar sql_login
f_login.Siguiente

'seteamos los datos del usuario provenientes de la base de datos
password 	= f_login.ObtenerValor ("susu_tclave")
pers_ncorr 	= f_login.ObtenerValor ("pers_ncorr")
  
'response.end()

'----------------------------------------------------------------------------------------------------------------
'si "password" (BD) es igual a la "clave_alumno" ingresada
  if ucase(password) =  ucase(clave_alumno) then
     'consultamos RUT del usuario conectado
     sql = " SELECT pers_nrut FROM personas WHERE pers_ncorr = " & pers_ncorr
	 RUT =  conexion.ConsultaUno(sql)
	 
	 'Si el RUT es un valor valido, entonces:
	 if RUT <> "" then
       'debemos ver si la persona que ingresa es estudiante, sino no puede entrar
	   es_alumno= conexion.consultaUno(" select isnull(count(*),0) from sis_roles_usuarios where cast(pers_ncorr as varchar) = '"&pers_ncorr&"' and srol_ncorr = 4 ")
       
	   'si es alumno, entonces: habilitación  de toma de carga por carrera
	   if es_alumno <> "0" then
	     
		 'consultamos la carrera que cursa
		 c_carr_ccod = " select top 1 ltrim(rtrim(carr_ccod)) from alumnos a, ofertas_academicas b, especialidades c "&_
		               " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod "&_
					   " and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and b.peri_ccod in (238,240) and a.emat_ccod in (1,4,8) order by a.alum_fmatricula desc "'solo matricula 1er semestre 2015
					   'response.Write(c_carr_ccod)
					   'response.End()
		 carr_ccod = conexion.consultaUno(c_carr_ccod)
		 
		 'consultamos la sede de la carrera
		 c_sede_ccod = " select top 1 b.sede_ccod from alumnos a, ofertas_academicas b, especialidades c "&_
		               " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod "&_
					   " and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and b.peri_ccod in (238,240) and a.emat_ccod in (1,4,8) order by a.alum_fmatricula desc"'solo matricula 1er semestre 2015
					   'response.Write(c_sede_ccod)
					   'response.End()
		 sede_ccod = conexion.consultaUno(c_sede_ccod)
		 
		 'consultamos la jornada de la carrera
		 c_jorn_ccod = " select top 1 b.jorn_ccod from alumnos a, ofertas_academicas b, especialidades c "&_
		               " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod "&_
					   " and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and b.peri_ccod in (238,240) and a.emat_ccod in (1,4,8) order by a.alum_fmatricula desc"'solo matricula 1er semestre 2015
					   'response.Write(c_jorn_ccod)
					   'response.End()
		 jorn_ccod = conexion.consultaUno(c_jorn_ccod)
		 
		 'consultamos el año de ingreso a la carrera
		 anio_ingreso = conexion.consultaUno("select protic.ano_ingreso_carrera_egresa2("&pers_ncorr&",'"&carr_ccod&"')")
						'response.Write(anio_ingreso)
					    'response.End()
		 
		 'consultamos la facultad de la carrera
		 facu_ccod    = conexion.consultaUno("select facu_ccod from carreras a, areas_academicas b where a.area_ccod=b.area_ccod and a.carr_ccod='"&carr_ccod&"'")
		                'response.Write(facu_ccod)
	                    'response.End()
		 
		 'consultamos el promedio del alumno
		 promedio     = conexion.consultaUno("select promedio from PROMEDIOS_ALUMNOS_CARRERA where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and carr_ccod='"&carr_ccod&"' and peri_ccod=238")
		                'response.Write("select promedio from PROMEDIOS_ALUMNOS_CARRERA where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and carr_ccod='"&carr_ccod&"' and peri_ccod=236")
 	                    'response.End()
		
		'seteamos variables de acceos en "false"
		 crear_acceso = false
		 es_carrera = false
		 'response.Write("PROMEDIO = "&PROMEDIO&" , v_mes_actual = "&v_mes_actual&" , v_dia_actual = "&v_dia_actual&" , v_minuto_sys = "&v_minuto_sys)
		 'response.Write(PROMEDIO)
		 'response.Write(v_mes_actual)
		 'response.Write(v_dia_actual)
		 'response.Write(v_minuto_sys)
		 'response.End()

'PROMEDIO = , v_mes_actual = 7 , v_dia_actual = 13 , v_minuto_sys = 23



'----------------------------------------------------------------------------------------------------------------


'----------------------------------------------------------------------------------------------------------------
'Para la Carrera de PUBLICIDAD = 45 (carga academica ON LINE)
'----------------------------------------------------------------------------------------------------------------
         'Opcion para calendario especial: para el mes de matricula "v_mes_actual" = 7 (Julio)
		 'Opcion para calendario especial: si la carrera es Publicidad y el "promedio" NO es vacio
		 if v_mes_actual = 7 and carr_ccod = "45" and not esVacio(promedio) then 
			es_carrera = true
			crear_acceso = false
			'TODOS: Para el dia "v_dia_actual" = 13 y "promedio" >= 5.3
			if  v_dia_actual = 13 and cDbl(promedio) >= 5.3 then 
		  		    es_carrera = true
					crear_acceso = true
					'RESPONSE.Write("9")		
			'Para el "anio_ingreso" <= "2012" y dia "v_dia_actual" = 14 y "promedio" >= 5.0
			elseif anio_ingreso <= "2012" and v_dia_actual = 14 then 
				if v_hora_sys < 12 and cDbl(promedio) >= 5.0 then
					es_carrera = true
					crear_acceso = true
					'RESPONSE.Write("10")
		   	    elseif v_hora_sys >= 12 then
					es_carrera = true
					crear_acceso = true
					'RESPONSE.Write("11")			   
			    end if
			'Para el "anio_ingreso" = "2013" y dia "v_dia_actual" = 14 y "promedio" >= 5.0
			elseif anio_ingreso = "2013" and v_dia_actual = 14 then 
				if v_hora_sys < 12 and cDbl(promedio) >= 5.0 then
					es_carrera = true
					crear_acceso = true
					'RESPONSE.Write("12")
				elseif v_hora_sys >= 12 then
					es_carrera = true
				    crear_acceso = true			   
					'RESPONSE.Write("13")
				end if
			'Para el "anio_ingreso" = "2014" y dia "v_dia_actual" = 14 y "promedio" >= 5.0
			elseif anio_ingreso = "2014" and v_dia_actual = 15 then 
				if v_hora_sys < 12 and cDbl(promedio) >= 5.0 then
					es_carrera = true
					crear_acceso = true
					'RESPONSE.Write("14")
				elseif v_hora_sys >= 12 then
					es_carrera = true
					crear_acceso = true
					'RESPONSE.Write("15")			   
				end if
			'Para el "anio_ingreso" = "2015" y dia "v_dia_actual" = 14 y "promedio" >= 5.0
			elseif anio_ingreso = "2015" and v_dia_actual = 16 then 
				if v_hora_sys < 12 and cDbl(promedio) >= 5.0 then
					es_carrera = true
					crear_acceso = true
					'RESPONSE.Write("14")
				elseif v_hora_sys >= 12 then
					es_carrera = true
					crear_acceso = true
					'RESPONSE.Write("15")			   
				end if
			end if
		 'si la carrera es Publicidad y el promedio es vacio
		 elseif carr_ccod = "45" and v_mes_actual = 7 and esVacio(promedio) then
		    if anio_ingreso <= "2012" and v_dia_actual = 14  and v_hora_sys >= 12 then 
				es_carrera = true
				crear_acceso = true
				'RESPONSE.Write("11")			   
			elseif anio_ingreso = "2013" and v_dia_actual = 14 and v_hora_sys >= 12 then 
				es_carrera = true
				crear_acceso = true			   
				'RESPONSE.Write("13")
			elseif anio_ingreso = "2014" and v_dia_actual = 15 and v_hora_sys >= 12 then 
				es_carrera = true
				crear_acceso = true
				'RESPONSE.Write("15")
			elseif anio_ingreso = "2015" and v_dia_actual = 16 and v_hora_sys >= 12 then 
				es_carrera = true
				crear_acceso = true
				'RESPONSE.Write("15")
			end if
		 end if
'----------------------------------------------------------------------------------------------------------------


'----------------------------------------------------------------------------------------------------------------
'Para la Carrera de PSICOLOGÍA = 43 (carga academica ON LINE)
'----------------------------------------------------------------------------------------------------------------
		 'Opcion para calendario especial: si la carrera es PSICOLOGÍA
		 if carr_ccod = "43" then   
			es_carrera = true	
			'para el mes de matricula "v_mes_actual" = 7 (Julio), dias indicados y promosion menor a ....
			if v_mes_actual = 7 and (v_dia_actual = 17 or v_dia_actual = 18) and  anio_ingreso <= "2011" then
				crear_acceso = true
			'para el mes de matricula "v_mes_actual" = 7 (Julio), dias indicados y promosion igual a ....
			elseif v_mes_actual = 7 and (v_dia_actual = 19 or v_dia_actual = 20) and  anio_ingreso = "2012" then
				crear_acceso = true
			'para el mes de matricula "v_mes_actual" = 7 (Julio), dias indicados y promosion igual a ....
			elseif v_mes_actual = 7 and (v_dia_actual = 21 or v_dia_actual = 22) and  anio_ingreso = "2013" then
				crear_acceso = true	
			'para el mes de matricula "v_mes_actual" = 7 (Julio), dias indicados y promosion igual a ....
			elseif v_mes_actual = 7 and (v_dia_actual = 23 or v_dia_actual = 24) and  anio_ingreso = "2014" then
				crear_acceso = true
			'para el mes de matricula "v_mes_actual" = 7 (Julio), dias indicados y promosion igual a ....
			elseif v_mes_actual = 7 and (v_dia_actual = 25 or v_dia_actual = 26) and  anio_ingreso = "2015" then 
			'elseif v_mes_actual = 7 and (v_dia_actual = 03 or v_dia_actual = 03) and  anio_ingreso = "2015" then 
				crear_acceso = true	
			end if
		 end if 
'----------------------------------------------------------------------------------------------------------------


'----------------------------------------------------------------------------------------------------------------
'Para la Carrera de RELACIONES PÚBLICAS = 47 (carga academica ON LINE)
'----------------------------------------------------------------------------------------------------------------
		'Opcion para calendario especial: si la carrera es RELACIONES PÚBLICAS
		if carr_ccod = "47" then
			es_carrera = true	
			'para el mes de matricula "v_mes_actual" = 7 (Julio), dias indicados y promosion menor a ....
			if v_mes_actual = 7 and (v_dia_actual >= 17  and v_dia_actual <= 26) and  anio_ingreso <= "2012" then
				crear_acceso = true
			'response.end()
			'para el mes de matricula "v_mes_actual" = 7 (Julio), dias indicados y promosion igual a ....
			elseif v_mes_actual = 7 and (v_dia_actual >= 21 and v_dia_actual <= 26) and  anio_ingreso = "2013" then
				crear_acceso = true
			
			'para el mes de matricula "v_mes_actual" = 7 (Julio), dias indicados y promosion igual a ....
			elseif v_mes_actual = 7 and (v_dia_actual >= 23 and v_dia_actual <= 26) and  anio_ingreso = "2014" then
				crear_acceso = true	
			'para el mes de matricula "v_mes_actual" = 7 (Julio), dias indicados y promosion igual a ....
			elseif v_mes_actual = 7 and (v_dia_actual >= 24 and v_dia_actual <= 26) and  anio_ingreso = "2015" then
				crear_acceso = true	
			end if
		end if 
'----------------------------------------------------------------------------------------------------------------


'----------------------------------------------------------------------------------------------------------------
'Para las otras Carreras (carga academica ON LINE resto de las carreras)
'----------------------------------------------------------------------------------------------------------------
		 if (carr_ccod <> "43" and carr_ccod <> "45" and carr_ccod <> "47") then ' <<-- aqui van las carreas con calendario especial
		 	 'a continuacion el resto de las carreras sin calendario especial
			if (carr_ccod = "800" or carr_ccod = "8" or carr_ccod = "975" or carr_ccod = "970" or carr_ccod = "41" or carr_ccod = "17" or carr_ccod = "16" or carr_ccod = "860" or carr_ccod = "880" or carr_ccod = "940" or carr_ccod = "49" or carr_ccod = "99" or carr_ccod = "51" or carr_ccod = "106" or carr_ccod = "105" or carr_ccod = "830" or carr_ccod = "850" or carr_ccod = "108" or carr_ccod = "32" or carr_ccod = "14" or carr_ccod = "104" or carr_ccod = "112" or carr_ccod = "103" or carr_ccod = "113" or carr_ccod = "100" or carr_ccod = "101" or carr_ccod = "102" or carr_ccod = "110" or carr_ccod = "117" or carr_ccod = "840") then
				es_carrera = true
				'para el mes de matricula "v_mes_actual" = 7 (Julio), dias indicados
				if v_mes_actual = 7 and (v_dia_actual >= 17) and (v_dia_actual <= 26) then
					crear_acceso = true
				end if
				'if v_mes_actual = 2 and (v_dia_actual >= 1) and (v_dia_actual <= 27) then
				'	crear_acceso = true
				'end if
			end if 
		 end if 
'----------------------------------------------------------------------------------------------------------------

'response.Write("carr_ccod = "&carr_ccod&" , es_carrera = "&es_carrera) 'carr_ccod = , es_carrera = False
'response.End

'response.Write(es_carrera) 'False
'response.Write(crear_acceso)
'response.Write(sede_ccod)
'response.End()			 


'----------------------------------------------------------------------------------------------------------------
'Para la sede LA ARAUCANA: tola de carga
'----------------------------------------------------------------------------------------------------------------
		 if sede_ccod = "9" then
		 	es_carrera = true	
		 	if (v_mes_actual = 7 and v_dia_actual >= 27 ) then
		 		crear_acceso = true
		 	end if
		 	if (v_mes_actual = 8 and v_dia_actual <= 9 ) then
		 		crear_acceso = true
		 	end if
		 end if
'----------------------------------------------------------------------------------------------------------------


'----------------------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------
        'response.Write("crear_acceso = "&crear_acceso&" , es_carrera = "&es_carrera)
		'response.End()
		'crear_acceso = False , es_carrera = True
		
		'en caso de cumplir alguna condición de calendario de toma de carga cargamos la variable de sesion
		session("autorizacion_carga_2009") = crear_acceso
		
		'para probar Mensaje 3
		'crear_acceso = True
		'es_carrera = True
		
		'if not crear_acceso and es_carrera then
		if crear_acceso = False and es_carrera = True then
		    'response.Write("crear_acceso = "&crear_acceso&" , es_carrera = "&es_carrera)
			mensaje_no_disponible = "Aún no se encuentra disponible la toma de carga académica para tu programa de estudios, favor consultar calendario de dicha actividad"
		    session("autorizacion_carga_2009") = false
			session("mensajeerror") = mensaje_no_disponible
		    response.Redirect("portada_alumno.asp") 
		end if
        'response.Write(carr_ccod)
		'response.End()

'response.Write(es_carrera) 'False
'response.End()		

		'las siguientes carreras harán toma de carga en la escuela
		'if not es_carrera then
		if es_carrera = False then
		    'response.Write("es_carrera = "&es_carrera)
			mensaje_consultar = "Consulta sobre el proceso de toma de carga directamente en tu escuela."
			session("autorizacion_carga_2009") = false

			session("mensajeerror") = mensaje_consultar
            response.Redirect("portada_alumno.asp") 
		end if
				
		'vemos si el alumno presenta bloqueos de matrícula
		c_bloqueo_notas = " select case count(*) when 0 then 'Libre' else 'Bloqueado' end  "& vbCrLf &_
			     		  " from causal_eliminacion where cast(rut as varchar) = '"&RUT&"' "
        bloqueo_notas = conexion.consultaUno(c_bloqueo_notas)  
		
		if bloqueo_notas = "Bloqueado" then
			'response.Write("bloqueo_notas = "&bloqueo_notas)
			mensaje_bloqueo_notas = "El alumno presenta un bloqueo académico en el sistema, lo que inpide la toma de carga, haga el favor de comunicarse con su escuela para solucionar la situación."
			session("autorizacion_carga_2009") = false
			session("mensajeerror") = mensaje_bloqueo_notas
		    response.Redirect("portada_alumno.asp") 
		end if
'----------------------------------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------------------------------


		'############################################################################################
			'********** 	MANEJO USUARIOS CONECTADOS 		**********
			sql_pers_ncorr = "SELECT pers_ncorr FROM personas WHERE pers_nrut = " & RUT
			v_pers_ncorr =  conexion.ConsultaUno(sql_pers_ncorr)
			
			sql_login="Select count(*) from login_usuarios where elog_ccod = 1 and pers_ncorr = "&v_pers_ncorr
			v_existe=conexion.ConsultaUno(sql_login)
			
			if v_existe > 0 then ' el usuario ya tenia una sesion , pero debe validarse que no haya exedido los 10 minutos de conexion
					
					sql_atualiza = "update login_usuarios set lusu_factualiza=getdate() where pers_ncorr = "&v_pers_ncorr&" and elog_ccod = 1"
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
        	'session("rut_usuario") = RUT	
	   		'response.Redirect("../informacion_alumno_2008_evaluacion/portada_ponline.asp")


			consulta_datos_act = " select case count(*) when 0 then 'NO' else 'SI' end "&_
							     " from act_datos_personales "&_
							     " where cast(pers_ncorr as varchar) = '"&pers_ncorr&"'"
			
			datos_act = conexion.consultaUno(consulta_datos_act)
			datos_act = "SI"
		    session("rut_usuario") = RUT
		    if datos_act <> "SI" then	
		    	response.Redirect("../informacion_alumno_2008_evaluacion/portada_act_datos.asp")
		    else
			    response.Redirect("../informacion_alumno_2008_evaluacion/portada_ponline.asp")
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
	'response.session("mensajeerror")
  end if 
 
 %>