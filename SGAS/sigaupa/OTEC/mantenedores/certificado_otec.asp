<%@language=vbscript%>
<!-- #include file = "../biblioteca/fpdf.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
dgso_ncorr = Request.QueryString("dgso_ncorr")
pers_ncorr = Request.QueryString("pers_ncorr")

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

rut 		= conexion.consultaUno("select cast(pers_nrut as varchar) + '-' + pers_xdv from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
nombres 	= conexion.consultaUno("select pers_tnombre from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
apellidos	= conexion.consultaUno("select pers_tape_paterno + ' ' + pers_tape_materno from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
dcur_ncorr	= conexion.consultaUno("select dcur_ncorr from datos_generales_secciones_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")
nombre_ac	= conexion.consultaUno("select dcur_tdesc from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")
nombre_se	= conexion.consultaUno("select dcur_nombre_sence from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'") 
codigo_se	= conexion.consultaUno("select dcur_nsence from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")
horas   	= conexion.consultaUno("select sum(maot_nhoras_programa) from mallas_otec where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")
fecha_i   	= conexion.consultaUno("select protic.trunc(dgso_finicio) from datos_generales_secciones_otec where cast(dgso_ncorr as varchar) = '"&dgso_ncorr&"' ")
fecha_t   	= conexion.consultaUno("select protic.trunc(dgso_ftermino) from datos_generales_secciones_otec where cast(dgso_ncorr as varchar) = '"&dgso_ncorr&"' ")
en_postulacion = conexion.consultaUno("select count(*) from postulacion_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"' and epot_ccod=4")

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

'-----------dividimos cuando el nombre del programa sea mas grande que 40 caracteres
Dim arregloPrograma,largopPrograma
arregloPrograma = Split(nombre_ac)
largoPrograma   = Len(nombre_ac)
linea_1 = ""
linea_2 = ""
if largoPrograma <= 40 then
   linea_1 = nombre_ac
else
   valor_corte = 0
   for each palabra in arregloPrograma
     if Len(linea_1&" "&palabra) <= 40 and valor_corte = 0 then
	 	linea_1 = linea_1 & " " & palabra
	 else
	    linea_2 = linea_2 & " " & palabra
		valor_corte = 1
	 end if
   next
end if

'-----------dividimos cuando el nombre Sence del programa sea mas grande que 40 caracteres
Dim arregloSence,largopSence
arregloSence = Split(nombre_se)
largoSence   = Len(nombre_se)
linea_1_se = ""
linea_2_se = ""
if largoSence <= 40 then
   linea_1_se = nombre_se
else
   valor_corte_se = 0
   for each palabra in arregloSence
     if Len(linea_1_se&" "&palabra) <= 40 and valor_corte_se = 0 then
	 	linea_1_se = linea_1_se & " " & palabra
	 else
	    linea_2_se = linea_2_se & " " & palabra
		valor_corte_se = 1
	 end if
   next
end if


c_responsable = " select udpo_tdesc  " & vbCrLf &_
                " from responsable_programa a, responsable_unidad b, UNIDADES_DICTAN_PROGRAMAS_OTEC c  " & vbCrLf &_
                " where a.reun_ncorr = b.reun_ncorr and b.udpo_ccod=c.udpo_ccod  " & vbCrLf &_
				" and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'"
responsable   = conexion.consultaUno(c_responsable)

consulta_fecha = " select cast(datePart(day,getDate()) as varchar) " 				 
dia_impresion = conexion.consultaUno(consulta_fecha)

consulta_fecha = " select case datePart(month,getDate()) when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' " & vbCrLf &_
				 " when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' " & vbCrLf &_
				 " when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' end " 
mes_impresion = conexion.consultaUno(consulta_fecha)

consulta_fecha = " select cast(datePart(year,getDate()) as varchar) as fecha_01"				 
anio_impresion = conexion.consultaUno(consulta_fecha)

espacio="                                       "
espacio2="    "
Set pdf=CreateJsObject("FPDF")
pdf.CreatePDF()
pdf.SetPath("../biblioteca/fpdf/" )
pdf.SetFont "times","",12
pdf.Open()
pdf.AddPage()
'lineas superiores
'pdf.Line 8, 18, 204, 18 
'pdf.Line 7, 17, 205, 17 
'lineas izquierdas
'pdf.Line 7, 17, 7, 285
'pdf.Line 8, 18, 8, 284
'lineas derechas
'pdf.Line 204, 18, 204, 284
'pdf.Line 205, 17, 205, 285
'lineas inferiores
'pdf.Line 8, 284, 204, 284 
'pdf.Line 7, 285, 205, 285

'pdf.Image "../certificados_dae/imagenes/logo_upa.jpg", 14, 22, 20, 20, "JPG"
	pdf.ln(43)
pdf.SetFont "times","",18
pdf.Cell 180,1,"","","","C"  
	pdf.ln(6)
pdf.SetFont "times","",14
pdf.Cell 185,1,rut,"","","R"
pdf.ln(28)
pdf.SetFont "times","",14
pdf.Cell 185,1,"                                                 "&nombres,"","","L"  
pdf.ln(12)
pdf.SetFont "times","",14
pdf.Cell 185,1,"                                                 "&apellidos,"","","L"  
pdf.ln(17)
pdf.SetFont "times","",14
pdf.Cell 185,1,"                                                 "&linea_1,"","","L" 
pdf.ln(11)
pdf.SetFont "times","",14
pdf.Cell 185,1,"                                                 "&linea_2,"","","L" 
pdf.ln(13)
pdf.SetFont "times","",14
pdf.Cell 185,1,"                                                 "&linea_1_se,"","","L" 
pdf.ln(11)
pdf.SetFont "times","",14
pdf.Cell 185,1,"                                                 "&linea_2_se,"","","L"   
pdf.ln(16)
pdf.SetFont "times","",14
pdf.Cell 185,1,"                                                 "&codigo_se,"","","L"
pdf.ln(18)
pdf.SetFont "times","",14
pdf.Cell 180,0,"                                                  "&fecha_i,"","","L"
pdf.SetX(100)
pdf.Cell 80,0,"","","","L"
pdf.SetX(120)
pdf.Cell 60,0,"","","","L"
pdf.SetX(160)
pdf.Cell 20,0,fecha_t,"","","L"
pdf.ln(16)
pdf.SetFont "times","",14
pdf.Cell 185,1,"                                                 "&calificacion&"                 "&en_palabra&"                                      "&asistencia,"","","L" 
pdf.ln(13)
pdf.SetFont "times","",14
pdf.Cell 185,1,"                                                 "&estado,"","","L"   
pdf.ln(16)
pdf.SetFont "times","",14
pdf.Cell 185,1,"                                                 "&responsable,"","","L"   
	pdf.ln(53)
pdf.SetFont "times","",14
pdf.Cell 180,0,"        SANTIAGO      ","","","L"
pdf.SetX(60)
pdf.Cell 135,0,dia_impresion,"","","L"
pdf.SetX(80)
pdf.Cell 115,0,mes_impresion,"","","L"
pdf.SetX(123)
pdf.Cell 73,0,anio_impresion,"","","L"
	pdf.ln(1)
pdf.Close()
pdf.Output()
%> 
