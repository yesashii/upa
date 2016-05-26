<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_carr_ccod = Request.QueryString("busqueda[0][carr_ccod]")
q_carga_alumnos = Request.QueryString("carga_alumnos")
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Predictivo de egreso títulos y grados"


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
f_botonera.Carga_Parametros "predictivo_tit_grados.xml", "botonera"

'---------------------------------------------------------------------------------------------------
 pers_ncorr_usuario = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar) = '"&negocio.obtenerUsuario&"'")
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "predictivo_tit_grados.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 
 c_carreras = "(select Distinct a.carr_ccod,a.carr_tdesc "& vbCrLf & _
			  " from carreras a, salidas_carrera b "& vbCrLf & _
			  "	where a.carr_ccod = b.carr_ccod "& vbCrLf & _
			  "	and exists (select 1 from especialidades esp, sis_especialidades_usuario seu "& vbCrLf & _
			  "				where esp.espe_ccod = seu.espe_ccod and esp.carr_ccod=a.carr_ccod "& vbCrLf & _
			  "				and cast(seu.pers_ncorr as varchar)='"&pers_ncorr_usuario&"'))a"
 
 f_busqueda.Agregacampoparam "carr_ccod", "destino" , c_carreras
 f_busqueda.AgregaCampoCons "carr_ccod", q_carr_ccod 
 f_busqueda.Siguiente
 
 c_anos = " select max(b.anos_ccod) from actividades_periodos a, periodos_academicos b "&_
          " where a.tape_ccod=7 and a.peri_ccod=b.peri_ccod and b.anos_ccod <= datepart(year, getDate()) "
 anos = conexion.consultaUno(c_anos)
'---------------------------------------------------------------------------------------------------
SQL = " select carr_tdesc from carreras where carr_ccod='" & q_carr_ccod & "'"
carrera = conexion.consultaUno(SQL)

