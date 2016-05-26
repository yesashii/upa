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
arancel=request.form("b[0][arancel]")
mantencion=request.form("b[0][mantencion]")
peri_ccod=request.form("b[0][peri_ccod]")
if arancel <>"" then
tdet_ccod=arancel
end if
if mantencion <>"" then
tdet_ccod=mantencion
end if

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

response.Write(err.number)
'session("mensajeerror")= "El nombre de La pestaña no es Correcto"
'response.Redirect("subir_excel.asp")
else

rs.MoveFirst() 
contador=0
contador2=0
While Not rs.eof 
contador2=contador2+1
'Inserto los registros 
docto = "" 
mvt = "" 
mat = "" 
loc = "" 
fec = "" 

rut = Trim(rs.fields("rut").value) 
rs.MoveNext() 
'Conexion para insertar la compañía en caso de que no exista  conectar.ConsultaUno(
post_ncorr=conectar.ConsultaUno("select isnull(b.post_ncorr,0) from personas a, alumnos b,ofertas_academicas c where cast(pers_nrut as varchar)+'-'+pers_xdv='"&rut&"' and a.pers_ncorr=b.pers_ncorr and peri_ccod="&peri_ccod&" and b.ofer_ncorr=c.ofer_ncorr")

'aaaa="select isnull(a.post_ncorr,0) from personas a, alumnos b,ofertas_academicas c where cast(pers_nrut as varchar)+'-'+pers_xdv='"&rut&"' and a.pers_ncorr=b.pers_ncorr and peri_ccod="&peri_ccod&" and b.ofer_ncorr=c.ofer_ncorr"

'bbbb="select count(*) from alumno_credito where post_ncorr="&post_ncorr&" and tdet_ccod="&tdet_ccod&""
	if post_ncorr <>"" then
	
	existe=conectar.ConsultaUno("select count(*) from alumno_credito where post_ncorr="&post_ncorr&" and tdet_ccod="&tdet_ccod&"")
	 usu=negocio.obtenerUsuario
	'response.Write("<BR>post_ncorr="&existe&"<BR>")
	'response.Write("<BR>existe="&post_ncorr&"<BR>")
		if existe =0 then
		acre_ncorr=conectar.ConsultaUno("exec ObtenerSecuencia 'alumno_credito'")
		
		sqlCO = "insert into alumno_credito (acre_ncorr,post_ncorr,tdet_ccod,audi_tusuario,audi_fmodificacion) values ("&acre_ncorr&"," & post_ncorr & "," & tdet_ccod & ",'"&usu&" mediante subida masiva con excel',getdate())" 
		
		losx_ncorr=conectar.ConsultaUno("exec ObtenerSecuencia 'log_subidos_excel'")
		
		sqlLog="insert into log_subidos_excel (losx_ncorr,post_ncorr,acre_ncorr,tdet_ccod,audi_tusuario,audi_fmodificacion) values("&losx_ncorr&","&post_ncorr&","&acre_ncorr&","&tdet_ccod&",'"&usu&"',getdate())"
		
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
		'response.Write("<BR>"&sqlCO&"<BR>")
		'response.Write("<BR>"&sqlLog&"<BR>")
		contador=contador+1
		else
		contador=contador+0
		end if
		
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



'
'
'Respuesta = conectar.ObtenerEstadoTransaccion()
'----------------------------------------------------
session("mensajeerror")= " Fueron procesados "&contador2&" alumnos de los cuales "&contador&" fueron guardados"
response.Redirect("subir_excel.asp")
%>




