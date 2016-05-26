<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'-----------------------------------------------------
	'for each k in request.form
	'response.Write(k&" = "&request.Form(k)&"<br>")
	'next
'response.End()

server.ScriptTimeout = 150000 
set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar

archivo= request.form("b[0][arch]")
pestana= request.form("b[0][pes]")
peri_ccod=request.form("b[0][peri_ccod]")
talu_ccod=request.form("b[0][talu_ccod]")
trut1="\r Alumnos que tiene matricula pero no es activa"
trut2="\r Alumnos que No tiene matricula el semestre seleccionado"

response.Write("<br> archivo="&archivo)
response.Write("<br> pestana="&pestana&"<br>")
'response.End()
'Nos conectamos a la hoja de datos del Excel 
set cnn = createobject("ADODB.Connection")

'DB_CONNECTIONSTRING = "Driver={Microsoft Excel Driver (*.xls)};Dbq=" & archivo & ";" 
DB_CONNECTIONSTRING = "DRIVER={Microsoft Excel Driver (*.xls)};DBQ=" & server.mappath(".") & "\archivos\" &archivo 
cnn.open DB_CONNECTIONSTRING 
'Recordset sin especificar rango de celdas en excel (signo de pesos al final del nombre de la hoja de excel) 
set rs = createobject("ADODB.Recordset")
SQLStr = "SELECT rut FROM ["&pestana&"$]" 

on error resume next
rs.open SQLStr, DB_CONNECTIONSTRING

if err.number <> 0 then

''response.Write(err.number)
'session("mensajeerror")= "El nombre de La pestaña no es Correcto"
'response.Redirect("subir_excel.asp")
response.End()
else

rs.MoveFirst() 
contador=0
contador2=0
while not rs.EOF
contador2=contador2+1

rut = Trim(rs.fields("rut").value) 

rs.MoveNext() 


consulta_matr="select count(matr_ncorr) "& vbCrLf &_
			"from personas a,"& vbCrLf &_
			"alumnos b,"& vbCrLf &_
			"postulantes c"& vbCrLf &_
			"where a.pers_nrut="&rut&""& vbCrLf &_
			"and a.pers_ncorr=b.pers_ncorr"& vbCrLf &_
			"and b.pers_ncorr=c.pers_ncorr"& vbCrLf &_
			"and b.post_ncorr=c.post_ncorr"& vbCrLf &_
			"and c.peri_ccod="&peri_ccod&""& vbCrLf &_
			"and emat_ccod=1"
existe_matricula=conectar.ConsultaUno(consulta_matr)

'aaaa="select isnull(a.post_ncorr,0) from personas a, alumnos b,ofertas_academicas c where cast(pers_nrut as varchar)+'-'+pers_xdv='"&rut&"' and a.pers_ncorr=b.pers_ncorr and peri_ccod="&peri_ccod&" and b.ofer_ncorr=c.ofer_ncorr"
'response.Write("<BR>matr_ncorr="&matr_ncorr&"<BR>")
'bbbb="select count(*) from alumno_credito where post_ncorr="&post_ncorr&" and tdet_ccod="&tdet_ccod&""
	if cdbl(existe_matricula) >0 then
	
	consulta_matr="select matr_ncorr "& vbCrLf &_
			"from personas a,"& vbCrLf &_
			"alumnos b,"& vbCrLf &_
			"postulantes c"& vbCrLf &_
			"where a.pers_nrut="&rut&""& vbCrLf &_
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
		
		sqlLog="insert into log_marcado_alumno_intercambio (LMAI_NCORR,MATR_NCORR,AUDI_TUSUARIO,AUDI_FMODIFICACION,talu_ccod)values("&LMAI_NCORR&","&matr_ncorr&",'"&usu&"-mediante excel',getdate(),'"&talu_ccod&"')"
		
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
		contador=contador+1
		else
		
		c_matr_no_activa="select count(matr_ncorr) "& vbCrLf &_
			"from personas a,"& vbCrLf &_
			"alumnos b,"& vbCrLf &_
			"postulantes c"& vbCrLf &_
			"where a.pers_nrut="&rut&""& vbCrLf &_
			"and a.pers_ncorr=b.pers_ncorr"& vbCrLf &_
			"and b.pers_ncorr=c.pers_ncorr"& vbCrLf &_
			"and b.post_ncorr=c.post_ncorr"& vbCrLf &_
			"and c.peri_ccod="&peri_ccod&""& vbCrLf &_
			"and emat_ccod<>1"
			matr_no_activa=conectar.ConsultaUno(c_matr_no_activa)
			
			if matr_no_activa >0 then
				trut1=trut1&"\r "&rut&""
			end if
			
			
			consulta_no_tiene_matr="select count(matr_ncorr) "& vbCrLf &_
			"from personas a,"& vbCrLf &_
			"alumnos b,"& vbCrLf &_
			"postulantes c"& vbCrLf &_
			"where a.pers_nrut="&rut&""& vbCrLf &_
			"and a.pers_ncorr=b.pers_ncorr"& vbCrLf &_
			"and b.pers_ncorr=c.pers_ncorr"& vbCrLf &_
			"and b.post_ncorr=c.post_ncorr"& vbCrLf &_
			"and c.peri_ccod="&peri_ccod&""& vbCrLf &_
			"and emat_ccod=1"
no_tiene_matr=conectar.ConsultaUno(consulta_no_tiene_matr)

			if matr_no_activa =0 then
			trut2=trut2&"\r "&rut&""
			end if
			
		contador=contador+0
	end if
		
	
	wend
end if

'response.end()
'
'response.Write("<BR>"&contador&"<BR>")
'response.Write("<BR>"&contador2&"<BR>")
 'Se cierra y se destruye el objeto recordset 
 'response.end()
rs.close
 'rs = Nothing 
' Se cierra y se destruye la conexion al archivo 
 db.close
 'db = Nothing


'
'response.end()


'
'
'Respuesta = conectar.ObtenerEstadoTransaccion()
'----------------------------------------------------
session("mensajeerror")= " Fueron procesados "&contador2&"  alumnos de los cuales "&contador&" fueron guardados \r "&trut1&" \r "&trut2&""
response.Redirect("marca_alumno.asp")
%>




