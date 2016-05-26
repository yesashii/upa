<%
function FormateaFechaANSI (fecha_inicial)
'//--   Función que, dada una fecha en el formato dd/mm/aaaa, devuelve  --////
'//-- dicha fecha en formato ANSI aaaammdd                              --////

	arr_fecha_inicial = split(fecha_inicial, "/")
	if ubound(arr_fecha_inicial) = 2 then
		v_dia  = arr_fecha_inicial(0)
		v_mes  = arr_fecha_inicial(1)
		v_anno = arr_fecha_inicial(2)
		
		FormateaFechaANSI = v_anno & v_mes & v_dia
	else
		FormateaFechaANSI = ""
	end if
end function
%>