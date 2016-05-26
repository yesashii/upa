<%@language=vbscript%>
<!-- #include file = "../biblioteca/fpdf.asp" -->
<%


 espacio="                                       "
 espacio2="    "
 linea="_____________________________________________________________________________"
Set pdf=CreateJsObject("FPDF")
pdf.CreatePDF()
pdf.SetPath("../biblioteca/fpdf/" )
pdf.SetFont "times","",12
pdf.Open()
pdf.AddPage()

pdf.ln(1)
pdf.Close()
pdf.Output()
%> 
