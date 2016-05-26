<!-- #include file = "funciones.asp" -->
<%
	Class Controlador_consulta_dte
		
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
		
		public function generadorxml(folio, tipo, monto, fecha)
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
         		vbTAB&vbTAB&vbTAB&"<dbn:Merito>true</dbn:Merito>"&vbCrLf&_
				vbTAB&vbTAB&"</dbn:get_pdf>"&vbCrLf&_
				vbTAB&"</soapenv:Body>"&vbCrLf&_
				"</soapenv:Envelope>"
			generadorxml = xmlgenerado
		end function
		
		public sub enviar(xml)
			'response.write xml
			'response.end
			strSOAPAction = "DBNET/get_pdf"
			
			'Ahora sí estamos listos para llamar a la función InvokeWebService(). Conociendo la estructura del XML de respuesta (SOAP Response), obtenemos el resultado de la ejecución:
			'Dimensionamos la variable donde obtendremos la respuesta del WebService 
			base64_pdf = "NO ENCUENTRA DTE"
			Dim xmlResponse
			'response.write xmlResponse &"<-1"
			'response.end
			'Realizamos la llamada a la función InvokeWebService(), brindándole los parámetros correspondientes
			
			If InvokeWebService(xml, strSOAPAction, "http://172.16.254.15/wssCustomerETDPDF/getpdf64.asmx", xmlResponse) Then
				
				'Si el WebService se ejecutó con éxito, obtenemos la respuesta y la imprimimos utilizando MSXML.DOMDocument
				nombre_pdf = xmlResponse.documentElement.selectSingleNode("soap:Body/get_pdfResponse/get_pdfResult/string").text
				
				base64_pdf = Replace(xmlResponse.documentElement.selectSingleNode("soap:Body/get_pdfResponse/get_pdfResult").text,nombre_pdf,"")
				
				Response.Write ("Resultado:" )
				Response.Write ("<br>Nombre: "&nombre_pdf)
				Response.Write ("<br>Base: "&base64_pdf&"<br>")
			End If

			if instr(base64_pdf, "NO ENCUENTRA DTE") then
				response.redirect "http://fangorn.upacifico.cl/sigaupa/documentos_electronicos/consulta_documentos/index.asp?texto=1"
				response.end
			end if
			
			base64String =base64_pdf
			Set tmpDoc = Server.CreateObject("MSXML2.DomDocument")
			Set nodeB64 = tmpDoc.CreateElement("b64")
			nodeB64.DataType = "bin.base64" ' stores binary as base64 string
			nodeB64.Text = Mid(base64String, InStr(base64String, ",") + 1) ' append data text (all data after the comma)
			
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
