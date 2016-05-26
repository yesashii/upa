<!-- #include file = "../biblioteca/fpdf.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'--------------------------------------------------por get
post_ncorr = request.querystring("post_ncorr")
'--------------------------------------------------por get
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
set errores = new cErrores

'*********************************************************'
'**				FORMULARIO QUE TRAE LOS DATOS   		**'
'*********************************************************'-----------------
	set f_listado1 = new CFormulario
	f_listado1.Carga_Parametros "tabla_vacia.xml", "tabla" 'carga el xml
	f_listado1.Inicializar conexion 'inicializo conexion
	consulta = "" & vbCrLf & _
	"select isnull                                                                  " & vbCrLf & _
	"       (protic.ano_ingreso_carrera(p.pers_ncorr, ee.carr_ccod), pac.anos_ccod) " & vbCrLf & _
	"                                      ano_ingreso,                             " & vbCrLf & _
	"       ss.sede_tdesc                         as nombre_sede,                   " & vbCrLf & _
	"       pp.pers_tnombre + ' ' + pp.pers_tape_paterno                            " & vbCrLf & _
	"       + ' ' + pp.pers_tape_materno          as nombre_alumno,                 " & vbCrLf & _
	"       convert(char(8), pp.pers_nrut) + '-'                                    " & vbCrLf & _
	"       + pp.pers_xdv                         as rut_post,                      " & vbCrLf & _
	"       ccc.carr_tdesc                        as carrera,                       " & vbCrLf & _
	"       ddp.dire_tcalle + ' ' + ddp.dire_tnro as direccion,                     " & vbCrLf & _
	"       ddp.dire_tfono                        as fono,                          " & vbCrLf & _
	"       c.ciud_tdesc                          as ciudad,                        " & vbCrLf & _
	"       c.ciud_tcomuna                        as comuna                         " & vbCrLf & _
	"from   postulantes p                                                           " & vbCrLf & _
	"       inner join personas_postulante pp                                       " & vbCrLf & _
	"               on p.pers_ncorr = pp.pers_ncorr                                 " & vbCrLf & _
	"                  and p.post_ncorr = isnull('" & post_ncorr & "', '')          " & vbCrLf & _
	"       inner join direcciones_publica ddp                                      " & vbCrLf & _
	"               on pp.pers_ncorr = ddp.pers_ncorr                               " & vbCrLf & _
	"                  and ddp.tdir_ccod = 1                                        " & vbCrLf & _
	"       left outer join ciudades c                                              " & vbCrLf & _
	"                    on ddp.ciud_ccod = c.ciud_ccod                             " & vbCrLf & _
	"       inner join ofertas_academicas oa                                        " & vbCrLf & _
	"               on p.ofer_ncorr = oa.ofer_ncorr                                 " & vbCrLf & _
	"       inner join especialidades ee                                            " & vbCrLf & _
	"               on oa.espe_ccod = ee.espe_ccod                                  " & vbCrLf & _
	"       inner join carreras ccc                                                 " & vbCrLf & _
	"               on ee.carr_ccod = ccc.carr_ccod                                 " & vbCrLf & _
	"       inner join sedes ss                                                     " & vbCrLf & _
	"               on oa.sede_ccod = ss.sede_ccod                                  " & vbCrLf & _
	"       inner join periodos_academicos pac                                      " & vbCrLf & _
	"               on oa.peri_ccod = pac.peri_ccod                                 " 
	'----------------------------------------debug>>
	'response.Write("<pre>"&consulta&"</pre>")
	'response.End()
	'----------------------------------------<<debug
	f_listado1.Consultar consulta 
	f_listado1.siguiente
	'--------------------------------------VARIABLES
		nombre_sede 	= f_listado1.obtenerValor("nombre_sede")	
		ano_ingreso 	= f_listado1.obtenerValor("ano_ingreso")
		nombre_alumno	= f_listado1.obtenerValor("nombre_alumno")	
		rut_post 		= f_listado1.obtenerValor("rut_post")	
		carrera 		= f_listado1.obtenerValor("carrera")
		direccion 		= f_listado1.obtenerValor("direccion")
		fono 			= f_listado1.obtenerValor("fono")
		ciudad 			= f_listado1.obtenerValor("ciudad")
		comuna 			= f_listado1.obtenerValor("comuna")
