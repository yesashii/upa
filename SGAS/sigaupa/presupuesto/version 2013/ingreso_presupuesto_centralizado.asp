<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 2000 
set pagina = new CPagina
pagina.Titulo = "Solicitud Centralizada"
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
botonera.Carga_Parametros "solicitud_presupuestaria_centralizada.xml", "botonera"
'-----------------------------------------------------------------------
 
 codcaja	= request.querystring("busqueda[0][codcaja]")
 area_ccod	= request.querystring("busqueda[0][area_ccod]")
 mes_venc	= request.querystring("busqueda[0][mes_venc]")  
 nro_t		= request.querystring("nro_t")
 
 if codcaja="" then
	 codcaja= request.querystring("codcaja")
 end if

 if area_ccod="" then
	 area_ccod= request.querystring("area_ccod")
 end if

 v_anio_actual	= conexion2.ConsultaUno("select year(getdate())")

 v_mes_actual	= conexion2.ConsultaUno("select month(getdate())")

'if v_mes_actual <=10 then
'	v_prox_anio	=	v_anio_actual
'else
'	v_prox_anio	=	v_anio_actual+1
'end if
 
v_prox_anio	=	v_anio_actual+1
' v_prox_anio	=	v_anio_actual ' se agrego por que el 2010 el presupuesto paso de a�o
  
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "solicitud_presupuestaria_centralizada.xml", "busqueda_presupuesto"
 f_busqueda.Inicializar conexion2
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoParam "area_ccod", "filtro",  "area_ccod in ( select area_ccod from  presupuesto_upa.protic.area_presupuesto_usuario  where rut_usuario in ('"&v_usuario&"') )"
 f_busqueda.AgregaCampoCons "area_ccod", area_ccod

'----------------------------------------------------------------------------
set f_solicitado = new CFormulario
f_solicitado.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
f_solicitado.Inicializar conexion2


set f_aprobados = new CFormulario
f_aprobados.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
f_aprobados.Inicializar conexion2



