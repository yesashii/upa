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

pers_ncorr = request.form("pers_ncorr_2")
carr_ccod = request.form("carr_ccod_2")
plan_ccod = request.form("plan_ccod_2")

set f_salidas = new CFormulario
f_salidas.Carga_Parametros "vistos_buenos_egresados.xml", "salidas_ti"
f_salidas.Inicializar conexion
f_salidas.ProcesaForm

cegr_ncorr = conexion.consultaUno("select cegr_ncorr from CANDIDATOS_EGRESO where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(plan_ccod as varchar)='"&plan_ccod&"' and carr_ccod='"&carr_ccod&"'")


cont = 0
for fila = 0 to f_salidas.CuentaPost - 1
   saca_ncorr = f_salidas.ObtenerValorPost (fila, "saca_ncorr")
   eceg_ccod = f_salidas.ObtenerValorPost (fila, "eceg_ccod")
   motivo = f_salidas.ObtenerValorPost (fila, "cegr_motivo_rechazo")
   if len(saca_ncorr) > o then
		c_grabado = " select count(*) from candidatos_egreso a, candidatos_egreso_detalle b "&_
					   " where a.cegr_ncorr=b.cegr_ncorr and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and cast(b.saca_ncorr as varchar)='"&saca_ncorr&"'"
		grabado = conexion.consultaUno(c_grabado)
		
		if grabado <> "0" then
		  c_update = " update CANDIDATOS_EGRESO_DETALLE set eceg_ccod = "&eceg_ccod&",cegr_motivo_rechazo='"&motivo&"', audi_tusuario='"&negocio.obtenerUsuario&"', audi_fmodificacion=getDate() where cast(cegr_ncorr as varchar)='"&cegr_ncorr&"' and cast(saca_ncorr as varchar)='"&saca_ncorr&"'"
		  conexion.ejecutaS c_update
        else
		  c_insert = " INSERT INTO CANDIDATOS_EGRESO_DETALLE (CEGR_NCORR,SACA_NCORR,ECEG_CCOD,USUA_NCORR_CREADOR,CEGR_FCREACION,USUA_NCORR_VALIDA,CEGR_FVALIDACION,CEGR_MOTIVO_RECHAZO,AUDI_TUSUARIO,AUDI_FMODIFICACION) "&_
                     " VALUES ("&cegr_ncorr&","&saca_ncorr&","&eceg_ccod&","&negocio.obtenerUsuario&",getDate(),"&negocio.obtenerUsuario&",getDate(),'"&motivo&"','"&negocio.obtenerUsuario&"',getDate())"
		  conexion.ejecutaS c_insert 
		end if

    end if   
next

response.Redirect(Request.ServerVariables("HTTP_REFERER"))
			   
%>
