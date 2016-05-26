<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_peri_ccod = Request.QueryString("busqueda[0][peri_ccod]")

set pagina = new CPagina
pagina.Titulo = "Resumen matrículas por Sedes y Campus"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
periodo = q_peri_ccod 'negocio.obtenerPeriodoAcademico("postulacion")

set botonera = new CFormulario
botonera.Carga_Parametros "tablon_matriculas.xml", "botonera"
'--------------------------------------------------------------------------

set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "tablon_matriculas.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select '' as peri_ccod"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "peri_ccod", q_peri_ccod

anos_ccod = conexion.consultaUno("select anos_ccod-1 from periodos_academicos where cast(peri_ccod as varchar)='"&q_peri_ccod&"'")
periodo_anterior = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod&"' and plec_ccod=1")

'----------------------------buscamos el listado de matrículas para el período
if q_peri_ccod <> "" then
    filtro_pep = ""
	if q_peri_ccod = "222" then
		filtro_pep = ",'870'"
	end if
	
	set datos_matriculas = new CFormulario
	datos_matriculas.Carga_Parametros "tablon_matriculas.xml", "formu_matriculas"
	datos_matriculas.Inicializar conexion
	conc_matriculas = " select distinct sede_tdesc as sede, carr_tdesc as carrera, jorn_tdesc as jornada, "& vbCrLf &_
	                  " isnull((select vacantes_nuevos  "& vbCrLf &_
					  "	  from estructura_indicador_ofertas ttt  "& vbCrLf &_
					  "	  where cast(admision as varchar)='"&cint(anos_ccod)+1&"' and ttt.sede=a.sede_ccod   "& vbCrLf &_
					  "	  and ttt.cod_carrera=d.carr_ccod and ttt.jornada=a.jorn_ccod),a.ofer_nvacantes) as vacantes, "& vbCrLf &_
					  " ( select count(*) "& vbCrLf &_
					  " from personas ta (nolock), ofertas_academicas tc, alumnos td (nolock),especialidades te   "& vbCrLf &_
					  " where ta.pers_ncorr = td.pers_ncorr    "& vbCrLf &_
					  " and tc.ofer_ncorr= td.ofer_ncorr "& vbCrLf &_
					  " and tc.espe_ccod = te.espe_ccod  "& vbCrLf &_
					  " and tc.jorn_ccod=a.jorn_ccod    "& vbCrLf &_
					  " and te.carr_ccod=d.carr_ccod "& vbCrLf &_
					  " and tc.sede_ccod=b.sede_ccod "& vbCrLf &_
					  " and td.emat_ccod in (1,4,8,2,15,16)  and td.audi_tusuario not like '%ajunte matricula%'   "& vbCrLf &_
					  " and protic.afecta_estadistica(td.matr_ncorr) > 0    "& vbCrLf &_
					  " and tc.peri_ccod=protic.retorna_max_periodo_matricula(ta.pers_ncorr,'"&periodo&"',te.carr_ccod)   "& vbCrLf &_
					  " and isnull(td.alum_nmatricula,0) not in (7777)  "& vbCrLf &_
					  " and td.audi_tusuario not in ('Agregabase_saenzBeta2','AgregaBaseSaenzBeta2','AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49','AgregaNota491T','AgregaNota492T', "& vbCrLf &_
					  "            'AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99','AgregaNotaN', "& vbCrLf &_   
					  "            'AgregaNotaProtix','AgregaNotaprotix1','Agreganotas_saenzBeta2','AgregaNotas46$','AgregaNotas46$Beta','AgregaNotas46$Beta2','AgregaNotasSaenzBeta2','Agregaprotix_saenzBeta2','AgregaProtixSaenzBeta2')  "& vbCrLf &_
					  " and exists (select 1 from postulantes tt (nolock) where tt.post_ncorr=td.post_ncorr and tt.post_bnuevo='S') "& vbCrLf &_
					  " )as matriculados, "& vbCrLf &_
					  " ( select count(*) "& vbCrLf &_
					  " from personas ta (nolock), ofertas_academicas tc, alumnos td (nolock),especialidades te   "& vbCrLf &_
					  " where ta.pers_ncorr = td.pers_ncorr    "& vbCrLf &_
					  " and tc.ofer_ncorr= td.ofer_ncorr "& vbCrLf &_
					  " and tc.espe_ccod = te.espe_ccod  "& vbCrLf &_
					  " and tc.jorn_ccod=a.jorn_ccod    "& vbCrLf &_
					  " and te.carr_ccod=d.carr_ccod "& vbCrLf &_
					  " and tc.sede_ccod=case when b.sede_ccod = 1 and d.carr_ccod in ('51','110') then 2 "& vbCrLf &_
					  "						  when b.sede_ccod = 8 and d.carr_ccod in ('99','105') then 2 "& vbCrLf &_
					  "						  else b.sede_ccod end "& vbCrLf &_
					  " and td.emat_ccod in (1,4,8,2,15,16)  and td.audi_tusuario not like '%ajunte matricula%'   "& vbCrLf &_
					  " and protic.afecta_estadistica(td.matr_ncorr) > 0    "& vbCrLf &_
					  " and cast(tc.peri_ccod as varchar)='"&periodo_anterior&"'"& vbCrLf &_
					  " and convert(datetime,protic.trunc(td.alum_fmatricula),103) <= (getDate()-365) "& vbCrLf &_
					  " and isnull(td.alum_nmatricula,0) not in (7777) "& vbCrLf &_
					  " and td.audi_tusuario not in ('Agregabase_saenzBeta2','AgregaBaseSaenzBeta2','AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49','AgregaNota491T','AgregaNota492T', "& vbCrLf &_
					  "            'AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99','AgregaNotaN', "& vbCrLf &_
				      "            'AgregaNotaProtix','AgregaNotaprotix1','Agreganotas_saenzBeta2','AgregaNotas46$','AgregaNotas46$Beta','AgregaNotas46$Beta2','AgregaNotasSaenzBeta2','Agregaprotix_saenzBeta2','AgregaProtixSaenzBeta2')  "& vbCrLf &_
					  " and exists (select 1 from postulantes tt (nolock) where tt.post_ncorr=td.post_ncorr and tt.post_bnuevo='S') "& vbCrLf &_
					  " )as proceso_anterior, case a.jorn_ccod when 1 then 'D' else 'V' end as jornada_corta "& vbCrLf &_
					  " from ofertas_academicas a, sedes b, especialidades c, carreras d, jornadas e,aranceles f"& vbCrLf &_
					  " where a.sede_ccod=b.sede_ccod and a.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod"& vbCrLf &_
					  " and a.jorn_ccod=e.jorn_ccod and cast(a.peri_ccod as varchar)='"&periodo&"' "& vbCrLf &_
					  " and a.post_bnuevo='S' and a.aran_ncorr=f.aran_ncorr "& vbCrLf &_
					  " and d.tcar_ccod=1 and b.sede_ccod <> 9 and d.carr_ccod <> '600' and d.carr_ccod not in ('107','109' "&filtro_pep&")"& vbCrLf &_
					  " order by sede,carrera,jornada "
	
	datos_matriculas.Consultar conc_matriculas
	datos_matriculas.siguientef
    sede = datos_matriculas.obtenerValor("sede")
	'datos_matriculas.primero
