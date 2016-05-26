<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
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
'FECHA ACTUALIZACION 	:19/06/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ORDEN DE COMPRA
'LINEA			:
'*******************************************************************
set pagina = new CPagina
pagina.Titulo = "Solicitud de giro"

v_tsol_ccod		= request.QueryString("busqueda[0][tsol_ccod]")
area_ccod		= request.QueryString("busqueda[0][area_ccod]")
v_cod_solicitud	= request.QueryString("busqueda[0][cod_solicitud]")

set conectar = new cconexion
conectar.inicializar "upacifico"

set conexion = new Cconexion2
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

v_usuario 	= negocio.ObtenerUsuario()

sql_solicitud= "Select '' where 1=2 "

if v_tsol_ccod="" then
v_tsol_ccod=0
end if

select case (v_tsol_ccod)
	
	case 1:
	
	'PAGO PROVEEDORES
	
		if v_cod_solicitud<>"" then
			filtro_cod	=	"&busqueda[0][sogi_ncorr]="&v_cod_solicitud
			filtro		=	" and sogi_ncorr="&v_cod_solicitud
		end if 

'		sql_solicitud=  " select 1 as tsol_ccod,sogi_ncorr as cod_solicitud,sogi_mgiro as monto_solicitud, protic.obtener_rut(pers_ncorr_proveedor) as proveedor, "&_
'					 	" protic.trunc(sogi_fecha_solicitud) as fecha_solicitud, isnull(vibo_ccod,0) as vibo_ccod, isnull(area_ccod,"&area_ccod&") as area_ccod,audi_tusuario,  "&_
'						" case when isnull(vibo_ccod,0) in (10,12) then '<a href=javascript:VerPagina("&v_tsol_ccod&",'+cast(sogi_ncorr as varchar)+')>Editar</a>' else '<a href=javascript:VerPagina("&v_tsol_ccod&",'+cast(sogi_ncorr as varchar)+')>Ver</a>' end as accion "&_
'						" from ocag_solicitud_giro where case when (vibo_ccod=11  AND ocag_baprueba_rector=1) OR (vibo_ccod=6 AND ocag_baprueba_rector=2) OR ocag_baprueba=3 then 's' else 'n' end = 'n' and isnull(area_ccod,"&area_ccod&")="&area_ccod&" "&filtro&" ORDER BY sogi_ncorr DESC"

		sql_solicitud=  " select 1 as tsol_ccod,sogi_ncorr as cod_solicitud,sogi_mgiro as monto_solicitud, protic.obtener_rut(pers_ncorr_proveedor) as proveedor, "&_
					 	" protic.trunc(sogi_fecha_solicitud) as fecha_solicitud, isnull(vibo_ccod,0) as vibo_ccod, isnull(area_ccod,"&area_ccod&") as area_ccod,audi_tusuario,  "&_
						" case when vibo_ccod=7 then '<a href=javascript:VerPagina("&v_tsol_ccod&",'+cast(sogi_ncorr as varchar)+')>Ver</a>' ELSE  '<a href=javascript:VerPagina("&v_tsol_ccod&",'+cast(sogi_ncorr as varchar)+')>Editar</a>' end as accion "&_
						" from ocag_solicitud_giro where case when ocag_baprueba=3 then 's' else 'n' end = 'n' and isnull(area_ccod,"&area_ccod&")="&area_ccod&" "&filtro&" ORDER BY sogi_ncorr DESC"
						
		url="pago_proveedor.asp?area_ccod="&area_ccod&""
		
		'Response.Write("1 "&sql_solicitud&"<br>")
		'Response.Write("<br>"&url&"<br>")
		'Response.End()
	
	case 2: 
	
	'REEMBOLSO DE GASTOS
	
		if v_cod_solicitud<>"" then
			filtro_cod	="&busqueda[0][rgas_ncorr]="&v_cod_solicitud
			filtro		=" and rgas_ncorr="&v_cod_solicitud
		end if

