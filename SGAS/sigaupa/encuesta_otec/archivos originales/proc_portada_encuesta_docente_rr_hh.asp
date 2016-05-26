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

 set conexion = new CConexion
 conexion.Inicializar "upacifico"
 'session("rut_usuario") = RUT
' response.end()
'response.Redirect("programas.asp")
 'response.Redirect("programas.asp") 

sql_pers_ncorr = "SELECT pers_ncorr FROM personas WHERE cast(pers_nrut as varchar)='" & RUT & "'"
v_pers_ncorr =  conexion.ConsultaUno(sql_pers_ncorr)

slt_existe="select  count(*)"& vbCrLf &_
"from postulacion_otec a,"& vbCrLf &_
"datos_generales_secciones_otec b,"& vbCrLf &_
"diplomados_cursos c,"& vbCrLf &_
"secciones_otec d "& vbCrLf &_
"where a.dgso_ncorr=b.dgso_ncorr "& vbCrLf &_
"and epot_ccod=4 "& vbCrLf &_
"and b.dcur_ncorr=c.dcur_ncorr"& vbCrLf &_
"and pers_ncorr="&v_pers_ncorr&""& vbCrLf &_
"and b.dgso_ncorr=d.dgso_ncorr"& vbCrLf &_
"and esot_ccod=3"

		  
existe = conexion.consultaUno(slt_existe)		 
response.Write("<br/>"&slt_existe)
''existe="S"
''contesto="N"
'response.End()

if cdbl(v_pers_ncorr)=153207  then
existe=1
end if
if cdbl(existe) > 0  then
	   		session("rut_usuario") = RUT	
			 response.Write("<br/>"&"1")
	   		response.Redirect("programas.asp")
			
end if		
if cdbl(existe) = 0 then
	   		session("mensajeerror")= "Usted no tiene ningún programa  para evaluar"
		    response.Redirect("portada_encuesta.asp")
			response.Write("<br/>"&"3") 
end if

 'response.Redirect("portada_encuesta.asp")
 
 %>