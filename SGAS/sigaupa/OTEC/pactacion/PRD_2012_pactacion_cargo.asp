<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

'for each x in request.Form
'	response.Write("<br>"&x&" -> "&request.Form(x))
'next
'response.End()


q_comp_ndocto = Request.QueryString("comp_ndocto")
q_inst_ccod = Request.QueryString("inst_ccod")
q_tcom_ccod = Request.QueryString("tcom_ccod")
q_pers_ncorr_codeudor = Request.QueryString("pers_ncorr_codeudor")
v_dgso_ncorr 	= Request.QueryString("dgso_ncorr")
v_fpot_ccod 	= Request.QueryString("fpot_ccod")

v_indice = Request.Form("indice")
v_num_oc = Request.Form("cargo["&v_indice&"][num_oc]")
'response.Write("<hr>"&v_num_oc&"<hr>")
if v_num_oc="" or EsVacio(v_num_oc) then
	v_num_oc 		= Request.QueryString("num_oc")	
end if
if v_num_oc <>"" then
	sql_num_oc="and nord_compra="&v_num_oc
end if


q_pers_nrut 	= Request.Form("pers_nrut")
q_pers_xdv 		= Request.Form("pers_xdv")
q_tipo_persona 	= Request.Form("tipo_persona")



if q_tipo_persona="" then
	q_tipo_persona 	= Request.QueryString("q_tipo_persona")
end if

'response.Write("Tipo persona :"&q_tipo_persona)

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set pagina = new CPagina
pagina.Titulo = "Pactación Curso / Diplomado"
'---------------------------------------------------------------------------------------------------
if q_pers_nrut<>"" then
	nombre = conexion.consultauno("select pers_tnombre from personas where cast(pers_nrut as varchar) ='"&q_pers_nrut&"'")
end if

' si es una Empresa o una Otic
if q_tipo_persona=2 or q_tipo_persona=3 then
	if q_pers_ncorr_codeudor="" then
		v_pers_ncorr_empr=conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
	else
		v_pers_ncorr_empr=q_pers_ncorr_codeudor
	end if

	v_existe_en_dir=conexion.consultaUno("select count(*) from direcciones where cast(pers_ncorr as varchar)='"&v_pers_ncorr_empr&"'")

	if v_existe_en_dir=0 then
	
		set f_datos_empresa = new CFormulario
		f_datos_empresa.Carga_Parametros "consulta.xml", "consulta"
		f_datos_empresa.Inicializar conexion
	
			sql_datos_empresa="select empr_ncorr,empr_tdireccion,empr_tfono,ciud_ccod "&vbcrlf&_
							  "	from empresas where empr_ncorr="&v_pers_ncorr_empr
	
		f_datos_empresa.Consultar sql_datos_empresa
		f_datos_empresa.SiguienteF
	
		v_direccion	=	f_datos_empresa.ObtenerValor("empr_tdireccion")
		v_fono		=	f_datos_empresa.ObtenerValor("empr_tfono")
		v_ciudad	=	f_datos_empresa.ObtenerValor("ciud_ccod")
	
		sql_inserta=" Insert into direcciones (pers_ncorr,tdir_ccod,dire_tcalle,dire_tnro,dire_tfono,ciud_ccod) "&vbcrlf&_
					" values("&v_pers_ncorr_empr&",1, '"&v_direccion&"','','"&v_fono&"',"&v_ciudad&" ) "
		conexion.EjecutaS(sql_inserta)
		
		sql_update_persona="Update personas set pers_tfono='"&v_fono&"' where pers_ncorr="&v_pers_ncorr_empr
		conexion.EjecutaS(sql_update_persona)
	
	end if
end if
' fin de creacion de datos cuando no existen

set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede

if not cajero.tienecajaabierta then
  conexion.MensajeError "No puede recibir pagos sin tener una caja abierta"
  response.Redirect(request.ServerVariables("HTTP_REFERER")) 
end if

v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")
v_inst_ccod = "1"
v_tcom_ccod = 7

'response.Write("<br>v_comp_mdocumento "&v_monto_arancel)
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "datos_otec.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_cargo = new CFormulario
f_cargo.Carga_Parametros "datos_otec.xml", "cargo_mostrar"
f_cargo.Inicializar conexion

'response.Write("<hr>"&q_comp_ndocto&"<hr>")

