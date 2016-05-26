<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'-----------------------------------------------------
'	for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'	next
'response.End()

server.ScriptTimeout = 50000 
set conectar = new cconexion
conectar.inicializar "upacifico"
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
'SQLStr = "SELECT rut,nombre,carrera FROM [Hoja1$]"
on error resume next


rs.open SQLStr, DB_CONNECTIONSTRING


'response.Write(aaa)
'response.End()
if err.number <> 0 then

response.Redirect("borra_archivo.asp?arch="&archivo&"")

else
response.Redirect("proc_cierra_aula.asp?arch="&archivo&"&pes="&pestana&"")

end if
'
 'Se cierra y se destruye el objeto recordset 
 'response.end()
rs.close
' Se cierra y se destruye la conexion al archivo 
 db.close
%>




