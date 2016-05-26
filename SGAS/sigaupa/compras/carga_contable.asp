<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO:COMPRAS Y AUT. DE GIRO
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:23/09/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ORDEN DE COMPRA
'LINEA			:
'*******************************************************************
OPCION		= request.QueryString("OPCION")

if OPCION="" then
OPCION=1
end if

set pagina = new CPagina
pagina.Titulo = "Carga Contable"

set botonera = new CFormulario
botonera.carga_parametros "carga_contable.xml", "botonera"

set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new cnegocio
negocio.Inicializa conectar

v_usuario=negocio.ObtenerUsuario()

 set f_solicitudes = new CFormulario
 f_solicitudes.Carga_Parametros "carga_contable.xml", "solicitudes"
 f_solicitudes.Inicializar conectar

select case (OPCION)
	case 1:
	' POR TRASPASAR
'	sql_solicitudes	=	"select sogi_ncorr as cod_solicitud, protic.obtener_nombre_completo(pers_ncorr_proveedor,'n') as nombre,'' as aprueba,"&_
'						" '1' as tipo,1 as tsol_ccod, sogi_mgiro as monto,mes_ccod, anos_ccod, '' AS asgi_fautorizado from ocag_solicitud_giro where vibo_ccod=6 "&_
'						" Union "&_
'						"select rgas_ncorr as cod_solicitud, protic.obtener_nombre_completo(pers_ncorr_proveedor,'n') as nombre, '' as aprueba,"&_
'						" '2' as tipo,'2' as tsol_ccod, rgas_mgiro as monto,mes_ccod, anos_ccod, '' AS asgi_fautorizado from ocag_reembolso_gastos where vibo_ccod=6 "&_
'						" Union "&_
'						"select fren_ncorr as cod_solicitud, protic.obtener_nombre_completo(pers_ncorr,'n') as nombre, '' as aprueba,"&_
'						" '3' as tipo,'3' as tsol_ccod, fren_mmonto as monto,mes_ccod, anos_ccod, '' AS asgi_fautorizado from ocag_fondos_a_rendir where vibo_ccod=6 "&_
'						" Union "&_
'						"select sovi_ncorr as cod_solicitud, protic.obtener_nombre_completo(pers_ncorr,'n') as nombre, '' as aprueba,"&_
'						" '4' as tipo,'4' as tsol_ccod, sovi_mmonto_pesos as monto,mes_ccod, anos_ccod, '' AS asgi_fautorizado from ocag_solicitud_viatico where vibo_ccod=6 "&_
'						" Union "&_
'						"select dalu_ncorr as cod_solicitud, protic.obtener_nombre_completo(pers_ncorr,'n') as nombre, '' as aprueba,"&_
'						" '5' as tipo,'5' as tsol_ccod, dalu_mmonto_pesos as monto,mes_ccod, anos_ccod, '' AS asgi_fautorizado from ocag_devolucion_alumno where vibo_ccod=6 "&_
'						" Union "&_
'						"select ffij_ncorr as cod_solicitud, protic.obtener_nombre_completo(pers_ncorr,'n') as nombre, '' as aprueba,"&_
'						" '6' as tipo,'6' as tsol_ccod, ffij_mmonto_pesos as monto,mes_ccod, anos_ccod, '' AS asgi_fautorizado from ocag_fondo_fijo where vibo_ccod=6 "	
						
	sql_solicitudes	=	"select sogi_ncorr as cod_solicitud, protic.obtener_nombre_completo(pers_ncorr_proveedor,'n') as nombre,'' as aprueba, '1' as tipo,'1' as tsol_ccod "&_
						", sogi_mgiro as monto,mes_ccod, anos_ccod, '' AS asgi_fautorizado "&_
						", '<a href=  javascript:VerSolicitud('+cast(sogi_ncorr as varchar)+',1);  >ver</a>' as solicitud "&_
						", sogi_bboleta_honorario "&_
						"from ocag_solicitud_giro "&_
						"where (vibo_ccod=6 AND ocag_baprueba_rector =2) or (vibo_ccod=11 AND ocag_baprueba_rector =1)  "&_
						"Union "&_
						"select rgas_ncorr as cod_solicitud, protic.obtener_nombre_completo(pers_ncorr_proveedor,'n') as nombre, '' as aprueba, '2' as tipo,'2' as tsol_ccod "&_
						", rgas_mgiro as monto,mes_ccod, anos_ccod, '' AS asgi_fautorizado "&_
						", '<a href=  javascript:VerSolicitud('+cast(rgas_ncorr as varchar)+',2);  >ver</a>' as solicitud "&_
						", 0 AS sogi_bboleta_honorario "&_
						"from ocag_reembolso_gastos "&_
						"where (vibo_ccod=6 AND ocag_baprueba_rector =2) or (vibo_ccod=11 AND ocag_baprueba_rector =1) "&_
						"Union "&_
						"select fren_ncorr as cod_solicitud, protic.obtener_nombre_completo(pers_ncorr,'n') as nombre, '' as aprueba, '3' as tipo,'3' as tsol_ccod, fren_mmonto as monto "&_
						",mes_ccod, anos_ccod, '' AS asgi_fautorizado "&_
						", '<a href=  javascript:VerSolicitud('+cast(fren_ncorr as varchar)+',3);  >ver</a>' as solicitud "&_
						", 0 AS sogi_bboleta_honorario "&_
						"from ocag_fondos_a_rendir "&_
						"where(vibo_ccod=6 AND ocag_baprueba_rector =2) or (vibo_ccod=11 AND ocag_baprueba_rector =1)  "&_
						"Union  "&_
						"select sovi_ncorr as cod_solicitud, protic.obtener_nombre_completo(pers_ncorr,'n') as nombre, '' as aprueba, '4' as tipo,'4' as tsol_ccod, sovi_mmonto_pesos as monto "&_
						", mes_ccod, anos_ccod, '' AS asgi_fautorizado "&_
						", '<a href=  javascript:VerSolicitud('+cast(sovi_ncorr as varchar)+',4);  >ver</a>' as solicitud "&_
						", 0 AS sogi_bboleta_honorario "&_
						"from ocag_solicitud_viatico "&_
						"where (vibo_ccod=6 AND ocag_baprueba_rector =2) or (vibo_ccod=11 AND ocag_baprueba_rector =1) "&_
						"Union "&_
						"select dalu_ncorr as cod_solicitud, protic.obtener_nombre_completo(pers_ncorr,'n') as nombre, '' as aprueba, '5' as tipo,'5' as tsol_ccod, dalu_mmonto_pesos as monto "&_
						",mes_ccod, anos_ccod, '' AS asgi_fautorizado "&_
						", '<a href=  javascript:VerSolicitud('+cast(dalu_ncorr as varchar)+',5);  >ver</a>' as solicitud "&_
						", 0 AS sogi_bboleta_honorario "&_
						"from ocag_devolucion_alumno "&_
						"where (vibo_ccod=6 AND ocag_baprueba_rector =2) or (vibo_ccod=11 AND ocag_baprueba_rector =1)  "&_
						"Union "&_
						"select ffij_ncorr as cod_solicitud, protic.obtener_nombre_completo(pers_ncorr,'n') as nombre, '' as aprueba, '6' as tipo,'6' as tsol_ccod, ffij_mmonto_pesos as monto "&_
						",mes_ccod, anos_ccod, '' AS asgi_fautorizado "&_
						", '<a href=  javascript:VerSolicitud('+cast(ffij_ncorr as varchar)+',6);  >ver</a>' as solicitud "&_
						", 0 AS sogi_bboleta_honorario "&_
						"from ocag_fondo_fijo "&_
						"where (vibo_ccod=6 AND ocag_baprueba_rector =2) or (vibo_ccod=11 AND ocag_baprueba_rector =1) "&_
						"Union "&_
						"select a.rfre_ncorr as cod_solicitud, protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre, '' as aprueba, '7' as tipo ,'7' as tsol_ccod, b.fren_mmonto as monto "&_
						", b.mes_ccod, b.anos_ccod, '' AS asgi_fautorizado "&_
						", '<a href=  javascript:VerSolicitud('+cast(a.fren_ncorr as varchar)+',7);  >ver</a>' as solicitud "&_
						", 0 AS sogi_bboleta_honorario "&_
						"from ocag_rendicion_fondos_a_rendir a "&_
						"INNER JOIN ocag_fondos_a_rendir b "&_
						"ON a.fren_ncorr = B.fren_ncorr "&_
						"where (a.vibo_ccod = 6 AND a.ocag_baprueba_rector = 2) or (a.vibo_ccod = 11 AND a.ocag_baprueba_rector = 1) "&_
						"Union "&_
						"select a.rffi_ncorr as cod_solicitud, protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre, '' as aprueba, '8' as tipo ,'8' as tsol_ccod "&_
						", b.ffij_mmonto_pesos as monto, b.mes_ccod, b.anos_ccod, '' AS asgi_fautorizado "&_
						", '<a href=  javascript:VerSolicitud('+cast(a.ffij_ncorr as varchar)+',8);  >ver</a>' as solicitud "&_
						", 0 AS sogi_bboleta_honorario "&_
						"from ocag_rendicion_fondo_fijo a "&_
						"INNER JOIN ocag_fondo_fijo b "&_
						"ON a.ffij_ncorr = b.ffij_ncorr "&_
						"WHERE (a.vibo_ccod = 6 AND a.ocag_baprueba_rector = 2) or (a.vibo_ccod = 11 AND a.ocag_baprueba_rector = 1) ORDER BY sogi_ncorr DESC"	
						
	pagina.Titulo = "Carga Contable - Pendientes"

	case 2:
	' TRASPASADOS HOY

	sql_solicitudes	=	"select a.sogi_ncorr as cod_solicitud, protic.obtener_nombre_completo(a.pers_ncorr_proveedor,'n') as nombre, '1' as tipo, '1' as tsol_ccod "&_
						", a.sogi_mgiro as monto, a.mes_ccod, a.anos_ccod, b.asgi_fautorizado "&_
						", '<a href=  javascript:VerSolicitud('+cast(sogi_ncorr as varchar)+',1);  >ver</a>' as solicitud "&_
						"from ocag_solicitud_giro a "&_
						"INNER JOIN ocag_autoriza_solicitud_giro b "&_
						"ON a.sogi_ncorr = b.cod_solicitud "&_
						"AND a.vibo_ccod>=7 AND b.vibo_ccod>=7 AND b.tsol_ccod=1 "&_
						"and b.asgi_fautorizado = protic.trunc(GETDATE()) "&_
						"Union "&_
						"select a.rgas_ncorr as cod_solicitud, protic.obtener_nombre_completo(a.pers_ncorr_proveedor,'n') as nombre, '2' as tipo, '2' as tsol_ccod "&_
						", a.rgas_mgiro as monto, a.mes_ccod, a.anos_ccod, b.asgi_fautorizado "&_
						", '<a href=  javascript:VerSolicitud('+cast(rgas_ncorr as varchar)+',2);  >ver</a>' as solicitud "&_
						"from ocag_reembolso_gastos a "&_
						"INNER JOIN ocag_autoriza_solicitud_giro b "&_
						"ON a.rgas_ncorr = b.cod_solicitud "&_
						"AND a.vibo_ccod>=7 AND b.vibo_ccod>=7 AND b.tsol_ccod=2 "&_
						"and b.asgi_fautorizado = protic.trunc(GETDATE()) "&_
						"Union "&_
						"select a.fren_ncorr as cod_solicitud, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, '3' as tipo, '3' as tsol_ccod "&_
						", a.fren_mmonto as monto, a.mes_ccod, a.anos_ccod, b.asgi_fautorizado "&_
						", '<a href=  javascript:VerSolicitud('+cast(fren_ncorr as varchar)+',3);  >ver</a>' as solicitud "&_
						"from ocag_fondos_a_rendir a "&_
						"INNER JOIN ocag_autoriza_solicitud_giro b "&_
						"ON a.fren_ncorr = b.cod_solicitud "&_
						"AND a.vibo_ccod>=7 AND b.vibo_ccod>=7 AND b.tsol_ccod=3 "&_
						"and b.asgi_fautorizado = protic.trunc(GETDATE()) "&_
						"Union "&_
						"select a.sovi_ncorr as cod_solicitud, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, '4' as tipo, '4' as tsol_ccod "&_
						", a.sovi_mmonto_pesos as monto, a.mes_ccod, a.anos_ccod, b.asgi_fautorizado "&_
						", '<a href=  javascript:VerSolicitud('+cast(sovi_ncorr as varchar)+',4);  >ver</a>' as solicitud "&_
						"from ocag_solicitud_viatico a "&_
						"INNER JOIN ocag_autoriza_solicitud_giro b "&_
						"ON a.sovi_ncorr = b.cod_solicitud "&_
						"AND a.vibo_ccod>=7 AND b.vibo_ccod>=7 AND b.tsol_ccod=4 "&_
						"and b.asgi_fautorizado = protic.trunc(GETDATE()) "&_
						"Union "&_
						"select a.dalu_ncorr as cod_solicitud, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, '5' as tipo,'5' as tsol_ccod "&_
						", a.dalu_mmonto_pesos as monto, a.mes_ccod, a.anos_ccod, b.asgi_fautorizado "&_
						", '<a href=  javascript:VerSolicitud('+cast(dalu_ncorr as varchar)+',5);  >ver</a>' as solicitud "&_
						"from ocag_devolucion_alumno a "&_
						"INNER JOIN ocag_autoriza_solicitud_giro b "&_
						"ON a.dalu_ncorr = b.cod_solicitud "&_
						"AND a.vibo_ccod>=7 AND b.vibo_ccod>=7 AND b.tsol_ccod=5 "&_
						"and b.asgi_fautorizado = protic.trunc(GETDATE()) "&_
						"Union "&_
						"select a.ffij_ncorr as cod_solicitud, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, '6' as tipo,'6' as tsol_ccod "&_
						", a.ffij_mmonto_pesos as monto, a.mes_ccod, a.anos_ccod, b.asgi_fautorizado "&_
						", '<a href=  javascript:VerSolicitud('+cast(ffij_ncorr as varchar)+',6);  >ver</a>' as solicitud "&_
						"from ocag_fondo_fijo a "&_
						"INNER JOIN ocag_autoriza_solicitud_giro b "&_
						"ON a.ffij_ncorr = b.cod_solicitud "&_
						"AND a.vibo_ccod>=7 AND b.vibo_ccod>=7 AND b.tsol_ccod=6 "&_
						"and b.asgi_fautorizado = protic.trunc(GETDATE())  "&_
						"Union "&_
						"select a.rfre_ncorr as cod_solicitud, protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre, '7' as tipo, '7' as tsol_ccod , b.fren_mmonto as monto "&_
						", b.mes_ccod , b.anos_ccod, c.asgi_fautorizado ,  '<a href=  javascript:VerSolicitud('+cast(a.fren_ncorr as varchar)+',7);  >ver</a>' as solicitud "&_
						"from ocag_rendicion_fondos_a_rendir a "&_
						"INNER JOIN ocag_fondos_a_rendir b "&_
						"ON a.fren_ncorr = B.fren_ncorr "&_
						"AND a.vibo_ccod>=7 "&_
						"AND b.vibo_ccod>=7 "&_
						"INNER JOIN ocag_autoriza_solicitud_giro c "&_
						"ON a.rfre_ncorr = c.cod_solicitud and c.tsol_ccod = 7 and c.vibo_ccod = 7 "&_
						"and c.asgi_fautorizado = protic.trunc(GETDATE()) "&_
						"Union "&_
						"select a.rffi_ncorr as cod_solicitud, protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre, '8' as tipo,'8' as tsol_ccod , b.ffij_mmonto_pesos as monto "&_
						", b.mes_ccod, b.anos_ccod , c.asgi_fautorizado , '<a href=  javascript:VerSolicitud('+cast(a.ffij_ncorr as varchar)+',8);  >ver</a>' as solicitud "&_
						"from ocag_rendicion_fondo_fijo a "&_
						"INNER JOIN ocag_fondo_fijo b "&_
						"ON a.ffij_ncorr = B.ffij_ncorr "&_
						"AND a.vibo_ccod>=7 "&_
						"AND b.vibo_ccod>=7 "&_
						"INNER JOIN ocag_autoriza_solicitud_giro c "&_
						"ON a.rffi_ncorr = c.cod_solicitud and c.tsol_ccod = 8 and c.vibo_ccod = 7 "&_
						"and c.asgi_fautorizado = protic.trunc(GETDATE()) "
						
	pagina.Titulo = "Carga Contable - Hoy"
							
	case 3:
	' HISTORICO
	
	sql_solicitudes	=	"select a.sogi_ncorr as cod_solicitud, protic.obtener_nombre_completo(a.pers_ncorr_proveedor,'n') as nombre, '1' as tipo, '1' as tsol_ccod "&_
						", a.sogi_mgiro as monto, a.mes_ccod, a.anos_ccod, b.asgi_fautorizado "&_
						", '<a href=  javascript:VerSolicitud('+cast(sogi_ncorr as varchar)+',1);  >ver</a>' as solicitud "&_
						"from ocag_solicitud_giro a "&_
						"INNER JOIN ocag_autoriza_solicitud_giro b "&_
						"ON a.sogi_ncorr = b.cod_solicitud "&_
						"AND a.vibo_ccod>=7 AND b.vibo_ccod>=7 AND b.tsol_ccod=1 "&_
						"and b.asgi_fautorizado < protic.trunc(GETDATE()) "&_
						"Union "&_
						"select a.rgas_ncorr as cod_solicitud, protic.obtener_nombre_completo(a.pers_ncorr_proveedor,'n') as nombre, '2' as tipo, '2' as tsol_ccod "&_
						", a.rgas_mgiro as monto, a.mes_ccod, a.anos_ccod, b.asgi_fautorizado "&_
						", '<a href=  javascript:VerSolicitud('+cast(rgas_ncorr as varchar)+',2);  >ver</a>' as solicitud "&_
						"from ocag_reembolso_gastos a "&_
						"INNER JOIN ocag_autoriza_solicitud_giro b "&_
						"ON a.rgas_ncorr = b.cod_solicitud "&_
						"AND a.vibo_ccod>=7 AND b.vibo_ccod>=7 AND b.tsol_ccod=2 "&_
						"and b.asgi_fautorizado < protic.trunc(GETDATE()) "&_
						"Union "&_
						"select a.fren_ncorr as cod_solicitud, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, '3' as tipo, '3' as tsol_ccod "&_
						", a.fren_mmonto as monto, a.mes_ccod, a.anos_ccod, b.asgi_fautorizado "&_
						", '<a href=  javascript:VerSolicitud('+cast(fren_ncorr as varchar)+',3);  >ver</a>' as solicitud "&_
						"from ocag_fondos_a_rendir a "&_
						"INNER JOIN ocag_autoriza_solicitud_giro b "&_
						"ON a.fren_ncorr = b.cod_solicitud "&_
						"AND a.vibo_ccod>=7 AND b.vibo_ccod>=7 AND b.tsol_ccod=3 "&_
						"and b.asgi_fautorizado < protic.trunc(GETDATE()) "&_
						"Union "&_
						"select a.sovi_ncorr as cod_solicitud, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, '4' as tipo, '4' as tsol_ccod "&_
						", a.sovi_mmonto_pesos as monto, a.mes_ccod, a.anos_ccod, b.asgi_fautorizado "&_
						", '<a href=  javascript:VerSolicitud('+cast(sovi_ncorr as varchar)+',4);  >ver</a>' as solicitud "&_
						"from ocag_solicitud_viatico a "&_
						"INNER JOIN ocag_autoriza_solicitud_giro b "&_
						"ON a.sovi_ncorr = b.cod_solicitud "&_
						"AND a.vibo_ccod>=7 AND b.vibo_ccod>=7 AND b.tsol_ccod=4 "&_
						"and b.asgi_fautorizado < protic.trunc(GETDATE()) "&_
						"Union "&_
						"select a.dalu_ncorr as cod_solicitud, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, '5' as tipo,'5' as tsol_ccod "&_
						", a.dalu_mmonto_pesos as monto, a.mes_ccod, a.anos_ccod, b.asgi_fautorizado "&_
						", '<a href=  javascript:VerSolicitud('+cast(dalu_ncorr as varchar)+',5);  >ver</a>' as solicitud "&_
						"from ocag_devolucion_alumno a "&_
						"INNER JOIN ocag_autoriza_solicitud_giro b "&_
						"ON a.dalu_ncorr = b.cod_solicitud "&_
						"AND a.vibo_ccod>=7 AND b.vibo_ccod>=7 AND b.tsol_ccod=5 "&_
						"and b.asgi_fautorizado < protic.trunc(GETDATE()) "&_
						"Union "&_
						"select a.ffij_ncorr as cod_solicitud, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, '6' as tipo,'6' as tsol_ccod "&_
						", a.ffij_mmonto_pesos as monto, a.mes_ccod, a.anos_ccod, b.asgi_fautorizado "&_
						", '<a href=  javascript:VerSolicitud('+cast(ffij_ncorr as varchar)+',6);  >ver</a>' as solicitud "&_
						"from ocag_fondo_fijo a "&_
						"INNER JOIN ocag_autoriza_solicitud_giro b "&_
						"ON a.ffij_ncorr = b.cod_solicitud "&_
						"AND a.vibo_ccod>=7 AND b.vibo_ccod>=7 AND b.tsol_ccod=6 "&_
						"and b.asgi_fautorizado < protic.trunc(GETDATE()) "&_
						"Union "&_
						"select a.rfre_ncorr as cod_solicitud, protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre, '7' as tipo, '7' as tsol_ccod , b.fren_mmonto as monto "&_
						", b.mes_ccod , b.anos_ccod, c.asgi_fautorizado ,  '<a href=  javascript:VerSolicitud('+cast(a.fren_ncorr as varchar)+',7);  >ver</a>' as solicitud "&_
						"from ocag_rendicion_fondos_a_rendir a "&_
						"INNER JOIN ocag_fondos_a_rendir b "&_
						"ON a.fren_ncorr = B.fren_ncorr "&_
						"AND a.vibo_ccod>=7 "&_
						"AND b.vibo_ccod>=7 "&_
						"INNER JOIN ocag_autoriza_solicitud_giro c "&_
						"ON a.rfre_ncorr = c.cod_solicitud and c.tsol_ccod = 7 and c.vibo_ccod = 7 "&_
						"and c.asgi_fautorizado < protic.trunc(GETDATE()) "&_
						"Union "&_
						"select a.rffi_ncorr as cod_solicitud, protic.obtener_nombre_completo(b.pers_ncorr,'n') as nombre, '8' as tipo,'8' as tsol_ccod , b.ffij_mmonto_pesos as monto "&_
						", b.mes_ccod, b.anos_ccod , c.asgi_fautorizado , '<a href=  javascript:VerSolicitud('+cast(a.ffij_ncorr as varchar)+',8);  >ver</a>' as solicitud "&_
						"from ocag_rendicion_fondo_fijo a "&_
						"INNER JOIN ocag_fondo_fijo b "&_
						"ON a.ffij_ncorr = B.ffij_ncorr "&_
						"AND a.vibo_ccod>=7 "&_
						"AND b.vibo_ccod>=7 "&_
						"INNER JOIN ocag_autoriza_solicitud_giro c "&_
						"ON a.rffi_ncorr = c.cod_solicitud and c.tsol_ccod = 8 and c.vibo_ccod = 7 "&_
						"and c.asgi_fautorizado < protic.trunc(GETDATE()) "
						
	pagina.Titulo = "Carga Contable - Historico"
	
	End Select

	'response.Write("1. sql_solicitudes : "&sql_solicitudes&"<BR>")

