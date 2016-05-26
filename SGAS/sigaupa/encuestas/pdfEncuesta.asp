<!-- #include file = "../biblioteca/fpdf.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
set errores = new cErrores
'--------------------------------------------------por get
Dim arrpreg()
Dim preg1_profesor()
Dim preg1_carrera()
Dim preg1_facultad()
Dim preg1_universidad()

'Dim arr_secc_ccod()
dcur_ncorr 	= request.querystring("dcur_ncorr")
anos_ccod	= request.querystring("anos_ccod")
sedes		= request.querystring("sedes")
carreras	= request.querystring("carreras")
jornadas	= request.querystring("jornadas")
carr_ccod   =   request.QueryString("carr_ccod")
jorn_ccod	=	request.querystring("jorn_ccod")
sede_ccod	=	request.querystring("sede_ccod")
secc_ccod	=	request.querystring("secc_ccod")
pers_ncorr_profesor	=	request.querystring("pers_ncorr")
cad_secc_ccod	=	request.querystring("cad_secc_ccod")
peri_ccod	=	request.querystring("peri_ccod")
carr_ccod	=	request.querystring("carr_ccod")
'--------------------------------------------------por get
'convierto la cadena de secc_ccod en arreglo
arr_secc_ccod = Split(cad_secc_ccod,"-")


'secc_ccod = 55302
'pers_ncorr_profesor = 110439
'peri_ccod = 212
'carr_ccod = 820
'For i = 1 To Request.QueryString("sc").Count
'Response.Write(Request.QueryString("sc")(i))
'Next

'response.Write("secc_ccod: "&secc_ccod&" pers_ncorr: "&pers_ncorr)
'response.End()

set f_portada = new CFormulario
f_portada.Carga_Parametros "tabla_vacia.xml", "tabla"
f_portada.Inicializar conexion

facu_ccod = conexion.consultaUno("select b.facu_ccod from carreras a, areas_academicas b where a.area_ccod=b.area_ccod and a.carr_ccod='"&carr_ccod&"'")
'*********************'
'* creación del pdf  *'
'*********************'   
Set pdf=CreateJsObject("FPDF")
pdf.CreatePDF "l","mm","Letter"
pdf.SetPath("../biblioteca/fpdf/" )
'pdf.LoadModels("PieFecha") 
'pdf.SetAutoPageBreak TRUE,20
pdf.SetFont "Arial","B",12
pdf.Open()
pdf.AddPage()

'*********************'  Datos Generales

set datos_generales= new cformulario
datos_generales.carga_parametros "tabla_vacia.xml","tabla"
datos_generales.inicializar conexion
Query_datos_generales = " Select protic.initcap(carr_tdesc) as carrera, ltrim(rtrim(b.asig_ccod))+' ' + protic.initCap(b.asig_tdesc) as asignatura,  "& vbCrLf &_ 
                        " secc_tdesc as seccion,a.peri_ccod,a.carr_ccod, f.pers_tnombre + ' ' + f.pers_tape_paterno + ' ' + f.pers_tape_materno as profesor,  "& vbCrLf &_ 
						" f.pers_nrut,a.sede_ccod,jorn_ccod, f.pers_xdv,(select count(*) from cuestionario_opinion_alumnos bb where bb.secc_ccod=a.secc_Ccod and bb.pers_ncorr_profesor=f.pers_ncorr and isnull(estado_cuestionario,0) = 2) as cantidad_encuestas  "& vbCrLf &_ 
						" from secciones a, asignaturas b, carreras c, bloques_horarios d, bloques_profesores e, personas f  "& vbCrLf &_ 
						" where a.asig_ccod=b.asig_ccod and a.carr_ccod=c.carr_ccod  "& vbCrLf &_ 
						" and a.secc_ccod=d.secc_ccod and d.bloq_ccod=e.bloq_ccod and e.pers_ncorr=f.pers_ncorr and cast(f.pers_ncorr as varchar)='"&pers_ncorr_profesor&"' "& vbCrLf &_ 
						" and cast(a.secc_ccod as varchar)='"&cad_secc_ccod&"'"
