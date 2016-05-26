<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
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
'FECHA ACTUALIZACION 	:25/09/2013
'ACTUALIZADO POR	:JAIME PAINEMAL A.
'MOTIVO			:PROYECTO ORDEN DE COMPRA
'LINEA			:113
'*******************************************************************
OPCION = request.querystring("OPCION")
pers_nrut = request.querystring("busqueda[0][pers_nrut]")
pers_xdv = request.querystring("busqueda[0][pers_xdv]")
'tipo_doc = request.querystring("tipo_doc")

if OPCION="" then
OPCION=1
end if

'RESPONSE.WRITE("1. OPCION : "&OPCION&"<BR>")
'RESPONSE.WRITE("2. pers_nrut : "&pers_nrut&"<BR>")

set pagina = new CPagina
pagina.Titulo = "Entrega de Cheques"
	
set botonera = new CFormulario
botonera.carga_parametros "entrega_cheques.xml", "botonera"

set conectar = new cconexion
conectar.inicializar "upacifico"

set conexion = new Cconexion2
conexion.Inicializar "upacifico"

set negocio = new cnegocio
negocio.Inicializa conectar

v_usuario=negocio.ObtenerUsuario()

'RESPONSE.WRITE("3. v_usuario : "&v_usuario&"<BR>")

set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "entrega_cheques.xml", "buscador"
f_busqueda.Inicializar conectar
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente

f_busqueda.AgregaCampoCons "pers_nrut", pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", pers_xdv

'if tipo_doc=1 then

'if OPCION=1 or OPCION=2 or OPCION=3  then

	set f_cheques_entregados = new CFormulario
	f_cheques_entregados.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
	f_cheques_entregados.Inicializar conectar
	
	' ACA  PREGUNTA POR LOS CHEQUES ENTREGADOS
	' Y LOS CHEQUES REVALIDADOS 1 VEZ
	'sql_cheques_entregados= "select cpbnum from ocag_entrega_cheques"
	sql_cheques_entregados= " SELECT eche_ndocto FROM ocag_entrega_cheques WHERE eche_ccod <> 4 "
											
	'RESPONSE.WRITE("1. sql_cheques_entregados : "&sql_cheques_entregados&"<BR>")
	
	f_cheques_entregados.Consultar sql_cheques_entregados
	f_cheques_entregados.siguiente

	' ACA CONSTRUYE EL FILTRO PARA DEJAR FUERA LOS CHEQUES ENTREGADOS
	if f_cheques_entregados.nrofilas>0 then
		for fila = 0 to f_cheques_entregados.nrofilas - 1
			'inicio_filtro=" where cpbnum not in ( "
			inicio_filtro=" where numero not in ( "
			if fila=0 then
				'filtro_sga= "'"&f_cheques_entregados.ObtenerValor("cpbnum")&"'"
				filtro_sga= "'"&f_cheques_entregados.ObtenerValor("eche_ndocto")&"'"
			else
				'filtro_sga= filtro_sga&",'"&f_cheques_entregados.ObtenerValor("cpbnum")&"'"
				filtro_sga= filtro_sga&",'"&f_cheques_entregados.ObtenerValor("eche_ndocto")&"'"
			end if
			fin_filtro= ") "
			sql_filtro= inicio_filtro&" "&filtro_sga&" "&fin_filtro
			f_cheques_entregados.siguiente
		next
	end if

'end if

' 888888888888888888888888888888888888888888888888888888888888888888888888888888888

	set f_cheques = new CFormulario
	f_cheques.Carga_Parametros "entrega_cheques.xml", "cheques"

	IF OPCION = 1 THEN
	f_cheques.Inicializar conexion
	END IF

	IF OPCION = 2 THEN
	f_cheques.Inicializar conectar
	END IF

	set f_solicitudes = new CFormulario
	f_solicitudes.Carga_Parametros "entrega_cheques.xml", "solicitudes"
	f_solicitudes.Inicializar conectar

' 888888888888888888888888888888888888888888888888888888888888888888888888888888888

