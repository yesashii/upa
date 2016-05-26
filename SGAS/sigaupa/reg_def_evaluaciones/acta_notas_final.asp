<%@language=vbscript%>
<!-- #include file = "../biblioteca/fpdf.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%

'for each k in request.form
'	response.Write(k&" = "&request.form(k)&"<br>")
'next

secc_ccod = request.QueryString("secc_ccod")


sql = " Select asig_tdesc as asignatura, duas_tdesc as duracion, secc_tdesc as seccion, "& vbCrLf &_
	  "	isnull((select top 1 pers_tape_paterno + ' ' + pers_tape_materno + ' ' + pers_tnombre "& vbCrLf &_
	  "	 from bloques_horarios aa, bloques_profesores bb, personas cc "& vbCrLf &_
	  "	 where aa.secc_ccod=a.secc_ccod and aa.bloq_ccod=bb.bloq_ccod "& vbCrLf &_
	  "	 and bb.pers_ncorr=cc.pers_ncorr and bb.tpro_ccod=1), ' ') as profesor, "& vbCrLf &_
	  "	isnull((select top 1 protic.initCap(pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno) "& vbCrLf &_
	  "	 from bloques_horarios aa, bloques_profesores bb, personas cc "& vbCrLf &_
	  "	 where aa.secc_ccod=a.secc_ccod and aa.bloq_ccod=bb.bloq_ccod "& vbCrLf &_
	  "	 and bb.pers_ncorr=cc.pers_ncorr and bb.tpro_ccod=1),' ') as profesor_min, "& vbCrLf &_
	  "	carr_tdesc as carrera, "& vbCrLf &_
	  "	anos_ccod as anio, plec_ccod as periodo, "& vbCrLf &_
	  "	protic.trunc(getDate()) as fecha_impresion, "& vbCrLf &_
	  "	case isnull(estado_cierre_ccod,1) when 2 then 'ACTA FINAL' else 'ACTA FINAL PROVISORIA' end as titulo, "& vbCrLf &_
	  "	isnull((select protic.initCap(pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno) "& vbCrLf &_
	  "	 from cargos_carrera aa, personas bb "& vbCrLf &_
	  "	 where aa.sede_ccod=a.sede_ccod and aa.carr_ccod=a.carr_ccod and aa.jorn_ccod=a.jorn_ccod "& vbCrLf &_
	  "	 and aa.pers_ncorr=bb.pers_ncorr),' ') as director "& vbCrLf &_
	  "	from secciones a, asignaturas b, periodos_academicos c, carreras d, duracion_asignatura e "& vbCrLf &_
	  "	where a.asig_ccod=b.asig_ccod and a.peri_ccod=c.peri_ccod "& vbCrLf &_
	  "	and a.carr_ccod=d.carr_ccod and b.duas_ccod=e.duas_ccod "& vbCrLf &_
	  "	and cast(a.secc_ccod as varchar)='"&secc_ccod&"' "

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "tabla_vacia.xml", "tabla"
f_encabezado.Inicializar conexion
f_encabezado.Consultar sql
f_encabezado.siguiente
'response.Write("<pre>"&sql&"</pre>")
'response.End()

asignatura = f_encabezado.obtenerValor("asignatura")	
duracion = f_encabezado.obtenerValor("duracion")
seccion = f_encabezado.obtenerValor("seccion")
profesor = f_encabezado.obtenerValor("profesor")
profesor_min = f_encabezado.obtenerValor("profesor_min")
carrera = f_encabezado.obtenerValor("carrera")
anio = f_encabezado.obtenerValor("anio")
periodo = f_encabezado.obtenerValor("periodo")
fecha_impresion = f_encabezado.obtenerValor("fecha_impresion")
titulo = f_encabezado.obtenerValor("titulo")
director = f_encabezado.obtenerValor("director")

fecha_fotografia = conexion.consultaUno("select max(fecha_snapshot) from snapshot_cargas_academicas where cast(secc_ccod as varchar) = '"&secc_ccod&"'")

'-----------------------------------------------------------------------------------------------------------------------------------------------
'-----------------------------------------------------------------------------------------------------------------------------------------------

sql2 = " select cast(c.pers_nrut as varchar)+'-'+upper(c.pers_xdv) as RUT, "& vbCrLf &_
	   " upper(c.PERS_TAPE_PATERNO+' '+c.PERS_TAPE_MATERNO) as apellidos, "& vbCrLf &_
	   " upper(c.pers_tnombre) as nombres, "& vbCrLf &_
	   " case cast(isnull(carg_nasistencia,0) as varchar) when 0 then '0' else cast(carg_nasistencia as varchar) end as asistencia, "& vbCrLf &_
	   " isnull(cast(carg_nnota_final as varchar),' ') as nota_final, "& vbCrLf &_
	   " isnull(sitf_ccod,' ') as situacion   "& vbCrLf &_
	   " from snapshot_cargas_academicas a, alumnos b, personas c "& vbCrLf &_
	   " where a.matr_ncorr=b.matr_ncorr and b.pers_ncorr=c.pers_ncorr "& vbCrLf &_
	   " and cast(a.secc_ccod as varchar)='"&secc_ccod&"' "& vbCrLf &_
	   " order by apellidos, nombres "

'response.End()
set f_detalle = new CFormulario
f_detalle.Carga_Parametros "tabla_vacia.xml", "tabla"
f_detalle.Inicializar conexion
f_detalle.Consultar SQL2
'f_detalle.siguiente
cantidad_asignaturas = f_detalle.nroFilas
limite_hoja = 13
if cantidad_asignaturas <= 18 then
	limite_hoja = 18
elseif cantidad_asignaturas  > 18 then
	limite_hoja = 23
end if

espacio="                                       "
espacio2="    "
Set pdf=CreateJsObject("FPDF")
pdf.CreatePDF()
pdf.SetPath("../biblioteca/fpdf/" )
pdf.SetFont "times","",12
pdf.Open()
pdf.LoadModels("pie_actas") 
pdf.AddPage()

pdf.Image "imagenes_certificado/logo_upa_rojo_2011.jpg", 15, 15, 45, 17, "JPG"
	pdf.ln(25)
pdf.SetFont "times","B",14
pdf.Cell 180,1,"Universidad Del Pacífico","","","C" 
	pdf.ln(5)
pdf.SetFont "times","B",14
pdf.Cell 180,1,"REGISTRO CURRICULAR","","","C" 
	pdf.ln(10)
pdf.SetFont "times","B",16
pdf.Cell 180,1,"CARGA ACADEMICA AL "&fecha_fotografia,"","","C" 
	pdf.ln(10)
pdf.SetFont "times","",9
pdf.SetX(144)
pdf.Cell 180,0,"Fecha de Impresión","","","L"
pdf.SetX(170)
pdf.Cell 180,0,":","","","L"
pdf.SetX(172)
pdf.Cell 180,0,fecha_impresion,"","","L"
	pdf.ln(5)
pdf.SetFont "times","B",12
pdf.SetX(15)
pdf.Cell 180,0,"ASIGNATURA","","","L"
pdf.SetX(50)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(55)
pdf.Cell 180,0,asignatura,"","","L"
	pdf.ln(5)
pdf.SetFont "times","B",12
pdf.SetX(15)
pdf.Cell 180,0,"CARACTER","","","L"
pdf.SetX(50)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(55)
pdf.Cell 180,0,duracion,"","","L"
	pdf.ln(5)
pdf.SetFont "times","B",12
pdf.SetX(15)
pdf.Cell 180,0,"SECCIÓN","","","L"
pdf.SetX(50)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(55)
pdf.Cell 180,0,seccion,"","","L"
	pdf.ln(5)
pdf.SetFont "times","B",12
pdf.SetX(15)
pdf.Cell 180,0,"PROFESOR","","","L"
pdf.SetX(50)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(55)
pdf.Cell 180,0,profesor,"","","L"
	pdf.ln(5)
pdf.SetFont "times","B",12
pdf.SetX(15)
pdf.Cell 180,0,"CARRERA","","","L"
pdf.SetX(50)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(55)
pdf.Cell 180,0,carrera,"","","L"
	pdf.ln(5)
pdf.SetFont "times","B",12
pdf.SetX(15)
pdf.Cell 180,0,"AÑO","","","L"
pdf.SetX(50)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(55)
pdf.Cell 180,0,anio,"","","L"
pdf.SetX(85)
pdf.SetFont "times","B",12
pdf.Cell 180,0,"SEMESTRE","","","L"
pdf.SetX(110)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(115)
pdf.Cell 180,0,periodo,"","","L"

