<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina

set f_busqueda = new CFormulario
set conexion = new CConexion
set botonera = new CFormulario
set negocio = new CNegocio

conexion.Inicializar "upacifico"
negocio.Inicializa conexion
'-----------------------------------------------------------------------
pagina.Titulo = "Envíos a Cobranza"

'-----------------------------------------------------------------------
botonera.Carga_Parametros "envios_cobranza.xml", "btn_envios_cobranza"
f_busqueda.Carga_Parametros "envios_cobranza.xml", "fbusqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select '' "
f_busqueda.Siguiente

Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")

 sede = request.querystring("busqueda[0][sede_ccod]")
 empresa = request.querystring("busqueda[0][inen_ccod]")
 estado = request.querystring("busqueda[0][EENV_CCOD]")
 folio = request.querystring("busqueda[0][envi_ncorr]")
 inicio = request.querystring("busqueda[0][envi_fenvio]")
 termino = request.querystring("busqueda[0][envio_termino]") 
 tipo_envio = request.querystring("busqueda[0][tenv_ccod]") 
 rut_alumno = request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito = request.querystring("busqueda[0][pers_xdv]")
 rut_apoderado = request.querystring("busqueda[0][code_nrut]")
 rut_apoderado_digito = request.querystring("busqueda[0][code_xdv]")

f_busqueda.AgregaCampoCons "sede_ccod", sede
f_busqueda.AgregaCampoCons "inen_ccod", empresa
f_busqueda.AgregaCampoCons "EENV_CCOD", estado
f_busqueda.AgregaCampoCons "envi_ncorr", folio
f_busqueda.AgregaCampoCons "envi_fenvio", inicio
f_busqueda.AgregaCampoCons "envio_termino", termino
f_busqueda.AgregaCampoCons "tenv_ccod", tipo_envio
f_busqueda.AgregaCampoCons "pers_nrut", rut_alumno
f_busqueda.AgregaCampoCons "pers_xdv", rut_alumno_digito
f_busqueda.AgregaCampoCons "code_nrut", rut_apoderado
f_busqueda.AgregaCampoCons "code_xdv", rut_apoderado_digito

'---------------------------------------------------------------------------------------------------
set f_listado = new CFormulario
f_listado.Carga_Parametros "envios_cobranza.xml", "f_listado"
f_listado.Inicializar conexion

'sql_listado = "select distinct envi_ncorr as folio, envi_ncorr as num_folio, envi_ncorr,  inen_tdesc as empresa_envio,TINE_CCOD as tipo_empresa," & vbcrlf & _
'			"envi_fenvio as fecha, eenv_tdesc as estado_envio, 0 as retenidos, 0 as saldo, tenv_tdesc as tipo_envio, SUM(cant_doc) as cant_doc  " & vbcrlf & _
'"from (select *   " & vbcrlf & _
'      "from (select distinct nvl(a.envi_ncorr,0) as envi_ncorr, a.envi_fenvio, " & vbcrlf & _
'	             "nvl(a.inen_ccod,0) as inen_ccod, " & vbcrlf & _
'				 "nvl(e.pers_nrut, 0) as pers_nrut, e.pers_xdv, " & vbcrlf & _ 
'				 "nvl(g1.pers_nrut, 0) as code_nrut, g1.pers_xdv as code_xdv, " & vbcrlf & _
'				 "count(b.envi_ncorr) as cant_doc,h.inen_tdesc, h.TINE_CCOD,i.eenv_tdesc,   nvl(l.sede_ccod,0) as sede_ccod, te.tenv_tdesc " & vbcrlf & _
 '          "from envios a, detalle_envios b, detalle_ingresos c, ingresos d, personas e, postulantes f, codeudor_postulacion g, " & vbcrlf & _
 '                "instituciones_envio h, estados_envio i, alumnos k, ofertas_academicas l, sedes m, personas g1, tipos_envios te " & vbcrlf & _
