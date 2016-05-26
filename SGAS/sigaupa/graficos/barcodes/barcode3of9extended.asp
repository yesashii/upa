<%
' Generate barcodes
'
' Extended Code 3 of 9
'
' Character set: 7-Bit ASCII range 0-127
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

Class Barcode3of9Extended
	Private m_objCharset
	Private m_lCurrentX
	
	Public ActiveCanvas
	
	Public Top
	Public Left
	Public Height
	
	Public Text
	
	Public NarrowWidth
	Public WideRatio
	
	Public QuietZone
	
	Public Function GetWidth()
		' Complicated
		Dim lTextLength, lTemp
		
		lTextLength = 0
		
		For lTemp = 1 to Len(Text)
			if Len(m_objCharset.Item(Mid(Text,lTemp,1))) > 9 then
				lTextLength = lTextLength + 2
			else
				lTextLength = lTextLength + 1
			end if
		Next
		
		GetWidth = (lTextLength + 2) * ((3 * WideRatio) + 6) * NarrowWidth + (lTextLength + 1) * NarrowWidth
		GetWidth = GetWidth + (QuietZone * 2) * NarrowWidth
	End Function
	
	Public Sub Render()
		Dim lTemp
		
		m_lCurrentX = Left + (QuietZone * NarrowWidth)
		RenderCharacter "**"

		For lTemp = 1 to Len(Text)
			RenderCharacter Mid(Text,lTemp,1)
		Next
		
		RenderCharacter "**"
	End Sub

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
		Dim sPercent, sDollar, sSlash, sPlus
		
		Set ActiveCanvas = Nothing
		Set m_objCharset = Server.CreateObject("Scripting.Dictionary")

		' 0 = narrow
		' 1 = wide
		sPercent = "000101010"
		sDollar = "010101000"
		sSlash = "010100010"
		sPlus = "010001010"
		
		m_objCharset.Add Chr(0),sPercent & "0110000001"	' %U
		m_objCharset.Add Chr(1),sDollar & "0100001001"	' $A
		m_objCharset.Add Chr(2),sDollar & "0001001001"	' $B
		m_objCharset.Add Chr(3),sDollar & "0101001000"	' $C
		m_objCharset.Add Chr(4),sDollar & "0000011001"	' $D
		m_objCharset.Add Chr(5),sDollar & "0100011000"	' $E
		m_objCharset.Add Chr(6),sDollar & "0001011000"	' $F
		m_objCharset.Add Chr(7),sDollar & "0000001101"	' $G
		m_objCharset.Add Chr(8),sDollar & "0100001100"	' $H
		m_objCharset.Add Chr(9),sDollar & "0001001100"	' $I
		m_objCharset.Add Chr(10),sDollar & "0000011100"	' $J
		m_objCharset.Add Chr(11),sDollar & "0100000011"	' $K
		m_objCharset.Add Chr(12),sDollar & "0001000011"	' $L
		m_objCharset.Add Chr(13),sDollar & "0101000010"	' $M
		m_objCharset.Add Chr(14),sDollar & "0000010011"	' $N
		m_objCharset.Add Chr(15),sDollar & "0100010010"	' $O
		m_objCharset.Add Chr(16),sDollar & "0001010010"	' $P
		m_objCharset.Add Chr(17),sDollar & "0000000111"	' $Q
		m_objCharset.Add Chr(18),sDollar & "0100000110"	' $R
		m_objCharset.Add Chr(19),sDollar & "0001000110"	' $S
		m_objCharset.Add Chr(20),sDollar & "0000010110"	' $T
		m_objCharset.Add Chr(21),sDollar & "0110000001"	' $U
		m_objCharset.Add Chr(22),sDollar & "0011000001"	' $V
		m_objCharset.Add Chr(23),sDollar & "0111000000"	' $W
		m_objCharset.Add Chr(24),sDollar & "0010010001"	' $X
		m_objCharset.Add Chr(25),sDollar & "0110010000"	' $Y
		m_objCharset.Add Chr(26),sDollar & "0011010000"	' $Z
		m_objCharset.Add Chr(27),sPercent & "0100001001"	' %A
		m_objCharset.Add Chr(28),sPercent & "0001001001"	' %B
		m_objCharset.Add Chr(29),sPercent & "0101001000"	' %C
		m_objCharset.Add Chr(30),sPercent & "0000011001"	' %D
		m_objCharset.Add Chr(31),sPercent & "0100011000"	' %E
		m_objCharset.Add " ","011000100"					' Space
		m_objCharset.Add "!",sSlash & "0100001001"		' /A
		m_objCharset.Add Chr(34),sSlash & "0001001001"	' /B
		m_objCharset.Add "#",sSlash & "0101001000"		' /C
		m_objCharset.Add "$",sSlash & "0000011001"		' /D
		m_objCharset.Add "%",sSlash & "0100011000"		' /E
		m_objCharset.Add "&",sSlash & "0001011000"		' /F
		m_objCharset.Add "'",sSlash & "0000001101"		' /G
		m_objCharset.Add "(",sSlash & "0100001100"		' /H
		m_objCharset.Add ")",sSlash & "0001001100"		' /I
		m_objCharset.Add "*",sSlash & "0000011100"		' /J
		m_objCharset.Add "+",sSlash & "0100000011"		' /K
		m_objCharset.Add ",",sSlash & "0001000011"		' /L
		m_objCharset.Add "-","010000101"
		m_objCharset.Add ".","110000100"
		m_objCharset.Add "/",sSlash & "0100010010"		' /O
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
		m_objCharset.Add ":",sSlash & "0011010000"		' /Z
		m_objCharset.Add ";",sPercent & "0001011000"		' %F
		m_objCharset.Add "<",sPercent & "0000001101"		' %G
		m_objCharset.Add "=",sPercent & "0100001100"		' %H
		m_objCharset.Add ">",sPercent & "0001001100"		' %I
		m_objCharset.Add "?",sPercent & "0000011100"		' %J
		m_objCharset.Add "@",sPercent & "0011000001"		' %V
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
		m_objCharset.Add "[",sPercent & "0100000011"		' %K
		m_objCharset.Add "\",sPercent & "0001000011"		' %L
		m_objCharset.Add "]",sPercent & "0101000010"		' %M
		m_objCharset.Add "^",sPercent & "0000010011"		' %N
		m_objCharset.Add "_",sPercent & "0100010010"		' %O
		m_objCharset.Add "`",sPercent & "0111000000"		' %W
		m_objCharset.Add "a",sPlus & "0100001001"			' +A
		m_objCharset.Add "b",sPlus & "0001001001"			' +B
		m_objCharset.Add "c",sPlus & "0101001000"			' +C
		m_objCharset.Add "d",sPlus & "0000011001"			' +D
		m_objCharset.Add "e",sPlus & "0100011000"			' +E
		m_objCharset.Add "f",sPlus & "0001011000"			' +F
		m_objCharset.Add "g",sPlus & "0000001101"			' +G
		m_objCharset.Add "h",sPlus & "0100001100"			' +H
		m_objCharset.Add "i",sPlus & "0001001100"			' +I
		m_objCharset.Add "j",sPlus & "0000011100"			' +J
		m_objCharset.Add "k",sPlus & "0100000011"			' +K
		m_objCharset.Add "l",sPlus & "0001000011"			' +L
		m_objCharset.Add "m",sPlus & "0101000010"			' +M
		m_objCharset.Add "n",sPlus & "0000010011"			' +N
		m_objCharset.Add "o",sPlus & "0100010010"			' +O
		m_objCharset.Add "p",sPlus & "0001010010"			' +P
		m_objCharset.Add "q",sPlus & "0000000111"			' +Q
		m_objCharset.Add "r",sPlus & "0100000110"			' +R
		m_objCharset.Add "s",sPlus & "0001000110"			' +S
		m_objCharset.Add "t",sPlus & "0000010110"			' +T
		m_objCharset.Add "u",sPlus & "0110000001"			' +U
		m_objCharset.Add "v",sPlus & "0011000001"			' +V
		m_objCharset.Add "w",sPlus & "0111000000"			' +W
		m_objCharset.Add "x",sPlus & "0010010001"			' +X
		m_objCharset.Add "y",sPlus & "0110010000"			' +Y
		m_objCharset.Add "z",sPlus & "0011010000"			' +Z
		m_objCharset.Add "{",sPercent & "0001010010"		' %P
		m_objCharset.Add "|",sPercent & "0000000111"		' %Q
		m_objCharset.Add "}",sPercent & "0100000110"		' %R
		m_objCharset.Add "~",sPercent & "0001000110"		' %S
		m_objCharset.Add "**","010010100"					' *, the start/stop character
		
		Top = 0
		Left = 0
		Height = 0
		Text = ""
		
		NarrowWidth = 1
		WideRatio = 3
		
		QuietZone = 10 * NarrowWidth
	End Sub
	
	Private Sub Class_Terminate()
		Set m_objCharset = Nothing
	End Sub
End Class

%>