pdf.ln(5)
pdf.SetFont "times","B",10
pdf.SetFillColor(230) 

pdf.SetX(15)
pdf.Cell 10,4,"N°","","","L",true
pdf.SetX(25)
pdf.Cell 20,4,"R.U.T.","","","L",true
pdf.SetX(45)
pdf.Cell 50,4,"Nombres","","","L",true
pdf.SetX(95)
pdf.Cell 50,4,"Apellidos","","","L",true
pdf.SetX(145)
pdf.Cell 19,4,"Asistencia","","","L",true
pdf.SetX(164)
pdf.Cell 15,4,"Nota","","","L",true
pdf.SetX(179)
pdf.Cell 11,4,"Situa.","","","L",true
 pdf.ln(4)
pdf.SetX(15)
pdf.Cell 10,4,"","","","L",true
pdf.SetX(25)
pdf.Cell 20,4,"","","","L",true
pdf.SetX(45)
pdf.Cell 50,4,"","","","L",true
pdf.SetX(95)
pdf.Cell 50,4,"","","","L",true
pdf.SetX(145)
pdf.Cell 19,4,"","","","L",true
pdf.SetX(164)
pdf.Cell 15,4,"Final","","","L",true
pdf.SetX(179)
pdf.Cell 11,4,"Final","","","L",true
pdf.ln(3)
suma_notas = 0.0
total_asignaturas = 0
filas_impresas = 0
numero = 0
while f_detalle.siguiente
   rut = f_detalle.obtenerValor("RUT")
   apellidos = f_detalle.obtenerValor("apellidos")
   nombres = f_detalle.obtenerValor("nombres")
   asistencia  = f_detalle.obtenerValor("asistencia")
   nota_final = f_detalle.obtenerValor("nota_final")
   situacion = f_detalle.obtenerValor("situacion")
   filas_impresas = filas_impresas + 1
   numero = numero + 1

   if cantidad_asignaturas > 13 and filas_impresas > limite_hoja then
      filas_impresas = 0
	  limite_hoja = 25
	  pdf.AddPage()
	  pdf.Image "imagenes_certificado/logo_upa_rojo_2011.jpg", 15, 15, 45, 17, "JPG"
	  pdf.ln(25)
		pdf.SetFont "times","B",14
		pdf.Cell 180,1,"Universidad Del Pacífico","","","C" 
			pdf.ln(5)
		pdf.SetFont "times","B",14
		pdf.Cell 180,1,"REGISTRO CURRICULAR","","","C" 
			pdf.ln(10)
		pdf.SetFont "times","B",16
		pdf.Cell 180,1,"CARGA ACADEMICA AL "&fecha_fotografia,"","","C" 
			pdf.ln(10)
		pdf.SetFont "times","",9
		pdf.SetX(144)
		pdf.Cell 180,0,"Fecha de Impresión","","","L"
		pdf.SetX(170)
		pdf.Cell 180,0,":","","","L"
		pdf.SetX(172)
		pdf.Cell 180,0,fecha_impresion,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","B",12
		pdf.SetX(15)
		pdf.Cell 180,0,"ASIGNATURA","","","L"
		pdf.SetX(50)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(55)
		pdf.Cell 180,0,asignatura,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","B",12
		pdf.SetX(15)
		pdf.Cell 180,0,"CARACTER","","","L"
		pdf.SetX(50)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(55)
		pdf.Cell 180,0,duracion,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","B",12
		pdf.SetX(15)
		pdf.Cell 180,0,"SECCIÓN","","","L"
		pdf.SetX(50)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(55)
		pdf.Cell 180,0,seccion,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","B",12
		pdf.SetX(15)
		pdf.Cell 180,0,"PROFESOR","","","L"
		pdf.SetX(50)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(55)
		pdf.Cell 180,0,profesor,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","B",12
		pdf.SetX(15)
		pdf.Cell 180,0,"CARRERA","","","L"
		pdf.SetX(50)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(55)
		pdf.Cell 180,0,carrera,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","B",12
		pdf.SetX(15)
		pdf.Cell 180,0,"AÑO","","","L"
		pdf.SetX(50)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(55)
		pdf.Cell 180,0,anio,"","","L"
		pdf.SetX(85)
		pdf.SetFont "times","B",12
		pdf.Cell 180,0,"SEMESTRE","","","L"
		pdf.SetX(110)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(115)
		pdf.Cell 180,0,periodo,"","","L"
		
		pdf.ln(5)
		pdf.SetFont "times","B",10
		pdf.SetFillColor(230) 
		
		pdf.SetX(15)
		pdf.Cell 10,4,"N°","","","L",true
		pdf.SetX(25)
		pdf.Cell 20,4,"R.U.T.","","","L",true
		pdf.SetX(45)
		pdf.Cell 50,4,"Nombres","","","L",true
		pdf.SetX(95)
		pdf.Cell 50,4,"Apellidos","","","L",true
		pdf.SetX(145)
		pdf.Cell 19,4,"Asistencia","","","L",true
		pdf.SetX(164)
		pdf.Cell 15,4,"Nota","","","L",true
		pdf.SetX(179)
		pdf.Cell 11,4,"Situa.","","","L",true
		 pdf.ln(4)
		pdf.SetX(15)
		pdf.Cell 10,4,"","","","L",true
		pdf.SetX(25)
		pdf.Cell 20,4,"","","","L",true
		pdf.SetX(45)
		pdf.Cell 50,4,"","","","L",true
		pdf.SetX(95)
		pdf.Cell 50,4,"","","","L",true
		pdf.SetX(145)
		pdf.Cell 19,4,"","","","L",true
		pdf.SetX(164)
		pdf.Cell 15,4,"Final","","","L",true
		pdf.SetX(179)
		pdf.Cell 11,4,"Final","","","L",true
		pdf.ln(3)
   end if
   
	pdf.ln(5)
	pdf.SetFont "times","",9
	pdf.SetX(15)
	pdf.SetTextColor 186,186,186
	pdf.Cell 10,0,numero,"","","L",false
	pdf.SetTextColor 0,0,0
	pdf.SetX(25)
	pdf.Cell 20,0,rut,"","","L",false
	pdf.SetX(45)
	pdf.Cell 50,0,nombres,"","","L",false
	pdf.SetX(95)
	pdf.Cell 50,0,apellidos,"","","L",false
	pdf.SetX(150)
	pdf.Cell 14,0,asistencia,"","","L",false
	pdf.SetX(166)
	pdf.Cell 13,0,nota_final,"","","L",false
	pdf.SetX(181)
	pdf.Cell 9,0,situacion,"","","L",false
wend
    'response.Write(suma_notas&" / "&total_asignaturas)
if total_asignaturas = 0 then
	total_asignaturas = 1
end if	


pdf.SetY(-50)
pdf.SetFont "times","B",10
pdf.SetX(15)
pdf.Cell 63,0,"..........................................","","","C"  
pdf.SetX(78)
pdf.Cell 63,0,"..........................................","","","C"  
pdf.SetX(141)
pdf.Cell 63,0,"..........................................","","","C"   
pdf.SetY(-46)
pdf.SetFont "times","",10
pdf.SetX(15)
pdf.Cell 63,0,profesor_min,"","","C"  
pdf.SetX(78)
pdf.Cell 63,0,"Elena Ortúzar Muñoz","","","C"  
pdf.SetX(141)
pdf.Cell 63,0,director,"","","C" 
pdf.SetY(-42)
pdf.SetFont "times","",10
pdf.SetX(15)
pdf.Cell 63,0,"Docente","","","C"  
pdf.SetX(78)
pdf.Cell 63,0,"Secretaria General","","","C"  
pdf.SetX(141)
pdf.Cell 63,0,"Director Escuela","","","C" 
pdf.SetY(-38)
pdf.SetFont "times","",10
pdf.SetX(15)
pdf.Cell 63,0,"Universidad del Pacífico","","","C"  
pdf.SetX(78)
pdf.Cell 63,0,"Universidad del Pacífico","","","C"  
pdf.SetX(141)
pdf.Cell 63,0,"Universidad del Pacífico","","","C" 

