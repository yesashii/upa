<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut = Request.QueryString("pers_nrut")

set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new CNegocio
negocio.Inicializa conexion

'consulta = "select count(*) from personas where pers_nrut = '" & q_pers_nrut & "'"

consulta = "select count(*) " & vbCrLf &_
           "from personas a, postulantes b, codeudor_postulacion c, personas d " & vbCrLf &_
		   "where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
		   "  and b.post_ncorr = c.post_ncorr " & vbCrLf &_
		   "  and c.pers_ncorr = d.pers_ncorr " & vbCrLf &_
		   "  and b.peri_ccod = '" & negocio.ObtenerPeriodoAcademico("POSTULACION") & "' " & vbCrLf &_
		   "  and a.pers_nrut = '" & q_pers_nrut & "'"



cuenta = CInt(conexion.ConsultaUno(consulta))

if cuenta = 0 then
	url = "agregar_persona_pactacion.asp?pers_nrut=" & q_pers_nrut
else
	url = "agregar_cargo_pactacion.asp?pers_nrut=" & q_pers_nrut
end if

Response.Redirect(url)
%>