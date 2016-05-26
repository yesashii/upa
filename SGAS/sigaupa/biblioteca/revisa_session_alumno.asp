<%
Session.Timeout = 10
usuario = session("rut_usuario")		
	    'response.Write("usuario "&usuario)
		if usuario="" then
			paginaTerminoSesion = "../portada_alumno/portada_alumno.asp"
			response.Redirect paginaTerminoSesion
			response.flush
		end if
%>
