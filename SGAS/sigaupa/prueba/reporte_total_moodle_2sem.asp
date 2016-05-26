<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'---------------------------------------------------------------------------------------------------

Response.AddHeader "Content-Disposition", "attachment;filename=reporte_grl.txt"
Response.ContentType = "text/plain"
Server.ScriptTimeOut = 150000
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
'response.Write(codigo_id)
set formulario = new CFormulario
formulario.carga_parametros "alumnos_moodle.xml", "alumnos"
formulario.Inicializar conexion


set formulario_grl = new CFormulario
formulario_grl.carga_parametros "tabla_vacia.xml", "tabla"
formulario_grl.Inicializar conexion
consulta_grl =  " select distinct a.secc_ccod,a.sede_ccod,a.carr_ccod,a.jorn_ccod,a.asig_ccod,substring(a.secc_tdesc,1,1) as seccion,"& vbCrLf &_
				" cc.idnumber as codigo_id,a.peri_ccod"& vbCrLf &_
				" from secciones a, cargas_academicas b, alumnos c, moodle_course cc"& vbCrLf &_
				" where a.secc_ccod=b.secc_ccod and b.matr_ncorr=c.matr_ncorr"& vbCrLf &_
				" and a.peri_ccod in (216) --and c.emat_ccod=1"& vbCrLf &_
				" and cc.sede_ccod=a.sede_ccod and cc.carr_ccod=a.carr_ccod "& vbCrLf &_
				" and cc.jorn_ccod=a.jorn_ccod and cc.asig_ccod=a.asig_ccod "& vbCrLf &_
				" and a.secc_ccod not in (43149,43151,43146,43152,43164,43165,43166,43147) "& vbCrLf &_
				" and cast(cc.seccion as varchar) = substring(a.secc_tdesc,1,1) "

