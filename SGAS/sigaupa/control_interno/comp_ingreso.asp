<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO:
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:05/04/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			:204 - 239,241
'*******************************************************************
Max_Lineas_Comp = 8
Max_Lineas_Pagos = 6
Cont_Lineas_Comp  = 0
Cont_Lineas_Pagos  = 0

set pagina = new CPagina
pagina.Titulo = "Conciliar Documentos"

'-------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede
cajero.AsignarTipoCaja(1002) ' caja para el control interno
usuario = negocio.ObtenerUsuario
'response.Write("usuario "&usuario)

caja=cajero.ObtenerCajaAbierta
nombre_cajero=conexion.consultaUno("Select cast(pers_tnombre as varchar)+' '+cast(pers_tape_paterno as varchar) +' '+ cast(pers_tape_materno as varchar) as nombre from personas where cast(pers_nrut as varchar)='"&usuario&"'")
dato="Select protic.initcap('"&nombre_cajero&"')"
'response.Write("dato: "&dato)
nombre_cajero=conexion.consultaUno(dato)
'cajita=cajero.ObtenerCajaAbierta
if nombre_cajero<>"" then
datos_cajero="* "&nombre_cajero&"("&caja&")->Regularizacion"
end if
'response.Write("<strong>Cajero:<strong> "&cajerits&" / <strong>caja:</strong> "&cajita)


nfolio = request.querystring("nfolio")
nro_ting_ccod = Request.QueryString("nro_ting_ccod")
pers_ncorr = Request.QueryString("pers_ncorr")
total = Request.QueryString("total")
detalle_compromiso = Request.QueryString("detalle_compromiso")
nombre_banco = Request.QueryString("nombre_banco")
periodo = Request.QueryString("peri_ccod")
'response.Write("folio "&nfolio&" nro_ting_ccod "&nro_ting_ccod&" pers_ncorr "&pers_ncorr&" total "&total&" periodo "&periodo)
'-----------------------------------------------------------------------
set f_consulta_alumno = new CFormulario
f_consulta_alumno.Carga_Parametros "parametros.xml", "tabla"
f_consulta_alumno.inicializar conexion

'  sql = " select codigo_alumno ('"&pers_ncorr&"',oa.peri_ccod) as codigo_alumno, "& vbCrLf &_
'		"		 obtener_nombre_carrera(oa.ofer_ncorr,'C') nombre_carrera,oa.ofer_ncorr oferta, "& vbCrLf &_
'		"		 pp.pers_tnombre || ' ' || pp.pers_tape_paterno || ' ' || pp.pers_tape_materno nombre_alumno, "& vbCrLf &_
'		"		 pp.pers_nrut || '-' || pp.pers_xdv rut_alumno, "& vbCrLf &_
'		"		 to_char(sysdate,'DD/MM/YYYY') fecha_dia, "& vbCrLf &_			
'		"		 pp_c.pers_tnombre || ' ' || pp_c.pers_tape_paterno || ' ' || pp_c.pers_tape_materno nombre_codeudor, "& vbCrLf &_
'		"		 pp_c.pers_nrut || '-' || pp_c.pers_xdv rut_codeudor "& vbCrLf &_
'		" from ofertas_academicas oa, alumnos aa, personas pp,  "& vbCrLf &_
'		"		 postulantes pos, codeudor_postulacion cp, personas pp_c "& vbCrLf &_
'		"where oa.ofer_ncorr (+)= aa.ofer_ncorr "& vbCrLf &_
'		"		 and pp.pers_ncorr='"&pers_ncorr&"'  "& vbCrLf &_
'		"		 and pos.peri_ccod = '"&periodo&"' "& vbCrLf &_
'		"		 and aa.emat_ccod (+)= 1 "& vbCrLf &_
'		"		 and aa.pers_ncorr (+)= pp.pers_ncorr "& vbCrLf &_ 
'		"		 and pos.pers_ncorr = pp.pers_ncorr "& vbCrLf &_
'		"		 and pos.post_ncorr = cp.post_ncorr (+)  "& vbCrLf &_
'	    "		 and pp_c.pers_ncorr (+) = cp.pers_ncorr "& vbCrLf &_			
'		"		 ORDER BY oa.peri_ccod DESC "& vbCrLf
		
sql = "select protic.codigo_alumno('"&pers_ncorr&"',oa.peri_ccod) as codigo_alumno,"& vbCrLf &_
		"    protic.obtener_nombre_carrera(oa.ofer_ncorr,'CE') as nombre_carrera,oa.ofer_ncorr as oferta,"& vbCrLf &_
		"    pp.pers_tnombre + ' ' + pp.pers_tape_paterno + ' ' + pp.pers_tape_materno as nombre_alumno,"& vbCrLf &_
		"    protic.format_rut(pp.pers_nrut) as rut_alumno,"& vbCrLf &_
		"    convert(varchar,getdate(),103) as fecha_dia,"& vbCrLf &_
		"    pp_c.pers_tnombre + ' ' + pp_c.pers_tape_paterno + ' ' + pp_c.pers_tape_materno as nombre_codeudor,"& vbCrLf &_
		"    protic.format_rut(pp_c.pers_nrut) as rut_codeudor"& vbCrLf &_
		"    from ofertas_academicas oa,alumnos aa,personas pp,"& vbCrLf &_
		"        postulantes pos,codeudor_postulacion cp,personas pp_c"& vbCrLf &_
		"    where aa.ofer_ncorr = oa.ofer_ncorr"& vbCrLf &_
		"        and pp.pers_ncorr = '"&pers_ncorr&"'"& vbCrLf &_
		"        and pos.peri_ccod = '"&periodo&"'"& vbCrLf &_
		"        and aa.emat_ccod = 1"& vbCrLf &_
		"        and aa.pers_ncorr = pp.pers_ncorr"& vbCrLf &_
		"        and pos.pers_ncorr = pp.pers_ncorr"& vbCrLf &_
		"        and pos.post_ncorr = cp.post_ncorr"& vbCrLf &_
		"        and pp_c.pers_ncorr = cp.pers_ncorr"

