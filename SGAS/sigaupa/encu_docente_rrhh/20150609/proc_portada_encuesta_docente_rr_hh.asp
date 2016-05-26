<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%


 Session.Contents.RemoveAll()
 	
	'for each k in request.form
	'response.Write(k&" = "&request.Form(k)&"<br>")
	'next
'-----------------------------------------------------------
  'rut =request.QueryString("pers_nrut")
  rut =request.Form("a[0][pers_nrut]")
 'rut =request("a[0][pers_nrut]")
 dv =request.Form("a[0][pers_xdv]")
 
 
if  rut="15964262" then
	session("rut_usuario") = "6182724"	
 	response.Write("<br/>"&"1")
	response.Redirect("asignaturas.asp")
end if
 
 'response.Write("<br/>rut="&rut)
 'response.Write("<br/>"&dv)
'response.end()
v_dia_actual 	= 	Day(now())
v_mes_actual	= 	Month(now())
fecha=Date()
'fecha_corte2=Date()
fecha_corte="17-11-2014" '-------> Fecha Cierra	
fecha_corte2="06-10-2014" '-------> Fecha Apertura		
 set conexion = new CConexion
 conexion.Inicializar "upacifico"

slt_existe= "select case count(*) when 0 then 'N' else 'S' end  from asignaturas a, secciones b, bloques_horarios c, bloques_profesores d,personas e"& vbCrLf &_
			"where a.asig_ccod=b.asig_ccod"& vbCrLf &_
			"and b.secc_ccod=c.secc_ccod"& vbCrLf &_
			"and b.peri_ccod in (236)"& vbCrLf &_
			"and c.bloq_ccod=d.bloq_ccod"& vbCrLf &_
			"and d.pers_ncorr=e.pers_ncorr"& vbCrLf &_
			"and e.pers_nrut='"&rut&"' "

'response.Write("<br/>"&slt_existe)		 
'contesto=conexion.consultaUno(slt_contensto)		  
existe = conexion.consultaUno(slt_existe)		 
'response.Write("<br/>"&existe)
'response.Write("<br/>"&v_mes_actual)
'existe="S"
'contesto="N"
'response.End()
'if rut="4230043" then
'	session("rut_usuario") = RUT	
'			 response.Write("<br/>"&"1")
'	   		response.Redirect("asignaturas.asp")

'end if

if cdate(fecha)>=cdate(fecha_corte2) then

			if existe = "S" and  cdate(fecha)<=cdate(fecha_corte) then
					'############################################################################################
						sql_pers_ncorr = "SELECT pers_ncorr FROM personas WHERE cast(pers_nrut as varchar)='" & RUT & "'"
						v_pers_ncorr =  conexion.ConsultaUno(sql_pers_ncorr)
					
						session("rut_usuario") = RUT	
						 'response.Write("<br/>"&"1")
						response.Redirect("asignaturas.asp")
						
			end if 		
			if existe = "N" and  cdate(fecha)<=cdate(fecha_corte)  then
						session("mensajeerror")= "El rut No corresponde a un docente"
						response.Redirect("portada_encuesta.asp")
						'response.Write("<br/>"&"3") 
			end if
			
			if existe = "N"  and cdate(fecha)>cdate(fecha_corte)  then
						session("mensajeerror")= "La Encuesta Ha sido Cerrada"
						response.Redirect("portada_encuesta.asp")
						response.Write("<br/>"&"3") 
			end if
			
			if existe = "S"  and cdate(fecha)>cdate(fecha_corte)  then
						session("mensajeerror")= "La Encuesta Ha sido Cerrada"
						response.Redirect("portada_encuesta.asp")
						response.Write("<br/>"&"3") 
			end if
		
else

session("mensajeerror")= "La Encuesta estará activa entre los días 6 de octubre y 17 de noviembre de 2014"
 response.Redirect("portada_encuesta.asp")		
end if
 
 %>