'response.Write("<pre>"&Query_datos_generales&"</pre>")
'response.End()
datos_generales.consultar Query_datos_generales
datos_generales.siguiente
'------------------buscamos que datos vamos mostrar en el encabezado de la encuesta
carrera    = datos_generales.obtenerValor("carrera")
asignatura = datos_generales.obtenerValor("asignatura")
seccion    = datos_generales.obtenerValor("seccion")
carr_ccod  = datos_generales.obtenerValor("carr_ccod")
peri_ccod  = datos_generales.obtenerValor("peri_ccod")
profesor   = datos_generales.obtenerValor("profesor")
cantidad_encuestas = datos_generales.obtenerValor("cantidad_encuestas")
pers_nrut = datos_generales.obtenerValor("pers_nrut")
pers_xdv  = datos_generales.obtenerValor("pers_xdv")
sede  = datos_generales.obtenerValor("sede_ccod")
jorn  = datos_generales.obtenerValor("jorn_ccod")

'---------------------------------------------Titulo
pdf.SetY(15)
pdf.SetFont "Arial","BU",14
pdf.MultiCell 255,12,"CUESTIONARIO DE OPINIÓN DE ALUMNOS" ,"0","C",""
'---------------------------------------------Titulo
'************************************'
'* imprime la cabecera de la tablas  *'
'************************************'
function datosGenerales()
	
	pdf.SetFont "Arial","B",10
	pdf.Ln()
	pdf.Cell 127,8,"Carrera: "& carrera,"","0","L"
	pdf.Cell 128,8,"Sección: "& seccion,"","1","L"
	pdf.Cell 127,8,"Asignatura: "& asignatura,"","0","L"
	pdf.Cell 128,8,"Cantidad Encuestas: "& cantidad_encuestas,"","1","L"
	pdf.Cell 255,8,"Profesor: "& profesor,"","1","L"
	pdf.Cell 255,8,"","","0","L"
	pdf.Ln()
end function
function cabeceraAsignatura(seccion)
'asignatura = "desarrollo"
asignatura = conexion.consultaUno("select ASIG_TDESC from ASIGNATURAS where ASIG_CCOD=(select asig_ccod from SECCIONES where SECC_CCOD='"&seccion&"')")

	pdf.SetFont "Arial","B",10
	pdf.Ln()
	pdf.Cell 255,8,asignatura,"LTR","1","L"
end function

function cabeceraDimension(num,titulo)

	pdf.SetFont "Arial","B",10
	pdf.Cell 255,8,"Dimension "&num& ": " &titulo,"","1","C"

end function

function cabeceraTabla()
	pdf.SetFont "Arial","B",10
	pdf.Cell 10,8,"N°","LTR","0","C"
	pdf.Cell 205,8,"Pregunta","LTR","0","L"
	pdf.Cell 10,8,"Prof","LTR","0","L"
	pdf.Cell 10,8,"Carr","LTR","0","L"
	pdf.Cell 10,8,"Facu","LTR","0","L"
	pdf.Cell 10,8,"Univ","LTR","1","L"
	'--------------------------
end function
'*********************'
'* inserta filas  *'
'*********************'
'response.Write("profe"&pers_ncorr_profesor)
'response.End()

function dimension1(seccion,persona,carrera,periodo,facultad)
i = 0
j = 1
Redim arrpreg(8)
Redim preserve preg1_profesor(8) 
Redim preserve preg1_carrera(8) 
Redim preserve preg1_facultad(8) 
Redim preserve preg1_universidad(8) 
arrpreg(0) = "¿El/la docente explicó clara y oportunamente los objetivos, metodología y bibliografía a utilizar, al inicio del curso?"
arrpreg(1) = "¿Qué tan significativas para mi aprendizaje fueron las actividades desarrolladas por el/la docente en clases?"
arrpreg(2) = "Las clases desarrolladas por el/la docente ¿me dieron la posibilidad de pensar, observar, investigar, practicar y sacar mis propias conclusiones?"
arrpreg(3) = "¿De qué manera el/la docente respondió las consultas que realizamos en clases?"
arrpreg(4) = "¿Con qué frecuencia el/la docente relacionó los contenidos tratados con nuestro futuro desempeño profesional?"
arrpreg(5) = "La forma de organizar los contenidos del curso por el/la docente ¿fue favorable a mi aprendizaje?"
arrpreg(6) = "Las actividades desarrolladas por el/la docente ¿fueron coherentes con los objetivos de aprendizaje de la asignatura?"
arrpreg(7) = "Las actividades desarrolladas ¿facilitan la innovación y creatividad en el hacer disciplinario?"
arrpreg(8) = "Me parece que las expectativas del/la docente sobre nuestros aprendizajes son."

	for Each item in arrpreg
	