'AHORA SE DEBEN SACAR LOS ALUMNOS QUE INGRESARON POSTERIORMENTE AL HORARIO
sql2 = " select cast(c.pers_nrut as varchar)+'-'+upper(c.pers_xdv) as RUT, "& vbCrLf &_
	   " upper(c.PERS_TAPE_PATERNO+' '+c.PERS_TAPE_MATERNO) as apellidos, "& vbCrLf &_
	   " upper(c.pers_tnombre) as nombres, "& vbCrLf &_
	   " case cast(isnull(carg_nasistencia,0) as varchar) when 0 then '0' else cast(carg_nasistencia as varchar) end as asistencia, "& vbCrLf &_
	   " isnull(cast(carg_nnota_final as varchar),' ') as nota_final, "& vbCrLf &_
	   " isnull(sitf_ccod,' ') as situacion   "& vbCrLf &_
	   " from cargas_academicas a (nolock), alumnos b(nolock), personas c(nolock) "& vbCrLf &_
	   " where a.matr_ncorr=b.matr_ncorr and b.pers_ncorr=c.pers_ncorr "& vbCrLf &_
	   " and cast(a.secc_ccod as varchar)='"&secc_ccod&"' "& vbCrLf &_
	   " and not exists (select 1 from snapshot_cargas_academicas tt where tt.matr_ncorr=a.matr_ncorr and tt.secc_ccod=a.secc_ccod) " & vbCrLf &_
	   " order by apellidos, nombres "

'response.End()
set f_detalle_nuevos = new CFormulario
f_detalle_nuevos.Carga_Parametros "tabla_vacia.xml", "tabla"
f_detalle_nuevos.Inicializar conexion
f_detalle_nuevos.Consultar SQL2
'f_detalle.siguiente
cantidad_asignaturas = f_detalle_nuevos.nroFilas
limite_hoja = 13
if cantidad_asignaturas <= 18 then
	limite_hoja = 18
elseif cantidad_asignaturas  > 18 then
	limite_hoja = 23
end if

pdf.AddPage()

pdf.Image "imagenes_certificado/logo_upa_rojo_2011.jpg", 15, 15, 45, 17, "JPG"
	pdf.ln(25)
pdf.SetFont "times","B",14
pdf.Cell 180,1,"Universidad Del Pacífico","","","C" 
	pdf.ln(5)
pdf.SetFont "times","B",14
pdf.Cell 180,1,"REGISTRO CURRICULAR","","","C" 
	pdf.ln(10)
pdf.SetFont "times","B",16
pdf.Cell 180,1,"RESUMEN ALUMNOS INGRESADOS POSTERIORMENTE","","","C" 
	pdf.ln(10)
pdf.SetFont "times","",9
pdf.SetX(144)
pdf.Cell 180,0,"Fecha de Impresión","","","L"
pdf.SetX(170)
pdf.Cell 180,0,":","","","L"
pdf.SetX(172)
pdf.Cell 180,0,fecha_impresion,"","","L"
	pdf.ln(5)
pdf.SetFont "times","B",12
pdf.SetX(15)
pdf.Cell 180,0,"ASIGNATURA","","","L"
pdf.SetX(50)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(55)
pdf.Cell 180,0,asignatura,"","","L"
	pdf.ln(5)
pdf.SetFont "times","B",12
pdf.SetX(15)
pdf.Cell 180,0,"CARACTER","","","L"
pdf.SetX(50)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(55)
pdf.Cell 180,0,duracion,"","","L"
	pdf.ln(5)
pdf.SetFont "times","B",12
pdf.SetX(15)
pdf.Cell 180,0,"SECCIÓN","","","L"
pdf.SetX(50)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(55)
pdf.Cell 180,0,seccion,"","","L"
	pdf.ln(5)
pdf.SetFont "times","B",12
pdf.SetX(15)
pdf.Cell 180,0,"PROFESOR","","","L"
pdf.SetX(50)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(55)
pdf.Cell 180,0,profesor,"","","L"
	pdf.ln(5)
pdf.SetFont "times","B",12
pdf.SetX(15)
pdf.Cell 180,0,"CARRERA","","","L"
pdf.SetX(50)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(55)
pdf.Cell 180,0,carrera,"","","L"
	pdf.ln(5)
pdf.SetFont "times","B",12
pdf.SetX(15)
pdf.Cell 180,0,"AÑO","","","L"
pdf.SetX(50)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(55)
pdf.Cell 180,0,anio,"","","L"
pdf.SetX(85)
pdf.SetFont "times","B",12
pdf.Cell 180,0,"SEMESTRE","","","L"
pdf.SetX(110)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(115)
pdf.Cell 180,0,periodo,"","","L"

pdf.ln(5)
pdf.SetFont "times","B",10
pdf.SetFillColor(230) 

pdf.SetX(15)
pdf.Cell 10,4,"N°","","","L",true
pdf.SetX(25)
pdf.Cell 20,4,"R.U.T.","","","L",true
pdf.SetX(45)
pdf.Cell 50,4,"Nombres","","","L",true
pdf.SetX(95)
pdf.Cell 50,4,"Apellidos","","","L",true
pdf.SetX(145)
pdf.Cell 19,4,"Asistencia","","","L",true
pdf.SetX(164)
pdf.Cell 15,4,"Nota","","","L",true
pdf.SetX(179)
pdf.Cell 11,4,"Situa.","","","L",true
 pdf.ln(4)
pdf.SetX(15)
pdf.Cell 10,4,"","","","L",true
pdf.SetX(25)
pdf.Cell 20,4,"","","","L",true
pdf.SetX(45)
pdf.Cell 50,4,"","","","L",true
pdf.SetX(95)
pdf.Cell 50,4,"","","","L",true
pdf.SetX(145)
pdf.Cell 19,4,"","","","L",true
pdf.SetX(164)
pdf.Cell 15,4,"Final","","","L",true
pdf.SetX(179)
pdf.Cell 11,4,"Final","","","L",true
pdf.ln(3)
suma_notas = 0.0
total_asignaturas = 0
filas_impresas = 0
numero = 0

while f_detalle_nuevos.siguiente
   rut = f_detalle_nuevos.obtenerValor("RUT")
   apellidos = f_detalle_nuevos.obtenerValor("apellidos")
   nombres = f_detalle_nuevos.obtenerValor("nombres")
   asistencia  = f_detalle_nuevos.obtenerValor("asistencia")
   nota_final = f_detalle_nuevos.obtenerValor("nota_final")
   situacion = f_detalle_nuevos.obtenerValor("situacion")
   filas_impresas = filas_impresas + 1
   numero = numero + 1

   if cantidad_asignaturas > 13 and filas_impresas > limite_hoja then
      filas_impresas = 0
	  limite_hoja = 25
	  pdf.AddPage()
	  pdf.Image "imagenes_certificado/logo_upa_rojo_2011.jpg", 15, 15, 45, 17, "JPG"
	  pdf.ln(25)
		pdf.SetFont "times","B",14
		pdf.Cell 180,1,"Universidad Del Pacífico","","","C" 
			pdf.ln(5)
		pdf.SetFont "times","B",14
		pdf.Cell 180,1,"REGISTRO CURRICULAR","","","C" 
			pdf.ln(10)
		pdf.SetFont "times","B",16
		pdf.Cell 180,1,"RESUMEN ALUMNOS INGRESADOS POSTERIORMENTE","","","C" 
			pdf.ln(10)
		pdf.SetFont "times","",9
		pdf.SetX(144)
		pdf.Cell 180,0,"Fecha de Impresión","","","L"
		pdf.SetX(170)
		pdf.Cell 180,0,":","","","L"
		pdf.SetX(172)
		pdf.Cell 180,0,fecha_impresion,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","B",12
		pdf.SetX(15)
		pdf.Cell 180,0,"ASIGNATURA","","","L"
		pdf.SetX(50)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(55)
		pdf.Cell 180,0,asignatura,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","B",12
		pdf.SetX(15)
		pdf.Cell 180,0,"CARACTER","","","L"
		pdf.SetX(50)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(55)
		pdf.Cell 180,0,duracion,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","B",12
		pdf.SetX(15)
		pdf.Cell 180,0,"SECCIÓN","","","L"
		pdf.SetX(50)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(55)
		pdf.Cell 180,0,seccion,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","B",12
		pdf.SetX(15)
		pdf.Cell 180,0,"PROFESOR","","","L"
		pdf.SetX(50)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(55)
		pdf.Cell 180,0,profesor,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","B",12
		pdf.SetX(15)
		pdf.Cell 180,0,"CARRERA","","","L"
		pdf.SetX(50)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(55)
		pdf.Cell 180,0,carrera,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","B",12
		pdf.SetX(15)
		pdf.Cell 180,0,"AÑO","","","L"
		pdf.SetX(50)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(55)
		pdf.Cell 180,0,anio,"","","L"
		pdf.SetX(85)
		pdf.SetFont "times","B",12
		pdf.Cell 180,0,"SEMESTRE","","","L"
		pdf.SetX(110)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(115)
		pdf.Cell 180,0,periodo,"","","L"
		
		pdf.ln(5)
		pdf.SetFont "times","B",10
		pdf.SetFillColor(230) 
		
		pdf.SetX(15)
		pdf.Cell 10,4,"N°","","","L",true
		pdf.SetX(25)
		pdf.Cell 20,4,"R.U.T.","","","L",true
		pdf.SetX(45)
		pdf.Cell 50,4,"Nombres","","","L",true
		pdf.SetX(95)
		pdf.Cell 50,4,"Apellidos","","","L",true
		pdf.SetX(145)
		pdf.Cell 19,4,"Asistencia","","","L",true
		pdf.SetX(164)
		pdf.Cell 15,4,"Nota","","","L",true
		pdf.SetX(179)
		pdf.Cell 11,4,"Situa.","","","L",true
		 pdf.ln(4)
		pdf.SetX(15)
		pdf.Cell 10,4,"","","","L",true
		pdf.SetX(25)
		pdf.Cell 20,4,"","","","L",true
		pdf.SetX(45)
		pdf.Cell 50,4,"","","","L",true
		pdf.SetX(95)
		pdf.Cell 50,4,"","","","L",true
		pdf.SetX(145)
		pdf.Cell 19,4,"","","","L",true
		pdf.SetX(164)
		pdf.Cell 15,4,"Final","","","L",true
		pdf.SetX(179)
		pdf.Cell 11,4,"Final","","","L",true
		pdf.ln(3)
   end if
	pdf.ln(5)
	pdf.SetFont "times","",9
	pdf.SetX(15)
	pdf.SetTextColor 186,186,186
	pdf.Cell 10,0,numero,"","","L",false
	pdf.SetTextColor 0,0,0
	pdf.SetX(25)
	pdf.Cell 20,0,rut,"","","L",false
	pdf.SetX(45)
	pdf.Cell 50,0,nombres,"","","L",false
	pdf.SetX(95)
	pdf.Cell 50,0,apellidos,"","","L",false
	pdf.SetX(150)
	pdf.Cell 14,0,asistencia,"","","L",false
	pdf.SetX(166)
	pdf.Cell 13,0,nota_final,"","","L",false
	pdf.SetX(181)
	pdf.Cell 9,0,situacion,"","","L",false
