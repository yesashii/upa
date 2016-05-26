<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<title>Facturacion</title>
<body topmargin="0">
<table width="90%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td width="25" height="24" background="../imagenes/borde_superior.jpg"><img width="25" height="24" src="../imagenes/superior_izquierda.jpg"></td>
		<td width="400" height="24" background="../imagenes/borde_superior.jpg">&nbsp;</td>
	    <td width="29" height="24"><img width="29" height="24" src="../imagenes/superior_derecha.jpg"></td>
	</tr>
	<tr>		
		<td width="25" background="../imagenes/lado_izquierda.jpg" align="right">&nbsp;</td>
		<td bgcolor="#FFFFFF" >
<!-- #include file	= 	"../biblioteca/_negocio.asp" -->
<!-- #include file	=	"../biblioteca/_conexion.asp" -->
<!-- #include file	=	"../biblioteca/funciones_formateo.asp" -->
<%

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()


q_dgso_ncorr	=	request.Querystring("dgso_ncorr")
q_pers_nrut		=	request.Querystring("pers_nrut")
q_tipo			=	request.Querystring("tipo")
q_origen		=	request.Querystring("origen")

c_pago= "30 Dias"


set conectar	= new cconexion
conectar.inicializar	"upacifico"


'********************************************************************************************************************
sql_cambio_anio=	"select (year(dgso_ftermino)- year(dgso_finicio)) as diferencia "& vbcrlf &_
					" from datos_generales_secciones_otec "& vbcrlf &_
					" where dgso_ncorr="&q_dgso_ncorr

v_cambio_anio = conectar.consultaUno(sql_cambio_anio) 

if v_cambio_anio=1 and (q_tipo="3" or  q_tipo="4") then
	response.Write("Este programa se extiende a lo largo de 2 años, por lo tanto,se crearan 2 facturas en caso que sea financiado con Otic <br/>")
end if


set f_cargo = new CFormulario
f_cargo.Carga_Parametros "datos_otec.xml", "cargo"
f_cargo.Inicializar conectar

