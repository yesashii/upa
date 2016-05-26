<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

'response.End()

v_secc_ccod=request.Form("secc_ccod")
cali_ncorr=request.Form("cali_ncorr")
cali_nponderacion=request.Form("m[0][cali_nponderacion]")
cali_nresolucion=request.Form("m[0][cali_nresolucion]")
cali_tobservacion=request.Form("m[0][cali_tobservacion]")



set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

set negocio = new Cnegocio
negocio.Inicializa conectar

if (cali_ncorr <> "") then
'------------------Debemos guardar la información de la calificación antigua antes de modificarla para tener un respaldo-----------
		'--------------------------agregado por msandoval---------------------------------------------------------------------
c_insertar = " insert into calificaciones_seccion_cambio (CALI_NCORR,SECC_CCOD,TEVA_CCOD,CALI_NEVALUACION,CALI_NPONDERACION,CALI_FEVALUACION,AUDI_TUSUARIO,AUDI_FMODIFICACION,CALI_NRESOLUCION,CALI_TOBSERVACION,CALI_TCONCEPTO) "&_
		     " select cali_ncorr,secc_ccod,teva_ccod,cali_nevaluacion,cali_nponderacion,cali_fevaluacion, audi_tusuario as audi_tusuario,getDate() as audi_fmodificacion,null,null,'ANTES DE CAMBIAR' as concepto "&_
		     " from calificaciones_seccion where cast(cali_ncorr as varchar)= '" & cali_ncorr & "'"
conectar.EjecutaS(c_insertar)
end if

formulario.carga_parametros "editar_evaluacion.xml", "agregar_eval_cambio"
formulario.inicializar conectar


	formulario.procesaForm

	if (cali_ncorr<>"") then
		v_cali_ncorr=cali_ncorr
		concepto = "Modificado"
	else	
		v_cali_ncorr=conectar.consultauno("execute obtenerSecuencia 'calificaciones_seccion'")
		concepto = "Agregado"
	end if
    'response.Write("<br>cali_ncorr "&v_cali_ncorr&" secc_ccod "&v_secc_ccod)
	formulario.AgregaCampoPost "cali_ncorr", v_cali_ncorr
	formulario.AgregaCampoPost "secc_ccod", v_secc_ccod

	'formulario.ListarPost

	formulario.mantienetablas false
	
	'conectar.estadoTransaccion false
	

   '------------------Insertamos los nuevos datos ya sean agregados o modificados-----------
   '--------------------------agregado por msandoval---------------------------------------------------------------------
   c_insertar = " insert into calificaciones_seccion_cambio (CALI_NCORR,SECC_CCOD,TEVA_CCOD,CALI_NEVALUACION,CALI_NPONDERACION,CALI_FEVALUACION,AUDI_TUSUARIO,AUDI_FMODIFICACION,CALI_NRESOLUCION,CALI_TOBSERVACION,CALI_TCONCEPTO) "&_
		        " select cali_ncorr,secc_ccod,teva_ccod,cali_nevaluacion,cali_nponderacion,cali_fevaluacion, '"&negocio.obtenerUsuario&"' as audi_tusuario,getDate() as audi_fmodificacion,'"&cali_nresolucion&"' as cali_nresolucion,'"&cali_tobservacion&"' as cali_tobservacion,'"&concepto&"' as concepto "&_
		        " from calificaciones_seccion where cast(cali_ncorr as varchar)= '" & v_cali_ncorr & "'"
   conectar.EjecutaS(c_insertar)

   'response.Write(c_insertar)
	'response.End()
	url="agregar_evaluacion.asp?secc_ccod="&v_secc_ccod



'response.Redirect(url)
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>