wend
    'response.Write(suma_notas&" / "&total_asignaturas)
if total_asignaturas = 0 then
	total_asignaturas = 1
end if	

pdf.SetY(-50)
pdf.SetFont "times","B",10
pdf.SetX(15)
pdf.Cell 63,0,"..........................................","","","C"  
pdf.SetX(78)
pdf.Cell 63,0,"..........................................","","","C"  
pdf.SetX(141)
pdf.Cell 63,0,"..........................................","","","C"   
pdf.SetY(-46)
pdf.SetFont "times","",10
pdf.SetX(15)
pdf.Cell 63,0,profesor_min,"","","C"  
pdf.SetX(78)
pdf.Cell 63,0,"Elena Ortúzar Muñoz","","","C"  
pdf.SetX(141)
pdf.Cell 63,0,director,"","","C" 
pdf.SetY(-42)
pdf.SetFont "times","",10
pdf.SetX(15)
pdf.Cell 63,0,"Docente","","","C"  
pdf.SetX(78)
pdf.Cell 63,0,"Secretaria General","","","C"  
pdf.SetX(141)
pdf.Cell 63,0,"Director Escuela","","","C" 
pdf.SetY(-38)
pdf.SetFont "times","",10
pdf.SetX(15)
pdf.Cell 63,0,"Universidad del Pacífico","","","C"  
pdf.SetX(78)
pdf.Cell 63,0,"Universidad del Pacífico","","","C"  
pdf.SetX(141)
pdf.Cell 63,0,"Universidad del Pacífico","","","C" 

'AHORA SE DEBEN SACAR LOS ALUMNOS QUE MODIFICARON ASISTENCIA, NOTA O SITUACION
sql2 = " select cast(c.pers_nrut as varchar)+'-'+upper(c.pers_xdv) as RUT, "& vbCrLf &_
	   " upper(c.PERS_TAPE_PATERNO+' '+c.PERS_TAPE_MATERNO) as apellidos, "& vbCrLf &_
	   " upper(c.pers_tnombre) as nombres, "& vbCrLf &_
	   " case cast(isnull(carg_nasistencia,0) as varchar) when 0 then '0' else cast(carg_nasistencia as varchar) end as asistencia, "& vbCrLf &_
	   " isnull(cast(carg_nnota_final as varchar),' ') as nota_final, "& vbCrLf &_
	   " isnull(sitf_ccod,' ') as situacion   "& vbCrLf &_
	   " from cargas_academicas a (nolock), alumnos b(nolock), personas c(nolock) "& vbCrLf &_
	   " where a.matr_ncorr=b.matr_ncorr and b.pers_ncorr=c.pers_ncorr "& vbCrLf &_
	   " and cast(a.secc_ccod as varchar)='"&secc_ccod&"' "& vbCrLf &_
	   " and exists (select 1 from snapshot_cargas_academicas tt where tt.matr_ncorr=a.matr_ncorr and tt.secc_ccod=a.secc_ccod "& vbCrLf &_
	   "              and (isnull(tt.carg_nasistencia,0) <> isnull(a.carg_nasistencia,0) or isnull(tt.carg_nnota_final,0.0) <> isnull(a.carg_nnota_final,0.0) or isnull(tt.sitf_ccod,'PE') <> isnull(a.sitf_ccod,'PE') ) ) " & vbCrLf &_
	   " order by apellidos, nombres "

'response.End()
set f_detalle_cambios = new CFormulario
f_detalle_cambios.Carga_Parametros "tabla_vacia.xml", "tabla"
f_detalle_cambios.Inicializar conexion
f_detalle_cambios.Consultar SQL2
'f_detalle.siguiente
cantidad_asignaturas = f_detalle_cambios.nroFilas
limite_hoja = 13
if cantidad_asignaturas <= 18 then
	limite_hoja = 18
elseif cantidad_asignaturas  > 18 then
	limite_hoja = 23
end if

pdf.AddPage()

pdf.Image "imagenes_certificado/logo_upa_rojo_2011.jpg", 15, 15, 45, 17, "JPG"
	pdf.ln(25)
pdf.SetFont "times","B",14
pdf.Cell 180,1,"Universidad Del Pacífico","","","C" 
	pdf.ln(5)
pdf.SetFont "times","B",14
pdf.Cell 180,1,"REGISTRO CURRICULAR","","","C" 
	pdf.ln(10)
pdf.SetFont "times","B",16
pdf.Cell 180,1,"RESUMEN ALUMNOS MODIFICADOS","","","C" 
	pdf.ln(10)
pdf.SetFont "times","",9
pdf.SetX(144)
pdf.Cell 180,0,"Fecha de Impresión","","","L"
pdf.SetX(170)
pdf.Cell 180,0,":","","","L"
pdf.SetX(172)
pdf.Cell 180,0,fecha_impresion,"","","L"
	pdf.ln(5)
pdf.SetFont "times","B",12
pdf.SetX(15)
pdf.Cell 180,0,"ASIGNATURA","","","L"
pdf.SetX(50)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(55)
pdf.Cell 180,0,asignatura,"","","L"
	pdf.ln(5)
pdf.SetFont "times","B",12
pdf.SetX(15)
pdf.Cell 180,0,"CARACTER","","","L"
pdf.SetX(50)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(55)
pdf.Cell 180,0,duracion,"","","L"
	pdf.ln(5)
pdf.SetFont "times","B",12
pdf.SetX(15)
pdf.Cell 180,0,"SECCIÓN","","","L"
pdf.SetX(50)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(55)
pdf.Cell 180,0,seccion,"","","L"
	pdf.ln(5)
pdf.SetFont "times","B",12
pdf.SetX(15)
pdf.Cell 180,0,"PROFESOR","","","L"
pdf.SetX(50)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(55)
pdf.Cell 180,0,profesor,"","","L"
	pdf.ln(5)
pdf.SetFont "times","B",12
pdf.SetX(15)
pdf.Cell 180,0,"CARRERA","","","L"
pdf.SetX(50)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(55)
pdf.Cell 180,0,carrera,"","","L"
	pdf.ln(5)
