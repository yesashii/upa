<!--#include file="../biblioteca/_conexion.asp"-->
<!--#include file="../biblioteca/_negocio.asp"-->
<%
'-----------------------------------------------------------------------------------------------------------------
q_carr_ccod = Request.QueryString("busqueda[0][carr_ccod]")
q_peri_ccod = Request.QueryString("busqueda[0][peri_ccod]")
q_espe_ccod = Request.QueryString("busqueda[0][espe_ccod]")
q_plan_ccod = Request.QueryString("busqueda[0][plan_ccod]")
q_sede_ccod = Request.QueryString("busqueda[0][sede_ccod]")

'-----------------------------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Proceso de Titulación"

set conexion = new cConexion
conexion.Inicializar "desauas"

set negocio = new cnegocio
negocio.Inicializa conexion

buscando = false
if (q_carr_ccod <> "") and (q_peri_ccod <> "") and (q_espe_ccod <> "") and (q_plan_ccod <> "") and (q_sede_ccod <> "") then
	buscando = true
	'v_usuario = negocio.ObtenerUsuario	
	
	sentencia = "registra_nota_egreso_alumnos(" & q_plan_ccod & ", " & q_sede_ccod & ", " & q_peri_ccod & ")"
	conexion.EstadoTransaccion conexion.EjecutaP(sentencia)
end if



'-------------------------------------------------------------------------------------------------------------------------	
if q_sede_ccod = "" then
	v_sede_ccod = negocio.ObtenerSede
else
	v_sede_ccod = q_sede_ccod
end if

if q_peri_ccod = "" then
	v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")
else
	v_peri_ccod = q_peri_ccod
end if



'-------------------------------------------------------------------------------------------------------------------------
set f_busqueda = new cFormulario
f_busqueda.Carga_Parametros "lista_titulados.xml", "f_busqueda"
f_busqueda.Inicializar conexion


consulta = "SELECT '" & v_sede_ccod & "' AS sede_ccod, " &_
           "       '" & v_peri_ccod & "' AS peri_ccod, " &_
		   "       '" & q_carr_ccod & "' AS carr_ccod, " &_
		   "       '" & q_espe_ccod & "' AS espe_ccod " &_
           "FROM dual"
		   

f_busqueda.Consultar consulta
f_busqueda.Siguiente


'--------------------------------------------------------------------------------------------------------------------------
set botonera = new cformulario
botonera.carga_parametros "lista_titulados.xml","botonera"

set f_datos = new cFormulario
f_datos.Carga_Parametros "lista_titulados.xml", "f_datos"
f_datos.Inicializar conexion

consulta = "select a.plan_ncorrelativo, b.espe_tdesc, c.carr_tdesc, d.inst_trazon_social, (select peri_tdesc from periodos_academicos where peri_ccod = '"&q_peri_ccod&"') as periodo, (select sede_tdesc from sedes where sede_ccod = '" & v_sede_ccod & "') as sede_tdesc " & vbCrLf &_
           "from planes_estudio a, especialidades b, carreras c, instituciones d " & vbCrLf &_
		   "where a.espe_ccod = b.espe_ccod " & vbCrLf &_
		   "  and b.carr_ccod = c.carr_ccod " & vbCrLf &_
		   "  and c.inst_ccod = d.inst_ccod " & vbCrLf &_
		   "  and a.plan_ccod = '" & q_plan_ccod & "'"

f_datos.Consultar consulta
f_datos.Siguiente

'---------------------------------------------------------------------------------------------------------------------------------
set fc_requisitos = new CFormulario
fc_requisitos.Carga_Parametros "consulta.xml", "consulta"
fc_requisitos.Inicializar conexion

