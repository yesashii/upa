<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'-----------------------------------------------------
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

'response.End()

set conectar = new cconexion
conectar.inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conectar
contador=1

encu_ncorr = request.Form("encu_ncorr")
pers_ncorr_encuestado = request.Form("pers_ncorr")
secc_ccod = request.Form("secc_ccod")
pers_ncorr_destino = request.Form("pers_ncorr_profesor")
q_peri_ccod = negocio.obtenerPeriodoAcademico("Planificacion")
usuario = negocio.obtenerUsuario
'response.Write("<hr>universo "&univ_ncorr&"<hr>")
for each k in request.Form()
    if k <> "pers_ncorr" and k <> "encu_ncorr" and k <> "secc_ccod" and k <> "pers_ncorr_profesor" then
		'response.Write(k&" = "&request.Form(k)&"<br>")
		 preg_ncorr=cInt(k)
		 resp_ncorr=request.Form(k)
		 reen_ncorr = conectar.ConsultaUno("execute obtenerSecuencia 'resultados_encuestas' ") 	
		 sql = "insert into resultados_encuestas (reen_ncorr,encu_ncorr,preg_ncorr,resp_ncorr,secc_ccod,peri_ccod,pers_ncorr_encuestado,pers_ncorr_destino,audi_tusuario,audi_fmodificacion)"&_
		       " values ("&reen_ncorr&","&encu_ncorr&","&preg_ncorr&","&resp_ncorr&","&secc_ccod&","&q_peri_ccod&","&pers_ncorr_encuestado&","&pers_ncorr_destino&",'"&usuario&"',getDate())"    
         'response.Write("<br>Consulta "&sql)
		 conectar.EjecutaS(sql)
		 Respuesta = conectar.ObtenerEstadoTransaccion()
		contador=contador+1
	end if
next
'----------------------------------------------------
'response.End()
if respuesta = true then
  session("mensajeerror")= "Resultados ingresados con Éxito"
else
  session("mensajeerror")= "Error al guadar los resultados"
end if
%>

<script language="JavaScript" type="text/JavaScript">
  location.href = "contestar_encuesta2.asp?encu_ncorr="+<%=encu_ncorr%>+"&secc_ccod="+<%=secc_ccod%>+"&pers_ncorr_docente="+<%=pers_ncorr_destino%>;
</script>

