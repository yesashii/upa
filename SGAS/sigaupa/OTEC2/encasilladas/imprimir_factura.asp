<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body topmargin="0" onUnload="">
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file="../biblioteca/funciones_formateo.asp" -->
<%

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()


q_fact_nfactura	=	request.Querystring("factura")
q_pers_ncorr	=	request.Querystring("pers_ncorr")
q_tfac_ccod		= 	request.Querystring("tipo_factura")

c_pago= "CONTADO"


set conectar	= new cconexion
conectar.inicializar	"upacifico"

set negocio		= new cnegocio
negocio.inicializa		conectar


		set f_datos_empresa		= new cformulario
		f_datos_empresa.Carga_Parametros "parametros.xml", "tabla"
		
		sql_consulta_empresa= 	" Select a.*, c.ciud_tdesc as comuna, c.ciud_tcomuna as ciudad from empresas a, ciudades c "& vbCrLf &_
							  	" Where empr_ncorr="&q_pers_ncorr&" "& vbCrLf &_
								" 	and a.ciud_ccod*=c.ciud_ccod "


'response.Write("<pre>"&sql_consulta_empresa&"</pre>")
'response.Flush()

		f_datos_empresa.inicializar		conectar
		f_datos_empresa.consultar sql_consulta_empresa
'response.Write("<hr>empr_nrut: "& f_datos_empresa.obtenerValor("comuna"))
		f_datos_empresa.siguienteF

		rut				=	f_datos_empresa.obtenerValor("empr_nrut")
		dv				=	f_datos_empresa.obtenerValor("empr_xdv")
		giro			=	f_datos_empresa.obtenerValor("empr_tgiro")
		razon_social	=	f_datos_empresa.obtenerValor("empr_trazon_social")
		direccion1		=	f_datos_empresa.obtenerValor("empr_tdireccion")
		ciud_ccod		=	f_datos_empresa.obtenerValor("ciud_ccod")
		c_pago			=	f_datos_empresa.obtenerValor("c_pago")
		telefono		=	f_datos_empresa.obtenerValor("empr_tfono")
		nro				=	f_datos_empresa.obtenerValor("dire_tnro")
		comuna			=	f_datos_empresa.obtenerValor("comuna")
		ciudad			=	f_datos_empresa.obtenerValor("ciudad")
'_____________________________________________________________________________

'response.Write("<hr>Giro: "& f_datos_empresa.obtenerValor("comuna"))


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
response.Write("<table border=0 ><tr><td>")
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
	   archivo = archivo & space(0)&Ac1(dia,2,"I")&space(7)&Ac1(mes,15,"I")& space(2)&Ac1(agno,4,"I")& chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & space(0)&Ac1(sin_acentos(razon_social),60,"I") &space(40) &chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & space(0) & Ac1(sin_acentos(direccion1)&" "&nro,40,"I") & space(5) & Ac1(comuna,20,"I")& space(5) & Ac1(telefono,10,"I") &chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & space(0) & Ac1(ciudad,20,"I")  & space(50)  & Ac1(rut&"-"&dv,11,"I")& chr(13) & chr(10)   
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & space(0) & Ac1(sin_acentos(giro),50,"I")& space(20)  & Ac1(sin_acentos(c_pago),15,"I")  &chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)


	consulta_i= " Select isnull(cast(protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ding_ndocto') as varchar),'') as docto, "& vbCrLf &_
					" dd.tdet_ccod, dc.tcom_ccod as codigo, dc.COMP_NDOCTO nro_documento, "& vbCrLf &_
					"    convert(varchar,dc.DCOM_FCOMPROMISO,103) fecha_vencimiento, "& vbCrLf &_
					" case when dc.tcom_ccod=25 or dc.tcom_ccod=5 or dc.tcom_ccod=4 then "& vbCrLf &_
					" (Select top 1 a1.tdet_tdesc from tipos_detalle a1,detalles a2 "& vbCrLf &_ 
					" where a2.tcom_ccod=dc.tcom_ccod and a2.inst_ccod=dc.inst_ccod "& vbCrLf &_
					" and a2.comp_ndocto=dc.comp_ndocto and a1.tdet_ccod=a2.tdet_ccod) "& vbCrLf &_
					" when dc.tcom_ccod=37 then "& vbCrLf &_
					"    tc.tcom_tdesc "& vbCrLf &_
					" else  "& vbCrLf &_
					"    tc.tcom_tdesc "& vbCrLf &_
					" end concepto,  "& vbCrLf &_
					" cast(SUM(ab.ABON_MABONO) as numeric) total,cast(SUM(ab.ABON_MABONO) as numeric) abono, "& vbCrLf &_
					"    upper(ti.ting_tdesc) as ting_tdesc "& vbCrLf &_
					"    from ingresos ii,abonos ab,compromisos cp,detalle_compromisos dc,tipos_compromisos tc, "& vbCrLf &_
					"        detalles dd,tipos_detalle td,tipos_ingresos ti "& vbCrLf &_
					"    where ii.ingr_ncorr = ab.ingr_ncorr "& vbCrLf &_
					"        and ii.ingr_nfolio_referencia in (select folio_abono_factura from facturas where fact_nfactura="&q_fact_nfactura&" and tfac_ccod="&q_tfac_ccod&") "& vbCrLf &_
					"        and ii.ting_ccod = '12' "& vbCrLf &_
					"        and ab.tcom_ccod = dc.tcom_ccod "& vbCrLf &_
					"        and ab.inst_ccod = dc.inst_ccod "& vbCrLf &_
					"        and ab.comp_ndocto = dc.comp_ndocto  "& vbCrLf &_
					"        and ab.dcom_ncompromiso = dc.dcom_ncompromiso "& vbCrLf &_
					"        and dc.tcom_ccod = tc.tcom_ccod "& vbCrLf &_
					"        and dc.tcom_ccod = dd.tcom_ccod "& vbCrLf &_
					"        and dc.inst_ccod = dd.inst_ccod "& vbCrLf &_
					"        and dc.comp_ndocto = dd.comp_ndocto "& vbCrLf &_
					"        and dd.tdet_ccod = td.tdet_ccod "& vbCrLf &_
					"        and dc.comp_ndocto=cp.comp_ndocto "& vbCrLf &_
					"        and dc.tcom_ccod=cp.tcom_ccod "& vbCrLf &_
					"        and case isnull(dd.tdet_ccod,0) when 0 then dc.tcom_ccod else td.tcom_ccod end = dc.tcom_ccod "& vbCrLf &_
					"        and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ting_ccod') *= ti.ting_ccod "& vbCrLf &_
					" GROUP BY dd.tdet_ccod, td.tcom_ccod, dc.tcom_ccod, dc.COMP_NDOCTO,dc.DCOM_FCOMPROMISO,tc.tcom_tdesc, ti.ting_tdesc,dc.tcom_ccod, dc.inst_ccod, dc.dcom_ncompromiso, td.tdet_tdesc "

