<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

'q_peri_ccod = Request.QueryString("b[0][peri_ccod]")
'q_solo_aprobadas = Request.QueryString("b[0][solo_aprobadas]")
'carrera = Request.QueryString("enca[0][carreras_alumno]")
plan_ccod		= 	request.querystring("ch[0][plan_ccod]")


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Histórico de notas del alumno"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

q_pers_nrut = Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")

if esVacio(q_pers_nrut) then
	q_pers_nrut = negocio.obtenerUsuario
	q_pers_xdv = conexion.consultaUno("Select pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
end if
'---------------------------------------------------------------------------------------------------

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "notas_alumno.xml", "botonera"

'---------------------------------------------------------------------------------------------------
'set f_busqueda = new CFormulario
'f_busqueda.Carga_Parametros "notas_alumno.xml", "busqueda"
'f_busqueda.Inicializar conexion
'f_busqueda.Consultar "select ''"
'f_busqueda.siguiente

'if not esVacio(q_pers_nrut) then
'	pers_ncorr_temporal=conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
'	consulta="(select c.peri_ccod, cast(c.anos_ccod as varchar)+ ' - ' + cast(c.plec_ccod as varchar) + 'º Semestre ' as desc_periodo " & vbCrLf &_
'	         "from alumnos a,ofertas_Academicas b, periodos_academicos c " & vbCrLf &_
'			 "where cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"'" & vbCrLf &_
'			 "and a.ofer_ncorr=b.ofer_ncorr" & vbCrLf &_
'			 "and c.anos_ccod >= 2005" & vbCrLf &_
'			 "and b.peri_ccod=c.peri_ccod)t"
'	f_busqueda.AgregaCampoParam "peri_ccod","destino",consulta
'end if
'f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
'f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
'f_busqueda.AgregaCampoCons "peri_ccod", q_peri_ccod


if esVacio(plan_ccod) or plan_ccod=""  then
	consulta_actual_plan="  select  distinct cast(f.espe_ccod as varchar)+ '-' + cast(f.plan_ccod as varchar)+ '-' + cast(d.carr_ccod as varchar) as parametro " & vbcrlf &_
						 "	from personas a, alumnos b,ofertas_academicas c,especialidades d,carreras e,planes_estudio f,cargas_academicas g" & vbcrlf &_
						 " where cast(pers_nrut as varchar)='"&q_pers_nrut&"'" & vbcrlf &_
						 " and a.pers_ncorr=b.pers_ncorr" & vbcrlf &_
						 " and b.ofer_ncorr=c.ofer_ncorr" & vbcrlf &_
						 " and b.matr_ncorr *= g.matr_ncorr" & vbcrlf &_
						 " and c.espe_ccod=d.espe_ccod" & vbcrlf &_
						 " and d.carr_ccod=e.carr_ccod" & vbcrlf &_
					 	 "and b.plan_ccod=f.plan_ccod "
					 
plan_ccod = conexion.consultaUno(consulta_actual_plan) 
end if	

set historico	=	new cHistoricoNotas
set combo_b		= 	new cformulario
combo_b.inicializar			conexion
combo_b.carga_parametros	"notas_alumno.xml","combo"
combo_b.consultar			"select '' as salida, '' as parametro"

combo_b.agregacampoparam	"plan_ccod","destino","(select  distinct a.pers_nrut,e.carr_ccod, " & vbcrlf &_
							"                       cast(f.espe_ccod as varchar)+ '-' + e.carr_tdesc + '-' + d.espe_tdesc +'-'+ cast(f.plan_tdesc as varchar) AS salida,    " & vbcrlf &_
							"						cast(f.espe_ccod as varchar)+ '-' + cast(f.plan_ccod as varchar)+ '-' + cast(e.carr_ccod as varchar) as parametro " & vbcrlf &_
							"						from personas a, alumnos b,ofertas_academicas c,especialidades d,carreras e,planes_estudio f,cargas_academicas g " & vbcrlf &_
							"                       where cast(pers_nrut as varchar)='"&q_pers_nrut&"' " & vbcrlf &_
							"						and a.pers_ncorr=b.pers_ncorr" & vbcrlf &_
							"						and b.ofer_ncorr=c.ofer_ncorr" & vbcrlf &_
    						"						and b.matr_ncorr *= g.matr_ncorr" & vbcrlf &_
							"						and c.espe_ccod=d.espe_ccod" & vbcrlf &_
							"						and d.carr_ccod=e.carr_ccod" & vbcrlf &_
							"						and b.plan_ccod=f.plan_ccod) a"
combo_b.siguiente
combo_b.agregacampocons		"plan_ccod", plan_ccod

if plan_ccod <> "" then 
	variables		=	split(plan_ccod,"-")
	plan			=	variables(1)
	especialidad	=	variables(0)
'	carrera			=	mid(especialidad,1,2)
	carrera			=   variables(2)
	historico.inicializar	conexion, q_pers_nrut, plan, especialidad, carrera
	'response.write(  rut  &"'='" &  plan  &"'='" & especialidad &"'='" & carrera )
end if


'---------------------------------------------------------------------------------------------------
set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "notas_alumno.xml", "encabezado"
f_encabezado.Inicializar conexion

consulta = "select top 1 protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, b.plan_ccod, " & vbCrLf &_
           "       ltrim(rtrim(protic.obtener_nombre_carrera(b.ofer_ncorr, 'C'))) as carrera, protic.ano_ingreso_plan(b.pers_ncorr, b.plan_ccod) as ano_ingreso_plan, cast(d.espe_nduracion as varchar) + ' Semestres' as duas_tdesc " & vbCrLf &_
		   "from personas a, alumnos b, ofertas_academicas c, especialidades d" & vbCrLf &_
		   "where a.pers_ncorr = b.pers_ncorr   " & vbCrLf &_
		   "  and b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
		   "  and c.espe_ccod = d.espe_ccod "  & vbCrLf &_
		   "  and b.ofer_ncorr = protic.ultima_oferta_matriculado(a.pers_ncorr) "  & vbCrLf &_
		   "  and b.emat_ccod <> 9 " & vbCrLf &_
		   "  and cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "' "
		   
'response.Write("<pre>"&consulta&"</pre>")
f_encabezado.Consultar consulta
f_encabezado.Siguiente

v_plan_ccod = f_encabezado.ObtenerValor("plan_ccod")


nombre_carrera=f_encabezado.obtenerValor("carrera")



lenguetas_notas = Array(Array("Notas Parciales del Alumno", "notas_parciales_alumno.asp"), Array("Histórico de notas del alumno", "notas_alumno.asp"))


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
colores = Array(3);
	colores[0] = '';
	//colores[1] = '#97AAC6';
	//colores[2] = '#C0C0C0';
	colores[1] = '#FFECC6';
	colores[2] = '#FFECC6';
	
var t_parametros;


function Inicio()
{
	t_parametros = new CTabla("p")
}

function dibujar(formulario){
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
            <td><%pagina.DibujarLenguetas lenguetas_notas, 2 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
		  <tr>
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
				<tr>
                  <td width="20%"><div align="left"><strong>Programa de Estudio</strong></div></td>
				  <td width="2%"><div align="center"><strong>:</strong></div></td>
				  <td width="78%" colspan="3"><div align="left"><%combo_b.dibujacampo("plan_ccod")%></div></td>
                </tr>
              </table>
            </form></td>
          </tr>
		  <tr>
		  	<td><hr></td>
		  </tr>
		  <tr>
            <td>
			<form name="edicion" action="notas_alumno.asp">
			 <div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
              <br>
			   <%if not esVacio(q_pers_nrut) then%>
			   <table width="98%"  border="0">
                <tr>
                  <td width="64" align="left"><strong>RUT</strong></td>
				  <td width="11"  align="center"><strong>:</strong></td>
				  <td width="83"  align="left"><%f_encabezado.DibujaCampo("rut")%></td>
				  <td width="182" align="left"><strong>Nombre</strong></td>
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
				  <td width="182" align="left"><strong>Año Ingreso al Plan de Estudios</strong></td>
				  <td width="14"  align="center"><strong>:</strong></td>
				  <td width="266"  align="left"><%f_encabezado.DibujaCampo("ano_ingreso_plan")%></td>
                </tr>
              </table>
			  <%end if%>
			  </div>
              
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Notas"%>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td scope="col" colspan="6"><div align="center">
							  <%if plan_ccod <> "" then
								historico.dibuja
								else %>
								  <table class="v1" border="1" borderColor="#999999" bgColor="#adadad" cellspacing="0" cellspading="0" width="98%">
								  <tr align="center" bgColor="#c4d7ff">
									<TH><FONT color=#333333>Nivel</FONT></TH>
									<TH><FONT color=#333333>C&oacute;digo Asignatura</FONT></TH>
									<TH><FONT color=#333333>Asignatura</FONT></TH>
									<TH><FONT color=#333333>1 oportunidad</FONT></TH>
									<TH><FONT color=#333333>2 oportunidad</FONT></TH>
									<TH><FONT color=#333333>3 oportunidad</FONT></TH>
								  </tr>
								  <tr bgcolor="#FFFFFF">
									<td colspan="6" align="center" class=noclick onmouseover=resaltar(this) onmouseout=desResaltar(this)>No hay datos asociados a los parametros de b&uacute;squeda.</td>
								  </tr>
								</table>
								<%
							end if%>
							</div>
						  </td>
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
            <td width="24%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%'f_botonera.DibujaBoton "excel"%></div></td>
                  <td><div align="center"><%f_botonera.DibujaBoton "salir"%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="76%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