'		sql_solicitud=  " select 2 as tsol_ccod,rgas_ncorr as cod_solicitud,rgas_mgiro as monto_solicitud, protic.obtener_rut(pers_ncorr_proveedor) as proveedor,  "&_
'					 	" protic.trunc(ocag_fingreso) as fecha_solicitud, isnull(vibo_ccod,0) as vibo_ccod, audi_tusuario,   "&_
'						" case when isnull(vibo_ccod,0) in (10,12) then '<a href=javascript:VerPagina("&v_tsol_ccod&",'+cast(rgas_ncorr as varchar)+')>Editar</a>' else '<a href=javascript:VerPagina("&v_tsol_ccod&",'+cast(rgas_ncorr as varchar)+')>Ver</a>' end as accion "&_
'						" from ocag_reembolso_gastos where case when (vibo_ccod=11  AND ocag_baprueba_rector=1) OR (vibo_ccod=6 AND ocag_baprueba_rector=2) OR ocag_baprueba=3 then 's' else 'n' end = 'n' and isnull(area_ccod,"&area_ccod&")="&area_ccod&" "&filtro&" ORDER BY rgas_ncorr DESC"

		sql_solicitud=  " select 2 as tsol_ccod,rgas_ncorr as cod_solicitud,rgas_mgiro as monto_solicitud, protic.obtener_rut(pers_ncorr_proveedor) as proveedor,  "&_
					 	" protic.trunc(ocag_fingreso) as fecha_solicitud, isnull(vibo_ccod,0) as vibo_ccod, audi_tusuario,   "&_
						" case when vibo_ccod=7 then '<a href=javascript:VerPagina("&v_tsol_ccod&",'+cast(rgas_ncorr as varchar)+')>Ver</a>' ELSE '<a href=javascript:VerPagina("&v_tsol_ccod&",'+cast(rgas_ncorr as varchar)+')>Editar</a>' end as accion "&_
						" from ocag_reembolso_gastos where case when ocag_baprueba=3 then 's' else 'n' end = 'n' and isnull(area_ccod,"&area_ccod&")="&area_ccod&" "&filtro&" ORDER BY rgas_ncorr DESC"
						
		url="reembolso_gastos.asp?area_ccod="&area_ccod&"&Item=5"
		
		'Response.Write("2 "&sql_solicitud&"<br>")
		'Response.Write("<br>"&url&"<br>")
		'Response.End()
	
	case 3: 
	
	'FONDO A RENDIR
	
		if v_cod_solicitud<>"" then
			filtro_cod	="&busqueda[0][fren_ncorr]="&v_cod_solicitud
			filtro		=" and a.fren_ncorr="&v_cod_solicitud
		end if

'		sql_solicitud=  " select 3 as tsol_ccod,fren_ncorr as cod_solicitud,fren_mmonto as monto_solicitud, protic.obtener_rut(pers_ncorr) as proveedor,  "&_
'						" protic.trunc(ocag_fingreso) as fecha_solicitud, isnull(vibo_ccod,0) as vibo_ccod, audi_tusuario, "&_
'						" case when isnull(vibo_ccod,0) in (10,12) then '<a href=javascript:VerSolicitud('+cast(fren_ncorr as varchar)+',"&v_tsol_ccod&")>Ver</a>'+' | '+'<a href=javascript:VerPagina("&v_tsol_ccod&",'+cast(fren_ncorr as varchar)+')>Editar</a>' "&_
'						" else '<a href=javascript:VerSolicitud('+cast(fren_ncorr as varchar)+',"&v_tsol_ccod&")>Ver</a>'+'|'+'<a href=javascript:RendirFondo('+cast("&v_tsol_ccod&" as varchar)+','+cast(fren_ncorr as varchar)+')>Rendir</a>' end as accion  "&_
'						" from ocag_fondos_a_rendir where case when (vibo_ccod=11  AND ocag_baprueba_rector=1) OR (vibo_ccod=6 AND ocag_baprueba_rector=2) OR ocag_baprueba=3 then 's' else 'n' end = 'n' and isnull(area_ccod,"&area_ccod&")="&area_ccod&" "&filtro&" ORDER BY fren_ncorr DESC"
		
