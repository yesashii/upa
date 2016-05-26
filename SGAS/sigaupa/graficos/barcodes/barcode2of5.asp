<%
' Barcode 2 of 5 (Numbers only, non-interleaved)
' Check digit optional
' PRELIMINARY CODE, NEEDS PROPER TESTING!
Class Barcode2of5
	Private m_objCharset
	Private m_aCharacters
	Private m_lCurrentX
	
	Public ActiveCanvas
	
	Public Top
	Public Left
	Public Height
	
	Public Text
	
	Public NarrowWidth
	Public WideRatio
	
	Public QuietZone
	
	Public MOD10

	Public Function GetWidth()
		' Width calculation
		' L = (C(2N+3)+6+N)X
		GetWidth = (Len(Text) * (2 * WideRatio + 3) + 6 + WideRatio) * NarrowWidth + (QuietZone * 4)
	End Function
	
	Public Sub Render()
		Dim lTemp
		
		m_lCurrentX = QuietZone
		
		RenderCharacter "START"
		
		For lTemp = 1 to Len(Text)
			RenderCharacter Mid(Text,lTemp,1)
		Next
		
		if MOD10 then RenderMOD10()
		
		RenderCharacter "STOP"
	End Sub
	
	Public Sub RenderMOD10()
	End Sub
	
	Private Sub RenderCharacter(sCharacter)
		Dim sCharData, lTemp, bBar
		
		sCharData = m_objCharset.Item(sCharacter)
		
		bBar = True
		
		For lTemp = 1 To Len(sCharData)
			if Mid(sCharData,lTemp,1) = "0" then
				if bBar then ActiveCanvas.FilledRectangle m_lCurrentX,Top,m_lCurrentX + NarrowWidth,Top + Height
				m_lCurrentX = m_lCurrentX + NarrowWidth
			else
				if bBar then ActiveCanvas.FilledRectangle m_lCurrentX,Top,m_lCurrentX + WideRatio,Top + Height
				m_lCurrentX = m_lCurrentX + WideRatio
			end if
			bBar = Not bBar
		Next
		
		m_lCurrentX = m_lCurrentX + NarrowWidth
	End Sub
	
	Private Sub Class_Initialize()
		Set ActiveCanvas = Nothing
		Set m_objCharset = Server.CreateObject("Scripting.Dictionary")

		' 0 - Narrow
		' 1 - Wide
		m_objCharset.Add "0","00110"
		m_objCharset.Add "1","10001"
		m_objCharset.Add "2","01001"
		m_objCharset.Add "3","11000"
		m_objCharset.Add "4","00101"
		m_objCharset.Add "5","10100"
		m_objCharset.Add "6","01100"
		m_objCharset.Add "7","00011"
		m_objCharset.Add "8","10010"
		m_objCharset.Add "9","01010"
		m_objCharset.Add "START","0000"
		m_objCharset.Add "STOP","100"
		
		Top = 0
		Left = 0
		Height = 0
		Text = ""
		
		NarrowWidth = 1
		WideRatio = 3
		
		QuietZone = 10 * NarrowWidth
		
		MOD10 = False
	End Sub
	
	Private Sub Class_Terminate()
		Set m_objCharset = Nothing
	End Sub
End Class
%>