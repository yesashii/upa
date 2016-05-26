<%@language=vbscript%>
<!-- #include file = "../biblioteca/fpdf.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "genera_clave.asp" -->
<%
origen=request.QueryString("origen")
q_origen = Request.QueryString("origen")
if(q_origen="1") then
	q_rut = Request.QueryString("rut")
	q_peri = Request.QueryString("peri")
	q_sede = Request.QueryString("sede")
	session("sede")=q_sede
	session("_periodo")=q_peri
	session("rut_usuario")=q_rut
end if

 set conexion = new CConexion
 conexion.Inicializar "upacifico"
 set errores = new CErrores

 set negocio = new CNegocio
 negocio.Inicializa conexion
 
 'q_pers_nrut=16365740
 q_pers_nrut=16608757
 q_peri_ccod=218
 'q_pers_nrut=17420975
 'q_pers_nrut=17131451
 'q_pers_nrut=9968176
  
  pers_ncorr=request.QueryString("pers_ncorr")

 
 '---------------------------------------------obtengo los datos del alumno
 set f_datos_antecedentes = new CFormulario
 f_datos_antecedentes.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_datos_antecedentes.Inicializar conexion

					
				 selec_antecedentes=	"select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre,"& vbCrLf &_
				 	"pers_nrut as rut,pers_xdv as dv,"& vbCrLf &_
					"upper(protic.obtener_f_nacimiento_escrita(pers_nrut))as fnacimiento,"& vbCrLf &_
					"pers_temail,"& vbCrLf &_
					"pers_tcelular,"& vbCrLf &_
					"(select upper(dire_tcalle)+' '+dire_tnro from direcciones where pers_ncorr=a.pers_ncorr and tdir_ccod=1)as direccion,(select ciud_tdesc from ciudades cc where cc.ciud_ccod=c.ciud_ccod)as comuna ,"& vbCrLf &_
					"(select sexo_tdesc from sexos bb where a.sexo_ccod=bb.sexo_ccod )as sexo,"& vbCrLf &_
					"(select eciv_tdesc from estados_civiles aa where a.eciv_ccod=aa.eciv_ccod)as estado_civil,"& vbCrLf &_
					"(select pais_tnacionalidad from paises aa where aa.pais_ccod=a.pais_ccod)as nacionalidad,"& vbCrLf &_
					"dire_tfono,"& vbCrLf &_
					"(select ciud_tcomuna from ciudades cc where cc.ciud_ccod=c.ciud_ccod)as ciudad"& vbCrLf &_
					"from personas a, direcciones b,ciudades c "& vbCrLf &_
					"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_
					"and b.ciud_ccod=c.ciud_ccod"& vbCrLf &_
					"and a.pers_ncorr="&pers_ncorr&""& vbCrLf &_
					"and tdir_ccod in (1)"
					
					
 f_datos_antecedentes.Consultar selec_antecedentes
 f_datos_antecedentes.Siguiente
 

 
   
  matr_ncorr=conexion.ConsultaUno("Select matr_ncorr from alumnos a, postulantes b,personas c where a.post_ncorr=b.post_ncorr and emat_ccod=1 and b.pers_ncorr=c.pers_ncorr and b.peri_ccod="&q_peri_ccod&" and pers_nrut="&q_pers_nrut&"")
   
   '---------------------------------------------obtengo los datos academicos
   
   set f_academico = new CFormulario
 f_academico.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_academico.Inicializar conexion
 
 
 s_academico="select  pers_ncorr, c.carr_ccod,carr_tdesc , emat_ccod,b.jorn_ccod,facu_tdesc,(select sede_tdesc from sedes hhh where hhh.sede_ccod=b.sede_ccod) as sede,protic.ANO_INGRESO_CARRERA(a.pers_ncorr,c.carr_ccod)as anio_ingreso,a.post_ncorr"& vbCrLf &_
