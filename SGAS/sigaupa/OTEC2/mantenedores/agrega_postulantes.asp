<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
DCUR_NCORR = session("dcur_ncorr_postulacion")
sede_ccod = session("sede_ccod_postulacion")
q_pers_nrut = Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")
e_empr_nrut = Request.QueryString("e[0][empr_nrut]")
e_empr_xdv = Request.QueryString("e[0][empr_xdv]")
o_empr_nrut = Request.QueryString("o[0][empr_nrut]")
o_empr_xdv = Request.QueryString("o[0][empr_xdv]")
'for each k in request.querystring
'	response.write(k&"="&request.querystring(k)&"<br>")
'next
'response.End()

'response.Write("e_empr_nrut "&e_empr_nrut)
session("url_actual")="../mantenedores/agrega_postulantes.asp?b[0][dcur_ncorr]="&dcur_ncorr&"&b[0][sede_ccod]="&sede_ccod&"&b[0][pers_nrut]="&q_pers_nrut&"&b[0][pers_xdv]="&q_pers_xdv
'response.Write("../mantenedores/m_modulos.asp?mote_tdesc="&mote_tdesc&"&mote_ccod="&mote_ccod)
set pagina = new CPagina
pagina.Titulo = "Ingreso de Postulación"

set botonera =  new CFormulario
botonera.carga_parametros "agrega_postulantes.xml", "botonera"
'response.End()
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores 	= new cErrores



'response.Write(carr_ccod)
dcur_tdesc = conexion.consultauno("SELECT dcur_tdesc FROM diplomados_cursos WHERE cast(dcur_ncorr as varchar)= '" & DCUR_NCORR & "'")
'----------------------------------------------------------------------- 
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "agrega_postulantes.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select '' "
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv


tiene_datos_generales = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")

dcur_tdesc = conexion.consultaUno("select dcur_tdesc from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")
sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede_ccod&"'")
dcur_nsence = conexion.consultaUno("select dcur_nsence from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")
dgso_ncorr = conexion.consultaUno("select dgso_ncorr from datos_generales_secciones_otec where cast(DCUR_NCORR as varchar)='"&DCUR_NCORR&"' and cast(sede_ccod as varchar)='"&sede_ccod&"' and esot_ccod in (1,2)")
periodo_programa = conexion.consultaUno("select 'FECHA INICIO : <strong>'+ protic.trunc(dgso_finicio) + '</strong>    FECHA TERMINO : <strong>' + protic.trunc(dgso_ftermino) + '</strong>' from datos_generales_secciones_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")

'response.Write("lalal "&dgso_ncorr)

'---------------------------------------------------------------------------------------------------
set datos_generales = new cformulario
datos_generales.carga_parametros "agrega_postulantes.xml", "datos_generales"
datos_generales.inicializar conexion


consulta= " select a.dgso_ncorr,a.dcur_ncorr,a.sede_ccod,protic.trunc(dgso_finicio) as dgso_finicio,protic.trunc(dgso_ftermino) as dgso_ftermino,dgso_ncupo,dgso_nquorum,ofot_nmatricula,ofot_narancel " & vbCrlf & _
		  " from datos_generales_secciones_otec a left outer join ofertas_otec  b" & vbCrlf & _
		  "  on a.dgso_ncorr = b.dgso_ncorr " & vbCrlf &_
		  " where cast(a.dcur_ncorr as varchar)='"&DCUR_NCORR&"'  " & vbCrlf & _
		  " and cast(a.sede_ccod as varchar)='"&sede_ccod&"' " 

if tiene_datos_generales = "N" then
	consulta = "select '' as dgso_ncorr"
end if
'response.write("<pre>"&consulta&"</pre>")
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
set datos_postulante = new cformulario
datos_postulante.carga_parametros "agrega_postulantes.xml", "datos_postulante"
datos_postulante.inicializar conexion


consulta= "  select a.pers_ncorr,cast(a.pers_nrut as varchar) + '-' + a.pers_xdv as codigo_rut,a.pers_nrut,a.pers_xdv,a.pers_tnombre,a.pers_tape_paterno,a.pers_tape_materno, " & vbCrlf & _
		  "  protic.trunc(pers_fnacimiento) as pers_fnacimiento, nied_ccod, " & vbCrlf & _
		  "  pers_tprofesion, b.dire_tcalle,b.dire_tnro,b.dire_tpoblacion,b.dire_tblock,b.ciud_ccod, " & vbCrlf & _
		  "  a.pers_tfono,a.pers_tcelular,a.pers_temail, isnull(utiliza_sence,0) as utiliza_sence, fpot_ccod, pers_tempresa,pers_tcargo  " & vbCrlf & _
		  "  from personas a join  direcciones b " & vbCrlf & _
		  "     on  a.pers_ncorr=b.pers_ncorr " & vbCrlf & _
		  "  left outer join postulacion_otec c " & vbCrlf & _
		  "     on a.pers_ncorr = c.pers_ncorr and '"&dgso_ncorr&"' = cast(c.dgso_ncorr as varchar) " & vbCrlf & _
		  "  where cast(pers_nrut as varchar)='"&q_pers_nrut&"' " & vbCrlf & _
		  "  and  b.tdir_ccod=1 and c.epot_ccod not in (4,5) "

fue_grabado = conexion.consultaUno("select count(*) from ("&consulta&")aa")
esta_en_personas = conexion.consultaUno("select count(*) from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")		  

if esta_en_personas ="0" and q_pers_nrut <> "" and fue_grabado="0" then
    'response.Write("entre acá")
	consulta = "select '"&q_pers_nrut&"' as pers_nrut,'"&q_pers_xdv&"' as pers_xdv, '"&q_pers_nrut&"' + '-' + '"&q_pers_xdv&"' as codigo_rut"
