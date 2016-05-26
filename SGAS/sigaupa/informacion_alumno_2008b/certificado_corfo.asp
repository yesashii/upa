<%@language=vbscript%>
<!-- #include file = "../biblioteca/fpdf.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
 
pers_nrut = request.QueryString("pers_nrut")
carr_ccod = request.QueryString("carr_ccod")
tdes_ccod = request.QueryString("tdes_ccod")
v_dia_actual 	= 	Day(now())
v_mes_actual	= 	Month(now())
if v_dia_actual >= 30 or v_mes_actual > 1 then
	q_peri_ccod = "228"
	q_anos_ccod = Year(now())
else
	q_peri_ccod = "226"
	q_anos_ccod = Year(now()) - 1
end if

pers_ncorr = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='" & pers_nrut & "' ")

c_consulta = " select case count(*) when 0 then 'N' else 'S' end " & vbCrLf &_
			 " from certificados_online " & vbCrLf &_
			 " where cast(pers_ncorr as varchar)='"&pers_ncorr&"'  " & vbCrLf &_
		     " and carr_ccod ='"&carr_ccod&"' " & vbCrLf &_
			 " and cast(tdes_ccod as varchar)='100' " & vbCrLf &_
			 " and convert(datetime,protic.trunc(getDate()),103) <= convert(datetime,protic.trunc(fecha_vencimiento),103)"

tiene_grabado = conexion.consultaUno(c_consulta)

if tiene_grabado = "N" then 
 ceon_ncorr = conexion.consultaUno("exec obtenerSecuencia 'certificados_online'")
 matr_ncorr_temporal = conexion.consultaUno ("select max(matr_ncorr) from alumnos where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and emat_ccod = 1 ") 
 post_ncorr_temporal = conexion.consultaUno ("select max(post_ncorr) from alumnos where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and emat_ccod = 1 ") 
 letra_nombre_temporal = conexion.consultaUno ("select lower(substring(pers_tnombre,2,1))  from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'") 
 letra_apellido_temporal = conexion.consultaUno ("select lower(substring(pers_tape_paterno,2,1))  from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'") 
 new_matr = clng(matr_ncorr_temporal)*1 + ceon_ncorr
 new_post = clng(post_ncorr_temporal)*1 - ceon_ncorr
 codigo = new_post & letra_apellido_temporal & new_matr & letra_nombre_temporal &ceon_ncorr
 vencimiento = conexion.consultaUno("select protic.trunc(getDate()+30)")
 
 'c_insert = "insert into certificados_online (ceon_ncorr, pers_ncorr, carr_ccod, tdes_ccod, fecha_emision, fecha_vencimiento, audi_tusuario, audi_fmodificacion,cod_activacion)"&_
 '           "values ("&ceon_ncorr&","&pers_ncorr&",'"&carr_ccod&"',100,getDate(), (getDate() + 30), '"&pers_nrut&"', getdate(),'"&codigo&"')"
			
 conexion.ejecutaS c_insert
else
c_ceon = " select ceon_ncorr " & vbCrLf &_
			 " from certificados_online " & vbCrLf &_
			 " where cast(pers_ncorr as varchar)='"&pers_ncorr&"'  " & vbCrLf &_
		     " and carr_ccod ='"&carr_ccod&"' " & vbCrLf &_
			 " and cast(tdes_ccod as varchar)='100' " & vbCrLf &_
			 " and convert(datetime,protic.trunc(getDate()),103) <= convert(datetime,protic.trunc(fecha_vencimiento),103)"
ceon_ncorr = conexion.consultaUno(c_ceon)

c_codigo = " select ltrim(rtrim(cod_activacion)) " & vbCrLf &_
			 " from certificados_online " & vbCrLf &_
			 " where cast(pers_ncorr as varchar)='"&pers_ncorr&"'  " & vbCrLf &_
		     " and carr_ccod ='"&carr_ccod&"' " & vbCrLf &_
			 " and cast(tdes_ccod as varchar)='100' " & vbCrLf &_
			 " and convert(datetime,protic.trunc(getDate()),103) <= convert(datetime,protic.trunc(fecha_vencimiento),103)"
codigo = conexion.consultaUno(c_codigo)

