<!-- #include file="../biblioteca/_conexion.asp" -->

<%
pagina=request.QueryString("pagina")
pers_nrut=request.QueryString("pers_nrut")

set conectar = new CConexion
set formulario = new CFormulario

conectar.Inicializar "upacifico"

pers_ncorr = conectar.ConsultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'")


if cint(pagina)=1 then
	url="experiencia_laboral.asp?pers_ncorr="&pers_ncorr
end if 
if cint(pagina)=2 then
	url="experiencia_docente.asp?pers_ncorr="&pers_ncorr
end if 
if cint(pagina)=3 then
	url="perfeccionamiento.asp?pers_ncorr="&pers_ncorr
end if 


response.Redirect(url)
%>