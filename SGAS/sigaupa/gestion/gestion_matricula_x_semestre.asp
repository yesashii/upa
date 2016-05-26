<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
set botonera =  new CFormulario
botonera.carga_parametros "gestion_matricula_x_semestre.xml","botones_rep_matriculados"
pagina.Titulo = "Alumnos Matriculados por semestre"

set conectar = new cConexion
set negocio = new cnegocio
set f_matriculados = new cformulario
conectar.inicializar "upacifico"
negocio.inicializa conectar

f_matriculados.carga_parametros "gestion_matricula_x_semestre.xml","matriculados"
f_matriculados.inicializar conectar

periodo=negocio.ObtenerPeriodoAcademico("POSTULACION")
if esVacio(periodo) then
	periodo=negocio.ObtenerPeriodoAcademico("CLASES18")
end if
periodo_tdesc = conectar.consultaUno("select peri_tdesc from  periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")

usuario=negocio.obtenerUsuario
		
consulta=" select aa.sede_ccod,aa.sede_tdesc, " & vbCrLf  & _
" cast(isnull(EN_PROCESO_n,0) as integer) as EN_PROCESO_n, " & vbCrLf  & _
" cast(isnull(EN_PROCESO_a,0) as integer) as EN_PROCESO_a, " & vbCrLf  & _
" cast(isnull(EN_PROCESO_n,0)+isnull(EN_PROCESO_a,0) as integer) as EN_PROCESO_t, " & vbCrLf  & _
" cast(isnull(ENVIADOS_n,0) as integer) as ENVIADOS_n, " & vbCrLf  & _
" cast(isnull(ENVIADOS_a,0) as integer) as ENVIADOS_a, " & vbCrLf  & _
" cast(isnull(ENVIADOS_n,0) + isnull(ENVIADOS_a,0) as integer) as ENVIADOS_t, " & vbCrLf  & _
" cast(isnull(MATRICULADOS_n,0) as integer) as MATRICULADOS_n, " & vbCrLf  & _
" cast(isnull(MATRICULADOS_a,0) as integer) as MATRICULADOS_a, " & vbCrLf  & _
" cast(isnull(MATRICULADOS_n,0) + isnull(MATRICULADOS_a,0) as integer) as MATRICULADOS_t  " & vbCrLf  & _
" from -- obtencion de primera tabla a " & vbCrLf  & _
"     (select a.sede_ccod,a.sede_tdesc, " & vbCrLf  & _
"        SUM(case EPOS_CCOD When 1 then (case nuevo when 'S' then total_pos end )else 0 end) as EN_PROCESO_n, " & vbCrLf  & _
"        SUM(case EPOS_CCOD When 1 then (case nuevo when 'N' then total_pos end )else 0 end) as EN_PROCESO_a, " & vbCrLf  & _
"        SUM(case EPOS_CCOD When 2 then (case nuevo when 'S' then total_pos end )else 0 end) as ENVIADOS_n, " & vbCrLf  & _
"        SUM(case EPOS_CCOD When 2 then (case nuevo when 'N' then total_pos end )else 0 end) as ENVIADOS_a " & vbCrLf  & _
"        from(   select b.sede_ccod,sede_tdesc, d.epos_ccod, " & vbCrLf  & _
"                    protic.es_nuevo_carrera(c.pers_ncorr,e.carr_ccod,a.peri_ccod) as nuevo,count(*) as total_pos " & vbCrLf  & _
"                from ofertas_academicas a " & vbCrLf  & _
"                    left outer join sedes b " & vbCrLf  & _
"                        on a.sede_ccod=b.sede_ccod " & vbCrLf  & _
"                    left outer join postulantes c " & vbCrLf  & _
"                        on a.ofer_ncorr =c.ofer_ncorr " & vbCrLf  & _
"                    left outer join estados_postulantes d " & vbCrLf  & _
"                        on c.epos_ccod = d.epos_ccod " & vbCrLf  & _
"                    left outer join especialidades e " & vbCrLf  & _
"                        on a.espe_ccod = e.espe_ccod " & vbCrLf  & _
"                    where cast(a.peri_ccod as varchar)='"&periodo&"' " & vbCrLf  & _
"                        and c.audi_tusuario not in ('AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42','AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49'," & vbCrLf &_
"						   'AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno','AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52', " & vbCrLf &_
" 						   'AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65','AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88'," & vbCrLf &_
"  						   'AgregaNota98','AgregaNota99','AgregaNotaN','AgregaNotaProtix','AgregaNotaprotix1') " & vbCrLf &_
"                group by b.sede_ccod,sede_tdesc, d.epos_ccod, protic.es_nuevo_carrera(c.pers_ncorr,e.carr_ccod,a.peri_ccod)" & vbCrLf  & _
"            ) a " & vbCrLf  & _
"        GROUP BY a.sede_ccod,a.SEDE_TDESC " & vbCrLf  & _
"     ) aa " & vbCrLf  & _
"     left outer join -- segunda tabla del from (B) " & vbCrLf  & _
"    (select b.sede_ccod, sede_tdesc,  count(*) as MATRICULADOS_n " & vbCrLf  & _
"        from ofertas_academicas a " & vbCrLf  & _
"            left outer join sedes b " & vbCrLf  & _
"                on a.sede_ccod =b.sede_ccod " & vbCrLf  & _
"            left outer join alumnos c " & vbCrLf  & _
"                on a.ofer_ncorr =c.ofer_ncorr " & vbCrLf  & _
"            right outer join especialidades d " & vbCrLf  & _
"                on a.espe_ccod = d.espe_ccod " & vbCrLf  & _
" 			join periodos_academicos f "& vbCrLf &_
"    			on a.peri_ccod=f.peri_ccod "& vbCrLf &_
" 			where cast(f.peri_ccod as varchar)= '" & periodo  & "' " & vbCrLf &_
"                and c.emat_ccod in (1,4,8,2)  " & vbCrLf  & _
"			and protic.afecta_estadistica(c.matr_ncorr) > 0 " & vbCrLf  & _
"	        and c.audi_tusuario not in ('Agregabase_saenzBeta2','AgregaBaseSaenzBeta2','AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42'," & vbCrLf  & _
"                   'AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno', " & vbCrLf  & _
"                   'AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65', " & vbCrLf  & _
"                   'AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99','AgregaNotaN', " & vbCrLf  & _
"                   'AgregaNotaProtix','AgregaNotaprotix1','Agreganotas_saenzBeta2','AgregaNotas46$','AgregaNotas46$Beta','AgregaNotas46$Beta2','AgregaNotasSaenzBeta2', " & vbCrLf  & _
"                   'Agregaprotix_saenzBeta2','AgregaProtixSaenzBeta2') " & vbCrLf  & _
" 		 		And c.pers_ncorr > 0 " & vbCrLf &_
"        and protic.es_nuevo_carrera(c.pers_ncorr,d.carr_ccod,a.peri_ccod) = 'S' " & vbCrLf  & _
"        group by b.sede_ccod,sede_tdesc " & vbCrLf  & _
"     ) B on aa.sede_ccod=b.sede_ccod " & vbCrLf  & _
"     left outer join -- tercera tabla del form (bb) " & vbCrLf  & _
"    ( select b.sede_ccod,sede_tdesc,  count(*) as MATRICULADOS_a " & vbCrLf  & _
"        from ofertas_academicas a " & vbCrLf  & _
"            left outer join sedes b " & vbCrLf  & _
"                on a.sede_ccod=b.sede_ccod " & vbCrLf  & _
"            left outer join alumnos c " & vbCrLf  & _
"                on a.ofer_ncorr = c.ofer_ncorr " & vbCrLf  & _
"            right outer join especialidades d " & vbCrLf  & _
"                on a.espe_ccod = d.espe_ccod " & vbCrLf  & _
"        where cast(a.peri_ccod as varchar)= '"&periodo&"' " & vbCrLf  & _
"			and protic.afecta_estadistica(c.matr_ncorr) > 0 " & vbCrLf  & _
"	        and c.audi_tusuario not in ('Agregabase_saenzBeta2','AgregaBaseSaenzBeta2','AgregaNota2T','AgregaNota37','AgregaNota3Nuevo','AgregaNota41','AgregaNota42'," & vbCrLf  & _
"                   'AgregaNota43','AgregaNota45','AgregaNota46','AgregaNota49','AgregaNota491T','AgregaNota492T','AgregaNota4diu2003','AgregaNota4diurno', " & vbCrLf  & _
"                   'AgregaNota4T','AgregaNota4vesp','AgregaNota4vesp2003','AgregaNota52','AgregaNota60','AgregaNota61','AgregaNota64','AgregaNota65', " & vbCrLf  & _
"                   'AgregaNota69','AgregaNota80','AgregaNota81','AgregaNota83','AgregaNota85','AgregaNota88','AgregaNota98','AgregaNota99','AgregaNotaN', " & vbCrLf  & _
"                   'AgregaNotaProtix','AgregaNotaprotix1','Agreganotas_saenzBeta2','AgregaNotas46$','AgregaNotas46$Beta','AgregaNotas46$Beta2','AgregaNotasSaenzBeta2', " & vbCrLf  & _
"                   'Agregaprotix_saenzBeta2','AgregaProtixSaenzBeta2') " & vbCrLf  & _
"                and c.emat_ccod in (1,4,8,2)  " & vbCrLf  & _
" 		 		And c.pers_ncorr > 0 " & vbCrLf &_
"        and protic.es_nuevo_carrera(c.pers_ncorr,d.carr_ccod,a.peri_ccod) = 'N' " & vbCrLf  & _
"        group by b.sede_ccod,sede_tdesc " & vbCrLf  & _
"    ) BB on aa.sede_ccod = bb.sede_ccod " & vbCrLf  & _
"and exists (select 1 from sis_sedes_usuarios x, personas y where x.pers_ncorr=y.pers_ncorr and cast(y.pers_nrut as varchar)= '"&usuario&"' and x.sede_ccod = aa.sede_ccod ) "


