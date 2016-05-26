<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%

'for each x in request.Form
'	response.Write(x&"->"&request.Form(x)&"<br>")
'next
'response.End()


' Valida  que no existan archivos cargados con anterioridad vacios.
set conexion = new CConexion
conexion.Inicializar "upacifico"

sql_elimina="delete from pago_electronico_pagare_upa where ingr_nfolio_referencia is null and protic.trunc(audi_fmodificacion) > protic.trunc(getdate())"
conexion.EstadoTransaccion conexion.EjecutaS(sql_elimina) 


ForWriting = 2
adLongVarChar = 201
lngNumberUploaded = 0

'Get binary data from form 
noBytes = Request.TotalBytes 
binData = Request.BinaryRead (noBytes)

'convery the binary data to a string
Set RST = CreateObject("ADODB.Recordset")
LenBinary = LenB(binData)

if LenBinary > 0 Then
	RST.Fields.Append "myBinary", adLongVarChar, LenBinary
	RST.Open
	RST.AddNew
	RST("myBinary").AppendChunk BinData
	RST.Update
	strDataWhole = RST("myBinary")
End if


'get the boundary indicator
strBoundry = Request.ServerVariables ("HTTP_CONTENT_TYPE")
lngBoundryPos = instr(1,strBoundry,"boundary=") + 9 
strBoundry = "--" & right(strBoundry,len(strBoundry)-lngBoundryPos)

'Get first file boundry positions.
lngCurrentBegin = instr(1,strDataWhole,strBoundry)
lngCurrentEnd = instr(lngCurrentBegin + 1,strDataWhole,strBoundry) - 1
Do While lngCurrentEnd > 0

'Get the data between current boundry and remove it from the whole.
strData = mid(strDataWhole,lngCurrentBegin, lngCurrentEnd - lngCurrentBegin)
strDataWhole = replace(strDataWhole,strData,"")

'Get the full path of the current file.
lngBeginFileName = instr(1,strdata,"filename=") + 10
lngEndFileName = instr(lngBeginFileName,strData,chr(34)) 

'Make sure they selected at least one file. 
if lngBeginFileName = lngEndFileName and lngNumberUploaded = 0 Then
	Response.Write "<H2> Ha ocurrido el siguiente error.</H2>"
	Response.Write "Debes elegir un archivo para subir"
	Response.Write "<BR><BR>Pulsa el botón volver, realiza la corrección."
	Response.Write "<BR><BR><INPUT type='button' onclick='history.go(-1)' value='<< Volver' id='button'1 name='button'1>"
	Response.End 
End if
'There could be one or more empty file boxes. 
if lngBeginFileName <> lngEndFileName Then
strFilename = mid(strData,lngBeginFileName,lngEndFileName - lngBeginFileName)

'Loose the path information and keep just the file name. 
tmpLng = instr(1,strFilename,"\")
Do While tmpLng > 0
PrevPos = tmpLng
tmpLng = instr(PrevPos + 1,strFilename,"\")
Loop

FileName = right(strFilename,len(strFileName) - PrevPos)

'Get the begining position of the file data sent.
'if the file type is registered with the browser then there will be a Content-Type
lngCT = instr(1,strData,"Content-Type:")

if lngCT > 0 Then
lngBeginPos = instr(lngCT,strData,chr(13) & chr(10)) + 4
Else
lngBeginPos = lngEndFileName
End if
'Get the ending position of the file data sent.
lngEndPos = len(strData) 

'Calculate the file size. 
lngDataLenth = lngEndPos - lngBeginPos
'Get the file data 
strFileData = mid(strData,lngBeginPos,lngDataLenth)
'Create the file. 
Set fso = CreateObject("Scripting.FileSystemObject")
Set f   = fso.OpenTextFile(server.mappath("..") & "\archivos_pagare_upa_electronico\"&FileName, ForWriting, True)
f.Write strFileData
Set f = nothing
Set fso = nothing

lngNumberUploaded = lngNumberUploaded + 1

End if

'Get then next boundry postitions if any
lngCurrentBegin = instr(1,strDataWhole,strBoundry)
lngCurrentEnd = instr(lngCurrentBegin + 1,strDataWhole,strBoundry) - 1
loop

session("nombre_archivo")	= 	FileName
session("msg_exito") 		= 	"Archivo subido con nombre: <b>"&FileName&"</b> y ya está en el servidor para validar.<BR>"

response.Redirect("revisar_archivo_pagare_upa_electronico.asp?q_leng=2")


%>