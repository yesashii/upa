<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- '#include file = "../biblioteca/_negocio.asp" -->

<%
'-------------------------------------------------------debug>>
ip_usuario = Request.ServerVariables("REMOTE_ADDR")
ip_de_prueba = "172.16.100.127" 'luis herrera

'--------------------------------------------------------------

'    for each k in request.Form()
'	    response.Write(k&" = "&request.Form(k)&"<br>")
'    next
'    response.End()
'-------------------------------------------------------debug<<
' postulacion_masiva_otec.asp?b[0][dcur_ncorr]=1109&b[0][sede_ccod]=1&b[0][nord_compra]=001&b[0][fpot_ccod]=2

DCUR_NCORR  	= request.querystring("b[0][dcur_ncorr]")
sede_ccod   	= request.querystring("b[0][sede_ccod]")
fpot_ccod   	= request.querystring("b[0][fpot_ccod]")
nord_compra 	= request.querystring("b[0][nord_compra]")
anio_admision = request.querystring("b[0][anio_admision]")
tipo_usuario  = session("tipo_usuario")

if dcur_ncorr = "" or sede_ccod = "" then
	DCUR_NCORR  = request.form("b[0][dcur_ncorr]")
	sede_ccod   = request.form("b[0][sede_ccod]")
	fpot_ccod   = request.form("b[0][fpot_ccod]")
  nord_compra = request.form("b[0][nord_compra]")
end if

if fpot_ccod = 4 then
	tipo=2
end if

if fpot_ccod = 3 or fpot_ccod = 3 or fpot_ccod = 5 then
	tipo=1
end if

'rut recargado de la empresa
e_empr_nrut = request.querystring("e[0][empr_nrut]")
e_empr_xdv  = request.querystring("e[0][empr_xdv]")

'rut recargado de la otic
o_empr_nrut = request.querystring("o[0][empr_nrut]")
o_empr_xdv  = request.querystring("o[0][empr_xdv]")
'response.Write(o_empr_nrut&"-"&o_empr_xdv)
'response.Write("detalle "&detalle)
session("url_actual")="../mantenedores/postulacion_masiva_otec.asp?b[0][dcur_ncorr]="&dcur_ncorr&"&b[0][sede_ccod]="&sede_ccod&"&b[0][fpot_ccod]="&fpot_ccod&"&b[0][nord_compra]="&nord_compra
'response.Write("../mantenedores/m_modulos.asp?mote_tdesc="&mote_tdesc&"&mote_ccod="&mote_ccod)
set pagina = new CPagina
pagina.Titulo = "Postulacion a Seminarios, Cursos y Diplomados"

set botonera =  new CFormulario
botonera.carga_parametros "postulacion_masiva_otec.xml", "botonera"

set f_botonera =  new CFormulario
f_botonera.carga_parametros "postulacion_masiva_otec.xml", "botonera2"

'response.End()
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

'set negocio = new CNegocio
'negocio.Inicializa conexion

'set errores 	= new cErrores

if fpot_ccod = "" then
	fpot_ccod="2"
end if


dcur_tdesc = conexion.consultauno("SELECT dcur_tdesc FROM diplomados_cursos WHERE cast(dcur_ncorr as varchar)= '" & DCUR_NCORR & "'")
'response.Write(dcur_tdesc)

'-----------------------------------------------------------------------
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "postulacion_masiva_otec.xml", "f_busqueda"

 f_busqueda.Inicializar conexion

 consulta = "Select '"&anio_admision&"' as anio_admision,'"&dcur_ncorr&"' as dcur_ncorr, '"&sede_ccod&"' as sede_ccod, '"&nord_compra&"' as nord_compra"
 f_busqueda.consultar consulta

 filtro_dcur = ""
 if tipo_usuario = "Externo" then
   filtro_dcur = " and b.dcur_ncorr in (select dcur_ncorr from mantenedor_diplomados_cursos where isnull(mdcu_estado,0) = 1) "
 end if

 consulta = " select anio_admision,b.dcur_ncorr,b.dcur_tdesc,c.sede_ccod,c.sede_tdesc " & vbCrLf & _
			" from datos_generales_secciones_otec a, diplomados_cursos b,sedes c,ofertas_otec d " & vbCrLf & _
			" where a.dcur_ncorr=b.dcur_ncorr " & vbCrLf & _
		    " and a.sede_ccod=c.sede_ccod " & vbCrLf & _
			" and a.esot_ccod not in (3,4) and a.dcur_ncorr not in (5,35) "& filtro_dcur & vbCrLf & _
			" and a.dgso_ncorr=d.dgso_ncorr " & vbCrlf & _
			" and exists (select 1 from ofertas_otec cc where cc.dgso_ncorr=a.dgso_ncorr) "& vbCrLf & _
			" order by anio_admision desc, c.sede_tdesc asc, b.dcur_tdesc asc"
 'response.Write("<pre>"&consulta&"</pre>")
 f_busqueda.inicializaListaDependiente "lBusqueda", consulta
 f_busqueda.Siguiente

tiene_datos_generales = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from datos_generales_secciones_otec where cast(DCUR_NCORR as varchar)='"&DCUR_NCORR&"' and cast(sede_ccod as varchar)='"&sede_ccod&"' and esot_ccod in (1,2)")

dcur_tdesc = conexion.consultaUno("select dcur_tdesc from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")
sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede_ccod&"'")
dcur_nsence = conexion.consultaUno("select dcur_nsence from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")
dgso_ncorr = conexion.consultaUno("select dgso_ncorr from datos_generales_secciones_otec where cast(DCUR_NCORR as varchar)='"&DCUR_NCORR&"' and cast(sede_ccod as varchar)='"&sede_ccod&"' and esot_ccod in (1,2)")
periodo_programa = conexion.consultaUno("select 'FECHA INICIO : <strong>'+ protic.trunc(dgso_finicio) + '</strong>    FECHA TERMINO : <strong>' + protic.trunc(dgso_ftermino) + '</strong>' from datos_generales_secciones_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")

'response.Write("select empr_nrut from ordenes_compras_otec a,empresas b where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"' and a.empr_ncorr=b.empr_ncorr")

