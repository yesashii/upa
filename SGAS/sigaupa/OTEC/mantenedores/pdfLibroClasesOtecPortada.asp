<!-- #include file = "../biblioteca/fpdf.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'--------------------------------------------------por get
dcur_ncorr = request.querystring("dcur_ncorr")
'--------------------------------------------------por get
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
'set errores = new cErrores

set f_portada = new CFormulario
f_portada.Carga_Parametros "tabla_vacia.xml", "tabla"
f_portada.Inicializar conexion
'************************************************************************'
'*				CONSULTA QUE LLENA LOS DATOS DE LA PORTADA 				*'
'************************************************************************'
consulta = "" & vbCrLf & _
"select distinct case                                                      " & vbCrLf & _
"                  when ( len(b.dcur_nombre_sence) < 2 ) then b.dcur_tdesc " & vbCrLf & _
"                  else isnull(b.dcur_nombre_sence, b.dcur_tdesc)          " & vbCrLf & _
"                end                           as dcur_tdesc,              " & vbCrLf & _
"                protic.trunc(a.dgso_finicio)  as seot_finicio,            " & vbCrLf & _
"                protic.trunc(a.dgso_ftermino) as seot_ftermino,           " & vbCrLf & _
"                a.dgso_ncorr				   as dgso_ncorr               " & vbCrLf & _
"from   datos_generales_secciones_otec as a                                " & vbCrLf & _
"       inner join diplomados_cursos as b                                  " & vbCrLf & _
"               on a.dcur_ncorr = b.dcur_ncorr                             " & vbCrLf & _
"                  and cast(b.dcur_ncorr as varchar) = '"&dcur_ncorr&"'    "
'************************************************************************'
'response.Write("<pre>"&consulta&"</pre>")
'response.end()
f_portada.Consultar consulta
f_portada.siguiente
'************************'
'* CAPTURA DE VARIABLES	*'
'****************************************************'
dgso_ncorr_aux = f_portada.obtenerValor("dgso_ncorr")
nombreActividad = f_portada.obtenerValor("dcur_tdesc")
fechaInicio = f_portada.obtenerValor("seot_finicio")
fechaTermino = f_portada.obtenerValor("seot_ftermino")
codSence = f_portada.obtenerValor("dcur_nsence")
'relatores = conexion.consultaUno("select protic.initCap(isnull(protic.OBTENER_RELATORES_OTEC(" & dcur_ncorr & "),''))")
relatores = conexion.consultaUno("select isnull(protic.initCap(protic.OBTENER_RELATORES_OTEC("& dgso_ncorr_aux &")),'')")
if relatores = "" then
	relatores = "_"
end if
'relatores = "pedro "
'****************************************************'

'********************************************************'
'*				CONSULTA QUE TRAE LOS DÍAS 				*'
'********************************************************'-------------
set f_dias = new CFormulario
f_dias.Carga_Parametros "tabla_vacia.xml", "tabla"
f_dias.Inicializar conexion
consulta = "" & vbCrLf & _
"select d.dias_tdesc 							as dias  " & vbCrLf & _
"from   datos_generales_secciones_otec as a              " & vbCrLf & _
"       inner join secciones_otec as b                   " & vbCrLf & _
"               on a.dgso_ncorr = b.dgso_ncorr           " & vbCrLf & _
"       inner join programacion_calendario_otec as c     " & vbCrLf & _
"               on b.seot_ncorr = c.seot_ncorr           " & vbCrLf & _
"       inner join dias_semana as d                      " & vbCrLf & _
"               on c.dias_ccod = d.dias_ccod             " & vbCrLf & _
"where  cast(a.dcur_ncorr as varchar) = '"&dcur_ncorr&"' " & vbCrLf & _
"order by  d.dias_ccod           			             " 


Redim array_dias(7)
contador_dias = 1
f_dias.Consultar consulta
while f_dias.siguiente
	array_dias(contador_dias) = f_dias.obtenerValor("dias")
	contador_dias = contador_dias + 1
	if(contador_dias > 7) then
		return false
	end if	
wend
'********************************************************'--------------
'*				CONSULTA QUE TRAE LOS DÍAS 				*'
'********************************************************'