select case (OPCION)

	case 1:

	'CHEQUES PENDIENTES POR ENTREGAR
	if pers_nrut <> "" then
	
'		sql_cheques_softland	=	"select cpbnum,CpbAno,numero, fecha, proveedor, sum(monto) as monto "&_
'								" from ( "&_
'								"  select a.cpbnum,a.CpbAno,convert(char(10),a.movfv,103) as fecha,b.nomaux as proveedor, "&_   
'								"  cast(a.movdebe as integer) as monto,cast(a.NumDoc as integer) as numero "&_   
'								"  from softland.cwmovim a join softland.cwtauxi b "&_   
'								"	on  a.codaux=b.codaux "&_
'								"  where a.codaux='"&pers_nrut&"' "&_
'								"  and a.ttdcod like 'CP' "&_   
'								"  and a.cpbano=2011 "&_ 
'								" ) as tabla "&_
'								" "&sql_filtro&" "&_
'								" group by  cpbnum,CpbAno, numero, fecha, proveedor "

		sql_cheques_softland	=	"select codaux, cpbnum,CpbAno,numero, fecha, proveedor, sum(monto) as monto "& vbCrLf &_
								" from ( "& vbCrLf &_
								"  select a.codaux, a.cpbnum, a.CpbAno,convert(char(10), a.movfv,103) as fecha, b.nomaux as proveedor, "& vbCrLf &_   
								"  cast(a.movdebe as integer) as monto, cast(a.NumDoc as integer) as numero "& vbCrLf &_   
								"  from softland.cwmovim a INNER JOIN softland.cwtauxi b "& vbCrLf &_   
								"	on  a.codaux=b.codaux "& vbCrLf &_
								"  where a.codaux='"&pers_nrut&"' "& vbCrLf &_
								"  and a.ttdcod = 'CP' "& vbCrLf &_   
								"  and a.cpbano>=2013 "& vbCrLf &_ 
								"  and a.movfv is not null "& vbCrLf &_ 
								"  and a.movdebe > 0 "& vbCrLf &_ 
								" ) as tabla "& vbCrLf &_
								" "&sql_filtro&" "& vbCrLf &_
								" group by codaux, cpbnum,CpbAno, numero, fecha, proveedor "
								
	else
		sql_cheques_softland	=	"select '' where 1=2"												
	end if
	
	pagina.Titulo = "Entrega de Cheques - Pendientes"

	case 2:
	
	'CHEQUES ENTREGADOS
	if pers_nrut <> "" then
								
		sql_cheques_softland	=	"select a.cpbnum "& vbCrLf &_ 
								", year(a.eche_fdocto) AS CpbAno "& vbCrLf &_ 
								", protic.trunc(a.eche_fdocto) AS fecha "& vbCrLf &_ 
								", b.PERS_TAPE_PATERNO + ' ' + b.PERS_TAPE_MATERNO + ' ' + b.PERS_TNOMBRE as proveedor "& vbCrLf &_ 
								", a.eche_mmonto AS monto "& vbCrLf &_ 
								", a.eche_ndocto AS numero "& vbCrLf &_ 
								", a.eche_tanotacion_retiro AS observacion "& vbCrLf &_ 
								", c.eche_tdesc "& vbCrLf &_ 
								"from ocag_entrega_cheques a "& vbCrLf &_ 
								"INNER JOIN PERSONAS b "& vbCrLf &_ 
								"ON a.pers_nrut = b.pers_nrut "& vbCrLf &_ 
								"and a.pers_nrut = "&pers_nrut&" "& vbCrLf &_ 
								"INNER JOIN ocag_estado_cheque c "& vbCrLf &_ 
								"ON a.eche_ccod = c.eche_ccod " 
								
	else
		sql_cheques_softland	=	"select '' where 1=2"												
	end if
	
	pagina.Titulo = "Entrega de Cheques - Entregados"
	
	case 3:

	if pers_nrut <> "" then
		sql_solicitudes="select "&_
					"	 tabla.* "&_
					"	 , b.tsol_tdesc, b.tsol_tcodigo, b.tsol_sigla "&_
					"						from ( "&_
					"    select ocag_frecepcion_presupuesto, pers_ncorr_proveedor as pers_ncorr, ocag_responsable, sogi_ncorr as cod_solicitud,sogi_ncorr as num_solicitud,'' as aprueba, isnull(a.vibo_ccod,0) as vibo_ccod, audi_tusuario as usuario, "&_
					"	'1' as tipo, '1' as tsol_ccod, sogi_mgiro as monto,mes_ccod, anos_ccod, protic.obtener_nombre_completo(pers_ncorr_proveedor, 'n') as pers_tnombre,  "&_
					"   '<a href=""javascript:VerSolicitud('+cast(a.sogi_ncorr as varchar)+',1);"">ver</a>' as solicitud,protic.trunc(sogi_fecha_solicitud) as fecha_solicitud "&_
					"	from ocag_solicitud_giro a where isnull(a.vibo_ccod,0)>0     "&_
					"	Union    "&_
					"	select ocag_frecepcion_presupuesto,pers_ncorr_proveedor as pers_ncorr,ocag_responsable,rgas_ncorr as cod_solicitud,rgas_ncorr as num_solicitud,'' as aprueba, isnull(a.vibo_ccod,0) as vibo_ccod,audi_tusuario as usuario,   "&_
					"	'2' as tipo,'2' as tsol_ccod, rgas_mgiro as monto,mes_ccod, anos_ccod, protic.obtener_nombre_completo(pers_ncorr_proveedor, 'n') as pers_tnombre, "&_
					"   '<a href=""javascript:VerSolicitud('+cast(a.rgas_ncorr as varchar)+',2);"">ver</a>' as solicitud,protic.trunc(rgas_fpago) as fecha_solicitud "&_
					"	from ocag_reembolso_gastos a where isnull(a.vibo_ccod,0)>0     "&_
					"	Union   "&_
					"	select ocag_frecepcion_presupuesto,pers_ncorr, ocag_responsable,fren_ncorr as cod_solicitud,fren_ncorr as num_solicitud,'' as aprueba, isnull(a.vibo_ccod,0) as vibo_ccod,audi_tusuario as usuario,  "&_
					"	'3' as tipo,'3' as tsol_ccod, fren_mmonto as monto,mes_ccod, anos_ccod, protic.obtener_nombre_completo(pers_ncorr, 'n') as pers_tnombre, "&_
					"   '<a href=""javascript:VerSolicitud('+cast(a.fren_ncorr as varchar)+',3);"">ver</a>' as solicitud,protic.trunc(fren_fpago) as fecha_solicitud "&_
					"	from ocag_fondos_a_rendir a where isnull(a.vibo_ccod,0)>0     "&_
					"	Union   "&_
					"	select ocag_frecepcion_presupuesto,pers_ncorr, ocag_responsable,sovi_ncorr as cod_solicitud,sovi_ncorr as num_solicitud, '' as aprueba, isnull(a.vibo_ccod,0) as vibo_ccod,audi_tusuario as usuario,  "&_
					"	'4' as tipo,'4' as tsol_ccod, sovi_mmonto_pesos as monto,mes_ccod, anos_ccod, protic.obtener_nombre_completo(pers_ncorr, 'n') as pers_tnombre, "&_
					"   '<a href=""javascript:VerSolicitud('+cast(a.sovi_ncorr as varchar)+',4);"">ver</a>' as solicitud,protic.trunc(sovi_fpago) as fecha_solicitud "&_
					"	from ocag_solicitud_viatico a where isnull(a.vibo_ccod,0)>0    "&_
					"	Union   "&_
					"	select ocag_frecepcion_presupuesto,pers_ncorr,ocag_responsable,dalu_ncorr as cod_solicitud,dalu_ncorr as num_solicitud,'' as aprueba, isnull(a.vibo_ccod,0) as vibo_ccod, audi_tusuario as usuario, "&_
					"	'5' as tipo,'5' as tsol_ccod, dalu_mmonto_pesos as monto,mes_ccod, anos_ccod, protic.obtener_nombre_completo(pers_ncorr, 'n') as pers_tnombre, "&_
					"   '<a href=""javascript:VerSolicitud('+cast(a.dalu_ncorr as varchar)+',5);"">ver</a>' as solicitud,protic.trunc(dalu_fpago) as fecha_solicitud "&_
					"	from ocag_devolucion_alumno a where isnull(a.vibo_ccod,0)>0     "&_
					"	Union   "&_
					"	select ocag_frecepcion_presupuesto,pers_ncorr,ocag_responsable,ffij_ncorr as cod_solicitud,ffij_ncorr as num_solicitud,'' as aprueba, isnull(a.vibo_ccod,0) as vibo_ccod, audi_tusuario as usuario,  "&_
					"	'6' as tipo,'6' as tsol_ccod, ffij_mmonto_pesos as monto,mes_ccod, anos_ccod, protic.obtener_nombre_completo(pers_ncorr, 'n') as pers_tnombre, "&_
					"   '<a href=""javascript:VerSolicitud('+cast(a.ffij_ncorr as varchar)+',6);"">ver</a>' as solicitud,protic.trunc(ffij_fpago) as fecha_solicitud "&_
					"	from ocag_fondo_fijo a where isnull(a.vibo_ccod,0)>0   "&_ 
					"	Union   "&_
					"	select ocag_frecepcion_presupuesto,pers_ncorr,ocag_responsable,ordc_ncorr as cod_solicitud,ordc_ncorr as num_solicitud,'' as aprueba, isnull(a.vibo_ccod,0) as vibo_ccod, audi_tusuario as usuario, "&_  
					"	'9' as tipo, '9' as tsol_ccod, ordc_mmonto as monto,year(fecha_solicitud) as anos_ccod, month(fecha_solicitud) as mes_ccod, protic.obtener_nombre_completo(pers_ncorr, 'n') as pers_tnombre,  "&_  
					"	'<a href=  javascript:VerSolicitud('+cast(a.ordc_ncorr as varchar)+',1);  >ver</a>' as solicitud,protic.trunc(fecha_solicitud) as fecha_solicitud   "&_
					"	from ocag_orden_compra a  where isnull(a.vibo_ccod,0) >0  "&_
					"	) as tabla "&_
					"	INNER JOIN ocag_tipo_solicitud b "&_
					"	ON cast(tabla.tipo as numeric)= b.tsol_ccod "&_
					"	INNER JOIN personas c "&_
					"	ON  tabla.pers_ncorr = c.pers_ncorr "&_
					"	and pers_nrut="&pers_nrut
								
	else
		sql_solicitudes	=	"select '' where 1=2"												
	end if
	
	pagina.Titulo = "Autorizaciones - Pendientes"