consulta = "select rownum as nrequisito, a.* " & vbCrLf &_
           "from ( " & vbCrLf &_
		   "select b.*, nvl(a.repl_nponderacion, 0) as repl_nponderacion " & vbCrLf &_
		   "from requisitos_plan a, tipos_requisitos_titulo b " & vbCrLf &_
		   "where a.treq_ccod = b.treq_ccod " & vbCrLf &_
		   "  and b.teva_ccod = 1 " & vbCrLf &_
		   "  and a.plan_ccod = '" & q_plan_ccod & "' " & vbCrLf &_
		   "  and a.sede_ccod = '" & v_sede_ccod & "' " & vbCrLf &_
		   "  and a.peri_ccod = '" & v_peri_ccod & "' " & vbCrLf &_
		   "order by a.repl_bobligatorio desc, b.treq_ccod asc" & vbCrLf &_
		   ") a"
'response.Write("<pre>"&consulta&"</pre>")

fc_requisitos.Consultar consulta
v_nrequisitos = fc_requisitos.NroFilas

v_suma_ponderaciones = 0
while fc_requisitos.Siguiente
	v_suma_ponderaciones = v_suma_ponderaciones + CInt(fc_requisitos.ObtenerValor("repl_nponderacion"))
wend
fc_requisitos.Inicializar conexion




'-----------------------------------------------------------------------------------------------------------------------------------
set fc_titulados = new CFormulario
fc_titulados.Carga_Parametros "lista_titulados.xml", "titulados"
fc_titulados.Inicializar conexion


consulta = "select rownum as n, a.* from ( " & vbCrLf &_
           "select b.egre_ncorr, c.pers_ncorr, b.espe_ccod || '-' || b.plan_ccod as p1_historico, c.pers_nrut as p2_historico, c.pers_xdv as p3_historico, " & vbCrLf &_
		   "	   c.pers_tape_paterno || ' ' || c.pers_tape_materno || ' ' || c.pers_tnombre as nombre, " & vbCrLf &_
		   "	   c.pers_nrut || '-' || c.pers_xdv as rut, " & vbCrLf &_
		   "	   d.anos_ccod || '/' || substr(upper(d.peri_tdesc), 1, 1) as periodo_ingreso, " & vbCrLf &_
		   "	   e.anos_ccod || '/' || substr(upper(e.peri_tdesc), 1, 1) as periodo_egreso, " & vbCrLf &_
		   "	   to_char(a.fecha_entrega, 'dd/mm/yyyy') as fecha_entrega, " & vbCrLf &_
		   "       h.aceg_ncorr, decode(b.egre_nregistro_titulo ||  '/' || b.egre_nfolio_titulo, '/', '&nbsp;', b.egre_nregistro_titulo ||  '/' || b.egre_nfolio_titulo) as reg_folio, " & vbCrLf 
		   
for i_ = 1 to v_nrequisitos
	consulta = consulta & "	   to_char(max(decode(g.nrequisito," & i_ & ",f.reti_nnota)), '0.0') as n" & i_ & ", " & vbCrLf &_
	                      "	   to_char(max(decode(g.nrequisito," & i_ & ",f.reti_nnota * g.repl_nponderacion / 100)), '0.00') as p" & i_ & ", " & vbCrLf
