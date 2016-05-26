<%@language=vbscript%>
<!-- #include file = "../biblioteca/fpdf.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
saca_ncorr = Request.QueryString("saca_ncorr")
pers_ncorr = Request.QueryString("pers_ncorr")
tsca_ccod  = Request.QueryString("tsca_ccod")

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
 
set f_titulados = new CFormulario
f_titulados.Carga_Parametros "adm_titulados.xml", "titulados"
f_titulados.Inicializar conexion

SQL = "  select top 1 a.asca_ncorr, a.pers_ncorr, protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr, 'N') as nombre, "& vbCrLf &_
      "  a.asca_nregistro, a.asca_nfolio, SUBSTRING(LTRIM(RTRIM(cast(cast(a.asca_nnota AS decimal(2,1))AS varchar))), 1, CHARINDEX('.', LTRIM(RTRIM(cast(cast(a.asca_nnota AS decimal(2,1)) AS varchar)))) - 1) + '.' +  "& vbCrLf &_
      "  isnull(SUBSTRING(LTRIM(RTRIM(cast(cast(a.asca_nnota AS decimal(2,1))AS varchar))), CHARINDEX('.', LTRIM(RTRIM(cast(cast(a.asca_nnota AS decimal(2,1))AS varchar)))) + 1, 1),0) as asca_nnota, a.asca_fsalida, "& vbCrLf &_
 	  "	 a.peri_ccod, b.plan_ccod, a.sede_ccod, c.pers_nrut, c.pers_xdv, cast(a.asca_nnota AS decimal(2,1)) as nota_prueba,b.carr_ccod,  "& vbCrLf &_     
      "  cast(a.asca_nfolio as varchar) as folio_reg, linea_1_certificado as titulo_grado,linea_2_certificado as mencion,linea_3_certificado as mencion2,  "& vbCrLf &_
      "  '' + "& vbCrLf &_
      "   case  SUBSTRING(LTRIM(RTRIM(cast(cast(a.asca_nnota AS decimal(2,1))AS varchar))), 1, CHARINDEX('.', LTRIM(RTRIM(cast(cast(a.asca_nnota AS decimal(2,1)) AS varchar)))) - 1) "& vbCrLf &_
      "   when 1 then 'Uno' when 2 then 'Dos' when 3 then 'Tres' when 4 then 'Cuatro' when 5 then 'Cinco' when 6 then 'Seis' "& vbCrLf &_
      "   when 7 then 'Siete' end + '      ,     ' +  "& vbCrLf &_
      "   case isnull(SUBSTRING(LTRIM(RTRIM(cast(cast(a.asca_nnota AS decimal(2,1))AS varchar))), CHARINDEX('.', LTRIM(RTRIM(cast(cast(a.asca_nnota AS decimal(2,1))AS varchar)))) + 1, 1),0)  "& vbCrLf &_
      "   when 1 then 'Uno' when 2 then 'Dos' when 3 then 'Tres' when 4 then 'Cuatro' when 5 then 'Cinco' when 6 then 'Seis'  "& vbCrLf &_
      "   when 7 then 'Siete' when 8 then 'Ocho' when 9 then 'Nueve' when 0 then 'Cero' end + '' as en_palabras, "& vbCrLf &_
	  " case isnull(a.sede_ccod,1) when 1 then 'Santiago' when 2 then 'Santiago' when 8 then 'Santiago' when 9 then 'Santiago' "& vbCrLf &_
	  " when 4 then 'Melipilla' when 7 then 'Concepción' end as sede "& vbCrLf &_
	  " from alumnos_salidas_carrera a, salidas_carrera b, personas c "& vbCrLf &_
	  " where a.saca_ncorr = b.saca_ncorr  "& vbCrLf &_
   	  " and a.pers_ncorr = c.pers_ncorr  "& vbCrLf &_
      " and cast(a.saca_ncorr as varchar)='"&saca_ncorr&"' and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' "& vbCrLf &_
	  " order by nombre asc "

f_titulados.Consultar SQL
f_titulados.siguiente

