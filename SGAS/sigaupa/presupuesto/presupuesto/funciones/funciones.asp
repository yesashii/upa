<%
'funcion que cambia nombres
function traeNombre(desc)
	'------------------------------combos>>
	varAux = ""
	if desc = "eje" then
		varAux = "Eje Presupuestario"
	end if	
	if desc = "foco" then
		varAux = "Foco Del PDEI"
	end if	
	if desc = "programa" then
		varAux = "Programa Del PDEI"
	end if
	if desc = "proyecto" then
		varAux = "Proyecto Del PDEI"
	end if
	if desc = "objetivo" then
		varAux = "Objetivo Del PDEI"
	end if
	'------------------------------combos<<
	'------------------------------pestañasIngresoPresupuesto>>
	
	'------------------------------pestañasIngresoPresupuesto<<
	traeNombre = varAux
end function
'------------------------------pestañasolicitud centralizada>>
function encaPendientes()
%>
	<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
	  <th width="22%">Concepto</th>
	  <th width="51%">Descripción</th>
	  <th width="51%">Área</th>
	  <th width="9%">Para mes</th>
	  <th width="9%">Cantidad</th>
	  <th width="9%">Valor Aprox.</th>
	  <th width="9%">Tipo gasto</th>
	  <th width="18%">Estado</th>
	  <th width="18%">Accion</th>
	</tr>
<%
end function

'----------------------------------------------------------
'-	Encavezado Aceptadas y Rechazadas 
'----------------------------------------------------------
function encaDeAlta()
%>
	<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
	  <th width="22%">Concepto</th>
	  <th width="51%">Descripción</th>
	  <th width="51%">Área</th>
	  <th width="9%">Para mes</th>
	  <th width="9%">Cantidad</th>
	  <th width="9%">Valor Aprox.</th>
	  <th width="9%">Tipo gasto</th>
	  <th width="18%">Estado</th>
	</tr>
<%
end function

function filasPendientes(concepto, descripcion, area, eje, foco, programa, proyecto, objetivo, mes, cantidad, val_aprox, tipo, nomEstadoSolicitud, codEstadoSolicitud, cod_solicitud, accion)
%>
	<tr bordercolor='#999999'>	
		<td><font color="#0033FF"><%f_solicitado.DibujaCampo(concepto)%></a></font></td>
		<td><%=f_solicitado.DibujaCampo(descripcion)%></td>
		<td><%=area%></td>
		<td><%=f_solicitado.DibujaCampo(mes)%></td>
		<td><%=f_solicitado.DibujaCampo(cantidad)%></td>
		<td><%=f_solicitado.DibujaCampo(val_aprox)%></td>
		<td><%=tipo%></td>
		<td><%=f_solicitado.DibujaCampo(nomEstadoSolicitud)%></td>
		<td><a href="javascript:CambiaEstado(1,<%f_solicitado.DibujaCampo(codEstadoSolicitud)%>,<%f_solicitado.DibujaCampo(cod_solicitud)%>);"><%f_solicitado.DibujaCampo(accion)%></a></td>
	</tr>	
<%
end function

function filasPendientesSG(concepto, descripcion, area, eje, foco, programa, proyecto, objetivo, mes, cantidad, val_aprox, tipo, nomEstadoSolicitud, codEstadoSolicitud, cod_solicitud, accion, aborrar)
%>
	<tr bordercolor='#999999'>	
		<td><font color="#0033FF"><%f_solicitado.DibujaCampo(concepto)%></a></font></td>
		<td><%=f_solicitado.DibujaCampo(descripcion)%></td>
		<td><%=area%></td>
		<td><%=v_eje%></td>
		<td><%=v_foco%></td>
		<td><%=v_programa%></td>
		<td><%=v_proyecto%></td>									  
		<td><%=v_objetivo%></td>
		<td><%=f_solicitado.DibujaCampo(mes)%></td>
		<td><%=f_solicitado.DibujaCampo(cantidad)%></td>
		<td><%=f_solicitado.DibujaCampo(val_aprox)%></td>
		<td><%=tipo%></td>
		<td><%=f_solicitado.DibujaCampo(nomEstadoSolicitud)%></td>
		<td><a href="javascript:CambiaEstado(4,<%f_solicitado.DibujaCampo(codEstadoSolicitud)%>,<%f_solicitado.DibujaCampo(cod_solicitud)%>);"><%f_solicitado.DibujaCampo(accion)%>
		</a> |<a href="javascript:Rechazar(4,<%f_solicitado.DibujaCampo("ccsg_ncorr")%>);">Rechazar</a></td>
	</tr>	
<%
end function

