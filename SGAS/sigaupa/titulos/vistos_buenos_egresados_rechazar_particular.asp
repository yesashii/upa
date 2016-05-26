<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

pers_ncorr = request.form("pers_ncorr")

set f_salidas = new CFormulario
f_salidas.Carga_Parametros "vistos_buenos_egresados.xml", "salidas_vb"
f_salidas.Inicializar conexion
f_salidas.ProcesaForm

cont = 0
for fila = 0 to f_salidas.CuentaPost - 1
   saca_ncorr = f_salidas.ObtenerValorPost (fila, "saca_ncorr")
   eceg_ccod = f_salidas.ObtenerValorPost (fila, "eceg_ccod")
   motivo = f_salidas.ObtenerValorPost (fila, "cegr_motivo_rechazo")
   if len(saca_ncorr) > o then
		c_cegr_ncorr = " select a.cegr_ncorr from candidatos_egreso a, candidatos_egreso_detalle b "&_
					   " where a.cegr_ncorr=b.cegr_ncorr and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and cast(b.saca_ncorr as varchar)='"&saca_ncorr&"'"
		cegr_ncorr = conexion.consultaUno(c_cegr_ncorr)
		
		c_update = "update CANDIDATOS_EGRESO_DETALLE set eceg_ccod = "&eceg_ccod&",cegr_motivo_rechazo='"&motivo&"', audi_tusuario='"&negocio.obtenerUsuario&"', audi_fmodificacion=getDate() where cast(cegr_ncorr as varchar)='"&cegr_ncorr&"' and cast(saca_ncorr as varchar)='"&saca_ncorr&"'"
		conexion.ejecutaS c_update
    end if   
next

response.Redirect(Request.ServerVariables("HTTP_REFERER"))
			   
%>