nombre = f_titulados.obtenerValor("nombre")
rut = f_titulados.obtenerValor("rut")
titulo = f_titulados.obtenerValor("titulo_grado")
folio = f_titulados.obtenerValor("folio_reg")
nota = f_titulados.obtenerValor("asca_nnota")
fecha_origen = f_titulados.obtenerValor("asca_fsalida")
en_palabras = f_titulados.obtenerValor("en_palabras")
nota_prueba = f_titulados.obtenerValor("nota_prueba")
mencion1 = f_titulados.obtenerValor("mencion")
mencion2 = f_titulados.obtenerValor("mencion2")
carr_ccod = f_titulados.obtenerValor("carr_ccod")
pers_nrut = f_titulados.obtenerValor("pers_nrut")
texto_sede = f_titulados.obtenerValor("sede")

consulta_fecha = " select cast(datePart(day,getDate()) as varchar) " 				 
dia_impresion = conexion.consultaUno(consulta_fecha)

consulta_fecha = " select case datePart(month,getDate()) when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' " & vbCrLf &_
				 " when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' " & vbCrLf &_
				 " when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' end " 
mes_impresion = conexion.consultaUno(consulta_fecha)

consulta_fecha = " select cast(datePart(year,getDate()) as varchar) as fecha_01"				 
anio_impresion = conexion.consultaUno(consulta_fecha)

consulta_fecha = " select cast(datePart(day,'"&fecha_origen&"') as varchar)+ ' de ' + " & vbCrLf &_
				 " case datePart(month,'"&fecha_origen&"') when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' " & vbCrLf &_
				 " when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' " & vbCrLf &_
				 " when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' end + ' de ' +  " & vbCrLf &_
				 " cast(datePart(year,'"&fecha_origen&"') as varchar) as fecha_01"
fecha_titulacion = conexion.consultaUno(consulta_fecha)

'-------------------debemos sacar el año en que se titulo para ver a que distinción corresponde su nota.
anio_titulacion = conexion.consultaUno("select datePart(year,'"&fecha_origen&"')")

if anio_titulacion <= "2005" then
   if cdbl(nota_prueba) >= cdbl(4.0) and cdbl(nota_prueba) <= cdbl(4.9) then
   		equivale = "UNANIMIDAD"
    elseif cdbl(nota_prueba) >= cdbl(5.0) and cdbl(nota_prueba) <= cdbl(5.4) then
   		equivale = "UN VOTO DE DISTINCIÓN"
	elseif cdbl(nota_prueba) >= cdbl(5.5) and cdbl(nota_prueba) <= cdbl(5.9) then
   		equivale = "DOS VOTOS DE DISTINCIÓN"	
	elseif cdbl(nota_prueba) >= cdbl(6.0) and cdbl(nota_prueba) <= cdbl(6.4) then
   		equivale = "TRES VOTOS DE DISTINCIÓN"	 
    elseif cdbl(nota_prueba) >= cdbl(6.5) and cdbl(nota_prueba) <= cdbl(7.0) then
   		equivale = "APROBADO CON DISTINCIÓN MÁXIMA" 
   end if 
else
    'response.Write(cdbl(nota_prueba))
    if cdbl(nota_prueba) >= cdbl(4.0) and cdbl(nota_prueba) <= cdbl(4.9) then
   		equivale = "APROBADO POR UNANIMIDAD"
    elseif cdbl(nota_prueba) >= cdbl(5.0) and cdbl(nota_prueba) <= cdbl(5.9) then
   		equivale = "APROBADO CON DISTINCIÓN" 
    elseif cdbl(nota_prueba) >= cdbl(6.0) and cdbl(nota_prueba) <= cdbl(7.0) then
   		equivale = "APROBADO CON DISTINCIÓN MÁXIMA" 
   end if 
end if

tcar_ccod = conexion.consultaUno("select tcar_ccod from carreras where carr_ccod='"&carr_ccod&"'")
if tcar_ccod = "2" then 
	texto_oculto = "se otorgó el Grado Académico de"
else 
	texto_oculto = "se otorgó el Título de"
end if

'Cambiamos el tsca_ccod para titulos profesionales o grados académicos según los registros históricos
tipo = tsca_ccod
texto_tipo = ""
if tsca_ccod = "1" then
	tipo = "3"
	texto_tipo = "TÍTULO"
elseif tsca_ccod = "2" then
	tipo = "5" 
	texto_tipo = "TÍTULO"