if dgso_ncorr <> "" and e_empr_nrut="" then
  if fpot_ccod="2" or fpot_ccod="3" then
	e_empr_nrut = conexion.consultaUno("select empr_nrut from ordenes_compras_otec a,empresas b where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"' and a.empr_ncorr = b.empr_ncorr")
	e_empr_xdv = conexion.consultaUno("select empr_xdv from ordenes_compras_otec a,empresas b where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"' and a.empr_ncorr = b.empr_ncorr")
  else
	e_empr_nrut = conexion.consultaUno("select empr_nrut from ordenes_compras_otec a,empresas b where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"' and a.empr_ncorr_2=b.empr_ncorr")
	e_empr_xdv = conexion.consultaUno("select empr_xdv from ordenes_compras_otec a,empresas b where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"' and a.empr_ncorr_2=b.empr_ncorr")
  end if
end if
'response.End()
if dgso_ncorr <> "" and o_empr_nrut="" and fpot_ccod="4" then
	o_empr_nrut = conexion.consultaUno("select empr_nrut from ordenes_compras_otec a,empresas b where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"' and a.empr_ncorr = b.empr_ncorr")
	o_empr_xdv = conexion.consultaUno("select empr_xdv from ordenes_compras_otec a,empresas b where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"' and a.empr_ncorr = b.empr_ncorr")
end if

if e_empr_nrut <>"" then
	e_empr_ncorr=conexion.consultaUno("select empr_ncorr from empresas where cast(empr_nrut as varchar)='"&e_empr_nrut&"'")
end if


'---------------------------------------------------------------------------------------------------
set datos_generales = new cformulario
datos_generales.carga_parametros "postulacion_masiva_otec.xml", "datos_generales"
datos_generales.inicializar conexion


consulta= " select a.dgso_ncorr,a.dcur_ncorr,a.sede_ccod,protic.trunc(dgso_finicio) as dgso_finicio,protic.trunc(dgso_ftermino) as dgso_ftermino,dgso_ncupo,dgso_nquorum,ofot_nmatricula,ofot_narancel " & vbCrlf & _
		  " from datos_generales_secciones_otec a left outer join ofertas_otec  b" & vbCrlf & _
		  "  on a.dgso_ncorr = b.dgso_ncorr " & vbCrlf &_
		  " where cast(a.dcur_ncorr as varchar)='"&DCUR_NCORR&"'  " & vbCrlf & _
		  " and cast(a.sede_ccod as varchar)='"&sede_ccod&"' "

if tiene_datos_generales = "N" then
	consulta = "select '' as dgso_ncorr"
end if

datos_generales.consultar consulta
if codigo <> "" then
	datos_generales.agregacampocons "sede_ccod", sede_ccod
	datos_generales.agregacampocons "dcur_ncorr", dcur_ncorr
end if
datos_generales.siguiente

'--------------iniciamos variables de sessión con valor de sede y programa para la postulación------------
if sede_ccod <> "" and dcur_ncorr <> "" then
	session("sede_ccod_postulacion") = sede_ccod
	session("dcur_ncorr_postulacion") = dcur_ncorr
end if

'---------------------------------------------------------------------------------------------------
set datos_empresa = new cformulario
datos_empresa.carga_parametros "postulacion_masiva_otec.xml", "datos_empresa"
datos_empresa.inicializar conexion


consulta= " select empr_ncorr,empr_trazon_social, empr_nrut,empr_xdv, empr_tdireccion, " & vbCrlf & _
		  " ciud_ccod,empr_tfono,empr_tfax,empr_tgiro,empr_tejecutivo,empr_temail_ejecutivo " & vbCrlf & _
		  " from empresas  " & vbCrlf & _
		  " where cast(empr_nrut as varchar)='"&e_empr_nrut&"' and empr_xdv='"&e_empr_xdv&"'"

existe_empresa = conexion.consultaUno("select count(*) from empresas where cast(empr_nrut as varchar)='"&e_empr_nrut&"' and empr_xdv='"&e_empr_xdv&"'")
'response.write("<pre>"&consulta&"</pre>")
if existe_empresa="0" then
	consulta = "select '' as pers_ncorr"
end if
'response.write("<pre>"&consulta&"</pre>")
datos_empresa.consultar consulta
datos_empresa.siguiente

if e_empr_nrut <> "" and e_empr_xdv <> "" then
	datos_empresa.AgregaCampoCons "empr_nrut", e_empr_nrut
	datos_empresa.AgregaCampoCons "empr_xdv", e_empr_xdv
end if

empr_ncorr	=	datos_empresa.obtenerValor("empr_ncorr")


if fpot_ccod="2" or fpot_ccod="3" then
	tiene_empresa_1 = conexion.consultaUno("select isnull(empr_ncorr,0) from ordenes_compras_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"'")
else
	tiene_empresa_1 = conexion.consultaUno("select isnull(empr_ncorr_2,0) from ordenes_compras_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"'")
end if
if fpot_ccod = "4" then
	tiene_otic_1 = conexion.consultaUno("select isnull(empr_ncorr,0) from ordenes_compras_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"'")
else
	tiene_otic_1 = "0"
end if

'---------------------------------------------------------------------------------------------------
habilita_orden = "NO"
habilita_otic = "NO"
if fpot_ccod = "2" and tiene_empresa_1 > "0" then
	habilita_orden = "SI"
end if
if fpot_ccod = "3" and tiene_empresa_1 > "0" then
	habilita_orden = "SI"
end if
if fpot_ccod = "4" and tiene_empresa_1 > "0" and tiene_otic_1 > "0" then
	habilita_orden = "SI"
end if
if fpot_ccod = "4" and tiene_empresa_1 > "0" then
	habilita_otic = "SI"
end if


if habilita_otic = "SI" then'--------si financia Otic y ya ingreso empresa buscamos datos otic
	set datos_otic = new cformulario
	datos_otic.carga_parametros "postulacion_masiva_otec.xml", "datos_otic"
	datos_otic.inicializar conexion


	consulta= " select empr_ncorr,empr_trazon_social, empr_nrut,empr_xdv, empr_tdireccion, " & vbCrlf & _
			  " ciud_ccod,empr_tfono,empr_tfax,empr_tgiro,empr_tejecutivo,empr_temail_ejecutivo " & vbCrlf & _
			  " from empresas  " & vbCrlf & _
			  " where cast(empr_nrut as varchar)='"&o_empr_nrut&"' and empr_xdv='"&o_empr_xdv&"'"
	'response.Write("<pre>"&consulta&"</pre>")

	existe_otic = conexion.consultaUno("select count(*) from empresas where cast(empr_nrut as varchar)='"&o_empr_nrut&"' and empr_xdv='"&o_empr_xdv&"'")
		if existe_otic = "0" then
			consulta = "select '' as pers_ncorr"
		end if
		datos_otic.consultar consulta
		datos_otic.siguiente
		if o_empr_nrut <> "" and o_empr_xdv <> "" then
			datos_otic.AgregaCampoCons "empr_nrut", o_empr_nrut
			datos_otic.AgregaCampoCons "empr_xdv", o_empr_xdv
		end if

empr_ncorr_2		= 	datos_otic.obtenerValor("empr_ncorr")
end if

'------------------------------búsqueda de datos orden de compra---------------------------------------------------
matricula = conexion.consultaUno("select ofot_nmatricula from ofertas_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")
arancel = conexion.consultaUno("select ofot_narancel from ofertas_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")
ocot_nalumnos = conexion.consultaUno("select isnull((select top 1 ocot_nalumnos from ordenes_compras_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"'),0)")
c_ocot_monto_empresa	="select isnull((select top 1 ocot_monto_empresa from ordenes_compras_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"'),0)"
ocot_monto_empresa = conexion.consultaUno(c_ocot_monto_empresa)
ocot_monto_otic = conexion.consultaUno("select isnull((select top 1 ocot_monto_otic from ordenes_compras_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"'),0)")
descuento_estimado = conexion.consultaUno("select isnull((select top 1 monto_descuento_editado from ordenes_compras_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"'),0)")
ocot_NRO_REGISTRO_SENCE = conexion.consultaUno("select isnull((select top 1 ocot_NRO_REGISTRO_SENCE from ordenes_compras_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"'),0)")
descuento_editado = conexion.consultaUno("select isnull((select top 1 monto_descuento_estimado from ordenes_compras_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"'),0)")
valor_descuento = conexion.consultaUno("select isnull((select top 1 cast(tdet_ccod as varchar)+'*'+cast(ddcu_mdescuento as varchar) from ordenes_compras_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"'),'0*0')")
valor_calcula2 = clng(ocot_monto_empresa) + clng(ocot_monto_otic)
'------------------------------------------------------------------------------------------------------------------
'---------------------debug>>
'ocot_monto_empresa	=
'respuestaDir				= postulacion_masiva_otec.asp?b[0][dcur_ncorr]=1109&b[0][sede_ccod]=1&b[0][nord_compra]=001&b[0][fpot_ccod]=2

''		if ip_usuario = ip_de_prueba then
'			response.Write(" Entró:  "&c_ocot_monto_empresa)
			'response.end()
''		end if
'---------------------debug<<


set datos_finales = new cformulario
datos_finales.carga_parametros "postulacion_masiva_otec.xml", "datos_finales"
datos_finales.inicializar conexion

consulta= " select '' as pers_ncorr"

c_datos = " select '0*0' as tdet_ccod, 'SIN DESCUENTO (0%)' as tdet_tdesc "&_
          " union "&_
          " select cast(a.tdet_ccod as varchar)+'*'+cast(ddcu_mdescuento as varchar) as tdet_ccod,b.tdet_tdesc + ' ('+cast(ddcu_mdescuento as varchar)+'%)' as tdet_tdesc "&_
		  " from descuentos_diplomados_curso a, tipos_detalle b "&_
		  " where a.tdet_ccod=b.tdet_ccod and ddcu_mdescuento > 0 "&_
		  " and cast(dcur_ncorr as varchar)='"&DCUR_NCORR&"'"

datos_finales.consultar consulta
datos_finales.agregaCampoParam "tdet_ccod","destino","("&c_datos&")a"
datos_finales.siguiente
datos_finales.agregaCampoCons "tdet_ccod",valor_descuento
'valor_descuento = "0*0"
habilitado_ingreso_alumnos = false
if ocot_monto_empresa <> "0" or acot_monto_otic <> "0" then
	habilitado_ingreso_alumnos = true
end if

'conexion.consultaUno()
'response.Write("select isnull((select count(*) from postulacion_otec where  dgso_ncorr="&dgso_ncorr&" and norc_empresa="&nord_compra&"and empr_ncorr_empresa="&e_empr_ncorr&"),0)")
if dgso_ncorr <> "" and nord_compra <> "" and e_empr_ncorr <> "" then
	if fpot_ccod="2" or fpot_ccod="3" then
		existe_postulante= conexion.consultaUno("select isnull((select count(*) from postulacion_otec where  dgso_ncorr="&dgso_ncorr&" and norc_empresa="&nord_compra&"and empr_ncorr_empresa="&e_empr_ncorr&"),0)")
	else
		existe_postulante= conexion.consultaUno("select isnull((select count(*) from postulacion_otec where  dgso_ncorr="&dgso_ncorr&" and norc_otic="&nord_compra&"and empr_ncorr_empresa="&e_empr_ncorr&"),0)")
	end if
	'response.write("<br>dgso_ncorr="&dgso_ncorr)
	'response.write("<br>dgso_ncorr="&nord_compra)
	'response.write("<br>"&existe_postulante)
end if


'##########################################################################################
'*******************ARREGLO PARA SOLUCION DE CAMBIO DE AÑO EN OC***************************
if EsVacio(empr_ncorr) then
	empr_ncorr		= 	0
end if

if EsVacio(empr_ncorr_2) then
	empr_ncorr_2	=	0
end if

if not EsVacio(dgso_ncorr) then

v_monto_a=0
v_monto_b=0
v_monto_c=0
v_monto_d=0

'tiene_detalle = conexion.consultaUno(" select count(*) from ordenes_compras_otec  where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'  and cast(empr_ncorr as varchar)='"&empr_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"'")
'---------------------------------------------------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "agrega_postulantes.xml", "datos_orden"
formulario.inicializar conexion

if fpot_ccod=4 then
	filtro= " and cast(empr_ncorr as varchar)='"&empr_ncorr_2&"' " ' Otic
else
	filtro= " and cast(empr_ncorr as varchar)='"&empr_ncorr&"' " 'Empresa
end if
	consulta= " select orco_ncorr,dgso_ncorr,empr_ncorr,nord_compra,empr_ncorr_2,fpot_ccod,ocot_nalumnos,ocot_monto_persona,ocot_monto_otic,ocot_NRO_REGISTRO_SENCE,ocot_monto_empresa " & vbCrlf & _
			  " from ordenes_compras_otec " & vbCrlf & _
			  " where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' " & vbCrlf & _
			  " "&filtro&" " & vbCrlf & _
			  " and cast(nord_compra as varchar)='"&nord_compra&"' "

'response.write("<pre>"&consulta&"</pre>")

formulario.consultar consulta
formulario.siguiente



set f_datos = new cformulario
f_datos.carga_parametros "tabla_vacia.xml", "tabla"
f_datos.inicializar conexion

sql_cambio_anio=	"select protic.trunc(dgso_finicio) as fecha_inicio,protic.trunc(dgso_ftermino) as fecha_fin,year(dgso_finicio) as anio_inicio, "& vbcrlf &_
					" year(dgso_ftermino) as anio_fin,(year(dgso_ftermino)- year(dgso_finicio)) as diferencia "& vbcrlf &_
					" from datos_generales_secciones_otec "& vbcrlf &_
					" where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'"

'response.Write(sql_cambio_anio)

f_datos.consultar sql_cambio_anio
f_datos.siguiente

v_cambio_anio 	= f_datos.obtenerValor("diferencia")
v_anio_inicio 	= f_datos.obtenerValor("anio_inicio")
v_anio_fin 		= f_datos.obtenerValor("anio_fin")
v_fecha_inicio_a= f_datos.obtenerValor("fecha_inicio")
v_fecha_corte_b = f_datos.obtenerValor("fecha_fin")
v_fecha_inicio_c= f_datos.obtenerValor("fecha_inicio")
v_fecha_corte_d = f_datos.obtenerValor("fecha_fin")

v_num_oc_a=nord_compra
v_num_oc_b=nord_compra
v_num_oc_c=nord_compra
v_num_oc_d=nord_compra

' Si cambia de año y es con Otic y codigo sence (Empresa sence, empresa y otic,  natural y empresa)
if v_cambio_anio=1 and (fpot_ccod="3" or  fpot_ccod="4" or  fpot_ccod="5") then
	v_txt="Total"
	v_orco_ncorr=formulario.obtenerValor("orco_ncorr")
	'v_orco_ncorr=0
	set f_detalle = new cformulario
	f_detalle.carga_parametros "agrega_postulantes.xml", "detalle_datos_orden"
	f_detalle.inicializar conexion

	if v_orco_ncorr <>"" then
		consulta_detalle= "select orco_ncorr,anos_ccod,protic.trunc(dorc_finicio) as dorc_finicio,protic.trunc(dorc_ffin) as dorc_ffin,  "& vbcrlf &_
						  "	dorc_mmonto, dorc_naccion_sence, dorc_num_oc, empr_ncorr, tins_ccod, dorc_nindice,dorc_nhoras  "& vbcrlf &_
						  "	from detalle_ordenes_compras_otec where orco_ncorr="&v_orco_ncorr&" order by dorc_nindice asc "
	else
		consulta_detalle = "select * from detalle_ordenes_compras_otec  where 1=2"
	end if

	f_detalle.consultar consulta_detalle
	f_detalle.siguiente

	if f_detalle.nroFilas >1 then
		' tins_ccod=1 (empresa)
		v_fecha_inicio_a=f_detalle.obtenerValor("dorc_finicio")
		v_fecha_corte_a	=f_detalle.obtenerValor("dorc_ffin")
		v_monto_a		=f_detalle.obtenerValor("dorc_mmonto")
		v_num_horas_a	=f_detalle.obtenerValor("dorc_nhoras")
		v_num_accion_a	=f_detalle.obtenerValor("dorc_naccion_sence")
		v_num_oc_a		=f_detalle.obtenerValor("dorc_num_oc")

		f_detalle.Siguiente

		v_fecha_inicio_b=f_detalle.obtenerValor("dorc_finicio")
		v_fecha_corte_b	=f_detalle.obtenerValor("dorc_ffin")
		v_monto_b		=f_detalle.obtenerValor("dorc_mmonto")
		v_num_horas_b	=f_detalle.obtenerValor("dorc_nhoras")
		v_num_accion_b	=f_detalle.obtenerValor("dorc_naccion_sence")
		v_num_oc_b		=f_detalle.obtenerValor("dorc_num_oc")

		if tipo = "2" then ' tins_ccod=2 (otic)

			f_detalle.Siguiente

			v_fecha_inicio_c=f_detalle.obtenerValor("dorc_finicio")
			v_fecha_corte_c	=f_detalle.obtenerValor("dorc_ffin")
			v_monto_c		=f_detalle.obtenerValor("dorc_mmonto")
			v_num_horas_c	=f_detalle.obtenerValor("dorc_nhoras")
			v_num_accion_c	=f_detalle.obtenerValor("dorc_naccion_sence")
			v_num_oc_c		=f_detalle.obtenerValor("dorc_num_oc")

			f_detalle.Siguiente

			v_fecha_inicio_d=f_detalle.obtenerValor("dorc_finicio")
			v_fecha_corte_d	=f_detalle.obtenerValor("dorc_ffin")
			v_monto_d		=f_detalle.obtenerValor("dorc_mmonto")
			v_num_horas_d	=f_detalle.obtenerValor("dorc_nhoras")
			v_num_accion_d	=f_detalle.obtenerValor("dorc_naccion_sence")
			v_num_oc_d		=f_detalle.obtenerValor("dorc_num_oc")
		end if
	end if

end if

' Si NO cambia de año aunque sea con otic y codigo sence, solo va en un año (Empresa sence, empresa y otic,  natural y empresa)
if v_cambio_anio=0 and (fpot_ccod="3" or  fpot_ccod="4" or  fpot_ccod="5") then

' cambian las fechas al no dividir las facturas
v_fecha_inicio_a= f_datos.obtenerValor("fecha_inicio")
v_fecha_corte_a = f_datos.obtenerValor("fecha_fin")
v_fecha_inicio_c= f_datos.obtenerValor("fecha_inicio")
v_fecha_corte_c = f_datos.obtenerValor("fecha_fin")


	v_txt="Total"
	v_orco_ncorr=formulario.obtenerValor("orco_ncorr")

	set f_detalle = new cformulario
	f_detalle.carga_parametros "agrega_postulantes.xml", "detalle_datos_orden"
	f_detalle.inicializar conexion

	if v_orco_ncorr <>"" then
		consulta_detalle= "select orco_ncorr,anos_ccod,protic.trunc(dorc_finicio) as dorc_finicio,protic.trunc(dorc_ffin) as dorc_ffin,  "& vbcrlf &_
						  "	dorc_mmonto, dorc_naccion_sence, dorc_num_oc, empr_ncorr, tins_ccod, dorc_nindice,dorc_nhoras  "& vbcrlf &_
						  "	from detalle_ordenes_compras_otec where orco_ncorr="&v_orco_ncorr&" order by dorc_nindice asc "
	else
		consulta_detalle = "select * from detalle_ordenes_compras_otec  where 1=2"
	end if
	'response.write("<pre>"&consulta_detalle&"</pre>")
	f_detalle.consultar consulta_detalle
	f_detalle.Siguiente
	if f_detalle.nroFilas >=1 then
		' tins_ccod=1 (empresa)
		v_fecha_inicio_a=f_detalle.obtenerValor("dorc_finicio")
		v_fecha_corte_a	=f_detalle.obtenerValor("dorc_ffin")
		v_monto_a		=f_detalle.obtenerValor("dorc_mmonto")
		v_num_horas_a	=f_detalle.obtenerValor("dorc_nhoras")
		v_num_accion_a	=f_detalle.obtenerValor("dorc_naccion_sence")
		v_num_oc_a		=f_detalle.obtenerValor("dorc_num_oc")

		if tipo = "2" then ' tins_ccod=2 (otic)

			f_detalle.Siguiente

			v_fecha_inicio_c=f_detalle.obtenerValor("dorc_finicio")
			v_fecha_corte_c	=f_detalle.obtenerValor("dorc_ffin")
			v_monto_c		=f_detalle.obtenerValor("dorc_mmonto")
			v_num_horas_c	=f_detalle.obtenerValor("dorc_nhoras")
			v_num_accion_c	=f_detalle.obtenerValor("dorc_naccion_sence")
			v_num_oc_c		=f_detalle.obtenerValor("dorc_num_oc")

		end if
	end if

end if

end if
'##########################################################################################


%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>


<script language="JavaScript">
var t_busqueda2;
t_busqueda2 = new CTabla("e");

function enviar(formulario){
	formulario.elements["detalle"].value="2";
  	if(preValidaFormulario(formulario)){
		formulario.submit();

	}
}
function abrir() {

	direccion = "editar_diplomados_curso.asp";
	resultado=window.open(direccion, "ventana1","width=550,height=250,scrollbars=no, left=380, top=150");

 // window.close();
}
function abrir_programa() {
	var DCUR_NCORR = '<%=DCUR_NCORR%>';
	direccion = "editar_programas_dcurso.asp?dcur_ncorr=" + DCUR_NCORR;
	resultado=window.open(direccion, "ventana2","width=550,height=400,scrollbars=yes, left=380, top=100");

 // window.close();
}

function agregar_nuevo(formulario){
  	if(preValidaFormulario(formulario)){
		formulario.action = "agrega_postulantes.asp";
		formulario.submit();

	}
}

function forma_pago(valor)
{
	forma_pago_registrada = '<%=forma_pago%>';
	//alert("forma_pago "+forma_pago_registrada+ " valor "+valor);
	if (forma_pago_registrada != valor)
	{
		alert("Se debe volver a buscar los datos para que los cambios se  vean reflejados.");
		if ((forma_pago_registrada=="2") || (forma_pago_registrada=="3"))
			{document.getElementById("bt_empresa").style.visibility = "hidden" ;
		}
		if ((forma_pago_registrada=="4"))
		{document.getElementById("bt_otic").style.visibility = "hidden" ;}

	}
	else
	{
		if ((forma_pago_registrada=="2") || (forma_pago_registrada=="3"))
			{document.getElementById("bt_empresa").style.visibility = "visible" ;
		}
		if ((forma_pago_registrada=="4"))
		{document.getElementById("bt_otic").style.visibility = "visible" ;}
	}
	if (valor=='2')//en caso de ser forma de pago empresa sin sence se debe descheckear esa opción
	{
	 document.getElementById("sence").style.visibility = "hidden" ;
	 document.edicion_persona.elements["m[0][utiliza_sence]"].checked = false;
	 document.edicion_persona.elements["_m[0][utiliza_sence]"].checked = false;
	 document.edicion_persona.elements["m[0][utiliza_sence]"].value = 0;
	 document.edicion_persona.elements["_m[0][utiliza_sence]"].value = 0;
	}
	if (valor=='3')//en caso de ser forma de pago empresa con sence se debe descheckear esa opción
	{
		 document.getElementById("sence").style.visibility = "visible" ;
		 document.edicion_persona.elements["m[0][utiliza_sence]"].checked = true;
		 document.edicion_persona.elements["_m[0][utiliza_sence]"].checked = true;
		 document.edicion_persona.elements["m[0][utiliza_sence]"].value = 1;
		 document.edicion_persona.elements["_m[0][utiliza_sence]"].value = 1;
	}
	if (valor=='4')
	{
		document.getElementById("sence").style.visibility = "visible" ;
	}
}
function ValidaRut22()
{
	rut = document.edicion2.elements["e[0][empr_nrut]"].value + '-' + document.edicion2.elements["e[0][empr_xdv]"].value;

	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido.');
		document.edicion2.elements["e[0][empr_xdv"].objeto.select();
		return false;
	}

	return true;
}
function ValidaRut33()
{
	rut = document.edicion2.elements["o[0][empr_nrut]"].value + '-' + document.edicion2.elements["o[0][empr_xdv]"].value;

	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido.');
		document.edicion2.elements["o[0][empr_xdv]"].objeto.select();
		return false;
	}

	return true;
}

function genera_digito (rut){
 var IgStringVerificador, IgN, IgSuma, IgDigito, IgDigitoVerificador, rut;
 var texto_rut = new String(rut);
 var posicion_guion = 0;

 posicion_guion = texto_rut.indexOf("-");
 if (posicion_guion != -1)
 {
    texto_rut = texto_rut.substring(0,posicion_guion);
    document.edicion2.elements["e[0][empr_nrut]"].value= texto_rut;
	rut = texto_rut;
 }
// texto_rut.
 //alert(texto_rut);
   if (rut.length==7) rut = '0' + rut;


   IgStringVerificador = '32765432';
   IgSuma = 0;
   for( IgN = 0; IgN < 8 && IgN < rut.length; IgN++)
      IgSuma = eval(IgSuma + '+' + rut.substr(IgN, 1) + '*' + IgStringVerificador.substr(IgN, 1) + ';');
   IgDigito = 11 - IgSuma % 11;
   IgDigitoVerificador = IgDigito==10?'K':IgDigito==11?'0':IgDigito;
   //alert(IgDigitoVerificador);
   document.edicion2.elements["e[0][empr_xdv]"].value=IgDigitoVerificador;
//alert(rut+IgDigitoVerificador);
_Buscar(this, document.forms['edicion2'],'', 'ValidaRut22();', 'FALSE');
}

function genera_digito2 (rut){
 var IgStringVerificador, IgN, IgSuma, IgDigito, IgDigitoVerificador, rut;
 var texto_rut = new String(rut);//rut de la otic
 var posicion_guion = 0;
 var otro_rut  = document.edicion2.elements["e[0][empr_nrut]"].value; //rut de la empresa
 if (otro_rut == rut)
	 {
	   alert("Imposible asignar un rut de Otic igual al de la empresa registrada para el postulante");
	   document.edicion2.elements["o[0][empr_nrut]"].value="";
	   document.edicion2.elements["o[0][empr_xdv]"].value="";
	 }
 else
	 {
		 posicion_guion = texto_rut.indexOf("-");
		 if (posicion_guion != -1)
		 {
			texto_rut = texto_rut.substring(0,posicion_guion);
			document.edicion2.elements["o[0][empr_nrut]"].value= texto_rut;
			rut = texto_rut;
		 }
		// texto_rut.
		 //alert(texto_rut);
		   if (rut.length==7) rut = '0' + rut;


		   IgStringVerificador = '32765432';
		   IgSuma = 0;
		   for( IgN = 0; IgN < 8 && IgN < rut.length; IgN++)
			  IgSuma = eval(IgSuma + '+' + rut.substr(IgN, 1) + '*' + IgStringVerificador.substr(IgN, 1) + ';');
		   IgDigito = 11 - IgSuma % 11;
		   IgDigitoVerificador = IgDigito==10?'K':IgDigito==11?'0':IgDigito;
		   //alert(IgDigitoVerificador);
		   document.edicion2.elements["o[0][empr_xdv]"].value=IgDigitoVerificador;
		//alert(rut+IgDigitoVerificador);
		_Buscar(this, document.forms['edicion2'],'', 'ValidaRut33();', 'FALSE');
	 }
}
/*function calcula_total(valor)
{
	var matricula = document.edicion2.elements["matricula"].value;
	var arancel = document.edicion2.elements["arancel"].value;
	var total = (matricula + arancel) * valor;
	var codigo    = document.edicion2.elements["seleccionado"].value;
	arreglo = codigo.split("*");
	tdet_ccod = arreglo[0];
	descuento = arreglo[1] / 100;
	if (descuento == 0)
	{
		descuento=1;
	}
	else
	{
		total = total - (total * descuento);
	}
	document.edicion2.elements["monto_calculado"].value=total;
}*/

function evaluar_reparticion()
{
	matricula = document.edicion2.elements["matricula"].value;
	arancel = document.edicion2.elements["arancel"].value;
	valor = document.edicion2.elements["o[0][ocot_nalumnos]"].value;
	total = ((matricula*1) + (arancel*1)) * (valor*1);
	tipo_pago = '<%=fpot_ccod%>';
	var codigo    = document.edicion2.elements["seleccionado"].value;
	arreglo = codigo.split("*");
	tdet_ccod = arreglo[0];
	descuento = arreglo[1] / 100;
	if (descuento == 0)
	{
		descuento=1;
		total = 0;
	}
	else
	{
		total = total * descuento;
	}

	document.edicion2.elements["o[0][monto_descuento_estimado]"].value = total;
	document.edicion2.elements["o[0][monto_descuento_editado]"].value = total;

	empresa = document.edicion2.elements["o[0][ocot_monto_empresa]"].value;
	if (tipo_pago=='4')
		{otic = document.edicion2.elements["o[0][ocot_monto_otic]"].value;}
	else
		{otic = 0;}

	total2 = (empresa * 1) + (otic * 1);
	document.edicion2.elements["monto_calculado"].value=total2;
}


function configurar_orden_compra(){

formulario=document.forms['edicion2'];
valor=0;
v_cambio_anio	=	'<%=v_cambio_anio%>';
forma_pago 		= 	'<%=fpot_ccod%>';
v_otic 			= 	'<%=tipo%>';
v_nro_accion	=	formulario.elements["o[0][ocot_NRO_REGISTRO_SENCE]"].value;
v_nro_alumnos	=	formulario.elements["o[0][ocot_nalumnos]"].value;
v_monto_empresa	=	formulario.elements["o[0][ocot_monto_empresa]"].value;

v_monto_a=0;
v_monto_b=0;
v_monto_c=0;
v_monto_d=0;

//alert(v_otic);

//alert(forma_pago);alert(v_nro_accion);alert(v_nro_alumnos);alert(v_monto_empresa);
 if (v_otic==2){
	 v_monto_otic	=formulario.elements["o[0][ocot_monto_otic]"].value;
	 if ((!v_monto_otic)||(v_monto_otic==0)){
		alert("Debe ingresar los datos generales de la Orden de Compra");
		return false;
	 }
 }

 //if ((!v_nro_accion)||(!v_nro_alumnos)||(!v_monto_empresa)){
if (forma_pago=='2'){
	if ((!v_nro_alumnos)||(!v_monto_empresa)||(v_nro_alumnos==0)||(v_monto_empresa==0)){
		alert("Debe ingresar los datos generales de la Orden de Compra");
		return false;
	}
}else{
	if ((!v_nro_alumnos)||(!v_monto_empresa)||(!v_nro_accion)||(v_nro_alumnos==0)||(v_monto_empresa==0)||(v_nro_accion==0)){
		alert("Debe ingresar los datos generales de la Orden de Compra");
		return false;
	}
}

 if(v_cambio_anio==1) {

  //Si es solo empresa y los valores traen datos, validar los montos complementarios
	if (forma_pago=='3'){
		v_monto_a	=	parseInt(formulario.elements["do[0][dorc_mmonto]"].value);
		v_monto_b	=	parseInt(formulario.elements["do[1][dorc_mmonto]"].value);
		v_monto_total=v_monto_a+v_monto_b;
		if (v_monto_total!=v_monto_empresa){
			alert("La suma de los montos "+v_monto_total+" complementarios deben se igual al monto total Empresa \nMonto Empresa: "+v_monto_empresa+" ");
			return false;
		}

	}

	// SI ES EMPRESA CON OTIC
	if (forma_pago=='4'){
		v_monto_a	=	parseInt(formulario.elements["do[0][dorc_mmonto]"].value);
		v_monto_b	=	parseInt(formulario.elements["do[1][dorc_mmonto]"].value);
		v_monto_total=v_monto_a+v_monto_b;
		if (v_monto_total!=v_monto_empresa){
			alert("La suma de los montos "+v_monto_total+" complementarios deben se igual al monto total Empresa \nMonto Empresa: "+v_monto_empresa+" ");
			return false;
		}

		v_monto_c	=	parseInt(formulario.elements["do[2][dorc_mmonto]"].value);
		v_monto_d	=	parseInt(formulario.elements["do[3][dorc_mmonto]"].value);
		v_monto_total=eval(v_monto_c + v_monto_d);

		if (v_monto_total!=v_monto_otic){
			alert("La suma de los montos "+ v_monto_total +"complementarios deben se igual al monto total Otic \nMonto Otic: "+v_monto_otic+" ");
			return false;
		}

	}

  //SI ES PERSONA NATURAL + EMPRESA
	if (forma_pago=='5'){
		v_monto_a	=	parseInt(formulario.elements["do[0][dorc_mmonto]"].value);
		v_monto_b	=	parseInt(formulario.elements["do[1][dorc_mmonto]"].value);
		v_monto_total=v_monto_a+v_monto_b;
		if (v_monto_total!=v_monto_empresa){
			alert("La suma de los montos "+v_monto_total+" complementarios deben se igual al monto total Empresa \nMonto Empresa: "+v_monto_empresa+" ");
			return false;
		}

	}
 }

//CUANDO NO CAMBIAN DE AÑO
 if(v_cambio_anio==0) {


    // Empresa con Sence
	if (forma_pago=='3'){
		v_monto_a	=	parseInt(formulario.elements["do[0][dorc_mmonto]"].value);

		if (v_monto_a!=v_monto_empresa){
			alert("El monto parcial ingresado "+v_monto_a+" para la Empresa, debe se igual al monto total Empresa \nMonto Empresa: "+v_monto_empresa+" ");
			return false;
		}

	}

	// SI ES EMPRESA CON OTIC
	if (forma_pago=='4'){
		v_monto_a	=	parseInt(formulario.elements["do[0][dorc_mmonto]"].value); // EMPRESA
		if (v_monto_a!=v_monto_empresa){
			alert("El monto parcial ingresado "+v_monto_a+" para la Empresa, debe se igual al monto total Empresa \nMonto Empresa: "+v_monto_empresa+" ");
			return false;
		}

		v_monto_c	=	parseInt(formulario.elements["do[2][dorc_mmonto]"].value); // OTIC
		if (v_monto_c!=v_monto_otic){
			alert("El monto parcial ingresado "+v_monto_c+" para la Otic, debe se igual al monto total Otic \nMonto Otic: "+v_monto_otic+" ");
			return false;
		}

	}

    //SI ES PERSONA NATURAL + EMPRESA
	if (forma_pago=='5'){
		v_monto_a	=	parseInt(formulario.elements["do[0][dorc_mmonto]"].value);
		if (v_monto_a!=v_monto_empresa){
			alert("El monto parcial ingresado "+v_monto_a+" para la Empresa, debe se igual al monto total Empresa \nMonto Empresa: "+v_monto_empresa+" ");
			return false;
		}
	}
 } // FIN SIN CAMBIO DE AÑO

if (forma_pago=='2'){
	total_detalle=document.edicion2.elements["monto_calculado"].value;
}else{
	total_detalle=parseInt(v_monto_a)+parseInt(v_monto_b)+parseInt(v_monto_c)+parseInt(v_monto_d);
}
total_calculado=document.edicion2.elements["monto_calculado"].value;

//alert("total_detalle: "+total_detalle);
//alert("total_calculado: "+total_calculado);


if (total_detalle!=total_calculado){
	alert("No coinciden los montos detallados en las ordenes de compra");
	return false;
}else{
	_Guardar(this, document.forms['edicion2'], 'guardar_orden_masiva.asp','','', '', 'FALSE');
}

}


/*function configurar_orden_compra()
{
	  var monto_calculado = document.edicion2.elements["monto_calculado"].value;
	  if ((monto_calculado*1) > 0 )
	  {
	    //alert("llegue acá");
	    _Guardar(this, document.forms['edicion2'], 'guardar_orden_masiva.asp','','', '', 'FALSE');
	  }
	  else
	  {
	  	alert("Antes de grabar los datos en la orden de compra, debe ingresar la información requerida");
	  }

}*/

function configurar_orden_compra2(valor_lista)
{
	document.edicion2.elements["seleccionado"].value = valor_lista;
	matricula = document.edicion2.elements["matricula"].value;
	arancel = document.edicion2.elements["arancel"].value;
	valor = document.edicion2.elements["o[0][ocot_nalumnos]"].value;
	tipo_pago = '<%=fpot_ccod%>';
	total = ((matricula*1) + (arancel*1)) * (valor*1);
	//alert(valor_lista);
	codigo = valor_lista;
	arreglo = codigo.split("*");
	tdet_ccod = arreglo[0];
	descuento = arreglo[1] / 100;
	if (descuento == 0)
	{
		descuento=1;
		total = 0;
	}
	else
	{
		total = (total * descuento);
	}

	document.edicion2.elements["o[0][monto_descuento_estimado]"].value=total;
	document.edicion2.elements["o[0][monto_descuento_editado]"].value=total;
}

function configurar_orden_compra_num()
{
	valor_lista = document.edicion2.elements["seleccionado"].value;
	matricula = document.edicion2.elements["matricula"].value;
	arancel = document.edicion2.elements["arancel"].value;
	valor = document.edicion2.elements["o[0][ocot_nalumnos]"].value;
	tipo_pago = '<%=fpot_ccod%>';
	total = ((matricula*1) + (arancel*1)) * (valor*1);
	//alert(valor_lista);
	codigo = valor_lista;
	arreglo = codigo.split("*");
	tdet_ccod = arreglo[0];
	descuento = arreglo[1] / 100;
	if (descuento == 0)
	{
		descuento=1;
		total = 0;
	}
	else
	{
		total = (total * descuento);
	}

	document.edicion2.elements["o[0][monto_descuento_estimado]"].value=total;
	document.edicion2.elements["o[0][monto_descuento_editado]"].value=total;
}

function agregar_postulantes()
{
	var dgso_ncorr = '<%=dgso_ncorr%>';
	var fpot_ccod = '<%=fpot_ccod%>';
	var rut_empresa = '<%=e_empr_nrut%>';
	var rut_otic = '<%=o_empr_nrut%>';
	var nord_compra = '<%=nord_compra%>';
	direccion = "agrega_postulantes_masivos.asp?dgso_ncorr="+dgso_ncorr+"&fpot_ccod="+fpot_ccod+"&nord_compra="+nord_compra+"&rut_empresa="+rut_empresa+"&rut_otic="+rut_otic;
	resultado = window.open(direccion, "ventana2","width=600, height=550, scrollbars=yes, left=380, top=100");
}

function verifica_fpote()
{

}
</script>
<% f_busqueda.generaJS %>
</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="580" height="100%">
<tr valign="top" height="30">
	<td bgcolor="#EAEAEA">
</td>
</tr>
<tr valign="top">
	<td bgcolor="#EAEAEA">
<table width="652" border="0" align="left" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA" align="center">
	<table width="90%">
	<tr>
		<td align="center">

	<table width="50%"  border="0" align="left" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td align="left"><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                    <td width="20%"><strong>Año</strong></td>
					<td width="3%"><strong>:</strong></td>
                    <td><%f_busqueda.dibujaCampoLista "lBusqueda", "anio_admision" %></td>
                  </tr>
				  <tr>
                    <td width="20%"><strong>Sede</strong></td>
					<td width="3%"><strong>:</strong></td>
                    <td><%f_busqueda.dibujaCampoLista "lBusqueda", "sede_ccod" %></td>
                 </tr>
				<tr>
                    <td width="20%"><strong>Módulo</strong></td>
					<td width="3%"><strong>:</strong></td>
                    <td><%f_busqueda.dibujaCampoLista "lBusqueda", "dcur_ncorr"%></td>
                 </tr>

                 <tr>
                          <td colspan="3" align="left">
                            <table width="90%" border="0">
                              <tr>
                                <td width="100%">
                                  <table width="100%" border="0">
								  <%if cdbl(existe_postulante)=0 then%>
                                    <tr>
                                      <td colspan="4" align="left"><strong>Método de pago la postulanción:</strong></td>
                                    </tr>

                                    <tr>
                                      <td width="33%" align="center">Empresa sin SENCE</td>
                                      <td width="34%" align="center">Empresa con SENCE</td>
                                      <td width="33%" align="center">Empresa con OTIC</td>
                                    </tr>

                                    <tr>
                                      <td width="33%" align="center">
                                        <%if fpot_ccod = "2" then %>
                                        <input type="radio" name="b[0][fpot_ccod]" value="2" checked >
                                        <%else%>
                                        <input type="radio" name="b[0][fpot_ccod]" value="2" >
                                        <%end if%>                                      </td>
                                      <td width="25%" align="center">
                                        <%if fpot_ccod = "3" then %>
                                        <input type="radio" name="b[0][fpot_ccod]" value="3" checked >
                                        <%else%>
                                        <input type="radio" name="b[0][fpot_ccod]" value="3" >
                                        <%end if%>                                      </td>
                                      <td width="25%" align="center">
                                        <%if fpot_ccod = "4" then %>
                                        <input type="radio" name="b[0][fpot_ccod]" value="4" checked >
                                        <%else%>
                                        <input type="radio" name="b[0][fpot_ccod]" value="4" >
                                        <%end if%>                                      </td>
                                    </tr>
									<%end if%>
                                </table></td>
                              </tr>
                          </table></td>
                 </tr>
                 <tr>
                 	<td colspan="3" align="left">
                      <table width="100%" cellpadding="0" cellspacing="0">
                      	<tr>
                        	<td width="20%" align="left"><strong>N° Orden de Compra</strong></td>
                            <td width="3%" align="center"><strong>:</strong></td>
                            <td width="50%" align="left"><%f_busqueda.dibujaCampo "nord_compra" %></td>
                            <td width="27%" align="left"><%botonera.dibujaboton "buscar"%></td>
                        </tr>
                      </table>
                    </td>
                 </tr>

				 <tr>
				  <td colspan="3"><input type="hidden" name="detalle" value=""></td>
                </tr>
              </table>
            </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	</td>
	</tr>
	</table>
	</td></tr>

	<%if nord_compra <> "" then %>




	<tr>
    <td valign="top" bgcolor="#EAEAEA" align="left">&nbsp;</td></tr>
	<tr>
    <td valign="top" bgcolor="#EAEAEA" align="left">
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Ingreso información orden de compra"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
                <table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>                        <div align="center"><%pagina.DibujarTituloPagina%> <br>
                    </div></td>
                    </tr>

                  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <%if dcur_tdesc <> "" and nord_compra <> "" then %>


				  <tr>
                    <td><%response.Write("PROGRAMA: <strong>"&dcur_tdesc&"</strong>")
						%></td>
                  </tr>
				  <tr>
                    <td><%response.Write("SEDE: <strong>"&sede_tdesc&"</strong>")
						%></td>
                  </tr>
				  <tr>
                    <td><%response.Write("CÓDIGO SENCE: <strong>"&dcur_nsence&"</strong>")
						%></td>
                  </tr>
				  <tr>
				  	<td><%=periodo_programa%>
					</td>
				  </tr>
                  <tr>
                    <td><%if fpot_ccod = "2" then
					         tpot_tdesc = "Empresa sin Sence"
						  elseif fpot_ccod = "3" then
					         tpot_tdesc = "Empresa con Sence"
						  elseif fpot_ccod = "4" then
					         tpot_tdesc = "Empresa con Otic"
						  end if
					      response.Write("FORMA DE PAGO: <font color='#990000'><strong>"&tpot_tdesc&"</strong></font>")%></td>
                  </tr>
                  <tr>
                    <td><%response.Write("ORDEN DE COMPRA: <font color='#990000'><strong>"&nord_compra&"</strong></font>")%></td>
                  </tr>
				  <tr>
					  <td>&nbsp;</td>
				  </tr>
				  <%end if%>
				  <tr>
                    <td>
                    	<table width="100%" cellpadding="0" cellspacing="0" align="left">
                    		<form name="edicion2">
                                <input type="hidden" name="b[0][dcur_ncorr]" value="<%=dcur_ncorr%>">
                                <input type="hidden" name="b[0][sede_ccod]" value="<%=sede_ccod%>">
                                <input type="hidden" name="b[0][nord_compra]" value="<%=nord_compra%>">
                                <tr>
                                  <td colspan="6">&nbsp;</td>
                                </tr>
                                <tr>
                                  <td colspan="6" align="center" bgcolor="#999999"><font size="+2" face="Times New Roman, Times, serif" color="#FFFFFF"><strong>PASO 1</strong></font></td>
                                </tr>
                                <%if (fpot_ccod="2" or fpot_ccod="3" or fpot_ccod="4") and nord_compra <> "" then%>
                                <tr>
                                  <td colspan="6" align="left"><strong>------DATOS EMPRESA------</strong></td>
                                </tr>
                                <tr>
                                  <input type="hidden" name="b[0][fpot_ccod]" value="<%=fpot_ccod%>">
                                  <td width="10%"><strong>Rut</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_empresa.dibujaCampo("empr_nrut")%>
                                    -
                                      <%datos_empresa.dibujaCampo("empr_xdv")%></td>
                                  <td width="10%" align="right"><strong>Razón Social</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_empresa.dibujaCampo("empr_trazon_social")%>
                                      <%datos_empresa.dibujaCampo("pote_ncorr")%></td>
                                </tr>
                                <tr>
                                  <td width="10%"><strong>Dirección</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_empresa.dibujaCampo("empr_tdireccion")%></td>
                                  <td width="10%" align="right"><strong>Comuna</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_empresa.dibujaCampo("ciud_ccod")%></td>
                                </tr>
                                <tr>
                                  <td width="10%"><strong>Teléfono</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_empresa.dibujaCampo("empr_tfono")%></td>
                                  <td width="10%" align="right"><strong>Fax</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_empresa.dibujaCampo("empr_tfax")%></td>
                                </tr>
                                <tr>
                                  <td width="10%"><strong>Giro</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_empresa.dibujaCampo("empr_tgiro")%></td>
                                  <td width="10%" align="right"><strong>Nombre Ejecutivo</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_empresa.dibujaCampo("empr_tejecutivo")%></td>
                                </tr>
                                <tr>
                                  <td width="10%"><strong>E-mail Ejecutivo</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td colspan="4"><%datos_empresa.dibujaCampo("empr_temail_ejecutivo")%></td>
                                </tr>
                                <tr>
                                  <td colspan="6" align="left">
                                    <table width="100%" cellpadding="0" cellspacing="0" id="bt_empresa" style="visibility:visible">
                                      <tr>
                                        <td align="right"><%f_botonera.dibujaBoton "guardar_empresas"%></td>
                                      </tr>
                                  </table></td>
                                </tr>
                                <%end if%>
                                <%'response.Write("--------**********--------- "&tiene_empresa)
                                  if habilita_otic = "SI" then%>
                                <tr>
                                  <td colspan="6" align="left"><strong>------DATOS OTIC------</strong></td>
                                </tr>
                                <tr>
                                  <td width="10%"><strong>Rut</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_otic.dibujaCampo("empr_nrut")%>
                                    -
                                      <%datos_otic.dibujaCampo("empr_xdv")%></td>
                                  <td width="10%" align="right"><strong>Razón Social</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_otic.dibujaCampo("empr_trazon_social")%></td>
                                </tr>
                                <tr>
                                  <td width="10%"><strong>Dirección</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_otic.dibujaCampo("empr_tdireccion")%></td>
                                  <td width="10%" align="right"><strong>Comuna</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_otic.dibujaCampo("ciud_ccod")%></td>
                                </tr>
                                <tr>
                                  <td width="10%"><strong>Teléfono</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_otic.dibujaCampo("empr_tfono")%></td>
                                  <td width="10%" align="right"><strong>Fax</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_otic.dibujaCampo("empr_tfax")%></td>
                                </tr>
                                <tr>
                                  <td width="10%"><strong>Giro</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_otic.dibujaCampo("empr_tgiro")%></td>
                                  <td width="10%" align="right"><strong>Nombre Ejecutivo</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_otic.dibujaCampo("empr_tejecutivo")%></td>
                                </tr>
                                <tr>
                                  <td width="10%"><strong>E-mail Ejecutivo</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td colspan="4"><%datos_otic.dibujaCampo("empr_temail_ejecutivo")%></td>
                                </tr>
                                <tr>
                                  <td colspan="6" align="left">
                                    <table width="100%" cellpadding="0" cellspacing="0" id="bt_otic" style="visibility:visible">
                                      <tr>
                                        <td align="right"><%f_botonera.dibujaBoton "guardar_otic"%></td>
                                      </tr>
                                  </table></td>
                                </tr>
                                <%end if%>
                                <%if habilita_orden = "SI" then%>

                                <tr>
                                  <td colspan="6">&nbsp;</td>
                                </tr>
                                <tr>
                                  <td colspan="6" align="center"><table width="98%" border="1">
                                      <tr>
                                        <td align="center">
                                                <table width="100%" cellpadding="0" cellspacing="0">
                                                  <tr>
                                                    <td colspan="6" align="center" bgcolor="#99CCFF"><strong>Datos generales Orden de Compra</strong></td>
                                                  </tr>
                                                  <tr>
                                                    <td width="7%" height="31" align="left"><strong>Matrícula</strong></td>
                                                    <td width="1%" align="left"><strong>:</strong></td>
                                                    <td width="42%" align="left">$<%=matricula%><input type="hidden" name="matricula" value="<%=matricula%>"></td>
                                                    <td width="7%" align="left"><strong>Arancel</strong></td>
                                                    <td width="1%" align="left"><strong>:</strong></td>
                                                    <td width="42%" align="left">$<%=arancel%><input type="hidden" name="arancel" value="<%=arancel%>"></td>
                                                  </tr>
												  <tr>
                                                <td width="7%" height="21" align="left"><strong>Descuento</strong></td>
                                                    <td width="1%" align="left"><strong>:</strong></td>
                                                    <td align="left"><%datos_finales.dibujaCampo("tdet_ccod")%><input type="hidden" name="seleccionado" value="<%=valor_descuento%>"></td>
                                                    <td width="7%" align="left"><strong>Monto estimado desc. </strong></td>
                                                    <td align="left"><strong>:</strong></td>
                                                    <td><input type="text" name="o[0][monto_descuento_editado]" value="<%=descuento_editado%>" size="10" maxlength="8"><input type="hidden" name="o[0][monto_descuento_estimado]" value="<%=descuento_estimado%>"></td>
                                               </tr>

                                                  <tr>
                                                  <td width="7%" height="21" align="left">&nbsp;</td>
                                                    <td width="1%" align="left"></td>
                                                    <td align="left" colspan="4">&nbsp;</td>
                                                  </tr>
                                                  <tr>
                                                    <td width="7%" align="left"><strong>N° de accion sence</strong></td>
                                                    <td width="1%" align="left"><strong>:</strong></td>
                                                    <td width="42%" align="left"><input type="text" name="o[0][ocot_NRO_REGISTRO_SENCE]" value="<%=ocot_NRO_REGISTRO_SENCE%>" size="25" maxlength="50" onChange="configurar_orden_compra_num();"></td>
                                                    <td width="7%" align="left"><strong>Total Alumnos</strong></td>
                                                    <td width="1%" align="left"><strong>:</strong></td>
                                                    <td width="42%" align="left"><input type="text" name="o[0][ocot_nalumnos]" value="<%=ocot_nalumnos%>" size="10" maxlength="3" onChange="configurar_orden_compra_num();"></td>
                                                  </tr>
                                                  <%if fpot_ccod = "4" then%>
                                                  <tr>
                                                    <td width="7%" align="left"><strong>Monto Empresa</strong></td>
                                                    <td width="1%" align="left"><strong>:</strong></td>
                                                    <td width="42%" align="left"><input type="text" name="o[0][ocot_monto_empresa]" value="<%=ocot_monto_empresa%>" size="10" maxlength="8" onChange="evaluar_reparticion();">$</td>
                                                    <td width="7%" align="left"><strong>Monto Otic</strong></td>
                                                    <td width="1%" align="left"><strong>:</strong></td>
                                                    <td width="42%" align="left"><input type="text" name="o[0][ocot_monto_otic]" value="<%=ocot_monto_otic%>" size="10" maxlength="8" onChange="evaluar_reparticion();">$</td>
                                                  </tr>
                                                  <%else%>
                                                  <tr>
                                                    <td width="7%" align="left"><strong>Monto Empresa</strong></td>
                                                    <td width="1%" align="left"><strong>:</strong></td>
                                                    <td width="42%" align="left" colspan="4"><input type="text" name="o[0][ocot_monto_empresa]" value="<%=ocot_monto_empresa%>" size="10" maxlength="8" onChange="evaluar_reparticion();">$</td>
                                                  </tr>
                                                  <%end if%>

                                                  <!-- DETALLE DE ORDENES DE COMPRA -->
												<%formulario.dibujaCampo("orco_ncorr")%>
                                                <%formulario.dibujaCampo("dgso_ncorr")%>
                                                <%formulario.dibujaCampo("empr_ncorr")%>
                                                <%formulario.dibujaCampo("nord_compra")%>
                                                <%formulario.dibujaCampo("empr_ncorr_2")%>
                                                <%formulario.dibujaCampo("fpot_ccod")%>
                                                <input type="hidden" name="tipo" value="<%=tipo%>">
                                                <% if v_cambio_anio=1 and (fpot_ccod="3" or  fpot_ccod="4" or  fpot_ccod="5") then %>
                                                  <tr>
                                                      <td colspan="6">
                                                            <br>
                                                            <center><font color="#0000FF" size="2">Detalle de pagos complementarios</font></center>
                                                            <br>
                                                            <input type="hidden" name="do[0][empr_ncorr]" value="<%=empr_ncorr%>">
                                                            <input type="hidden" name="do[1][empr_ncorr]" value="<%=empr_ncorr%>">
                                                            <input type="hidden" name="do[0][anos_ccod]" value="<%=v_anio_inicio%>">
                                                            <input type="hidden" name="do[1][anos_ccod]" value="<%=v_anio_fin%>">
                                                            <input type="hidden" name="do[0][tins_ccod]" value="1">
                                                            <input type="hidden" name="do[1][tins_ccod]" value="1">
                                                            <input type="hidden" name="do[0][dorc_nindice]" value="0">
                                                            <input type="hidden" name="do[1][dorc_nindice]" value="1">
                                                                <table width="100%">
                                                                <tr>
                                                                  <td colspan="3" align="center" bgcolor="#99CCFF"><strong>EMPRESA</strong></td></tr>
                                                                  <tr><td></td><th align="left"><%=v_anio_inicio%></th><th align="left"><%=v_anio_fin%></th></tr>
                                                                <tr>
                                                                    <th align="left">Fecha Inicio</th>
                                                                    <td><input type="text" name="do[0][dorc_finicio]" value="<%=v_fecha_inicio_a%>" size="12" id="FE-N"/></td>
                                                                    <td><input type="text" name="do[1][dorc_finicio]" value="<%=v_fecha_inicio_b%>" size="12" id="FE-N"/></td>
                                                                </tr>
                                                                <tr>
                                                                    <th align="left">Fecha Corte</th>
                                                                    <td><input type="text" name="do[0][dorc_ffin]" value="<%=v_fecha_corte_a%>" size="12" id="FE-N"/></td>
                                                                    <td><input type="text" name="do[1][dorc_ffin]" value="<%=v_fecha_corte_b%>" size="12" id="FE-N"/></td>
                                                                </tr>
                                                                <tr>
                                                                    <th align="left">Monto</th>
                                                                    <td><input type="text" name="do[0][dorc_mmonto]" value="<%=v_monto_a%>" size="10" id="NU-N"/></td>
                                                                    <td><input type="text" name="do[1][dorc_mmonto]" value="<%=v_monto_b%>" size="10" id="NU-N"/></td>
                                                                </tr>
                                                                <tr>
                                                                    <th align="left">N° Horas</th>
                                                                    <td><input type="text" name="do[0][dorc_nhoras]" value="<%=v_num_horas_a%>" size="10" maxlength="3" id="NU-N"/></td>
                                                                    <td><input type="text" name="do[1][dorc_nhoras]" value="<%=v_num_horas_b%>" size="10" maxlength="3" id="NU-N"/></td>
                                                                </tr>
                                                                <tr>
                                                                    <th align="left">Reg. Accion Sence</th>
                                                                    <td><input type="text" name="do[0][dorc_naccion_sence]" value="<%=v_num_accion_a%>" size="10" maxlength="7" id="NU-N"/></td>
                                                                    <td><input type="text" name="do[1][dorc_naccion_sence]" value="<%=v_num_accion_b%>" size="10" maxlength="7" id="NU-N"/></td>
                                                                </tr>
                                                                <tr>
                                                                    <th align="left">N° Orden Compra</th>
                                                                    <td><input type="text" name="do[0][dorc_num_oc]" value="<%=v_num_oc_a%>" size="10" maxlength="10" id="NU-N"/></td>
                                                                    <td><input type="text" name="do[1][dorc_num_oc]" value="<%=v_num_oc_b%>" size="10" maxlength="10" id="NU-N"/></td>
                                                                </tr>
                                                                </table>
                                                                <br/>
                                                               <%if tipo = "2" then%>

                                                            <input type="hidden" name="do[2][empr_ncorr]" value="<%=empr_ncorr_2%>">
                                                            <input type="hidden" name="do[3][empr_ncorr]" value="<%=empr_ncorr_2%>">
                                                            <input type="hidden" name="do[2][anos_ccod]" value="<%=v_anio_inicio%>">
                                                            <input type="hidden" name="do[3][anos_ccod]" value="<%=v_anio_fin%>">
                                                            <input type="hidden" name="do[2][tins_ccod]" value="2">
                                                            <input type="hidden" name="do[3][tins_ccod]" value="2">
                                                            <input type="hidden" name="do[2][dorc_nindice]" value="2">
                                                            <input type="hidden" name="do[3][dorc_nindice]" value="3">

                                                               <table width="100%">
                                                                <tr><td colspan="3" align="center" bgcolor="#99CCFF"><strong>OTIC</strong></td></tr>
                                                                <tr><td></td><th align="left"><%=v_anio_inicio%></th><th align="left"><%=v_anio_fin%></th></tr>
                                                                <tr>
                                                                    <th align="left">Fecha Inicio</th>
                                                                    <td><input type="text" name="do[2][dorc_finicio]" value="<%=v_fecha_inicio_c%>" size="12" id="FE-N" /></td>
                                                                    <td><input type="text" name="do[3][dorc_finicio]" value="<%=v_fecha_inicio_d%>" size="12" id="FE-N" /></td>
                                                                </tr>
                                                                <tr>
                                                                    <th align="left">Fecha Corte</th>
                                                                    <td><input type="text" name="do[2][dorc_ffin]" value="<%=v_fecha_corte_c%>" size="12" id="FE-N" /></td>
                                                                    <td><input type="text" name="do[3][dorc_ffin]" value="<%=v_fecha_corte_d%>" size="12" id="FE-N" /></td>
                                                                </tr>
                                                                <tr>
                                                                    <th align="left">Monto</th>
                                                                    <td><input type="text" name="do[2][dorc_mmonto]" value="<%=v_monto_c%>" size="10" id="NU-N" /></td>
                                                                    <td><input type="text" name="do[3][dorc_mmonto]" value="<%=v_monto_d%>" size="10" id="NU-N" /></td>
                                                                </tr>
                                                                <tr>
                                                                    <th align="left">N° Horas</th>
                                                                    <td><input type="text" name="do[2][dorc_nhoras]" value="<%=v_num_horas_c%>" size="10" maxlength="3" id="NU-N" /></td>
                                                                    <td><input type="text" name="do[3][dorc_nhoras]" value="<%=v_num_horas_d%>" size="10" maxlength="3" id="NU-N" /></td>
                                                                </tr>
                                                                <tr>
                                                                    <th align="left">Reg. Accion Sence</th>
                                                                    <td><input type="text" name="do[2][dorc_naccion_sence]" value="<%=v_num_accion_c%>" size="10" maxlength="7" id="NU-N" /></td>
                                                                    <td><input type="text" name="do[3][dorc_naccion_sence]" value="<%=v_num_accion_d%>" size="10" maxlength="7" id="NU-N" /></td>
                                                                </tr>
                                                                <tr>
                                                                    <th align="left">N° Orden Compra</th>
                                                                    <td><input type="text" name="do[2][dorc_num_oc]" value="<%=v_num_oc_c%>" size="10" maxlength="10" id="NU-N" /></td>
                                                                    <td><input type="text" name="do[3][dorc_num_oc]" value="<%=v_num_oc_d%>" size="10" maxlength="10" id="NU-N" /></td>
                                                                </tr>
                                                                </table>
                                                                <br/>

                                                            <%end if%>
                                                            </td>
                                                        </tr>
                                                       <%end if%>

                                                        <% if v_cambio_anio=0 and (fpot_ccod="3" or  fpot_ccod="4" or  fpot_ccod="5") then %>
                                                        <tr>
                                                            <td colspan="6">
                                                            <br>
                                                            <center><font color="#0000FF" size="2">Detalle de pagos complementarios</font></center>
                                                            <br>
                                                            <input type="hidden" name="do[0][empr_ncorr]" value="<%=empr_ncorr%>">
                                                            <input type="hidden" name="do[0][anos_ccod]" value="<%=v_anio_inicio%>">
                                                            <input type="hidden" name="do[0][tins_ccod]" value="1">
                                                            <input type="hidden" name="do[0][dorc_nindice]" value="0">

                                                                <table width="100%">
                                                                <tr>
                                                                  <td colspan="3" align="center" bgcolor="#99CCFF"><strong>EMPRESA</strong></td></tr>
                                                                  <tr><td></td><th align="left"><%=v_anio_inicio%></th><th>&nbsp;</th></tr>
                                                                <tr>
                                                                    <th align="left">Fecha Inicio</th>
                                                                    <td><input type="text" name="do[0][dorc_finicio]" value="<%=v_fecha_inicio_a%>" size="12" id="FE-N"/></td>
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                                <tr>
                                                                    <th align="left">Fecha Corte</th>
                                                                    <td><input type="text" name="do[0][dorc_ffin]" value="<%=v_fecha_corte_a%>" size="12" id="FE-N"/></td>
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                                <tr>
                                                                    <th align="left">Monto</th>
                                                                    <td><input type="text" name="do[0][dorc_mmonto]" value="<%=v_monto_a%>" size="10" id="NU-N"/></td>
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                                <tr>
                                                                    <th align="left">N° Horas</th>
                                                                    <td><input type="text" name="do[0][dorc_nhoras]" value="<%=v_num_horas_a%>" size="10" maxlength="3" id="NU-N"/></td>
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                                <tr>
                                                                    <th align="left">Reg. Accion Sence</th>
                                                                    <td><input type="text" name="do[0][dorc_naccion_sence]" value="<%=v_num_accion_a%>" size="10" maxlength="7" id="NU-N"/></td>
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                                <tr>
                                                                    <th align="left">N° Orden Compra</th>
                                                                    <td><input type="text" name="do[0][dorc_num_oc]" value="<%=v_num_oc_a%>" size="10" maxlength="10" id="NU-N"/></td>
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                                </table>
                                                                <br/>
                                                               <%if tipo = "2" then%>

                                                            <input type="hidden" name="do[2][empr_ncorr]" value="<%=empr_ncorr_2%>">
                                                            <input type="hidden" name="do[2][anos_ccod]" value="<%=v_anio_inicio%>">
                                                            <input type="hidden" name="do[2][tins_ccod]" value="2">
                                                            <input type="hidden" name="do[2][dorc_nindice]" value="2">

                                                               <table width="100%">
                                                                <tr><td colspan="3" align="center" bgcolor="#99CCFF"><strong>OTIC</strong></td></tr>
                                                                <tr><td></td><th align="left"><%=v_anio_inicio%></th><th>&nbsp;</th></tr>
                                                                <tr>
                                                                    <th align="left">Fecha Inicio</th>
                                                                    <td><input type="text" name="do[2][dorc_finicio]" value="<%=v_fecha_inicio_c%>" size="12" id="FE-N" /></td>
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                                <tr>
                                                                    <th align="left">Fecha Corte</th>
                                                                    <td><input type="text" name="do[2][dorc_ffin]" value="<%=v_fecha_corte_c%>" size="12" id="FE-N" /></td>
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                                <tr>
                                                                    <th align="left">Monto</th>
                                                                    <td><input type="text" name="do[2][dorc_mmonto]" value="<%=v_monto_c%>" size="10" id="NU-N" /></td>
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                                <tr>
                                                                    <th align="left">N° Horas</th>
                                                                    <td><input type="text" name="do[2][dorc_nhoras]" value="<%=v_num_horas_c%>" size="10" maxlength="3" id="NU-N" /></td>
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                                <tr>
                                                                    <th align="left">Reg. Accion Sence</th>
                                                                    <td><input type="text" name="do[2][dorc_naccion_sence]" value="<%=v_num_accion_c%>" size="10" maxlength="7" id="NU-N" /></td>
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                                <tr>
                                                                    <th align="left">N° Orden Compra</th>
                                                                    <td><input type="text" name="do[2][dorc_num_oc]" value="<%=v_num_oc_c%>" size="10" maxlength="10" id="NU-N" /></td>
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                              </table>
                                                                <br/>
                                                            <%end if%>
                                                      </td>
                                                  </tr>
                                                   <%end if%>
													 <!-- FIN DETALLE ORDENES DE COMPRA -->
                                                  <tr>
                                                    <td width="7%" align="left"><strong>Monto calculado</strong></td>
                                                    <td width="1%" align="left"><strong>:</strong></td>
                                                    <td width="42%" align="left"><input type="text" name="monto_calculado" value="<%=valor_calcula2%>" size="8" style="background:#d8d8de; border:none; color:#0000CC;"></td>
                                                    <td width="7%" align="left"><strong>&nbsp;</strong></td>
                                                    <td width="1%" align="left"><strong>&nbsp;</strong></td>
                                                    <td width="42%" align="left"><input type="text" name="resultado" value="" size="30" style="background:#d8d8de; border:none; color:#990000">
                                                    <input type="hidden" name="o[0][tdet_ccod]" value=""></td>
                                                  </tr>
                                                  <tr>
                                                    <td colspan="6" align="right">&nbsp;</td>
                                                  </tr>
												  <tr>
                                                    <td colspan="6" align="Center" bgcolor="#CCCCCC"><font color="#990000" face="Courier New, Courier, mono" size="2">Se han quitado las validaciones de los totalizadores, cualquier diferencia en el total de la orden de compra es de exclusiva responsabilidad de quien la registra.</font></td>
                                                  </tr>
                                                  <tr>
                                                    <td colspan="6" align="right"><%f_botonera.dibujaBoton "configurar_orden_compra"%></td>
                                                  </tr>
                                                </table>
                                        </td>
                                      </tr>
                                  </table></td>
                                </tr>


									<%if habilitado_ingreso_alumnos then%>




                                        <tr>
                                          <td colspan="6">&nbsp;</td>
                                        </tr>
                                        <tr>
                                          <td colspan="6" align="center" bgcolor="#999999"><font size="+2" face="Times New Roman, Times, serif" color="#FFFFFF"><strong>PASO 2</strong></font></td>
                                       </tr>
                                       <tr>
                                          <td colspan="6" bgcolor="#999999" align="center"><%f_botonera.dibujaBoton "agregar_alumnos"%></td>
                                        </tr>
                                        <tr>
                                          <td colspan="6" bgcolor="#999999" align="center">&nbsp;</td>
                                        </tr>
                                    <%end if%>
                                <%end if%>
                              </form>
                        </table>
                    </td>
                  </tr>
                </table>
              <br>
                </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
	</td>
  </tr>
  <%end if 'de nord_compra %>
</table>
</td>
</tr>
</table>
</body>
</html>