'            "where a.envi_ncorr = b.envi_ncorr (+) " & vbcrlf & _
'              "and b.ting_ccod = c.ting_ccod (+) " & vbcrlf & _
'              "and b.ding_ndocto = c.ding_ndocto (+) " & vbcrlf & _
'              "and b.ingr_ncorr = c.ingr_ncorr (+) " & vbcrlf & _
'              "and c.ingr_ncorr = d.ingr_ncorr (+) " & vbcrlf & _
'              "and d.pers_ncorr = e.pers_ncorr (+) " & vbcrlf & _
'              "and e.pers_ncorr = f.pers_ncorr (+) " & vbcrlf & _
'              "and f.post_ncorr = g.post_ncorr (+) " & vbcrlf & _
'              "and f.peri_ccod (+) =" & Periodo & " " & vbcrlf & _
'              "and a.inen_ccod = h.inen_ccod " & vbcrlf & _
'			  "and (h.TINE_CCOD = 3 or h.TINE_CCOD = 4) " & vbcrlf & _
'              "and a.eenv_ccod = i.eenv_ccod " & vbcrlf & _
'   		  "and f.post_ncorr = k.post_ncorr  (+) " & vbcrlf & _
'			  "and k.emat_ccod (+) = 1 " & vbcrlf & _
'          	  "and k.ofer_ncorr  = l.ofer_ncorr (+) " & vbcrlf & _
'	          "and l.sede_ccod = m.sede_ccod (+) "&_
'			  "and g1.pers_ncorr (+)= g.pers_ncorr " & vbcrlf & _
'			  "and a.tenv_ccod = te.tenv_ccod " & vbcrlf & _
'			  "group by a.inen_ccod,a.envi_ncorr,a.envi_fenvio," & vbcrlf & _
'		      "e.pers_nrut,e.pers_xdv,g1.pers_nrut,g1.pers_xdv, h.inen_tdesc," & vbcrlf & _
'		      "h.TINE_CCOD, i.eenv_tdesc, l.sede_ccod,te.tenv_tdesc" & vbcrlf & _
'		  ") a " & vbcrlf & _
 '          "where a.pers_nrut = nvl('" & rut_alumno & "', a.pers_nrut) " & vbcrlf & _
'              "and a.code_nrut = nvl('" & rut_apoderado & "', a.code_nrut) " & vbcrlf & _
'              "and a.envi_ncorr = nvl('" & folio &  "', a.envi_ncorr) " & vbcrlf & _
'			  "and trunc(a.envi_fenvio)  BETWEEN nvl('" & inicio & "', a.envi_fenvio) AND  nvl('" & termino & "', a.envi_fenvio) " & vbcrlf & _
'		      "and a.inen_ccod = nvl('" & empresa &  "', a.inen_ccod) " & vbcrlf & _
'			  "and a.sede_ccod = nvl('" & sede &  "', a.sede_ccod) " & vbcrlf & _ 
'      ") group by envi_ncorr, inen_tdesc, envi_fenvio, eenv_tdesc,TINE_CCOD,tenv_tdesc	ORDER BY envi_ncorr DESC"