preg1_profesor(i) = conexion.consultaUno("select cast(avg(parte_2_"&j&") as decimal(4,3)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_"&j&",0) <> 0")
preg1_carrera(i) = conexion.consultaUno("select cast(avg(parte_2_"&j&") as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_"&j&",0) <> 0")
preg1_facultad(i) = conexion.consultaUno("select cast(avg(parte_2_"&j&") as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_"&j&",0) <> 0")
preg1_universidad(i) = conexion.consultaUno("select cast(avg(parte_2_"&j&") as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_2_"&j&",0) <> 0")


		pdf.SetFont "Arial","B",6
		pdf.Cell 10,8,"" &i+1& "","LTR","0","C"
		pdf.Cell 205,8,"" &item& "","LTR","0","L"
		pdf.Cell 10,8,""&preg1_profesor(i)&"","LTR","0","C"
		pdf.Cell 10,8,""&preg1_carrera(i)&"","LTR","0","C"
		pdf.Cell 10,8,""&preg1_facultad(i)&"","LTR","0","C"
		pdf.Cell 10,8,""&preg1_universidad(i)&"","LTR","1","C"
		'pdf.Cell 255,8,"","","0","L"
		'--------------------------
			
		i = i+1
		j = j+1
	next
	pdf.Cell 255,0,"","LTR","1","L"
	if num mod 12 = 0 and max <> num then		
		pdf.AddPage()
		pdf.SetY(20)
		cabeceraTabla()
	end if	
end function

function dimension2(seccion,persona,carrera,periodo,facultad)
i = 0
j = 1
Redim arrpreg(3)
Redim preserve preg1_profesor(3) 
Redim preserve preg1_carrera(3) 
Redim preserve preg1_facultad(3) 
Redim preserve preg1_universidad(3) 

arrpreg(0) = "El/la docente ¿comunicó claramente los criterios de evaluación y calificación con los que seremos evaluados?"
arrpreg(1) = "Los procedimientos de evaluación utilizados por el/la docente ¿fueron coherentes con los contenidos tratados y las actividades desarrolladas durante el curso?"
arrpreg(2) = "Las instrucciones e indicaciones de los instrumentos de evaluación aplicados por el/la docente ¿han sido claras y precisas para su desarrollo?"
arrpreg(3) = "El análisis y comentarios de los resultados de las evaluaciones ¿fueron entregados en un tiempo oportuno, me ayudaron a ver mis errores y así mejorar mis aprendizajes?"


	for Each item in arrpreg

preg1_profesor(i) = conexion.consultaUno("select cast(avg(parte_3_"&j&") as decimal(4,3)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_3_"&j&",0) <> 0")
preg1_carrera(i) = conexion.consultaUno("select cast(avg(parte_3_"&j&") as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_3_"&j&",0) <> 0")
preg1_facultad(i) = conexion.consultaUno("select cast(avg(parte_3_"&j&") as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_3_"&j&",0) <> 0")
preg1_universidad(i) = conexion.consultaUno("select cast(avg(parte_3_"&j&") as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_3_"&j&",0) <> 0")

'response.Write(preg1_profesor(i)&"<br>")
'response.Write(preg1_carrera(i)&"<br>")
'response.Write(preg1_facultad(i)&"<br>")
'response.Write(preg1_universidad(i)&"<br>")

		pdf.SetFont "Arial","B",6
		pdf.Cell 10,8,"" &i+1& "","LTR","0","C"
		pdf.Cell 205,8,"" &item& "","LTR","0","L"
		pdf.Cell 10,8,""&preg1_profesor(i)&"","LTR","0","C"
		pdf.Cell 10,8,""&preg1_carrera(i)&"","LTR","0","C"
		pdf.Cell 10,8,""&preg1_facultad(i)&"","LTR","0","C"
		pdf.Cell 10,8,""&preg1_universidad(i)&"","LTR","1","C"
		'pdf.Cell 255,8,"","","0","L"
		'--------------------------
		i = i+1
		j = j+1
	next
	pdf.Cell 255,0,"","LTR","1","L"
	if num mod 12 = 0 and max <> num then		
		pdf.AddPage()
		pdf.SetY(20)
		cabeceraTabla()
	end if	
end function