'		sql_solicitud=  " select 3 as tsol_ccod,fren_ncorr as cod_solicitud,fren_mmonto as monto_solicitud, protic.obtener_rut(pers_ncorr) as proveedor,  "&_
'						" protic.trunc(ocag_fingreso) as fecha_solicitud, isnull(vibo_ccod,0) as vibo_ccod, audi_tusuario, "&_
'						" case when (vibo_ccod=11 AND ocag_baprueba_rector=1) OR (vibo_ccod=6 AND ocag_baprueba_rector=2) then "&_
'						" '<a href=javascript:VerSolicitud('+cast(fren_ncorr as varchar)+',"&v_tsol_ccod&")>Ver</a>'+'|'+'<a href=javascript:RendirFondo('+cast("&v_tsol_ccod&" as varchar)+','+cast(fren_ncorr as varchar)+')>Rendir</a>' ELSE '<a href=javascript:VerPagina("&v_tsol_ccod&",'+cast(fren_ncorr as varchar)+')>Editar</a>' end as accion  "&_
'						" from ocag_fondos_a_rendir where case when ocag_baprueba=3 then 's' else 'n' end = 'n' and isnull(area_ccod,"&area_ccod&")="&area_ccod&" "&filtro&" ORDER BY fren_ncorr DESC"

		sql_solicitud=  " select 3 as tsol_ccod, A.fren_ncorr as cod_solicitud, A.fren_mmonto as monto_solicitud, protic.obtener_rut(A.pers_ncorr) as proveedor "&_
						" , protic.trunc(A.ocag_fingreso) as fecha_solicitud, isnull(a.vibo_ccod,0) as vibo_ccod, A.audi_tusuario, "&_
						" CASE "&_
						" WHEN A.vibo_ccod=7 "&_
						" THEN "&_
						" 	CASE "&_
						" 	WHEN ISNULL(B.ocag_baprueba,1) = 5 "&_
						" 	THEN '<a href=javascript:VerSolicitud('+cast(A.fren_ncorr as varchar)+',"&v_tsol_ccod&")>Ver</a>'+'|'+'<a href=javascript:RendirFondo('+cast("&v_tsol_ccod&"  as varchar)+','+cast(A.fren_ncorr as varchar)+')>Rendir</a>' "&_
						" 	ELSE "&_
						" 		CASE "&_
						" 		WHEN ISNULL(B.vibo_ccod,0) IN (0,12) "&_
						" 		THEN '<a href=javascript:VerSolicitud('+cast(A.fren_ncorr as varchar)+',"&v_tsol_ccod&")>Ver</a>'+'|'+'<a href=javascript:RendirFondo('+cast("&v_tsol_ccod&"  as varchar)+','+cast(A.fren_ncorr as varchar)+')>Rendir</a>' "&_
						" 		ELSE '<a href=javascript:VerSolicitud('+cast(A.fren_ncorr as varchar)+',"&v_tsol_ccod&")>Ver</a>' "&_
						" 		END "&_
						" 	END "&_
						" ELSE "&_
						" '<a href=javascript:VerPagina("&v_tsol_ccod&",'+cast(A.fren_ncorr as varchar)+')>Editar</a>' "&_
						" END as accion "&_
						" from ocag_fondos_a_rendir A "&_
						" LEFT OUTER JOIN ocag_rendicion_fondos_a_rendir B ON A.fren_ncorr = B.fren_ncorr "&_
						" where case when A.ocag_baprueba=3 then 's' else 'n' end = 'n' and isnull(A.area_ccod,"&area_ccod&")="&area_ccod&" "&filtro&" ORDER BY A.fren_ncorr DESC"

		url="fondos_rendir.asp?area_ccod="&area_ccod&""

		'Response.Write("3 "&sql_solicitud&"<br>")
		'Response.Write("<br>"&url&"<br>")
		'Response.End()
	
	case 4: 
	
	'SOLICITUD DE VIATICO
	
		if v_cod_solicitud<>"" then
			filtro_cod	="&busqueda[0][sovi_ncorr]="&v_cod_solicitud
			filtro		=" and sovi_ncorr="&v_cod_solicitud
		end if 	