c_vencimiento = " select protic.trunc(fecha_vencimiento) " & vbCrLf &_
				" from certificados_online " & vbCrLf &_
				" where cast(pers_ncorr as varchar)='"&pers_ncorr&"'  " & vbCrLf &_
				" and carr_ccod ='"&carr_ccod&"' " & vbCrLf &_
				" and cast(tdes_ccod as varchar)='100' " & vbCrLf &_
				" and convert(datetime,protic.trunc(getDate()),103) <= convert(datetime,protic.trunc(fecha_vencimiento),103)"
vencimiento = conexion.consultaUno(c_vencimiento) 
end if 

nombre = conexion.consultaUno("select upper(cast(pers_tnombre as varchar) + ' ' + cast(pers_tape_paterno as varchar) + ' ' + cast(pers_tape_materno as varchar)) from personas where cast(pers_nrut as varchar)='" & pers_nrut & "' ")
rut = conexion.consultaUno("select upper(protic.format_rut('"&pers_nrut&"'))")
c_carrera = " select top 1 ltrim(rtrim(carr_tdesc)) + case b.jorn_ccod when 1 then ' (D)' else ' (V)' end + ', ' + "&_
            " case b.sede_ccod when 1 then 'SEDE' when '4' then 'SEDE' when 2 then 'CAMPUS' when 8 then 'CAMPUS' when 7 then 'OFICINA' end + ' ' + ltrim(rtrim(sede_tdesc)) "&_
			" from alumnos a, ofertas_academicas b, especialidades c, carreras d, periodos_academicos e, sedes f "&_
			" where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod and b.sede_ccod=f.sede_ccod "&_
			" and b.peri_ccod=e.peri_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and d.carr_ccod='"&carr_ccod&"' "&_
			" and cast(e.anos_ccod as varchar)='"&q_anos_ccod&"' and protic.afecta_estadistica(a.matr_ncorr) > 0 and isnull(a.alum_nmatricula,0) not in (7777) "
carrera = conexion.consultaUno(c_carrera)

c_duracion = " select top 1 case c.espe_nduracion / 2 when 1 then 'UN AÑO' when 2 then 'DOS AÑOS' when 3 then 'TRES AÑOS' when 4 then 'CUATRO AÑOS' "&_
             "                           when 5 then 'CINCO AÑOS' when 6 then 'SEIS AÑOS' when 7 then 'SIETE AÑOS' end "&_
             " + case  c.espe_nduracion % 2 when 0 then ' ' else '  Y MEDIO ' end as duracion  "&_
			 " from alumnos a, ofertas_academicas b, especialidades c, carreras d, periodos_academicos e, sedes f "&_
			 " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod and b.sede_ccod=f.sede_ccod "&_
			 " and b.peri_ccod=e.peri_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and d.carr_ccod='"&carr_ccod&"' "&_
			 " and cast(e.anos_ccod as varchar)='"&q_anos_ccod&"' and protic.afecta_estadistica(a.matr_ncorr) > 0 and isnull(a.alum_nmatricula,0) not in (7777) "
duracion = conexion.consultaUno(c_duracion)

c_matricula = "select top 1 ARAN_MMATRICULA "&_
			  " from alumnos a, ofertas_academicas b, especialidades c, carreras d, periodos_academicos e, sedes f, aranceles g "&_
			  " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod and b.sede_ccod=f.sede_ccod "&_
			  " and b.peri_ccod=e.peri_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and d.carr_ccod='"&carr_ccod&"' "&_
			  " and cast(e.anos_ccod as varchar)='"&q_anos_ccod&"' and protic.afecta_estadistica(a.matr_ncorr) > 0 and isnull(a.alum_nmatricula,0) not in (7777) "
matricula = conexion.consultaUno(c_matricula)
matricula = formatNumber(clng(matricula),0)

c_arancel = " select top 1 ARAN_MCOLEGIATURA "&_
			" from alumnos a, ofertas_academicas b, especialidades c, carreras d, periodos_academicos e, sedes f, aranceles g "&_
			" where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod and b.sede_ccod=f.sede_ccod "&_
			" and b.peri_ccod=e.peri_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and d.carr_ccod='"&carr_ccod&"' and b.aran_ncorr=g.aran_ncorr  "&_
			" and cast(e.anos_ccod as varchar)='"&q_anos_ccod&"' and protic.afecta_estadistica(a.matr_ncorr) > 0 and isnull(a.alum_nmatricula,0) not in (7777) "
arancel = conexion.consultaUno(c_arancel)
arancel = formatNumber(clng(arancel),0)