End Select


	if OPCION<>3 then
		'response.Write("5. sql_cheques_softland : "&sql_cheques_softland&"<BR>")
		f_cheques.Consultar sql_cheques_softland
	else
		'response.Write("6. sql_solicitudes : "&sql_solicitudes&"<BR>")
		f_solicitudes.Consultar sql_solicitudes
	end if
 
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

function Enviar()
{

	if(pincha==1)
	{
		return true;
	}
	else
	{
		return false;
	}

}

function VerDetalleCheque(num_cheque, cpbnum,cod_aux){
	url="datos_cheque.asp?num_ndocto="+num_cheque+"&cpbnum="+cpbnum+"&cod_aux="+cod_aux;
	window.open(url,"DatosCheque","scrollbars=yes, menubar=no, resizable=yes, width=740,height=400");
}

function ActivaObservacion(objeto){
	formulario = document.datos;
	v_indice=extrae_indice(objeto.name);
	if(objeto.checked){
		formulario.elements["datos["+v_indice+"][eche_tanotacion_retiro]"].value="";
		formulario.elements["datos["+v_indice+"][eche_tanotacion_retiro]"].disabled=false;
		pincha=1
	}else{
		formulario.elements["datos["+v_indice+"][eche_tanotacion_retiro]"].value="seleccione cheque para entrega";
		formulario.elements["datos["+v_indice+"][eche_tanotacion_retiro]"].disabled=true;
		pincha=0
	}
}

