<%
Session.Timeout = 10
usuario = session("rut_usuario")		
	    'response.Write("usuario "&usuario)
		if usuario="" then
			paginaTerminoSesion = "../portal_empresas/portada_empresa.asp"
			response.Redirect paginaTerminoSesion
			response.flush
		end if
%>
