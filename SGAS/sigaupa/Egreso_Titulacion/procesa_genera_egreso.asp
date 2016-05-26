<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'response.Flush()
'for each k in request.Form()
	'response.Write(k&" = "&request.Form(k)&"<br>")
'next


registros	=	request.Form("egre[0][registros]")

'---------------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------------
usuario = negocio.ObtenerUsuario

set	f_datos = new cVariables
f_datos.procesaform

'f_datos.Listar

for nr = 0 to registros - 1	
	egre_ncorr = f_datos.obtenervalor("GA",nr,"egre_ncorr")
	'response.Write(nr&".<br>")
	
	if egre_ncorr <> "" then
		aceg_ncorr = f_datos.obtenervalor("GA", nr, "html_aceg_ncorr")
		
		if EsVacio(aceg_ncorr) then
			if EsVacio(aceg_ncorr_seq) then
				aceg_ncorr_seq = conexion.ConsultaUno("SELECT aceg_ncorr_seq.nextval FROM dual")
			end if
			aceg_ncorr = aceg_ncorr_seq
		end if
		
		crear_acta = ""
		crear_acta = conexion.ConsultaUno("select '1' as existe from actas_egresos where aceg_ncorr = '"&aceg_ncorr&"'")
		
		if EsVacio(crear_acta) then
			'crear acta
			set fActa = new cFormulario
			fActa.Carga_Parametros "genera_egreso.xml","nueva_acta"
			fActa.inicializar conexion
			fActa.ProcesaForm
			fActa.agregacampopost "aceg_ncorr", aceg_ncorr
			fActa.agregacampopost "plan_ccod", conexion.ConsultaUno("select nvl(plan_ccod,'') from egresados where egre_ncorr = '"&egre_ncorr&"'")
			fActa.agregacampopost "espe_ccod", conexion.ConsultaUno("select nvl(espe_ccod,'') from egresados where egre_ncorr = '"&egre_ncorr&"'")
			fActa.agregacampopost "peri_ccod", conexion.ConsultaUno("select nvl(peri_ccod,'') from egresados where egre_ncorr = '"&egre_ncorr&"'")
			fActa.agregacampopost "sede_ccod", negocio.ObtenerSede
			fActa.agregacampopost "aceg_femision", negocio.ObtenerFechaActual 'conexion.ConsultaUno("select sysdate from dual")
			fActa.mantienetablas false
			'response.Write("acta:"&aceg_ncorr&"<br>")				
		end if			
		
		set fActa = new cFormulario
		fActa.Carga_Parametros "genera_egreso.xml","detalle_acta"
		fActa.inicializar conexion
		fActa.ProcesaForm
		fActa.agregacampopost "aceg_ncorr",aceg_ncorr
		fActa.agregacampopost "egre_ncorr",egre_ncorr
		fActa.mantienetablas false
		'response.Write(nr&" - "&egre_ncorr&"-"&aceg_ncorr&"."&ab&"<br>")
		'response.Write("<hr>")
	end if
next 
	
	
	
	
	'----------------------------------------------------------------------*------------------------------
	'----  DE AQUI PA ABAJO NO SE QUE HACE    NO SIRVE ---------------------------------------------------

	set f_valores = new CFormulario
	f_valores.Carga_Parametros "genera_egreso.xml", "nueva_acta"
	f_valores.Inicializar conexion
	f_valores.ProcesaForm

	set f_acta_nt	=	new cFormulario
	f_acta_nt.carga_parametros	"genera_egreso.xml","f_acta_nt"
	f_acta_nt.inicializar	conexion
	
	
	'v_aceg_ncorr = conexion.ConsultaUno("SELECT aceg_ncorr_seq.nextval FROM dual")

	'conexion.Estadotransaccion	false
	if false then
	for fila=0 to 9
		if f_datos.obtenervalor("GA",fila,"html_aceg_ncorr") <> "" then
			insert_actas_egresos	= "insert into actas_egresos values('"& f_datos.obtenervalor("GA",fila,"html_aceg_ncorr") &"','"&f_valores.ObtenerValorPost(0, "plan_ccod")&"','"&f_valores.ObtenerValorPost(0, "espe_ccod")&"',sysdate,'"& v_usuario &"','"&f_valores.ObtenerValorPost(0, "peri_ccod")&"','"&f_valores.ObtenerValorPost(0, "sede_ccod")&"',sysdate)"
			conexion.EstadoTransaccion	conexion.EjecutaS (insert_actas_egresos)
			response.Write("<pre>"&insert_actas_egresos&"</pre><br>")
			
			v_pers_ncorr	=	f_datos.obtenervalor("GA",fila,"pers_ncorr")
			insert_detalle_aegresos	=	"insert into detalle_actas_egresos "& vbcrlf &_
								"select '"& f_datos.obtenervalor("GA",fila,"html_aceg_ncorr") &"', a.egre_ncorr, sysdate,'"&v_usuario&"' "& vbcrlf &_
								" from egresados a "& vbcrlf &_
								" where "& vbcrlf &_
								" a.plan_ccod='"&f_valores.ObtenerValorPost(0, "plan_ccod")&"'  "& vbcrlf &_
								" and a.espe_ccod='"&f_valores.ObtenerValorPost(0, "espe_ccod")&"'  "& vbcrlf &_
								" and a.peri_ccod='"&f_valores.ObtenerValorPost(0, "peri_ccod")&"' "& vbcrlf &_
								" and a.sede_ccod='"&f_valores.ObtenerValorPost(0, "sede_ccod")&"'  "& vbcrlf &_
								" and a.pers_ncorr = '"& v_pers_ncorr &"' "& vbcrlf &_
								" and not exists (select 1 from detalle_actas_egresos b where a.egre_ncorr=b.egre_ncorr)"

			response.Write("<pre>"&insert_detalle_aegresos&"</pre><br>")
			conexion.EstadoTransaccion	conexion.EjecutaS (insert_detalle_aegresos)

		end if	'si viene un nro de acta
	next
	end if


'conexion.EstadoTransaccion	false

Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>