if q_origen =2 then  'Despues de contratar

	select case q_tipo
											 
			case "2"
			'Empresa  despues de contratado
				sql_extra=" and a.empr_ncorr_empresa=e.pers_ncorr "
				
				sql_datos_postulante= 	" Select a.dgso_ncorr,count(a.pers_ncorr) as alumnos,a.empr_ncorr_empresa as pers_ncorr, "&vbcrlf&_
									" d.dcur_ncorr,a.epot_ccod,d.dcur_tdesc,a.fpot_ccod, isnull(d.tdet_ccod,1281) as tdet_ccod, "&vbcrlf&_
									" ocot_monto_empresa as financia,nord_compra as num_oc "&vbcrlf&_
									" from postulacion_otec a, datos_generales_secciones_otec b ,  "&vbcrlf&_
									" ofertas_otec c , diplomados_cursos d, personas e, ordenes_compras_otec f,postulantes_cargos_otec g "&vbcrlf&_
									" where cast(e.pers_nrut as varchar)='"&q_pers_nrut&"' "&vbcrlf&_
									" and a.empr_ncorr_empresa=e.pers_ncorr "&vbcrlf&_
									" and a.pote_ncorr =g.pote_ncorr "&vbcrlf&_
									" and a.dgso_ncorr="&q_dgso_ncorr&"  " & vbCrLf &_ 
									" and g.tipo_institucion =2 "&vbcrlf&_
									" and a.dgso_ncorr=b.dgso_ncorr "&vbcrlf&_
									" and b.dgso_ncorr=c.dgso_ncorr "&vbcrlf&_
									" and c.dcur_ncorr=d.dcur_ncorr "&vbcrlf&_
									" and a.dgso_ncorr=f.dgso_ncorr "&vbcrlf&_
									" and case when a.fpot_ccod=4 then norc_otic else a.norc_empresa end=f.nord_compra "&vbcrlf&_
									" and a.epot_ccod in (2,3,4) "&vbcrlf&_
									" and a.empr_ncorr_empresa=case when a.fpot_ccod=4 then f.empr_ncorr_2 else f.empr_ncorr end "&vbcrlf&_
									" group by a.dgso_ncorr,ocot_monto_empresa,ocot_monto_otic,a.empr_ncorr_empresa,d.dcur_ncorr,a.epot_ccod,d.dcur_tdesc,a.fpot_ccod,d.tdet_ccod,nord_compra "
		case "4"
			'Otic despues de contratado
				sql_extra=" and a.empr_ncorr_otic=e.pers_ncorr "
							
				sql_datos_postulante= 	" Select a.dgso_ncorr,count(a.pers_ncorr) as alumnos,a.empr_ncorr_otic as pers_ncorr, "&vbcrlf&_
									" d.dcur_ncorr,a.epot_ccod,d.dcur_tdesc,a.fpot_ccod, isnull(d.tdet_ccod,1281) as tdet_ccod, "&vbcrlf&_
									" ocot_monto_otic as financia,nord_compra as num_oc "&vbcrlf&_
									" from postulacion_otec a, datos_generales_secciones_otec b ,  "&vbcrlf&_
									" ofertas_otec c , diplomados_cursos d, personas e,ordenes_compras_otec f ,postulantes_cargos_otec g "&vbcrlf&_
									" where cast(e.pers_nrut as varchar)='"&q_pers_nrut&"' "&vbcrlf&_
									" and a.empr_ncorr_otic=e.pers_ncorr "&vbcrlf&_
									" and a.pote_ncorr =g.pote_ncorr "&vbcrlf&_
									" and a.dgso_ncorr="&q_dgso_ncorr&"  " & vbCrLf &_ 
									" and g.tipo_institucion =3 "&vbcrlf&_
									" and a.dgso_ncorr=b.dgso_ncorr "&vbcrlf&_
									" and b.dgso_ncorr=c.dgso_ncorr "&vbcrlf&_
									" and c.dcur_ncorr=d.dcur_ncorr "&vbcrlf&_
									" and a.dgso_ncorr=f.dgso_ncorr "&vbcrlf&_
									" and a.norc_otic=f.nord_compra "&vbcrlf&_
									" and a.epot_ccod in (2,3,4) "&vbcrlf&_
									" and a.empr_ncorr_otic=f.empr_ncorr "&vbcrlf&_
									" group by a.dgso_ncorr,ocot_monto_empresa,ocot_monto_otic,a.empr_ncorr_otic,d.dcur_ncorr,a.epot_ccod,d.dcur_tdesc,a.fpot_ccod,d.tdet_ccod,nord_compra "
	
		end select
