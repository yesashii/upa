<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
'---------------------------------------------------------------------------------------------------

Response.AddHeader "Content-Disposition", "attachment;filename=reporte_grl_222.txt"
Response.ContentType = "text/plain;charset=UTF-8"
Server.ScriptTimeOut = 3500000
set conexion = new CConexion
conexion.Inicializar "upacifico"
'set negocio = new CNegocio
'negocio.Inicializa conexion
'response.Write(codigo_id)
set formulario = new CFormulario
formulario.carga_parametros "alumnos_moodle.xml", "alumnos"
formulario.Inicializar conexion


set formulario_grl = new CFormulario
formulario_grl.carga_parametros "tabla_vacia.xml", "tabla"
formulario_grl.Inicializar conexion
consulta_grl =  " select distinct a.secc_ccod,a.sede_ccod,a.carr_ccod,a.jorn_ccod,a.asig_ccod,substring(a.secc_tdesc,1,1) as seccion,"& vbCrLf &_
				" cc.idnumber as codigo_id,a.peri_ccod"& vbCrLf &_
				" from secciones a, cargas_academicas b (nolock), alumnos c (nolock), moodle_course_222 cc"& vbCrLf &_
				" where a.secc_ccod=b.secc_ccod and b.matr_ncorr=c.matr_ncorr"& vbCrLf &_
				" and a.peri_ccod in (228) "& vbCrLf &_
				" and cc.sede_ccod=a.sede_ccod and cc.carr_ccod=a.carr_ccod "& vbCrLf &_
				" and cc.jorn_ccod=a.jorn_ccod and cc.asig_ccod=a.asig_ccod and isnull(cc.periodo,'0') = '0' "& vbCrLf &_
				" and cast(cc.seccion as varchar) = substring(a.secc_tdesc,1,1) "& vbCrLf &_
				" union "& vbCrLf &_
				" select distinct a.secc_ccod,a.sede_ccod,a.carr_ccod,a.jorn_ccod,a.asig_ccod,substring(a.secc_tdesc,1,1) as seccion, "& vbCrLf &_
				" cc.idnumber as codigo_id,a.peri_ccod "& vbCrLf &_
				" from secciones a, bloques_horarios b , bloques_profesores c , moodle_course_222 cc "& vbCrLf &_
				" where a.secc_ccod=b.secc_ccod and b.bloq_ccod=c.bloq_ccod and c.tpro_ccod=1 "& vbCrLf &_
				" and a.peri_ccod in (228) "& vbCrLf &_
				" and cc.sede_ccod=a.sede_ccod and cc.carr_ccod=a.carr_ccod  "& vbCrLf &_
				" and cc.jorn_ccod=a.jorn_ccod and cc.asig_ccod=a.asig_ccod and isnull(cc.periodo,'0') = '0'  "& vbCrLf &_
				" and cast(cc.seccion as varchar) = substring(a.secc_tdesc,1,1) "

