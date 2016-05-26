<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->



<%
'-----------------------------------------------------
'	for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'	next
'response.End()

set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar


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
'Creates a raw data file for with all da
' ta sent. Uncomment for debuging. 
'Set fso = CreateObject("Scripting.FileSystemObject")
'Set f = fso.OpenTextFile(server.mappath(".") & "\raw.txt", ForWriting, True)
'f.Write strDataWhole
'set f = nothing
'set fso = nothing
'get the boundry indicator
strBoundry = Request.ServerVariables ("HTTP_CONTENT_TYPE")
lngBoundryPos = instr(1,strBoundry,"boundary=") + 8 
strBoundry = "--" & right(strBoundry,len(strBoundry)-lngBoundryPos)
'Get first file boundry positions.
lngCurrentBegin = instr(1,strDataWhole,strBoundry)
lngCurrentEnd = instr(lngCurrentBegin + 1,strDataWhole,strBoundry) - 1
'Get the data between current boundry an
' d remove it from the whole.
strData = mid(strDataWhole,lngCurrentBegin, lngCurrentEnd - lngCurrentBegin)
strDataWhole = replace(strDataWhole,strData,"")

'Get the full path of the current file.
lngBeginFileName = instr(1,strdata,"filename=") + 10
lngEndFileName = instr(lngBeginFileName,strData,chr(34))
lngBeginPestana= instr(1,strDataWhole,"name=") + 26
lngEndPestana = instr(lngBeginPestana,strDataWhole,chr(45)) 
'Make sure they selected at least one fi
' le. 
if lngBeginFileName = lngEndFileName and lngNumberUploaded = 0 Then


session("mensajeerror")= " Debe Ingresar un archivo"
End if
'There could be one or more empty file b
' oxes. 
if lngBeginFileName <> lngEndFileName Then
strFilename = mid(strData,lngBeginFileName,lngEndFileName - lngBeginFileName)
StrPestana= mid(strDataWhole,lngBeginPestana,lngEndPestana - lngBeginPestana) 
'Creates a raw data file with data betwe
' en current boundrys. Uncomment for debug
' ing. 
'Set fso = CreateObject("Scripting.FileSystemObject")
'Set f = fso.OpenTextFile(server.mappath(".") & "\raw_" & lngNumberUploaded & ".txt", ForWriting, True)
'f.Write strData
'set f = nothing
'set fso = nothing

'Loose the path information and keep jus
' t the file name. 
tmpLng = instr(1,strFilename,"\")
Do While tmpLng > 0
PrevPos = tmpLng
tmpLng = instr(PrevPos + 1,strFilename,"\")
Loop

FileName = right(strFilename,len(strFileName) - PrevPos)


'Get the begining position of the file d
' ata sent.
'if the file type is registered with the
' browser then there will be a Content-Typ
' e
lngCT = instr(1,strData,"Content-Type:")

if lngCT > 0 Then
lngBeginPos = instr(lngCT,strData,chr(13) & chr(10)) + 4
Else
lngBeginPos = lngEndFileName
End if
'Get the ending position of the file dat
' a sent.
lngEndPos = len(strData) 

'Calculate the file size. 
lngDataLenth = lngEndPos - lngBeginPos
'Get the file data 
strFileData = mid(strData,lngBeginPos,lngDataLenth)
'Create the file. 
Set fso = CreateObject("Scripting.FileSystemObject")
Set f = fso.OpenTextFile(server.mappath(".") & "\archivos\"&FileName, ForWriting, True)
'Set f = fso.OpenTextFile("C:\" &FileName, ForWriting, True)
f.Write strFileData
Set f = nothing
Set fso = nothing
'lngNumberUploaded = lngNumberUploaded + 1

End if

'Get then next boundry postitions if any
' .
lngCurrentBegin = instr(1,strDataWhole,strBoundry)
lngCurrentEnd = instr(lngCurrentBegin + 1,strDataWhole,strBoundry) - 1


response.Redirect("comprueba_pestana.asp?arch="&FileName&"&pes="&StrPestana&"")
'response.write("<BR>=inserta_registros_proc.asp?arch="&FileName&"&pes="&StrPestana&"")
'response.Write("<BR>"&FileName)
'response.Write("<BR>"&StrPestana)
'response.end()

'response.Redirect("inserta_registros_proc.asp?arch="&FileName&"")
'----------------------------------------------------
'response.Write("respuesta "&Respuesta)
'if Respuesta = true then
'session("mensajeerror")= " El alumno fue ingresado con Éxito"
'else
'  session("mensajeerror")= "Error al guardar "
'end if
''response.End()
'
'response.Redirect(request.ServerVariables("HTTP_REFERER"))
'response.Redirect("creditos.asp")
%>


