<%@language=vbscript%>
<!-- #include file = "../biblioteca/fpdf.asp" -->
<%

Set pdf=CreateJsObject("FPDF")
pdf.CreatePDF()
pdf.SetPath("../biblioteca/fpdf/" )
pdf.SetFont "Arial","",12
pdf.Open()
pdf.AddPage()
pdf.WriteText "A <A> A A A <A> A A"
pdf.Close()
pdf.Output()

      
%> 