else

	select case q_tipo
									 
			case "2"
			'Empresa
			sql_extra=" and a.empr_ncorr_empresa=e.pers_ncorr "
			
			sql_datos_postulante= 	" Select a.dgso_ncorr,count(a.pers_ncorr) as alumnos,a.empr_ncorr_empresa as pers_ncorr, "&vbcrlf&_
								" d.dcur_ncorr,a.epot_ccod,d.dcur_tdesc,a.fpot_ccod, isnull(d.tdet_ccod,1281) as tdet_ccod, "&vbcrlf&_
								" ocot_monto_empresa as financia,nord_compra as num_oc "&vbcrlf&_
								" from postulacion_otec a, datos_generales_secciones_otec b ,  "&vbcrlf&_
								" ofertas_otec c , diplomados_cursos d, personas e, ordenes_compras_otec f "&vbcrlf&_
								" where cast(e.pers_nrut as varchar)='"&q_pers_nrut&"' "&vbcrlf&_
								" and a.empr_ncorr_empresa=e.pers_ncorr "&vbcrlf&_
								" and a.dgso_ncorr="&q_dgso_ncorr&"  " & vbCrLf &_ 
								" and a.dgso_ncorr=b.dgso_ncorr "&vbcrlf&_
								" and b.dgso_ncorr=c.dgso_ncorr "&vbcrlf&_
								" and c.dcur_ncorr=d.dcur_ncorr "&vbcrlf&_
								" and a.dgso_ncorr=f.dgso_ncorr "&vbcrlf&_
								" and case when a.fpot_ccod=4 then norc_otic else a.norc_empresa end=f.nord_compra "&vbcrlf&_
								" and a.epot_ccod in (2,3) "&vbcrlf&_
								" and a.empr_ncorr_empresa=case when a.fpot_ccod=4 then f.empr_ncorr_2 else f.empr_ncorr end "&vbcrlf&_
								" group by a.dgso_ncorr,ocot_monto_empresa,ocot_monto_otic,a.empr_ncorr_empresa,d.dcur_ncorr,a.epot_ccod,d.dcur_tdesc,a.fpot_ccod,d.tdet_ccod,nord_compra "

			case "3"
			'Otic antes de contratar
			sql_extra=" and a.empr_ncorr_otic=e.pers_ncorr "
			
			sql_datos_postulante= 	" Select a.dgso_ncorr,count(a.pers_ncorr) as alumnos,a.empr_ncorr_otic as pers_ncorr, "&vbcrlf&_
								" d.dcur_ncorr,a.epot_ccod,d.dcur_tdesc,a.fpot_ccod, isnull(d.tdet_ccod,1281) as tdet_ccod, "&vbcrlf&_
								" ocot_monto_otic as financia,nord_compra as num_oc "&vbcrlf&_
								" from postulacion_otec a, datos_generales_secciones_otec b ,  "&vbcrlf&_
								" ofertas_otec c , diplomados_cursos d, personas e,ordenes_compras_otec f "&vbcrlf&_
								" where cast(e.pers_nrut as varchar)='"&q_pers_nrut&"' "&vbcrlf&_
								" and a.empr_ncorr_otic=e.pers_ncorr "&vbcrlf&_
								" and a.dgso_ncorr="&q_dgso_ncorr&"  " & vbCrLf &_ 
								" and a.dgso_ncorr=b.dgso_ncorr "&vbcrlf&_
								" and b.dgso_ncorr=c.dgso_ncorr "&vbcrlf&_
								" and c.dcur_ncorr=d.dcur_ncorr "&vbcrlf&_
								" and c.dcur_ncorr=d.dcur_ncorr "&vbcrlf&_
								" and a.dgso_ncorr=f.dgso_ncorr "&vbcrlf&_
								" and a.norc_otic=f.nord_compra "&vbcrlf&_
								" and a.epot_ccod in (2,3) "&vbcrlf&_
								" and a.empr_ncorr_empresa=case when a.fpot_ccod=4 then f.empr_ncorr_2 else f.empr_ncorr end "&vbcrlf&_
								" group by a.dgso_ncorr,ocot_monto_empresa,ocot_monto_otic,a.empr_ncorr_otic,d.dcur_ncorr,a.epot_ccod,d.dcur_tdesc,a.fpot_ccod,d.tdet_ccod,nord_compra "

		end select

end if
'response.Write("<pre>"&sql_datos_postulante&"</pre>")
'response.End()
f_cargo.Consultar sql_datos_postulante
f_cargo.siguienteF



v_num_oc	=	f_cargo.obtenerValor("num_oc")
v_tdet_ccod	=	f_cargo.obtenerValor("tdet_ccod")

'********************************************************************************************************************
sql_tipo_fac=" select tbol_ccod " &_
				" from tipos_detalle  " &_
				" where tdet_ccod="&v_tdet_ccod 
'response.Write("<pre>"&sql_tipo_fac&"</pre>")				
'response.End()
q_tfac_ccod=conectar.consultaUno(sql_tipo_fac)

'******************************************************************************************

set f_listado_alumnos	= new cformulario
f_listado_alumnos.Carga_Parametros "consulta.xml", "consulta"

