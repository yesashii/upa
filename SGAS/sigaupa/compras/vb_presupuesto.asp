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
'LINEA			:199
'*******************************************************************
v_solicitud	= request.querystring("busqueda[0][solicitud]")
v_tipo		= request.querystring("busqueda[0][tsol_ccod]")

set pagina = new CPagina
pagina.Titulo = "V.B. Presupuesto"

set botonera = new CFormulario
botonera.carga_parametros "vb_presupuesto.xml", "botonera"

set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

v_usuario=negocio.ObtenerUsuario()


 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "vb_presupuesto.xml", "datos_solicitud"
 f_busqueda.Inicializar conectar

if v_usuario="13582834" then
	sql_filtro=""
else 
	sql_filtro =" and ocag_responsable in ("&v_usuario& ")"
end if

if v_solicitud<>"" then
	sql_filtro=sql_filtro&" and cod_solicitud="&v_solicitud
end if

if v_tipo<>"" then
	sql_filtro=sql_filtro& " and tabla.tsol_ccod="&v_tipo
'end if
 
sql_solicitudes=	"select * from ( "&_
					" 	select ocag_responsable,isnull(tsol_ccod,1) as tsol_ccod, sogi_ncorr as cod_solicitud,sogi_ncorr as num_solicitud,'' as aprueba, isnull(vibo_ccod,0) as vibo_ccod, ocag_generador as usuario,sogi_mgiro as monto, "&_
					" 	'<a href=""javascript:VerSolicitud('+cast(a.sogi_ncorr as varchar)+',1);"">ver</a>' as solicitud, 'motivo rechazo' as asgi_tobservaciones, protic.obtener_nombre_completo(b.pers_ncorr,'n') as proveedor,c.pers_nrut,c.pers_tnombre,sogi_mgiro as total, sogi_ncorr as codigo,c.PERS_TEMAIL as email  "&_
					" 	from ocag_solicitud_giro a, personas b, personas c "&_
					" 	where isnull(a.vibo_ccod,0)=1  and isnull(ocag_baprueba,1) in (1) "&_
					" 	and a.pers_ncorr_proveedor=b.pers_ncorr "&_
					" 	and a.audi_tusuario=c.pers_nrut "&_
					"	Union    "&_
					"	select ocag_responsable,isnull(tsol_ccod,2) as tsol_ccod,rgas_ncorr as cod_solicitud,rgas_ncorr as num_solicitud,'' as aprueba, isnull(a.vibo_ccod,0) as vibo_ccod,ocag_generador as usuario,rgas_mgiro as monto,   "&_
					"   '<a href=""javascript:VerSolicitud('+cast(a.rgas_ncorr as varchar)+',2);"">ver</a>' as solicitud,'motivo rechazo' as asgi_tobservaciones,protic.obtener_nombre_completo(b.pers_ncorr,'n') as proveedor,c.pers_nrut,c.pers_tnombre, rgas_mgiro as total, rgas_ncorr as codigo,c.PERS_TEMAIL as email "&_
					"	from ocag_reembolso_gastos a, personas b, personas c   "&_
					" 	where isnull(a.vibo_ccod,0)=1  and isnull(ocag_baprueba,1) in (1) "&_
					" 	and a.pers_ncorr_proveedor=b.pers_ncorr "&_
					" 	and a.audi_tusuario=c.pers_nrut "&_				
					"	Union   "&_
					"	select ocag_responsable,isnull(tsol_ccod,3) as tsol_ccod, fren_ncorr as cod_solicitud,fren_ncorr as num_solicitud,'' as aprueba, isnull(a.vibo_ccod,0) as vibo_ccod,ocag_generador as usuario,fren_mmonto as monto,  "&_
					"   '<a href=""javascript:VerSolicitud('+cast(a.fren_ncorr as varchar)+',3);"">ver</a>' as solicitud,'motivo rechazo' as asgi_tobservaciones,protic.obtener_nombre_completo(b.pers_ncorr,'n') as proveedor,c.pers_nrut,c.pers_tnombre, fren_mmonto as total, fren_ncorr as codigo,c.PERS_TEMAIL as email"&_
					"	from ocag_fondos_a_rendir a, personas b, personas c "&_
					" 	where isnull(a.vibo_ccod,0)=1  and isnull(ocag_baprueba,1) in (1) "&_
					" 	and a.pers_ncorr=b.pers_ncorr "&_
					" 	and a.audi_tusuario=c.pers_nrut "&_					
					"	Union   "&_
					"	select ocag_responsable,isnull(tsol_ccod,4) as tsol_ccod,sovi_ncorr as cod_solicitud,sovi_ncorr as num_solicitud, '' as aprueba, isnull(a.vibo_ccod,0) as vibo_ccod,ocag_generador as usuario,sovi_mmonto_pesos as monto,  "&_
					"   '<a href=""javascript:VerSolicitud('+cast(a.sovi_ncorr as varchar)+',4);"">ver</a>' as solicitud,'motivo rechazo' as asgi_tobservaciones,protic.obtener_nombre_completo(b.pers_ncorr,'n') as proveedor,c.pers_nrut,c.pers_tnombre, sovi_mmonto_pesos as total, sovi_ncorr as codigo,c.PERS_TEMAIL as email "&_
					"	from ocag_solicitud_viatico a, personas b, personas c  "&_
					" 	where isnull(a.vibo_ccod,0)=1  and isnull(ocag_baprueba,1) in (1) "&_
					" 	and a.pers_ncorr=b.pers_ncorr "&_
					" 	and a.audi_tusuario=c.pers_nrut "&_					
					"	Union   "&_
					"	select ocag_responsable,isnull(tsol_ccod,5) as tsol_ccod, dalu_ncorr as cod_solicitud,dalu_ncorr as num_solicitud,'' as aprueba, isnull(a.vibo_ccod,0) as vibo_ccod, ocag_generador as usuario,dalu_mmonto_pesos as monto, "&_
					"   '<a href=""javascript:VerSolicitud('+cast(a.dalu_ncorr as varchar)+',5);"">ver</a>' as solicitud,'motivo rechazo' as asgi_tobservaciones,protic.obtener_nombre_completo(b.pers_ncorr,'n') as proveedor,c.pers_nrut,c.pers_tnombre, dalu_mmonto_pesos as total, dalu_ncorr as codigo,c.PERS_TEMAIL as email "&_
					"	from ocag_devolucion_alumno a, personas b, personas c"&_
					" 	where isnull(a.vibo_ccod,0)=1  and isnull(ocag_baprueba,1) in (1) "&_
					" 	and a.pers_ncorr=b.pers_ncorr "&_
					" 	and a.audi_tusuario=c.pers_nrut "&_					
					"	Union   "&_
					"	select ocag_responsable,isnull(tsol_ccod,6) as tsol_ccod, ffij_ncorr as cod_solicitud,ffij_ncorr as num_solicitud,'' as aprueba, isnull(a.vibo_ccod,0) as vibo_ccod, ocag_generador as usuario,ffij_mmonto_pesos as monto,  "&_
					"   '<a href=""javascript:VerSolicitud('+cast(a.ffij_ncorr as varchar)+',6);"">ver</a>' as solicitud,'motivo rechazo' as asgi_tobservaciones,protic.obtener_nombre_completo(b.pers_ncorr,'n') as proveedor,c.pers_nrut,c.pers_tnombre, ffij_mmonto_pesos as total, ffij_ncorr as codigo,c.PERS_TEMAIL as email "&_
					"	from ocag_fondo_fijo a, personas b, personas c"&_	
					" 	where isnull(a.vibo_ccod,0)=1  and isnull(ocag_baprueba,1) in (1) "&_
					" 	and a.pers_ncorr=b.pers_ncorr "&_
					" 	and a.audi_tusuario=c.pers_nrut "&_
					"	Union   "&_
					"	select  "&_
  					"	a.ocag_responsable "&_
					"	, isnull(a.tsol_ccod,7) as tsol_ccod "&_
					"	, rfre_ncorr as cod_solicitud, rfre_ncorr as num_solicitud "&_
					"	, '' as aprueba "&_
					"	, isnull(a.vibo_ccod,0) as vibo_ccod "&_
					"	, aa.ocag_generador as usuario "&_
					"	, rfre_mmonto as monto "&_
					"	, '<a href=""javascript:VerSolicitud('+cast(a.fren_ncorr as varchar)+',7);"">ver</a>' as solicitud "&_
					"	, 'motivo rechazo' as asgi_tobservaciones "&_
					"	, protic.obtener_nombre_completo(b.pers_ncorr,'n') as proveedor "&_
					"	, c.pers_nrut,c.pers_tnombre, rfre_mmonto as total, rfre_ncorr as codigo,c.PERS_TEMAIL as email  "&_
					"	from ocag_fondos_a_rendir aa  "&_
					"	INNER JOIN ocag_rendicion_fondos_a_rendir a "&_
					"	ON AA.fren_ncorr = A.fren_ncorr AND isnull(a.vibo_ccod,0)=1  and isnull(a.ocag_baprueba,1) in (1)  "&_
					"	INNER JOIN personas b "&_
					"	on a.pers_nrut=b.pers_nrut  "&_
					"	INNER JOIN personas c "&_
					"	ON a.ocag_generador=c.pers_nrut  "&_					
					"	Union   "&_
					"	select A.ocag_responsable  "&_
					"	, isnull(x.tsol_ccod,8) as tsol_ccod  "&_
					"	, x.rffi_ncorr as cod_solicitud  "&_
					"	, x.rffi_ncorr as num_solicitud  "&_
					"	, '' as aprueba, isnull(x.vibo_ccod,0) as vibo_ccod, x.ocag_generador as usuario  "&_
					"	, A.ffij_mmonto_pesos as monto  "&_
					"	, '<a href=""javascript:VerSolicitud('+cast(x.ffij_ncorr as varchar)+',8);"">ver</a>' as solicitud  "&_
					"	, 'motivo rechazo' as asgi_tobservaciones  "&_
					"	,protic.obtener_nombre_completo(b.pers_ncorr,'n') as proveedor,c.pers_nrut,c.pers_tnombre  "&_
					"	, A.ffij_mmonto_pesos as total  "&_
					"	, x.rffi_ncorr as codigo "&_
					"	,c.PERS_TEMAIL as email 	 "&_
					"	from ocag_fondo_fijo a, ocag_rendicion_fondo_fijo x, personas b, personas c 	 "&_
					"	WHERE a.FFIJ_NCORR = x.ffij_ncorr and isnull(x.vibo_ccod,0)=1  and isnull(X.ocag_baprueba,1) in (1)   "&_
					"	AND A.pers_nrut_AUT=b.pers_nrut   "&_
					"	AND X.ocag_generador=c.pers_nrut "&_					
					"	Union   "&_					
					"	select ocag_responsable,isnull(tsol_ccod,9) as tsol_ccod, ordc_ncorr as cod_solicitud,ordc_ncorr as num_solicitud,'' as aprueba, isnull(a.vibo_ccod,0) as vibo_ccod, ocag_generador as usuario, ordc_mmonto as monto, "&_  
					"	'<a href=""javascript:VerSolicitud('+cast(a.ordc_ncorr as varchar)+',9);"">ver</a>' as solicitud,'motivo rechazo' as asgi_tobservaciones, protic.obtener_nombre_completo(b.pers_ncorr, 'n') as proveedor,c.pers_nrut,c.pers_tnombre, ordc_mmonto as total, ordc_ncorr as codigo,c.PERS_TEMAIL as email  "&_  
					"	from ocag_orden_compra a, personas b, personas c   "&_
					"	where isnull(a.vibo_ccod,0)=1  and isnull(ocag_baprueba,1) in (1) "&_
					" 	and a.pers_ncorr=b.pers_ncorr "&_
					" 	and a.ocag_generador=c.pers_nrut "&_																						
					"	) as tabla, ocag_tipo_solicitud b "&_
					"	where isnull(vibo_ccod,0)=1 "&_
					" 	and cast(tabla.tsol_ccod as numeric)= b.tsol_ccod "&sql_filtro
 
 				else
				
				sql_solicitudes="select '' WHERE 1=2"
				
				end if
 
 'response.Write("<pre>"&sql_solicitudes&"</pre>")
 f_busqueda.Consultar sql_solicitudes
 'f_busqueda.Siguiente