f_solicitudes.Consultar sql_solicitudes
 
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


function Enviar(){
	formulario = document.buscador;
	//validar campos vacios
	return true;
}

function Mensaje()
{
	<% 
		if session("mensaje_error")<>"" then
	%>
		alert("<%=session("mensaje_error")%>");
	<%
		session("mensaje_error")=""
		end if
	%>
}

function VerSolicitud(codigo,tsol_ccod){
	window.open("ver_solicitud_giro.asp?solicitud="+codigo+"&tsol_ccod="+tsol_ccod,"solicitud",'scrollbars=yes, menubar=no, resizable=yes, width=800,height=500');
}

function CambiaValor(obj){
	v_name=obj.name;
	v_valor=obj.value;
	v_indice=extrae_indice(v_name);
	if (v_valor==2){
		document.datos.elements["datos["+v_indice+"][asgi_tobservaciones]"].disabled=false;
		document.datos.elements["datos["+v_indice+"][asgi_tobservaciones]"].value="";
		document.datos.elements["datos["+v_indice+"][asgi_nestado]"].disabled=false;
	}else{
		document.datos.elements["datos["+v_indice+"][asgi_tobservaciones]"].disabled=true;
		document.datos.elements["datos["+v_indice+"][asgi_nestado]"].disabled=true;
	}	

}


