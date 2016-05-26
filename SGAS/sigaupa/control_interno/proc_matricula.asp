<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%
set conexion    = new cConexion
set fMatricula  = new cFormulario


conexion.inicializar "desauas"

set negocio = new Cnegocio
negocio.Inicializa conexion

v_usuario = negocio.ObtenerUsuario



fMatricula.carga_parametros "ariel.xml", "fContrato_matricula"
fMatricula.inicializar conexion
fMatricula.procesaForm	

v_cont_ncorr = fMatricula.ObtenerValorPost(0, "cont_ncorr")
consulta = "select nvl(b.tpos_ccod, 1) " & vbCrLf &_
           "from contratos a, postulantes b " & vbCrLf &_
		   "where a.post_ncorr = b.post_ncorr " & vbCrLf &_
		   "  and a.cont_ncorr = '" & v_cont_ncorr & "'"
			   
v_tpos_ccod = conexion.ConsultaUno(consulta)
'conexion.EstadoTransaccion false

v_pers_nrut = conexion.ConsultaUno("select c.pers_nrut from contratos a, postulantes b, personas c where a.post_ncorr = b.post_ncorr and b.pers_ncorr = c.pers_ncorr and a.cont_ncorr = '" & fMatricula.ObtenerValorPost(0, "cont_ncorr") & "'")

if v_tpos_ccod <> "3" then		
	sentencia = "crea_postulacion_pr(" & fMatricula.ObtenerValorPost(0, "cont_ncorr") & ")"	
	conexion.EjecutaP(sentencia)
	
	consulta = "select bloqueos_matricula(" & v_pers_nrut & ", " & Request.Form("peri_ccod") & ") from dual"
else
	consulta = "select pet_bloqueos_matricula(" & v_pers_nrut & ", " & Request.Form("peri_ccod") & ") from dual"
end if

mensaje = conexion.ConsultaUno(consulta)
	
if mensaje = "" or IsNull(mensaje) or IsEmpty(mensaje) then
	v_post_ncorr = conexion.ConsultaUno("select post_ncorr from contratos where cont_ncorr = '" & fMatricula.ObtenerValorPost(0, "cont_ncorr") & "'")
	fMatricula.AgregaCampoPost "post_ncorr", v_post_ncorr	
	fMatricula.mantieneTablas false
else
	Session("mensajeError") = mensaje
end if

if v_tpos_ccod = "3" then
	v_matr_ncorr = conexion.ConsultaUno("select matr_ncorr from contratos where cont_ncorr = '" & v_cont_ncorr & "'")
	sentencia = "update alumnos set talu_ccod = 3 where matr_ncorr = '" & v_matr_ncorr & "'"
	conexion.EstadoTransaccion conexion.EjecutaS (sentencia)
	
	sentencia = "insert into cargas_academicas (matr_ncorr, secc_ccod, audi_tusuario, audi_fmodificacion) " & vbCrLf &_
	            "select a.matr_ncorr, d.secc_ccod, '" & v_usuario & "', sysdate " & vbCrLf &_
				"from alumnos a, ofertas_academicas b, especialidades c, secciones d " & vbCrLf &_
				"where a.ofer_ncorr = b.ofer_ncorr " & vbCrLf &_
				"  and b.espe_ccod = c.espe_ccod " & vbCrLf &_
				"  and d.sede_ccod = b.sede_ccod " & vbCrLf &_
				"  and d.carr_ccod = c.carr_ccod " & vbCrLf &_
				"  and d.peri_ccod = b.peri_ccod " & vbCrLf &_
				"  and d.jorn_ccod = b.jorn_ccod " & vbCrLf &_
				"  and d.asig_ccod = 'H00000' " & vbCrLf &_
				"  and a.matr_ncorr = '" & v_matr_ncorr & "' " & vbCrLf &_
				"  and not exists (select 1 from cargas_academicas where matr_ncorr = a.matr_ncorr and secc_ccod = d.secc_ccod)"
				
	conexion.EstadoTransaccion conexion.EjecutaS (sentencia)
end if
	

response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

