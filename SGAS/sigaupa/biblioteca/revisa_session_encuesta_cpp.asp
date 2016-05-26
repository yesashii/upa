<%
Session.Timeout = 180
usuario = session("rut_usuario")		
	    'response.Write("usuario "&usuario)
		if usuario="" then
			paginaTerminoSesion = "../encuesta_cpp/encuesta.asp"
			session("mensajeerror")="el tiempo de sesion ha terminado debe comenzar nuevamente la encuesta"
			response.Redirect paginaTerminoSesion
			response.flush
		end if
%>
