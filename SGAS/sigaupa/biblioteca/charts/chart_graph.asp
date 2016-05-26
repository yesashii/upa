<%
' Generic charting object with support for multiple data sets
' Supports scattering and plain line graphing for mathematical plotting
Class Point
	Public X
	Public Y
End Class

Class ValueSet
	Public DrawDots
	Public DrawLines
	Public DotCrossSize
	Public DotColourIndex
	Public LinePattern
	Public Name
	Public DrawName
	Public DrawValues
	Public DrawRoot
	Public Points
	
	' Add a point, return the object
	Public Function AddPoint(lX,lY)
		Dim objTemp
		
		Set objTemp = New Point
		objTemp.X = lX
		objTemp.Y = lY

		Points.Add CStr(Points.Count + 1),objTemp
		
		Set AddPoint = objTemp
	End Function

	' Add an array of points
	Public Function AddPoints(aPoints)
		Dim lTemp

		' Must always be an even number of points in the array		
		if UBound(aPoints) Mod 2 <> 0 then
			For lTemp = 0 to UBound(aPoints) step 2
				AddPoint aPoints(lTemp),aPoints(lTemp+1)
			Next
		end if
	End Function
	
	Private Sub Class_Initialize()
		Set Points = Server.CreateObject("Scripting.Dictionary")
		DrawDots = True
		DrawLines = True
		DotCrossSize = 1
		DotColourIndex = 1
		LinePattern = "1"
		Name = "Empty set"
		DrawRoot = True
		DrawName = False
		DrawValues = False
	End Sub
	
	Private Sub Class_Terminate()
		Set Points = Nothing
	End Sub
End Class