'sql_listado="select distinct envi_ncorr as folio, envi_ncorr as num_folio, envi_ncorr,  inen_tdesc as empresa_envio,TINE_CCOD as tipo_empresa," & vbcrlf & _
'			" envi_fenvio as fecha, eenv_tdesc as estado_envio, 0 as retenidos, 0 as saldo, tenv_tdesc as tipo_envio, SUM(cant_doc) as cant_doc  " & vbcrlf & _
'			" from (" & vbcrlf & _
'			"    select *   " & vbcrlf & _
'			"    from (" & vbcrlf & _
'			"         select distinct isnull(a.envi_ncorr,0) as envi_ncorr, a.envi_fenvio, " & vbcrlf & _
'			"         isnull(a.inen_ccod,0) as inen_ccod, " & vbcrlf & _
'			"         isnull(e.pers_nrut, 0) as pers_nrut, e.pers_xdv, " & vbcrlf & _
'			"         isnull(g1.pers_nrut, 0) as code_nrut, g1.pers_xdv as code_xdv, " & vbcrlf & _
'        	"		  count(b.envi_ncorr) as cant_doc,h.inen_tdesc, h.TINE_CCOD,i.eenv_tdesc,   " & vbcrlf & _
'			"         isnull(l.sede_ccod,0) as sede_ccod, te.tenv_tdesc " & vbcrlf & _
'			"         from envios a left outer join detalle_envios b" & vbcrlf & _
'			"            on a.envi_ncorr = b.envi_ncorr " & vbcrlf & _
'			"         left outer join detalle_ingresos c" & vbcrlf & _
'			"            on  b.ting_ccod = c.ting_ccod and b.ding_ndocto = c.ding_ndocto and b.ingr_ncorr = c.ingr_ncorr" & vbcrlf & _
'			"         left outer join ingresos d" & vbcrlf & _
'			"            on  c.ingr_ncorr = d.ingr_ncorr" & vbcrlf & _
'			"         left outer join personas e" & vbcrlf & _
'			"            on  d.pers_ncorr = e.pers_ncorr " & vbcrlf & _
'			"         left outer join postulantes f" & vbcrlf & _
'			"            on  e.pers_ncorr = f.pers_ncorr" & vbcrlf & _
'			"         left outer join codeudor_postulacion g" & vbcrlf & _
'			"            on  f.post_ncorr = g.post_ncorr" & vbcrlf & _
'			"         join instituciones_envio h" & vbcrlf & _
'			"            on  a.inen_ccod = h.inen_ccod " & vbcrlf & _
'			"         join estados_envio i" & vbcrlf & _
'			"            on  a.eenv_ccod = i.eenv_ccod " & vbcrlf & _
'			"         left outer join alumnos k" & vbcrlf & _
'			"            on  f.post_ncorr = k.post_ncorr  " & vbcrlf & _
'			"         left outer join ofertas_academicas l" & vbcrlf & _
'			"            on   k.ofer_ncorr = l.ofer_ncorr " & vbcrlf & _
'			"         left outer join sedes m" & vbcrlf & _
'			"            on   l.sede_ccod = m.sede_ccod" & vbcrlf & _
'			"         left outer join personas g1" & vbcrlf & _
'			"            on   g.pers_ncorr = g1.pers_ncorr  " & vbcrlf & _
'			"         join tipos_envios te		" & vbcrlf & _
'			"            on   a.tenv_ccod = te.tenv_ccod " & vbcrlf & _
'			"         where cast(f.peri_ccod as varchar) = '"&periodo&"' " & vbcrlf & _
'			"               and (h.TINE_CCOD = 3 or h.TINE_CCOD = 4) " & vbcrlf & _
'			"               and k.emat_ccod = 1 " & vbcrlf & _
'			"         group by a.inen_ccod,a.envi_ncorr,a.envi_fenvio," & vbcrlf & _
'			"                  e.pers_nrut,e.pers_xdv,g1.pers_nrut,g1.pers_xdv, h.inen_tdesc," & vbcrlf & _
'			"                  h.TINE_CCOD, i.eenv_tdesc, l.sede_ccod,te.tenv_tdesc" & vbcrlf & _
'			"        ) a " & vbcrlf & _
'			"    where cast(a.pers_nrut as varchar)= isnull('"&rut_alumno&"', cast(a.pers_nrut as varchar)) " & vbcrlf & _
'			"    and cast(a.code_nrut as varchar) = isnull('"&rut_apoderado&"', cast(a.code_nrut as varchar)) " & vbcrlf & _
'			"    and cast(a.envi_ncorr as varchar) = isnull('"&folio&"', cast(a.envi_ncorr as varchar)) " & vbcrlf & _
'			"    and protic.trunc(a.envi_fenvio)  BETWEEN isnull('"&inicio&"', a.envi_fenvio) AND  isnull('"&termino&"', a.envi_fenvio) " & vbcrlf & _
'			"    and cast(a.inen_ccod as varchar)= isnull('"&empresa&"', cast(a.inen_ccod as varchar)) " & vbcrlf & _
'			"    and cast(a.sede_ccod as varchar)= isnull('"&sede&"', cast(a.sede_ccod as varchar)) " & vbcrlf & _
'			")b" & vbcrlf & _
'			"group by envi_ncorr, inen_tdesc, envi_fenvio, eenv_tdesc,TINE_CCOD,tenv_tdesc	" & vbcrlf & _
'			"ORDER BY envi_ncorr DESC"
				
