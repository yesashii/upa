<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_carr_ccod = Request.QueryString("busqueda[0][carr_ccod]")
q_carga_alumnos = Request.QueryString("carga_alumnos")
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Candidatos a egreso por escuela"


'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores = new CErrores

'---------------------------------------------------------------------------------------------------
v_sede_ccod = negocio.ObtenerSede
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "vistos_buenos_egresados.xml", "botonera"

'---------------------------------------------------------------------------------------------------
 pers_ncorr_usuario = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar) = '"&negocio.obtenerUsuario&"'")
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "vistos_buenos_egresados.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 
 c_carreras = "(select Distinct a.carr_ccod,a.carr_tdesc "& vbCrLf & _
			  " 	from carreras a, salidas_carrera b "& vbCrLf & _
			  "		where a.carr_ccod = b.carr_ccod "& vbCrLf & _
			  "		and exists (select 1 from candidatos_egreso ce where ce.carr_ccod=a.carr_ccod) "& vbCrLf & _
			  "	)a"
 
 f_busqueda.Agregacampoparam "carr_ccod", "destino" , c_carreras
 f_busqueda.AgregaCampoCons "carr_ccod", q_carr_ccod 
 f_busqueda.Siguiente

'---------------------------------------------------------------------------------------------------
SQL = " select carr_tdesc from carreras where carr_ccod='" & q_carr_ccod & "'"
carrera = conexion.consultaUno(SQL)

	set f_candidatos = new CFormulario
	f_candidatos.Carga_Parametros "vistos_buenos_egresados.xml", "candidatos"
	f_candidatos.Inicializar conexion
	
	c_candidatos = " select cast(b.pers_nrut as varchar)+'-'+pers_xdv as Rut,  "& vbCrLf & _
				   "  pers_tape_paterno + ' ' + pers_tape_materno + ', ' + pers_tnombre as Nombre_completo,  "& vbCrLf & _
				   "  c.plan_tdesc as plan_,protic.trunc(cegr_fsolicitud) as fecha_solicitud,  "& vbCrLf & _
				   "  case isnull(cegr_nvb_escuela,0) when 0 then 'NO' else 'SI' end as vb_escuela, "& vbCrLf & _
				   "  case isnull(cegr_nvb_titulos,0) when 0 then ' ' when 3 then 'NO' else 'SI' end as vb_titulos, a.plan_ccod, a.carr_ccod,a.pers_ncorr, "& vbCrLf & _
				   "  cast(isnull(CEGR_NTOTAL_REINTENTOS,0) as varchar) + ' / ' + cast(isnull(CEGR_NTOTAL_RECHAZOS,0) as varchar) as reenvios_rechazos "& vbCrLf & _
				   "  from candidatos_egreso a, personas b, planes_estudio c "& vbCrLf & _
				   "  where a.pers_ncorr=b.pers_ncorr  "& vbCrLf & _
				   "  and a.plan_ccod=c.plan_ccod and cast(a.carr_ccod as varchar)='"&q_carr_ccod&"'"& vbCrLf & _
				   "  and not exists (select 1 from alumnos tt where tt.pers_ncorr=a.pers_ncorr and tt.plan_ccod=a.plan_ccod and tt.emat_ccod = 4) "& vbCrLf & _
				   "  order by pers_tape_paterno, pers_tape_materno, pers_tnombre "
	'response.Write("<pre>"&c_candidatos&"</pre>")
	f_candidatos.Consultar c_candidatos
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
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
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
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
			    <input type="hidden" name="carga_alumnos" value="">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="100%"><div align="center">
                    <table width="98%"  border="0">
                      <tr>
                        <td width="13%"><strong>Carrera</strong></td>
                        <td width="2%"><strong>:</strong></td>
                        <td width="85%"><% f_busqueda.dibujaCampo ("carr_ccod") %></td>
                      </tr>
					  <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td align="right"><%f_botonera.DibujaBoton "buscar"%></td>
                      </tr>
                    </table>
                  </div></td>
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
            <td><%pagina.DibujarLenguetas Array("Candidatos a egreso"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%></br>
              </br>
              <table width="98%"  border="0">
                  <tr>
                        <td width="13%"><strong>Carrera</strong></td>
                        <td width="2%"><strong>:</strong></td>
                        <td width="85%"><%=carrera%></td>
                  </tr>
              </table>
                </div>
              <form name="edicion" method="get">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  	     <tr>
							 <td align="center">&nbsp;</td>
						  </tr>
						  <tr>
							<td align="center"><%pagina.DibujarSubtitulo "Candidatos a egreso de escuela"%>
							  <table width="98%"  border="0" align="center">
								<tr>
								  <td scope="col"><div align="center"><%f_candidatos.DibujaTabla%></div></td>
								</tr>
							  </table>
							</td>
						  </tr>
                </table>
                  </br>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28">
		<table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="20%" height="20">
			<div align="center">
              <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                <form name="form_excel" target="_blank" action="predictivo_dir_escuela_excel.asp" method="get">
					<input type="hidden" name="carr_ccod" value="<%=q_carr_ccod%>">
				</form>
				<tr>
                  <td><div align="center"><%f_botonera.DibujaBoton "salir"%></div></td>
				  <td><div align="center"><% if q_carr_ccod <> "" then
				                                   f_botonera.agregabotonparam "excel", "url","vistos_buenos_egresados_excel.asp?carr_ccod="&q_carr_ccod
				                                   f_botonera.DibujaBoton "excel"
										     end if%></div></td>
                </tr>
              </table>
            </div>
			</td>
            <td width="80%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	</br>
	</br>
	</td>
  </tr>  
</table>
</body>
</html>
