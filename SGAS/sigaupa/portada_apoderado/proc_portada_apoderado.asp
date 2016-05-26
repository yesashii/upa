<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%'response.End()
Session.Contents.RemoveAll()
v_hora_sys	=	Hour(now())
v_minuto_sys=	Minute(now())
v_dia_sys	=	WeekDay(now())
v_dia_actual 	= 	Day(now())
v_mes_actual	= 	Month(now())

v_numero_alumnos=20 ' numero por defecto

if (v_dia_actual=25 and v_mes_actual=12 )or (v_dia_actual=1 and v_mes_actual=1) then
	v_numero_alumnos=105
else
	' si el dia es 1=domingo o 7= sabado, se amplia el numero de alumnos permitidos
	if v_dia_sys=1 or v_dia_sys=7 then
		v_numero_alumnos=100
	else
	' se restringe el numero entre las 8:00 hrs. de la mañana y las 20:00 hrs. de la noche (dias de semana)
		if cint(v_hora_sys)<20 and cint(v_hora_sys)>8 then
			v_numero_alumnos=20
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

if login <> "16125125-9" and login <> "10389199-k" and login <> "17029051-8" and login <> "18310313-k"  then
	'conexion_logeo.ControlaNumeroAlumnos v_numero_alumnos
end if
'conexion_logeo.CierraConexionesInactivasAlumnos

 'Conexión para el servidor sbd02 alumnos
 'set conexion2 = new CConexion2
 'conexion2.Inicializar "upacifico"
 
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

	   		'#######	SI NO ES ALUMNO, DEBE SER UN APODERADO	#######
	   		
	   		es_apoderado= conexion.consultaUno("select isnull(count(*),0) from sis_roles_usuarios where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and srol_ncorr=5")
			if es_apoderado <> "0" then
				session("rut_usuario") = RUT
				sql_rut_alu= " Select count(*) as cantidad from  "&_
							 " (select distinct a.pers_nrut,a.pers_xdv, a.pers_tnombre, a.pers_tape_paterno, a.pers_tape_materno "&_
							 " from personas a, postulantes b "&_
							 " where a.pers_ncorr=b.pers_ncorr "&_
							 " and b.post_ncorr in (select post_ncorr from codeudor_postulacion cp, personas pr where cp.pers_ncorr=pr.pers_ncorr and pers_nrut="&RUT&")) as tabla"
				
				
				cantidad_alumnos= conexion.consultaUno(sql_rut_alu)
				
				
				if cantidad_alumnos=1 then ' aval de un alumno distinto a si mismo
					sql_rut_alu= " select distinct a.pers_nrut "&_
								" from personas a, postulantes b "&_
								" where a.pers_ncorr=b.pers_ncorr "&_
								" and b.post_ncorr in (select post_ncorr from codeudor_postulacion cp, personas pr where cp.pers_ncorr=pr.pers_ncorr and pers_nrut="&RUT&")"
					rut_alumno= conexion.consultaUno(sql_rut_alu)
				
					session("rut_apoderado") = RUT
					session("rut_usuario") = rut_alumno	
					response.Redirect("../informacion_apoderado/inicio.html")
				else 'tiene a mas de un alumno avalado
					session("rut_apoderado") = RUT
					session("rut_usuario") = RUT	
					response.Redirect("seleccionar_alumno.asp") 
				end if
			
			else ' else apoderado
			
	   			session("mensajeerror")= "Esta persona no se encuentra registrada como Alumno o Apoderado en el sistema."
		    	response.Redirect("portada_apoderado.asp") 
	   		end if
	 else ' else rut
	   session("mensajeerror")= "Nombre de Usuario o Clave incorrecta.\nAsegurece de ingresar los datos reales."
	   response.Redirect("portada_apoderado.asp") 
	 end if
  else ' else login
    session("mensajeerror")= "Nombre de Usuario o Clave incorrecta.\nAsegurece de ingresar los datos reales."
    response.Redirect("portada_apoderado.asp")
	'response.session("mensajeerror")
  end if 
 
 %>