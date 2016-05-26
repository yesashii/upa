<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.queryString
'	response.Write(k&" = "&request.querystring(k)&"<br>")
'next
saca_ncorr = Request.QueryString("saca_ncorr")
pers_ncorr = Request.QueryString("pers_ncorr")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Documentos Entregados a Títulos y Grados"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_salida = new CFormulario
f_salida.Carga_Parametros "expediente_titulacion.xml", "salida"
f_salida.Inicializar conexion

SQL = " select b.pers_ncorr,a.saca_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_nrut, b.pers_xdv,  "& vbCrLf &_
      " b.pers_tnombre + ' ' + b.pers_tape_paterno + ' ' + b.pers_tape_materno as alumno, "& vbCrLf &_
	  " a.saca_tdesc as salida, c.tsca_ccod,case c.tsca_ccod when 1 then '<font color=#073299><strong>' "& vbCrLf &_ 
      "            when 2 then '<font color=#004000><strong>' "& vbCrLf &_ 
  	  " 		   when 3 then '<font color=#b76d05><strong>' "& vbCrLf &_ 
	  "			   when 4 then '<font color=#714e9c><strong>' "& vbCrLf &_ 
	  " 		   when 5 then '<font color=#ab2b05><strong>' "& vbCrLf &_ 
	  "  		   when 6 then '<font color=#0078c0><strong>' end + c.tsca_tdesc + '</strong></font>' as tipo_salida, d.carr_ccod, d.carr_tdesc, "& vbCrLf &_
      "    (select top 1 sede_ccod from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod order by t2.peri_ccod desc) as sede_ccod, "& vbCrLf &_
      "    (select top 1 sede_tdesc from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            INNER JOIN sedes t4 "& vbCrLf &_
      "            ON t2.sede_ccod = t4.sede_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod order by t2.peri_ccod desc) as sede_tdesc, "& vbCrLf &_
      "    (select top 1 jorn_tdesc from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            INNER JOIN jornadas t4 "& vbCrLf &_
      "            ON t2.jorn_ccod = t4.jorn_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod order by t2.peri_ccod desc) as jorn_tdesc, "& vbCrLf &_
      "    (select top 1 peri_ccod from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (4,8) "& vbCrLf &_
      "            order by t2.peri_ccod desc) as peri_ccod, "& vbCrLf &_
      "    (select top 1 peri_tdesc from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod=t3.espe_ccod "& vbCrLf &_
      "            INNER JOIN periodos_academicos t4 "& vbCrLf &_
      "            ON t2.peri_ccod = t4.peri_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (4,8) "& vbCrLf &_
      "            order by t2.peri_ccod desc) as peri_tdesc, "& vbCrLf &_
      "    (select case count(*) when 0 then 'N' else 'S' end  from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod=t3.espe_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (4)) as egresado, "& vbCrLf &_
      "    (select case count(*) when 0 then 'N' else 'S' end  from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (8)) as titulado, "& vbCrLf &_
      "    (select top 1 t1.plan_ccod  from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (4) order by peri_ccod desc ) as plan_ccod, "& vbCrLf &_
      " asca_ncorr, protic.trunc(asca_fsalida) as asca_fsalida, asca_nfolio, asca_nregistro, replace(cast(asca_nnota as decimal(2,1)),',','.') as asca_nnota, ' '  as asca_bingr_manual, "& vbCrLf &_
      "    (select max(peri_ccod) "& vbCrLf &_
      "			from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "			ON t1.pers_ncorr = b.pers_ncorr "& vbCrLf &_
      "			INNER JOIN especialidades t3 "& vbCrLf &_
      "			ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "			WHERE t2.espe_ccod = t3.espe_ccod and t3.carr_ccod = d.carr_ccod and isnull(t1.emat_ccod,0) <> 9) as ultimo_periodo "& vbCrLf &_
      " from salidas_carrera a INNER JOIN personas b "& vbCrLf &_
      " ON cast(b.pers_ncorr as varchar)='"&pers_ncorr&"' and cast(a.saca_ncorr as varchar)='"&saca_ncorr&"' "& vbCrLf &_
      " INNER JOIN tipos_salidas_carrera c "& vbCrLf &_
      " ON a.tsca_ccod=c.tsca_ccod "& vbCrLf &_
      " INNER JOIN  carreras d "& vbCrLf &_
      " ON a.carr_ccod=d.carr_ccod "& vbCrLf &_
      " LEFT OUTER JOIN alumnos_salidas_carrera e "& vbCrLf &_
      " ON a.saca_ncorr = e.saca_ncorr and b.pers_ncorr = e.pers_ncorr" 