'---------------------------------------------busqueda de los ofer_ncorr con datos de las personas------------------
ultimo_periodo = conexion.consultaUno(" select top 1 max(b.peri_ccod)as periodo from postulantes a, periodos_academicos b where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.peri_ccod=b.peri_ccod order by periodo desc")
v_post_ncorr = conexion.consultaUno("select post_ncorr from postulantes where cast(pers_ncorr as varchar)='"&pers_ncorr&"' and cast(peri_ccod as varchar)='"&ultimo_periodo&"'")
ofer_ncorr=conexion.consultaUno("select ofer_ncorr from postulantes where cast(post_ncorr as varchar)='"&v_post_ncorr&"'")
'response.Write("ofer_ncorr "&ofer_ncorr)
if ofer_ncorr="" then
    ofer_ncorr=conexion.consultaUno("Select ofer_ncorr from alumnos cast(post_ncorr as varchar)='"&v_post_ncorr&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"' and emat_ccod='1'")
end if
if ofer_ncorr<>"" then
	sql=sql&" and cast(oa.ofer_ncorr as varchar)='"&ofer_ncorr&"'"
end if
'-------------------------------------------------------------------------------------------------------------------

'periodo=negocio.obtenerPeriodoAcademico("CLASE18")		
cankidad=conexion.consultaUno("Select count(*) from ("&sql&")a")
'response.Write("<pre>cantidad"&cankidad&" Periodo "& periodo&"</pre>")
if cInt(cankidad)=0 then
sql = "select cast(pp.pers_nrut as varchar)+'-'+cast(pp.pers_xdv as varchar) as codigo_alumno,"& vbCrLf &_
		"    '- SIN DATOS-' nombre_carrera,'' as oferta,"& vbCrLf &_
		"    pp.pers_tnombre + ' ' + pp.pers_tape_paterno + ' ' + pp.pers_tape_materno as nombre_alumno,"& vbCrLf &_
		"    protic.format_rut(pp.pers_nrut) as rut_alumno,"& vbCrLf &_
		"    convert(varchar,getdate(),103) as fecha_dia,"& vbCrLf &_
		"    '-SIN DATOS-' as nombre_codeudor,"& vbCrLf &_
		"    '-SIN DATOS-' as rut_codeudor"& vbCrLf &_
		"    from personas pp"& vbCrLf &_
		"    where pp.pers_ncorr = '"&pers_ncorr&"'"
end if
f_consulta_alumno.consultar sql
f_consulta_alumno.siguiente
'response.Write("<PRE>" & sql & "</PRE>")

'---------------------------------------------------------------------------------
set f_consulta_compromiso = new CFormulario
f_consulta_compromiso.Carga_Parametros "parametros.xml", "tabla"
f_consulta_compromiso.inicializar conexion

 
'		sql =   "SELECT dd.tdet_ccod, td.tcom_ccod, dc.tcom_ccod, dc.COMP_NDOCTO nro_documento,TO_CHAR(dc.DCOM_FCOMPROMISO,'DD/MM/YYYY') fecha_vencimiento,   "& vbCrLf &_
'				"	   tc.tcom_tdesc tipo_compromiso, SUM(ab.ABON_MABONO) monto_abono, initcap(ti.ting_tdesc) as ting_tdesc, Documento_Asociado_Cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ding_ndocto') AS ding_ndocto, "& vbCrLf &_
'				"	   initcap(nvl(td.tdet_tdesc, tc.tcom_tdesc)) as tipo_detalle "& vbCrLf &_
'				" FROM INGRESOS ii, ABONOS ab, DETALLE_COMPROMISOS dc, TIPOS_COMPROMISOS tc, TIPOS_INGRESOS ti, "& vbCrLf &_
'				"	   detalles dd, tipos_detalle td "& vbCrLf &_
'				" WHERE ii.ingr_ncorr=ab.INGR_NCORR   "& vbCrLf &_
'				" AND ii.ingr_nfolio_referencia='"&nfolio&"' "& vbCrLf &_
'				"  AND ii.ting_ccod='"&nro_ting_ccod&"' "& vbCrLf &_
'				"  AND ab.TCOM_CCOD= dc.tcom_ccod  "& vbCrLf &_
'				"  AND ab.INST_CCOD=dc.INST_CCOD  "& vbCrLf &_
'				" AND ab.COMP_NDOCTO=dc.COMP_NDOCTO  "& vbCrLf &_
'				"  AND ab.DCOM_NCOMPROMISO=dc.DCOM_NCOMPROMISO  "& vbCrLf &_
'				"  AND dc.TCOM_CCOD=tc.TCOM_CCOD "& vbCrLf &_
'				"  and dc.tcom_ccod = dd.tcom_ccod (+) "& vbCrLf &_
'				"  and dc.inst_ccod = dd.inst_ccod (+) "& vbCrLf &_
'				"  and dc.comp_ndocto = dd.comp_ndocto (+) "& vbCrLf &_
'				"  and dd.tdet_ccod = td.tdet_ccod (+) "& vbCrLf &_
'				"  and decode(dd.tdet_ccod, null, dc.tcom_ccod, td.tcom_ccod) = dc.tcom_ccod "& vbCrLf &_
'				"  AND Documento_Asociado_Cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ting_ccod') = ti.ting_ccod (+) "& vbCrLf &_
'				"GROUP BY dd.tdet_ccod, td.tcom_ccod, dc.tcom_ccod, dc.COMP_NDOCTO,dc.DCOM_FCOMPROMISO,tc.tcom_tdesc, ti.ting_tdesc,dc.tcom_ccod, dc.inst_ccod, dc.dcom_ncompromiso, td.tdet_tdesc "& vbCrLf