function filasDeAlta(concepto, descripcion, area, eje, foco, programa, proyecto, objetivo, mes, cantidad, val_aprox, tipo, nomEstadoSolicitud)
%>
	<tr bordercolor='#999999'>	
		<td><font color="#0033FF"><%f_aprobados.DibujaCampo(concepto)%></a></font></td>
		<td><%=f_aprobados.DibujaCampo(descripcion)%></td>
		<td><%=area%></td>
		<td><%=f_aprobados.DibujaCampo(mes)%></td>
		<td><%=f_aprobados.DibujaCampo(cantidad)%></td>
		<td><%=f_aprobados.DibujaCampo(val_aprox)%></td>
		<td><%=tipo%></td>
		<td><%=f_aprobados.DibujaCampo(nomEstadoSolicitud)%></td>
	</tr>	
<%
end function
'------------------------------pestañasolicitud centralizada<<
'funcion encargada de formatear los combos
function cadenaCombo(cadena)
	largoCadena = len(cadena)
	cadenaFinal = cadena
	if largoCadena > 40 then
		cadena_1    =  mid(cadenaFinal,1, 40)
		cadenaFinal =  cadena_1&"..." 
	end if
	cadenaCombo = cadenaFinal
end function

function cadenaTabla(cadena)
	largoCadena = len(cadena)
	cadenaFinal = cadena
	if largoCadena > 10 then
		cadena_1    =  mid(cadenaFinal,1, 10)
		cadenaFinal =  cadena_1&"..." 
	end if
	if isNull(cadena) then cadenaFinal = "Sin seleccionar" end if
	cadenaTabla = cadenaFinal
end function
function cadenaTablaExcel(cadena)
	cadenaFinal = cadena
	if isNull(cadena) then cadenaFinal = "Sin seleccionar" end if
	cadenaTablaExcel = cadenaFinal
end function



function IsValidUTF8(s)
  dim i
  dim c
  dim n

  IsValidUTF8 = false
  i = 1
  do while i <= len(s)
    c = asc(mid(s,i,1))
    if c and &H80 then
      n = 1
      do while i + n < len(s)
        if (asc(mid(s,i+n,1)) and &HC0) <> &H80 then
          exit do
        end if
        n = n + 1
      loop
      select case n
      case 1
        exit function
      case 2
        if (c and &HE0) <> &HC0 then
          exit function
        end if
      case 3
        if (c and &HF0) <> &HE0 then
          exit function
        end if
      case 4
        if (c and &HF8) <> &HF0 then
          exit function
        end if
      case else
        exit function
      end select
      i = i + n
    else
      i = i + 1
    end if
  loop
  IsValidUTF8 = true 
end function

'DecodeUTF8
'  Decodes a UTF-8 string to the Windows character set
'  Non-convertable characters are replace by an upside
'  down question mark.
'Returns:
'  A Windows string
function DecodeUTF8(s)
  dim i
  dim c
  dim n

  i = 1
  do while i <= len(s)
    c = asc(mid(s,i,1))
    if c and &H80 then
      n = 1
      do while i + n < len(s)
        if (asc(mid(s,i+n,1)) and &HC0) <> &H80 then
          exit do
        end if
        n = n + 1
      loop
      if n = 2 and ((c and &HE0) = &HC0) then
        c = asc(mid(s,i+1,1)) + &H40 * (c and &H01)
      else
        c = 191 
      end if
      s = left(s,i-1) + chr(c) + mid(s,i+n)
    end if
    i = i + 1
  loop
  DecodeUTF8 = s 
end function

'EncodeUTF8
'  Encodes a Windows string in UTF-8
'Returns:
'  A UTF-8 encoded string
function EncodeUTF8(s)
  dim i
  dim c

  i = 1
  do while i <= len(s)
    c = asc(mid(s,i,1))
    if c >= &H80 then
      s = left(s,i-1) + chr(&HC2 + ((c and &H40) / &H40)) + chr(c and &HBF) + mid(s,i+1)
      i = i + 1
    end if
    i = i + 1
  loop
  EncodeUTF8 = s 
end function
'---------------------------------------------------------------------------------------------
'--------------------------------------------------------------------------------------->>>>>>>>>>>>>funciones
function esDesimal(numero)
	sNumero = Cstr(numero)
	numDummy = instr(sNumero, ",")
	if numDummy <> 0 then
       esDesimal = true
	else
       esDesimal = false
	end if
end function

function suma( var_1, var_2)
	varF_1 = CInt(var_1)
	varF_2 = CInt(var_2)
	tot = varF_1 + varF_2
	suma = CStr(tot)
end function

function persent(f_total, f_granTotal)
	
	if f_granTotal <> "0" then
		x_1 = Cint(f_granTotal)
		x_2 = Cint(f_total)
		if x_1 <> 0 then
			x_3 = Cdbl(x_2)/Cdbl(x_1)
		else
			x_3 = 0
		end if	
		x_4 = x_3*100		
		if esDesimal(x_4) then
			persent = FormatNumber(x_4,2,-1,0,-2)
		else
			persent =FormatNumber(x_4,0)
		end if		
	else
		persent = "0"
	end if
	
	
end function
%>