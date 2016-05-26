<!--#include file="../canvas.asp"-->
<!--#include file="class_request.asp"-->
<html>
<head>
<title>ASPCanvas Font maker</title>
</head>
<body>
<script language=javascript>
<!--
function ValidateForm(objForm)
{
	if(objForm.fontfile.value=='')
	{
		alert('Please select a file to upload');
		objForm.fontfile.focus();
		return false;
	}
	return true;
}
//-->
</script>
<h1>ASPCanvas Font Maker</h1>
<p>This application will generate font packs for ASPCanvas</p>
<p>Use the ASCII table below to generate the characters in the font you require</p>
<textarea cols="80" rows="2"><%Dim lTemp

For lTemp = 33 To 126
	Response.Write Chr(lTemp)
Next
%></textarea>
<form action="fontmaker.asp" method="post" enctype="multipart/form-data" onsubmit="return ValidateForm(this);">
Select font BMP file to upload:&nbsp;<input type="file" name="fontfile" id="fontfile"><br>
Enter width of the space character:&nbsp;<input type="text" name="spacewidth" value="10"><br>
Enter number of pixels to add either side of each character:&nbsp;<input type="text" name="border" value="0"><br>
<input type="submit" name="action" value="Create font pack">
</form>
<%
Dim objRequest, objCanvas, objBMP

Set objRequest = New ProxyRequest

if UCase(objRequest("action")) = "CREATE FONT PACK" then

	Set objBMP = Server.CreateObject("ADODB.Stream")

	objBMP.Type = 1
	objBMP.Open

	objBMP.Write objRequest("fontfile")
	objBMP.Position = 0
	objBMP.Type = 2
	objBMP.Charset = "x-ansi"

	Set objCanvas = New Canvas

	objCanvas.ErrorsToResponse = True
	objCanvas.ErrorsToImage = False
	objCanvas.BMPWarnings = False

	' Send in a stream for the bitmap
	objCanvas.LoadBMPFromStream objBMP

	Response.Write "Creating font pack"

%>
<textarea cols="80" rows="30"><%=objCanvas.CreateFontPack(CLng(objRequest("spacewidth")),CLng(objRequest("border")))%></textarea>
<%	
	objBMP.Close
	
	Set objBMP = Nothing
end if

Function ASCIIToUNICODE(sText)
	Dim lTemp, sTemp
	
	sTemp = ""
	
	if IsNull(sText) then
		ASCIIToUNICODE = ""
	else
		For lTemp = 1 To LenB(sText)
			sTemp = sTemp & Chr(AscB(MidB(sText,lTemp,1)))
		Next
	
		ASCIIToUNICODE = sTemp
	end if
End Function


%>
</body>
</html>
