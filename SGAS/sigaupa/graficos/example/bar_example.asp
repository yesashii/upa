<!--#include file="../canvas.asp"-->
<!--#include file="../charts/chart_bar.asp"-->
<!--#include file="../extra_fonts/lucida_8_point.asp"-->
<%

Dim objCanvas, objChart

Set objCanvas = New Canvas
Set objChart = New ChartBar

objCanvas.GlobalColourTable(0) = RGB(255,255,255)
objCanvas.GlobalColourTable(1) = RGB(0,0,0)
objCanvas.GlobalColourTable(2) = RGB(90,132,192)
objCanvas.GlobalColourTable(3) = RGB(35,95,59)
objCanvas.GlobalColourTable(4) = RGB(242,142,14)
objCanvas.GlobalColourTable(5) = RGB(134,160,6)

objCanvas.Resize 600,500,False

objCanvas.ForegroundColourIndex = 1

objCanvas.Rectangle 0,0,598,498

Set objChart.ActiveCanvas = objCanvas

objChart.Left = 50
objChart.Top = 50

objChart.Width = 540
objChart.Height = 380

objChart.Max = 120

objChart.Min = 0

objChart.Vertical = True

Dim objSet

Set objSet = objChart.AddSet()
'15823
objSet.Name = "Promedio Profesor"
objSet.AddPoints Array("METODOLOGIA",10,"INTERACCION",20,"ADMINISTRATIVO",30,"PUNTAJE TOTAL",40)
objSet.FillIndex = 2

Set objSet = objChart.AddSet()

objSet.Name = "Promedio Escuela"
objSet.AddPoints Array("METODOLOGIA",10,"INTERACCION",20,"ADMINISTRATIVO",30,"PUNTAJE TOTAL",40)
objSet.FillIndex = 3

Set objSet = objChart.AddSet()

objSet.Name = "Promedio Facultad"
objSet.AddPoints Array("METODOLOGIA",10,"INTERACCION",20,"ADMINISTRATIVO",30,"PUNTAJE TOTAL",40)
objSet.FillIndex = 4

Set objSet = objChart.AddSet()

objSet.Name = "Promedio Universidad"
objSet.AddPoints Array("METODOLOGIA",80,"INTERACCION",32,"ADMINISTRATIVO",8,"PUNTAJE TOTAL",40)
objSet.FillIndex = 5

objChart.Render

objCanvas.Write
%>