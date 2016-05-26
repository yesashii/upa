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
 tipo_usuario = request("tipo_usuario")
 sede_aux = request("sede")

if session("sede")=""  then
	session("sede")=sede_aux
else
 	session("sede")= 1
end if 

  sql = "SELECT * FROM sis_usuarios WHERE upper(susu_tlogin) ='" & Ucase(login) & "'"
  f_busqueda.Consultar sql
  f_busqueda.Siguiente
  
  password 		= f_busqueda.ObtenerValor ("susu_tclave")
  pers_ncorr 	= f_busqueda.ObtenerValor ("pers_ncorr")

  if ucase(password) =  ucase(clave) then
     sql = "SELECT pers_nrut FROM personas WHERE pers_ncorr=" & pers_ncorr
	 RUT =  conexion.ConsultaUno(sql)
	 

	 if RUT <> "" then
	 
	 	sql_pers_ncorr = "SELECT pers_ncorr FROM personas WHERE pers_nrut=" & RUT
		v_pers_ncorr =  conexion.ConsultaUno(sql_pers_ncorr)
		'///////////////////revisamos si la persona que ingresa tiene los roles para el permiso solicitado
		if tipo_usuario="D.Docencia" then
			 c_permiso = "select case count(*) when 0 then 'N' else 'S' end from sis_roles_usuarios where srol_ncorr='27' and cast(pers_ncorr as varchar)='"&v_pers_ncorr&"'"
		elseif tipo_usuario = "D.Extensión" then
			 c_permiso = "select case count(*) when 0 then 'N' else 'S' end from personas where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"' and  pers_nrut in (16657576,7741733,9831249,13828975,7688542,11396469,8474919,13392966,12697496,8409343,12005686,14205430,8923510,13945590,12082412,12244262) "
		elseif tipo_usuario = "Call Center" then
			 c_permiso = "select case count(*) when 0 then 'N' else 'S' end from personas where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"' and  pers_nrut in (13466322,9475710,9831249,7741733,16692191,11646306,12237605,16098659,13684336,12082412,12244262) "
		elseif tipo_usuario = "Asistente" then
			 c_permiso = "select case count(*) when 0 then 'N' else 'S' end from personas where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"' and  pers_nrut in (14372588,16935509,16399099,16607228,11667970) "	 
		elseif tipo_usuario = "R.Curricular" then
			 c_permiso = "select case count(*) when 0 then 'N' else 'S' end from sis_roles_usuarios where srol_ncorr='2' and cast(pers_ncorr as varchar)='"&v_pers_ncorr&"'"		
		elseif tipo_usuario = "Escuela" then
			 c_permiso = "select case count(*) when 0 then 'N' else 'S' end from sis_roles_usuarios a, personas b where a.pers_ncorr=b.pers_ncorr and srol_ncorr in (87,64,66,69,150) and cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"'"
		elseif tipo_usuario = "Personal" then
			 c_permiso = "select case count(*) when 0 then 'N' else 'S' end from sis_roles_usuarios where srol_ncorr='25' and cast(pers_ncorr as varchar)='"&v_pers_ncorr&"'"
		elseif tipo_usuario = "Relator" then
			 c_permiso = "select case count(*) when 0 then 'N' else 'S' end from bloques_relatores_otec where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"'"
		elseif tipo_usuario = "Cajero" then
			 c_permiso = "select case count(*) when 0 then 'N' else 'S' end from sis_roles_usuarios where srol_ncorr in (60,63,87) and cast(pers_ncorr as varchar)='"&v_pers_ncorr&"'"
		elseif tipo_usuario = "Contabilidad" then
   			 c_permiso = "select case count(*) when 0 then 'N' else 'S' end from personas where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"' and  pers_nrut in (16657576,14183788,9831249,7741733,14205430,13493596,8829456,12366148,10612013,6629316,8876413,12005686,12082412,12244262)"
		elseif tipo_usuario = "Títulos" then
   			 c_permiso = "select case count(*) when 0 then 'N' else 'S' end from sis_roles_usuarios where srol_ncorr='95' and cast(pers_ncorr as varchar)='"&v_pers_ncorr&"'"
		elseif tipo_usuario = "Muestra" then
   			 c_permiso = "select case count(*) when 0 then 'N' else 'S' end from personas where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"' and  pers_nrut in (13466322,9475710)"
		elseif tipo_usuario = "Externo" then
   			 c_permiso = "select case count(*) when 0 then 'N' else 'S' end from personas where cast(pers_ncorr as varchar)='"&v_pers_ncorr&"' and  pers_nrut in (13813352,7741733,260394,12082412,12244262)"	 
		end if
	    permiso = conexion.consultaUno(c_permiso)
		admin = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from sis_roles_usuarios where srol_ncorr='1' and cast(pers_ncorr as varchar)='"&v_pers_ncorr&"'")
		if admin = "S" or v_pers_ncorr="99187" then 'en caso de ser administrativo o bien ser Mónica Fernández
			permiso = "S"
		end if
		if permiso="N" then
			session("mensajeerror")= "Lo sentimos pero usted no presenta permisos para entrar con el rol seleccionado ("&tipo_usuario&")"
	   	    response.Redirect("portada.asp") 
		end if
		'############################################################################################
		'********** 	maneja usuarios conectados 		**********
