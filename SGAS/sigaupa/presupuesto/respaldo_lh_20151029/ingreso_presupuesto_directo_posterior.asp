<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
sin_bloqueo=false
Server.ScriptTimeout = 2000 
set pagina = new CPagina
pagina.Titulo = "Solicitud Presupuestaria"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set conexion2 = new CConexion2
conexion2.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
v_usuario = negocio.ObtenerUsuario()
'response.Write("Usuario: "&Usuario)

'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "solicitud_presupuestaria.xml", "botonera"
'-----------------------------------------------------------------------
 
 codcaja	= request.querystring("busqueda[0][codcaja]")
 area_ccod	= request.querystring("busqueda[0][area_ccod]")
 mes_venc	= request.querystring("busqueda[0][mes_venc]")  
 nro_t		= request.querystring("nro_t")
 v_concepto = request.querystring("busqueda[0][concepto]")
 v_detalle  = request.querystring("busqueda[0][detalle]")    
 
 if codcaja="" then
	 codcaja= request.querystring("codcaja")
 end if

 if area_ccod="" then
	 area_ccod= request.querystring("area_ccod")
 end if

 


 v_anio_actual	= conexion2.ConsultaUno("select year(getdate())")
 v_prox_anio	=	v_anio_actual+1
 'v_prox_anio	=	v_anio_actual ' se agrego por que el 2010 el presupuesto paso de año
 'response.Write(" v_anio_actual: "&v_anio_actual&" v_prox_anio:"&v_prox_anio)
 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "solicitud_presupuestaria.xml", "busqueda_presupuesto"
 f_busqueda.Inicializar conexion2
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoParam "area_ccod", "filtro",  "area_ccod in ( select area_ccod from  presupuesto_upa.protic.area_presupuesto_usuario  where rut_usuario in ('"&v_usuario&"') )"
 f_busqueda.AgregaCampoCons "area_ccod", area_ccod

 f_busqueda.AgregaCampoParam "codcaja", "destino",  " (select distinct cpre_orden, cod_pre, concepto_pre +' ('+cod_pre+')' as valor from presupuesto_upa.protic.codigos_presupuesto where cod_area in ('"&area_ccod&"')) a "
 f_busqueda.AgregaCampoCons "codcaja", codcaja
 f_busqueda.AgregaCampoCons "detalle", v_detalle
 
' Bloquea la caja de texto para ingresar un nuevo detalle mientras esta algun detalle seleccionado
if v_detalle<>""  and codcaja <> "" then
	f_busqueda.AgregaCampoCons "nuevo_detalle", "-Bloqueado-"	
	mostrar_agregar=false
end if


if v_detalle=""  and codcaja <> "" then
	f_busqueda.AgregaCampoParam "nuevo_detalle", "deshabilitado", "false"
	f_busqueda.AgregaCampoCons "nuevo_detalle", ""
	mostrar_agregar=true	
else
	f_busqueda.AgregaCampoCons "nuevo_detalle", "-Bloqueado-"	
	mostrar_agregar=false
end if
 
'Activa filtros si se ha seleccionado un codigo presupuestario 
 if codcaja <>"" then
	 f_busqueda.AgregaCampoParam "detalle", "destino",  " (select distinct cpre_ncorr,cod_pre,concepto_pre, detalle_pre from presupuesto_upa.protic.codigos_presupuesto) a "
	 f_busqueda.AgregaCampoParam "detalle", "filtro",  " cod_pre in ('"&codcaja&"') "
	 
	 txt_detalle= conexion2.ConsultaUno("select detalle_pre from presupuesto_upa.protic.codigos_presupuesto where cast(cpre_ncorr as varchar)='"&v_detalle&"'")
 else
    f_busqueda.AgregaCampoParam "detalle", "destino",  " (select '' as cpre_ncorr,'' as cod_pre,'' as concepto_pre, '' as detalle_pre where 1=1 ) a "
	f_busqueda.AgregaCampoParam "detalle", "deshabilitado", "true"
 end if
