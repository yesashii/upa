<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file="../biblioteca/funciones_formateo.asp" -->
<%

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

rut				=	request.Form("f[0][rut]")
dv				=	request.Form("f[0][dv]")
giro			=	request.Form("f[0][pers_tgiro]")
razon_social	=	request.Form("f[0][pers_trazon_social]")
direccion1		=	request.Form("f[0][dire_tcalle]")
ciud_ccod		=	request.Form("f[0][ciud_ccod]")
c_pago			=	request.Form("f[0][c_pago]")
telefono		=	request.Form("f[0][pers_tfono]")
n_factura		=	request.form("ingr_nfolio_referencia")
ingr_ncorr 		= 	request.form("ingr_ncorr")
impresora		=	request.form("ip[0][impr_truta]")
nro				=	request.Form("f[0][dire_tnro]")
set tabla_i		= new cformulario
set conectar	= new cconexion
set negocio		= new cnegocio
set perso		= new cformulario
set domicilio	= new cformulario
set factura		= new cformulario


session("impresora")	=	impresora

conectar.inicializar	"desauas"
tabla_i.inicializar		conectar
negocio.inicializa		conectar
factura.inicializar		conectar

perso.inicializar		conectar
domicilio.inicializar	conectar

perso.carga_parametros		"factura.xml" , "persona"
domicilio.carga_parametros	"factura.xml" , "direccion"	
factura.carga_parametros	"factura.xml" , "agregar_factura"	

perso.procesaform
domicilio.procesaform
factura.procesaform

pers_ncorr	=	conectar.consultauno("select pers_ncorr from personas where pers_nrut = '"& rut &"'")

pers_tnombre	=	conectar.consultauno("select pers_tnombre from personas where pers_nrut = '"& rut &"'")
pers_tape_paterno	=	conectar.consultauno("select pers_tape_paterno from personas where pers_nrut = '"& rut &"'")
pers_tape_materno	=	conectar.consultauno("select pers_tape_materno from personas where pers_nrut = '"& rut &"'")


dfac_ncorr	=	conectar.consultauno("select dfac_ncorr_seq.nextval from dual")

if pers_ncorr = "" then
	pers_ncorr	=	conectar.consultauno("select pers_ncorr_seq.nextval from dual")
end if


pers_ncorr_alumno	=	conectar.consultauno("select pers_ncorr from ingresos where ingr_ncorr='"& ingr_ncorr &"'")


perso.agregacampopost		"pers_ncorr"			, pers_ncorr
perso.agregacampopost		"pers_nrut"				, rut
perso.agregacampopost		"pers_xdv"				, dv

if pers_tape_paterno = "" or isnull(pers_tape_paterno) then
	perso.agregacampopost		"pers_tape_paterno"		, " "
	perso.agregacampopost		"pers_tape_materno"		, " "
	perso.agregacampopost		"pers_tnombre"			, " "
else
	perso.agregacampopost		"pers_tape_paterno"		, pers_tape_paterno
	perso.agregacampopost		"pers_tape_materno"		, pers_tape_materno
	perso.agregacampopost		"pers_tnombre"			, pers_tnombre
end if

p	=	perso.mantienetablas		(false)

domicilio.agregacampopost	"pers_ncorr"			, pers_ncorr
domicilio.agregacampopost	"tdir_ccod"				, 1
	
d	=	domicilio.mantienetablas	(false)


factura.agregacampopost		"dfac_ncorr"			,	dfac_ncorr
factura.agregacampopost		"pers_ncorr_factura"	,	pers_ncorr
factura.agregacampopost		"pers_ncorr_alumno"		,	pers_ncorr_alumno
factura.agregacampopost		"dfac_rut_empresa"		,	rut
factura.agregacampopost		"dfac_xdv"				,	dv
factura.agregacampopost		"dfac_trazon_social"	,	razon_social
factura.agregacampopost		"dfac_tgiro"			,	giro
factura.agregacampopost		"dfac_tdireccion"		,	direccion1
factura.agregacampopost		"dfac_ciud_ccod"		,	ciud_ccod
factura.agregacampopost		"dfac_tfono"			,	telefono
factura.agregacampopost		"ingr_ncorr"			,	ingr_ncorr
factura.agregacampopost		"dfac_tnro"				,	nro
factura.agregacampopost		"dfac_nfactura"			,	n_factura

f	=	factura.mantienetablas		(false)

'RESPONSE.Write("<H1>pers: "&P&"<br> Fac: "&F&"<br> Dom: "&D&"</H1>")

tabla_i.carga_parametros	"paulo.xml","tabla"

dia		=	conectar.consultauno("select to_char(sysdate,'dd') from dual")