'*****************************************************************
if EsVacio(q_comp_ndocto) then

	set f_postulantes = new Cformulario
	f_postulantes.Carga_Parametros "datos_otec.xml", "cargo"
	f_postulantes.Inicializar conexion
	f_postulantes.ProcesaForm

	for fila = 0 to f_postulantes.CuentaPost - 1
	
	   valor_dcur_ncorr	= f_postulantes.ObtenerValorPost (fila, "dcur_ncorr")
	
		if valor_dcur_ncorr <> "" then
			v_dcur_ncorr		= 	f_postulantes.ObtenerValorPost (fila, "dcur_ncorr")
			v_pote_ncorr		= 	f_postulantes.ObtenerValorPost (fila, "pote_ncorr")
			v_pers_ncorr		= 	f_postulantes.ObtenerValorPost (fila, "pers_ncorr")
			v_fpot_ccod			= 	f_postulantes.ObtenerValorPost (fila, "fpot_ccod")
			v_tdet_ccod			= 	f_postulantes.ObtenerValorPost (fila, "tdet_ccod")
			v_num_oc			= 	f_postulantes.ObtenerValorPost (fila, "num_oc")
			v_monto_arancel 	= 	clng(f_postulantes.ObtenerValorPost (fila, "monto_arancel"))
			v_monto_matricula 	= 	clng(f_postulantes.ObtenerValorPost (fila, "monto_matricula"))
			v_dgso_ncorr		= 	f_postulantes.ObtenerValorPost (fila, "dgso_ncorr")
			v_monto_financiado	=	v_monto_arancel+v_monto_matricula
			pers_ncorr_codeudor=v_pers_ncorr
		'response.Write("<hr> Forma pago:"& v_fpot_ccod&"<hr>")
			if v_fpot_ccod<>"1" and q_tipo_persona="1" then
				session("mensajeError")="Ha selecionado el rut de una persona natural, sin embargo esta sera financiada por una Empresa/Otic. \nPor lo tanto debe ingresar el rut de la Empresa/Otic para generar el cargo y la posterior facturación."
				response.Redirect(request.ServerVariables("HTTP_REFERER"))
			end if

		end if
	
	next


		select case q_tipo_persona
		' tipo persona : PERSONA
			case "1"
				v_tipo_persona = "PERSONA"
				sql_datos_postulante= 	" Select a.pers_ncorr,d.dcur_ncorr,a.epot_ccod,d.dcur_tdesc, "&vbcrlf&_
										"  cast(c.ofot_narancel*(isnull(g.ddcu_mdescuento,0)*0.01) as numeric) as spac_mdescuento,"&vbcrlf&_
										"  cast(c.ofot_narancel*(isnull(g.ddcu_mdescuento,0)*0.01) as numeric) as c_comp_mdescuento,"&vbcrlf&_
										" (c.ofot_nmatricula+c.ofot_narancel)-(c.ofot_narancel*(isnull(g.ddcu_mdescuento,0)*0.01)) as c_comp_mdocumento,"&vbcrlf&_
										" c.ofot_nmatricula+c.ofot_narancel as c_arancel "&vbcrlf&_
										" from postulacion_otec a "&vbcrlf&_
										"join datos_generales_secciones_otec b  "&vbcrlf&_
										"    on a.pers_ncorr="&v_pers_ncorr &vbcrlf&_
										"    and a.dgso_ncorr=b.dgso_ncorr "&vbcrlf&_
										"join ofertas_otec c   "&vbcrlf&_
										"   on b.dgso_ncorr=c.dgso_ncorr "&vbcrlf&_
										"join diplomados_cursos d  "&vbcrlf&_
										"   on c.dcur_ncorr=d.dcur_ncorr  "&vbcrlf&_
										"left outer join descuentos_diplomados_curso g  "&vbcrlf&_
										"   on a.tdet_ccod=g.tdet_ccod "&vbcrlf&_
										"   and d.dcur_ncorr=g.dcur_ncorr   "&vbcrlf&_									
										" where d.dcur_ncorr="&v_dcur_ncorr&" "&vbcrlf&_ 
										" and a.pote_ncorr="&v_pote_ncorr&" " 
										
			case "2"
				'tipo persona : EMPRESA
				v_tipo_persona = "EMPRESA"
				sql_datos_postulante= 	" Select top 1 a.empr_ncorr_empresa as pers_ncorr,d.dcur_ncorr,a.epot_ccod, "&vbcrlf&_
									" d.dcur_tdesc,sum(c.ofot_nmatricula)+sum(c.ofot_narancel) as c_arancel, "&vbcrlf&_
									" cast(sum(c.ofot_narancel)*(g.ddcu_mdescuento*0.01) as numeric) as spac_mdescuento, "&vbcrlf&_
									" cast(sum(c.ofot_narancel)*(g.ddcu_mdescuento*0.01) as numeric) as c_comp_mdescuento, "&vbcrlf&_
									" f.ocot_monto_empresa as c_comp_mdocumento"&vbcrlf&_
									" from postulacion_otec a "&vbcrlf&_
									" join datos_generales_secciones_otec b "&vbcrlf&_
									" 	on a.empr_ncorr_empresa="&v_pers_ncorr&" " &vbcrlf&_
									" 	and a.dgso_ncorr=b.dgso_ncorr "&vbcrlf&_
									" join ofertas_otec c "&vbcrlf&_
									" 	on b.dgso_ncorr=c.dgso_ncorr "&vbcrlf&_
									" join diplomados_cursos d "&vbcrlf&_
									" 	on c.dcur_ncorr=d.dcur_ncorr "&vbcrlf&_
									" join ordenes_compras_otec f "&vbcrlf&_
									" 	on a.dgso_ncorr=f.dgso_ncorr "&vbcrlf&_
									" 	and case when a.fpot_ccod=4 then norc_otic else a.norc_empresa end=f.nord_compra "&vbcrlf&_
									" "&sql_num_oc&" "&vbcrlf&_
									" 	and case when a.fpot_ccod=4 then f.empr_ncorr_2 else f.empr_ncorr end="&v_pers_ncorr&" "&vbcrlf&_
									" left outer join descuentos_diplomados_curso g "&vbcrlf&_
									" 	on a.tdet_ccod=g.tdet_ccod  "&vbcrlf&_
									" 	and d.dcur_ncorr=g.dcur_ncorr "&vbcrlf&_		
									" where d.dcur_ncorr="&v_dcur_ncorr&" "&vbcrlf&_ 
									" and a.fpot_ccod="&v_fpot_ccod&" "&vbcrlf&_
									" and a.epot_ccod in (2,3) "&vbcrlf&_
									" group by g.ddcu_mdescuento,a.empr_ncorr_empresa,d.dcur_ncorr,a.epot_ccod,d.dcur_tdesc,a.fpot_ccod,f.ocot_monto_empresa "&vbcrlf&_
									" order by c_comp_mdocumento desc "
			
			case "3"
			 	' Tipo persona: OTIC
				v_tipo_persona = "OTIC"
				sql_datos_postulante= 	" Select top 1 a.empr_ncorr_otic as pers_ncorr,d.dcur_ncorr,a.epot_ccod, "&vbcrlf&_
									" d.dcur_tdesc,sum(c.ofot_nmatricula)+sum(c.ofot_narancel) as c_arancel, "&vbcrlf&_
									" cast(sum(c.ofot_narancel)*(g.ddcu_mdescuento*0.01) as numeric) as spac_mdescuento, "&vbcrlf&_
									" cast(sum(c.ofot_narancel)*(g.ddcu_mdescuento*0.01) as numeric) as c_comp_mdescuento, "&vbcrlf&_
									" f.ocot_monto_otic as c_comp_mdocumento"&vbcrlf&_
									" from postulacion_otec a "&vbcrlf&_
									" join datos_generales_secciones_otec b "&vbcrlf&_
									" 	on a.empr_ncorr_otic="&v_pers_ncorr&" " &vbcrlf&_
									" 	and a.dgso_ncorr=b.dgso_ncorr "&vbcrlf&_
									" join ofertas_otec c "&vbcrlf&_
									" 	on b.dgso_ncorr=c.dgso_ncorr "&vbcrlf&_
									" join diplomados_cursos d "&vbcrlf&_
									" 	on c.dcur_ncorr=d.dcur_ncorr "&vbcrlf&_
									" join ordenes_compras_otec f "&vbcrlf&_
									" 	on a.dgso_ncorr=f.dgso_ncorr "&vbcrlf&_
									" 	and a.norc_otic=f.nord_compra "&vbcrlf&_
									"  and f.fpot_ccod="&v_fpot_ccod&" "&vbcrlf&_
									" "&sql_num_oc&" "&vbcrlf&_
									" left outer join descuentos_diplomados_curso g "&vbcrlf&_
									" 	on a.tdet_ccod=g.tdet_ccod  "&vbcrlf&_
									" 	and d.dcur_ncorr=g.dcur_ncorr "&vbcrlf&_		
									" where d.dcur_ncorr="&v_dcur_ncorr&" "&vbcrlf&_ 
									" and a.fpot_ccod="&v_fpot_ccod&" "&vbcrlf&_
									" and a.epot_ccod in (2,3) "&vbcrlf&_
									" group by g.ddcu_mdescuento,a.empr_ncorr_otic,d.dcur_ncorr,a.epot_ccod,d.dcur_tdesc,a.fpot_ccod,f.ocot_monto_otic "&vbcrlf&_
									" order by c_comp_mdocumento desc "
			end select
