<html>
<head>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
</script>
</head>
<body onUnload="window.opener.parent.top.location.reload();">
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file="../biblioteca/funciones_formateo.asp" -->
<%
  set conexion = new CConexion
  conexion.Inicializar "upacifico"
  set negocio = new CNegocio
  negocio.Inicializa conexion
'------------datos sesiones-----------------------
	v_sucu_ncorr = negocio.ObtenerSede
	v_usuario = negocio.ObtenerUsuario
'-------------------------------------------------
nfolio = request.querystring("nfolio")
nro_ting_ccod = Request.QueryString("nro_ting_ccod")
pers_ncorr = Request.QueryString("pers_ncorr")
total = Request.QueryString("total")
detalle_compromiso = Request.QueryString("detalle_compromiso")
nombre_banco = Request.QueryString("nombre_banco")
periodo = Request.QueryString("peri_ccod")

'response.Write("folio "&nfolio&" nro_ting_ccod= "&nro_ting_ccod&" pers_ncorr "&pers_ncorr&" total "&total&" detalle "&detalle_compromiso&"<br>banco "&nombre_banco&" periodo "&periodo)
'-----------------------------------------------------------------------
set f_consulta_alumno = new CFormulario
f_consulta_alumno.Carga_Parametros "parametros.xml", "tabla"
f_consulta_alumno.inicializar conexion

sql = "select protic.codigo_alumno('"&pers_ncorr&"',oa.peri_ccod) as codigo_alumno,"& vbCrLf &_
		"    protic.obtener_nombre_carrera(oa.ofer_ncorr,'CE') nombre_carrera,oa.ofer_ncorr oferta,"& vbCrLf &_
		"    pp.pers_tnombre + ' ' + pp.pers_tape_paterno + ' ' + pp.pers_tape_materno nombre_alumno,"& vbCrLf &_
		"    cast(pp.pers_nrut as varchar) + '-' + pp.pers_xdv rut_alumno,"& vbCrLf &_
		"    convert(varchar,getdate(),103) fecha_dia,"& vbCrLf &_
		"    pp_c.pers_tnombre + ' ' + pp_c.pers_tape_paterno + ' ' + pp_c.pers_tape_materno nombre_codeudor,"& vbCrLf &_
		"    cast(pp_c.pers_nrut as varchar) + '-' + pp_c.pers_xdv rut_codeudor"& vbCrLf &_
		"    from ofertas_academicas oa,alumnos aa,personas pp,"& vbCrLf &_
		"        postulantes pos,codeudor_postulacion cp,personas pp_c"& vbCrLf &_
		"    where oa.ofer_ncorr *= aa.ofer_ncorr"& vbCrLf &_
		"        and pp.pers_ncorr = '"&pers_ncorr&"'"& vbCrLf &_
		"        and pos.peri_ccod = '"&periodo&"'"& vbCrLf &_
		"        and aa.emat_ccod = 1"& vbCrLf &_
		"        and aa.pers_ncorr =* pp.pers_ncorr"& vbCrLf &_
		"        and pos.pers_ncorr = pp.pers_ncorr"& vbCrLf &_
		"        and pos.post_ncorr = cp.post_ncorr"& vbCrLf &_
		"        and pp_c.pers_ncorr = cp.pers_ncorr"

'response.Write("<PRE>" & sql & "</PRE>")
'periodo=negocio.obtenerPeriodoAcademico("CLASE18")		
cankidad=conexion.consultaUno("Select count(*) from ("&sql&")a")
'response.Write("<pre>cantidad"&cankidad&" Periodo "& periodo&"</pre>")
if cInt(cankidad)=0 then
sql = "select pp.pers_nrut as codigo_alumno,"& vbCrLf &_
		"    '- SIN DATOS-' nombre_carrera,'' as oferta,"& vbCrLf &_
		"    pp.pers_tnombre + ' ' + pp.pers_tape_paterno + ' ' + pp.pers_tape_materno nombre_alumno,"& vbCrLf &_
		"    cast(pp.pers_nrut as varchar) + '-' + pp.pers_xdv rut_alumno,"& vbCrLf &_
		"    convert(varchar,getdate(),103) fecha_dia,"& vbCrLf &_
		"    '-SIN DATOS-' nombre_codeudor,"& vbCrLf &_
		"    '-SIN DATOS-' rut_codeudor"& vbCrLf &_
		"    from personas pp"& vbCrLf &_
		"    where pp.pers_ncorr = '"&pers_ncorr&"'"