'sql = "select isnull(cast(protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ding_ndocto') as varchar),'') as numero_docto,"& vbCrLf &_
'		" dd.tdet_ccod, td.tcom_ccod, dc.tcom_ccod, dc.COMP_NDOCTO nro_documento,"& vbCrLf &_
'		"    convert(varchar,dc.DCOM_FCOMPROMISO,103) fecha_vencimiento,"& vbCrLf &_
'		"    tc.tcom_tdesc tipo_compromiso, SUM(ab.ABON_MABONO) monto_abono,"& vbCrLf &_
'		"    upper(ti.ting_tdesc) as ting_tdesc"& vbCrLf &_
'		"	 --(select ingr_ncorr from ingresos a where a.ingr_nfolio_referencia = '"&nfolio&"')"& vbCrLf &_
'		"    from ingresos ii,abonos ab,detalle_compromisos dc,tipos_compromisos tc,"& vbCrLf &_
'		"        detalles dd,tipos_detalle td,tipos_ingresos ti"& vbCrLf &_
'		"    where ii.ingr_ncorr = ab.ingr_ncorr"& vbCrLf &_
'		"        and ii.ingr_nfolio_referencia = '"&nfolio&"'"& vbCrLf &_
'		"        and ii.ting_ccod = '"&nro_ting_ccod&"'"& vbCrLf &_
'		"        and ab.tcom_ccod = dc.tcom_ccod"& vbCrLf &_
'		"        and ab.inst_ccod = dc.inst_ccod  "& vbCrLf &_
'		"        and ab.comp_ndocto = dc.comp_ndocto "& vbCrLf &_
'		"        and ab.dcom_ncompromiso = dc.dcom_ncompromiso"& vbCrLf &_
'		"        and dc.tcom_ccod = tc.tcom_ccod"& vbCrLf &_
'		"        and dc.tcom_ccod = dd.tcom_ccod"& vbCrLf &_
'		"        and dc.inst_ccod = dd.inst_ccod"& vbCrLf &_
'		"        and dc.comp_ndocto = dd.comp_ndocto"& vbCrLf &_
'		"        and dd.tdet_ccod = td.tdet_ccod"& vbCrLf &_
'		"        and case isnull(dd.tdet_ccod,0) when 0 then dc.tcom_ccod else td.tcom_ccod end = dc.tcom_ccod"& vbCrLf &_
'		"        and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ting_ccod') *= ti.ting_ccod"& vbCrLf &_
'		"GROUP BY dd.tdet_ccod, td.tcom_ccod, dc.tcom_ccod, dc.COMP_NDOCTO,dc.DCOM_FCOMPROMISO,tc.tcom_tdesc, ti.ting_tdesc,dc.tcom_ccod, dc.inst_ccod, dc.dcom_ncompromiso, td.tdet_tdesc"

sql = "select isnull(cast(protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ding_ndocto') as varchar),'') as numero_docto,"& vbCrLf &_
		" dd.tdet_ccod, td.tcom_ccod, dc.tcom_ccod, dc.COMP_NDOCTO nro_documento,"& vbCrLf &_
		"    convert(varchar,dc.DCOM_FCOMPROMISO,103) fecha_vencimiento,"& vbCrLf &_
		"    tc.tcom_tdesc tipo_compromiso, SUM(ab.ABON_MABONO) monto_abono,"& vbCrLf &_
		"    upper(ti.ting_tdesc) as ting_tdesc"& vbCrLf &_
		"	 --(select ingr_ncorr from ingresos a where a.ingr_nfolio_referencia = '"&nfolio&"')"& vbCrLf &_
		"    from ingresos ii "& vbCrLf &_
		"    INNER JOIN abonos ab "& vbCrLf &_
		"    ON ii.ingr_ncorr = ab.ingr_ncorr and ii.ingr_nfolio_referencia = '"&nfolio&"' and ii.ting_ccod = '"&nro_ting_ccod&"' "& vbCrLf &_
		"    INNER JOIN detalle_compromisos dc "& vbCrLf &_
		"    ON ab.tcom_ccod = dc.tcom_ccod and ab.inst_ccod = dc.inst_ccod and ab.comp_ndocto = dc.comp_ndocto and ab.dcom_ncompromiso = dc.dcom_ncompromiso "& vbCrLf &_
		"    INNER JOIN tipos_compromisos tc "& vbCrLf &_
		"    ON dc.tcom_ccod = tc.tcom_ccod "& vbCrLf &_
		"    INNER JOIN detalles dd "& vbCrLf &_
		"    ON dc.tcom_ccod = dd.tcom_ccod and dc.inst_ccod = dd.inst_ccod and dc.comp_ndocto = dd.comp_ndocto "& vbCrLf &_
		"    INNER JOIN tipos_detalle td "& vbCrLf &_
		"    ON dd.tdet_ccod = td.tdet_ccod "& vbCrLf &_
		"    and case isnull(dd.tdet_ccod,0) when 0 then dc.tcom_ccod else td.tcom_ccod end = dc.tcom_ccod "& vbCrLf &_
		"    LEFT OUTER JOIN tipos_ingresos ti "& vbCrLf &_
		"    ON protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ting_ccod') = ti.ting_ccod "& vbCrLf &_
		"GROUP BY dd.tdet_ccod, td.tcom_ccod, dc.tcom_ccod, dc.COMP_NDOCTO,dc.DCOM_FCOMPROMISO,tc.tcom_tdesc, ti.ting_tdesc,dc.tcom_ccod, dc.inst_ccod, dc.dcom_ncompromiso, td.tdet_tdesc"

'response.Write("<pre>"&sql&"</pre>")		
f_consulta_compromiso.consultar sql
'f_consulta_compromiso.siguiente

'---------------------------------------------------------------------------------
set f_consulta_docto = new CFormulario
f_consulta_docto.Carga_Parametros "parametros.xml", "tabla"
f_consulta_docto.inicializar conexion

'sql = "select di.ding_ndocto nro_documento,di.ding_fdocto fecha_documento, bb.BANC_TDESC as nombre_banco,'"&nfolio&"' as nfolio,"& vbCrLf &_
'		"    upper( case ti.ting_tdesc when '' then 'EFECTIVO' when ti.ting_tdesc then ti.ting_tdesc end ) tipo_pago,"& vbCrLf &_
'		"    case ti.ting_tdesc when '' then ii.ingr_mefectivo when ti.ting_tdesc then di.ding_mdetalle end as monto_doc,"& vbCrLf &_
'		"    '' detalles_compromiso, '"+total+"' total,"& vbCrLf &_
'		"    case ii.ting_ccod when 17 then 'COMPROBANTE\n DE\n REGULARIZACIÓN' else replace(tii.ting_tdesc, ' ', '\n') end AS tdocumento"& vbCrLf &_
'		"    from ingresos ii,detalle_ingresos di,tipos_ingresos ti,bancos bb,tipos_ingresos tii"& vbCrLf &_
'		"    where ii.ingr_ncorr = di.ingr_ncorr   "& vbCrLf &_
'		"        and di.ting_ccod *= ti.ting_ccod"& vbCrLf &_
'		"        and di.banc_ccod *= bb.banc_ccod"& vbCrLf &_
'		"        and ii.ting_ccod = tii.ting_ccod"& vbCrLf &_
'		"        and ii.ingr_nfolio_referencia= '"&nfolio&"'"& vbCrLf &_
'		"        and ii.ting_ccod='"&nro_ting_ccod&"'  "& vbCrLf &_
'		"        and ii.eing_ccod in (1,4)"