next
'nota_titulacion(b.egre_ncorr), '0.0') as nota_titulacion
consulta = consulta & _
           "	   to_char(nota_titulacion(b.egre_ncorr), '0.0') as nota_titulacion " & vbCrLf & _ 
		   " from (select egre_ncorr, min(cumplido) as cumplido, decode(min(cumplido),1,max(reti_ftermino)) as fecha_entrega " & vbCrLf &_
		   "      from (select a.egre_ncorr, a.repl_ncorr, " & vbCrLf &_
		   "                   decode(a.repl_bobligatorio,'S','S','N',decode(b.reti_ncorr,null, 'N', 'S')) as obligatorio, " & vbCrLf &_
		   "            	    decode(b.ereq_ccod,1,1,0) as cumplido, " & vbCrLf &_
		   "            	     b.reti_ftermino " & vbCrLf &_
		   "            from (select a.egre_ncorr, b.repl_ncorr, b.repl_bobligatorio  " & vbCrLf &_
		   "                  from egresados a, requisitos_plan b " & vbCrLf &_
		   "                  where a.plan_ccod = b.plan_ccod " & vbCrLf &_
		   "                    and a.sede_ccod = b.sede_ccod " & vbCrLf &_
		   "                    and a.peri_ccod = b.peri_ccod " & vbCrLf &_
		   "                    and a.plan_ccod = '" & q_plan_ccod & "' " & vbCrLf &_
		   "                    and a.peri_ccod = '" & v_peri_ccod & "' " & vbCrLf &_
		   "                    and a.sede_ccod = '" & v_sede_ccod & "' " & vbCrLf &_
		   "                  order by a.egre_ncorr, b.treq_ccod) a, requisitos_titulacion b " & vbCrLf &_
		   "            where a.egre_ncorr = b.egre_ncorr (+) " & vbCrLf &_
		   "              and a.repl_ncorr = b.repl_ncorr (+) ) " & vbCrLf &_
		   "      where obligatorio = 'S' " & vbCrLf &_
		   "      group by egre_ncorr) a, egresados b, personas c, periodos_academicos d, periodos_academicos e, requisitos_titulacion f, " & vbCrLf &_
		   "	  (select rownum as nrequisito, a.* " & vbCrLf &_
		   "	   from (select a.* " & vbCrLf &_
		   "	         from requisitos_plan a, tipos_requisitos_titulo b " & vbCrLf &_
		   "			 where a.treq_ccod = b.treq_ccod " & vbCrLf &_
		   "			   and b.teva_ccod = 1 " & vbCrLf &_
		   "			   and a.plan_ccod = '" & q_plan_ccod & "' " & vbCrLf &_
		   "			   and a.peri_ccod = '" & v_peri_ccod & "' " & vbCrLf &_
		   "			   and a.sede_ccod = '" & v_sede_ccod & "' " & vbCrLf &_
		   "			 order by a.repl_bobligatorio desc, a.treq_ccod asc) a " & vbCrLf &_
		   "	   ) g, detalle_actas_egresos h " & vbCrLf &_
		   "where a.egre_ncorr = b.egre_ncorr " & vbCrLf &_
		   "  and b.pers_ncorr = c.pers_ncorr " & vbCrLf &_
		   "  and b.peri_ccod_ingreso = d.peri_ccod " & vbCrLf &_
		   "  and b.peri_ccod = e.peri_ccod  " & vbCrLf &_
		   "  and b.egre_ncorr = f.egre_ncorr " & vbCrLf &_
		   "  and f.repl_ncorr = g.repl_ncorr " & vbCrLf &_
		   "  and b.egre_ncorr = h.egre_ncorr " & vbCrLf &_
		   "  and f.ereq_ccod = 1 " & vbCrLf &_
		   "  and a.cumplido = 1 " & vbCrLf &_
		   "group by a.fecha_entrega, b.egre_ncorr, c.pers_ncorr, b.espe_ccod, b.plan_ccod, c.pers_nrut, c.pers_xdv, " & vbCrLf &_
		   "         c.pers_nrut, c.pers_xdv, c.pers_tape_paterno, c.pers_tape_materno, c.pers_tnombre, " & vbCrLf &_
		   "		 d.anos_ccod, d.peri_tdesc, e.anos_ccod, e.peri_tdesc, h.aceg_ncorr, b.egre_nregistro_titulo, b.egre_nfolio_titulo " & vbCrLf &_
		   "order by nombre " & vbCrLf &_
		   ") a"

'response.Write("<pre>"&consulta&"</pre>")
'response.Flush()
fc_titulados.Consultar consulta

'----------------------------------------------------------------------------------------------------------------------
set f_actas_titulacion = new CFormulario
f_actas_titulacion.Carga_Parametros "lista_titulados.xml", "actas_titulacion"
f_actas_titulacion.Inicializar conexion

	   
consulta = "select a.acti_ncorr, a.acti_femision, count(distinct c.egre_ncorr) as ntitulados " & vbCrLf &_
           "from actas_titulacion a, detalle_actas_titulacion b, requisitos_titulacion c " & vbCrLf &_
		   "where a.acti_ncorr = b.acti_ncorr " & vbCrLf &_
		   "  and a.plan_ccod = '" & q_plan_ccod & "' " & vbCrLf &_
		   "  and a.espe_ccod = '" & q_espe_ccod & "' " & vbCrLf &_
		   "  and a.sede_ccod = '" & v_sede_ccod & "' " & vbCrLf &_
		   "  and a.peri_ccod = '" & v_peri_ccod & "' " & vbCrLf &_
		   "  and b.reti_ncorr = c.reti_ncorr " & vbCrLf &_
		   "group by a.acti_ncorr, a.acti_femision " & vbCrLf &_
		   "order by a.acti_femision asc, a.acti_ncorr asc"
		   
		   
