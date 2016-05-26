<!-- #include file = "../biblioteca/_conexion.asp" -->
<%

Response.AddHeader "Content-Disposition", "attachment;filename=reporte_usuarios_grl.txt"
Response.ContentType = "text/plain"
Server.ScriptTimeOut = 150000

set conexion = new CConexion
conexion.Inicializar "upacifico"

'------------------------------------------------------------------------------------
fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "tabla_vacia.xml", "tabla"
formulario.Inicializar conexion

consulta = " select distinct replace(replace(replace(replace(replace(replace(cast(b.susu_tlogin as varchar),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N') as username, "& vbCrLf &_
		   " replace(replace(replace(replace(replace(replace(upper(cast(b.susu_tclave as varchar)),'Á','A'),'É','E'),'Í','I'),'Ó','O'),'Ú','U'),'Ñ','N') as passwords, "& vbCrLf &_
		   " cast(rut as varchar)+'-'+ xdv as rut,nombre,  "& vbCrLf &_
		   " apellidos, "& vbCrLf &_
		   " replace(replace(replace(replace(replace(replace(email_upa,'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N') as email_upa, "& vbCrLf &_
		   "b.pers_ncorr,"& vbCrLf &_
		   " carrera,año_ingreso,tipo  "& vbCrLf &_
		   " from sd_cuentas_email_totales a,sis_usuarios b "& vbCrLf &_
		   " where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
		   " order by apellidos "

'########## Todos los docentes ############
consulta1 = " select distinct replace(replace(replace(replace(replace(replace(cast(b.susu_tlogin as varchar),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N') as username, "& vbCrLf &_
		   " replace(replace(replace(replace(replace(replace(upper(cast(b.susu_tclave as varchar)),'Á','A'),'É','E'),'Í','I'),'Ó','O'),'Ú','U'),'Ñ','N') as passwords, "& vbCrLf &_
		   " cast(rut as varchar)+'-'+ xdv as rut,nombre,  "& vbCrLf &_
		   " apellidos, "& vbCrLf &_
		   " replace(replace(replace(replace(replace(replace(email_upa,'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N') as email_upa, "& vbCrLf &_
		   "b.pers_ncorr,"& vbCrLf &_
		   " carrera,año_ingreso,tipo  "& vbCrLf &_
		   " from sd_cuentas_email_totales a,sis_usuarios b "& vbCrLf &_
		   " where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
		   " and b.pers_ncorr in (select distinct pers_ncorr from profesores) "& vbCrLf &_
		   " order by apellidos "

'########## Solo docentes 2009 ############		   
consulta2 = " select distinct replace(replace(replace(replace(replace(replace(cast(b.susu_tlogin as varchar),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N') as username, "& vbCrLf &_
		   " replace(replace(replace(replace(replace(replace(upper(cast(b.susu_tclave as varchar)),'Á','A'),'É','E'),'Í','I'),'Ó','O'),'Ú','U'),'Ñ','N') as passwords, "& vbCrLf &_
		   " cast(rut as varchar)+'-'+ xdv as rut,nombre, apellidos, "& vbCrLf &_
		   " replace(replace(replace(replace(replace(replace(email_upa,'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N') as email_upa, "& vbCrLf &_
		   " carrera,año_ingreso,tipo,  "& vbCrLf &_
		   " b.pers_ncorr,'Comu_Dire_Docen' as course1, '1' as type1 "& vbCrLf &_
		   " from sd_cuentas_email_totales a,sis_usuarios b "& vbCrLf &_
		   " where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
		   " and b.pers_ncorr in (select distinct a.pers_ncorr from profesores a, contratos_docentes_upa b where a.pers_ncorr=b.pers_ncorr and b.ano_contrato=2009)  "& vbCrLf &_
		   " order by apellidos "		   

'response.Write("<pre>"&consulta&"</pre>")
'response.End()
formulario.Consultar consulta2 
response.Write("username,password,idnumber,firstname,lastname,email,course1,type1")
Response.Write(vbCrLf)
while formulario.siguiente
				username = formulario.obtenerValor("username")
				response.Write(username&",")
				password = formulario.obtenerValor("passwords")
				response.Write(password&",")
				idnumber = formulario.obtenerValor("pers_ncorr")
				response.Write(idnumber&",")
				firstname = formulario.obtenerValor("nombre")
				response.Write(firstname&",")
				lastname = formulario.obtenerValor("apellidos")
				response.Write(lastname&",")
				email = formulario.obtenerValor("email_upa")
				response.Write(email&",")
				course1 = formulario.obtenerValor("course1")
				response.Write(course1&",")
				type1 = formulario.obtenerValor("type1")
				response.Write(type1)
				Response.Write(vbCrLf)
wend

%>