set f_concepto = new CFormulario
f_concepto.Carga_Parametros "solicitud_presupuestaria_centralizada.xml", "concepto"
f_concepto.Inicializar conexion2
f_concepto.Consultar "select ''"
f_concepto.Siguiente


	
   if Request.QueryString <> "" then
	  
	  if nro_t="" then
	  	nro_t=1
	  end if


			
	select case (nro_t)
		case 1:
			sql_solicitud="select *,nombremes, case a.esol_ccod when 1 then 'Anular' when 3 then 'Dejar Pendiente' when 4 then 'Ver motivo' else 'Estado Final' end as accion "& vbCrLf &_
							" from presupuesto_upa.protic.centralizar_solicitud_audiovisual a, presupuesto_upa.protic.concepto_centralizado b,presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d "& vbCrLf &_
							"	where a.tpre_ccod in (1) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
							"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
							"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
							"	and isnull(mes_ccod,1)=d.indice "& vbCrLf &_
							" 	and a.esol_ccod not in (2,3) "& vbCrLf &_
							"	and area_ccod="&area_ccod&" and anio_ccod="&v_prox_anio
						
			sql_aprobadas="select * "& vbCrLf &_
							" from presupuesto_upa.protic.centralizar_solicitud_audiovisual a, presupuesto_upa.protic.concepto_centralizado b,presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d "& vbCrLf &_
							"	where a.tpre_ccod in (1) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
							"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
							"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
							"	and isnull(mes_ccod,1)=d.indice "& vbCrLf &_
							" 	and a.esol_ccod in (2) "& vbCrLf &_
							"	and area_ccod="&area_ccod&" and anio_ccod="&v_prox_anio
												
			f_concepto.AgregaCampoParam "ccen_ccod", "filtro", "tpre_ccod in (1)"
			
		case 2:
			sql_solicitud="select *,nombremes, case a.esol_ccod when 1 then 'Anular' when 3 then 'Dejar Pendiente' when 4 then 'Ver motivo' else 'Estado Final' end as accion "& vbCrLf &_
						" from presupuesto_upa.protic.centralizar_solicitud_biblioteca a, presupuesto_upa.protic.concepto_centralizado b,presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d "& vbCrLf &_
						"	where a.tpre_ccod in (2) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
						"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
						"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
						"	and isnull(mes_ccod,1)=d.indice "& vbCrLf &_
						" 	and a.esol_ccod not in (2,3) "& vbCrLf &_
						"	and area_ccod="&area_ccod&" and anio_ccod="&v_prox_anio
			
			sql_aprobadas="select * "& vbCrLf &_
						" from presupuesto_upa.protic.centralizar_solicitud_biblioteca a, presupuesto_upa.protic.concepto_centralizado b,presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d "& vbCrLf &_
						"	where a.tpre_ccod in (2) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
						"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
						"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
						"	and isnull(mes_ccod,1)=d.indice "& vbCrLf &_
						" 	and a.esol_ccod in (2) "& vbCrLf &_
						"	and area_ccod="&area_ccod&" and anio_ccod="&v_prox_anio		
							
			f_concepto.AgregaCampoParam "ccen_ccod", "filtro", "tpre_ccod in (2)"
			
		case 3:
			sql_solicitud="select *,nombremes, case a.esol_ccod when 1 then 'Anular' when 3 then 'Dejar Pendiente' when 4 then 'Ver motivo' else 'Estado Final' end as accion "& vbCrLf &_
						" from presupuesto_upa.protic.centralizar_solicitud_computacion a, presupuesto_upa.protic.concepto_centralizado b,presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d "& vbCrLf &_
						"	where a.tpre_ccod in (3) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
						"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
						"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
						"	and isnull(mes_ccod,1)=d.indice "& vbCrLf &_
						" 	and a.esol_ccod not in (2,3) "& vbCrLf &_
						"	and area_ccod="&area_ccod&" and anio_ccod="&v_prox_anio

			sql_aprobadas="select * "& vbCrLf &_
						" from presupuesto_upa.protic.centralizar_solicitud_computacion a, presupuesto_upa.protic.concepto_centralizado b,presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d "& vbCrLf &_
						"	where a.tpre_ccod in (3) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
						"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
						"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
						"	and isnull(mes_ccod,1)=d.indice "& vbCrLf &_
						" 	and a.esol_ccod in (2) "& vbCrLf &_
						"	and area_ccod="&area_ccod&" and anio_ccod="&v_prox_anio		

						
			f_concepto.AgregaCampoParam "ccen_ccod", "filtro", "tpre_ccod in (3)"
			
		case 4:
			sql_solicitud="select *,sede_tdesc as sede, nombremes, case a.esol_ccod when 1 then 'Anular' when 3 then 'Dejar Pendiente' when 4 then 'Ver motivo' else 'Estado Final' end as accion "& vbCrLf &_
						" from presupuesto_upa.protic.centralizar_solicitud_servicios_generales a, presupuesto_upa.protic.concepto_centralizado b,presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d, presupuesto_upa.protic.sedes e "& vbCrLf &_ 
						"	where a.tpre_ccod in (4) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
						"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
						"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
						"	and isnull(mes_ccod,1)=d.indice "& vbCrLf &_
						"   and isnull(a.sede_ccod,1)=e.sede_ccod "& vbCrLf &_
						" 	and a.esol_ccod not in (2,3) "& vbCrLf &_
						"	and area_ccod="&area_ccod&" and anio_ccod="&v_prox_anio

			sql_aprobadas="select *,sede_tdesc as sede "& vbCrLf &_
						" from presupuesto_upa.protic.centralizar_solicitud_servicios_generales a, presupuesto_upa.protic.concepto_centralizado b,presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d, presupuesto_upa.protic.sedes e "& vbCrLf &_
						"	where a.tpre_ccod in (4) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
						"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
						"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
						"	and isnull(mes_ccod,1)=d.indice "& vbCrLf &_
						"   and isnull(a.sede_ccod,1)=e.sede_ccod "& vbCrLf &_
						" 	and a.esol_ccod in (2) "& vbCrLf &_
						"	and area_ccod="&area_ccod&" and anio_ccod="&v_prox_anio		
						
			f_concepto.AgregaCampoParam "ccen_ccod", "filtro", "tpre_ccod in (4)"
			
		case 5:
			sql_solicitud="select *,nombremes, case a.esol_ccod when 1 then 'Anular' when 3 then 'Dejar Pendiente' when 4 then 'Ver motivo' else 'Estado Final' end as accion "& vbCrLf &_
						" from presupuesto_upa.protic.centralizar_solicitud_personal a, presupuesto_upa.protic.concepto_centralizado b,presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d  "& vbCrLf &_
						"	where a.tpre_ccod in (5) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
						"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
						"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
						"	and isnull(mes_ccod,1)=d.indice "& vbCrLf &_
						" 	and a.esol_ccod not in (2,3) "& vbCrLf &_
						"	and area_ccod="&area_ccod&" and anio_ccod="&v_prox_anio

			sql_aprobadas="select * "& vbCrLf &_
						" from presupuesto_upa.protic.centralizar_solicitud_personal a, presupuesto_upa.protic.concepto_centralizado b,presupuesto_upa.protic.estado_solicitud c,softland.sw_mesce d "& vbCrLf &_
						"	where a.tpre_ccod in (5) and a.tpre_ccod=b.tpre_ccod "& vbCrLf &_
						"	and a.ccen_ccod=b.ccen_ccod "& vbCrLf &_
						"	and a.esol_ccod=c.esol_ccod "& vbCrLf &_
						"	and isnull(mes_ccod,1)=d.indice "& vbCrLf &_
						" 	and a.esol_ccod in (2) "& vbCrLf &_
						" 	and a.esol_ccod not in (2) "& vbCrLf &_
						"	and area_ccod="&area_ccod&" and anio_ccod="&v_prox_anio		

						
			f_concepto.AgregaCampoParam "ccen_ccod", "filtro", "tpre_ccod in (5)"
	end select	

	'response.Write("<pre>"&sql_solicitud&"</pre>")

	f_solicitado.consultar sql_solicitud
	f_aprobados.consultar sql_aprobadas