pdf.SetFont "times","B",12
pdf.SetX(15)
pdf.Cell 180,0,"AÑO","","","L"
pdf.SetX(50)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(55)
pdf.Cell 180,0,anio,"","","L"
pdf.SetX(85)
pdf.SetFont "times","B",12
pdf.Cell 180,0,"SEMESTRE","","","L"
pdf.SetX(110)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(115)
pdf.Cell 180,0,periodo,"","","L"

pdf.ln(5)
pdf.SetFont "times","B",10
pdf.SetFillColor(230) 

pdf.SetX(15)
pdf.Cell 10,4,"N°","","","L",true
pdf.SetX(25)
pdf.Cell 20,4,"R.U.T.","","","L",true
pdf.SetX(45)
pdf.Cell 50,4,"Nombres","","","L",true
pdf.SetX(95)
pdf.Cell 50,4,"Apellidos","","","L",true
pdf.SetX(145)
pdf.Cell 19,4,"Asistencia","","","L",true
pdf.SetX(164)
pdf.Cell 15,4,"Nota","","","L",true
pdf.SetX(179)
pdf.Cell 11,4,"Situa.","","","L",true
 pdf.ln(4)
pdf.SetX(15)
pdf.Cell 10,4,"","","","L",true
pdf.SetX(25)
pdf.Cell 20,4,"","","","L",true
pdf.SetX(45)
pdf.Cell 50,4,"","","","L",true
pdf.SetX(95)
pdf.Cell 50,4,"","","","L",true
pdf.SetX(145)
pdf.Cell 19,4,"","","","L",true
pdf.SetX(164)
pdf.Cell 15,4,"Final","","","L",true
pdf.SetX(179)
pdf.Cell 11,4,"Final","","","L",true
pdf.ln(3)
suma_notas = 0.0
total_asignaturas = 0
filas_impresas = 0
numero = 0

while f_detalle_cambios.siguiente
   rut = f_detalle_cambios.obtenerValor("RUT")
   apellidos = f_detalle_cambios.obtenerValor("apellidos")
   nombres = f_detalle_cambios.obtenerValor("nombres")
   asistencia  = f_detalle_cambios.obtenerValor("asistencia")
   nota_final = f_detalle_cambios.obtenerValor("nota_final")
   situacion = f_detalle_cambios.obtenerValor("situacion")
   filas_impresas = filas_impresas + 1
   numero = numero + 1

   if cantidad_asignaturas > 13 and filas_impresas > limite_hoja then
      filas_impresas = 0
	  limite_hoja = 25
	  pdf.AddPage()
	  pdf.Image "imagenes_certificado/logo_upa_rojo_2011.jpg", 15, 15, 45, 17, "JPG"
	  pdf.ln(25)
		pdf.SetFont "times","B",14
		pdf.Cell 180,1,"Universidad Del Pacífico","","","C" 
			pdf.ln(5)
		pdf.SetFont "times","B",14
		pdf.Cell 180,1,"REGISTRO CURRICULAR","","","C" 
			pdf.ln(10)
		pdf.SetFont "times","B",16
		pdf.Cell 180,1,"RESUMEN ALUMNOS MODIFICADOS","","","C" 
			pdf.ln(10)
		pdf.SetFont "times","",9
		pdf.SetX(144)
		pdf.Cell 180,0,"Fecha de Impresión","","","L"
		pdf.SetX(170)
		pdf.Cell 180,0,":","","","L"
		pdf.SetX(172)
		pdf.Cell 180,0,fecha_impresion,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","B",12
		pdf.SetX(15)
		pdf.Cell 180,0,"ASIGNATURA","","","L"
		pdf.SetX(50)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(55)
		pdf.Cell 180,0,asignatura,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","B",12
		pdf.SetX(15)
		pdf.Cell 180,0,"CARACTER","","","L"
		pdf.SetX(50)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(55)
		pdf.Cell 180,0,duracion,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","B",12
		pdf.SetX(15)
		pdf.Cell 180,0,"SECCIÓN","","","L"
		pdf.SetX(50)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(55)
		pdf.Cell 180,0,seccion,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","B",12
		pdf.SetX(15)
		pdf.Cell 180,0,"PROFESOR","","","L"
		pdf.SetX(50)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(55)
		pdf.Cell 180,0,profesor,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","B",12
		pdf.SetX(15)
		pdf.Cell 180,0,"CARRERA","","","L"
		pdf.SetX(50)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(55)
		pdf.Cell 180,0,carrera,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","B",12
		pdf.SetX(15)
		pdf.Cell 180,0,"AÑO","","","L"
		pdf.SetX(50)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(55)
		pdf.Cell 180,0,anio,"","","L"
		pdf.SetX(85)
		pdf.SetFont "times","B",12
		pdf.Cell 180,0,"SEMESTRE","","","L"
		pdf.SetX(110)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(115)
		pdf.Cell 180,0,periodo,"","","L"
		
		pdf.ln(5)
		pdf.SetFont "times","B",10
		pdf.SetFillColor(230) 
		
		pdf.SetX(15)
		pdf.Cell 10,4,"N°","","","L",true
		pdf.SetX(25)
		pdf.Cell 20,4,"R.U.T.","","","L",true
		pdf.SetX(45)
		pdf.Cell 50,4,"Nombres","","","L",true
		pdf.SetX(95)
		pdf.Cell 50,4,"Apellidos","","","L",true
		pdf.SetX(145)
		pdf.Cell 19,4,"Asistencia","","","L",true
		pdf.SetX(164)
		pdf.Cell 15,4,"Nota","","","L",true
		pdf.SetX(179)
		pdf.Cell 11,4,"Situa.","","","L",true
		 pdf.ln(4)
		pdf.SetX(15)
		pdf.Cell 10,4,"","","","L",true
		pdf.SetX(25)
		pdf.Cell 20,4,"","","","L",true
		pdf.SetX(45)
		pdf.Cell 50,4,"","","","L",true
		pdf.SetX(95)
		pdf.Cell 50,4,"","","","L",true
		pdf.SetX(145)
		pdf.Cell 19,4,"","","","L",true
		pdf.SetX(164)
		pdf.Cell 15,4,"Final","","","L",true
		pdf.SetX(179)
		pdf.Cell 11,4,"Final","","","L",true
		pdf.ln(3)
   end if
	pdf.ln(5)
	pdf.SetFont "times","",9
	pdf.SetX(15)
	pdf.SetTextColor 186,186,186
	pdf.Cell 10,0,numero,"","","L",false
	pdf.SetTextColor 0,0,0
	pdf.SetX(25)
	pdf.Cell 20,0,rut,"","","L",false
	pdf.SetX(45)
	pdf.Cell 50,0,nombres,"","","L",false
	pdf.SetX(95)
	pdf.Cell 50,0,apellidos,"","","L",false
	pdf.SetX(150)
	pdf.Cell 14,0,asistencia,"","","L",false
	pdf.SetX(166)
	pdf.Cell 13,0,nota_final,"","","L",false
	pdf.SetX(181)
	pdf.Cell 9,0,situacion,"","","L",false
wend
    'response.Write(suma_notas&" / "&total_asignaturas)
if total_asignaturas = 0 then
	total_asignaturas = 1
end if	

pdf.SetY(-50)
pdf.SetFont "times","B",10
pdf.SetX(15)
pdf.Cell 63,0,"..........................................","","","C"  
pdf.SetX(78)
pdf.Cell 63,0,"..........................................","","","C"  
pdf.SetX(141)
pdf.Cell 63,0,"..........................................","","","C"   
pdf.SetY(-46)
pdf.SetFont "times","",10
pdf.SetX(15)
pdf.Cell 63,0,profesor_min,"","","C"  
pdf.SetX(78)
pdf.Cell 63,0,"Elena Ortúzar Muñoz","","","C"  
pdf.SetX(141)
pdf.Cell 63,0,director,"","","C" 
pdf.SetY(-42)
pdf.SetFont "times","",10
pdf.SetX(15)
pdf.Cell 63,0,"Docente","","","C"  
pdf.SetX(78)
pdf.Cell 63,0,"Secretaria General","","","C"  
pdf.SetX(141)
pdf.Cell 63,0,"Director Escuela","","","C" 
pdf.SetY(-38)
pdf.SetFont "times","",10
pdf.SetX(15)
pdf.Cell 63,0,"Universidad del Pacífico","","","C"  
pdf.SetX(78)
pdf.Cell 63,0,"Universidad del Pacífico","","","C"  
pdf.SetX(141)
pdf.Cell 63,0,"Universidad del Pacífico","","","C" 


