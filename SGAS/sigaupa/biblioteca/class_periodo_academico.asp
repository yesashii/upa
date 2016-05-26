<%
class CPeriodoAcademico
	private conexion, actividad
	private nombre_variable

	Sub Inicializar (con, act)		
		set conexion = con
		actividad = act		
		nombre_variable = "_periodo_" & LCase(actividad)		
	end sub
	
	
	Sub Dibujar()
		Dim consulta, registros, fila
		Dim salida
		Dim selected
		
		consulta = "select a.peri_ccod, a.tape_ccod, c.peri_tdesc, c.anos_ccod " & vbCrLf &_
		           "from actividades_periodos a, tipos_actividades_periodos b, periodos_academicos c " & vbCrLf &_
				   "where a.tape_ccod = b.tape_ccod " & vbCrLf &_
				   "  and a.peri_ccod = c.peri_ccod " & vbCrLf &_
				   "  and a.acpe_bvigente = 'S' " & vbCrLf &_
				   "  and upper(b.tape_tactividad) = '" & UCase(actividad) & "'" & vbCrLf &_
				   "order by a.peri_ccod asc"
				   
		
				   
		salida = "<select name=""" & nombre_variable & """>" & vbCrLf		
		   
		conexion.Ejecuta consulta
		set registros = conexion.ObtenerRegistros
		
		if registros.Item("filas").Count > 0 then
			salida = salida & "<option value="""">Seleccione Periodo Académico</option>" & vbCrLf
			for each fila in registros.Item("filas").Items
				if CStr(fila.Item("PERI_CCOD")) = CStr(Session(nombre_variable)) then				
					selected = " selected"
				else
					selected = ""
				end if
			
				salida = salida & "<option value=""" & fila.Item("PERI_CCOD") & """" & selected & ">" & fila.Item("ANOS_CCOD") & " " & fila.Item("PERI_TDESC") & "</option>" & vbCrLf
			next
		else
			salida = salida & "<option value="""">No existen periodos para este proceso</option>"
		end if
		
		salida = salida & "</select>" & vbCrLf	
		
		Response.Write(salida)
		
		set registros = Nothing
	end sub
	
end class
%>