Class ChartGraph
	Public ActiveCanvas

	Public Top
	Public Left
	Public Height
	Public Width
	
	Public AxisColourIndex
	
	Public XAxisOffset
	Public YAxisOffset
	
	Public XAxisText
	Public YAxisText
	
	Public XAxisTextOffset
	Public YAxisTextOffset
	
	Public XAxisValueTextNS
	Public YAxisValueTextNS
	
	Public DrawXAxis
	Public DrawYAxis

	Public DrawXAxisMinMaxValues
	Public DrawYAxisMinMaxValues

	Public DrawXAxisMajorValues
	Public DrawYAxisMajorValues

	Public DrawXAxisName
	Public DrawYAxisName
	
	Public DrawLegend
	Public LegendX
	Public LegendY
	Public LegendMargin
	Public ClearLegendBackground
	Public LegendBackgroundColourIndex
		
	Public MaxX
	Public MaxY
	
	Public MinX
	Public MinY
	
	Public XMinor
	Public XMajor
	
	Public YMinor
	Public YMajor

	Public MajorPipSize
	Public MinorPipSize
	
	Public DataSets
	
	Public Function AddSet()
		Dim objTemp
		
		Set objTemp = New ValueSet

		DataSets.Add CStr(DataSets.Count + 1),objTemp
		
		Set AddSet = objTemp
	End Function

	' All the hard work is done here	
	Public Sub Render()
		Dim XAxisLength, YAxisLength, sinPixelXRatio, sinPixelYRatio
		Dim lTemp, lOldColourIndex
		Dim aKeys, objSet, aKeys2, objPoint, lTemp2, lRealX, lRealY, lLastX, lLastY
		Dim lTempX, lTempY, lLegendWidth, lLegendHeight, lTextWidth, lCursorX, lCursorY, lTextHeight
		
		lOldColourIndex = ActiveCanvas.ForegroundColourIndex
		
		XAxisLength = Width - XAxisOffset
		YAxisLength = Height - YAxisOffset

		' Need to work out the scale for the chart
		sinPixelXRatio = XAxisLength / (MaxX - MinX) ' Pixels per X unit
		sinPixelYRatio = YAxisLength / (MaxY - MinY) ' Pixels per Y unit
		
		if DrawXAxis then
			ActiveCanvas.ForegroundColourIndex = AxisColourIndex
			' Draw the main axis
			ActiveCanvas.Line Left + XAxisOffset,Top + YAxisLength,Left + Width,Top + YAxisLength

			if DrawXAxisMinMaxValues then
				if XAxisValueTextNS then
					ActiveCanvas.DrawTextNS Left + XAxisOffset - ActiveCanvas.GetTextNSWidth(MaxX),Top + YAxisLength + MajorPipSize,CStr(MinX)
					ActiveCanvas.DrawTextNS Left + XAxisLength + XAxisOffset - ActiveCanvas.GetTextNSWidth(MaxX),Top + YAxisLength + MajorPipSize,CStr(MaxX)
				else
					ActiveCanvas.DrawTextWE Left + XAxisOffset - ActiveCanvas.GetTextWEWidth(MaxX),Top + YAxisLength + MajorPipSize,CStr(MinX)
					ActiveCanvas.DrawTextWE Left + XAxisLength + XAxisOffset - ActiveCanvas.GetTextWEWidth(MaxX),Top + YAxisLength + MajorPipSize,CStr(MaxX)
				end if
			end if

			' Do the minor X pips
			For lTemp = 0 To (MaxX - MinX) Step XMinor
				ActiveCanvas.Line Left + XAxisOffset + CInt(lTemp * sinPixelXRatio),Top + YAxisLength,Left + XAxisOffset + CInt(lTemp * sinPixelXRatio),Top + YAxisLength + MinorPipSize
			Next

			' Do the major X pips
			For lTemp = 0 To (MaxX - MinX) Step XMajor
				ActiveCanvas.Line Left + XAxisOffset + CInt(lTemp * sinPixelXRatio),Top + YAxisLength,Left + XAxisOffset + CInt(lTemp * sinPixelXRatio),Top + YAxisLength + MajorPipSize
				if DrawXAxisMajorValues then
					if XAxisValueTextNS then
						ActiveCanvas.DrawTextNS Left + XAxisOffset + CInt(lTemp * sinPixelXRatio) - ActiveCanvas.GetTextNSWidth(lTemp),Top + YAxisLength + MajorPipSize,CStr(lTemp)
					else
						ActiveCanvas.DrawTextWE Left + XAxisOffset + CInt(lTemp * sinPixelXRatio) - ActiveCanvas.GetTextWEWidth(lTemp),Top + YAxisLength + MajorPipSize,CStr(lTemp)
					end if
				end if
			Next

			if DrawXAxisName then
				ActiveCanvas.ForegroundColourIndex = LegendBackgroundColourIndex
				ActiveCanvas.FilledRectangle Left + CInt(Width / 2),Top + YAxisLength + XAxisTextOffset,Left + CInt(Width / 2) + ActiveCanvas.GetTextWEWidth(XAxisText),Top + YAxisLength + XAxisTextOffset + ActiveCanvas.GetTextWEHeight(XAxisText)
				ActiveCanvas.ForegroundColourIndex = AxisColourIndex
				ActiveCanvas.Rectangle Left + CInt(Width / 2),Top + YAxisLength + XAxisTextOffset,Left + CInt(Width / 2) + ActiveCanvas.GetTextWEWidth(XAxisText),Top + YAxisLength + XAxisTextOffset + ActiveCanvas.GetTextWEHeight(XAxisText)
				ActiveCanvas.DrawTextWE Left + CInt(Width / 2),Top + YAxisLength + XAxisTextOffset,XAxisText
			end if
		end if
	
		if DrawYAxis then
			objCanvas.ForegroundColourIndex = AxisColourIndex
			' Draw the main axis
			ActiveCanvas.Line Left + XAxisOffset,Top,Left + XAxisOffset,Top + YAxisLength

			if DrawYAxisMinMaxValues then
				if YAxisValueTextNS then
					ActiveCanvas.DrawTextNS Left + YAxisOffset - MajorPipSize - ActiveCanvas.GetTextNSWidth(MinY),Top + YAxisLength,CStr(MinY)
					ActiveCanvas.DrawTextNS Left + YAxisOffset - MajorPipSize - ActiveCanvas.GetTextNSWidth(MaxY),Top,CStr(MaxY)
				else
					ActiveCanvas.DrawTextWE Left + YAxisOffset - MajorPipSize - ActiveCanvas.GetTextWEWidth(MinY),Top + YAxisLength,CStr(MinY)
					ActiveCanvas.DrawTextWE Left + YAxisOffset - MajorPipSize - ActiveCanvas.GetTextWEWidth(MaxY),Top,CStr(MaxY)
				end if
			end if
					
			' Do the minor Y pips
			For lTemp = 0 To (MaxY - MinY) Step YMinor
				ActiveCanvas.Line Left + XAxisOffset,Top + YAxisLength - CInt(lTemp * sinPixelYRatio),Left + XAxisOffset - MinorPipSize,Top + YAxisLength - CInt(lTemp * sinPixelYRatio)
			Next

			' Do the major Y pips
			For lTemp = 0 To (MaxY - MinY) Step YMajor
				ActiveCanvas.Line Left + XAxisOffset,Top + YAxisLength - CInt(lTemp * sinPixelYRatio),Left + XAxisOffset - MajorPipSize,Top + YAxisLength - CInt(lTemp * sinPixelYRatio)
				if DrawYAxisMajorValues then
					if YAxisValueTextNS then
						ActiveCanvas.DrawTextNS Left + YAxisOffset - MajorPipSize - ActiveCanvas.GetTextNSWidth(lTemp),Top + YAxisLength - CInt(lTemp * sinPixelYRatio),CStr(lTemp)
					else
						ActiveCanvas.DrawTextWE Left + YAxisOffset - MajorPipSize - ActiveCanvas.GetTextWEWidth(lTemp),Top + YAxisLength - CInt(lTemp * sinPixelYRatio),CStr(lTemp)
					end if
				end if
			Next
			
			' Draw axis labels
			if DrawYAxisName then
				ActiveCanvas.ForegroundColourIndex = LegendBackgroundColourIndex
				ActiveCanvas.FilledRectangle Left + YAxisOffset - YAxisTextOffset - ActiveCanvas.GetTextNSWidth(YAxisText),Top + CInt(Height / 2),Left + YAxisOffset - YAxisTextOffset,Top + CInt(Height / 2) + ActiveCanvas.GetTextNSHeight(YAxisText)
				ActiveCanvas.ForegroundColourIndex = AxisColourIndex
				ActiveCanvas.Rectangle Left + YAxisOffset - YAxisTextOffset - ActiveCanvas.GetTextNSWidth(YAxisText),Top + CInt(Height / 2),Left + YAxisOffset - YAxisTextOffset,Top + CInt(Height / 2) + ActiveCanvas.GetTextNSHeight(YAxisText)
				ActiveCanvas.DrawTextNS Left + YAxisOffset - YAxisTextOffset - ActiveCanvas.GetTextNSWidth(YAxisText),Top + CInt(Height / 2),YAxisText
			end if
		end if
		
		' Now draw the data
		' Iterate through all the datasets		
		aKeys = DataSets.Keys
		
		For lTemp = 0 to UBound(aKeys)
			Set objSet = DataSets(aKeys(lTemp))
			aKeys2 = objSet.Points.Keys
			if objSet.DrawRoot then
				lLastX = Left + XAxisOffset
				lLastY = Top + Height - YAxisOffset
			else
				lLastX = -1
				lLastY = -1
			end if
			if objSet.DrawLines then
				For lTemp2 = 0 to UBound(aKeys2)
					Set objPoint = objSet.Points(aKeys2(lTemp2))
					lRealX = Left + XAxisOffset + CInt((objPoint.X - MinX) * sinPixelXRatio)
					lRealY = Top + Height - YAxisOffset - CInt((objPoint.Y - MinY) * sinPixelYRatio)
					if lLastX = -1 and lLastY = -1 then
						lLastX = lRealX
						lLastY = lRealY
					end if
					ActiveCanvas.CustomLine lLastX,lLastY,lRealX,lRealY,objSet.LinePattern
					lLastX = lRealX
					lLastY = lRealY
				Next
			end if
			if objSet.DrawDots then
				For lTemp2 = 0 to UBound(aKeys2)
					Set objPoint = objSet.Points(aKeys2(lTemp2))
					lRealX = Left + XAxisOffset + CInt((objPoint.X - MinX) * sinPixelXRatio)
					lRealY = Top + Height - YAxisOffset - CInt((objPoint.Y - MinY) * sinPixelYRatio)
					if objSet.DotCrossSize > 1 then
						' Draw a cross
						ActiveCanvas.CustomLine lRealX - objSet.DotCrossSize,lRealY,lRealX + objSet.DotCrossSize,lRealY,CStr(objSet.DotColourIndex)
						ActiveCanvas.CustomLine lRealX,lRealY - objSet.DotCrossSize,lRealX,lRealY + objSet.DotCrossSize,CStr(objSet.DotColourIndex)
					else
						ActiveCanvas.Pixel(lRealX,lRealY) = objSet.DotColourIndex
					end if
					if objSet.DrawValues then
						ActiveCanvas.ForegroundColourIndex = objSet.DotColourIndex
						ActiveCanvas.DrawTextWE lRealX,lRealY,"(" & objPoint.X & "," & objPoint.Y & ")"
					end if
					lLastX = lRealX
					lLastY = lRealY
				Next
			end if
			if objSet.DrawName then	
				ActiveCanvas.ForegroundColourIndex = objSet.DotColourIndex
				ActiveCanvas.DrawTextWE lLastX,lLastY - ActiveCanvas.GetTextWEHeight(objSet.Name),objSet.Name
			end if
		Next

		If DrawLegend then
			' Draw the legend for all sets of data
			' The X and Y positions denote where the legend should sit
			' LegendX: -1=Right, -2=Left, -3=Center
			' LegendY: -1=Top, -2=Bottom, -3=Middle
			' Any positive values indicate that the legend is in a static position
			' lLegendWidth = Max set name width + (margin * 2) + (border * 2)
			' lLegendHeight = (Lines + 1) * font height + (margin * 2) + (border * 2)
			lLegendWidth = LegendMargin * 2 + 2 + 10
			lLegendHeight = LegendMargin * 2 + 2
			
			lLegendHeight = lLegendHeight + (ActiveCanvas.GetTextWEHeight("a") * (DataSets.Count + 1))
			
			lTextWidth = ActiveCanvas.GetTextWEWidth("Legend:")
			
			aKeys = DataSets.Keys
			
			For lTemp = 0 to UBound(aKeys)
				if ActiveCanvas.GetTextWEWidth(DataSets.Item(aKeys(lTemp)).Name) > lTextWidth then
					lTextWidth = ActiveCanvas.GetTextWEWidth(DataSets.Item(aKeys(lTemp)).Name)
				end if
			Next

			lLegendWidth = lLegendWidth + lTextWidth
			
			Select Case LegendX
				Case -1
					lTempX = Left + Width - lLegendWidth
				Case -2
					lTempX = Left + XAxisOffset + 3
				Case -3
					lTempX = Left + CInt(Width / 2) - CInt(lLegendWidth / 2)
				Case Else
					lTempX = LegendX
			End Select

			Select Case LegendY
				Case -1
					lTempY = Top
				Case -2
					lTempY = Top + YAxisLength - lLegendHeight
				Case -3
					lTempY = Top + CInt(Height / 2) - CInt(lLegendHeight / 2)
				Case Else
					lTempY = LegendY
			End Select
			
			lCursorX = lTempX + 1 + LegendMargin
			lCursorY = lTempY + 1 + LegendMargin

			if ClearLegendBackground then
				ActiveCanvas.ForegroundColourIndex = LegendBackgroundColourIndex
				ActiveCanvas.FilledRectangle lTempX,lTempY,lTempX + lLegendWidth,lTempY + lLegendHeight
			end if

			ActiveCanvas.ForegroundColourIndex = AxisColourIndex			
			ActiveCanvas.Rectangle lTempX,lTempY,lTempX + lLegendWidth,lTempY + lLegendHeight
			ActiveCanvas.DrawTextWE lCursorX, lCursorY, "Legend:"

			lCursorX = lCursorX + 10

			lCursorY = lCursorY + ActiveCanvas.GetTextWEHeight("a")

			lTextHeight = ActiveCanvas.GetTextWEHeight("a")

			For lTemp = 0 to UBound(aKeys)
				ActiveCanvas.CustomLine lCursorX,lCursorY + CInt(lTextHeight / 2),lCursorX - 10,lCursorY + CInt(lTextHeight / 2),DataSets.Item(aKeys(lTemp)).LinePattern
				ActiveCanvas.DrawTextWE lCursorX, lCursorY, DataSets.Item(aKeys(lTemp)).Name
				lCursorY = lCursorY + lTextHeight
			Next
		end if

		ActiveCanvas.ForegroundColourIndex = lOldColourIndex
	End Sub

	Private Sub Class_Initialize()
		Set ActiveCanvas = Nothing

		' Data set dictionary
		Set DataSets = Server.CreateObject("Scripting.Dictionary")

		Top = 0
		Left = 0
		Height = 100
		Width = 100
		
		AxisColourIndex = 1
		
		XAxisOffset = 15 ' 15 from the left
		YAxisOffset = 15 ' 15 from the bottom
		
		XAxisText = "X Axis"
		YAxisText = "Y Axis"

		XAxisTextOffset = 10
		YAxisTextOffset = 10

		XAxisValueTextNS = True
		YAxisValueTextNS = True
		
		DrawXAxis = True
		DrawYAxis = True
		
		MaxX = 100
		MaxY = 100

		MinX = 0
		MinY = 0

		XMinor = 5
		XMajor = 25
		
		YMinor = 5
		YMajor = 25

		MajorPipSize = 10
		MinorPipSize = 5

		DrawXAxisMinMaxValues = True
		DrawYAxisMinMaxValues = True
		
		DrawXAxisMajorValues = False
		DrawYAxisMajorValues = False

		DrawXAxisName = True
		DrawYAxisName = True

		DrawLegend = True
		LegendX = -1 ' Right hand side
		LegendY = -1 ' Top
		LegendMargin = 3 ' Pixels
		ClearLegendBackground = True
		LegendBackgroundColourIndex = 0
	End Sub
	
	Private Sub Class_Terminate()
		Set DataSets = Nothing
	End Sub
End Class
%>