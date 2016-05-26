<%
Const adOpenForwardOnly = 0
Const adOpenKeyset = 1
Const adOpenDynamic = 2
Const adOpenStatic = 3
Const adLockReadOnly = 1
Const adLockPessimistic = 2
Const adLockOptimistic = 3

class CConexion
    private con, registros, rs, estadoT
	private v_commandtimeout, v_connectiontimeout
	
	sub Inicializar(var) 
                dsn="sigaupa_sbd00":usuario_bd="protic":clave_bd=",.protic"
				str_con = "DSN=" & dsn & ";UID=" & usuario_bd & ";PWD=" & clave_bd & ";"
				set con = createobject("ADODB.Connection")
                con.open str_con	
	end sub

	sub MensajeError(mensaje)
		session("mensajeError") = mensaje
	end sub
	
	sub Ejecuta (sqltext)
		on error resume next
		set rs= createobject("ADODB.Recordset")
		rs.CursorType = adOpenKeyset
		rs.LockType = adLockReadOnly 
		con.CommandTimeout = 10000
		
		rs.open sqltext,con
		
		flag = true
		salida = ""
		hayErrores = false
		If con.Errors.Count > 0 then
				For each error in con.errors 
					if error.number < 0 then
						if flag then
                             salida = " No se puede mostrar la página "
							flag=false
						end if
						salida = salida & "<pre><b>ERROR</b> (" & Error.Number & ")" & Error.Description & "</pre>" & vbCrLf
						hayErrores = true
				    end if
				next
		end if
		if hayErrores then
			response.write salida
			response.Flush()
		else
		    set r = CreateObject("Scripting.Dictionary")
			r.Add "filas", CreateObject("Scripting.Dictionary")
			i = 0
			while (not rs.EOF)
                r.Item("filas").Add i, CreateObject("Scripting.Dictionary")
				for each campo in rs.Fields	
					if not r.Item("filas").Item(i).Exists(campo.name) then	
						r.Item("filas").Item(i).Add Ucase(campo.name), campo.value
					end if
				next 

				i = i + 1
				rs.movenext
			wend
			set registros = r
		End if
	end sub
	
	
	function ConsultaUno (sqltext)
		set rs= createobject("ADODB.Recordset")
		rs.CursorType = adOpenKeyset
		rs.LockType = adLockReadOnly 
		rs.open sqltext,con
		
		if not rs.EOF then
			valor = rs(0)
			rs.close
			set rs = nothing
			ConsultaUno = valor 
		else
			ConsultaUno = null
		end if
	end function

	function EjecutaS (sqltext)
	    On Error Resume Next
		EjecutaQuery = true
		set rs= createobject("ADODB.Recordset")
		rs.CursorType = adOpenKeyset
		rs.LockType = adLockReadOnly 
		rs.open sqltext,con
		
		If con.Errors.Count > 0 then
			salida = ""
			For each error in con.errors 
			  select case error.number
			  	case -2147217900 
					salida = salida & "Error al intentar ejecutar la intruccion : <br> "&sqltext&" "
			  end select
			next
			EjecutaS = false
		end if
	end function


	function EjecutaP (sqltext)
		On Error Resume Next
		set rs = createobject("ADODB.Recordset")
		con.execute sqltext
		ejecutaP = true
		set rs = nothing
	end function

	function EjecutaPSql (sqltext)
		set rs= createobject("ADODB.Recordset")
		rs.CursorType = adOpenKeyset
		rs.LockType = adLockReadOnly 
		rs.open sqltext,con 
		
		EjecutaPSql = null
	end function

	

	function ConsultaLimitada (sqltext, nroRegistros, offset)
 '		on error resume next   
		set rs = createobject("ADODB.Recordset")		
		rs.open sqltext,con,adOpenForwardOnly,adLockReadOnly 			
		nReg = rs.recordCount
		
		'response.Write("offset:"&offset&"Consulta : <br>"&sqltext)		
		'response.Write("<br> Registros encontrados:"&nReg)
		'response.Flush()

		
		'************************************************************************************************************
		' A G R E G A D O    P A R A   U A S 
		nReg = 0
		while not rs.eof
			nReg = nReg + 1
			rs.movenext
		wend
		if nReg > 0 then
			rs.movefirst
		end if
		'************************************************************************************************************
		
		flag = true
		salida = ""
		hayErrores = false
		If con.Errors.Count > 0 then
				For each error in con.errors 
					if error.number < 0 then
						if flag then
							'salida = "<b>Revisar</b><br>Consulta: <br>" & sqltext & "<br>" & vbCrLf
                            salida = " No se puede mostrar la página "
							flag=false
						end if
						salida = salida & "<pre><b>ERROR</b> (" & Error.Number & ")" & Error.Description & "</pre>" & vbCrLf
						hayErrores = true
				    end if
				next
		end if
		if hayErrores then
			response.write salida
			response.Flush()
		else
		    set registros = CreateObject("Scripting.Dictionary")
			registros.Add "filas", CreateObject("Scripting.Dictionary")
			i = 0
			k = 0
			while ( not rs.EOF and i < ( offset + 1 )*nroRegistros )
			    if i >= offset*nroRegistros then
					registros.Item("filas").Add k, CreateObject("Scripting.Dictionary")
					for each campo in rs.Fields
						if not registros.Item("filas").Item(k).Exists(campo.name) then
							registros.Item("filas").Item(k).Add ucase(campo.name), campo.value 
						end if
					next 
					k = k + 1
				end if
				i = i + 1
				rs.movenext
			wend
			rs.close
		End if
		consultaLimitada = nReg
	end function
	
	sub Listar    
	    for each pos in registros.Item("filas").Keys
		    for each campo in registros.Item("filas").Item(pos).keys
			    response.Write(pos & ". " & campo & ": " & registros.Item("filas").Item(pos).Item(campo) & "<br>")
			next
		next
		response.flush()
	end sub
	
	function ObtenerRegistros
	    set obtenerRegistros = registros
	end function

	Private Sub Class_Terminate
		On Error Resume Next 'Uncomment this to prevent IIS crashing
		con.Close   
		set con = nothing
	End Sub 	

	Sub CierraConexion   
		con.Close   
		set con = nothing
   	End Sub
	
end class


