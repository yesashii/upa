<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 2000 
set pagina = new CPagina
pagina.Titulo = "Formulacion Presupuestaria"
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
botonera.Carga_Parametros "formulacion_presupuesto.xml", "botonera"
'-----------------------------------------------------------------------
 
nro_t		= request.querystring("nro_t")
concepto 	= request.querystring("busqueda[0][concepto]")
v_area 		= request.querystring("busqueda[0][cod_area]")
detalle_concepto 	= request.querystring("concepto")


 v_anio_actual	= conexion2.ConsultaUno("select year(getdate())")
 'v_prox_anio	=	v_anio_actual+1
 v_prox_anio	=	v_anio_actual
 

if concepto<>"" then
	sql_concepto= "and concepto like '"&concepto&"' "
end if

if v_area<>"" then
	sql_area= " and cod_area = "&v_area&" "
end if

'----------------------------------------------------------------------------
set f_presupuestado = new CFormulario
f_presupuestado.Carga_Parametros "formulacion_presupuesto.xml", "f_presupuesto"
f_presupuestado.Inicializar conexion2

	  
	if nro_t="" then
	  	nro_t=1
	end if

	select case (nro_t)
		
		case 1:
	
			sql_presupuestado	= " select area_tdesc as area,sum(isnull(total,0)) as total,   "& vbCrLf &_
								  "  sum(isnull(enero,0)) as enero, sum(isnull(febrero,0)) as febrero, sum(isnull(marzo,0)) as marzo, sum(isnull(abril,0)) as abril, "& vbCrLf &_  
								  "  sum(isnull(mayo,0)) as mayo, sum(isnull(junio,0)) as junio, sum(isnull(julio,0)) as julio, sum(isnull(agosto,0)) as agosto,   "& vbCrLf &_
								  "  sum(isnull(septiembre,0)) as septiembre,sum(isnull(octubre,0)) as octubre, sum(isnull(noviembre,0)) as noviembre,   "& vbCrLf &_ 
								  "  sum(isnull(diciembre,0)) as diciembre, sum(isnull(enero_prox,0)) as enero_prox,sum(isnull(febrero_prox,0)) as febrero_prox "& vbCrLf &_
								  "	FROM presupuesto_upa.protic.solicitud_presupuesto_upa  a, presupuesto_upa.protic.area_presupuestal b "& vbCrLf &_
								  "	where a.cod_area=b.area_ccod "& vbCrLf &_
								  " and cod_anio="&v_prox_anio&" "& vbCrLf &_
								  " "&sql_concepto&" "& vbCrLf &_
								  "	group by area_tdesc order by  area_tdesc desc"

		
				 set f_busqueda = new CFormulario
				 f_busqueda.Carga_Parametros "formulacion_presupuesto.xml", "busqueda_formulacion"
				 f_busqueda.Inicializar conexion2
				 f_busqueda.Consultar "select ''"
				 f_busqueda.Siguiente
				
				 f_busqueda.AgregaCampoParam "concepto", "destino",  " (select distinct concepto_pre, concepto_pre as valor from presupuesto_upa.protic.codigos_presupuesto) a "
				 f_busqueda.AgregaCampoCons "concepto", concepto
		
		case 2:
	

			sql_presupuestado	= " SELECT concepto, sum(isnull(total,0)) as total,  "& vbCrLf &_ 
								  " sum(isnull(enero,0)) as enero, sum(isnull(febrero,0)) as febrero, sum(isnull(marzo,0)) as marzo, sum(isnull(abril,0)) as abril,"& vbCrLf &_   
								  " sum(isnull(mayo,0)) as mayo, sum(isnull(junio,0)) as junio, sum(isnull(julio,0)) as julio, sum(isnull(agosto,0)) as agosto, "& vbCrLf &_  
								  " sum(isnull(septiembre,0)) as septiembre,sum(isnull(octubre,0)) as octubre, sum(isnull(noviembre,0)) as noviembre, "& vbCrLf &_   
								  " sum(isnull(diciembre,0)) as diciembre, sum(isnull(enero_prox,0)) as enero_prox,sum(isnull(febrero_prox,0)) as febrero_prox  "& vbCrLf &_ 
								  " FROM presupuesto_upa.protic.solicitud_presupuesto_upa  "& vbCrLf &_ 
								  " where 1=1 "& vbCrLf &_
								  " and cod_anio="&v_prox_anio&" "& vbCrLf &_
								  " "&sql_area&" "& vbCrLf &_
								  " group by concepto  "
		
		'response.Write("<pre>"&sql_presupuestado&"</pre>")
		
				 set f_busqueda = new CFormulario
				 f_busqueda.Carga_Parametros "formulacion_presupuesto.xml", "busqueda_formulacion"
				 f_busqueda.Inicializar conexion2
				 f_busqueda.Consultar "select ''"
				 f_busqueda.Siguiente
				
				 f_busqueda.AgregaCampoParam "cod_area", "destino",  "(select distinct cod_area, area_tdesc as valor from presupuesto_upa.protic.codigos_presupuesto a, presupuesto_upa.protic.area_presupuestal b where cod_area=area_ccod) a "
				 f_busqueda.AgregaCampoCons "cod_area", v_area
				 f_busqueda.AgregaCampoParam "cod_area","orden", "valor asc"


				if detalle_concepto<>"" then
					 set f_detalle = new CFormulario
					 f_detalle.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
					 f_detalle.Inicializar conexion2
				
									  
					sql_detalle_concepto= "	 SELECT spru_ncorr,cod_pre,area_tdesc as area,concepto,detalle, isnull(total,0) as total,  "& vbCrLf &_
										  " case isnull(leasing,0) when 1 then '<font color=Red>SI</font>' else 'NO' end as  usa_leasing, "& vbCrLf &_
										  " isnull(enero,0) as enero,  isnull(febrero,0) as febrero,  isnull(marzo,0) as marzo,  isnull(abril,0) as abril,"& vbCrLf &_
										  " isnull(mayo,0) as mayo,  isnull(junio,0) as junio,  isnull(julio,0) as julio,  isnull(agosto,0) as agosto,"& vbCrLf &_ 
										  " isnull(septiembre,0) as septiembre, isnull(octubre,0) as octubre,  isnull(noviembre,0) as noviembre, "& vbCrLf &_
										  " isnull(diciembre,0) as diciembre,  isnull(enero_prox,0) as enero_prox, isnull(febrero_prox,0) as febrero_prox  "& vbCrLf &_
										  " FROM presupuesto_upa.protic.solicitud_presupuesto_upa a, presupuesto_upa.protic.area_presupuestal b  "& vbCrLf &_
										  " where cod_area=area_ccod "& vbCrLf &_
										  " and cod_anio="&v_prox_anio&" "& vbCrLf &_
										  " "&sql_area&" "& vbCrLf &_
										  " and concepto='"&detalle_concepto&"' "
									  
									  										  
					'response.Write("<pre>"&sql_detalle_concepto&"</pre>")					  
					 f_detalle.Consultar sql_detalle_concepto
					  
				end if
		
		case 3:
	

			sql_presupuestado	= " SELECT concepto, b.area_tdesc as area, detalle, sum(isnull(total,0)) as total, "& vbCrLf &_ 
								  " sum(isnull(enero,0)) as enero, sum(isnull(febrero,0)) as febrero, sum(isnull(marzo,0)) as marzo, sum(isnull(abril,0)) as abril,"& vbCrLf &_   
								  " sum(isnull(mayo,0)) as mayo, sum(isnull(junio,0)) as junio, sum(isnull(julio,0)) as julio, sum(isnull(agosto,0)) as agosto, "& vbCrLf &_  
								  " sum(isnull(septiembre,0)) as septiembre,sum(isnull(octubre,0)) as octubre, sum(isnull(noviembre,0)) as noviembre, "& vbCrLf &_   
								  " sum(isnull(diciembre,0)) as diciembre, sum(isnull(enero_prox,0)) as enero_prox,sum(isnull(febrero_prox,0)) as febrero_prox  "& vbCrLf &_ 
								  " FROM presupuesto_upa.protic.solicitud_presupuesto_upa a, presupuesto_upa.protic.area_presupuestal b  "& vbCrLf &_ 
								  " where isnull(leasing,0)=1 "& vbCrLf &_
								  " and cod_area=area_ccod "& vbCrLf &_
								  " and cod_anio="&v_prox_anio&" "& vbCrLf &_
								  " group by concepto, area_tdesc,detalle  "

		case 4:
	

			sql_presupuestado	= " SELECT concepto, sum(isnull(total,0)) as total,  "& vbCrLf &_ 
								  " sum(isnull(enero,0)) as enero, sum(isnull(febrero,0)) as febrero, sum(isnull(marzo,0)) as marzo, sum(isnull(abril,0)) as abril,"& vbCrLf &_   
								  " sum(isnull(mayo,0)) as mayo, sum(isnull(junio,0)) as junio, sum(isnull(julio,0)) as julio, sum(isnull(agosto,0)) as agosto, "& vbCrLf &_  
								  " sum(isnull(septiembre,0)) as septiembre,sum(isnull(octubre,0)) as octubre, sum(isnull(noviembre,0)) as noviembre, "& vbCrLf &_   
								  " sum(isnull(diciembre,0)) as diciembre, sum(isnull(enero_prox,0)) as enero_prox,sum(isnull(febrero_prox,0)) as febrero_prox  "& vbCrLf &_ 
								  " FROM presupuesto_upa.protic.solicitud_presupuesto_upa  "& vbCrLf &_ 
								  " where 1=1 "& vbCrLf &_
								  " and cod_anio="&v_prox_anio&" "& vbCrLf &_
								  " "&sql_area&" "& vbCrLf &_
								  " group by concepto  "
		
				 set f_busqueda = new CFormulario
				 f_busqueda.Carga_Parametros "formulacion_presupuesto.xml", "busqueda_formulacion"
				 f_busqueda.Inicializar conexion2
				 f_busqueda.Consultar "select ''"
				 f_busqueda.Siguiente
				
				 f_busqueda.AgregaCampoParam "cod_area", "destino",  "(select distinct cod_area, area_tdesc as valor from presupuesto_upa.protic.codigos_presupuesto a, presupuesto_upa.protic.area_presupuestal b where cod_area=area_ccod) a "
				 f_busqueda.AgregaCampoCons "cod_area", v_area
				 f_busqueda.AgregaCampoParam "cod_area","orden", "valor asc"

	end select	
	'response.Write("<pre>"&sql_presupuestado&"</pre>")
	'response.Flush()
	f_presupuestado.consultar sql_presupuestado
