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
'FECHA ACTUALIZACION 	:26/05/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ORDEN DE COMPRA
'LINEA			:216
'*******************************************************************
set pagina = new CPagina
pagina.Titulo = "V.B. Vicerector"

v_solicitud	= request.querystring("busqueda[0][solicitud]")
v_tipo		= request.querystring("busqueda[0][tsol_ccod]")

set botonera = new CFormulario
botonera.carga_parametros "vb_vicerector.xml", "botonera"

set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

v_usuario=negocio.ObtenerUsuario()


 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "vb_vicerector.xml", "datos_solicitud"
 f_busqueda.Inicializar conectar

if v_usuario="13582834" then
	sql_filtro=""
else 
	sql_filtro =sql_filtro&" and ocag_responsable in ("&v_usuario& ")"
end if 

if v_solicitud<>"" then
	sql_filtro=" and cod_solicitud="&v_solicitud
end if

if v_tipo<>"" then
	sql_filtro=sql_filtro& " and tabla.tsol_ccod="&v_tipo
end if
 

if v_tipo="9" then
 
' sql_solicitudes="  Select * from ( "& vbCrLf &_
' 				"	Select ocag_responsable,ordc_ncorr as cod_solicitud,ordc_ncorr as num_solicitud,'' as aprueba, isnull(a.vibo_ccod,0) as vibo_ccod, ocag_generador as usuario, "& vbCrLf &_  
'				"	'9' as tipo,isnull(a.tsol_ccod,9) as tsol_ccod, ordc_mmonto as monto, ordc_mmonto as monto_orden, protic.obtener_nombre_completo(pers_ncorr, 'n') as pers_tnombre,  "& vbCrLf &_  
'				"	'<a href=  javascript:VerSolicitud('+cast(a.ordc_ncorr as varchar)+',1);  >ver</a>' as solicitud,protic.trunc(fecha_solicitud) as fecha_solicitud   "& vbCrLf &_
'				"	from ocag_orden_compra a   "& vbCrLf &_
'				"	where isnull(a.vibo_ccod,0)=4  and ocag_baprueba in (0,1) "& vbCrLf &_
'				" 	) as  tabla, ocag_tipo_solicitud b "& vbCrLf &_
'				"	where cast(tabla.tsol_ccod as numeric)= b.tsol_ccod "&sql_filtro
				
 sql_solicitudes="  Select * from ( "& vbCrLf &_
 				"	Select ocag_responsable,ordc_ncorr as cod_solicitud,ordc_ncorr as num_solicitud,'' as aprueba, isnull(a.vibo_ccod,0) as vibo_ccod, ocag_generador as usuario, "& vbCrLf &_  
				"	'9' as tipo,isnull(a.tsol_ccod,9) as tsol_ccod, ordc_mmonto as monto, ordc_mmonto as monto_orden, protic.obtener_nombre_completo(a.pers_ncorr, 'n') as pers_tnombre,  "& vbCrLf &_  
				"	'<a href=  javascript:VerSolicitud('+cast(a.ordc_ncorr as varchar)+',9);  >ver</a>' as solicitud,protic.trunc(fecha_solicitud) as fecha_solicitud,c.pers_nrut,c.pers_tnombre as nombre,ordc_mmonto as total, c.PERS_TEMAIL as email   "& vbCrLf &_
				"	from ocag_orden_compra a , personas c   "& vbCrLf &_
				"	where isnull(a.vibo_ccod,0)=4  and ocag_baprueba in (0,1) and a.ocag_generador=c.pers_nrut"& vbCrLf &_
				" 	) as  tabla, ocag_tipo_solicitud b "& vbCrLf &_
				"	where cast(tabla.tsol_ccod as numeric)= b.tsol_ccod "&sql_filtro