sql_alumnos =" select protic.obtener_rut(a.pers_ncorr)as rut, "& vbCrLf &_
			" protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre "& vbCrLf &_
			" from postulacion_otec a, personas b "& vbCrLf &_
			" where a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
			" and a.pote_ncorr in (select pote_ncorr "& vbCrLf &_
			"		from postulacion_otec a, datos_generales_secciones_otec b ,"& vbCrLf &_      
			"		  ofertas_otec c , diplomados_cursos d, personas e,ordenes_compras_otec f  "& vbCrLf &_ 
			"		  where e.pers_ncorr in (select top 1 pers_ncorr from personas where pers_nrut="&q_pers_nrut&") "& vbCrLf &_  
			"		  and a.dgso_ncorr="&q_dgso_ncorr&" "& vbCrLf &_    
			"  "&sql_extra&"  " & vbCrLf &_    
			"		  and a.dgso_ncorr=b.dgso_ncorr  "& vbCrLf &_   
			"		  and b.dgso_ncorr=c.dgso_ncorr  "& vbCrLf &_  
			"		  and c.dcur_ncorr=d.dcur_ncorr  "& vbCrLf &_ 
			"		  and a.dgso_ncorr=f.dgso_ncorr  "& vbCrLf &_
			"		  and case when a.fpot_ccod=4 then norc_otic else a.norc_empresa end=f.nord_compra  "& vbCrLf &_ 
			"		  and f.nord_compra="&v_num_oc&"  "& vbCrLf &_    
			"		  and a.epot_ccod in (2,3,4))   "

f_listado_alumnos.inicializar conectar
f_listado_alumnos.consultar sql_alumnos

'response.Write("<pre>"&sql_alumnos&"</pre>")

'response.End()
'******************************************************************************************

set f_datos_otec	= new cformulario
f_datos_otec.Carga_Parametros "consulta.xml", "consulta"

sql_datos_otec =" select case when dcur_nombre_sence is null or len(dcur_nombre_sence)=0 then dcur_tdesc else dcur_nombre_sence end as programa,sede_tdesc as sede,b.DCUR_NSENCE as cod_sense,b.dcur_nro_registro_sence as num_sence, "& vbCrLf &_
				" 'INICIO:'+protic.trunc(dgso_finicio)+' TERMINO:'+protic.trunc(dgso_ftermino) as duracion_programa, "& vbCrLf &_
				" (select sum(maot_nhoras_programa) from mallas_otec mo where mo.dcur_ncorr=b.dcur_ncorr group by mo.dcur_ncorr) as n_horas "& vbCrLf &_
				" from datos_generales_secciones_otec a,  diplomados_cursos b, sedes c "& vbCrLf &_
				" where a.dcur_ncorr=b.dcur_ncorr "& vbCrLf &_
				" and a.sede_ccod=c.sede_ccod "& vbCrLf &_
				" and cast(a.dgso_ncorr as varchar)='"&q_dgso_ncorr&"'"

'response.Write("<pre>"&sql_datos_otec&"</pre>")

f_datos_otec.inicializar conectar
f_datos_otec.consultar sql_datos_otec

'******************************************************************************************


		total		=	clng(f_cargo.obtenerValor("financia"))
		v_monto_neto=	clng(total*0.81)
		v_monto_iva	=	total-v_monto_neto
		
		
'******************************************************************************************
		set f_datos_empresa		= new cformulario
		f_datos_empresa.Carga_Parametros "consulta.xml", "consulta"
		
		sql_consulta_empresa= 	" Select a.*, c.ciud_tdesc as comuna, c.ciud_tcomuna as ciudad from empresas a, ciudades c "& vbCrLf &_
							  	" Where empr_ncorr in (select top 1 pers_ncorr from personas where pers_nrut="&q_pers_nrut&") "& vbCrLf &_
								" 	and a.ciud_ccod*=c.ciud_ccod "


		f_datos_empresa.inicializar		conectar
		f_datos_empresa.consultar sql_consulta_empresa
		f_datos_empresa.siguienteF

		rut				=	f_datos_empresa.obtenerValor("empr_nrut")
		dv				=	f_datos_empresa.obtenerValor("empr_xdv")
		giro			=	f_datos_empresa.obtenerValor("empr_tgiro")
		razon_social	=	f_datos_empresa.obtenerValor("empr_trazon_social")
		direccion1		=	f_datos_empresa.obtenerValor("empr_tdireccion")
		ciud_ccod		=	f_datos_empresa.obtenerValor("ciud_ccod")
		telefono		=	f_datos_empresa.obtenerValor("empr_tfono")
		nro				=	f_datos_empresa.obtenerValor("dire_tnro")
		comuna			=	f_datos_empresa.obtenerValor("comuna")
		ciudad			=	f_datos_empresa.obtenerValor("ciudad")
