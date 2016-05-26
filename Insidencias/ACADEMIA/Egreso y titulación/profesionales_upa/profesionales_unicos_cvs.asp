<!-- #include file = "../biblioteca/_conexion.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=titulados_egresados_unicos.txt"
Response.ContentType = "text/plain;charset=UTF-8"
Server.ScriptTimeOut = 300000
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_alumnos = new CFormulario
f_alumnos.Carga_Parametros "tabla_vacia.xml", "tabla"
f_alumnos.Inicializar conexion
		   
consulta = " select distinct cast(a.pers_nrut as varchar)+'-'+a.pers_xdv as rut, a.pers_tnombre as nombre, "& vbCrLf &_
           " a.pers_tape_paterno as ap_paterno, a.pers_tape_materno as ap_materno, case  when isnull(pers_temail,'--') not like '%@%' then '' else ltrim(rtrim(lower(a.pers_temail))) end as email  "& vbCrLf &_
		   "   from alumni_personas a (nolock), alumnos b (nolock) "& vbCrLf &_
		   "   where a.pers_ncorr=b.pers_ncorr and b.emat_ccod in (4,8)  "& vbCrLf &_
		   " union  "& vbCrLf &_
		   " select distinct cast(a.pers_nrut as varchar)+'-'+a.pers_xdv as rut, a.pers_tnombre as nombre, "& vbCrLf &_
		   " a.pers_tape_paterno as ap_paterno, a.pers_tape_materno as ap_materno, case  when isnull(pers_temail,'--') not like '%@%' then '' else ltrim(rtrim(lower(a.pers_temail))) end as email   "& vbCrLf &_
		   "   from alumni_personas a (nolock), egresados_upa2 b  "& vbCrLf &_
		   "   where a.pers_nrut=b.pers_nrut and a.pers_xdv=b.pers_xdv  "& vbCrLf &_
		   " union   "& vbCrLf &_
		   " select distinct cast(a.pers_nrut as varchar)+'-'+a.pers_xdv as rut, a.pers_tnombre as nombre, "& vbCrLf &_
		   " a.pers_tape_paterno as ap_paterno, a.pers_tape_materno as ap_materno, case  when isnull(pers_temail,'--') not like '%@%' then '' else ltrim(rtrim(lower(a.pers_temail))) end as email   "& vbCrLf &_
		   "   from alumni_personas a (nolock), alumnos_salidas_intermedias b,alumnos_salidas_carrera c  "& vbCrLf &_
		   "   where a.pers_ncorr=b.pers_ncorr and b.emat_ccod in (4,8)   "& vbCrLf &_
		   "   and b.saca_ncorr=c.saca_ncorr and b.pers_ncorr=c.pers_ncorr  "

'response.End()
f_alumnos.Consultar consulta
filas = f_alumnos.nroFilas
if filas > 0 then
	response.Write("rut,nombre,apellido,email")
	Response.Write(vbCrLf)
	while f_alumnos.Siguiente 
	  rut = f_alumnos.ObtenerValor("rut")
	  response.Write(rut&";")
	  nombre= f_alumnos.ObtenerValor("nombre")
	  response.Write(nombre&";")
	  apellido = f_alumnos.ObtenerValor("ap_paterno")
	  response.Write(apellido&";")
	  email = f_alumnos.ObtenerValor("email")
	  response.Write(email)
	  Response.Write(vbCrLf)
	wend 
end if
%>