sql = "select di.ding_ndocto nro_documento,di.ding_fdocto fecha_documento, bb.BANC_TDESC as nombre_banco,'"&nfolio&"' as nfolio,"& vbCrLf &_
		"    upper( case ti.ting_tdesc when '' then 'EFECTIVO' when ti.ting_tdesc then ti.ting_tdesc end ) tipo_pago,"& vbCrLf &_
		"    case ti.ting_tdesc when '' then ii.ingr_mefectivo when ti.ting_tdesc then di.ding_mdetalle end as monto_doc,"& vbCrLf &_
		"    '' detalles_compromiso, '"+total+"' total,"& vbCrLf &_
		"    case ii.ting_ccod when 17 then 'COMPROBANTE\n DE\n REGULARIZACIÓN' else replace(tii.ting_tdesc, ' ', '\n') end AS tdocumento"& vbCrLf &_
		"    from ingresos ii "& vbCrLf &_
		"    INNER JOIN detalle_ingresos di "& vbCrLf &_
		"    ON ii.ingr_ncorr = di.ingr_ncorr and ii.ingr_nfolio_referencia = '"&nfolio&"' and ii.ting_ccod = '"&nro_ting_ccod&"' and ii.eing_ccod in (1,4) "& vbCrLf &_
		"    LEFT OUTER JOIN tipos_ingresos ti "& vbCrLf &_
		"    ON di.ting_ccod = ti.ting_ccod "& vbCrLf &_
		"    LEFT OUTER JOIN bancos bb "& vbCrLf &_
		"    ON di.banc_ccod = bb.banc_ccod "& vbCrLf &_
		"    INNER JOIN tipos_ingresos tii "& vbCrLf &_
		"    ON ii.ting_ccod = tii.ting_ccod "

'response.Write("<pre>"&sql&"</pre>")
'response.End()		

f_consulta_docto.consultar sql
f_consulta_docto.Siguiente
documento = f_consulta_docto.obtenerValor("tdocumento")
if nro_ting_ccod=16 then
	documento="COMPROBANTE\n DE\n INGRESO\n\n"&"<font size=3>Nº " &nfolio&"</font>"
end if
if nro_ting_ccod=34 then
	documento="COMPROBANTE\n DE\n PAGO\n\n"&"<font size=3>Nº " &nfolio&"</font>"
end if
if nro_ting_ccod=17 then
	documento="COMPROBANTE\n DE\n INGRESO POR\n REGULACIÓN\n\n"&"<font size=3>Nº " &nfolio&"</font>"
end if

f_consulta_docto.primero
'response.Write("<PRE>" & sql & "</PRE>")

'------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "comp_ingreso.xml", "f_botonera"
f_botonera.inicializar conexion

'---------------------------calculo del valor de pagos no en efectivo 04/11/2004---------------------
valor_otros=0
f_consulta_docto.primero
while f_consulta_docto.siguiente
valor_otros=cdbl(valor_otros) + cdbl(f_consulta_docto.ObtenerValor("monto_doc"))
wend 
f_consulta_docto.primero
'f_consulta_docto.siguiente

total=0
f_consulta_compromiso.primero
while f_consulta_compromiso.Siguiente
	total = cdbl(total) + cdbl(f_consulta_compromiso.ObtenerValor("monto_abono"))
wend
f_consulta_compromiso.primero
'f_consulta_compromiso.Siguiente

if total > valor_otros then
efectivo=total-valor_otros
'response.Write("Pago Efectivo $ "& efectivo)
end if



%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!--<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">-->
<!--<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">-->

<style>
@media print{ .noprint {visibility:hidden; }}
</style>

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript">
function imprimir()
{
  window.print();  
}

function salir()
{ //alert("yupiiiiiiiii");
  window.close();
  //window.opener.parent.top.location.reload();
}

</script>

</head>

