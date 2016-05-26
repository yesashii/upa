<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body topmargin="0" onUnload="cerrar_pagina()">
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file	=	"../biblioteca/funciones_formateo.asp" -->
<%

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()


q_nota_credito	=	request.Querystring("nota_credito")
q_pers_ncorr	=	request.Querystring("pers_ncorr")
q_ndcr_ncorr 	= 	request.querystring("ndcr_ncorr")
q_origen 		= 	request.querystring("origen")


c_pago= "CONTADO"


set conectar	= new cconexion
conectar.inicializar	"upacifico"

set negocio		= new cnegocio
negocio.inicializa		conectar

v_estado		=	conectar.ConsultaUno("select encr_ccod from notas_de_credito where ndcr_ncorr="&q_ndcr_ncorr)


set tabla_usos		= new cformulario
tabla_usos.inicializar		conectar
tabla_usos.carga_parametros	"consulta.xml","consulta"

sql_usos= 	"select '* '+uncr_tdesc+' ($'+cast(cast(dunc_mmonto_asociado as numeric) as varchar)+')' as uso  "& vbCrLf &_
			"from notas_de_credito a, detalle_uso_nota_credito b, uso_nota_credito c "& vbCrLf &_
			"where a.ndcr_ncorr=b.ndcr_ncorr "& vbCrLf &_
			"and b.uncr_ccod=c.uncr_ccod "& vbCrLf &_
			"and a.ndcr_nnota_credito="&q_nota_credito
'response.Write("<pre>"&sql_usos&"</pre>")
tabla_usos.consultar sql_usos



set f_datos_empresa		= new cformulario
f_datos_empresa.Carga_Parametros "consulta.xml", "consulta"

sql_consulta_empresa= 	" Select a.*, c.ciud_tdesc as comuna, c.ciud_tcomuna as ciudad, protic.obtener_nombre_completo(a.pers_ncorr,'n') as razon_social,"& vbCrLf &_
						"protic.obtener_direccion(a.pers_ncorr,1,'CNC') as direccion"& vbCrLf &_
						" from personas a, direcciones b, ciudades c "& vbCrLf &_
						" Where cast(a.pers_ncorr as varchar)= '"&q_pers_ncorr&"' "& vbCrLf &_
						"   and a.pers_ncorr=b.pers_ncorr "& vbCrLf &_
						"   and b.tdir_ccod=1 "& vbCrLf &_
						" 	and b.ciud_ccod*=c.ciud_ccod "


'response.Write("<pre>"&sql_consulta_empresa&"</pre>")


f_datos_empresa.inicializar		conectar
f_datos_empresa.consultar sql_consulta_empresa
f_datos_empresa.siguienteF

rut				=	f_datos_empresa.obtenerValor("pers_nrut")
dv				=	f_datos_empresa.obtenerValor("pers_xdv")
giro			=	f_datos_empresa.obtenerValor("pers_tgiro")
razon_social	=	f_datos_empresa.obtenerValor("razon_social")
direccion1		=	f_datos_empresa.obtenerValor("direccion")
ciud_ccod		=	f_datos_empresa.obtenerValor("ciud_ccod")
c_pago			=	f_datos_empresa.obtenerValor("c_pago")
telefono		=	f_datos_empresa.obtenerValor("pers_tfono")
nro				=	f_datos_empresa.obtenerValor("dire_tnro")
comuna			=	f_datos_empresa.obtenerValor("comuna")
ciudad			=	f_datos_empresa.obtenerValor("ciudad")

'_____________________________________________________________________________
'response.End()
'response.Flush() 
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
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & space(5)&Ac1(dia,2,"I")&space(7)&Ac1(mes,15,"I")& space(10)&Ac1(agno,4,"I")& chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & space(5)&Ac1(sin_acentos(razon_social),80,"I") &space(20) &chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & space(5) & Ac1(sin_acentos(direccion1)&" "&nro,40,"I") & space(5) & Ac1(comuna,20,"I")& space(10) & Ac1(telefono,10,"I") &chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & space(5) & Ac1(ciudad,40,"I")  & space(35)  & Ac1(rut&"-"&dv,11,"I")& chr(13) & chr(10)   
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & space(3) & Ac1(sin_acentos(giro),50,"I")& space(30)  & Ac1(sin_acentos(c_pago),15,"I")  &chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)


