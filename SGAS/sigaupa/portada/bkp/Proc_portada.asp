<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%

 Session.Contents.RemoveAll()

 set conexion = new CConexion
 conexion.Inicializar "upacifico"

 'set negocio = new CNegocio
 'negocio.Inicializa conexion

'-----------------------------------------------------------------------
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "parametros.xml", "tabla"
 f_busqueda.Inicializar conexion
 '------------------------------------------------------------
 login = request("datos[0][login]")
 clave = request("datos[0][clave]")

 'response.write("login: "&login)
 'response.end()
 'tipo_usuario = request("TipoUsuario")

  sql = "SELECT susu_tclave , pers_ncorr FROM sis_usuarios WHERE upper(susu_tlogin) ='" & Ucase(login) & "'"
  f_busqueda.Consultar sql
  f_busqueda.Siguiente

  password 		= f_busqueda.ObtenerValor ("susu_tclave")
  pers_ncorr 	= f_busqueda.ObtenerValor ("pers_ncorr")

  if ucase(password) =  ucase(clave) then
     sql = "SELECT pers_nrut FROM personas WHERE cast(pers_ncorr as varchar)='" & pers_ncorr & "'"
	 RUT =  conexion.ConsultaUno(sql)

	 es_profesor = conexion.consultaUno("SELECT count(*) FROM sis_roles_usuarios WHERE cast(pers_ncorr as varchar)='" & pers_ncorr&"' and srol_ncorr=3")
	 if es_profesor <> "0" then
	 	session("_actividad")= 6
		session("_periodo_PLANIFICACION") 	= 240
		session("_periodo")= 240
	 end if

	 if RUT <> "" then
		'############################################################################################
		'********** 	maneja usuarios conectados 		**********
		sql_pers_ncorr = "SELECT pers_ncorr FROM personas WHERE pers_nrut=" & RUT
		v_pers_ncorr =  conexion.ConsultaUno(sql_pers_ncorr)

		sql_login="Select count(*) from login_usuarios where elog_ccod=1 and pers_ncorr="&v_pers_ncorr
		v_existe=conexion.ConsultaUno(sql_login)

		if v_existe >0 then
		' el usuario ya tenia una sesion , pero debe validarse que no haya exedido los 20 minutos de conexion
		sql_tiempo_logeo=	"select datediff(mi,lusu_factualiza,getdate()) as minutos from login_usuarios where pers_ncorr="&v_pers_ncorr&" and elog_ccod=1"
		v_tiempo_logeo	=	conexion.ConsultaUno(sql_tiempo_logeo) ' tiempo en minutos

			if v_tiempo_logeo <=20 then
				sql_atualiza="update login_usuarios set lusu_factualiza=getdate() where pers_ncorr="&v_pers_ncorr&" and elog_ccod=1"
				conexion.ejecutaS(sql_atualiza)
			else
				sql_atualiza="update login_usuarios set elog_ccod=2 where pers_ncorr="&v_pers_ncorr&" and elog_ccod=1"
				conexion.ejecutaS(sql_atualiza)
				'*********************************************************************
					' se debe crear un nuevo registro de conexion
					v_num_logeo=conexion.ConsultaUno("exec ObtenerSecuencia 'numero_logeo'")
					sql_inserta_login=  " Insert into login_usuarios "&_
										" (lusu_ncorr,pers_ncorr, elog_ccod,lusu_flogeo,lusu_factualiza) "&_
										" values ("&v_num_logeo&","&v_pers_ncorr&",1,getdate(),getdate()) "
					conexion.ejecutaS(sql_inserta_login)
				'*********************************************************************
			end if

		else
		' el usuario no tenia una sesion activa, se crea un nuevo registro
			v_num_logeo=conexion.ConsultaUno("exec ObtenerSecuencia 'numero_logeo'")

			sql_inserta_login=  " Insert into login_usuarios "&_
								" (lusu_ncorr,pers_ncorr, elog_ccod,lusu_flogeo,lusu_factualiza) "&_
								" values ("&v_num_logeo&","&v_pers_ncorr&",1,getdate(),getdate()) "
			conexion.ejecutaS(sql_inserta_login)

		end if
		'############################################################################################
	   session("rut_usuario") = RUT
	   response.Redirect("../lanzadera/lanzadera.asp")
	 else
	   session("mensajeerror")= "Nombre de Usuario o Clave incorrecta.\nAsegurece de ingresar los datos reales."
	   response.Redirect("portada.asp")
	 end if
  else
    session("mensajeerror")= "Nombre de Usuario o Clave incorrecta.\nAsegurece de ingresar los datos reales."
    response.Redirect("portada.asp")
  end if

 %>
