<!-- #include file="../biblioteca/_conexion.asp"-->

<%
'--------------------------------------------------------------------------------------------
set conectar	= new cConexion
set fasig  		= new cFormulario
set var_m		= new cvariables
'------------------------------------------------------------------------------------------

v_nivel		=	request.Form("v_nivel")
plan		=	request.Form("plan")

conectar.inicializar "upacifico"

fasig.carga_parametros "adm_mallas_curriculares.xml", "form_ingr_asig"
fasig.inicializar conectar
'response.Write("Agregar asignatura a malla")
'------------------------------------------------------------------------------------------
fasig.procesaform
var_m.procesaform

if var_m.nrofilas("M") > 0 then
	for k=0 to var_m.nrofilas("M")-1
		if var_m.obtenervalor("m",k,"asig_ccod") <> "" then
			asig=var_m.obtenervalor("m",k,"asig_ccod")
			verif=conectar.consultauno("select mall_ccod from malla_curricular where plan_ccod='"&plan&"' and asig_ccod='"&asig&"'")
			'response.Write("select mall_ccod from malla_curricular where plan_ccod='"&plan&"' and asig_ccod='"&asig&"'")
			'response.Flush()
			if isnull(verif) or verif="" then
				mall_ccod=conectar.consultauno("execute obtenersecuencia 'malla_curricular'")
				fasig.agregaCampoPost "mall_ccod", mall_ccod
				fasig.agregaCampoPost "asig_ccod", asig
				fasig.agregaCampoPost "nive_ccod", v_nivel
				fasig.agregaCampoPost "plan_ccod", plan
				fasig.agregaCampoPost "mall_npermiso",0
				fasig.mantieneTablas false
		    end if
			verif=""
		
		end if
	next
end if
'response.End()
%>
<script language="JavaScript">
opener.location.reload();
window.close();
</script>


