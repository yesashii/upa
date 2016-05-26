<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
q_seguir = Request.QueryString("seguir")
q_plan_ccod = Request.Form("dp[0][plan_ccod]")
q_peri_ccod = Request.QueryString("peri_ccod")

tiene_licenciatura = request.Form("_salidas[0][tiene_licenciatura]")
'------------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'conexion.EstadoTransaccion false

set f_salidas = new CFormulario
f_salidas.Carga_Parametros "adm_titulados.xml", "salidas_alumnos"
f_salidas.Inicializar conexion
f_salidas.ProcesaForm


set f_elimina_salidas = new CFormulario
f_elimina_salidas.Carga_Parametros "adm_titulados.xml", "elimina_salidas_alumnos"
f_elimina_salidas.Inicializar conexion
f_elimina_salidas.ProcesaForm

carr_ccod = conexion.consultaUno("select ltrim(rtrim(carr_ccod)) from planes_estudio a, especialidades b where a.espe_ccod=b.espe_ccod and cast(a.plan_ccod as varchar)='"&q_plan_ccod&"'")
if carr_ccod = "51" or carr_ccod = "930" or carr_ccod = "810" or carr_ccod = "920" then 
	carr_ccod = "51"
end if 

if carr_ccod = "12" or carr_ccod = "910" or carr_ccod = "900" or carr_ccod = "890" then 
	carr_ccod="12"
end if
'response.Write("select ltrim(rtrim(carr_ccod)) from planes_estudio a, especialidades b where a.espe_ccod=b.espe_ccod and cast(a.plan_ccod as varchar)='"&q_plan_ccod&"'<br>")
for i_ = 0 to f_salidas.CuentaPost - 1
	v_bguardar = f_salidas.ObtenerValorPost(i_, "bguardar")
	v_salu_ncorr = f_salidas.ObtenerValorPost(i_, "salu_ncorr")
	v_salu_fsalida = f_salidas.ObtenerValorPost(i_, "salu_fsalida")
	v_salu_nregistro = f_salidas.ObtenerValorPost(i_, "salu_nregistro")
	if esVacio(v_salu_ncorr) then
		v_salu_ncorr=conexion.consultaUno("execute obtenerSecuencia 'salidas_alumnos'")
		f_salidas.AgregaCampoFilaPost i_ , "salu_ncorr" , v_salu_ncorr 
	end if
	
	if tiene_licenciatura="S" then 
	   f_salidas.AgregaCampoFilaPost i_ , "tiene_licenciatura" , "S"
	   f_salidas.AgregaCampoFilaPost i_ , "cod_registro" , request.Form("salidas[0][cod_registro]")
	else
	   f_salidas.AgregaCampoFilaPost i_ , "tiene_licenciatura" , "N"
	   f_salidas.AgregaCampoFilaPost i_ , "cod_registro" , null
	end if
	
	folio_final = conexion.consultaUno("select '"&carr_ccod&"' + '-' + ltrim(rtrim('"&v_salu_nregistro&"')) + '-' + cast(datepart(year,convert(datetime,'"&v_salu_fsalida&"',103)) as varchar)")
	'response.Write(folio_final)
	'response.End()
	f_salidas.AgregaCampoFilaPost i_ , "salu_nfolio" , folio_final
	if v_bguardar = "N" then
		f_salidas.EliminaFilaPost i_
		'response.Write("<br>ELiminando fila " & i_ & " de salidas")
	else
		f_elimina_salidas.EliminaFilaPost i_
		'response.Write("<br>ELiminando fila " & i_ & " de elimina_salidas<br>")
	end if
next

f_salidas.MantieneTablas false
f_elimina_salidas.MantieneTablas false


'response.End()

'------------------------------------------------------------------------------------------------------
if q_seguir = "S" then
    %>
	<script language="javascript">	
	opener.location.reload();
	navigate('<%="adm_titulados_agregar.asp?dp[0][plan_ccod]=" & q_plan_ccod & "&dp[0][peri_ccod]=" & q_peri_ccod%>');
	</script>
	<%    
else
%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>
<%
end if
%>
