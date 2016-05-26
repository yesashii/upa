
<%
class CPassword
    Function GenerarPassword(largo,conexion)
		Dim Resultado, Caracter, Password
	
		'Cargamos la matriz con números y letras
		caracter = Array("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z")
		
		Randomize()
		ClaveExiste= "S"
		Do While ClaveExiste= "S"
		
				Do While Len(Resultado) < largo
					Resultado = Resultado & Caracter(Int(36 * Rnd()))
				Loop
		
			ClaveExiste = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end  from certificados_online where cod_activacion='"&Resultado&"'")
		loop
		GenerarPassword = Resultado
	End Function
End Class
%>