else
 sql_solicitudes="select * from ( "& vbCrLf &_
				"    select ocag_responsable,sogi_ncorr as cod_solicitud,sogi_ncorr as num_solicitud,'' as aprueba, isnull(a.vibo_ccod,0) as vibo_ccod, ocag_generador as usuario, "& vbCrLf &_
				"	'1' as tipo, isnull(a.tsol_ccod,1) as tsol_ccod, sogi_mgiro as monto, protic.obtener_nombre_completo(pers_ncorr_proveedor, 'n') as pers_tnombre,  "& vbCrLf &_
				"   '<a href=""javascript:VerSolicitud('+cast(a.sogi_ncorr as varchar)+',1);"">ver</a>' as solicitud, "& vbCrLf &_
				"   (select top 1 protic.trunc(dpva_fpago) from ocag_detalle_pago_validacion where vcon_ncorr=b.vcon_ncorr) as asgi_fpropuesta_finanzas, "& vbCrLf &_
				"   protic.trunc(protic.ocag_retorna_fecha_normal(ocag_frecepcion_presupuesto,1)) as asgi_fautorizado_finanzas,c.pers_nrut,c.pers_tnombre as nombre,sogi_mgiro as total, c.PERS_TEMAIL as email   "& vbCrLf &_
				"	from ocag_solicitud_giro a, ocag_validacion_contable b, personas c where a.vibo_ccod=4   and ocag_baprueba in (0,1) and b.tsol_ccod = 1 and a.sogi_ncorr=b.cod_solicitud and a.audi_tusuario=c.pers_nrut "& vbCrLf &_
				"	Union    "& vbCrLf &_
				"	select ocag_responsable,rgas_ncorr as cod_solicitud,rgas_ncorr as num_solicitud,'' as aprueba, isnull(a.vibo_ccod,0) as vibo_ccod,ocag_generador as usuario,   "& vbCrLf &_
				"	'2' as tipo, isnull(a.tsol_ccod,2) as tsol_ccod, rgas_mgiro as monto, protic.obtener_nombre_completo(pers_ncorr_proveedor, 'n') as pers_tnombre, "& vbCrLf &_
				"   '<a href=""javascript:VerSolicitud('+cast(a.rgas_ncorr as varchar)+',2);"">ver</a>' as solicitud, "& vbCrLf &_
				"   (select top 1 protic.trunc(dpva_fpago) from ocag_detalle_pago_validacion where vcon_ncorr=b.vcon_ncorr) as asgi_fpropuesta_finanzas, "& vbCrLf &_
				"   protic.trunc(protic.ocag_retorna_fecha_normal(ocag_frecepcion_presupuesto,2)) as asgi_fautorizado_finanzas,c.pers_nrut,c.pers_tnombre as nombre,rgas_mgiro as total, c.PERS_TEMAIL as email    "& vbCrLf &_
				"	from ocag_reembolso_gastos a, ocag_validacion_contable b , personas c where a.vibo_ccod=4  and ocag_baprueba in (0,1) and b.tsol_ccod = 2 and a.rgas_ncorr=b.cod_solicitud  and a.audi_tusuario=c.pers_nrut "& vbCrLf &_
				"	Union   "& vbCrLf &_
				"	select ocag_responsable,fren_ncorr as cod_solicitud,fren_ncorr as num_solicitud,'' as aprueba, isnull(a.vibo_ccod,0) as vibo_ccod,ocag_generador as usuario,  "& vbCrLf &_
				"	'3' as tipo, isnull(a.tsol_ccod,3) as tsol_ccod, fren_mmonto as monto, protic.obtener_nombre_completo(a.pers_ncorr, 'n') as pers_tnombre, "& vbCrLf &_
				"   '<a href=""javascript:VerSolicitud('+cast(a.fren_ncorr as varchar)+',3);"">ver</a>' as solicitud, "& vbCrLf &_
				"   (select top 1 protic.trunc(dpva_fpago) from ocag_detalle_pago_validacion where vcon_ncorr=b.vcon_ncorr) as asgi_fpropuesta_finanzas, "& vbCrLf &_
				"   protic.trunc(protic.ocag_retorna_fecha_normal(ocag_frecepcion_presupuesto,3)) as asgi_fautorizado_finanzas,c.pers_nrut,c.pers_tnombre as nombre,fren_mmonto as total, c.PERS_TEMAIL as email    "& vbCrLf &_
				"	from ocag_fondos_a_rendir a, ocag_validacion_contable b, personas c  where a.vibo_ccod=4  and ocag_baprueba in (0,1) and b.tsol_ccod = 3 and a.fren_ncorr=b.cod_solicitud  and a.audi_tusuario=c.pers_nrut "& vbCrLf &_
				"	Union   "& vbCrLf &_
				"	select ocag_responsable,sovi_ncorr as cod_solicitud,sovi_ncorr as num_solicitud, '' as aprueba, isnull(a.vibo_ccod,0) as vibo_ccod,ocag_generador as usuario,  "& vbCrLf &_
				"	'4' as tipo, isnull(a.tsol_ccod,4) as tsol_ccod, sovi_mmonto_pesos as monto, protic.obtener_nombre_completo(a.pers_ncorr, 'n') as pers_tnombre, "& vbCrLf &_
				"   '<a href=""javascript:VerSolicitud('+cast(a.sovi_ncorr as varchar)+',4);"">ver</a>' as solicitud, "& vbCrLf &_
				"   (select top 1 protic.trunc(dpva_fpago) from ocag_detalle_pago_validacion where vcon_ncorr=b.vcon_ncorr) as asgi_fpropuesta_finanzas, "& vbCrLf &_
				"   protic.trunc(protic.ocag_retorna_fecha_normal(ocag_frecepcion_presupuesto,4)) as asgi_fautorizado_finanzas,c.pers_nrut,c.pers_tnombre as nombre,sovi_mmonto_pesos as total, c.PERS_TEMAIL as email    "& vbCrLf &_
				"	from ocag_solicitud_viatico a, ocag_validacion_contable b, personas c  where a.vibo_ccod=4  and ocag_baprueba in (0,1) and b.tsol_ccod = 4 and a.sovi_ncorr=b.cod_solicitud   and a.audi_tusuario=c.pers_nrut"& vbCrLf &_
				"	Union   "& vbCrLf &_
				"	select ocag_responsable,dalu_ncorr as cod_solicitud,dalu_ncorr as num_solicitud,'' as aprueba, isnull(a.vibo_ccod,0) as vibo_ccod, ocag_generador as usuario, "& vbCrLf &_
				"	'5' as tipo, isnull(a.tsol_ccod,5) as tsol_ccod, dalu_mmonto_pesos as monto, protic.obtener_nombre_completo(a.pers_ncorr, 'n') as pers_tnombre, "& vbCrLf &_
				"   '<a href=""javascript:VerSolicitud('+cast(a.dalu_ncorr as varchar)+',5);"">ver</a>' as solicitud, "& vbCrLf &_
				"   (select top 1 protic.trunc(dpva_fpago) from ocag_detalle_pago_validacion where vcon_ncorr=b.vcon_ncorr) as asgi_fpropuesta_finanzas, "& vbCrLf &_
				"   protic.trunc(protic.ocag_retorna_fecha_normal(ocag_frecepcion_presupuesto,5)) as asgi_fautorizado_finanzas,c.pers_nrut,c.pers_tnombre as nombre,dalu_mmonto_pesos as total, c.PERS_TEMAIL as email    "& vbCrLf &_
				"	from ocag_devolucion_alumno a, ocag_validacion_contable b, personas c  where a.vibo_ccod=4  and ocag_baprueba in (0,1) and b.tsol_ccod = 5 and a.dalu_ncorr=b.cod_solicitud  and a.audi_tusuario=c.pers_nrut "& vbCrLf &_
				"	Union   "& vbCrLf &_
				"	select ocag_responsable,ffij_ncorr as cod_solicitud,ffij_ncorr as num_solicitud,'' as aprueba, isnull(a.vibo_ccod,0) as vibo_ccod,ocag_generador as usuario,  "& vbCrLf &_
				"	'6' as tipo, isnull(a.tsol_ccod,6) as tsol_ccod, ffij_mmonto_pesos as monto, protic.obtener_nombre_completo(a.pers_ncorr, 'n') as pers_tnombre, "& vbCrLf &_
				"   '<a href=""javascript:VerSolicitud('+cast(a.ffij_ncorr as varchar)+',6);"">ver</a>' as solicitud, "& vbCrLf &_
				"   (select top 1 protic.trunc(dpva_fpago) from ocag_detalle_pago_validacion where vcon_ncorr=b.vcon_ncorr) as asgi_fpropuesta_finanzas, "& vbCrLf &_
				"   protic.trunc(protic.ocag_retorna_fecha_normal(ocag_frecepcion_presupuesto,6)) as asgi_fautorizado_finanzas,c.pers_nrut,c.pers_tnombre as nombre,ffij_mmonto_pesos as total, c.PERS_TEMAIL as email    "& vbCrLf &_
				"	from ocag_fondo_fijo a, ocag_validacion_contable b, personas c  where a.vibo_ccod=4 and a.ocag_baprueba in (0,1) and b.tsol_ccod = 6 and a.ffij_ncorr=b.cod_solicitud and a.audi_tusuario=c.pers_nrut "& vbCrLf &_												
				"	Union   "& vbCrLf &_	
				"	select aa.ocag_responsable, a.rfre_ncorr as cod_solicitud, a.rfre_ncorr as num_solicitud,'' as aprueba, isnull(a.vibo_ccod,0) as vibo_ccod  "& vbCrLf &_	
				"	, a.ocag_generador as usuario,   "& vbCrLf &_	
				"	'7' as tipo, isnull(a.tsol_ccod,7) as tsol_ccod, a.rfre_mmonto as monto, protic.obtener_nombre_completo(d.pers_ncorr, 'n') as pers_tnombre,   "& vbCrLf &_	
				"	'<a href=  javascript:VerSolicitud('+cast(a.fren_ncorr as varchar)+',7);  >ver</a>' as solicitud,   "& vbCrLf &_	
				"	protic.trunc(dpva_fpago) as asgi_fpropuesta_finanzas,   "& vbCrLf &_	
				"	protic.trunc(protic.ocag_retorna_fecha_normal(a.ocag_frecepcion_presupuesto,7)) as asgi_fautorizado_finanzas ,f.pers_nrut,f.pers_tnombre as nombre,a.rfre_mmonto as total, d.PERS_TEMAIL as email   "& vbCrLf &_	
				"	from ocag_fondos_a_rendir AA, ocag_rendicion_fondos_a_rendir a, ocag_validacion_contable b, ocag_detalle_pago_validacion c, personas d, personas f  "& vbCrLf &_	
				"	where AA.fren_ncorr = A.fren_ncorr  "& vbCrLf &_	
				"	AND a.rfre_ncorr=b.cod_solicitud AND a.vibo_ccod=4 and isnull(a.ocag_baprueba,1) in (1) and b.tsol_ccod = 7  "& vbCrLf &_	
				"	AND b.vcon_ncorr=c.vcon_ncorr  "& vbCrLf &_	
				"	AND a.pers_nrut=d.pers_nrut  "& vbCrLf &_	
				"	AND a.ocag_generador=f.pers_nrut "& vbCrLf &_
				"	Union   "& vbCrLf &_
				"	select A.ocag_responsable, X.rffi_ncorr as cod_solicitud, X.rffi_ncorr as num_solicitud,'' as aprueba, isnull(x.vibo_ccod,0) as vibo_ccod  "& vbCrLf &_	
				"	, X.ocag_generador as usuario   "& vbCrLf &_	
				"	, '8' as tipo, isnull(x.tsol_ccod,8) as tsol_ccod   "& vbCrLf &_	
				"	, a.ffij_mmonto_pesos as monto  "& vbCrLf &_	
				"	, protic.obtener_nombre_completo(d.pers_ncorr, 'n') as pers_tnombre   "& vbCrLf &_	
				"	, '<a href=  javascript:VerSolicitud('+cast(x.ffij_ncorr as varchar)+',8);  >ver</a>' as solicitud   "& vbCrLf &_	
				"	, protic.trunc(dpva_fpago) as asgi_fpropuesta_finanzas  "& vbCrLf &_	
				"	, protic.trunc(protic.ocag_retorna_fecha_normal(x.ocag_frecepcion_presupuesto,8)) as asgi_fautorizado_finanzas    "& vbCrLf &_	
				"	, f.pers_nrut  "& vbCrLf &_	
				"	, f.pers_tnombre as nombre   "& vbCrLf &_	
				"	, a.ffij_mmonto_pesos as total  "& vbCrLf &_	
				"	, d.PERS_TEMAIL as email   "& vbCrLf &_	
				"	from ocag_fondo_fijo a, ocag_rendicion_fondo_fijo x, ocag_validacion_contable b, ocag_detalle_pago_validacion c, personas d, personas f   "& vbCrLf &_	
				"	WHERE a.ffij_ncorr = X.ffij_ncorr and X.vibo_ccod=4 and isnull(X.ocag_baprueba,1) in (1)  "& vbCrLf &_	
				"	AND X.rffi_ncorr=b.cod_solicitud and b.tsol_ccod = 8   "& vbCrLf &_	
				"	AND b.vcon_ncorr=c.vcon_ncorr  "& vbCrLf &_	
				"	AND a.pers_nrut_aut=d.pers_nrut   "& vbCrLf &_	
				"	AND x.ocag_generador=f.pers_nrut "& vbCrLf &_
				"	) as tabla, ocag_tipo_solicitud b "& vbCrLf &_
				"	where isnull(vibo_ccod,0)=4 "& vbCrLf &_
				" 	and cast(tabla.tsol_ccod as numeric)= b.tsol_ccod "&sql_filtro
				
