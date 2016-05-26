<%
Session.Timeout = 30
usuario = session("rut_usuario")		
	    'response.Write("usuario "&usuario)
		if usuario="" then
			paginaTerminoSesion = "../encu_satisfaccion/portada_encuesta.asp"
			response.Redirect paginaTerminoSesion
			response.flush
		end if
%>
