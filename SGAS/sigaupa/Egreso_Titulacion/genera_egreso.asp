<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
fcarr_ccod = request.QueryString("busqueda[0][carr_ccod]")
fespe_ccod = request.QueryString("busqueda[0][espe_ccod]")
fplan_ccod = request.QueryString("busqueda[0][plan_ccod]")
fperi_ccod = request.QueryString("busqueda[0][peri_ccod]")
fsede_ccod = request.QueryString("busqueda[0][sede_ccod]")



set pagina = new CPagina
pagina.Titulo = "Proceso de Egreso"

'-----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new CNegocio
negocio.Inicializa conexion

buscando = false
'if (fcarr_ccod <> "") and (fperi_ccod <> "") and (fespe_ccod <> "") and (fplan_ccod <> "") and (fsede_ccod <> "") then
if (fcarr_ccod <> "") or (fperi_ccod <> "") or (fespe_ccod <> "") or (fplan_ccod <> "") or (fsede_ccod <> "") then
	buscando = true
	usuario = negocio.ObtenerUsuario
	sentencia = "genera_egresado('" & fplan_ccod & "','" & fcarr_ccod & "','" & fespe_ccod & "','" & fperi_ccod & "'," & fsede_ccod & ",'" & usuario & "')" 	
	'response.Write(sentencia)
	conexion.EjecutaP(sentencia )
end if


if fsede_ccod = "" then
	sede_ccod = negocio.ObtenerSede
else
	sede_ccod = fsede_ccod
end if

'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "genera_egreso.xml", "botonera"

'-----------------------------------------------------------------------
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "genera_egreso.xml", "fBusqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' as carr_ccod from dual"
 f_busqueda.agregacampocons "carr_ccod",fcarr_ccod 
 f_busqueda.agregacampocons "peri_ccod",fperi_ccod 
 f_busqueda.agregacampocons "sede_ccod",sede_ccod 
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
           " (select sede_tdesc from sedes where sede_ccod = '" & sede_ccod & "') as sede_tdesc, " & vbCrLf &_
           " (select peri_tdesc from periodos_academicos where peri_ccod = '" & fperi_ccod & "') as periodo " & vbCrLf &_
           "from planes_estudio a, especialidades b, carreras c, instituciones d  " & vbCrLf &_
		   "where a.espe_ccod = b.espe_ccod " & vbCrLf &_
		   "  and b.carr_ccod = c.carr_ccod " & vbCrLf &_
		   "  and c.inst_ccod = d.inst_ccod " & vbCrLf &_
		   "  and a.plan_ccod = '" & fplan_ccod & "'"

'response.Write(consulta)
'response.Flush()

f_datos.Consultar consulta
f_datos.Siguiente

set f_egre = new cFormulario
f_egre.Inicializar conexion
f_egre.Carga_Parametros "genera_egreso.xml", "f_egresados"

if fperi_ccod = "" or isnull(fperi_ccod) or isempty(fperi_ccod) then
	peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")
else
	peri_ccod = fperi_ccod
end if
	  
