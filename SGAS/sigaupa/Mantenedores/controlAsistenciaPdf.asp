<!-- #include file = "../biblioteca/fpdf.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'--------------------------------------------------por get
q_secc_ccod = request.querystring("secc_ccod")
'--------------------------------------------------por get
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
set errores = new cErrores
'***********************************'
'*	INICIO DE LA CREACIÓN DEL PDF  *'
'***********************************'-----------
'----------------------------------inicio>>
Set pdf=CreateJsObject("FPDF")
'pdf.CreatePDF()' crear con valores por defecto
pdf.CreatePDF "l","mm","Letter"
pdf.SetPath("../biblioteca/fpdf/" )
pdf.SetFont "Arial","B",12
pdf.Open()
pdf.AddPage()
'----------------------------------<<inicio
function crearEspacios(var_x, var_y, alto)
	x = cint(var_x)
	y = cint(var_y)
	alto = cint(alto)
	pdf.setXY x,y	
	for i=0 to 23
		if i=23 then
			pdf.Cell 8,alto,"","1","1","C"
		else
			pdf.Cell 8,alto,"","1","0","C"
		end if
	next	
end function

function encabezado()
	'****************'
	'*	ENCABEZADO  *'
	'****************'-----------
	'*********************************************************************'
	'**				FORMULARIO QUE TRAE LOS DATOS DEL ENCABEZADO  		**'
	'*********************************************************************'-----------------
		set f_listado1 = new CFormulario
		f_listado1.Carga_Parametros "tabla_vacia.xml", "tabla" 'carga el xml
		f_listado1.Inicializar conexion 'inicializo conexion
		consulta = "" & vbCrLf & _
		"select c.asig_ccod                            as codigo,     " & vbCrLf & _
		"       a.secc_tdesc                           as seccion,    " & vbCrLf & _
		"       b.peri_tdesc                           as periodo,    " & vbCrLf & _
		"       c.asig_tdesc                           as asignatura, " & vbCrLf & _
		"       d.sede_tdesc                           as sede,       " & vbCrLf & _
		"       e.jorn_tdesc                           as jornada,    " & vbCrLf & _
		"       protic.profesores_seccion(a.secc_ccod) as profesor,   " & vbCrLf & _
		"		b.anos_ccod							   as anio		  " & vbCrLf & _	
		"from   secciones as a                                        " & vbCrLf & _
		"       inner join periodos_academicos as b                   " & vbCrLf & _
		"               on a.peri_ccod = b.peri_ccod                  " & vbCrLf & _
		"       inner join asignaturas as c                           " & vbCrLf & _
		"               on a.asig_ccod = c.asig_ccod                  " & vbCrLf & _
		"       inner join sedes as d                                 " & vbCrLf & _
		"               on a.sede_ccod = d.sede_ccod                  " & vbCrLf & _
		"       inner join jornadas as e                              " & vbCrLf & _
		"               on a.jorn_ccod = e.jorn_ccod                  " & vbCrLf & _
		"where  cast(a.secc_ccod as varchar) = '"&q_secc_ccod&"'      " 
		'----------------------------------------debug>>
		'response.Write("<pre>"&consulta&"</pre>")
		'response.End()
		'----------------------------------------<<debug
		f_listado1.Consultar consulta 
		f_listado1.siguiente
		'--------------------------------------VARIABLES
			string_nombre 			= conexion.consultaUno("select carr_tdesc from secciones a, carreras b where a.carr_ccod=b.carr_ccod and cast(a.secc_ccod as varchar)='"&q_secc_ccod&"'")
			string_sede 			= f_listado1.obtenerValor("sede")'"LAS CONDES"
			string_horario 			= f_listado1.obtenerValor("jornada")'"Diurno"
			string_periodo 			= f_listado1.obtenerValor("periodo")'"PRIMER SEMESTRE 2013"
			string_anio 			= f_listado1.obtenerValor("anio")'"2013"
			string_celda 			= string_nombre&" "&string_sede&" ("&string_horario&")"
			string_fecha 			= conexion.ConsultaUno("select protic.trunc(getdate())")
			string_hora 			= conexion.ConsultaUno("SELECT Convert(varchar(8),GetDate(), 108)")
			string_pag 				= pdf.PageNo()
			string_asignatura 		= f_listado1.obtenerValor("asignatura")'"ACONDICIONAMIENTO FÍSICO"
			string_codAsignatura 	= f_listado1.obtenerValor("codigo")'"FGODD102"
			string_seccion 			= f_listado1.obtenerValor("seccion")'"2--(D)"
			string_profesores 		= f_listado1.obtenerValor("profesor")'"RIVEROS CALSOW CRISTIAN MAURICIO(DOCENTE)"		
		'--------------------------------------VARIABLES
	'*********************************************************************'-----------------
	'**				FORMULARIO QUE TRAE LOS DATOS DEL ENCABEZADO  		**'
	'*********************************************************************'
	y = 20
	pdf.setY y 
	pdf.SetFont "Arial","B",6
	pdf.Cell 15,4,"CARRERA","0","0","L"
	x1 = pdf.GetX()
	'---------------------------------------nombre de la carrera	
	'pdf.setY (y-2)
	pdf.setX x1
	pdf.SetFont "Arial","",6
	pdf.MultiCell 55,4,string_celda,"0","L",""
	pdf.SetFont "Arial","",8
	'---------------------------------------nombre de la carrera
	'---------------------------------------titulo
		pdf.SetFont "Arial","B",9
		pdf.setXY pdf.getx() + 40, y
		pdf.MultiCell 220,4,"CONTROL DE ASISTENCIA "&string_anio&" ("&string_periodo&")","0","C",""
		pdf.setX 50
		pdf.MultiCell 220,4,"( BORRADOR )","0","C",""
	'---------------------------------------titulo
	'---------------------------------------FECHAS
		pdf.SetFont "Arial","B",6
		pdf.setXY pdf.getx(), y
		pdf.MultiCell 238,4,"Fecha","0","R",""
		pdf.MultiCell 238,4,"Hora","0","R",""
		pdf.MultiCell 238,4,"Pag.","0","R",""
		'-------------------------------------
		pdf.setXY pdf.getx(), y
		pdf.MultiCell 240,4,":","0","R",""
		pdf.MultiCell 240,4,":","0","R",""
		pdf.MultiCell 240,4,":","0","R",""
		'-------------------------------------
		pdf.SetFont "Arial","",6
		pdf.setXY pdf.getx() + 240, y
		pdf.MultiCell 15,4,string_fecha,"0","L","0"
		pdf.setXY pdf.getx() + 240, y+4
		pdf.MultiCell 15,4,string_hora,"0","L","0"
		pdf.setXY pdf.getx() + 240, y+8
		pdf.MultiCell 15,4,string_pag,"0","L","0"
	'---------------------------------------FECHAS
	
	'---------------------------------------Asignatura
		pdf.SetXY 15, 40 
		pdf.SetFont "Arial","b",7
		pdf.Cell 23,4,"ASIGNATURA ","0","0","L"
		pdf.SetFont "Arial","",7
		pdf.Cell 115,4,": "&string_asignatura,"0","0","L"
	'---------------------------------------Asignatura
	'------------------------lista profesores
		pdf.SetFont "Arial","b",7
		pdf.Cell 26,4,"PROFESOR(ES) :","0","0","L"
		pdf.SetFont "Arial","",7		
		y = pdf.GetY()
		x = pdf.GetX()
		pdf.setXY x,y
		pdf.MultiCell 80,4,string_profesores,"0","L","0"
	'------------------------lista profesores
	'---------------------------------------\\\
	pdf.ln(2)
		pdf.SetX 15
		pdf.SetFont "Arial","b",7
		pdf.Cell 23,4,"CÓDIGO","0","0","L"
		pdf.SetFont "Arial","",7
		pdf.Cell 28,4,": "&string_codAsignatura,"0","1","L"
		pdf.SetFont "Arial","b",7
	pdf.ln(2)
		pdf.SetX 15
		pdf.Cell 23,4,"SECCIÓN","0","0","L"
		pdf.SetFont "Arial","",7
		pdf.Cell 15,4,": "&string_seccion,"0","0","L"
		
		
	'---------------------------------------///
	'--------------------------------------cuadroP
	pdf.setXY 10,36
	pdf.MultiCell 255,44,"","1","C","0"
	'--------------------------------------cuadroP
	
	'-------------------------------tabla_1
		'-----------------
		pdf.setXY 60,52	
		pdf.SetFont "Arial","",8
		alto = 7
		ancho = 25
		
		'-----------------
		crearEspacios "73","65","15"
		'-----------------
		'-------------------------------------**
	'-------------------------------tabla_1
	pdf.setXY 15,75
	pdf.SetFont "Arial","b",8
	pdf.MultiCell 41,5,"NOMBRE ALUMNO(A)","0","L","0"	
	'-------------------------------------
	pdf.SetFont "Arial","b",9
	pdf.setXY 140,60
	pdf.MultiCell 35,5," / = Inasistencia ","0","L","0"
	pdf.setXY 180,60
	pdf.MultiCell 35,5, "·  = Asistencia ","0","L","0"
	pdf.SetFont "Arial","",8
	'-------------------------------------
	'-------------------------------------
	pdf.SetFont "Arial","",9
	pdf.setXY 255,60
	pdf.MultiCell 12,5," % ","0","C","0"
	pdf.SetFont "Arial","",8
	'-------------------------------------
	
	'****************'-----------
	'*	ENCABEZADO  *'
	'****************'
