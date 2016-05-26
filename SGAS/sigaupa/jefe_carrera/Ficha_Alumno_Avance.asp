<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
 rut_alumno = request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito = request.querystring("busqueda[0][pers_xdv]")
 
set pagina = new CPagina
pagina.Titulo = "Avance Curricular"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'---------------------------------------------------------------------------------------------------

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "Ficha_Alumno.xml", "busqueda_alumno"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' "
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut_alumno
 f_busqueda.AgregaCampoCons "pers_xdv", rut_alumno_digito
'-----------------------------------------------------------------------------------------
 set botonera = new CFormulario
 botonera.Carga_Parametros "Ficha_Alumno.xml", "botonera"
 '-----------------------------------------------------------------------------------------

 set f_alumno = new CFormulario
 f_alumno.Carga_Parametros "parametros.xml", "tabla"
 f_alumno.Inicializar conexion
 
sql =  "select protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_alumno, f.carr_tdesc, e.espe_tdesc, g.peri_ccod, g.peri_tdesc as periodo "& vbCrLf &_
			"from personas a, postulantes b, alumnos c, ofertas_academicas d, especialidades e, carreras f, periodos_academicos g "& vbCrLf &_
			"where a.pers_ncorr = b.pers_ncorr "& vbCrLf &_
			"  and b.post_ncorr = c.post_ncorr "& vbCrLf &_
			"  and c.emat_ccod <> 9 "& vbCrLf &_
			"  and c.ofer_ncorr = d.ofer_ncorr "& vbCrLf &_
			"  and d.espe_ccod = e.espe_ccod "& vbCrLf &_
			"  and e.carr_ccod = f.carr_ccod "& vbCrLf &_
			"  and b.peri_ccod = g.peri_ccod "& vbCrLf &_
			"  and cast(a.pers_nrut as varchar) = '" & rut_alumno & "' "& vbCrLf &_
			"order by  b.peri_ccod DESC "& vbCrLf

  if Request.QueryString <> "" then
	 f_alumno.consultar sql
     f_alumno.siguiente
	 alumno = f_alumno.Obtenervalor ("nombre_alumno")	 
  else
	f_alumno.consultar "select '' where 1 = 2"
  end if
 
 '-----------------------------------------------------------------------------------------

 set f_datos = new CFormulario
 f_datos.Carga_Parametros "parametros.xml", "tabla"
 f_datos.Inicializar conexion

	    sql =   "SELECT DISTINCT max(f.plan_ncorrelativo), c.carr_ccod,	c.carr_tdesc,d.espe_ccod,d.espe_tdesc,  f.plan_ccod, f.plan_ncorrelativo,peri_ccod   "& vbCrLf &_
				"FROM  alumnos a, ofertas_academicas b, carreras c, especialidades d, personas e, planes_estudio f     "& vbCrLf &_
				"WHERE a.ofer_ncorr = b.ofer_ncorr     "& vbCrLf &_
				"	AND c.carr_ccod = d.carr_ccod     "& vbCrLf &_
			    "	AND d.espe_ccod = b.espe_ccod     "& vbCrLf &_
				"	AND a.pers_ncorr = e.pers_ncorr   "& vbCrLf &_
				"	AND d.espe_ccod = f.espe_ccod   "& vbCrLf &_
				"	AND a.plan_ccod = f.plan_ccod   "& vbCrLf &_
				"	AND a.emat_ccod = 1  "& vbCrLf &_
				"	AND f.epes_ccod = 1  "& vbCrLf &_
				"	AND cast(e.pers_nrut as varchar) = '" & rut_alumno & "' "& vbCrLf &_
				"GROUP BY c.carr_ccod, c.carr_tdesc,d.espe_ccod,d.espe_tdesc,  f.plan_ccod, f.plan_ncorrelativo,peri_ccod  order by  peri_ccod desc"& vbCrLf

if alumno <> "" then
   f_datos.consultar sql
   f_datos.siguiente
   plan = f_datos.obtenerValor("plan_ccod")
   especialidad = f_datos.obtenerValor("espe_ccod")
   carrera = f_datos.obtenerValor("carr_ccod")
end if
'--------------------------------------------------------------------------------------
if plan <> "" then
  set historico	=	new cHistoricoNotas
  historico.inicializar	conexion, rut_alumno, plan, especialidad, carrera
end if


'--------------------------------------------------------------------------------

pers_ncorr	=	conexion.consultauno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"& rut_alumno &"'")
	 
peri_ccod	=	conexion.consultauno("select max(b.peri_ccod)  " & vbcrlf & _
									"	from alumnos a, ofertas_academicas b  " & vbcrlf & _
									"	where cast(a.pers_ncorr as varchar)='" & pers_ncorr &"' and a.emat_ccod=1 " & vbcrlf & _
									"	and a.ofer_ncorr = b.ofer_ncorr ")
										
