<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
q_plan_ccod = Request.QueryString("busqueda[0][plan_ccod]")
q_carr_ccod = Request.QueryString("busqueda[0][carr_ccod]")
q_espe_ccod = Request.QueryString("busqueda[0][espe_ccod]")

'------------------------------------------------------------------------------------------------------------------
set botonera = new Cformulario
botonera.carga_parametros "requisitos_titulacion.xml","botonera"

set pagina = new cpagina
pagina.titulo = "Requisito Titulación"

set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new Cnegocio
negocio.Inicializa conexion

'--------------------------------------------------------------------------------------------------------------------
v_pers_ncorr = conexion.ConsultaUno("select pers_ncorr from personas where pers_nrut = '" & q_pers_nrut & "'")
if not (v_pers_ncorr = "" or IsNull(v_pers_ncorr) or IsEmpty(v_pers_ncorr)) then
	sentencia = "registra_nota_egreso(" & v_pers_ncorr & ", " & q_plan_ccod & ")"
	conexion.EstadoTransaccion conexion.EjecutaP(sentencia)
	
	sentencia = "genera_requisitos_obligatorios(" & v_pers_ncorr & ", " & q_plan_ccod & ")"
	conexion.EstadoTransaccion conexion.EjecutaP(sentencia)
end if


v_sede_ccod = negocio.ObtenerSede

'--------------------------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "requisitos_titulacion.xml", "busqueda"
f_busqueda.Inicializar conexion

consulta = "SELECT '' FROM dual"
f_busqueda.Consultar consulta
f_busqueda.Siguiente

f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.AgregaCampoCons "plan_ccod", q_plan_ccod
f_busqueda.AgregaCampoCons "carr_ccod", q_carr_ccod
f_busqueda.AgregaCampoCons "espe_ccod", q_espe_ccod


'--------------------------------------------------------------------------------------------------------------------
set f_requisitos = new CFormulario
f_requisitos.Carga_Parametros "requisitos_titulacion.xml", "requisitos"
f_requisitos.Inicializar conexion
		   
consulta = "select b.plan_ccod, a.pers_ncorr, c.repl_ncorr, b.egre_ncorr, e.treq_ccod, e.treq_tdesc, nvl(to_char(d.repl_nponderacion), '&nbsp;') as repl_nponderacion, " & vbCrLf &_
           "       d.repl_bobligatorio, b.egre_fegreso, c.reti_ncorr, c.reti_ftermino, " & vbCrLf &_
		   "	   decode(d.repl_bobligatorio,'S','*','&nbsp;') as obligatorio, " & vbCrLf &_
		   "	   nvl(to_char(c.reti_nnota, '0.0'), '&nbsp;') as reti_nnota, f.ereq_tdesc, g.teva_tdesc " & vbCrLf &_
		   "from personas a, egresados b, requisitos_titulacion c, requisitos_plan d, tipos_requisitos_titulo e, estados_requisitos f, tipos_evaluacion_requisitos g " & vbCrLf &_
		   "where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
		   "  and b.egre_ncorr = c.egre_ncorr " & vbCrLf &_
		   "  and c.repl_ncorr = d.repl_ncorr " & vbCrLf &_
		   "  and d.treq_ccod = e.treq_ccod " & vbCrLf &_
		   "  and nvl(c.ereq_ccod, 2) = f.ereq_ccod " & vbCrLf &_
		   "  and e.teva_ccod = g.teva_ccod " & vbCrLf &_
		   "  and a.pers_nrut = '" & q_pers_nrut & "' " & vbCrLf &_
		   "  and b.plan_ccod = '" & q_plan_ccod & "' " & vbCrLf &_
		   "  and b.sede_ccod = '" & v_sede_ccod & "' " & vbCrLf &_
		   "  --and b.peri_ccod = '" & v_peri_ccod & "' " & vbCrLf &_
		   "order by d.repl_bobligatorio desc, e.teva_ccod asc, d.treq_ccod asc"
		   