set f_buscador = new CFormulario
 f_buscador.Carga_Parametros "vb_presupuesto.xml", "buscador"
 f_buscador.Inicializar conectar
 f_buscador.Consultar " select '' "
 f_buscador.Siguiente

	f_buscador.agregaCampoCons "solicitud", v_solicitud
	f_buscador.agregaCampoCons "tsol_ccod", v_tipo
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
function Revisarfecha(f){

	formulario = document.datos;
	d = new Date();
	mes = d.getMonth()+1;
	if(d.getDate()<10){
		dia = "0"+d.getDate();
	}
	else
	{
		dia = d.getDate();
	}
	if(d.getMonth()<10){
		mes = "0"+mes;
	}
	else
	{
		mes = mes;
	}
	fecha = dia+"/"+ mes +"/"+d.getFullYear();
	if(Date.parse(formulario.elements(f.name).value)>Date.parse(fecha)){
		alert("La fecha de recepcion no puede ser mayor a la fecha actual");
		formulario.elements(f.name).focus();
	}
	else{
		
	}
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
		
		document.datos.elements["datos["+v_indice+"][aprueba_r]"][0].disabled=true;
		document.datos.elements["datos["+v_indice+"][aprueba_r]"][1].disabled=true;
		document.datos.elements["datos["+v_indice+"][asgi_frecepcion_presupuesto]"].disabled=true;
	}else{

		document.datos.elements["datos["+v_indice+"][asgi_tobservaciones]"].disabled=true;
		document.datos.elements["datos["+v_indice+"][asgi_nestado]"].disabled=true;
		
		document.datos.elements["datos["+v_indice+"][aprueba_r]"][0].disabled=false;
		document.datos.elements["datos["+v_indice+"][aprueba_r]"][1].disabled=false;
		document.datos.elements["datos["+v_indice+"][asgi_frecepcion_presupuesto]"].disabled=false;
	}	

}

