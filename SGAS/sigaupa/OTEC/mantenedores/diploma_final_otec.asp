<!-- #include file = "../biblioteca/fpdf.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'--------------------------------------------------por get
dgso_ncorr = Request.QueryString("dgso_ncorr")
pers_ncorr = Request.QueryString("pers_ncorr")
'--------------------------------------------------por get
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
'set errores = new cErrores

rut 		= conexion.consultaUno("select cast(pers_nrut as varchar) + '-' + pers_xdv from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
alumno  	= conexion.consultaUno("select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
dcur_ncorr	= conexion.consultaUno("select dcur_ncorr from datos_generales_secciones_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")
nombre_ac	= conexion.consultaUno("select dcur_tdesc from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")
nombre_se	= conexion.consultaUno("select isnull(dcur_nombre_sence,dcur_tdesc) from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'") 
codigo_se	= conexion.consultaUno("select dcur_nsence from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")
horas   	= conexion.consultaUno("select sum(maot_nhoras_programa) from mallas_otec where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")
fecha_i   	= conexion.consultaUno("select protic.trunc(dgso_finicio) from datos_generales_secciones_otec where cast(dgso_ncorr as varchar) = '"&dgso_ncorr&"' ")
fecha_t   	= conexion.consultaUno("select protic.trunc(dgso_ftermino) from datos_generales_secciones_otec where cast(dgso_ncorr as varchar) = '"&dgso_ncorr&"' ")
en_postulacion = conexion.consultaUno("select count(*) from postulacion_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"' and epot_ccod=4")
c_unidad    = " select b.UDPO_TDESC + ' DE LA UNIVERSIDAD DEL PACÍFICO' from ofertas_otec a,unidades_dictan_programas_otec b "&_
			  " where cast(dcur_ncorr as varchar)='"&dgso_ncorr&"' "&_
			  " and a.udpo_ccod=b.udpo_ccod"
unidad      = conexion.consultaUno(c_unidad)

c_duracion  = " select cast(datepart(day,a.dgso_finicio) as varchar) + ' de ' + lower(b.MES_TDESC) + ' de ' + cast(datepart(year,a.dgso_finicio) as varchar) + ' al ' + "&_
       		  " cast(datepart(day,a.dgso_ftermino) as varchar) + ' de ' + lower(c.MES_TDESC) + ' de ' + cast(datepart(year,a.dgso_ftermino) as varchar) as fecha_x "&_
			  " from datos_generales_secciones_otec a, meses b, meses c where cast(a.dcur_ncorr as varchar)='"&dgso_ncorr&"' "&_
			  " and datepart(month,a.dgso_finicio)=b.mes_ccod "&_
			  " and datepart(month,a.dgso_ftermino)=c.mes_ccod"
duracion    = conexion.consultaUno(c_duracion)

dia 		= conexion.consultaUno("select datepart(day,getDate())")
mes 		= conexion.consultaUno("select protic.initCap(mes_tdesc) from meses where mes_ccod = datepart(month,getDate())")
anio 		= conexion.consultaUno("select datepart(year,getDate())")

if en_postulacion <> "0" then 
calificacion= conexion.consultaUno("select replace(pote_nnota_final,',','.') from postulacion_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"' and epot_ccod = 4")
asistencia  = conexion.consultaUno("select pote_nasistencia from postulacion_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"'  and epot_ccod = 4")
estado      = conexion.consultaUno("select case pote_nest_final when 1 then 'REPROBADO' when 2 then 'APROBADO' else '' end from postulacion_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"'  and epot_ccod = 4")

c_en_palabra = " select case  SUBSTRING(LTRIM(RTRIM(cast(cast(pote_nnota_final AS decimal(2,1))AS varchar))), 1, CHARINDEX('.', LTRIM(RTRIM(cast(cast(pote_nnota_final AS decimal(2,1)) AS varchar)))) - 1) "& vbCrLf &_
			   "   when 1 then 'Uno' when 2 then 'Dos' when 3 then 'Tres' when 4 then 'Cuatro' when 5 then 'Cinco' when 6 then 'Seis' "& vbCrLf &_
			   "   when 7 then 'Siete' end + '                 ' +  "& vbCrLf &_
			   "   case isnull(SUBSTRING(LTRIM(RTRIM(cast(cast(pote_nnota_final AS decimal(2,1))AS varchar))), CHARINDEX('.', LTRIM(RTRIM(cast(cast(pote_nnota_final AS decimal(2,1))AS varchar)))) + 1, 1),0)  "& vbCrLf &_
			   "   when 1 then 'Uno' when 2 then 'Dos' when 3 then 'Tres' when 4 then 'Cuatro' when 5 then 'Cinco' when 6 then 'Seis'  "& vbCrLf &_
			   "   when 7 then 'Siete' when 8 then 'Ocho' when 9 then 'Nueve' when 0 then 'Cero' end + '' as en_palabras "& vbCrLf &_
               " from postulacion_otec "& vbCrLf &_
			   " where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' "& vbCrLf &_
			   " and   cast(pers_ncorr as varchar)='"&pers_ncorr&"' and epot_ccod = 4 "
			   
else
calificacion= conexion.consultaUno("select replace(pote_nnota_final,',','.') from postulacion_asociada_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"' and epot_ccod = 4")
asistencia  = conexion.consultaUno("select pote_nasistencia from postulacion_asociada_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"'  and epot_ccod = 4")
estado      = conexion.consultaUno("select case pote_nest_final when 1 then 'REPROBADO' when 2 then 'APROBADO' else '' end from postulacion_asociada_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"'  and epot_ccod = 4")

c_en_palabra = " select case  SUBSTRING(LTRIM(RTRIM(cast(cast(pote_nnota_final AS decimal(2,1))AS varchar))), 1, CHARINDEX('.', LTRIM(RTRIM(cast(cast(pote_nnota_final AS decimal(2,1)) AS varchar)))) - 1) "& vbCrLf &_
			   "   when 1 then 'Uno' when 2 then 'Dos' when 3 then 'Tres' when 4 then 'Cuatro' when 5 then 'Cinco' when 6 then 'Seis' "& vbCrLf &_
			   "   when 7 then 'Siete' end + '                 ' +  "& vbCrLf &_
			   "   case isnull(SUBSTRING(LTRIM(RTRIM(cast(cast(pote_nnota_final AS decimal(2,1))AS varchar))), CHARINDEX('.', LTRIM(RTRIM(cast(cast(pote_nnota_final AS decimal(2,1))AS varchar)))) + 1, 1),0)  "& vbCrLf &_
			   "   when 1 then 'Uno' when 2 then 'Dos' when 3 then 'Tres' when 4 then 'Cuatro' when 5 then 'Cinco' when 6 then 'Seis'  "& vbCrLf &_
			   "   when 7 then 'Siete' when 8 then 'Ocho' when 9 then 'Nueve' when 0 then 'Cero' end + '' as en_palabras "& vbCrLf &_
               " from postulacion_asociada_otec "& vbCrLf &_
			   " where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' "& vbCrLf &_
			   " and   cast(pers_ncorr as varchar)='"&pers_ncorr&"' and epot_ccod = 4 "
end if			   

en_palabra= conexion.consultaUno(c_en_palabra)
'****************************************************'

'************************************************************'
'*				INICIO DE LA CREACIÓN DEL PDF				*'
'************************************************************'
Set pdf=CreateJsObject("FPDF")
'pdf.CreatePDF()' crear con valores por defecto
pdf.CreatePDF "l","mm","Letter"
pdf.SetPath("../biblioteca/fpdf/" )
pdf.SetFont "times","B",16
pdf.Open()
'pdf.SetAutoPageBreak TRUE,20
'---------------------------------------------Bordes
pdf.AddPage()
'pdf.SetY(13)
'pdf.MultiCell 260,190,"","1","C",""
'pdf.SetY(15)
'pdf.SetX(12)
'pdf.MultiCell 256,186,"","1","C",""
'---------------------------------------------Bordes

'---------------------------------------------Titulo
pdf.SetY(71)
pdf.SetX(23)
pdf.SetFont "times","B",18
pdf.Cell 80,8," ",0,"C"
pdf.Cell 4,8," ",0,"C"
pdf.SetFont "times","",18
pdf.Cell 175,8,alumno,0,"C"

'---------------------------------------------NOMBRE ACTIVIDAD DE CAPACITACIÓN
pdf.SetY(85)
pdf.Ln()
pdf.SetX(23)
pdf.SetFont "times","B",16
pdf.Cell 80,8," ",0,"C"
'------------::
pdf.Cell 4,8," ",0,"C"
'------------::
'-------------------------------------Primera_parte_nombre_programa
pdf.SetFont "times","",16
largo = Len(nombre_se)
a=Split(nombre_se)
largo_2 = Ubound(a)
palabra = ""
if largo_2 >= 5  then
for i = 0 to 4
	palabra = palabra & a(i) & " "
next
else
	palabra = nombre_se
end if
pdf.Cell 175,8,palabra,0,"C"
'-------------------------------------Segunda linea_nombre_programa
pdf.SetFont "times","B",16
pdf.SetY(97)
pdf.Ln()
pdf.SetX(23)
pdf.Cell 80,8," ",0,"C"
'------------::
pdf.Cell 4,8," ",0,"C"
'------------::
'------------------NOM diplomado
pdf.SetFont "times","",16
'-------------------------------------Segunda_parte_nombre_programa
palabra = ""
if largo_2 > 5 then
for i = 5 to largo_2
	palabra = palabra & a(i) & " "
next
end if
pdf.Cell 175,8,palabra,0,"C"
'-------------------------------------Segunda_parte_nombre_programa
'-------------------------------------Horas y programa
pdf.SetFont "times","B",16
pdf.SetY(109)
pdf.Ln()
pdf.SetX(27)
pdf.Cell 80,8," ",0,"C"
'------------::
pdf.Cell 4,8," ",0,"C"
'------------::
'------------------NOM diplomado
pdf.SetFont "times","",16
'-------------------------------------HORAS
pdf.Cell 60,8,horas,0,"C"
'-------------------------------------PRIMERA LINEA UNIDAD
b=Split(unidad)
largo_2 = Ubound(b)
palabra = ""
if largo_2 >= 2  then
for i = 0 to 2
	palabra = palabra & b(i) & " "
next
else
	palabra = unidad
end if
pdf.Cell 95,8,palabra,0,"C"
'------------------------------------SEGUNDA LINEA UNIDAD
pdf.SetFont "times","B",16
pdf.SetY(121)
pdf.Ln()
pdf.SetX(23)
pdf.Cell 80,8," ",0,"C"
'------------::
pdf.Cell 4,8," ",0,"C"
'------------::
'------------------NOM diplomado
pdf.SetFont "times","",16
'-------------------------------------Segunda_parte_UNIDAD
palabra = ""
if largo_2 > 2 then
for i = 3 to largo_2
	palabra = palabra & b(i) & " "
next
end if
pdf.Cell 175,8,palabra,0,"C"
'------------------------------------Duración
'-------------------------------------Horas y programa
pdf.SetFont "times","B",16
pdf.SetY(131)
pdf.Ln()
pdf.SetX(50)
pdf.Cell 80,8," ",0,"C"
'------------::
pdf.Cell 4,8," ",0,"C"
'------------::
'------------------NOM diplomado
pdf.SetFont "times","",16
'-------------------------------------HORAS
pdf.Cell 150,8,duracion,0,"C"
'-------------------------------------Fecha de impresión
pdf.SetFont "times","B",16
pdf.SetY(143)
pdf.Ln()
pdf.SetX(110)
pdf.Cell 56,8," ",0,"C"
'------------::
pdf.Cell 4,8," ",0,"C"
'------------::
'------------------NOM diplomado
pdf.SetFont "times","",16
'-------------------------------------HORAS
pdf.Cell 32,8,"Santiago",0,"C"
pdf.Cell 17,8,dia,0,"C"
pdf.Cell 40,8,mes,0,"C"
pdf.Cell 5,8,anio,0,"C"


pdf.Close()
pdf.Output()


%>