'----------------------------------------------------------------------------


 set f_presupuesto = new CFormulario
 f_presupuesto.Carga_Parametros "solicitud_presupuestaria.xml", "f_presupuesto"
 f_presupuesto.Inicializar conexion2

   if Request.QueryString <> "" then
	  
	  if nro_t="" then
	  	nro_t=1
	  end if

	select case (nro_t)
		
		case 1:
	
			if mes_venc <> "" then
				sql_mes= "and month(movfv)="&mes_venc
				nombre_mes=conexion2.consultauno("select nombremes from softland.sw_mesce where indice="&mes_venc&"")
				
				if mes_venc=0 then
					nombre_mes= "TODOS LOS MESES"
					sql_mes=""
				end if
			
			end if


			if codcaja <> "" then
					'######################## por codigo	###################	
				consulta_prespuesto="select  month(movfv) as mes_venc,* from softland.cwmovim " & vbCrLf &_
								" where year(movfv)=year(getdate()) " & vbCrLf &_
								" and movhaber <> 0 " & vbCrLf &_
								" and cpbnum>0 "& vbCrLf &_
								" and pctcod like '2-10-070-10-000003' "& vbCrLf &_
								" "&sql_mes&" "& vbCrLf &_
								" and cajcod='"&codcaja&"' "

				if txt_detalle <>"" then
					str_detalle="and detalle='"&txt_detalle&"'"
				end if 
						
				sql_meses= "	select  upper(nombremes) as mes,indice as mes_venc,sum(cast(isnull(solicitado,0) as numeric)) as solicitado,   "& vbCrLf &_ 
							" sum(cast(isnull(presupuestado,0) as numeric)) as presupuestado "& vbCrLf &_
							"	 from softland.sw_mesce as b   "& vbCrLf &_
							"	 left outer join (  "& vbCrLf &_
							"		select pa.mes as mes, sum(solicitado) as solicitado,sum(presupuestado) as presupuestado "& vbCrLf &_
							"			from     	"& vbCrLf &_
							"				( 		"& vbCrLf &_
							"				select sum(valor) as presupuestado,sum(valor) as solicitado,mes,cod_anio, cod_pre, cod_area, descripcion_area,concepto "& vbCrLf &_
							"				from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2013     "& vbCrLf &_
							"				where cod_pre='"&codcaja&"' "& vbCrLf &_
							"				and cod_area="&area_ccod&" "& vbCrLf &_
							"				"&str_concepto&" "& vbCrLf &_
							"				"&str_detalle&" "& vbCrLf &_
							"				and cod_anio=year(getdate()) "& vbCrLf &_
							"				group by mes,cod_anio, cod_pre, cod_area, descripcion_area,concepto  "& vbCrLf &_
							"				) as pa "& vbCrLf &_
							"			group by pa.mes   "& vbCrLf &_                    
							"	)as a  "& vbCrLf &_
							"on indice=mes  "& vbCrLf &_
						"group by nombremes,indice "
							
			else
				'######################## por area	###################	
				consulta_prespuesto="select  month(movfv) as mes_venc,* from softland.cwmovim " & vbCrLf &_
						" where year(movfv)=year(getdate()) " & vbCrLf &_
						" and movhaber <> 0 " & vbCrLf &_
						" and cpbnum>0 "& vbCrLf &_
						" and pctcod like '2-10-070-10-000003' "& vbCrLf &_
						" "&sql_mes&" "& vbCrLf &_
						" and cajcod in (select distinct cod_pre from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2013 where cod_area="&area_ccod&") "
			
			
				sql_meses= "	select  upper(nombremes) as mes,indice as mes_venc,sum(cast(isnull(solicitado,0) as numeric)) as solicitado,   "& vbCrLf &_ 
							" sum(cast(isnull(presupuestado,0) as numeric)) as presupuestado "& vbCrLf &_
							"	 from softland.sw_mesce as b   "& vbCrLf &_
							"	 left outer join (  "& vbCrLf &_
							"		select pa.mes as mes, sum(solicitado) as solicitado,sum(presupuestado) as presupuestado "& vbCrLf &_
							"			from     "& vbCrLf &_
							"				(select sum(valor) as presupuestado,sum(valor) as solicitado,mes,cod_anio,cod_area, descripcion_area "& vbCrLf &_
							"				from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2013     "& vbCrLf &_
							"				where cod_pre in (select distinct cod_pre from presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2013 where cod_area= "&area_ccod&" ) "& vbCrLf &_
							"				and cod_anio=year(getdate()) "& vbCrLf &_
							"				group by mes,cod_anio, cod_area, descripcion_area  "& vbCrLf &_
							"				) as pa "& vbCrLf &_
							"			group by pa.mes   "& vbCrLf &_                    
							"	)as a  "& vbCrLf &_
							"on indice=mes  "& vbCrLf &_
						"group by nombremes,indice "
						
			end if
		
			f_presupuesto.consultar consulta_prespuesto			
			
			
		
			set f_meses = new CFormulario
			f_meses.Carga_Parametros "solicitud_presupuestaria.xml", "solicitud"
			f_meses.Inicializar conexion2

			'response.Write("<pre>"&sql_meses&"</pre>")
			f_meses.consultar sql_meses
			
	end select	

	sql_area_presu	= " select top 1 area_tdesc from presupuesto_upa.protic.area_presupuesto_usuario a, presupuesto_upa.protic.area_presupuestal b " & vbCrLf &_
					" where a.area_ccod=b.area_ccod " & vbCrLf &_
					" and rut_usuario="&v_usuario&"  and a.area_ccod="&area_ccod&"  "
	
	area_presupuesto = 	conexion2.consultaUno(sql_area_presu)