sql_listado3="select distinct envi_ncorr as folio, envi_ncorr as num_folio, envi_ncorr,  inen_tdesc as empresa_envio,TINE_CCOD as tipo_empresa," & vbcrlf & _
			 " envi_fenvio as fecha, EENV_CCOD, eenv_tdesc as estado_envio, 0 as retenidos, 0 as saldo, tenv_tdesc as tipo_envio, protic.cantidad_documentos_envio(envi_ncorr) as cant_doc  " & vbcrlf & _
			 " from (" & vbcrlf & _
			 "    select *   " & vbcrlf & _
			 "    from (" & vbcrlf & _
			 "         select distinct isnull(a.envi_ncorr,0) as envi_ncorr, a.envi_fenvio, " & vbcrlf & _
			 "         isnull(a.inen_ccod,0) as inen_ccod, " & vbcrlf & _
			 "         isnull(e.pers_nrut, 0) as pers_nrut, e.pers_xdv, " & vbcrlf & _
			 "         isnull(g1.pers_nrut, 0) as code_nrut, g1.pers_xdv as code_xdv, " & vbcrlf & _
			 "		 count(b.envi_ncorr) as cant_doc,h.inen_tdesc, h.TINE_CCOD, i.EENV_CCOD, i.eenv_tdesc,   " & vbcrlf & _
			 "         isnull(l.sede_ccod,0) as sede_ccod, te.tenv_tdesc" & vbcrlf & _
			 "         from envios a left outer join detalle_envios b" & vbcrlf & _
			 "            on a.envi_ncorr = b.envi_ncorr " & vbcrlf & _
			 "         left outer join detalle_ingresos c" & vbcrlf & _
			 "            on  b.ting_ccod = c.ting_ccod and b.ding_ndocto = c.ding_ndocto and b.ingr_ncorr = c.ingr_ncorr" & vbcrlf & _
			 "         left outer join ingresos d" & vbcrlf & _
			 "            on  c.ingr_ncorr = d.ingr_ncorr" & vbcrlf & _
			 "         left outer join personas e" & vbcrlf & _
			 "            on  d.pers_ncorr = e.pers_ncorr " & vbcrlf & _
			 "         left outer join postulantes f" & vbcrlf & _
			 "            on  e.pers_ncorr = f.pers_ncorr" & vbcrlf & _
			 "         left outer join codeudor_postulacion g" & vbcrlf & _
			 "            on  f.post_ncorr = g.post_ncorr and f.peri_ccod  = "&periodo&"" & vbcrlf & _
			 "         join instituciones_envio h" & vbcrlf & _
			 "            on  a.inen_ccod = h.inen_ccod " & vbcrlf & _
			 "         join estados_envio i" & vbcrlf & _
			 "            on  a.eenv_ccod = i.eenv_ccod " & vbcrlf & _
			 "         left outer join alumnos k" & vbcrlf & _
			 "            on  f.post_ncorr = k.post_ncorr  " & vbcrlf & _
			 "         left outer join ofertas_academicas l" & vbcrlf & _
			 "            on   k.ofer_ncorr = l.ofer_ncorr and k.emat_ccod = 1" & vbcrlf & _
			 "         left outer join sedes m" & vbcrlf & _
			 "            on   l.sede_ccod = m.sede_ccod" & vbcrlf & _
			 "         left outer join personas g1" & vbcrlf & _
			 "            on   g.pers_ncorr = g1.pers_ncorr  " & vbcrlf & _
			 "         join tipos_envios te		" & vbcrlf & _
			 "            on   a.tenv_ccod = te.tenv_ccod " & vbcrlf & _
			 "         where h.TINE_CCOD in (3,4) " & vbcrlf & _
			 "         group by a.inen_ccod,a.envi_ncorr,a.envi_fenvio," & vbcrlf & _
			 "                  e.pers_nrut,e.pers_xdv,g1.pers_nrut,g1.pers_xdv, h.inen_tdesc," & vbcrlf & _
			 "                  h.TINE_CCOD, i.EENV_CCOD, i.eenv_tdesc, l.sede_ccod,te.tenv_tdesc" & vbcrlf & _
			 "        ) a " & vbcrlf & _
			 "    where 1=1 " 
			 if rut_alumno<>"" then
			 		sql_listado3=sql_listado3& " and  cast(a.pers_nrut as varchar)= isnull('"&rut_alumno&"', cast(a.pers_nrut as varchar)) "
			 end if
			 if rut_apoderado<>"" then		
			        sql_listado3=sql_listado3&  " and cast(a.code_nrut as varchar) = isnull('"&rut_apoderado&"', cast(a.code_nrut as varchar)) 	"
			 end if
			 if folio<>"" then
			        sql_listado3=sql_listado3&  " and cast(a.envi_ncorr as varchar) = isnull('"&folio&"', cast(a.envi_ncorr as varchar)) "
			 end if
			 if inicio<>"" and termino<>"" then
			        sql_listado3=sql_listado3 &  " and protic.trunc(a.envi_fenvio)  BETWEEN isnull('"&inicio&"', a.envi_fenvio) AND  isnull('"&termino&"', a.envi_fenvio) "
			 end if
			 if empresa<>"" then
			        sql_listado3=sql_listado3 &  " and cast(a.inen_ccod as varchar)= isnull('"&empresa&"', cast(a.inen_ccod as varchar)) "
			 end if

			 if estado<>"" then
			        sql_listado3=sql_listado3 &  " and cast(a.EENV_CCOD as varchar)= isnull('"&estado&"', cast(a.EENV_CCOD as varchar)) "
			 end if
			 
			 if sede<>"" then
			        sql_listado3=sql_listado3 &  " and cast(a.sede_ccod as varchar)= isnull('"&sede&"', cast(a.sede_ccod as varchar)) "
			 end if
			 sql_listado3=sql_listado3 & " )b" & vbcrlf & _
			 " group by envi_ncorr, inen_tdesc, envi_fenvio, EENV_CCOD, eenv_tdesc,TINE_CCOD,tenv_tdesc	" & vbcrlf & _
			 " ORDER BY envi_ncorr DESC"

 if Request.QueryString <> "" then
    'response.Write("<pre>"&sql_listado3&"</pre>")
    f_listado.Consultar sql_listado3
