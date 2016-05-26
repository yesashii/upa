<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
fcarr_ccod = request.QueryString("busqueda[0][carr_ccod]")
fespe_ccod = request.QueryString("busqueda[0][espe_ccod]")
fplan_ccod = request.QueryString("busqueda[0][plan_ccod]")
fperi_ccod = request.QueryString("busqueda[0][peri_ccod]")
fsede_ccod = request.QueryString("busqueda[0][sede_ccod)")


'-----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set pagina = new CPagina
pagina.Titulo = "Requisitos de Titulación"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores = new CErrores

if fsede_ccod = "" then
	sede_ccod = negocio.ObtenerSede
else
	sede_ccod = fsede_ccod
end if


set botonera = new CFormulario
botonera.Carga_Parametros "mant_requisito.xml", "botonera"

botonera.agregabotonparam "agregar","deshabilitado","true"
if (fcarr_ccod <> "") and (fperi_ccod <> "") and (fespe_ccod <> "") and (fplan_ccod <> "") and (sede_ccod <> "") then
	botonera.agregabotonparam "agregar","deshabilitado","false"
	v_usuario = negocio.ObtenerUsuario
	sentencia = "execute GENERA_REQUISITOS_PLAN '" & sede_ccod & "','" & fplan_ccod & "','" & fperi_ccod & "'" 		
	'response.Write(sentencia)
	conexion.EjecutaP(sentencia )
end if

'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'-----------------------------------------------------------------------
'-----------------------------------------------------------------------
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "genera_egreso.xml", "fBusqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' as carr_ccod, '' as espe_ccod "
 f_busqueda.agregacampocons "carr_ccod",fcarr_ccod 
 f_busqueda.agregacampocons "peri_ccod",fperi_ccod 
 f_busqueda.Siguiente

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
f_busqueda.AgregaCampoParam "sede_ccod", "tipo", "INPUT"
f_busqueda.AgregaCampoParam "sede_ccod", "permiso", "OCULTO"
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

'------------------------------------------------------------------------------------------------------------------------
set fc_especialidades = new CFormulario
fc_especialidades.Carga_Parametros "genera_egreso.xml", "tabla"
fc_especialidades.Inicializar conexion
fc_especialidades.Consultar ("select * from especialidades order by carr_ccod, espe_tdesc")

set fc_planes = new CFormulario
fc_planes.Carga_Parametros "genera_egreso.xml", "tabla"
fc_planes.Inicializar conexion
fc_planes.Consultar ("select * from planes_estudio order by espe_ccod, plan_ncorrelativo")
'-------------------------------------------------------------------------------

set f_datos = new cFormulario
f_datos.Carga_Parametros "genera_egreso.xml", "f_datos"
f_datos.Inicializar conexion

consulta = "select a.plan_ncorrelativo, b.espe_tdesc, c.carr_tdesc, d.inst_trazon_social, " & vbCrLf &_
           " (select sede_tdesc from sedes where cast(sede_ccod as varchar)= '" & sede_ccod & "') as sede_tdesc, " & vbCrLf &_
           " (select peri_tdesc from periodos_academicos where cast(peri_ccod as varchar)= '" & fperi_ccod & "') as periodo " & vbCrLf &_
           "from planes_estudio a, especialidades b, carreras c, instituciones d  " & vbCrLf &_
		   "where a.espe_ccod = b.espe_ccod " & vbCrLf &_
		   "  and b.carr_ccod = c.carr_ccod " & vbCrLf &_
		   "  and c.inst_ccod = d.inst_ccod " & vbCrLf &_
		   "  and cast(a.plan_ccod as varchar)= '" & fplan_ccod & "'"

'response.Write("<pre>"&consulta&"</pre>")
'response.Flush()

f_datos.Consultar consulta
f_datos.Siguiente

if fperi_ccod = "" or isnull(fperi_ccod) or isempty(fperi_ccod) then
	peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")
else
	peri_ccod = fperi_ccod
end if


set fReq = new cFormulario
fReq.Carga_Parametros "mant_requisito.xml", "f_requisitos"
fReq.Inicializar conexion
	  
sql = " SELECT  a.repl_ncorr,A.TREQ_CCOD,TREQ_TDESC,B.TEVA_CCOD,C.TEVA_TDESC,a.repl_bobligatorio,isnull(cast(repl_nponderacion as varchar),'&nbsp;') as repl_nponderacion " & vbCrLf &_
		 " FROM REQUISITOS_PLAN A, TIPOS_REQUISITOS_TITULO B,TIPOS_EVALUACION_REQUISITOS C " & vbCrLf &_
		 " WHERE A.TREQ_CCOD=B.TREQ_CCOD " & vbCrLf &_
		 " AND B.TEVA_CCOD=C.TEVA_CCOD " & vbCrLf &_
		 " and cast(a.sede_ccod as varchar)= '"&sede_ccod&"'" & vbCrLf &_
		 " and cast(a.plan_ccod as varchar)= '"&fplan_ccod&"'" & vbCrLf &_
		 " and cast(a.peri_ccod as varchar)= '"&peri_ccod&"'"  & vbCrLf &_
		 "order by b.treq_ccod asc"
		 
