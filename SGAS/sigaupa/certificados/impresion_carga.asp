<%@language=vbscript%>
<!-- #include file = "../biblioteca/fpdf.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%

pers_nrut = request.Form("p[0][pers_nrut]")

sql = " select distinct b.matr_ncorr,b.pers_ncorr, protic.format_Rut(a.pers_nrut) as rut, "& vbCrLf &_
	  " pers_tape_paterno + ' '+ pers_tape_materno + ' ' + pers_tnombre as nombre_alfa, "& vbCrLf &_
	  " pers_tnombre + ' ' + pers_tape_paterno + ' '+ pers_tape_materno as nombre, "& vbCrLf &_
	  " e.carr_tdesc as carrera, protic.ano_ingreso_carrera(a.pers_ncorr,e.carr_ccod) as ano_ingreso, "& vbCrLf &_
	  " sede_tdesc as sede, jorn_tdesc as jornada, protic.trunc(getDate()) as fecha_impresion "& vbCrLf &_
	  " from personas a, alumnos b, ofertas_academicas c, especialidades d, carreras e, sedes f, jornadas g "& vbCrLf &_
	  " where pers_nrut in (16209877,16212091,17269748,16590752,16653219,16942170,17405966,197097, "& vbCrLf &_
	  " 17402341,17265918,16653650,16381485,17252919,17264958,17404548,17404864,16307771,16610633,15365840,14709092,16747967,17084891,17404147,17043032,15660341,16609492,16790044,15933958,17120045,17087362,17325874,16872541,17086422,17405835,16617860,16368233,16941898,16610925,16427309,16941736,16783576,16605499,17087855,17299298,16940291,16209485,16301653,16369481,16208948,17264787,16935474,17404297,16655400,17353615,17302966,16652861, "& vbCrLf &_
	  " 16976447,16366338,16213791,16609799,16094576,16571786,16020143,16573524,17250960,16371199,16937297,17949489,198577, "& vbCrLf &_
	  " 17270210,16368011,17405128,17270506,17188385,15315448,16656950,17290637,16303895,16210169,17354262,16610725,17311064,17325394,17083016,16211864,16767514,17401978,17083076,17085210,17563425,16976627,198945,16945600,17085239, "& vbCrLf &_
	  " 16886731,15937110,16767985,16652961,17175877,17132567,17266961,16873968,14726361,16558740,16611845,16210461,17079929,16943238,16019588,17022702,16907844,17108009,16213283,16940059,17483714,16212191,17083247,16936750, "& vbCrLf &_
	  " 16937366,16861059,17131451,17084040,16610382,16750359,17089238,16941157,17310032,17016964,16945348,16941408, "& vbCrLf &_
	  " 17532947,16607064,16936588,17199510,16366651,16611129,15035964,17270893,17373356,17082703,17515462,17404470, "& vbCrLf &_
	  " 17023396,16213644,16359594,16153771,16098122,16751993,17268281,16933963,17188762,17048217,16662022,15936699, "& vbCrLf &_
	  " 16610558,17082712,17087311,17314554,16610361,16366588,16607779) "& vbCrLf &_
	  " and a.pers_ncorr=b.pers_ncorr and b.ofer_ncorr=c.ofer_ncorr "& vbCrLf &_
	  " and c.peri_ccod=224 and c.espe_ccod = d.espe_ccod and d.carr_ccod=e.carr_ccod "& vbCrLf &_
	  " and c.sede_ccod=f.sede_ccod and c.jorn_ccod=g.jorn_ccod "& vbCrLf &_
	  " and exists (select 1 from cargas_academicas tt where tt.matr_ncorr=b.matr_ncorr) "& vbCrLf &_
	  " and e.carr_ccod = '45' "& vbCrLf &_
	  " order by nombre_alfa asc"


set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

