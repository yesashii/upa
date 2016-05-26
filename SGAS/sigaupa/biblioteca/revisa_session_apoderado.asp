<%
Session.Timeout = 20
usuario = session("rut_usuario")		
	    'response.Write("usuario "&usuario)
		if usuario="" then
			'paginaTerminoSesion = "../portada_alumno_2008/portada_alumno.asp"
			paginaTerminoSesion = "../portada_apoderado/portada_apoderado.asp"
			response.Redirect paginaTerminoSesion
			response.flush
		end if
%>