else
	 f_solicitado.consultar "select '' where 1 = 2"
	 f_solicitado.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
	 
	 f_aprobados.consultar "select '' where 1 = 2"
	 f_aprobados.AgregaParam "mensajeError", "Ingrese criterio de busqueda"


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
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>

<script language="JavaScript">
function Validar(){
	return true;
}

function GrabarSolicitud()
{

	formulario=document.forms['solicitud'];
	v_concepto		=	document.solicitud.elements['busqueda[0][ccen_ccod]'].value;
	v_descripcion	=	formulario.descripcion.value;
	v_cantidad		=	formulario.cantidad.value;

	if(v_concepto==""){
		alert("No ha seleccionado un concepto presupuestario v�lido");
		return false;
	}

	if((v_descripcion!="")&&(v_cantidad!="")){	
		
		formulario.action = "proc_agrega_solicitud_centralizada.asp";
		formulario.method = "post";
		formulario.submit(); 
	}else{
		alert("Debe ingresar una descripcion y una cantidad valida para su solicitud");
		return false;
	}
}

function CambiaEstado(num,v_estado,codigo){
	area='<%=area_ccod%>';
	if(v_estado==2){
		alert("Esta solicitud ya fue activada, por lo tanto no es posible anularla");
	}else{
	
		if(v_estado==4){
			window.open("ver_motivo_rechazo.asp?nro="+num+"&cod="+codigo,"ventana1","width=300,height=180,scrollbars=no, left=380, top=350")
		}else{
			// solo estados pendientes y anulada
			if(v_estado==1){
				txt_estado="Anular";
			}else{
				txt_estado="desea dejar Pendiente";
			}
			
			if(confirm("Esta seguro que "+txt_estado+" la solicitud seleccionada")){
				location.href="proc_cambia_estado_solicitud.asp?nro="+num+"&etd="+v_estado+"&cod="+codigo+"&area="+area;
			}		
		}	
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
                      <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador
                      </font></div></td>
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
                <td bgcolor="#D8D8DE"><div align="center">
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
                </div></td>
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
                    <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="170" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Ingreso Solicitud Centralizada</font></div>
                    </td>
                    <td width="485" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
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
                              <%pagina.DibujarLenguetasFClaro Array(array("Audiovisual","ingreso_presupuesto_centralizado.asp?area_ccod="&area_ccod&"&nro_t=1"),array("Biblioteca","ingreso_presupuesto_centralizado.asp?area_ccod="&area_ccod&"&nro_t=2"),array("Computacion","ingreso_presupuesto_centralizado.asp?area_ccod="&area_ccod&"&nro_t=3"),array("Servicios Generales","ingreso_presupuesto_centralizado.asp?area_ccod="&area_ccod&"&nro_t=4"),array("Recursos Humanos","ingreso_presupuesto_centralizado.asp?area_ccod="&area_ccod&"&nro_t=5")), nro_t %>
                            </td>
                          </tr>
                          <tr> 
                            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
                          </tr>
                          <tr> 
                            <td><br/>
							<% 
							select case (nro_t)
							case 1:
							%>
								<font>Anexo N�5.1: Requerimientos Audiovisuales</font>
								<br/>
								
								<form name="solicitud">
								<input type="hidden" name="area_ccod" value="<%=area_ccod%>">
								<input type="hidden" name="tipo" value="1">
								
								<table border="1" width="%" bordercolorlight="#CCCCCC" bordercolordark="#CCCCCC">
									<tr>
										<td colspan="3" align="center"><strong>Solicitar</strong></td>
									</tr>
									<tr>
										<td><strong>Concepto</strong></td><td>:</td><td><%=f_concepto.DibujaCampo("ccen_ccod")%></td>
									</tr>
									<tr>
										<td><strong>Descripcion</strong></td><td>:</td><td>
										<textarea name="descripcion" cols="40" rows="5"></textarea>
										<!--<input type="text" name="descripcion" size="50">-->										
										</td>
									</tr>
									<tr>
										<td><strong>Cantidad</strong></td><td>:</td><td><input type="text" name="cantidad" size="4"></td>
									</tr>
									<tr>
										<td><strong>Mes</strong></td><td>:</td><td>
										<select name="mes">
											<option value="1">ENERO</option>
											<option value="2">FEBRERO</option>
											<option value="3">MARZO</option>
											<option value="4">ABRIL</option>
											<option value="5">MAYO</option>
											<option value="6">JUNIO</option>
											<option value="7">JULIO</option>
											<option value="8">AGOSTO</option>
											<option value="9">SEPTIEMBRE</option>
											<option value="10">OCTUBRE</option>
											<option value="11">NOVIEMBRE</option>
											<option value="12">DICIEMBRE</option>
										</select></td>
									</tr>										
									<tr>
										<td colspan="3" align="center"><% botonera.DibujaBoton("agrega_concepto") %></td>
									</tr>										
								</table>
								</form>
								<br/>
								<font>Pendientes</font>
								<br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripcion</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="18%">Estado</th>
									  <th width="18%">Accion</th>
									</tr>
									<%
									while f_solicitado.Siguiente
									%>
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><%f_solicitado.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_solicitado.DibujaCampo("ccau_tdesc")%></td>
									  <td><%=f_solicitado.DibujaCampo("nombremes")%></td>
									  <td><%=f_solicitado.DibujaCampo("ccau_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("esol_tdesc")%></td>
									  <td><a href="javascript:CambiaEstado(1,<%f_solicitado.DibujaCampo("esol_ccod")%>,<%f_solicitado.DibujaCampo("ccau_ncorr")%>);"><%f_solicitado.DibujaCampo("accion")%></a></td>
									</tr>
									 <%
									 wend%>
									 <%if f_solicitado.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="6" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
									 <% end if%>
								</table>
								<br/>
								<font>Aceptadas</font>
								<br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripcion</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="18%">Estado</th>
									</tr>
									<%
									while f_aprobados.Siguiente
									%>
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><%f_aprobados.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_aprobados.DibujaCampo("ccau_tdesc")%></td>
									  <td><%=f_aprobados.DibujaCampo("nombremes")%></td>
									  <td><%=f_aprobados.DibujaCampo("ccau_ncantidad")%></td>
									  <td><%=f_aprobados.DibujaCampo("esol_tdesc")%></td>
									</tr>
									 <%wend%>
									 <%if f_aprobados.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="5" align="center">No se encontraron solicitudes aprobadas </td></tr>
									 <% end if%>
								</table>
								
							<%case 2:%>
								<font>Anexo N�4: Material Bibliogr�fico</font>
								<br/>
								<form name="solicitud">
								<input type="hidden" name="area_ccod" value="<%=area_ccod%>">
								<input type="hidden" name="tipo" value="2">
								<table border="1" width="%" bordercolorlight="#CCCCCC" bordercolordark="#CCCCCC">
									<tr>
										<td colspan="3" align="center"><strong>Solicitar</strong></td>
									</tr>
									<tr>
										<td><strong>Concepto</strong></td><td>:</td><td><%=f_concepto.DibujaCampo("ccen_ccod")%></td>
									</tr>
									<tr>
										<td><strong>Descripcion</strong></td><td>:</td><td>
										<textarea name="descripcion" cols="40" rows="5"></textarea>
										<!--<input type="text" name="descripcion" size="50">-->
										</td>
									</tr>
									<tr>
										<td><strong>Cantidad</strong></td><td>:</td><td><input type="text" name="cantidad" size="4"></td>
									</tr>
									<tr>
										<td><strong>Mes</strong></td><td>:</td><td>
										<select name="mes">
											<option value="1">ENERO</option>
											<option value="2">FEBRERO</option>
											<option value="3">MARZO</option>
											<option value="4">ABRIL</option>
											<option value="5">MAYO</option>
											<option value="6">JUNIO</option>
											<option value="7">JULIO</option>
											<option value="8">AGOSTO</option>
											<option value="9">SEPTIEMBRE</option>
											<option value="10">OCTUBRE</option>
											<option value="11">NOVIEMBRE</option>
											<option value="12">DICIEMBRE</option>
										</select></td>
									</tr>
									<tr>
										<td colspan="3" align="center"><% botonera.DibujaBoton("agrega_concepto") %></td>
									</tr>																			
								</table>
								</form>
								<br/>
								<font>Pendientes</font>
								<br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripcion</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="18%">Estado</th>
									  <th width="18%">Accion</th>
									</tr>
									<%
									while f_solicitado.Siguiente
									%>
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><%f_solicitado.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_solicitado.DibujaCampo("ccbi_tdesc")%></td>
									  <td><%=f_solicitado.DibujaCampo("nombremes")%></td>
									  <td><%=f_solicitado.DibujaCampo("ccbi_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("esol_tdesc")%></td>
									  <td><a href="javascript:CambiaEstado(2,<%f_solicitado.DibujaCampo("esol_ccod")%>,<%f_solicitado.DibujaCampo("ccbi_ncorr")%>);"><%f_solicitado.DibujaCampo("accion")%></a></td>
									</tr>
									 <%wend%>
									 <%if f_solicitado.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="6" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
									 <% end if%>
								</table>
								<br/>
								<font>Aceptadas</font>
								<br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripcion</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="18%">Estado</th>
									</tr>
									<%
									while f_aprobados.Siguiente
									%>
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><%f_aprobados.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_aprobados.DibujaCampo("ccbi_tdesc")%></td>
									  <td><%=f_aprobados.DibujaCampo("nombremes")%></td>
									  <td><%=f_aprobados.DibujaCampo("ccbi_ncantidad")%></td>
									  <td><%=f_aprobados.DibujaCampo("esol_tdesc")%></td>
									</tr>
									 <%wend%>
									 <%if f_aprobados.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="5" align="center">No se encontraron solicitudes aprobadas </td></tr>
									 <% end if%>
								</table>
																
							<%case 3:%>
								<font>Anexo N�5: Requerimientos Computacionales</font>
								<br/>
								<form name="solicitud">
								<input type="hidden" name="area_ccod" value="<%=area_ccod%>">
								<input type="hidden" name="tipo" value="3">
								<table border="1" width="%" bordercolorlight="#CCCCCC" bordercolordark="#CCCCCC">
									<tr>
										<td colspan="4" align="center"><strong>Solicitar</strong></td>
									</tr>
									<tr>
										<td><strong>Concepto</strong></td><td>:</td><td><%=f_concepto.DibujaCampo("ccen_ccod")%></td>
									</tr>
									<tr>
										<td><strong>Descripcion</strong></td><td>:</td><td>
										<textarea name="descripcion" cols="40" rows="5"></textarea>
										<!--<input type="text" name="descripcion" size="50">-->											
										</td>
									</tr>
									<tr>
										<td><strong>Cantidad</strong></td><td>:</td><td><input type="text" name="cantidad" size="4"></td>
									</tr>
									<tr>
										<td><strong>Mes</strong></td><td>:</td><td>
										<select name="mes">
											<option value="1">ENERO</option>
											<option value="2">FEBRERO</option>
											<option value="3">MARZO</option>
											<option value="4">ABRIL</option>
											<option value="5">MAYO</option>
											<option value="6">JUNIO</option>
											<option value="7">JULIO</option>
											<option value="8">AGOSTO</option>
											<option value="9">SEPTIEMBRE</option>
											<option value="10">OCTUBRE</option>
											<option value="11">NOVIEMBRE</option>
											<option value="12">DICIEMBRE</option>
										</select></td>
									</tr>									
									<tr>
										<td colspan="3" align="center"><% botonera.DibujaBoton("agrega_concepto") %></td>
									</tr>																			
								</table>
								</form>
								<br/>
								<font>Pendientes</font>
								<br/>								
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripcion</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="18%">Estado</th>
									  <th width="18%">Accion</th>
									</tr>
									<%
									while f_solicitado.Siguiente
									%>
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><%f_solicitado.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_solicitado.DibujaCampo("ccco_tdesc")%></td>
									  <td><%=f_solicitado.DibujaCampo("nombremes")%></td>
									  <td><%=f_solicitado.DibujaCampo("ccco_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("esol_tdesc")%></td>
									  <td><a href="javascript:CambiaEstado(3,<%f_solicitado.DibujaCampo("esol_ccod")%>,<%f_solicitado.DibujaCampo("ccco_ncorr")%>);"><%f_solicitado.DibujaCampo("accion")%></a></td>
									</tr>
									 <%wend%>
									 <%if f_solicitado.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="6" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
									 <% end if%>
								</table>								
								<br/>
								<font>Aceptadas</font>
								<br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripcion</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="18%">Estado</th>
									</tr>
									<%
									while f_aprobados.Siguiente
									%>
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><%f_aprobados.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_aprobados.DibujaCampo("ccco_tdesc")%></td>
									  <td><%=f_aprobados.DibujaCampo("nombremes")%></td>
									  <td><%=f_aprobados.DibujaCampo("ccco_ncantidad")%></td>
									  <td><%=f_aprobados.DibujaCampo("esol_tdesc")%></td>
									</tr>
									 <%wend%>
									 <%if f_aprobados.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="5" align="center">No se encontraron solicitudes aprobadas </td></tr>
									 <% end if%>
								</table>
																
							<%case 4:%>
								<font>Anexo N�6: Requerimientos Reparaciones, Equipos Mobiliarios</font>
								<br/>
								<form name="solicitud">
								<input type="hidden" name="area_ccod" value="<%=area_ccod%>">
								<input type="hidden" name="tipo" value="4">
								<table border="1" width="%" bordercolorlight="#CCCCCC" bordercolordark="#CCCCCC">
									<tr>
										<td colspan="3" align="center"><strong>Solicitar</strong></td>
									</tr>
									<tr>
										<td><strong>Concepto</strong></td><td>:</td><td><%=f_concepto.DibujaCampo("ccen_ccod")%></td>
									</tr>
									<tr>
										<td><strong>Descripcion</strong></td><td>:</td><td>
										<textarea name="descripcion" cols="40" rows="5"></textarea>
										<!--<input type="text" name="descripcion" size="50">-->											
										</td>
									</tr>
									<tr>
										<td><strong>Cantidad</strong></td><td>:</td><td><input type="text" name="cantidad" size="4"></td>
									</tr>
									<tr>
										<td><strong>Mes</strong></td><td>:</td><td>
										<select name="mes">
											<option value="1">ENERO</option>
											<option value="2">FEBRERO</option>
											<option value="3">MARZO</option>
											<option value="4">ABRIL</option>
											<option value="5">MAYO</option>
											<option value="6">JUNIO</option>
											<option value="7">JULIO</option>
											<option value="8">AGOSTO</option>
											<option value="9">SEPTIEMBRE</option>
											<option value="10">OCTUBRE</option>
											<option value="11">NOVIEMBRE</option>
											<option value="12">DICIEMBRE</option>
										</select></td>
									</tr>
									<tr>
										<td><strong>Sede Asociada</strong></td><td>:</td><td>
										<select name="sede_ccod">
											<option value="1">LAS CONDES</option>
											<option value="2">LYON</option>
											<option value="4">MELIPILLA</option>
											<option value="8">BAQUEDANO</option>
										</select></td>
									</tr>													
									<tr>
										<td colspan="3" align="center"><% botonera.DibujaBoton("agrega_concepto") %></td>
									</tr>																			
								</table>
								</form>
								<br/>
								<font>Pendientes</font>
								<br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripcion</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Sede</th>
									  <th width="9%">Cantidad</th>
									  <th width="18%">Estado</th>
									  <th width="18%">Accion</th>
									</tr>
									<%
									while f_solicitado.Siguiente
									%>
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><%f_solicitado.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_solicitado.DibujaCampo("ccsg_tdesc")%></td>
									  <td><%=f_solicitado.DibujaCampo("nombremes")%></td>
									  <td><%=f_solicitado.DibujaCampo("sede")%></td>
									  <td><%=f_solicitado.DibujaCampo("ccsg_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("esol_tdesc")%></td>
									  <td><a href="javascript:CambiaEstado(4,<%f_solicitado.DibujaCampo("esol_ccod")%>,<%f_solicitado.DibujaCampo("ccsg_ncorr")%>);"><%f_solicitado.DibujaCampo("accion")%></a></td>
									</tr>
									 <%wend%>
									 <%if f_solicitado.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="7" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
									 <% end if%>
								</table>
								<br/>
								<font>Aceptadas</font>
								<br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripcion</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Sede</th>
									  <th width="9%">Cantidad</th>
									  <th width="18%">Estado</th>
									</tr>
									<%
									while f_aprobados.Siguiente
									%>
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><%f_aprobados.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_aprobados.DibujaCampo("ccsg_tdesc")%></td>
									  <td><%=f_aprobados.DibujaCampo("nombremes")%></td>
									   <td><%=f_aprobados.DibujaCampo("sede")%></td>
									  <td><%=f_aprobados.DibujaCampo("ccsg_ncantidad")%></td>
									  <td><%=f_aprobados.DibujaCampo("esol_tdesc")%></td>
									</tr>
									 <%wend%>
									 <%if f_aprobados.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="6" align="center">No se encontraron solicitudes aprobadas </td></tr>
									 <% end if%>
								</table>																
							<%case 5:%>
								<font>Anexo N�: Requerimientos de Personal</font>
								<br/>
								<form name="solicitud">
								<input type="hidden" name="area_ccod" value="<%=area_ccod%>">
								<input type="hidden" name="tipo" value="5">
								<table border="1" width="%" bordercolorlight="#CCCCCC" bordercolordark="#CCCCCC">
									<tr>
										<td colspan="3" align="center"><strong>Solicitar</strong></td>
									</tr>
									<tr>
										<td><strong>Concepto</strong></td><td>:</td><td><%=f_concepto.DibujaCampo("ccen_ccod")%></td>
									</tr>
									<tr>
										<td><strong>Descripcion</strong></td><td>:</td><td>
										<textarea name="descripcion" cols="40" rows="5"></textarea>
										<!--<input type="text" name="descripcion" size="50">-->											
										</td>
									</tr>
									<tr>
										<td><strong>Cantidad</strong></td><td>:</td><td><input type="text" name="cantidad" size="4"></td>
									</tr>
									<tr>
										<td><strong>Mes</strong></td><td>:</td><td>
										<select name="mes">
											<option value="1">ENERO</option>
											<option value="2">FEBRERO</option>
											<option value="3">MARZO</option>
											<option value="4">ABRIL</option>
											<option value="5">MAYO</option>
											<option value="6">JUNIO</option>
											<option value="7">JULIO</option>
											<option value="8">AGOSTO</option>
											<option value="9">SEPTIEMBRE</option>
											<option value="10">OCTUBRE</option>
											<option value="11">NOVIEMBRE</option>
											<option value="12">DICIEMBRE</option>
										</select></td>
									</tr>									
									<tr>
										<td colspan="3" align="center"><% botonera.DibujaBoton("agrega_concepto") %></td>
									</tr>																			
								</table>
								</form>
								<br/>
								<font>Pendientes</font>
								<br/>								
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripcion</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="18%">Estado</th>
									  <th width="18%">Accion</th>									  
									</tr>
									<%
									while f_solicitado.Siguiente
									%>
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><%f_solicitado.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_solicitado.DibujaCampo("ccpe_tdesc")%></td>
									  <td><%=f_solicitado.DibujaCampo("nombremes")%></td>
									  <td><%=f_solicitado.DibujaCampo("ccpe_ncantidad")%></td>
									  <td><%=f_solicitado.DibujaCampo("esol_tdesc")%></td>
									  <td><a href="javascript:CambiaEstado(5,<%f_solicitado.DibujaCampo("esol_ccod")%>,<%f_solicitado.DibujaCampo("ccpe_ncorr")%>);"><%f_solicitado.DibujaCampo("accion")%></a></td>
									</tr>
									 <%wend%>
									 <%if f_solicitado.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="6" align="center">No se encontraron solicitudes para el area seleccionada </td></tr>
									 <% end if%>
								</table>
								<br/>
								<font>Aceptadas</font>
								<br/>
								<table width="95%" border="1" align="center"  >
									<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
									  <th width="22%">Concepto</th>
									  <th width="51%">Descripcion</th>
									  <th width="9%">Para mes</th>
									  <th width="9%">Cantidad</th>
									  <th width="18%">Estado</th>
									</tr>
									<%
									while f_aprobados.Siguiente
									%>
									<tr bordercolor='#999999'>	
									  <td><font color="#0033FF"><%f_aprobados.DibujaCampo("ccen_tdesc")%></a></font></td>
									  <td><%=f_aprobados.DibujaCampo("ccpe_tdesc")%></td>
									  <td><%=f_aprobados.DibujaCampo("nombremes")%></td>
									  <td><%=f_aprobados.DibujaCampo("ccpe_ncantidad")%></td>
									  <td><%=f_aprobados.DibujaCampo("esol_tdesc")%></td>
									</tr>
									 <%wend%>
									 <%if f_aprobados.nrofilas <=0 then%>
									 	<tr bordercolor='#999999'>	<td colspan="5" align="center">No se encontraron solicitudes aprobadas </td></tr>
									 <% end if%>
								</table>																										
							<% end select %>
							<br/>
							<br/>
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
	
												<td width="100%">
													<%
													botonera.agregabotonparam "excel_solicitud_central", "url", "solicitud_central_excel.asp?nro="&nro_t&"&area="&area_ccod&"&anio="&v_prox_anio
													botonera.DibujaBoton ("excel_solicitud_central")
													%>
												</td>

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
                <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                <td width="100" bgcolor="#D8D8DE"><table width="100%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td ><% botonera.DibujaBoton ("lanzadera") %> </td>
                    </tr>
                  </table>
                </td>
                <td width="262" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
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