'		sql_solicitud=  " select 4 as tsol_ccod,sovi_ncorr as cod_solicitud,sovi_mmonto_pesos as monto_solicitud, protic.obtener_rut(pers_ncorr) as proveedor,  "&_
'						" protic.trunc(ocag_fingreso) as fecha_solicitud, isnull(vibo_ccod,0) as vibo_ccod, audi_tusuario,   "&_
'						" case when isnull(vibo_ccod,0) in (10,12) then '<a href=javascript:VerPagina("&v_tsol_ccod&",'+cast(sovi_ncorr as varchar)+')>Editar</a>' else '<a href=javascript:VerPagina("&v_tsol_ccod&",'+cast(sovi_ncorr as varchar)+')>Ver</a>' end as accion "&_
'						" from ocag_solicitud_viatico where case when (vibo_ccod=11  AND ocag_baprueba_rector=1) OR (vibo_ccod=6 AND ocag_baprueba_rector=2) OR ocag_baprueba=3 then 's' else 'n' end = 'n' and isnull(area_ccod,"&area_ccod&")="&area_ccod&" "&filtro&" ORDER BY sovi_ncorr DESC"

		sql_solicitud=  " select 4 as tsol_ccod,sovi_ncorr as cod_solicitud,sovi_mmonto_pesos as monto_solicitud, protic.obtener_rut(pers_ncorr) as proveedor,  "&_
						" protic.trunc(ocag_fingreso) as fecha_solicitud, isnull(vibo_ccod,0) as vibo_ccod, audi_tusuario,   "&_
						" case when vibo_ccod=7 then '<a href=javascript:VerPagina("&v_tsol_ccod&",'+cast(sovi_ncorr as varchar)+')>Ver</a>' ELSE '<a href=javascript:VerPagina("&v_tsol_ccod&",'+cast(sovi_ncorr as varchar)+')>Editar</a>' end as accion "&_
						" from ocag_solicitud_viatico where case when ocag_baprueba=3 then 's' else 'n' end = 'n' and isnull(area_ccod,"&area_ccod&")="&area_ccod&" "&filtro&" ORDER BY sovi_ncorr DESC"
						
		url="solicitud_viaticos.asp?area_ccod="&area_ccod&""

		'Response.Write("4 "&sql_solicitud&"<br>")
		'Response.Write("<br>"&url&"<br>")
		'Response.End()

	case 5: 
	
	'DEVOLUCION ALUMNO
	
		if v_cod_solicitud<>"" then
			filtro_cod	="&busqueda[0][dalu_ncorr]="&v_cod_solicitud
			filtro		=" and dalu_ncorr="&v_cod_solicitud
		end if

'		sql_solicitud=  " select 5 as tsol_ccod,dalu_ncorr as cod_solicitud,dalu_mmonto_pesos as monto_solicitud, protic.obtener_rut(pers_ncorr) as proveedor,  "&_
'						" protic.trunc(ocag_fingreso) as fecha_solicitud, isnull(vibo_ccod,0) as vibo_ccod, audi_tusuario,   "&_
'						" case when isnull(vibo_ccod,0) in (10,12) then '<a href=javascript:VerPagina("&v_tsol_ccod&",'	+cast(dalu_ncorr as varchar)+')>Editar</a>' else '<a href=javascript:VerPagina("&v_tsol_ccod&",'	+cast(dalu_ncorr as varchar)+')>Ver</a>' end as accion "&_
'						" from ocag_devolucion_alumno where case when (vibo_ccod=11  AND ocag_baprueba_rector=1) OR (vibo_ccod=6 AND ocag_baprueba_rector=2) OR ocag_baprueba=3 then 's' else 'n' end = 'n' and isnull(area_ccod,"&area_ccod&")="&area_ccod&" "&filtro&" ORDER BY dalu_ncorr DESC"

		sql_solicitud=  " select 5 as tsol_ccod,dalu_ncorr as cod_solicitud,dalu_mmonto_pesos as monto_solicitud, protic.obtener_rut(pers_ncorr) as proveedor,  "&_
						" protic.trunc(ocag_fingreso) as fecha_solicitud, isnull(vibo_ccod,0) as vibo_ccod, audi_tusuario,   "&_
						" case when vibo_ccod=7 then '<a href=javascript:VerPagina("&v_tsol_ccod&",'	+cast(dalu_ncorr as varchar)+')>Ver</a>' ELSE '<a href=javascript:VerPagina("&v_tsol_ccod&",'	+cast(dalu_ncorr as varchar)+')>Editar</a>' end as accion "&_
						" from ocag_devolucion_alumno where case when ocag_baprueba=3 then 's' else 'n' end = 'n' and isnull(area_ccod,"&area_ccod&")="&area_ccod&" "&filtro&" ORDER BY dalu_ncorr DESC"

		url="devolucion_alumno.asp?area_ccod="&area_ccod&""

		'Response.Write("5 "&sql_solicitud&"<br>")
		'Response.Write("<br>"&url&"<br>")
		'Response.End()

	case 6: 
	
	'NUEVO FONDO FIJO
	
		if v_cod_solicitud<>"" then
			filtro_cod="&busqueda[0][ffij_ncorr]="&v_cod_solicitud
			filtro=" and ffij_ncorr="&v_cod_solicitud
		end if 	