f_actas_titulacion.Consultar consulta


'------------------------------------------------------------------------------------------------------------------------
consulta = "select count(*) from ( " & vbCrLf &_
           "select egre_ncorr, min(cumplido) as cumplido, decode(min(cumplido),1,max(reti_ftermino)) as fecha_entrega " & vbCrLf &_
		   "from (select a.egre_ncorr, a.repl_ncorr, " & vbCrLf &_
		   "             decode(a.repl_bobligatorio,'S','S','N',decode(b.reti_ncorr, null, 'N', 'S')) as obligatorio, " & vbCrLf &_
		   "      	     decode(b.ereq_ccod,1,1,0) as cumplido, " & vbCrLf &_
		   "      	     b.reti_ftermino " & vbCrLf &_
		   "      from (select a.egre_ncorr, b.repl_ncorr, b.repl_bobligatorio " & vbCrLf &_
		   "            from egresados a, requisitos_plan b " & vbCrLf &_
		   "            where a.plan_ccod = b.plan_ccod " & vbCrLf &_
		   "              and a.sede_ccod = b.sede_ccod " & vbCrLf &_
		   "              and a.peri_ccod = b.peri_ccod " & vbCrLf &_
		   "              and a.plan_ccod = '" & q_plan_ccod & "' " & vbCrLf &_
		   "			  and a.espe_ccod = '" & q_espe_ccod & "' " & vbCrLf &_
		   "              and a.peri_ccod = '" & v_peri_ccod & "' " & vbCrLf &_
		   "              and a.sede_ccod = '" & v_sede_ccod & "' " & vbCrLf &_
		   "            order by a.egre_ncorr, b.treq_ccod) a, requisitos_titulacion b " & vbCrLf &_
		   "      where a.egre_ncorr = b.egre_ncorr (+) " & vbCrLf &_
		   "        and a.repl_ncorr = b.repl_ncorr (+) ) a " & vbCrLf &_
		   "where a.obligatorio = 'S' " & vbCrLf &_
		   "group by a.egre_ncorr " & vbCrLf &_
		   "having min(a.cumplido) = 1 " & vbCrLf &_
		   ") a " & vbCrLf &_
		   "where not exists (select 1 " & vbCrLf &_
		   "                  from detalle_actas_titulacion a2, requisitos_titulacion b2 " & vbCrLf &_
		   "				  where a2.reti_ncorr = b2.reti_ncorr " & vbCrLf &_
		   "				    and b2.egre_ncorr = a.egre_ncorr) "
		   
v_ntitulados_sin_acta = CLng(conexion.ConsultaUno(consulta))


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
f_busqueda.AgregaCampoParam "sede_ccod", "tipo", "INPUT"
f_busqueda.AgregaCampoParam "sede_ccod", "permiso", "OCULTO"
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

function GenerarActa(formulario)
{
	v_suma_ponderaciones = '<%=v_suma_ponderaciones%>';
	
	if (v_suma_ponderaciones == '100')  {
		if (confirm("Se agregarán solamente los alumnos que no aparecen en ninguna acta.\n\n¿Está seguro que desea generar una nueva Acta de Titulación?")) {
			formulario.elements["btGenerar"].setAttribute("disabled", true);
			
			formulario.action = "proc_generar_acta_titulacion.asp";
			formulario.method = "post";
			formulario.submit();
		}
	} else {
		alert ('No se puede generar acta de titulación, porque la suma de las \nponderaciones de los requisitos de titulación no suma 100% (Suma '+v_suma_ponderaciones+'%).');
	}
}