consulta_fecha = "  select cast(datePart(day,fecha_emision) as varchar)+ ' de ' + " & vbCrLf &_
				 "  case datePart(month,fecha_emision) when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' " & vbCrLf &_
				 "  when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' " & vbCrLf &_
				 "  when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' end " & vbCrLf &_
				 "  + ' de ' + cast(datePart(year,fecha_emision) as varchar) as fecha_01 " & vbCrLf &_
				 "  from certificados_online " & vbCrLf &_
				 "  where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cod_activacion='"&codigo&"' "				 
'response.Write(consulta_fecha)				
fecha_01 = conexion.consultaUno(consulta_fecha)
fecha_01 = "Santiago, "&fecha_01

espacio="                                       "
espacio2="    "
Set pdf=CreateJsObject("FPDF")
pdf.CreatePDF()
pdf.SetPath("../biblioteca/fpdf/" )
pdf.SetFont "times","",12
pdf.Open()
pdf.AddPage()
pdf.SetLeftMargin(15)
'pdf.Image "../certificados_dae/imagenes/logo_upa.jpg", 14, 22, 20, 20, "JPG"
	pdf.ln(30)
pdf.SetFont "times","U",14
pdf.Cell 180,1,"CERTIFICADO N° "&ceon_ncorr,"","","C"  
	pdf.ln(10)
pdf.SetFont "times","U",14
pdf.Cell 180,1,"LÍNEA DE CRÉDITO EDUCACIÓN SUPERIOR","","","C"  
	pdf.ln(10)
pdf.SetFont "times","U",14
pdf.Cell 180,1,"BANCO ESTADO "&q_anos_ccod,"","","C"  
	pdf.ln(12)
pdf.SetFont "times","B",14
pdf.Cell 180,1,"ÍTALO GIRAUDO TORRES","","","C" 
pdf.Line 20, pdf.GetY() + 4, 180, pdf.GetY() + 4 
	pdf.ln(6)
pdf.SetFont "times","",14
pdf.Cell 180,1,"NOMBRE","","","C" 
	pdf.ln(10)
pdf.SetFont "times","B",14
pdf.Cell 180,1,"VICERRECTOR DE ADMINISTRACIÓN Y FINANZAS","","","C" 
pdf.Line 20, pdf.GetY() + 4, 180, pdf.GetY() + 4 
	pdf.ln(6)
pdf.SetFont "times","",14
pdf.Cell 180,1,"CARGO","","","C" 
	pdf.ln(10)
pdf.SetFont "times","B",14
pdf.Cell 180,1,"UNIVERSIDAD DEL PACÍFICO","","","C" 
pdf.Line 20, pdf.GetY() + 4, 180, pdf.GetY() + 4 
	pdf.ln(6)
pdf.SetFont "times","",14
pdf.Cell 180,1,"INSTITUCIÓN","","","C" 
	pdf.ln(10)
pdf.SetFont "times","",14
pdf.MultiCell 180,5,"Certifica que don (ña) "&nombre&" Cédula de identidad N° "&rut&" es alumno (a) regular de la Carrera de "&carrera&", habiendo cursado a la fecha el CERO año.","","","J" 
pdf.ln(8)
pdf.SetFont "times","",14
pdf.MultiCell 180,3,"De acuerdo a la malla curricular la duración de la carrera es de "&duracion&".","","","J" 
pdf.ln(10)
pdf.SetFont "times","",14
pdf.MultiCell 180,5,"Los valores correspondientes a matrícula y al arancel que el interesado (a) deberá pagar para cursar el PRIMER AÑO, durante el año académico "&q_anos_ccod&", asciende a: Matrícula: $ "&matricula&".- y Arancel $ "&arancel&".-","","","J" 
pdf.ln(10)
pdf.SetFont "times","",14
pdf.MultiCell 180,5,"En caso que dicha suma sea financiada total o parcialmente con un crédito bancario, el monto respectivo deberá ser girado en documento a nombre de: UNIVERSIDAD DEL PACIFICO, RUT.: 71.704.700-1.","","","J" 
	pdf.ln(10)
pdf.SetFont "times","",14
pdf.Cell 180,1,fecha_01,"","","R" 
pdf.Image "imagenes/firma_contrato_limpio_solo.jpg",10,205,94,58,"JPG"
pdf.ln(45)
pdf.SetFont "times","",14
pdf.Cell 180,1,"-------------------------------------","","","L" 
pdf.ln(5)
pdf.SetFont "times","",14
pdf.Cell 180,1,"Firma y Timbre Institución","","","L" 
pdf.Close()
pdf.Output()
%> 
