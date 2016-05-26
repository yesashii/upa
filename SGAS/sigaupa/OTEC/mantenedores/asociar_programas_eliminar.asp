<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set formulario = new cformulario
formulario.carga_parametros "asociar_programas.xml", "f_relaciones"
formulario.inicializar conectar
formulario.ProcesaForm
mensaje=""
for filai = 0 to formulario.CuentaPost - 1
	DCUR_NCORR = formulario.ObtenerValorPost (filai, "DCUR_NCORR")
	DCUR_NCORR_ORIGEN = formulario.ObtenerValorPost (filai, "DCUR_NCORR_ORIGEN")
	DCUR_NORDEN = formulario.ObtenerValorPost (filai, "DCUR_NORDEN")
	
    if DCUR_NCORR <> "" and DCUR_NCORR_ORIGEN <> "" then
	  c_tiene_seccion = " select count(*) " & vbCrlf & _
	                    " from programas_asociados a, mallas_otec b " & vbCrlf & _
						" where cast(a.dcur_ncorr as varchar)='"&dcur_ncorr&"' and cast(a.dcur_ncorr_origen as varchar)='"&dcur_ncorr_origen&"' " & vbCrlf & _
						" and a.dcur_ncorr=b.dcur_ncorr and cast(b.maot_orden_relacion as varchar)='"&dcur_norden&"' " & vbCrlf & _
						" and exists (select 1 from secciones_otec tt where tt.maot_ncorr=b.maot_ncorr) "
	  tiene_seccion = conectar.ConsultaUno(c_tiene_seccion)
	  if tiene_seccion <> "0" then
	      mensaje = "Imposible eliminar la(s) asignatura(s) de la malla, pertenecen a una planificación ya registrada"
	  else
	  	  c_delete1 = "delete mallas_otec where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"' and cast(maot_orden_relacion as varchar)='"&dcur_norden&"'"
		  c_delete2 = "delete programas_asociados where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"' and cast(dcur_ncorr_origen as varchar)='"&dcur_ncorr_origen&"'"
		  
		  conectar.EstadoTransaccion conectar.EjecutaS(c_delete1)
		  conectar.EstadoTransaccion conectar.EjecutaS(c_delete2)
	  end if
	end if
next

if mensaje <> "" then
	msj_error = mensaje
end if	
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