consulta = "SELECT egresados.plan_ccod, personas.pers_ncorr, egresados.egre_ncorr, " & _
"       tipos_requisitos_titulo.treq_ccod, tipos_requisitos_titulo.treq_tdesc," & _
"       requisitos_plan.repl_nponderacion, requisitos_plan.repl_bobligatorio," & _
"       egresados.egre_fegreso, requisitos_titulacion.reti_ncorr," & _
"       requisitos_titulacion.reti_ftermino, to_char(requisitos_titulacion.reti_nnota, '0.0') as reti_nnota," & _
"       estados_requisitos.ereq_tdesc, tipos_evaluacion_requisitos.teva_tdesc,requisitos_titulacion.repl_ncorr" & _
"  FROM personas," & _
"       egresados," & _
"       tipos_requisitos_titulo," & _
"       requisitos_plan," & _
"       requisitos_titulacion," & _
"       estados_requisitos," & _
"       tipos_evaluacion_requisitos" & _
" WHERE (    (tipos_requisitos_titulo.treq_ccod = requisitos_plan.treq_ccod)" & _
"        AND (egresados.egre_ncorr = requisitos_titulacion.egre_ncorr)" & _
"        AND (requisitos_plan.repl_ncorr = requisitos_titulacion.repl_ncorr)" & _
"        AND (personas.pers_ncorr = egresados.pers_ncorr)" & _
"        AND (estados_requisitos.ereq_ccod(+) = requisitos_titulacion.ereq_ccod)" & _
"        AND (tipos_evaluacion_requisitos.teva_ccod = tipos_requisitos_titulo.teva_ccod)" & _
"  		 and personas.pers_nrut = '" & q_pers_nrut & "' " & vbCrLf &_
"  		 and egresados.plan_ccod = '" & q_plan_ccod & "' " & vbCrLf &_
"  		 and egresados.sede_ccod = '" & v_sede_ccod & "' " & vbCrLf &_
"       )" & vbCrLf &_
"  order by repl_bobligatorio desc, tipos_evaluacion_requisitos.teva_ccod asc, treq_ccod asc"

'response.Write("<pre>"&consulta&"</pre>")		
f_requisitos.Consultar consulta

'----------------------------------------------------------------------------------------------------------
set fc_datos = new CFormulario
fc_datos.Carga_Parametros "consulta.xml", "consulta"
fc_datos.Inicializar conexion

consulta = "select b.egre_ncorr, a.pers_nrut || '-' || a.pers_xdv as rut, " & vbCrLf &_
           "       a.pers_tape_paterno || ' ' || a.pers_tape_materno || ' ' || a.pers_tnombre as nombre, " & vbCrLf &_
		   "	   f.sede_tdesc, e.carr_tdesc, d.espe_tdesc, c.plan_ncorrelativo, g.inst_trazon_social " & vbCrLf &_
		   "from personas a, egresados b, planes_estudio c, especialidades d, carreras e, sedes f, instituciones g " & vbCrLf &_
		   "where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
		   "  and b.plan_ccod = c.plan_ccod " & vbCrLf &_
		   "  and c.espe_ccod = d.espe_ccod " & vbCrLf &_
		   "  and d.carr_ccod = e.carr_ccod " & vbCrLf &_
		   "  and b.sede_ccod = f.sede_ccod " & vbCrLf &_
		   "  and e.inst_ccod = g.inst_ccod " & vbCrLf &_
		   "  and a.pers_nrut = '" & q_pers_nrut & "' " & vbCrLf &_
		   "  and b.plan_ccod = '" & q_plan_ccod & "'"

fc_datos.Consultar consulta
fc_datos.Siguiente

v_egre_ncorr = fc_datos.ObtenerValor("egre_ncorr")


'------------------------------------------------------------------------------------------------------------------------
consulta = "select count(distinct d.acti_ncorr) " & vbCrLf &_
           "from personas a, egresados b, requisitos_titulacion c, detalle_actas_titulacion d " & vbCrLf &_
		   "where a.pers_ncorr = b.pers_ncorr " & vbCrLf &_
		   "  and b.egre_ncorr = c.egre_ncorr " & vbCrLf &_
		   "  and c.reti_ncorr = d.reti_ncorr " & vbCrLf &_
		   "  and b.plan_ccod = '" & q_plan_ccod & "' " & vbCrLf &_
		   "  and a.pers_nrut = '" & q_pers_nrut & "'"
		   
v_nactas_alumno = CLng(conexion.ConsultaUno(consulta))

	
'response.Write(v_nactas_alumno)
if v_nactas_alumno > 0 then
	f_requisitos.AgregaParam "editar", "FALSE"
	f_requisitos.AgregaParam "eliminar", "FALSE"
	v_nfilas_check = 0
	botonera.agregabotonParam "eliminar","deshabilitado","true"
	botonera.agregabotonParam "agregar","deshabilitado","true"
	
else
	v_nfilas_check = f_requisitos.NroFilas
end if
  
  
  
'------------------------------------------------------------------------------------------------------------------------

set fc_especialidades = new CFormulario
fc_especialidades.Carga_Parametros "consulta.xml", "consulta"
fc_especialidades.Inicializar conexion
fc_especialidades.Consultar ("select * from especialidades order by carr_ccod, espe_tdesc")