'response.Write("<pre>"&sql_datos_postulante&"</pre>")


set f_cargo_datos = new CFormulario
f_cargo_datos.Carga_Parametros "consulta.xml", "consulta"
f_cargo_datos.Inicializar conexion
f_cargo_datos.Consultar sql_datos_postulante
f_cargo_datos.SiguienteF
	' validacion de empresa
	if q_tipo_persona="2" or q_tipo_persona="3" then
'response.End()	
		v_comp_mdocumento 	= 	clng(f_cargo_datos.ObtenerValor("c_comp_mdocumento")) ' valor a pactar
		
		v_spac_monto 		= 	clng(f_cargo_datos.ObtenerValor("c_arancel")) ' valor total sin descuento
		v_comp_mdescuento 	= 	f_cargo_datos.ObtenerValor("c_comp_mdescuento")
		
		if(v_comp_mdescuento) then
			v_comp_mdescuento=clng(v_comp_mdescuento)
		end if
		' chequea si la empresa va a financiar el total del curso o no
'response.Write("Fianciado: "&v_monto_financiado&" Documento: "&v_comp_mdocumento)		
'response.Flush()

		if (clng(v_monto_financiado)<clng(v_comp_mdocumento)) then
					session("mensajeError")="El costo del programa OTEC "&clng(v_comp_mdocumento)&" selecionado es mayor al monto de financiamiento de la Empresa "&clng(v_monto_financiado)&".\nDebe corregir estos datos, no se acepta financiamiento compartido entre personas naturales y Empresas."
					response.Redirect(request.ServerVariables("HTTP_REFERER"))
		end if
	else
		v_comp_mdocumento 	= 	clng(f_cargo_datos.ObtenerValor("c_comp_mdocumento")) ' valor a pactar
		v_spac_monto 		= 	clng(f_cargo_datos.ObtenerValor("c_arancel")) ' valor total sin descuento
		v_comp_mdescuento 	= 	clng(f_cargo_datos.ObtenerValor("c_comp_mdescuento"))
	end if


	f_cargo.Consultar sql_datos_postulante
	

	f_cargo.AgregaCampoCons "c_tdet_ccod", v_tdet_ccod
	f_cargo.AgregaCampoCons "tdet_ccod", v_tdet_ccod
	f_cargo.AgregaCampoCons "spac_mneto", v_spac_monto
	f_cargo.AgregaCampoCons "spac_mdescuento", v_comp_mdescuento
	f_cargo.AgregaCampoCons "spac_mpactacion", v_comp_mdocumento
	f_cargo.AgregaCampoCons "pers_ncorr", v_pers_ncorr
	f_cargo.AgregaCampoCons "inst_ccod", v_inst_ccod
	f_cargo.AgregaCampoCons "tcom_ccod", v_tcom_ccod