'		sql_solicitud=  " select 6 as tsol_ccod,ffij_ncorr as cod_solicitud,ffij_mmonto_pesos as monto_solicitud, protic.obtener_rut(pers_ncorr) as proveedor,  "&_
'						" protic.trunc(ocag_fingreso) as fecha_solicitud, isnull(vibo_ccod,0) as vibo_ccod, audi_tusuario, "&_
'						" case when isnull(vibo_ccod,0) in (10,12) then '<a href=javascript:VerSolicitud('+cast(ffij_ncorr as varchar)+',"&v_tsol_ccod&")>Ver</a>' +' | '+'<a href=javascript:VerPagina("&v_tsol_ccod&",'+cast(ffij_ncorr as varchar)+')>Editar</a>' "&_
'						" else '<a href=javascript:VerSolicitud('+cast(ffij_ncorr as varchar)+',"&v_tsol_ccod&")>Ver</a>'+'|'+'<a href=javascript:RendirFondo('+cast("&v_tsol_ccod&" as varchar)+','+cast(ffij_ncorr as varchar)+')>Rendir</a>' end as accion  "&_
'						" from ocag_fondo_fijo where case when (vibo_ccod=11  AND ocag_baprueba_rector=1) OR (vibo_ccod=6 AND ocag_baprueba_rector=2) OR ocag_baprueba=3 then 's' else 'n' end = 'n' and isnull(area_ccod,"&area_ccod&")="&area_ccod&" "&filtro&" ORDER BY ffij_ncorr DESC"

'		sql_solicitud=  " select 6 as tsol_ccod,ffij_ncorr as cod_solicitud,ffij_mmonto_pesos as monto_solicitud, protic.obtener_rut(pers_ncorr) as proveedor,  "&_
'						" protic.trunc(ocag_fingreso) as fecha_solicitud, isnull(vibo_ccod,0) as vibo_ccod, audi_tusuario, "&_
'						" case when (vibo_ccod=11 AND ocag_baprueba_rector=1) OR (vibo_ccod=6 AND ocag_baprueba_rector=2) then "&_
'						" '<a href=javascript:VerSolicitud('+cast(ffij_ncorr as varchar)+',"&v_tsol_ccod&")>Ver</a>'+'|'+'<a href=javascript:RendirFondo('+cast("&v_tsol_ccod&" as varchar)+','+cast(ffij_ncorr as varchar)+')>Rendir</a>' ELSE '<a href=javascript:VerPagina("&v_tsol_ccod&",'+cast(ffij_ncorr as varchar)+')>Editar</a>' end as accion  "&_
'						" from ocag_fondo_fijo where case when ocag_baprueba=3 then 's' else 'n' end = 'n' and isnull(area_ccod,"&area_ccod&")="&area_ccod&" "&filtro&" ORDER BY ffij_ncorr DESC"

	sql_solicitud=  " select 6 as tsol_ccod, A.ffij_ncorr as cod_solicitud, A.ffij_mmonto_pesos as monto_solicitud, protic.obtener_rut(A.pers_ncorr) as proveedor "&_
						" , protic.trunc(A.ocag_fingreso) as fecha_solicitud, isnull(A.vibo_ccod,0) as vibo_ccod, A.audi_tusuario, "&_
						" CASE "&_
						" WHEN A.vibo_ccod=7 "&_
						" THEN "&_
						" 	CASE "&_
						" 	WHEN ISNULL(B.ocag_baprueba,1) = 5 "&_
						" 	THEN '<a href=javascript:VerSolicitud('+cast(A.ffij_ncorr as varchar)+',"&v_tsol_ccod&")>Ver</a>'+'|'+'<a href=javascript:RendirFondo('+cast("&v_tsol_ccod&" as varchar)+','+cast(A.ffij_ncorr as varchar)+')>Rendir</a>' "&_
						" 	ELSE "&_
						" 		CASE "&_
						" 		WHEN ISNULL(B.vibo_ccod,0) IN (0,12) "&_
						" 		THEN '<a href=javascript:VerSolicitud('+cast(A.ffij_ncorr as varchar)+',"&v_tsol_ccod&")>Ver</a>'+'|'+'<a href=javascript:RendirFondo('+cast("&v_tsol_ccod&" as varchar)+','+cast(A.ffij_ncorr as varchar)+')>Rendir</a>'  "&_
						" 		ELSE '<a href=javascript:VerSolicitud('+cast(A.ffij_ncorr as varchar)+',"&v_tsol_ccod&")>Ver</a>' "&_
						" 		END "&_
						" 	END "&_
						" ELSE "&_
						" '<a href=javascript:VerPagina("&v_tsol_ccod&",'+cast(A.ffij_ncorr as varchar)+')>Editar</a>' "&_
						" END as accion "&_
						" FROM ocag_fondo_fijo A "&_
						" LEFT OUTER JOIN ocag_rendicion_fondo_fijo B "&_
						" ON A.ffij_ncorr = B.ffij_ncorr "&_
						" where "&_
						" case when A.ocag_baprueba=3 "&_
						" then 's' else 'n' end = 'n' and isnull(A.area_ccod, "&area_ccod&")="&area_ccod&" "&filtro&" ORDER BY A.ffij_ncorr DESC"

						 url="fondo_fijo.asp?area_ccod="&area_ccod&""
		

	' 8888888888888888888888888888888
	' 19-07-2013
	' ORDEN DE COMPRA
	' 8888888888888888888888888888888
	case 9: 
	
	'ORDEN DE COMPRA
	
		if v_cod_solicitud<>"" then
			filtro_cod="&busqueda[0][ordc_ncorr]="&v_cod_solicitud
			filtro=" and ordc_ncorr="&v_cod_solicitud
		end if 	