<body onUnload="window.opener.parent.top.location.reload();">
<table width="95%" border="0">
   <tr> 
    <td><table width="620" border="1" align="center" cellpadding="0" cellspacing="0">
        <tr> 
          <th nowrap> <table width="100%" border="0" cellpadding="0">
              <tr> 
                <th nowrap> <table width="100%" border="0" cellpadding="2" cellspacing="0">
                    <tr> 
                      <td width="20%"><div align="center"><font size="1"><img src="../imagenes/logo.bmp" width="105" height="70"> www.upacifico.cl</font></div></td>
                      <td width="62%"><div align="center"><font size="1"><strong>UNIVERSIDAD 
                          DEL PACIFICO <BR>
                          EDUCACION SUPERIOR</strong><BR>
                          R.U.T: 71.704.700-1<BR>
                          CASA CENTRAL: AV. LAS CONDES N&ordm; 11121 <BR>
                          Fono: (56) (02) 366 53 00 - Fax :(56) (02) 366 53 18 
                          - Santiago<BR>
                          SEDE PROVIDENCIA: Av. R. Lyon 227 - Fono (56) (02) 378 
                          92 59 - Santiago<BR>
                          ORIGINAL</font></div></td>
                      <td width="18%"><div align="center"><font size="1"><strong> 
                          <% response.Write(replace (documento,"\n", "<BR>"))%>
                          </strong></font></div></td>
                    </tr>
                    <tr> 
                      <td height="23"> <div align="center"></div></td>
                      <td><div align="center"><font size="1"><font size="1"></font></font></div></td>
                      <td><div align="center"><font size="3"><strong><%'= "Nº " & nfolio%></strong></font></div></td>
                    </tr>
                    <tr> 
                      <td> <div align="center"> 
                          <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td><div align="center"><font size="1"><%=f_consulta_alumno.ObtenerValor ("codigo_alumno")%></font></div></td>
                            </tr>
                          </table>
                        </div></td>
                      <td> <div align="center"> 
                          <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td><div align="center"><font size="1"><%=f_consulta_alumno.ObtenerValor ("nombre_carrera")%></font></div></td>
                            </tr>
                          </table>
                        </div></td>
                      <td> <div align="center"> 
                          <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td><div align="center"><font size="1"><%=f_consulta_alumno.ObtenerValor ("fecha_dia")%></font></div></td>
                            </tr>
                          </table>
                        </div></td>
                    </tr>
                    <tr> 
                      <td><div align="center"><font size="1">Cod. Alumno</font></div></td>
                      <td><div align="center"><font size="1">Carrera</font></div></td>
                      <td><div align="center"><font size="1">Fecha</font></div></td>
                    </tr>
                    <tr> 
                      <td><div align="center"> 
                          <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td><div align="center"><font size="1"><%=f_consulta_alumno.ObtenerValor ("rut_alumno")%>&nbsp;</font></div></td>
                            </tr>
                          </table>
                        </div></td>
                      <td colspan="2"><div align="center"> 
                          <table width="100%" border="1" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td><div align="center"><font size="1"><%=f_consulta_alumno.ObtenerValor ("nombre_alumno")%></font></div></td>
                            </tr>
                          </table>
                        </div>
                        <div align="center"></div></td>
                    </tr>
                    <tr> 
                      <td><div align="center"><font size="1">R.U.T. Alumno</font></div></td>
                      <td colspan="2"><div align="center"><font size="1">Datos 
                          del Alumno</font></div>
                        <div align="center"></div></td>
                    </tr>
                    <tr> 
                      <td><div align="center"> 
                          <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td> <div align="center"><font size="1"><%=f_consulta_alumno.ObtenerValor ("rut_codeudor")%></font></div></td>
                            </tr>
                          </table>
                        </div></td>
                      <td colspan="2"><div align="center"></div>
                        <div align="center"> 
                          <table width="100%" border="1" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td><div align="center"><font size="1"><%=f_consulta_alumno.ObtenerValor ("nombre_codeudor")%></font></div></td>
                            </tr>
                          </table>
                        </div></td>
                    </tr>
                    <tr> 
                      <td><div align="center"><font size="1">R.U.T. Apoderado</font></div></td>
                      <td colspan="2"><div align="center"><font size="1">Datos 
                          del Apoderado</font></div>
                        <div align="center"></div></td>
                    </tr>
                    <tr> 
                      <td colspan="3"><div align="right"><font size="1"><%=datos_cajero%></font></div></td>
                    </tr>
                    <tr> 
                      <td colspan="3"><table width="100%" border="1" cellpadding="0" cellspacing="0">
                          <tr> 
                            <td width="19%"><div align="center"><font size="1">N&ordm; 
                                Documento</font></div></td>
                            <td width="52%"><div align="left"><font size="1">Tipo de Descuento &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                Documento&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Nº documento </font></div></td>
                            <td width="14%"><div align="center"><font size="1">Valor</font></div></td>
                            <td width="15%"><div align="center"><font size="1">Fecha 
                                Vcto.</font></div></td>
                          </tr>
                          <tr> 
                            <td valign="top"> <div align="center"> 
                                <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                                  <% while f_consulta_compromiso.Siguiente %>
                                  <tr> 
                                    <td><div align="center"><font size="1"><%=f_consulta_compromiso.ObtenerValor("nro_documento")%></font></div></td>
                                  </tr>
                                  <%wend
							   f_consulta_compromiso.primero
							%>
                                  <% for a = f_consulta_compromiso.nrofilas to Max_Lineas_Comp -1  %>
                                  <tr> 
                                    <th nowrap><font size="1">&nbsp;</font></th>
                                  </tr>
                                  <% next %>
                                </table>
                              </div></td>
                            <th nowrap valign="top"> <table width="100%" border="0" align="right" cellpadding="0" cellspacing="0">
                                <% while f_consulta_compromiso.Siguiente %>
                                <tr> 
                                  <td width="33%"><div align="left"><font size="1"> 
                                      <%  linea ="&nbsp;"
							    if f_consulta_compromiso.ObtenerValor("tipo_compromiso") <> "" then
							       linea = f_consulta_compromiso.ObtenerValor("tipo_compromiso")
							    end if
							    if f_consulta_compromiso.ObtenerValor("ding_ndocto") <> "" then
							       linea = linea & " Nº " & f_consulta_compromiso.ObtenerValor("ding_ndocto")
							    end if
							   response.Write(linea)
							   %>
                                      </font></div></td>
									<td width="33%">
									  	<div align="left"><font size="1"> <%=f_consulta_compromiso.ObtenerValor("ting_tdesc")%></font></div>
									</td>
                                  <td width="34%"><div align="left"><font size="1">
                                      <%  
							   valor = f_consulta_compromiso.ObtenerValor("numero_docto")
							   response.Write(valor)
							   %>
                                      </font></div></td>
                                </tr>
                                <% wend
							   f_consulta_compromiso.primero
                             for a = f_consulta_compromiso.nrofilas to Max_Lineas_Comp -1  %>
                                <tr> 
                                  <th nowrap><font size="1">&nbsp;</font></th>
                                  <th nowrap><font size="1">&nbsp;</font></th>
                                </tr>
                                <% next %>
                              </table></th>
                            <th nowrap valign="top"> <div align="right"> 
                                <table width="100%" border="0" align="right" cellpadding="0" cellspacing="0">
                                  <%  valor = "0"
							    total = "0"
							while f_consulta_compromiso.Siguiente %>
                                  <tr> 
                                    <td><div align="right"><font size="1"> 
                                        <%  
							        salida = "$ " & FormatNumber(f_consulta_compromiso.ObtenerValor("monto_abono"),0,-1,0,-1)
							        response.Write(salida)
									total = cdbl(total) + cdbl(f_consulta_compromiso.ObtenerValor("monto_abono"))
							   %>
                                        </font></div></td>
                                  </tr>
                                  <% wend
							   f_consulta_compromiso.primero
                             for a = f_consulta_compromiso.nrofilas to Max_Lineas_Comp -1  %>
                                  <tr> 
                                    <th nowrap><font size="1">&nbsp;</font></th>
                                  </tr>
                                  <% next %>
                                </table>
                              </div></th>
                            <th nowrap valign="top"> <div align="center"> 
                                <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                                  <% while f_consulta_compromiso.Siguiente  %>
                                  <tr> 
                                    <td><div align="center"><font size="1"> 
                                        <% 
					    response.Write(f_consulta_compromiso.ObtenerValor("fecha_vencimiento"))						
						%>
                                        </font></div></td>
                                  </tr>
                                  <% 
							wend 
							for a = f_consulta_compromiso.nrofilas to Max_Lineas_Comp -1  %>
                                  <tr> 
                                    <th nowrap><font size="1">&nbsp;</font></th>
                                  </tr>
                                  <% next
								  f_consulta_compromiso.primero
								   %>
                                </table>
                              </div></th>
                          </tr>
                          <!--<tr> 
                      <td colspan="4"><HR noshade></td>
                    </tr>-->
                          <tr> 
                            <td valign="top"> <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                <% while f_consulta_docto.siguiente %>
                                <tr> 
                                  <td><font size="1"> 
                                    <% =f_consulta_docto.ObtenerValor("tipo_pago")%>
                                    </font></td>
                                </tr>
                                <% wend 
						 f_consulta_docto.primero
						%>
						 <%'Para agregar el monto pagado en efectivo  04/11/2004
								  if efectivo >0 then%>
								  	<tr> 
                                  		<td><font size="1"><%="EFECTIVO"%></font>
										</td>
                                	</tr>
								  <% restantes=Max_lineas_Pagos -1
								  else
								     restantes=Max_lineas_Pagos
								  end if
								  '----------------------------------------------------%>
                                <% for a = f_consulta_docto.nrofilas to restantes -1  %>
                                <tr> 
                                  <th nowrap><font size="1">&nbsp;</font></th>
                                </tr>
                                <% next %>
                              </table></td>
                            <td valign="top"> <div align="left"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                  <%while f_consulta_docto.siguiente%>
                                  <tr> 
                                    <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr> 
                                          <td> <div align="left"><font size="1"> 
                                              <%
							  if f_consulta_docto.ObtenerValor("nro_documento") <> ""  then
							    response.Write(f_consulta_docto.ObtenerValor("nro_documento"))
							  else
								response.Write("&nbsp;")							     
							   end if %>
                                              </font></div></td>
                                          <td> <div align="left"><font size="1"> 
                                              <%
							   if f_consulta_docto.ObtenerValor("nombre_banco") <> "" then
							     response.Write(f_consulta_docto.ObtenerValor("nombre_banco"))
							   else
							     response.Write("&nbsp;")							     
							   end if%>
                                              </font></div></td>
                                          <td> <div align="right"><font size="1"><%= "$ " & formatnumber(f_consulta_docto.ObtenerValor("monto_doc"),0,-1,0-1)%></font></div></td>
                                        </tr>
                                      </table></td>
                                  </tr>
                                  <%wend 
						  f_consulta_docto.primero %>
						            <%'Para agregar el monto pagado en efectivo  04/11/2004
								  if efectivo >0 then%>
								  	<tr> 
                                  		<td align="right"><font size="1"><%= "$ " & formatnumber(efectivo,0,-1,0-1)%></font>
										</td>
                                	</tr>
								  <% restantes=Max_lineas_Pagos -1
								  else
								     restantes=Max_lineas_Pagos
								  end if
								  '----------------------------------------------------%>
								  <% for a = f_consulta_docto.nrofilas to restantes -1  %>
                                  <tr> 
                                    <th nowrap><font size="1">&nbsp;</font></th>
                                  </tr>
                                  <% next %>
                                </table>
                              </div></td>
                            <td><font size="1">&nbsp;</font></td>
                            <td valign="top"> <div align="center"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                  <% while f_consulta_docto.siguiente %>
                                  <tr> 
                                    <td><div align="center"><font size="1"> 
                                        <%
					  if f_consulta_docto.ObtenerValor("fecha_documento") <> "" then
					     response.Write(f_consulta_docto.ObtenerValor("fecha_documento"))
					  else
					     response.Write("&nbsp;")
					  end if
					 
					  %>
                                        </font></div></td>
                                  </tr>
                                  <% wend %>
                                  <% for a = f_consulta_docto.nrofilas to Max_Lineas_Pagos -1  %>
                                  <tr> 
                                    <th nowrap><font size="1">&nbsp;</font></th>
                                  </tr>
                                  <% next 
								   f_consulta_docto.primero%>
                                </table>
                              </div></td>
                          </tr>
                        </table></td>
                    </tr>
                    <tr> 
                      <th colspan="3" nowrap> <table width="100%" border="0" cellpadding="0" cellspacing="0">
                          <tr> 
                            <th width="50%" nowrap><div align="left"><font size="1">v&aacute;lido 
                                s&oacute;lo con firma y timbre cajero</font></div></th>
                            <th width="21%" nowrap><div align="right"><font size="1">TOTAL</font></div></th>
                            <th width="0%" nowrap><div align="right"></div></th>
                            <th width="14%" nowrap> <div align="right"> 
                                <table width="100%" border="1" align="right" cellpadding="0" cellspacing="0">
                                  <tr> 
                                    <td><div align="right"><font size="1"><%= "$ " & formatnumber(total,0,-1,0-1)%></font></div></td>
                                  </tr>
                                </table>
                              </div></th>
                            <th width="15%" nowrap>&nbsp;</th>
                          </tr>
                        </table></th>
                    </tr>
                    <!--  <tr> 
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>-->
                  </table></th>
              </tr>
            </table></th>
        </tr>
      </table></td>
 
  </tr>
  <tr> 
    <td>  <table class="noprint" width="100%" border="0">
            <tr> 
              <td> <div align="right"> 
                  <%f_botonera.dibujaboton "imprimir" %>
                </div></td>
              <td> <div align="left"> 
                  <% f_botonera.dibujaboton "cancelar"
		  %>
                </div></td>
            </tr>
          </table></td>
  </tr>
  <tr> 
    <td><table width="620" border="1" align="center" cellpadding="0" cellspacing="0">
        <tr> 
          <th nowrap> <table width="100%" border="0" cellpadding="0">
              <tr> 
                <th nowrap> <table width="100%" border="0" cellpadding="2" cellspacing="0">
                    <tr> 
                      <td width="20%"><div align="center"><font size="1"><img src="../imagenes/logo.bmp" width="105" height="70"> www.upacifico.cl</font></div></td>
                      <td width="62%"><div align="center"><font size="1"><strong>UNIVERSIDAD 
                          DEL PACIFICO <BR>
                          EDUCACION SUPERIOR</strong><BR>
                          R.U.T: 71.704.700-1<BR>
                          CASA CENTRAL: AV. LAS CONDES N&ordm; 11121 <BR>
                          Fono: (56) (02) 366 53 00 - Fax :(56) (02) 366 53 18 
                          - Santiago<BR>
                          SEDE PROVIDENCIA: Av. R. Lyon 227 - Fono (56) (02) 378 
                          92 59 - Santiago<BR>
                          COPIA</font></div></td>
                      <td width="18%"><div align="center"><font size="1"><strong>
                          <% response.Write(replace (documento,"\n", "<BR>"))%>
                          </strong></font></div></td>
                    </tr>
                    <tr> 
                      <td><div align="center"></div></td>
                      <td><div align="center"><font size="1"><font size="1"></font></font></div></td>
                      <td><div align="center"><font size="3"><strong><%'= "Nº " & nfolio%></strong></font></div></td>
                    </tr>
                    <tr> 
                      <td> <div align="center"> 
                          <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td><div align="center"><font size="1"><%=f_consulta_alumno.ObtenerValor ("codigo_alumno")%></font></div></td>
                            </tr>
                          </table>
                        </div></td>
                      <td> <div align="center"> 
                          <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td><div align="center"><font size="1"><%=f_consulta_alumno.ObtenerValor ("nombre_carrera")%></font></div></td>
                            </tr>
                          </table>
                        </div></td>
                      <td> <div align="center"> 
                          <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td><div align="center"><font size="1"><%=f_consulta_alumno.ObtenerValor ("fecha_dia")%></font></div></td>
                            </tr>
                          </table>
                        </div></td>
                    </tr>
                    <tr> 
                      <td><div align="center"><font size="1">Cod. Alumno</font></div></td>
                      <td><div align="center"><font size="1">Carrera</font></div></td>
                      <td><div align="center"><font size="1">Fecha</font></div></td>
                    </tr>
                    <tr> 
                      <td><div align="center"> 
                          <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td><div align="center"><font size="1"><%=f_consulta_alumno.ObtenerValor ("rut_alumno")%>&nbsp;</font></div></td>
                            </tr>
                          </table>
                        </div></td>
                      <td colspan="2"><div align="center"> 
                          <table width="100%" border="1" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td><div align="center"><font size="1"><%=f_consulta_alumno.ObtenerValor ("nombre_alumno")%></font></div></td>
                            </tr>
                          </table>
                        </div>
                        <div align="center"></div></td>
                    </tr>
                    <tr> 
                      <td><div align="center"><font size="1">R.U.T. Alumno</font></div></td>
                      <td colspan="2"><div align="center"><font size="1">Datos 
                          del Alumno</font></div>
                        <div align="center"></div></td>
                    </tr>
                    <tr> 
                      <td><div align="center"> 
                          <table width="100%" border="1" align="center" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td> <div align="center"><font size="1"><%=f_consulta_alumno.ObtenerValor ("rut_codeudor")%></font></div></td>
                            </tr>
                          </table>
                        </div></td>
                      <td colspan="2"><div align="center"></div>
                        <div align="center"> 
                          <table width="100%" border="1" cellpadding="0" cellspacing="0">
                            <tr> 
                              <td><div align="center"><font size="1"><%=f_consulta_alumno.ObtenerValor ("nombre_codeudor")%></font></div></td>
                            </tr>
                          </table>
                        </div></td>
                    </tr>
                    <tr> 
                      <td><div align="center"><font size="1">R.U.T. Apoderado</font></div></td>
                      <td colspan="2"><div align="center"><font size="1">Datos 
                          del Apoderado</font></div>
                        <div align="center"></div></td>
                    </tr>
                    <tr> 
                      <td colspan="3"><div align="right"><font size="1"><%=datos_cajero%></font></div></td>
                   </tr>
                    <tr> 
                      <td colspan="3"><table width="100%" border="1" cellpadding="0" cellspacing="0">
                          <tr> 
                            <td width="19%"><div align="center"><font size="1">N&ordm; 
                                Documento</font></div></td>
                            <td width="52%">
								<div align="left"><font size="1">Tipo de Descuento &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                Documento&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Nº documento </font></div>
							</td>
                            <td width="14%"><div align="center"><font size="1">Valor</font></div></td>
                            <td width="15%"><div align="center"><font size="1">Fecha 
                                Vcto.</font></div></td>
                          </tr>
                          <tr> 
                            <td valign="top"> <div align="center"> 
                                <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                                  <% while f_consulta_compromiso.Siguiente %>
                                  <tr> 
                                    <td><div align="center"><font size="1"><%=f_consulta_compromiso.ObtenerValor("nro_documento")%></font></div></td>
                                  </tr>
                                  <%wend
							   f_consulta_compromiso.primero
							%>
                                  <% for a = f_consulta_compromiso.nrofilas to Max_Lineas_Comp -1  %>
                                  <tr> 
                                    <th nowrap><font size="1">&nbsp;</font></th>
                                  </tr>
                                  <% next %>
                                </table>
                              </div></td>
                            <th nowrap valign="top"> 
							<table width="100%" border="0" align="right" cellpadding="0" cellspacing="0">
                                <% while f_consulta_compromiso.Siguiente %>
                                <tr> 
                                  <td width="32%"><div align="left"><font size="1">
                                      <%  linea ="&nbsp;"
							    if f_consulta_compromiso.ObtenerValor("tipo_compromiso") <> "" then
							       linea = f_consulta_compromiso.ObtenerValor("tipo_compromiso")
							    end if
							    if f_consulta_compromiso.ObtenerValor("ding_ndocto") <> "" then
							       linea = linea & " Nº " & f_consulta_compromiso.ObtenerValor("ding_ndocto")
							    end if
							   response.Write(linea)
							   %>
                                      </font></div></td>
								<td width="34%">
									<div align="left"><font size="1"> <%=f_consulta_compromiso.ObtenerValor("ting_tdesc")%></font></div>
								</td>
                                  <td width="34%"><div align="left"><font size="1"> 
                                      <%  
							   valor = f_consulta_compromiso.ObtenerValor("numero_docto")
							   response.Write(valor)
							   %>
                                      </font></div></td>
                                </tr>
                                <% wend
							   f_consulta_compromiso.primero
                             for a = f_consulta_compromiso.nrofilas to Max_Lineas_Comp -1  %>
                                <tr> 
                                  <th nowrap><font size="1">&nbsp;</font></th>
								  <th nowrap><font size="1">&nbsp;</font></th>
                                  <th nowrap><font size="1">&nbsp;</font></th>
                                </tr>
                                <% next %>
                              </table>
							  </th>
                            <th nowrap valign="top"> <div align="right"> 
                                <table width="100%" border="0" align="right" cellpadding="0" cellspacing="0">
                                  <%  valor = "0"
							    total = "0"
							while f_consulta_compromiso.Siguiente %>
                                  <tr> 
                                    <td><div align="right"><font size="1"> 
                                        <%  
							        salida = "$ " & FormatNumber(f_consulta_compromiso.ObtenerValor("monto_abono"),0,-1,0,-1)
							        response.Write(salida)

									total = cdbl(total) + cdbl(f_consulta_compromiso.ObtenerValor("monto_abono"))
							   %>
                                        </font></div></td>
                                  </tr>
                                  <% wend
							   f_consulta_compromiso.primero
                             for a = f_consulta_compromiso.nrofilas to Max_Lineas_Comp -1  %>
                                  <tr> 
                                    <th nowrap><font size="1">&nbsp;</font></th>
                                  </tr>
                                  <% next %>
                                </table>
                              </div></th>
                            <th nowrap valign="top"> <div align="center"> 
                                <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                                  <% while f_consulta_compromiso.Siguiente  %>
                                  <tr> 
                                    <td><div align="center"><font size="1"> 
                                        <% 
					    response.Write(f_consulta_compromiso.ObtenerValor("fecha_vencimiento"))						
						%>
                                        </font></div></td>
                                  </tr>
                                  <% 
							wend 
							for a = f_consulta_compromiso.nrofilas to Max_Lineas_Comp -1  %>
                                  <tr> 
                                    <th nowrap><font size="1">&nbsp;</font></th>
                                  </tr>
                                  <% next
								  f_consulta_compromiso.primero
								   %>
                                </table>
                              </div></th>
                          </tr>
                          <!--<tr> 
                      <td colspan="4"><HR noshade></td>
                    </tr>-->
                          <tr> 
                            <td valign="top"> <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                <% while f_consulta_docto.siguiente %>
                                <tr> 
                                  <td><font size="1"> 
                                    <% =f_consulta_docto.ObtenerValor("tipo_pago")%>
                                    </font></td>
                                </tr>
                                <% wend 
						 f_consulta_docto.primero
						%>
						 <%'Para agregar el monto pagado en efectivo  04/11/2004
								  if efectivo >0 then%>
								  	<tr> 
                                  		<td><font size="1"><%="EFECTIVO"%></font>
										</td>
                                	</tr>
								  <% restantes=Max_lineas_Pagos -1
								  else
								     restantes=Max_lineas_Pagos
								  end if
								  '----------------------------------------------------%>
								  
                                <% for a = f_consulta_docto.nrofilas to restantes -1  %>
                                <tr> 
                                  <th nowrap><font size="1">&nbsp;</font></th>
                                </tr>
                                <% next %>
                              </table></td>
                            <td valign="top"> <div align="left"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                  <%while f_consulta_docto.siguiente%>
                                  <tr> 
                                    <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr> 
                                          <td>