'response.Write("<pre>"&sql&"</pre>")		  
fReq.Consultar sql


'----------------------------------------------------------------------------------------------------------------------
'-------------------------------------------------------------------------------

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

arr_especialidades = new Array();
arr_planes = new Array();

<%
i_ = 0
while fc_especialidades.Siguiente
	%>
arr_especialidades[<%=i_%>] = new Array();
arr_especialidades[<%=i_%>]["espe_ccod"] = "<%=fc_especialidades.ObtenerValor("espe_ccod")%>";
arr_especialidades[<%=i_%>]["espe_tdesc"] = "<%=fc_especialidades.ObtenerValor("espe_tdesc")%>";
arr_especialidades[<%=i_%>]["carr_ccod"] = "<%=fc_especialidades.ObtenerValor("carr_ccod")%>";
	<%
	i_ = i_ + 1
wend


i_ = 0
while fc_planes.Siguiente
	%>
arr_planes[<%=i_%>] = new Array();
arr_planes[<%=i_%>]["plan_ccod"] = "<%=fc_planes.ObtenerValor("plan_ccod")%>";
arr_planes[<%=i_%>]["plan_ncorrelativo"] = "<%=fc_planes.ObtenerValor("plan_ncorrelativo")%>";
arr_planes[<%=i_%>]["espe_ccod"] = "<%=fc_planes.ObtenerValor("espe_ccod")%>";
	<%
	i_ = i_ + 1
wend
%>

function CargarEspecialidades(formulario, carr_ccod)
{
	formulario.elements["busqueda[0][espe_ccod]"].length = 0;
	
	op = document.createElement("OPTION");
	op.value = "";
	op.text = "Seleccione especialidad";
	formulario.elements["busqueda[0][espe_ccod]"].add(op)
	
	for (i = 0; i < arr_especialidades.length; i++) {
		if (arr_especialidades[i]["carr_ccod"] == carr_ccod) {
			op = document.createElement("OPTION");
			op.value = arr_especialidades[i]["espe_ccod"];
			op.text = arr_especialidades[i]["espe_tdesc"];
			formulario.elements["busqueda[0][espe_ccod]"].add(op)			
		}
	}	
	
	CargarPlanes(formulario, '');
}

function CargarPlanes(formulario, espe_ccod)
{
	formulario.elements["busqueda[0][plan_ccod]"].length = 0;
	
	op = document.createElement("OPTION");
	op.value = "";
	op.text = "Seleccione plan";
	formulario.elements["busqueda[0][plan_ccod]"].add(op)
	
	for (i = 0; i < arr_planes.length; i++) {
		if (arr_planes[i]["espe_ccod"] == espe_ccod) {
			op = document.createElement("OPTION");
			op.value = arr_planes[i]["plan_ccod"];
			op.text = arr_planes[i]["plan_ncorrelativo"];
			formulario.elements["busqueda[0][plan_ccod]"].add(op);			
		}
	}	
}


function enviar(formulario) {
	if (preValidaFormulario(formulario)) {
		formulario.method = "get";
		formulario.action="";
		formulario.submit();
	}
}

function eliminar(formulario) {
	alert(formulario.elements["reqplan"].lenght)
	for (i=0;i<formulario.elements["reqplan"].lenght;i++){
		alert(i)
	}
	return false	
	if (confirm("¿Está seguro que desea eliminar los requisitos seleccionados?")){
		formulario.method = "post";
		formulario.action = "eliminar_requisitos.asp";
		formulario.submit();
	}	
}

function InicioPagina()
{
	CargarEspecialidades(document.buscador, document.buscador.elements["busqueda[0][carr_ccod]"].value);
	document.buscador.elements["busqueda[0][espe_ccod]"].value = '<%=fespe_ccod%>';
	
	CargarPlanes(document.buscador, document.buscador.elements["busqueda[0][espe_ccod]"].value);
	document.buscador.elements["busqueda[0][plan_ccod]"].value = '<%=fplan_ccod%>';	
	
}

function Buscar()
{
	miform = document.buscador;
	
	miform.action = "m_requisito.asp"; 
	miform.submit();
	
}

