<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
Session.Contents.RemoveAll()
v_hora_sys	=	Hour(now())
v_minuto_sys=	Minute(now())
v_dia_sys	=	WeekDay(now())
v_dia_actual 	= 	Day(now())
v_mes_actual	= 	Month(now())

ip_usuario=Request.ServerVariables("REMOTE_ADDR")

v_numero_alumnos=15 ' numero por defecto

if (v_dia_actual=25 and v_mes_actual=12 )or (v_dia_actual=1 and v_mes_actual=1) then
	v_numero_alumnos=60
else
	' si el dia es 1=domingo o 7= sabado, se amplia el numero de alumnos permitidos
	if v_dia_sys=1 or v_dia_sys=7 then
		v_numero_alumnos=60
	else
	' se restringe el numero entre las 8:00 hrs. de la mañana y las 20:00 hrs. de la noche (dias de semana)
		if cint(v_hora_sys)<20 and cint(v_hora_sys)>8 then
			v_numero_alumnos=15
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

if ip_usuario="172.16.11.91"  then
	conexion_logeo.ControlaNumeroAlumnos v_numero_alumnos
end if
conexion_logeo.CierraConexionesInactivasAlumnos

 set conexion = new CConexion
 conexion.Inicializar "upacifico"
 
 'set negocio = new CNegocio
 'negocio.Inicializa conexion
'-----------------------------------------------------------------------
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "parametros.xml", "tabla"
 f_busqueda.Inicializar conexion 


  sql = "SELECT * FROM sis_usuarios WHERE upper(susu_tlogin) ='" & Ucase(login) & "'"
'response.Write("<br>"&sql)
'response.End()
  f_busqueda.Consultar sql
  f_busqueda.Siguiente
  
  password 		= f_busqueda.ObtenerValor ("susu_tclave")
  pers_ncorr 	= f_busqueda.ObtenerValor ("pers_ncorr")

  if ucase(password) =  ucase(clave_alumno) then
     sql = "SELECT pers_nrut FROM personas WHERE pers_ncorr=" & pers_ncorr
	 RUT =  conexion.ConsultaUno(sql)

	 if RUT <> "" then

	   'debemos ver si la persona que ingresa es estudiante, sino no puede entrar
	   es_alumno= conexion.consultaUno("select isnull(count(*),0) from sis_roles_usuarios where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and srol_ncorr=4")
	   if es_alumno <> "0" then
		'############################################################################################
			'********** 	maneja usuarios conectados 		**********
			sql_pers_ncorr = "SELECT pers_ncorr FROM personas WHERE pers_nrut=" & RUT
			v_pers_ncorr =  conexion.ConsultaUno(sql_pers_ncorr)
			
			sql_login="Select count(*) from login_usuarios where elog_ccod=1 and pers_ncorr="&v_pers_ncorr
			v_existe=conexion.ConsultaUno(sql_login)
			
			if v_existe >0 then
			' el usuario ya tenia una sesion , pero debe validarse que no haya exedido los 10 minutos de conexion
			sql_tiempo_logeo=	"select datediff(mi,lusu_factualiza,getdate()) as minutos from login_usuarios where pers_ncorr="&v_pers_ncorr&" and elog_ccod=1"
			v_tiempo_logeo	=	conexion.ConsultaUno(sql_tiempo_logeo) ' tiempo en minutos
			
				if v_tiempo_logeo <=10 then
					sql_atualiza="update login_usuarios set lusu_factualiza=getdate() where pers_ncorr="&v_pers_ncorr&" and elog_ccod=1"
					conexion.ejecutaS(sql_atualiza)
				else
					sql_atualiza="update login_usuarios set elog_ccod=2 where pers_ncorr="&v_pers_ncorr&" and elog_ccod=1"
					conexion.ejecutaS(sql_atualiza)
					'*********************************************************************
						' se debe crear un nuevo registro de conexion
						v_num_logeo=conexion.ConsultaUno("exec ObtenerSecuencia 'numero_logeo'")
						sql_inserta_login=  " Insert into login_usuarios "&_
											" (lusu_ncorr,pers_ncorr, elog_ccod,lusu_flogeo,lusu_factualiza, lusu_tusuario) "&_
											" values ("&v_num_logeo&","&v_pers_ncorr&",1,getdate(),getdate(),'A') "
						conexion.ejecutaS(sql_inserta_login)
					'*********************************************************************
				end if
	
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
	   		response.Redirect("../informacion_alumno_2008/inicio.html")
	   else
	   		session("mensajeerror")= "Esta persona no se encuentra registrada como Alumno en el sistema"
		    response.Redirect("portada_alumno.asp") 
	   end if
	 else
	   session("mensajeerror")= "Nombre de Usuario o Clave incorrecta.\nAsegurece de ingresar los datos reales2."
	   
	   response.Redirect("portada_alumno.asp") 
	 end if
  else
    session("mensajeerror")= "Nombre de Usuario o Clave incorrecta.\nAsegurece de ingresar los datos reales1."
    response.Redirect("portada_alumno.asp")
  end if 
 
 %>