else
	f_listado.consultar "select '' from personas where 1 = 2"
	f_listado.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
  end if

cantidad=f_listado.nroFilas
'---------------------------------------------------------------------------------------------------
'set botonera = new CFormulario
'botonera.Carga_Parametros "Envios_Notaria.xml", "botonera"
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
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>
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
	
	rut_apoderado = formulario.elements["busqueda[0][code_nrut]"].value + "-" + formulario.elements["busqueda[0][code_xdv]"].value;	
    if (formulario.elements["busqueda[0][code_nrut]"].value  != '')
	  if (!valida_rut(rut_apoderado)) 
  	   {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][code_xdv]"].focus();
		formulario.elements["busqueda[0][code_xdv]"].select();
		return false;
	   }
	return true;
}

</script>

<script language="JavaScript">
function abrir()
 { 
  location.reload("Envios_Cobranza_Agregar1.asp") 
 }
</script>

<script language='javaScript1.2'> 
  colores = Array(3);
  colores[0] = ''; 
  colores[1] = '#97AAC6'; 
  colores[2] = '#C0C0C0'; 
</script>
<%
	set calendario = new FCalendario
	calendario.IniciaFuncion
	calendario.MuestraFecha "busqueda[0][envi_fenvio]","1","buscador","fecha_oculta_fenvio"
	calendario.MuestraFecha "busqueda[0][envio_termino]","2","buscador","fecha_oculta_ftermino"
	calendario.FinFuncion
