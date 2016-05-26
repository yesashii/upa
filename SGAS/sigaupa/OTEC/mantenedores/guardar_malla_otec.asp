<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
set conectar = new CConexion
conectar.Inicializar "upacifico"

set formulario = new cformulario
formulario.carga_parametros "m_diplomados_curso.xml", "form_busca_modulos"
formulario.inicializar conectar

set negocio = new CNegocio
negocio.Inicializa conectar

formulario.procesaForm
for i=0 to formulario.cuentaPost - 1
	mote_ccod=formulario.obtenerValorPost(i,"mote_ccod")
	dcur_ncorr=formulario.obtenerValorPost(i,"dcur_ncorr")
	horas_programa=formulario.obtenerValorPost(i,"maot_nhoras_programa")
	presupuesto=formulario.obtenerValorPost(i,"maot_npresupuesto_relator")
	horasa=formulario.obtenerValorPost(i,"maot_nhoras_ayudantia")
	presupuestoa=formulario.obtenerValorPost(i,"maot_npresupuesto_ayudantia")
	horasi=formulario.obtenerValorPost(i,"maot_nhoras_elearning")
	presupuestoi=formulario.obtenerValorPost(i,"maot_npresupuesto_elearning")
	horasbi=formulario.obtenerValorPost(i,"maot_nhoras_bilearning")
	presupuestobi=formulario.obtenerValorPost(i,"maot_npresupuesto_bilearning")
	dcur_norden=formulario.obtenerValorPost(i,"dcur_norden")
	maot_ncorr=conectar.consultauno("execute obtenersecuencia 'mallas_otec'")
	if dcur_norden = "" or esVacio(dcur_norden) then
		dcur_norden = "1"
	end if
	usuario = negocio.obtenerUsuario
	if not EsVacio(dcur_ncorr) and not EsVacio(mote_ccod) and not EsVacio(dcur_norden)  and not EsVacio(horas_programa)  and not EsVacio(presupuesto) then 
		SQL = " insert into mallas_otec (MAOT_NCORR,DCUR_NCORR,MOTE_CCOD,MAOT_NORDEN,maot_nhoras_programa,maot_npresupuesto_relator,AUDI_TUSUARIO,AUDI_FMODIFICACION,MAOT_ORDEN_RELACION)"&_
              " values ("&maot_ncorr&","&dcur_ncorr&",'"&mote_ccod&"',"&dcur_norden&","&horas_programa&","&presupuesto&",'"&usuario&"',getDate(),1)"
	    
		conectar.EstadoTransaccion conectar.EjecutaS(SQL)
		'response.Write(SQL)
	end if
	if maot_ncorr <> "" and horasa <> "" and presupuestoa <> "" then
		c_update = "update mallas_otec set maot_nhoras_ayudantia="&horasa&",maot_npresupuesto_ayudantia="&presupuestoa&", audi_tusuario='"&usuario&"',audi_fmodificacion=getDate() where cast(maot_ncorr as varchar)='"&maot_ncorr&"'"
		conectar.ejecutaS c_update
	    'response.Write(c_update)
	end if

	if maot_ncorr <> "" and horasi <> "" and presupuestoi <> "" then
		c_update = "update mallas_otec set maot_nhoras_elearning="&horasi&",maot_npresupuesto_elearning="&presupuestoi&", audi_tusuario='"&usuario&"',audi_fmodificacion=getDate() where cast(maot_ncorr as varchar)='"&maot_ncorr&"'"
		conectar.ejecutaS c_update
	    'response.Write(c_update)
	end if
	
	if maot_ncorr <> "" and horasbi <> "" and presupuestobi <> "" then
		c_update = "update mallas_otec set maot_nhoras_bilearning="&horasbi&",maot_npresupuesto_bilearning="&presupuestobi&", audi_tusuario='"&usuario&"',audi_fmodificacion=getDate() where cast(maot_ncorr as varchar)='"&maot_ncorr&"'"
		conectar.ejecutaS c_update
	    'response.Write(c_update)
	end if		
		
next

'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