</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="InicioPagina(); MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="1102"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
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
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="15" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="77" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF"><strong>Buscador</strong></font></div></td>
                    <td width="10"><img src="../imagenes/derech1.gif" width="12" height="17"></td>
                    <td width="568" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
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
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"><div align="center">
				<form name="buscador" method="get">
                  <table width="98%"  border="0">
                    <tr>
                      <td width="81%"><table width="524" height="79" border="0">
                        <tr align="left" valign="top">
                          <td width="248" height="38">Carrera<br><%f_busqueda.dibujacampo("carr_ccod")%></td>
                          <td width="266">Especialidad<br><%f_busqueda.dibujacampo("espe_ccod")%></td>
                          </tr>
                        <tr align="left" valign="top">
                          <td height="30">Plan<br>
						  <%
						  f_busqueda.dibujacampo("plan_ccod")
						  f_busqueda.dibujacampo("sede_ccod")
						  %></td>
                          <td>Periodo Egreso<br><%f_busqueda.dibujacampo("peri_ccod")%></td>
                          </tr>
                      </table></td>
                      <td width="19%"><div align="center">
                        <%botonera.DibujaBoton "buscar" %>
                      </div></td>
                    </tr>
                  </table>
				</form>
                </div></td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>			
          </td>
      </tr>
    </table>	
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
                    <td width="139" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF"><strong>Listado
                            de Requisitos</strong></font></div>
                    </td>
                    <td width="518" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                  </tr>
                </table>
              </td>
              <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
            </tr>
          </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"> <div align="center"><BR> 
                    <table width="100%" border="0">
                      <tr>
                        <td height="20" nowrap>Carrera</td>
                        <td nowrap><div align="center">:</div></td>
                        <td nowrap><strong><%=f_datos.obtenervalor("carr_tdesc") %></strong></td>
                        <td nowrap>Especialidad</td>
                        <td nowrap><div align="center">:</div></td>
                        <td nowrap><strong><%=f_datos.obtenervalor("espe_tdesc") %></strong></td>
                      </tr>
                      <tr>
                        <td height="20" nowrap>Plan</td>
                        <td nowrap><div align="center">:</div></td>
                        <td nowrap><strong><%=f_datos.obtenervalor("plan_ncorrelativo") %></strong></td>
                        <td nowrap>Periodo Egreso</td>
                        <td nowrap><div align="center">:</div></td>
                        <td nowrap><strong><%=f_datos.obtenervalor("periodo") %></strong></td>
                      </tr>
                      <tr>
                        <td width="45" height="20" nowrap>Sede</td>
                        <td width="9" nowrap><div align="center">:</div></td>
                        <td width="256" nowrap><strong><%=f_datos.obtenervalor("sede_tdesc") %></strong></td>
                        <td width="84" nowrap>Institución</td>
                        <td width="9" nowrap><div align="center">:</div></td>
                        <td width="241" nowrap>
                          <strong><%=f_datos.obtenervalor("inst_trazon_social") %></strong>                        </td>
                      </tr>
                    </table>
                    <br>
                    <%pagina.DibujarTituloPagina%>
                  </div>
                  <table width="665" border="0">
                    <tr>
                      <td><div align="right">
                      </div></td>
                      
                    </tr>
                    <tr>
                      <td ><div align="left"><br>
                        <%pagina.DibujarSubtitulo("Lista de Requisitos de Titulación del Plan")%></div></td>
                    </tr><form name="edicion" action="" method="post">
							<input type="hidden" name="req[0][plan_ccod]" value="<%=fplan_ccod%>">
							<input type="hidden" name="req[0][espe_ccod]" value="<%=fespe_ccod%>">
							<input type="hidden" name="req[0][peri_ccod]" value="<%=peri_ccod%>">
							<input type="hidden" name="req[0][sede_ccod]" value="<%=sede_ccod%>">
							<input type="hidden" name="nrofilas" value="<%=fReq.nrofilas%>">
                    <tr>
                      <td >
                    
                        <div align="center">
                            <% fReq.DibujaTabla %>                 
                      
                      </div>
                     </td>
                    </tr>
                    <tr>
                      <td >&nbsp;</td>
                    </tr>
                    <tr>
                      <td ><strong>Nota</strong>: El requisito &quot;PROMEDIO
                        DE ASIGNATURAS&quot; es obligatorio, solamente se puede
                        editar de &eacute;ste la ponderaci&oacute;n.</td>
                    </tr>
                    <tr>
                      <td ><div align="right"></div></td>
                    </tr> </form>
                    <tr>
                      
                      <td > 
                      </td>
                     
                    </tr>
                  </table>
                     
                   
                </td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                <td width="237" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>                      
                      <td width="33%">
                        <div align="left">
                          <%
						  botonera.AgregaBotonUrlParam "agregar","plan_ccod",fplan_ccod
						  botonera.AgregaBotonUrlParam "agregar","peri_ccod",peri_ccod
						  botonera.AgregaBotonUrlParam "agregar","sede_ccod",sede_ccod
						  botonera.dibujaboton "agregar" %>
</div></td>
                      <td width="33%"><div align="left">
                        <%botonera.dibujaboton "eliminar" %>
                        </div></td>
                      <td width="34%">
                        <div align="left"> 
                          <%botonera.dibujaboton "lanzadera" %>
                        </div></td>
                    </tr>
                  </table>
                </td>
                <td width="125" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
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