'AHORA SE DEBEN SACAR LOS ALUMNOS QUE fueron eliminados
sql2 = " select cast(c.pers_nrut as varchar)+'-'+upper(c.pers_xdv) as RUT, "& vbCrLf &_
	   " upper(c.PERS_TAPE_PATERNO+' '+c.PERS_TAPE_MATERNO) as apellidos, "& vbCrLf &_
	   " upper(c.pers_tnombre) as nombres, "& vbCrLf &_
	   " case cast(isnull(carg_nasistencia,0) as varchar) when 0 then '0' else cast(carg_nasistencia as varchar) end as asistencia, "& vbCrLf &_
	   " isnull(cast(carg_nnota_final as varchar),' ') as nota_final, "& vbCrLf &_
	   " isnull(sitf_ccod,' ') as situacion   "& vbCrLf &_
	   " from snapshot_cargas_academicas a (nolock), alumnos b(nolock), personas c(nolock) "& vbCrLf &_
	   " where a.matr_ncorr=b.matr_ncorr and b.pers_ncorr=c.pers_ncorr "& vbCrLf &_
	   " and cast(a.secc_ccod as varchar)='"&secc_ccod&"' "& vbCrLf &_
	   " and not exists (select 1 from cargas_academicas tt where tt.matr_ncorr=a.matr_ncorr and tt.secc_ccod=a.secc_ccod ) " & vbCrLf &_
	   " order by apellidos, nombres "

'response.End()
set f_detalle_eliminados = new CFormulario
f_detalle_eliminados.Carga_Parametros "tabla_vacia.xml", "tabla"
f_detalle_eliminados.Inicializar conexion
f_detalle_eliminados.Consultar SQL2
'f_detalle.siguiente
cantidad_asignaturas = f_detalle_eliminados.nroFilas
limite_hoja = 13
if cantidad_asignaturas <= 18 then
	limite_hoja = 18
elseif cantidad_asignaturas  > 18 then
	limite_hoja = 23
end if

pdf.AddPage()

pdf.Image "imagenes_certificado/logo_upa_rojo_2011.jpg", 15, 15, 45, 17, "JPG"
	pdf.ln(25)
pdf.SetFont "times","B",14
pdf.Cell 180,1,"Universidad Del Pacífico","","","C" 
	pdf.ln(5)
pdf.SetFont "times","B",14
pdf.Cell 180,1,"REGISTRO CURRICULAR","","","C" 
	pdf.ln(10)
pdf.SetFont "times","B",16
pdf.Cell 180,1,"RESUMEN ALUMNOS ELIMINADOS","","","C" 
	pdf.ln(10)
pdf.SetFont "times","",9
pdf.SetX(144)
pdf.Cell 180,0,"Fecha de Impresión","","","L"
pdf.SetX(170)
pdf.Cell 180,0,":","","","L"
pdf.SetX(172)
pdf.Cell 180,0,fecha_impresion,"","","L"
	pdf.ln(5)
pdf.SetFont "times","B",12
pdf.SetX(15)
pdf.Cell 180,0,"ASIGNATURA","","","L"
pdf.SetX(50)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(55)
pdf.Cell 180,0,asignatura,"","","L"
	pdf.ln(5)
pdf.SetFont "times","B",12
pdf.SetX(15)
pdf.Cell 180,0,"CARACTER","","","L"
pdf.SetX(50)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(55)
pdf.Cell 180,0,duracion,"","","L"
	pdf.ln(5)
pdf.SetFont "times","B",12
pdf.SetX(15)
pdf.Cell 180,0,"SECCIÓN","","","L"
pdf.SetX(50)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(55)
pdf.Cell 180,0,seccion,"","","L"
	pdf.ln(5)
pdf.SetFont "times","B",12
pdf.SetX(15)
pdf.Cell 180,0,"PROFESOR","","","L"
pdf.SetX(50)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(55)
pdf.Cell 180,0,profesor,"","","L"
	pdf.ln(5)
pdf.SetFont "times","B",12
pdf.SetX(15)
pdf.Cell 180,0,"CARRERA","","","L"
pdf.SetX(50)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(55)
pdf.Cell 180,0,carrera,"","","L"
	pdf.ln(5)
pdf.SetFont "times","B",12
pdf.SetX(15)
pdf.Cell 180,0,"AÑO","","","L"
pdf.SetX(50)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(55)
pdf.Cell 180,0,anio,"","","L"
pdf.SetX(85)
pdf.SetFont "times","B",12
pdf.Cell 180,0,"SEMESTRE","","","L"
pdf.SetX(110)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(115)
pdf.Cell 180,0,periodo,"","","L"

pdf.ln(5)
pdf.SetFont "times","B",10
pdf.SetFillColor(230) 

pdf.SetX(15)
pdf.Cell 10,4,"N°","","","L",true
pdf.SetX(25)
pdf.Cell 20,4,"R.U.T.","","","L",true
pdf.SetX(45)
pdf.Cell 50,4,"Nombres","","","L",true
pdf.SetX(95)
pdf.Cell 50,4,"Apellidos","","","L",true
pdf.SetX(145)
pdf.Cell 19,4,"Asistencia","","","L",true
pdf.SetX(164)
pdf.Cell 15,4,"Nota","","","L",true
pdf.SetX(179)
pdf.Cell 11,4,"Situa.","","","L",true
 pdf.ln(4)
pdf.SetX(15)
pdf.Cell 10,4,"","","","L",true
pdf.SetX(25)
pdf.Cell 20,4,"","","","L",true
pdf.SetX(45)
pdf.Cell 50,4,"","","","L",true
pdf.SetX(95)
pdf.Cell 50,4,"","","","L",true
pdf.SetX(145)
pdf.Cell 19,4,"","","","L",true
pdf.SetX(164)
pdf.Cell 15,4,"Final","","","L",true
pdf.SetX(179)
pdf.Cell 11,4,"Final","","","L",true
pdf.ln(3)
suma_notas = 0.0
total_asignaturas = 0
filas_impresas = 0
numero = 0

