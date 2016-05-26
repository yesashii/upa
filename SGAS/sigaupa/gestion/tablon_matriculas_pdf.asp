<%@language=vbscript%>
<!--#include file = "../biblioteca/fpdf.asp" -->
<%

'for each k in request.form
'	response.Write(k&" = "&request.form(k)&"<br>")
'next
Set pdf=CreateJsObject("FPDF")
pdf.CreatePDF()
pdf.SetPath("../biblioteca/fpdf/" )
pdf.SetFont "times","",12
pdf.Open()
pdf.AddPage()
pdf.Image "../imagenes/logo_upacifico.jpg", 12, 18, 50, 25, "JPG"
pdf.ln(90)
pdf.SetFont "times","B",24
pdf.Cell 180,1,"Resumen matrículas por Sedes y Campus","","","C" 
fecha_impresion = Now()
fecha_anterior = request.Form("fecha_anterior")
fecha_actual = request.Form("fecha_actual")
pdf.ln(8)
pdf.ln(20)
		pdf.SetFont "times","",12
		pdf.SetX(130)
		pdf.Cell 180,0,"Fecha Actual","","","L"
		pdf.SetX(150)
		pdf.Cell 180,0,"","","","L"
		pdf.SetX(160)
		pdf.Cell 180,0,":"&fecha_actual,"","","L"
		pdf.ln(5)
		pdf.SetFont "times","",12
		pdf.SetX(130)
		pdf.Cell 180,0,"Comparada al","","","L"
		pdf.SetX(150)
		pdf.Cell 180,0,"","","","L"
		pdf.SetX(160)
		pdf.Cell 180,0,":"&fecha_anterior,"","","L"
dim contador_sedes
For contador_sedes = 0 To cint(request.Form("total_sedes")) Step 1
	nombre_sede = request.Form("sede_paso["&contador_sedes&"]")
	total_sede = request.Form("total_carrera["&contador_sedes&"]")
	pdf.AddPage()
	pdf.Image "../imagenes/logo_upacifico.jpg", 12, 18, 50, 25, "JPG"
	pdf.ln(50)
	pdf.SetFont "times","B",18
	pdf.Cell 180,1,"Resumen matrículas "&nombre_sede,"","","C" 
 '
  	pdf.ln(10)
	pdf.SetFont "times","B",10
	pdf.SetFillColor(200)
	pdf.SetX(15)
	pdf.Cell 175,4,"","","","L",true
	pdf.SetX(115)
	pdf.Cell 75,4,"","","","L",true
	pdf.SetX(135)
	pdf.Cell 55,4,"Matrícula","","","L",true
	pdf.SetX(155)
	pdf.Cell 35,4,"Matrícula","","","L",true
	pdf.SetX(175)
	pdf.Cell 20,4,"","","","L",true
	pdf.ln(4)
	pdf.SetFont "times","B",10
	pdf.SetX(15)
	pdf.Cell 175,3,"Carrera","","","L",true
	pdf.SetX(115)
	pdf.Cell 75,3,"Meta","","","L",true
	pdf.SetX(135)
	pdf.Cell 55,3,"Actual","","","L",true
	pdf.SetX(155)
	pdf.Cell 35,3,"Anterior","","","L",true
	pdf.SetX(175)
	pdf.Cell 20,3,"Desviación","","","L",true
	total_vacantes = 0
	total_actuales = 0
	total_antiguos = 0
  	For contador_carreras = 0 To total_sede - 1 Step 1
	      cadena = split(request.Form("carrera["&contador_sedes&"]["&contador_carreras&"]"),"*")
		  nombre_carrera = cadena(0)
		  nombre_jornada = cadena(1)
		  vacantes = cadena(2)
		  actuales = cadena(3)
		  antiguos = cadena(4)
		  total_vacantes = total_vacantes + cint(vacantes)
  		  total_actuales = total_actuales + cint(actuales)
		  total_antiguos = total_antiguos + cint(antiguos)
		  pdf.ln(5)
		  pdf.SetFont "times","",8
		  pdf.SetTextColor 186,186,186
		  pdf.SetX(10)
		  pdf.Cell 5,0,"","","","L",false
		  pdf.SetTextColor 0,0,0
		  pdf.SetX(15)
		  pdf.Cell 175,0,nombre_carrera&" ("&nombre_jornada&")","","","L",false
		  pdf.SetFont "times","",10
		  pdf.SetX(118)
		  pdf.Cell 75,0,vacantes,"","","L",false
		  pdf.SetX(138)
		  pdf.Cell 55,0,actuales,"","","L",false
		  pdf.SetX(158)
		  pdf.Cell 35,0,antiguos,"","","L",false
		  pdf.SetFont "times","B",9
		  if (actuales - antiguos) >= 0 then
		  	pdf.SetTextColor 7,129,7
		  else
		  	pdf.SetTextColor 223,21,25
		  end if
		  pdf.SetX(178)
		  pdf.Cell 20,0,(actuales - antiguos),"","","L",false
	Next
	pdf.Line 115, pdf.getY()+3, 185, pdf.getY()+3
    pdf.ln(5)
	pdf.SetFont "times","",8
	pdf.SetTextColor 186,186,186
	pdf.SetX(10)
	pdf.Cell 5,0,"","","","L",false
	pdf.SetTextColor 0,0,0
	pdf.SetX(15)
	pdf.Cell 175,0,"","","","L",false
	pdf.SetFont "times","B",12
	pdf.SetX(118)
	pdf.Cell 75,0,total_vacantes,"","","L",false
	pdf.SetX(138)
	pdf.Cell 55,0,total_actuales,"","","L",false
	pdf.SetX(158)
	pdf.Cell 35,0,total_antiguos,"","","L",false
	pdf.SetX(178)
	pdf.Cell 20,0,(total_actuales - total_antiguos),"","","L",false
	'pdf.Image "http://admision.upacifico.cl/graficos/graphbarras.php?dat="&total_vacantes&","&total_actuales&","&total_antiguos&"&bkg=FFFFFF&ttl=Matrículas", 12, pdf.getY()+3, 0, 0, "JPG"
	pdf.ln(1)
	pdf.SetY(-40)
	pdf.SetFont "times","",12
	pdf.Cell 180,0,"Santiago, "&fecha_actual&".","","","L" 
Next

pdf.Close()
pdf.Output()
%> 
