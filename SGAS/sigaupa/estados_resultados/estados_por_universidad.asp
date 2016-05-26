<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 2000 
set pagina = new CPagina
pagina.Titulo = "Estado de resultado - Consolidado Universidad"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
v_usuario = negocio.ObtenerUsuario()
'response.Write("Usuario: "&Usuario)



'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "estados_resultados.xml", "botonera"
'-----------------------------------------------------------------------
 


 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "estados_resultados.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 


'----------------------------------------------------------------------------

set f_ingreso = new CFormulario
f_ingreso.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
f_ingreso.Inicializar conexion

  sede_ccod	= request.querystring("busqueda[0][sede_ccod]")

 if sede_ccod="" then
	 sede_ccod= -1
	 sql_filtro="sum(isnull(BAQUEDANO,0)) as BAQUEDANO,sum(isnull(CONCEPCION,0)) as CONCEPCION,sum(isnull(LASCONDES,0)) as LASCONDES,sum(isnull(MELIPILLA,0)) as MELIPILLA,"
 else
 	select case sede_ccod
		case 1
			sql_filtro= "0 as BAQUEDANO,0 as CONCEPCION,sum(isnull(LASCONDES,0)) as LASCONDES,0 as MELIPILLA,"
		case 4
			sql_filtro= "0 as BAQUEDANO,0 as CONCEPCION,0 as LASCONDES,sum(isnull(MELIPILLA,0)) as MELIPILLA,"
		case 7
			sql_filtro= "0 as BAQUEDANO,sum(isnull(CONCEPCION,0)) as CONCEPCION,0 as LASCONDES,0 as MELIPILLA,"
		case 8
			sql_filtro= "sum(isnull(BAQUEDANO,0)) as BAQUEDANO,0 as CONCEPCION, 0 as LASCONDES,0 as MELIPILLA,"	
		end select
 end if
 
 f_busqueda.AgregaCampoCons "sede_ccod", sede_ccod	
  
  		 
			sql_ingreso	=   " select b.cod_grupo,descripcion_grupo,b.cod_orden,b.descripcion,  "& vbCrLf &_ 
							" "&sql_filtro&"  "& vbCrLf &_
							" sum(isnull(BAQUEDANO,0)) + sum(isnull(CONCEPCION,0)) + sum(isnull(LASCONDES,0)) + sum(isnull(MELIPILLA,0)) as total  "& vbCrLf &_
							" from  (  "& vbCrLf &_
							"	select cast(cod_dis as numeric) as codigo,  "& vbCrLf &_
							"	case sede when 'CAMPUS BAQUEDANO' then cast(sum(total) as numeric) end as BAQUEDANO,  "& vbCrLf &_
							"	case sede when 'OFICINA CONCEPCION' then cast(sum(total) as numeric) end as CONCEPCION,  "& vbCrLf &_
							"	case sede when 'SEDE LAS CONDES' then cast(sum(total) as numeric) end as LASCONDES,  "& vbCrLf &_
							"	case sede when 'SEDE MELIPILLA' then cast(sum(total) as numeric) end as MELIPILLA  "& vbCrLf &_
							"	from eru_estados_resultados_upa  "& vbCrLf &_
							"	group by cod_dis, sede  "& vbCrLf &_
							" ) as matriz, eru_codigos_estados_upa b, eru_grupos_estados c  "& vbCrLf &_
							" where matriz.codigo=b.cod_dis  "& vbCrLf &_
							" and b.cod_grupo=c.cod_grupo  "& vbCrLf &_
							" and b.cod_grupo=1  "& vbCrLf &_
							" group by descripcion_grupo,b.cod_grupo,b.cod_orden,codigo,b.descripcion  "& vbCrLf &_
							" order by b.cod_grupo,b.cod_orden "
			
			'response.Write("<pre>"&sql_ingreso&"</pre>")
			f_ingreso.consultar sql_ingreso


			set f_costo_operacional = new CFormulario
			f_costo_operacional.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			f_costo_operacional.Inicializar conexion

			sql_costo_operacional	=   " select b.cod_grupo,descripcion_grupo,b.cod_orden,b.descripcion,  "& vbCrLf &_ 
										" "&sql_filtro&"  "& vbCrLf &_
										" sum(isnull(BAQUEDANO,0)) + sum(isnull(CONCEPCION,0)) + sum(isnull(LASCONDES,0)) + sum(isnull(MELIPILLA,0)) as total  "& vbCrLf &_
										" from  (  "& vbCrLf &_
										"	select cast(cod_dis as numeric) as codigo,  "& vbCrLf &_
										"	case sede when 'CAMPUS BAQUEDANO' then cast(sum(total) as numeric) end as BAQUEDANO,  "& vbCrLf &_
										"	case sede when 'OFICINA CONCEPCION' then cast(sum(total) as numeric) end as CONCEPCION,  "& vbCrLf &_
										"	case sede when 'SEDE LAS CONDES' then cast(sum(total) as numeric) end as LASCONDES,  "& vbCrLf &_
										"	case sede when 'SEDE MELIPILLA' then cast(sum(total) as numeric) end as MELIPILLA  "& vbCrLf &_
										"	from eru_estados_resultados_upa  "& vbCrLf &_
										"	group by cod_dis, sede  "& vbCrLf &_
										" ) as matriz, eru_codigos_estados_upa b, eru_grupos_estados c  "& vbCrLf &_
										" where matriz.codigo=b.cod_dis  "& vbCrLf &_
										" and b.cod_grupo=c.cod_grupo  "& vbCrLf &_
										" and b.cod_grupo=2  "& vbCrLf &_
										" group by descripcion_grupo,b.cod_grupo,b.cod_orden,codigo,b.descripcion  "& vbCrLf &_
										" order by b.cod_grupo,b.cod_orden "
			
			'response.Write("<pre>"&sql_costo_operacional&"</pre>")
			f_costo_operacional.consultar sql_costo_operacional			