sql_egresado = "select rownum as n, a.* " & vbCrLf &_
               "from (select a.egre_ncorr, b.pers_ncorr, b.pers_tape_paterno || ' ' || b.pers_tape_materno || ' ' || b.pers_tnombre as nombre, b.pers_nrut || '-' || b.pers_xdv as rut, " & vbCrLf &_
			   "             a.egre_fmatricula, a.egre_fegreso, a.peri_ccod_ingreso, " & vbCrLf &_
			   "			 c.anos_ccod || '/' || decode(c.plec_ccod,1,'O',3,'P') as periodo_ingreso, " & vbCrLf &_
			   "			 d.anos_ccod || '/' || decode(d.plec_ccod,1,'O',3,'P') as periodo_egreso, " & vbCrLf &_
			   "			 to_char(nota_egreso(a.pers_ncorr, a.plan_ccod), '0.0') as nota_egreso, " & vbCrLf &_
			   "			 e.aceg_ncorr, nvl(to_char(e.aceg_ncorr), '') as html_aceg_ncorr,  a.espe_ccod || '-' || a.plan_ccod as p1_historico, b.pers_nrut as p2_historico, b.pers_xdv as p3_historico " & vbCrLf &_
			   "      from egresados a, personas b, periodos_academicos c, periodos_academicos d, " & vbCrLf &_
			   "           detalle_actas_egresos e " & vbCrLf &_
			   "      where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
			   "        and a.peri_ccod_ingreso = c.peri_ccod " & vbCrLf &_
			   "        and a.peri_ccod = d.peri_ccod " & vbCrLf &_
			   "        and a.egre_ncorr = e.egre_ncorr (+) " & vbCrLf &_
			   "        and a.plan_ccod = '" & fplan_ccod & "' " & vbCrLf &_
			   "        and a.espe_ccod = '" & fespe_ccod & "' " & vbCrLf &_
			   "        and a.sede_ccod = '" & sede_ccod & "' " & vbCrLf &_
			   "        and a.peri_ccod = '" & peri_ccod & "' " & vbCrLf &_
			   "      --order by decode(e.aceg_ncorr, null, 0, 1) desc, e.aceg_ncorr asc, b.pers_tape_paterno asc, b.pers_tape_materno asc, b.pers_tnombre asc " & vbCrLf &_
			   "      order by b.pers_tape_paterno asc, b.pers_tape_materno asc, b.pers_tnombre asc " & vbCrLf &_
			   ") a"

'response.Write("<pre>"&sql_egresado&"</pre>")		  
f_egre.Consultar sql_egresado


'------------------------------------------------------------------------------------------------------------------------
consulta = "select count(*)" & vbCrLf &_
		   "from egresados a " & vbCrLf &_
		   "where a.plan_ccod = '" & fplan_ccod & "' " & vbCrLf &_
		   "  and a.espe_ccod = '" & fespe_ccod & "' " & vbCrLf &_
		   "  and a.sede_ccod = '" & sede_ccod & "' " & vbCrLf &_
		   "  and a.peri_ccod = '" & peri_ccod & "' " & vbCrLf &_
		   "  and not exists (select 1 " & vbCrLf &_
		   "                  from detalle_actas_egresos a2 " & vbCrLf &_
		   "				  where a.egre_ncorr = a2.egre_ncorr)"
		   
negresados_sin_acta = CLng(conexion.ConsultaUno(consulta))

'----------------------------------------------------------------------------------------------------------------------

set f_actas = new CFormulario
f_actas.Carga_Parametros "genera_egreso.xml", "actas_egreso"
f_actas.Inicializar conexion

consulta = "select a.aceg_ncorr, a.aceg_femision, count(b.egre_ncorr) as negresados " & vbCrLf &_
           "from actas_egresos a, detalle_actas_egresos b " & vbCrLf &_
		   "where a.aceg_ncorr = b.aceg_ncorr (+)" & vbCrLf &_
		   "  and a.plan_ccod = '" & fplan_ccod & "' " & vbCrLf &_
		   "  and a.espe_ccod = '" & fespe_ccod & "' " & vbCrLf &_
		   "  and a.sede_ccod = '" & sede_ccod & "' " & vbCrLf &_
		   "  and a.peri_ccod = '" & peri_ccod & "' " & vbCrLf &_
		   "group by a.aceg_ncorr, a.aceg_femision " & vbCrLf &_
		   "order by a.aceg_femision asc, a.aceg_ncorr asc"
		   
f_actas.Consultar consulta

'-------------------------------------------------------------------------------
set f_tabla		=	new cFormulario
f_tabla.inicializar	conexion
f_tabla.carga_parametros	"genera_egreso.xml","tabla_datos"