%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<STYLE TYPE="text/css" MEDIA="screen, print, projection">
<!--

   table.subtabla {
		font-style: italic;
		font-size : 8px !important;
		height:20px;

	}
	table tr.color {
		color:#003366;
	}
-->
</STYLE>

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function Validar(){
	return true;
}

function CargarConcepto(formulario)
{
	_Buscar(this, document.forms['presupuesto'],'', 'Validar();', 'FALSE');
}


function CargarArea(formulario)
{
	_Buscar(this, document.forms['presupuesto'],'', 'Validar();', 'FALSE');
}

function CargarDetalleConcepto(formulario, valor)
{
	document.presupuesto.concepto.value=valor;
	_Buscar(this, document.forms['presupuesto'],'', 'Validar();', 'FALSE');
}

function MarcarLeasing()
{
	formulario=document.forms['presupuesto'];
	formulario.action = "proc_marcar_leasing.asp";
	formulario.method = "post";
	formulario.submit(); 

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
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="100%" height="62" border="0"></td>
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
                    <td width="300" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Formulacion Presupuestaria Consolidada</font>  </div>
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
                              <%pagina.DibujarLenguetasFClaro Array(array("Por Area","formulacion_presupuesto_consolidado.asp?nro_t=1"),array("Por Concepto","formulacion_presupuesto_consolidado.asp?nro_t=2"),array("Leasing","formulacion_presupuesto_consolidado.asp?nro_t=3"),array("Revision","formulacion_presupuesto_consolidado.asp?nro_t=4")), nro_t %>
                            </td>
                          </tr>
                          <tr> 
                            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
                          </tr>
                          <tr> 
								<td> 
								<form name="presupuesto" method="get">
								<input type="hidden" name="nro_t" value="<%=nro_t%>">
								<input type="hidden" name="concepto" value="">
									<table border="0" width="100%">
					  
									<% 
									select case (nro_t)
									case 1:
									%>
									<tr><td>
									 
										<br/>
										<font color="#0000CC" size="2">FORMULACION PRESUPUESTARIA POR AREA </font> 
										<br/>
										<br/>
										<strong>Filtro búsqueda:</strong> <% f_busqueda.DibujaCampo("concepto") %>
										<br/>
										<br/>
										<table width="100%" border="1" align="center" >
												<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
												  <th width="40%" height="81">AREA</th>
												  <th width="25%">ENERO</th>
												  <th width="25%">FEBRERO</th>
												  <th width="25%">MARZO</th>
												  <th width="25%">ABRIL</th>
												  <th width="25%">MAYO</th>
												  <th width="25%">JUNIO</th>
												  <th width="25%">JULIO</th>
												  <th width="25%">AGOSTO</th>
												  <th width="25%">SEPTIEMBRE</th>
												  <th width="25%">OCTUBRE</th>
												  <th width="25%">NOVIEMBRE</th>
												  <th width="25%">DICIEMBRE</th>
												  <th width="25%">ENERO PROX</th>
												  <th width="25%">FEBRERO PROX</th>
												  <th width="25%">TOTAL</th>
												</tr>
											<%
											while f_presupuestado.Siguiente
												v_total		=	v_total		+	CDbl(f_presupuestado.ObtenerValor("total"))
												v_enero		=	v_enero		+	CDbl(f_presupuestado.ObtenerValor("enero"))
												v_febrero	=	v_febrero	+	CDbl(f_presupuestado.ObtenerValor("febrero"))
												v_marzo		=	v_marzo		+	CDbl(f_presupuestado.ObtenerValor("marzo"))
												v_abril		=	v_abril		+	CDbl(f_presupuestado.ObtenerValor("abril"))
												v_mayo		=	v_mayo		+	CDbl(f_presupuestado.ObtenerValor("mayo"))
												v_junio		=	v_junio		+	CDbl(f_presupuestado.ObtenerValor("junio"))
												v_julio		=	v_julio		+	CDbl(f_presupuestado.ObtenerValor("julio"))
												v_agosto	=	v_agosto	+	CDbl(f_presupuestado.ObtenerValor("agosto"))
												v_septiembre=	v_septiembre	+	CDbl(f_presupuestado.ObtenerValor("septiembre"))
												v_octubre	=	v_octubre		+	CDbl(f_presupuestado.ObtenerValor("octubre"))
												v_noviembre	=	v_noviembre		+	CDbl(f_presupuestado.ObtenerValor("noviembre"))
												v_diciembre	=	v_diciembre		+	CDbl(f_presupuestado.ObtenerValor("diciembre"))
												v_enero_prox	=v_enero_prox	+	CDbl(f_presupuestado.ObtenerValor("enero_prox"))
												v_febrero_prox	=v_febrero_prox	+	CDbl(f_presupuestado.ObtenerValor("febrero_prox"))
											%>
											<tr bordercolor='#999999'>	
												<td><%=f_presupuestado.ObtenerValor("area")%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("enero"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("febrero"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("marzo"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("abril"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("mayo"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("junio"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("julio"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("agosto"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("septiembre"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("octubre"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("noviembre"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("diciembre"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("enero_prox"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("febrero_prox"),0)%></td>
												<td><strong><%=formatcurrency(f_presupuestado.ObtenerValor("total"),0)%></strong></td>
											</tr>
											 <%wend%>
											<tr bordercolor='#999999'>
											<td ><b>Totales</b></td>
											<td align="right"><b><%=formatcurrency(v_enero,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_febrero,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_marzo,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_abril,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_mayo,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_junio,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_julio,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_agosto,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_septiembre,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_octubre,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_noviembre,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_diciembre,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_enero_prox,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_febrero_prox,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_total,0)%></b></td>
										 </tr>									 
										  </table>
								 <% case 2:%>
									 <tr><td>
									 
										<br/>
										<font color="#0000CC" size="2">FORMULACION PRESUPUESTARIA POR CONCEPTO </font> 
										<br/>
										<br/>	
										<strong>Filtro búsqueda:</strong> <% f_busqueda.DibujaCampo("cod_area") %>
										<br/>
										<br/>		
											<table width="100%" border="1" align="center" >
												<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
												  <th >CONCEPTO</th>
												  <th width="25%">ENERO</th>
												  <th width="25%">FEBRERO</th>
												  <th width="25%">MARZO</th>
												  <th width="25%">ABRIL</th>
												  <th width="25%">MAYO</th>
												  <th width="25%">JUNIO</th>
												  <th width="25%">JULIO</th>
												  <th width="25%">AGOSTO</th>
												  <th width="25%">SEPTIEMBRE</th>
												  <th width="25%">OCTUBRE</th>
												  <th width="25%">NOVIEMBRE</th>
												  <th width="25%">DICIEMBRE</th>
												  <th width="25%">ENERO PROX</th>
												  <th width="25%">FEBRERO PROX</th>
												  <th width="25%">TOTAL</th>
												</tr>
											<%
											while f_presupuestado.Siguiente
												v_total		=	v_total		+	CDbl(f_presupuestado.ObtenerValor("total"))
												v_enero		=	v_enero		+	CDbl(f_presupuestado.ObtenerValor("enero"))
												v_febrero	=	v_febrero	+	CDbl(f_presupuestado.ObtenerValor("febrero"))
												v_marzo		=	v_marzo		+	CDbl(f_presupuestado.ObtenerValor("marzo"))
												v_abril		=	v_abril		+	CDbl(f_presupuestado.ObtenerValor("abril"))
												v_mayo		=	v_mayo		+	CDbl(f_presupuestado.ObtenerValor("mayo"))
												v_junio		=	v_junio		+	CDbl(f_presupuestado.ObtenerValor("junio"))
												v_julio		=	v_julio		+	CDbl(f_presupuestado.ObtenerValor("julio"))
												v_agosto	=	v_agosto	+	CDbl(f_presupuestado.ObtenerValor("agosto"))
												v_septiembre=	v_septiembre	+	CDbl(f_presupuestado.ObtenerValor("septiembre"))
												v_octubre	=	v_octubre		+	CDbl(f_presupuestado.ObtenerValor("octubre"))
												v_noviembre	=	v_noviembre		+	CDbl(f_presupuestado.ObtenerValor("noviembre"))
												v_diciembre	=	v_diciembre		+	CDbl(f_presupuestado.ObtenerValor("diciembre"))
												v_enero_prox	=v_enero_prox	+	CDbl(f_presupuestado.ObtenerValor("enero_prox"))
												v_febrero_prox	=v_febrero_prox	+	CDbl(f_presupuestado.ObtenerValor("febrero_prox"))
											
											%>
											<tr bordercolor='#999999'>	
												<td><a href="javascript:CargarDetalleConcepto(this.form,'<%=f_presupuestado.ObtenerValor("concepto")%>')"><%=f_presupuestado.ObtenerValor("concepto")%></a></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("enero"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("febrero"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("marzo"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("abril"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("mayo"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("junio"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("julio"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("agosto"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("septiembre"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("octubre"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("noviembre"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("diciembre"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("enero_prox"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("febrero_prox"),0)%></td>
												<td><strong><%=formatcurrency(f_presupuestado.ObtenerValor("total"),0)%></strong></td>
											</tr>
											 <%
											 if f_presupuestado.ObtenerValor("concepto")=detalle_concepto and detalle_concepto<>"" then
											 	ind=0
											 %>
											 <tr>
											 <td colspan="16">
											 <div id="tablachica">
											 	<table border="0" class="subtabla" width="98%"  cellpadding="0" cellspacing="0" align="right" bordercolorlight="#000033">
													<tr  bordercolor='#CCCCCC'>
														<th width="1%"></th>
														<th width="1%">LEASING</th>
														<th width="15%">Area presupuesto </th>
														<th width="15%">Detalle</th>
														<th width="6%">Enero</th>
														<th width="6%">Febrero</th>
														<th width="6%">Marzo</th>
														<th width="6%">Abril</th>
														<th width="6%">Mayo</th>
														<th width="6%">Junio</th>
														<th width="6%">Julio</th>
														<th width="6%">Agosto</th>
														<th width="6%">Septiembre</th>
														<th width="6%">Octubre</th>
														<th width="6%">Noviembre</th>
														<th width="6%">Diciembre</th>
														<th width="6%">Enero prox.</th>
														<th width="6%">Febrero prox.</th>
														<th width="12%">Total</th>
														
													</tr>
													<% 
													while f_detalle.Siguiente 
													
													%>
													<tr class="color">
														<td>
														<input type="hidden" name="detalle[<%=ind%>][spru_ncorr]"  value="<%=f_detalle.ObtenerValor("spru_ncorr")%>">
														<input type="checkbox" name="detalle[<%=ind%>][agregar]" value="1">
														</td>
														<td><strong><%=f_detalle.ObtenerValor("usa_leasing")%></strong></td>
														<td><font color="#003366"><%=f_detalle.ObtenerValor("area")%></font></td>
														<td><%=f_detalle.ObtenerValor("detalle")%></td>
														<td><%=formatcurrency(f_detalle.ObtenerValor("enero"),0)%></td>
														<td><%=formatcurrency(f_detalle.ObtenerValor("febrero"),0)%></td>
														<td><%=formatcurrency(f_detalle.ObtenerValor("marzo"),0)%></td>
														<td><%=formatcurrency(f_detalle.ObtenerValor("abril"),0)%></td>
														<td><%=formatcurrency(f_detalle.ObtenerValor("mayo"),0)%></td>
														<td><%=formatcurrency(f_detalle.ObtenerValor("junio"),0)%></td>
														<td><%=formatcurrency(f_detalle.ObtenerValor("julio"),0)%></td>
														<td><%=formatcurrency(f_detalle.ObtenerValor("agosto"),0)%></td>
														<td><%=formatcurrency(f_detalle.ObtenerValor("septiembre"),0)%></td>
														<td><%=formatcurrency(f_detalle.ObtenerValor("octubre"),0)%></td>
														<td><%=formatcurrency(f_detalle.ObtenerValor("noviembre"),0)%></td>
														<td><%=formatcurrency(f_detalle.ObtenerValor("diciembre"),0)%></td>
														<td><%=formatcurrency(f_detalle.ObtenerValor("enero_prox"),0)%></td>
														<td><%=formatcurrency(f_detalle.ObtenerValor("febrero_prox"),0)%></td>
														<td><%=formatcurrency(f_detalle.ObtenerValor("total"),0)%></td>
														
													</tr>
													<% 
													ind=ind+1
													wend
													%>
												</table>
												</div>
												</td>
											</tr>
											<% end if
											 
											 wend%>
											<tr bordercolor='#999999'>
											<td ><b>Totales</b></td>
											<td align="right"><b><%=formatcurrency(v_enero,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_febrero,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_marzo,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_abril,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_mayo,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_junio,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_julio,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_agosto,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_septiembre,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_octubre,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_noviembre,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_diciembre,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_enero_prox,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_febrero_prox,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_total,0)%></b></td>
										 </tr>									 
										  </table>
 									<% case 3:%>
									 <tr><td>
									 
										<br/>
										<font color="#0000CC" size="2">PRESUPUESTO LEASING </font> 
										<br/>
										<br/>			
											<table width="100%" border="1" align="center" >
												<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
												  <th >AREA</th>
												  <th >CONCEPTO</th>
												  <th >DETALLE</th>
												  <th width="25%">ENERO</th>
												  <th width="25%">FEBRERO</th>
												  <th width="25%">MARZO</th>
												  <th width="25%">ABRIL</th>
												  <th width="25%">MAYO</th>
												  <th width="25%">JUNIO</th>
												  <th width="25%">JULIO</th>
												  <th width="25%">AGOSTO</th>
												  <th width="25%">SEPTIEMBRE</th>
												  <th width="25%">OCTUBRE</th>
												  <th width="25%">NOVIEMBRE</th>
												  <th width="25%">DICIEMBRE</th>
												  <th width="25%">ENERO PROX</th>
												  <th width="25%">FEBRERO PROX</th>
												  <th width="25%">TOTAL</th>
												</tr>
											<%
											while f_presupuestado.Siguiente
												v_total		=	v_total		+	CDbl(f_presupuestado.ObtenerValor("total"))
												v_enero		=	v_enero		+	CDbl(f_presupuestado.ObtenerValor("enero"))
												v_febrero	=	v_febrero	+	CDbl(f_presupuestado.ObtenerValor("febrero"))
												v_marzo		=	v_marzo		+	CDbl(f_presupuestado.ObtenerValor("marzo"))
												v_abril		=	v_abril		+	CDbl(f_presupuestado.ObtenerValor("abril"))
												v_mayo		=	v_mayo		+	CDbl(f_presupuestado.ObtenerValor("mayo"))
												v_junio		=	v_junio		+	CDbl(f_presupuestado.ObtenerValor("junio"))
												v_julio		=	v_julio		+	CDbl(f_presupuestado.ObtenerValor("julio"))
												v_agosto	=	v_agosto	+	CDbl(f_presupuestado.ObtenerValor("agosto"))
												v_septiembre=	v_septiembre	+	CDbl(f_presupuestado.ObtenerValor("septiembre"))
												v_octubre	=	v_octubre		+	CDbl(f_presupuestado.ObtenerValor("octubre"))
												v_noviembre	=	v_noviembre		+	CDbl(f_presupuestado.ObtenerValor("noviembre"))
												v_diciembre	=	v_diciembre		+	CDbl(f_presupuestado.ObtenerValor("diciembre"))
												v_enero_prox	=v_enero_prox	+	CDbl(f_presupuestado.ObtenerValor("enero_prox"))
												v_febrero_prox	=v_febrero_prox	+	CDbl(f_presupuestado.ObtenerValor("febrero_prox"))
											
											%>
											<tr bordercolor='#999999'>	
												<td ><%=f_presupuestado.ObtenerValor("area")%></td>
												<td ><%=f_presupuestado.ObtenerValor("concepto")%></td>
												<td ><%=f_presupuestado.ObtenerValor("detalle")%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("enero"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("febrero"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("marzo"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("abril"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("mayo"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("junio"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("julio"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("agosto"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("septiembre"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("octubre"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("noviembre"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("diciembre"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("enero_prox"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("febrero_prox"),0)%></td>
												<td><strong><%=formatnumber(f_presupuestado.ObtenerValor("total"),0)%></strong></td>
											</tr>
											 <%wend%>
											<tr bordercolor='#999999'>
											<td colspan="3"><b>Totales</b></td>
											<td align="right"><b><%=formatcurrency(v_enero,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_febrero,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_marzo,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_abril,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_mayo,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_junio,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_julio,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_agosto,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_septiembre,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_octubre,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_noviembre,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_diciembre,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_enero_prox,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_febrero_prox,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_total,0)%></b></td>
										 </tr>									 
										  </table>										  
								
								 <% case 4:%>
									 <tr><td>
									 
										<br/>
										<font color="#0000CC" size="2">FORMULACION PRESUPUESTARIA POR CONCEPTO </font> 
										<br/>
										<br/>		
											<table width="100%" border="1" align="center" >
												<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
												  <th >CONCEPTO</th>
												  <th width="25%">ENERO</th>
												  <th width="25%">FEBRERO</th>
												  <th width="25%">MARZO</th>
												  <th width="25%">ABRIL</th>
												  <th width="25%">MAYO</th>
												  <th width="25%">JUNIO</th>
												  <th width="25%">JULIO</th>
												  <th width="25%">AGOSTO</th>
												  <th width="25%">SEPTIEMBRE</th>
												  <th width="25%">OCTUBRE</th>
												  <th width="25%">NOVIEMBRE</th>
												  <th width="25%">DICIEMBRE</th>
												  <th width="25%">ENERO PROX</th>
												  <th width="25%">FEBRERO PROX</th>
												  <th width="25%">TOTAL</th>
												</tr>
											<%
											while f_presupuestado.Siguiente
												v_total		=	v_total		+	CDbl(f_presupuestado.ObtenerValor("total"))
												v_enero		=	v_enero		+	CDbl(f_presupuestado.ObtenerValor("enero"))
												v_febrero	=	v_febrero	+	CDbl(f_presupuestado.ObtenerValor("febrero"))
												v_marzo		=	v_marzo		+	CDbl(f_presupuestado.ObtenerValor("marzo"))
												v_abril		=	v_abril		+	CDbl(f_presupuestado.ObtenerValor("abril"))
												v_mayo		=	v_mayo		+	CDbl(f_presupuestado.ObtenerValor("mayo"))
												v_junio		=	v_junio		+	CDbl(f_presupuestado.ObtenerValor("junio"))
												v_julio		=	v_julio		+	CDbl(f_presupuestado.ObtenerValor("julio"))
												v_agosto	=	v_agosto	+	CDbl(f_presupuestado.ObtenerValor("agosto"))
												v_septiembre=	v_septiembre	+	CDbl(f_presupuestado.ObtenerValor("septiembre"))
												v_octubre	=	v_octubre		+	CDbl(f_presupuestado.ObtenerValor("octubre"))
												v_noviembre	=	v_noviembre		+	CDbl(f_presupuestado.ObtenerValor("noviembre"))
												v_diciembre	=	v_diciembre		+	CDbl(f_presupuestado.ObtenerValor("diciembre"))
												v_enero_prox	=v_enero_prox	+	CDbl(f_presupuestado.ObtenerValor("enero_prox"))
												v_febrero_prox	=v_febrero_prox	+	CDbl(f_presupuestado.ObtenerValor("febrero_prox"))
											
											%>
											<tr bordercolor='#999999'>	
												<td><%=f_presupuestado.ObtenerValor("concepto")%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("enero"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("febrero"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("marzo"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("abril"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("mayo"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("junio"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("julio"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("agosto"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("septiembre"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("octubre"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("noviembre"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("diciembre"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("enero_prox"),0)%></td>
												<td><%=formatcurrency(f_presupuestado.ObtenerValor("febrero_prox"),0)%></td>
												<td><strong><%=formatcurrency(f_presupuestado.ObtenerValor("total"),0)%></strong></td>
											</tr>
											 <%
											 if f_presupuestado.ObtenerValor("concepto")<>"" then
											 	ind=0
												txt_concepto=f_presupuestado.ObtenerValor("concepto")
												
												set f_detalle = new CFormulario
												f_detalle.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
												f_detalle.Inicializar conexion2
											
												sql_detalle_concepto= "	 SELECT spru_ncorr,cod_pre,area_tdesc as area,concepto,detalle, isnull(total,0) as total,  "& vbCrLf &_
																	  " case isnull(leasing,0) when 1 then '<font color=Red>SI</font>' else 'NO' end as  usa_leasing, "& vbCrLf &_
																	  " isnull(enero,0) as enero,  isnull(febrero,0) as febrero,  isnull(marzo,0) as marzo,  isnull(abril,0) as abril,"& vbCrLf &_
																	  " isnull(mayo,0) as mayo,  isnull(junio,0) as junio,  isnull(julio,0) as julio,  isnull(agosto,0) as agosto,"& vbCrLf &_ 
																	  " isnull(septiembre,0) as septiembre, isnull(octubre,0) as octubre,  isnull(noviembre,0) as noviembre, "& vbCrLf &_
																	  " isnull(diciembre,0) as diciembre,  isnull(enero_prox,0) as enero_prox, isnull(febrero_prox,0) as febrero_prox  "& vbCrLf &_
																	  " FROM presupuesto_upa.protic.solicitud_presupuesto_upa a, presupuesto_upa.protic.area_presupuestal b  "& vbCrLf &_
																	  " where cod_area=area_ccod "& vbCrLf &_
																	  " "&sql_area&" "& vbCrLf &_
																	  " and concepto='"&txt_concepto&"' "
																										  
												'response.Write("<pre>"&sql_detalle_concepto&"</pre>")					  
												 f_detalle.Consultar sql_detalle_concepto
											 %>
											 <tr>
											 <td colspan="16">
											 <div id="tablachica">
											 	<table border="0" class="subtabla" width="98%"  cellpadding="0" cellspacing="0" align="right" bordercolorlight="#000033">
													<tr  bordercolor='#CCCCCC'>
														<th width="1%"></th>
														<th width="1%">LEASING</th>
														<th width="15%">Codigo</th>
														<th width="15%">Area presupuesto </th>
														<th width="15%">Detalle</th>
														<th width="6%">Enero</th>
														<th width="6%">Febrero</th>
														<th width="6%">Marzo</th>
														<th width="6%">Abril</th>
														<th width="6%">Mayo</th>
														<th width="6%">Junio</th>
														<th width="6%">Julio</th>
														<th width="6%">Agosto</th>
														<th width="6%">Septiembre</th>
														<th width="6%">Octubre</th>
														<th width="6%">Noviembre</th>
														<th width="6%">Diciembre</th>
														<th width="6%">Enero prox.</th>
														<th width="6%">Febrero prox.</th>
														<th width="12%">Total</th>
														
													</tr>
													<% 
													while f_detalle.Siguiente 
													%>
													<tr class="color">
														<td>
														<input type="hidden" name="detalle[<%=ind%>][spru_ncorr]"  value="<%=f_detalle.ObtenerValor("spru_ncorr")%>">
														<input type="checkbox" name="detalle[<%=ind%>][agregar]" value="1">
														</td>
														<td><strong><%=f_detalle.ObtenerValor("usa_leasing")%></strong></td>
														<td><font color="#003366"><%=f_detalle.ObtenerValor("cod_pre")%></font></td>
														<td><font color="#003366"><%=f_detalle.ObtenerValor("area")%></font></td>
														<td><%=f_detalle.ObtenerValor("detalle")%></td>
														<td><%=formatcurrency(f_detalle.ObtenerValor("enero"),0)%></td>
														<td><%=formatcurrency(f_detalle.ObtenerValor("febrero"),0)%></td>
														<td><%=formatcurrency(f_detalle.ObtenerValor("marzo"),0)%></td>
														<td><%=formatcurrency(f_detalle.ObtenerValor("abril"),0)%></td>
														<td><%=formatcurrency(f_detalle.ObtenerValor("mayo"),0)%></td>
														<td><%=formatcurrency(f_detalle.ObtenerValor("junio"),0)%></td>
														<td><%=formatcurrency(f_detalle.ObtenerValor("julio"),0)%></td>
														<td><%=formatcurrency(f_detalle.ObtenerValor("agosto"),0)%></td>
														<td><%=formatcurrency(f_detalle.ObtenerValor("septiembre"),0)%></td>
														<td><%=formatcurrency(f_detalle.ObtenerValor("octubre"),0)%></td>
														<td><%=formatcurrency(f_detalle.ObtenerValor("noviembre"),0)%></td>
														<td><%=formatcurrency(f_detalle.ObtenerValor("diciembre"),0)%></td>
														<td><%=formatcurrency(f_detalle.ObtenerValor("enero_prox"),0)%></td>
														<td><%=formatcurrency(f_detalle.ObtenerValor("febrero_prox"),0)%></td>
														<td><%=formatcurrency(f_detalle.ObtenerValor("total"),0)%></td>
														
													</tr>
													<% 
													ind=ind+1
													wend
													%>
												</table>
												</div>
												</td>
											</tr>
											<% end if
											 
											 wend%>
											<tr bordercolor='#999999'>
											<td ><b>Totales</b></td>
											<td align="right"><b><%=formatcurrency(v_enero,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_febrero,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_marzo,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_abril,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_mayo,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_junio,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_julio,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_agosto,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_septiembre,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_octubre,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_noviembre,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_diciembre,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_enero_prox,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_febrero_prox,0)%></b></td>
											<td align="right"><b><%=formatcurrency(v_total,0)%></b></td>
										 </tr>									 
										  </table>
								
								<%End Select%>
								<br/>
								</td></tr></table>
								
								</form>
							</td>
                          </tr>
                        </table></td>
                      		<td width="7" background="../imagenes/marco_claro/10.gif">&nbsp;</td>
                    	</tr>
					  	<tr>
							<td align="left" valign="top"><img src="../imagenes/marco_claro/17.gif" width="9" height="28"></td>
							<td valign="top">
							<table  width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
                          		<tr > 
                            		<td width="150" height="20"><div align="center"> 
                                		<table width="80%" align="center"  border="0" cellspacing="0" cellpadding="0">
										  	<tr> 
											<% 
											select case (nro_t)
												case 1:
												%>
												<td width="49%">
													<% botonera.DibujaBoton ("excel_area")%>
												</td>
												<%case 2:%>
												<td width="100%">
													<%botonera.DibujaBoton ("excel_concepto")%>
												</td>
												<td width="100%">
													<%botonera.DibujaBoton ("marca_leasing")%>
												</td>	
												<%case 3:%>
												<td width="49%">
													<% botonera.DibujaBoton ("excel_leasing")%>
												</td>
												<%case 4:%>
												<td width="100%">
													<%
													botonera.AgregaBotonParam "excel_revision", "url",  "reporte_formulacion_excel.asp?nro_t=4&cod_area="&v_area 
													botonera.DibujaBoton ("excel_revision")%>
												</td>											
												<% end select %>
										  	</tr>
                                		</table>
                              </div></td>
								<td rowspan="2" background="../imagenes/marco_claro/15.gif"><img src="../imagenes/marco_claro/14.gif" width="12" height="28"></td>
                          		</tr>
							   	<tr> 
                            		<td height="8" background="../imagenes/marco_claro/13.gif"></td>
                          		</tr>
							</table>
						</td>
							<td align="right" valign="top" height="13"><img src="../imagenes/marco_claro/16.gif" width="7"height="28"></td>
					  	</tr>
                  </table>
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