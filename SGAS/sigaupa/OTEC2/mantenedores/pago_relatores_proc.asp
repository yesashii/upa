<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
on error resume next
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar



'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()



set formulario = new cformulario
formulario.carga_parametros "pago_relatores.xml", "f_horario"
formulario.inicializar conectar
formulario.procesaForm

for i=0 to formulario.cuentaPost - 1
	seot_ncorr=formulario.obtenerValorPost(i,"seot_ncorr")
	pers_ncorr=formulario.obtenerValorPost(i,"pers_ncorr")
	monto=formulario.obtenerValorPost(i,"monto_asignado")
	hora=formulario.obtenerValorPost(i,"hora_asignada")
	if not EsVacio(seot_ncorr) and not EsVacio(pers_ncorr) then
	  
	  if EsVacio(monto) then
	  monto="null"
	  end if
	  if EsVacio(hora) then
	  hora="null"
	  end if
	  tiene_contrato= conectar.consultaUno("select count(*) from contratos_docentes_otec a, anexos_otec b, detalle_anexo_otec c where a.cdot_ncorr=b.cdot_ncorr and b.anot_ncorr=c.anot_ncorr and c.seot_ncorr="&seot_ncorr&" and pers_ncorr="&pers_ncorr&" and ecdo_ccod=1")
     ya_grabado = conectar.consultaUno("select case count(*) when 0 then 'N' else 'S' end  from pago_relatores_otec where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(seot_ncorr as varchar)='"&seot_ncorr&"'")
	 
		 if tiene_contrato="0" then
			  
			  if ya_grabado = "N" then
				  SQL="insert into pago_relatores_otec(seot_ncorr,pers_ncorr,monto_asignado,hora_asignada,audi_tusuario,audi_fmodificacion)"&_
						"values ("&seot_ncorr&","&pers_ncorr&","&monto&","&hora&",'"&negocio.obtenerUsuario&"',getDate())"
					'response.Write("<br>"&SQL)
					
			  else
				 SQL = "Update pago_relatores_otec set monto_asignado="&monto&",hora_asignada="&hora&", audi_tusuario='"&negocio.obtenerUsuario&"',audi_fmodificacion=getDate() where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(seot_ncorr as varchar)='"&seot_ncorr&"'"
			  end if
		  'response.Write("<br>"&SQL)
		  'response.End()
		  conectar.EstadoTransaccion conectar.EjecutaS(SQL)
		
		else
		session("mensajeerror")= "No Puede Modificar por que un tiene contrato asociado"
		end if
	end if
next


'response.Write(consulta)
'response.End()
'conectar.ejecutaS consulta
response.Redirect(request.ServerVariables("HTTP_REFERER"))


%>