if q_carr_ccod <> "" then
	set f_candidatos = new CFormulario
	f_candidatos.Carga_Parametros "predictivo_tit_grados.xml", "candidatos"
	f_candidatos.Inicializar conexion
	
	c_candidatos = " select sede, jornada,pers_ncorr,      "& vbCrLf & _
				   " rut, ap_paterno + ' ' + ap_materno + ' ' + nombres as nombre_completo,    "& vbCrLf & _
				   " ano_ingreso_carrera, ultimo_estado, ultimo_periodo, ultimo_plan  as plan_ccod,'"&q_carr_ccod&"' as carr_ccod, "& vbCrLf & _
				   " isnull((select case isnull(tt.CEGR_NVB_ESCUELA,'0') when '0' then '' else 'SI' end from CANDIDATOS_EGRESO tt where tt.pers_ncorr=table1.pers_ncorr and tt.plan_ccod=table1.ultimo_plan and tt.carr_ccod='"&q_carr_ccod&"'),'') as V_B_Escuela, "& vbCrLf & _
				   " isnull((select case isnull(tt.CEGR_NVB_TITULOS,'0') when '0' then '' when '3' then 'NO' else 'SI' end from CANDIDATOS_EGRESO tt where tt.pers_ncorr=table1.pers_ncorr and tt.plan_ccod=table1.ultimo_plan and tt.carr_ccod='"&q_carr_ccod&"'),'') as V_B_Titulos, "& vbCrLf & _
				   " isnull((select cast(isnull(CEGR_NTOTAL_REINTENTOS,0) as varchar) + ' / ' + cast(isnull(CEGR_NTOTAL_RECHAZOS,0) as varchar) from CANDIDATOS_EGRESO tt where tt.pers_ncorr=table1.pers_ncorr and tt.plan_ccod=table1.ultimo_plan and tt.carr_ccod='"&q_carr_ccod&"'),' ') as reenvios_rechazos "& vbCrLf & _
				   " from    "& vbCrLf & _
				   " (    "& vbCrLf & _
				   "   select distinct sede_tdesc as sede, jorn_tdesc as jornada,    "& vbCrLf & _
				   "   g.pers_ncorr,cast(g.pers_nrut as varchar)+'-'+g.pers_xdv as rut, g.pers_tnombre as nombres,   "& vbCrLf & _ 
				   "   g.pers_tape_paterno as ap_paterno, g.pers_tape_materno as ap_materno,    "& vbCrLf & _
				   "   protic.ano_ingreso_carrera_egresa2(a.pers_ncorr,e.carr_ccod) as ano_ingreso_carrera,      "& vbCrLf & _
				   "  (select top 1 emat_tdesc    "& vbCrLf & _
				   "   from alumnos tt (nolock), ofertas_academicas t2,  "& vbCrLf & _ 
				   "        especialidades t3, estados_matriculas t4    "& vbCrLf & _
				   "   where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod    "& vbCrLf & _
				   "   and tt.pers_ncorr=a.pers_ncorr and t3.carr_ccod=e.carr_ccod  "& vbCrLf & _
				   "   and tt.emat_ccod=t4.emat_ccod    "& vbCrLf & _
				   "   order by t2.peri_ccod desc, tt.audi_tusuario desc) as ultimo_estado,    "& vbCrLf & _
				   "  (select top 1 peri_tdesc    "& vbCrLf & _
				   "   from alumnos tt (nolock), ofertas_academicas t2,  "& vbCrLf & _
				   "   	    especialidades t3, periodos_academicos t4    "& vbCrLf & _
				   "   where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod    "& vbCrLf & _
				   "	 and tt.pers_ncorr=a.pers_ncorr and t3.carr_ccod=e.carr_ccod  "& vbCrLf & _
				   "	 and t2.peri_ccod=t4.peri_ccod    "& vbCrLf & _
				   "     order by t2.peri_ccod desc, tt.audi_tusuario desc) as ultimo_periodo,   "& vbCrLf & _  
				   "  (select top 1 tt.plan_ccod    "& vbCrLf & _
				   "   from alumnos tt (nolock), ofertas_academicas t2,  "& vbCrLf & _ 
				   "        especialidades t3, estados_matriculas t4    "& vbCrLf & _
				   "   where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod    "& vbCrLf & _
				   "   and tt.pers_ncorr=a.pers_ncorr and t3.carr_ccod=e.carr_ccod  "& vbCrLf & _
				   "   and tt.emat_ccod=t4.emat_ccod    "& vbCrLf & _
				   "   order by t2.peri_ccod desc, tt.audi_tusuario desc) as ultimo_plan    "& vbCrLf & _    
				   " from alumnos a (nolock), ofertas_academicas b, sedes c, especialidades d,  "& vbCrLf & _
				   "      carreras e, jornadas f, personas g  (nolock), periodos_academicos h   "& vbCrLf & _
				   " where a.ofer_ncorr=b.ofer_ncorr and b.sede_ccod=c.sede_ccod    "& vbCrLf & _
				   " and b.espe_ccod=d.espe_ccod and d.carr_ccod=e.carr_ccod    "& vbCrLf & _
				   " and b.jorn_ccod=f.jorn_ccod    "& vbCrLf & _
				   " and a.pers_ncorr=g.pers_ncorr and b.peri_ccod = h.peri_ccod   "& vbCrLf & _
				   " and (select count(*)  "& vbCrLf & _  
				   "      from alumnos tt (nolock), ofertas_academicas t2, especialidades t3    "& vbCrLf & _
				   "      where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod    "& vbCrLf & _
				   "      and tt.pers_ncorr=a.pers_ncorr and t3.carr_ccod=e.carr_ccod    "& vbCrLf & _ 
				   "  	  and tt.emat_ccod = 1 and isnull(tt.alum_nmatricula,0) <> 7777 ) >= 2    "& vbCrLf & _
				   " and not exists(select 1    "& vbCrLf & _
				   " 			    from alumnos tt (nolock), ofertas_academicas t2, especialidades t3    "& vbCrLf & _
				   "  			    where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod    "& vbCrLf & _
				   "			    and tt.pers_ncorr=a.pers_ncorr and t3.carr_ccod=e.carr_ccod     "& vbCrLf & _
				   "				and tt.emat_ccod in (4,8))      "& vbCrLf & _        
				   " and cast(d.carr_ccod as varchar)='"&q_carr_ccod&"'    "& vbCrLf & _
				   " )table1   "& vbCrLf & _ 
				   " where protic.PREDICTIVO_EGRESO_TGRADOS(table1.pers_ncorr,'"&q_carr_ccod&"',table1.ultimo_plan,"&anos&") = 1  "& vbCrLf & _ 
				   " order by sede, jornada, nombre_completo asc"
	'response.Write("<pre>"&c_candidatos&"</pre>")
	f_candidatos.Consultar c_candidatos
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
	function enviar(formulario)
	{
         document.getElementById("texto_alerta").style.visibility="visible";
		 formulario.elements["carga_alumnos"].value = "1";
		 formulario.submit();
	}
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
						 <td colspan="3" align="right">
							<%f_botonera.DibujaBoton "buscar_alumnos"%>
						 </td>
					  </tr>
					  <tr>
						   <td  colspan="3" align="center">
								  <div  align="right" id="texto_alerta" style="visibility: hidden;"><font color="#0000FF" size="-1">Espere 
									  un momento mientras se realiza la busqueda...</font>
								  </div>
						   </td>
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
	<%if q_carr_ccod <> "" then%>
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
            <td><%pagina.DibujarLenguetas Array("Predictivo egreso"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
              <br>
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
                <br>
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
				  <td><div align="center"><% if q_carr_ccod <> "" and periodo_activo <> "0"  then
				                                   f_botonera.agregabotonparam "excel", "url","predictivo_tit_grados_excel.asp?carr_ccod="&q_carr_ccod
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
	<%END IF%>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
