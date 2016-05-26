<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Seleccione la Asignatura y docente a evaluar"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

if esVacio(q_pers_nrut) then
	q_pers_nrut = negocio.obtenerUsuario
	q_pers_xdv = conexion.consultaUno("Select pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
	pers_ncorr_temporal = conexion.consultaUno("Select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
end if

'response.Write(q_pers_nrut)
consulta_periodo=" select max(b.peri_ccod) "&_
                 " from alumnos a, ofertas_academicas b,personas c,especialidades d "&_
				 " where a.pers_ncorr = c.pers_ncorr and cast(c.pers_nrut as varchar)='"&q_pers_nrut&"' and b.espe_ccod=d.espe_ccod and carr_ccod in ('193','39','7')" &_
				 " and a.ofer_ncorr = b.ofer_ncorr and emat_ccod in (1,2,4,8,10,13) and exists (select 1 from cargas_academicas carg where carg.matr_ncorr= a.matr_ncorr) "
				 

q_peri_ccod = conexion.consultaUno(consulta_periodo)
'response.Write(q_peri_ccod)
anos_ccod = conexion.consultaUno("select anos_ccod from periodos_Academicos where  cast(peri_ccod as varchar)='"&q_peri_ccod&"'")

if esVacio(matr_ncorr) then
	consulta_matr=" Select top 1 b.matr_ncorr from personas a, alumnos b, ofertas_Academicas c,especialidades d" &_
	              " where a.pers_ncorr=b.pers_ncorr and b.ofer_ncorr=c.ofer_ncorr and c.espe_ccod=d.espe_ccod and carr_ccod in ('193','39','7') and emat_ccod in (1,2,4,8,10,13)"&_
				  " and cast(c.peri_ccod as varchar)='"&q_peri_ccod&"' and cast(a.pers_nrut as varchar)='"&q_pers_nrut&"'"
				  	
	matr_ncorr= conexion.consultaUno(consulta_matr)	
end if


carrera = conexion.consultaUno("Select carr_ccod from alumnos a, ofertas_Academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast( matr_ncorr as varchar)='"&matr_ncorr&"'")

'---------------------------------------------------------------------------------------------------

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "seleccionar_docente_otec.xml", "botonera"

'---------------------------------------------------------------------------------------------------
'response.Write(pers_ncorr_temporal)
'---------------------------------------------------------------------------------------------------
set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "seleccionar_docente_otec.xml", "encabezado"
f_encabezado.Inicializar conexion

consulta = "select top 1 protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, b.plan_ccod, " & vbCrLf &_
           "       ltrim(rtrim(protic.obtener_nombre_carrera(b.ofer_ncorr, 'C'))) as carrera, protic.ano_ingreso_carrera(b.pers_ncorr, d.carr_ccod) as ano_ingreso_plan, cast(d.espe_nduracion as varchar) + ' Semestres' as duas_tdesc " & vbCrLf &_
		   "from personas a, alumnos b, ofertas_academicas c, especialidades d" & vbCrLf &_
		   "where a.pers_ncorr = b.pers_ncorr   " & vbCrLf &_
		   "  and b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
		   "  and c.espe_ccod = d.espe_ccod " & vbCrLf &_
		   "  and cast(b.matr_ncorr as varchar)='"&matr_ncorr&"' " & vbCrLf &_
		   "  and cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "' "
		   


'response.Write("<pre>"&consulta&"</pre>")
f_encabezado.Consultar consulta
f_encabezado.Siguiente
f_encabezado.AgregaCampoCons "carreras_alumno", matr_ncorr
f_encabezado.AgregaCampoParam "carreras_alumno","destino",consulta_carrera
v_plan_ccod = f_encabezado.ObtenerValor("plan_ccod")

'---------------------------------------------------------------------------------------------------
set f_ramos = new CFormulario
f_ramos.Carga_Parametros "seleccionar_docente_otec.xml", "ramos"
f_ramos.Inicializar conexion

			
consulta2 = "  select distinct * from ( " & vbCrLf &_
            "  select distinct ltrim(rtrim(g.asig_ccod))as asig_ccod, g.asig_tdesc,f.secc_tdesc as seccion,f.secc_ccod, " & vbCrLf &_
			"  i.pers_tnombre + ' ' + i.pers_tape_paterno + ' ' + i.pers_tape_materno as docente,h.pers_ncorr, " & vbCrLf &_
			"  (Select case count(*) when 0 then 'No' else 'Sí' end  from encuestas_otec re where re.secc_ccod=f.secc_ccod and re.pers_ncorr_encuestado=j.pers_ncorr and re.pers_ncorr_destino=i.pers_ncorr) as encuestado " & vbCrLf &_
			"  from bloques_horarios a,cargas_academicas d,secciones f, asignaturas g, bloques_profesores h, personas i, alumnos j  " & vbCrLf &_
			"  where  a.secc_ccod = f.secc_ccod " & vbCrLf &_
			"	and f.asig_ccod = g.asig_ccod  " & vbCrLf &_
			"	and a.secc_ccod = d.secc_ccod  " & vbCrLf &_
			"   and d.matr_ncorr = j.matr_ncorr" & vbCrLf &_
			"   and a.bloq_ccod = h.bloq_ccod " & vbCrLf &_
			"   and h.tpro_ccod = 1 " & vbCrLf &_
		    "   and h.pers_ncorr = i.pers_ncorr " & vbCrLf &_
			"	and not exists (select 1 from convalidaciones conv where d.matr_ncorr=conv.matr_ncorr and f.asig_ccod=conv.asig_ccod) " & vbCrLf &_
			"	and cast(d.matr_ncorr as varchar)= '"&matr_ncorr&"'"& vbCrLf &_
			"  UNION ALL " & vbCrLf &_
			"  select distinct ltrim(rtrim(b.asig_ccod))as asig_ccod, b.asig_tdesc,a.secc_tdesc as seccion,a.secc_ccod, " & vbCrLf &_
		    "  h.pers_tnombre + ' ' + h.pers_tape_paterno + ' ' + h.pers_tape_materno as docente,g.pers_ncorr, " & vbCrLf &_
		    "  (Select case count(*) when 0 then 'No' else 'Sí' end  from encuestas_otec re where re.secc_ccod=a.secc_ccod and re.pers_ncorr_encuestado=e.pers_ncorr and re.pers_ncorr_destino=h.pers_ncorr) as encuestado " & vbCrLf &_
			"  from secciones a, asignaturas b, periodos_academicos c, cargas_academicas d, alumnos e, bloques_horarios f, bloques_profesores g, personas h " & vbCrLf &_
		    "  where a.asig_ccod = b.asig_ccod " & vbCrLf &_
			"  and b.duas_ccod = 3 " & vbCrLf &_
			"  and a.peri_ccod = c.peri_ccod " & vbCrLf &_
			"  and cast(c.anos_ccod as varchar) = '"&anos_ccod&"' " & vbCrLf &_
		    "  and a.secc_ccod = d.secc_ccod " & vbCrLf &_
		    "  and d.matr_ncorr = e.matr_ncorr " & vbCrLf &_
		    "  and cast(e.pers_ncorr as varchar) = '"&pers_ncorr_temporal&"' " & vbCrLf &_
			"  and a.secc_ccod = f.secc_ccod " & vbCrLf &_
			"  and f.bloq_ccod = g.bloq_ccod and g.tpro_ccod = 1 " & vbCrLf &_
			"  and g.pers_ncorr = h.pers_ncorr )a "
			
			
'response.Write("<pre>"&consulta2&"</pre>")
f_ramos.Consultar consulta2
'f_ramos.siguiente   
nombre_carrera=f_encabezado.obtenerValor("carrera")
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

var t_parametros;

function Inicio()
{
	t_parametros = new CTabla("p")
}

function Cerrar_ventana()
{
	window.close();
}

function dibujar(formulario){
	document.getElementById("texto_alerta").style.visibility="visible";
	formulario.submit();
}
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif'); Inicio();" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="80" valign="top"><img src="../imagenes/banner.jpg" width="750" height="100" border="0"></td>
  </tr>
  <%'pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#FFFFFF"><br>
	
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
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
			<form name="edicion" action="seleccionar_docente.asp">
			 <div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
              <br>
			   <%if not esVacio(q_pers_nrut) then%>
			   <table width="98%"  border="0">
                <tr>
                  <td width="64" align="left"><strong>RUT</strong></td>
				  <td width="11"  align="center"><strong>:</strong></td>
				  <td width="83"  align="left"><%f_encabezado.DibujaCampo("rut")%></td>
				  <td width="182" align="right"><strong>Nombre&nbsp;</strong></td>
				  <td width="14"  align="center"><strong>:</strong></td>
				  <td width="266"  align="left"><%f_encabezado.DibujaCampo("nombre")%></td>
                </tr>
				<tr>
                  <td width="64" align="left"><strong>Carrera</strong></td>
				  <td width="11"  align="center"><strong>:</strong></td>
				  <td  align="left" colspan="4"><%=nombre_carrera%></td>
			    </tr>
				 <tr>
                  <td width="64" align="left"><strong>Duraci&oacute;n</strong></td>
				  <td width="11"  align="center"><strong>:</strong></td>
				  <td width="83"  align="left"><%f_encabezado.DibujaCampo("duas_tdesc")%></td>
				          <td width="182" align="right"><strong>Año Ingreso &nbsp;</strong></td>
				  <td width="14"  align="center"><strong>:</strong></td>
				  <td width="266"  align="left"><%f_encabezado.DibujaCampo("ano_ingreso_plan")%></td>
                </tr>
              </table>
			  <%end if%>
			  <br>
			  </div>
              
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Notas"%>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td scope="col" colspan="6"><div align="center"><%f_ramos.DibujaTabla%></div></td>
                        </tr>
						</table></td>
                  </tr>
                </table>
              <br>
			  <input type="hidden" name="b[0][pers_nrut]" value="<%=q_pers_nrut%>"> 
              <input name="b[0][pers_xdv]" type="hidden" value="<%=q_pers_xdv%>">
			  <input name="b[0][peri_ccod]" type="hidden" value="<%=q_peri_ccod%>">
			 </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="13%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                   <td><div align="center"><%f_botonera.DibujaBoton "salir"%></div></td>
                </tr>
              </table>
            </div></td>
            <td width="87%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