class CFormulario
    private regs, fila_actual, parametros, conexion, totalRegistros, variables,listaDep, pPost
	private v_table_bordercolor, v_table_bgcolor, v_tr_bgcolor, v_font_color, v_tr_bordercolor, v_tr_fontcolor, v_grilla_bgcolor, v_color_resaltado, v_color_seleccionado
	private d_parametros_fila	
	
    
	sub Carga_Parametros(nombre, idFormulario)
	    Set objXMLDoc = CreateObject("Microsoft.XMLDOM") 
		objXMLDoc.async = False 
		objXMLDoc.load("C:\Inetpub\wwwroot\sigaupa\biblioteca\" & nombre ) 

		Set root = objXMLDoc.documentElement 
		for each node in root.childNodes
			Set objAttributes = node.attributes 
			if objAttributes.getNamedItem("formulario").nodeValue = idFormulario then
				set parametros = CreateObject("Scripting.Dictionary")
				For Each intAtt in objAttributes 
				   parametros.Add intAtt.name, intAtt.nodeValue
				Next

				parametros.Add "campos", CreateObject("Scripting.Dictionary")
				parametros.Add "tablas", CreateObject("Scripting.Dictionary")
				parametros.Add "listas", CreateObject("Scripting.Dictionary")
				parametros.Add "botones", CreateObject("Scripting.Dictionary")
				
				for each hr in node.childNodes
					select case ucase(hr.nodeName) 
						case "CAMPOS"
							if not parametros.Item("campos").Exists(hr.attributes.getNamedItem("nombre").nodeValue) then
								parametros.Item("campos").Add hr.attributes.getNamedItem("nombre").nodeValue , CreateObject("Scripting.Dictionary")
								set campo = parametros.Item("campos").Item(hr.attributes.getNamedItem("nombre").nodeValue)
								for each hhr in hr.childNodes
									if not campo.Exists(hhr.nodeName) then
										campo.Add hhr.nodeName,hhr.text
									end if
								next
							end if
							
							
						case "BOTONES"
							if not parametros.Item("botones").Exists(hr.attributes.getNamedItem("nombre").nodeValue) then
								parametros.Item("botones").Add hr.attributes.getNamedItem("nombre").nodeValue, CreateObject("Scripting.Dictionary")
								set o_boton = parametros.Item("botones").Item(hr.attributes.getNamedItem("nombre").nodeValue)
								
								o_boton.Add "parametrosUrl", CreateObject("Scripting.Dictionary")
								for each hhr in hr.childNodes
									if not o_boton.Exists(hhr.nodeName) then
										o_boton.Add hhr.nodeName, hhr.text
									end if
								next																
							end if
						
							
						case "TABLAS"
							tabla_nombre = hr.attributes.getNamedItem("nombre").nodeValue
							tabla_accion = hr.attributes.getNamedItem("accion").nodeValue
							if not parametros.Item("tablas").Exists(tabla_nombre) then
								parametros.Item("tablas").Add tabla_nombre, ucase(tabla_accion)
							end if
							
						case "LISTAS"
							if not parametros.Item("listas").Exists(hr.attributes.getNamedItem("nombre").nodeValue) then
								parametros.Item("listas").Add hr.attributes.getNamedItem("nombre").nodeValue , CreateObject("Scripting.Dictionary")
								set campo = parametros.Item("listas").Item(hr.attributes.getNamedItem("nombre").nodeValue)
								for each hhr in hr.childNodes
									clave = ucase(hhr.attributes.getNamedItem("clave").nodeValue)
									valor = hhr.attributes.getNamedItem("valor").nodeValue
									if campo.Exists(clave) then
										campo.Item(clave) = valor
									else
										campo.Add clave, valor
									end if
								next
							end if
						
					end select	
				next
			end if
		next
	end sub
	
	
	function ExisteParametro(campo)
		if parametros.Item("campos").Exists(campo) then
			existeParametro = true
		else
			existeParametro = false
		end if
	end function

	function ClonaFilaCons(fila)
		if regs.Item("filas").Exists(fila) then
		    nF = regs.Item("filas").Count
			nroCampos =  regs.Item("filas").Item(fila).Count
			regs.Item("filas").Add nF, createObject("Scripting.Dictionary")
			for each x in regs.Item("filas").Item(fila).keys
				regs.Item("filas").Item(nF).Add x, regs.Item("filas").Item(fila).Item(x)
			next
		end if
		clonaFilaCons = nroCampos
	end function
	
	sub AgregaCampoCons(campo, valor)
		if regs.Item("filas").count = 0 then
			regs.Item("filas").Add 0, createObject("Scripting.Dictionary")
		end if
		for each it in regs.Item("filas").Items
			if it.Exists(ucase(campo)) then
				it.Item(ucase(campo)) = valor
			else
				it.Add ucase(campo), valor
			end if
		next
	end sub
	
	sub agregaCampoFilaCons(fila, campo, valor)
		if not regs.Item("filas").Exists(fila) then
			regs.Item("filas").Add fila, createObject("Scripting.Dictionary")
		end if
		if regs.Item("filas").Item(fila).Exists(ucase(campo)) then
			regs.Item("filas").Item(fila).Item(ucase(campo)) = valor
		else
			regs.Item("filas").Item(fila).Add ucase(campo), valor
		end if
	end sub
	
	sub agregaCampoParam(campo, atributo, valor)
		for each kt in parametros.Item("campos").keys
			if kt = campo then
				set it = parametros.Item("campos").Item(kt)
				if it.Exists(atributo) then
					it.Item(atributo) = valor
				else
					it.Add atributo, valor
				end if
				
				exit for
			end if
		next
	end sub
	
	
	Sub AgregaCampoFilaParam(p_fila, p_campo, p_atributo, p_valor)
		Dim v_atributo_general
	
		if not d_parametros_fila.Exists(p_campo) then		
			d_parametros_fila.Add p_campo, CreateObject("Scripting.Dictionary")
		end if
		
		if not d_parametros_fila.Item(p_campo).Exists(p_fila) then
			d_parametros_fila.Item(p_campo).Add p_fila, CreateObject("Scripting.Dictionary")
		end if
		
		v_atributo_general = p_atributo & "_G"
				
		if not d_parametros_fila.Item(p_campo).Item(p_fila).Exists(p_atributo) then
			d_parametros_fila.Item(p_campo).Item(p_fila).Add p_atributo, p_valor			
			d_parametros_fila.Item(p_campo).Item(p_fila).Add v_atributo_general, Me.ObtenerDescriptor(p_campo, p_atributo)
		else
			d_parametros_fila.Item(p_campo).Item(p_fila).Item(p_atributo) = p_valor
			d_parametros_fila.Item(p_campo).Item(p_fila).Item(v_atributo_general) = Me.ObtenerDescriptor(p_campo, p_atributo)
		end if		
	End Sub
	
	
	Sub AgregaBotonParam(p_boton, p_atributo, p_valor)
		for each kt in parametros.Item("botones").Keys
			if kt = p_boton then
				set it = parametros.Item("botones").Item(kt)
				
				if it.Exists(p_atributo) then
					it.Item(p_atributo) = p_valor
				else
					it.Add p_atributo, p_valor
				end if
				
				exit for
			end if
		next
	End Sub
	
	
	Sub AgregaBotonUrlParam(p_boton, p_parametro, p_valor)
		for each kt in parametros.Item("botones").Keys
			if kt = p_boton then
				set it = parametros.Item("botones").Item(kt)
				
				if not it.Item("parametrosUrl").Exists(p_parametro) then
					it.Item("parametrosUrl").Add p_parametro, p_valor
				else
					it.Item("parametrosUrl").Item(p_parametro) = p_valor
				end if
				
				exit for
			end if
		next
		
	End Sub
	
	
	sub agregaParam(atributo, valor)
		if typeName(parametros) = "Dictionary" then
			if parametros.Exists(atributo) then
				parametros.Item(atributo) = valor
			else
				parametros.Add atributo, valor
			end if
		end if
	end sub
	
	
	Sub AgregaElemento(p_tipo, p_nombre)
		select case UCase(p_tipo)
			case "CAMPOS"
				if not parametros.Item("campos").Exists(p_nombre) then
					parametros.Item("campos").Add p_nombre, CreateObject("Scripting.Dictionary")
				end if
				
			case "TABLAS"
			
			case "LISTAS"
			
			case "BOTONES"
			      if not parametros.Item("botones").Exists(p_nombre) then
					parametros.Item("botones").Add p_nombre, CreateObject("Scripting.Dictionary")
					
					set o_boton = parametros.Item("botones").Item(p_nombre)
					o_boton.Add "parametrosUrl", CreateObject("Scripting.Dictionary")					
				   end if
		end select
	End Sub
	
	sub pagina
		if parametros.Exists("nroRegistros") then
			p = request.QueryString("_p" & me.nombreVariable)
			if p = "" then
				offset = 0
			else
				offset = p
			end if	
			nroRegistros = parametros.Item("nroRegistros")
			select case totalRegistros mod nroRegistros
				case 0
					totalPaginas = totalRegistros / nroRegistros
				case else
					totalPaginas = int(totalRegistros/nroRegistros) + 1
			end select 
			response.Write("Página " & offset + 1 & " de " & totalPaginas)
		end if
	end sub

	function cambiaPatron(cadena,patron,valor)
	    patron = patron
		set regid         = New RegExp
		regid.Pattern     = patron & "=\w+"
		regid.IgnoreCase  = True
		cadena_inicial = cadena
		if regid.Test(cadena) then
		    nuevacadena=regid.replace(cadena_inicial,patron &"="& valor)
			cambiaPatron=nuevacadena
		else
		   if cadena_inicial="" then
		   	    nuevacadena=  patron &"="& valor 
		   else
				nuevacadena= cadena_inicial & "&" & patron &"="& valor
		   end if
		   cambiaPatron=nuevacadena
		end if
		set regid = nothing
    End function

	sub accesoPagina		
	'response.Write(parametros.Exists("nroRegistros"))
	
		if parametros.Exists("nroRegistros") then			
			p = request.QueryString("_p" & me.nombreVariable)
			q = request.QueryString("_q" & me.nombreVariable)
			if p = "" then
				offset = 0
			else
				offset = p
			end if	
			if q = "" then
				grupo = 0
			else
				grupo = q
			end if	
		'	response.Write(p&"--"&q)
			
			nroRegistros = parametros.Item("nroRegistros")
			maxLista = parametros.Item("maxLista")			
			
			select case totalRegistros mod nroRegistros
				case 0
					totalPaginas = totalRegistros / nroRegistros
				case else
					totalPaginas = int(totalRegistros/nroRegistros) + 1
			end select 
			select case totalPaginas mod maxLista
				case 0
					totalGrupos = totalPaginas / maxLista
				case else
					totalGrupos = int(totalPaginas/maxLista) + 1
			end select 
			if (q + 1)*maxLista < totalPaginas then				
				nroPaginasDespliegue = maxLista
			else				
				nroPaginasDespliegue = totalPaginas - q*maxLista				
			end if			
			
			Set fso = CreateObject("Scripting.FileSystemObject")
			archivo = fso.GetBaseName(request.ServerVariables("URL"))
			extension = fso.GetExtensionName(request.ServerVariables("URL"))
			cadena = request.ServerVariables("QUERY_STRING")
			for i = q*maxLista to q*maxLista + nroPaginasDespliegue - 1
				if cint(i) <> cint(p) then
					cadenaNueva = cambiaPatron(cadena ,"_p" & me.nombreVariable, i )
					punt = "<a href='" & archivo & "." & extension & "?" & cadenaNueva & "'>" & i + 1 & "</a>"
				else
					punt = i + 1
				end if
				s = s & "[" & punt & "]"
			next			
			if cint(q) > 0 then
				cadenaNueva = cambiaPatron(cadena ,"_q" & me.nombreVariable, q - 1 )
				s = "<a href='" & archivo & "." & extension & "?" & cadenaNueva & "'> << </a>" & s
			end if
			if cint(q) < totalGrupos - 1 then
				cadenaNueva = cambiaPatron(cadena ,"_q" & me.nombreVariable, q + 1 )
				s = s & "<a href='" & archivo & "." & extension & "?" & cadenaNueva & "'> >> </a>"
			end if			
			response.Write(s)
		end if
	end sub
	
	function nombreVariable
		if parametros.Exists("variable") then
			variable = parametros.Item("variable")
		else
			variable = "test"
		end if
		nombreVariable = variable	
	end function
	
	function obtenerAtributo(atrib)
		if not isObject(parametros) then
			response.write "No está cargando parametros"
			response.Flush()
		end if
		if parametros.Exists(atrib) then
			variable = parametros.Item(atrib)
		else
			variable = ""
		end if
		obtenerAtributo = variable	
	end function
	
	function nombreElemento(campo)
		nombreElemento = me.nombreVariable & "[" & fila_actual & "][" & campo & "]"
	end function
	
	function describeCampo(campo)
	    if parametros.Item("campos").Exists(campo) then
	    	set describeCampo = parametros.Item("campos").Item(campo)
		else
		    set describeCampo = CreateObject("Scripting.Dictionary")
		end if
	end function
	
	function DescribeBoton(p_id_boton)
	   	if parametros.Item("botones").Exists(p_id_boton) then
			set DescribeBoton = parametros.Item("botones").Item(p_id_boton)
		else
			set DescribeBoton = CreateObject("Scripting.Dictionary")
		end if
	end function
	
	sub inicializar(con)
		set conexion = con
		fila_actual = -1
		
		v_table_bordercolor = "#999999"
		v_table_bgcolor = "#ADADAD"
		
		v_tr_bgcolor = "#C4D7FF"
		v_tr_bordercolor = "#999999"
		v_tr_fontcolor = "#333333"
		
		v_grilla_bgcolor = "#FFFFFF"
		
		v_font_color = "#CC3300"
		
		v_color_resaltado = "#FFECC6"
		v_color_seleccionado = "#FFECC6" 
		
	
		set d_parametros_fila = CreateObject("Scripting.Dictionary")
	end sub
	
	
	sub consultar(sqltxt)
		
		p = request.QueryString("_p" & me.nombreVariable)
		if p = "" then
			offset = 0
		else
			offset = p
		end if		
				
		if parametros.Exists("nroRegistros") then
			'response.Write(sqltxt)
			totalRegistros = conexion.consultaLimitada ( sqltxt,parametros.Item("nroRegistros"),offset )
		else
			conexion.Ejecuta(sqltxt)
		end if
		
		set regs = conexion.obtenerRegistros
	end sub
	
    function siguiente
		n_filas = me.nroFilas
		if fila_actual < n_filas -1 then
		    fila_actual = fila_actual + 1
			siguiente = true
		else
		    siguiente = false
		end if
	end function
	
	function Anterior
		n_filas = me.nroFilas
		if fila_actual > 0 then
		    fila_actual = fila_actual - 1
			Anterior = true
		else
		    Anterior = false
		end if
	end function
    function primero
	    fila_actual = -1
	end function
	
    function siguienteF
	    fila_actual = fila_actual + 1
	end function
	
	function nroFilas
	    nroFilas = regs.Item("filas").count
	end function
	
	function obtenerValorFormateado(campo)
		valor = me.obtenerValor(campo)
		obtenerValorFormateado = valor
		if valor="" or isnull(valor) then
			valor = "0"
		end if

		select case ucase(me.obtenerDescriptor(campo,"formato"))
			case "ENTERO"
					obtenerValorFormateado = FormatNumber(valor,0,-1,0,-2)	
			case "DECIMAL"
				nroDecimales = ucase(me.obtenerDescriptor(campo,"decimales"))
				if not isNumeric(nroDecimales) then
					nroDecimales = 0
				end if
					obtenerValorFormateado = FormatNumber(valor,nroDecimales,-1,0,-2)
			case "MONEDA"
				nroDecimales = ucase(me.obtenerDescriptor(campo,"decimales"))
				if valor="" or isnull(valor) then
					valor = "0"
				end if
				if not isNumeric(nroDecimales) then
					nroDecimales = 0
				end if
					obtenerValorFormateado = "$ " & FormatNumber(valor,nroDecimales,-1,0,-2)
		end select
	end function

	function esDDMMYYYY
		fecha = #1/2/2000#
		if day(fecha) = 1 then
			esDDMMYYYY = true
		else
			esDDMMYYYY = false
		end if	
			
	end function
	
	function obtenerValor(campo)
         cm = ucase(campo)
		if  not me.esDDMMYYYY then
			dia = 0
			mes = 1
			ano = 2
		else
			dia = 1
			mes = 0
			ano = 2
		end if
		'response.write "campo: "& fila_actual & regs.Item("filas").Item(fila_actual).Item(cm)
		'response.Flush()
		if regs.Item("filas").count > 0 then
			if regs.Item("filas").Exists(fila_actual) then
				if regs.Item("filas").Item(fila_actual).Exists(ucase(cm)) then
					select case ucase(me.obtenerDescriptor(campo,"tipoDato"))
						case "FECHA"
							if not isNull( regs.Item("filas").Item(fila_actual).Item(cm) ) then 
								set r = new RegExp
								r.pattern = "([0-9]{1,2})[-/]([0-9]{1,2})[-/]([0-9]{4}) ([0-9]{1,2}):([0-9]{1,2}):([0-9]{3}) (PM|AM)|([0-9]{1,2})[-/]([0-9]{1,2})[-/]([0-9]{4})"
								r.Global = true
								r.IgnoreCase = true
								if r.Test(regs.Item("filas").Item(fila_actual).Item(cm)) then
									r.pattern = "([0-9]+)|(AM|PM)"
									set ms = r.Execute(regs.Item("filas").Item(fila_actual).Item(cm))
									select case ms.count
										case 3
											obtenerValor = string(2-len(ms.item(dia)),"0") & ms.item(dia) & "/" & string(2-len(ms.item(mes)),"0") & ms.item(mes) & "/" & ms.item(ano)
										case 6
											obtenerValor = string(2-len(ms.item(dia)),"0") & ms.item(dia) & "/" & string(2-len(ms.item(mes)),"0") & ms.item(mes) & "/" & ms.item(ano) 
										case 7
											obtenerValor = string(2-len(ms.item(dia)),"0") & ms.item(dia) & "/" & string(2-len(ms.item(mes)),"0") & ms.item(mes) & "/" & ms.item(ano)
										case else
											obtenerValor = ""
									end select
								end if
							else
								obtenerValor = ""
							end if
						case "FECHAHORA"
							if not isNull( regs.Item("filas").Item(fila_actual).Item(cm) ) then 
								set r = new RegExp
								r.pattern = "([0-9]{1,2})[-/]([0-9]{1,2})[-/]([0-9]{4}) ([0-9]{1,2}):([0-9]{1,2}):([0-9]{3}) (PM|AM)|([0-9]{1,2})[-/]([0-9]{1,2})[-/]([0-9]{4})"
								r.Global = true
								r.IgnoreCase = true
								if r.Test(regs.Item("filas").Item(fila_actual).Item(cm)) then
									r.pattern = "([0-9]+)|(AM|PM)"
									set ms = r.Execute(regs.Item("filas").Item(fila_actual).Item(cm))
									select case ms.count
										case 3
											obtenerValor = string(2-len(ms.item(dia)),"0") & ms.item(dia) & "/" & string(2-len(ms.item(mes)),"0") & ms.item(mes) & "/" & ms.item(ano) & " 00:00"
										case 6
											obtenerValor = string(2-len(ms.item(dia)),"0") & ms.item(dia) & "/" & string(2-len(ms.item(mes)),"0") & ms.item(mes) & "/" & ms.item(ano) & " " & ms.item(3) & ":" & ms.item(4) 
										case 7
											obtenerValor = string(2-len(ms.item(dia)),"0") & ms.item(dia) & "/" & string(2-len(ms.item(mes)),"0") & ms.item(mes) & "/" & ms.item(ano) & " " & ms.item(3) & ":" & ms.item(4) & " " & ms.item(6)
										case else
											obtenerValor = ""
									end select
								end if
							else
								obtenerValor = ""
							end if
						case "HORA"
							if not isNull( regs.Item("filas").Item(fila_actual).Item(cm) ) then 
								set r = new RegExp
								r.pattern = "([0-9]{1,2})/([0-9]{1,2})/([0-9]{4}) ([0-9]{1,2}):([0-9]{1,2}):([0-9]{3}) (PM|AM)|([0-9]{1,2})/([0-9]{1,2})/([0-9]{4})"
								r.Global = true
								r.IgnoreCase = true
								if r.Test(regs.Item("filas").Item(fila_actual).Item(cm)) then
									r.pattern = "([0-9]+)|(AM|PM)"
									set ms = r.Execute(regs.Item("filas").Item(fila_actual).Item(cm))
									select case ms.count
										case 3
											obtenerValor = "00:00"
										case 7
											obtenerValor = ms.item(3) & ":" & ms.item(4) & " " & ms.item(6)
										case else
											obtenerValor = ""
									end select
								end if
							else
								obtenerValor = ""
							end if
						case else
							obtenerValor = regs.Item("filas").Item(fila_actual).Item(cm)				
					end select
				else
					obtenerValor = ""
					if depuracion then
						response.Write "Error: campo buscado " & cm & " en<br>"
						for each cam in regs.Item("filas").Item(fila_actual).Keys
							response.Write cam & "<br>"
						next
						response.write "<br><br>"
					end if
				end if
			else
				obtenerValor = ""
			end if
		else
			obtenerValor=""
		end if
    end function
	
	sub dibujaEtiqueta(campo)
		response.write(me.obtenerDescriptor(campo,"descripcion"))
	end sub
	
	sub dibujaTexto(campo)
		fpaso = me.obtenerValor(campo)
		if isnull(fpaso) then
			fpaso=""
		end if
		set regEx = new RegExp
		regEx.Pattern = "%(\w+)%"
		regEx.IgnoreCase = True
		regEx.Global = True
		Set Matches = regEx.Execute(fpaso)
		nuevo = me.obtenerValor(campo)
		For Each Match in Matches  
		  set regExRep = new RegExp
		  regExRep.Pattern = Match.Value
		  regExRep.IgnoreCase = True
		  regExRep.Global = True
		  columna = mid(Match.Value,2,len(Match.Value)-2)
		  nuevo = regExRep.replace(nuevo,trim(me.obtenerValor(columna)))
		Next
		if ucase(me.obtenerDescriptor(campo,"etiqueta")) = "TRUE" then
			etiqueta = me.obtenerDescriptor(campo,"descripcion") & " "
		end if
		formato = me.obtenerDescriptor(campo,"formato")
		if formato = "" then
			valor = nuevo
			if valor = "" then
				valor = "&nbsp;"
			end if
	    	response.Write(etiqueta & valor)
		else
			response.write etiqueta & me.obtenerValorFormateado(campo)
		end if
	end sub
	
	function obtenerDescriptor(campo,descriptor)
	    set d_campo = me.describeCampo(campo)
		if d_campo.Exists(descriptor) then
		    dvalor = d_campo.Item(descriptor)
		else
		    dvalor = ""
		end if		
	    obtenerDescriptor = dvalor
	end function
	
	function ObtenerDescriptorBoton(p_id_boton, p_descriptor)
		set d_boton = me.DescribeBoton(p_id_boton)		
	
		if d_boton.Exists(p_descriptor) then
			ObtenerDescriptorBoton = d_boton.Item(p_descriptor)
		else
			ObtenerDescriptorBoton = ""
		end if
		
	end function
	
	sub dibujaInput(campo, tipo)
	    deshabilitado = me.esDeshabilitado(campo)
		idCampo = me.id(campo)
		script = me.obtenerDescriptor(campo,"script")
		soloLectura = me.obtenerDescriptor(campo,"soloLectura")
		onBlur = me.obtenerDescriptor(campo,"onBlur")
		if ucase(soloLectura) = "TRUE" then
			ro = "readonly"
		else
			ro = ""
		end if
		ancho = " size='" & me.obtenerDescriptor(campo,"caracteres") & "' "
		maximo = " maxlength='" & me.obtenerDescriptor(campo,"maxCaracteres") & "' "
		if ucase(me.obtenerDescriptor(campo,"etiqueta")) = "TRUE" then
			etiqueta = me.obtenerDescriptor(campo,"descripcion")
		end if
		if ucase(me.obtenerDescriptor(campo,"formato"))<>"" then
			s = " <input type='" & tipo & "' class=""derecha"" name='_" & me.nombreElemento(campo) & _
				"' value='" & me.obtenerValorFormateado(campo) & "' onFocus='desenMascara(this)' onBlur='enMascara( this, """ & me.obtenerDescriptor(campo,"formato") & """,0);" & onBlur & "' " & ancho & maximo & deshabilitado & idCampo & ro & ">" & chr(13)
			s = s & " <input type='HIDDEN' name='" & me.nombreElemento(campo) & _
				"' value='" & me.obtenerValor(campo) & "'" & ">" & chr(13)
		else
			s = " <input type='" & tipo & "'  name='" & me.nombreElemento(campo) & _
				"' value='" & me.obtenerValor(campo) & "'" & script & ancho & maximo & deshabilitado & idCampo & ro & ">" & chr(13)
		end if
		s = etiqueta & s
		response.Write(s)
	end sub
	
	sub dibujaTextarea(campo)
	    deshabilitado = me.esDeshabilitado(campo)
		idCampo = me.id(campo)
		script = me.obtenerDescriptor(campo,"script")
		
		ancho = " cols='" & me.obtenerDescriptor(campo,"caracteres") & "' "
		filas = " rows='" & me.obtenerDescriptor(campo,"filas") & "' "
		if ucase(me.obtenerDescriptor(campo,"etiqueta")) = "TRUE" then
			etiqueta = me.obtenerDescriptor(campo,"descripcion") & "<br>"
		end if
		if ucase(me.obtenerDescriptor(campo,"formato"))<>"" then
			s = "<textarea " & script & ancho & filas &  deshabilitado & idCampo & "name='" & me.nombreElemento(campo) & "'>" & _
				me.obtenerValor(campo) & "</textarea>" & chr(13)
		else
			s = "<textarea " & script & ancho & filas &  deshabilitado & idCampo & "name='" & me.nombreElemento(campo) & "'>" & _
				me.obtenerValor(campo) & "</textarea>" & chr(13)
		end if
		s = etiqueta & s
		response.Write(s)		
	end sub
	
	sub dibujaSelect(campo)
		destino = me.obtenerDescriptor(campo,"destino")
		upaso = me.obtenerDescriptor(campo,"union")
		salida = me.obtenerDescriptor(campo,"salida")
		codigo = me.obtenerDescriptor(campo,"codigo")
		fpaso = me.obtenerDescriptor(campo,"filtro")
		opaso = me.obtenerDescriptor(campo,"orden")
		permiso = me.obtenerDescriptor(campo,"permiso")
		deshabilitado = me.esDeshabilitado(campo)
		script = me.obtenerDescriptor(campo,"script")
		anulable = me.obtenerDescriptor(campo,"anulable")
		mensNulo = me.obtenerDescriptor(campo,"mensajeNulo")
		estpaso = me.obtenerDescriptor(campo,"estilo")
		varnpaso = me.obtenerDescriptor(campo,"varCondicionNulo")
		valnpaso = me.obtenerDescriptor(campo,"valCondicionNulo")
		mensVacio = me.obtenerDescriptor(campo,"mensajeVacio")

		idCampo = me.id(campo)
		
		if upaso <> "" then
			union = upaso
			sf = true
		else
			union = codigo
			sf = false
		end if
		
		if fpaso <> "" then
			set regEx = new RegExp
			regEx.Pattern = "%(\w+)%"
			regEx.IgnoreCase = True
			regEx.Global = True
			Set Matches = regEx.Execute(fpaso)
			nuevo = fpaso
			For Each Match in Matches  
			  set regExRep = new RegExp
			  regExRep.Pattern = Match.Value
			  regExRep.IgnoreCase = True
			  regExRep.Global = True
			  columna = mid(Match.Value,2,len(Match.Value)-2)
			  nuevo = regExRep.replace(nuevo,trim(me.obtenerValor(columna)))
			Next
			filtro = " where " & nuevo
		else
			filtro = ""
		end if
		if opaso <> "" then
			orden = " order by " & opaso
		else
			orden = ""
		end if
		if estpaso <> "" then
			estilo = " class='" & estpaso & "'"
		else
			estilo = ""
		end if
		consulta = "select  " & union & ", " & salida & " from " & destino &  filtro & orden
		conexion.ejecuta consulta
		set descripciones = conexion.obtenerRegistros
		if ucase(me.obtenerDescriptor(campo,"etiqueta")) = "TRUE" then
			etiqueta = me.obtenerDescriptor(campo,"descripcion") & " "
		end if
		s = etiqueta & " <select name='" & me.nombreElemento(campo) & "' " & script & deshabilitado & idCampo & estilo & ">" & chr(13)
		if descripciones.Item("filas").Count = 0 then
			s = s & "<option value=''>" & mensVacio & "</option>"
		else
			if ucase(anulable)= "TRUE" then
				colocarMensNulo = true
				if varnpaso <> "" then
					if eval(me.obtenerValor(varnpaso) & " <> " & valnpaso) then
						colocarMensNulo = false
					end if
				end if
				if colocarMensNulo then
					s = s & "<option value=''>" & mensNulo & "</option>"
				end if
			end if
			for each descripcion in descripciones.Item("filas").Items
				if descripcion.Exists(ucase(union)) then
					if sf then
						if not isnull(me.obtenerValor(campo)) then
							if cstr(descripcion.Item(ucase(union))) = cstr(me.obtenerValor(campo)) then
								seleccionado = " selected "
								valor = descripcion.Item(ucase(salida))
							else
								seleccionado = ""
							end if
						else
							seleccionado = ""
						end if
					end if
				else
					response.write "Error: union buscada " & ucase(union) & " en <br>"
					for each desc in descripcion.Keys
						response.write desc & "<br>"
					next
					response.write "<br><br>"
				end if
				s = s & "<option value='" & descripcion.Item(ucase(union)) & "' " & seleccionado & ">" & descripcion.Item(ucase(salida)) & "</option>" & chr(13)
			next
		end if
		s = s & "</select>" & chr(13)
		if ucase(permiso) = "LECTURAESCRITURA" then
			response.Write(s)
		else
			response.Write(etiqueta & valor)
		end if
	end sub
	
	sub dibujaRadio(campo)
		destino = me.obtenerDescriptor(campo,"destino")
		union = me.obtenerDescriptor(campo,"union")
		salida = me.obtenerDescriptor(campo,"salida")
		fpaso = me.obtenerDescriptor(campo,"filtro")
		permiso = me.obtenerDescriptor(campo,"permiso")
		columnas = me.obtenerDescriptor(campo,"columnas")
		deshabilitado = me.esDeshabilitado(campo)
		script = me.obtenerDescriptor(campo,"script")
		anchoTabla = Me.ObtenerDescriptor(campo, "ancho")

		idCampo = me.id(campo)

		if fpaso <> "" then
			filtro = " where " & fpaso
		end if
		consulta = "select " & union & ", " & salida & " from " & destino &  filtro
		conexion.ejecuta consulta
		set descripciones = conexion.obtenerRegistros
		if ucase(me.obtenerDescriptor(campo,"etiqueta")) = "TRUE" then
			et = me.obtenerDescriptor(campo,"descripcion") & " "
			etiqueta = "<tr><th colspan='" & columnas*2 & "'>" & et & "</th></tr>"
		end if
		s =  "<table width='" & anchoTabla & "'>" & etiqueta
		i=1
		for each descripcion in descripciones.Item("filas").Items
		    select case i mod columnas
				case 1
				    sini = "<tr>"
					ster = ""
				case 0
				    sini = ""
				    ster = "</tr>"
				case else
				    sini = ""
				    ster = ""				
			end select
			if not isnull(me.obtenerValor(campo)) then
				if cstr(descripcion.Item(ucase(union))) = cstr(me.obtenerValor(campo)) then
					chequeado = " checked "
					valor = descripcion.Item(ucase(salida))
				else
					chequeado = ""
				end if
			else
				chequeado = ""
			end if
			s = s & sini & "<td>"
			s = s & " <input type='RADIO' value='" & descripcion.Item(ucase(union)) & _
			    "' " & chequeado & script & deshabilitado & idCampo & " name='" & me.nombreElemento(campo) & "' >" & _
				descripcion.Item(ucase(salida)) & chr(13)
			s = s & "</td>"
			s = s & ster
			i = i + 1
		next
		s = s & "</table>"
		if ucase(permiso) = "LECTURAESCRITURA" then
			response.Write(s)
		else
			response.Write(etiqueta & valor)
		end if
	end sub
	
	function esDeshabilitado(campo)
		deshabilitado = me.obtenerDescriptor(campo,"deshabilitado")
		if ucase(deshabilitado) = "TRUE" then
			deshab = " disabled "
		else
			deshab = ""
		end if
		esDeshabilitado = deshab		
	end function
	
	function id(campo)
		idCampo = me.obtenerDescriptor(campo,"id")
		if ucase(idCampo) = "" then
			idSal = ""
		else
			idSal = " id='" & idCampo & "' "
		end if
		id = idSal		
	end function
	
	sub dibujaBoleano(campo)
		objeto = ucase(me.obtenerDescriptor(campo,"objeto"))
		afirmacion = me.obtenerDescriptor(campo,"afirmacion")
		negacion = me.obtenerDescriptor(campo,"negacion")
		permiso = me.obtenerDescriptor(campo,"permiso")
		deshabilitado = me.esDeshabilitado(campo)
		script = me.obtenerDescriptor(campo,"script")
		onclic = me.obtenerDescriptor(campo,"onClick")
		idCampo = me.id(campo)
		valor = me.obtenerValor(campo)
		
		valorVerdadero = me.ObtenerDescriptor(campo, "valorVerdadero")
		valorFalso = me.ObtenerDescriptor(campo, "valorFalso")
		if valorVerdadero = "" then	valorVerdadero = "1"		
		if valorFalso = "" then valorFalso = "2"
		
		select case objeto
			case "CHECKBOX"
				if Cstr(valor) = Cstr(valorVerdadero) then
					chequeado = " checked "
				else
					chequeado = " "
				end if
				if valor="" then
					valor = valorFalso
				end if
				s = "<input type='CHECKBOX' name='_" & me.nombreElemento(campo) & "' value='" & valorVerdadero & "' " & chequeado & script & deshabilitado & idCampo & " onClick=""cambiaOculto(this, '" & valorVerdadero & "', '" & valorFalso & "');" & onclic & """>"
				s = s & "<input type='HIDDEN' name='" & me.nombreElemento(campo) & "' value='" & valor & "' " & idCampo & ">"
			case "RADIO"
				if valor = valorVerdadero then
					chequeado1 = " checked "
					chequeado2 = " "
				elseif valor = valorFalso then
					chequeado1 = " "
					chequeado2 = " checked "
				end if	
				s = afirmacion & " <input type='RADIO' name='" & me.nombreElemento(campo) & "' value='" & valorVerdadero & "' " & chequeado1 & script & deshabilitado & idCampo & ">"
				s = s & negacion & "<input type='RADIO' name='" & me.nombreElemento(campo) & "' value='" & valorFalso & "' " & chequeado2 & script & deshabilitado & idCampo & ">"
		end select
		if ucase(permiso) = "LECTURAESCRITURA" then
			response.Write(s)
		else
			if valor = valorVerdadero then
				resp = afirmacion
			else
				resp = negacion
			end if
			response.Write(etiqueta & resp)
		end if
	end sub
	
	
	Sub EstablecerParametrosCampo(p_campo, p_fila, p_tipo)
		Dim it, valor
		
		if d_parametros_fila.Exists(p_campo) then
			if d_parametros_fila.Item(p_campo).Exists(p_fila) then
				for each it in d_parametros_fila.Item(p_campo).Item(p_fila)
				
					select case p_tipo
						case "ESPECIAL"
							valor = d_parametros_fila.Item(p_campo).Item(p_fila).Item(it)
						case "GENERAL"
							valor = Me.ObtenerDescriptor(p_campo, it & "_G")
					end select
					
					Me.AgregaCampoParam p_campo, it, valor
				next
			end if
		end if
	End Sub
	
    function DibujaCampo(campo)
	
		EstablecerParametrosCampo campo, fila_actual, "ESPECIAL"
		
		permisoGeneral = ucase(me.obtenerAtributo("permisoGeneral"))
		select case permisoGeneral
			case "LECTURA"
					select case ucase(me.obtenerDescriptor(campo,"permiso"))
						case "LECTURAESCRITURA"
							permiso = "LECTURA"
						case "OCULTO" 
							permiso = "INVISIBLE"
						case else 
							permiso = ucase(me.obtenerDescriptor(campo,"permiso"))
					end select
			case else
					permiso = ucase(me.obtenerDescriptor(campo,"permiso"))
		end select 	
	    select case permiso
			case "LECTURAESCRITURA"
			    select case ucase(me.obtenerDescriptor(campo,"tipo"))
					case "INPUT"
						me.dibujaInput campo, "text"
					case "HIDDEN"
						me.dibujaInput campo, "hidden"
					case "CLAVE"
						me.dibujaInput campo, "password"
					case "TEXTAREA"
						me.dibujaTextarea campo
					case "SELECT"
						me.dibujaSelect campo
					case "RADIO"
						me.dibujaRadio campo
					case "BOLEANO"
						me.dibujaBoleano campo
					case "BOTON"
						Me.AgregaElemento "BOTONES", campo
						for each atributo in parametros.Item("campos").Item(campo)
							Me.AgregaBotonParam campo, atributo, parametros.Item("campos").Item(campo).Item(atributo)							
						next						
						Me.AgregaBotonParam campo, "url", ReemplazaParametrosUrl(parametros.Item("campos").item(campo).item("url"))
						Me.DibujaBoton campo
				end select
			case "LECTURA"
			    select case ucase(me.obtenerDescriptor(campo,"tipo"))

					case "SELECT"
						me.dibujaSelect campo
					case "RADIO"
						me.dibujaRadio campo
					case "BOLEANO"
						me.dibujaBoleano campo
					case else
						me.dibujaTexto campo
				end select
			case "OCULTO"
				me.dibujaInput campo, "hidden"
			case "INVISIBLE"
			case else
			    select case ucase(me.obtenerDescriptor(campo,"tipo"))
					case "SELECT"
						me.dibujaSelect campo
					case else
						me.dibujaTexto campo
				end select
		end select
		
		EstablecerParametrosCampo campo, fila_actual, "GENERAL"
	end function
	
	Function ReemplazaParametrosUrl(p_texto)
		Dim v_texto
		Dim regEx, Matches, regExRep, columna		
	
		set regEx = new RegExp
		regEx.Pattern = "%(\w+)%"
		regEx.IgnoreCase = True
		regEx.Global = True
		Set Matches = regEx.Execute(p_texto)
		v_texto = p_texto
		For Each Match in Matches   
		  set regExRep = new RegExp
		  regExRep.Pattern = Match.Value
		  regExRep.IgnoreCase = True
		  regExRep.Global = True
		  columna = mid(Match.Value,2,len(Match.Value)-2)
		  v_texto = regExRep.replace(v_texto,trim(me.obtenerValor(columna)))
		Next		
			
		ReemplazaParametrosUrl = v_texto		
	
	End Function
	
	Sub DibujaLista
		dim salida
		dim campos
		dim nColumnas, anchoTabla, nRegistros
		dim str_columnas
		dim i, iColumna
		dim d, a
		
		set campos = parametros.Item("campos")
		d = campos.Keys
		a = campos.Items
		
		str_columnas = Me.ObtenerAtributo("columnas")
		
		if str_columnas <> "" then			
			nColumnas = CInt(str_columnas)
		else
			nColumnas = 1
		end if
		
		if nColumnas = 0 then nColumnas = 1			
		
		anchoTabla = Me.ObtenerAtributo("anchoTabla")
		nRegistros = Me.NroFilas		
		
		i = 0
		salida = "<table width='" & anchoTabla & "'  border='0' align='center' cellpadding='0' cellspacing='0'> " & Chr(13)
		
		while i < nRegistros			
			salida = salida & "  <tr>" & Chr(13)
			for iColumna = 1 to nColumnas
				salida = salida & "    <td>" & Chr(13)				
				salida = salida & "      <table width='100%' border='0' cellpadding='0' cellspacing='0'> " & Chr(13)				
				salida = salida & "        <tr>" & Chr(13)
								
				Me.Siguiente
				for j = 0 to campos.Count - 1
					salida = salida & "          <td width='" & a(j).Item("ancho") & "'>" & Chr(13)
					Response.Write(salida)
					salida = ""
					if i < nRegistros then
						Me.DibujaCampo(d(j))
					end if
					salida = salida & "          </td>" & Chr(13)
				next			
				
				salida = salida & "        </tr> " & Chr(13)								
				salida = salida & "      </table>" & Chr(13)								
				salida = salida & "    </td>" & Chr(13)
				
				if iColumna <> nColumnas then
					salida = salida & "    <td width='" & Me.ObtenerAtributo("separacionColumnas") & "'></td>" & Chr(13)
				end if
				
				i = i + 1
			next
			salida = salida & "  </tr>" & Chr(13)			
		wend
		
		salida = salida & "</table>" & Chr(13)
		
		Response.Write(salida)		
	End Sub
	
	
	Sub DibujaRegistro
		dim salida
		dim campos, a, d
		dim i, j
		dim v_id, v_obligatorio, v_alto_fila, v_columnas
		dim str_obligatorio, bcampos_obligatorios
		dim ncolumnas, ncampos
		dim str_sep
		dim v_separacion
		
		set campos = parametros.Item("campos")
		a = campos.Items
		d = campos.Keys
		
		v_columnas = Me.ObtenerAtributo("columnas")
		if IsNumeric(v_columnas) then
			ncolumnas = CInt(v_columnas)
			if ncolumnas <= 0 then
				ncolumnas = 1
			end if
		else
			ncolumnas = 1
		end if	
				
		if UCase(Me.ObtenerAtributo("camposObligatorios") = "TRUE") then
			bcampos_obligatorios = true
		else
			bcampos_obligatorios = false
		end if
		
		v_separacion = Me.ObtenerAtributo("separacion")
		if v_separacion = "" then
			v_separacion = "10"
		end if
		
		
		
		v_alto_fila = "18"		
		str_obligatorio = "(*)"
		
		if Me.NroFilas > 0 then		
			Me.Siguiente
			
			ncampos = campos.Count
			
			salida = "<table width='" & Me.ObtenerAtributo("anchoTabla") & "'  border='0' align='center' cellpadding='0' cellspacing='0'>" & Chr(13)
			
			i = 0
			while i < ncampos
				salida = salida & "  <tr>" & Chr(13)
				
				for j = 1 to ncolumnas
					if i < ncampos then
					
						if UCase(a(i).Item("permiso") <> "OCULTO") then	
												
							v_id = a(i).Item("id")					
							v_obligatorio = ""
							if v_id <> "" then
								if (split(v_id, "-"))(1) = "N" then
									v_obligatorio = str_obligatorio									
								end if
							end if							
							
							if bcampos_obligatorios then
								salida = salida & "    <td width='" & v_separacion & "' height='" & v_alto_fila & "'><div align='center' style='color: #FF0000; font-weight: bold;'>" & v_obligatorio & "</div></td>" & Chr(13)												
							end if
							
							salida = salida & "    <td height='" & v_alto_fila & "'><strong>" & a(i).Item("descripcion") & "</strong></td>" & Chr(13)
							
							if UCase(a(i).Item("tipo")) = "SEPARADOR" then
								str_sep = ""
							else
								str_sep = ":"
							end if
							
							salida = salida & "    <td width='" & v_separacion & "' height='" & v_alto_fila & "'><div align='center'><strong>" & str_sep & "</strong></div></td>" & Chr(13)
							salida = salida & "    <td><div align='"&a(i).Item("alineamiento")&"'>"
							
							Response.Write(salida)
							salida = ""						
							Me.DibujaCampo(d(i))
							
							salida = salida & "    </div></td>" & Chr(13)		
							
							if j <> ncolumnas then
								salida = salida & "    <td width='" & Me.ObtenerAtributo("separacionColumnas") & "' height='" & v_alto_fila & "'></td>" & Chr(13)
							end if
						else
							Me.DibujaCampo(d(i))
						end if			
					end if					
					i = i + 1					
				next
			
				salida = salida & "</tr>" & Chr(13)	
				
			wend
						
			
			if bcampos_obligatorios then
				salida = salida & "  <tr><td colspan='" & (ncolumnas * 4) & "'><div align='right'><br><font color='#FF0000'><b>" & str_obligatorio & "</b></font> Campos obligatorios</div></td></tr> " & Chr(13)		
			end if
			
			salida = salida & "</table>"
		
		end if
		
		Response.Write(salida)
	End Sub
	
	
	sub DibujaTabla

		set cont_resumen = CreateObject("Scripting.Dictionary")
		anchoTabla = me.obtenerAtributo("anchoTabla")
		if ucase(me.obtenerAtributo("resumen"))="TRUE" then
			resumen = true
		end if
	    set campos = parametros.Item("campos")
		a = campos.Items
		d = campos.Keys
		nro_reg = me.nroFilas
		
				
		s = chr(13) & "<script language='javaScript1.2'> colores = Array(3);" & _
		    "   colores[0] = '" & parametros.Item("colorBase") & _
			"'; colores[1] = '" & parametros.Item("colorResaltado") &  _
			"'; colores[2] = '" & parametros.Item("colorSeleccionado") & "'; </script>" & chr(13)		

			
		s = chr(13) & "<script language='javaScript1.2'> colores = Array(3);" & _
		    "   colores[0] = ''; colores[1] = '" & v_color_resaltado & "'; colores[2] = '" & v_color_seleccionado & "'; </script>" & chr(13)
		
	    s = s & "<table class=v1 width='" & anchoTabla & "' border='1' cellpadding='0' cellspacing='0' bordercolor='" & v_table_bordercolor & "' bgcolor='" & v_table_bgcolor & "' id='tb_" & parametros.Item("variable") & "'>" & chr(13)
		s = s & "<tr bgcolor='" & v_tr_bgcolor & "' bordercolor='" & v_tr_bordercolor & "'>" & chr(13)
		if nro_reg > 0 and parametros.Item("eliminar") then
		    if parametros.item("seleccionarTodo") then
			    s = s & "<script language='JavaScript'>" & vbCrLf
				s = s & "variable_tabla = '" & parametros.Item("variable") & "';" & vbCrLf
				s = s & "clave_tabla='" & parametros.Item("clave") & "';" & vbCrLf
				s = s & "</script>" & vbCrLf
			    s = s & "<th><input type='checkbox' name='chk_selTodo' onClick='_SeleccionarTodo(this.form, variable_tabla, clave_tabla, " & nro_reg & ")'></th>" & chr(13)
			else
		        s = s & "<th>&nbsp;</th>" & chr(13)
			end if
		end if
		for j=0 to campos.count - 1
			select case ucase(me.obtenerDescriptor(d(j),"permiso"))
				case "LECTURAESCRITURA" 
					s = s & "<th><font color='" & v_tr_fontcolor & "'>" & a(j).Item("descripcion") & "</font></th>" & chr(13)
				case "LECTURA"
					s = s & "<th><font color='" & v_tr_fontcolor & "'>" & a(j).Item("descripcion") & "</font></th>" & chr(13)
			end select 
		next
		s = s & "</tr>" & chr(13)
		
		if nro_reg = 0 then
		    s = s & "<tr bgcolor=""" & v_grilla_bgcolor & """><td align='center' colspan='" & parametros.Item("campos").count + 1 & "'>" & parametros.Item("mensajeError") & "</td></tr>" & chr(13)
		else
			for i_=0 to nro_reg - 1 
				me.siguiente
				    paginaEdicion = parametros.Item("paginaEdicion")
					set regEx = new RegExp
					regEx.Pattern = "%(\w+)%"
					regEx.IgnoreCase = True
					regEx.Global = True
					Set Matches = regEx.Execute(paginaEdicion)
					nuevo = paginaEdicion
					For Each Match in Matches   
					  set regExRep = new RegExp
					  regExRep.Pattern = Match.Value
					  regExRep.IgnoreCase = True
					  regExRep.Global = True
					  columna = mid(Match.Value,2,len(Match.Value)-2)
					  nuevo = regExRep.replace(nuevo,trim(me.obtenerValor(columna)))
				    Next
				    if ucase(parametros.Item("nuevaVentana")) = "TRUE" then
					    donde = 1
					else
                        donde = 2  
					end if
					
					if (not IsEmpty(parametros.Item("nuevaVentanaAncho"))) and (IsNumeric(parametros.Item("nuevaVentanaAncho"))) then
						v_nuevaVentanaAncho = CInt(parametros.Item("nuevaVentanaAncho"))
					else
						v_nuevaVentanaAncho = 770
					end if
					
					if (not IsEmpty(parametros.Item("nuevaVentanaAlto"))) and (IsNumeric(parametros.Item("nuevaVentanaAlto"))) then
						v_nuevaVentanaAlto = CInt(parametros.Item("nuevaVentanaAlto"))
					else
						v_nuevaVentanaAlto = 400
					end if	
					

									
				
		        if ucase(parametros.Item("eliminar")) = "TRUE" then
				    marca = "<td width='10' align='center'><input type='checkbox' name='" & _
				        parametros.Item("variable") & "[" & i_ & "][" & _
						parametros.Item("clave") & "]' value='" & _
						me.obtenerValor(parametros.Item("clave")) & "' onClick='seleccionar(this)'></td>" & chr(13) 
				else
				    marca = ""
				end if
				s = s & "<tr bgcolor=""" & v_grilla_bgcolor & """>"
				s = s & marca
				for j=0 to campos.count - 1
					if ucase(parametros.Item("editar")) = "TRUE"  and ucase(me.obtenerDescriptor(d(j),"permiso")) <> "LECTURAESCRITURA" then
						accion = "onClick='irA(" & chr(34) & nuevo & chr(34) & ", " & chr(34) & donde & chr(34) & ", " & v_nuevaVentanaAncho & ", " & v_nuevaVentanaAlto & ")'"
						estilo = "class='click'"
					else
						accion = ""
						estilo = "class='noclick'"
					end if
					if resumen then
						tipo_resumen = ucase(me.obtenerDescriptor(d(j),"resumen"))
						
						if tipo_resumen <> "" then
							if not cont_resumen.exists(d(j)) then
								cont_resumen.Add d(j) , 0
							end if
							
							select case tipo_resumen
								case "SUMA"
									
									if isNumeric (me.obtenerValor(d(j))) then
								    	valorCampo = clng(me.obtenerValor(d(j)))
									else
										valorCampo = 0
									end if
									cont_resumen.Item(d(j)) = cont_resumen.Item(d(j)) + valorCampo
								case "SUMA_JC"
								    	valorCampo = Ccur(me.obtenerValor(d(j)))
										cont_resumen.Item(d(j)) = cont_resumen.Item(d(j)) + valorCampo
								case "CUENTA"
									cont_resumen.Item(d(j)) = cont_resumen.Item(d(j)) + 1
							end select 
						end if
					end if
					
					v_nowrap = Me.ObtenerDescriptor(d(j), "nowrap")
					if UCase(v_nowrap) = "TRUE" then
						str_nowrap = " nowrap"
					else
						str_nowrap = ""
					end if
					
					select case ucase(me.obtenerDescriptor(d(j),"permiso"))
						case "LECTURAESCRITURA"
							s = s & "<td " & estilo & "align='" & a(j).Item("alineamiento") & "' width='" & a(j).Item("ancho") & "' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' " & accion & ">" 
							response.Write(s)
							me.dibujaCampo(d(j))
							s = "</td>" & chr(13)
						case "OCULTO"
							response.Write(s)
							me.dibujaCampo(d(j))
							s = chr(13)
						case "LECTURA"
							s = s & "<td " & estilo & "align='" & a(j).Item("alineamiento") & "' width='" & a(j).Item("ancho") & "' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' " & accion & str_nowrap & ">" 
							response.Write(s)
							me.dibujaCampo(d(j))							
							s = "</td>" & chr(13)
					end select 
				next
		        s = s & "</tr>" & chr(13) 
			next
		end if
		
		
		if resumen then
			'response.write "<tr bgcolor=""" & v_grilla_bgcolor & """>"
			s = s & "<tr bgcolor=""" & v_grilla_bgcolor & """>"
			cont = 0
			nColumnas = 0
			flag = true
			for j=0 to campos.count - 1
			
				if a(j).Item("permiso") <> "OCULTO" then
					nColumnas = nColumnas + 1
				end if				
				 
				if cont_resumen.exists(d(j)) then
					if flag then
						flag = false
						'response.write "<th colspan='" & cont & "'>Total</th>"
						if not parametros.Item("eliminar") then
							nColumnas = nColumnas - 1
						end if
						s = s & "<th colspan='" & nColumnas & "'>Total</th>"
					end if
					alineamiento = me.obtenerDescriptor(d(j),"alineamiento")
					if alineamiento <> "" then
						al_str = "align='" & alineamiento & "'"
					end if
					select case ucase(me.obtenerDescriptor(d(j),"formato"))
						case "MONEDA"
									sf = "$ " & formatNumber(cont_resumen.Item(d(j)),0,-1,0,-1)
						case "DECIMAL"
									sf = formatNumber(cont_resumen.Item(d(j)),0,-1,0,-1)					
						case "ENTERO"
									sf = formatNumber(cont_resumen.Item(d(j)),0,-1,0,-1)						
					end select 
					'response.write "<th " & al_str & ">" & sf & "</th>"
					s = s & "<th " & al_str & ">" & sf & "</th>"
				elseif not flag then
					'response.write "<td>&nbsp;</td>"
					s = s & "<td>&nbsp;</td>"
				end if
				
				cont = cont + 1				
			next
			'response.write "</tr>"
			s = s & "</tr>"
		end if
		
		
	    s = s & "</table>" & chr(13)
		response.write(s)
		
	end sub


	sub inicializaListaDependiente(lista, consulta)
		set listaDep = new cListaDependiente
		listaDep.inicializa conexion, consulta, parametros.Item("listas").Item(lista)
	end sub
	
	sub generaJS
		listaDep.generaJavaScript
	end sub
	
	sub dibujaCampoLista (lista, campo)		
		set thd = parametros.Item("listas").Item(lista)
		nroElementos = thd.count
		i=1
		flag = false
		flag2 = false
		ca = ""
		axnx = ""
		nom = ""
		for each k in thd
			if flag2 then
				el = me.nombreElemento(k)
				axn5 = axn5 & "completaSelect('" & el & "',''" & nom & "); "
			end if
			if flag then
				valor = me.obtenerValor(lcase(k))
				elemento = me.nombreElemento(k)
				axn1 = "completaSelect('" & elemento & "','" & valor & "'" & nom & "); "
				flag = false
			end if
			nombre = me.nombreElemento(k)
			if k = ucase(campo) then
				flag = true
				flag2 = true
				if i = 1 then
					valor = me.obtenerValor(lcase(k))
					axnx = "completaSelect('" & nombre  & "','" & valor & "'); " & vbCrLf
				end if
				nom2 = nombre
			end if
			nom = nom & ", '" & nombre & "'"
			ca = k
			i = i + 1
		next
		axn2 = " onChange=""" & axn5 & """"
		response.write "<select name=""" & nom2 & """ " & axn2 & "></select>"		
		listaDep.asignaSalida axnx & vbCrLf 
		listaDep.asignaSalida axn1 & vbCrLf 		
	end sub
	
	
	Function ObtenerTextoBoton(p_id_boton)	
		select case (UCase(Me.ObtenerDescriptorBoton(p_id_boton, "tipoTexto")))		
			case "ELIMINAR"
				ObtenerTextoBoton = "Eliminar"		
		
			case "BUSCAR"
				ObtenerTextoBoton = "Buscar"
				
			case "AGREGAR"
				ObtenerTextoBoton = "Agregar"
				
			case "SALIR"
				ObtenerTextoBoton = "Salir"
				
			case "ACTUALIZAR"
				ObtenerTextoBoton = "Actualizar"
				
			case "GUARDAR"
				ObtenerTextoBoton = "Guardar"
				
			case "SIGUIENTE"
				ObtenerTextoBoton = "Siguiente"
				
			case "ANTERIOR"
				ObtenerTextoBoton = "Anterior"
				
			case "DEFINIR"
				ObtenerTextoBoton = Me.ObtenerDescriptorBoton(p_id_boton, "texto")
				
			case "CERRAR"
				ObtenerTextoBoton = "Cerrar"
				
			case "ACEPTAR"
				ObtenerTextoBoton = "Aceptar"
				
			case "CANCELAR"
				ObtenerTextoBoton = "Cancelar"
				
			case "IMPRIMIR"
				ObtenerTextoBoton = "Imprimir"
				
			case else
				ObtenerTextoBoton = ""
		end select
	End Function
	
	
	Function ObtenerSoloUnClick(p_SoloUnClick, p_default)
		if p_SoloUnClick = "" then
			if p_default then
				ObtenerSoloUnClick = "TRUE"
			else
				ObtenerSoloUnClick = "FALSE"
			end if
		else
			ObtenerSoloUnClick = p_SoloUnClick
		end if
		
	End Function
	
	
	Function ObtenerFuncionBoton(p_id_boton)
		Dim v_accion
		
		v_accion = UCase(Me.ObtenerDescriptorBoton(p_id_boton, "accion"))
		
		select case (v_accion)
			case "ELIMINAR"
				ObtenerFuncionBoton = "_Eliminar(this, document.forms['" & Me.ObtenerDescriptorBoton(p_id_boton, "formulario") & "'], '" & Me.ObtenerDescriptorBoton(p_id_boton, "url") & "', '" & Me.ObtenerDescriptorBoton(p_id_boton, "mensajeConfirmacion") & "', '" & Me.ObtenerSoloUnClick(Me.ObtenerDescriptorBoton(p_id_boton, "soloUnClick"), true) & "');"
				
			case "AGREGAR"
				ObtenerFuncionBoton = "_Agregar(this, '" & Me.ObtenerDescriptorBoton(p_id_boton, "url") & "', '" & Me.ObtenerDescriptorBoton(p_id_boton, "posicionX") & "', '" & Me.ObtenerDescriptorBoton(p_id_boton, "posicionY") & "', '" & Me.ObtenerDescriptorBoton(p_id_boton, "ancho") & "', '" & Me.ObtenerDescriptorBoton(p_id_boton, "alto") & "', '" & Me.ObtenerDescriptorBoton(p_id_boton, "scroll") & "', '" & Me.ObtenerSoloUnClick(Me.ObtenerDescriptorBoton(p_id_boton, "soloUnClick"), false) & "');"
				
			case "BUSCAR" 
				ObtenerFuncionBoton = "_Buscar(this, document.forms['" & Me.ObtenerDescriptorBoton(p_id_boton, "formulario") & "'],'" & Me.ObtenerDescriptorBoton(p_id_boton, "url") & "', '" & Me.ObtenerDescriptorBoton(p_id_boton, "funcionValidacion") & "', '" & Me.ObtenerSoloUnClick(Me.ObtenerDescriptorBoton(p_id_boton, "soloUnClick"), false) & "')"
				
			case "CERRAR"
				ObtenerFuncionBoton = "_CerrarVentana();"
				
			case "ACTUALIZAR"
				ObtenerFuncionBoton = "_Actualizar(this, document.forms['" & Me.ObtenerDescriptorBoton(p_id_boton, "formulario") & "'], '" & Me.ObtenerDescriptorBoton(p_id_boton, "url") & "', '" & Me.ObtenerDescriptorBoton(p_id_boton, "funcionValidacion") & "', '" & Me.ObtenerDescriptorBoton(p_id_boton, "mensajeConfirmacion") & "', '" & Me.ObtenerSoloUnClick(Me.ObtenerDescriptorBoton(p_id_boton, "soloUnClick"), true) & "')"
				
			case "GUARDAR"
				ObtenerFuncionBoton = "_Guardar(this, document.forms['" & Me.ObtenerDescriptorBoton(p_id_boton, "formulario") & "'], '" & Me.ObtenerDescriptorBoton(p_id_boton, "url") & "','" & Me.ObtenerDescriptorBoton(p_id_boton, "target") & "', '" & Me.ObtenerDescriptorBoton(p_id_boton, "funcionValidacion") & "', '" & Me.ObtenerDescriptorBoton(p_id_boton, "mensajeConfirmacion") & "', '" & Me.ObtenerSoloUnClick(Me.ObtenerDescriptorBoton(p_id_boton, "soloUnClick"), false) & "')"
				
			case "NAVEGAR"
				ObtenerFuncionBoton = "_Navegar(this, '" & Me.ObtenerDescriptorBoton(p_id_boton, "url") & "', '" & Me.ObtenerSoloUnClick(Me.ObtenerDescriptorBoton(p_id_boton, "soloUnClick"), false) & "')"
				
			case "JAVASCRIPT"
				ObtenerFuncionBoton = Me.ObtenerDescriptorBoton(p_id_boton, "funcion")
				
			case else 
				ObtenerFuncionBoton = ""
				
		end select
	End Function
	
	
	Sub FormarUrlBoton(p_id_boton)
		Dim str_parametro, str_valor, url_original, str_parametros, url_final
		Dim union
		
		if parametros.Item("botones").Exists(p_id_boton) then		
			url_original = Me.ObtenerDescriptorBoton(p_id_boton, "url")
			str_parametros = ""			
									
			for each str_parametro in parametros.Item("botones").Item(p_id_boton).Item("parametrosUrl").Keys
				str_parametros = str_parametros & str_parametro & "=" & parametros.Item("botones").Item(p_id_boton).Item("parametrosUrl").Item(str_parametro) & "&"
			next
			
			if Len(str_parametros) > 0 then
				str_parametros = Left(str_parametros, Len(str_parametros) - 1)
			end if			
			
			if InStrRev(url_original, "?") > 0 then
				union = "&"
			else
				union = "?"
			end if
			
			if Len(str_parametros) > 0 then
				url_final = url_original & union & str_parametros
			else
				url_final = url_original
			end if
			
			Me.AgregaBotonParam p_id_boton, "url", url_final
			
		end if
		
	End Sub 
		
	
	Sub DibujaBoton(p_id_boton)
		Dim v_accion, v_texto, v_tipo_texto
		Dim salida, nombre_boton, str_funcion
		Dim v_class, v_funcion_over, v_funcion_out
				
		v_accion = UCase(Me.ObtenerDescriptorBoton(p_id_boton, "accion"))
		v_tipo_texto = UCase(Me.ObtenerDescriptorBoton(p_id_boton, "tipoTexto"))
		v_texto = Me.ObtenerTextoBoton(p_id_boton)		
		
		nombre_boton = "bt_" & p_id_boton & CLng((Rnd(Second(now)) * 10000))
		
		Me.FormarUrlBoton(p_id_boton)
		
		
		str_funcion = Me.ObtenerFuncionBoton(p_id_boton)
		v_class = "click"
		v_funcion_over = "_OverBoton(this);"
		v_funcion_out = "_OutBoton(this);"
		
		v_ancho = "88"
		if Len(v_texto) > 15 then
			v_ancho = "160"
		end if
		
		if UCase(Me.ObtenerDescriptorBoton(p_id_boton, "deshabilitado")) = "TRUE" then			
			v_class = "noclick"
			str_funcion = ""
			v_funcion_over = ""
			v_funcion_out = ""
			v_texto = "" & v_texto & ""
		end if

		salida = "<table id=""" & nombre_boton & """ width=""92"" border=""0"" cellspacing=""0"" cellpadding=""0"" class=""" & v_class & """ onMouseOver=""" & v_funcion_over & """ onMouseOut=""" & v_funcion_out & """ onClick=""" & str_funcion & """>" & vbCrLf &_
		         "  <tr> " & vbCrLf &_
				 "    <td width=""7"" height=""16"" rowspan=""3""><img src=""../imagenes/botones/boton1.gif"" width=""5"" height=""16"" id=""" & nombre_boton & "c11""></td> " & vbCrLf &_
				 "    <td width=""88"" height=""2""><img src=""../imagenes/botones/boton2.gif"" width=""" & v_ancho & """ height=""2"" id=""" & nombre_boton & "c12""></td> " & vbCrLf &_
				 "    <td width=""10"" height=""16"" rowspan=""3""><img src=""../imagenes/botones/boton4.gif"" width=""5"" height=""16"" id=""" & nombre_boton & "c13""></td>" & vbCrLf &_
				 "  </tr>" & vbCrLf &_
				 "  <tr> " & vbCrLf &_
				 "    <td height=""12"" bgcolor=""#EEEEF0"" id=""" & nombre_boton & "c21"" nowrap> " & vbCrLf &_
				 "      <div align=""center""><font id=""" & nombre_boton & "f21"" color=""#333333"" size=""1"" face=""Verdana, Arial, Helvetica, sans-serif"">" & v_texto & "</font></div></td>" & vbCrLf &_
				 "  </tr>" & vbCrLf &_
				 "  <tr> " & vbCrLf &_
				 "    <td width=""88"" height=""2""><img src=""../imagenes/botones/boton3.gif"" width=""" & v_ancho & """ height=""2"" id=""" & nombre_boton & "c31""></td>" & vbCrLf &_
				 "  </tr>" & vbCrLf &_
				 "</table>"

 salida1 =" <input class=boton type=""button"" name=""" & nombre_boton & "f21"" value="""& v_texto &""" onClick=""" & str_funcion & """>"
				 
		Response.Write(salida)
		
	End Sub
	
	Private Sub Class_Terminate   
      set conexion = nothing
   	End Sub
	
End Class
%>