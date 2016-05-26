<!-- #include file = "../biblioteca/fpdf.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
 'response.End()
set conexion = new CConexion
 conexion.Inicializar "upacifico"
 set errores = new CErrores

 set negocio = new CNegocio
 negocio.Inicializa conexion
 q_pers_nrut=16365740
 'q_pers_nrut=16608757
 'q_pers_nrut=7684028
 
 set f_datos_antecedentes = new CFormulario
 f_datos_antecedentes.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_datos_antecedentes.Inicializar conexion

					
				 selec_antecedentes=	"select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno as nombre,"& vbCrLf &_
					"protic.trunc(pers_fnacimiento)fnacimiento,"& vbCrLf &_
					"pers_temail,"& vbCrLf &_
					"pers_temail2,"& vbCrLf &_
					"(select sexo_tdesc from sexos bb where a.sexo_ccod=bb.sexo_ccod )as sexo,"& vbCrLf &_
					"(select eciv_tdesc from estados_civiles aa where a.eciv_ccod=aa.eciv_ccod)as estado_civil,"& vbCrLf &_
					"(select pais_tnacionalidad from paises aa where aa.pais_ccod=a.pais_ccod)as nacionalidad,"& vbCrLf &_
					" protic.obtener_direccion(a.pers_ncorr,1,'CNPB') as direccion,"& vbCrLf &_
					"dire_tfono,"& vbCrLf &_
					"dire_tcelular,"& vbCrLf &_
					"(select regi_tdesc from regiones cc where cc.regi_ccod=c.regi_ccod)as regi_tdesc"& vbCrLf &_
					"from personas a, direcciones b,ciudades c "& vbCrLf &_
					"where a.pers_ncorr=b.pers_ncorr"& vbCrLf &_
					"and b.ciud_ccod=c.ciud_ccod"& vbCrLf &_
					"and pers_nrut="&q_pers_nrut&""& vbCrLf &_
					"and tdir_ccod=1"
 f_datos_antecedentes.Consultar selec_antecedentes
 f_datos_antecedentes.Siguiente
 
 'response.End()
  'response.Write(s_idioma)
 
 set f_idioma = new CFormulario
 f_idioma.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_idioma.Inicializar conexion

					s_idioma="select  idal_ncorr,a.idio_ccod,idal_habla,idal_lee,idal_escribe,a.nidi_ccod,nidi_tdesc,case when a.idio_ccod=8 then idal_otro " & vbCrLf &_
					"else idio_tdesc end as idio_tdesc "& vbCrLf &_
					"from idioma_alumno a,niveles_idioma b,idioma c"& vbCrLf &_
					"where  a.nidi_ccod=b.nidi_ccod and a.idio_ccod=c.idio_ccod and pers_ncorr=protic.obtener_pers_ncorr("&q_pers_nrut&") "

  f_idioma.Consultar s_idioma
 'f_idioma.Siguiente
 'response.Write(s_idioma)
 'response.end()
 
 tfijo=f_datos_antecedentes.ObtenerValor("dire_tfono")
 tmovil=f_datos_antecedentes.ObtenerValor("dire_tcelular")
 correo=f_datos_antecedentes.ObtenerValor("pers_temail")
 
 
  'response.Write(selec_antecedentes&"<br/>")
  'response.Write(tfijo&"<br/>")
  'response.Write(tmovil&"<br/>")
 'response.end()
 set f_trabajo_actual = new CFormulario
 f_trabajo_actual.Carga_Parametros "tabla_vacia.xml", "tabla" 
 f_trabajo_actual.Inicializar conexion
 
 s_trabajo="select top 1 a.dlpr_ncorr,exal_ncorr ,dlpr_nombre_empresa,dlpr_rubro_empresa,dlpr_cargo_empresa,dlpr_web_empresa "& vbCrLf &_
			"from direccion_laboral_profesionales a,experiencia_alumno b "& vbCrLf &_
			"where a.dlpr_ncorr=b.dlpr_ncorr and tiea_ccod=1 and a.pers_ncorr=protic.obtener_pers_ncorr("&q_pers_nrut&") order  by exal_fini desc"
  f_trabajo_actual.Consultar s_trabajo
  
  
  
  
espacio="                "
Set pdf=CreateJsObject("FPDF") 

'pdf.Header=function Header()
'{
'
'    pdf.Image "upacificologopdf",10,8,33,"JPEG"
'    pdf.SetFont"Arial","B",15
'    pdf.Cell 80,0
'    pdf.Ln (20)
'}
'
'pdf.CreatePDF() 
'pdf.SetPath("../biblioteca/fpdf/") 
'pdf.SetFont "Arial","",12 
'pdf.Open() 
'pdf.AddPage() 



'------------------------------------------------------------pagina 1-------------------------------------------------------------------

pdf.ln(40)
pdf.Cell 42,1,"                                                       CURRICULUM VITAE" 
pdf.ln(20)
pdf.Cell 42,1,""&espacio&" DATOS  PERSONALES" 
pdf.ln(20)
pdf.cell 42,10, ""&espacio&"NOMBRE                                 :"
pdf.cell 42,10, ""&espacio&"                   "&f_datos_antecedentes.ObtenerValor("nombre")&""
pdf.ln()
pdf.cell 42,10, ""&espacio&"FECHA DE NACIMIENTO       :"
pdf.cell 42,10, ""&espacio&"                   "&f_datos_antecedentes.ObtenerValor("fnacimiento")&""
pdf.ln()
pdf.cell 42,10, ""&espacio&"NACIONALIDAD   	                  :"
pdf.cell 42,10, ""&espacio&"                   "&f_datos_antecedentes.ObtenerValor("nacionalidad")&""
pdf.ln()
pdf.cell 42,10, ""&espacio&"ESTADO CIVIL   	                    :"
pdf.cell 42,10, ""&espacio&"                   "&f_datos_antecedentes.ObtenerValor("estado_civil")&""
pdf.ln()
pdf.cell 42,10, ""&espacio&"DOMICILIO  	                           :"
pdf.cell 42,10, ""&espacio&"                   "&f_datos_antecedentes.ObtenerValor("direccion")&""
if tfijo <> "" then
pdf.ln()
pdf.cell 42,10, ""&espacio&"TELEFONO   	                         :"
pdf.cell 42,10, ""&espacio&"                   "&f_datos_antecedentes.ObtenerValor("dire_tfono")&""
end if
if tmovil <> "" then
pdf.ln()
pdf.cell 42,10, ""&espacio&"CELULAR   	                            :"
pdf.cell 42,10, ""&espacio&"                   "&f_datos_antecedentes.ObtenerValor("dire_tcelular")&""
end if

if correo <> "" then
pdf.ln()
pdf.cell 42,10, ""&espacio&"E-MAIL   	                                 :"
pdf.cell 42,10, ""&espacio&"                   "&f_datos_antecedentes.ObtenerValor("pers_temail")&""
end if

'------------------------------------------------------------pagina 2-------------------------------------------------------------------

 
'hh=1
if hh=0 then

pdf.ln()
pdf.AddPage() 
pdf.ln()


pdf.Cell 42,0,"                                                        DATOS PERSONALES" 
pdf.ln()
pdf.SetFont "Arial","",12
while f_idioma.siguiente 
pdf.ln()
pdf.cell 42,10, ""&espacio&"         NIVEL IDIOMA"
pdf.cell 42,10, ""&espacio&""&f_idioma.ObtenerValor("nidi_tdesc")&""
wend
end if
pdf.Close()
pdf.Output()
%> 