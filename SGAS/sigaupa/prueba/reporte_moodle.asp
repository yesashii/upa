<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'---------------------------------------------------------------------------------------------------


peri_ccod  		= request.querystring("peri_ccod")
codigo_id  		= request.querystring("codigo_id")
Response.AddHeader "Content-Disposition", "attachment;filename=reporte_" & codigo_id & ".txt"
Response.ContentType = "text/plain"

set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
'response.Write(codigo_id)
arreglo = Split(codigo_id,"-")
sede=arreglo(0)
carrera=arreglo(1)
jornada=arreglo(2)
asignatura =arreglo(3)
seccion = arreglo(4)

set formulario = new CFormulario
formulario.carga_parametros "tabla_vacia.xml", "tabla"
formulario.Inicializar conexion
consulta = "  select replace(replace(replace(replace(replace(replace(c.susu_tlogin,'á','A'),'é','E'),'í','I'),'ó','O'),'ú','U'),'ñ','N') as username, "& vbCrLf &_
            " replace(replace(replace(replace(replace(replace(upper(c.susu_tclave),'Á','A'),'É','E'),'Í','I'),'Ó','O'),'Ú','U'),'Ñ','N') as password, "& vbCrLf &_
			" nombres as firstname, apellidos as lastname, "& vbCrLf &_
			" (select top 1 replace(replace(replace(replace(replace(replace(lower(email_nuevo),'á','a'),'é','e'),'í','i'),'ó','o'),'ú','u'),'ñ','n') from cuentas_email_upa tt where tt.pers_ncorr=table1.pers_ncorr) as email, "& vbCrLf &_
			" '"&codigo_id&"' as course1, tipo as type1, 90 as institution, 509 as department "& vbCrLf &_
			" from  "& vbCrLf &_
			" ( "& vbCrLf &_
            " select distinct d.pers_ncorr,d.pers_nrut as rut, d.pers_xdv as dv, protic.initcap(d.pers_tnombre) as nombres, "& vbCrLf &_
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
			" union "& vbCrLf &_
			" select distinct d.pers_ncorr, d.pers_nrut as rut, d.pers_xdv as dv, protic.initcap(d.pers_tnombre) as nombres,  "& vbCrLf &_
			" protic.initcap(d.pers_tape_paterno + ' ' + d.pers_tape_materno) as apellidos, '' as carrera,'2' as tipo  "& vbCrLf &_
			" from secciones b, bloques_horarios a, bloques_profesores c, personas d "& vbCrLf &_
			" where a.secc_ccod=b.secc_ccod and cast(b.peri_ccod as varchar)='"&peri_ccod&"'  "& vbCrLf &_
			" and a.bloq_ccod = c.bloq_ccod and c.pers_ncorr=d.pers_ncorr and c.tpro_ccod=1 "& vbCrLf &_
			" and cast(b.sede_ccod as varchar)='"&sede&"'  "& vbCrLf &_
			" and b.carr_ccod ='"&carrera&"'  "& vbCrLf &_
			" and cast(b.jorn_ccod as varchar)='"&jornada&"' "& vbCrLf &_ 
			" and b.asig_ccod ='"&asignatura&"'  "& vbCrLf &_
			" and substring(secc_tdesc,1,1) = '"&seccion&"' "& vbCrLf &_
			" --union  "& vbCrLf &_
			" --select distinct a.pers_ncorr,a.pers_nrut as rut, a.pers_xdv as dv, protic.initcap(a.pers_tnombre) as nombres,  "& vbCrLf &_
			" --protic.initcap(a.pers_tape_paterno + ' ' + a.pers_tape_materno) as apellidos, '' as carrera,'2' as tipo "& vbCrLf &_ 
			" --from personas a "& vbCrLf &_
			" --where a.pers_nrut='7139878' "& vbCrLf &_
			" ) table1, personas b, sis_usuarios c "& vbCrLf &_
			" where table1.rut=b.pers_nrut and b.pers_ncorr=c.pers_ncorr "& vbCrLf &_
			" and exists (select 1 from cuentas_email_upa tt where tt.pers_ncorr=table1.pers_ncorr) "

formulario.Consultar consulta & " order by lastname"


total = conexion.consultaUno("select count(*) from ("&consulta&")a")
if total <> "0" then
    response.Write("username,password,firstname,lastname,email,course1,type1")
	Response.Write(vbCrLf)
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
		response.Write(type1)'&",")
		'institution = formulario.obtenerValor("institution")
		'response.Write(institution&",")
		'department = formulario.obtenerValor("department")
		'response.Write(department)
		Response.Write(vbCrLf)
	wend
end if
'response.End()
%>