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

DCUR_NCORR = request.Form("dcur_ncorr")

set formulario_relaciones = new cformulario
formulario_relaciones.carga_parametros "tabla_vacia.xml", "tabla"
formulario_relaciones.inicializar conexion

consulta =" select b.dcur_ncorr, 'N' as orden " & vbCrlf & _
		  " from diplomados_cursos b where cast(b.dcur_ncorr as varchar) = '"&DCUR_NCORR&"' " & vbCrlf & _
		  "	union " & vbCrlf & _
		  "	select b.dcur_ncorr,cast(a.DCUR_NORDEN as varchar) as orden " & vbCrlf & _
		  "	from programas_asociados a, diplomados_cursos b " & vbCrlf & _
		  "	where a.dcur_ncorr_origen = b.dcur_ncorr " & vbCrlf & _
		  "	and cast(a.dcur_ncorr as varchar)= '"&DCUR_NCORR&"' " & vbCrlf & _
		  "	order by orden " 

'response.write("<pre>"&consulta&"</pre>")
formulario_relaciones.consultar consulta 


'-----------------------------------------programas del diplomado o curso----------------------------------------------------------
set formulario_alumnos = new cformulario
formulario_alumnos.carga_parametros "tabla_vacia.xml", "tabla"
formulario_alumnos.inicializar conexion

consulta =" select b.pers_ncorr,b.pote_ncorr,'P' as tipo  " & vbCrlf & _
		  " from datos_generales_secciones_otec a, postulacion_otec b, personas c  " & vbCrlf & _
		  " where a.dgso_ncorr=b.dgso_ncorr and b.pers_ncorr=c.pers_ncorr   " & vbCrlf & _
		  " and cast(a.dcur_ncorr as varchar)='"&DCUR_NCORR&"' " & vbCrlf & _
		  " and b.epot_ccod = 4  " & vbCrlf & _
		  " union " & vbCrlf & _
		  " select b.pers_ncorr,max(b.pote_ncorr) as pote_ncorr,'D' as tipo  " & vbCrlf & _
		  " from datos_generales_secciones_otec a, postulacion_otec b, personas c  " & vbCrlf & _
		  " where a.dgso_ncorr=b.dgso_ncorr and b.pers_ncorr=c.pers_ncorr   " & vbCrlf & _
		  " and a.dcur_ncorr in (select tt.dcur_ncorr_origen from programas_asociados tt where cast(tt.dcur_ncorr as varchar)= '"&DCUR_NCORR&"') " & vbCrlf & _
		  " and b.epot_ccod = 4 " & vbCrlf & _
		  " and not exists (select 1  " & vbCrlf & _
		  "	  			    from datos_generales_secciones_otec tr, postulacion_otec te " & vbCrlf & _
		  "				    where tr.dgso_ncorr=te.dgso_ncorr and te.pers_ncorr=b.pers_ncorr and te.epot_ccod = 4 " & vbCrlf & _
	      "				    and cast(tr.dcur_ncorr as varchar)='"&DCUR_NCORR&"') " & vbCrlf & _
		  "	group by b.pers_ncorr " 

'response.write("<pre>"&consulta&"</pre>")
formulario_alumnos.consultar consulta


while formulario_alumnos.siguiente
	pers_ncorr = formulario_alumnos.obtenerValor("pers_ncorr")
	pote_ncorr = formulario_alumnos.obtenerValor("pote_ncorr")
	tipo 	   = formulario_alumnos.obtenerValor("tipo")

	formulario_relaciones.primero
    while formulario_relaciones.siguiente
		dcur_ncorr_2 = formulario_relaciones.obtenerValor("dcur_ncorr")
		ordern_j     = formulario_relaciones.obtenerValor("orden")
		dgso_ncorr   = conexion.consultaUno("select dgso_ncorr from datos_generales_secciones_otec where cast(dcur_ncorr as varchar)='"&dcur_ncorr_2&"'")
		matriculado  = conexion.consultaUno("select count(*) from postulacion_otec where epot_ccod=4 and cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")
		matriculado_2= conexion.consultaUno("select count(*) from postulacion_asociada_otec where epot_ccod=4 and cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")
		certificado_2= conexion.consultaUno("select count(*) from postulacion_asociada_otec where epot_ccod=4 and cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and isnull(cast(pote_nnota_final as varchar),'0.0')='0.0'")
	    valor = ""
		valor = request.Form("m["&pers_ncorr&"][prog_"&dcur_ncorr_2&"]")
		
		if matriculado = "0" and matriculado_2 = "0" and valor <> "" then
			c_insert = "insert into postulacion_asociada_otec (pote_ncorr,pers_ncorr,epot_ccod,fecha_asociacion,dgso_ncorr,fpot_ccod,empr_ncorr_empresa,norc_empresa,empr_ncorr_otic,"&_
			           "                                       norc_otic, AUDI_TUSUARIO, AUDI_FMODIFICACION)"&_
					   "select pote_ncorr,pers_ncorr,4 as epot_ccod,getdate() as fecha_asociacion,"&dgso_ncorr&" as dgso_ncorr,fpot_ccod,empr_ncorr_empresa,norc_empresa,empr_ncorr_otic,"&_
					   "       norc_otic, '"&negocio.obtenerUsuario&"' as AUDI_TUSUARIO,getDate() as  AUDI_FMODIFICACION "&_
					   "from postulacion_otec where cast(pote_ncorr as varchar)='"&pote_ncorr&"'"
			conexion.ejecutaS c_insert
		end if
		
		if matriculado_2 <> "0" and valor = "" and certificado_2 <> "0" then
			c_delete = "delete from postulacion_asociada_otec where cast(pote_ncorr as varchar)='"&pote_ncorr&"' and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'"
			conexion.ejecutaS c_delete
		end if
		
	wend
wend
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
