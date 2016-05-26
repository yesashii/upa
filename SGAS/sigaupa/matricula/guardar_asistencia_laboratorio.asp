<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file="../biblioteca/_negocio.asp" -->

<%
'for each x in request.FORM
'  response.Write("<br>"&x&"->"&request.FORM(x))
'next
'response.End()
rut=request.FORM("rut")
digito=request.FORM("digito")
sala_ccod=request.FORM("salas[0][sala_ccod]")

set conexion = new cconexion
conexion.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario=negocio.ObtenerUsuario()
pers_ncorr_encargado=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")

registro_evento = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from sis_roles_usuarios a where srol_ncorr='190' and cast(pers_ncorr as varchar)='"&pers_ncorr_encargado&"'")	
if registro_evento = "S" then
	tipo = "E"
else
	tipo = "C"
end if

codigo = conexion.consultaUno("select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&rut&"'")

if not esvacio(codigo) then
	acumulativo = conexion.consultaUno("SELECT ISNULL(MAX(ACUMULATIVO),0) + 1 FROM asistencia_laboratorios")
	consulta_insert = "insert into asistencia_laboratorios (acumulativo,pers_ncorr,fecha_asistencia,tipo)"&_
	                  " values ("&acumulativo&","&codigo&",getDate(),'"&tipo&"')"
	conexion.ejecutaS consulta_insert
	
	if sala_ccod <> "" then
		c_update = "update asistencia_laboratorios set sala_ccod="&sala_ccod&",audi_tusuario='"&negocio.obtenerUsuario&"',audi_fmodificacion=getDate() where cast(acumulativo as varchar)='"&acumulativo&"'"
		conexion.ejecutaS c_update
	end if
	
end if

response.Redirect("info_alumnos.asp?busqueda[0][pers_nrut]="&rut&"&busqueda[0][pers_xdv]="&digito&"&grabar=1")
%>