mes		=	conectar.consultauno("select decode(to_char(sysdate,'mm'),'01','ENERO','02','FEBRERO','03','MARZO','04','ABRIL','05','MAYO','06','JUNIO','07','JULIO','08','AGOSTO','09','SEPTIEMBRE','10','OCTUBRE','11','NOVIEMBRE','12','DICIEMBRE',to_char(sysdate,'mm')) from dual")

agno	=	conectar.consultauno("select to_char(sysdate,'YYYY') from dual")

sede	=	negocio.obtenernombresede

pers_ncorr_alumno	=	conectar.consultauno("select pers_ncorr from ingresos where ingr_ncorr = '"& ingr_ncorr &"'")

alumno		=	conectar.consultauno("select pers_nrut||'-'||pers_xdv||'    '||pers_tape_paterno||' '||pers_tape_materno||', '|| pers_tnombre as alumno from personas where pers_ncorr='"& pers_ncorr_alumno &"'")

comuna	=conectar.consultauno("select ciud_tdesc||'-'||ciud_tcomuna from ciudades where ciud_ccod='"& ciud_ccod &"'")


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

	   Set oFile      = CreateObject("Scripting.FileSystemObject")
	   archivo = archivo &space(90)&Ac1("",32,"I")
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
	   archivo = archivo & space(18)&Ac1(sin_acentos(sede),15,"I")&space(5)&Ac1(dia,2,"I")&space(7)&Ac1(mes,15,"I")& space(2)&Ac1(agno,4,"I")& chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & space(20)&Ac1(sin_acentos(razon_social),50,"I") &space(50) & Ac1(rut&" - "&dv,15,"I") &chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & space(20) & Ac1(sin_acentos(direccion1)&" "&nro,99,"I") & space(1) & Ac1(comuna,22,"I") &chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & space(20) & Ac1(sin_acentos(giro),50,"I")  & space(50) & Ac1(telefono,15,"I") &chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & space(28) & Ac1(sin_acentos(c_pago),50,"I")  &chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   
	   consulta_i = "select a.tcom_ccod as codigo, " &_
					 "       a.comp_ndocto as docto, " &_
					 "  	 b.tcom_tdesc as concepto, " &_
					 "  	 c.dcom_ncompromiso as cuota,d.ingr_mtotal as total, " &_
						"	   nvl(ingr_mintereses,0) as intereses, " &_
						"	   nvl(ingr_mmultas,0) as multas, " &_
						"	   nvl(ingr_manticipado,0) as m_anticipado, " &_
						"  decode(decode(a.abon_mabono - c.dcom_mcompromiso," &_
   						" 0,0, " &_
				        "(a.abon_mabono - c.dcom_mcompromiso) / abs(a.abon_mabono - c.dcom_mcompromiso)), " &_
			            "0,a.abon_mabono, " &_
			            "1,c.dcom_mcompromiso, " &_
			            "-1,a.abon_mabono) as abono " &_						
						"from abonos a, tipos_compromisos b, detalle_compromisos c,ingresos d " &_
						"where a.tcom_ccod=b.tcom_ccod and " &_
						"	  a.tcom_ccod = c.tcom_ccod and " &_
						"	  a.inst_ccod = c.inst_ccod and " &_
						"	  a.comp_ndocto = c.comp_ndocto and " &_
						"	  a.dcom_ncompromiso = c.dcom_ncompromiso and " &_
						"	  a.ingr_ncorr=d.ingr_ncorr and  " & _
						"	  a.ingr_ncorr='" & ingr_ncorr & "' " &_
						"order by a.comp_ndocto asc, a.dcom_ncompromiso asc"
						
			consulta_i = "select a.tcom_ccod as codigo, " &_
					 "       a.comp_ndocto as docto, " &_
					 "  	 b.tcom_tdesc as concepto, " &_
					 "  	 c.dcom_ncompromiso as cuota,d.ingr_mtotal as total, " &_
						"	   nvl(ingr_mintereses,0) as intereses, " &_
						"	   nvl(ingr_mmultas,0) as multas, " &_
						"	   nvl(ingr_manticipado,0) as m_anticipado, " &_
						"	   least(abon_mabono, dcom_mcompromiso - nvl(dcom_mconvenio, 0) - nvl(dcom_mbeca,0) - nvl(dcom_mdescuento,0)) as abono " &_
						"from abonos a, tipos_compromisos b, detalle_compromisos c,ingresos d " &_
						"where a.tcom_ccod=b.tcom_ccod and " &_
						"	  a.tcom_ccod = c.tcom_ccod and " &_
						"	  a.inst_ccod = c.inst_ccod and " &_
						"	  a.comp_ndocto = c.comp_ndocto and " &_
						"	  a.dcom_ncompromiso = c.dcom_ncompromiso and " &_
						"	  a.ingr_ncorr=d.ingr_ncorr and  " & _
						"	  a.ingr_ncorr='" & ingr_ncorr & "' " &_
						"order by a.comp_ndocto asc, a.dcom_ncompromiso asc"
		
		tabla_i.consultar consulta_i
		if tabla_i.nroFilas > 0 then
			for k=0 to tabla_i.nroFilas-1
				tabla_i.siguiente
				codigo		= 	tabla_i.obtenerValor("codigo")
				docto		= 	tabla_i.obtenerValor("docto")
				concepto	= 	sin_acentos(tabla_i.obtenerValor("concepto"))
				cuota		= 	tabla_i.obtenerValor("cuota")
				abono		=	clng(tabla_i.obtenerValor("abono"))
				total		= 	clng(tabla_i.obtenerValor("total"))
				intereses	=	clng(tabla_i.obtenerValor("intereses"))
				multas		=	clng(tabla_i.obtenerValor("multas"))
				m_anticipado=	clng(tabla_i.obtenerValor("m_anticipado"))
				
				suma=0
				if m_anticipado > 0 and multas > 0 and intereses > 0 then
					suma=3
				elseif (m_anticipado > 0 and multas > 0 )or (intereses > 0 and multas > 0 ) or (m_anticipado > 0 and intereses > 0) then
					suma=2
					elseif m_anticipado > 0 or multas > 0 or intereses > 0 then
						suma = 1
				end if
				if abono > 999 then
					archivo = archivo & space(71)&Ac1(docto,8,"I")&space(4)&Ac1(cuota,6,"D")&space(2)&Ac1(concepto,20,"I")&space(15)& Ac1(formatcurrency(abono,0,-1,0,-1),11,"D")& chr(13) &  chr(10)
				else
					archivo = archivo & space(71)&Ac1(docto,8,"I")&space(4)&Ac1(cuota,6,"D")&space(2)&Ac1(concepto,20,"I")&space(15)& Ac1(formatcurrency(abono,0,-1,0,-1),11,"D")& chr(13) &  chr(10)
				end if
			next
		end if
		
		if m_anticipado > 0 then
		archivo=archivo &space(91)& Ac1("PAGO ANTICIPADO",20,"I")&space(15)&Ac1(formatcurrency(m_anticipado,0,-1,0,-1),11,"D")& chr(13) &  chr(10)
		end if
		
		if intereses >0 then
			archivo=archivo &space(91)& Ac1("INTERESES",20,"I")&space(15)&Ac1(formatcurrency(intereses,0,-1,0,-1),11,"D")& chr(13) &  chr(10)
		else
			archivo=archivo& chr(13) &  chr(10)
		end if
		if multas > 0 then
			archivo=archivo &space(91)& Ac1("MULTAS",20,"I")&space(15)&Ac1(formatcurrency(multas,0,-1,0,-1),11,"D")& chr(13) &  chr(10)
		else
			archivo=archivo& chr(13) &  chr(10)
		end if
		for kk=1 to 3-suma
			archivo =  archivo & chr(13) &  chr(10)
		next
		
		filas=clng(conectar.consultauno("select count(*) from abonos where ingr_ncorr='"& ingr_ncorr &"'"))
		
		FOR i=1 to 10 - filas
			archivo =  archivo & chr(13) &  chr(10)
		next
	   for j=0 to 3
			archivo =  archivo & chr(13) &  chr(10)
	   next
			archivo =  archivo  &space(61)& Ac1("PAGO POR CUENTA ALUMNO: "&alumno,180,"I") & chr(13) &  chr(10)
	  for j=0 to 3
			archivo =  archivo & chr(13) &  chr(10)
	   next
	   archivo = archivo &space(95) &Ac1("TOTAL",5,"I")&space(28) & Ac1(formatcurrency(total,0,-1,0,-1),11,"I") & chr(13) & chr(10)
	   '********   NRO A PALABRAS ************************
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(13) & chr(10)
	   
	   archivo = archivo &space(58)& Ac1(Traduce_numero(total,2),85,"I") 
	   '********   NRO A PALABRAS ************************
	   
			
	   archivo = archivo & chr(13) & chr(10)
	   archivo = archivo & chr(12) 
'--------------------------------------------------------------------------------------				
	   Set oFile      = CreateObject("Scripting.FileSystemObject")
	   Set oPrinter   = oFile.CreateTextFile(impresora) 
	   'Set oPrinter   = oFile.CreateTextFile("//pc-jaec/Musica$/impresora.txt") 
	   'response.Write("<pre>"&archivo&"</pre>")
	   oPrinter.write(archivo)				 

	   Set oWshnet    = Nothing
	   Set oFile      = Nothing
	   set oPrinter   = Nothing
	   set iPrinter   = Nothing 
	   
	'----------------------------------------------------------------------------------
	
%>
<script language="JavaScript">
	self.opener.location.reload();
	window.close();
</script>