'************************************************************'
'*				INICIO DE LA CREACIÓN DEL PDF				*'
'************************************************************'
Set pdf=CreateJsObject("FPDF")
'pdf.CreatePDF()' crear con valores por defecto
pdf.CreatePDF "l","mm","Letter"
pdf.SetPath("../biblioteca/fpdf/" )
pdf.SetFont "Arial","B",12
pdf.Open()
'pdf.SetAutoPageBreak TRUE,20
'---------------------------------------------Bordes
pdf.AddPage()
pdf.SetY(13)
pdf.MultiCell 260,190,"","1","C",""
pdf.SetY(15)
pdf.SetX(12)
pdf.MultiCell 256,186,"","1","C",""
'---------------------------------------------Bordes

'---------------------------------------------Titulo
pdf.SetY(25)
pdf.SetFont "Arial","BU",22
pdf.MultiCell 256,12,"LIBRO DE CONTROL DE CLASES" ,"0","C",""
'---------------------------------------------Titulo

'---------------------------------------------NOMBRE OTEC
pdf.SetY(45)
pdf.SetX(20)
pdf.SetFont "Arial","B",14
pdf.Cell 70,8,"NOMBRE OTEC",0,"C"
'------------::
pdf.Cell 4,8,":",0,"C"
'------------::
'------------------NOM UNIVERSIDAD
pdf.SetFont "Arial","",14
pdf.Cell 165,8,"Universidad Del Pacífico",0,"C"
'------------------NOM UNIVERSIDAD
'---------------------------------------------NOMBRE OTEC

'---------------------------------------------NOMBRE ACTIVIDAD DE CAPACITACIÓN
pdf.Ln()
pdf.Ln()
pdf.SetX(20)
pdf.SetFont "Arial","B",14
pdf.Cell 70,8,"NOMBRE ACTIVIDAD DE",0,"C"
'------------::
pdf.Cell 4,8,":",0,"C"
'------------::
'-------------------------------------Primera_parte_nombre_programa
pdf.SetFont "Arial","",13
largo = Len(nombreActividad)
a=Split(nombreActividad)
largo_2 = Ubound(a)
palabra = ""
if largo_2 >= 3 then
for i = 0 to 3
	palabra = palabra & a(i) & " "
next
else
	palabra = nombreActividad
end if
pdf.Cell 165,8,palabra,0,"C"
'-------------------------------------Primera_parte_nombre_programa
pdf.SetFont "Arial","B",14
pdf.Ln()
pdf.SetX(20)
pdf.Cell 70,8,"CAPACITACIÓN",0,"C"
'------------::
pdf.Cell 4,10," ",0,"C"
'------------::
'------------------NOM diplomado
pdf.SetFont "Arial","",13
'-------------------------------------Segunda_parte_nombre_programa
palabra = ""
if largo_2 > 3 then
for i = 4 to largo_2
	palabra = palabra & a(i) & " "
next
end if
pdf.Cell 165,8,palabra,0,"C"
'-------------------------------------Segunda_parte_nombre_programa
'------------------NOM diplomado
'---------------------------------------------NOMBRE ACTIVIDAD DE CAPACITACIÓN

'---------------------------------------------CÓDIGO AUTORIZADO POR SENCE
pdf.Ln()
pdf.Ln()
pdf.SetX(20)
pdf.SetFont "Arial","B",14
pdf.Cell 70,8,"CÓDIGO AUTORIZADO",0,"C"
pdf.Ln()
pdf.SetX(20)
pdf.Cell 70,8,"POR SENCE",0,"C"
'------------::
pdf.Cell 4,8,":",0,"C"
'------------::
'------------------codigo sence
if codSence = "" then
	codSence = "N/A."
end if
pdf.SetFont "Arial","",14
pdf.Cell 165,8,""&codSence&"",0,"C"
'------------------codigo sence
'---------------------------------------------CÓDIGO AUTORIZADO POR SENCE