matr_ncorr	= conexion.consultauno("	select matr_ncorr from alumnos a, ofertas_academicas b  " & vbcrlf & _
								"		where a.ofer_ncorr=b.ofer_ncorr and cast(b.peri_ccod as varchar)='" & peri_ccod &"'  " & vbcrlf & _
								"		and a.emat_ccod=1 and cast(a.pers_ncorr as varchar)='" & pers_ncorr &"'")

set resumen_he		=	new CFormulario

resumen_he.carga_parametros		"historico.xml","resumen"		
resumen_he.inicializar			conexion

tabla_resumen=" SELECT c.reho_ncorr,cast(e.asig_ccod as varchar)+' - '+ e.asig_tdesc AS asignatura_origen," & vbcrlf &_ 
       			" cast(a.asig_ccod as varchar)+' - '+ a.asig_tdesc AS asignatura_destino,cast(f.carg_nnota_final as varchar) as nota " & vbcrlf &_
				"  FROM asignaturas a, " & vbcrlf &_
				"       secciones b, " & vbcrlf &_
				"       resoluciones_homologaciones c, " & vbcrlf &_
				"       secciones d, " & vbcrlf &_
				"       asignaturas e " & vbcrlf &_
				"       ,cargas_academicas f " & vbcrlf &_
				"       ,cargas_academicas g " & vbcrlf &_
				"       ,ALUMNOS h " & vbcrlf &_
				"       ,personas i " & vbcrlf &_
				" WHERE b.secc_ccod = c.secc_ccod_destino " & vbcrlf &_
				"   AND d.secc_ccod = c.secc_ccod_origen " & vbcrlf &_
				"   AND e.asig_ccod = d.asig_ccod " & vbcrlf &_
				"   AND a.asig_ccod = b.asig_ccod " & vbcrlf &_
				"   and f.secc_ccod = d.secc_ccod " & vbcrlf &_
				"  and f.secc_ccod = c.secc_ccod_origen " & vbcrlf &_
				"   and g.secc_ccod = b.secc_ccod " & vbcrlf &_
				"   and g.secc_ccod = c.secc_ccod_destino " & vbcrlf &_
				"   and c.matr_ncorr_origen=f.matr_ncorr " & vbcrlf &_
				"   and c.matr_ncorr_destino=g.matr_ncorr " & vbcrlf &_
				"   and g.matr_ncorr=h.matr_ncorr " & vbcrlf &_
				"   and h.pers_ncorr=i.pers_ncorr " & vbcrlf &_
				"   and cast(h.matr_ncorr as varchar)='" & matr_ncorr & "' " & vbcrlf &_
				"union " & vbcrlf &_
				"	select " & vbcrlf &_
				"		  c.secc_ccod,cast(i.asig_ccod as varchar)+' '+i.asig_tdesc as asignatura_origen ," & vbcrlf &_   
				"	cast(j.asig_ccod as varchar)+' '+j.asig_tdesc as asignatura_destino, " & vbcrlf &_
				"	case b.carg_nnota_final when null then ' * ' else b.carg_nnota_final end as nota   " & vbcrlf &_
				"	from " & vbcrlf &_
				"		equivalencias a " & vbcrlf &_
				"		, cargas_academicas b " & vbcrlf &_
				"		, secciones c " & vbcrlf &_
				"		, ofertas_academicas d " & vbcrlf &_
				"		, planes_estudio e " & vbcrlf &_
				"		, especialidades f " & vbcrlf &_
				"		, alumnos g " & vbcrlf &_
				"		, personas h " & vbcrlf &_
				"		,asignaturas i " & vbcrlf &_
				"		,asignaturas j " & vbcrlf &_
				"		,malla_curricular k " & vbcrlf &_
				"	where " & vbcrlf &_
				"		 a.matr_ncorr=b.matr_ncorr " & vbcrlf &_
				"		 and a.secc_ccod=b.secc_ccod " & vbcrlf &_
				"		 and b.secc_ccod=c.secc_ccod " & vbcrlf &_
				"		 and b.matr_ncorr=g.matr_ncorr " & vbcrlf &_
				"		 and d.ofer_ncorr=g.ofer_ncorr " & vbcrlf &_
				"		 and e.plan_ccod=g.plan_ccod " & vbcrlf &_
				"		 and e.espe_ccod=f.espe_ccod " & vbcrlf &_
				"		 and g.pers_ncorr=h.pers_ncorr " & vbcrlf &_
				"		 and cast(h.pers_nrut as varchar)='" & rut_alumno & "' " & vbcrlf &_
				"		 and i.asig_ccod=k.asig_ccod " & vbcrlf &_
				"		 and j.asig_ccod=c.asig_ccod " & vbcrlf &_
				"		 and a.mall_ccod=k.mall_ccod " & vbcrlf &_
				"		 and a.secc_ccod=c.secc_ccod " 

'response.Write("<PRE>" & tabla_resumen & "</PRE>")
'response.Flush()
resumen_he.consultar	tabla_resumen


