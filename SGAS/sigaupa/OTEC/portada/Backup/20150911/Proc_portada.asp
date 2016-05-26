<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%

Session.Contents.RemoveAll() 
  
set conexion = new CConexion
conexion.Inicializar "upacifico"
 
'set negocio = new CNegocio
'negocio.Inicializa conexion

'------------------------------------------------------------
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

sql = "SELECT * FROM sis_usuarios WHERE upper(susu_tlogin) = '" & Ucase(login) & "'"
f_busqueda.Consultar sql
f_busqueda.Siguiente

password 	= f_busqueda.ObtenerValor ("susu_tclave")
pers_ncorr 	= f_busqueda.ObtenerValor ("pers_ncorr")

'-----------------------------------------------------------------------------------------------------------------------------------------------
'-----------------------------------------------------------------------------------------------------------------------------------------------
  'Si la clave es correcta, entonces.....
  if ucase(password) = ucase(clave) then
     sql = "SELECT pers_nrut FROM personas WHERE pers_ncorr = " & pers_ncorr
	 RUT =  conexion.ConsultaUno(sql)
	 
	 'Si existe RUT en "personas".....
	 if RUT <> "" then
	 
	 	sql_pers_ncorr = "SELECT pers_ncorr FROM personas WHERE pers_nrut = " & RUT
		v_pers_ncorr =  conexion.ConsultaUno(sql_pers_ncorr)
		
