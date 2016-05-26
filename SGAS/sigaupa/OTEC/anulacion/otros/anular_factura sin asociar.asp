<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut = Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Emisión Notas de Crédito"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "notas_credito.xml", "botonera"

'response.Write("sede:"&session("sede"))
'response.Flush()
'response.End()
set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede

if not cajero.TieneCajaAbierta then
		msg_alert	="No puede emitir notas de crédito si no tiene una caja abierta."
		ini_ocultar	="<!--"
		fin_ocultar	="-->"
else
	msg_alert=""
end if

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "notas_credito.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv



v_pers_ncorr=conexion.consultaUno("select pers_ncorr from personas where  cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
nombre = conexion.consultauno("select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno  from personas where cast(pers_nrut as varchar) ='"&q_pers_nrut&"' and cast(pers_xdv as varchar) = '"&q_pers_xdv&"'")


set f_ingresos_1 = new CFormulario
f_ingresos_1.Carga_Parametros "notas_credito.xml", "compromisos_por_pagar"
f_ingresos_1.Inicializar conexion

		sql_todos_compromisos_pendientes ="select   tcom_tdesc, b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, b.comp_ndocto as c_comp_ndocto, b.tcom_ccod as c_tcom_ccod,  " & vbCrLf &_
										  "cast(b.dcom_ncompromiso as varchar) + ' / ' + cast(a.comp_ncuotas as varchar) as ncuota, a.comp_fdocto, b.dcom_fcompromiso, b.dcom_mcompromiso,   " & vbCrLf &_
										  "protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as ting_ccod,     " & vbCrLf &_
										  "protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') as ding_ndocto,     " & vbCrLf &_
										  "protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as abonos,   " & vbCrLf &_
										  "protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as documentado,  " & vbCrLf &_ 
										  "protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo,   " & vbCrLf &_
										  "d.edin_ccod, d.edin_tdesc, d.udoc_ccod     " & vbCrLf &_
										  "from  " & vbCrLf &_
										  "compromisos a  " & vbCrLf &_
										  "join detalle_compromisos b  " & vbCrLf &_
										  "on a.tcom_ccod = b.tcom_ccod     " & vbCrLf &_
										  "and a.inst_ccod = b.inst_ccod     " & vbCrLf &_
										  "and a.comp_ndocto = b.comp_ndocto " & vbCrLf &_
										  "left outer join detalle_ingresos c " & vbCrLf &_
										  "	on protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')    = c.ting_ccod    " & vbCrLf &_
										  "	and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto    " & vbCrLf &_
										  "	and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr')  = c.ingr_ncorr   " & vbCrLf &_
										  "left outer join estados_detalle_ingresos d  " & vbCrLf &_
										  "on c.edin_ccod = d.edin_ccod " & vbCrLf &_
										  "join tipos_compromisos e " & vbCrLf &_
										  "on a.tcom_ccod=e.tcom_ccod " & vbCrLf &_
										  "where --protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0 and   " & vbCrLf &_
										  "a.ecom_ccod = '1'   " & vbCrLf &_
										  "and b.ecom_ccod = '1'   " & vbCrLf &_
										  "and cast(a.pers_ncorr as varchar) = '" & v_pers_ncorr & "'"& vbCrLf &_
										  "and isnull(c.ting_ccod,0) not in(5,36) "& vbCrLf &_
										  " and b.dcom_mcompromiso>isnull(protic.abono_nota_credito(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'monto'),0) "& vbCrLf &_
										  "and exists (select 1 "& vbCrLf &_
										  "from detalles dt, tipos_detalle td "& vbCrLf &_
										  "where dt.tdet_ccod=td.tdet_ccod "& vbCrLf &_
										  "and dt.comp_ndocto=a.comp_ndocto "& vbCrLf &_
										  "and dt.tcom_ccod=a.tcom_ccod "& vbCrLf &_
										  "and isnull(td.tben_ccod,0) not in (1,2,3) "& vbCrLf &_
										  "and td.tdet_bboleta='S') "& vbCrLf &_
										  " and exists (select 1 "& vbCrLf &_
											" from detalles dt, tipos_detalle td "& vbCrLf &_
											" where dt.tdet_ccod=td.tdet_ccod "& vbCrLf &_
											" and dt.comp_ndocto=a.comp_ndocto "& vbCrLf &_
											" and dt.tcom_ccod=a.tcom_ccod "& vbCrLf &_
											" and isnull(td.tben_ccod,0) not in (1,2,3)"& vbCrLf &_
											" and isnull(tbol_ccod,2)=2 ) "& vbCrLf &_
										  " UNION "& vbCrLf &_
										  "select   tcom_tdesc, b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, b.comp_ndocto as c_comp_ndocto, b.tcom_ccod as c_tcom_ccod,  " & vbCrLf &_
										  "cast(b.dcom_ncompromiso as varchar) + ' / ' + cast(a.comp_ncuotas as varchar) as ncuota, a.comp_fdocto, b.dcom_fcompromiso, b.dcom_mcompromiso,   " & vbCrLf &_
										  "protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as ting_ccod,     " & vbCrLf &_
										  "protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') as ding_ndocto,     " & vbCrLf &_
										  "protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as abonos,   " & vbCrLf &_
										  "protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as documentado,  " & vbCrLf &_ 
										  "protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo,   " & vbCrLf &_
										  "d.edin_ccod, d.edin_tdesc, d.udoc_ccod     " & vbCrLf &_
										  "from  " & vbCrLf &_
										  "compromisos a  " & vbCrLf &_
										  "join detalle_compromisos b  " & vbCrLf &_
										  "on a.tcom_ccod = b.tcom_ccod     " & vbCrLf &_
										  "and a.inst_ccod = b.inst_ccod     " & vbCrLf &_
										  "and a.comp_ndocto = b.comp_ndocto " & vbCrLf &_
										  "left outer join detalle_ingresos c " & vbCrLf &_
										  "	on protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')    = c.ting_ccod    " & vbCrLf &_
										  "	and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto    " & vbCrLf &_
										  "	and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr')  = c.ingr_ncorr   " & vbCrLf &_
										  "left outer join estados_detalle_ingresos d  " & vbCrLf &_
										  "on c.edin_ccod = d.edin_ccod " & vbCrLf &_
										  "join tipos_compromisos e " & vbCrLf &_
										  "on a.tcom_ccod=e.tcom_ccod " & vbCrLf &_
										  "where --protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0 and   " & vbCrLf &_
										  "a.ecom_ccod = '1'   " & vbCrLf &_
										  "and b.ecom_ccod = '1'   " & vbCrLf &_
										  "and cast(a.pers_ncorr as varchar) = '" & v_pers_ncorr & "'"& vbCrLf &_
										  "and isnull(c.ting_ccod,0) in(49,50) "& vbCrLf &_
										  " and b.dcom_mcompromiso>isnull(protic.abono_nota_credito(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'monto'),0) "& vbCrLf &_
										  " and exists (select 1 "& vbCrLf &_
											" from detalles dt, tipos_detalle td "& vbCrLf &_
											" where dt.tdet_ccod=td.tdet_ccod "& vbCrLf &_
											" and dt.comp_ndocto=a.comp_ndocto "& vbCrLf &_
											" and dt.tcom_ccod=a.tcom_ccod "& vbCrLf &_
											" and isnull(td.tben_ccod,0) not in (1,2,3)"& vbCrLf &_
											" and isnull(tbol_ccod,2)=2 ) "

'response.Write("<pre>"&sql_todos_compromisos_pendientes&"</pre>")

f_ingresos_1.Consultar sql_todos_compromisos_pendientes



if f_ingresos_1.NroFilas = 0 then
	f_botonera.AgregaBotonParam "aceptar", "deshabilitado", "TRUE"
end if
'---------------------------------------------------------------------------------------------------



set f_ingresos_2 = new CFormulario
f_ingresos_2.Carga_Parametros "notas_credito.xml", "compromisos_por_pagar_editorial"
f_ingresos_2.Inicializar conexion

		sql_todos_compromisos_pendientes_editorial ="select   tcom_tdesc, b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, b.comp_ndocto as c_comp_ndocto, b.tcom_ccod as c_tcom_ccod,  " & vbCrLf &_
													  "cast(b.dcom_ncompromiso as varchar) + ' / ' + cast(a.comp_ncuotas as varchar) as ncuota, a.comp_fdocto, b.dcom_fcompromiso, b.dcom_mcompromiso,   " & vbCrLf &_
													  "protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as ting_ccod,     " & vbCrLf &_
													  "protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') as ding_ndocto,     " & vbCrLf &_
													  "protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as abonos,   " & vbCrLf &_
													  "protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as documentado,  " & vbCrLf &_ 
													  "protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo,   " & vbCrLf &_
													  "d.edin_ccod, d.edin_tdesc, d.udoc_ccod     " & vbCrLf &_
													  "from  " & vbCrLf &_
													  "compromisos a  " & vbCrLf &_
													  "join detalle_compromisos b  " & vbCrLf &_
													  "on a.tcom_ccod = b.tcom_ccod     " & vbCrLf &_
													  "and a.inst_ccod = b.inst_ccod     " & vbCrLf &_
													  "and a.comp_ndocto = b.comp_ndocto " & vbCrLf &_
													  "left outer join detalle_ingresos c " & vbCrLf &_
													  "	on protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')    = c.ting_ccod    " & vbCrLf &_
													  "	and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto    " & vbCrLf &_
													  "	and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr')  = c.ingr_ncorr   " & vbCrLf &_
													  "left outer join estados_detalle_ingresos d  " & vbCrLf &_
													  "on c.edin_ccod = d.edin_ccod " & vbCrLf &_
													  "join tipos_compromisos e " & vbCrLf &_
													  "on a.tcom_ccod=e.tcom_ccod " & vbCrLf &_
													  "where --protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0 and   " & vbCrLf &_
													  "a.ecom_ccod = '1'   " & vbCrLf &_
													  "and b.ecom_ccod = '1'   " & vbCrLf &_
													  "and cast(a.pers_ncorr as varchar) = '" & v_pers_ncorr & "'"& vbCrLf &_
													  "and isnull(c.ting_ccod,0) not in(5,36) "& vbCrLf &_
													  " and b.dcom_mcompromiso>isnull(protic.abono_nota_credito(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'monto'),0) "& vbCrLf &_
													  "and exists (select 1 "& vbCrLf &_
													  "from detalles dt, tipos_detalle td "& vbCrLf &_
													  "where dt.tdet_ccod=td.tdet_ccod "& vbCrLf &_
													  "and dt.comp_ndocto=a.comp_ndocto "& vbCrLf &_
													  "and dt.tcom_ccod=a.tcom_ccod "& vbCrLf &_
													  "and isnull(td.tben_ccod,0) not in (1,2,3) "& vbCrLf &_
													  "and td.tdet_bboleta='S') "& vbCrLf &_
													  " and exists (select 1 "& vbCrLf &_
														" from detalles dt, tipos_detalle td "& vbCrLf &_
														" where dt.tdet_ccod=td.tdet_ccod "& vbCrLf &_
														" and dt.comp_ndocto=a.comp_ndocto "& vbCrLf &_
														" and dt.tcom_ccod=a.tcom_ccod "& vbCrLf &_
														" and isnull(td.tben_ccod,0) not in (1,2,3)"& vbCrLf &_
														" and isnull(tbol_ccod,2)=1 ) "& vbCrLf &_
													  " UNION "& vbCrLf &_
													  "select   tcom_tdesc, b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, b.comp_ndocto as c_comp_ndocto, b.tcom_ccod as c_tcom_ccod,  " & vbCrLf &_
													  "cast(b.dcom_ncompromiso as varchar) + ' / ' + cast(a.comp_ncuotas as varchar) as ncuota, a.comp_fdocto, b.dcom_fcompromiso, b.dcom_mcompromiso,   " & vbCrLf &_
													  "protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as ting_ccod,     " & vbCrLf &_
													  "protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') as ding_ndocto,     " & vbCrLf &_
													  "protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as abonos,   " & vbCrLf &_
													  "protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as documentado,  " & vbCrLf &_ 
													  "protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo,   " & vbCrLf &_
													  "d.edin_ccod, d.edin_tdesc, d.udoc_ccod     " & vbCrLf &_
													  "from  " & vbCrLf &_
													  "compromisos a  " & vbCrLf &_
													  "join detalle_compromisos b  " & vbCrLf &_
													  "on a.tcom_ccod = b.tcom_ccod     " & vbCrLf &_
													  "and a.inst_ccod = b.inst_ccod     " & vbCrLf &_
													  "and a.comp_ndocto = b.comp_ndocto " & vbCrLf &_
													  "left outer join detalle_ingresos c " & vbCrLf &_
													  "	on protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')    = c.ting_ccod    " & vbCrLf &_
													  "	and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto    " & vbCrLf &_
													  "	and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr')  = c.ingr_ncorr   " & vbCrLf &_
													  "left outer join estados_detalle_ingresos d  " & vbCrLf &_
													  "on c.edin_ccod = d.edin_ccod " & vbCrLf &_
													  "join tipos_compromisos e " & vbCrLf &_
													  "on a.tcom_ccod=e.tcom_ccod " & vbCrLf &_
													  "where --protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0 and   " & vbCrLf &_
													  "a.ecom_ccod = '1'   " & vbCrLf &_
													  "and b.ecom_ccod = '1'   " & vbCrLf &_
													  "and cast(a.pers_ncorr as varchar) = '" & v_pers_ncorr & "'"& vbCrLf &_
													  "and isnull(c.ting_ccod,0) in(49,50) "& vbCrLf &_
													  " and b.dcom_mcompromiso>isnull(protic.abono_nota_credito(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'monto'),0) "& vbCrLf &_
													  " and exists (select 1 "& vbCrLf &_
														" from detalles dt, tipos_detalle td "& vbCrLf &_
														" where dt.tdet_ccod=td.tdet_ccod "& vbCrLf &_
														" and dt.comp_ndocto=a.comp_ndocto "& vbCrLf &_
														" and dt.tcom_ccod=a.tcom_ccod "& vbCrLf &_
														" and isnull(td.tben_ccod,0) not in (1,2,3)"& vbCrLf &_
														" and isnull(tbol_ccod,2)=1 ) "

'response.Write("<pre>"&sql_todos_compromisos_pendientes&"</pre>")

f_ingresos_2.Consultar sql_todos_compromisos_pendientes_editorial

'----------------------------------------------------------------


sql_usos_notacredito="select uncr_ccod,uncr_tdesc from uso_nota_credito order by uncr_ccod asc "
set f_usos = new CFormulario
f_usos.Carga_Parametros "consulta.xml", "consulta"
f_usos.Inicializar conexion

sql_usos_notacredito="select uncr_ccod,uncr_tdesc from uso_nota_credito order by uncr_ccod asc "

f_usos.Consultar sql_usos_notacredito

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
function ValidarEmision()
{
formu=document.edicion;
	if (t_ingresos.CuentaSeleccionados("dcom_ncompromiso") == 0 ) {
		alert('Debe seleccionar uno o más ingresos para emitir nota de crédito.');
		return false;
	}
	return true;
}
function ValidarEmisionEditorial()
{
formu=document.edicion_editorial;
	if (t_ingresos_editorial.CuentaSeleccionados("dcom_ncompromiso") == 0 ) {
		alert('Debe seleccionar uno o más ingresos para emitir nota de crédito.');
		return false;
	}
	return true;
}

var t_ingresos;

function InicioPagina()
{
	t_ingresos = new CTabla("cc_compromisos")
	t_ingresos_editorial = new CTabla("cc_compromisos_editorial")
}


function mensaje(){
<%if msg_alert <> "" then%>
alert('<%=msg_alert%>');
<%end if%>
}

</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                    <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td><div align="right"><strong>R.U.T. Institucion </strong></div></td>
                        <td width="50"><div align="center"><strong>:</strong></div></td>
                        <td><%f_busqueda.DibujaCampo("pers_nrut")%> 
                          - 
                            <%f_busqueda.DibujaCampo("pers_xdv")%> <%pagina.DibujarBuscaPersonas "b[0][pers_nrut]", "b[0][pers_xdv]"%></td>
							<td><strong>N° Factura</strong></td>
							<td><%f_busqueda.DibujaCampo("fact_nfactura")%></td>
                      </tr>
                    </table>
                  </div></td>
                  <td width="19%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td>
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
	<br>
	<%=ini_ocultar%>
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
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
				<br/>
			<table width="96%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="27%"><strong>Rut</strong></td>
					<td width="2%"><strong>:</strong></td>
					<td width="71%"><%=q_pers_nrut&"-"&q_pers_xdv%></td>
				</tr>
				<tr>
					<td><strong>Nombre o institucion</strong></td>
					<td><strong>:</strong></td>
					<td><%=nombre%></td>
				</tr>

			  </table>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Ingresos Universidad"%>
                      <input type="hidden" name="pers_ncorr" value="<%=v_pers_ncorr%>">
					  <input type="hidden" name="institucion" value="1">                          
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
						 <tr>
                          	<td><div align="center"><%f_ingresos_1.DibujaTabla%></div></td>
                         </tr>
                        <tr>
                          <td align="left"><%f_botonera.DibujaBoton("aceptar")%></td>
                        </tr>
                      </table>
   					</td>
                  </tr>
                </table>
            </form> <br>
			<form name="edicion_editorial">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Ingresos Editorial"%>
                      <input type="hidden" name="pers_ncorr" value="<%=v_pers_ncorr%>">
					  <input type="hidden" name="institucion" value="3">                      
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
						 <tr>
                          	<td><div align="center"><%f_ingresos_2.DibujaTabla%></div></td>
                         </tr>
                        <tr>
                          <td align="left"><%f_botonera.DibujaBoton("aceptar_editorial")%></td>
                        </tr>
                      </table>
   					</td>
                  </tr>
                </table>
            </form> <br>
			</td>
			</tr>
        </table>
		
		</td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="15%" height="20"><div align="center"></div></td>
            <td width="85%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
	<%=fin_ocultar%>	
	</td>
  </tr>  
</table>
</body>
</html>