'		sql_solicitud=  " select 9 as tsol_ccod, ordc_ncorr as cod_solicitud, ordc_mmonto as monto_solicitud  "&_
'						" , protic.obtener_rut(pers_ncorr) as proveedor  "&_
'						" , protic.trunc(ocag_fingreso) as fecha_solicitud, isnull(vibo_ccod,0) as vibo_ccod, audi_tusuario  "&_
'						" , case when isnull(vibo_ccod,0) in (10,12)  "&_
'						" then '<a href=javascript:VerPagina("&v_tsol_ccod&",'+cast(ordc_ncorr as varchar)+')>Editar</a>'  "&_
'						" else '<a href=javascript:VerPagina("&v_tsol_ccod&",'+cast(ordc_ncorr as varchar)+')>Ver</a>'  "&_
'						" end as accion   "&_
'						" from ocag_orden_compra  "&_
'						" where case when (ordc_bestado_final='S' AND vibo_ccod=11  AND ocag_baprueba_rector=1) OR (ordc_bestado_final='S' AND vibo_ccod=6 AND ocag_baprueba_rector=2) OR ocag_baprueba=3 then 's' else 'n' end = 'n' and isnull(area_ccod,"&area_ccod&")="&area_ccod&" "&filtro&" ORDER BY ordc_ncorr DESC"

		sql_solicitud=  " select 9 as tsol_ccod, ordc_ncorr as cod_solicitud, ordc_mmonto as monto_solicitud  "&_
						" , protic.obtener_rut(pers_ncorr) as proveedor  "&_
						" , protic.trunc(ocag_fingreso) as fecha_solicitud, isnull(vibo_ccod,0) as vibo_ccod, audi_tusuario  "&_
						" , case when (ordc_bestado_final='S' AND vibo_ccod=11  AND ocag_baprueba_rector=1) OR (ordc_bestado_final='S' AND vibo_ccod=6 AND ocag_baprueba_rector=2) "&_
						" then "&_
						" '<a href=javascript:VerPagina("&v_tsol_ccod&",'+cast(ordc_ncorr as varchar)+')>Ver</a>'  ELSE  '<a href=javascript:VerPagina("&v_tsol_ccod&",'+cast(ordc_ncorr as varchar)+')>Editar</a>' "&_
						" end as accion   "&_
						" from ocag_orden_compra  "&_
						" where case when ocag_baprueba=3 then 's' else 'n' end = 'n' and isnull(area_ccod,"&area_ccod&")="&area_ccod&" "&filtro&" ORDER BY ordc_ncorr DESC"

		url="BUSCAR_ORDEN_COMPRA.ASP?area_ccod="&area_ccod&""
		
		'Response.Write("6 "&sql_solicitud&"<br>")
		'Response.Write("<br>"&url&"<br>")
		'Response.End()