",(select top 1 anos_ccod from alumnos aa,postulantes bb,periodos_academicos cc where aa.pers_ncorr=a.pers_ncorr and emat_ccod in (1)and aa.pers_ncorr=bb.pers_ncorr and bb.peri_ccod=cc.peri_ccod order by bb.peri_ccod desc)as ultimo_ano"& vbCrLf &_
",cast((select comp_mneto-isnull(sdes_mmatricula ,0)"& vbCrLf &_
        "from compromisos aa"& vbCrLf &_
        "left outer join sdescuentos bb" & vbCrLf &_
        "on aa.post_ncorr=bb.post_ncorr"& vbCrLf &_
        "where aa.ecom_ccod=1 "& vbCrLf &_
        "and aa.peri_ccod=b.peri_ccod "& vbCrLf &_
        "and aa.post_ncorr=a.post_ncorr"& vbCrLf &_
        "and aa.tcom_ccod =1) as numeric(18,0))as ARAN_MMATRICULA,"& vbCrLf &_
"cast((select comp_mneto-isnull(sdes_mcolegiatura,0) "& vbCrLf &_
        "from compromisos aa"& vbCrLf &_
        "left outer join sdescuentos bb" & vbCrLf &_
        "on aa.post_ncorr=bb.post_ncorr "& vbCrLf &_
        "where aa.ecom_ccod=1 "& vbCrLf &_
        "and aa.peri_ccod=b.peri_ccod "& vbCrLf &_
        "and aa.post_ncorr=a.post_ncorr"& vbCrLf &_
        "and aa.tcom_ccod =2) as numeric(18,0))as ARAN_MCOLEGIATURA"& vbCrLf &_
"from alumnos a, ofertas_academicas b,especialidades c,carreras d,areas_academicas e,facultades f,aranceles g"& vbCrLf &_
"where a.ofer_ncorr=b.ofer_ncorr"& vbCrLf &_
"and b.espe_ccod=c.espe_ccod"& vbCrLf &_
"and b.peri_ccod="&q_peri_ccod&""& vbCrLf &_
"and a.pers_ncorr="&pers_ncorr&""& vbCrLf &_
"and c.carr_ccod=d.carr_ccod"& vbCrLf &_
"and d.area_ccod=e.area_ccod"& vbCrLf &_
"and e.facu_ccod=f.facu_ccod"& vbCrLf &_
"and b.ofer_ncorr=g.ofer_ncorr"& vbCrLf &_
"and emat_ccod=1"& vbCrLf &_
"and b.aran_ncorr=g.aran_ncorr"

   
 f_academico.Consultar s_academico
 f_academico.Siguiente
 'response.write(s_academico)
 'response.end() 
 
 
  post_ncorr=f_academico.ObtenerValor("post_ncorr")
 post_bnuevo=conexion.ConsultaUno("select post_bnuevo from postulantes where post_ncorr="&post_ncorr&"")
 
 if post_bnuevo ="S" then
 lleva_cursado="CERO"
 cursara="PRIMER "
 else
 lleva_cursado=""
 end if
 
 
 
 rut=f_datos_antecedentes.ObtenerValor("rut")
 
 ano_ingreso=f_academico.ObtenerValor("ANO_INGRESO_CARRERA")
ultimo_ano_cursado=f_academico.ObtenerValor("ultimo_ano")
colegiatura=f_academico.ObtenerValor("ARAN_MCOLEGIATURA")
matricula=f_academico.ObtenerValor("ARAN_MMATRICULA")
carrera=f_academico.ObtenerValor("carr_tdesc")
   jorn_ccod=f_academico.ObtenerValor("jorn_ccod")
   if jorn_ccod="1" then
   jorn="(D)"
   else
   jorn="(V)"
   end if
   
  
    sede=f_academico.ObtenerValor("sede")
	v_dia_actual 	= 	Day(now())
	v_mes	= 	Month(now())
	v_anio  = 	year(now())
	Select Case (v_mes)
    Case 1:
       v_mes_actual="Enero" 
    Case 2:
       v_mes_actual="Febrero" 
    Case 3:
       v_mes_actual="Marzo" 
    Case 4:
       v_mes_actual="Abril"
	Case 5:
       v_mes_actual="Mayo"
	Case 6:
       v_mes_actual="Junio"
	Case 7:
       v_mes_actual="Julio"
	Case 8:
       v_mes_actual="Agosto"
	Case 9:
       v_mes_actual="Septiembre"
	Case 10:
       v_mes_actual="Octubre"
	Case 11:
       v_mes_actual="Noviembre"
	Case 12:
       v_mes_actual="Diciembre"  
         
	End Select
	carr_ccod =f_academico.ObtenerValor("carr_ccod")
	tdes_ccod="99"
