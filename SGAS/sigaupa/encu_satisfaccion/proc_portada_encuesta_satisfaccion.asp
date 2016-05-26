<!-- #include file = "../biblioteca/_conexion_encuesta_rr_pp.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%


 Session.Contents.RemoveAll()
'-----------------------------------------------------------
 rut ="1" 'request("datos[0][pers_nrut]")
 dv ="1" 'request("datos[0][pers_xdv]")
 response.Write(rut)
 response.Write("<br/>"&dv)

 set conexion = new CConexion
 conexion.Inicializar "upacifico"

existe="S"
contesto="N"
if existe <> "N" and rut <> "" then
		'############################################################################################
			sql_pers_ncorr = "SELECT pers_ncorr FROM personas WHERE cast(pers_nrut as varchar)='" & RUT & "'"
			v_pers_ncorr =  conexion.ConsultaUno(sql_pers_ncorr)
		if contesto = "N"  then	
	   		session("rut_usuario") = RUT	
			 response.Write("<br/>"&"1")
	   		response.Redirect("encuesta.asp")
			
			else
			session("mensajeerror")= "Tu Ya has respondido la encuesta"
		    response.Redirect("portada_encuesta.asp") 
			response.Write("<br/>"&"2")
			end if
else
	   		session("mensajeerror")= "El rut ingresado no pertenece a un egresado de Relaciones Publicas"
		    response.Redirect("portada_encuesta.asp")
			response.Write("<br/>"&"3") 
end if
 
 %>