Set pdf=CreateJsObject("FPDF")
pdf.CreatePDF()
pdf.SetPath("../biblioteca/fpdf/" )
pdf.SetFont "times","",12
pdf.Open()


	
set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "tabla_vacia.xml", "tabla"
f_encabezado.Inicializar conexion
f_encabezado.Consultar sql
while f_encabezado.siguiente
	matr_ncorr = f_encabezado.obtenerValor("matr_ncorr")
	pers_ncorr = f_encabezado.obtenerValor("pers_ncorr")
	rut = f_encabezado.obtenerValor("rut")	
	nombre = f_encabezado.obtenerValor("nombre")
	carrera = f_encabezado.obtenerValor("carrera")
	ano_ingreso = f_encabezado.obtenerValor("ano_ingreso")
	sede = f_encabezado.obtenerValor("sede")
	jornada = f_encabezado.obtenerValor("jornada")

	pdf.AddPage()
	
	pdf.Image "imagenes_certificado/logo_upa_rojo_2011.jpg", 15, 15, 45, 17, "JPG"
	pdf.ln(25)
	pdf.SetFont "times","B",14
	pdf.Cell 180,1,"Universidad Del Pacífico","","","C" 
	pdf.ln(10)
	pdf.SetFont "times","B",16
	pdf.Cell 180,1,"CARGA ACADÉMICA REGISTRADA","","","C"
	pdf.ln(6)
	pdf.SetFont "times","B",16
	pdf.Cell 180,1,"SEGUNDO SEMESTRE 2011","","","C"
	pdf.ln(10)
	pdf.SetFont "times","B",12
	pdf.SetX(15)
	pdf.Cell 180,0,"R.U.T.","","","L"
	pdf.SetX(50)
	pdf.Cell 180,0,":","","","L"
	pdf.SetFont "times","",11
	pdf.SetX(55)
	pdf.Cell 180,0,rut,"","","L"
	pdf.ln(5)
	pdf.SetFont "times","B",12
	pdf.SetX(15)
	pdf.Cell 180,0,"NOMBRE","","","L"
	pdf.SetX(50)
	pdf.Cell 180,0,":","","","L"
	pdf.SetFont "times","",11
	pdf.SetX(55)
	pdf.Cell 180,0,nombre,"","","L"
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
	pdf.Cell 180,0,"AÑO INGRESO","","","L"
	pdf.SetX(50)
	pdf.Cell 180,0,":","","","L"
	pdf.SetFont "times","",11
	pdf.SetX(55)
	pdf.Cell 180,0,ano_ingreso,"","","L"
	pdf.ln(5)
	pdf.SetFont "times","B",12
	pdf.SetX(15)
	pdf.Cell 180,0,"SEDE","","","L"
	pdf.SetX(50)
	pdf.Cell 180,0,":","","","L"
	pdf.SetFont "times","",11
	pdf.SetX(55)
	pdf.Cell 180,0,sede,"","","L"
	pdf.ln(5)
	pdf.SetFont "times","B",12
	pdf.SetX(15)
	pdf.Cell 180,0,"JORNADA","","","L"
	pdf.SetX(50)
	pdf.Cell 180,0,":","","","L"
	pdf.SetFont "times","",11
	pdf.SetX(55)
	pdf.Cell 180,0,jornada,"","","L"
	
	
	
	sql2 = " select c.asig_ccod as cod_asignatura, c.asig_tdesc as asignatura,b.secc_tdesc as seccion, " & vbCrLf &_
			   " protic.horario_con_sala(b.secc_ccod) as horario,  case a.acse_ncorr when 3 then 'Carga Adicional' when 4 then 'Carga Sin Pre-requisitos' else case a.carg_afecta_promedio when 'N' then 'Optativo' else 'Carga Regular' end end as tipo, "& vbCrLf &_
			   " isnull((select isnull(cred_valor,0) from asignaturas aa,creditos_Asignatura bb "& vbCrLf &_
			   "  where aa.cred_ccod = bb.cred_ccod and aa.asig_ccod=c.asig_ccod),0) as creditos"& vbCrLf &_
			   " from cargas_Academicas a, secciones b, asignaturas c " & vbCrLf &_
			   " where cast(matr_ncorr as varchar)='"&matr_ncorr&"' " & vbCrLf &_
			   " and a.secc_ccod=b.secc_ccod " & vbCrLf &_
			   " and not exists (Select 1 from equivalencias eq where eq.matr_ncorr=a.matr_ncorr and eq.secc_ccod=a.secc_ccod) " & vbCrLf &_
			   " and b.asig_ccod=c.asig_ccod " & vbCrLf &_
			   " union " & vbCrLf &_
			   " select c.asig_ccod as cod_asignatura, c.asig_tdesc as asignatura,b.secc_tdesc as seccion, " & vbCrLf &_
			   " protic.horario_con_sala(b.secc_ccod) as horario,'Equivalencia'  as tipo, " & vbCrLf &_
			   " isnull((select isnull(cred_valor,0) from asignaturas aa,creditos_Asignatura bb "& vbCrLf &_
			   "  where aa.cred_ccod = bb.cred_ccod and aa.asig_ccod=c.asig_ccod),0) as creditos"& vbCrLf &_
			   " from equivalencias a, secciones b, asignaturas c " & vbCrLf &_
			   " where cast(matr_ncorr as varchar)='"&matr_ncorr&"' " & vbCrLf &_
			   " and a.secc_ccod=b.secc_ccod " & vbCrLf &_
			   " and b.asig_ccod=c.asig_ccod " & vbCrLf &_
	           " union  select f.asig_ccod as cod_asignatura, f.asig_tdesc as asignatura,e.secc_tdesc as seccion, " & vbCrLf &_
			   "     protic.horario_con_sala(e.secc_ccod) as horario, case acse_ncorr when 3 then 'Carga Adicional' when 4 then 'Carga Sin Pre-requisitos' else case d.carg_afecta_promedio when 'N' then 'Optativo' else 'Carga Regular' end end as tipo, " & vbCrLf &_
			   "     isnull((select isnull(cred_valor,0) from asignaturas aa,creditos_Asignatura bb " & vbCrLf &_
			   "             where aa.cred_ccod = bb.cred_ccod and aa.asig_ccod=f.asig_ccod),0) as creditos " & vbCrLf &_
			   "    from alumnos a, ofertas_academicas b, especialidades c, cargas_academicas d, secciones e, asignaturas f " & vbCrLf &_
			   "    where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
			   "    and b.peri_ccod=222 and b.espe_ccod=c.espe_ccod  " & vbCrLf &_
			   "    and c.carr_ccod='45' and a.emat_ccod in (1,4,8) and f.duas_ccod=3 " & vbCrLf &_
			   "    and not exists (Select 1 from equivalencias eq where eq.matr_ncorr=d.matr_ncorr and eq.secc_ccod=d.secc_ccod)  " & vbCrLf &_
			   "    and a.matr_ncorr=d.matr_ncorr and d.secc_ccod=e.secc_ccod and e.asig_ccod=f.asig_ccod " & vbCrLf &_
			   " union " & vbCrLf &_
			   "    select f.asig_ccod as cod_asignatura, f.asig_tdesc as asignatura,e.secc_tdesc as seccion, " & vbCrLf &_
			   "    protic.horario_con_sala(e.secc_ccod) as horario, case isnull(acse_ncorr,0) when 0 then 'Equivalencia' else 'Carga Extraordinaria' end as tipo, " & vbCrLf &_
			   "    isnull((select isnull(cred_valor,0) from asignaturas aa,creditos_Asignatura bb " & vbCrLf &_
			   "            where aa.cred_ccod = bb.cred_ccod and aa.asig_ccod=f.asig_ccod),0) as creditos " & vbCrLf &_
    		   "    from alumnos a, ofertas_academicas b, especialidades c, equivalencias d, secciones e, asignaturas f,cargas_academicas ca " & vbCrLf &_
			   "    where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
			   "    and b.peri_ccod =222 and b.espe_ccod=c.espe_ccod  " & vbCrLf &_
		       "    and c.carr_ccod='45' and a.emat_ccod in (1,4,8) " & vbCrLf &_
			   "    and a.matr_ncorr=d.matr_ncorr and d.secc_ccod=e.secc_ccod and e.asig_ccod=f.asig_ccod and f.duas_ccod=3 " & vbCrLf &_
			   "    and d.matr_ncorr=ca.matr_ncorr and d.secc_ccod=ca.secc_ccod " & vbCrLf &_
			   " order by asignatura "
	
    set f_detalle = new CFormulario
	f_detalle.Carga_Parametros "tabla_vacia.xml", "tabla"
	f_detalle.Inicializar conexion
    f_detalle.Consultar sql2
	
	pdf.ln(5)
	pdf.SetFont "times","B",10
	pdf.SetFillColor(230) 
	
	pdf.SetX(15)
	pdf.Cell 10,4,"N°","","","L",true
	pdf.SetX(25)
	pdf.Cell 20,4,"CÓDIGO","","","L",true
	pdf.SetX(45)
	pdf.Cell 80,4,"ASIGNATURA","","","L",true
	pdf.SetX(125)
	pdf.Cell 20,4,"SECCIÓN","","","L",true
	pdf.SetX(145)
	pdf.Cell 20,4,"CRÉDITOS","","","L",true
	pdf.SetX(165)
	pdf.Cell 25,4,"CONCEPTO","","","L",true
    numero = 0
    while f_detalle.siguiente
     asig_ccod = f_detalle.obtenerValor("cod_asignatura")
     asig_tdesc = f_detalle.obtenerValor("asignatura")
     seccion = f_detalle.obtenerValor("seccion")
     horario  = f_detalle.obtenerValor("horario")
     tipo = f_detalle.obtenerValor("tipo")
     creditos = f_detalle.obtenerValor("creditos")
     numero = numero + 1
    
	 pdf.ln(5)
	 pdf.SetX(15)
	 pdf.SetFont "times","",10
	 pdf.SetTextColor 186,186,186
	 pdf.Cell 10,4,numero,"","","L"
	 pdf.SetX(25)
	 pdf.SetTextColor 0,0,0
	 pdf.Cell 20,4,asig_ccod,"","","L"
	 pdf.SetX(45)
	 pdf.Cell 80,4,asig_tdesc,"","","L"
	 pdf.SetX(125)
	 pdf.Cell 20,4,seccion,"","","L"
	 pdf.SetX(145)
	 pdf.Cell 20,4,creditos,"","","L"
	 pdf.SetX(165)
	 pdf.Cell 25,4,tipo,"","","L"
	wend 
	 
	
	pdf.SetY(-50)
	pdf.SetFont "times","B",12
	pdf.SetX(130)
	pdf.Cell 50,0,"...................................","","","C"   
	pdf.SetY(-46)
	pdf.SetFont "times","B",12
	pdf.SetX(130)
	pdf.Cell 50,0,"ESCUELA","","","C"   
wend

pdf.Close()
pdf.Output()
%> 