else ' si ya se calculo
	pers_ncorr_codeudor = Request.QueryString("pers_ncorr_codeudor")
	consulta =  " select a.tcom_ccod, a.inst_ccod, a.comp_ndocto, a.pers_ncorr,tdet_mvalor_unitario as c_arancel, "&vbcrlf&_
				" tdet_tdesc as dcur_tdesc, spac_mneto as c_comp_mneto,a.tdet_ccod, "&vbcrlf&_
				" a.spac_mdescuento as spac_mdescuento,a.spac_mdescuento as c_comp_mdescuento, a.spac_mpactacion as c_comp_mdocumento,  "&vbcrlf&_
				" a.spac_mneto, a.spac_mdescuento, a.spac_mpactacion " & vbCrLf &_
	            " from sim_pactaciones a, tipos_detalle b  " & vbCrLf &_
				" where a.tdet_ccod=b.tdet_ccod  " & vbCrLf &_
				" and cast(a.comp_ndocto as varchar) = '" & q_comp_ndocto & "' "&vbcrlf&_
				" and cast(a.inst_ccod as varchar)= '" & q_inst_ccod & "' "&vbcrlf&_
				" and cast(a.tcom_ccod as varchar)= '" & q_tcom_ccod & "'"	
	'response.Write("<pre>" & consulta & "</pre>")		
	f_cargo.Consultar consulta
	
	v_comp_mdocumento = clng(conexion.ConsultaUno("select spac_mpactacion from sim_pactaciones where cast(comp_ndocto as varchar)= '" & q_comp_ndocto & "' and tcom_ccod=7"))   	
	q_pers_nrut = conexion.ConsultaUno("select pers_nrut from sim_pactaciones a, personas b where cast(a.comp_ndocto as varchar)= '" & q_comp_ndocto & "' and a.pers_ncorr=b.pers_ncorr")   	
	q_pers_xdv = conexion.ConsultaUno("select pers_xdv from sim_pactaciones a, personas b where cast(comp_ndocto as varchar)= '" & q_comp_ndocto & "' and a.pers_ncorr=b.pers_ncorr")   	
	nombre = conexion.consultauno("select pers_tnombre from personas where cast(pers_nrut as varchar) ='"&q_pers_nrut&"' and cast(pers_xdv as varchar) = '"&q_pers_xdv&"'")
select case q_tipo_persona
		case "1"
			v_tipo_persona="PERSONA"
	 	case "2" 
			v_tipo_persona="EMPRESA"		
		case "3"
			v_tipo_persona="OTIC"		 
end select
'response.Write("<hr> entro aca <hr>")

end if
	'response.End()

'----------------------------------------------------------------------------------------------------
set f_forma_pactacion = new CFormulario
f_forma_pactacion.Carga_Parametros "datos_otec.xml", "forma_pactacion"
f_forma_pactacion.Inicializar conexion

set f_consulta = new CFormulario
f_consulta.Carga_Parametros "consulta.xml", "consulta"
f_consulta.Inicializar conexion


if v_fpot_ccod="1" then
' si es persona natural, no lleva orden de compra
	sql_oc_variable="Select distinct tcom_ccod, ting_ccod   " & vbCrLf &_
					"From stipos_pagos a  where tcom_ccod = '1' "
else
' sino, solo sera a traves de una O.C:
	sql_oc_variable=" SELECT  1 as tcom_ccod,5 as ting_ccod "
end if


consulta = "select a.tcom_ccod, a.ting_ccod, a.ting_ccod as c_ting_ccod, b.comp_ndocto," & vbCrLf &_
			"        b.sfpa_mmonto, b.sfpa_ncuotas, b.sfpa_ndocto_inicial, b.sfpa_nfrecuencia," & vbCrLf &_
			"        b.sfpa_finicio_pago, b.banc_ccod, b.plaz_ccod, b.sfpa_tctacte," & vbCrLf &_
			"        isnull(b.pers_ncorr_codeudor, '" & pers_ncorr_codeudor & "') as pers_ncorr_codeudor," & vbCrLf &_
			"        ltrim(rtrim(" & vbCrLf &_
			"                    isnull(b.sfpa_mtasa_interes, isnull(c.tint_mtasa, 0))" & vbCrLf &_
			"            )) as sfpa_mtasa_interes," & vbCrLf &_
			"       case isnull(b.ting_ccod,0) " & vbCrLf &_
			"                when 0 then 'N'" & vbCrLf &_
			"                else 'S'" & vbCrLf &_
			"                end as butiliza" & vbCrLf &_
			"    from 	("&sql_oc_variable&")a, " & vbCrLf &_
			" 			sim_forma_pactaciones b,tasas_interes c" & vbCrLf &_
			"        where a.ting_ccod *= b.ting_ccod" & vbCrLf &_
			"            and a.ting_ccod *= c.ting_ccod" & vbCrLf &_
			"            and c.ttin_ccod = 1" & vbCrLf &_
			"            and c.peri_ccod = '" &v_peri_ccod & "'" & vbCrLf &_
			"            and cast(b.comp_ndocto as varchar) = '" & q_comp_ndocto & "'"
	

