<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%

'-----------------------------------------------------
	'for each k in request.form
	''response.Write(k&" = "&request.Form(k)&"<br>")
	'next
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
'response.Write(binData&"<br>")

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



strBoundry = Request.ServerVariables ("HTTP_CONTENT_TYPE")
lngBoundryPos = instr(1,strBoundry,"boundary=") + 8 
strBoundry = "--"& right(strBoundry,len(strBoundry)-lngBoundryPos)
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


if lngBeginFileName <> lngEndFileName Then
	strFilename = mid(strData,lngBeginFileName,lngEndFileName - lngBeginFileName)
	
	'response.Write("strDataWhole ="&strDataWhole&"<br>")
	'response.Write("lngBeginPestana= "&lngBeginPestana&"<br>")
	'response.Write("lngEndPestana ="&lngEndPestana&"<br>")
	' response.Write("StrPestana ="&StrPestana&"<br>")
	
	tmpLng = instr(1,strFilename,"\")
	Do While tmpLng > 0
	PrevPos = tmpLng
	tmpLng = instr(PrevPos + 1,strFilename,"\")
	Loop
	
	FileName = right(strFilename,len(strFileName) - PrevPos)
	
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
	
	server.ScriptTimeout = 50000 
	
	
	
set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar
	 	ncorr=conectar.ConsultaUno("exec ObtenerSecuencia 'ufe_salida_excel'")

arr_erchivo=split(FileName,".")

extension=arr_erchivo(1)		
FileName=arr_erchivo(0)&"_"&ncorr&"."&extension
	'Create the file. 
	Set fso = CreateObject("Scripting.FileSystemObject")
	Set f = fso.OpenTextFile(server.mappath(".") & "\archivos\"&FileName, ForWriting, True)
	f.Write strFileData
	
	'response.Write(f)
    'response.End()
	
	Set f = nothing
	Set fso = nothing

End if




'Get then next boundry postitions if any
' .
lngCurrentBegin = instr(1,strDataWhole,strBoundry)
lngCurrentEnd = instr(lngCurrentBegin + 1,strDataWhole,strBoundry) - 1



if extension="xls"  then
response.Redirect("comprueba_pestana.asp?arch="&FileName&"")
elseif  extension="xlsx" then
response.Redirect("comprueba_pestana_xlsx.asp?arch="&FileName&"")
end if
%>