while f_detalle_eliminados.siguiente
   rut = f_detalle_eliminados.obtenerValor("RUT")
   apellidos = f_detalle_eliminados.obtenerValor("apellidos")
   nombres = f_detalle_eliminados.obtenerValor("nombres")
   asistencia  = f_detalle_eliminados.obtenerValor("asistencia")
   nota_final = f_detalle_eliminados.obtenerValor("nota_final")
   situacion = f_detalle_eliminados.obtenerValor("situacion")
   filas_impresas = filas_impresas + 1
   numero = numero + 1

   if cantidad_asignaturas > 13 and filas_impresas > limite_hoja then
      filas_impresas = 0
	  limite_hoja = 25
	  pdf.AddPage()
	  pdf.Image "imagenes_certificado/logo_upa_rojo_2011.jpg", 15, 15, 45, 17, "JPG"
	  pdf.ln(25)
		pdf.SetFont "times","B",14
		pdf.Cell 180,1,"Universidad Del Pacífico","","","C" 
			pdf.ln(5)
		pdf.SetFont "times","B",14
		pdf.Cell 180,1,"REGISTRO CURRICULAR","","","C" 
			pdf.ln(10)
		pdf.SetFont "times","B",16
		pdf.Cell 180,1,"RESUMEN ALUMNOS ELIMINADOS","","","C" 
			pdf.ln(10)
		pdf.SetFont "times","",9
		pdf.SetX(144)
		pdf.Cell 180,0,"Fecha de Impresión","","","L"
		pdf.SetX(170)
		pdf.Cell 180,0,":","","","L"
		pdf.SetX(172)
		pdf.Cell 180,0,fecha_impresion,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","B",12
		pdf.SetX(15)
		pdf.Cell 180,0,"ASIGNATURA","","","L"
		pdf.SetX(50)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(55)
		pdf.Cell 180,0,asignatura,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","B",12
		pdf.SetX(15)
		pdf.Cell 180,0,"CARACTER","","","L"
		pdf.SetX(50)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(55)
		pdf.Cell 180,0,duracion,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","B",12
		pdf.SetX(15)
		pdf.Cell 180,0,"SECCIÓN","","","L"
		pdf.SetX(50)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(55)
		pdf.Cell 180,0,seccion,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","B",12
		pdf.SetX(15)
		pdf.Cell 180,0,"PROFESOR","","","L"
		pdf.SetX(50)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(55)
		pdf.Cell 180,0,profesor,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","B",12
		pdf.SetX(15)
		pdf.Cell 180,0,"CARRERA","","","L"
		pdf.SetX(50)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(55)
		pdf.Cell 180,0,carrera,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","B",12
		pdf.SetX(15)
		pdf.Cell 180,0,"AÑO","","","L"
		pdf.SetX(50)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(55)
		pdf.Cell 180,0,anio,"","","L"
		pdf.SetX(85)
		pdf.SetFont "times","B",12
		pdf.Cell 180,0,"SEMESTRE","","","L"
		pdf.SetX(110)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(115)
		pdf.Cell 180,0,periodo,"","","L"
		
		pdf.ln(5)
		pdf.SetFont "times","B",10
		pdf.SetFillColor(230) 
		
		pdf.SetX(15)
		pdf.Cell 10,4,"N°","","","L",true
		pdf.SetX(25)
		pdf.Cell 20,4,"R.U.T.","","","L",true
		pdf.SetX(45)
		pdf.Cell 50,4,"Nombres","","","L",true
		pdf.SetX(95)
		pdf.Cell 50,4,"Apellidos","","","L",true
		pdf.SetX(145)
		pdf.Cell 19,4,"Asistencia","","","L",true
		pdf.SetX(164)
		pdf.Cell 15,4,"Nota","","","L",true
		pdf.SetX(179)
		pdf.Cell 11,4,"Situa.","","","L",true
		 pdf.ln(4)
		pdf.SetX(15)
		pdf.Cell 10,4,"","","","L",true
		pdf.SetX(25)
		pdf.Cell 20,4,"","","","L",true
		pdf.SetX(45)
		pdf.Cell 50,4,"","","","L",true
		pdf.SetX(95)
		pdf.Cell 50,4,"","","","L",true
		pdf.SetX(145)
		pdf.Cell 19,4,"","","","L",true
		pdf.SetX(164)
		pdf.Cell 15,4,"Final","","","L",true
		pdf.SetX(179)
		pdf.Cell 11,4,"Final","","","L",true
		pdf.ln(3)
   end if
	pdf.ln(5)
	pdf.SetFont "times","",9
	pdf.SetX(15)
	pdf.SetTextColor 186,186,186
	pdf.Cell 10,0,numero,"","","L",false
	pdf.SetTextColor 0,0,0
	pdf.SetX(25)
	pdf.Cell 20,0,rut,"","","L",false
	pdf.SetX(45)
	pdf.Cell 50,0,nombres,"","","L",false
	pdf.SetX(95)
	pdf.Cell 50,0,apellidos,"","","L",false
	pdf.SetX(150)
	pdf.Cell 14,0,asistencia,"","","L",false
	pdf.SetX(166)
	pdf.Cell 13,0,nota_final,"","","L",false
	pdf.SetX(181)
	pdf.Cell 9,0,situacion,"","","L",false
wend
    'response.Write(suma_notas&" / "&total_asignaturas)
if total_asignaturas = 0 then
	total_asignaturas = 1
end if	

pdf.SetY(-50)
pdf.SetFont "times","B",10
pdf.SetX(15)
pdf.Cell 63,0,"..........................................","","","C"  
pdf.SetX(78)
pdf.Cell 63,0,"..........................................","","","C"  
pdf.SetX(141)
pdf.Cell 63,0,"..........................................","","","C"   
pdf.SetY(-46)
pdf.SetFont "times","",10
pdf.SetX(15)
pdf.Cell 63,0,profesor_min,"","","C"  
pdf.SetX(78)
pdf.Cell 63,0,"Elena Ortúzar Muñoz","","","C"  
pdf.SetX(141)
pdf.Cell 63,0,director,"","","C" 
pdf.SetY(-42)
pdf.SetFont "times","",10
pdf.SetX(15)
pdf.Cell 63,0,"Docente","","","C"  
pdf.SetX(78)
pdf.Cell 63,0,"Secretaria General","","","C"  
pdf.SetX(141)
pdf.Cell 63,0,"Director Escuela","","","C" 
pdf.SetY(-38)
pdf.SetFont "times","",10
pdf.SetX(15)
pdf.Cell 63,0,"Universidad del Pacífico","","","C"  
pdf.SetX(78)
pdf.Cell 63,0,"Universidad del Pacífico","","","C"  
pdf.SetX(141)
pdf.Cell 63,0,"Universidad del Pacífico","","","C" 

'AHORA SE DEBEN SACAR LOS ALUMNOS QUE MODIFICARON ASISTENCIA, NOTA O SITUACION
sql2 = " select cast(c.pers_nrut as varchar)+'-'+upper(c.pers_xdv) as RUT, "& vbCrLf &_
	   " upper(c.PERS_TAPE_PATERNO+' '+c.PERS_TAPE_MATERNO) as apellidos, "& vbCrLf &_
	   " upper(c.pers_tnombre) as nombres, "& vbCrLf &_
	   " case cast(isnull(carg_nasistencia,0) as varchar) when 0 then '0' else cast(carg_nasistencia as varchar) end as asistencia, "& vbCrLf &_
	   " isnull(cast(carg_nnota_final as varchar),' ') as nota_final, "& vbCrLf &_
	   " isnull(sitf_ccod,' ') as situacion   "& vbCrLf &_
	   " from cargas_academicas a (nolock), alumnos b(nolock), personas c(nolock) "& vbCrLf &_
	   " where a.matr_ncorr=b.matr_ncorr and b.pers_ncorr=c.pers_ncorr "& vbCrLf &_
	   " and cast(a.secc_ccod as varchar)='"&secc_ccod&"' "& vbCrLf &_
	   " order by apellidos, nombres "

'response.End()
set f_detalle_final = new CFormulario
f_detalle_final.Carga_Parametros "tabla_vacia.xml", "tabla"
f_detalle_final.Inicializar conexion
f_detalle_final.Consultar SQL2
'f_detalle.siguiente
cantidad_asignaturas = f_detalle_final.nroFilas
limite_hoja = 13
if cantidad_asignaturas <= 18 then
	limite_hoja = 18
elseif cantidad_asignaturas  > 18 then
	limite_hoja = 23
end if

pdf.AddPage()

pdf.Image "imagenes_certificado/logo_upa_rojo_2011.jpg", 15, 15, 45, 17, "JPG"
	pdf.ln(25)
pdf.SetFont "times","B",14
pdf.Cell 180,1,"Universidad Del Pacífico","","","C" 
	pdf.ln(5)
pdf.SetFont "times","B",14
pdf.Cell 180,1,"REGISTRO CURRICULAR","","","C" 
	pdf.ln(10)
pdf.SetFont "times","B",16
pdf.Cell 180,1,titulo,"","","C" 
	pdf.ln(10)
pdf.SetFont "times","",9
pdf.SetX(144)
pdf.Cell 180,0,"Fecha de Impresión","","","L"
pdf.SetX(170)
pdf.Cell 180,0,":","","","L"
pdf.SetX(172)
pdf.Cell 180,0,fecha_impresion,"","","L"
	pdf.ln(5)
pdf.SetFont "times","B",12
pdf.SetX(15)
pdf.Cell 180,0,"ASIGNATURA","","","L"
pdf.SetX(50)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(55)
pdf.Cell 180,0,asignatura,"","","L"
	pdf.ln(5)
pdf.SetFont "times","B",12
pdf.SetX(15)
pdf.Cell 180,0,"CARACTER","","","L"
pdf.SetX(50)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(55)
pdf.Cell 180,0,duracion,"","","L"
	pdf.ln(5)
pdf.SetFont "times","B",12
pdf.SetX(15)
pdf.Cell 180,0,"SECCIÓN","","","L"
pdf.SetX(50)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(55)
pdf.Cell 180,0,seccion,"","","L"
	pdf.ln(5)
pdf.SetFont "times","B",12
pdf.SetX(15)
pdf.Cell 180,0,"PROFESOR","","","L"
pdf.SetX(50)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(55)
pdf.Cell 180,0,profesor,"","","L"
	pdf.ln(5)
pdf.SetFont "times","B",12
pdf.SetX(15)
pdf.Cell 180,0,"CARRERA","","","L"
pdf.SetX(50)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(55)
pdf.Cell 180,0,carrera,"","","L"
	pdf.ln(5)
pdf.SetFont "times","B",12
pdf.SetX(15)
pdf.Cell 180,0,"AÑO","","","L"
pdf.SetX(50)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(55)
pdf.Cell 180,0,anio,"","","L"
pdf.SetX(85)
pdf.SetFont "times","B",12
pdf.Cell 180,0,"SEMESTRE","","","L"
pdf.SetX(110)
pdf.Cell 180,0,":","","","L"
pdf.SetFont "times","",11
pdf.SetX(115)
pdf.Cell 180,0,periodo,"","","L"

