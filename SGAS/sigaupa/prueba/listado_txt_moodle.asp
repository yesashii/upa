<!-- #include file = "../biblioteca/_conexion.asp" -->
<%

Response.AddHeader "Content-Disposition", "attachment;filename=reporte_usuarios_grl.txt"
Response.ContentType = "text/plain;charset=UTF-8"

Server.ScriptTimeOut = 150000

set conexion = new CConexion
conexion.Inicializar "upacifico"

'------------------------------------------------------------------------------------
fecha=conexion.consultaUno("select cast(datePart(day,getDate())as varchar)+'-'+cast(datePart(month,getDate()) as varchar)+'-'+cast(datePart(year,getDate()) as varchar) as fecha")
'------------------------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "tabla_vacia.xml", "tabla"
formulario.Inicializar conexion

consulta = " select distinct replace(replace(replace(replace(replace(replace(b.susu_tlogin,'�','A'),'�','E'),'�','I'),'�','O'),'�','U'),'�','N') as username,  "& vbCrLf &_
		   " replace(replace(replace(replace(replace(replace(upper(b.susu_tclave),'�','A'),'�','E'),'�','I'),'�','O'),'�','U'),'�','N') as passwords,  "& vbCrLf &_
		   " rut,pers_tnombre as nombre,   "& vbCrLf &_
		   " pers_tape_paterno + ' ' + pers_tape_materno as apellidos,  "& vbCrLf &_
		   " replace(replace(replace(replace(replace(replace(lower(email_nuevo),'�','a'),'�','e'),'�','i'),'�','o'),'�','u'),'�','n') as email_upa, "& vbCrLf &_
		   " b.pers_ncorr,  "& vbCrLf &_
		   " '' as carrera,'' as a�o_ingreso, "& vbCrLf &_
		   " case when email_nuevo like '%@alumnos.upacifico.cl%' then 1 "& vbCrLf &_
		   "     when email_nuevo like '%@docentes.upacifico.cl%' then 2  "& vbCrLf &_
		   "     when email_nuevo like '%@upacifico.cl%' then 2 end as  tipo    "& vbCrLf &_
		   " from cuentas_email_upa a,sis_usuarios b   "& vbCrLf &_
		   " where a.pers_ncorr=b.pers_ncorr   "& vbCrLf &_
		   " order by apellidos "

'########## Todos los docentes ############
consulta1 = " select distinct replace(replace(replace(replace(replace(replace(b.susu_tlogin,'�','A'),'�','E'),'�','I'),'�','O'),'�','U'),'�','N') as username, "& vbCrLf &_
		   " replace(replace(replace(replace(replace(replace(upper(b.susu_tclave),'�','A'),'�','E'),'�','I'),'�','O'),'�','U'),'�','N') as passwords, "& vbCrLf &_
		   " cast(rut as varchar)+'-'+ xdv as rut,nombre,  "& vbCrLf &_
		   " apellidos, "& vbCrLf &_
		   " replace(replace(replace(replace(replace(replace(lower(email_upa),'�','a'),'�','e'),'�','i'),'�','o'),'�','u'),'�','n') as email_upa, "& vbCrLf &_
		   " b.pers_ncorr,"& vbCrLf &_
		   " carrera,a�o_ingreso,tipo  "& vbCrLf &_
		   " from sd_cuentas_email_totales a,sis_usuarios b "& vbCrLf &_
		   " where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
		   " and b.pers_ncorr in (select distinct pers_ncorr from profesores) "& vbCrLf &_
		   " order by apellidos "

'########## Solo docentes 2009 ############		   
consulta2 = " select distinct replace(replace(replace(replace(replace(replace(b.susu_tlogin,'�','A'),'�','E'),'�','I'),'�','O'),'�','U'),'�','N') as username, "& vbCrLf &_
		   " replace(replace(replace(replace(replace(replace(upper(b.susu_tclave),'�','A'),'�','E'),'�','I'),'�','O'),'�','U'),'�','N') as passwords, "& vbCrLf &_
		   " cast(rut as varchar)+'-'+ xdv as rut,nombre,  "& vbCrLf &_
		   " apellidos, "& vbCrLf &_
		   " replace(replace(replace(replace(replace(replace(lower(email_upa),'�','a'),'�','e'),'�','i'),'�','o'),'�','u'),'�','n') as email_upa, "& vbCrLf &_
		   "b.pers_ncorr,"& vbCrLf &_
		   " carrera,a�o_ingreso,tipo  "& vbCrLf &_
		   " from sd_cuentas_email_totales a,sis_usuarios b "& vbCrLf &_
		   " where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
		   " and b.pers_ncorr in (select distinct a.pers_ncorr from profesores a, contratos_docentes_upa b where a.pers_ncorr=b.pers_ncorr and b.ano_contrato=2009)  "& vbCrLf &_
		   " order by apellidos "		   

'response.Write("<pre>"&consulta&"</pre>")
'response.End()
formulario.Consultar consulta 
response.Write("username,password,idnumber,firstname,lastname,email")
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
				response.Write(email)
				Response.Write(vbCrLf)
wend

%>