else
	 f_presupuesto.consultar "select '' where 1 = 2"
	 f_presupuesto.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
end if

if v_usuario= "13582834" or v_usuario= "13493596" or v_usuario="9251062" or v_usuario="11843248" then
	sin_bloqueo=true
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
function Validar(){
	return true;
}

function CargarCodigo(formulario, espe_ccod)
{

	formulario.elements["busqueda[0][detalle]"].value="";
	_Buscar(this, document.forms['busca_codigo'],'', 'Validar();', 'FALSE');
}

function CargarConcepto(formulario)
{

	_Buscar(this, document.forms['busca_codigo'],'', 'Validar();', 'FALSE');
}


function CargarDetalles(formulario)
{
	_Buscar(this, document.forms['busca_codigo'],'', 'Validar();', 'FALSE');
}

function GuardarDetalle()
{
//alert();
	formulario=document.forms['busca_codigo'];
	formulario.action = "proc_agrega_detalle_posterior.asp";
//alert();	
	formulario.method = "post";
	formulario.submit(); 
}

function ver_detalle(var1,var2,var3){
	formulario=document.forms['busca_codigo'];
	formulario.elements["busqueda[0][mes_venc]"].value=var3
	_Buscar(this, document.forms['busca_codigo'],'', 'Validar();', 'FALSE');

}



function ValidaNumero(elemento){
	formulario=document.forms['solicitud'];
	cadena=elemento.name;
	valor_nuevo=cadena.substring(1,cadena.Length); 
//alert(elemento.value);
	if(isNumber(formulario.elements[valor_nuevo].value)){
		CalcularTotalSolicitado();
		return true;
	}else{
		alert("Ingrese un numero válido");
		elemento.value="0";
		elemento.focus();
	}
}

function CalcularTotalSolicitado()
{
	var formulario = document.forms["solicitud"];
	
	v_total_solicitud = 0;
	
	for (var i = 0; i < 12; i++) {
		if (formulario.elements["test["+i+"][solicitado]"].value){
			v_total_solicitud = v_total_solicitud + parseInt(formulario.elements["test["+i+"][solicitado]"].value);
		}
	}
	
	formulario.total_solicitud.value=	FormatoMoneda(String(v_total_solicitud));

}


function FormatoMoneda(valor){
	salida = '';
	numDecimales=0;

		if((valor.length-numDecimales)%3>0){
				adicional = 1;
		}
			iteraciones = ((valor.length-numDecimales)-(valor.length-numDecimales)%3)/3 + adicional;
		    for(i=1;i<=iteraciones;i++) {
			    extra = valor.length-3*i-numDecimales < 0 ? valor.length-3*i-numDecimales : 0;
				if(i==1)
					salida = valor.substr(valor.length-3*i-numDecimales,3+extra) + salida;				
				else
					salida = valor.substr(valor.length-3*i-numDecimales,3+extra) + '.' + salida;
			}
				if(salida==''){
					salida = 0;
				}
					salida = '$ ' + salida;
	return salida;			
}

function GrabarRegistro()
{
	formulario=document.forms['solicitud'];
	formulario.action = "proc_grabar_solicitud_posterior.asp";
	formulario.method = "post";
	formulario.submit(); 

}

