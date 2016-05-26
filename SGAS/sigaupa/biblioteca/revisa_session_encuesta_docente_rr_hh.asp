<%
Session.Timeout = 90
usuario = session("rut_usuario")		
	    'response.Write("usuario "&usuario)
		if usuario="" then
			paginaTerminoSesion = "../encu_docente_rrhh/portada_encuesta.asp"
			response.Redirect paginaTerminoSesion
			response.flush
		end if
%>