end if
f_consulta_alumno.consultar sql
f_consulta_alumno.siguiente


'---------------------------------------------------------------------------------
set f_consulta_compromiso = new CFormulario
f_consulta_compromiso.Carga_Parametros "parametros.xml", "tabla"
f_consulta_compromiso.inicializar conexion

sql = "select dd.tdet_ccod, td.tcom_ccod, dc.tcom_ccod, dc.COMP_NDOCTO nro_documento,"& vbCrLf &_
		"    convert(varchar,dc.DCOM_FCOMPROMISO,103) fecha_vencimiento,"& vbCrLf &_
		"    tc.tcom_tdesc tipo_compromiso, SUM(ab.ABON_MABONO) monto_abono,"& vbCrLf &_
		"    upper(ti.ting_tdesc) as ting_tdesc"& vbCrLf &_
		"	 --(select ingr_ncorr from ingresos a where a.ingr_nfolio_referencia = '"&nfolio&"')"& vbCrLf &_
		"    from ingresos ii,abonos ab,detalle_compromisos dc,tipos_compromisos tc,"& vbCrLf &_
		"        detalles dd,tipos_detalle td,tipos_ingresos ti"& vbCrLf &_
		"    where ii.ingr_ncorr = ab.ingr_ncorr"& vbCrLf &_
		"        and ii.ingr_nfolio_referencia = '"&nfolio&"'"& vbCrLf &_
		"        and ii.ting_ccod = '"&nro_ting_ccod&"'"& vbCrLf &_
		"        and ab.tcom_ccod = dc.tcom_ccod"& vbCrLf &_
		"        and ab.inst_ccod = dc.inst_ccod  "& vbCrLf &_
		"        and ab.comp_ndocto = dc.comp_ndocto "& vbCrLf &_
		"        and ab.dcom_ncompromiso = dc.dcom_ncompromiso"& vbCrLf &_
		"        and dc.tcom_ccod = tc.tcom_ccod"& vbCrLf &_
		"        and dc.tcom_ccod = dd.tcom_ccod"& vbCrLf &_
		"        and dc.inst_ccod = dd.inst_ccod"& vbCrLf &_
		"        and dc.comp_ndocto = dd.comp_ndocto"& vbCrLf &_
		"        and dd.tdet_ccod = td.tdet_ccod"& vbCrLf &_
		"        and case isnull(dd.tdet_ccod,0) when 0 then dc.tcom_ccod else td.tcom_ccod end = dc.tcom_ccod"& vbCrLf &_
		"        and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ting_ccod') *= ti.ting_ccod"& vbCrLf &_
		"GROUP BY dd.tdet_ccod, td.tcom_ccod, dc.tcom_ccod, dc.COMP_NDOCTO,dc.DCOM_FCOMPROMISO,tc.tcom_tdesc, ti.ting_tdesc,dc.tcom_ccod, dc.inst_ccod, dc.dcom_ncompromiso, td.tdet_tdesc"
'response.Write("<pre>"&sql&"</pre>")		
f_consulta_compromiso.consultar sql

set f_consulta_docto = new CFormulario
f_consulta_docto.Carga_Parametros "parametros.xml", "tabla"
f_consulta_docto.inicializar conexion
sql = "select di.ding_ndocto nro_documento,di.ding_fdocto fecha_documento, bb.BANC_TDESC as nombre_banco,'"&nfolio&"' as nfolio,"& vbCrLf &_
		"    upper( case ti.ting_tdesc when '' then 'EFECTIVO' when ti.ting_tdesc then ti.ting_tdesc end ) tipo_pago,"& vbCrLf &_
		"    case ti.ting_tdesc when '' then ii.ingr_mefectivo when ti.ting_tdesc then di.ding_mdetalle end as monto_doc,"& vbCrLf &_
		"    '' detalles_compromiso, '"+total+"' total,"& vbCrLf &_
		"    case ii.ting_ccod when 17 then 'COMPROBANTE\n DE\n REGULARIZACIÓN' else replace(tii.ting_tdesc, ' ', '\n') end AS tdocumento"& vbCrLf &_
		"    from ingresos ii,detalle_ingresos di,tipos_ingresos ti,bancos bb,tipos_ingresos tii"& vbCrLf &_
		"    where ii.ingr_ncorr = di.ingr_ncorr   "& vbCrLf &_
		"        and di.ting_ccod *= ti.ting_ccod"& vbCrLf &_
		"        and di.banc_ccod *= bb.banc_ccod"& vbCrLf &_
		"        and ii.ting_ccod = tii.ting_ccod"& vbCrLf &_
		"        and ii.ingr_nfolio_referencia= '"&nfolio&"'"& vbCrLf &_
		"        and ii.ting_ccod='"&nro_ting_ccod&"'  "& vbCrLf &_
		"        and ii.eing_ccod in (1,4)"