'---------------------------------------------------------------------
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
function Validar()
{
	formulario = document.buscador;
	rut_alumno = formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value;	
	if (formulario.elements["busqueda[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].focus();
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	  }
	
	return true;
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
              <br>
                    <table width="98%"  border="0" align="center">
                      <tr>
                        <td width="36%"><div align="right">RUT del Alumno</div></td>
                        <td width="5%"><div align="center">:</div></td>
                        <td width="47%"><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                            <% f_busqueda.DibujaCampo ("pers_nrut") %>
                            - 
                            <% f_busqueda.DibujaCampo ("pers_xdv") %>
                            </font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></div></td>
                        <td width="12%"><div align="center"><%botonera.DibujaBoton "buscar"%></div></td>
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
                <td>
                  <%
				  if alumno <> "" then
				    pagina.DibujarLenguetas array(Array("Datos Alumno","Ficha_Alumno.asp?busqueda[0][pers_nrut]=" & rut_alumno  & "&busqueda[0][pers_xdv]=" & rut_alumno_digito), Array("Avance Curricular"), Array("Notas Parciales","Ficha_Alumno_Notas.asp?busqueda[0][pers_nrut]=" & rut_alumno  & "&busqueda[0][pers_xdv]=" & rut_alumno_digito)), 2 
                  else
				    pagina.DibujarLenguetas Array("Datos Alumno","Avance Curricular","Notas Parciales"), 2 
				  end if
				  %>
				</td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
              <form name="edicion">
			  
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                        <td> 
                          <table width="100%">
                            <tr>
						      <td>
							   <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2"> 
                                  </font></b></font> </div>
								<% if plan <> "" then %>
                                <table width="100%" border="0">
                                  <tr> 
                                    <td width="18%"><strong>Nombre</strong></td>
                                    <td width="6%"><div align="center"><strong>:</strong></div></td>
                                    <td width="76%"><b><font color="#666677" size="2"> 
                                      <%=f_alumno.Obtenervalor ("nombre_alumno")%> </font></b></td>
                                  </tr>
                                  <tr>
                                    <td><strong>Carrera</strong></td>
                                    <td><div align="center"><strong>:</strong></div></td>
                                    <td><b><font color="#666677" size="2"> 
                                <%=f_alumno.Obtenervalor ("carr_tdesc") & " - " &  f_alumno.Obtenervalor ("espe_tdesc")%> </font></b></td>
                                  </tr>
                                </table> 
								<BR><BR><BR>
								<% historico.dibuja %>
								<BR><BR> <BR>
								<% pagina.DibujarSubtitulo "Resumen Equivalencias - Homologaciones"  %>
								<BR><BR>
								<%resumen_he.dibujatabla()
								  else %>
                                <table border="1" bordercolor="#FFFFFF" cellspacing="0" cellspading="0" width="98%">
                              <tr align="center" bgcolor="#6382AD">
                                <td><span class="tituloTabla tituloTabla"><b>Nivel</b></span></td>
                                <td><span class="tituloTabla tituloTabla"><b>C&oacute;digo Asignatura</b></span></td>
                                <td><span class="tituloTabla tituloTabla"><b>Asignatura</b></span></td>
                                <td><span class="tituloTabla tituloTabla"><b>1 oportunidad</b></span></td>
                                <td><span class="tituloTabla tituloTabla"><b>2 oportunidad</b></span></td>
                                <td><span class="tituloTabla tituloTabla"><b>3 oportunidad</b></span></td>
                              </tr>
                              <tr bgcolor="#ADC7E7">
                                <td colspan="7" align="center">No hay datos asociados a los parametros de b&uacute;squeda.</td>
                              </tr>
                            </table>
						 
						 <%
						end if
						%>
                                * Esta asignatura la est&aacute; cursando el alumno 
                                en este periodo. </td>
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
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="19%" height="20"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td width="47%"><div align="center"> 
                            <%
				  if alumno <> "" then
				    botonera.agregaBotonParam "anterior", "deshabilitado", "false"
				  else
				    botonera.agregaBotonParam "anterior", "deshabilitado", "true"
				  end if
				  botonera.agregaBotonParam "anterior" , "url",  "ficha_alumno.asp?busqueda[0][pers_nrut]=" & rut_alumno  & "&busqueda[0][pers_xdv]=" & rut_alumno_digito
				  botonera.dibujaBoton "anterior"
				  %>
                          </div></td>
                        <td width="17%"> 
                          <%
				  if alumno <> "" then
				    botonera.agregaBotonParam "siguiente", "deshabilitado", "false"
				  else
				    botonera.agregaBotonParam "siguiente", "deshabilitado", "true"
				  end if
				  botonera.agregaBotonParam "siguiente" , "url",  "ficha_alumno_Notas.asp?busqueda[0][pers_nrut]=" & rut_alumno  & "&busqueda[0][pers_xdv]=" & rut_alumno_digito
				  botonera.dibujaBoton "siguiente"
				  %>
                        </td>
                        <td width="36%"><div align="center"> 
                            <%botonera.dibujaBoton "lanzadera"%>
                          </div></td>
                      </tr>
                    </table>
            </div></td>
            <td width="81%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
