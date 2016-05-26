<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

pers_nrut=request.Form("busqueda[0][pers_nrut]")
pers_xdv=request.Form("busqueda[0][pers_xdv]")
matr_monto=request.Form("matricula_bene")
matr_porc=request.Form("matricula_porc")
aran_monto=request.Form("arancel_bene")
aran_porc=request.Form("arancel_porc")
carrera=request.Form("a[0][carrera]")
tipo= request.Form("condicionales")
tipo1=request.Form("tipo")
post_ncorr=request.Form("post_ncorr")
ofer_ncorr=request.Form("ofer_ncorr")
pers_ncorr=request.Form("pers_ncorr")
peri_ccod=request.Form("peri_ccod")
tipo_pase_sem=request.Form("tipo2")

'response.Write(tipo_pase_sem)
'response.End()
'response.Write("post_ncorr:"&post_ncorr&" -ofer_ncorr:"&ofer_ncorr&" -aran_porc:"&aran_porc&" -matr_porc"&matr_porc&"<br>")
v_usuario 	= negocio.ObtenerUsuario()

consulta="Select count(*) from pase_matricula a, ofertas_academicas b,especialidades c " & vbCrLf &_
         " where a.pers_ncorr='"&pers_ncorr&"'" & vbCrLf &_
		 " and a.peri_ccod='"&peri_ccod&"' and a.ofer_ncorr=b.ofer_ncorr" & vbCrLf &_
		 " and b.espe_ccod=c.espe_ccod" & vbCrLf &_ 
		 " and cast(c.carr_ccod as varchar)='"&carrera&"'"
'response.Write("<pre>"&consulta&"</pre>")				 
'response.End()
carrera_guardada=conexion.consultaUno(consulta)
'response.Write("<br>carrera actual "&carrera&" carrera_guardada "&carrera_guardada)
'response.End()
if carrera_guardada > "0" then
    consulta="Select a.pama_ncorr from pase_matricula a, ofertas_academicas b,especialidades c " & vbCrLf &_
         " where a.pers_ncorr='"&pers_ncorr&"'" & vbCrLf &_
		 " and a.peri_ccod='"&peri_ccod&"' and a.ofer_ncorr=b.ofer_ncorr" & vbCrLf &_
		 " and b.espe_ccod=c.espe_ccod" & vbCrLf &_ 
		 " and cast(c.carr_ccod as varchar)='"&carrera&"'"

    'response.Write("<pre>"&consulta&"</pre>")		 
	'response.End()
    pama_ncorr=conexion.consultaUno(consulta)

else
   pama_ncorr=conexion.consultaUno("execute obtenersecuencia 'pase_matricula'")
end if


'response.End()
if tipo="1" then
	texto="Hasta 2 asignaturas"
elseif tipo="2" then
	texto="Desde 3 asignaturas"
elseif tipo="3" then
	texto="Práctica Profesional"
elseif tipo="4" then
	texto="Examen de título por rendir"
elseif tipo="5" then
    texto="Alumno último semestre"
elseif tipo="6" then
    texto="Alumno con Carga Académica 2do. Semestre."

end if

set f_pase_matricula = new CFormulario
f_pase_matricula.Carga_Parametros "pase_matricula.xml", "agrega_pase"
f_pase_matricula.Inicializar conexion
f_pase_matricula.ProcesaForm


f_pase_matricula.AgregaCampoPost "pama_ncorr", pama_ncorr
f_pase_matricula.AgregaCampoPost "post_ncorr", post_ncorr
f_pase_matricula.AgregaCampoPost "ofer_ncorr", ofer_ncorr
f_pase_matricula.AgregaCampoPost "pers_ncorr", pers_ncorr
f_pase_matricula.AgregaCampoPost "peri_ccod", peri_ccod
f_pase_matricula.AgregaCampoPost "pama_tipo_pase", tipo
f_pase_matricula.AgregaCampoPost "pama_mmatricula", matr_monto
f_pase_matricula.AgregaCampoPost "pama_mcolegiatura", aran_monto
f_pase_matricula.AgregaCampoPost "pama_nporc_matricula", matr_porc
f_pase_matricula.AgregaCampoPost "pama_nporc_colegiatura", aran_porc
f_pase_matricula.AgregaCampoPost "pama_tobservaciones", texto


f_pase_matricula.MantieneTablas false

'conexion.estadotransaccion false  'roolback 
'response.End()

if tipo_pase_sem="1" then
	texto_sem="Primer semestre"
elseif tipo="2" then
	texto_sem="Segundo semestre"
elseif tipo="3" then
	texto_sem="Ambos semestres"
end if

'************ Agrega Tipo Pase matricula semestral 27-10-2015 Rpavez************
'response.Write(tipo)
'response.End()

if tipo="1" then

	'**** Busca Tipo pase Semestral********

	query = "select pmse_ncorr from pase_matricula_semestral where pama_ncorr="&pama_ncorr

	pmse_ncorr_paso=conexion.consultaUno(query)
'response.Write("pmse_ncorr_paso"&pmse_ncorr_paso)
'response.End()
	if isnull(pmse_ncorr_paso) then
	pmse_ncorr=conexion.consultaUno("execute obtenersecuencia 'pase_matricula_semestral'")
	'response.Write(pmse_ncorr)

	query_pase_sem = "insert into pase_matricula_semestral values ('"&pmse_ncorr&"',"&pama_ncorr&","&tipo_pase_sem&","&v_usuario&",GETDATE())"	
	else
	query_pase_sem = "update pase_matricula_semestral set pmse_tipo_pase="&tipo_pase_sem&", audi_tusuario="&v_usuario&",audi_fmodificacion=GETDATE() where pama_ncorr="&pama_ncorr	
	end if
'response.Write(query)
'response.Write(query_pase_sem)
'response.End()
	
	conexion.EjecutaS(query_pase_sem)
end if

'---------------------------------------------------------------------------------------------------------
ruta="pase_matricula.asp?busqueda[0][pers_nrut]="&pers_nrut&"&busqueda[0][pers_xdv]="&pers_xdv
Response.Redirect(ruta)
%>