'_____________________________________________________________________________

dia		=	conectar.consultauno("select day(getdate())")
mes		=	conectar.consultauno("select mes_tdesc from meses where mes_ccod=month(getdate())")
agno	=	conectar.consultauno("select year(getdate())")

'------------------------------------- FUNCION DE IMPRESION --------------------------------------
	  function Ac1(texto,ancho,alineado)
		largo =Len(Trim(texto))
		if isNull(largo) then
			largo=0
		end if
		if largo > ancho then largo=ancho
		if ucase(alineado) = "D" then 
		   Ac1=space(ancho-cint(largo))&Left(texto,largo)
		else
		   Ac1=Left(texto,largo)&space(ancho-largo)
		end if   
	  end function

'------------------------------------ FIN FUNCION DE IMPRESION -------------------------------------				
'	   archivo = archivo &space(80)&Ac1("",40,"I")
	   archivo = archivo & chr(13) & chr(10)
   	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10) 
	   archivo = archivo & chr(13) & chr(10) 
	   archivo = archivo & chr(13) & chr(10) 
	   archivo = archivo & chr(13) & chr(10) 
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & space(2)&Ac1(dia,2,"I")&space(7)&Ac1(mes,15,"I")& space(11)&Ac1(agno,4,"I")& chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & space(2)&Ac1(sin_acentos(razon_social),60,"I") &space(1) &chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & space(2) & Ac1(sin_acentos(direccion1)&" "&nro,38,"I") & space(9) & Ac1(comuna,20,"I")& space(9) & Ac1(telefono,7,"I") &chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & space(2) & Ac1(ciudad,41,"I")  & space(35)  & Ac1(rut&"-"&dv,11,"I")& chr(13) & chr(10)   
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & space(7) & Ac1(sin_acentos(giro),50,"I")& space(21)  & Ac1(sin_acentos(c_pago),10,"I")  &chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)


		concepto	= 	"CURSO/DIPLOMADO"
		cuota		= 	1
		abono		=	total
		total		= 	total
		intereses	=	0
		multas		=	0
		m_anticipado=	0
				
		archivo = archivo & space(2)&Ac1(cuota,5,"I")&space(5)&Ac1(concepto,30,"I")&space(35)& Ac1(formatcurrency(abono,0,-1,0,-1),11,"D")& chr(13) &  chr(10)
		archivo = archivo & chr(13) & chr(10)
		
		if v_oc_asociada <>"" then
			archivo = archivo &chr(13)&chr(10)&space(10)&Ac1(v_oc_asociada,30,"I")&space(15)& chr(13) &  chr(10)
		end if

		if f_datos_otec.nroFilas > 0 then
		f_datos_otec.siguiente
			programa	= 	f_datos_otec.obtenerValor("programa")
			duracion	= 	f_datos_otec.obtenerValor("duracion_programa")
			cod_sense	= 	f_datos_otec.obtenerValor("cod_sense")
			num_horas	= 	f_datos_otec.obtenerValor("n_horas")
			num_sense	= 	f_datos_otec.obtenerValor("num_sense")
			
			archivo = archivo & space(10)&Ac1("Nombre:"&programa,60,"I")&space(5)& chr(13) &  chr(10)
			archivo = archivo & space(10)&Ac1("Duracion:"&duracion,50,"I")&space(5)& chr(13) &  chr(10)
			archivo = archivo & space(10)&Ac1("Cod Sence:"&cod_sense,35,"I")&space(5)& chr(13) &  chr(10)
			archivo = archivo & space(10)&Ac1("N° Sence:"&num_sense,35,"I")&space(5)& chr(13) &  chr(10)
			archivo = archivo & space(10)&Ac1("N° Horas:"&num_horas,35,"I")&space(5)& chr(13) &  chr(10)

		end if


		v_nro_alumnos = f_listado_alumnos.nroFilas
		if v_nro_alumnos>15 then
			response.Write("<br>El numero de alumnos excede al maximo posible por factura (15)<br> Se creara por tanto una factura por cada 15 alumnos")
		end if	
		
				
		
		if v_nro_alumnos > 0 then
			v_monto_alumno	= Clng(total/v_nro_alumnos)
			'v_monto_alumno	=total
			archivo = archivo &chr(13)&chr(10)&space(20)&Ac1("Listado de Alumnos",30,"I")&space(1)& chr(13) &  chr(10)
			archivo = archivo & space(10)&space(5)&Ac1("RUT",10,"I")&space(2)&Ac1("NOMBRE",30,"I")&space(1)& chr(13) &  chr(10)
			
			for k=0 to f_listado_alumnos.nroFilas-1
				f_listado_alumnos.siguiente
				rut		= 	f_listado_alumnos.obtenerValor("rut")
				nombre	= 	f_listado_alumnos.obtenerValor("nombre")
				archivo = 	archivo & space(5)&space(5)&Ac1(rut,10,"I")&space(2)&Ac1(nombre,35,"I")&space(10)& Ac1(formatcurrency(v_monto_alumno,0,-1,0,-1),11,"D")&chr(13)&chr(10)
				filas	=	filas+1
			next
			
		end if
		
		if m_anticipado > 0 then
			archivo=archivo &space(0)& Ac1("PAGO ANTICIPADO",20,"I")&space(15)&Ac1(formatcurrency(m_anticipado,0,-1,0,-1),11,"D")& chr(13) &  chr(10)
		end if
	
		if intereses >0 then
			archivo=archivo &space(0)& Ac1("INTERESES",20,"I")&space(15)&Ac1(formatcurrency(intereses,0,-1,0,-1),11,"D")& chr(13) &  chr(10)
		else
			archivo=archivo& chr(13) &  chr(10)
		end if
		if multas > 0 then
			archivo=archivo &space(0)& Ac1("MULTAS",20,"I")&space(15)&Ac1(formatcurrency(multas,0,-1,0,-1),11,"D")& chr(13) &  chr(10)
		else
			archivo=archivo& chr(13) &  chr(10)
		end if


		FOR i=1 to 19 - filas
			archivo =  archivo & chr(13) &  chr(10)
		next

		
   
	   archivo = archivo &space(10)& Ac1(Traduce_numero(total,10),79,"I") 
	   '********   NRO A PALABRAS ************************
	   
	   	for kk=1 to 3
			archivo =  archivo & chr(13) &  chr(10)
		next
		
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	  ' archivo = archivo & chr(13) & chr(10)
	  ' archivo = archivo & chr(13) & chr(10)
	   	
   	if q_tfac_ccod="1" then
	   archivo = archivo &space(20)&space(58) & Ac1(formatcurrency(v_monto_neto,0,-1,0,-1),11,"D") & chr(13) & chr(10)
   	   archivo = archivo &chr(13) & chr(10)
	   archivo = archivo &space(20)&space(58) & Ac1(formatcurrency(v_monto_iva,0,-1,0,-1),11,"D") & chr(13) & chr(10)
   	   archivo = archivo &chr(13) & chr(10)
   	   archivo = archivo &space(20)&space(58) & Ac1(formatcurrency(total,0,-1,0,-1),11,"D") & chr(13) & chr(10)
   	else
	   archivo = archivo &space(20)&space(58) & Ac1(formatcurrency(total,0,-1,0,-1),11,"D") & chr(13) & chr(10)
	end if	   
	   '********   TOTALIZAR ************************
	   archivo = archivo & chr(13) & chr(10)
	'   archivo = archivo & chr(13) 

response.Write("<pre>" & archivo & "</pre>")
response.Flush()	

'--------------------------------------------------------------------------------------				

%>
		</td>
	    <td width="29" background="../imagenes/lado_derecha.gif"></td>
	</tr>
	<tr>
		<td width="25" height="27" background="../imagenes/borde_inferior.jpg"><img width="25" height="27" src="../imagenes/inferior_izquierda.jpg"></td>
		<td width="400" height="27" background="../imagenes/borde_inferior.jpg">&nbsp;</td>
		<td width="29" height="27"><img width="29" height="27" src="../imagenes/inferior_derecha.jpg"></td>
	</tr>
</table>
</body>
</html>

