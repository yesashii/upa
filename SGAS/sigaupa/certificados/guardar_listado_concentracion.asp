<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%

'for each k in request.Form()
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
tiene_salida_intermedia = request.Form("tiene_salida_intermedia")
'response.Write(tiene_salida_intermedia)

set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

pers_ncorr=request.Form("pers_ncorr")
plan_ccod = request.Form("enca[0][carreras_alumno]")
'response.Write("<hr>"&plan_ccod&"<hr>")
if plan_ccod="" then
	plan_consulta = "0"
else
	plan_consulta = plan_ccod
end if 
'response.End()
formulario.carga_parametros "conc_notas.xml", "notas_nuevo"
formulario.inicializar conectar
msj_topones=""
formulario.procesaForm

if not esVacio(pers_ncorr) then
consulta_delete1 = " delete from concentracion_notas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'  and cast(plan_ccod as varchar)='"&plan_consulta&"'"
conectar.ejecutaS consulta_delete1
'response.Write(consulta_delete1)
end if
'response.End()
for i=0 to formulario.cuentaPost - 1
    
	asig_ccod=formulario.obtenerValorPost(i,"asig_ccod_guardar")
	asig_tdesc=formulario.obtenerValorPost(i,"asig_tdesc_guardar")
	nota_final=formulario.obtenerValorPost(i,"nota_final_guardar")
	sitf_ccod=formulario.obtenerValorPost(i,"sitf_guardar")
	anos_ccod=formulario.obtenerValorPost(i,"anos_guardar")
	plec_ccod=formulario.obtenerValorPost(i,"plec_guardar")
	horas=formulario.obtenerValorPost(i,"horas_guardar")
	cantidad=formulario.obtenerValorPost(i,"cantidad_guardar")
	esta_guardada=formulario.obtenerValorPost(i,"esta_guardada")


	if not EsVacio(asig_ccod) and not EsVacio(pers_ncorr) and esta_guardada = "1" then
		esta= conectar.consultaUno("select count(*) from concentracion_notas where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and asig_ccod='"&asig_ccod&"' and cast(anos_ccod as varchar)='"&anos_ccod&"' and cast(plan_ccod as varchar)='"&plan_consulta&"'")
		if esta = "0" then
		   if tiene_salida_intermedia = "0" then
				if not isnull(nota_final) and nota_final <> "" then
				   consulta_insert = "insert into concentracion_notas (pers_ncorr,asig_ccod,asig_tdesc,nota_final,sitf_ccod,anos_ccod,plec_ccod,horas,cantidad,audi_tusuario,audi_fmodificacion,plan_ccod) "&_
									 " values ("&pers_ncorr&",'"&asig_ccod&"','"&asig_tdesc&"',"&nota_final&",'"&sitf_ccod&"','"&anos_ccod&"','"&plec_ccod&"',"&horas&_
									 ",'"&cantidad&"','"&negocio.obtenerUsuario&"',getDate(),"&plan_consulta&")"
				else				  
				   consulta_insert = "insert into concentracion_notas (pers_ncorr,asig_ccod,asig_tdesc,nota_final,sitf_ccod,anos_ccod,plec_ccod,horas,cantidad,audi_tusuario,audi_fmodificacion,plan_ccod) "&_
									 " values ("&pers_ncorr&",'"&asig_ccod&"','"&asig_tdesc&"',null,'"&sitf_ccod&"','"&anos_ccod&"','"&plec_ccod&"',"&horas&_
									 ",'"&cantidad&"','"&negocio.obtenerUsuario&"',getDate(),"&plan_consulta&")"
				end if					
			else ' cuando es salida intermedia
				if not isnull(nota_final) and nota_final <> "" then
				   consulta_insert = "insert into concentracion_notas (pers_ncorr,asig_ccod,asig_tdesc,nota_final,sitf_ccod,anos_ccod,plec_ccod,horas,cantidad,audi_tusuario,audi_fmodificacion,plan_ccod,salida_intermedia) "&_
									 " values ("&pers_ncorr&",'"&asig_ccod&"','"&asig_tdesc&"',"&nota_final&",'"&sitf_ccod&"','"&anos_ccod&"','"&plec_ccod&"',"&horas&_
									 ",'"&cantidad&"','"&negocio.obtenerUsuario&"',getDate(),"&plan_consulta&",'s.i')"
				else				  
				   consulta_insert = "insert into concentracion_notas (pers_ncorr,asig_ccod,asig_tdesc,nota_final,sitf_ccod,anos_ccod,plec_ccod,horas,cantidad,audi_tusuario,audi_fmodificacion,plan_ccod,salida_intermedia) "&_
									 " values ("&pers_ncorr&",'"&asig_ccod&"','"&asig_tdesc&"',null,'"&sitf_ccod&"','"&anos_ccod&"','"&plec_ccod&"',"&horas&_
									 ",'"&cantidad&"','"&negocio.obtenerUsuario&"',getDate(),"&plan_consulta&",'s.i')"
				end if
			end if			 
				'response.Write(consulta_insert)
				conectar.ejecutaS consulta_insert
		end if
		
	end if 
next 
'response.End()
conectar.MensajeError "Se han grabado las asignaturas seleccionadas, ahorá puede imprimir el acta correspondiente."
'conectar.estadotransaccion false

response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>