end function
function insertaElemento(var_num, var_nombre)
	pdf.SetFont "Arial","",6
	num = Cstr(var_num)
	'nombre = Cstr(var_nombre)
	pdf.Cell 4,5,num,"1","","C"
	pdf.Cell 59,5,var_nombre,"1","","L"
	crearEspacios pdf.GetX(),pdf.GetY(),"5"
end function
'**************************'
'*			CUERPO		  *'
'**************************'-----------
encabezado()
'*********************************************************************'
'**				FORMULARIO QUE TRAE LA LISTA DE ALUMNOS	     		**'
'*********************************************************************'-----------------
set f_listado = new CFormulario
f_listado.Carga_Parametros "tabla_vacia.xml", "tabla" 'carga el xml
f_listado.Inicializar conexion 'inicializo conexion
consulta = "" & vbCrLf & _
"select protic.obtener_nombre_completo(a.pers_ncorr,'a') as nombre " & vbCrLf & _
"from   cargas_academicas as ca                                    " & vbCrLf & _
"       inner join alumnos as a                                    " & vbCrLf & _
"               on ca.matr_ncorr = a.matr_ncorr                    " & vbCrLf & _
"       inner join personas as p                                   " & vbCrLf & _
"               on a.pers_ncorr = p.pers_ncorr                     " & vbCrLf & _
"where  cast(ca.secc_ccod as varchar) = '"&q_secc_ccod&"'          " & vbCrLf & _
"order by nombre asc                                               " 
'----------------------------------------debug>>
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
'----------------------------------------<<debug
f_listado.Consultar consulta 
'*********************************************************************'-----------------
'**				FORMULARIO QUE TRAE LA LISTA DE ALUMNOS	     		**'
'*********************************************************************'
pdf.setxy 10,80
contador = 1
while f_listado.siguiente
	nombre = f_listado.obtenerValor("nombre")
	if pdf.GetY() < 180 then
		insertaElemento contador,nombre
	else
		pdf.AddPage()
		encabezado()
		pdf.setxy 10,80
		insertaElemento contador,nombre
	end if	
	contador = contador + 1
wend
'insertaElemento 1,"vio"
'**************************'-----------
'*			CUERPO		  *'
'**************************'

'----------------------------------fin>>
pdf.Close()
pdf.Output()
'----------------------------------<<fin
'***********************************'-----------
'*	INICIO DE LA CREACIÓN DEL PDF  *'
'***********************************'
%>