'	consulta_i= " Select isnull(cast(protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ding_ndocto') as varchar),'') as docto, "& vbCrLf &_
'					" dd.tdet_ccod, dc.tcom_ccod as codigo, dc.COMP_NDOCTO nro_documento, "& vbCrLf &_
'					"    convert(varchar,dc.DCOM_FCOMPROMISO,103) fecha_vencimiento, "& vbCrLf &_
'					" 'CURSO: '+(Select top 1 a1.tdet_tdesc from tipos_detalle a1 where a1.tdet_ccod=dd.tdet_ccod) as concepto, "& vbCrLf &_
'					" cast(SUM(ab.ABON_MABONO) as numeric) total,cast(SUM(ab.ABON_MABONO) as numeric) abono, "& vbCrLf &_
'					"    upper(ti.ting_tdesc) as ting_tdesc "& vbCrLf &_
'					"    from ingresos ii,abonos ab,compromisos cp,detalle_compromisos dc,tipos_compromisos tc, "& vbCrLf &_
'					"        detalles dd,tipos_detalle td,tipos_ingresos ti "& vbCrLf &_
'					"    where ii.ingr_ncorr = ab.ingr_ncorr "& vbCrLf &_
'					"        and ii.ingr_nfolio_referencia in (select folio_abono_factura from facturas where fact_nfactura="&q_nota_credito&" and tfac_ccod="&q_tfac_ccod&") "& vbCrLf &_
'					"        and ii.ting_ccod = '12' "& vbCrLf &_
'					"        and ab.tcom_ccod = dc.tcom_ccod "& vbCrLf &_
'					"        and ab.inst_ccod = dc.inst_ccod "& vbCrLf &_
'					"        and ab.comp_ndocto = dc.comp_ndocto  "& vbCrLf &_
'					"        and ab.dcom_ncompromiso = dc.dcom_ncompromiso "& vbCrLf &_
'					"        and dc.tcom_ccod = tc.tcom_ccod "& vbCrLf &_
'					"        and dc.tcom_ccod = dd.tcom_ccod "& vbCrLf &_
'					"        and dc.inst_ccod = dd.inst_ccod "& vbCrLf &_
'					"        and dc.comp_ndocto = dd.comp_ndocto "& vbCrLf &_
'					"        and dd.tdet_ccod = td.tdet_ccod "& vbCrLf &_
'					"        and dc.comp_ndocto=cp.comp_ndocto "& vbCrLf &_
'					"        and dc.tcom_ccod=cp.tcom_ccod "& vbCrLf &_
'					"        and case isnull(dd.tdet_ccod,0) when 0 then dc.tcom_ccod else td.tcom_ccod end = dc.tcom_ccod "& vbCrLf &_
'					"        and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ting_ccod') *= ti.ting_ccod "& vbCrLf &_
'					" GROUP BY dd.tdet_ccod, td.tcom_ccod, dc.tcom_ccod, dc.COMP_NDOCTO,dc.DCOM_FCOMPROMISO,tc.tcom_tdesc, ti.ting_tdesc,dc.tcom_ccod, dc.inst_ccod, dc.dcom_ncompromiso, td.tdet_tdesc "

			consulta_i= "Select *,e.tdet_tdesc as concepto,b.dncr_mdetalle as abono,b.dncr_mdetalle as total,isnull(ndcr_miva,0) as monto_iva, "& vbCrLf &_
						" isnull(cast(protic.documento_asociado_cuota(c.tcom_ccod, c.inst_ccod, c.comp_ndocto, c.dcom_ncompromiso, 'ding_ndocto') as varchar),'') as docto, "& vbCrLf &_
						"  isnull((select ting_tipos_softland from tipos_ingresos where ting_ccod=isnull(cast(protic.documento_asociado_cuota(c.tcom_ccod, c.inst_ccod, c.comp_ndocto, c.dcom_ncompromiso, 'ting_ccod') as varchar),0)),'')as tipo"& vbCrLf &_
						" from notas_de_credito a, detalle_notas_de_credito b, detalle_compromisos c, detalles d, tipos_detalle e "& vbCrLf &_
						" Where cast(a.pers_ncorr as varchar)= '"&q_pers_ncorr&"'  "& vbCrLf &_
						"    and a.ndcr_ncorr=b.ndcr_ncorr "& vbCrLf &_
						" 	and b.tcom_ccod=c.tcom_ccod "& vbCrLf &_
						"    and b.comp_ndocto=c.comp_ndocto  "& vbCrLf &_
						" 	and b.inst_ccod=c.inst_ccod  "& vbCrLf &_
						" 	and b.dcom_ncompromiso=c.dcom_ncompromiso "& vbCrLf &_
						"    and c.tcom_ccod=d.tcom_ccod "& vbCrLf &_
						"    and c.comp_ndocto=d.comp_ndocto "& vbCrLf &_
						"    and c.inst_ccod=d.inst_ccod "& vbCrLf &_
						"    and d.tdet_ccod=e.tdet_ccod "& vbCrLf &_
						"	 and d.deta_ncantidad>=0 "& vbCrLf &_
						"    and a.ndcr_nnota_credito="&q_nota_credito

