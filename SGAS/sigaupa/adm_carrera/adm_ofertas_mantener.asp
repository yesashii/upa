<!-- #include file="../biblioteca/_conexion.asp"-->
<!-- #include file="../biblioteca/_negocio.asp"-->

<%
estado_transaccion=true

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new Cnegocio
negocio.Inicializa conexion

aran_existe = Request.Form("ofertas[0][aran_ncorr]")
aran_ncorr = Request.Form("aran_ncorr")
ofer_nvacantes = request.Form("ofertas[0][ofer_nvacantes]")
ofer_nquorum = request.Form("ofertas[0][ofer_nquorum]")
v_paga_examen = request.Form("ofertas[0][ofer_bpaga_examen]")
v_ofer_publica = request.Form("ofertas[0][ofer_bpublica]")
v_ofer_activa = request.Form("ofertas[0][ofer_bactiva]")
'response.Write(request.Form("ofertas[0][ofer_bpaga_examen]"))
'response.End()
if v_paga_examen=0 then
	v_paga_examen="N"
else
	v_paga_examen="S"
end if

if v_ofer_publica=0 then
	v_ofer_publica="N"
else
	v_ofer_publica="S"
end if

if v_ofer_activa=0 then
	v_ofer_activa="N"
else
	v_ofer_activa="S"
end if
'response.Write(ofer_nvacantes&"<br>")
'response.Write(ofer_nquorum&"<br>")
'response.End()

v_usuario = negocio.ObtenerUsuario
'*** INSERTA ARANCELES **************************************************
set t_aranceles = new CFormulario
t_aranceles.Carga_Parametros "adm_ofertas_edicion.xml", "t_aranceles"
t_aranceles.Inicializar conexion
t_aranceles.ProcesaForm

t_aranceles.AgregaCampoPost "aran_cvigente_fup", "S"
t_aranceles.MantieneTablas false

'*** ACTUALIZA OFERTAS ACADEMICAS **************************************************

set f_consulta = new CFormulario
f_consulta.Carga_Parametros "andres.xml", "consulta"
f_consulta.Inicializar conexion

consulta = "SELECT count(*) " & vbCrlf & _
           "FROM ofertas_academicas " & vbCrlf & _
		   "WHERE ofer_ncorr = " & Request.Form("ofertas[0][ofer_ncorr]")
'response.write consulta
'response.end  
cuenta = conexion.consultauno(consulta)

if cuenta > 0 then
	eliminar_arancel_antiguo ="DELETE FROM aranceles WHERE  ofer_ncorr = " & Request.Form("ofertas[0][ofer_ncorr]") &" AND aran_ncorr <> "& aran_ncorr
	'response.Write("<pre>"&eliminar_arancel_antiguo&"</pre>")
	conexion.EjecutaS (eliminar_arancel_antiguo)
	sentencia = " UPDATE  ofertas_academicas " & _
				" SET  aran_ncorr= "& aran_ncorr &", " & _
				" ofer_nvacantes="&ofer_nvacantes&", " & _
				" ofer_nquorum="&ofer_nquorum&", " & _
				" ofer_bpaga_examen='"& v_paga_examen &"', " & _
				" ofer_bpublica='"& v_ofer_publica &"', " & _
				" ofer_bactiva='"& v_ofer_activa &"', " & _
				" audi_fmodificacion=getdate(), " & _								
				" audi_tusuario='"& v_usuario &"' " & _
				" WHERE ofer_ncorr = " & Request.Form("ofertas[0][ofer_ncorr]")
end if 

'response.Write("<pre>"&sentencia&"</pre>")

estado=conexion.EjecutaS (sentencia)
'response.write sentencia
'response.write estado
'response.end
if estado=false then
	estado_transaccion=false
end if	
'estado_transaccion=false

conexion.estadotransaccion estado_transaccion

'response.End()


'---------------------------------------------------------------------------------------------------------------
%>

<script language="JavaScript">
opener.location.reload();
window.close();
</script>