function Salir()
{
	window.close();
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


function Buscar(formulario)
{
	if (preValidaFormulario(formulario)) {
		return true
	}
	return false
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function InicioPagina()
{
	CargarEspecialidades(document.buscador, document.buscador.elements["busqueda[0][carr_ccod]"].value);
	document.buscador.elements["busqueda[0][espe_ccod]"].value = '<%=q_espe_ccod%>';
	
	CargarPlanes(document.buscador, document.buscador.elements["busqueda[0][espe_ccod]"].value);
	document.buscador.elements["busqueda[0][plan_ccod]"].value = '<%=q_plan_ccod%>';	
	
}

//-->
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
                          del Proceso de Titulaci&oacute;n </strong></font></div>
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
                    <br>
                    <br>
</div>
                  <table width="665" border="0">
                    <tr>
                      <td ><div align="left"><%pagina.DibujarSubtitulo("Listado de Alumnos Titulados")%></div></td>
                    </tr>
                    <tr>
                      <td >
					  <form name="edicion">
							<input type="hidden" name="acta[0][plan_ccod]" value="<%=q_plan_ccod%>">
							<input type="hidden" name="acta[0][espe_ccod]" value="<%=q_espe_ccod%>">
							<input type="hidden" name="acta[0][peri_ccod]" value="<%=v_peri_ccod%>">
							<input type="hidden" name="acta[0][sede_ccod]" value="<%=v_sede_ccod%>">
                            <table width="97%" align="center" cellpadding="0" cellspacing="0">
                              <tr> 
                                <td></td>
                              </tr>
                              <tr> 
                                <td align="right"></td>
                              </tr>
                              <tr> 
                                <td align="right">P&aacute;ginas: 
                                  <%fc_titulados.AccesoPagina%></td>
                              </tr>
                              <tr> 
                                <td height="19" align="center"> <table width="100%" border="1" align="center" cellpadding=0 cellspacing=0 bordercolor="#FFFFFF" bgcolor="#6382AD">
                                    <tr align="center"> 
                                      <td colspan="7"><span class="tituloTabla">&nbsp;</span></td>
                                      <td colspan="<%=(v_nrequisitos * 2)%>"><span class="tituloTabla"><strong>Notas 
                                        Finales</strong></span></td>
                                      <td colspan="2"><span class="tituloTabla">&nbsp;</span></td>
                                    </tr>
                                    <tr align="center"> 
                                      <td width="5%" rowspan="2"><span class="tituloTabla"><strong>N&ordm;</strong></span></td>
                                      <td width="30%" rowspan="2"><span class="tituloTabla"><strong>Alumno</strong></span></td>
                                      <td width="15%" rowspan="2"><span class="tituloTabla"><strong>RUT</strong></span></td>
                                      <td width="6%" rowspan="2"><span class="tituloTabla"><strong>N&ordm;<br>
                                        Acta<br>
                                        Egreso</strong></span></td>
                                      <td width="4%" rowspan="2"><span class="tituloTabla"><strong>A&ntilde;o<br>
                                        Sem.<br>
                                        Ing.</strong> </span></td>
                                      <td width="4%" rowspan="2"><span class="tituloTabla"><strong>A&ntilde;o<br>
                                        Sem.<br>
                                        Egr.</strong></span></td>
                                      <td width="6%" rowspan="2"><span class="tituloTabla"><strong>Fecha<br>
                                        Entreg.<br>
                                        Req. </strong></span></td>                                      
                                      <%
										while fc_requisitos.Siguiente										     
										%>
                                      <td colspan="2" title="<%=fc_requisitos.ObtenerValor("treq_tdesc")%>"><span class="tituloTabla"><strong><br>
                                        <%=fc_requisitos.ObtenerValor("repl_nponderacion")%>% </strong></span></td>
                                      <%
										wend
										%>
                                      <td width="5%" rowspan="2"><span class="tituloTabla"><strong>Nota<br>
                                        Final </strong></span></td>
                                      <td rowspan="2"><span class="tituloTabla"><strong>Reg.<br>
                                        Folio<br>
                                        Titulos</strong></span></td> 
                                    </tr>
                                    <tr align="center">                                      
                                      <%
									  i_ = 0
									  while i_ < v_nrequisitos 
									  %>
                                      <td><span class="tituloTabla">Nota</span></td>
                                      <td><span class="tituloTabla">Pond</span></td>
                                      <%
									  		i_ = i_ + 1
									  wend
									  %>
                                    </tr>
                                    <%
									while fc_titulados.Siguiente
									%>
                                    <tr align="center" bordercolor="#FFFFFF" bgcolor="#ADC7E7"> 
                                      <td><font size="1" face="Arial, Helvetica, sans-serif"><%=fc_titulados.ObtenerValor("n")%></font></td>
                                      <td><div align="left"><font size="1" face="Arial, Helvetica, sans-serif"><%=fc_titulados.ObtenerValor("nombre")%></font></div></td>
                                      <td><font size="1" face="Arial, Helvetica, sans-serif"><%=fc_titulados.ObtenerValor("rut")%></font></td>
                                      <td><font size="1" face="Arial, Helvetica, sans-serif"><%=fc_titulados.ObtenerValor("aceg_ncorr")%>&nbsp; </font></td>
                                      <td><font size="1" face="Arial, Helvetica, sans-serif"><%=fc_titulados.ObtenerValor("periodo_ingreso")%></font></td>
                                      <td><font size="1" face="Arial, Helvetica, sans-serif"><%=fc_titulados.ObtenerValor("periodo_egreso")%></font></td>
                                      <td><font size="1" face="Arial, Helvetica, sans-serif"><%=fc_titulados.ObtenerValor("fecha_entrega")%></font></td>
                                      <%
									  i_ = 1
									  while i_ <= v_nrequisitos
									  %>
                                      <td><font size="1" face="Arial, Helvetica, sans-serif"><%=fc_titulados.ObtenerValor("n" & i_)%></font></td>
                                      <td><font size="1" face="Arial, Helvetica, sans-serif"><%=fc_titulados.ObtenerValor("p" & i_)%></font></td>
                                      <%
									  i_ = i_ + 1
									  wend
									  %>
                                      <td><font size="1" face="Arial, Helvetica, sans-serif"><%=fc_titulados.ObtenerValor("nota_titulacion")%></font></td>
                                      <td><font size="1" face="Arial, Helvetica, sans-serif">&nbsp;<%=fc_titulados.ObtenerValor("reg_folio")%></font></td> 
                                    </tr>
                                    <%
									wend
									%>
                                  </table></td>
                              </tr>
							  <%if v_suma_ponderaciones <> 100 then%>
                              <tr>
                                <td height="19" align="center"><strong><font color="#FF0000"><br>
                                  La suma de las ponderaciones no suma 100%.</font></strong></td>
                              </tr>
							  <%end if%>
                              <tr> 
                                <td height="19" align="center"><div align="right"><font size="2"> 
                                    <br>
                                    <%if fc_titulados.NroFilas > 0 and v_ntitulados_sin_acta > 0 then%>
                                    <input name="btGenerar" type="button" id="btGenerar" onClick="GenerarActa(this.form)" value="Generar Acta de Titulaci&oacute;n ">(S&oacute;lo alumnos sin acta)
                                    <%end if%>
                                    </font></div></td>
                              </tr>
                            </table>
                          </form>
					  
					  </td>
                    </tr>
                    <tr>
                      <td ><div align="right"><b>                      </b></div></td>
                    </tr>
                    <tr>
                      <td ><div align="center"></div></td>
                    </tr>
                    <tr>
                      <td ><form name="actas">
                        <table width="97%" border="0" align="center" cellpadding="0" cellspacing="0">
                          <tr>
                            <td><div align="left"><%pagina.DibujarSubtitulo("Actas de Titulación")%></div></td>
                          </tr>
                          <tr>
                            <td>
                              <div align="center">
                                <%f_actas_titulacion.DibujaTabla%>
                            </div></td>
                          </tr>
                        </table>
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
	<p>&nbsp;</p></td>
  </tr>  
</table></body>
</html>