'response.Write("<pre>" & consulta & "</pre>")
'response.Flush()
 

f_forma_pactacion.Consultar consulta 
f_consulta.Consultar consulta

 
i_ = 0
while f_consulta.Siguiente	

	if f_consulta.ObtenerValor("ting_ccod") <> "3" then
		f_forma_pactacion.AgregaCampoFilaParam i_, "banc_ccod", "permiso", "LECTURA"
		f_forma_pactacion.AgregaCampoFilaParam i_, "plaz_ccod", "permiso", "LECTURA"
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_ndocto_inicial", "permiso", "LECTURA"
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_tctacte", "permiso", "LECTURA"
	end if
' Order de compra (solo para Empresas)
	if f_consulta.ObtenerValor("ting_ccod") = "5" then
		'f_forma_pactacion.AgregaCampoFilaParam i_, "banc_ccod", "permiso", "LECTURA"
		'f_forma_pactacion.AgregaCampoFilaParam i_, "plaz_ccod", "permiso", "LECTURA"
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_nfrecuencia", "deshabilitado", "TRUE"
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_ndocto_inicial", "permiso", "LECTURAESCRITURA"
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_mtasa_interes", "permiso", "LECTURA"
	end if	

	if f_consulta.ObtenerValor("ting_ccod") = "13" OR f_consulta.ObtenerValor("ting_ccod") = "51"  then
		'f_forma_pactacion.AgregaCampoFilaParam i_, "banc_ccod", "permiso", "LECTURA"
		'f_forma_pactacion.AgregaCampoFilaParam i_, "plaz_ccod", "permiso", "LECTURA"
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_ndocto_inicial", "permiso", "LECTURAESCRITURA"
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_tctacte", "permiso", "LECTURAESCRITURA"
	end if
	
	if f_consulta.ObtenerValor("ting_ccod") = "6" then
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_nfrecuencia", "permiso", "LECTURA"
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_finicio_pago", "soloLectura", "TRUE"
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_mtasa_interes", "permiso", "LECTURA"
	end if
	
	if f_consulta.ObtenerValor("butiliza") = f_forma_pactacion.ObtenerDescriptor("butiliza", "valorFalso") then
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_ncuotas", "deshabilitado", "TRUE"
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_mmonto", "deshabilitado", "TRUE"
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_finicio_pago", "deshabilitado", "TRUE"
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_nfrecuencia", "deshabilitado", "TRUE"
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_mmonto", "deshabilitado", "TRUE"
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_ndocto_inicial", "deshabilitado", "TRUE"
		f_forma_pactacion.AgregaCampoFilaParam i_, "banc_ccod", "deshabilitado", "TRUE"
		f_forma_pactacion.AgregaCampoFilaParam i_, "plaz_ccod", "deshabilitado", "TRUE"
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_mtasa_interes", "deshabilitado", "TRUE"
		f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_tctacte", "deshabilitado", "TRUE"
	end if	
	

	
	f_forma_pactacion.AgregaCampoFilaParam i_, "sfpa_ncuotas", "filtro", "tcom_ccod = '2' and ting_ccod = '" & f_consulta.ObtenerValor("ting_ccod") & "' and stpa_ncuotas > 0"
	i_ = i_ + 1
wend


'---------------------------------------------------------------------------------------------------------------------
set f_suma = new CFormulario
f_suma.Carga_Parametros "agregar_cargo_pactacion.xml", "suma"
f_suma.Inicializar conexion


if isnull(v_comp_mdocumento) or EsVacio(v_comp_mdocumento) then
	v_comp_mdocumento=0
end if	

if(v_comp_mdocumento) then
	 v_comp_mdocumento=clng(v_comp_mdocumento) 
else
	v_comp_mdocumento=0
end if
			
  
	consulta = "select isnull(sum(sfpa_mmonto), 0) as total_actual, isnull(" & v_comp_mdocumento & ", 0) as total_pactar," & vbCrLf &_
				"    isnull(sum(sfpa_mmonto), 0) - isnull(" & v_comp_mdocumento & ", 0) as diferencia," & vbCrLf &_
				"    convert(varchar,getdate(),103) as fecha_actual " & vbCrLf &_
				"from sim_forma_pactaciones a " & vbCrLf &_
				"where cast(comp_ndocto as varchar) = '" & q_comp_ndocto & "'"
	'response.Write("<pre>" & consulta & "</pre>")			
	f_suma.Consultar consulta
	'response.End()	

'#################################################################################	
'###################	RESULTADO DE LA SIMULACION  ##########################
'#################################################################################

'response.Flush()
'response.End() 

'---------------------------------------------------------------------------------------------------------------------
set f_detalles_pactacion = new CFormulario
f_detalles_pactacion.Carga_Parametros "agregar_cargo_pactacion.xml", "detalles_pactacion"
f_detalles_pactacion.Inicializar conexion