elseif esta_en_personas <> "0" and q_pers_nrut <> "" and fue_grabado="0" then
	consulta= "  select a.pers_ncorr,cast(a.pers_nrut as varchar) + '-' + a.pers_xdv as codigo_rut,a.pers_nrut,a.pers_xdv,a.pers_tnombre,a.pers_tape_paterno,a.pers_tape_materno, " & vbCrlf & _
			  "  protic.trunc(pers_fnacimiento) as pers_fnacimiento, " & vbCrlf & _
			  "  pers_tprofesion, b.dire_tcalle,b.dire_tnro,b.dire_tpoblacion,b.dire_tblock,b.ciud_ccod, " & vbCrlf & _
			  "  a.pers_tfono,a.pers_tcelular,a.pers_temail  " & vbCrlf & _
			  "  from personas a left outer join  direcciones b " & vbCrlf & _
			  "     on  a.pers_ncorr=b.pers_ncorr and 1 =  tdir_ccod " & vbCrlf & _
			  "  where cast(pers_nrut as varchar)='"&q_pers_nrut&"' " 

end if

'response.write("<pre>"&consulta&"</pre>")
datos_postulante.consultar consulta 
datos_postulante.siguiente




forma_pago = conexion.consultaUno("select fpot_ccod from postulacion_otec a, personas b where a.pers_ncorr=b.pers_ncorr and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
'response.Write(forma_pago)
if forma_pago= "" or esVacio(forma_pago)then
forma_pago="1"' toma por defecto que la forma de pago es persona natural al igual que los radio.
end if

tiene_postulacion = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from postulacion_otec a, personas b where a.pers_ncorr=b.pers_ncorr and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(pers_nrut as varchar)='"&q_pers_nrut&"' and a.epot_ccod not in (4,5)")

'---------------------------------------------------------------------------------------------------
set datos_empresa = new cformulario
datos_empresa.carga_parametros "agrega_postulantes.xml", "datos_empresa"
datos_empresa.inicializar conexion


consulta= "   select a.pote_ncorr,a.pers_ncorr,a.norc_empresa, " & vbCrlf & _ 
		  "   isnull(a.empr_ncorr_empresa, (select empr_ncorr from empresas where cast(empr_nrut as varchar)='"&e_empr_nrut&"')) as empr_ncorr, " & vbCrlf & _ 
		  "   isnull((select empr_trazon_social from empresas em where em.empr_ncorr=a.empr_ncorr_empresa),(select empr_trazon_social from empresas where cast(empr_nrut as varchar)='"&e_empr_nrut&"')) as empr_trazon_social, " & vbCrlf & _ 
   		  "   isnull((select empr_nrut from empresas em where em.empr_ncorr=a.empr_ncorr_empresa),(select empr_nrut from empresas where cast(empr_nrut as varchar)='"&e_empr_nrut&"')) as empr_nrut, " & vbCrlf & _ 
		  "   isnull((select empr_xdv from empresas em where em.empr_ncorr=a.empr_ncorr_empresa),(select empr_xdv from empresas where cast(empr_nrut as varchar)='"&e_empr_nrut&"')) as empr_xdv, " & vbCrlf & _ 
		  "   isnull((select empr_tdireccion from empresas em where em.empr_ncorr=a.empr_ncorr_empresa),(select empr_tdireccion from empresas where cast(empr_nrut as varchar)='"&e_empr_nrut&"')) as empr_tdireccion, " & vbCrlf & _ 
		  "   isnull((select ciud_ccod from empresas em where em.empr_ncorr=a.empr_ncorr_empresa),(select ciud_ccod from empresas where cast(empr_nrut as varchar)='"&e_empr_nrut&"')) as ciud_ccod, " & vbCrlf & _ 
		  "   isnull((select empr_tfono from empresas em where em.empr_ncorr=a.empr_ncorr_empresa),(select empr_tfono from empresas where cast(empr_nrut as varchar)='"&e_empr_nrut&"')) as empr_tfono, " & vbCrlf & _ 
		  "   isnull((select empr_tfax from empresas em where em.empr_ncorr=a.empr_ncorr_empresa),(select empr_tfax from empresas where cast(empr_nrut as varchar)='"&e_empr_nrut&"')) as empr_tfax, " & vbCrlf & _ 
		  "   isnull((select empr_tgiro from empresas em where em.empr_ncorr=a.empr_ncorr_empresa),(select empr_tgiro from empresas where cast(empr_nrut as varchar)='"&e_empr_nrut&"')) as empr_tgiro, " & vbCrlf & _ 
		  "   isnull((select empr_tejecutivo from empresas em where em.empr_ncorr=a.empr_ncorr_empresa),(select empr_tejecutivo from empresas where cast(empr_nrut as varchar)='"&e_empr_nrut&"')) as empr_tejecutivo, " & vbCrlf & _ 
		  "   isnull((select empr_temail_ejecutivo from empresas em where em.empr_ncorr=a.empr_ncorr_empresa),(select empr_temail_ejecutivo from empresas where cast(empr_nrut as varchar)='"&e_empr_nrut&"')) as empr_temail_ejecutivo " & vbCrlf & _ 
		  "   from postulacion_otec a, personas b " & vbCrlf & _ 
		  "   where  a.pers_ncorr=b.pers_ncorr " & vbCrlf & _ 
		  "   and cast(b.pers_nrut as varchar)='"&q_pers_nrut&"' " & vbCrlf & _
		  "   and cast(a.dgso_ncorr as varchar)='"&dgso_ncorr&"'  "
		  
		  
'response.write("<pre>"&consulta&"</pre>")
if tiene_postulacion = "N" then
	consulta = "select '' as pers_ncorr"
end if
'response.write("<pre>"&consulta&"</pre>")
datos_empresa.consultar consulta 
datos_empresa.siguiente
if e_empr_nrut <> "" and e_empr_xdv <> "" then
	datos_empresa.AgregaCampoCons "empr_nrut", e_empr_nrut
	datos_empresa.AgregaCampoCons "empr_xdv", e_empr_xdv
end if
'---------------------------------------------------------------------------------------------------
if forma_pago = "4" then '-------------en el caso de ser otic debemos ver si ya tiene ingresada la empresa antes de la otic
	tiene_empresa_1 = conexion.consultaUno("select isnull(empr_ncorr_empresa,0) from postulacion_otec a, personas b where a.pers_ncorr=b.pers_ncorr and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
'response.Write("select isnull(empr_ncorr_empresa,0) from postulacion_otec a, personas b where a.pers_ncorr=b.pers_ncorr and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
end if

if forma_pago="4" and tiene_empresa <> "0" then'--------si financia Otic y ya ingreso empresa buscamos datos otic
	set datos_otic = new cformulario
	datos_otic.carga_parametros "agrega_postulantes.xml", "datos_otic"
	datos_otic.inicializar conexion
	
	
	consulta= "   select a.pote_ncorr,a.pers_ncorr, a.norc_otic," & vbCrlf & _ 
			  "   isnull(a.empr_ncorr_otic, (select empr_ncorr from empresas where cast(empr_nrut as varchar)='"&o_empr_nrut&"')) as empr_ncorr, " & vbCrlf & _ 
			  "   isnull((select empr_trazon_social from empresas em where em.empr_ncorr=a.empr_ncorr_otic),(select empr_trazon_social from empresas where cast(empr_nrut as varchar)='"&o_empr_nrut&"')) as empr_trazon_social, " & vbCrlf & _ 
			  "   isnull((select empr_nrut from empresas em where em.empr_ncorr=a.empr_ncorr_otic),(select empr_nrut from empresas where cast(empr_nrut as varchar)='"&o_empr_nrut&"')) as empr_nrut, " & vbCrlf & _ 
			  "   isnull((select empr_xdv from empresas em where em.empr_ncorr=a.empr_ncorr_otic),(select empr_xdv from empresas where cast(empr_nrut as varchar)='"&o_empr_nrut&"')) as empr_xdv, " & vbCrlf & _ 
			  "   isnull((select empr_tdireccion from empresas em where em.empr_ncorr=a.empr_ncorr_otic),(select empr_tdireccion from empresas where cast(empr_nrut as varchar)='"&o_empr_nrut&"')) as empr_tdireccion, " & vbCrlf & _ 
			  "   isnull((select ciud_ccod from empresas em where em.empr_ncorr=a.empr_ncorr_otic),(select ciud_ccod from empresas where cast(empr_nrut as varchar)='"&o_empr_nrut&"')) as ciud_ccod, " & vbCrlf & _ 
			  "   isnull((select empr_tfono from empresas em where em.empr_ncorr=a.empr_ncorr_otic),(select empr_tfono from empresas where cast(empr_nrut as varchar)='"&o_empr_nrut&"')) as empr_tfono, " & vbCrlf & _ 
			  "   isnull((select empr_tfax from empresas em where em.empr_ncorr=a.empr_ncorr_otic),(select empr_tfax from empresas where cast(empr_nrut as varchar)='"&o_empr_nrut&"')) as empr_tfax, " & vbCrlf & _ 
			  "   isnull((select empr_tgiro from empresas em where em.empr_ncorr=a.empr_ncorr_otic),(select empr_tgiro from empresas where cast(empr_nrut as varchar)='"&o_empr_nrut&"')) as empr_tgiro, " & vbCrlf & _ 
			  "   isnull((select empr_tejecutivo from empresas em where em.empr_ncorr=a.empr_ncorr_otic),(select empr_tejecutivo from empresas where cast(empr_nrut as varchar)='"&o_empr_nrut&"')) as empr_tejecutivo, " & vbCrlf & _ 
			  "   isnull((select empr_temail_ejecutivo from empresas em where em.empr_ncorr=a.empr_ncorr_otic),(select empr_temail_ejecutivo from empresas where cast(empr_nrut as varchar)='"&o_empr_nrut&"')) as empr_temail_ejecutivo " & vbCrlf & _ 
			  "   from postulacion_otec a, personas b " & vbCrlf & _ 
			  "   where  a.pers_ncorr=b.pers_ncorr " & vbCrlf & _ 
			  "   and cast(b.pers_nrut as varchar)='"&q_pers_nrut&"' " & vbCrlf & _
			  "   and cast(a.dgso_ncorr as varchar)='"&dgso_ncorr&"'  "
			  
	
	if tiene_postulacion = "N" then
		consulta = "select '' as pers_ncorr"
	end if
	datos_otic.consultar consulta 
	datos_otic.siguiente
	if o_empr_nrut <> "" and o_empr_xdv <> "" then
		datos_otic.AgregaCampoCons "empr_nrut", o_empr_nrut
		datos_otic.AgregaCampoCons "empr_xdv", o_empr_xdv
	end if
end if
mensaje_orden=""
if (forma_pago="2" or forma_pago="3") and tiene_postulacion="S" then
	tiene_empresa = conexion.consultaUno("select empr_ncorr_empresa from postulacion_otec a, personas b where a.pers_ncorr=b.pers_ncorr and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
	orden_compra  = conexion.consultaUno("select norc_empresa from postulacion_otec a, personas b where a.pers_ncorr=b.pers_ncorr and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
    registro_orden = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from ordenes_compras_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(empr_ncorr as varchar)='"&tiene_empresa&"' and cast(nord_compra as varchar)='"&orden_compra&"'")
	if registro_orden = "N" and orden_compra <> "" then
		mensaje_orden = "Aún no agrega los datos de la orden de compra, dichos datos son necesarios para la matrícula, el proceso es una vez independiente de la cantidad de alumnos que beneficie."
        url_orden = "agregar_orden_compra.asp?dgso_ncorr="&dgso_ncorr&"&empr_ncorr="&tiene_empresa&"&nord_compra="&orden_compra&"&tipo=1&fpot_ccod="&forma_pago     	
	elseif registro_orden = "S" and orden_compra <> "" then
		mensaje_orden = "Si desea actualizar los datos de la orden de compra haga click en el siguiente botón.</strong>(esto afectará a todos los alumnos que esten bajo esta orden de compra).<strong>"
        url_orden = "agregar_orden_compra.asp?dgso_ncorr="&dgso_ncorr&"&empr_ncorr="&tiene_empresa&"&nord_compra="&orden_compra&"&tipo=1&fpot_ccod="&forma_pago     	
	end if	
elseif (forma_pago="4") and tiene_postulacion="S" then
	tiene_empresa = conexion.consultaUno("select empr_ncorr_otic from postulacion_otec a, personas b where a.pers_ncorr=b.pers_ncorr and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
	orden_compra  = conexion.consultaUno("select norc_otic from postulacion_otec a, personas b where a.pers_ncorr=b.pers_ncorr and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
    registro_orden = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from ordenes_compras_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(empr_ncorr as varchar)='"&tiene_empresa&"' and cast(nord_compra as varchar)='"&orden_compra&"'")
	empr_ncorr_2 = conexion.consultaUno("select empr_ncorr_empresa from postulacion_otec a, personas b where a.pers_ncorr=b.pers_ncorr and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
	if registro_orden = "N" and orden_compra <> "" then
		mensaje_orden = "Aún no agrega los datos de la orden de compra, dichos datos son necesarios para la matrícula, el proceso es una vez independiente de la cantidad de alumnos que beneficie."
        url_orden = "agregar_orden_compra.asp?dgso_ncorr="&dgso_ncorr&"&empr_ncorr="&tiene_empresa&"&nord_compra="&orden_compra&"&tipo=2&empr_ncorr_2="&empr_ncorr_2&"&fpot_ccod="&forma_pago       		
	elseif registro_orden = "S" and orden_compra <> "" then
		mensaje_orden = "Si desea actualizar los datos de la orden de compra haga click en el siguiente botón.</strong>(esto afectará a todos los alumnos que esten bajo esta orden de compra).<strong>"
        url_orden = "agregar_orden_compra.asp?dgso_ncorr="&dgso_ncorr&"&empr_ncorr="&tiene_empresa&"&nord_compra="&orden_compra&"&tipo=2&empr_ncorr_2="&empr_ncorr_2&"&fpot_ccod="&forma_pago       		
	end if	
end if

'response.Write("url_orden "&url_orden)

'---------------------generamos lista para llenar valores adicionales -----------------------------------------------------------
set datos_finales = new cformulario
datos_finales.carga_parametros "agrega_postulantes.xml", "datos_finales"
datos_finales.inicializar conexion


consulta= " select pote_ncorr,tdet_ccod,isnull(datos_persona_correctos,'0') as datos_persona_correctos, " & vbCrlf & _
		  " isnull(datos_empresa_correctos,'0') as datos_empresa_correctos,isnull(datos_otic_correctos,'0') as datos_otic_correctos  " & vbCrlf & _
		  " from postulacion_otec a, personas b " & vbCrlf & _
		  " where a.pers_ncorr=b.pers_ncorr and cast(pers_nrut as varchar)='"&q_pers_nrut&"'" & vbCrlf & _
		  " and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'" 

c_datos = " select 0 as tdet_ccod, 'SIN DESCUENTO (0%)' as tdet_tdesc "&_
          " union "&_
          " select a.tdet_ccod,b.tdet_tdesc + ' ('+cast(ddcu_mdescuento as varchar)+'%)' as tdet_tdesc "&_
		  " from descuentos_diplomados_curso a, tipos_detalle b "&_
		  " where a.tdet_ccod=b.tdet_ccod and isnull(a.ddcu_mdescuento,0) > 0 "&_
		  " and cast(dcur_ncorr as varchar)='"&DCUR_NCORR&"'"
datos_finales.consultar consulta
datos_finales.agregaCampoParam "tdet_ccod","destino","("&c_datos&")a"
datos_finales.siguiente

if tiene_postulacion="S" then
	pote_ncorr = conexion.consultaUno("select pote_ncorr from postulacion_otec a, personas b where a.pers_ncorr=b.pers_ncorr and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
    matriculado = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from postulacion_otec where cast(pote_ncorr as varchar)='"&pote_ncorr&"' and epot_ccod=4")
end if
'response.Write(c_datos)
'response.Write(matriculado)
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
var t_busqueda;
var t_busqueda2;
function ValidaBusqueda()
{
	rut = t_busqueda.ObtenerValor(0, "pers_nrut") + '-' + t_busqueda.ObtenerValor(0, "pers_xdv")
	
	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido.');		
		t_busqueda.filas[0].campos["pers_xdv"].objeto.select();
		return false;
	}
	
	return true;	
}
function InicioPagina()
{
	t_busqueda = new CTabla("b");
	t_busqueda2 = new CTabla("e");
	t_busqueda3 = new CTabla("o");
}

function forma_pago(valor)
{
	forma_pago_registrada = '<%=forma_pago%>';
	//alert("forma_pago "+forma_pago_registrada+ " valor "+valor);
	if (forma_pago_registrada != valor)
	{
		alert("Se debe volver a guardar los datos para que los cambios se  vean reflejados.");
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
	if (valor=='1')
	{
		 document.getElementById("sence").style.visibility = "hidden" ;
		 document.edicion_persona.elements["m[0][utiliza_sence]"].checked = false;
		 document.edicion_persona.elements["_m[0][utiliza_sence]"].checked = false;
		 document.edicion_persona.elements["m[0][utiliza_sence]"].value = 0;
		 document.edicion_persona.elements["_m[0][utiliza_sence]"].value = 0;
	}
	if (valor=='2')//en caso de ser forma de pago empresa sin sence se debe descheckear esa opción
	{
	 document.getElementById("sence").style.visibility = "hidden" ;
	 document.edicion_persona.elements["m[0][utiliza_sence]"].checked = false;
	 document.edicion_persona.elements["_m[0][utiliza_sence]"].checked = false;
	 document.edicion_persona.elements["m[0][utiliza_sence]"].value = 0;
	 document.edicion_persona.elements["_m[0][utiliza_sence]"].value = 0;
	}
	if (valor=='3')//en caso de ser forma de pago empresa sin sence se debe descheckear esa opción
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
	rut = t_busqueda2.ObtenerValor(0, "empr_nrut") + '-' + t_busqueda2.ObtenerValor(0, "empr_xdv")

	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido.');		
		t_busqueda2.filas[0].campos["empr_xdv"].objeto.select();
		return false;
	}
	
	return true;	
}
function ValidaRut33()
{
	rut = t_busqueda3.ObtenerValor(0, "empr_nrut") + '-' + t_busqueda3.ObtenerValor(0, "empr_xdv")

	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido.');		
		t_busqueda3.filas[0].campos["empr_xdv"].objeto.select();
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

function configurar_orden_compra() {
	
	direccion = '<%=url_orden%>';
	resultado=window.open(direccion, "ventana1","width=400,height=300,scrollbars=no, left=380, top=150");
	
 // window.close();
}

function valida_cierre(formulario)
{forma_pago = '<%=forma_pago%>';
 valor = 1;
  //alert(formulario.elements["_m[0][datos_persona_correctos]"].checked);
	if ((forma_pago=='1')&&(document.edicion_fin.elements["_m[0][datos_persona_correctos]"].checked==false))
		{ valor = 0;
		  alert("Debe Seleccionar la conformidad de los datos entregados por el alumno para cerrar la postulación");
		 }
	if (((forma_pago=='2')||(forma_pago=='3'))&&((document.edicion_fin.elements["_m[0][datos_persona_correctos]"].checked==false)||(document.edicion_fin.elements["_m[0][datos_empresa_correctos]"].checked==false)))
		{ valor = 0;
		  alert("Debe Seleccionar la conformidad de los datos personales y de la empresa, entregados por el alumno, para cerrar la postulación");
		 }
	if ((forma_pago=='4')&&((document.edicion_fin.elements["_m[0][datos_persona_correctos]"].checked==false)||(document.edicion_fin.elements["_m[0][datos_empresa_correctos]"].checked==false)||(document.edicion_fin.elements["_m[0][datos_otic_correctos]"].checked==false)))
		{ valor = 0;
		  alert("Debe Seleccionar la conformidad de los datos personales, de la empresa y la otic, entregados por el alumno, para cerrar la postulación");
		 }	
		 
/*alert(document.edicion_fin.elements["m[0][tdet_ccod]"].value);		
if (document.edicion_fin.elements["m[0][tdet_ccod]"].value=="")
 {
 	document.edicion_fin.elements["temporal"].value=0;
 }
else
 {
 	document.edicion_fin.elements["temporal"].value = document.edicion_fin.elements["m[0][tdet_ccod]"].value;
 } */
 
if (valor == 0)		  
	{return false;	}
else
	{return true;}
			
}
</script>

</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
<table width="580" height="100%">
<tr valign="top" height="30">
	<td bgcolor="#EAEAEA">
</td>
</tr>
<tr valign="top">
	<td bgcolor="#EAEAEA">
<table width="652" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA" align="center">
	<table width="90%">
	<tr>
		<td align="center">
	
	<table width="60%"  border="0" align="left" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
                    <td width="20%"><div align="center"><strong>Rut</strong></td>
					<td width="3%"><div align="center"><strong>:</strong></td>
                    <td width="50%"><%f_busqueda.DibujaCampo("pers_nrut")%> 
                          - 
                            <%f_busqueda.DibujaCampo("pers_xdv")%> <%pagina.DibujarBuscaPersonas "b[0][pers_nrut]", "b[0][pers_xdv]"%></td>
					<td align="right"><%botonera.dibujaboton "buscar"%></td>
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
            <td><%pagina.DibujarLenguetas Array("Ingreso de Postulación"), 1 %></td>
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
				  <%if dcur_ncorr <> "" and not esVacio(dcur_ncorr) then %>
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
				  	<td>&nbsp;</td>
				  </tr>
				  <%if q_pers_nrut <> "" and q_pers_xdv <> "" then %>
				  
				  <tr>
				  	<td align="center">						<table width="98%">
                      <form name="edicion_persona">
                        <tr>
                          <td colspan="6" align="center" bgcolor="#999999"><font size="+2" face="Times New Roman, Times, serif" color="#FFFFFF"><strong>PASO 1</strong></font></td>
                        </tr>
                        <tr>
                          <td width="10%"><strong>Rut</strong></td>
                          <td width="1%"><strong>:</strong></td>
                          <td width="39%"><%datos_postulante.dibujaCampo("codigo_rut")%>
                              <%datos_postulante.dibujaCampo("pers_nrut")%>
                              <%datos_postulante.dibujaCampo("pers_xdv")%></td>
                          <td width="10%" align="right"><strong>Nombre</strong></td>
                          <td width="1%"><strong>:</strong></td>
                          <td width="39%"><%datos_postulante.dibujaCampo("pers_tnombre")%></td>
                        </tr>
                        <tr>
                          <td width="10%"><strong>A.Paterno</strong></td>
                          <td width="1%"><strong>:</strong></td>
                          <td width="39%"><%datos_postulante.dibujaCampo("pers_tape_paterno")%></td>
                          <td width="10%" align="right"><strong>A.Materno</strong></td>
                          <td width="1%"><strong>:</strong></td>
                          <td width="39%"><%datos_postulante.dibujaCampo("pers_tape_materno")%></td>
                        </tr>
                        <tr>
                          <td width="10%"><strong>F.Nacimiento</strong></td>
                          <td width="1%"><strong>:</strong></td>
                          <td width="39%"><%datos_postulante.dibujaCampo("pers_fnacimiento")%></td>
                          <td width="10%" align="right"><strong>Profesión</strong></td>
                          <td width="1%"><strong>:</strong></td>
                          <td width="39%"><%datos_postulante.dibujaCampo("pers_tprofesion")%></td>
                        </tr>
                        <tr>
                          <td width="10%"><strong>Nivel Edu.</strong></td>
                          <td width="1%"><strong>:</strong></td>
                          <td colspan="4"><%datos_postulante.dibujaCampo("nied_ccod")%></td>
                        </tr>
                        <tr>
                          <td width="10%"><strong>Dirección</strong></td>
                          <td width="1%"><strong>:</strong></td>
                          <td width="39%"><%datos_postulante.dibujaCampo("dire_tcalle")%></td>
                          <td width="10%" align="right"><strong>Número</strong></td>
                          <td width="1%"><strong>:</strong></td>
                          <td width="39%"><%datos_postulante.dibujaCampo("dire_tnro")%></td>
                        </tr>
                        <tr>
                          <td width="10%"><strong>Población</strong></td>
                          <td width="1%"><strong>:</strong></td>
                          <td width="39%"><%datos_postulante.dibujaCampo("dire_tpoblacion")%></td>
                          <td width="10%" align="right"><strong>Depto</strong></td>
                          <td width="1%"><strong>:</strong></td>
                          <td width="39%"><%datos_postulante.dibujaCampo("dire_tblock")%></td>
                        </tr>
                        <tr>
                          <td width="10%"><strong>Comuna</strong></td>
                          <td width="1%"><strong>:</strong></td>
                          <td width="39%"><%datos_postulante.dibujaCampo("ciud_ccod")%></td>
                          <td width="10%" align="right"><strong>E-mail</strong></td>
                          <td width="1%"><strong>:</strong></td>
                          <td width="39%"><%datos_postulante.dibujaCampo("pers_temail")%></td>
                        </tr>
                        <tr>
                          <td width="10%"><strong>Fono</strong></td>
                          <td width="1%"><strong>:</strong></td>
                          <td width="39%"><%datos_postulante.dibujaCampo("pers_tfono")%></td>
                          <td width="10%" align="right"><strong>Celular</strong></td>
                          <td width="1%"><strong>:</strong></td>
                          <td width="39%"><%datos_postulante.dibujaCampo("pers_tcelular")%></td>
                        </tr>
                        <tr>
                          <td width="10%"><strong>Empresa</strong></td>
                          <td width="1%"><strong>:</strong></td>
                          <td width="39%"><%datos_postulante.dibujaCampo("pers_tempresa")%></td>
                          <td width="10%" align="right"><strong>Cargo</strong></td>
                          <td width="1%"><strong>:</strong></td>
                          <td width="39%"><%datos_postulante.dibujaCampo("pers_tcargo")%></td>
                        </tr>
                        <tr>
                          <td colspan="6">
                            <table width="100%" cellpadding="0" cellspacing="0" id="sence" style="visibility:visible">
                              <tr>
                                <td width="10%"><strong>Utiliza Sence</strong></td>
                                <td width="1%"><strong>:</strong></td>
                                <td width="39%" colspan="4"><%datos_postulante.dibujaCampo("utiliza_sence")%></td>
                              </tr>
                          </table></td>
                        </tr>
                        <tr>
                          <td colspan="6" align="center">
                            <table width="98%" border="1">
                              <tr>
                                <td width="100%">
                                  <table width="100%" border="0">
                                    <tr>
                                      <td colspan="4" align="left"><strong>Quién Cancela el Programa</strong></td>
                                    </tr>
                                    <tr>
                                      <td width="25%" align="center">Persona Natural</td>
                                      <td width="25%" align="center">Empresa sin SENCE</td>
                                      <td width="25%" align="center">Empresa con SENCE</td>
                                      <td width="25%" align="center">Empresa con OTIC</td>
                                    </tr>
                                    <tr>
                                      <td width="25%" align="center">
                                        <%if datos_postulante.obtenerValor("fpot_ccod")= "" or datos_postulante.obtenerValor("fpot_ccod")= "1" then %>
                                        <input type="radio" name="m[0][fpot_ccod]" value="1" checked onClick="forma_pago(this.value);">
                                        <%else%>
                                        <input type="radio" name="m[0][fpot_ccod]" value="1" onClick="forma_pago(this.value);">
                                        <%end if%>
                                      </td>
                                      <td width="25%" align="center">
                                        <%if datos_postulante.obtenerValor("fpot_ccod")= "2" then %>
                                        <input type="radio" name="m[0][fpot_ccod]" value="2" checked onClick="forma_pago(this.value);">
                                        <%else%>
                                        <input type="radio" name="m[0][fpot_ccod]" value="2" onClick="forma_pago(this.value);">
                                        <%end if%>
                                      </td>
                                      <td width="25%" align="center">
                                        <%if datos_postulante.obtenerValor("fpot_ccod")= "3" then %>
                                        <input type="radio" name="m[0][fpot_ccod]" value="3" checked onClick="forma_pago(this.value);">
                                        <%else%>
                                        <input type="radio" name="m[0][fpot_ccod]" value="3" onClick="forma_pago(this.value);">
                                        <%end if%>
                                      </td>
                                      <td width="25%" align="center">
                                        <%if datos_postulante.obtenerValor("fpot_ccod")= "4" then %>
                                        <input type="radio" name="m[0][fpot_ccod]" value="4" checked onClick="forma_pago(this.value);">
                                        <%else%>
                                        <input type="radio" name="m[0][fpot_ccod]" value="4" onClick="forma_pago(this.value);">
                                        <%end if%>
                                      </td>
                                    </tr>
                                </table></td>
                              </tr>
                          </table></td>
                        </tr>
                        <tr>
                          <td colspan="6" align="right"><%  if matriculado="S" then
																	botonera.agregaBotonParam "guardar_persona","deshabilitado","true"																
						                                      end if
						                                      botonera.dibujaBoton "guardar_persona"%></td>
                        </tr>
                      </form>
                      <%if tiene_postulacion = "S" then%>
                      <form name="edicion2">
                        <input type="hidden" name="b[0][pers_nrut]" value="<%=q_pers_nrut%>">
                        <input type="hidden" name="b[0][pers_xdv]" value="<%=q_pers_xdv%>">
                        <tr>
                          <td colspan="6">&nbsp;</td>
                        </tr>
                        <tr>
                          <td colspan="6" align="center" bgcolor="#999999"><font size="+2" face="Times New Roman, Times, serif" color="#FFFFFF"><strong>PASO 2</strong></font></td>
                        </tr>
                        <%if forma_pago="2" or forma_pago="3" or forma_pago="4" then%>
                        <tr>
                          <td colspan="6" align="left"><strong>------DATOS EMPRESA------</strong></td>
                        </tr>
                        <tr>
                          <input type="hidden" name="e[0][fpot_ccod]" value="<%=forma_pago%>">
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
                          <%if forma_pago = "4" then %>
                          <td colspan="4"><%datos_empresa.dibujaCampo("empr_temail_ejecutivo")%>
                              <input type="hidden" name="e[0][norc_empresa]" value="0"></td>
                          <%else%>
                          <td width="39%"><%datos_empresa.dibujaCampo("empr_temail_ejecutivo")%></td>
                          <td width="10%" align="right"><strong>N°Orden Compra</strong></td>
                          <td width="1%"><strong>:</strong></td>
                          <td width="39%"><%datos_empresa.dibujaCampo("norc_empresa")%></td>
                          <%end if%>
                        </tr>
                        <tr>
                          <td colspan="6" align="left">
                            <table width="100%" cellpadding="0" cellspacing="0" id="bt_empresa" style="visibility:visible">
                              <tr>
                                <td align="right"><%botonera.dibujaBoton "guardar_empresas"%></td>
                              </tr>
                          </table></td>
                        </tr>
                        <%end if%>
                        <%'response.Write("--------**********--------- "&tiene_empresa)
							if forma_pago="4" and tiene_empresa_1 <> "0" then%>
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
                          <td width="39%"><%datos_otic.dibujaCampo("empr_temail_ejecutivo")%></td>
                          <td width="10%" align="right"><strong>N°Orden Compra</strong></td>
                          <td width="1%"><strong>:</strong></td>
                          <td width="39%"><%datos_otic.dibujaCampo("norc_otic")%></td>
                        </tr>
                        <tr>
                          <td colspan="6" align="left">
                            <table width="100%" cellpadding="0" cellspacing="0" id="bt_otic" style="visibility:visible">
                              <tr>
                                <td align="right"><%botonera.dibujaBoton "guardar_otic"%></td>
                              </tr>
                          </table></td>
                        </tr>
                        <%end if%>
                        <%if (forma_pago="2" or forma_pago="3" or forma_pago="4") and tiene_empresa_1 <> "0" then%>
                        <tr>
                          <td colspan="6">&nbsp;</td>
                        </tr>
                        <tr>
                          <td colspan="6" align="center"><table width="90%" border="1">
                              <tr>
                                <td align="center"> <strong> <font face="Times New Roman, Times, serif" size="2"> <%=mensaje_orden%>&nbsp;<br>
                                        <%
										    if mensaje_orden <> "" then
											'botonera.dibujaBoton "configurar_orden_compra"%>
                                        <table width="100%" cellpadding="0" cellspacing="0" id="bt_orden" style="visibility:visible">
                                          <tr>
                                            <td align="center"><%botonera.dibujaBoton "configurar_orden_compra"%></td>
                                          </tr>
                                        </table>
                                        <%end if%>
                                </font> </strong> </td>
                              </tr>
                          </table></td>
                        </tr>
                        <%end if%>
                      </form>
                      <form name="edicion_fin">
                        <%datos_finales.dibujaCampo("pote_ncorr")%>
                        <input type="hidden" name="forma_pago" value="<%=forma_pago%>">
                        <%if forma_pago= "1" then%>
                        <tr>
                          <td colspan="6">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="10%"><strong>Descuento</strong></td>
                          <td width="1%"><strong>:</strong></td>
                          <td colspan="4"><%datos_finales.dibujaCampo("tdet_ccod")%></td>
                        </tr>
                        <tr>
                          <td width="10%" align="right"><% datos_finales.agregaBotonParam "datos_persona_correctos","id","TO-N"
							                                     datos_finales.dibujaCampo("datos_persona_correctos")%></td>
                          <td width="1%"><strong>:</strong></td>
                          <td colspan="4"><strong>Los Datos Personales y de descuentos han sido comprobados y se encuentran correctos.</strong></td>
                        </tr>
                        <tr>
                          <td colspan="6" align="center"><%  if matriculado="S" then
																	botonera.agregaBotonParam "guardar_datos_finales","deshabilitado","true"																
						                                      end if
						                                     botonera.dibujaBoton("guardar_datos_finales")%></td>
                        </tr>
                        <%elseif (forma_pago="2" or forma_pago="3") and tiene_empresa <> "" and not Esvacio(tiene_empresa) then%>
                        <tr>
                          <td colspan="6">&nbsp;</td>
                        </tr>
                        <tr>
                          <td colspan="6" align="center" bgcolor="#999999"><font size="+2" face="Times New Roman, Times, serif" color="#FFFFFF"><strong>PASO 3</strong></font></td>
                        </tr>
                        <tr>
                          <td colspan="6">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="10%"><strong>Descuento</strong></td>
                          <td width="1%"><strong>:</strong></td>
                          <td colspan="4"><%datos_finales.dibujaCampo("tdet_ccod")%></td>
                        </tr>
                        <tr>
                          <td width="10%" align="right"><% datos_finales.agregaBotonParam "datos_persona_correctos","id","TO-N" 
							                                     datos_finales.dibujaCampo("datos_persona_correctos")%></td>
                          <td width="1%"><strong>:</strong></td>
                          <td colspan="4"><strong>Los Datos Personales y de descuentos han sido comprobados y se encuentran correctos.</strong></td>
                        </tr>
                        <tr>
                          <td width="10%" align="right"><% datos_finales.agregaBotonParam "datos_empresa_correctos","id","TO-N"
							                                     datos_finales.dibujaCampo("datos_empresa_correctos")%></td>
                          <td width="1%"><strong>:</strong></td>
                          <td colspan="4"><strong>Los Datos de la Empresa han sido comprobados y se encuentran correctos.</strong></td>
                        </tr>
                        <tr>
                          <td colspan="6" align="center"><%   if matriculado="S" then
																	botonera.agregaBotonParam "guardar_datos_finales","deshabilitado","true"																
						                                      end if
						                                      botonera.dibujaBoton("guardar_datos_finales")%></td>
                        </tr>
                        <%elseif (forma_pago="4") and tiene_empresa_1 <> "" and tiene_empresa_1 <> "0" and tiene_empresa <> "" and not Esvacio(tiene_empresa) then%>
                        <tr>
                          <td colspan="6">&nbsp;</td>
                        </tr>
                        <tr>
                          <td colspan="6" align="center" bgcolor="#999999"><font size="+2" face="Times New Roman, Times, serif" color="#FFFFFF"><strong>PASO 3</strong></font></td>
                        </tr>
                        <tr>
                          <td colspan="6">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="10%"><strong>Descuento</strong></td>
                          <td width="1%"><strong>:</strong></td>
                          <td colspan="4"><%datos_finales.dibujaCampo("tdet_ccod")%></td>
                        </tr>
                        <tr>
                          <td width="10%" align="right"><%datos_finales.agregaBotonParam "datos_persona_correctos","id","TO-N"
							                                    datos_finales.dibujaCampo("datos_persona_correctos")%></td>
                          <td width="1%"><strong>:</strong></td>
                          <td colspan="4"><strong>Los Datos Personales y de descuentos han sido comprobados y se encuentran correctos.</strong></td>
                        </tr>
                        <tr>
                          <td width="10%" align="right"><% datos_finales.agregaBotonParam "datos_empresa_correctos","id","TO-N"
							                                     datos_finales.dibujaCampo("datos_empresa_correctos")%></td>
                          <td width="1%"><strong>:</strong></td>
                          <td colspan="4"><strong>Los Datos de la Empresa han sido comprobados y se encuentran correctos.</strong></td>
                        </tr>
                        <tr>
                          <td width="10%" align="right"><% datos_finales.agregaBotonParam "datos_otic_correctos","id","TO-N"
							                                     datos_finales.dibujaCampo("datos_otic_correctos")%></td>
                          <td width="1%"><strong>:</strong></td>
                          <td colspan="4"><strong>Los Datos de la Otic han sido comprobados y se encuentran correctos.</strong></td>
                        </tr>
                        <tr>
                          <td colspan="6" align="left">
                            <table width="100%" cellpadding="0" cellspacing="0" id="bt_datos_finales" style="visibility:visible">
                              <tr>
                                <td align="right"><% if matriculado="S" then
														botonera.agregaBotonParam "guardar_datos_finales","deshabilitado","true"																
						                             end if
								                     botonera.dibujaBoton "guardar_datos_finales"%></td>
                              </tr>
                          </table></td>
                        </tr>
                        <%end if%>
                      </form>
                      <%end if%>
                    </table></td>
				  </tr>
				  
				  <%end if%>
				  <%end if%>
				  <tr>
                    <td>&nbsp;</td>
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
</table>
</td>
</tr>
</table>
</body>
</html>
