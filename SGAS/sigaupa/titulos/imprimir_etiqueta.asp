<%@language=vbscript%>
<!-- #include file = "../biblioteca/fpdf.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
pers_ncorr = Request.QueryString("pers_ncorr")

set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_etiqueta = new CFormulario
f_etiqueta.Carga_Parametros "tabla_vacia.xml", "tabla"
f_etiqueta.Inicializar conexion

filtro = ""
if pers_ncorr <> "" then
	filtro = " and cast(c.pers_ncorr as varchar)='"&pers_ncorr&"'"
end if

SQL =   " select distinct c.pers_tape_paterno + ' ' + c.pers_tape_materno as apellidos,  " & vbCrLf &_
		" c.pers_tnombre as nombres, protic.format_rut(c.pers_nrut) as rut,  " & vbCrLf &_
		" d.carr_tdesc as carrera,  " & vbCrLf &_
		" (select top 1 sede_tdesc   " & vbCrLf &_
		" from alumnos tt, ofertas_academicas t2, especialidades t3, sedes t4  " & vbCrLf &_
		" where tt.ofer_ncorr = t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod  " & vbCrLf &_
		" and tt.pers_ncorr = a.pers_ncorr and t3.carr_ccod = d.carr_ccod   " & vbCrLf &_
		" and t2.sede_ccod = t4.sede_ccod  " & vbCrLf &_
	    " order by peri_ccod, tt.alum_fmatricula desc) as sede,  " & vbCrLf &_
        " a.pers_ncorr,a.plan_ccod,a.carr_ccod   " & vbCrLf &_
		" from detalles_titulacion_carrera a, personas c, carreras d " & vbCrLf &_
		" where isnull(imprimir_etiqueta,0) = 1  " & vbCrLf &_
		" and a.pers_ncorr=c.pers_ncorr  "&filtro & vbCrLf &_
		" and a.carr_ccod=d.carr_ccod  " & vbCrLf &_
		" and exists (select 1 from planes_estudio tt where tt.plan_ccod=a.plan_ccod)  " & vbCrLf &_
		" union  " & vbCrLf &_
		" select distinct c.pers_tape_paterno + ' ' + c.pers_tape_materno as apellidos,  " & vbCrLf &_
		" c.pers_tnombre as nombres, protic.format_rut(c.pers_nrut) as rut,  " & vbCrLf &_
		" d.saca_tdesc as carrera, e.sede_tdesc as sede,a.pers_ncorr,a.plan_ccod,a.carr_ccod   " & vbCrLf &_
		" from detalles_titulacion_carrera a, alumnos_salidas_carrera b, personas c, salidas_carrera d, sedes e  " & vbCrLf &_
		" where isnull(imprimir_etiqueta,0) = 1  " & vbCrLf &_
		" and a.pers_ncorr=b.pers_ncorr   " & vbCrLf &_
		" and a.pers_ncorr=c.pers_ncorr  "&filtro & vbCrLf &_
		" and b.saca_ncorr=d.saca_ncorr and b.sede_ccod=e.sede_ccod  " & vbCrLf &_
		" and not exists (select 1 from planes_estudio tt where tt.plan_ccod=a.plan_ccod) "
		
      
f_etiqueta.Consultar SQL
'f_etiqueta.siguiente


Set pdf=CreateJsObject("FPDF")
pdf.CreatePDF()
pdf.SetPath("../biblioteca/fpdf/" )
pdf.SetFont "times","",10
pdf.Open()
total = 13 'tendrá el total de registros
while f_etiqueta.siguiente
  apellidos = f_etiqueta.obtenerValor("apellidos")
  nombres = f_etiqueta.obtenerValor("nombres")
  rut = f_etiqueta.obtenerValor("rut")
  carrera = f_etiqueta.obtenerValor("carrera")
  sede = f_etiqueta.obtenerValor("sede")
  pers_ncorr = f_etiqueta.obtenerValor("pers_ncorr")
  plan_ccod  = f_etiqueta.obtenerValor("plan_ccod")
  carr_ccod  = f_etiqueta.obtenerValor("carr_ccod")
  
  c_update = "update detalles_titulacion_carrera set fecha_impresion_etiqueta = getDate() where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(plan_ccod as varchar)='"&plan_ccod&"' and carr_ccod='"&carr_ccod&"'"
  conexion.ejecutaS c_update	
	
   if total = 13 then
		pdf.AddPage()
		total = 0
		pdf.ln(8)
	else
		pdf.ln(10)
	end if
    
	pdf.SetFont "times","",10
	pdf.Cell 180,0,"      ","","","L"
	pdf.SetX(30)
	pdf.Cell 150,0,apellidos,"","","L"
	pdf.SetX(155)
	pdf.Cell 25,0,rut,"","","L"
	pdf.ln(5)
	pdf.SetFont "times","",10
	pdf.Cell 180,0,"      ","","","L"
	pdf.SetX(30)
	pdf.Cell 150,0,nombres,"","","L"
	pdf.SetX(155)
	pdf.Cell 25,0,sede,"","","L"
	pdf.ln(5)
	pdf.SetFont "times","",10
	pdf.Cell 180,0,"      ","","","L"
	pdf.SetX(50)
	pdf.Cell 130,0,carrera,"","","L"

total = total + 1
wend

pdf.Close()
pdf.Output()
%> 
