<%
Function InvokeWebService (strSoap, strSOAPAction, strURL, ByRef xmlResponse)
    '*****************************************************************************
    ' Descripción: Invoca un WebService y obtiene su resultado.
    '
    ' Inputs:
    '    strSoap:        Petición HTTP a enviar, en formato SOAP. Contiene la    
    '                llamada al WebMethod y sus parámetros 
    '                correspondientes.
    '    strSOAPAction:    Namespace y nombre del WebMethod a utilizar.
    '    strURL:        URL del WebService.
    '
    ' Returns:
    '    La función retornará False si ha fallado la ejecución del WebService o si
    '    ha habido error en la comunicación con el servidor remoto. De lo contrario
    '    retornará True.
    '
    '    xmlResponse:    Respuesta obtenida desde el WebService, parseada 
    '                por el MSXML.
    '*****************************************************************************

    Dim xmlhttp
    Dim blnSuccess

        'Creamos el objeto ServerXMLHTTP
        Set xmlhttp = Server.CreateObject("Msxml2.ServerXMLHTTP")
		'Set xmlhttp = CreateObject("Microsoft.XMLHTTP")


        'Abrimos la conexión con el método POST, ya que estamos enviando una
        'petición.
        xmlhttp.Open "POST", strURL

        'Agregamos encabezados HTTP requeridos por el WebService
        xmlhttp.setRequestHeader "Man", "POST " & strURL & " HTTP/1.1"
        xmlhttp.setRequestHeader "Content-Type", "text/xml; charset=utf-8"
        xmlhttp.setRequestHeader "SOAPAction", strSOAPAction

        'El SOAPAction es importante ya que el WebService lo utilizará para
        'verificar qué WebMethod estamos usando en la operación.

        'Enviamos la petición
        xmlhttp.send(strSoap)
        'Verificamos el estado de la comunicación
        If xmlhttp.Status = 200 Then

            'El código 200 implica que la comunicación se puedo establecer y que
            'el WebService se ejecutó con éxito.
			blnSuccess = True
        Else

            'Si el código es distinto de 200, la comunicación falló o el
            'WebService provocó un Error.
			Dim errores(14)
			errores(0) = Array (301,"Movido permanentemente","Servidor","La pagina solicitada se ha movido permanentemente. El servidor redirige automáticamente la solicitud a la nueva ubicación.")
			errores(1) = Array (304,"No Modificado","Servidor","El servidor ha decidido, sobre la base de la información en la solicitud, que los datos solicitados no se ha modificado desde la última solicitud y para que no tenga que ser enviado de nuevo.")
			errores(2) = Array (307,"Redirección temporal","Servidor","La página solicitada se ha movido, pero este cambio no puede ser permanente. El servidor redirige automáticamente la solicitud a la nueva ubicación.")
			errores(3) = Array (400,"Solicitud incorrecta","Client.BadRequest","La petición HTTP es incompleto o incorrecto.")
			errores(4) = Array (401,"Se requiere autorización","Client.Authorization","Se requiere autorización para utilizar el servicio, pero no se suministra un nombre de usuario y una contraseña válidos.")
			errores(5) = Array (403,"Prohibido","Client.Forbidden","Usted no tiene permiso para acceder a la base de datos.")
			errores(6) = Array (404,"Extraviado,Client.NotFound","La base de datos llamada no se ejecuta en el servidor, o el servicio web llamado no existe.")
			errores(7) = Array (408,"Solicitud de tiempo de espera","Server.RequestTimeout","La conexión de máximo tiempo de inactividad se superó durante la recepción de la solicitud.")
			errores(8) = Array (411,"HTTP longitud requerida","Client.LengthRequired","El servidor requiere que el cliente incluye una especificación Content-Length en la solicitud. Esto suele ocurrir cuando se cargan los datos al servidor.")
			errores(9) = Array (413,"Entidad demasiado grande","Servidor","La solicitud supera el tamaño máximo permitido.")
			errores(10) = Array (414,"URI demasiado grande","Servidor","La longitud de la URI excede la longitud máxima permitida.")
			errores(11) = Array (500,"Error Interno del Servidor","Servidor","Se ha producido un error interno. La solicitud no pudo ser procesada.<br />Consultar por folios.")
			errores(12) = Array (501,"No Implementado","Servidor","El método de solicitud HTTP no es GET, HEAD, o POST.")
			errores(13) = Array (502,"Mala puerta de enlace","Servidor","El documento solicitado reside en un servidor de terceros y el servidor ha recibido un error del servidor de terceros.")
			errores(14) = Array (503,"Servicio No Disponible","Servidor","El número de conexiones supera el máximo permitido.")
			
			for each errors in errores
				if Cstr(errors(0)) = cstr(xmlhttp.Status) then
					texto = "ERROR NUMERO " & errors(0) & vbCrLf&_
						"Nombre.- " &errors(1)&vbCrLf&_
						"Lugar de error.- "&errors(2)&vbCrLf&_
						"Descripcion.- "&errors(3)
					response.write "<pre>"&texto&"</pre>"
					'response.write "Se ha producido un error"
				end if
			next
			
            blnSuccess = False
        End If

        'Obtenemos la respuesta del servidor remoto, parseada por el MSXML.
        Set xmlResponse = xmlhttp.responseXML
		
		InvokeWebService = blnSuccess

        'Destruimos el objeto, acá no hay GarbageCollector ;)
        Set xmlhttp = Nothing
	End Function

	public sub print_r(arr, depth)
		if isArray(arr) then
			If depth=0 then
				Response.Write ("<pre>Array <br/>" & depth & "(<br />")
			else
				Response.Write ("Array" & depth & "(<br />")
			end if
			for x=0 to uBound(arr)
				if isArray(arr(x)) then
					for i=0 to depth
					Response.write("   ")
					next 
					Response.write (depth & "["&x&"] =>")
					call print_r(arr(x), depth+1) 
				else
					for i=0 to depth
					Response.write("   ")
					next
					Response.write(depth & "["&x&"] =>" & arr(x))
				end if
				Response.Write ("<br />")
			next
			for i=1 to depth
				Response.write("   ")
			next
			Response.Write (")")
			If depth=0 then Response.Write ("</pre>") end if
		end if
	end sub
	
	Function Base64Decode(ByVal base64String)
  'rfc1521
  '1999 Antonin Foller, Motobit Software, http://Motobit.cz
  Const Base64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
  Dim dataLength, sOut, groupBegin
  
  'remove white spaces, If any
  base64String = Replace(base64String, vbCrLf, "")
  base64String = Replace(base64String, vbTab, "")
  base64String = Replace(base64String, " ", "")
  
  'The source must consists from groups with Len of 4 chars
  dataLength = Len(base64String)
  If dataLength Mod 4 <> 0 Then
    Err.Raise 1, "Base64Decode", "Bad Base64 string."
    Exit Function
  End If

  
  ' Now decode each group:
  For groupBegin = 1 To dataLength Step 4
    Dim numDataBytes, CharCounter, thisChar, thisData, nGroup, pOut
    ' Each data group encodes up To 3 actual bytes.
    numDataBytes = 3
    nGroup = 0

    For CharCounter = 0 To 3
      ' Convert each character into 6 bits of data, And add it To
      ' an integer For temporary storage.  If a character is a '=', there
      ' is one fewer data byte.  (There can only be a maximum of 2 '=' In
      ' the whole string.)

      thisChar = Mid(base64String, groupBegin + CharCounter, 1)

      If thisChar = "=" Then
        numDataBytes = numDataBytes - 1
        thisData = 0
      Else
        thisData = InStr(1, Base64, thisChar, vbBinaryCompare) - 1
      End If
      If thisData = -1 Then
        Err.Raise 2, "Base64Decode", "Bad character In Base64 string."
        Exit Function
      End If

      nGroup = 64 * nGroup + thisData
    Next
    
    'Hex splits the long To 6 groups with 4 bits
    nGroup = Hex(nGroup)
    
    'Add leading zeros
    nGroup = String(6 - Len(nGroup), "0") & nGroup
    
    'Convert the 3 byte hex integer (6 chars) To 3 characters
    pOut = Chr(CByte("&H" & Mid(nGroup, 1, 2))) + _
      Chr(CByte("&H" & Mid(nGroup, 3, 2))) + _
      Chr(CByte("&H" & Mid(nGroup, 5, 2)))
    
    'add numDataBytes characters To out string
    sOut = sOut & Left(pOut, numDataBytes)
  Next

  Base64Decode = sOut
End Function
%>