'response.Write("<br/>"&carr_ccod)	

	c_consulta = " select case count(*) when 0 then 'N' else 'S' end " & vbCrLf &_
			 " from certificados_online " & vbCrLf &_
			 " where cast(pers_ncorr as varchar)='"&pers_ncorr&"'  " & vbCrLf &_
		     " and carr_ccod ='"&carr_ccod&"' " & vbCrLf &_
			 " and cast(tdes_ccod as varchar)='"&tdes_ccod&"' "& vbCrLf &_
			 " and convert(datetime,protic.trunc(audi_fmodificacion),103) <= convert(datetime,protic.trunc(getDate()),103)"
'response.Write("<br/>"&c_consulta)
'response.End()
tiene_grabado = conexion.consultaUno(c_consulta)

'---------------------revisamos si tiene grabado este certificado y si no l tiene se debe grabar un certificado nuevo.
 

if tiene_grabado = "N" then 

set Password= new CPassword
clave= Password.GenerarPassword(25,conexion)

 codigo = "matr"&clave

 vencimiento = conexion.consultaUno("select protic.trunc(getDate()+30)")
 ceon_ncorr = conexion.consultaUno("exec obtenerSecuencia 'certificados_online'")
 c_insert = "insert into certificados_online (ceon_ncorr, pers_ncorr, carr_ccod, tdes_ccod, fecha_emision, fecha_vencimiento, audi_tusuario, audi_fmodificacion,cod_activacion)"&_
            "values ("&ceon_ncorr&","&pers_ncorr&",'"&carr_ccod&"',"&tdes_ccod&",getDate(), (getDate() + 30), '"&pers_nrut&"', getdate(),'"&codigo&"')"
			
 conexion.ejecutaS c_insert
else
c_codigo = " select ltrim(rtrim(cod_activacion)) " & vbCrLf &_
			 " from certificados_online " & vbCrLf &_
			 " where cast(pers_ncorr as varchar)='"&pers_ncorr&"'  " & vbCrLf &_
		     " and carr_ccod ='"&carr_ccod&"' " & vbCrLf &_
			 " and cast(tdes_ccod as varchar)='"&tdes_ccod&"' " & vbCrLf &_
			 " and convert(datetime,protic.trunc(getDate()),103) <= convert(datetime,protic.trunc(fecha_vencimiento),103)"
codigo = conexion.consultaUno(c_codigo)
end if 
 
  'response.Write("<br/>"&s_academico)
 'response.end() 
 
 espacio="                                       "
 espacio2="    "
 linea="_____________________________________________________________________________"
Set pdf=CreateJsObject("FPDF")
pdf.CreatePDF()
pdf.SetPath("../biblioteca/fpdf/" )
pdf.SetFont "times","",14
pdf.Open()
pdf.AddPage()

pdf.Cell 42,1,"                                                       " 
	pdf.ln(26)
pdf.SetFont "times","U",14
pdf.Cell 180,1,"C E R T I F I C A D O","","","C"  
	pdf.ln(5)
pdf.Cell 180,1,"LÍNEA DE CRÉDITO EDUCACIÓN SUPERIOR","","","C" 
	pdf.ln(10)
