<!-- #include file="../biblioteca/_conexion.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.form(k)&"<br>")
'next
'response.End()
	
audi_tusuario	=	request.form("audi_tusuario")
secc_ccod	=	request.form("secc_ccod")	

set conectar		=	new cconexion
conectar.inicializar		"upacifico"


set f_alumnos = new CFormulario
f_alumnos.Carga_Parametros "tabla_vacia.xml", "tabla"
f_alumnos.Inicializar conectar

c_alumnos = " select a.matr_ncorr, pers_tape_paterno + ' ' + pers_tape_materno + ', ' + pers_tnombre as nombre, "&_
            "(select count(*) from calificaciones_seccion tt (nolock), calificaciones_alumnos t2 (nolock) "&_
			" where tt.secc_ccod=a.secc_ccod and tt.secc_ccod=t2.secc_ccod and tt.cali_ncorr=t2.cali_ncorr "&_
			" and t2.matr_ncorr=a.matr_ncorr and tt.cali_nevaluacion = 1) as nota_1, "&_
			"(select count(*) from calificaciones_seccion tt (nolock), calificaciones_alumnos t2 (nolock) "&_
			" where tt.secc_ccod=a.secc_ccod and tt.secc_ccod=t2.secc_ccod and tt.cali_ncorr=t2.cali_ncorr "&_
			" and t2.matr_ncorr=a.matr_ncorr and tt.cali_nevaluacion = 2) as nota_2, "&_
			"(select count(*) from calificaciones_seccion tt (nolock), calificaciones_alumnos t2 (nolock) "&_
			" where tt.secc_ccod=a.secc_ccod and tt.secc_ccod=t2.secc_ccod and tt.cali_ncorr=t2.cali_ncorr "&_
			" and t2.matr_ncorr=a.matr_ncorr and tt.cali_nevaluacion = 3) as nota_3, "&_
			"(select count(*) from calificaciones_seccion tt (nolock), calificaciones_alumnos t2 (nolock) "&_
			" where tt.secc_ccod=a.secc_ccod and tt.secc_ccod=t2.secc_ccod and tt.cali_ncorr=t2.cali_ncorr "&_
			" and t2.matr_ncorr=a.matr_ncorr and tt.cali_nevaluacion = 4) as nota_4, "&_
			"(select count(*) from calificaciones_seccion tt (nolock), calificaciones_alumnos t2 (nolock) "&_
			" where tt.secc_ccod=a.secc_ccod and tt.secc_ccod=t2.secc_ccod and tt.cali_ncorr=t2.cali_ncorr "&_
			" and t2.matr_ncorr=a.matr_ncorr and tt.cali_nevaluacion = 5) as nota_5, "&_
			"(select count(*) from calificaciones_seccion tt (nolock), calificaciones_alumnos t2 (nolock) "&_
			" where tt.secc_ccod=a.secc_ccod and tt.secc_ccod=t2.secc_ccod and tt.cali_ncorr=t2.cali_ncorr "&_
			" and t2.matr_ncorr=a.matr_ncorr and tt.cali_nevaluacion = 6) as nota_6, "&_ 
			"(select count(*) from calificaciones_seccion tt (nolock), calificaciones_alumnos t2 (nolock) "&_
			" where tt.secc_ccod=a.secc_ccod and tt.secc_ccod=t2.secc_ccod and tt.cali_ncorr=t2.cali_ncorr "&_
			" and t2.matr_ncorr=a.matr_ncorr and tt.cali_nevaluacion = 7) as nota_7, "&_
			"(select count(*) from calificaciones_seccion tt (nolock), calificaciones_alumnos t2 (nolock) "&_
			" where tt.secc_ccod=a.secc_ccod and tt.secc_ccod=t2.secc_ccod and tt.cali_ncorr=t2.cali_ncorr "&_
			" and t2.matr_ncorr=a.matr_ncorr and tt.cali_nevaluacion = 8) as nota_8, "&_
			"(select count(*) from calificaciones_seccion tt (nolock), calificaciones_alumnos t2 (nolock) "&_
			" where tt.secc_ccod=a.secc_ccod and tt.secc_ccod=t2.secc_ccod and tt.cali_ncorr=t2.cali_ncorr "&_
			" and t2.matr_ncorr=a.matr_ncorr and tt.cali_nevaluacion = 9) as nota_9, "&_
			"(select count(*) from calificaciones_seccion tt (nolock), calificaciones_alumnos t2 (nolock) "&_
			" where tt.secc_ccod=a.secc_ccod and tt.secc_ccod=t2.secc_ccod and tt.cali_ncorr=t2.cali_ncorr "&_
			" and t2.matr_ncorr=a.matr_ncorr and tt.cali_nevaluacion = 10) as nota_10, "&_
			"(select count(*) from calificaciones_seccion tt (nolock), calificaciones_alumnos t2 (nolock) "&_
			" where tt.secc_ccod=a.secc_ccod and tt.secc_ccod=t2.secc_ccod and tt.cali_ncorr=t2.cali_ncorr "&_
			" and t2.matr_ncorr=a.matr_ncorr and tt.cali_nevaluacion = 11) as nota_11, "&_
			"(select count(*) from calificaciones_seccion tt (nolock), calificaciones_alumnos t2 (nolock) "&_
			" where tt.secc_ccod=a.secc_ccod and tt.secc_ccod=t2.secc_ccod and tt.cali_ncorr=t2.cali_ncorr "&_
			" and t2.matr_ncorr=a.matr_ncorr and tt.cali_nevaluacion = 12) as nota_12, "&_
			"(select count(*) from calificaciones_seccion tt (nolock), calificaciones_alumnos t2 (nolock) "&_
			" where tt.secc_ccod=a.secc_ccod and tt.secc_ccod=t2.secc_ccod and tt.cali_ncorr=t2.cali_ncorr "&_
			" and t2.matr_ncorr=a.matr_ncorr and tt.cali_nevaluacion = 13) as nota_13, "&_
			"(select count(*) from calificaciones_seccion tt (nolock), calificaciones_alumnos t2 (nolock) "&_
			" where tt.secc_ccod=a.secc_ccod and tt.secc_ccod=t2.secc_ccod and tt.cali_ncorr=t2.cali_ncorr "&_
			" and t2.matr_ncorr=a.matr_ncorr and tt.cali_nevaluacion = 14) as nota_14, "&_
			"(select count(*) from calificaciones_seccion tt (nolock), calificaciones_alumnos t2 (nolock) "&_
			" where tt.secc_ccod=a.secc_ccod and tt.secc_ccod=t2.secc_ccod and tt.cali_ncorr=t2.cali_ncorr "&_
			" and t2.matr_ncorr=a.matr_ncorr and tt.cali_nevaluacion = 15) as nota_15, "&_
			"(select count(*) from calificaciones_seccion tt (nolock), calificaciones_alumnos t2 (nolock) "&_
			" where tt.secc_ccod=a.secc_ccod and tt.secc_ccod=t2.secc_ccod and tt.cali_ncorr=t2.cali_ncorr "&_
			" and t2.matr_ncorr=a.matr_ncorr and tt.cali_nevaluacion = 16) as nota_16, "&_
			"(select count(*) from calificaciones_seccion tt (nolock), calificaciones_alumnos t2 (nolock) "&_
			" where tt.secc_ccod=a.secc_ccod and tt.secc_ccod=t2.secc_ccod and tt.cali_ncorr=t2.cali_ncorr "&_
			" and t2.matr_ncorr=a.matr_ncorr and tt.cali_nevaluacion = 17) as nota_17, "&_
			"(select count(*) from calificaciones_seccion tt (nolock), calificaciones_alumnos t2 (nolock) "&_
			" where tt.secc_ccod=a.secc_ccod and tt.secc_ccod=t2.secc_ccod and tt.cali_ncorr=t2.cali_ncorr "&_
			" and t2.matr_ncorr=a.matr_ncorr and tt.cali_nevaluacion = 18) as nota_18, "&_
			"(select count(*) from calificaciones_seccion tt (nolock), calificaciones_alumnos t2 (nolock) "&_
			" where tt.secc_ccod=a.secc_ccod and tt.secc_ccod=t2.secc_ccod and tt.cali_ncorr=t2.cali_ncorr "&_
			" and t2.matr_ncorr=a.matr_ncorr and tt.cali_nevaluacion = 19) as nota_19, "&_
			"(select count(*) from calificaciones_seccion tt (nolock), calificaciones_alumnos t2 (nolock) "&_
			" where tt.secc_ccod=a.secc_ccod and tt.secc_ccod=t2.secc_ccod and tt.cali_ncorr=t2.cali_ncorr "&_
			" and t2.matr_ncorr=a.matr_ncorr and tt.cali_nevaluacion = 20) as nota_20 "&_
			" from cargas_academicas a, alumnos b, personas c "&_
			" where a.matr_ncorr=b.matr_ncorr and b.pers_ncorr=c.pers_ncorr and b.emat_ccod <> 9 "&_
			" and cast(a.secc_ccod as varchar)='"&secc_ccod&"' "&_
			" order by nombre "

