<!-- #include file = "../biblioteca/fpdf.asp" -->
<%
Set pdf=CreateJsObject("FPDF")
pdf.CreatePDF()
pdf.SetPath("../biblioteca/fpdf/")
pdf.SetFont "Arial","",16
pdf.Open()
pdf.AddPage()
pdf.Cell 5,10,"Hola Mundo!"
pdf.Cell 60,20,"FDPF for Asp",0,1,"C"
pdf.Close()
pdf.Output()
%>