End Select

'response.Write(v_tsol_ccod & sql_solicitud&"<BR>")
'RESPONSE.END()

set botonera = new CFormulario
botonera.carga_parametros "solicitud_giro.xml", "botonera"

set f_busqueda2 = new CFormulario
f_busqueda2.Carga_Parametros "solicitud_giro.xml", "buscador"
f_busqueda2.Inicializar conectar
f_busqueda2.Consultar "select ''"
f_busqueda2.Siguiente

f_busqueda2.AgregaCampoCons "cod_solicitud", v_cod_solicitud
f_busqueda2.AgregaCampoCons "tsol_ccod", v_tsol_ccod

'********* Para traer el area desde servidor de softland **************
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "solicitud_giro.xml", "buscador2"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

'if v_usuario="13582834" then
'	f_busqueda.AgregaCampoParam "area_ccod", "filtro",  "area_ccod in ( select distinct area_ccod from  presupuesto_upa.protic.area_presupuesto_usuario)"
'else
'	f_busqueda.AgregaCampoParam "area_ccod", "filtro",  "area_ccod in ( select area_ccod from  presupuesto_upa.protic.area_presupuesto_usuario where rut_usuario in ('"&v_usuario&"') )"
'end if

f_busqueda.AgregaCampoParam "area_ccod", "filtro",  "area_ccod in ( select area_ccod from  presupuesto_upa.protic.area_presupuesto_usuario where rut_usuario in ('"&v_usuario&"') )"

f_busqueda.AgregaCampoCons "area_ccod", area_ccod


set f_solicitud = new CFormulario
f_solicitud.carga_parametros "solicitud_giro.xml", "datos_solicitud"
f_solicitud.inicializar conectar
f_solicitud.consultar sql_solicitud

%>


<html>
<head>
<title>Solicitud de Giro</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if
%>
}

function Validar(){
	formulario = document.buscador;
	//var posicion=document.buscador.document.buscador.busqueda[0][area_ccod].value; //posicion
	//alert(posicion);
	var num = formulario.elements("busqueda[0][cod_solicitud]").value;
	
//	if (formulario.elements("busqueda[0][tsol_ccod]").options.selectedIndex == 0) {
//		alert("Debe escoger un tipo de solicitud");
		
	if (formulario.elements("busqueda[0][area_ccod]").options.selectedIndex == 0) {
		alert("Debe escoger un área presupuestaria");
		//document.buscador.area_ccod.set;
		return false;
	}
	else{
		if(isNaN(parseInt(num))){
			if(formulario.elements("busqueda[0][cod_solicitud]").value == ""){
				formulario.submit();
			}
			else{
				alert("Debe ingresar un numero");
				return false;
			}
		}
		else{
			if(num%1==0){
				document.buscador.submit();
			}
		}
	}
}

function Enviar(){
	alert('okokok');
	var posicion=document.buscador.getElementByName('area_ccod').options.selectedIndex; //posicion
	//alert(document.buscador.getElementById('area_ccod').options[posicion].text); //valor
	alert(posicion);
	formulario = document.buscador;
	if (document.buscador.elements('busqueda[0][area_ccod]').value == ""){
		alert("Debe escoger un área presupuestaria");
		return false;
	}
	else{
		return true;	
	}
	
}

function VerSolicitud(codigo,tsol_ccod){
	window.open("ver_solicitud_giro.asp?solicitud="+codigo+"&tsol_ccod="+tsol_ccod,"solicitud",'scrollbars=yes, menubar=no, resizable=yes, width=800,height=500');
}

function NuevaSolicitud(){
	url_solicitud="<%=url%>";
	location.href=url_solicitud;
	return true;
}

function RendirFondo(tipo,cod_fondo){
switch (tipo){
		case 6:
			url="rendicion_fondo_fijo.asp?cod_solicitud="+cod_fondo;
		break;			
		case 3:
			url="rendicion_fondo_rendir.asp?cod_solicitud="+cod_fondo;
		break;			
	}
	location.href=url;
	return true;
}

