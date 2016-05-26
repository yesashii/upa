<%@language=vbscript%>
<!-- #include file = "../biblioteca/fpdf.asp" -->
<!-- #include file = "evaluacion_2015_proc.asp" -->
<%
	
	Set encuesta_controlador = new controlador_encuesta
	DIM array(3,2)
	srut = request.QueryString("rut")
	valores = encuesta_controlador.valores(srut)
	pers_ncorr = valores(0)
	peri_ccod = request.QueryString("periodo")
	eva_auto = encuesta_controlador.promedio_autoevaluacion(pers_ncorr, peri_ccod)
	eva_alum = encuesta_controlador.promedio_alumno(pers_ncorr, peri_ccod)
	eva_dire = encuesta_controlador.promedio_director(pers_ncorr, peri_ccod)
	carreras = encuesta_controlador.obtener_asignatura(pers_ncorr, peri_ccod)
	periodo = encuesta_controlador.nombre_periodo(peri_ccod)
	'response.write periodo
	'response.end
	
	promedio_final= round((cint(eva_auto)/10*0.2)+(cint(eva_alum)/10*0.5)+(cint(eva_dire)/10*0.3),1)
	
	personas = encuesta_controlador.obtener_persona(pers_ncorr)
	nombre = personas(1)
	rut =personas(0)
	
	espaciado = 100
	if len(nombre)<espaciado then
		espacio = espaciado-len(nombre)
		for i=1 to espacio
			nombre= nombre&" "
		next
	end if
	if len(promedio_final)=1 then
		promedio_final = promedio_final&".0"
	end if
	
	array(0,0) = "DESTACADO"
	array(1,0) = "BUENO"
	array(2,0) = "SUFICIENTE"
	array(3,0) = "INSUFICIENTE"
		
	array(0,1) = "Representa un desempe�o profesional sobresaliente en las cuatro dimensiones que definen la calidad de la docencia. Se determina por una amplia \n representatividad de los criterios evaluados por cada una de las dimensiones y tambi�n por la informaci�n recogida por la evaluaci�n de los directores y la autoevaluaci�n docente."
	array(1,1) = "Representa un buen desempe�o profesional. Se determina por una representatividad de los criterios en la mayor�a de las dimensiones evaluadas. Sin embargo, se manifiestan desempe�os o dimensiones que podr�an ser mejoradas. Se considera la informaci�n recogida por loa evaluaci�n de los directivos y por la autoevaluaci�n."
	array(2,1) = "Representa un desempe�o que cumple con  los criterios b�sicos en las  dimensiones evaluadas. Se manifiestan claras deficiencias en el logro de los criterios de cada dimensi�n evaluada o de una dimensi�n espec�fica. Se considera la informaci�n recogida por loa evaluaci�n de los directivos y por la autoevaluaci�n. En este nivel de requieren planificar acciones concretas de mejora."
	array(3,1) = "Representa un desempe�o que tiene claras debilidades en la mayor�a de las dimensiones evaluadas. No se cumplen con los criterios m�nimos de cada dimensi�n, y esto afecta directamente a la calidad de la docencia. En este caso se requiere la revisi�n y mejora del desempe�o global del docente. Se considera la informaci�n recogida por loa evaluaci�n de los directivos y por la autoevaluaci�n."
	
	array(0,2) = "3.7-4.0"
	array(1,2) = "3.0-3.6"
	array(2,2) = "2.0-2.9"
	array(3,2) = "1.0-1.9"
	
	if promedio_final >=3.7 then
		nivel = array(0,0)
		glosa = array(0,1)
	else
		if promedio_final >=3 then
			nivel = array(1,0)
			glosa = array(1,1)
		else
			if promedio_final >=2 then
				nivel = array(2,0)
				glosa = array(2,1)
			else
				nivel = array(3,0)
				glosa = array(3,1)
			end if
		end if
	end if
	
	Set pdf=CreateJsObject("FPDF")
	pdf.CreatePDF "L", "mm", "A4"
	pdf.SetPath("../biblioteca/fpdf/" )
	
	pdf.Open()
	pdf.AddPage()
	pdf.SetFont "times","BU",14
	pdf.Cell 0,0,"Evaluaci�n docente periodo "&periodo,"","","C","true"
	pdf.ln(30)
	pdf.SetFont "times","",12
	'---------------- DATOS DEL PROFESOR-----------------------
	pdf.Cell 0,0,"Profesor: "&nombre&"RUT: "&rut,"","","L" 
	pdf.ln(12)
	'---------------- DATOS DE CARRERA-----------------------
	pdf.Cell 0,0,"Carreras: ","","","L"
	pdf.ln(12)
	i=1
	for each carrera IN carreras
		pdf.Cell 10,6,i,1
		pdf.Cell 250,6,carrera,1
		i=i+1
		pdf.ln()
	next
	pdf.ln(10)
	'---------------- DATOS DE EVALUACION-----------------------
	pdf.Cell 80,6,"EVALUACI�N",1, "" , "C"
	pdf.Cell 35,6,"PORCENTAJE",1, "" , "C"
	pdf.Cell 150,6,"PROMEDIO",1, "" , "C"
	pdf.ln()
	pdf.Cell 80,6,"Evaluaci�n del Director",1
	pdf.Cell 35,6,"30%",1
	pdf.Cell 150,6,eva_dire,1
	pdf.ln()
	pdf.Cell 80,6,"Evaluaci�n en el Cuestionario estudiantil",1
	pdf.Cell 35,6,"50%",1
	pdf.Cell 150,6,eva_alum,1
	pdf.ln()
	pdf.Cell 80,6,"Auto-Evaluaci�n docente",1
	pdf.Cell 35,6,"20%",1
	pdf.Cell 150,6,eva_auto,1
	pdf.ln()
	pdf.Cell 115,6,"Promedio Final (1)",1,"","R"
	pdf.Cell 150,6,promedio_final,1
	pdf.ln()
	pdf.Cell 115,6,"Nivel de Desempe�o (2)",1,"","R"
	pdf.Cell 150,6,nivel,1,1,"C"
	pdf.Cell 115,6,"",0,"","R"
	pdf.MultiCell 150,6,glosa,1
	pdf.ln(6)
	pdf.MultiCell 0,6,"(1)Promedio final: Se calcular� con la media ponderada a partir de los promedios obtenidos por el docente en cada instrumento. Cada profesor debe tener una nota final, dado a que esto se traduce en un nivel de desempe�o y eso posteriormente se utilizaa para la premiaci�n de fin de a�o",0,"","R"
	pdf.ln()
	pdf.MultiCell 0,6,"(2)Niveles de Desempe�o: Rango de la escala del 1 al 4 utilizada por la evaluaci�n",0,"","R"
	pdf.AddPage()
	for f=0 to 3
	pdf.Cell 80,16,array(f,0)&" ["&array(f,2)&"]",0,0,"C"
	pdf.MultiCell 200,6,array(f,1),0
	pdf.ln()
	next
	pdf.Close()
	pdf.Output()
%> 
