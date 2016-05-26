<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
'-----------------------------------------------------
'	for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'	next
'response.End()

server.ScriptTimeout = 5000
set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar



archivo= request.QueryString("arch")
pestana= request.QueryString("pes")

response.Write("<br> archivo="&archivo)
response.Write("<br> pestana="&pestana&"<br>")

'Nos conectamos a la hoja de datos del Excel 
set db = server.createobject("ADODB.Connection")

'DB_CONNECTIONSTRING = "Driver={Microsoft Excel Driver (*.xls)};Dbq=" & archivo & ";" 
'DB_CONNECTIONSTRING = "DRIVER={Microsoft Excel Driver (*.xls)};DBQ=" & server.mappath(".") & "\archivos\" &archivo &";"
DB_CONNECTIONSTRING ="Provider=Microsoft.ACE.OLEDB.12.0;Data Source="&sFilePath&";Extended Properties="&CHR(034)&"Excel 12.0 Xml;HDR=YES;IMEX=1"&CHR(034)&";"

response.Write(DB_CONNECTIONSTRING)

db.open(DB_CONNECTIONSTRING) 

'Recordset sin especificar rango de celdas en excel (signo de pesos al final del nombre de la hoja de excel) 
set rs = server.createobject("ADODB.Recordset")

SQLStr = "SELECT rut FROM ["&pestana&"$]" 
rs.open SQLStr,DB_CONNECTIONSTRING

on error resume next
'response.Write("<br> error="&err.description)
'response.Write("<br> error="&err.number)

if err.number <> 0 then
'response.Write("1")
response.Redirect("borra_archivo.asp?arch="&archivo&"")

else
response.Redirect("marca_opcion.asp?arch="&archivo&"&pes="&pestana&"")
'response.Write("2")
end if

' Se cierra y se destruye la conexion al archivo 
 db.close
 rs.close

rs = Nothing 
db= Nothing
' Se cierra y se destruye la conexion al archivo 
'response.Write("<br> error="&err.description)
'response.Write("<br> error="&err.number)
'response.end()


'
 'Se cierra y se destruye el objeto recordset 
 'response.end()

 





%>