'************************************************************************
			set f_gasto_administracion = new CFormulario
			f_gasto_administracion.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			f_gasto_administracion.Inicializar conexion

			sql_gasto_administracion	=   " select b.cod_grupo,descripcion_grupo,b.cod_orden,b.descripcion,  "& vbCrLf &_ 
											" "&sql_filtro&"  "& vbCrLf &_
											" sum(isnull(BAQUEDANO,0)) + sum(isnull(CONCEPCION,0)) + sum(isnull(LASCONDES,0)) + sum(isnull(MELIPILLA,0)) as total  "& vbCrLf &_
											" from  (  "& vbCrLf &_
											"	select cast(cod_dis as numeric) as codigo,  "& vbCrLf &_
											"	case sede when 'CAMPUS BAQUEDANO' then cast(sum(total) as numeric) end as BAQUEDANO,  "& vbCrLf &_
											"	case sede when 'OFICINA CONCEPCION' then cast(sum(total) as numeric) end as CONCEPCION,  "& vbCrLf &_
											"	case sede when 'SEDE LAS CONDES' then cast(sum(total) as numeric) end as LASCONDES,  "& vbCrLf &_
											"	case sede when 'SEDE MELIPILLA' then cast(sum(total) as numeric) end as MELIPILLA  "& vbCrLf &_
											"	from eru_estados_resultados_upa  "& vbCrLf &_
											"	group by cod_dis, sede  "& vbCrLf &_
											" ) as matriz, eru_codigos_estados_upa b, eru_grupos_estados c  "& vbCrLf &_
											" where matriz.codigo=b.cod_dis  "& vbCrLf &_
											" and b.cod_grupo=c.cod_grupo  "& vbCrLf &_
											" and b.cod_grupo=3  "& vbCrLf &_
											" group by descripcion_grupo,b.cod_grupo,b.cod_orden,codigo,b.descripcion  "& vbCrLf &_
											" order by b.cod_grupo,b.cod_orden "
			
			'response.Write("<pre>"&sql_sedes&"</pre>")
			f_gasto_administracion.consultar sql_gasto_administracion	