'response.Write("<pre>"&consulta_i&"</pre>")
'response.Flush()

		set tabla_i		= new cformulario
		tabla_i.inicializar		conectar
		tabla_i.carga_parametros	"consulta.xml","consulta"
		tabla_i.consultar consulta_i

		if tabla_i.nroFilas > 0 then
			for k=0 to tabla_i.nroFilas-1
				tabla_i.siguiente

				docto		= 	tabla_i.obtenerValor("docto")
				tipo_docto	= 	tabla_i.obtenerValor("tipo")
				concepto	= 	sin_acentos(tabla_i.obtenerValor("concepto"))
				cuota		= 	1
				abono		=	clng(tabla_i.obtenerValor("abono"))
				total		= 	total+clng(tabla_i.obtenerValor("total"))
				monto_iva	= 	clng(tabla_i.obtenerValor("monto_iva"))
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
					archivo = archivo & space(0)&space(0)&Ac1(cuota,5,"D")&space(5)&Ac1(concepto,50,"I")&space(20)& Ac1(formatcurrency(abono,0,-1,0,-1),12,"D")& chr(13) &  chr(10)
				else
					archivo = archivo & space(0)&space(0)&Ac1(cuota,5,"D")&space(5)&Ac1(concepto,50,"I")&space(20)& Ac1(formatcurrency(abono,0,-1,0,-1),12,"D")& chr(13) &  chr(10)
					'archivo = archivo & space(0)&Ac1(docto,8,"I")&space(1)&Ac1(tipo_docto,8,"I")&space(4)&Ac1(cuota,5,"D")&space(5)&Ac1(concepto,30,"I")&space(15)& Ac1(formatcurrency(abono,0,-1,0,-1),11,"D")& chr(13) &  chr(10)
				end if
				filas=filas+1
			next
		end if
		archivo = archivo & chr(13) & chr(10)
		archivo = archivo & chr(13) & chr(10)
		if tabla_usos.nroFilas > 0 then
			for k=0 to tabla_usos.nroFilas-1
				tabla_usos.siguiente
				v_uso=tabla_usos.obtenerValor("uso")
				archivo = archivo &space(10)& Ac1(v_uso,100,"I")& chr(13) &  chr(10) 
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
		'filas=1

		
		FOR i=1 to 10 - filas
			archivo =  archivo & chr(13) &  chr(10)
		next
	   	for j=0 to 3
			archivo =  archivo & chr(13) &  chr(10)
	   	next
	  	for j=0 to 3
			archivo =  archivo & chr(13) &  chr(10)
	   	next
		
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)		
	   archivo = archivo &space(10)& Ac1(Traduce_numero(total,10),100,"I") 
	   '********   NRO A PALABRAS ************************
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)

	   if monto_iva>0 then
	   		monto_afecto=total-monto_iva
		   	archivo = archivo & chr(13) & chr(10)
			archivo = archivo &space(40)&space(40) & Ac1(formatcurrency(monto_afecto,0,-1,0,-1),12,"D") & chr(13) & chr(10)
			archivo = archivo &space(40)&space(40) & Ac1(formatcurrency(monto_iva,0,-1,0,-1),12,"D") & chr(13) & chr(10)
	   else
		   	archivo = archivo &space(40)&space(40) & Ac1(formatcurrency(total,0,-1,0,-1),12,"D") & chr(13) & chr(10)
		   	archivo = archivo & chr(13) & chr(10)
		   	archivo = archivo & chr(13) & chr(10)
	   	 	archivo = archivo & chr(13) & chr(10)
	   end if
	   		
	   archivo = archivo &space(40)&space(40) & Ac1(formatcurrency(total,0,-1,0,-1),12,"D") & chr(13) & chr(10)
	   '********   TOTALIZAR ************************
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) 

response.Write("<pre>" & archivo & "</pre>")
response.Flush()	
response.Write("</td></tr></table>")
'--------------------------------------------------------------------------------------				
 
%>

<script language="javascript1.1">
window.print();
</script>
<script language="javascript1.1">

function cerrar_pagina(){
mensaje="Se ha impreso correctamente la Nota de Credito ??";
var estado='<%=v_estado%>';
	if ((estado!='2') && (estado!='3')){
		if (confirm(mensaje)){
			window.opener.location.href="./proc_cierra_nota_credito.asp?cod_nota_credito=<%=q_ndcr_ncorr%>&origen=<%=q_origen%>";
		}else{
			url_ventana="../ver_notas_credito.asp?busqueda[0][ndcr_nnota_credito]=<%=q_nota_credito%>";
			window.open(url_ventana,"ventana_maneja"," scrollbar=yes,resizeable=yes");
			window.opener.close();
		}
	}
	
}
</script>

</body>
</html>