'response.Write("<pre>"&consulta_i&"</pre>")
'response.Flush()

		set tabla_i		= new cformulario
		tabla_i.inicializar		conectar
		tabla_i.carga_parametros	"paulo.xml","tabla"
		tabla_i.consultar consulta_i

		if tabla_i.nroFilas > 0 then
			for k=0 to tabla_i.nroFilas-1
				tabla_i.siguiente

				docto		= 	tabla_i.obtenerValor("docto")
				concepto	= 	sin_acentos(tabla_i.obtenerValor("concepto"))
				'cuota		= 	tabla_i.obtenerValor("cuota")
				cuota		= 	1
				abono		=	clng(tabla_i.obtenerValor("abono"))
				'abono		=	0
				total		= 	total+clng(tabla_i.obtenerValor("total"))
				'intereses	=	clng(tabla_i.obtenerValor("intereses"))
				'multas		=	clng(tabla_i.obtenerValor("multas"))
				'm_anticipado=	clng(tabla_i.obtenerValor("m_anticipado"))
				intereses	=	0
				multas		=	0
				m_anticipado=	0
				
				suma=0
				if m_anticipado > 0 and multas > 0 and intereses > 0 then
					suma=3
				elseif (m_anticipado > 0 and multas > 0 )or (intereses > 0 and multas > 0 ) or (m_anticipado > 0 and intereses > 0) then
					suma=2
					elseif m_anticipado > 0 or multas > 0 or intereses > 0 then
					suma = 1
				end if
				if abono > 999 then
					archivo = archivo & space(0)&Ac1(docto,8,"I")&space(5)&Ac1(cuota,5,"D")&space(5)&Ac1(concepto,30,"I")&space(15)& Ac1(formatcurrency(abono,0,-1,0,-1),12,"D")& chr(13) &  chr(10)
				else
					archivo = archivo & space(0)&Ac1(docto,8,"I")&space(5)&Ac1(cuota,5,"D")&space(5)&Ac1(concepto,30,"I")&space(15)& Ac1(formatcurrency(abono,0,-1,0,-1),11,"D")& chr(13) &  chr(10)
				end if
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
		for kk=1 to 3-suma
			archivo =  archivo & chr(13) &  chr(10)
		next

		'filas=clng(conectar.consultauno("select count(*) from abonos where ingr_ncorr in ("& array_ingr_ncorr &") "))
		filas=1

		FOR i=1 to 10 - filas
			archivo =  archivo & chr(13) &  chr(10)
		next
	   for j=0 to 3
			archivo =  archivo & chr(13) &  chr(10)
	   next
			'archivo =  archivo  &space(10)& Ac1("PAGO POR CUENTA ALUMNO: "&alumno,180,"I") & chr(13) &  chr(10)
	  for j=0 to 3
			archivo =  archivo & chr(13) &  chr(10)
	   next
	   archivo = archivo &space(20) &Ac1("TOTAL",5,"I")&space(43) & Ac1(formatcurrency(total,0,-1,0,-1),12,"I") & chr(13) & chr(10)
	   '********   NRO A PALABRAS ************************
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)

	   
	   archivo = archivo &space(10)& Ac1(Traduce_numero(total,10),100,"I") 
	   '********   NRO A PALABRAS ************************
   
			
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) 

response.Write("<pre>" & archivo & "</pre>")
response.Flush()	
response.Write("</td></tr></table>")
'--------------------------------------------------------------------------------------				

 
%>

<script language="javascript1.1">
//window.print();
</script>

</body>
</html>