function seleccionar(elemento){
	if (elemento.checked){
		str=elemento.name;
		v_indice=extrae_indice(str);
		document.datos.elements["datos["+v_indice+"][aprueba]"][0].checked=true;
		document.datos.elements["datos["+v_indice+"][aprueba]"][0].disabled=false;
		document.datos.elements["datos["+v_indice+"][aprueba]"][1].disabled=false;
		document.datos.elements["datos["+v_indice+"][asgi_frecepcion_presupuesto]"].disabled=false;
		
		document.datos.elements["datos["+v_indice+"][aprueba_r]"][0].checked=true;
		document.datos.elements["datos["+v_indice+"][aprueba_r]"][0].disabled=false;
		document.datos.elements["datos["+v_indice+"][aprueba_r]"][1].disabled=false;
		
	}else{
		str=elemento.name;
		v_indice=extrae_indice(str);
		document.datos.elements["datos["+v_indice+"][aprueba]"][0].disabled=true;
		document.datos.elements["datos["+v_indice+"][aprueba]"][1].disabled=true;
		document.datos.elements["datos["+v_indice+"][asgi_tobservaciones]"].disabled=true;
		document.datos.elements["datos["+v_indice+"][asgi_frecepcion_presupuesto]"].disabled=true;
		
		document.datos.elements["datos["+v_indice+"][aprueba_r]"][0].disabled=true;
		document.datos.elements["datos["+v_indice+"][aprueba_r]"][1].disabled=true;
	}
}