end if
fecha_anterior = conexion.consultaUno("select protic.trunc(getDate()-365) ")
fecha_actual = conexion.consultaUno("select getDate() ")
'response.Write("<pre>"&conc_matriculas&"</pre>")
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
<script type="text/javascript">
	function abrir_pdf()
	{
	   document.edicion_postulacion.submit();
	}   
</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
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
            <td><%pagina.DibujarLenguetas Array("Toma de Asignaturas Escuela"), 1 %></td>
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
                        <td><div align="right"><strong>Periodo</strong></div></td>
                        <td width="50"><div align="center"><strong>:</strong></div></td>
                        <td><%f_busqueda.dibujaCampo("peri_ccod")%></td>
                      </tr>
                    </table>
                  </div></td>
                  <td width="19%"><div align="center"><%botonera.DibujaBoton("buscar")%></div></td>
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
	<%if q_peri_ccod <> "" then %>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Resumen Matrículas</font></div></td>
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
              <table width="100%" border="0" cellspacing="0" cellpadding="0" aling="center">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  
                <td bgcolor="#D8D8DE"> <div align="center">&nbsp; 
                    <BR>
					<%pagina.DibujarTituloPagina%>
                  </div>
				  <table width="100%" border="0">
                    <tr> 
                      <td align="left">&nbsp;</td>
                    </tr>
					<tr> 
                      <td align="left" bgcolor="#FFFFFF"><font size="2" color="#990000">Los valores indicados en la columna "anterior" y "admisión anterior", están directamente relacionados con los resultados obtenidos para la admisión del año anterior, (día actual = <%=fecha_actual%>  ==> fecha comparación = <%=fecha_anterior%>). Considerar dicha información sólo con fines comparativos.</font></td>
                    </tr>
					<form name="edicion_postulacion" action="tablon_matriculas_pdf.asp" method="post" target="_blank">
					<tr> 
						<td align="left">
							  <%
							     total_vacante=0
								 total_matricula=0
								 total_anterior=0
								 filas = 3
								 vacantes_general = 0
								 matriculas_general = 0
								 anterior_general = 0
								 total_sedes = 0
								 total_carreras = 0
							  %>
							  <table width="100%" cellpadding="0" cellspacing="20">
							  <tr valign="top">
							  		<td width="80%" align="left">
									  <table width="100%" cellpadding="0" cellspacing="0" border="1" bordercolor="#999999">
										<tr>
											<td colspan="6" bgcolor="#c4d7ff" align="center">
												<font color="#000000" size="2"><strong><%=sede%></strong></font>
												<input type="hidden" name="sede_paso[<%=total_sedes%>]" value="<%=sede%>">
											</td>
										</tr>
										<tr>
											<td bgcolor="#c4d7ff"><font color="#000000" size="1">Carrera</font></td>
											<td bgcolor="#c4d7ff"><font color="#000000" size="1">Jornada</font></td>
											<td bgcolor="#c4d7ff"><font color="#000000" size="1">Meta</font></td>
											<td bgcolor="#c4d7ff"><font color="#000000" size="1">Actual</font></td>
											<td bgcolor="#c4d7ff"><font color="#000000" size="1">Anterior</font></td>
											<td bgcolor="#c4d7ff"><font color="#000000" size="1">Desviación</font></td>
										</tr>
										<% datos_matriculas.primero
										   while datos_matriculas.siguiente
										     sede_t = datos_matriculas.obtenerValor("sede")
											 vacantes_t = cint(datos_matriculas.obtenerValor("vacantes"))
											 matriculados_t = cint(datos_matriculas.obtenerValor("matriculados"))
											 anterior_t = cint(datos_matriculas.obtenerValor("proceso_anterior"))
											 carrera_t = datos_matriculas.obtenerValor("carrera")
											 jornada_t = datos_matriculas.obtenerValor("jornada")
											 jornada_c = datos_matriculas.obtenerValor("jornada_corta")
											 if sede = sede_t then 
											   total_vacante = total_vacante + vacantes_t
											   total_matricula = total_matricula + matriculados_t
											   total_anterior = total_anterior + anterior_t
											   vacantes_general = vacantes_general + vacantes_t
								               matriculas_general = matriculas_general + matriculados_t
											   anterior_general = anterior_general + anterior_t
											   filas = filas + 1
											   flecha = ""
											   if matriculados_t > anterior_t then
											       flecha = "<img width='10' height='10' src='../imagenes/mayor.gif' title='Las matrículas actuales son mayores a las del año pasado a esta misma fecha para la carrera'>"
											   elseif matriculados_t < anterior_t then
											       flecha = "<img width='10' height='10' src='../imagenes/menor.gif' title='El año pasado a esta fecha existían más matrículas para la carrera'>"
											   else
											       flecha = ""
											   end if
											   color_desviacion = "#000000"
											   if (matriculados_t - anterior_t) >= 0 then
											   	color_desviacion = "#006600"
											   else 
											   	color_desviacion = "#CC0000"
											   end if
											   	
											 %>
												<tr>
													<td bgcolor="#FFFFFF"><font color="#000000"><%=carrera_t%></font></td>
													<td bgcolor="#FFFFFF"><font color="#000000"><%=jornada_t%></font></td>
													<td bgcolor="#FFFFFF" align="center"><font color="#000000"><%=vacantes_t%></font></td>
													<td bgcolor="#FFFFFF" align="center"><font color="#000000"><%=flecha%><%=matriculados_t%></font></td>
													<td bgcolor="#FFFFFF" align="center"><font color="#000000"><%=anterior_t%></font></td>
													<td bgcolor="#FFFFFF" align="center"><font color="<%=color_desviacion%>" size="3"><strong><%=(matriculados_t - anterior_t)%></strong></font></td>
													<input type="hidden" name="carrera[<%=total_sedes%>][<%=total_carreras%>]" value="<%=carrera_t&"*"&jornada_c&"*"&vacantes_t&"*"&matriculados_t&"*"&anterior_t%>">
												    <%total_carreras = total_carreras + 1%>
												</tr>
											 <%else
											   datos_matriculas.anterior
											   color_matricula = "#FFFFFF"
											   if total_matricula >= total_anterior then
											   	color_matricula = "#99FF66"
											   else
											   	color_matricula = "#FF6633"
											   end if 
											   
											   
											 %>
												<tr>
													<td colspan="2" bgcolor="#FFFFFF" align="right"><font size="2" color="#000000"><strong>Totales...:</strong></font></td>
													<td bgcolor="#FFFFFF" align="center"><font size="2" color="#000000"><strong><%=total_vacante%></strong></font></td>
													<td bgcolor="<%=color_matricula%>" align="center"><font size="2" color="#000000"><strong><%=total_matricula%></strong></font></td>
													<td bgcolor="#FFFFFF" align="center"><font size="2" color="#000000"><strong><%=total_anterior%></strong></font></td>
													<td bgcolor="#FFFFFF" align="center"><font size="2" color="#000000"><strong><%=(total_matricula - total_anterior)%></strong></font></td>
												</tr>
												<input type="hidden" name="total_carrera[<%=total_sedes%>]" value="<%=total_carreras%>">
												<%
												total_sedes = total_sedes + 1
											    total_carreras = 0
												%>  								 
												</table>
											</td>
											<td width="20%" align="left">
											<table width="100%" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" border="1" bordercolor="#666666">
											   <tr>
											       <td colspan="2" align="left">
													<%if filas > 10 then%>
														<img height="<%=filas*18%>" src="http://admision.upacifico.cl/graficos/graphbarras.php?dat=<%=total_vacante%>,<%=total_matricula%>,<%=total_anterior%>&bkg=FFFFFF&ttl=Matrículas <%=sede%>">
													<%else%>
														<img height="<%=filas*25%>" src="http://admision.upacifico.cl/graficos/graphbarras.php?dat=<%=total_vacante%>,<%=total_matricula%>,<%=total_anterior%>&bkg=FFFFFF&ttl=Matrículas <%=sede%>">
													<%end if%>
												   </td>
											   </tr>
											   <tr>
											   	 <td width="3%" bgcolor="#ff0000">&nbsp;</td>
												 <td width="97%" align="left">: Meta</td>
											   </tr>
											   <tr>
											   	 <td width="3%" bgcolor="#24abe8">&nbsp;</td>
												 <td width="97%" align="left">: Admisión actual</td>
											   </tr>
											   <tr>
											   	 <td width="3%" bgcolor="#2fd033">&nbsp;</td>
												 <td width="97%" align="left">: Admisión anterior</td>
											   </tr>
											 </table>
											</td>
											<%sede = sede_t%>
											</tr>
											<tr valign="top">
											<td width="80%" align="left">
												<table width="100%" cellpadding="0" cellspacing="0" border="1" bordercolor="#999999">
												<tr>
													<td colspan="6" bgcolor="#c4d7ff" align="center">
														<font color="#000000" size="2"><strong><%=sede%></strong></font>
														<input type="hidden" name="sede_paso[<%=total_sedes%>]" value="<%=sede%>">
													</td>
												</tr>
												<tr>
													<td bgcolor="#c4d7ff"><font color="#000000" size="1">Carrera</font></td>
													<td bgcolor="#c4d7ff"><font color="#000000" size="1">Jornada</font></td>
													<td bgcolor="#c4d7ff" align="center"><font color="#000000" size="1">Meta</font></td>
													<td bgcolor="#c4d7ff" align="center"><font color="#000000" size="1">Actual</font></td>
													<td bgcolor="#c4d7ff" align="center"><font color="#000000" size="1">Anterior</font></td>
													<td bgcolor="#c4d7ff" align="center"><font color="#000000" size="1">Desviación</font></td>
												</tr>
											 <%total_vacante = 0 
											   total_matricula = 0
											   total_anterior = 0
											   filas = 3
											   end if%>
										<%wend%>
										<%
											   color_matricula = "#FFFFFF"
											   if total_matricula >= total_anterior then
											   	color_matricula = "#99FF66"
											   else
											   	color_matricula = "#FF6633"
											   end if 
										%>
										<tr>
											<td colspan="2" bgcolor="#FFFFFF" align="right"><font size="2" color="#000000"><strong>Totales...:</strong></font></td>
											<td bgcolor="#FFFFFF" align="center"><font size="2" color="#000000"><strong><%=total_vacante%></strong></font></td>
											<td bgcolor="<%=color_matricula%>" align="center"><font size="2" color="#000000"><strong><%=total_matricula%></strong></font></td>
											<td bgcolor="#FFFFFF" align="center"><font size="2" color="#000000"><strong><%=total_anterior%></strong></font></td>
											<td bgcolor="#FFFFFF" align="center"><font size="2" color="#000000"><strong><%=(total_matricula - total_anterior)%></strong></font></td>
										</tr> 
										<input type="hidden" name="total_carrera[<%=total_sedes%>]" value="<%=total_carreras%>"> 
									  </table>
									  </td>
									  <td width="20%" align="left">
									  <table width="100%" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" border="1" bordercolor="#666666">
											   <tr>
											       <td colspan="2" align="left">
													<%if filas > 10 then %>
														<img height="<%=filas*18%>" src="http://admision.upacifico.cl/graficos/graphbarras.php?dat=<%=total_vacante%>,<%=total_matricula%>,<%=total_anterior%>&bkg=FFFFFF&ttl=Matrículas <%=sede%>">
													<%else%>
														<img height="<%=filas*25%>" src="http://admision.upacifico.cl/graficos/graphbarras.php?dat=<%=total_vacante%>,<%=total_matricula%>,<%=total_anterior%>&bkg=FFFFFF&ttl=Matrículas <%=sede%>">
													<%end if%>
												  </td>
											   </tr>
											   <tr>
											   	 <td width="3%" bgcolor="#ff0000">&nbsp;</td>
												 <td width="97%" align="left">: Meta</td>
											   </tr>
											   <tr>
											   	 <td width="3%" bgcolor="#24abe8">&nbsp;</td>
												 <td width="97%" align="left">: Admisión actual</td>
											   </tr>
											   <tr>
											   	 <td width="3%" bgcolor="#2fd033">&nbsp;</td>
												 <td width="97%" align="left">: Admisión anterior</td>
											   </tr>
											 </table> 
									  </td>
									</tr>
									</table>
						</td>
                    </tr>
					      <input type="hidden" name="total_sedes" value="<%=total_sedes%>">
						  <input type="hidden" name="fecha_anterior" value="<%=fecha_anterior%>">
						  <input type="hidden" name="fecha_actual" value="<%=fecha_actual%>">
					</form>
					<tr> 
                      <td align="left">&nbsp;</td>
                    </tr>
					<tr> 
                      <td align="center">
					  	<table width="90%" cellpadding="3" cellspacing="3" border="1" bordercolor="#FFFFFF">
							<tr>
								<td colspan="4" bgcolor="#c4d7ff" align="center">
							   	   <font color="#000000" size="2"><strong>Resultados totales de la Universidad</strong></font>
								</td>
							</tr>
							<tr>
								<td bgcolor="#c4d7ff"><font color="#000000" size="2"><strong>Meta Total</strong></font></td>
								<td bgcolor="#c4d7ff"><font color="#000000" size="2"><strong>Admisión Actual</strong></font></td>
								<td bgcolor="#c4d7ff"><font color="#000000" size="2"><strong>Admisión Anterior</strong></font></td>
								<td bgcolor="#c4d7ff"><font color="#000000" size="2"><strong>Desviación</strong></font></td>
							</tr>
							<%
								color_matricula = "#FFFFFF"
								if matriculas_general >= anterior_general then
								  	color_matricula = "#99FF66"
								else
								  	color_matricula = "#FF6633"
								end if 
							%>
							<tr>
								<td bgcolor="#FFFFFF" width="25%" align="center"><font color="#000000" size="3"><%=vacantes_general%></font></td>
								<td bgcolor="<%=color_matricula%>" width="25%" align="center"><font color="#000000" size="3"><%=matriculas_general%></font></td>
								<td bgcolor="#FFFFFF" width="25%" align="center"><font color="#000000" size="3"><%=anterior_general%></font></td>
								<td bgcolor="#FFFFFF" width="25%" align="center"><font color="#000000" size="3"><%=(matriculas_general - anterior_general)%></font></td>
							</tr>
						</table>
					  </td>
                    </tr>
					<tr> 
                      <td align="center">&nbsp;</td>
                    </tr>
                  </table> 
                  
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="101" nowrap bgcolor="#D8D8DE">
				  <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                       <td width="50%">
                        <%  botonera.dibujaboton "salir"%>
						<!--<a href="javascript:document.edicion_postulacion.submit();">.</a>-->
                      </td>
					  <td width="50%">
					    <% if q_peri_ccod <> "" then
						      botonera.dibujaboton "imprimir"
						   end if%>
					  </td>
                    </tr>
                  </table></td>
                  <td width="309" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="267" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<BR>
		  </td>
        </tr>
      </table>
	<%end if%>	
   </td>
  </tr>  
</table>
</body>
</html>
