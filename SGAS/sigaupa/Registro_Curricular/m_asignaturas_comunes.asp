 <!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
carrera       = request.QueryString("bsec[0][carr_ccod]")
especialidad  = request.QueryString("bsec[0][espe_ccod]")
nivel         = request.QueryString("bsec[0][nive_ccod]")
plan          = request.QueryString("bsec[0][plan_ccod]") 
carr_ccod = request.querystring("a[0][carr_ccod]")
espe_ccod = request.querystring("a[0][espe_ccod]")
plan_ccod= request.QueryString("a[0][plan_ccod]")

carrera=carr_ccod
especialidad=espe_ccod
plan=plan_ccod

'response.End()

set pagina = new CPagina
pagina.Titulo = "Asignaturas comunes por carrera"

set botonera =  new CFormulario
botonera.carga_parametros "m_asignaturas_comunes.xml", "btn_busca_malla"
'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar


ca="select cast(carr_ccod as varchar)+' - '+carr_tdesc as carr_tdesc from carreras where cast(carr_ccod as varchar)='"&carrera&"'"
rcarrera=conectar.consultauno(ca)
espe="select cast(espe_ccod as varchar)+ '-' +espe_tdesc as espe_tdesc from especialidades where cast(espe_ccod as varchar)='"&especialidad&"'"
respecialidad=conectar.consultauno(espe)
pl="select cast(plan_ccod as varchar)+'-'+cast(plan_ncorrelativo as varchar)+' - '+plan_tdesc as plan_ncorrelativo from planes_estudio where cast(plan_ccod as varchar)='"&plan&"'"
rplan=conectar.consultauno(pl)

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "m_asignaturas_comunes.xml", "buscador"
 f_busqueda.inicializar conectar

 peri = negocio.obtenerPeriodoAcademico ( "planificacion" ) 
 sede = negocio.obtenerSede

 consulta="Select '"&carr_ccod&"' as carr_ccod, '"&espe_ccod&"' as espe_ccod, '"&plan_ccod&"' as plan_ccod"
 f_busqueda.consultar consulta

consulta = " select distinct ltrim(rtrim(cast(a.carr_ccod as varchar))) as carr_ccod,a.carr_tdesc,b.espe_ccod,b.espe_tdesc,c.plan_ccod,c.plan_tdesc " & vbCrLf & _
		   " from carreras a, especialidades b, planes_estudio c, ofertas_Academicas d " & vbCrLf & _
		   " where a.carr_ccod=b.carr_ccod " & vbCrLf & _
		   " and b.espe_ccod=c.espe_ccod " & vbCrLf & _
		   " and b.espe_ccod=d.espe_ccod  and isnull(c.plan_tcreditos,'0') = '0' " & vbCrLf & _
		   " and cast(d.sede_ccod as varchar)='"&sede&"' " & vbCrLf & _
		   " and cast(d.peri_ccod as varchar)='"&peri&"' " & vbCrLf & _
		   " union " & vbCrLf & _
		   " select  distinct ltrim(rtrim(cast(a.carr_ccod as varchar))) as carr_ccod,a.carr_tdesc,b.espe_ccod,b.espe_tdesc,c.plan_ccod,c.plan_tdesc " & vbCrLf & _
		   " from carreras a, especialidades b, planes_estudio c " & vbCrLf & _
		   " where a.carr_ccod=b.carr_ccod " & vbCrLf & _
		   " and b.espe_ccod=c.espe_ccod and isnull(c.plan_tcreditos,'0') = '0'" & vbCrLf & _
		   " and b.espe_nplanificable='2' " & vbCrLf & _
		   " order by a.carr_tdesc,b.espe_tdesc,c.plan_tdesc asc" 
'response.Write("<pre>"&consulta&"</pre>")	
f_busqueda.inicializaListaDependiente "lBusqueda", consulta
f_busqueda.siguiente