'response.Write("<pre>"&sql&"</pre>")
'response.End()		

f_consulta_docto.consultar sql
f_consulta_docto.Siguiente
documento = f_consulta_docto.obtenerValor("tdocumento")
f_consulta_docto.primero


'-----------------------------------------------------------------
' Funcion para dibujar texto alineado
function Ac(texto,ancho,alineado)
    largo =Len(Trim(texto))
	if isnull(largo) then largo=0
	if largo > ancho then largo=ancho
    if ucase(alineado) = "D" then 
	   Ac=space(ancho-largo)&Left(texto,largo)
	else
	   Ac=Left(texto,cint(largo))&space(ancho-largo)
	end if   
end function

function nombre_Mes(valor)
if valor=1 then
	nombre_Mes="Enero"
elseif valor=2 then
    nombre_Mes="Febrero"
elseif valor=3 then
    nombre_Mes="Marzo"
elseif valor=4 then
    nombre_Mes="Abril"
elseif valor=5 then
    nombre_Mes="Mayo"
elseif valor=6 then
    nombre_Mes="Junio"
elseif valor=7 then
    nombre_Mes="Julio"
elseif valor=8 then
    nombre_Mes="Agosto"
elseif valor=9 then
    nombre_Mes="Septiembre"
elseif valor=10 then
    nombre_Mes="Octubre"
elseif valor=11 then
    nombre_Mes="Noviembre"
elseif valor=12 then
    nombre_Mes="Diciembre"
end if
end function
'-----------------------------------------------------------------
sin_totales=0
'for each x in Request.Form
 'response.write("<br>"& x & "="& Request.Form(x))
'Next

'v_pers_ncorr	=	request.Form("busqueda[0][pers_ncorr]")
'v_docu_ncorr	=	request.Form("busqueda[0][docu_ncorr]")
'v_tdoc_ccod		=	request.Form("busqueda[0][tdoc_ccod]")

FechaObtenida	= f_consulta_alumno.ObtenerValor ("fecha_dia")
porcentaje_iva 	=	0

arr_fecha=split(FechaObtenida,"/")
Dia=arr_fecha(0)
Mes3=nombre_Mes(arr_fecha(1))
Ano=arr_fecha(2)

direccion=conexion.consultaUno("Select dire_tcalle  from direcciones where pers_ncorr='"&pers_ncorr&"'")
numero= conexion.consultaUno("Select dire_tnro from direcciones where pers_ncorr='"&pers_ncorr&"'")
ciudad= conexion.consultaUno("Select a.ciud_tdesc  from ciudades a,direcciones b where b.ciud_ccod=a.ciud_ccod and b.pers_ncorr='"&pers_ncorr&"'")
comuna= conexion.consultaUno("Select a.ciud_tcomuna  from ciudades a,direcciones b where b.ciud_ccod=a.ciud_ccod and b.pers_ncorr='"&pers_ncorr&"'")
fono= conexion.consultaUno("Select pers_tfono from personas where pers_ncorr='"&pers_ncorr&"'")
if numero <>"" then
	direccion_real= direccion &" N° "& numero
else
	direccion_real= direccion &" s/n"
end if
'response.Write("<br> Dia "&Dia&" Mes "&Mes&" Año "&Ano)
'response.End()
'---------------------------------------------------------------
' Sangria encabezado
'---------------------------------------------------------------

   archivo = archivo & chr(13) & chr(10) &  space(6) 
   archivo = archivo & chr(13) & chr(10) &  space(6) 
   archivo = archivo & chr(13) & chr(10) &  space(6) 
   archivo = archivo & chr(13) & chr(10) &  space(6) 
   archivo = archivo & chr(13) & chr(10) &  space(6) 
   archivo = archivo & chr(13) & chr(10) &  space(6) 
   archivo = archivo & chr(13) & chr(10) &  space(6) 
   archivo = archivo & chr(13) & chr(10) &  space(6) 