'response.Write("<pre>"&consulta&"</pre>")
'response.End()
f_matriculados.Consultar consulta
'f_matriculados.Siguiente


%>


<html>
<head>
<title>Alumnos Matriculados</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
	colores = Array(3);
	colores[0] = '';
	//colores[1] = '#97AAC6';
	//colores[2] = '#C0C0C0';
	colores[1] = '#FFECC6';
	colores[2] = '#FFECC6';
</script>

<style type="text/css">
<!--
.Estilo2 {color: #000000}
.Estilo3 {font-weight: bold}
.Estilo4 {color: #000000; font-weight: bold; }
-->
</style>
</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../__base/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
                <td>
                  <%pagina.DibujarLenguetas Array("Alumnos"), 1 %>
                </td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center">
                    <p align="left">&nbsp; </p>
                    <table width="100%" border="0">
                      <%if RegistrosN>0 then%>
                      <tr> 
                        <td align="center">&nbsp; </td>
                      </tr>
                      <%end if%>
                       <tr> 
                        <td align="center"><strong>
                          <%pagina.DibujarSubtitulo "Gestión Matricula por Sede y Semestre"%>
                          </strong></td>
                      </tr>
                    </table>
                    <form name="edicion">
                      <div align="left">
                        <input name="url" type="hidden" value="<%=request.ServerVariables("HTTP_REFERER")%>">
                      </div>
                      <table width="98%" align="center">
                      	<tr>
                          <td align="center">
                            <div align="left"><strong>Periodo : </strong><%=periodo_tdesc%> </div></td>
                        </tr>
						<tr>
                          <td align="center">
                            <div align="right"> </div></td>
                        </tr>
                        <tr>
                          <td align="center"><table width="630" class="v1" border="1" cellpadding="0" cellspacing="0" borderColor="#999999" bgColor="#adadad">
                              <!--DWLayoutTable-->
                              <tr borderColor="#999999" bgColor="#c4d7ff">
                                <th width="150" rowspan="2" valign="bottom"><FONT color="#333333"><div align="left"><strong>Sede</strong></div></font></th>
                                <th width="141" colspan="3" valign="top"><FONT color="#333333"><div align="center"><strong>EN PROCESO</strong></div></font></th>
                                <th width="141" colspan="3" valign="top"><FONT color="#333333"><div align="center"><strong>ENVIADOS</strong></div></font></th>
                                <th width="141" colspan="3" valign="top"><FONT color="#333333"><div align="center"><strong>MATRICULADOS</strong></div></font></th>
                              </tr>            
							  <tr borderColor="#999999" bgColor="#c4d7ff">
                                <th width="47" height="14"><FONT color="#333333"><div align="center">Nuevos</div></font></th>
                                <th width="47"><FONT color="#333333"><div align="center">Antiguos</div></font></th>
                                <th width="47"><FONT color="#333333"><div align="center">Total</div></font></th>
                                <th width="47"><FONT color="#333333"><div align="center">Nuevos</div></font></th>
                                <th width="47"><FONT color="#333333"><div align="center">Antiguos</div></font></th>
                                <th width="47"><FONT color="#333333"><div align="center"><strong>Total</strong></div></font></th>
                                <th width="47"><FONT color="#333333"><div align="center">Nuevos</div></font></th>
                                <th width="47"><FONT color="#333333"><div align="center">Antiguos</div></font></th>
                                <th width="47"><FONT color="#333333"><div align="center"><strong>Total</strong></div></font></th>
                              </tr>
                            <%'f_matriculados.dibujatabla()
							en_proceso_n_t=0
							en_proceso_a_t=0
							en_proceso_t_t=0
							enviados_n_t=0
							enviados_a_t=0
							enviados_t_t=0
							matriculados_n_t=0
							matriculados_a_t=0
							matriculados_t_t=0
							for nmat = 1 to f_matriculados.nrofilas
								f_matriculados.siguiente
								en_proceso_n_t=en_proceso_n_t+f_matriculados.obtenervalor("en_proceso_n")
								en_proceso_a_t=en_proceso_a_t+f_matriculados.obtenervalor("en_proceso_a")
								en_proceso_t_t=en_proceso_t_t+f_matriculados.obtenervalor("en_proceso_t")
								enviados_n_t=enviados_n_t+f_matriculados.obtenervalor("enviados_n")
								enviados_a_t=enviados_a_t+f_matriculados.obtenervalor("enviados_a")
								enviados_t_t=enviados_t_t+f_matriculados.obtenervalor("enviados_t")
								matriculados_n_t=matriculados_n_t+f_matriculados.obtenervalor("matriculados_n")
								matriculados_a_t=matriculados_a_t+f_matriculados.obtenervalor("matriculados_a")
								matriculados_t_t=matriculados_t_t+f_matriculados.obtenervalor("matriculados_t")
							%>							
							<tr bgcolor="#FFFFFF">
								<td width="47" class='click' onClick='irA("gestion_matricula_x_semestre_1.asp?sede_ccod=<%=f_matriculados.obtenervalor("sede_ccod")%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="left"><%=f_matriculados.obtenervalor("sede_tdesc")%></div></td>
                                <td width="47" class='click' onClick='irA("gestion_matricula_x_semestre_1.asp?sede_ccod=<%=f_matriculados.obtenervalor("sede_ccod")%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="right"><%=f_matriculados.obtenervalor("en_proceso_n")%></div></td>
                                <td width="47" class='click' onClick='irA("gestion_matricula_x_semestre_1.asp?sede_ccod=<%=f_matriculados.obtenervalor("sede_ccod")%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="right"><%=f_matriculados.obtenervalor("en_proceso_a")%></div></td>
                                <td bgcolor="#FFECC6" width="47" class='click' onClick='irA("gestion_matricula_x_semestre_1.asp?sede_ccod=<%=f_matriculados.obtenervalor("sede_ccod")%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="right"><%=f_matriculados.obtenervalor("en_proceso_t")%></div></td>
                                <td width="47" class='click' onClick='irA("gestion_matricula_x_semestre_1.asp?sede_ccod=<%=f_matriculados.obtenervalor("sede_ccod")%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="right"><%=f_matriculados.obtenervalor("enviados_n")%></div></td>
                                <td width="47" class='click' onClick='irA("gestion_matricula_x_semestre_1.asp?sede_ccod=<%=f_matriculados.obtenervalor("sede_ccod")%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="right"><%=f_matriculados.obtenervalor("enviados_a")%></div></td>
                                <td bgcolor="#FFECC6" width="47" class='click' onClick='irA("gestion_matricula_x_semestre_1.asp?sede_ccod=<%=f_matriculados.obtenervalor("sede_ccod")%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="right"><%=f_matriculados.obtenervalor("enviados_t")%></div></td>
                                <td width="47" class='click' onClick='irA("gestion_matricula_x_semestre_1.asp?sede_ccod=<%=f_matriculados.obtenervalor("sede_ccod")%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="right"><%=f_matriculados.obtenervalor("matriculados_n")%></div></td>
                                <td width="47" class='click' onClick='irA("gestion_matricula_x_semestre_1.asp?sede_ccod=<%=f_matriculados.obtenervalor("sede_ccod")%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="right"><%=f_matriculados.obtenervalor("matriculados_a")%></div></td>
                                <td bgcolor="#FFECC6" width="47" class='click' onClick='irA("gestion_matricula_x_semestre_1.asp?sede_ccod=<%=f_matriculados.obtenervalor("sede_ccod")%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="right"><%=f_matriculados.obtenervalor("matriculados_t")%></div></td>
                              </tr>
							<%
							next							
							%>
							<tr bgcolor="#FFFFFF">
								<td width="150" height="14"><div align="right" class="Estilo2"><strong>Total</strong></div></td>
                                <td width="47" height="14"><div align="center" class="Estilo2 Estilo3">
                                  <div align="right"><%=en_proceso_n_t%></div>
                                </div></td>
                                <td width="47"><div align="center" class="Estilo4">
                                  <div align="right"><%=en_proceso_a_t%></div>
                                </div></td>
                                <td bgcolor="#FFECC6" width="47"><div align="center" class="Estilo4">
                                  <div align="right"><%=en_proceso_t_t%></div>
                                </div></td>
                                <td width="47"><div align="center" class="Estilo4">
                                  <div align="right"><%=enviados_n_t%></div>
                                </div></td>
                                <td width="47"><div align="center" class="Estilo4">
                                  <div align="right"><%=enviados_a_t%></div>
                                </div></td>
                                <td bgcolor="#FFECC6" width="47"><div align="center" class="Estilo4">
                                  <div align="right"><%=enviados_t_t%></div>
                                </div></td>
                                <td width="47"><div align="center" class="Estilo4">
                                  <div align="right"><%=matriculados_n_t%></div>
                                </div></td>
                                <td width="47"><div align="center" class="Estilo4">
                                  <div align="right"><%=matriculados_a_t%></div>
                                </div></td>
                                <td bgcolor="#FFECC6" width="47"><div align="center" class="Estilo4">
                                  <div align="right"><%=matriculados_t_t%></div>
                                </div></td>
                              </tr>
                           </table>
						  </td>
                        </tr>
                      </table>
                    </form>
                    <br>
                    <br>
                  </div>
                </td>
              </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="21%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                   <td width="33%"><div align="center">
                            <% botonera.dibujaboton("cancelar") %>
                          </div></td>
                </tr>
              </table>
            </div></td>
            <td width="79%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
