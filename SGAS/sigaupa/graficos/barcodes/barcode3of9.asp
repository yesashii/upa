<%
' Generate barcodes
'
' Basic Code 3 of 9
'
' Character set: 0-9, A-Z, ' ', and -.$/+%
'
' Each character contains 5 bars and 4 spaces, a total of 9 elements. Each bar or space
' is either narrow or wide. 3 out of every 9 elements are always wide.
' Format is:
' 10 x-dimensions or 0.10 inches, whichever is greater
' The start character '*'
' The data
' The end character '*'
' Followed by 10 x-dimensions as with the start
'
' x-dimensions is the width of the smallest element in the barcode symbol
' Minimum x-dimension is 7.5 mils (1 mil=1/1000 inch) or 0.19mm
' The wide element is a multiple of the smallest element but must be consistent and between 2.0x and 3.0x
' the element IF the smallest element is greater than 20 mils. If the smallest element is less than
' 20 mils, the multiple can only range between 2.0 and 2.2
'
' The height of the barcode must be at least .15 times the symbols length or .25 inches, whichever is
' larger. The overall length of the symbol is in the equation:
' L = (C+2)(3N+6)X+(C+1)I
' L = Length
' C = Number of characters in symbol
' X = X-dimension
' N = Wide to narrow multiple
' I = Intercharacter gap
' 
' Maximum value for I is 5.3 x-dimensions for x less than 10 mils. If x is 10 mils or greater, the value
' of I is 3x or 53 mils, whichever is greater. For good printers, I=X
' 
' A check character is the sum of all data characters divided by 43. The remainder is the value of the 
' character.
'
' For our convenience, the x-dimension will be 1 pixel. Therefore, the barcode format is:
' 10 pixels
' The start character '*'
' The data, narrow = 1 pixel, wide = 2 pixels
' The end character '*'
' 10 pixels

' PRELIMINARY CODE, NEEDS PROPER TESTING!

Class Barcode3of9
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
	
	Public MOD43
	
	Public Function GetWidth()
		Dim lMOD43
		
		if MOD43 then lMOD43 = 1 else lMOD43 = 0
		
		GetWidth = (Len(Text) + lMOD43 + 2) * ((3 * WideRatio) + 6) * NarrowWidth + (Len(Text) + lMOD43 + 1) * NarrowWidth
		GetWidth = GetWidth + (QuietZone * 2) * NarrowWidth
	End Function
	
	Public Sub Render()
		Dim lTemp
		
		m_lCurrentX = Left + (QuietZone * NarrowWidth)
		RenderCharacter "*"
		
		For lTemp = 1 to Len(Text)
			RenderCharacter Mid(Text,lTemp,1)
		Next
		
		if MOD43 then RenderMOD43()
		
		RenderCharacter "*"
	End Sub

	' Calculate the rarely used MOD43 check digit
	Private Sub RenderMOD43()
		Dim lTotal, lTemp
		
		lTotal = 0
			
		For lTemp = 1 to Len(Text)
			lTotal = lTotal + GetIndex(Mid(Text,lTemp,1))
		Next
			
		RenderCharacter m_aCharacters(lTotal Mod 43)
	End Sub

	Private Function GetIndex(sChar)
		Dim lTemp
		
		For lTemp = 0 to UBound(m_aCharacters)
			If m_aCharacters(lTemp) = sChar then GetIndex = lTemp
		Next
	End Function

	Private Sub RenderCharacter(sCharacter)
		Dim sCharData, lTemp, bBar
		
		sCharData = m_objCharset.Item(sCharacter)

		bBar = True

		For lTemp = 1 to Len(sCharData)
			if Mid(sCharData,lTemp,1) = "0" then ' Narrow
				if bBar then ActiveCanvas.FilledRectangle m_lCurrentX,Top,m_lCurrentX + NarrowWidth,Top + Height
				m_lCurrentX = m_lCurrentX + NarrowWidth
			else ' Wide
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

		' 0 = narrow
		' 1 = wide
		m_objCharset.Add "0","000110100"
		m_objCharset.Add "1","100100001"
		m_objCharset.Add "2","001100001"
		m_objCharset.Add "3","101100000"
		m_objCharset.Add "4","000110001"
		m_objCharset.Add "5","100110000"
		m_objCharset.Add "6","001110000"
		m_objCharset.Add "7","000100101"
		m_objCharset.Add "8","100100100"
		m_objCharset.Add "9","001100100"
		m_objCharset.Add "A","100001001"
		m_objCharset.Add "B","001001001"
		m_objCharset.Add "C","101001000"
		m_objCharset.Add "D","000011001"
		m_objCharset.Add "E","100011000"
		m_objCharset.Add "F","001011000"
		m_objCharset.Add "G","000001101"
		m_objCharset.Add "H","100001100"
		m_objCharset.Add "I","001001100"
		m_objCharset.Add "J","000011100"
		m_objCharset.Add "K","100000011"
		m_objCharset.Add "L","001000011"
		m_objCharset.Add "M","101000010"
		m_objCharset.Add "N","000010011"
		m_objCharset.Add "O","100010010"
		m_objCharset.Add "P","001010010"
		m_objCharset.Add "Q","000000111"
		m_objCharset.Add "R","100000110"
		m_objCharset.Add "S","001000110"
		m_objCharset.Add "T","000010110"
		m_objCharset.Add "U","110000001"
		m_objCharset.Add "V","011000001"
		m_objCharset.Add "W","111000000"
		m_objCharset.Add "X","010010001"
		m_objCharset.Add "Y","110010000"
		m_objCharset.Add "Z","011010000"
		m_objCharset.Add "-","010000101"
		m_objCharset.Add ".","110000100"
		m_objCharset.Add " ","011000100"
		m_objCharset.Add "$","010101000"
		m_objCharset.Add "/","010100010"
		m_objCharset.Add "+","010001010"
		m_objCharset.Add "%","000101010"
		m_objCharset.Add "*","010010100"

		m_aCharacters = m_objCharset.Keys()

		Top = 0
		Left = 0
		Height = 0
		Text = ""
		
		NarrowWidth = 1
		WideRatio = 3
		
		QuietZone = 10 * NarrowWidth
		
		MOD43 = False
	End Sub
	
	Private Sub Class_Terminate()
		Set m_objCharset = Nothing
	End Sub
End Class

%>