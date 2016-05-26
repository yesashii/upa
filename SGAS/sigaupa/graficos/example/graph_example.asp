<!--#include file="../canvas.asp"-->
<!--#include file="../charts/chart_graph.asp"-->
<!--#include file="../extra_fonts/lucida_8_point.asp"-->
<%

Dim objCanvas, objChart

Set objCanvas = New Canvas
Set objChart = New ChartGraph

objCanvas.GlobalColourTable(0) = RGB(255,255,255)
objCanvas.GlobalColourTable(1) = RGB(0,0,0)
objCanvas.GlobalColourTable(2) = RGB(255,0,0)
objCanvas.GlobalColourTable(3) = RGB(0,255,0)
objCanvas.GlobalColourTable(4) = RGB(0,0,255)

objCanvas.Resize 800,600,False

objCanvas.ForegroundColourIndex = 1

Set objChart.ActiveCanvas = objCanvas

objChart.Left = 50
objChart.Top = 50

objChart.Width = 630
objChart.Height = 480

objChart.MaxY = 500
objChart.MaxX = 500

objChart.MinX = 0
objChart.MinY = 0

Dim objSet

Set objSet = objChart.AddSet()

objSet.Name = "First set"
objSet.DotColourIndex = 3
objSet.AddPoints Array(10,10,20,20,30,30,40,60,80,90,45,87,45,76,44,35,68,44,77,17,74,36)
objSet.LinePattern = "3"
objSet.DrawRoot = False	
objSet.DrawValues = False
objSet.DrawName = False
objSet.DrawLines = True
objSet.DotCrossSize = 1

Set objSet = objChart.AddSet()

objSet.Name = "Second set"
objSet.DotColourIndex = 4
objSet.AddPoints Array(103,164,124,56,54,67,3,5,35,56,256,345)
objSet.LinePattern = "4"
objSet.DrawRoot = False	
objSet.DrawValues = False
objSet.DrawName = False
objSet.DotCrossSize = 1
objSet.DrawLines = True

Set objSet = objChart.AddSet()

objSet.Name = "Third set"
objSet.DotColourIndex = 2
objSet.AddPoints Array(20,30,50,60,40,70,80,100)
objSet.LinePattern = "2"
objSet.DrawRoot = False	
objSet.DrawValues = False
objSet.DrawName = False
objSet.DotCrossSize = 1
objSet.DrawLines = True

Set objSet = objChart.AddSet()

objSet.Name = "Fourth set with a long, long name"
objSet.DotColourIndex = 1
objSet.AddPoints Array(10,20,30,40,50,60,70,80)
objSet.LinePattern = "1"
objSet.DrawRoot = False	
objSet.DrawValues = False
objSet.DrawName = False
objSet.DotCrossSize = 1
objSet.DrawLines = True

objChart.DrawXAxisMajorValues = True
objChart.DrawYAxisMajorValues = True
objChart.DrawXAxisMinMaxValues = True
objChart.YAxisValueTextNS = False
objChart.XAxisTextOffset = 50
objChart.YAxisTextOffset = 50
objChart.XMajor = 100
objChart.YMajor = 100
'objChart.LegendY = -3

objChart.Render

objCanvas.Write
%>