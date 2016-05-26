<%
Class Point
	Public Category
	Public Value
	
	Private Sub Class_Initialize()
		Category = ""
		Value = 0
	End Sub
End Class

Class ValueSet
	Public DrawFill
	Public DrawBorder
	Public FillIndex
	Public BorderIndex
	Public Name
	
	Public Points

	Public Function AddPoint(sCategory,lValue)
		Dim objTemp, lTemp
		
		Set objTemp = New Point
		objTemp.Category = sCategory
		objTemp.Value = lValue
		
		if Points.Exists(sCategory) then
			Points(sCategory).Value = Points(sCategory).Value + lValue
		else
			Points.Add sCategory,objTemp
		End if
		
		Set AddPoint = objTemp
	End Function

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
		DrawFill = True
		DrawBorder = False
		FillIndex = 1
		BorderIndex = 1
		Name = "Empty set"
	End Sub
	
	Private Sub Class_Terminate()
		Set Points = Nothing
	End Sub
End Class

Class ChartBar
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
	
	Public DrawXAxis
	Public DrawYAxis

	Public DrawMinMaxValues
	Public DrawMajorValues

	Public DrawLegend
	Public LegendX
	Public LegendY
	Public LegendMargin
	Public ClearLegendBackground
	Public LegendBackgroundColourIndex
		
	Public Max	
	Public Min
	
	Public Minor
	Public Major
	
	Public MajorPipSize
	Public MinorPipSize
	
	Public Vertical
	
	Public DataSets

	Public Function AddSet()
		Dim objTemp
		
		Set objTemp = New ValueSet

		DataSets.Add CStr(DataSets.Count + 1),objTemp
		
		Set AddSet = objTemp
	End Function

	' This function should really build up a list of unique categories
	Function BuildCategories()
		' MaxCategories is the highest count of categories
		Dim lCount, aKeys, aKeys2, aKeys3, lTemp, lTemp2, lTemp3, lTemp4
		Dim bFound, sCategory, objSet, objSet2, sCategories
		
		lCount = 0
		
		aKeys = DataSets.Keys()
		
		sCategories = ""
		
		For lTemp = 0 To UBound(aKeys)
			Set objSet = DataSets(aKeys(lTemp))
			aKeys2 = objSet.Points.Keys()
			For lTemp2 = 0 To UBound(aKeys2)
				sCategory = objSet.Points(aKeys2(lTemp2)).Category
				bFound = False
				For lTemp3 = lTemp To UBound(aKeys)
					Set objSet2 = DataSets(aKeys(lTemp3))
					aKeys3 = objSet2.Points.Keys()
					For lTemp4 = 0 To UBound(aKeys3)
						if objSet2.Points(aKeys3(lTemp4)).Category = sCategory and (lTemp <> lTemp3 or lTemp2 <> lTemp4) then
							bFound = True
						end if
					Next
				Next
				if not bFound then sCategories = sCategories & "~" & sCategory
			Next
		Next
		BuildCategories = Split(sCategories,"~")
	End Function

	' Sort the array
	Private Function Sort(aArray)
		Dim lTemp1, lTemp2, sTemp
		
		For lTemp1 = UBound(aArray) - 1 to 0 Step -1
			For lTemp2 = 0 to lTemp1
				if aArray(lTemp2) > aArray(lTemp2 + 1) then
					sTemp = aArray(lTemp2 + 1)
					aArray(lTemp2 + 1) = aArray(lTemp2)
					aArray(lTemp2) = sTemp
				end if
			Next
		Next
		Sort = aArray
	End Function

	' Hard work in here	
	Public Sub Render()
		Dim lOldColourIndex, XAxisLength, YAxisLength, lCenter
		Dim sinPixelRatio, lTemp, lTemp2, lMaxCategories, lDataSets
		Dim sinGapWidth, aKeys, aKeys2, objSet, aCategories, sinTemp3
		
		aCategories = Sort(BuildCategories())
		lMaxCategories = UBound(aCategories)
		
		lDataSets = DataSets.Count
		
		lOldColourIndex = ActiveCanvas.ForegroundColourIndex

		XAxisLength = Width - XAxisOffset
		YAxisLength = Height - YAxisOffset

		if Vertical then
			sinPixelRatio = YAxisLength / (Max - Min) ' Pixels per X unit
			sinGapWidth = XAxisLength / (lMaxCategories * lDataSets)
		else
			sinPixelRatio = XAxisLength / (Max - Min) ' Pixels per Y unit
			sinGapWidth = YAxisLength / (lMaxCategories * lDataSets)
		end if

		if DrawXAxis then
			ActiveCanvas.ForegroundColourIndex = AxisColourIndex
			ActiveCanvas.Line Left + XAxisOffset,Top + YAxisLength,Left + Width,Top + YAxisLength
			
			' Draw minor pips
			if Not Vertical then
				For lTemp = 0 to (Max - Min) Step Minor
					ActiveCanvas.Line Left + XAxisOffset + CInt(lTemp * sinPixelRatio),Top + YAxisLength,Left + XAxisOffset + CInt(lTemp * sinPixelRatio),Top + YAxisLength + MinorPipSize
				Next
				For lTemp = 0 To (Max - Min) Step Major
					ActiveCanvas.Line Left + XAxisOffset + CInt(lTemp * sinPixelRatio),Top + YAxisLength,Left + XAxisOffset + CInt(lTemp * sinPixelRatio),Top + YAxisLength + MajorPipSize
					ActiveCanvas.DrawTextWE Left + XAxisOffset + CInt(lTemp * sinPixelRatio) - ActiveCanvas.GetTextWEWidth(lTemp),Top + YAxisLength + MajorPipSize,CStr(lTemp)
				Next
			else
				' Draw the dividers
				' This is worked out by taking the maximum number of categories
				' out of our datasets
				For lTemp = 0 To (lMaxCategories * lDataSets)
					if lTemp Mod lDataSets = 0 then
						ActiveCanvas.Line Left + XAxisOffset + CInt(lTemp * sinGapWidth),Top + YAxisLength,Left + XAxisOffset + CInt(lTemp * sinGapWidth),Top + YAxisLength + MajorPipSize
					else
						ActiveCanvas.Line Left + XAxisOffset + CInt(lTemp * sinGapWidth),Top + YAxisLength,Left + XAxisOffset + CInt(lTemp * sinGapWidth),Top + YAxisLength + MinorPipSize
					end if
				Next
				
				' Draw the category names, these should be inserted central to each
				' category group
				' Left + XAxisOffset + (Category * Datasets * lGapWidth)
				For lTemp = 1 to UBound(aCategories)
					lCenter = Left + XAxisOffset + CInt((lTemp - 1) * DataSets.Count * sinGapWidth) + CInt((DataSets.Count * sinGapWidth) / 2) - CInt(ActiveCanvas.GetTextWEWidth(aCategories(lTemp)) / 2)
					ActiveCanvas.DrawTextWE lCenter,Top + YAxisLength + MajorPipSize, aCategories(lTemp)
				Next
				
			end if
		end if
		
		if DrawYAxis then
			ActiveCanvas.ForegroundColourIndex = AxisColourIndex
			ActiveCanvas.Line Left + XAxisOffset,Top,Left + XAxisOffset,Top + YAxisLength
			
			if Vertical then
				For lTemp = 0 To (Max - Min) Step Minor
					ActiveCanvas.Line Left + XAxisOffset,Top + YAxisLength - CInt(lTemp * sinPixelRatio),Left + XAxisOffset - MinorPipSize,Top + YAxisLength - CInt(lTemp * sinPixelRatio)
				Next
				For lTemp = 0 To (Max - Min) Step Major
					ActiveCanvas.Line Left + XAxisOffset,Top + YAxisLength - CInt(lTemp * sinPixelRatio),Left + XAxisOffset - MajorPipSize,Top + YAxisLength - CInt(lTemp * sinPixelRatio)
					ActiveCanvas.DrawTextNS Left + YAxisOffset - MajorPipSize - ActiveCanvas.GetTextNSWidth(lTemp),Top + YAxisLength - CInt(lTemp * sinPixelRatio),CStr(lTemp)
				Next
			else
				' Draw the dividers
				' This is worked out by taking the maximum number of categories
				' out of our datasets
				For lTemp = 0 To (lMaxCategories * lDataSets)
					if lTemp Mod lDataSets = 0 then
						ActiveCanvas.Line Left + XAxisOffset,Top + YAxisLength - CInt(lTemp * sinGapWidth),Left + XAxisOffset - MajorPipSize,Top + YAxisLength - CInt(lTemp * sinGapWidth)
					else
						ActiveCanvas.Line Left + XAxisOffset,Top + YAxisLength - CInt(lTemp * sinGapWidth),Left + XAxisOffset - MinorPipSize,Top + YAxisLength - CInt(lTemp * sinGapWidth)
					end if
				Next

				For lTemp = 1 to UBound(aCategories)
					lCenter = Top + CInt((lTemp - 1) * DataSets.Count * sinGapWidth) + CInt((DataSets.Count * sinGapWidth) / 2) - CInt(ActiveCanvas.GetTextNSHeight(aCategories(lTemp)) / 2)
					ActiveCanvas.DrawTextNS Left + XAxisOffset - MajorPipSize - ActiveCanvas.GetTextNSWidth(aCategories(lTemp)),lCenter, aCategories(lTemp)
				Next
			end if
		end if
		
		' Render the bars
		' aCategories holds all the unique categories for this chart
		if Vertical then
			sinTemp3 = Left + XAxisOffset + 1
		else
			sinTemp3 = Top
		end if
		
		For lTemp = 1 To UBound(aCategories)
			' Work through all the datasets
			aKeys = DataSets.Keys()
			For lTemp2 = 0 to UBound(aKeys)
				Set objSet = DataSets(aKeys(lTemp2))
				if objSet.Points.Exists(aCategories(lTemp)) then
					' We have data for this category, draw it!
					if objSet.DrawFill then
						ActiveCanvas.ForegroundColourIndex = objSet.FillIndex
						if Vertical then
							ActiveCanvas.FilledRectangle _
								CInt(sinTemp3), _
								Top + YAxisLength - CInt(objSet.Points(aCategories(lTemp)).Value * sinPixelRatio), _
								CInt(sinTemp3 + sinGapWidth), _
								Top + YAxisLength - 1
						else
							ActiveCanvas.FilledRectangle _
								Left + XAxisOffset + 1, _
								CInt(sinTemp3), _
								Left + XAxisOffset + CInt(objSet.Points(aCategories(lTemp)).Value * sinPixelRatio), _
								CInt(sinTemp3 + sinGapWidth)
						end if
					end if
					if objSet.DrawBorder then
						ActiveCanvas.ForegroundColourIndex = objSet.BorderIndex
						if Vertical then
							ActiveCanvas.Rectangle _
								CInt(sinTemp3), _
								Top + YAxisLength - CInt(objSet.Points(aCategories(lTemp)).Value * sinPixelRatio), _
								CInt(sinTemp3 + sinGapWidth), _
								Top + YAxisLength - 1
						else
							ActiveCanvas.Rectangle _
								Left + XAxisOffset + 1, _
								CInt(sinTemp3), _
								Left + XAxisOffset + CInt(objSet.Points(aCategories(lTemp)).Value * sinPixelRatio), _
								CInt(lTemp3 + sinGapWidth)
						end if
					end if
				end if
				sinTemp3 = sinTemp3 + sinGapWidth
			Next
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
			ActiveCanvas.DrawTextWE lCursorX, lCursorY, "Leyenda:"

			lCursorX = lCursorX + 10

			lCursorY = lCursorY + ActiveCanvas.GetTextWEHeight("a")

			lTextHeight = ActiveCanvas.GetTextWEHeight("a")

			For lTemp = 0 to UBound(aKeys)
				if DataSets.Item(aKeys(lTemp)).DrawFill then
					ActiveCanvas.ForegroundColourIndex = DataSets.Item(aKeys(lTemp)).FillIndex
					ActiveCanvas.FilledRectangle lCursorX - 10,lCursorY,lCursorX,lCursorY + lTextHeight - 1
				end if
				if DataSets.Item(aKeys(lTemp)).DrawBorder then
					ActiveCanvas.ForegroundColourIndex = DataSets.Item(aKeys(lTemp)).BorderIndex
					ActiveCanvas.Rectangle lCursorX - 10,lCursorY,lCursorX,lCursorY + lTextHeight - 1
				end if
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

		DrawXAxis = True
		DrawYAxis = True
		
		Max = 100

		Min = 0

		Minor = 5
		Major = 25
		
		MajorPipSize = 10
		MinorPipSize = 5

		DrawMinMaxValues = True
		
		DrawMajorValues = False

		Vertical = True

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