end if				

'RESPONSE.WRITE("1. sql_solicitudes : "&sql_solicitudes&"<BR>")
 
 'response.Write(sql_solicitudes)
 'response.End()
 f_busqueda.Consultar sql_solicitudes
 'f_busqueda.Siguiente

 set f_buscador = new CFormulario
 f_buscador.Carga_Parametros "vb_vicerector.xml", "buscador"
 f_buscador.Inicializar conectar
 f_buscador.Consultar " select '' "
 f_buscador.Siguiente

	f_buscador.agregaCampoCons "solicitud", v_solicitud
	f_buscador.agregaCampoCons "tsol_ccod", v_tipo
	'f_buscador.agregaCampoParam "tsol_ccod", "filtro", "tsol_ccod in (9)"

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

function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if%>
}

function VerSolicitud(codigo,tsol_ccod){
	window.open("ver_solicitud_giro.asp?solicitud="+codigo+"&tsol_ccod="+tsol_ccod,"solicitud",'scrollbars=yes, menubar=no, resizable=yes, width=800,height=500');
}


function CambiaValor(obj){
	//alert("test")
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

//alert("valor: "+v_valor);
}

function MostrarOcultar(obj) {
  datos.nplazas.style.visibility = (obj.checked) ? 'visible' : 'hidden';
  datos.nplazas.style.width=this.width+'px';
}  



