<%
' First, we include the correct files for this project
%>
<!--#include file="../canvas.asp"-->
<!--#include file="../font.asp"-->
<%
' Display an example image
Dim objCanvas

' Create an instance of our Canvas object
Set objCanvas = New Canvas

' Give the canvas two colours, black and white
objCanvas.GlobalColourTable(0) = RGB(255,255,255)
objCanvas.GlobalColourTable(1) = RGB(0,0,0)

' Set the canvas size, false tells the canvas not to keep the existing image
objCanvas.Resize 320,240,False
' Set the drawing pen to colour index 1 (black in this case)
objCanvas.ForegroundColourIndex = 1

' Find out what we're going to draw
Select Case Request("type")
	Case "circle" ' Circle drawing
		objCanvas.DrawTextWE 20,20,"Drawing a circle"
		objCanvas.Circle CLng(Request("x")),CLng(Request("y")),CLng(Request("radius"))
	Case "square" ' Square drawing
		objCanvas.DrawTextWE 20,20,"Drawing a square"
		objCanvas.Rectangle CLng(Request("x")),CLng(Request("y")),10,10
	Case "line" ' Line drawing
		objCanvas.DrawTextWE 20,20,"Drawing a line"
		objCanvas.Line CLng(Request("x")),CLng(Request("y")),10,10
End Select

' Draw a surrounding rectangle
objCanvas.Rectangle 0,0,319,239

' Send the image to the browser
objCanvas.Write
%>