set f_asignaturas_plan = new CFormulario
f_asignaturas_plan.Carga_Parametros "m_asignaturas_comunes.xml", "asignaturas_plan"
f_asignaturas_plan.Inicializar conectar

consulta = " select a.mall_ccod,a.plan_ccod,a.nive_ccod as nivel,a.nive_ccod,b.asig_nhoras,b.asig_ccod,b.asig_ccod as cod_asig,b.asig_tdesc as asignatura,c.duas_tdesc as duracion, " & vbCrLf & _
		   " (select case count(*) when 0 then 'No' else 'Sí' end " & vbCrLf & _
		   " from secciones s1, bloques_horarios s2 " & vbCrLf & _
		   " where s1.asig_ccod = a.asig_ccod and s1.secc_ccod = s2.secc_ccod and s1.mall_ccod=a.mall_ccod  " & vbCrLf & _
		   " and cast(s1.peri_ccod as varchar)='"&peri&"') as planificada " & vbCrLf & _
		   " from malla_curricular a, asignaturas b,duracion_asignatura c " & vbCrLf & _
		   " where cast(a.plan_ccod as varchar)= '"&plan_ccod&"' " & vbCrLf & _
		   " and a.asig_ccod = b.asig_ccod " & vbCrLf & _
		   " and b.duas_ccod = c.duas_ccod " & vbCrLf & _
		   " and not exists (select 1 from asignaturas_comunes ac where ac.mall_ccod = a.mall_ccod) " & vbCrLf & _
		   " and isnull(b.cred_ccod,0) = 0 " & vbCrLf & _
		   " order by nivel,asignatura"

if plan_ccod="" then
	consulta = " select * from sexos where 1=2"
end if

f_asignaturas_plan.Consultar consulta

'-------------------------------------------------------------------------------
set f_asignaturas_C = new CFormulario
f_asignaturas_C.Carga_Parametros "m_asignaturas_comunes.xml", "asignaturas_comunes"
f_asignaturas_C.Inicializar conectar

consulta = " select e.nive_ccod as nivel,a.mall_ccod as mall_ccod2,a.mall_ccod,c.espe_tdesc as especialidad,b.plan_tdesc as plan_est, " & vbCrLf & _
		   " d.asig_ccod as cod_asignatura, d.asig_tdesc as asignatura,asig_nhoras " & vbCrLf & _
		   " from asignaturas_comunes a, planes_estudio b, especialidades c, asignaturas d,malla_curricular e " & vbCrLf & _
		   " where a.carr_ccod='"&carr_ccod&"' and a.plan_ccod=b.plan_ccod " & vbCrLf & _
		   " and b.espe_ccod=c.espe_ccod and a.asig_ccod=d.asig_ccod " & vbCrLf & _
		   " and e.mall_ccod=a.mall_ccod " & vbCrLf & _
		   " order by nivel,especialidad,plan_est "


if plan_ccod="" then
	consulta = " select * from sexos where 1=2"
end if

f_asignaturas_C.Consultar consulta


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
function agregar_asig(formulario){
	mensaje="agregarla como asignatura común";
	if (verifica_check(formulario,mensaje)) {
		formulario.method="post"
		formulario.action = 'agregar_asignaturas_comunes.asp';
		formulario.submit();
	}
}

function eliminar_asig(formulario){
	mensaje="eliminar asignatura común";
	if (verifica_check(formulario,mensaje)) {
		formulario.method="post"
		formulario.action = 'eliminar_asignaturas_comunes.asp';
		formulario.submit();
	}
}

function enviar(formulario){
formulario.submit();
}
function agrega_asig(formulario){

	direccion="agregar_asig.asp?carr="+formulario.carr.value+"&plan="+formulario.plan.value+"&espe="+formulario.espe.value;
	resultado=window.open(direccion, "ventana1","width=700,height=550,scrollbars=yes, left=0, top=0");
}


