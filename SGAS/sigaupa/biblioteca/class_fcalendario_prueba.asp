<%
class FCalendario
	private FormularioCalendario,CampoOculto,Formu
	sub IniciaFuncion
		response.write "<script>" & vbCrlf
		response.write "function obtener_fecha(objeto)" & vbCrlf
		response.write "{"
	end sub
	sub FinFuncion
		response.write "}" & vbCrlf
		response.write "</script>"
	end sub
	'se crean las instancias para los distintos campos de formulario en donde se mostraran fechas
	sub MuestraFecha(NombreCampo,IndiceCampo,FormularioCalendario,CampoOculto)
		response.write "var fecha"&IndiceCampo&" = document."&FormularioCalendario&"."&CampoOculto&".value;" & vbCrlf
		response.write "if (objeto == """&IndiceCampo&""")" & vbCrlf
		response.write "{" & vbCrlf
		response.write "document."&FormularioCalendario&".elements["""&NombreCampo&"""].value = fecha"&IndiceCampo&"" & vbCrlf
		response.write "}"
	end sub
	sub DibujaImagen(CampoOculto,IndiceCampo,FormularioCalendario)
		response.write "<a style='cursor:hand;' onClick='PopCalendar.show(document."&FormularioCalendario&".elements["""&CampoOculto&"""], ""dd/mm/yyyy"", null, null, ""obtener_fecha("&IndiceCampo&")"", ""11"");'> " & vbCrlf
        response.write "<img src=""../imagenes/calendario/Calendario2.gif"" border=""0"" style=""Padding-Top:10px"" align=""absmiddle""> " & vbCrlf
		response.write "</a><input type=""hidden"" name="""&CampoOculto&""" >"
	end sub
	sub ImprimeVariables
		response.write "<script language='JavaScript'>" & vbCrlf
		response.write "//Para que ejecute debe de estar entre <body> y </body>" & vbCrlf
		response.write "PopCalendar = getCalendarInstance()" & vbCrlf
		response.write "PopCalendar.startAt = 1	// 0 - sunday ; 1 - monday" & vbCrlf
		response.write "PopCalendar.showWeekNumber = 0 // 0 - don't show; 1 - show" & vbCrlf
		response.write "PopCalendar.showToday = 1 // 0 - don't show; 1 - show" & vbCrlf
		response.write "PopCalendar.showWeekend = 1 // 0 - don't show; 1 - show" & vbCrlf
		response.write "PopCalendar.showHolidays = 1 // 0 - don't show; 1 - show" & vbCrlf
		response.write "PopCalendar.showSpecialDay = 1 // 0 - don't show, 1 - show" & vbCrlf
		response.write "PopCalendar.selectWeekend = 0 // 0 - don't Select; 1 - Select" & vbCrlf
		response.write "PopCalendar.selectHoliday = 0 // 0 - don't Select; 1 - Select" & vbCrlf
		response.write "PopCalendar.addCarnival = 1 // 0 - don't Add; 1- Add to Holiday (Tuesday of Carnival)" & vbCrlf
		response.write "PopCalendar.addGoodFriday = 1 // 0 - don't Add; 1- Add to Holiday" & vbCrlf
		response.write "PopCalendar.language = 0 // 0 - Spanish; 1 - English" & vbCrlf
		response.write "PopCalendar.defaultFormat = ""dd-mm-yyyy"" //Default Format dd-mm-yyyy" & vbCrlf
		response.write "PopCalendar.fixedX = -1 // x position (-1 if to appear below control)" & vbCrlf
		response.write "PopCalendar.fixedY = -1 // y position (-1 if to appear below control)" & vbCrlf
		response.write "PopCalendar.fade = .5 // 0 - don't fade; .1 to 1 - fade (Only IE) " & vbCrlf
		response.write "PopCalendar.shadow = 1 // 0  - don't shadow, 1 - shadow" & vbCrlf
		response.write "PopCalendar.move = 0 // 0  - don't move, 1 - move (Only IE)" & vbCrlf
		response.write "PopCalendar.saveMovePos = 1  // 0  - don't save, 1 - save" & vbCrlf
		response.write "PopCalendar.centuryLimit = 40 // 1940 - 2039" & vbCrlf
		response.write "//PopCalendar.forcedToday(""31-12-1999"", ""dd-mm-yyyy"")  // Force Today Date;" & vbCrlf
		response.write "PopCalendar.initCalendar()" & vbCrlf
		response.write "</script>"
	end sub
end class
%>