<%Option Explicit

    Dim objRequest, objXMLDoc, objXmlNode

    Dim strRet, strError, strNome

    Dim strName,CodItem,TpoCodigo,TipoDTE

    strName= "deepa"
	'Item
	CodItem = "123456"
	TpoCodigo = "INT"
	TipoDTE = "33"

    Set objRequest = Server.createobject("MSXML2.XMLHTTP")

    With objRequest

    .open "GET", "http://172.16.254.14/wssCustomerETDLoadASP/CustomerETDLoadASP.asmx/putCustomerETDLoad?CodItem="&CodItem&"&TpoCodigo="&TpoCodigo&"&TipoDTE="&TipoDTE, False

    .setRequestHeader "Content-Type", "text/xml"

    .setRequestHeader "SOAPAction", "http://172.16.254.14/wssCustomerETDLoadASP/CustomerETDLoadASP.asmx/putCustomerETDLoad"

    .send

    End With

    Set objXMLDoc = Server.createobject("MSXML2.DOMDocument")

    objXmlDoc.async = false

    Response.ContentType = "text/xml"

    Response.Write(objRequest.ResponseText)

    %>