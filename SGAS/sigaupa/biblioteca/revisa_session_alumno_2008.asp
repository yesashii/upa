<%
Session.Timeout = 10
usuario = session("rut_usuario")		
	    'response.Write("usuario "&usuario)
		if usuario="" then
			'paginaTerminoSesion = "../portada_alumno_2008/portada_alumno.asp"
			paginaTerminoSesion = "../portada_alumno_2008b/portada_alumno.asp"
			response.Redirect paginaTerminoSesion
			response.flush
		end if
%>
