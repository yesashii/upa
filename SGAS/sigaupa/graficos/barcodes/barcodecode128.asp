<%
' Code 128 barcode, including sets A, B and C
' Charset: 7-bit ASCII, 0-127
' Each character is made of 11 black or white modules (lines)
' The stop character is made of 13 black or white modules (lines)
' Bands can be between 1 and 4 modules (lines) wide
' Bands always start on a black
' B S B S B S
' Shifting is possible between codesets A B and C using the CODE command
' The SHIFT command is used to alternate between A and B for a single character
' Dual numbers are encoded using CODE C
' CODE means that the code switches to that set, SHIFT means that the next character 
' is of that set then it switched back

' PRELIMINARY CODE, NEEDS PROPER TESTING!

Class BarcodeCode128
	Private m_objCharsetA
	Private m_objCharsetB
	Private m_objCharsetC
	
	Private m_aCharsetA
	Private m_aCharsetB
	Private m_aCharsetC
	
	Private m_lCurrentX

	Public ActiveCanvas

	Public Top
	Public Left
	Public Height

	Public Text

	Public NarrowWidth

	Public QuietZone

	' This width calculation it just wrong. It only seems to work for about the first 18 characters
	Public Function GetWidth()
		Dim lTemp, bNumericOnly
		
		bNumericOnly = True
		
		For lTemp = 1 to Len(Text)
			if Not IsNumeric(Mid(Text,lTemp,1)) then bNumericOnly = False
		Next
		
		if bNumericOnly then
			' Length = (5.5C + 35)X (numeric only using Code C)
			GetWidth = (5.5 * Len(Text) + 35) * NarrowWidth + (QuietZone * 4)
		else
			' Length = (11C + 35)X (alphanumeric)
			GetWidth = (11 * Len(Text) + 35) * NarrowWidth + (QuietZone * 4)
		end if
	End Function
	
	Public Sub Render()
		' Scan the text and render each character
		' Get two characters, scan for both of them being numbers
		' If they are, switch to Code C and render the code for the two numbers
		' If they are not, search for the code in A and B, render the code
		Dim lTemp, sCurrentCode, lStartCode
		
		m_lCurrentX = Left + QuietZone
		
		lTemp = 1
		
		sCurrentCode = ""
		
		While lTemp < Len(Text)
			if lTemp < Len(Text) then
				if IsNumeric(Mid(Text,lTemp,1)) And IsNumeric(Mid(Text,lTemp+1,1)) then
					' We can do a Code C swap
					if sCurrentCode = "" then lStartCode = GetIndex("STARTC")
					if sCurrentCode <> "C" then 
						RenderCharacter "STARTC",m_objCharsetA
						sCurrentCode = "C"
					end if
					RenderCharacter Mid(Text,lTemp,2),m_objCharsetC
					lTemp = lTemp + 2
				end if
			end if
			if m_objCharsetA.Exists(Mid(Text,lTemp,1)) then
				' Render Code A
				if sCurrentCode = "" then lStartCode = GetIndex("STARTA")
				if sCurrentCode <> "A" then
					RenderCharacter "STARTA",m_objCharsetA
					sCurrentCode = "A"
				end if
				RenderCharacter Mid(Text,lTemp,1),m_objCharsetA
				lTemp = lTemp + 1
			elseif m_objCharsetB.Exists(Mid(Text,lTemp,1)) then
				' Render Code C
				if sCurrentCode = "" then lStartCode = GetIndex("STARTB")
				if sCurrentCode <> "B" then
					RenderCharacter "STARTB",m_objCharsetA
					sCurrentCode = "B"
				end if
				RenderCharacter Mid(Text,lTemp,1),m_objCharsetB
				lTemp = lTemp + 1
			else
				' No idea what character this is, proceed to the next
				lTemp = lTemp + 1
			end if
		Wend
		
		' Now we do the checksum
		RenderMOD103 lStartCode
		
		RenderCharacter "STOP",m_objCharsetA
	End Sub
	
	' Checksum is calculated by summing up:
	' Start code value
	' Then the value of each data element multiplied by its position in the data
	' Divide it by 103 and find the remainder for the checksum character
	' Then insert the character corresponding to this number
	Private Sub RenderMOD103(lStartCode)
		' Grab the first character, figure out which character set it is
		Dim lValue, lTemp
		
		lValue = lStartCode
		
		For lTemp = 1 to Len(Text)
			lValue = lValue + (GetIndex(Mid(Text,lTemp,1)) * lTemp)
		Next
		
		RenderCharacter m_aCharsetA(lValue Mod 103), m_objCharsetA
	End Sub

	Private Function GetIndex(sChar)
		Dim lTemp
		
		For lTemp = 0 To UBound(m_aCharsetA) - 1
			if m_aCharsetA(lTemp) = sChar or m_aCharsetB(lTemp) = sChar or m_aCharsetC(lTemp) = sChar then
				GetIndex = lTemp
			end if
		Next
	End Function

	Public Sub RenderCharacter(sCharacter, objCharset)
		' Render a character to the barcode
		Dim sCharData, bBar, lTemp, lWidth
		
		sCharData = objCharset.Item(sCharacter)
		
		bBar = True
		
		For lTemp = 1 to Len(sCharData)			
			lWidth = CLng(Mid(sCharData,lTemp,1))
			if bBar then ActiveCanvas.FilledRectangle m_lCurrentX,Top,m_lCurrentX + (lWidth * NarrowWidth), Top + Height
			m_lCurrentX = m_lCurrentX + (lWidth * NarrowWidth)
			bBar = Not bBar
		Next
	End Sub
	
	Private Sub Class_Initialize()
		Set ActiveCanvas = Nothing
		
		Set m_objCharsetA = Server.CreateObject("Scripting.Dictionary")
		Set m_objCharsetB = Server.CreateObject("Scripting.Dictionary")
		Set m_objCharsetC = Server.CreateObject("Scripting.Dictionary")
		
		' 1-4 modules wide, complete A, B and C charset for Code 128
		m_objCharsetA.Add " ","212222"
		m_objCharsetA.Add "!","222122"
		m_objCharsetA.Add Chr(34),"222221"
		m_objCharsetA.Add "#","121223"
		m_objCharsetA.Add "$","121322"
		m_objCharsetA.Add "%","131222"
		m_objCharsetA.Add "&","122213"
		m_objCharsetA.Add "'","122312"
		m_objCharsetA.Add "(","132212"
		m_objCharsetA.Add ")","221213"
		m_objCharsetA.Add "*","221312"
		m_objCharsetA.Add "+","231212"
		m_objCharsetA.Add ",","112232"
		m_objCharsetA.Add "-","122132"
		m_objCharsetA.Add ".","122231"
		m_objCharsetA.Add "/","113222"
		m_objCharsetA.Add "0","123122"
		m_objCharsetA.Add "1","123221"
		m_objCharsetA.Add "2","223211"
		m_objCharsetA.Add "3","221132"
		m_objCharsetA.Add "4","221231"
		m_objCharsetA.Add "5","213212"
		m_objCharsetA.Add "6","223112"
		m_objCharsetA.Add "7","312131"
		m_objCharsetA.Add "8","311222"
		m_objCharsetA.Add "9","321122"
		m_objCharsetA.Add ":","321221"
		m_objCharsetA.Add ";","312212"
		m_objCharsetA.Add "<","322112"
		m_objCharsetA.Add "=","322211"
		m_objCharsetA.Add ">","212123"
		m_objCharsetA.Add "?","212321"
		m_objCharsetA.Add "@","232121"
		m_objCharsetA.Add "A","111323"
		m_objCharsetA.Add "B","131123"
		m_objCharsetA.Add "C","131321"
		m_objCharsetA.Add "D","112313"
		m_objCharsetA.Add "E","132113"
		m_objCharsetA.Add "F","132311"
		m_objCharsetA.Add "G","211313"
		m_objCharsetA.Add "H","231113"
		m_objCharsetA.Add "I","231311"
		m_objCharsetA.Add "J","112133"
		m_objCharsetA.Add "K","112331"
		m_objCharsetA.Add "L","132131"
		m_objCharsetA.Add "M","113123"
		m_objCharsetA.Add "N","113321"
		m_objCharsetA.Add "O","133121"
		m_objCharsetA.Add "P","313121"
		m_objCharsetA.Add "Q","211331"
		m_objCharsetA.Add "R","231131"
		m_objCharsetA.Add "S","213113"
		m_objCharsetA.Add "T","213311"
		m_objCharsetA.Add "U","213131"
		m_objCharsetA.Add "V","311123"
		m_objCharsetA.Add "W","311321"
		m_objCharsetA.Add "X","331121"
		m_objCharsetA.Add "Y","312113"
		m_objCharsetA.Add "Z","312311"
		m_objCharsetA.Add "[","332111"
		m_objCharsetA.Add "\","314111"
		m_objCharsetA.Add "]","221411"
		m_objCharsetA.Add "^","431111"
		m_objCharsetA.Add "_","111224"
		m_objCharsetA.Add "NUL","111422"
		m_objCharsetA.Add "SOH","121124"
		m_objCharsetA.Add "STX","121421"
		m_objCharsetA.Add "ETX","141122"
		m_objCharsetA.Add "EOT","141221"
		m_objCharsetA.Add "ENQ","112214"
		m_objCharsetA.Add "ACK","112412"
		m_objCharsetA.Add "BEL","122114"
		m_objCharsetA.Add "BS","122411"
		m_objCharsetA.Add "HT","142112"
		m_objCharsetA.Add "LF","142211"
		m_objCharsetA.Add "VT","241211"
		m_objCharsetA.Add "FF","221114"
		m_objCharsetA.Add "CR","413111"
		m_objCharsetA.Add "SO","241112"
		m_objCharsetA.Add "SI","134111"
		m_objCharsetA.Add "DLE","111242"
		m_objCharsetA.Add "DC1","121142"
		m_objCharsetA.Add "DC2","121241"
		m_objCharsetA.Add "DC3","114212"
		m_objCharsetA.Add "DC4","124112"
		m_objCharsetA.Add "NAK","124211"
		m_objCharsetA.Add "SYN","411212"
		m_objCharsetA.Add "ETB","421112"
		m_objCharsetA.Add "CAN","421211"
		m_objCharsetA.Add "EM","212141"
		m_objCharsetA.Add "SUB","214121"
		m_objCharsetA.Add "ESC","412121"
		m_objCharsetA.Add "FS","111143"
		m_objCharsetA.Add "GS","111341"
		m_objCharsetA.Add "RS","131141"
		m_objCharsetA.Add "US","114113"
		m_objCharsetA.Add "FNC3","114311"
		m_objCharsetA.Add "FNC2","411113"
		m_objCharsetA.Add "SHIFT","411311"
		m_objCharsetA.Add "CODEC","113141"
		m_objCharsetA.Add "CODEB","114131"
		m_objCharsetA.Add "FNC4","311141"
		m_objCharsetA.Add "FNC1","411131"
		m_objCharsetA.Add "STARTA","211412"
		m_objCharsetA.Add "STARTB","211214"
		m_objCharsetA.Add "STARTC","211232"
		m_objCharsetA.Add "STOP","2331112"
		
		m_aCharsetA = m_objCharsetA.Keys()
		
		m_objCharsetB.Add " ","212222"
		m_objCharsetB.Add "!","222122"
		m_objCharsetB.Add Chr(34),"222221"
		m_objCharsetB.Add "#","121223"
		m_objCharsetB.Add "$","121322"
		m_objCharsetB.Add "%","131222"
		m_objCharsetB.Add "&","122213"
		m_objCharsetB.Add "'","122312"
		m_objCharsetB.Add "(","132212"
		m_objCharsetB.Add ")","221213"
		m_objCharsetB.Add "*","221312"
		m_objCharsetB.Add "+","231212"
		m_objCharsetB.Add ",","112232"
		m_objCharsetB.Add "-","122132"
		m_objCharsetB.Add ".","122231"
		m_objCharsetB.Add "/","113222"
		m_objCharsetB.Add "0","123122"
		m_objCharsetB.Add "1","123221"
		m_objCharsetB.Add "2","223211"
		m_objCharsetB.Add "3","221132"
		m_objCharsetB.Add "4","221231"
		m_objCharsetB.Add "5","213212"
		m_objCharsetB.Add "6","223112"
		m_objCharsetB.Add "7","312131"
		m_objCharsetB.Add "8","311222"
		m_objCharsetB.Add "9","321122"
		m_objCharsetB.Add ":","321221"
		m_objCharsetB.Add ";","312212"
		m_objCharsetB.Add "<","322112"
		m_objCharsetB.Add "=","322211"
		m_objCharsetB.Add ">","212123"
		m_objCharsetB.Add "?","212321"
		m_objCharsetB.Add "@","232121"
		m_objCharsetB.Add "A","111323"
		m_objCharsetB.Add "B","131123"
		m_objCharsetB.Add "C","131321"
		m_objCharsetB.Add "D","112313"
		m_objCharsetB.Add "E","132113"
		m_objCharsetB.Add "F","132311"
		m_objCharsetB.Add "G","211313"
		m_objCharsetB.Add "H","231113"
		m_objCharsetB.Add "I","231311"
		m_objCharsetB.Add "J","112133"
		m_objCharsetB.Add "K","112331"
		m_objCharsetB.Add "L","132131"
		m_objCharsetB.Add "M","113123"
		m_objCharsetB.Add "N","113321"
		m_objCharsetB.Add "O","133121"
		m_objCharsetB.Add "P","313121"
		m_objCharsetB.Add "Q","211331"
		m_objCharsetB.Add "R","231131"
		m_objCharsetB.Add "S","213113"
		m_objCharsetB.Add "T","213311"
		m_objCharsetB.Add "U","213131"
		m_objCharsetB.Add "V","311123"
		m_objCharsetB.Add "W","311321"
		m_objCharsetB.Add "X","331121"
		m_objCharsetB.Add "Y","312113"
		m_objCharsetB.Add "Z","312311"
		m_objCharsetB.Add "[","332111"
		m_objCharsetB.Add "\","314111"
		m_objCharsetB.Add "]","221411"
		m_objCharsetB.Add "^","431111"
		m_objCharsetB.Add "_","111224"
		m_objCharsetB.Add "`","111422"
		m_objCharsetB.Add "a","121124"
		m_objCharsetB.Add "b","121421"
		m_objCharsetB.Add "c","141122"
		m_objCharsetB.Add "d","141221"
		m_objCharsetB.Add "e","112214"
		m_objCharsetB.Add "f","112412"
		m_objCharsetB.Add "g","122114"
		m_objCharsetB.Add "h","122411"
		m_objCharsetB.Add "i","142112"
		m_objCharsetB.Add "j","142211"
		m_objCharsetB.Add "k","241211"
		m_objCharsetB.Add "l","221114"
		m_objCharsetB.Add "m","413111"
		m_objCharsetB.Add "n","241112"
		m_objCharsetB.Add "o","134111"
		m_objCharsetB.Add "p","111242"
		m_objCharsetB.Add "q","121142"
		m_objCharsetB.Add "r","121241"
		m_objCharsetB.Add "s","114212"
		m_objCharsetB.Add "t","124112"
		m_objCharsetB.Add "u","124211"
		m_objCharsetB.Add "v","411212"
		m_objCharsetB.Add "w","421112"
		m_objCharsetB.Add "x","421211"
		m_objCharsetB.Add "y","212141"
		m_objCharsetB.Add "z","214121"
		m_objCharsetB.Add "{","412121"
		m_objCharsetB.Add "|","111143"
		m_objCharsetB.Add "}","111341"
		m_objCharsetB.Add "~","131141"
		m_objCharsetB.Add "DEL","114113"
		m_objCharsetB.Add "FNC3","114311"
		m_objCharsetB.Add "FNC2","411113"
		m_objCharsetB.Add "SHIFT","411311"
		m_objCharsetB.Add "CODEC","113141"
		m_objCharsetB.Add "FNC4","114131"
		m_objCharsetB.Add "CODEA","311141"
		m_objCharsetB.Add "FNC1","411131"
		m_objCharsetB.Add "STARTA","211412"
		m_objCharsetB.Add "STARTB","211214"
		m_objCharsetB.Add "STARTC","211232"
		m_objCharsetB.Add "STOP","2331112"

		m_aCharsetB = m_objCharsetB.Keys()

		m_objCharsetC.Add "00","212222"
		m_objCharsetC.Add "01","222122"
		m_objCharsetC.Add "02","222221"
		m_objCharsetC.Add "03","121223"
		m_objCharsetC.Add "04","121322"
		m_objCharsetC.Add "05","131222"
		m_objCharsetC.Add "06","122213"
		m_objCharsetC.Add "07","122312"
		m_objCharsetC.Add "08","132212"
		m_objCharsetC.Add "09","221213"
		m_objCharsetC.Add "10","221312"
		m_objCharsetC.Add "11","231212"
		m_objCharsetC.Add "12","112232"
		m_objCharsetC.Add "13","122132"
		m_objCharsetC.Add "14","122231"
		m_objCharsetC.Add "15","113222"
		m_objCharsetC.Add "16","123122"
		m_objCharsetC.Add "17","123221"
		m_objCharsetC.Add "18","223211"
		m_objCharsetC.Add "19","221132"
		m_objCharsetC.Add "20","221231"
		m_objCharsetC.Add "21","213212"
		m_objCharsetC.Add "22","223112"
		m_objCharsetC.Add "23","312131"
		m_objCharsetC.Add "24","311222"
		m_objCharsetC.Add "25","321122"
		m_objCharsetC.Add "26","321221"
		m_objCharsetC.Add "27","312212"
		m_objCharsetC.Add "28","322112"
		m_objCharsetC.Add "29","322211"
		m_objCharsetC.Add "30","212123"
		m_objCharsetC.Add "31","212321"
		m_objCharsetC.Add "32","232121"
		m_objCharsetC.Add "33","111323"
		m_objCharsetC.Add "34","131123"
		m_objCharsetC.Add "35","131321"
		m_objCharsetC.Add "36","112313"
		m_objCharsetC.Add "37","132113"
		m_objCharsetC.Add "38","132311"
		m_objCharsetC.Add "39","211313"
		m_objCharsetC.Add "40","231113"
		m_objCharsetC.Add "41","231311"
		m_objCharsetC.Add "42","112133"
		m_objCharsetC.Add "43","112331"
		m_objCharsetC.Add "44","132131"
		m_objCharsetC.Add "45","113123"
		m_objCharsetC.Add "46","113321"
		m_objCharsetC.Add "47","133121"
		m_objCharsetC.Add "48","313121"
		m_objCharsetC.Add "49","211331"
		m_objCharsetC.Add "50","231131"
		m_objCharsetC.Add "51","213113"
		m_objCharsetC.Add "52","213311"
		m_objCharsetC.Add "53","213131"
		m_objCharsetC.Add "54","311123"
		m_objCharsetC.Add "55","311321"
		m_objCharsetC.Add "56","331121"
		m_objCharsetC.Add "57","312113"
		m_objCharsetC.Add "58","312311"
		m_objCharsetC.Add "59","332111"
		m_objCharsetC.Add "60","314111"
		m_objCharsetC.Add "61","221411"
		m_objCharsetC.Add "62","431111"
		m_objCharsetC.Add "63","111224"
		m_objCharsetC.Add "64","111422"
		m_objCharsetC.Add "65","121124"
		m_objCharsetC.Add "66","121421"
		m_objCharsetC.Add "67","141122"
		m_objCharsetC.Add "68","141221"
		m_objCharsetC.Add "69","112214"
		m_objCharsetC.Add "70","112412"
		m_objCharsetC.Add "71","122114"
		m_objCharsetC.Add "72","122411"
		m_objCharsetC.Add "73","142112"
		m_objCharsetC.Add "74","142211"
		m_objCharsetC.Add "75","241211"
		m_objCharsetC.Add "76","221114"
		m_objCharsetC.Add "77","413111"
		m_objCharsetC.Add "78","241112"
		m_objCharsetC.Add "79","134111"
		m_objCharsetC.Add "80","111242"
		m_objCharsetC.Add "81","121142"
		m_objCharsetC.Add "82","121241"
		m_objCharsetC.Add "83","114212"
		m_objCharsetC.Add "84","124112"
		m_objCharsetC.Add "85","124211"
		m_objCharsetC.Add "86","411212"
		m_objCharsetC.Add "87","421112"
		m_objCharsetC.Add "88","421211"
		m_objCharsetC.Add "89","212141"
		m_objCharsetC.Add "90","214121"
		m_objCharsetC.Add "91","412121"
		m_objCharsetC.Add "92","111143"
		m_objCharsetC.Add "93","111341"
		m_objCharsetC.Add "94","131141"
		m_objCharsetC.Add "95","114113"
		m_objCharsetC.Add "96","114311"
		m_objCharsetC.Add "97","411113"
		m_objCharsetC.Add "98","411311"
		m_objCharsetC.Add "99","113141"
		m_objCharsetC.Add "CODEB","114131"
		m_objCharsetC.Add "CODEA","311141"
		m_objCharsetC.Add "FNC1","411131"
		m_objCharsetC.Add "STARTA","211412"
		m_objCharsetC.Add "STARTB","211214"
		m_objCharsetC.Add "STARTC","211232"
		m_objCharsetC.Add "STOP","2331112"

		m_aCharsetC = m_objCharsetC.Keys()

		Top = 0
		Left = 0
		Height = 0
		Text = ""
		
		NarrowWidth = 1
		
		QuietZone = 10 * NarrowWidth
	End Sub
	
	Private Sub Class_Terminate()
		Set m_objCharsetA = Nothing
		Set m_objCharsetB = Nothing
		Set m_objCharsetC = Nothing
	End Sub
End Class
%>