'////////////////////////////////////// Revisamos si la persona que ingresa tiene los roles para el permiso solicitado //////////////////////////////////////
		'Para Dirección de Docencia
		if tipo_usuario="D.Docencia" then
			 c_permiso = "select case count(*) when 0 then 'N' else 'S' end from sis_roles_usuarios rus, sis_roles rol where rus.srol_ncorr = rol.srol_ncorr and rol.srol_tdesc = 'DIRDOCENCIA' and cast(rus.pers_ncorr as varchar) = '"&v_pers_ncorr&"'" 
		
		'Para Dirección de Extensión
		elseif tipo_usuario = "D.Extensión" then
			 c_permiso = "select case count(*) when 0 then 'N' else 'S' end from sis_roles_usuarios rus, sis_roles rol where rus.srol_ncorr = rol.srol_ncorr and rol.srol_tdesc = 'DIREXTENSION' and cast(rus.pers_ncorr as varchar) = '"&v_pers_ncorr&"'" 
		
		'Para Call Center
		elseif tipo_usuario = "Call Center" then
			 c_permiso = "select case count(*) when 0 then 'N' else 'S' end from sis_roles_usuarios rus, sis_roles rol where rus.srol_ncorr = rol.srol_ncorr and rol.srol_tdesc = 'CALLCENTER' and cast(rus.pers_ncorr as varchar) = '"&v_pers_ncorr&"'" 
		
		'Para Asistente
		elseif tipo_usuario = "Asistente" then
			 c_permiso = "select case count(*) when 0 then 'N' else 'S' end from sis_roles_usuarios rus, sis_roles rol where rus.srol_ncorr = rol.srol_ncorr and rol.srol_tdesc = 'ASISTENTE OTEC' and cast(rus.pers_ncorr as varchar) = '"&v_pers_ncorr&"'" 
		
		'Para Registro Curricular
		elseif tipo_usuario = "R.Curricular" then
			 c_permiso = "select case count(*) when 0 then 'N' else 'S' end from sis_roles_usuarios rus, sis_roles rol where rus.srol_ncorr = rol.srol_ncorr and rol.srol_tdesc = 'REGISTRO CURRICULAR' and cast(rus.pers_ncorr as varchar) = '"&v_pers_ncorr&"'" 
		
		'Para Escuela
		elseif tipo_usuario = "Escuela" then
			 c_permiso = "select case count(*) when 0 then 'N' else 'S' end from sis_roles_usuarios rus, sis_roles rol where rus.srol_ncorr = rol.srol_ncorr and rol.srol_tdesc in ('ESCUELA','DIR ESCUELA','COORDINADOR ACADEMICO','CAJERO - ADMISION','ESCUELA OTEC') and cast(rus.pers_ncorr as varchar) = '"&v_pers_ncorr&"'" 
		
		'Para Personal
		elseif tipo_usuario = "Personal" then
			 c_permiso = "select case count(*) when 0 then 'N' else 'S' end from sis_roles_usuarios rus, sis_roles rol where rus.srol_ncorr = rol.srol_ncorr and rol.srol_tdesc = 'RRHH' and cast(rus.pers_ncorr as varchar) = '"&v_pers_ncorr&"'" 
		
		'Para Relator
		elseif tipo_usuario = "Relator" then
			 c_permiso = "select case count(*) when 0 then 'N' else 'S' end from bloques_relatores_otec where cast(pers_ncorr as varchar) = '"&v_pers_ncorr&"'" 
		
		'Para Cajero
		elseif tipo_usuario = "Cajero" then
			 c_permiso = "select case count(*) when 0 then 'N' else 'S' end from sis_roles_usuarios rus, sis_roles rol where rus.srol_ncorr = rol.srol_ncorr and rol.srol_tdesc in ('CAJERO','CAJERO - MATRICULA','CAJERO - ADMISION') and cast(rus.pers_ncorr as varchar) = '"&v_pers_ncorr&"'" 
		
		'Para Contabilidad
		elseif tipo_usuario = "Contabilidad" then
   			 c_permiso = "select case count(*) when 0 then 'N' else 'S' end from sis_roles_usuarios rus, sis_roles rol where rus.srol_ncorr = rol.srol_ncorr and rol.srol_tdesc = 'CONTABILIDAD_OTEC' and cast(rus.pers_ncorr as varchar) = '"&v_pers_ncorr&"'" 
		
		'Para Títulos
		elseif tipo_usuario = "Títulos" then
   			 c_permiso = "select case count(*) when 0 then 'N' else 'S' end from sis_roles_usuarios rus, sis_roles rol where rus.srol_ncorr = rol.srol_ncorr and rol.srol_tdesc = 'TITULOS Y GRADOS' and cast(rus.pers_ncorr as varchar) = '"&v_pers_ncorr&"'" 
		
		'Para Muestra
		elseif tipo_usuario = "Muestra" then
   			 c_permiso = "select case count(*) when 0 then 'N' else 'S' end from sis_roles_usuarios rus, sis_roles rol where rus.srol_ncorr = rol.srol_ncorr and rol.srol_tdesc = 'MUESTRA_OTEC' and cast(rus.pers_ncorr as varchar) = '"&v_pers_ncorr&"'" 
		
		'Para Externo
		elseif tipo_usuario = "Externo" then
   			 c_permiso = "select case count(*) when 0 then 'N' else 'S' end from sis_roles_usuarios rus, sis_roles rol where rus.srol_ncorr = rol.srol_ncorr and rol.srol_tdesc = 'OTEC_EXTERNO' and cast(rus.pers_ncorr as varchar) = '"&v_pers_ncorr&"'"  
		
		end if
'////////////////////////////////////// FIN: Revisamos si la persona que ingresa tiene los roles para el permiso solicitado //////////////////////////////////////
		
	    permiso = conexion.consultaUno(c_permiso)
		admin = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from sis_roles_usuarios where srol_ncorr='1' and cast(pers_ncorr as varchar)='"&v_pers_ncorr&"'")
		if admin = "S" or v_pers_ncorr="99187" then 'en caso de ser administrativo o bien ser Mónica Fernández
			permiso = "S"
		end if
		if permiso="N" then
			session("mensajeerror")= "Lo sentimos pero usted no presenta permisos para entrar con el rol seleccionado ("&tipo_usuario&")"
	   	    response.Redirect("portada.asp") 
		end if
'-----------------------------------------------------------------------------------------------------------------------------------------------
'-----------------------------------------------------------------------------------------------------------------------------------------------

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