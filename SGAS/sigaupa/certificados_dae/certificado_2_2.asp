<%@language=vbscript%>
<!-- #include file = "../biblioteca/fpdf.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "genera_clave.asp" -->
<%
origen=request.QueryString("origen")
q_origen = Request.QueryString("origen")
if(q_origen="1") then
	q_rut = Request.QueryString("rut")
	q_peri = Request.QueryString("peri")
	q_sede = Request.QueryString("sede")
	session("sede")=q_sede
	session("_periodo")=q_peri
	session("rut_usuario")=q_rut
end if



 espacio="                                       "
 espacio2="    "
 linea="_____________________________________________________________________________"
Set pdf=CreateJsObject("FPDF")
pdf.CreatePDF()
pdf.SetPath("../biblioteca/fpdf/" )
pdf.SetFont "times","",12
pdf.Open()
pdf.AddPage()
''lineas superiores
'pdf.Line 8, 18, 204, 18 
'pdf.Line 7, 17, 205, 17 
''lineas izquierdas
'pdf.Line 7, 17, 7, 285
'pdf.Line 8, 18, 8, 284
''lineas derechas
'pdf.Line 204, 18, 204, 284
'pdf.Line 205, 17, 205, 285
''lineas inferiores
'pdf.Line 8, 284, 204, 284 
'pdf.Line 7, 285, 205, 285

pdf.Image "../certificados_dae/imagenes/logo_upa.jpg", 14, 22, 20, 20, "JPG"
	pdf.ln(45)
pdf.SetFont "times","B",12
pdf.Cell 180,1,"CERTIFICADO DE ALUMNO","","","C"  
	pdf.ln(15)
pdf.Cell 180,1,"La Universidad del Pacífico :","","","L" 
	pdf.ln(15)
	pdf.SetFont "times","",12
pdf.Cell 180,1,"Certifica que el(la) Sr.(ita).                                    :","","","L"
	pdf.ln(15)
pdf.Cell 180,1,"R.u.t..                                                                      :","","","L"
pdf.ln(15)	
pdf.Cell 180,1,"                :","","","L"
	pdf.ln(15)
pdf.Cell 180,1,"Jornada                                                                   :","","","L"
	pdf.ln(15)
pdf.Cell 180,1,"Sede                                                                        :","","","L"
	pdf.ln(15)
pdf.MultiCell 180,5,"Se extiende el presente certificado ","","","L"
pdf.Image "../certificados_dae/imagenes/firma2.jpg", 117, 175, 80, 30, "JPG"
pdf.ln(40)
pdf.SetFont "times","B",12
pdf.Cell 180,1,"MARIA TERESA MERINO GAME","","","R"
	pdf.ln(5)
pdf.Cell 180,1,"JEFE REGISTRO CURRICULAR","","","R"
	pdf.ln(10)
pdf.SetFont "times","B",10
pdf.Cell 180,1,"Código de Validación :","","","C"
	pdf.ln(05)
	pdf.SetFont "times","",10
pdf.Cell 180,1,"Para validar este certificado diríjase a la página de la Universidad:","","","C"
	pdf.ln(05)
	pdf.SetFont "times","B",10
pdf.Cell 180,1,"http://www.upacifico.cl/validacion_certificados/valida.htm","","","C"
	pdf.ln(05)
		pdf.SetFont "times","",10
pdf.Cell 180,1,"Ingrese Rut del alumno y código de validación","","","C"
	pdf.ln(05)
pdf.Cell 180,1,"(el certificado es Válido sólo si el mostrado en pantalla de validación es idéntico al que se encuentra en su poder).","","","C"
	pdf.ln(05)
pdf.Cell 180,1,"Este certificado es válido hasta el .","","","C"
	pdf.ln(05)
pdf.Cell 195,1,"Santiago: Sede Las Condes: Av.Las Condes 11.121 - Campus Lyon: Av. R. Lyon 227 - Campus Baquedano: Av. Ramón Carnicer 65.","","","C"
	pdf.ln(05)
pdf.Cell 180,1,"Melipilla : Sede Melipilla : Andrés Bello 0383 - Mall Leyán, Av. Serrano 395, Local 13, Planta Baja","","","C"
	pdf.ln(05)
pdf.Cell 180,1,"Concepción: Oficina Concepción: Víctor Lamas 917, Edificio Horizonte.","","","C"
	pdf.ln(10)
pdf.Cell 180,1,".","","","C"
pdf.ln(1)
pdf.Close()
pdf.Output()
%> 
