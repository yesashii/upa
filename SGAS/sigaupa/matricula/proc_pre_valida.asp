<!--#include file="../biblioteca/_conexion.asp" --> 
<!--#include file="../biblioteca/_negocio.asp" --> 

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_consulta = new CFormulario
f_consulta.Carga_Parametros "consulta.xml", "consulta"



'muestra_variables
 check1   = request.Form("radio")
 rut      = trim(request.Form("rut"))
 dv       = ucase(trim(request.Form("dv")))
 rut_post = rut & "-" & dv
 
 


 if check1 = "1" then ' Postulante es una persona chilena.	   
	   consulta = "select count(*) from usuarios where usua_tusuario = '"& rut_post &"'"
	   v_cuenta = conexion.ConsultaUno(consulta)
	   
	   if v_cuenta > 0 then										
			 session("mensajeError") = "INFORMACIÓN:\nUd. ya se ha creado como usuario. " _
										& "Si se le olvidó la CLAVE, presione el link ¿OLVIDÓ CLAVE? y responda la pregunta que " _
										& "Ud. mismo ingresó. Si su respuesta es correcta, el sistema le mostrará su clave."	
				    										
			 response.Redirect("inicio.asp")
	   else
		   	 v_pers_ncorr = conexion.ConsultaUno("select pers_ncorr from personas where pers_nrut = " & rut & " And pers_xdv='"&dv&"'")
			 			 
			 if EsVacio(v_pers_ncorr) then
			 	v_pers_ncorr = conexion.ConsultaUno("select pers_ncorr from personas_postulante where pers_nrut = " & rut & " And pers_xdv='"&dv&"'")
			 end if
			 
			 if EsVacio(v_pers_ncorr) then
			 	v_pers_ncorr = conexion.ConsultaUno("exec ObtenerSecuencia 'personas'  ")
			 end if
			 
			 Session("ses_corr_persona") = v_pers_ncorr
			
			 'texto = "select pers_ncorr from personas_postulante where pers_nrut=" & rut		

			 'f_consulta.Inicializar conexion			 
			 'f_consulta.Consultar texto
			 'f_consulta.Siguiente

			 'if f_consulta.NroFilas = 0 then ' No existe registro de la persona en la BD
			'	 texto = "select PERS_NCORR_SEQ.nextval as corr from dual"
			'	 session("ses_corr_persona") = conexion.ConsultaUno(texto)				 
			' else
			'	 session("ses_corr_persona") = f_consulta.ObtenerValor("pers_ncorr")
			' end if			 
	   end if
	   
	   session("ses_rut_post") = rut
	   session("ses_dv_post")  = dv
	   session("ses_extranjero") = ""
 else 
       ' El postulante es una persona extranjera.
	   ' Generaremos el RUT para el postulante extranjero
	   texto2 = "exec ObtenerSecuencia 'personas'"	   
	   rut_extranjero = conexion.ConsultaUno(texto2)	   
	   
	   ' Despues de generar un RUT para el alumno extranjero, ahora generamos el DV
	   texto = "select dbo.dv("& rut_extranjero &") as dv "	   
	   dv_extranjero = conexion.ConsultaUno(texto)
	   
	   
	   ' Ahora generaremos el pers_ncorr del extranjero
	   texto = "exec ObtenerSecuencia 'personas'"	   
	   corr_extranjero_nuevo = conexion.ConsultaUno(texto)
				
	   session("ses_corr_persona") = corr_extranjero_nuevo	  
	   session("ses_rut_post") = rut_extranjero
	   session("ses_dv_post")  = dv_extranjero
	   session("ses_extranjero") = "V"
 end if
 
Response.Redirect("registrarse.asp")
%>