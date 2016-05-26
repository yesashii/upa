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
formulario.carga_parametros "asignar_relator_programa.xml", "f_horario"
formulario.inicializar conectar
formulario.procesaForm

for i=0 to formulario.cuentaPost - 1
	bhot_ccod=formulario.obtenerValorPost(i,"bhot_ccod")
	pers_ncorr=formulario.obtenerValorPost(i,"pers_ncorr")
	seot_ncorr=formulario.obtenerValorPost(i,"seot_ncorr")
	cantidad_relatores = conectar.consultaUno("select seot_ncantidad_relator from secciones_otec where cast(seot_ncorr as varchar)='"&seot_ncorr&"'")
	'response.Write("<br>--"&cantidad_relatores)
	sede_ccod = conectar.consultaUno("select sede_ccod from bloques_horarios_otec where cast(bhot_ccod as varchar)='"&bhot_ccod&"'")
	if not EsVacio(bhot_ccod) and not EsVacio(pers_ncorr) and not EsVacio(sede_ccod) then
	  
	  consulta_cantidad_asignados= " select count(distinct pers_ncorr) from ( " & vbCrlf & _
                                   " select distinct b.pers_ncorr from bloques_horarios_otec a, bloques_relatores_otec b " & vbCrlf & _
                                   " where a.bhot_ccod=b.bhot_ccod " & vbCrlf & _
                                   " and cast(a.seot_ncorr as varchar)='"&seot_ncorr&"' " & vbCrlf & _
                                   " union " & vbCrlf & _
                                   " select '"&pers_ncorr&"' as pers_ncorr " & vbCrlf & _
                                   " )tabla_temp "
     'response.Write("<pre>"&consulta_cantidad_asignados&"</pre>")
	 
	 ya_grabado = conectar.consultaUno("select case count(*) when 0 then 'N' else 'S' end  from bloques_relatores_otec where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(bhot_ccod as varchar)='"&bhot_ccod&"'")
	 cantidad_asignados = conectar.consultaUno(consulta_cantidad_asignados)
	 if cint(cantidad_asignados) <= cint(cantidad_relatores)  then
	    if ya_grabado = "N" then
		
		    conectar.EstadoTransaccion conectar.EjecutaS("delete from bloques_relatores_otec where cast(bhot_ccod as varchar)='"&bhot_cod&"'")
			SQL="insert into bloques_relatores_otec(bhot_ccod,pers_ncorr,sede_ccod,audi_tusuario,audi_fmodificacion)"&_
				"values ("&bhot_ccod&","&pers_ncorr&","&sede_ccod&",'"&negocio.obtenerUsuario&"',getDate())"
			'response.Write("<br>"&SQL)
			conectar.EstadoTransaccion conectar.EjecutaS(SQL)
		end if
	 else
	    msj_error ="Imposible asignar el relator ya que se definió para esta sección que solo será dictada por "&cantidad_relatores&" Relatores"
	    conectar.EstadoTransaccion false
	 end if	
		'----- antes de borrar a un docente habilitado en cierto programa debemos ver si tiene algun bloque asignado
		'
	end if
next


'response.Write(consulta)
'response.End()
'conectar.ejecutaS consulta

if conectar.obtenerEstadoTransaccion then 
		conectar.MensajeError msj_error
end if

response.Redirect(request.ServerVariables("HTTP_REFERER"))


%>