elseif tsca_ccod = "3" then
	tipo = "4"
	texto_tipo = "GRADO ACADÉMICO"
elseif tsca_ccod = "4" then
	tipo = "6"
	texto_tipo = "TÍTULO SALIDA INTERMEDIA"
elseif tsca_ccod = "5" then
	tipo = "7"
	texto_tipo = "TÍTULO"
elseif tsca_ccod = "6" then
	tipo = "8"			
end if

'response.end()

espacio="                                       "
espacio2="    "
Set pdf=CreateJsObject("FPDF")
pdf.CreatePDF()
pdf.SetPath("../biblioteca/fpdf/" )
pdf.SetFont "times","",12
pdf.Open()
pdf.AddPage()

desY = 7 'variable que corre eje y hacia abajo

pdf.Image "../imagenes/fondo_tit.jpg", 20, 20, 175, 260, "JPG"
pdf.SetFont "times","",20
pdf.SetY(50-desY)
pdf.SetX(11.88)
pdf.Cell 0,0,"CERTIFICADO DE "&texto_tipo,"","","C"  
pdf.ln(5)
pdf.SetFont "times","",14
pdf.SetY(75-desY)
pdf.SetX(11.19)
pdf.Cell 0,0,"Certifico que, conforme a la Reglamentación de la Universidad, inscrita bajo el Folio C-N° 51","","","L"
pdf.ln(2)
pdf.SetFont "times","",14
pdf.SetY(85-desY)
pdf.SetX(11.19)
pdf.Cell 0,0,"del 31 de enero de 1990 del Ministerio de Educación, y según consta en el Expediente de","","","L"
	pdf.ln(2)
pdf.SetFont "times","",14
pdf.SetY(95-desY)
pdf.SetX(11.19)
pdf.Cell 0,0,"Titulación N° " & folio & " del Registro de Títulos y Grados correspondiente,","","","L" 
	pdf.ln(2) 	
pdf.SetFont "times","",14	
pdf.SetY(105-desY)
pdf.SetX(11.19)
pdf.Cell 0,1,"Con fecha         "&fecha_titulacion&"                                                    se otorgó el","","","L" 
	pdf.ln(2)
pdf.SetFont "times","",14
pdf.SetY(115-desY)
pdf.SetX(11.19)
pdf.Cell 0,1,"Título de    "&titulo,"","","L"
	pdf.ln(2)
pdf.SetY(125-desY)
pdf.SetX(11.19)
pdf.SetFont "times","",14
pdf.Cell 0,1,mencion1,"","","L"
    pdf.ln(2)
pdf.SetFont "times","",14
pdf.SetY(135-desY)
pdf.SetX(11.19)
pdf.Cell 0,1,"con calificación final de un   "&nota,"","","L"
	pdf.ln(2)
pdf.SetFont "times","",14
pdf.SetY(135-desY)
pdf.SetX(139.61)
pdf.Cell 180,1,"(   "&en_palabras&"  )","","","L"
	pdf.ln(2)
pdf.SetFont "times","",14
pdf.SetY(145-desY)
pdf.SetX(11.19)
pdf.Cell 0,1,"A Don  (ña)     "&nombre,"","","L"
    pdf.ln(2)
pdf.SetFont "times","",14
pdf.SetY(155-desY)
pdf.SetX(11.19)
pdf.Cell 0,1,"RUN:   "&nombre,"","","L"
pdf.ln(2)
pdf.SetFont "times","",14
pdf.SetY(165-desY)
pdf.SetX(11.19)
pdf.Cell 0,1,"Extendido como certificado borrador para se consultado por alumno o escuela.","","","L"
	pdf.ln(5)
pdf.SetFont "times","",14
pdf.SetY(269.5-18.5)
pdf.SetX(32.5)
pdf.Cell 180,0,texto_sede,"","","L"
pdf.SetX(52.5)
pdf.Cell 80,0,dia_impresion,"","","L"
pdf.SetX(60)
pdf.Cell 60,0,mes_impresion,"","","L"
pdf.SetX(83)
pdf.Cell 17,0,anio_impresion,"","","L"
	pdf.ln(1)
pdf.Close()
pdf.Output()
%> 
