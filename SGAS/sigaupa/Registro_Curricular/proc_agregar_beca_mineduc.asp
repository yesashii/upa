<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

v_accion	= Request.Form("accion")

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario=negocio.obtenerUsuario

set f_descuentos = new CFormulario
f_descuentos.Carga_Parametros "ingresar_beca_mineduc.xml", "agregar_beca"
f_descuentos.Inicializar conexion
f_descuentos.ProcesaForm
for filai = 0 to f_descuentos.CuentaPost - 1

	post_ncorr 		= f_descuentos.ObtenerValorPost (filai, "post_ncorr")
	ofer_ncorr 		= f_descuentos.ObtenerValorPost (filai, "ofer_ncorr")	
	stde_ccod 		= f_descuentos.ObtenerValorPost (filai, "stde_ccod")
	monto_bene 		= f_descuentos.ObtenerValorPost (filai, "monto_bene")
	ano_adju 		= f_descuentos.ObtenerValorPost (filai, "ano_adjudicacion")
	observacion 	= f_descuentos.ObtenerValorPost (filai, "observacion")
	stde_ccod_old	= f_descuentos.ObtenerValorPost (filai, "stde_ccod_old")	

if v_accion="M" then ' Si esta modificando, se elimina todo y se vuelve a insertar
	sql_borra_mineduc		="delete from alumno_credito where post_ncorr="&post_ncorr&" and tdet_ccod='"&stde_ccod_old&"'"
	conexion.ejecutaS (sql_borra_mineduc)
	
	sql_borra_sdescuentos	="delete from sdescuentos where post_ncorr="&post_ncorr&" and stde_ccod='"&stde_ccod_old&"' and ofer_ncorr='"&ofer_ncorr&"'"
	conexion.ejecutaS (sql_borra_sdescuentos)
end if	
'response.Write("paso 1: "&conexion.ObtenerEstadoTransaccion)	
	existe_mineduc=conexion.ConsultaUno("select case count(post_ncorr) when 0 then 'N' else 'S' end from alumno_credito where post_ncorr="&post_ncorr&" and tdet_ccod='"&stde_ccod&"'")
	
	if existe_mineduc="N" then
	
		 acre_ncorr=conexion.ConsultaUno("exec ObtenerSecuencia 'alumno_credito'")
		 'acre_ncorr=10000
		
			p_insert=	"insert into alumno_credito(acre_ncorr,post_ncorr,monto_bene,ano_adjudicacion,observacion,tdet_ccod,audi_tusuario,audi_fmodificacion) "&_
						" values("&acre_ncorr&","&post_ncorr&",'"&monto_bene&"','"&ano_adju&"','"&observacion&"','"&stde_ccod&"','beca - "&usuario&"',getdate())"		  
			'response.Write("<pre>"&p_insert&"</pre>")
			conexion.ejecutaS (p_insert)

	end if

	existe_sdescuento=conexion.ConsultaUno("select case count(post_ncorr) when 0 then 'N' else 'S' end from sdescuentos where post_ncorr="&post_ncorr&" and stde_ccod='"&stde_ccod&"' and ofer_ncorr='"&ofer_ncorr&"'")
	
	if existe_sdescuento="N" then
			sql_sdescuentos=	"insert into sdescuentos(esde_ccod,stde_ccod,post_ncorr,ofer_ncorr,sdes_mmatricula,sdes_mcolegiatura,sdes_nporc_matricula,sdes_nporc_colegiatura,sdes_tobservaciones,audi_tusuario,audi_fmodificacion) "&_
								" values('1',"&stde_ccod&","&post_ncorr&",'"&ofer_ncorr&"','0','0','0','0','"&observacion&"','beca - "&usuario&"',getdate())"		  
	else
			sql_sdescuentos=	" update sdescuentos set esde_ccod=1, sdes_mmatricula=0,sdes_mcolegiatura=0,sdes_nporc_matricula=0,sdes_nporc_colegiatura=0,sdes_tobservaciones='"&observacion&"',audi_tusuario='beca - "&usuario&"',audi_fmodificacion=getdate() "&_
								" where stde_ccod="&stde_ccod&" and post_ncorr="&post_ncorr&" and ofer_ncorr='"&ofer_ncorr&"' "		  
	end if
	conexion.ejecutaS (sql_sdescuentos)
	

next
'response.End()
f_descuentos.MantieneTablas false
'response.Write(conexion.ObtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'response.End()

%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>