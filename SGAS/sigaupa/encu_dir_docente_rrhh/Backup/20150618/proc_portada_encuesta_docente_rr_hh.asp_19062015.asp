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
 
 'response.Write("<br/>rut="&rut)
 'response.Write("<br/>"&dv)
'response.end()
 set conexion = new CConexion
 conexion.Inicializar "upacifico"

slt_existe= " select case count(*) when 0 then 'N' else 'S' end  from personas "& vbCrLf &_
			" where pers_nrut="&rut&""& vbCrLf &_
			" and pers_nrut in (12558863,11185823,14529566,10761951,5695737,5241717,15740666,7812265,7242784,6553688,10322800,6684101,11949949,10761951,8373540,13037981,8156208,8474919,8099825,4452431,7186515,6060680,5913652,9907604,7206909,8988079,14244135,14726133,12636785,5071197,7696810,7169333,14545344,10908282,4290651,15964262,12231092,10122299,8327507,9668098,14738680,10070749,8516097,9668098,12690605,6733079,11522121,13253319,8959886,23192926,8669217,5241717,7062331,5713893,12449905,12884063,8053780,14092744,2633087,14092744,5695737,8373540,13037981,10122299,11522121,7062331,13234600,8669217,12449905,16300631,10322800,13999681,11404850,16702540,7812265,5913652,9907604,7206909,9588833,8053780,8327507,12802046,12636785,6218977,5927758,5071197,12231092,12558863,10908282)"

'response.Write(slt_existe)
'response.End()
'slt_existe= " select case count(*) when 0 then 'N' else 'S' end  from personas "& vbCrLf &_
'			"where pers_nrut="&rut&""& vbCrLf &_
'			"and pers_nrut in (10908282)"
			
v_dia_actual 	= 	Day(now())
v_mes_actual	= 	Month(now())
fecha=Date()
'fecha_corte="28-12-2014" '-------> Fecha Cierra	
'fecha_corte2="06-10-2014" '-------> Fecha Apertura		 
fecha_corte="30-06-2015" '-------> Fecha Cierra	
fecha_corte2="01-06-2015" '-------> Fecha Apertura		 
'
'contesto=conexion.consultaUno(slt_contensto)		  
existe = conexion.consultaUno(slt_existe)		 
'response.Write("<br/>v_dia_actual= "&v_dia_actual)
'response.Write("<br/>v_mes_actual= "&v_mes_actual)
'response.Write("<br/>v_mes_actual= "&fecha)
'existe="S"
'contesto="N"
'response.End()

'############################################################################################

'if rut="14545344" then
'
'	   		session("rut_usuario") = RUT	
'			 response.Write("<br/>"&"1")
'	   		response.Redirect("docentes.asp")
'end if
if  rut="15964262" then
session("rut_usuario") = "11949949"	
 response.Write("<br/>"&"1")
response.Redirect("docentes.asp")
end if

if cdate(fecha)>=cdate(fecha_corte2) then


		if existe = "S" and  cdate(fecha)<=cdate(fecha_corte) then
				
					sql_pers_ncorr = "SELECT pers_ncorr FROM personas WHERE cast(pers_nrut as varchar)='" & RUT & "'"
					v_pers_ncorr =  conexion.ConsultaUno(sql_pers_ncorr)

					session("rut_usuario") = RUT	
					 response.Write("<br/>"&"1")
					response.Redirect("encuesta_2015.asp")
					
		end if		
		if existe = "N" and  cdate(fecha)<=cdate(fecha_corte)  then
					session("mensajeerror")= "Usted no es Director de Carrera"
					response.Redirect("portada_encuesta.asp")
					response.Write("<br/>"&"3") 
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

session("mensajeerror")= "La Encuesta estará activa entre los días 15 y 30 de junio de 2015"
 response.Redirect("portada_encuesta.asp")		
end if
 'session("mensajeerror")= "La Encuesta Ha sido Cerrada"
 'response.Redirect("portada_encuesta.asp")
 
 %>