f_salida.Consultar SQL
f_salida.Siguiente
plan_ccod = f_salida.obtenerValor("plan_ccod")
ultimo_periodo = f_salida.obtenerValor("ultimo_periodo")



q_plan_ccod  = plan_ccod
q_peri_ccod  = ultimo_periodo
q_pers_nrut = conexion.consultaUno("Select pers_nrut from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
q_pers_xdv  = conexion.consultaUno("Select pers_xdv from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "expediente_titulacion.xml", "botonera"
'---------------------------------------------------------------------------------------------------
set f_requerimientos = new CFormulario
f_requerimientos.Carga_Parametros "expediente_titulacion.xml", "requerimientos_titulacion"
f_requerimientos.Inicializar conexion

SQL = " select ACADEMICA,FINANCIERA,BIBLIOTECA,AUDIOVISUAL,LICENCIA_EM,CONCENTRACION_EM,PAA_PSU,CEDULA_DI,CERTIFICADO_TG,CONCENTRACION_NU,CURRICULUM_VITAE,  " & vbCrLf & _
      " MALLA_CURRICULAR,CEDULA_DI as CEDULA_DI2  " & vbCrLf & _
	  " from requerimientos_titulacion " & vbCrLf & _
	  " where cast(pers_ncorr as varchar)= '"&pers_ncorr&"' "

f_requerimientos.Consultar SQL
f_requerimientos.SiguienteF

'---------------------------------------------------------------------------------------------------
set f_titulado = new CFormulario
f_titulado.Carga_Parametros "expediente_titulacion.xml", "encabezado_de"
f_titulado.Inicializar conexion

v_sede_ccod = conexion.consultaUno("select top 1 sede_ccod from personas a, alumnos b, ofertas_academicas c where cast(a.pers_nrut as varchar)='"&q_pers_nrut&"' and a.pers_ncorr=b.pers_ncorr and cast(b.plan_Ccod as varchar)='"&q_plan_ccod&"' and b.ofer_ncorr=c.ofer_ncorr order by peri_ccod desc")

SQL = " select f.sede_ccod, a.pers_ncorr, b.plan_ccod, c.espe_ccod, e.peri_ccod, d.carr_tdesc, c.espe_tdesc, e.peri_tdesc, f.sede_tdesc, plan_tdesc as plan_ncorrelativo, protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre " & vbCrLf & _
	  " from personas a, planes_estudio b, especialidades c, carreras d, periodos_academicos e, sedes f " & vbCrLf & _
	  " where b.espe_ccod = c.espe_ccod " & vbCrLf & _
	  "   and c.carr_ccod = d.carr_ccod " & vbCrLf & _
	  "   and cast(f.sede_ccod as varchar)= '" & v_sede_ccod & "' " & vbCrLf & _
	  "   and cast(e.peri_ccod as varchar)= '" & q_peri_ccod & "' " & vbCrLf & _
	  "   and cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "' " & vbCrLf & _
	  "   and cast(b.plan_ccod as varchar)= '" & q_plan_ccod & "'"

f_titulado.Consultar SQL
f_titulado.SiguienteF
v_sede_ccod = f_titulado.obtenerValor("sede_ccod")


'---------------------------------------------------------------------------------------------------
f_botonera.AgregaBotonUrlParam "siguiente", "pers_nrut", q_pers_nrut
f_botonera.AgregaBotonUrlParam "siguiente", "pers_xdv", q_pers_xdv
'---------------------------------------------------------------------------------------------------

'---------------------------------------------------------------------------------------------------
url_leng_0 = "exp_tit_mensajes.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_1 = "exp_tit_datos_personales.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_2 = "exp_tit_doctos_entregados.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_3 = "exp_tit_historico_notas.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_4 = "exp_tit_practica.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_5 = "exp_tit_egreso.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_6 = "exp_tit_salida.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_7 = "exp_tit_titulo.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_8 = "exp_tit_concentracion.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr

'---------------------------------------------------------------------------------------------------
carr_param = conexion.consultaUno("select carr_ccod from salidas_carrera where cast(saca_ncorr as varchar)='"&saca_ncorr&"'")
permiso_escuela = conexion.consultaUno("select isnull((select isnull(peca_dat_personal,'0') from permisos_evt_carrera where carr_ccod='"&carr_param&"'),'0')")


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


var t_datos;
var o_pers_nrut;
var flag;





function dBlur()
{
	flag = 1;
}


function InicioPagina()
{
	t_datos = new CTabla("dp");
	
	flag = 0;
}

</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); InicioPagina();" onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td align="right" valign="top" bgcolor="#EAEAEA">	  <br>
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
            <td><%pagina.DibujarLenguetasFClaro Array(Array("Mensajes", url_leng_0), Array("Datos Pers.", url_leng_1), Array("Docs Alumno", url_leng_2),Array("Hist. Notas", url_leng_3), Array("Práctica prof.", url_leng_4), Array("Datos Egreso", url_leng_5),Array("Reg. Salida", url_leng_6), Array("Tesis y comisión", url_leng_7), Array("Conc. Notas", url_leng_8)), 3%></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
			   <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr> 
                      <td>
                        <table width="98%"  border="0" align="center">
                          <tr> 
                            <td>
							  <div align="center">
                                <%f_titulado.DibujaRegistro%>
                              </div>
							</td>
                          </tr>
                        </table></td>
                  </tr>
				  <tr>
                    <td>
					  <%pagina.DibujarSubtitulo "Documentos presentados por el alumno"%>
                      <table width="98%"  border="1" align="center">
                        <tr>
                          <td width="20%" align="center">SITUACIÓN</td>
						  <td colspan="2" align="center">
						  	<table width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td colspan="2" align="center">DOCUMENTOS DE ADMISIÓN</td>
								</tr>
								<tr>
									<td width="50%" align="center">PREGRADO</td>
									<td width="50%" align="center">LICENCIATURA Y/O MAGISTER</td>
								</tr>
							</table>
						  </td>
                        </tr>
						<tr valign="top">
                          <td width="20%" align="center">
						  	<table width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td width="5%">&nbsp;</td>
									<td width="80%">ACADEMICA</td>
									<td width="10%"><%f_requerimientos.dibujaCampo("ACADEMICA")%></td>
									<td width="5%">&nbsp;</td>
								</tr>
								<tr>
									<td width="5%">&nbsp;</td>
									<td width="80%">FINANCIERA</td>
									<td width="10%"><%f_requerimientos.dibujaCampo("FINANCIERA")%></td>
									<td width="5%">&nbsp;</td>
								</tr>
								<tr>
									<td width="5%">&nbsp;</td>
									<td width="80%">BIBLIOTECA</td>
									<td width="10%"><%f_requerimientos.dibujaCampo("BIBLIOTECA")%></td>
									<td width="5%">&nbsp;</td>
								</tr>
								<tr>
									<td width="5%">&nbsp;</td>
									<td width="80%">AUDIOVISUAL</td>
									<td width="10%"><%f_requerimientos.dibujaCampo("AUDIOVISUAL")%></td>
									<td width="5%">&nbsp;</td>
								</tr>
							</table>
						  </td>
						  <td colspan="2" align="center">
						  	<table width="100%" cellpadding="0" cellspacing="0">
								<tr valign="top">
									<td width="50%" align="center">
										<table width="100%" cellpadding="0" cellspacing="0">
											<tr>
												<td width="5%">&nbsp;</td>
												<td width="80%">LICENCIA ENSEÑANZA MEDIA</td>
												<td width="10%"><%f_requerimientos.dibujaCampo("LICENCIA_EM")%></td>
												<td width="5%">&nbsp;</td>
											</tr>
											<tr>
												<td width="5%">&nbsp;</td>
												<td width="80%">CONCENTRACION NOTAS E.MEDIA</td>
												<td width="10%"><%f_requerimientos.dibujaCampo("CONCENTRACION_EM")%></td>
												<td width="5%">&nbsp;</td>
											</tr>
											<tr>
												<td width="5%">&nbsp;</td>
												<td width="80%">PAA - PSU</td>
												<td width="10%"><%f_requerimientos.dibujaCampo("PAA_PSU")%></td>
												<td width="5%">&nbsp;</td>
											</tr>
											<tr>
												<td width="5%">&nbsp;</td>
												<td width="80%">CEDULA DE IDENTIDAD</td>
												<td width="10%"><%f_requerimientos.dibujaCampo("CEDULA_DI")%></td>
												<td width="5%">&nbsp;</td>
											</tr>
										</table>
									</td>
									<td width="50%" align="center">
										<table width="100%" cellpadding="0" cellspacing="0">
											<tr>
												<td width="5%">&nbsp;</td>
												<td width="80%">CERTIFICADO DE TÍTULO Y/O G. ACAD.</td>
												<td width="10%"><%f_requerimientos.dibujaCampo("CERTIFICADO_TG")%></td>
												<td width="5%">&nbsp;</td>
											</tr>
											<tr>
												<td width="5%">&nbsp;</td>
												<td width="80%">CONCENTRACION NOTAS UNIVERSIDAD</td>
												<td width="10%"><%f_requerimientos.dibujaCampo("CONCENTRACION_NU")%></td>
												<td width="5%">&nbsp;</td>
											</tr>
											<tr>
												<td width="5%">&nbsp;</td>
												<td width="80%">CURRICULUM VITAE</td>
												<td width="10%"><%f_requerimientos.dibujaCampo("CURRICULUM_VITAE")%></td>
												<td width="5%">&nbsp;</td>
											</tr>
											<tr>
												<td width="5%">&nbsp;</td>
												<td width="80%">MALLA CURRICULAR</td>
												<td width="10%"><%f_requerimientos.dibujaCampo("MALLA_CURRICULAR")%></td>
												<td width="5%">&nbsp;</td>
											</tr>
											<tr>
												<td width="5%">&nbsp;</td>
												<td width="80%">CEDULA DE IDENTIDAD</td>
												<td width="10%"><%f_requerimientos.dibujaCampo("CEDULA_DI2")%></td>
												<td width="5%">&nbsp;</td>
											</tr>
										</table>									
									</td>
								</tr>
							</table>
						  </td>
                        </tr>
                      </table></td>
                  </tr>
				  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <% if permiso_escuela = "0" then%>
				  <tr>
                    <td align="center"><font color="#8A0808">LA  ESCUELA NO POSEE PERMISOS DE INGRESO O EDICIÓN DE DATOS</font></td>
                  </tr>
				  <%end if%>
				  <tr>
                    <td>&nbsp;</td>
                  </tr>
	           </table>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="23%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%if permiso_escuela = "0" then
				                                f_botonera.AgregaBotonParam "guardar_doc" , "deshabilitado" , "true"
											 end if
											 f_botonera.DibujaBoton "guardar_doc"%></div></td>
                  <td><div align="center"><%f_botonera.DibujaBoton "cerrar"%></div></td>
                </tr>
              </table>
            </div></td>
            <td width="77%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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