pdf.SetFont "times","B",14
pdf.Cell 180,1,"ÍTALO GIRAUDO TORRES","","","C" 
	pdf.ln(0)
pdf.Cell 170,1,""&linea&" ","","","L"
	pdf.ln(6)
pdf.SetFont "times","",14
pdf.Cell 180,1,"NOMBRE","","","C"
	pdf.ln(10)
pdf.SetFont "times","BU",14
pdf.Cell 175,1,"VICERRECTOR DE ADMINISTRACIÓN Y FINANZAS","","","C" 
	pdf.ln(6)
pdf.SetFont "times","",14
pdf.Cell 180,1,"CARGO","","","C"
	pdf.ln(0)
pdf.SetFont "times","B",14	
pdf.Cell 170,1,""&linea&" ","","","L"
	pdf.ln(6)
pdf.SetFont "times","",14
	pdf.ln(4)
pdf.SetFont "times","B",14
pdf.Cell 180,1,"UNIVERSIDAD DEL PACÍFICO","","","C"
	pdf.ln(0)
pdf.Cell 170,1,""&linea&" ","","","L"
	pdf.ln(5)
pdf.SetFont "times","",14
pdf.Cell 180,1,"INSTITUCIÓN","","","C" 
	pdf.ln(6)
pdf.MultiCell 190,5,"Certifica que don (ña) "&f_datos_antecedentes.ObtenerValor("nombre")&" Cédula de Identidad N° "&FormatNumber(rut,0)&"- "&f_datos_antecedentes.ObtenerValor("dv")&" es alumna(o) regular de la Carrera de "&carrera&" "&jorn&", SEDE "&sede&", habiendo cursado a la fecha "&lleva_cursado&" año.","","J",""
	pdf.ln(6)
pdf.MultiCell 190,5,"De acuerdo a la malla curricular, debiera restarle UN AÑO Y MEDIO para egresar de la carrera.","","J",""
	pdf.ln(6)
pdf.MultiCell 190,5,"Los valores correspondientes a matrícula y al arancel que el interesado deberá pagar para cursar el "&cursara&" AÑO, durante el año académico 2010, ascienden a:  Matrícula "&FormatCurrency(matricula, 0)&".- y Arancel "&FormatCurrency(colegiatura, 0)&".-","","J",""
pdf.ln(6)
pdf.MultiCell 190,5,"En caso que dicha suma sea financiada total o parcialmente con un crédito bancario, el monto respectivo deberá ser girado en documento a nombre de: UNIVERSIDAD DEL PACIFICO,  RUT.: 71.704.700-1.","","J",""

pdf.ln(40)
pdf.Image "../certificados_dae/imagenes/firma.jpg", 14, 190, 70, 40, "JPG"
pdf.ln(0)
pdf.MultiCell 180,5,"______________________________","","L",""
pdf.ln(1)
pdf.Cell 180,1,"     Firma y Timbre Institución","","L",""
pdf.ln(0)
pdf.Cell 180,1,"Santiago, "&v_dia_actual&" de "&v_mes_actual&" del "&v_anio&"","","","R"

pdf.ln(30)
pdf.SetFont "times","B",10
pdf.Cell 180,1,"Código de Validación :"&codigo&"","","","C"
	pdf.ln(5)
	pdf.SetFont "times","",10
pdf.Cell 180,1,"Para validar este certificado diríjase a la página de la Universidad:","","","C"
	pdf.ln(05)
	pdf.SetFont "times","B",10
pdf.Cell 180,1,"http://www.upacifico.cl/validacion_certificados/valida.htm","","","C"
	pdf.ln(05)
		pdf.SetFont "times","",10
pdf.Cell 180,1,"Ingrese Rut del alumno y código de validación","","","C"
	pdf.ln(05)
pdf.Cell 180,1,"(el certificado es Válido sólo si el mostrado en pantalla de validación es idéntico al que se encuentra en su poder).","","","C"
	pdf.ln(05)

pdf.Close()
pdf.Output()
%> 
