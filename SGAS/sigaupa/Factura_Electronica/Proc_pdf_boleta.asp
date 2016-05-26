<!-- #include file = "funciones.asp" -->
<%
	Class Controlador_pdf_boleta
		
		private tipo
		private rut
		private folio
		private monto
		private fecha
		private isConstructed
		private xmlResponse
		
		private sub Class_Initialize
			Dim xmlResponse
			construct()
		end sub
		
		public default function construct()
			set construct = me
			isConstructed = true
		end function
		
		public sub SetRegistro (srut, sfolio, stipo, smonto, sfecha)
			if (not isConstructed) then
				call err.raise(60000, "ObjectNotConstructedException", "ok is not constructed")
			end if
			rut = srut
			folio = sfolio
			tipo = stipo
			monto = smonto
			fecha = sfecha
		end sub
		
		public function generadorxml(cedible)
			if (not isConstructed) then
				call err.raise(60000, "ObjectNotConstructedException", "Person is not constructed")
			end if
		
			xmlgenerado = "<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:dbn='DBNET'>"&vbCrLf&_
				vbTAB&"<soapenv:Header/>"&vbCrLf&_
				vbTAB&"<soapenv:Body>"&vbCrLf&_
				vbTAB&vbTAB&"<dbn:get_pdf>"&vbCrLf&_
         		vbTAB&vbTAB&vbTAB&"<dbn:rutt>71704700</dbn:rutt>"&vbCrLf&_
         		vbTAB&vbTAB&vbTAB&"<dbn:folio>"&folio&"</dbn:folio>"&vbCrLf&_
         		vbTAB&vbTAB&vbTAB&"<dbn:doc>"&tipo&"</dbn:doc>"&vbCrLf&_
         		vbTAB&vbTAB&vbTAB&"<dbn:monto>"&monto&"</dbn:monto>"&vbCrLf&_
         		vbTAB&vbTAB&vbTAB&"<dbn:fecha>"&fecha&"</dbn:fecha>"&vbCrLf&_
         		vbTAB&vbTAB&vbTAB&"<dbn:ruttt>"&rut&"</dbn:ruttt>"&vbCrLf&_
				vbTAB&vbTAB&"</dbn:get_pdf>"&vbCrLf&_
				vbTAB&"</soapenv:Body>"&vbCrLf&_
				"</soapenv:Envelope>"
			'response.write xmlgenerado
			generadorxml = xmlgenerado
		end function
		
		public sub enviar(xml)
			'response.write xml
			'response.end
			strSOAPAction = "DBNET/get_pdf"
			
			'Ahora sí estamos listos para llamar a la función InvokeWebService(). Conociendo la estructura del XML de respuesta (SOAP Response), obtenemos el resultado de la ejecución:
			'Dimensionamos la variable donde obtendremos la respuesta del WebService 
			
			Dim xmlResponse
			'response.write xmlResponse &"<-1"
			'response.end
			'Realizamos la llamada a la función InvokeWebService(), brindándole los parámetros correspondientes
			
			If InvokeWebService(xml, strSOAPAction, "http://172.16.254.15/wssConsultaBoletaASP/Service.asmx", xmlResponse) Then
				
				'Si el WebService se ejecutó con éxito, obtenemos la respuesta y la imprimimos utilizando MSXML.DOMDocument
				nombre_pdf = xmlResponse.documentElement.selectSingleNode("soap:Body/get_pdfResponse/get_pdfResult/string").text
				base64_pdf = Replace(xmlResponse.documentElement.selectSingleNode("soap:Body/get_pdfResponse/get_pdfResult").text,nombre_pdf,"")
				
				'Response.Write ("Resultado:" )
				'Response.Write ("<br>Nombre: "&nombre_pdf)
				'Response.Write ("<br>Base: "&base64_pdf)
				'response.End()
			End If
			if base64_pdf = "Datos no asociado a documento." then
				response.write "Error al consultar boleta, favor ingresar los datos correctos."
				response.redirect "../Factura_Electronica/fallo.html"
				response.end
			end if
			base64String =base64_pdf
			Set tmpDoc = Server.CreateObject("MSXML2.DomDocument")
			Set nodeB64 = tmpDoc.CreateElement("b64")
			nodeB64.DataType = "bin.base64" ' stores binary as base64 string
			nodeB64.Text = Mid(base64String, InStr(base64String, ",") + 1) ' append data text (all data after the comma)
			'code64 = Base64Decode(base64_pdf)
			'response.BinaryWrite(code64)
			'response.End()
			Set xmlResponse = Nothing
			
			With Response
				.Clear
				.ContentType = "application / pdf"
				.AddHeader "Content-Disposition", "attachment; filename=" & nombre_pdf
				.BinaryWrite nodeB64.NodeTypedValue 'get bytes and write
				.end
			End With
			'Liberamos la memoria del objeto xmlResponse 
			
		end sub
	end class
%>
