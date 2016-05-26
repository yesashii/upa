<%@ Language=VBScript %>
<HTML>
<BODY>
<%

resto		= 	v_num_alumnos mod v_limite_fac

Response.Write "<p>Date = " & Date()
response.Write("<hr>"&Session.LCID&"<hr>")
'Session.LCID = 2057
%>
<!--#include file=setlcid.inc -->

<%

valor="500"
response.Write("valor : "&formatcurrency(valor))

SetLCID   'Set the Locale ID per the browser


Response.Write "<br/>Date/Time Formats"
Response.Write "<p>Date = " & Date()
Response.Write "<br>Month = " & Month(Date())
Response.Write "<br>Day = " & Day(Date())
Response.Write "<br>Year = " & Year(Date())
Response.Write "<br>Time = " & Time()

Response.Write "<p>Currency Formats"
Response.Write "<p>" & FormatCurrency(9000, 0)
Response.Write "<p>" & FormatCurrency(1.05, 2)
Response.Write "<br>" & FormatNumber(1000000,2)
Response.Write "<br>" & FormatNumber(-1000000,2)

%>
</BODY>
</HTML>