<div align="left"><font size="1"> 
                                              <%
							  if f_consulta_docto.ObtenerValor("nro_documento") <> ""  then
							    response.Write(f_consulta_docto.ObtenerValor("nro_documento"))
							  else
								response.Write("&nbsp;")							     
							   end if %>
                                              </font></div></td>
                                          <td><div align="left"><font size="1"> 
                                              <%
							   if f_consulta_docto.ObtenerValor("nombre_banco") <> "" then
							     response.Write(f_consulta_docto.ObtenerValor("nombre_banco"))
							   else
							     response.Write("&nbsp;")							     
							   end if%>
                                              </font></div></td>
                                          <td><div align="right"><font size="1"><%= "$ " & formatnumber(f_consulta_docto.ObtenerValor("monto_doc"),0,-1,0-1)%></font></div></td>
                                        </tr>
                                      </table></td>
                                  </tr>
                                  <%wend 
						  f_consulta_docto.primero %>
						            <%'Para agregar el monto pagado en efectivo  04/11/2004
								  if efectivo >0 then%>
								  	<tr> 
                                  		<td align="right"><font size="1"><%= "$ " & formatnumber(efectivo,0,-1,0-1)%></font>
										</td>
                                	</tr>
								  <% restantes=Max_lineas_Pagos -1
								  else
								     restantes=Max_lineas_Pagos
								  end if
								  '----------------------------------------------------%>
                                  <% for a = f_consulta_docto.nrofilas to restantes -1  %>
                                  <tr> 
                                    <th nowrap><font size="1">&nbsp;</font></th>
                                  </tr>
                                  <% next %>
                                </table>
                              </div></td>
                            <td><font size="1">&nbsp;</font></td>
                            <td valign="top"> <div align="center"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                  <% while f_consulta_docto.siguiente %>
                                  <tr> 
                                    <td><div align="center"><font size="1"> 
                                        <%
					  if f_consulta_docto.ObtenerValor("fecha_documento") <> "" then
					     response.Write(f_consulta_docto.ObtenerValor("fecha_documento"))
					  else
					     response.Write("&nbsp;")
					  end if
					 
					  %>
                                        </font></div></td>
                                  </tr>
                                  <% wend %>
                                  <% for a = f_consulta_docto.nrofilas to Max_Lineas_Pagos -1  %>
                                  <tr> 
                                    <th nowrap><font size="1">&nbsp;</font></th>
                                  </tr>
                                  <% next 
								   f_consulta_docto.primero%>
                                </table>
                              </div></td>
                          </tr>
                        </table></td>
                    </tr>
                    <tr> 
                      <th colspan="3" nowrap> <table width="100%" border="0" cellpadding="0" cellspacing="0">
                          <tr> 
						    <th width="50%" nowrap><div align="left"><font size="1">v&aacute;lido 
                                s&oacute;lo con firma y timbre cajero</font></div></th>
                            <th width="21%" nowrap><div align="right"><font size="1">TOTAL</font></div></th>
                            <th width="0%" nowrap>&nbsp;</th>
                            <th width="14%" nowrap> <div align="right"> 
                                <table width="100%" border="1" align="right" cellpadding="0" cellspacing="0">
                                  <tr> 
                                    <td><div align="right"><font size="1"><%= "$ " & formatnumber(total,0,-1,0-1)%></font></div></td>
                                  </tr>
                                </table>
                              </div></th>
                            <th width="15%" nowrap>&nbsp;</th>
                          </tr>
                        </table></th>
                    </tr>
                    <!--  <tr> 
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>-->
                  </table></th>
              </tr>
            </table></th>
        </tr>
      </table></td>
  </tr>
</table>

</body>
</html>