'************************************************************************
			set f_gasto_indirecto = new CFormulario
			f_gasto_indirecto.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			f_gasto_indirecto.Inicializar conexion

			sql_gasto_indirecto	=   " select b.cod_grupo,descripcion_grupo,b.cod_orden,b.descripcion,  "& vbCrLf &_ 
											" "&sql_filtro&"  "& vbCrLf &_
											" sum(isnull(BAQUEDANO,0)) + sum(isnull(CONCEPCION,0)) + sum(isnull(LASCONDES,0)) + sum(isnull(MELIPILLA,0)) as total  "& vbCrLf &_
											" from  (  "& vbCrLf &_
											"	select cast(cod_dis as numeric) as codigo,  "& vbCrLf &_
											"	case sede when 'CAMPUS BAQUEDANO' then cast(sum(total) as numeric) end as BAQUEDANO,  "& vbCrLf &_
											"	case sede when 'OFICINA CONCEPCION' then cast(sum(total) as numeric) end as CONCEPCION,  "& vbCrLf &_
											"	case sede when 'SEDE LAS CONDES' then cast(sum(total) as numeric) end as LASCONDES,  "& vbCrLf &_
											"	case sede when 'SEDE MELIPILLA' then cast(sum(total) as numeric) end as MELIPILLA  "& vbCrLf &_
											"	from eru_estados_resultados_upa  "& vbCrLf &_
											"	group by cod_dis, sede  "& vbCrLf &_
											" ) as matriz, eru_codigos_estados_upa b, eru_grupos_estados c  "& vbCrLf &_
											" where matriz.codigo=b.cod_dis  "& vbCrLf &_
											" and b.cod_grupo=c.cod_grupo  "& vbCrLf &_
											" and b.cod_grupo=4  "& vbCrLf &_
											" group by descripcion_grupo,b.cod_grupo,b.cod_orden,codigo,b.descripcion  "& vbCrLf &_
											" order by b.cod_grupo,b.cod_orden "
			
			'response.Write("<pre>"&sql_sedes&"</pre>")
			f_gasto_indirecto.consultar sql_gasto_indirecto	


'-----------------------------------------------------------------------------
'*************************** TOTALIZADORES DE  SEDES *************************

			set f_totales = new CFormulario
			f_totales.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			f_totales.Inicializar conexion
			
			sql_totales= " select sum(isnull(BAQUEDANO,0))*-1 as BAQUEDANO,sum(isnull(CONCEPCION,0))*-1 as CONCEPCION,sum(isnull(LASCONDES,0))*-1 as LASCONDES,sum(isnull(MELIPILLA,0))*-1 as MELIPILLA, "& vbCrLf &_
							" (sum(isnull(BAQUEDANO,0)) + sum(isnull(CONCEPCION,0)) + sum(isnull(LASCONDES,0)) + sum(isnull(MELIPILLA,0)))*-1 as total  "& vbCrLf &_
							"	from  ( "& vbCrLf &_
							"		select cast(cod_dis as numeric) as codigo,  "& vbCrLf &_
							"		case sede when 'CAMPUS BAQUEDANO' then cast(sum(total) as numeric) end as BAQUEDANO, "& vbCrLf &_
							"		case sede when 'OFICINA CONCEPCION' then cast(sum(total) as numeric) end as CONCEPCION, "& vbCrLf &_
							"		case sede when 'SEDE LAS CONDES' then cast(sum(total) as numeric) end as LASCONDES, "& vbCrLf &_
							"		case sede when 'SEDE MELIPILLA' then cast(sum(total) as numeric) end as MELIPILLA "& vbCrLf &_
							"		from eru_estados_resultados_upa "& vbCrLf &_
							"		group by cod_dis, sede "& vbCrLf &_
							"	) as matriz, eru_codigos_estados_upa b "& vbCrLf &_
							"	where matriz.codigo=b.cod_dis "& vbCrLf &_
							"	and cod_grupo=1 "
			
			f_totales.consultar sql_totales
			
			'response.Write("<pre>"&sql_totales&"</pre>")
			
			while f_totales.Siguiente
				v_total_baquedano	=f_totales.obtenerValor("BAQUEDANO")
				v_total_concepcion	=f_totales.obtenerValor("CONCEPCION")
				v_total_lascondes	=f_totales.obtenerValor("LASCONDES")
				v_total_melipilla	=f_totales.obtenerValor("MELIPILLA")
				v_total_ingreso		=f_totales.obtenerValor("total")	
			wend

'-----------------------------------------------------------------------------
			
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
function imprimir()
{
  window.print();  
}
</script>
<style type="text/css">

