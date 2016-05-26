<% 
option explicit
Response.Expires = -1
Server.ScriptTimeout = 600
%>
<!-- #include file="freeaspupload.asp" -->
<%
' ****************************************************
' Cambiar el valor de la siguiente variable
' para indicar el directorio de destino.
' El directorio indicado debe tener permisos de escritura
' de caso contrario el script fallará mostrando un error.
  Dim uploadsDirVar
  uploadsDirVar = server.mappath(".") & "\archivos\" 
' ****************************************************

function SaveFiles
    Dim Upload, fileName, fileSize, ks, i, fileKey, resumen
    Set Upload = New FreeASPUpload
    Upload.Save(uploadsDirVar)
	' If something fails inside the script, but the exception is handled
	If Err.Number <> 0 then Exit function
    SaveFiles = ""
    ks = Upload.UploadedFiles.keys
    if (UBound(ks) <> -1) then
		resumen = "<B>Archivos subidos:</B> "
        for each fileKey in Upload.UploadedFiles.keys
			resumen = resumen & Upload.UploadedFiles(fileKey).FileName & " (" & Upload.UploadedFiles(fileKey).Length & "B) "
        next
    else
		resumen = "El nombre del archivo especificado en el formulario no es valido en el sistema."
    end if
	'comentar la siguiente linea si no se desea mostrar el resumen
'	SaveFiles = resumen
end function
%>

<HTML>
<HEAD>
<TITLE>Test Free ASP Upload</TITLE>
</HEAD>
<BODY>
<br>
<div style="border-bottom: #A91905 2px solid;font-size:16">Subir archivos</div>
<div style='margin-left:150'>

<form name="frmSend" method="POST" enctype="multipart/form-data" action="pruebaupload.asp">
Archivo 1: <input name="attach1" type="file" size="35"><br>
Archivo 2: <input name="attach2" type="file" size="35"><br>
Archivo 3: <input name="attach3" type="file" size="35"><br>
Archivo 4: <input name="attach4" type="file" size="35"><br>
<br> 
<input type=submit value="Upload">
</form>

<BR></div>
<%
'solo llamo al UPLOAD si hay envio de formulario
if Request.ServerVariables("REQUEST_METHOD") = "POST" then
	'Hace el upload de los archivos enviados y muestra el resumen	
	response.write SaveFiles()
end if
%>
</BODY>
</HTML>
