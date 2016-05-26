<!-- #include file = "../biblioteca/_conexion.asp" -->
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
 login = request.Form("usuario") '"16361982-2" 'request("datos[0][login]")
 clave = request.Form("clave") '"3272GCM" 'request("datos[0][clave]")
 
  sql = "SELECT susu_tclave , pers_ncorr FROM sis_usuarios WHERE upper(susu_tlogin) ='" & Ucase(login) & "'"
  f_busqueda.Consultar sql
  f_busqueda.Siguiente
  
  password 		= f_busqueda.ObtenerValor ("susu_tclave")
  pers_ncorr 	= f_busqueda.ObtenerValor ("pers_ncorr")
  
  titulado = conexion.consultaUno("select count(*) from alumnos where emat_ccod in (4,8) and cast(pers_ncorr as varchar)='"&pers_ncorr&"' ")

     if (ucase(password) =  ucase(clave)) and titulado <> "0" then
       sql = "SELECT pers_nrut FROM personas WHERE cast(pers_ncorr as varchar)='" & pers_ncorr & "'"
	   RUT =  conexion.ConsultaUno(sql)
	   '############################################################################################
	   session("rut_usuario") = RUT	
	   response.Redirect("dinamico_tyg.asp")
	 else
	   session("mensajeerror")= "Nombre de Usuario o Clave incorrecta.\nAsegurece de ingresar los datos reales y presentar estado de titulado o egresado en la institución."
	   response.Redirect("index.asp") 
	 end if
 
 %>