@media print{ .noprint {visibility:hidden; }}
	
</style>
</head>


<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
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
                    <td width="317" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Estado de resultado - Consolidado Universidad</font></div>
                    </td>
                    <td width="367" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
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
                <td bgcolor="#D8D8DE"> <div align="center"><BR><%pagina.DibujarTituloPagina%></div>
				  <br/>
				  <div align="center"><font color="#0033CC" size="2">VALORES ACUMULADOS AL MES DE JUNIO 2013</font></div>
				  <br/>

				  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#EDEDEF">
                    <tr> 
                      <td width="9" height="8"><img src="../imagenes/marco_claro/1.gif" width="9" height="8"></td>
                      <td height="8" background="../imagenes/marco_claro/2.gif"></td>
                      <td width="7" height="8"><img src="../imagenes/marco_claro/3.gif" width="7" height="8"></td>
                    </tr>
                    <tr> 
                      <td width="9" background="../imagenes/marco_claro/9.gif">&nbsp;</td>
                      <td>
					  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td height="2" background=""></td>
                          </tr>
                          <tr> 
                            <td> 
								<br/>
					
                              <table width="98%" border="0" align="center"  >
                                <tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
                                  <th width="48%">TIPO</th>
								  <th colspan="2">Total General</th>
                                </tr>
								<%
								v_grupo=1
								v_subtotal_lascondes	= 0
								v_subtotal_baquedano	= 0
								v_subtotal_melipilla	= 0
								v_subtotal_concepcion 	= 0
								v_subtotal_grupo	 	= 0
								
								while f_ingreso.Siguiente
									descripcion_grupo= f_ingreso.ObtenerValor("descripcion_grupo")

										v_porcentaje_lascondes	= (CDBL(f_ingreso.ObtenerValor("lascondes"))*-100)/CDBL(v_total_lascondes)
										v_porcentaje_baquedano	= (CDBL(f_ingreso.ObtenerValor("baquedano"))*-100)/CDBL(v_total_baquedano)
										v_porcentaje_melipilla	= (CDBL(f_ingreso.ObtenerValor("melipilla"))*-100)/CDBL(v_total_melipilla)
										v_porcentaje_concepcion	= (CDBL(f_ingreso.ObtenerValor("concepcion"))*-100)/CDBL(v_total_concepcion)
										v_porcentaje_total		= (CDBL(f_ingreso.ObtenerValor("total"))*-100)/CDBL(v_total_ingreso)
									
										v_subtotal_lascondes	= v_subtotal_lascondes + (CDBL(f_ingreso.ObtenerValor("lascondes"))*-1)
										v_subtotal_baquedano	= v_subtotal_baquedano + (CDBL(f_ingreso.ObtenerValor("baquedano"))*-1)
										v_subtotal_melipilla	= v_subtotal_melipilla + (CDBL(f_ingreso.ObtenerValor("melipilla"))*-1)
										v_subtotal_concepcion	= v_subtotal_concepcion + (CDBL(f_ingreso.ObtenerValor("concepcion"))*-1)
										v_subtotal_grupo		= v_subtotal_concepcion + (CDBL(f_ingreso.ObtenerValor("total"))*-1)
								%>
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td  align="left"><%f_ingreso.DibujaCampo("descripcion")%></td>
											<td width="26%" bgcolor="#E0E0E0"><%=formatnumber(cdbl(f_ingreso.ObtenerValor("total"))*-1,0)%></td>
											<td width="26%" bgcolor="#E0E0E0"><%=Round(v_porcentaje_total,0)%>&nbsp;<strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
								%>
								<!-- INICIO sub total de grupos -->
									<tr bordercolor='#999999'  align="right">	
										<th width="48%"  align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th width="26%" ><%=formatnumber(v_total_ingreso,0)%></th>
										<th>&nbsp;</th>
									</tr>
								<%

									v_subtotal_lascondes	= 0
									v_subtotal_baquedano	= 0
									v_subtotal_melipilla	= 0
									v_subtotal_concepcion 	= 0
									v_subtotal_grupo	 	= 0								
								while f_costo_operacional.Siguiente
									descripcion_grupo= f_costo_operacional.ObtenerValor("descripcion_grupo")
								
									v_porcentaje_lascondes	= (CDBL(f_costo_operacional.ObtenerValor("lascondes"))*100)/CDBL(v_total_lascondes)
									v_porcentaje_baquedano	= (CDBL(f_costo_operacional.ObtenerValor("baquedano"))*100)/CDBL(v_total_baquedano)
									v_porcentaje_melipilla	= (CDBL(f_costo_operacional.ObtenerValor("melipilla"))*100)/CDBL(v_total_melipilla)
									v_porcentaje_concepcion	= (CDBL(f_costo_operacional.ObtenerValor("concepcion"))*100)/CDBL(v_total_concepcion)
									v_porcentaje_total		= (CDBL(f_costo_operacional.ObtenerValor("total"))*100)/CDBL(v_total_ingreso)

									'** CALCULA LOS SUBTOTALES DE CADA GRUPO POR SEDES
									v_subtotal_lascondes	= v_subtotal_lascondes + (CDBL(f_costo_operacional.ObtenerValor("lascondes")))
									v_subtotal_baquedano	= v_subtotal_baquedano + (CDBL(f_costo_operacional.ObtenerValor("baquedano")))
									v_subtotal_melipilla	= v_subtotal_melipilla + (CDBL(f_costo_operacional.ObtenerValor("melipilla")))
									v_subtotal_concepcion	= v_subtotal_concepcion + (CDBL(f_costo_operacional.ObtenerValor("concepcion")))
									v_subtotal_grupo		= v_subtotal_grupo + (CDBL(f_costo_operacional.ObtenerValor("total")))
								
								
								%>							
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF"  align="right">	
                                  			<td  align="left"><%f_costo_operacional.DibujaCampo("descripcion")%></td>
											<td width="26%" bgcolor="#E0E0E0"><%=formatnumber(f_costo_operacional.ObtenerValor("total"),0)%></td>
											<td width="26%" bgcolor="#E0E0E0"><%=Round(v_porcentaje_total,0)%>&nbsp;<strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
									v_porc_grupo_lascondes	= (CDBL(v_subtotal_lascondes)*100)/CDBL(v_total_lascondes)
									v_porc_grupo_baquedano	= (CDBL(v_subtotal_baquedano)*100)/CDBL(v_total_baquedano)
									v_porc_grupo_melipilla	= (CDBL(v_subtotal_melipilla)*100)/CDBL(v_total_melipilla)
									v_porc_grupo_concepcion	= (CDBL(v_subtotal_concepcion)*100)/CDBL(v_total_concepcion)
									v_porc_grupo_total		= (CDBL(v_subtotal_grupo)*100)/CDBL(v_total_ingreso)
									
									'*** Subtotal Acumulado (A-B)=C ***
									v_operacional_lascondes 	= CDBL(v_total_lascondes)-CDBL(v_subtotal_lascondes)
									v_operacional_baquedano 	= CDBL(v_total_baquedano)-CDBL(v_subtotal_baquedano)	
									v_operacional_melipilla 	= CDBL(v_total_melipilla)-CDBL(v_subtotal_melipilla)	
									v_operacional_concepcion 	= CDBL(v_total_concepcion)-CDBL(v_subtotal_concepcion)
									v_operacional_total		 	= CDBL(v_total_ingreso)-CDBL(v_subtotal_grupo)	
									
									v_porc_operacional_lascondes	= (CDBL(v_operacional_lascondes)*100)/CDBL(v_total_lascondes)
									v_porc_operacional_baquedano	= (CDBL(v_operacional_baquedano)*100)/CDBL(v_total_baquedano)
									v_porc_operacional_melipilla	= (CDBL(v_operacional_melipilla)*100)/CDBL(v_total_melipilla)
									v_porc_operacional_concepcion	= (CDBL(v_operacional_concepcion)*100)/CDBL(v_total_concepcion)
									v_porc_operacional_total		= (CDBL(v_operacional_total)*100)/CDBL(v_total_ingreso)			


								
								%>
								<!-- INICIO sub total de grupo -->
									<tr bordercolor='#999999'  align="right">	
										<th width="48%"  align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th width="26%"><%=formatnumber(v_subtotal_grupo,0)%></th>
										<th width="26%"><%=Round(v_porc_grupo_total,0)%>&nbsp;<strong>%</strong></th>
									</tr>
								<!-- INICIO totalizado de RESULTADO OPERACIONAL-->
									<tr><th colspan="3" height="5"></th></tr>
									<tr bordercolor='#999999' bgcolor="#FFFFCC"  align="right">	
										<th  align="left"><strong>RESULTADO OPERACIONAL</strong></th>
										<th width="26%"><%=formatnumber(v_operacional_total,0)%></th>
										<th width="26%"><%=Round(v_porc_operacional_total,0)%>&nbsp;<strong>%</strong></th>
									</tr>
									<tr><th colspan="3" height="10"></th></tr>									
								<%
								
									v_subtotal_lascondes	= 0
									v_subtotal_baquedano	= 0
									v_subtotal_melipilla	= 0
									v_subtotal_concepcion 	= 0
									v_subtotal_grupo	 	= 0

								while f_gasto_administracion.Siguiente
									descripcion_grupo= f_gasto_administracion.ObtenerValor("descripcion_grupo")
								
									v_porcentaje_lascondes	= (CDBL(f_gasto_administracion.ObtenerValor("lascondes"))*100)/CDBL(v_total_lascondes)
									v_porcentaje_baquedano	= (CDBL(f_gasto_administracion.ObtenerValor("baquedano"))*100)/CDBL(v_total_baquedano)
									v_porcentaje_melipilla	= (CDBL(f_gasto_administracion.ObtenerValor("melipilla"))*100)/CDBL(v_total_melipilla)
									v_porcentaje_concepcion	= (CDBL(f_gasto_administracion.ObtenerValor("concepcion"))*100)/CDBL(v_total_concepcion)
									v_porcentaje_total		= (CDBL(f_gasto_administracion.ObtenerValor("total"))*100)/CDBL(v_total_ingreso)

									'** CALCULA LOS SUBTOTALES DE CADA GRUPO POR SEDES
									v_subtotal_lascondes	= v_subtotal_lascondes + (CDBL(f_gasto_administracion.ObtenerValor("lascondes")))
									v_subtotal_baquedano	= v_subtotal_baquedano + (CDBL(f_gasto_administracion.ObtenerValor("baquedano")))
									v_subtotal_melipilla	= v_subtotal_melipilla + (CDBL(f_gasto_administracion.ObtenerValor("melipilla")))
									v_subtotal_concepcion	= v_subtotal_concepcion + (CDBL(f_gasto_administracion.ObtenerValor("concepcion")))
									v_subtotal_grupo		= v_subtotal_grupo + (CDBL(f_gasto_administracion.ObtenerValor("total")))
								
								%>							
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF"  align="right">	
                                  			<td  align="left"><%f_gasto_administracion.DibujaCampo("descripcion")%></td>
											<td width="26%" bgcolor="#E0E0E0"><%=formatnumber(f_gasto_administracion.ObtenerValor("total"),0)%></td>
											<td width="26%" bgcolor="#E0E0E0"><%=Round(v_porcentaje_total,0)%>&nbsp;<strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
									v_porc_grupo_lascondes	= (CDBL(v_subtotal_lascondes)*100)/CDBL(v_total_lascondes)
									v_porc_grupo_baquedano	= (CDBL(v_subtotal_baquedano)*100)/CDBL(v_total_baquedano)
									v_porc_grupo_melipilla	= (CDBL(v_subtotal_melipilla)*100)/CDBL(v_total_melipilla)
									v_porc_grupo_concepcion	= (CDBL(v_subtotal_concepcion)*100)/CDBL(v_total_concepcion)
									v_porc_grupo_total		= (CDBL(v_subtotal_grupo)*100)/CDBL(v_total_ingreso)

									'*** Subtotal Acumulado (C-D)=E ***
									v_adm_lascondes 	= CDBL(v_operacional_lascondes)-CDBL(v_subtotal_lascondes)
									v_adm_baquedano 	= CDBL(v_operacional_baquedano)-CDBL(v_subtotal_baquedano)	
									v_adm_melipilla 	= CDBL(v_operacional_melipilla)-CDBL(v_subtotal_melipilla)	
									v_adm_concepcion 	= CDBL(v_operacional_concepcion)-CDBL(v_subtotal_concepcion)
									v_adm_total		 	= CDBL(v_operacional_total)-CDBL(v_subtotal_grupo)	
									
									v_porc_adm_lascondes	= (CDBL(v_adm_lascondes)*100)/CDBL(v_total_lascondes)
									v_porc_adm_baquedano	= (CDBL(v_adm_baquedano)*100)/CDBL(v_total_baquedano)
									v_porc_adm_melipilla	= (CDBL(v_adm_melipilla)*100)/CDBL(v_total_melipilla)
									v_porc_adm_concepcion	= (CDBL(v_adm_concepcion)*100)/CDBL(v_total_concepcion)
									v_porc_adm_total		= (CDBL(v_adm_total)*100)/CDBL(v_total_ingreso)		
																		
								%>
								<!-- INICIO sub total de grupos -->
									<tr bordercolor='#999999'  align="right">	
										<th width="48%"  align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th width="26%"><%=formatnumber(v_subtotal_grupo,0)%></th>
										<th width="26%"><%=Round(v_porc_grupo_total,0)%>&nbsp;<strong>%</strong></th>
									</tr>
								<!-- INICIO totalizado de RESULTADO OPERACIONAL-->
									<tr><th colspan="3" height="5"></th></tr>
									<tr bordercolor='#999999' bgcolor="#FFFFCC"  align="right">	
										<th  align="left"><strong>RESULTADO</strong></th>
										<th width="26%"><%=formatnumber(v_adm_total,0)%></th>
										<th width="26%"><%=Round(v_porc_adm_total,0)%>&nbsp;<strong>%</strong></th>
									</tr>
									<tr><th colspan="3" height="10"></th></tr>									
								 <%
								 
								 		v_subtotal_lascondes	= 0
										v_subtotal_baquedano	= 0
										v_subtotal_melipilla	= 0
										v_subtotal_concepcion 	= 0
										v_subtotal_grupo	 	= 0
										
								 while f_gasto_indirecto.Siguiente
								 
										 descripcion_grupo= f_gasto_indirecto.ObtenerValor("descripcion_grupo")
								 
										v_porcentaje_lascondes	= (CDBL(f_gasto_indirecto.ObtenerValor("lascondes"))*100)/CDBL(v_total_lascondes)
										v_porcentaje_baquedano	= (CDBL(f_gasto_indirecto.ObtenerValor("baquedano"))*100)/CDBL(v_total_baquedano)
										v_porcentaje_melipilla	= (CDBL(f_gasto_indirecto.ObtenerValor("melipilla"))*100)/CDBL(v_total_melipilla)
										v_porcentaje_concepcion	= (CDBL(f_gasto_indirecto.ObtenerValor("concepcion"))*100)/CDBL(v_total_concepcion)
										v_porcentaje_total		= (CDBL(f_gasto_indirecto.ObtenerValor("total"))*100)/CDBL(v_total_ingreso)
									
										v_subtotal_lascondes	= v_subtotal_lascondes + (CDBL(f_gasto_indirecto.ObtenerValor("lascondes")))
										v_subtotal_baquedano	= v_subtotal_baquedano + (CDBL(f_gasto_indirecto.ObtenerValor("baquedano")))
										v_subtotal_melipilla	= v_subtotal_melipilla + (CDBL(f_gasto_indirecto.ObtenerValor("melipilla")))
										v_subtotal_concepcion	= v_subtotal_concepcion + (CDBL(f_ingreso.ObtenerValor("concepcion")))
										v_subtotal_grupo		= v_subtotal_grupo + (CDBL(f_gasto_indirecto.ObtenerValor("total")))
								%>
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF"  align="right">	
                                  			<td  align="left"><%f_gasto_indirecto.DibujaCampo("descripcion")%></td>
											<td width="26%" bgcolor="#E0E0E0"><%=formatnumber(f_gasto_indirecto.ObtenerValor("total"),0)%></td>
											<td width="26%" bgcolor="#E0E0E0"><%=Round(v_porcentaje_total,0)%>&nbsp;<strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
									v_porc_grupo_lascondes	= (CDBL(v_subtotal_lascondes)*100)/CDBL(v_total_lascondes)
									v_porc_grupo_baquedano	= (CDBL(v_subtotal_baquedano)*100)/CDBL(v_total_baquedano)
									v_porc_grupo_melipilla	= (CDBL(v_subtotal_melipilla)*100)/CDBL(v_total_melipilla)
									v_porc_grupo_concepcion	= (CDBL(v_subtotal_concepcion)*100)/CDBL(v_total_concepcion)
									v_porc_grupo_total		= (CDBL(v_subtotal_grupo)*100)/CDBL(v_total_ingreso)								
								
								
								%>
								<!-- INICIO sub total de grupos -->
									<tr bordercolor='#999999'  align="right">	
										<th width="48%"  align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th width="26%"><%=formatnumber(v_subtotal_grupo,0)%></th>
										<th width="26%"><%=Round(v_porc_grupo_total,0)%>&nbsp;<strong>%</strong></th>
									</tr>
									<%
									'*** Subtotal Acumulado (E-F)=G ***
									v_resul_total_lascondes 	= CDBL(v_adm_lascondes)-CDBL(v_subtotal_lascondes)
									v_resul_total_baquedano 	= CDBL(v_adm_baquedano)-CDBL(v_subtotal_baquedano)	
									v_resul_total_melipilla 	= CDBL(v_adm_melipilla)-CDBL(v_subtotal_melipilla)	
									v_resul_total_concepcion 	= CDBL(v_adm_concepcion)-CDBL(v_subtotal_concepcion)
									v_resul_total	 			= CDBL(v_adm_total)-CDBL(v_subtotal_grupo)	
									
									v_porc_total_lascondes	= (CDBL(v_resul_total_lascondes)*100)/CDBL(v_total_lascondes)
									v_porc_total_baquedano	= (CDBL(v_resul_total_baquedano)*100)/CDBL(v_total_baquedano)
									v_porc_total_melipilla	= (CDBL(v_resul_total_melipilla)*100)/CDBL(v_total_melipilla)
									v_porc_total_concepcion	= (CDBL(v_resul_total_concepcion)*100)/CDBL(v_total_concepcion)
									v_porc_total_total		= (CDBL(v_resul_total)*100)/CDBL(v_total_ingreso)	
									
									%>
								 <tr><th colspan="3" height="5"></th></tr>
								 <tr bordercolor='#999999'  bgcolor="#FFFFCC"  align="right">
								 	<td  align="left"><b>RESULTADO TOTAL</b></td>
									<td><b><%=formatnumber(v_resul_total,0,0)%></b></td>
									<td><b><%=Round(v_porc_total_total,0)%></b>&nbsp;<strong>%</strong></td>
								 </tr>
								<tr><th colspan="3" height="10"></th></tr>								 
                              </table>
						<br/>
						</td>
                          </tr>
                        </table></td>
                      		<td width="7" background="../imagenes/marco_claro/10.gif">&nbsp;</td>
                    	</tr>
					  	<tr>
							<td class="noprint" align="left" valign="top"><img src="../imagenes/marco_claro/17.gif" width="9" height="28"></td>
							<td valign="top">
							<!-- desde aca -->
							<table  width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
                          		<tr > 
                            		<td class="noprint" width="47%" height="20" ><%botonera.DibujaBoton("imprimir")%></td>
								<td class="noprint" width="53%" rowspan="2" background="../imagenes/marco_claro/15.gif"><img src="../imagenes/marco_claro/14.gif" width="12" height="28"></td>
                          	</tr>
							   <tr> 
                            		<td height="8" background="../imagenes/marco_claro/13.gif"></td>
                          		</tr>
							</table>
							<!-- hasta aca 
							<img src="../imagenes/marco_claro/15.gif" width="100%" height="13">--></td>
							<td class="noprint" align="right" valign="top" height="13" ><img src="../imagenes/marco_claro/16.gif" width="7"height="28"></td>
					  	</tr>
                  </table>
                    <br/>
					<br/>
                </td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
            </table>
			
            <table class="noprint" width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                <td width="20%" bgcolor="#D8D8DE"><table width="100%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td ><% botonera.DibujaBoton ("lanzadera") %> </td>
                    </tr>
                  </table>
                </td>
                <td width="80%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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