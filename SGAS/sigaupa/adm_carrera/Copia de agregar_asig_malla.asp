 <!-- #include file = "../biblioteca/_conexion.asp" -->

<%

'--------------------------------------------------------------------------------------------
set conectar	= new cConexion
set fasig  		= new cFormulario
set var_m		= new cvariables
'------------------------------------------------------------------------------------------

'v_nivel		=	request.Form("v_nivel")
'plan		=	request.Form("plan")
'plan_ccod	=	request.Form("plan2")

conectar.inicializar "desauas"

'-------------------------------------------------------------------
'-------------------------------------------------------------------

set formulario = new CFormulario
formulario.Carga_Parametros "adm_mallas_curriculares.xml", "f_agregar_asignatura"
formulario.Inicializar conectar
formulario.ProcesaForm
'formulario.listarpost
v_nivel = formulario.ObtenerValorPost (0, "nivel")
plan_ccod = formulario.ObtenerValorPost (0, "plan")
MALL_NOTA_PRESENTACION = formulario.ObtenerValorPost (0, "MALL_NOTA_PRESENTACION")
MALL_PORCENTAJE_PRESENTACION = formulario.ObtenerValorPost (0, "MALL_PORCENTAJE_PRESENTACION")
MALL_NEVALUACION_MINIMA = formulario.ObtenerValorPost (0, "MALL_NEVALUACION_MINIMA")
MALL_PORCENTAJE_ASISTENCIA = formulario.ObtenerValorPost (0, "MALL_PORCENTAJE_ASISTENCIA")
'-------------------------------------------------------------------
'-------------------------------------------------------------------

fasig.carga_parametros "adm_mallas_curriculares.xml", "form_agrega_asig"
fasig.inicializar conectar
fasig.procesaform
'fasig.listarpost
'------------------------------------------------------------------------------------------

'response.Write("NIVEL :" & v_nivel & "  PLAN: " & plan_ccod & "<BR><BR>")
'response.End()
'var_m.procesaform
'fasig.listarpost

for fila = 0 to fasig.CuentaPost - 1
    asig_ccod   = fasig.ObtenerValorPost (fila, "asig_ccod")    	
	if asig_ccod <> "" then
      fasig.agregaCampoFilaPost fila, "plan_ccod", plan_ccod 
	  fasig.agregaCampoFilaPost fila, "nive_ccod", v_nivel 
	  fasig.agregaCampoFilaPost fila, "MALL_NOTA_PRESENTACION", MALL_NOTA_PRESENTACION
	  fasig.agregaCampoFilaPost fila, "MALL_PORCENTAJE_PRESENTACION", MALL_PORCENTAJE_PRESENTACION
	  fasig.agregaCampoFilaPost fila, "MALL_NEVALUACION_MINIMA", MALL_NEVALUACION_MINIMA
	  fasig.agregaCampoFilaPost fila, "MALL_PORCENTAJE_ASISTENCIA", MALL_PORCENTAJE_ASISTENCIA
	  
	  mall_ccod=conectar.consultauno("select mall_ccod_seq.nextval from dual")
	  fasig.agregaCampoFilaPost fila, "mall_ccod", mall_ccod
	else
       fasig.EliminaFilaPost fila    
    end if 
	
	cuenta = CInt(conectar.ConsultaUno("select count(*) from malla_curricular where plan_ccod = '" & plan_ccod & "' and asig_ccod = '" & asig_ccod & "'"))
	if cuenta > 0 then
		fasig.EliminaFilaPost fila    
	end if
next
'fasig.listarpost

fasig.mantieneTablas false
'conectar.estadotransaccion false  'roolback  


'if var_m.nrofilas("M") > 0 then
'	for k=0 to var_m.nrofilas("M")-1
'		if var_m.obtenervalor("m",k,"asig_ccod") <> "" then
'			asig=var_m.obtenervalor("m",k,"asig_ccod")
'			verif=conectar.consultauno("select mall_ccod from malla_curricular where plan_ccod='"&plan&"' and asig_ccod='"&asig&"'")
'			'response.Write("select mall_ccod from malla_curricular where plan_ccod='"&plan&"' and asig_ccod='"&asig&"'")
'			'response.Flush()
'			if isnull(verif) or verif="" then
'				mall_ccod=conectar.consultauno("select mall_ccod_seq.nextval from dual")
'				fasig.agregaCampoPost "mall_ccod", mall_ccod
'				fasig.agregaCampoPost "asig_ccod", asig
'				fasig.agregaCampoPost "nive_ccod", v_nivel
'				fasig.agregaCampoPost "plan_ccod", plan
'				fasig.mantieneTablas 	true
'		    end if
'			verif=""
'		
'		end if
'	next
'end if


%>
<script language="JavaScript">
opener.location.reload();
window.close();
</script>


