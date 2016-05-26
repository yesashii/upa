<%
Class CLogin
	private c_conexion
		
	sub Inicializa 
                dsn="sql_2005_mirror":usuario_bd="protic":clave_bd=",.protic"
				str_con = "DSN=" & dsn & ";UID=" & usuario_bd & ";PWD=" & clave_bd & ";"
				set c_conexion = createobject("ADODB.Connection")
                c_conexion.open str_con	
	end sub

 
	function ActualizaEstadoLogin (usuario,modulo)
		if usuario <> "" then
			sql_pers_ncorr = "SELECT top 1 pers_ncorr FROM personas WHERE pers_nrut=" & usuario

			v_pers_ncorr =  me.ConsultaUnoLogin(sql_pers_ncorr)
			sql_existe_tabla = "SELECT top 1 count(pers_ncorr) FROM login_usuarios WHERE pers_ncorr="&v_pers_ncorr&" and elog_ccod=1"
			v_existe_login =  me.ConsultaUnoLogin(sql_existe_tabla)
	
				if v_existe_login >0 then
					sql_atualiza="update login_usuarios set lusu_factualiza=getdate(),lusu_tmodulo='"&modulo&"' where pers_ncorr="&v_pers_ncorr&" and elog_ccod=1"
					me.EjecutaQuery(sql_atualiza)
				end if
		end if 
	end function

	function CantidadUsuariosActivos ()
			sql_usuarios_activos="select count(*) from login_usuarios where datediff(mi,lusu_factualiza,getdate()) <=20 and elog_ccod=1"
			CantidadUsuariosActivos =  me.ConsultaUnoLogin(sql_usuarios_activos)
	end function

	function CantidadAlumnosActivos ()
			sql_alumnos_activos="select count(*) from login_usuarios where datediff(mi,lusu_factualiza,getdate()) <=10 and elog_ccod=1 and lusu_tusuario='A'"
			CantidadAlumnosActivos =  me.ConsultaUnoLogin(sql_alumnos_activos)
	end function

	function CantidadActivosModulo (modulo)
			sql_activos_modulo="select count(*) from login_usuarios where datediff(mi,lusu_factualiza,getdate()) <=10 and elog_ccod=1 and lusu_tmodulo='"&modulo&"' "
			CantidadActivosModulo =  me.ConsultaUnoLogin(sql_activos_modulo)
	end function


	Function ControlaNumeroUsuarios (numero_maximo)
		cantidad_activos= me.CantidadUsuariosActivos
		if numero_maximo<cantidad_activos then
			paginaInicio = "../portada/espere.asp"
			response.Redirect paginaInicio
		end if
	end function

	Function ControlaNumeroAlumnos (numero_maximo)
		cantidad_activos= me.CantidadAlumnosActivos
		if numero_maximo<=cantidad_activos then
			paginaInicio = "../portada_alumno/espere.asp"
			response.Redirect paginaInicio
		end if
	end function

	Function ControlaNumeroUsuariosPagina (numero_maximo, modulo)
		cantidad_activos= me.CantidadActivosModulo (modulo)
		if numero_maximo<cantidad_activos then
			session("MensajeError")="En estos instantes no es posible conectarse al modulo "&modulo&" del sistema. \nDebido a la gran cantidad de usuarios que estan trabajando este modulo estara siendo limitado. \nIntentelo en algunos minutos mas tarde..."
			paginaInicio = "../lanzadera/lanzadera.asp"
			response.Redirect paginaInicio
		end if
	end function

	function CierraConexionesInactivas ()
		sql_usuarios_inactivos="update login_usuarios set elog_ccod=2 where datediff(mi,lusu_factualiza,getdate()) >=25 and elog_ccod=1"
		me.EjecutaQuery(sql_usuarios_inactivos)
	end function

	function CierraConexionesInactivasAlumnos ()
		sql_usuarios_inactivos="update login_usuarios set elog_ccod=2 where datediff(mi,lusu_factualiza,getdate()) >=11 and elog_ccod=1"
		me.EjecutaQuery(sql_usuarios_inactivos)
	end function

	Private Sub Class_Terminate
		On Error Resume Next 'Uncomment this to prevent IIS crashing
		c_conexion.Close   
		set c_conexion = nothing
	End Sub 	

	function ConsultaUnoLogin (sqltext)
		set rs= createobject("ADODB.Recordset")
		rs.open sqltext,c_conexion, 0
		if not rs.EOF then
			valor = rs(0)
			rs.close
			set rs = nothing
			ConsultaUnoLogin = valor 
		else
			ConsultaUnoLogin = null
		end if
	end function

	function EjecutaQuery (sqltext)
	    On Error Resume Next
		EjecutaQuery = true
		set rs= createobject("ADODB.Recordset")
		rs.open sqltext,c_conexion, 3
		If con.Errors.Count > 0 then
			salida = ""
			For each error in con.errors 
			  select case error.number
			  	case -2147217900 
					salida = salida & "Error al intentar Ejecutar la intruccion : <br> "&sqltext&" "
			  end select
			next
			EjecutaQuery = false
		end if
	end function

	Sub CierraConexion   
		c_conexion.Close   
		set c_conexion = nothing
   	End Sub

End Class

%>