consulta = "select  comp_ndocto, sdpc_ncuota, sdpc_ncuota as c_sdpc_ncuota, ting_ccod," & vbCrLf &_
			" case ting_ccod " & vbCrLf &_
			"		when 3 then 'CHEQUE' " & vbCrLf &_
			"		when 4 then 'LETRA' " & vbCrLf &_
			"		when 5 then 'ORDEN DE COMPRA' " & vbCrLf &_
			"		when 6 then 'EFECTIVO' " & vbCrLf &_
			"		when 13 then 'CREDITO' " & vbCrLf &_
			"		when 51 then 'DEBITO' " & vbCrLf &_
			"		end as c_ting_ccod, " & vbCrLf &_
			"    sdpc_ndocumento, banc_ccod, plaz_ccod, sdpc_tctacte," & vbCrLf &_
			"    sdpc_femision, sdpc_fvencimiento, cast(sdpc_mmonto as numeric) as sdpc_mmonto,cast(sdpc_mmonto as numeric) as sdpc_mmonto_cuota" & vbCrLf &_
			"    from sim_detalles_pactacion" & vbCrLf &_
			"    where cast(comp_ndocto as varchar) = '" & q_comp_ndocto & "'" & vbCrLf &_
			"order by sdpc_ncuota,sdpc_fvencimiento,ting_ccod asc"
'response.Write("<pre>"&consulta&"</pre>")			
f_detalles_pactacion.Consultar consulta

f_consulta.Inicializar conexion
f_consulta.Consultar consulta


sql_total_det_pag = " Select sum(a.sdpc_mmonto) as total " & vbCrLf &_
            		" From sim_detalles_pactacion a " & vbCrLf &_
		    		" Where cast(a.comp_ndocto as varchar) = '" & q_comp_ndocto & "' " 
					
total_det_pag = conexion.consultaUno (sql_total_det_pag)

if 	EsVacio(total_det_pag) then
	total_det_pag=0
end if


i_ = 0
while f_consulta.Siguiente
	if f_consulta.ObtenerValor("ting_ccod") <> "3" then
		f_detalles_pactacion.AgregaCampoFilaParam i_, "sdpc_ndocumento", "permiso", "LECTURA"
		f_detalles_pactacion.AgregaCampoFilaParam i_, "banc_ccod", "permiso", "LECTURA"
		f_detalles_pactacion.AgregaCampoFilaParam i_, "plaz_ccod", "permiso", "LECTURA"
		f_detalles_pactacion.AgregaCampoFilaParam i_, "sdpc_tctacte", "permiso", "LECTURA"
	end if

	if f_consulta.ObtenerValor("ting_ccod") = "5"  then
		'f_forma_pactacion.AgregaCampoFilaParam i_, "banc_ccod", "permiso", "LECTURA"
		'f_forma_pactacion.AgregaCampoFilaParam i_, "plaz_ccod", "permiso", "LECTURA"
		f_detalles_pactacion.AgregaCampoFilaParam i_, "sdpc_ndocumento", "permiso", "LECTURAESCRITURA"
		f_detalles_pactacion.AgregaCampoFilaParam i_, "sdpc_fvencimiento", "permiso","LECTURAESCRITURA"
		'f_detalles_pactacion.AgregaCampoFilaParam i_, "sdpc_tctacte", "permiso", "LECTURAESCRITURA"
	end if	

	if f_consulta.ObtenerValor("ting_ccod") = "13" OR f_consulta.ObtenerValor("ting_ccod") = "51"  then
		'f_forma_pactacion.AgregaCampoFilaParam i_, "banc_ccod", "permiso", "LECTURA"
		'f_forma_pactacion.AgregaCampoFilaParam i_, "plaz_ccod", "permiso", "LECTURA"
		f_detalles_pactacion.AgregaCampoFilaParam i_, "sdpc_ndocumento", "permiso", "LECTURA"
		f_detalles_pactacion.AgregaCampoFilaParam i_, "sdpc_tctacte", "permiso", "LECTURA"
	end if
	
	if f_consulta.ObtenerValor("ting_ccod") = "4" or f_consulta.ObtenerValor("ting_ccod") = "3" then
		f_detalles_pactacion.AgregaCampoFilaParam i_, "sdpc_mmonto_cuota", "permiso","LECTURAESCRITURA"
		'f_detalles_repactacion.AgregaCampoFilaParam i_, "sdrp_monto_oculto", "permiso","LECTURAESCRITURA"
		f_detalles_pactacion.AgregaCampoFilaParam i_, "sdpc_fvencimiento", "permiso","LECTURAESCRITURA"
		f_detalles_pactacion.AgregaCampoFilaParam i_, "sdpc_fvencimiento", "id","FE-N"
	end if

	i_ = i_ + 1
wend

'-------------------------------------------------------------------------------------
if f_detalles_pactacion.NroFilas = 0 then
	v_filas_simulacion=0
	f_botonera.AgregaBotonParam "aceptar_pactacion", "deshabilitado", "TRUE"
else
	v_filas_simulacion=f_detalles_pactacion.NroFilas
end if

'#################################################################################	
'###################	FIN RESULTADO DE LA SIMULACION  ##########################
'#################################################################################

%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<style type="text/css">
input.suma {
background-color:#D8D8DE;
border:0;
text-align:left;
}
</style>

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
var t_forma_pactacion;
var t_alt_forma_pactacion;
var t_suma;
var t_alt_suma;



