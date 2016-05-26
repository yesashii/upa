<%
Session.Timeout = 60
usuario = session("rut_usuario")		
	    'response.Write("usuario "&usuario)
		if usuario="" then
			paginaTerminoSesion = "../evalua/portada_evalua.asp"
			response.Redirect paginaTerminoSesion
			response.flush
		end if
%>