pdf.ln(5)
pdf.SetFont "times","B",10
pdf.SetFillColor(230) 

pdf.SetX(15)
pdf.Cell 10,4,"N°","","","L",true
pdf.SetX(25)
pdf.Cell 20,4,"R.U.T.","","","L",true
pdf.SetX(45)
pdf.Cell 50,4,"Nombres","","","L",true
pdf.SetX(95)
pdf.Cell 50,4,"Apellidos","","","L",true
pdf.SetX(145)
pdf.Cell 19,4,"Asistencia","","","L",true
pdf.SetX(164)
pdf.Cell 15,4,"Nota","","","L",true
pdf.SetX(179)
pdf.Cell 11,4,"Situa.","","","L",true
 pdf.ln(4)
pdf.SetX(15)
pdf.Cell 10,4,"","","","L",true
pdf.SetX(25)
pdf.Cell 20,4,"","","","L",true
pdf.SetX(45)
pdf.Cell 50,4,"","","","L",true
pdf.SetX(95)
pdf.Cell 50,4,"","","","L",true
pdf.SetX(145)
pdf.Cell 19,4,"","","","L",true
pdf.SetX(164)
pdf.Cell 15,4,"Final","","","L",true
pdf.SetX(179)
pdf.Cell 11,4,"Final","","","L",true
pdf.ln(3)
suma_notas = 0.0
total_asignaturas = 0
filas_impresas = 0
numero = 0

while f_detalle_final.siguiente
   rut = f_detalle_final.obtenerValor("RUT")
   apellidos = f_detalle_final.obtenerValor("apellidos")
   nombres = f_detalle_final.obtenerValor("nombres")
   asistencia  = f_detalle_final.obtenerValor("asistencia")
   nota_final = f_detalle_final.obtenerValor("nota_final")
   situacion = f_detalle_final.obtenerValor("situacion")
   filas_impresas = filas_impresas + 1
   numero = numero + 1

   if cantidad_asignaturas > 13 and filas_impresas > limite_hoja then
      filas_impresas = 0
	  limite_hoja = 25
	  pdf.AddPage()
	  pdf.Image "imagenes_certificado/logo_upa_rojo_2011.jpg", 15, 15, 45, 17, "JPG"
	  pdf.ln(25)
		pdf.SetFont "times","B",14
		pdf.Cell 180,1,"Universidad Del Pacífico","","","C" 
			pdf.ln(5)
		pdf.SetFont "times","B",14
		pdf.Cell 180,1,"REGISTRO CURRICULAR","","","C" 
			pdf.ln(10)
		pdf.SetFont "times","B",16
		pdf.Cell 180,1,titulo,"","","C" 
			pdf.ln(10)
		pdf.SetFont "times","",9
		pdf.SetX(144)
		pdf.Cell 180,0,"Fecha de Impresión","","","L"
		pdf.SetX(170)
		pdf.Cell 180,0,":","","","L"
		pdf.SetX(172)
		pdf.Cell 180,0,fecha_impresion,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","B",12
		pdf.SetX(15)
		pdf.Cell 180,0,"ASIGNATURA","","","L"
		pdf.SetX(50)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(55)
		pdf.Cell 180,0,asignatura,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","B",12
		pdf.SetX(15)
		pdf.Cell 180,0,"CARACTER","","","L"
		pdf.SetX(50)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(55)
		pdf.Cell 180,0,duracion,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","B",12
		pdf.SetX(15)
		pdf.Cell 180,0,"SECCIÓN","","","L"
		pdf.SetX(50)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(55)
		pdf.Cell 180,0,seccion,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","B",12
		pdf.SetX(15)
		pdf.Cell 180,0,"PROFESOR","","","L"
		pdf.SetX(50)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(55)
		pdf.Cell 180,0,profesor,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","B",12
		pdf.SetX(15)
		pdf.Cell 180,0,"CARRERA","","","L"
		pdf.SetX(50)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(55)
		pdf.Cell 180,0,carrera,"","","L"
			pdf.ln(5)
		pdf.SetFont "times","B",12
		pdf.SetX(15)
		pdf.Cell 180,0,"AÑO","","","L"
		pdf.SetX(50)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(55)
		pdf.Cell 180,0,anio,"","","L"
		pdf.SetX(85)
		pdf.SetFont "times","B",12
		pdf.Cell 180,0,"SEMESTRE","","","L"
		pdf.SetX(110)
		pdf.Cell 180,0,":","","","L"
		pdf.SetFont "times","",11
		pdf.SetX(115)
		pdf.Cell 180,0,periodo,"","","L"
		
		pdf.ln(5)
		pdf.SetFont "times","B",10
		pdf.SetFillColor(230) 
		
		pdf.SetX(15)
		pdf.Cell 10,4,"N°","","","L",true
		pdf.SetX(25)
		pdf.Cell 20,4,"R.U.T.","","","L",true
		pdf.SetX(45)
		pdf.Cell 50,4,"Nombres","","","L",true
		pdf.SetX(95)
		pdf.Cell 50,4,"Apellidos","","","L",true
		pdf.SetX(145)
		pdf.Cell 19,4,"Asistencia","","","L",true
		pdf.SetX(164)
		pdf.Cell 15,4,"Nota","","","L",true
		pdf.SetX(179)
		pdf.Cell 11,4,"Situa.","","","L",true
		 pdf.ln(4)
		pdf.SetX(15)
		pdf.Cell 10,4,"","","","L",true
		pdf.SetX(25)
		pdf.Cell 20,4,"","","","L",true
		pdf.SetX(45)
		pdf.Cell 50,4,"","","","L",true
		pdf.SetX(95)
		pdf.Cell 50,4,"","","","L",true
		pdf.SetX(145)
		pdf.Cell 19,4,"","","","L",true
		pdf.SetX(164)
		pdf.Cell 15,4,"Final","","","L",true
		pdf.SetX(179)
		pdf.Cell 11,4,"Final","","","L",true
		pdf.ln(3)
   end if
	pdf.ln(5)
	pdf.SetFont "times","",9
	pdf.SetX(15)
	pdf.SetTextColor 186,186,186
	pdf.Cell 10,0,numero,"","","L",false
	pdf.SetTextColor 0,0,0
	pdf.SetX(25)
	pdf.Cell 20,0,rut,"","","L",false
	pdf.SetX(45)
	pdf.Cell 50,0,nombres,"","","L",false
	pdf.SetX(95)
	pdf.Cell 50,0,apellidos,"","","L",false
	pdf.SetX(150)
	pdf.Cell 14,0,asistencia,"","","L",false
	pdf.SetX(166)
	pdf.Cell 13,0,nota_final,"","","L",false
	pdf.SetX(181)
	pdf.Cell 9,0,situacion,"","","L",false
wend
    'response.Write(suma_notas&" / "&total_asignaturas)
if total_asignaturas = 0 then
	total_asignaturas = 1
end if	

pdf.SetY(-50)
pdf.SetFont "times","B",10
pdf.SetX(15)
pdf.Cell 63,0,"..........................................","","","C"  
pdf.SetX(78)
pdf.Cell 63,0,"..........................................","","","C"  
pdf.SetX(141)
pdf.Cell 63,0,"..........................................","","","C"   
pdf.SetY(-46)
pdf.SetFont "times","",10
pdf.SetX(15)
pdf.Cell 63,0,profesor_min,"","","C"  
pdf.SetX(78)
pdf.Cell 63,0,"Elena Ortúzar Muñoz","","","C"  
pdf.SetX(141)
pdf.Cell 63,0,director,"","","C" 
pdf.SetY(-42)
pdf.SetFont "times","",10
pdf.SetX(15)
pdf.Cell 63,0,"Docente","","","C"  
pdf.SetX(78)
pdf.Cell 63,0,"Secretaria General","","","C"  
pdf.SetX(141)
pdf.Cell 63,0,"Director Escuela","","","C" 
pdf.SetY(-38)
pdf.SetFont "times","",10
pdf.SetX(15)
pdf.Cell 63,0,"Universidad del Pacífico","","","C"  
pdf.SetX(78)
pdf.Cell 63,0,"Universidad del Pacífico","","","C"  
pdf.SetX(141)
pdf.Cell 63,0,"Universidad del Pacífico","","","C" 

pdf.Close()
pdf.Output()
%> 