function seleccionar(elemento){
	if (elemento.checked){
		str=elemento.name;
		v_indice=extrae_indice(str);
		document.datos.elements["datos["+v_indice+"][aprueba]"][0].checked=true;
		document.datos.elements["datos["+v_indice+"][aprueba]"][0].disabled=false;
		document.datos.elements["datos["+v_indice+"][aprueba]"][1].disabled=false;

	}else{
		str=elemento.name;
		v_indice=extrae_indice(str);
		document.datos.elements["datos["+v_indice+"][aprueba]"][0].disabled=true;
		document.datos.elements["datos["+v_indice+"][aprueba]"][1].disabled=true;
		document.datos.elements["datos["+v_indice+"][asgi_tobservaciones]"].disabled=true;
	}
}

function verificar(){
	var email= ""	;
var formulario = document.forms["datos"];

var check=document.datos.getElementsByTagName('input');
var cantidadCheck=0;
var checkbox=new Array();
//var tabla = document.getElementById('tb_busqueda_detalle');

var Count = 0
 for (y=0;y<check.length;y++){
	 if (check[y].type=="checkbox"){
		 checkbox[cantidadCheck++]=check[y];
	}
}
	for (x=0;x<cantidadCheck;x++){
		if (checkbox[x].checked) {
			//alert(x)
			Count++;  
		}
	 }

	if (Count==1){
		for (var i = 0; i <= cantidadCheck; i++) {
			if(formulario.elements["datos["+i+"][cod_solicitud]"]){
				v_valor	=	formulario.elements["datos["+i+"][cod_solicitud]"].checked;
				if(v_valor==true){
					//email=formulario.elements["datos["+i+"][pers_temail]"].value;
					v_rut=formulario.elements["datos["+i+"][pers_nrut]"].value;
					proveedor=formulario.elements["datos["+i+"][nombre]"].value;
					monto=formulario.elements["datos["+i+"][total]"].value;
					tsol_tcodigo=formulario.elements["datos["+i+"][cod_solicitud]"].value;
					check=formulario.elements["datos["+i+"][asgi_nestado]"].value;
					//alert("v_rut:  "+v_rut+" proveedor: "+proveedor+"  monto:"+monto+"  tsol_tcodigo:"+tsol_tcodigo)
						for( y = 0; y < 2; y++ ){
						  if(formulario.elements["datos["+i+"][aprueba]"][y].checked){
							aprueba=formulario.elements["datos["+i+"][aprueba]"][y].value;
						  }
						}
				}
			}
		}
		
		if(aprueba==2 && check==3){
			//email=prompt('Ingrese Correo electronico del Solicitante:  (Ejemplo: solicitante@upacifico.cl)','');
			//-----------Carga email de Responsable desde BD, condiciona si el correo es el correcto, si no da opción de ingreso. Rpavez 06/05/2014	
			if (document.datos.elements["email"].value.length<5) {
				email=prompt('Ingrese Correo electronico Jefe Directo:  (Ejemplo: jefe@upacifico.cl)','');
			}
			else{
				if (confirm("Se enviara un correo a: " + document.datos.elements["email"].value)){
				email=document.datos.elements["email"].value;
				}
				else{
				email=prompt('Ingrese Correo electronico Jefe Directo:  (Ejemplo: jefe@upacifico.cl)','');
				}
			}
//-------------------------------------	
			var re  = /^([a-zA-Z0-9_.-])+@((upacifico)+.)+(cl)+$/; 
				if (!re.test(email)) { 
					alert ("Dirección de email inválida"); 
					return false; 
				} 
								
				if((email != "")&&(email != null)){
				
				window.open("http://admision.upacifico.cl/postulacion/www/proc_rechazo_presupuesto.php?proveedor="+proveedor+"&tsol_tcodigo="+tsol_tcodigo+"&monto="+monto+"&correo="+email);
				//return false;
				return true;
				}else{
					alert("Debe Ingresar un Correo Electronico.")
					return false;	
				}	
		}else{
			return true;
		}
	}else{
		alert("Seleccione una opción")
		//return false;
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Solicitudes Pendientes </font></div></td>
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
				  <br>
                    <div align="center"><font size="+1">
                      <%pagina.DibujarTituloPagina()%> 
                      </font>                    </div>
                    <table width="100%" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
                    <td><strong><font color="000000" size="1"> </font></strong>
					
                      <table width="100%" border="0">
                        <tr> 
                          <td>
						<form name="buscador"> 
					  	<table width="100%">
							<tr>
								<td width="17%">Numero Solicitud :</td>
								<td width="18%"><%f_buscador.dibujaCampo("solicitud")%></td>
								<td width="15%">Tipo Solicitud :</td>
							  <td width="20%"><%f_buscador.dibujaCampo("tsol_ccod")%></td>
								
							  <td width="30%" rowspan="2"><%botonera.DibujaBoton "buscar" %></td>
							</tr>
						</table>
					  </form>
						  
						  <hr/>
						  </td>
                        </tr>
						<tr>
							<td>
							<table border ="0" align="center" width="100%">
								<tr valign="top">
								<td>
								<form name="datos" method="post">
								<center><%f_busqueda.DibujaTabla()%>
                                 <input name="email" type="hidden" value="<%f_busqueda.DibujaCampo("email")%>"/></center>
								</form>
									</td>
								</tr>
								<tr>
									<td><font color="#0000FF" size="-2" style="font-family:"Courier New", Courier, monospace">F1=Pago a proveedores&nbsp;&nbsp; F2=Reembolso de gastos&nbsp;&nbsp;F3=Fondo a rendir&nbsp;&nbsp;F4=Solicitud de viatico&nbsp;&nbsp;F5=Devolucion alumno&nbsp;&nbsp;F6=Nuevo fondo fijo&nbsp;&nbsp;F7=Rendicion Fondo a Rendir&nbsp;&nbsp;F8=Rendicion Fondo Fijo&nbsp;&nbsp;F9=Orden de Compra</font></td>
								</tr>								
							  </table>
								
							</td>
						</tr>
                      </table>
                      </td>
                  </tr>
                </table>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="241" bgcolor="#D8D8DE">
				  <table width="49%" height="19"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="30%"><%botonera.dibujaboton "guardar"%></td>
					  <td width="30%"><%botonera.dibujaboton "salir"%></td>
                    </tr>
                  </table>                </td>
                  <td width="121" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