/*
function BuscarDocumentos(tipo){
	formulario = document.buscador;
	if (formulario.elements["busqueda[0][pers_nrut]"].value  != ''){
	v_rut	=	formulario.elements["busqueda[0][pers_nrut]"].value;
	v_xdv	=	formulario.elements["busqueda[0][pers_xdv]"].value;
	rut_alumno 	= formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value;

  	  	if (!valida_rut(rut_alumno)) {
			alert('Ingrese un RUT válido.');
			formulario.elements["busqueda[0][pers_xdv]"].focus();
			formulario.elements["busqueda[0][pers_xdv]"].select();
			return false;
		 }else{
		 if (tipo==1){ // Cheques
				formulario.tipo_doc.value=1;
		 }else{//Solicitudes de giro
				formulario.tipo_doc.value=2;
		 }
			formulario.submit();
		}
	 }else{
	 	alert("Debe ingresar un rut valido");
		return false;
	 }
}
*/

function BuscarDocumentos()
{
	formulario = document.buscador;
	if (formulario.elements["busqueda[0][pers_nrut]"].value  != '')
	{
	v_rut	=	formulario.elements["busqueda[0][pers_nrut]"].value;
	v_xdv	=	formulario.elements["busqueda[0][pers_xdv]"].value;
	opcion	=	<%=OPCION%>;
	rut_alumno 	= formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value;

		if (!valida_rut(rut_alumno)) 
		{
			alert('Ingrese un RUT válido.');
			formulario.elements["busqueda[0][pers_xdv]"].focus();
			formulario.elements["busqueda[0][pers_xdv]"].select();
			return false;
		}
		else
		{
			formulario.submit();
		}
	 }
	 else
	 {
	 	alert("Debe ingresar un rut valido");
		return false;
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Entrega de Cheques</font></div></td>
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
<!-- AQUI ESTA EL INICIO DEL FORM DE BUSQUEDA -->

	<%pagina.DibujarLenguetasFClaro Array(array("Cheques Pendientes","entrega_cheques.asp?OPCION=1"),array("Cheques Entregados","entrega_cheques.asp?OPCION=2"),array("Autorizaciones Pendientes","entrega_cheques.asp?OPCION=3")), OPCION %>

<!-- AQUI ESTA EL FIN FORM DE BUSQUEDA -->
				<br>
				<% IF OPCION <>3 THEN %>
					<div align="right">P&aacute;ginas : <%f_cheques.AccesoPagina%></div>
				<% ELSE %>
					<div align="right">P&aacute;gina : <%f_solicitudes.AccesoPagina%></div>
				<% END IF %>
				<br>				  
                    <div align="center"><font size="+1"><%pagina.DibujarTituloPagina()%> </font></div>
					
					<br>
					
<!-- 888888888888888888888888888888888888888888888888888888888888-->
                    <table border="0" width="100%" align="center" cellpadding="0" cellspacing="0">

<!-- 888888888888888888888888888888888888888888888888888888888888-->
					<tr>
					<form name="buscador">
					
					<!--<input type="hidden" name="tipo_doc" value="
					<%
					'=tipo_doc
					%>" />-->
					<input type="hidden" name="OPCION" value="<%=OPCION%>" />
						<td align="center">
							<table width="90%" border='1' bordercolor='#999999'>
							<tr  bgcolor='#ADADAD'>
								<th colspan="2">Ingreso de Rut</th>
								<th>Busqueda por solicitudes</th>
							</tr>
								<tr> 
 								  <td>Rut</td>
								  <td><%f_busqueda.dibujaCampo("pers_nrut")%>-<%f_busqueda.dibujaCampo("pers_xdv")%></td>
								  <td><%botonera.DibujaBoton "cheques_pendientes_2"%></td>
								</tr>
							</table>
						</td>
					</form>
					</tr>
<!-- 888888888888888888888888888888888888888888888888888888888888-->
                  <tr> 
						<td align="center">
						<br/>
				  
						<% 
						'if tipo_doc=1 then
						if OPCION<>3 then
						%>
							<form name="datos" method="post">
								<table width="98%"  border="0" align="center">
								  <tr bgcolor='#C4D7FF'>
									<th width="15%">N&deg; Cheque</th>
									<th width="15%">Monto</th>
                                    <th width="15%">Fecha</th>
									<th width="30%">Proveedor</th>
									<th width="5%">Detalle</th>
									<th width="5%">Entrega</th>
									<th width="30%">Observacion</th>
								  </tr>
								  <%
								  ind=0
								  while f_cheques.Siguiente 
								  %>
								  <input type="hidden" name="datos[<%=ind%>][codaux]" value="<%=f_cheques.obtenerValor("codaux")%>" />
								  <input type="hidden" name="datos[<%=ind%>][cod_numero]" value="<%=f_cheques.obtenerValor("numero")%>" />
								  <input type="hidden" name="datos[<%=ind%>][cod_monto]" value="<%=f_cheques.obtenerValor("monto")%>" />
								  <input type="hidden" name="datos[<%=ind%>][fecha]" value="<%=f_cheques.obtenerValor("fecha")%>" />
								  <input type="hidden" name="datos[<%=ind%>][cpbnum]" value="<%=f_cheques.obtenerValor("cpbnum")%>" />
								  <input type="hidden" name="datos[<%=ind%>][cod_proveedor]" value="<%=pers_nrut%>" />
								  <tr bgcolor='#FFFFFF'>
									<td><div align="right"><%=f_cheques.obtenerValor("numero")%></div></td>
									<td><div align="right"><%=f_cheques.obtenerValor("monto")%></div></td>
                                    <td><div align="right"><%=f_cheques.obtenerValor("fecha")%></div></td>
									<td><div align="right"><%=f_cheques.obtenerValor("proveedor")%></div></td>
									<td><div align="center"><a href="#" onClick="javascript:VerDetalleCheque(<%=f_cheques.obtenerValor("numero")%>,'<%=f_cheques.obtenerValor("cpbnum")%>',<%=pers_nrut%>)"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></div></td>	
									
									<%IF OPCION=1 THEN%>
									<td><div align="center"><input type="checkbox" name="datos[<%=ind%>][eche_ccod]" value="2" onClick="ActivaObservacion(this);"/></div></td>
									<td><div align="right"><input type="text" name="datos[<%=ind%>][eche_tanotacion_retiro]" value="seleccione cheque para entrega" disabled="disabled" size="40"/></div></td>
									<%ELSE%>
									<!--<td><div align="center"><input type="hidden" name="datos[
									<%'=ind
									%>
									][eche_ccod]" value="1" onClick="ActivaObservacion(this);"/></div></td>-->

									<td><div align="right"><%=f_cheques.obtenerValor("eche_tdesc")%></div></td>
									<td><div align="right"><%=f_cheques.obtenerValor("observacion")%></div></td>
									<%END IF%>

								  </tr>
								  <%
								  ind=ind+1
								  wend%>
								</table>
							</form>
							<%
							
							'end if							
							 
							'if tipo_doc=2 then

							else
							f_solicitudes.dibujaTabla
							end if
							 
							%>
							<br>
							<table width="98%"  border="0" align="center">
							  <tr>
								<td><div align="right">
									<%

									if OPCION<>1 then
										botonera.agregabotonparam "guardar" , "deshabilitado" , "TRUE"
									end if

										botonera.DibujaBoton "guardar"
									%>
								</div></td>
							  </tr>
							</table>							
						</td>
                  </tr>
                </table>
<!-- 888888888888888888888888888888888888888888888888888888888888-->
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
					  <td><%botonera.dibujaboton "salir"%></td>
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