f_alumnos.Consultar c_alumnos

set f_eva = new CFormulario
f_eva.Carga_Parametros "tabla_vacia.xml", "tabla"
f_eva.Inicializar conectar

c_eva = "select cali_ncorr,teva_tdesc as tipo, cali_nevaluacion,cali_nponderacion,protic.trunc(cali_fevaluacion) as fecha "&_
		" from calificaciones_seccion a,tipos_evaluacion b "&_
		" where a.teva_ccod=b.teva_ccod "&_
		" and cast(secc_ccod as varchar)='"&secc_ccod&"' "&_
		" order by cali_nevaluacion asc "

f_eva.Consultar c_eva

acciones = 0
while f_alumnos.siguiente
	matr_ncorr = f_alumnos.obtenerValor("matr_ncorr")
	
	f_eva.primero
	while f_eva.siguiente
	   cali_ncorr = f_eva.obtenerValor("cali_ncorr")
	   num        = f_eva.obtenerValor("cali_nevaluacion")
	   calificacion_ingresada = request.Form("m["&matr_ncorr&"][cali_"&cali_ncorr&"]") 
	   calificacion_registrada = request.Form("o["&matr_ncorr&"][cali_"&cali_ncorr&"]") 
	   tiene_registrada = f_alumnos.obtenerValor("nota_"&num)
	   if tiene_registrada <> "0" and calificacion_ingresada <> calificacion_registrada and calificacion_ingresada <> "" then
	     c_consulta2 = " insert into calificaciones_alumnos_log (MATR_NCORR,SECC_CCOD,CALI_NCORR,CALA_NNOTA,AUDI_TUSUARIO,AUDI_FMODIFICACION) "&_
		               " values ("&matr_ncorr&","&secc_ccod&","&cali_ncorr&","&calificacion_registrada&",'Modificado por "&audi_tusuario&"',getDate())"
		 conectar.ejecutaS c_consulta2
	     c_consulta = " update calificaciones_alumnos  set CALA_NNOTA="&calificacion_ingresada&", AUDI_TUSUARIO='"&audi_tusuario&"',AUDI_FMODIFICACION=getDate()"&_
		              " where cast(MATR_NCORR as varchar) = '"&matr_ncorr&"' and cast(SECC_CCOD as varchar)='"&secc_ccod&"' and cast(CALI_NCORR as varchar)='"&cali_ncorr&"'"				
	     conectar.ejecutaS c_consulta
		 acciones = acciones + 1
	   elseif tiene_registrada = "0" and calificacion_ingresada <> "" then
	   	 c_consulta = " insert into calificaciones_alumnos (MATR_NCORR,SECC_CCOD,CALI_NCORR,CALA_NNOTA,AUDI_TUSUARIO,AUDI_FMODIFICACION) "&_
		              " values ("&matr_ncorr&","&secc_ccod&","&cali_ncorr&","&calificacion_ingresada&",'"&audi_tusuario&"',getDate())"
		 conectar.ejecutaS c_consulta
		 acciones = acciones + 1
	   elseif tiene_registrada <> "0" and calificacion_ingresada = "" and calificacion_registrada <> "" then
	     c_consulta2 = " insert into calificaciones_alumnos_log (MATR_NCORR,SECC_CCOD,CALI_NCORR,CALA_NNOTA,AUDI_TUSUARIO,AUDI_FMODIFICACION) "&_
		               " values ("&matr_ncorr&","&secc_ccod&","&cali_ncorr&","&calificacion_registrada&",'Eliminado por "&audi_tusuario&"',getDate())"
		 conectar.ejecutaS c_consulta2
	   	 c_consulta =  " delete from calificaciones_alumnos "&_
		               " where cast(MATR_NCORR as varchar) = '"&matr_ncorr&"' and cast(SECC_CCOD as varchar)='"&secc_ccod&"' and cast(CALI_NCORR as varchar)='"&cali_ncorr&"'"
		 conectar.ejecutaS c_consulta
		 acciones = acciones + 1
	   end if
	   'response.Write("<br>"&c_consulta2)
	   'response.Write("<br>"&c_consulta)
	wend
wend
'response.End()
if conectar.ObtenerEstadoTransaccion = true and acciones > 0  then
	conectar.MensajeError "Se han realizado "&acciones&" accion(es) referida(s) a calificaciones en la asignatura."
elseif conectar.ObtenerEstadoTransaccion = false then
	conectar.MensajeError "Ocurrio un error al grabar las calificaciones, favor vuelva a intentarlo..."
end if


'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>