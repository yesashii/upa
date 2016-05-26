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

response.End()

Set conn = Server.CreateObject("ADODB.Connection") 
strConn = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & _ Server.MapPath(".") & "\archivos\"& "Extended Properties=""text;HDR=Yes;FMT-Delimited"";" 
conn.Open strConn 
Set rs = Server.CreateObject("ADODB.recordset") 

on error resume next
rs.open "SELECT * FROM "&archivo&".csv", conn 
while not rs.eof     

if contador2=0 then
For iCont = 0 to rs.Fields.Count - 1 
campo =rs.Fields(iCont).name
Response.Write (campo&"<br>")
Next 
end if
'campo = rs.fields.Item(contador2).Name
'response.Write("<br>"&campo)

rs.MoveNext() 
contador2=contador2+1


    
rs.movenext 
wend 




response.End()
'Nos conectamos a la hoja de datos del Excel 
set cnn = createobject("ADODB.Connection")

'DB_CONNECTIONSTRING = "Driver={Microsoft Excel Driver (*.xls)};Dbq=" & archivo & ";" 
DB_CONNECTIONSTRING = "DRIVER={Microsoft Excel Driver (*.xls)};DBQ=" & server.mappath(".") & "\archivos\" &archivo 
cnn.open DB_CONNECTIONSTRING 
'Recordset sin especificar rango de celdas en excel (signo de pesos al final del nombre de la hoja de excel) 
set rs = createobject("ADODB.Recordset")
SQLStr = "SELECT * FROM [Hoja1$]" 
'SQLStr = "SELECT rut,nombre,carrera FROM [Hoja1$]"
on error resume next
response.Write(SQLStr)

rs.open SQLStr, DB_CONNECTIONSTRING


'response.Write(err.number)
'response.Write(pestana)
'response.End()

if err.number <> 0 then

response.Write("<br>SE BORRA")
'response.Redirect("borra_archivo.asp?arch="&archivo&"")
contador2=0
else
response.Write("<br>SE QUEDA")



columnas = rs.Fields.Count
rs.MoveFirst() 
response.Write("<br>"&columnas)
While Not rs.eof 
if contador2=0 then
For iCont = 0 to rs.Fields.Count - 1 
campo =rs.Fields(iCont).name
Response.Write (campo&"<br>")
Next 
end if
'campo = rs.fields.Item(contador2).Name
'response.Write("<br>"&campo)

rs.MoveNext() 
contador2=contador2+1
	wend


end if
'
 'Se cierra y se destruye el objeto recordset 
 'response.end()
rs.close
' Se cierra y se destruye la conexion al archivo 
 db.close
%>