'--------------------------------------VARIABLES	
'*********************************************************'-----------------
'**				FORMULARIO QUE TRAE LOS DATOS   		**'
'*********************************************************'
'***********************************'
'*	INICIO DE LA CREACIÓN DEL PDF  *'
'***********************************'-----------
'----------------------------------inicio>>
Set pdf=CreateJsObject("FPDF")
'pdf.CreatePDF()' crear con valores por defecto
pdf.CreatePDF "P","mm","Letter"
pdf.SetPath("../biblioteca/fpdf/" )
pdf.SetFont "Arial","B",12
pdf.Open()
pdf.AddPage()


'**************************'
'*			CUERPO		  *'
'**************************'-----------
'pdf.SetLineWidth 0.1
pdf.SetLineWidth 0.4
pdf.Rect 10, 10, 195, 200 ,"D"
pdf.Rect 10, 10, 195, 40 ,"D"

'------------------------------------logo
pdf.Image "../imagenes/logo_upacifico.jpg",12,12, 45
'------------------------------------logo
'------------------------------------Titulo
pdf.SetFont "Arial","b",14
pdf.setXY 85, 25
pdf.MultiCell 60,5,"FICHA DEL ALUMNO","0","L","0"
'------------------------------------Titulo
'------------------------------------NOMBRE
pdf.SetFont "Arial","b",12
pdf.setXY 30, 60
pdf.MultiCell 45,7,"Nombre Alumno","0","L","0"
'-------------
pdf.SetFont "Arial","",12
pdf.setXY 75, 60
pdf.MultiCell 70,7,": "&nombre_alumno,"0","L","0"
'------------------------------------NOMBRE
'------------------------------------RUT
pdf.SetFont "Arial","b",12
y = pdf.GetY() + 5
pdf.setXY 30, y
pdf.MultiCell 45,7,"R.U.T","0","L","0"
'-------------
pdf.SetFont "Arial","",12
pdf.setXY 75, y
pdf.MultiCell 70,7,": "&rut_post,"0","L","0"
'------------------------------------RUT
'------------------------------------DIRECCION
pdf.SetFont "Arial","b",12
y = pdf.GetY() + 5
pdf.setXY 30, y
pdf.MultiCell 45,7,"Dirección","0","L","0"
'-------------
pdf.SetFont "Arial","",12
pdf.setXY 75, y
pdf.MultiCell 70,7,": "&direccion,"0","L","0"
'------------------------------------DIRECCION
'------------------------------------TELEFONO
pdf.SetFont "Arial","b",12
y = pdf.GetY() + 5
pdf.setXY 30, y
pdf.MultiCell 45,7,"Teléfono","0","L","0"
'-------------
pdf.SetFont "Arial","",12
pdf.setXY 75, y
pdf.MultiCell 70,7,": "&fono,"0","L","0"
'------------------------------------TELEFONO
'------------------------------------CIUDAD/COMUNA
pdf.SetFont "Arial","b",12
y = pdf.GetY() + 5
pdf.setXY 30, y
pdf.MultiCell 45,7,"Ciudad/Comuna","0","L","0"
'-------------
pdf.SetFont "Arial","",12
pdf.setXY 75, y
pdf.MultiCell 70,7,": "&ciudad&"/"&comuna,"0","L","0"
'------------------------------------CIUDAD/COMUNA
'------------------------------------CARRERA
pdf.SetFont "Arial","b",12
y = pdf.GetY() + 35
pdf.setXY 30, y
pdf.MultiCell 45,7,"Carrera","0","L","0"
'-------------
pdf.SetFont "Arial","",12
pdf.setXY 75, y
pdf.MultiCell 70,7,": "&carrera,"0","L","0"
'------------------------------------CARRERA
'------------------------------------AÑO INGRESO
pdf.SetFont "Arial","b",12
y = pdf.GetY() + 5
pdf.setXY 30, y
pdf.MultiCell 45,7,"Año de ingreso","0","L","0"
'-------------
pdf.SetFont "Arial","",12
pdf.setXY 75, y
pdf.MultiCell 70,7,": "&ano_ingreso,"0","L","0"
'------------------------------------AÑO INGRESO
'------------------------------------SEDE
pdf.SetFont "Arial","b",12
y = pdf.GetY() + 5
pdf.setXY 30, y
pdf.MultiCell 45,7,"Sede","0","L","0"
'-------------
pdf.SetFont "Arial","",12
pdf.setXY 75, y
pdf.MultiCell 70,7,": "&nombre_sede,"0","L","0"
'------------------------------------SEDE

pdf.SetLineWidth 0.5
pdf.Rect 163, 52, 38, 45 ,"D"


'**************************'-----------
'*			CUERPO		  *'
'**************************'
'----------------------------------fin>>
pdf.Close()
pdf.Output()
'----------------------------------<<fin
%>