function CambiaEstado(num,v_estado,codigo){
area='<%=area_ccod%>';
	if(v_estado==2){
		alert("Esta solicitud ya fue activada, por lo tanto no es posible realizar modificaciones");
	}else{
	
		if(v_estado==1){
			txt_estado="Dar de alta";
		}else{
			txt_estado="dejar Pendiente";
		}
		
		if(confirm("Esta seguro que desea "+txt_estado+" la solicitud seleccionada")){
			location.href="proc_cambia_estado_solicitud_encargado.asp?nro="+num+"&etd="+v_estado+"&cod="+codigo+"&area="+area;
		}		
			
	}

}

function Rechazar(num,codigo){
	if(confirm("Está a punto de rechazar una solicitud, desea continuar?")){
		direccion = "motivo_rechazo.asp?cod="+codigo+"&nro="+num;
		window.open(direccion, "ventana1","width=300,height=180,scrollbars=no, left=380, top=350");
	}
}

function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if%>
}

</script>
<style type="text/css">

	.meses:link, .meses:visited { 	text-decoration: underline;color:#0033FF; }
	.meses:hover {	text-decoration: none; }
	
</style>
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
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
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
				<form name="buscador">                
                      <table width="100%" border="0" align="left">
                        <tr>
                          <td width="35"></td>
						  <td width="190"><div align="left"><strong>Area Presupuesto</strong>  </div></td>
						  <td width="482"><% f_busqueda.DibujaCampo ("area_ccod") %></td>  
                          <td width="183"><div align="center"><%botonera.DibujaBoton "buscar" %></div></td>
                        </tr>
                      </table>
				</form>
                </td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE" background="../imagenes/base2.gif"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>			
          </td>
      </tr>
    </table>	
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
              <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td ><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td background="../imagenes/top_r1_c2.gif"><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="15" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="114" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Presupuesto</font></div>
                    </td>
                    <td width="904" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                  </tr>
                </table>
              </td>
              <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td background="../imagenes/top_r3_c2.gif"><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
            </tr>

              <tr>
                <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"> <div align="center"><BR>
                    <%pagina.DibujarTituloPagina%>
                  </div>
			<% if area_ccod <> "" then	%>  
				  <table width="632"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#EDEDEF">
                    <tr> 
                      <td width="9" height="8"><img src="../imagenes/marco_claro/1.gif" width="9" height="8"></td>
                      <td height="8" background="../imagenes/marco_claro/2.gif"></td>
                      <td width="7" height="8"><img src="../imagenes/marco_claro/3.gif" width="7" height="8"></td>
                    </tr>
                    <tr> 
                      <td width="9" background="../imagenes/marco_claro/9.gif">&nbsp;</td>
                      <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td> 
                              <%pagina.DibujarLenguetasFClaro Array(array("Carga","ingreso_presupuesto_directo.asp?area_ccod="&area_ccod&"&codcaja="& codcaja &"&nro_t=1")), nro_t %>
                            </td>
                          </tr>
                          <tr> 
                            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
                          </tr>
                          <tr> 
                            <td> 
								<table border="1" width="100%">
								<tr>
								<% 
								select case (nro_t)
								case 1:
								%>
								
								<td valign="top" width="30%">
								<br/>
								<center><font color="#0000CC" size="2"><b><%=area_presupuesto%></b></font></center>
									<form name="busca_codigo" method="get">
									<input type="hidden" name="nro_t" value="<%=nro_t%>" >
									<input type="hidden" name="busqueda[0][area_ccod]" value="<%=area_ccod%>"/>
									<input type="hidden" name="busqueda[0][mes_venc]" value=""/>
									<table width="100%" border="0">
										<tr>
											<td colspan="2" align="center"><br></td>
										</tr>									
										<tr>                          
											<td colspan="2"><div align="left"><strong>Concepto  presupuestario</strong></div></td>
										</tr>
										<tr>
											<td colspan="2"><% f_busqueda.DibujaCampo("codcaja") %></td>
										</tr>
										<tr>
										  <td colspan="2"><strong>Detalle presupuesto</strong> </td>
										</tr>
										<tr>
											<td colspan="2" align="left"><%f_busqueda.DibujaCampo ("detalle")%></td>
										</tr>
										<tr>
										  <td><strong>Agrega nuevo detalle</strong> </td>
										</tr>										
										<tr>
											<td align="left"><%f_busqueda.DibujaCampo ("nuevo_detalle")%></td>
											<td align="left"><%	
													if sin_bloqueo then
														if mostrar_agregar then
															botonera.DibujaBoton ("guardar_posterior")
														end if
													end if
													%>											
											</td>
										</tr>											
									</table>
									<br>
									<center>
									</center>
									</form>								
									</td>
								<td width="70%">
								
								
 								<form name="solicitud">
							
									  <input type="hidden" name="codcaja" value="<%=codcaja%>">
									  <input type="hidden" name="area_ccod" value="<%=area_ccod%>">
									  <input type="hidden" name="detalle" value="<%=v_detalle%>">

									<center><font color="#0000CC" size="2"><%=txt_detalle%></font></center>
								  <table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
									  <th width="33%">MES</th>
									  <th width="19%">Nuevo monto</th>
									  <th width="48%"><%=v_anio_actual%></th>
									</tr>
									<%
									v_total_soli	=0
									v_total_presu	=0
									'v_total_desvi	=0
									while f_meses.Siguiente
										v_total_soli	=	v_total_soli	+	Cdbl(f_meses.ObtenerValor("solicitado"))
										v_total_presu	=	v_total_presu	+	Cdbl(f_meses.ObtenerValor("presupuestado"))
										v_mes_venc		=	Cint(f_meses.ObtenerValor("mes_venc"))
									%>
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><b><%f_meses.DibujaCampo("mes")%></b></font></td>
									  <td><%=f_meses.DibujaCampo("solicitado")%></td>
									  <td><%=formatcurrency(f_meses.ObtenerValor("presupuestado"),0)%></td>
									</tr>
									 <%wend%>
									 <tr bordercolor='#999999'>
										<td><b>TOTAL</b></td>
										<td align="right"><input type='text' name='total_solicitud' value='' readonly style="background-color:#EDEDEF;border: 1px #EDEDEF solid;">										</td>
										<td><b><%=formatcurrency(v_total_presu,0,0)%></b></td>
									 </tr>
								  </table>
								  </form>							</td></tr>
							<tr><td colspan="2">  
								  <%if mes_venc<>"" then%>
							</td></tr>
								  
							<%end if%>
							 <tr>
							   <td colspan="2">
      							 <tr><td colspan="2">	  
								  <br/>
								  <center></center>
								
							<%End Select%>
						<br/>
						</td></tr></table>
						</td>
                          </tr>
                        </table></td>
                      		<td width="7" background="../imagenes/marco_claro/10.gif">&nbsp;</td>
                    	</tr>
					  	<tr>
							<td align="left" valign="top"><img src="../imagenes/marco_claro/17.gif" width="9" height="28"></td>
							<td valign="top">
							<!-- desde aca -->
							<table  width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
                          		<tr > 
                            		<td width="47%" height="20"><div align="center"> 
                                		<table width="94%"  border="0" cellspacing="0" cellpadding="0">
										  	<tr> 
											<% 
											select case (nro_t)
												case 1:
												%>
												<td width="49%">
												</td>
												<td width="100%">
													<%
													if sin_bloqueo then
													if v_detalle<>""  and codcaja <> "" then
														botonera.DibujaBoton ("grabar")
													end if
													end if
													%>
												</td>	
												<% end select %>
										  	</tr>
                                		</table>
                              </div></td>
								<td width="53%" rowspan="2" background="../imagenes/marco_claro/15.gif"><img src="../imagenes/marco_claro/14.gif" width="12" height="28"></td>
                          	</tr>
							   <tr> 
                            		<td height="8" background="../imagenes/marco_claro/13.gif"></td>
                          		</tr>
							</table>
							<!-- hasta aca 
							<img src="../imagenes/marco_claro/15.gif" width="100%" height="13">--></td>
							<td align="right" valign="top" height="13"><img src="../imagenes/marco_claro/16.gif" width="7"height="28"></td>
					  	</tr>
                  </table>
				  <% end if %>
                    <br/>
					<br/>
                </td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="10" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                <td width="152" bgcolor="#D8D8DE"><table width="100%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td><% botonera.DibujaBoton ("lanzadera") %></td>
                    </tr>
                  </table>
                </td>
                <td width="100%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                <td width="7" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
              </tr>
              <tr>
                <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
              </tr>
            </table>
        </td>
      </tr>
    </table>
	<p>&nbsp;</p></td>
  </tr>  
</table>
</body>
</html>