function dimension3(seccion,persona,carrera,periodo,facultad)
i = 0
j = 1
Redim arrpreg(3)
Redim preserve preg1_profesor(3) 
Redim preserve preg1_carrera(3) 
Redim preserve preg1_facultad(3) 
Redim preserve preg1_universidad(3) 

arrpreg(0) = "El/la docente ¿crea un ambiente de confianza que incentiva la participación en el aula?"
arrpreg(1) = "El/la docente ¿establece una interacción (diálogo) con los estudiantes que facilita mi aprendizaje?"
arrpreg(2) = "El/la docente ¿considera y atiende los puntos de vista de los estudiantes, aunque sean distintos a los suyos?"
arrpreg(3) = "El/la docente ¿estimuló mi interés por aprender más de mi disciplina?"

	for Each item in arrpreg

preg1_profesor(i) = conexion.consultaUno("select cast(avg(parte_4_"&j&") as decimal(4,3)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_4_"&j&",0) <> 0")
preg1_carrera(i) = conexion.consultaUno("select cast(avg(parte_4_"&j&") as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_4_"&j&",0) <> 0")
preg1_facultad(i) = conexion.consultaUno("select cast(avg(parte_4_"&j&") as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_4_"&j&",0) <> 0")
preg1_universidad(i) = conexion.consultaUno("select cast(avg(parte_4_"&j&") as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_4_"&j&",0) <> 0")

		pdf.SetFont "Arial","B",6
		pdf.Cell 10,8,"" &i+1& "","LTR","0","C"
		pdf.Cell 205,8,"" &item& "","LTR","0","L"
		pdf.Cell 10,8,""&preg1_profesor(i)&"","LTR","0","C"
		pdf.Cell 10,8,""&preg1_carrera(i)&"","LTR","0","C"
		pdf.Cell 10,8,""&preg1_facultad(i)&"","LTR","0","C"
		pdf.Cell 10,8,""&preg1_universidad(i)&"","LTR","1","C"
		'pdf.Cell 255,8,"","","0","L"
		'--------------------------
		
		i = i+1
		j = j+1
	next
	pdf.Cell 255,0,"","LTR","1","L"
	if num mod 12 = 0 and max <> num then		
		pdf.AddPage()
		pdf.SetY(20)
		cabeceraTabla()
	end if	
end function

function dimension4(seccion,persona,carrera,periodo,facultad)
i = 0
j = 1
Redim arrpreg(4)
Redim preserve preg1_profesor(4) 
Redim preserve preg1_carrera(4) 
Redim preserve preg1_facultad(4) 
Redim preserve preg1_universidad(4) 

arrpreg(0) = "El/la docente ¿asistió a realizar sus clases?"
arrpreg(1) = "Si el/la docente no realizó alguna clase ¿se preocupó de que los estudiantes fuéramos comunicados con anterioridad?"
arrpreg(2) = "El/la docente ¿fue puntual al comenzar y al finalizar las sesiones de clases?"
arrpreg(3) = "El/la docente ¿nos comunicó oportunamente fechas importantes como horarios de inicio y término de clases, y salas o espacios físicos a utilizar?"
arrpreg(4) = "El/la docente ¿cumple con los plazos acordados para la entrega de trabajos y pruebas?"



	for Each item in arrpreg