f_tabla.consultar 	sql_egresado

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
function GenerarActa(formulario, boton){
	bandera=1
	
		for (k=0;k<<%=f_egre.nrofilas%>;k++){			
			if (formulario.elements["ga["+k+"][html_aceg_ncorr]"].value!="" && formulario.elements["ga["+k+"][html_aceg_ncorr]"].disabled==false){
				//if (formulario.elements["ga["+k+"][egre_ncorr]"].checked==true) {
				//	bandera=1
				//} else 
				if (formulario.elements["ga["+k+"][egre_ncorr]"].checked==false) {
					nro_casillero=parseInt(k)+1
					alert('No puede dejar sin chequear el casillero correspondiente a la fila del número de acta que ingresó,\nen este caso el casillero del alumno número '+nro_casillero);
					//alert(formulario.elements["ga["+k+"][egre_ncorr]"].value+' - '+k);
					bandera=0
					break
				}
			}	
		}
		if (bandera==1){
			if (confirm("Se agregarán solamente los alumnos que no aparecen en ninguna acta.\n\n¿Está seguro que desea generar una nueva Acta de Egreso?\n")) {

					_HabilitarBoton(boton, false);
					formulario.action = "procesa_genera_egreso.asp";
					formulario.method = "post";
					formulario.submit();

			}
		}
}

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

var t_egresados;

function InicioPagina()
{
	CargarEspecialidades(document.buscador, document.buscador.elements["busqueda[0][carr_ccod]"].value);
	document.buscador.elements["busqueda[0][espe_ccod]"].value = '<%=fespe_ccod%>';
	
	CargarPlanes(document.buscador, document.buscador.elements["busqueda[0][espe_ccod]"].value);
	document.buscador.elements["busqueda[0][plan_ccod]"].value = '<%=fplan_ccod%>';	
	
	t_egresados = new CTabla("ga");
	for (var i = 0; i < t_egresados.filas.length; i++) {
		if (!isEmpty(t_egresados.ObtenerValor(i, "html_aceg_ncorr"))) {
			t_egresados.filas[i].campos["egre_ncorr"].objeto.disabled = true;
			t_egresados.filas[i].campos["html_aceg_ncorr"].objeto.disabled = true;
		}
	}	
	
}

function Buscar()
{
	miform = document.buscador;
	
	miform.action = "genera_egreso.asp"; 
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
                    <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF"><strong>Resultado
                          del Proceso de Egreso</strong></font></div>
                    </td>
                    <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
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
                      <td><div align="right">P&aacute;ginas:
                          <b><%f_egre.AccesoPagina%></b>
                      </div></td>
                      
                    </tr>
                    <tr>
                      <td ><div align="left"><%pagina.DibujarSubtitulo("Listado de Alumnos Egresados")%></div></td>
                    </tr><form name="edicion" action="" method="post">
                    <tr>
                      <td >
                    
                        <div align="center">
                            <% f_egre.DibujaTabla %>                 
                      
                      </div>
                     </td>
                    </tr>
                    <tr>
                      <td ><div align="right">
					      <input type="hidden" name="egre[0][registros]" value="<%=f_egre.nroFilas%>">
								     <%if f_egre.NroFilas > 0 and negresados_sin_acta > 0 then%>
								     <table width="50%"  border="0">
                                       <tr>
                                         <td><%botonera.DibujaBoton("generar_acta_egreso")%></td>
                                         <td>&nbsp;(Sólo alumnos sin acta)</td>
                                       </tr>
                                     </table>
                                       
                                      <%end if%>
                      </div></td>
                    </tr> </form>
                    <tr>
                      <td >&nbsp;</td>
                    </tr>
                    <tr>
                      <td ><div align="right">P&aacute;ginas: <b>
                        <%f_actas.AccesoPagina%>
                      </b></div></td>
                    </tr>
                    <tr>
                      <td ><div align="left"><%pagina.DibujarSubtitulo("Actas de Egreso")%></div></td>
                    </tr>
                    <tr>
                      <td ><form name="actas">
                    
                        <div align="center">
                            <% f_actas.DibujaTabla %>                 
                      
                      </div>
                      </form></td>
                    </tr>
                    <tr>
                      <td >&nbsp;</td>
                    </tr>
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
                      <td width="8%">
                        <div align="left">                          </div></td>
                      <td width="8%">
                        <div align="left">                          </div></td>
                      <td width="49%"><div align="left">
                        </div></td>
                      <td width="35%">
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
<script language="JavaScript">
</script>
</body>

</html>