function ValidarPactacion()
{
	var suma_actual = t_forma_pactacion.SumarColumna("sfpa_mmonto");
	

	if ((t_forma_pactacion.ObtenerValor(0, "sfpa_ncuotas")>1)&&(t_forma_pactacion.ObtenerValor(0, "ting_ccod")==5)) {
	//alert();
		alert('El N° de cuotas no puede ser mayor que "1" para la Orden de Compra');
		t_forma_pactacion.filas[0].campos["sfpa_ncuotas"].objeto.focus();
		return false;
	}

	if (suma_actual != t_suma.ObtenerValor(0, "total_pactar")) {
		alert('El monto a pactar debe ser igual a ' + t_alt_suma.ObtenerValor(0, "total_pactar"));
		t_alt_suma.filas[0].campos["total_actual"].objeto.focus();
		return false;
	}
	

	
	for (var i = 0; i < t_forma_pactacion.filas.length; i++) {
		if ( (t_forma_pactacion.ObtenerValor(i, "butiliza") == 'S') && (t_forma_pactacion.ObtenerValor(i, "sfpa_mmonto") <= 0) ) {
			alert('Si va a utilizar esta forma de pago, monto debe ser mayor que $0.')
			t_alt_forma_pactacion.filas[i].campos["sfpa_mmonto"].objeto.focus();
			return false;
		}
	}
	
	
	for (var i = 0; i < t_forma_pactacion.filas.length; i++) {
		if ( (t_forma_pactacion.ObtenerValor(i, "butiliza") == 'S') && (t_forma_pactacion.ObtenerValor(i, "sfpa_mtasa_interes") < 0) ) {
			alert('Porcentaje de interés no puede ser negativo.');
			t_forma_pactacion.filas[i].campos["sfpa_mtasa_interes"].objeto.select();
			return false;
		}
	}
	
	for (var i = 0; i < t_forma_pactacion.filas.length; i++) {
		if ( (t_forma_pactacion.ObtenerValor(i, "butiliza") == 'S') && (t_forma_pactacion.ObtenerValor(i, "ting_ccod") == 6) ) {
			t_forma_pactacion.filas[i].campos["sfpa_ncuotas"].objeto.value=1;
			t_forma_pactacion.filas[i].campos["sfpa_ncuotas"].objeto.select();
		}
		if ( (t_forma_pactacion.ObtenerValor(i, "butiliza") == 'S') && (t_forma_pactacion.ObtenerValor(i, "ting_ccod") == 51) ) {
			t_forma_pactacion.filas[i].campos["sfpa_ncuotas"].objeto.value=1;
			t_forma_pactacion.filas[i].campos["sfpa_ncuotas"].objeto.select();
		}
	
	}
	
	return true;
}


function HabilitarFila(p_fila, p_habilitado)
{
	
	t_forma_pactacion.filas[p_fila].Habilitar(p_habilitado);
	t_alt_forma_pactacion.filas[p_fila].campos["sfpa_mmonto"].objeto.setAttribute("disabled", !p_habilitado);	
	
	if (p_habilitado) {
		t_forma_pactacion.filas[p_fila].campos["sfpa_mmonto"].objeto.value = t_suma.ObtenerValor(0, "diferencia") * -1;
		t_forma_pactacion.filas[p_fila].campos["sfpa_finicio_pago"].objeto.value = t_suma.ObtenerValor(0, "fecha_actual");
		t_forma_pactacion.AsignarValor(p_fila, "sfpa_nfrecuencia", '1');
		if (t_forma_pactacion.filas[p_fila].campos["ting_ccod"].objeto.value==6 ){
			t_forma_pactacion.AsignarValor(p_fila, "sfpa_ncuotas", '1');
		}
		if (t_forma_pactacion.filas[p_fila].campos["ting_ccod"].objeto.value==51 ){
			t_forma_pactacion.AsignarValor(p_fila, "sfpa_ncuotas", '1');
		}
		if (t_forma_pactacion.filas[p_fila].campos["ting_ccod"].objeto.value==5 ){
			t_forma_pactacion.AsignarValor(p_fila, "sfpa_ncuotas", '1');
			t_forma_pactacion.AsignarValor(p_fila, "sfpa_ndocto_inicial", pactacion.num_oc.value);
		}
	}
	else {		
		t_forma_pactacion.filas[p_fila].campos["sfpa_mmonto"].objeto.value = '0';
		t_forma_pactacion.filas[p_fila].campos["sfpa_finicio_pago"].objeto.value = '';		
		t_forma_pactacion.AsignarValor(p_fila, "sfpa_nfrecuencia", '');
	}
	enMascara(t_alt_forma_pactacion.filas[p_fila].campos["sfpa_mmonto"].objeto, "MONEDA", 0);		
	sfpa_mmonto_blur(t_alt_forma_pactacion.filas[p_fila].campos["sfpa_mmonto"].objeto);	
}



function sfpa_mmonto_blur(objeto)
{
	t_suma.AsignarValor(0, "total_actual", t_forma_pactacion.SumarColumna("sfpa_mmonto"));
	t_suma.AsignarValor(0, "diferencia", t_forma_pactacion.SumarColumna("sfpa_mmonto") - t_suma.ObtenerValor(0, "total_pactar"));
	
	t_alt_suma.filas[0].campos["total_actual"].objeto.focus(); t_alt_suma.filas[0].campos["total_actual"].objeto.blur();
	t_alt_suma.filas[0].campos["diferencia"].objeto.focus(); t_alt_suma.filas[0].campos["diferencia"].objeto.blur();
}



function butiliza_click(objeto)
{
	HabilitarFila(_FilaCampo(objeto), objeto.checked);
}