preg1_profesor(i) = conexion.consultaUno("select cast(avg(parte_5_"&j&") as decimal(4,3)) from cuestionario_opinion_alumnos bb where cast(bb.secc_ccod as varchar)='"&secc_ccod&"' and cast(bb.pers_ncorr_profesor as varchar)= '"&pers_ncorr_profesor&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_5_"&j&",0) <> 0")
preg1_carrera(i) = conexion.consultaUno("select cast(avg(parte_5_"&j&") as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.carr_ccod as varchar)='"&carr_ccod&"' and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_5_"&j&",0) <> 0")
preg1_facultad(i) = conexion.consultaUno("select cast(avg(parte_5_"&j&") as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and aa.carr_ccod in (select carr_ccod from carreras aa, areas_academicas ba where aa.area_ccod=ba.area_ccod and cast(ba.facu_ccod as varchar)='"&facu_ccod&"') and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_5_"&j&",0) <> 0")
preg1_universidad(i) = conexion.consultaUno("select cast(avg(parte_5_"&j&") as decimal(4,3)) from secciones aa, cuestionario_opinion_alumnos bb where aa.secc_ccod=bb.secc_ccod and cast(aa.peri_ccod as varchar)= '"&peri_ccod&"' and isnull(estado_cuestionario,0) = 2 and isnull(parte_5_"&j&",0) <> 0")

		pdf.SetFont "Arial","B",6
		pdf.Cell 10,8,"" &i+1& "","LTR","0","C"
		pdf.Cell 205,8,"" &item& "","LTR","0","L"
		pdf.Cell 10,8,""&preg1_profesor(i)&"","LTR","0","C"
		pdf.Cell 10,8,""&preg1_carrera(i)&"","LTR","0","C"
		pdf.Cell 10,8,""&preg1_facultad(i)&"","LTR","0","C"
		pdf.Cell 10,8,""&preg1_universidad(i)&"","LTR","1","C"
		'--------------------------
		i = i+1
		j = j+1
	next
		
		'pdf.Cell 15,8,"","LTR","0","L"
		'pdf.Cell 190,8,"","LTR","0","L"
		'pdf.Cell 20,8,"","LTR","0","L"
		'pdf.Cell 10,8,"","LTR","0","L"
		'pdf.Cell 10,8,"","LTR","0","L"
		'pdf.Cell 10,8,"","LTR","0","L"
		pdf.Cell 255,0,"","LTR","1","L"
		
	if num mod 12 = 0 and max <> num then		
		pdf.AddPage()
		pdf.SetY(20)
		cabeceraTabla()
	end if	
end function
'*********************'
'***************************************************************************************************************************************************************
for each item2 in arr_secc_ccod
	'redim preserve arr_secc_ccod2(i)
	'response.Write(item&"-")
'cabeceraAsignatura item2
datosGenerales
cabeceraDimension 1,"Enseñanza para el aprendizaje"
cabeceraTabla() ' se inserta la cabecera
dimension1 item2,pers_ncorr_profesor,carr_ccod,peri_ccod,facu_ccod

cabeceraDimension 2,"Evaluación para el aprendizaje"
cabeceraTabla() ' se inserta la cabecera
dimension2 item2,pers_ncorr_profesor,carr_ccod,peri_ccod,facu_ccod
'response.End()
cabeceraDimension 3,"Ambiente para el Aprendizaje"
cabeceraTabla() ' se inserta la cabecera
dimension3 item2,pers_ncorr_profesor,carr_ccod,peri_ccod,facu_ccod

cabeceraDimension 4,"Responsabilidad Formal"
cabeceraTabla() ' se inserta la cabecera
dimension4 item2,pers_ncorr_profesor,carr_ccod,peri_ccod,facu_ccod

next
'************************************************************************'
'*				CONSULTA QUE LLENA LOS DATOS DE ANTECEDENTES			*'
'************************************************************************'
'consulta = "" & vbCrLf & _
'"select cast(c.pers_nrut as varchar) + '-'                        " & vbCrLf & _
'"       + c.pers_xdv                        as rut,               " & vbCrLf & _
'"       protic.initcap(c.pers_tape_paterno) as pers_tape_paterno, " & vbCrLf & _
'"       protic.initcap(c.pers_tape_materno) as pers_tape_materno, " & vbCrLf & _
'"       protic.initcap(c.pers_tnombre)      as pers_tnombre       " & vbCrLf & _
'"from   personas as c                                             " & vbCrLf & _
'"       inner join postulacion_otec as b                          " & vbCrLf & _
'"               on c.pers_ncorr = b.pers_ncorr                    " & vbCrLf & _
'"                  and epot_ccod = 4                              " & vbCrLf & _
'"       inner join datos_generales_secciones_otec as d            " & vbCrLf & _
'"               on b.dgso_ncorr = d.dgso_ncorr                    " & vbCrLf & _
'"where  cast(d.dcur_ncorr as varchar) = '"&dcur_ncorr&"'          " & vbCrLf & _
'"order  by pers_tape_paterno                                      " 
'************************************************************************'

'---------------------------------------------
			
'response.Write("<pre>"&consulta & "</pre>")
'response.end()	

'response.Write("<pre>"&consulta & " ORDER BY asig_tdesc, secc_tdesc </pre>")		
'response.End()		

'********************************************'
'* CAPTURA DE VARIABLES	PARA SER INSERTADAS *'
'****************************************************'
'--------------------------------------------------------------------------------

'****************************************************'
pdf.Close()
pdf.Output()
%>