function inicio()
{
}




</script>
<% f_busqueda.generaJS %>
</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../__base/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();" >
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
            <td><form name="buscador" method="get">
              <br>
                <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                            <table width="100%" border="0">
                              <tr> 
                                <td><div align="left"><strong>Carrera</strong></div></td>
                                <td><div align="center"><strong>:</strong></div></td>
                                <td>
                                  <%f_busqueda.dibujaCampoLista "lBusqueda", "carr_ccod" %>
                                </td>
                              </tr>
                              <tr> 
                                <td width="15%"><div align="left"><strong>Especialidad</strong></div></td>
                                <td width="4%"><div align="center"><strong>:</strong></div></td>
                                <td width="81%">
                                  <%f_busqueda.dibujaCampoLista "lBusqueda", "espe_ccod" %>
                                </td>
                              </tr>
							  <tr> 
                                <td width="15%"><div align="left"><strong>Planes</strong></div></td>
                                <td width="4%"><div align="center"><strong>:</strong></div></td>
                                <td width="81%"><%f_busqueda.dibujaCampoLista "lBusqueda", "plan_ccod"%></td>
                              </tr>
                            </table>
                          </div></td>
                  <td width="19%"><div align="center"><%botonera.DibujaBoton "buscar"%></div></td>
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
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
              
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%if carrera <> "" and especialidad  <> "" and plan <> "" then %>
                          <table width="627">
                            <tr> 
                              <td width="137"  colspan="2">&nbsp;</td>
                            </tr>
							<tr> 
                              <td width="137" nowrap>Programa de Estudio</td>
                              <td width="478">:<strong><%=rcarrera%></strong></td>
                            </tr>
                            <tr> 
                              <td>Especilidad</td>
                              <td>:<strong><%=respecialidad%></strong></td>
                            </tr>
                            <tr> 
                              <td>Plan</td>
                              <td>:<strong><%=rplan%></strong></td>
                            </tr>
							
                          </table>
					 <%end if %>
					  <form name="edicion">
					  <br>
					      <%pagina.DibujarSubtitulo "Seleccione las asignaturas del plan de estudio a hacer comunes"%>
                      <br>
                      <table width="100%" border="0">
                        <tr>
                          <td align="right">P&aacute;gina: <%f_asignaturas_plan.accesoPagina%></td>
                        </tr>
                        <tr>
                          <td><div align="center">
                                <% 
								  f_asignaturas_plan.dibujatabla()
								%>
                          </div></td>
                        </tr>
                        <tr>
							<td align="right"><%botonera.dibujaboton "AGREGAR" %></td>
					    </tr>
						<input name="cod_carrera" type="hidden" value="<%=carr_ccod%>">
                      </table>
					  </form>
					  <form name="edicion2">
					  <br>
					  		<%pagina.DibujarSubtitulo "Listado de Asignaturas Comunes de la Carrera."%>
                      <br>
                      <table width="100%" border="0">
                        <tr>
                          <td align="right">P&aacute;gina: <%f_asignaturas_C.accesoPagina%></td>
                        </tr>
                        <tr>
                          <td><div align="center">
                                <% 
								  f_asignaturas_C.dibujatabla()
								%>
                          </div></td>
                        </tr>
                        <tr>
							<td align="right"><%botonera.dibujaboton "ELIMINAR" %></td>
					    </tr>
                      </table>
					 </form>
                      </td>
                  </tr>
                </table>
              <br>
            </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="12%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                    <%botonera.dibujaboton "SALIR"%>
                  </div></td>
				  <td><div align="center">
                    <% if f_asignaturas_C.nroFilas > 0  then
					  botonera.agregaBotonParam "excel","url","listado_asignaturas_comunes.asp?carr_ccod="&carr_ccod
					  botonera.dibujaboton "excel"
					  end if%>
                  </div></td>
                </tr>
              </table>
            </div></td>
            <td width="88%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