'---------------------------------------------------------------
' datos generales (glosa)
'---------------------------------------------------------------
   'columna1= 12 - (8 + len(Dia))
   'columna2= 30 - (8 + len(Dia) + len(Mes3))
   'archivo = archivo & chr(13) & chr(10) &  space(8) & Dia & space(len(Dia)+columna1+1)& Mes3 & space(len(Dia)+len(Mes2)+columna2+1) & Ano
    archivo = archivo & chr(13) & chr(10) &  space(5) & Ac(Dia,10,"C")& Ac(" " ,4,"I") & Ac(Mes3,24,"C") & Ac(" " ,6,"I") & Ac(Ano,4,"I")
   dia2=Dia
   mes2=Mes3
   ano2=Ano
   archivo = archivo & chr(13) & chr(10) &  space(6) 
   archivo = archivo & chr(13) & chr(10) &  space(5) &f_consulta_alumno.ObtenerValor ("nombre_alumno")& space(40)  
   archivo = archivo & chr(13) & chr(10) &  space(6)
   'columna1= 39 - (8 + len(direccion_real))
   'columna2= 58 - (8 + len(direccion_real) + len(comuna)) 
   'archivo = archivo & chr(13) & chr(10) &  space(8) & direccion_real & space(len(direccion_real)+columna1+1) & comuna & space(len(direccion_real)+len(comuna)+columna1+1) & fono
   archivo = archivo & chr(13) & chr(10) &  space(5) & Ac(direccion_real,41,"I") &Ac(" ", 9,"I")& Ac(comuna,24,"I") &Ac(" ",6,"I")& fono
   archivo = archivo & chr(13) & chr(10) &  space(6)
  ' columna1= 58 - (8 + len(ciudad))
   rute=f_consulta_alumno.ObtenerValor ("codigo_alumno")
   dvx=conexion.consultaUno("Select dbo.dv("&rute&")")
   
   archivo = archivo & chr(13) & chr(10) &  space(5) &Ac(ciudad,74,"I") &Ac(" ",4,"I")& Ac(FormatNumber(rute,0,-1,0,-1),12,"D")&"-"&dvx
   archivo = archivo & chr(13) & chr(10) &  space(6)
   'columna1= 58 - (8 + len("GIRO "))
   archivo = archivo & chr(13) & chr(10) &  space(8) '& Ac("GIRO ",61,"I") &Ac(" ",15,"I")&Ac("tipo de Pago",20,"I")
   archivo = archivo & chr(13) & chr(10) &  space(6)
   archivo = archivo & chr(13) & chr(10) &  space(6)
   archivo = archivo & chr(13) & chr(10) &  space(6)
   archivo = archivo & chr(13) & chr(10) &  space(6)
   archivo = archivo & chr(13) & chr(10) &  space(6)
   archivo = archivo & chr(13) & chr(10) &  space(6)
   
   total=0
   while f_consulta_compromiso.Siguiente 
   columna=58
   'columna2=8 + len(f_consulta_compromiso.ObtenerValor("nro_documento") ) 
   datos= chr(13) & chr(10) & space(18) & Ac(f_consulta_compromiso.ObtenerValor("nro_documento"),8,"I") 
   'datos= chr(13) & chr(10) & space(8) & f_consulta_compromiso.ObtenerValor("nro_documento") 
   'response.Write("<br>Primero "&f_consulta_compromiso.ObtenerValor("nro_documento")&" "& 8+len(f_consulta_compromiso.ObtenerValor("nro_documento")))
  
   if f_consulta_compromiso.ObtenerValor("tipo_detalle")<> "" then
     datos= datos & Ac("",4,"I") & Ac(f_consulta_compromiso.ObtenerValor("tipo_detalle"),15,"C")
     columna=columna-24
   end if
   
   if f_consulta_compromiso.ObtenerValor("tipo_compromiso") <> "" then
        'columna2=columna2+20+len(f_consulta_compromiso.ObtenerValor("tipo_compromiso"))
		 datos = datos & Ac("",5,"I") & Ac(f_consulta_compromiso.ObtenerValor("tipo_compromiso"),15,"C")
	     columna=columna-20
   end if
   
   if f_consulta_compromiso.ObtenerValor("ding_ndocto") <> "" then
       datos = datos & Ac("Nº ",5,"C") & Ac(f_consulta_compromiso.ObtenerValor("ding_ndocto"),9,"I")
       columna=columna-14
   end if
       datos =datos &Ac(" ",columna,"I")& AC(FormatNumber(f_consulta_compromiso.ObtenerValor("monto_abono"),0,-1,0,-1),12,"I")
       total = cdbl(total) + cdbl(f_consulta_compromiso.ObtenerValor("monto_abono"))
       archivo= archivo & datos
	   contador= contador + 1
   wend 
   archivo = archivo & chr(13) & chr(10) &  space(6)
   
   f_consulta_compromiso.primero
   
   while f_consulta_docto.siguiente
   columna=35
   datos= chr(13) & chr(10) &space(18) & Ac(f_consulta_docto.ObtenerValor("tipo_pago"),15,"I")
   if f_consulta_docto.ObtenerValor("nro_documento") <> ""  then
      datos = datos & Ac(" ",5,"I") & Ac(f_consulta_docto.ObtenerValor("nro_documento"),10,"C")
	  columna=columna-15
   end if
   if f_consulta_docto.ObtenerValor("nombre_banco") <> "" then
   	 datos= datos & Ac(" ",5,"I")& Ac(f_consulta_docto.ObtenerValor("nombre_banco"),9,"C")
	 columna=columna-14
   end if
     datos=datos & Ac(" ",columna,"I") &Ac(formatnumber(f_consulta_docto.ObtenerValor("monto_doc"),0,-1,0-1),12,"I")
     archivo= archivo & datos
   wend
   
   for i=1 to 36-contador 
   archivo = archivo & chr(13) & chr(10) &  space(6)
   next 
   neto=cdbl(total)-cdbl(total)*0.19
   archivo = archivo & chr(13) & chr(10) &  space(84) & Ac(FormatNumber(cdbl(neto),0,-1,0,-1),12,"I") 
   archivo = archivo & chr(13) & chr(10) &  space(6)
   archivo = archivo & chr(13) & chr(10) &  space(84) & Ac(FormatNumber(cdbl(total) * 0.19 ,0,-1,0,-1),12,"I")
   'columna1= 15 - (8 + len(dia2))
   'columna2= 34 - (8 + len(dia2) + len(mes2))
   'columna3= 50 - (8 + len(dia2)+ len(mes2)+ len(ano2))
   archivo = archivo & chr(13) & chr(10) &  space(6)
   archivo = archivo & chr(13) & chr(10) &  space(8) & Ac(dia2,14,"I")& Ac(" ",4,"I") & Ac(mes2,28,"I")&Ac(" ",4,"I") & Ac(ano2,26,"I") & Ac(FormatNumber(cdbl(total),0,-1,0,-1),12,"I")
   
   response.Write("<pre>" & archivo & "</pre>")
   response.End()
   
