<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
	for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
	next


set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar


set f_agrega = new CFormulario
f_agrega.Carga_Parametros "marca_intercambio.xml", "formu"
f_agrega.Inicializar conectar
f_agrega.ProcesaForm

for filai = 0 to f_agrega.CuentaPost - 1

pers_nrut = f_agrega.ObtenerValorPost (filai, "pers_nrut")
peri_ccod = f_agrega.ObtenerValorPost (filai, "peri_ccod")
talu_ccod = f_agrega.ObtenerValorPost (filai, "talu_ccod")

 'acre_ncorr=10000
 
 consulta_matr="select count(matr_ncorr) "& vbCrLf &_
			"from personas a,"& vbCrLf &_
			"alumnos b,"& vbCrLf &_
			"postulantes c"& vbCrLf &_
			"where a.pers_nrut="&pers_nrut&""& vbCrLf &_
			"and a.pers_ncorr=b.pers_ncorr"& vbCrLf &_
			"and b.pers_ncorr=c.pers_ncorr"& vbCrLf &_
			"and b.post_ncorr=c.post_ncorr"& vbCrLf &_
			"and c.peri_ccod="&peri_ccod&""& vbCrLf &_
			"and emat_ccod=1"
existe_matricula=conectar.ConsultaUno(consulta_matr)
 
if cdbl(existe_matricula) >0 then
	
	consulta_matr="select matr_ncorr "& vbCrLf &_
			"from personas a,"& vbCrLf &_
			"alumnos b,"& vbCrLf &_
			"postulantes c"& vbCrLf &_
			"where a.pers_nrut="&pers_nrut&""& vbCrLf &_
			"and a.pers_ncorr=b.pers_ncorr"& vbCrLf &_
			"and b.pers_ncorr=c.pers_ncorr"& vbCrLf &_
			"and b.post_ncorr=c.post_ncorr"& vbCrLf &_
			"and c.peri_ccod="&peri_ccod&""& vbCrLf &_
			"and emat_ccod=1"
			
matr_ncorr=conectar.ConsultaUno(consulta_matr)
	
	
	 usu=negocio.obtenerUsuario
	
	'response.Write("<BR>existe="&post_ncorr&"<BR>")
	
		
		sqlCO = "update alumnos set talu_ccod='"&talu_ccod&"' where matr_ncorr="&matr_ncorr&"" 
		
		LMAI_NCORR=conectar.ConsultaUno("exec ObtenerSecuencia 'log_marcado_alumno_intercambio'")
		
		sqlLog="insert into log_marcado_alumno_intercambio (LMAI_NCORR,MATR_NCORR,AUDI_TUSUARIO,AUDI_FMODIFICACION,talu_ccod)values("&LMAI_NCORR&","&matr_ncorr&",'"&usu&"',getdate(),'"&talu_ccod&"')"
		
		conectar.ejecutaS(sqlCO)
		Respuesta2 = conectar.ObtenerEstadoTransaccion()
		conectar.ejecutaS(sqlLog)
		Respuesta = conectar.ObtenerEstadoTransaccion()
		'response.Write("<BR>"&Respuesta&"<BR>")
		'response.Write("<BR>"&Respuesta2&"<BR>")
		
			if Respuesta2="Falso"then
			response.Write("<BR>"&sqlCO&"<BR>")
			end if
			if Respuesta="Falso"then
			response.Write("<BR>"&sqlLog&"<BR>")
			end if
		response.Write("<BR>"&sqlCO&"<BR>")
		response.Write("<BR>"&sqlLog&"<BR>")
		
		session("mensajeerror")= " El alumno fue marcado exitosamente"

		else
		session("mensajeerror")= " El Alumno no tiene matricula para el periodo selecionado "
	end if


next
'----------------------------------------------------
response.Redirect("marca_alumno.asp")
%>