%>
</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<%calendario.ImprimeVariables%>
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
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
                    <td width="238" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador
                      de Env&iacute;os a Cobranza</font></div></td>
                    <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="395" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
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
				<form name="buscador" >
                  <table width="98%"  border="0">
                    <tr>
                      <td width="86%"><table width="555" border="0">
                              <tr> 
                                <td width="137"> <div align="left">Sede</div></td>
                                <td width="11">:</td>
                                <td width="147"> <%f_busqueda.dibujacampo("sede_ccod")%>&nbsp; </td>
                                <td width="81">&nbsp;</td>
                                <td width="10">&nbsp;</td>
                                <td width="143">&nbsp;</td>
                              </tr>
                              <tr> 
                                <td>Periodo Inicio</td>
                                <td>:</td>
                                <td><div align="left">
                                  <%f_busqueda.dibujacampo("envi_fenvio")%>&nbsp;
								       <a style='cursor:hand;' onClick='PopCalendar.show(document.buscador.fecha_oculta, "dd/mm/yyyy", null, null, "obtener_fecha(1)", "11");'> 
                                       </a> 
                                       <%calendario.DibujaImagen "fecha_oculta_fenvio","1","buscador" %></div></td>
                                <td>T&eacute;rmino</td>
                                <td>:</td>
                                <td><div align="left"> 
                                    <%f_busqueda.dibujacampo("envio_termino")%>&nbsp;
                                    <a style='cursor:hand;' onClick='PopCalendar.show(document.buscador.fecha_oculta, "dd/mm/yyyy", null, null, "obtener_fecha(2)", "11");'> 
                                    </a> 
                                    <%calendario.DibujaImagen "fecha_oculta_ftermino","2","buscador" %></div></td>
                              </tr>
                              <tr> 
                                <td>Empresa de Cobranza</td>
                                <td>:</td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                  <%f_busqueda.dibujacampo("inen_ccod")%>
                                  </font></td>
								 <!-- 888888888888888888888 23-05-2014 888888888888888888888888888888888 -->
                                <td>Estado</td>
                                <td>:</td>
                                <td><%f_busqueda.dibujacampo("EENV_CCOD")%></td>
								<!-- 888888888888888888888 23-05-2014 888888888888888888888888888888888 -->
                              </tr>
                              <tr> 
                                <td height="20">N&ordm; Folio</td>
                                <td>:</td>
                                <td> <%f_busqueda.dibujacampo("envi_ncorr")%> </td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                              </tr>
                              <tr> 
                                <td>Rut Alumno</td>
                                <td>:</td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                  <%f_busqueda.dibujacampo("pers_nrut")%>
                                  - 
                                  <%f_busqueda.dibujacampo("pers_xdv")%>
                                  </font><a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Rut 
                                  Apoderado</font></td>
                                <td>:</td>
                                <td><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                    <%f_busqueda.dibujacampo("code_nrut")%>
                                    - 
                                    <%f_busqueda.dibujacampo("code_xdv")%>
                                    </font><a href="javascript:buscar_persona('busqueda[0][code_nrut]', 'busqueda[0][code_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></div></td>
                              </tr>
                            </table></td>
                      <td width="14%"><div align="center"><%botonera.DibujaBoton "buscar" %></div></td>
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Listado
                          de Env&iacute;os
                          a Cobranza</font></div>
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
                <td bgcolor="#D8D8DE"> <div align="center">&nbsp; <br>
                    <%pagina.DibujarTituloPagina%>
                    <br>
                  </div>
                  <table width="665" border="0">
                    <tr> 
                      <td width="116">&nbsp;</td>
                      <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                          <%f_listado.AccesoPagina%>
                        </div></td>
                      <td width="24"> <div align="right"> </div></td>
                    </tr>
                  </table> 
                  <form name="edicion">
				  <table width="100%" cellspacing="0" cellpadding="0">
                    <tr>
                      <td><div align="center">
                          <% f_listado.DibujaTabla %>
                        </div></td>
                    </tr>
                  </table> 
                  </form>
                    <br>
                </td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                <td width="335" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td><div align="center"> 
                          <%botonera.DibujaBoton "agregar" %>
                        </div></td>
                      <td><div align="center">
                          <%
						   botonera.agregabotonparam "enviar_folio", "url", "Proc_Envios_Emp_Cobra.asp"
						   if cint(cantidad)=0 then
						        botonera.agregabotonparam "enviar_folio", "deshabilitado" ,"TRUE"
						   end if
						   botonera.dibujaboton "enviar_folio" %>
                        </div></td>
                      <td align="center" valign="middle"> 
					    <% botonera.agregabotonparam "eliminar", "url", "Proc_Empresa_Eliminar.asp"
						     botonera.dibujaboton "eliminar"%>
                        
                      </td>
                      <td><div align="center"> 
                          <%botonera.DibujaBoton "salir" %>
                        </div></td>
                    </tr>
                  </table>
                  
                </td>
                <td width="27" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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