set fc_planes = new CFormulario
fc_planes.Carga_Parametros "consulta.xml", "consulta"
fc_planes.Inicializar conexion
fc_planes.Consultar ("select * from planes_estudio order by espe_ccod, plan_ncorrelativo")


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'f_busqueda.AgregaCampoParam "sede_ccod", "tipo", "INPUT"
'f_busqueda.AgregaCampoParam "sede_ccod", "permiso", "OCULTO"
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

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


function FilasSeleccionadas(formulario)
{
	nseleccionados = 0;
	
	for (i = 0; i < <%=v_nfilas_check%>; i++) {
		if (formulario.elements["requisitos[" + i + "][reti_ncorr]"].checked) {
			nseleccionados++;
		}
	}
	
	return nseleccionados;
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


function BloquearCheckObligatorios(formulario)
{
	for (i = 0; i < <%=v_nfilas_check%>; i++) {		
		if (formulario.elements["requisitos[" + i + "][repl_bobligatorio]"].value == "S") {
			formulario.elements["requisitos[" + i + "][reti_ncorr]"].setAttribute("disabled", true);
		}
	}
}


function InicioPagina()
{	
	CargarEspecialidades(document.buscador, document.buscador.elements["busqueda[0][carr_ccod]"].value);
	document.buscador.elements["busqueda[0][espe_ccod]"].value = '<%=q_espe_ccod%>';
	
	CargarPlanes(document.buscador, document.buscador.elements["busqueda[0][espe_ccod]"].value);
	document.buscador.elements["busqueda[0][plan_ccod]"].value = '<%=q_plan_ccod%>';
	
	//BloquearCheckObligatorios(document.edicion);	
}

</script>

<style type="text/css">
<!--
.Estilo2 {color: #FFFFFF}
-->
</style>
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
                      <div align="left" class="Estilo2">Buscador</div></td>
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
                          <td>RUT<br>
                            <%f_busqueda.dibujacampo("pers_nrut")%>
                            -
                            <%f_busqueda.dibujacampo("pers_xdv")%>
                            &nbsp;
                            <%pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]"%></td>
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
                    <td width="153" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left" class="Estilo2">Requisitos de Titulaci&oacute;n</div>
                    </td>
                    <td width="504" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
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
                        <td height="20" nowrap>RUT</td>
                        <td nowrap><div align="right"><strong>:</strong></div></td>
                        <td width="216" nowrap><strong><%=fc_datos.obtenervalor("rut") %></strong></td>
                        <td width="76" nowrap>Nombre</td>
                        <td width="6" nowrap><div align="center"><strong>:</strong></div></td>
                        <td width="289" nowrap><strong><%=fc_datos.obtenervalor("nombre") %></strong></td>
                      </tr>
                      <tr>
                        <td height="20" nowrap>Sede</td>
                        <td nowrap><div align="right"><strong>:</strong></div></td>
                        <td nowrap><strong><%=fc_datos.obtenervalor("sede_tdesc") %></strong></td>
                        <td nowrap>Instituci&oacute;n</td>
                        <td nowrap><div align="center"><strong>:</strong></div></td>
                        <td nowrap><strong><%=fc_datos.obtenervalor("inst_trazon_social") %></strong></td>
                      </tr>
                      <tr>
                        <td width="47" height="20" nowrap>Carrera</td>
                        <td width="" nowrap><div align="right"><strong>:</strong></div></td>
                        <td nowrap colspan="4"><strong><%=fc_datos.obtenervalor("carr_tdesc") %> - <%=fc_datos.obtenervalor("espe_tdesc") %> - <%=fc_datos.obtenervalor("plan_ncorrelativo") %></strong></td>
                        
                      </tr>
                    </table>
                  </div>
                  <table width="665" border="0">
                    <tr>
                      <td><div align="right">
                      </div></td>
                      
                    </tr>
                    <tr>
                      <td ><div align="left"><br>
                          <br>
                        <%pagina.DibujarSubtitulo("Requisitos de Titulación del Alumno")%></div></td>
                    </tr><form name="edicion" action="" method="post">
                    <tr>
                      <td >
                    
                        <div align="center">
                            <% f_requisitos.DibujaTabla %>                 
                      
                      </div>
                     </td>
                    </tr>
                    <tr>
                      <td ><div align="right">
                      </div></td>
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
                      <td width="8%">
                        <div align="left">                          </div></td>
                      <td width="27%">
                        <div align="center">
                          <%
						   botonera.AgregaBotonUrlParam "agregar","egre_ncorr",v_egre_ncorr
						  botonera.dibujaboton "agregar" %>
                        </div></td>
                      <td width="35%">
                        <div align="center">
                          <%botonera.dibujaboton "eliminar" %>
                        </div></td><td width="30%">
                          <div align="center">
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
	</td>
  </tr>  
</table>
</body>
</html>