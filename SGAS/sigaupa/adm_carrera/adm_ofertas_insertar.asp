<!-- #include file="../biblioteca/_conexion.asp"-->

<%

'for each x in request.Form
'	response.Write("<br>"&x&"->"&request.Form(x))
'next

set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_consulta = new CFormulario
f_consulta.Carga_Parametros "andres.xml", "consulta"
f_consulta.Inicializar conexion

set f_consulta_2 = new CFormulario
f_consulta_2.Carga_Parametros "andres.xml", "consulta"
f_consulta_2.Inicializar conexion

set t_ofertas_academicas = new CFormulario
t_ofertas_academicas.Carga_Parametros "adm_ofertas_agregar.xml", "t_ofertas_academicas"
t_ofertas_academicas.Inicializar conexion
t_ofertas_academicas.ProcesaForm


for i = 0 to t_ofertas_academicas.CuentaPost
			

			'a_aran_ncorr = conexion.ConsultaUno("SELECT aran_ncorr_seq.nextval FROM dual")
			v_paga_examen = Request.Form("ofertas[0][ofer_bpaga_examen]")
			if v_paga_examen=1 then
				t_ofertas_academicas.AgregaCampoFilaPost i, "ofer_bpaga_examen", "S"
			else
				t_ofertas_academicas.AgregaCampoFilaPost i, "ofer_bpaga_examen", "N"
			end if	
			v_ofer_bpublico = Request.Form("ofertas[0][ofer_bpublica]")
			if v_ofer_bpublico=1 then
				t_ofertas_academicas.AgregaCampoFilaPost i, "ofer_bpublica", "S"
			else
				t_ofertas_academicas.AgregaCampoFilaPost i, "ofer_bpublica", "N"
			end if
			
			v_ofer_bactiva = Request.Form("ofertas[0][ofer_bactiva]")
			if v_ofer_bactiva=1 then
				t_ofertas_academicas.AgregaCampoFilaPost i, "ofer_bactiva", "S"
			else
				t_ofertas_academicas.AgregaCampoFilaPost i, "ofer_bactiva", "N"
			end if	
next

set t_aranceles = new CFormulario
t_aranceles.Carga_Parametros "adm_ofertas_agregar.xml", "t_aranceles"
t_aranceles.Inicializar conexion
t_aranceles.ProcesaForm

t_aranceles.AgregaCampoPost "aran_cvigente_fup", "S"


'-------------------------------------------------------------------------------------------------------------------
consulta = "SELECT count(*) AS cuenta " &_
           "FROM ofertas_academicas " &_
		   "WHERE sede_ccod = " & Request.Form("ofertas[0][sede_ccod]") & " AND " &_
		   "      espe_ccod = '" & v_espe_ccod & "' AND " &_
		   "	  peri_ccod = " & Request.Form("ofertas[0][peri_ccod]") & " and " &_
		   "	  post_bnuevo = '" & Request.Form("ofertas[0][post_bnuevo]")& "' and " &_
		   "	  jorn_ccod = " & Request.Form("ofertas[0][jorn_ccod]") 
	
'response.Write("<hr>cuenta: "&consulta)		   

f_consulta.Consultar consulta
f_consulta.Siguiente
cuenta = CInt(f_consulta.ObtenerValor("cuenta"))

if cuenta <= 0 then
	t_ofertas_academicas.MantieneTablas false
	t_aranceles.MantieneTablas false
end if

'response.end
'response.Write("<br>"&conexion.obtenerestadotransaccion)
'-------------------------------------------------------------------------------------------------------------------
consulta = "SELECT * " &_
           "FROM periodos_academicos " &_
		   "WHERE peri_ccod > " & Request.Form("ofertas[0][peri_ccod]") & " " &_
		   "ORDER BY peri_ccod ASC"
 

plec_ccod = conexion.ConsultaUno("SELECT plec_ccod FROM periodos_academicos WHERE peri_ccod = " & Request.Form("ofertas[0][peri_ccod]")) 
anos_ccod = conexion.ConsultaUno("SELECT anos_ccod FROM periodos_academicos WHERE peri_ccod = " & Request.Form("ofertas[0][peri_ccod]")) 

consulta = "SELECT * " &_
           "FROM periodos_academicos " &_
		   "WHERE peri_ccod >= " & Request.Form("ofertas[0][peri_ccod]") & " AND " &_
		   "	  anos_ccod = " & anos_ccod & " " &_
		   "ORDER BY peri_ccod ASC"
	'	   "     plec_ccod = decode(" & plec_ccod & ", 1, 3, 3, 0) AND " &_


f_consulta.Inicializar conexion
f_consulta.Consultar consulta

while f_consulta.Siguiente
	a_peri_ccod = f_consulta.ObtenerValor("peri_ccod")
	
	consulta = "SELECT count(*) AS cuenta " &_
               "FROM ofertas_academicas " &_
		       "WHERE sede_ccod = " & Request.Form("ofertas[0][sede_ccod]") & " AND " &_
		       "      espe_ccod = '" & Request.Form("ofertas[0][espe_ccod]") & "' AND " &_
		       "	  peri_ccod = " & a_peri_ccod & " AND " &_
			   "	  post_bnuevo = '" & Request.Form("ofertas[0][post_bnuevo]")& "' and " &_
		       "	  jorn_ccod = " & Request.Form("ofertas[0][jorn_ccod]")	

	f_consulta_2.Inicializar conexion		   
	f_consulta_2.Consultar consulta
	f_consulta_2.Siguiente
	cuenta = CInt(f_consulta_2.ObtenerValor("cuenta"))

	if cuenta <= 0 then
	'	a_ofer_ncorr = conexion.ConsultaUno("SELECT ofer_ncorr_seq.nextval FROM dual")
	'	a_aran_ncorr = conexion.ConsultaUno("SELECT ofer_ncorr_seq.nextval FROM dual")
		a_ofer_ncorr = Request.Form("ofertas[0][ofer_ncorr]")
		a_aran_ncorr = Request.Form("ofertas[0][aran_ncorr]")
		
		t_ofertas_academicas.AgregaCampoPost "ofer_ncorr", a_ofer_ncorr
		t_ofertas_academicas.AgregaCampoPost "peri_ccod", a_peri_ccod
		t_ofertas_academicas.AgregaCampoPost "aran_ncorr", a_aran_ncorr

		t_aranceles.AgregaCampoPost "peri_ccod", a_peri_ccod
		t_aranceles.AgregaCampoPost "ofer_ncorr", a_ofer_ncorr		
		
		for i = 0 to t_aranceles.CuentaPost
			'a_aran_ncorr = conexion.ConsultaUno("SELECT aran_ncorr_seq.nextval FROM dual")
			a_aran_ncorr = Request.Form("ofertas[0][aran_ncorr]")

			t_aranceles.AgregaCampoFilaPost i, "aran_ncorr", a_aran_ncorr
		next
		
		t_ofertas_academicas.MantieneTablas false
		t_aranceles.MantieneTablas false
		
	end if	

wend 
'conexion.estadotransaccion false
'response.End()
'--------------------------------------------------------------------------------------------------------------------
%>

<script language="JavaScript">
opener.location.reload();
window.close();
</script>