'---------------------------------------------FECHA DE EJECUCIÓN
pdf.Ln()
pdf.Ln()
pdf.SetX(20)
pdf.SetFont "Arial","B",14
pdf.Cell 70,8,"FECHA DE EJECUCIÓN",0,"L"
'------------::
pdf.Cell 4,8,":",0,"C"
'------------::
'------------------fecha de inicio
pdf.Cell 37,8,"FECHA INICIO:",0,"C"
pdf.SetFont "Arial","",14
pdf.Cell 30,8,""&fechaInicio&"",0,"C"
pdf.SetFont "Arial","B",14
'------------------fecha de inicio
'------------------fecha de TERMIN0
pdf.Cell 45,8,"FECHA TÉRMINO:",0,"C"
pdf.SetFont "Arial","",14
pdf.Cell 30,8,""&fechaTermino&"",0,"C"
'------------------fecha de TERMIN0
'---------------------------------------------FECHA DE EJECUCIÓN
'---------------------------------------------LUGAR DE EJECUCIÓN
pdf.Ln()
pdf.Ln()
pdf.SetX(20)
pdf.SetFont "Arial","B",14
pdf.Cell 70,8,"LUGAR DE EJECUCIÓN",0,"L"
'------------::
pdf.Cell 4,8,":",0,"C"
'------------::
'------------------fecha de inicio
pdf.SetFont "Arial","",14
pdf.Cell 55,8,"Av. Las Condes 11.121",0,"C"

'---------------------------------------------LUGAR DE EJECUCIÓN

'---------------------------------------------HORARIO
pdf.Ln()
pdf.Ln()
pdf.SetX(20)
pdf.SetFont "Arial","B",14
pdf.Cell 70,8,"HORARIO",0,"C"
'------------::
pdf.Cell 4,8,":",0,"C"
'------------::
'------------------
pdf.SetFont "Arial","",14
'pdf.Cell 165,8,"Por definir",0,"C"
'------------------
for i=1 to contador_dias - 1
	pdf.Cell 24,8,array_dias(i),"0","0","C" 
	if i <> contador_dias - 1 then
		pdf.Cell 5,8,"-","0","L","1"
	end if
next
'---------------------------------------------HORARIO

'---------------------------------------------NOMBRE RELATOR (A)

'*********************fijo
pdf.Ln()
pdf.Ln()
pdf.SetX(20)
pdf.SetFont "Arial","B",14
pdf.Cell 70,8,"NOMBRE RELATOR (A)",0,"C" 
'------------::
pdf.Cell 4,8,":",0,"C"
'------------::
'*********************fijo
'-------------------------------------------------------
largo = Len(relatores) 		'largo de la cadena
a = Split(relatores,"-")	'array con lista de nombres
largo_2 = Ubound(a)			'largo del array
'-------------------------------------------------------
pdf.SetFont "Arial","",14
if largo_2 < 3 then
	palabra = ""
	for i = 0 to largo_2
		if i <> 0 then
			palabra = palabra & ", " & a(i) 
		else
			palabra = palabra & ". " & a(i) 
		end if	
	next
	pdf.Cell 165,8,""&palabra&"",0,"L"		
else
	'------------------------------------------------------------------------
	palabra = ""
	for i = 0 to 2
			palabra = palabra  & a(i) & ", "
			
	next
	pdf.Cell 165,8,""&palabra&"",0,"L"	
	'------------------------------------------------------------------------
	paso = true
	max = 3
	while paso		
		'---------------------------------------------fila_ini (mas de 3)
		pdf.Ln()
		pdf.SetX(20)
		pdf.SetFont "Arial","B",14
		pdf.Cell 70,8," ",0,"C"
		'------------::
		pdf.Cell 4,8," ",0,"C"
		'------------::
		'------------------
		'*********************************
		palabra = ""
		if largo_2 < (max + 3) then
			for i = max to largo_2
				if i = largo_2 then
					palabra = palabra & a(i) & "."
				else
					palabra = palabra & a(i) & ", "
				end if	
			next
		else
			for i = max to (max + 2)
				if i = largo_2 then
					palabra = palabra & a(i) & " "
				else
					palabra = palabra & a(i) & ", "
				end if	
			next
		end if
		'*********************************
		pdf.SetFont "Arial","",14
		pdf.Cell 165,8,""& palabra &"",0,"L"
		'--------------------------------------------fila_fin
		max = max + 3
		if largo_2 < max then
			paso = false
		end if
	wend
end if
'---------------------------------------------NOMBRE RELATOR (A)





pdf.Close()
pdf.Output()


%>