function MostrarOcultar(obj) {
  datos.nplazas.style.visibility = (obj.checked) ? 'visible' : 'hidden';
  datos.nplazas.style.width=this.width+'px';
//	document.datos.elements["datos[0][asgi_tobservaciones]"].style.visibility = (obj.checked) ? 'visible' : 'hidden';
//	document.datos.elements["datos[0][asgi_tobservaciones]"].style.width="100px;";
  
}

function seleccionar(elemento){

var formulario = document.forms["datos"];
var check=document.datos.getElementsByTagName('input');
var cantidadCheck=0;
var checkbox=new Array();

var Count = 0
	
	for (y=0;y<check.length;y++){
		if (check[y].type=="checkbox"){
			checkbox[cantidadCheck++]=check[y];
		}
	}
	
	for (var i = 0; i <= cantidadCheck; i++) {
	
		if(formulario.elements["datos["+i+"][cod_solicitud]"]){
		
			v_valor	=	formulario.elements["datos["+i+"][cod_solicitud]"].checked;
			
			if(v_valor==true)
			{
			
			// pinchado
			
				monto=formulario.elements["datos["+i+"][total]"].value;
				
				if(monto<1500000)
				{

						if (elemento.checked)
						{

							document.datos.elements["datos["+i+"][aprueba]"][0].checked=true;
							document.datos.elements["datos["+i+"][aprueba]"][0].disabled=false;
							document.datos.elements["datos["+i+"][aprueba]"][1].disabled=false;
							document.datos.elements["datos["+i+"][asgi_frecepcion_presupuesto]"].disabled=false;
							
							document.datos.elements["datos["+i+"][aprueba_r]"][1].checked=true;
							document.datos.elements["datos["+i+"][aprueba_r]"][0].disabled=false;
							document.datos.elements["datos["+i+"][aprueba_r]"][1].disabled=false;
							
						}
						
				}else
				{
				
						if (elemento.checked)
						{

							document.datos.elements["datos["+i+"][aprueba]"][0].checked=true;
							document.datos.elements["datos["+i+"][aprueba]"][0].disabled=false;
							document.datos.elements["datos["+i+"][aprueba]"][1].disabled=false;
							document.datos.elements["datos["+i+"][asgi_frecepcion_presupuesto]"].disabled=false;
							
							document.datos.elements["datos["+i+"][aprueba_r]"][0].checked=true;
							document.datos.elements["datos["+i+"][aprueba_r]"][0].disabled=false;
							document.datos.elements["datos["+i+"][aprueba_r]"][1].disabled=false;
							
						}
					
				}
			
			}
			else
			{
			
			// no pinchado
			//alert("aca");

							document.datos.elements["datos["+i+"][aprueba]"][0].disabled=true;
							document.datos.elements["datos["+i+"][aprueba]"][1].disabled=true;
							document.datos.elements["datos["+i+"][asgi_nestado]"].disabled=true;
							document.datos.elements["datos["+i+"][asgi_tobservaciones]"].disabled=true;
							document.datos.elements["datos["+i+"][asgi_frecepcion_presupuesto]"].disabled=true;
								
							document.datos.elements["datos["+i+"][aprueba_r]"][0].disabled=true;
							document.datos.elements["datos["+i+"][aprueba_r]"][1].disabled=true;

			}
			
		}
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
					proveedor=formulario.elements["datos["+i+"][pers_tnombre]"].value;
					monto=formulario.elements["datos["+i+"][total]"].value;
					tsol_tcodigo=formulario.elements["datos["+i+"][codigo]"].value;
					check=formulario.elements["datos["+i+"][asgi_nestado]"].value;
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
			
			/*if (email==""){
				confirmar=confirm("Debe ingresar un correo electronico"); 
					if (confirmar) {
					window.open("../ADM_SISTEMA/editar_persona.asp?persona[0][pers_nrut]="+v_rut,"solicitud",'scrollbars=yes, menubar=no, resizable=yes, width=800,height=500');
					}else {
					alert('No se ha realizado la solicitud');
					return false;
					}
			}else{
				window.open("http://admision.upacifico.cl/postulacion/www/proc_rechazo_presupuesto.php?proveedor="+proveedor+"&tsol_tcodigo="+tsol_tcodigo+"&monto="+monto+"&correo="+email);
				//alert("Correo electronico de destino es "+ email)
				return true;
				//return false;
			}*/
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
							<br/>
							<table border ="0" align="center" width="100%">
								<tr valign="top">
								<td>
								<form name="datos" method="post" id="datos">
								<center><%f_busqueda.DibujaTabla()%>
                                <input name="email" type="hidden" value="<%f_busqueda.DibujaCampo("email")%>"/>
                                </center>
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