'response.Write("<pre>"&archivo&"</pre>")
'response.End()
'   impresora  	= 	"\\FRINDT\FX"
'   Set oFile      = CreateObject("Scripting.FileSystemObject")
'   Set oPrinter   = oFile.CreateTextFile(impresora, true, true) 
   
'   oPrinter.write(archivo)
 
'   Set oWshnet    = Nothing
'   Set oFile      = Nothing
'   set oPrinter   = Nothing
'   set iPrinter   = Nothing 

set f1 = new CFormulario
f1.Carga_Parametros "facturavta.xml", "encabezado_v"
f1.Inicializar conectar
f1.ProcesaForm
'f1.ListarPost

		 '----------------------------------------------------------------
		 for fila = 0 to f1.CuentaPost - 1
		 v_automatico= f1.ObtenerValorPost (fila, "automatico")
		 v_docu_ndocumento= f1.ObtenerValorPost (fila, "docu_ndocumento")
		 f1.AgregaCampoFilaPost fila,  "docu_nimpresion" , 1
		 f1.AgregaCampoFilaPost fila,  "docu_ndocumento" , v_docu_ndocumento
		  'f1.MantieneTablas false
	      'conexion.estadotransaccion false  'roolback
      next  
         if (v_automatico="") then
		     v_automatico=0
		end if	 

%>

</body>
</html>