formulario_grl.Consultar consulta_grl & " order by a.sede_ccod,a.carr_ccod,a.jorn_ccod,a.asig_ccod,seccion "
total_1 = conexion.consultaUno("select count(*) from ("&consulta_grl&")a")
if total_1 <> "0" then
    response.Write("username,password,idnumber,firstname,lastname,email,course1,type1")
	Response.Write(vbCrLf)
	while formulario_grl.siguiente
		peri_ccod  		= formulario_grl.obtenerValor("peri_ccod")
		codigo_id  		= formulario_grl.obtenerValor("codigo_id")
		sede            = formulario_grl.obtenerValor("sede_ccod")
		carrera         = formulario_grl.obtenerValor("carr_ccod")
		jornada         = formulario_grl.obtenerValor("jorn_ccod")
		asignatura      = formulario_grl.obtenerValor("asig_ccod")
		seccion         = formulario_grl.obtenerValor("seccion")

		consulta =  " select REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( REPLACE(replace(replace(replace(replace(replace(replace(lower(c.susu_tlogin),'á','a'),'é','e'),'í','i'),'ó','o'),'ú','u'),'ñ','n'),' ',''),'à','a'),'è','e'),'ì','i'),'ò','o'),'ù','u'),'ü','u') as username,matr_ncorr,secc_ccod, "& vbCrLf &_
		            " b.pers_ncorr, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( REPLACE(replace(replace(replace(replace(replace(replace(upper(c.susu_tclave),'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N'),' ',''),'à','A'),'è','E'),'ì','I'),'ò','O'),'ù','U'),'ü','U') as password, "& vbCrLf &_
					" REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( replace(replace(replace(replace(replace(replace(nombres,'á','a'),'é','e'),'í','i'),'ó','o'),'ú','u'),'ñ','n'),'à','a'),'è','e'),'ì','i'),'ò','o'),'ù','u'),'ü','u') as firstname, "& vbCrLf &_
					" REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( replace(replace(replace(replace(replace(replace(apellidos,'á','a'),'é','e'),'í','i'),'ó','o'),'ú','u'),'ñ','n'),'à','a'),'è','e'),'ì','i'),'ò','o'),'ù','u'),'ü','u') as lastname, "& vbCrLf &_
					" (select top 1 replace(replace(replace(replace(replace(replace(lower(email_nuevo),'á','a'),'é','e'),'í','i'),'ó','o'),'ú','u'),'ñ','n') from cuentas_email_upa tt where tt.pers_ncorr=table1.pers_ncorr) as email, "& vbCrLf &_
					" '"&codigo_id&"' as course1, tipo as type1, 90 as institution, 509 as department "& vbCrLf &_
					" from  "& vbCrLf &_
					" ( "& vbCrLf &_
					" select distinct a.matr_ncorr,a.secc_ccod,d.pers_ncorr,d.pers_nrut as rut, d.pers_xdv as dv, protic.initcap(d.pers_tnombre) as nombres, "& vbCrLf &_
					" protic.initcap(d.pers_tape_paterno + ' ' + d.pers_tape_materno) as apellidos, g.carr_tdesc as carrera,'1' as tipo  "& vbCrLf &_
					" from cargas_academicas a (nolock),secciones b, alumnos c, personas d, ofertas_academicas e, especialidades f, carreras g  "& vbCrLf &_
					" where a.secc_ccod=b.secc_ccod and cast(b.peri_ccod as varchar)='"&peri_ccod&"'  "& vbCrLf &_
					" and a.matr_ncorr=c.matr_ncorr and c.pers_ncorr=d.pers_ncorr  "& vbCrLf &_
					" and c.ofer_ncorr=e.ofer_ncorr  "& vbCrLf &_
					" and e.espe_ccod=f.espe_ccod and f.carr_ccod=g.carr_ccod  "& vbCrLf &_
					" and cast(b.sede_ccod as varchar)='"&sede&"'  "& vbCrLf &_
					" and b.carr_ccod ='"&carrera&"'  "& vbCrLf &_
					" and cast(b.jorn_ccod as varchar)='"&jornada&"'  "& vbCrLf &_
					" and b.asig_ccod ='"&asignatura&"'  "& vbCrLf &_
					" and substring(secc_tdesc,1,1) = '"&seccion&"'  "& vbCrLf &_
					" union "& vbCrLf &_
					" select distinct 0 as matr_ncorr, b.secc_ccod,d.pers_ncorr,d.pers_nrut as rut, d.pers_xdv as dv, protic.initcap(d.pers_tnombre) as nombres,  "& vbCrLf &_
					" protic.initcap(d.pers_tape_paterno + ' ' + d.pers_tape_materno) as apellidos, '' as carrera,'2' as tipo  "& vbCrLf &_
					" from secciones b, bloques_horarios a, bloques_profesores c, personas d "& vbCrLf &_
					" where a.secc_ccod=b.secc_ccod and cast(b.peri_ccod as varchar)='"&peri_ccod&"'  "& vbCrLf &_
					" and a.bloq_ccod = c.bloq_ccod and c.pers_ncorr=d.pers_ncorr and c.tpro_ccod in (1,2) "& vbCrLf &_
					" and cast(b.sede_ccod as varchar)='"&sede&"'  "& vbCrLf &_
					" and b.carr_ccod ='"&carrera&"'  "& vbCrLf &_
					" and cast(b.jorn_ccod as varchar)='"&jornada&"' "& vbCrLf &_ 
					" and b.asig_ccod ='"&asignatura&"'  "& vbCrLf &_
					" and substring(secc_tdesc,1,1) = '"&seccion&"' "& vbCrLf &_
					" --union  "& vbCrLf &_
					" --select distinct 0 as matr_ncorr, 0 as secc_ccod,d.pers_ncorr,a.pers_nrut as rut, a.pers_xdv as dv, protic.initcap(a.pers_tnombre) as nombres,  "& vbCrLf &_
					" --protic.initcap(a.pers_tape_paterno + ' ' + a.pers_tape_materno) as apellidos, '' as carrera,'2' as tipo "& vbCrLf &_ 
					" --from personas a "& vbCrLf &_
					" --where a.pers_nrut='7139878' "& vbCrLf &_
					" ) table1, personas b, sis_usuarios c "& vbCrLf &_
					" where table1.rut=b.pers_nrut and b.pers_ncorr=c.pers_ncorr "& vbCrLf &_
					" and exists (select 1 from cuentas_email_upa tt where tt.pers_ncorr=table1.pers_ncorr) "
'response.write("<br>"&consulta)
'response.End()
		formulario.Consultar consulta & " order by lastname"
		total = conexion.consultaUno("select count(*) from ("&consulta&")a")
		if total <> "0" then
			formulario.primero
			while formulario.siguiente
				username = formulario.obtenerValor("username")
				response.Write(username&",")
				password = formulario.obtenerValor("password")
				response.Write(password&",")
				idnumber = formulario.obtenerValor("pers_ncorr")
				response.Write(idnumber&",")
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
				matr_ncorr = formulario.obtenerValor("matr_ncorr")
				secc_ccod = formulario.obtenerValor("secc_ccod")
				
				'existe = conexion.consultaUno("select count(*) from matriculacion_moodle where cast(secc_ccod as varchar)='"&secc_ccod&"' and cast(matr_ncorr as varchar)='"&matr_ncorr&"' and cast(pers_ncorr as varchar)='"&idnumber&"'")
				
				'if existe = "0" then 
				'c_insert = " insert into MATRICULACION_MOODLE "&_
				'           "        (PERS_NCORR,SUSU_TLOGIN, SUSU_TCLAVE,COURSE1,TIPO,FECHA_CARGA, MATR_NCORR, SECC_CCOD, GRABADO) "&_
				'           " Values ("&idnumber&",'"&username&"','"&password&"','"&course1&"',"&type1&",getDate(),"&matr_ncorr&","&secc_ccod&",'SI')"
				'	conexion.ejecutaS c_insert
				'else
				'c_insert = " update MATRICULACION_MOODLE set GRABADO='SI' "&_
				'           " where cast(PERS_NCORR as varchar)='"&idnumber&"'  and cast(MATR_NCORR as varchar)='"&matr_ncorr&"' "&_
				'		    " and cast(SECC_CCOD as varchar)='"&secc_ccod&"'"
				'	conexion.ejecutaS c_insert
				'end if
			wend
		end if
	wend
end if

%>