formulario_grl.Consultar consulta_grl & " order by a.sede_ccod,a.carr_ccod,a.jorn_ccod,a.asig_ccod,seccion "
total_1 = conexion.consultaUno("select count(*) from ("&consulta_grl&")a")
if total_1 <> "0" then
    response.Write("username,password,firstname,lastname,email,course1,type1")
	Response.Write(vbCrLf)
	while formulario_grl.siguiente
		peri_ccod  		= formulario_grl.obtenerValor("peri_ccod")
		codigo_id  		= formulario_grl.obtenerValor("codigo_id")
		sede            = formulario_grl.obtenerValor("sede_ccod")
		carrera         = formulario_grl.obtenerValor("carr_ccod")
		jornada         = formulario_grl.obtenerValor("jorn_ccod")
		asignatura      = formulario_grl.obtenerValor("asig_ccod")
		seccion         = formulario_grl.obtenerValor("seccion")

		consulta =  " select replace(replace(replace(replace(replace(replace(c.susu_tlogin,'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N') as username, "& vbCrLf &_
		            " replace(replace(replace(replace(replace(replace(c.susu_tclave,'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N') as password, "& vbCrLf &_
					" nombres as firstname, apellidos as lastname, "& vbCrLf &_
					" (select top 1 replace(replace(replace(replace(replace(replace(lower(email_upa),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N') from sd_cuentas_email_totales tt where tt.rut=table1.rut) as email, "& vbCrLf &_
					" '"&codigo_id&"' as course1, tipo as type1, 90 as institution, 509 as department "& vbCrLf &_
					" from  "& vbCrLf &_
					" ( "& vbCrLf &_
					" select distinct d.pers_nrut as rut, d.pers_xdv as dv, protic.initcap(d.pers_tnombre) as nombres, "& vbCrLf &_
					" protic.initcap(d.pers_tape_paterno + ' ' + d.pers_tape_materno) as apellidos, g.carr_tdesc as carrera,'1' as tipo  "& vbCrLf &_
					" from cargas_academicas a,secciones b, alumnos c, personas d, ofertas_academicas e, especialidades f, carreras g  "& vbCrLf &_
					" where a.secc_ccod=b.secc_ccod and cast(b.peri_ccod as varchar)='"&peri_ccod&"'  "& vbCrLf &_
					" and a.matr_ncorr=c.matr_ncorr and c.pers_ncorr=d.pers_ncorr  "& vbCrLf &_
					" and c.ofer_ncorr=e.ofer_ncorr  "& vbCrLf &_
					" and e.espe_ccod=f.espe_ccod and f.carr_ccod=g.carr_ccod  "& vbCrLf &_
					" and cast(b.sede_ccod as varchar)='"&sede&"'  "& vbCrLf &_
					" and b.carr_ccod ='"&carrera&"'  "& vbCrLf &_
					" and cast(b.jorn_ccod as varchar)='"&jornada&"'  "& vbCrLf &_
					" and b.asig_ccod ='"&asignatura&"'  "& vbCrLf &_
					" and substring(secc_tdesc,1,1) = '"&seccion&"'  "& vbCrLf &_
					" and b.secc_ccod not in (43149,43151,43146,43152,43164,43165,43166,43147) "& vbCrLf &_
					" union "& vbCrLf &_
					" select distinct d.pers_nrut as rut, d.pers_xdv as dv, protic.initcap(d.pers_tnombre) as nombres,  "& vbCrLf &_
					" protic.initcap(d.pers_tape_paterno + ' ' + d.pers_tape_materno) as apellidos, '' as carrera,'2' as tipo  "& vbCrLf &_
					" from secciones b, bloques_horarios a, bloques_profesores c, personas d "& vbCrLf &_
					" where a.secc_ccod=b.secc_ccod and cast(b.peri_ccod as varchar)='"&peri_ccod&"'  "& vbCrLf &_
					" and a.bloq_ccod = c.bloq_ccod and c.pers_ncorr=d.pers_ncorr and c.tpro_ccod=1 "& vbCrLf &_
					" and cast(b.sede_ccod as varchar)='"&sede&"'  "& vbCrLf &_
					" and b.carr_ccod ='"&carrera&"'  "& vbCrLf &_
					" and cast(b.jorn_ccod as varchar)='"&jornada&"' "& vbCrLf &_ 
					" and b.asig_ccod ='"&asignatura&"'  "& vbCrLf &_
					" and substring(secc_tdesc,1,1) = '"&seccion&"' "& vbCrLf &_
					" and b.secc_ccod not in (43149,43151,43146,43152,43164,43165,43166,43147) "& vbCrLf &_
					" --union  "& vbCrLf &_
					" --select distinct a.pers_nrut as rut, a.pers_xdv as dv, protic.initcap(a.pers_tnombre) as nombres,  "& vbCrLf &_
					" --protic.initcap(a.pers_tape_paterno + ' ' + a.pers_tape_materno) as apellidos, '' as carrera,'2' as tipo "& vbCrLf &_ 
					" --from personas a "& vbCrLf &_
					" --where a.pers_nrut='7139878' "& vbCrLf &_
					" ) table1, personas b, sis_usuarios c "& vbCrLf &_
					" where table1.rut=b.pers_nrut and b.pers_ncorr=c.pers_ncorr "& vbCrLf &_
					" and exists (select 1 from sd_cuentas_email_totales tt where tt.rut=table1.rut) "

		formulario.Consultar consulta & " order by lastname"
		total = conexion.consultaUno("select count(*) from ("&consulta&")a")
		if total <> "0" then
			formulario.primero
			while formulario.siguiente
				username = formulario.obtenerValor("username")
				response.Write(username&",")
				password = formulario.obtenerValor("password")
				response.Write(password&",")
				firstname = formulario.obtenerValor("firstname")
				response.Write(firstname&",")
				lastname = formulario.obtenerValor("lastname")
				response.Write(lastname&",")
				email = formulario.obtenerValor("email")
				response.Write(email&",")
				course1 = formulario.obtenerValor("course1")
				response.Write(course1&",")
				type1 = formulario.obtenerValor("type1")
				response.Write(type1)
				Response.Write(vbCrLf)
			wend
		end if
	wend
end if
%>