function VerPagina(tipo,codigo){
	url_solicitud="<%=url%>";
	switch (tipo){
		case 1:
			filtro="&busqueda[0][sogi_ncorr]="+codigo;	
		break;
		case 2:
			filtro="&busqueda[0][rgas_ncorr]="+codigo;
		break;
		case 3:
			filtro="&busqueda[0][fren_ncorr]="+codigo;
		break;
		case 4:
			filtro="&busqueda[0][sovi_ncorr]="+codigo;
		break;
		case 5:
			filtro="&busqueda[0][dalu_ncorr]="+codigo;
		break;
		case 6:
			filtro="&busqueda[0][ffij_ncorr]="+codigo;
		break;
		case 9:
			filtro="&busqueda[0][ordc_ncorr]="+codigo;
		break;
	}		
	location.href=url_solicitud+filtro
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
	
	<table border="0" cellpadding="0" cellspacing="0" width="80%" align="center">
            <tr>
              <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8" background="../imagenes/top_r1_c2.gif"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="100" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador</font></div></td>
                    <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                  </tr>
              </table></td>
              <td align="left"><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>              
            </tr>
            <tr>
              <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td background="../imagenes/top_r3_c2.gif"><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE">
			<BR>
			
<!-- AQUI ESTA EL INICIO DEL FORM DE BUSQUEDA -->

				<form name="buscador" onSubmit="return Validar();" method="GET">                
                      <table width="100%" border="0" align="left">
                        <tr>
						  <td width="136"><div align="left"><strong>Solicitud Giro</strong>  </div></td>
						  <td width="264"><%f_busqueda2.DibujaCampo ("tsol_ccod") %></td>  
                          <td width="231" rowspan="3" align="center"><input type="submit" value="Buscar"></td>
                        </tr>
                        <tr>
						  <td width="190"><div align="left"><strong>Area Presupuesto</strong>  </div></td>
						  <td width="482"><%f_busqueda.DibujaCampo ("area_ccod") %></td>
                        </tr>
                        <tr>
                          <td><strong>Cod. Solicitud</strong> </td>
                          <td><%f_busqueda2.DibujaCampo ("cod_solicitud") %></td>
                        </tr>
                      </table>
				</form>

<!-- AQUI ESTA EL FIN FORM DE BUSQUEDA -->

                </td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE" background="../imagenes/base2.gif"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>
			<br/>
<!-- INICIO SUB TABLA PRINCIPAL -->
				<table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
				  <tr>
					<td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
					<td height="8" background="../imagenes/top_r1_c2.gif"></td>
					<td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
				  </tr>
				  <tr>
					<td width="9" background="../imagenes/izq.gif">&nbsp;</td>
					<td>
<!-- INICIO SUB TABLA PRINCIPAL -->	
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td><%'pagina.DibujarLenguetas Array("Resultado Busqueda"), 1 
									%>
									<div align="right">P&aacute;ginas : <%f_solicitud.AccesoPagina%></div>
							</td>
						</tr>
					  	<tr>
							<td height="2" background="../imagenes/top_r3_c2.gif"></td>
					  	</tr>
						
						<tr>
							<td bgcolor="#D8D8DE">
							  <br>
								<div align="center"><font size="+1">
								  <%pagina.DibujarTituloPagina()%> 
								  </font>                    
								</div>
							</td>
						</tr>
						<!-- ** INICIO GRILLA ** -->
						<tr>
						<td><%f_solicitud.DibujaTabla()%></td>
						</tr>
						<!-- ** FIN GRILLA ** -->
					</table>
<!-- FIN SUB TABLA PRINCIPAL -->
					<br/>			
					</td>
					<td width="7" background="../imagenes/der.gif">&nbsp;</td>
				  </tr>
				  <tr>
					<td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
					<td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
					  <tr>
						<td width="18%" height="20">
								<table width="90%"  border="0" cellspacing="0" cellpadding="0">
								  <tr>
									<td width="55%"><%
									'if v_tsol_ccod <> "" then
									if v_tsol_ccod <> 0 then
										botonera.dibujaboton "nuevo"
									end if
									%></td>
									<td width="55%"><%botonera.dibujaboton "salir"%></td>
								  </tr>
								</table>
						</td>
						<td width="82%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
					  </tr>
					  <tr>
						<td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
					  </tr>
					</table></td>
					<td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
				  </tr>
				</table>
<!-- FIN SUB TABLA PRINCIPAL -->
	</td>
  </tr>  
</table>
</body>
</html>
