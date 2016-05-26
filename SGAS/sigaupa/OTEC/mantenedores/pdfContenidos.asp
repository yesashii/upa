<!-- #include file = "../biblioteca/fpdf.asp" -->
<%
Set pdf=CreateJsObject("FPDF")
pdf.CreatePDF "l","mm","Letter"
pdf.SetPath("../biblioteca/fpdf/" )
pdf.SetFont "Arial","B",12
pdf.Open()
pdf.AddPage()
'---------------------------------------------Titulo
pdf.SetY(20)
pdf.SetFont "Arial","BU",14
pdf.MultiCell 256,12,"CONTENIDOS DE ACTIVIDADES DE CAPACITACIÓN" ,"0","C",""
'---------------------------------------------Titulo

'---------------------------------------FILA_1
pdf.SetFont "Arial","",12
pdf.Cell 25,8,"FECHA","LTR","0","C"
pdf.Cell 75,8,"TEMAS","LTR","0","L"
pdf.Cell 75,8,"ACTIVIDADES","LTR","0","L"
pdf.Cell 40,8,"HORA","LTR","0","C"
pdf.Cell 40,8,"FIRMA","LTR","1","L"
'--------------------------------------------
pdf.Cell 25,10,"","LBR","0","C"
pdf.Cell 75,10,"","LBR","0","L"
pdf.Cell 75,10,"","LBR","0","L"
pdf.Cell 20,10,"INICIO","1","0","C"
pdf.SetFont "Arial","",11
pdf.Cell 20,10,"TÉRMINO","1","0","C"
pdf.SetFont "Arial","",12
pdf.Cell 40,10,"RELATOR (A)","LBR","1","L"
'---------------------------------------FILA_1

for i=1 to 8
'---------------------------------------FILAs
pdf.Cell 25,8,"","LTR","0","C"
pdf.Cell 75,8,"","LTR","0","L"
pdf.Cell 75,8,"","LTR","0","L"
pdf.Cell 40,8,"","LTR","0","C"
pdf.Cell 40,8,"","LTR","1","L"
'--------------------------------------------
pdf.Cell 25,8,"","LBR","0","C"
pdf.Cell 75,8,"","LBR","0","L"
pdf.Cell 75,8,"","LBR","0","L"
pdf.Cell 40,8,"","LBR","0","C"
pdf.Cell 40,8,"","LBR","1","L"
'---------------------------------------FILAs
next 
pdf.Close()
pdf.Output()



%>