'		sql_pers_ncorr = "SELECT pers_ncorr FROM personas WHERE pers_nrut=" & RUT
'		v_pers_ncorr =  conexion.ConsultaUno(sql_pers_ncorr)
'		
'		sql_login="Select count(*) from login_usuarios where elog_ccod=1 and pers_ncorr="&v_pers_ncorr
'		v_existe=conexion.ConsultaUno(sql_login)
'		
'		if v_existe >0 then
'		' el usuario ya tenia una sesion , pero debe validarse que no haya exedido los 20 minutos de conexion
'		sql_tiempo_logeo=	"select datediff(mi,lusu_factualiza,getdate()) as minutos from login_usuarios where pers_ncorr="&v_pers_ncorr&" and elog_ccod=1"
'		v_tiempo_logeo	=	conexion.ConsultaUno(sql_tiempo_logeo) ' tiempo en minutos
'		
'			if v_tiempo_logeo <=20 then
'				sql_atualiza="update login_usuarios set lusu_factualiza=getdate() where pers_ncorr="&v_pers_ncorr&" and elog_ccod=1"
'				conexion.ejecutaS(sql_atualiza)
'			else
'				sql_atualiza="update login_usuarios set elog_ccod=2 where pers_ncorr="&v_pers_ncorr&" and elog_ccod=1"
'				conexion.ejecutaS(sql_atualiza)
'				'*********************************************************************
'					' se debe crear un nuevo registro de conexion
'					v_num_logeo=conexion.ConsultaUno("exec ObtenerSecuencia 'numero_logeo'")
'					sql_inserta_login=  " Insert into login_usuarios "&_
'										" (lusu_ncorr,pers_ncorr, elog_ccod,lusu_flogeo,lusu_factualiza) "&_
'										" values ("&v_num_logeo&","&v_pers_ncorr&",1,getdate(),getdate()) "
'					conexion.ejecutaS(sql_inserta_login)
'				'*********************************************************************
'			end if
'
'		else
'		' el usuario no tenia una sesion activa, se crea un nuevo registro
'			v_num_logeo=conexion.ConsultaUno("exec ObtenerSecuencia 'numero_logeo'")
'		
'			sql_inserta_login=  " Insert into login_usuarios "&_
'								" (lusu_ncorr,pers_ncorr, elog_ccod,lusu_flogeo,lusu_factualiza) "&_
'								" values ("&v_num_logeo&","&v_pers_ncorr&",1,getdate(),getdate()) "
'			conexion.ejecutaS(sql_inserta_login)
'		
'		end if
		'############################################################################################
	   session("rut_usuario") = RUT	
	   session("tipo_usuario") = tipo_usuario
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