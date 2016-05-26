<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_moodle.asp" -->
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

set conexion_moodle = new cConexion2
conexion_moodle.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

archivo= request.QueryString("arch")
pestana= request.QueryString("pes")

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
SQLStr = "SELECT idnumber FROM ["&pestana&"$]" 

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

idnumber = Trim(rs.fields("idnumber").value) 

rs.MoveNext() 


'aaaa="select isnull(a.post_ncorr,0) from personas a, alumnos b,ofertas_academicas c where cast(pers_nrut as varchar)+'-'+pers_xdv='"&rut&"' and a.pers_ncorr=b.pers_ncorr and peri_ccod="&peri_ccod&" and b.ofer_ncorr=c.ofer_ncorr"
'bbbb="select count(*) from alumno_credito where post_ncorr="&post_ncorr&" and tdet_ccod="&tdet_ccod&""
	
		 usu=negocio.obtenerUsuario
	
	'response.Write("<BR>existe="&post_ncorr&"<BR>")
	sql_existe = "select case count(*) when 0 then 'N'else 'S' end from mdl_course where idnumber='"&idnumber&"'"
	existe=conexion_moodle.ConsultaUno(sql_existe)
	
	
	if existe="S" then
		
		sqlCO = "update mdl_course set enrollable=0 where idnumber='"&idnumber&"'" 
		
		LMAI_NCORR=conectar.ConsultaUno("exec ObtenerSecuencia 'log_marcado_alumno_intercambio'")
		
		'sqlLog="insert into log_marcado_alumno_intercambio (LMAI_NCORR,MATR_NCORR,AUDI_TUSUARIO,AUDI_FMODIFICACION,talu_ccod)values("&LMAI_NCORR&","&matr_ncorr&",'"&usu&"-mediante excel',getdate(),'"&talu_ccod&"')"
		
		conexion_moodle.ejecutaS(sqlCO)
		
		
		
		Respuesta = conexion_moodle.ObtenerEstadoTransaccion()
		'conectar.ejecutaS(sqlLog)
		'Respuesta = conectar.ObtenerEstadoTransaccion()
		response.Write("<BR>"&Respuesta&"<BR>")
		'response.Write("<BR>"&Respuesta2&"<BR>")
		
			'if Respuesta2="Falso"then
			response.Write("<BR>"&sqlCO&"<BR>")
'			end if
'			if Respuesta="Falso"then
'			response.Write("<BR>"&sqlLog&"<BR>")
'			end if
'		response.Write("<BR>"&sqlCO&"<BR>")
'		response.Write("<BR>"&sqlLog&"<BR>")
	
	
	contador=contador+1	
	end if
		
	
	wend
end if

'response.Write("<br> Fueron Procesadas "&contador2&" Aulas de los cuales "&contador&" fueron cerradas")
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
session("mensajeerror")= " Fueron Procesadas "&contador2&" Aulas de los cuales "&contador&" fueron cerradas"
response.Redirect("subir_excel.asp")
%>