function InicioPagina()
{
	t_forma_pactacion = new CTabla("forma_pactacion");
	t_alt_forma_pactacion = new CTabla("_forma_pactacion");	

	t_suma = new CTabla("suma");
	t_alt_suma = new CTabla("_suma");
	
	t_alt_suma.filas[0].campos["total_actual"].objeto.className = 'suma';
	t_alt_suma.filas[0].campos["total_pactar"].objeto.className = 'suma';
	t_alt_suma.filas[0].campos["diferencia"].objeto.className = 'suma';
}



function ValidarCuotasPago()
{
var formulario = document.forms["detalle_pactacion"];
suma_cuotas = 0;
total_cuotas = <%=total_det_pag%>;
//alert("objeto:"+formulario.elements["detalles_repactacion[0][c_ting_ccod]"]);
for (var i = 0; i < <%=v_filas_simulacion%>; i++) {
//alert("entro a validar:"+i);
		if ((formulario.elements["detalles_pactacion[" +i + "][ting_ccod]"].value==3) || (formulario.elements["detalles_pactacion[" +i + "][ting_ccod]"].value==4) ) 
			{
			//alert("entro a sumar")
			suma_cuotas += parseInt(formulario.elements["detalles_pactacion[" +i + "][sdpc_mmonto_cuota]"].value);
			//valor_aux_01 = parseInt(formulario.elements["detalle_pagos[" +i + "][sdpa_mmonto]"].value);
			formulario.elements["detalles_pactacion[" +i + "][sdpc_mmonto]"].value=parseInt(formulario.elements["detalles_pactacion[" +i + "][sdpc_mmonto_cuota]"].value);
			//alert("valor edit "+i+" - "+valor_aux_01)	
			}else{
			suma_cuotas += parseInt(formulario.elements["detalles_pactacion[" +i + "][sdpc_mmonto]"].value);
			//valor_aux = parseInt(formulario.elements["detalle_pagos[" +i + "][c_sdpa_mmonto]"].value);
			//alert("valor NO edit "+i+" - "+valor_aux)	
			}
		//alert("arancel "+total_arancel);
	}
//alert("suma "+suma_cuotas)	

	if	(total_cuotas == suma_cuotas){
		return true;
	}
	
	if	(total_cuotas > suma_cuotas){
		alert ("El monto de las cuotas de los documentos es inferior a lo que se debe documentar.");
	}else{
		alert ("El monto de las cuotas de los documentos excede a lo que se debe documentar.");
	}
		
	return false;
}


</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
<table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
<tr>
    <td valign="top" bgcolor="#EAEAEA">	  <br>
	<table width="100%"  border="0" align="left" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><br>
              <table width="96%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="10%"><strong>Rut</strong></td>
								<td width="2%"><strong>:</strong></td>
								<td width="88%"><%=q_pers_nrut&"-"&q_pers_xdv%></td>
							</tr>
							<tr>
								<td><strong>Nombre</strong></td>
								<td><strong>:</strong></td>
								<td><%=nombre%></td>
							</tr>
							<tr>
								<td><strong>Entidad</strong></td>
								<td><strong>:</strong></td>
								<td><%=v_tipo_persona%></td>
							</tr>
					  </table>
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>
					
					<form name="pactacion">
					<input type="hidden" name="num_oc" value="<%=v_num_oc%>" >
					<input type="hidden" name="q_tipo_persona" value="<%=q_tipo_persona%>">
					<input type="hidden" name="dgso_ncorr" value="<%=v_dgso_ncorr%>">
					<input type="hidden" name="fpot_ccod" value="<%=v_fpot_ccod%>">

                    <%pagina.DibujarSubtitulo "Ítem Otec"%>                      
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center"><%f_cargo.DibujaTabla%></div></td>
                        </tr>
                      </table>
                      <br>                      <br>
                      <%pagina.DibujarSubtitulo "Forma de pago"%>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="center">
                              <%f_forma_pactacion.DibujaTabla%>
                          </div></td>
                        </tr>
                        <tr>
                          <td><br>
                            <%f_suma.DibujaRegistro%></td></tr>
                        <tr>
                          <td><div align="right"><%f_botonera.DibujaBoton("calcular")%></div></td>
                        </tr>
                      </table>
	              </form>
                  
				<form name="detalle_pactacion">
					<input type="hidden" name="pers_ncorr" value="<%=pers_ncorr_codeudor%>">	
					<input type="hidden" name="dgso_ncorr" value="<%=v_dgso_ncorr%>">
					<input type="hidden" name="fpot_ccod" value="<%=v_fpot_ccod%>">
					<input type="hidden" name="num_oc" value="<%=v_num_oc%>" >
					<input type="hidden" name="q_tipo_persona" value="<%=q_tipo_persona%>">

                        <%pagina.DibujarSubtitulo "Detalle de pago"%>
                        <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                          <tr>
                            <td><div align="center">
                                <%f_detalles_pactacion.DibujaTabla%>
                            </div></td>
                          </tr>
                        </table>                
                        
                      </form>                      <br>
					  
					  
					  
					  </td>
                  </tr>
                </table>
                          <br>
</td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="23%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                            <%f_botonera.DibujaBoton("aceptar_pactacion")%>
                          </div></td>
                  <td><div align="center">
					<% f_botonera.agregabotonparam "anterior", "url", "contratacion_otec.asp?busqueda[0][pers_nrut]="&q_pers_nrut&"&busqueda[0][pers_xdv]="&q_pers_xdv&"&busqueda[0][tipo_persona]="&q_tipo_persona
						f_botonera.DibujaBoton "anterior"  %>

                  </div></td>
                  </tr>
              </table>
            </div></td>
            <td width="77%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