</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
          <td>
		  <table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>


                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Carga Contable</font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
				
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>

			
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
			
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				  
				  <BR>

<!-- AQUI ESTA EL INICIO DEL FORM DE BUSQUEDA -->

								<TABLE BORDER="0">
									<TR>
										<TD align="left">
                              <%pagina.DibujarLenguetasFClaro Array(array("Pendientes por Traspasar","carga_contable.asp?OPCION=1"),array("Traspasados Hoy","carga_contable.asp?OPCION=2"),array("Historico","carga_contable.asp?OPCION=3")), OPCION %>
										<TD>
									</TR>
								</TABLE>
								
<!-- AQUI ESTA EL FIN FORM DE BUSQUEDA -->

				  <br>
                    <div align="center"><font size="+1">
                      <%pagina.DibujarTituloPagina()%> 
                      </font>                    </div>
                    <table width="100%" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
						<td><strong><font color="000000" size="1"> </font></strong>
							<form name="datos">
								<table width="98%"  border="0" align="center">
								  <tr>
									<td><div align="right">P&aacute;ginas : <%f_solicitudes.AccesoPagina%></div></td>
								  </tr>
								  <tr>
									<td><div align="center"><%f_solicitudes.DibujaTabla%></div></td>
								  </tr>
								  <tr>
									<td><div align="center"><%f_solicitudes.Pagina%></div></td>
								  </tr>
								</table>
							</form>
							<br>
							<table width="30%"  border="0" align="right">
							  <tr>
								<td><div align="right">			
									<%
									
									'if OPCION=2 OR OPCION =3 then
									'	botonera.agregabotonparam "guardar" , "deshabilitado" , "TRUE"
									'end if
									
									'	botonera.DibujaBoton "guardar"
									%>
								</div></td>

								<td><div align="right">
									<%
									
									if OPCION=2 OR OPCION =3 then
										botonera.agregabotonparam "traspasar_solicitudes" , "deshabilitado" , "TRUE"
									end if

										botonera.DibujaBoton "traspasar_solicitudes"
									%>
								</div></td>
	
							  </tr>
							</table>							
						</td>
                  </tr>
                </table>
	  <br/>
				  
				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="108" bgcolor="#D8D8DE">
				  <table width="23%" height="19"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
					  <td>
					  <%							
					  botonera.dibujaboton "salir"
					  %></td>
                    </tr>
                  </table>                </td>
                  <td width="252" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="317" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td height="8" valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<p><br>
			<p><br>
			<p><br>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
