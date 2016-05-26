<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_ncorr = Request.QueryString("pers_ncorr")
q_carr_ccod = Request.QueryString("carr_ccod")
q_plan_ccod = Request.QueryString("plan_ccod")


'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "REVISIÓN CANDIDATO A EGRESO"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "vistos_buenos_egresados.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "vistos_buenos_egresados.xml", "encabezado_vb"
f_encabezado.Inicializar conexion

SQL = " select cast(pers_nrut as varchar)+'-'+pers_xdv as rut, pers_tnombre as nombres, pers_tape_paterno + ' ' +  pers_tape_materno as apellidos," & vbCrLf &_
      " (select carr_tdesc from carreras where carr_ccod='"&q_carr_ccod&"') as carrera " & vbCrLf &_
	  " from personas where cast(pers_ncorr as varchar)='"&q_pers_ncorr&"'"

f_encabezado.Consultar SQL
f_encabezado.Siguiente

set f_salidas = new CFormulario
f_salidas.Carga_Parametros "vistos_buenos_egresados.xml", "salidas_vb"
f_salidas.Inicializar conexion

SQL = " select a.tsca_ccod, a.saca_ncorr, "+q_pers_ncorr+" as pers_ncorr,  "& vbCrLf & _
      " a.tsca_tdesc as tsca_tdesc, "& vbCrLf & _
	  " a.saca_tdesc, a.plan_ccod, "& vbCrLf & _
      " a.saca_npond_asignaturas, a.asignaturas, count(b.reca_ncorr) as adicionales, sum(b.repl_nponderacion) as pond_adicionales, "& vbCrLf & _
	  " (select CED.eceg_ccod from CANDIDATOS_EGRESO CE,CANDIDATOS_EGRESO_DETALLE CED where CE.CEGR_NCORR=CED.CEGR_NCORR AND CED.saca_ncorr=a.saca_ncorr AND cast(CE.pers_ncorr as varchar)='"&q_pers_ncorr&"' and cast(CE.plan_ccod as varchar)='"&q_plan_ccod&"' and CE.carr_ccod='"&q_carr_ccod&"') as eceg_ccod, "& vbCrLf & _
	  " (select cegr_motivo_rechazo from CANDIDATOS_EGRESO CE,CANDIDATOS_EGRESO_DETALLE CED where CE.CEGR_NCORR=CED.CEGR_NCORR AND CED.saca_ncorr=a.saca_ncorr AND cast(CE.pers_ncorr as varchar)='"&q_pers_ncorr&"' and cast(CE.plan_ccod as varchar)='"&q_plan_ccod&"' and CE.carr_ccod='"&q_carr_ccod&"') as cegr_motivo_rechazo, "& vbCrLf & _
	  " (select case count(*) when 0 then '' else 'SÍ' end from CANDIDATOS_EGRESO CE,CANDIDATOS_EGRESO_DETALLE CED where CE.CEGR_NCORR=CED.CEGR_NCORR AND CED.saca_ncorr=a.saca_ncorr AND cast(CE.pers_ncorr as varchar)='"&q_pers_ncorr&"' and cast(CE.plan_ccod as varchar)='"&q_plan_ccod&"' and CE.carr_ccod='"&q_carr_ccod&"') as asignado "& vbCrLf & _
      " from (  "& vbCrLf & _
	  "         select a.tsca_ccod, a.saca_ncorr, b.tsca_tdesc, a.saca_tdesc, a.plan_ccod, "& vbCrLf & _
	  "                a.saca_npond_asignaturas, count(c.mall_ccod) as asignaturas "& vbCrLf & _
      " 		from salidas_carrera a INNER JOIN tipos_salidas_carrera b "& vbCrLf & _
      "			ON a.tsca_ccod = b.tsca_ccod "& vbCrLf & _
      "			LEFT OUTER JOIN asignaturas_salidas_carrera c "& vbCrLf & _
      "			ON a.saca_ncorr = c.saca_ncorr "& vbCrLf & _
      "			WHERE cast(a.carr_ccod as varchar) = '" & q_carr_ccod & "' "& vbCrLf & _
      "			group by a.tsca_ccod, a.saca_ncorr, b.tsca_tdesc, a.saca_tdesc, a.plan_ccod, a.saca_npond_asignaturas "& vbCrLf & _
      " 	 ) a LEFT OUTER JOIN requisitos_carrera b "& vbCrLf & _
      " ON a.saca_ncorr = b.saca_ncorr "& vbCrLf & _
	  " WHERE PROTIC.PREDICTIVO_EGRESO_ESCUELA_VB("+q_pers_ncorr+",'"+q_carr_ccod+"',"+q_plan_ccod+",a.saca_ncorr,a.asignaturas) = 1 "& vbCrLf & _
	  " AND (select count(*) from CANDIDATOS_EGRESO CE,CANDIDATOS_EGRESO_DETALLE CED where CE.CEGR_NCORR=CED.CEGR_NCORR AND CED.saca_ncorr=a.saca_ncorr AND cast(CE.pers_ncorr as varchar)='"&q_pers_ncorr&"' and cast(CE.plan_ccod as varchar)='"&q_plan_ccod&"' and CE.carr_ccod='"&q_carr_ccod&"') > 0 "& vbCrLf & _
      " group by a.tsca_ccod, a.saca_ncorr, a.tsca_tdesc, a.saca_tdesc, a.plan_ccod, "& vbCrLf & _
	  "          a.saca_npond_asignaturas, a.asignaturas "& vbCrLf & _
	  " order by a.tsca_ccod, a.saca_ncorr "

f_salidas.Consultar SQL

set f_salidas_titulos = new CFormulario
f_salidas_titulos.Carga_Parametros "vistos_buenos_egresados.xml", "salidas_ti"
f_salidas_titulos.Inicializar conexion

SQL2 =" select a.tsca_ccod, a.saca_ncorr, "+q_pers_ncorr+" as pers_ncorr,  "& vbCrLf & _
      " a.tsca_tdesc as tsca_tdesc, "& vbCrLf & _
	  " a.saca_tdesc, a.plan_ccod, "& vbCrLf & _
      " a.saca_npond_asignaturas, a.asignaturas, count(b.reca_ncorr) as adicionales, sum(b.repl_nponderacion) as pond_adicionales, "& vbCrLf & _
	  " isnull((select CED.eceg_ccod from CANDIDATOS_EGRESO CE,CANDIDATOS_EGRESO_DETALLE CED where CE.CEGR_NCORR=CED.CEGR_NCORR AND CED.saca_ncorr=a.saca_ncorr AND cast(CE.pers_ncorr as varchar)='"&q_pers_ncorr&"' and cast(CE.plan_ccod as varchar)='"&q_plan_ccod&"' and CE.carr_ccod='"&q_carr_ccod&"'),0) as eceg_ccod, "& vbCrLf & _
	  " (select cegr_motivo_rechazo from CANDIDATOS_EGRESO CE,CANDIDATOS_EGRESO_DETALLE CED where CE.CEGR_NCORR=CED.CEGR_NCORR AND CED.saca_ncorr=a.saca_ncorr AND cast(CE.pers_ncorr as varchar)='"&q_pers_ncorr&"' and cast(CE.plan_ccod as varchar)='"&q_plan_ccod&"' and CE.carr_ccod='"&q_carr_ccod&"') as cegr_motivo_rechazo, "& vbCrLf & _
	  " (select case count(*) when 0 then '' else 'SÍ' end from CANDIDATOS_EGRESO CE,CANDIDATOS_EGRESO_DETALLE CED where CE.CEGR_NCORR=CED.CEGR_NCORR AND CED.saca_ncorr=a.saca_ncorr AND cast(CE.pers_ncorr as varchar)='"&q_pers_ncorr&"' and cast(CE.plan_ccod as varchar)='"&q_plan_ccod&"' and CE.carr_ccod='"&q_carr_ccod&"') as asignado "& vbCrLf & _
      " from (  "& vbCrLf & _
	  "         select a.tsca_ccod, a.saca_ncorr, b.tsca_tdesc, a.saca_tdesc, a.plan_ccod, "& vbCrLf & _
	  "                a.saca_npond_asignaturas, count(c.mall_ccod) as asignaturas "& vbCrLf & _
      " 		from salidas_carrera a INNER JOIN tipos_salidas_carrera b "& vbCrLf & _
      "			ON a.tsca_ccod = b.tsca_ccod "& vbCrLf & _
      "			LEFT OUTER JOIN asignaturas_salidas_carrera c "& vbCrLf & _
      "			ON a.saca_ncorr = c.saca_ncorr "& vbCrLf & _
      "			WHERE cast(a.carr_ccod as varchar) = '" & q_carr_ccod & "' and b.tsca_ccod in (1,2,4,5)"& vbCrLf & _
      "			group by a.tsca_ccod, a.saca_ncorr, b.tsca_tdesc, a.saca_tdesc, a.plan_ccod, a.saca_npond_asignaturas "& vbCrLf & _
      " 	 ) a LEFT OUTER JOIN requisitos_carrera b "& vbCrLf & _
      " ON a.saca_ncorr = b.saca_ncorr "& vbCrLf & _
	  " WHERE PROTIC.PREDICTIVO_EGRESO_ESCUELA_VB("+q_pers_ncorr+",'"+q_carr_ccod+"',"+q_plan_ccod+",a.saca_ncorr,a.asignaturas) = 1 "& vbCrLf & _
	  " AND (select count(*) from CANDIDATOS_EGRESO CE,CANDIDATOS_EGRESO_DETALLE CED where CE.CEGR_NCORR=CED.CEGR_NCORR AND CED.saca_ncorr=a.saca_ncorr AND cast(CE.pers_ncorr as varchar)='"&q_pers_ncorr&"' and cast(CE.plan_ccod as varchar)='"&q_plan_ccod&"' and CE.carr_ccod='"&q_carr_ccod&"') = 0 "& vbCrLf & _
      " group by a.tsca_ccod, a.saca_ncorr, a.tsca_tdesc, a.saca_tdesc, a.plan_ccod, "& vbCrLf & _
	  "          a.saca_npond_asignaturas, a.asignaturas "& vbCrLf & _
	  " order by a.tsca_ccod, a.saca_ncorr "

f_salidas_titulos.Consultar SQL2

grabado = conexion.consultaUno("select count(*) from CANDIDATOS_EGRESO where cast(pers_ncorr as varchar)='"&q_pers_ncorr&"' and cast(plan_ccod as varchar)='"&q_plan_ccod&"' and carr_ccod='"&q_carr_ccod&"'")
cegr_ncorr = conexion.consultaUno("select cegr_ncorr from CANDIDATOS_EGRESO where cast(pers_ncorr as varchar)='"&q_pers_ncorr&"' and cast(plan_ccod as varchar)='"&q_plan_ccod&"' and carr_ccod='"&q_carr_ccod&"'")

pendientes = conexion.consultaUno("select count(*) from CANDIDATOS_EGRESO_DETALLE where cast(cegr_ncorr as varchar)='"&cegr_ncorr&"' and eceg_ccod=1")
estado_final = conexion.consultaUno("select eceg_ccod from CANDIDATOS_EGRESO where cast(cegr_ncorr as varchar)='"&cegr_ncorr&"'")
aprobados = conexion.consultaUno("select count(*) from CANDIDATOS_EGRESO_DETALLE where cast(cegr_ncorr as varchar)='"&cegr_ncorr&"' and eceg_ccod=2")
es_moroso = conexion.consultaUno("select case protic.es_moroso('"&q_pers_ncorr&"',getDate()) when 'S' then 'SI' else 'NO' end")

lblAprobados = ""
if aprobados = "0" then
	lblAprobados = "El alumno debe tener a lo menos una salida aprobada, para generar el egreso"
end if

fecha_solicitud = conexion.consultaUno("select protic.trunc(CEGR_FSOLICITUD) from CANDIDATOS_EGRESO where cast(pers_ncorr as varchar)='"&q_pers_ncorr&"' and cast(plan_ccod as varchar)='"&q_plan_ccod&"' and carr_ccod='"&q_carr_ccod&"'")
estado_solicitud = conexion.consultaUno("select b.ECEG_TDESC from CANDIDATOS_EGRESO a, ESTADO_CANDIDATOS_EGRESO b where a.ECEG_CCOD=b.ECEG_CCOD AND cast(pers_ncorr as varchar)='"&q_pers_ncorr&"' and cast(plan_ccod as varchar)='"&q_plan_ccod&"' and carr_ccod='"&q_carr_ccod&"'")

sin_mencion = conexion.consultaUno("select isnull(CEGR_BSIN_MENCION,'0') from CANDIDATOS_EGRESO where cast(pers_ncorr as varchar)='"&q_pers_ncorr&"' and cast(plan_ccod as varchar)='"&q_plan_ccod&"' and carr_ccod='"&q_carr_ccod&"'")
'response.End()
considera_menciones = "SI"
if sin_mencion = "1" then
	considera_menciones = "NO"
end if



lenguetas = Array(Array("Revisión candidatos", "vistos_buenos_egresados_revisar.asp?pers_ncorr=" & q_pers_ncorr&"&carr_ccod="& q_carr_ccod & "&plan_ccod="&q_plan_ccod))
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
function habilitarMotivo(valor,nombre)
{ //var estado = '<%=v_es_moroso%>';
  fila = extrae_indice(nombre);
  //alert(fila);
  if ((valor=="3"))
		{
			document.edicion.elements["salidas["+fila+"][cegr_motivo_rechazo]"].disabled = false;
			document.edicion.elements["salidas["+fila+"][cegr_motivo_rechazo]"].id = "TO-N";
		}
	else
		{
			document.edicion.elements["salidas["+fila+"][cegr_motivo_rechazo]"].disabled = true;
			document.edicion.elements["salidas["+fila+"][cegr_motivo_rechazo]"].value = "";
			document.edicion.elements["salidas["+fila+"][cegr_motivo_rechazo]"].id = "TO-S";

		}
 
}
function habilitarMotivoTi(valor,nombre)
{ //var estado = '<%=v_es_moroso%>';
  fila = extrae_indice(nombre);
  //alert(fila);
  if ((valor=="3"))
		{
			document.edicion.elements["salidas_ti["+fila+"][cegr_motivo_rechazo]"].disabled = false;
			document.edicion.elements["salidas_ti["+fila+"][cegr_motivo_rechazo]"].id = "TO-N";
		}
	else
		{
			document.edicion.elements["salidas_ti["+fila+"][cegr_motivo_rechazo]"].disabled = true;
			document.edicion.elements["salidas_ti["+fila+"][cegr_motivo_rechazo]"].value = "";
			document.edicion.elements["salidas_ti["+fila+"][cegr_motivo_rechazo]"].id = "TO-S";

		}
 
}
function deshabilita_inicial()
{
   nro = document.edicion.elements.length;
   num =0;
   for( i = 0; i < nro; i++ )
    {
	  comp = document.edicion.elements[i];
	  str  = document.edicion.elements[i].name;
	  if(comp.type == 'text')
	  {
	     num += 1;
		 fila=extrae_indice(str);
		 valor=document.edicion.elements["salidas["+fila+"][eceg_ccod]"].value;
		 
		 if ((valor=="3"))
		{
			document.edicion.elements["salidas["+fila+"][cegr_motivo_rechazo]"].disabled = false;
			document.edicion.elements["salidas["+fila+"][cegr_motivo_rechazo]"].id = "TO-N";
		}
	else
		{
			document.edicion.elements["salidas["+fila+"][cegr_motivo_rechazo]"].disabled = true;
			document.edicion.elements["salidas["+fila+"][cegr_motivo_rechazo]"].value = "";
			document.edicion.elements["salidas["+fila+"][cegr_motivo_rechazo]"].id = "TO-S";
		}
	  }
   }
   
   nro2 = document.edicion2.elements.length;
   num2 =0;
   for( i = 0; i < nro2; i++ )
    {
	  comp = document.edicion2.elements[i];
	  str  = document.edicion2.elements[i].name;
	  if(comp.type == 'text')
	  {
	     num2 += 1;
		 fila=extrae_indice(str);
		 valor=document.edicion2.elements["salidas_ti["+fila+"][eceg_ccod]"].value;
		 
		 if ((valor=="3"))
		{
			document.edicion2.elements["salidas_ti["+fila+"][cegr_motivo_rechazo]"].disabled = false;
			document.edicion2.elements["salidas_ti["+fila+"][cegr_motivo_rechazo]"].id = "TO-N";
		}
	else
		{
			document.edicion2.elements["salidas_ti["+fila+"][cegr_motivo_rechazo]"].disabled = true;
			document.edicion2.elements["salidas_ti["+fila+"][cegr_motivo_rechazo]"].value = "";
			document.edicion2.elements["salidas_ti["+fila+"][cegr_motivo_rechazo]"].id = "TO-S";
		}
	  }
   }
}

</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="deshabilita_inicial(); MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
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
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td>
		  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas lenguetas, 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
			<div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
              <br>
              <table width="98%"  border="1">
                <tr>
                  <td width="90%">
				      <table width="100%" cellpadding="0" cellspacing="0">
					    <tr>
						    <td colspan="3" height="25" align="left"><b>Direcci&oacute;n de Escuela:</b></td>
						</tr>
						<form name="edicion">
						<input type="hidden" name="plan_ccod" value="<%=q_plan_ccod%>"> 
						<input type="hidden" name="carr_ccod" value="<%=q_carr_ccod%>"> 
						<input type="hidden" name="pers_ncorr" value="<%=q_pers_ncorr%>"> 
						<tr>
						    <td width="20%" height="25" align="left"><b>Rut Alumno</b></td>
							<td width="5%" align="center"><b>:</b></td>
							<td width="75%" align="left"><%=f_encabezado.obtenerValor("rut")%></td>
						</tr>
						<tr>
						    <td width="20%" height="25" align="left"><b>Apellidos</b></td>
							<td width="5%" align="center"><b>:</b></td>
							<td width="75%" align="left"><%=f_encabezado.obtenerValor("apellidos")%></td>
						</tr>
						<tr>
						    <td width="20%" height="25" align="left"><b>Nombres</b></td>
							<td width="5%" align="center"><b>:</b></td>
							<td width="75%" align="left"><%=f_encabezado.obtenerValor("nombres")%></td>
						</tr>
						<tr>
						    <td width="20%" height="25" align="left"><b>Carrera</b></td>
							<td width="5%" align="center"><b>:</b></td>
							<td width="75%" align="left"><%=f_encabezado.obtenerValor("carrera")%></td>
						</tr>
						<tr>
						    <td width="20%" height="25" align="left"><b>Considera Menciones?</b></td>
							<td width="5%" align="center"><b>:</b></td>
							<td width="75%" align="left"><%=considera_menciones%></td>
						</tr>
						<tr>
						    <td width="20%" height="25" align="left"><b>Fecha solicitud</b></td>
							<td width="5%" align="center"><b>:</b></td>
							<td width="75%" align="left"><%=fecha_solicitud%></td>
						</tr>
						<tr>
						    <td width="20%" height="25" align="left"><b>Estado solicitud</b></td>
							<td width="5%" align="center"><b>:</b></td>
							<td width="75%" align="left"><%=estado_solicitud%></td>
						</tr>
						<tr>
						    <td width="20%" height="25" align="left"><b>Es moroso</b></td>
							<td width="5%" align="center"><b>:</b></td>
							<td width="75%" align="left"><%=es_moroso%></td>
						</tr>
						<tr>
						    <td colspan="3" height="25" align="left"><b>Salidas y Menciones asociadas a alumno</b></td>
						</tr>
						<tr>
						    <td colspan="3"><div align="right">P&aacute;ginas : <%f_salidas.AccesoPagina%></div></td>
						</tr>
						<tr>
						    <td colspan="3" align="center"><%f_salidas.DibujaTabla%></td>
						</tr>
						<tr>
						    <td colspan="3"><div align="center"><%f_salidas.Pagina%></div></td>
						</tr>
						<tr>
						    <td colspan="3"><div align="right"><%if f_salidas.nroFilas <= 0 or estado_final <> "1" then
							                                         f_botonera.AgregaBotonParam "cambio_estado_salida","deshabilitado","true"
																 end if
							                                     f_botonera.DibujaBoton "cambio_estado_salida"%></div></td>
						</tr>
						</form>
						<tr>
						    <td colspan="3">&nbsp;</td>
						</tr>
						<form name="edicion2">
						<input type="hidden" name="plan_ccod_2" value="<%=q_plan_ccod%>"> 
						<input type="hidden" name="carr_ccod_2" value="<%=q_carr_ccod%>"> 
						<input type="hidden" name="pers_ncorr_2" value="<%=q_pers_ncorr%>"> 
						<tr>
						    <td colspan="3" height="25" align="left"><b>Salidas y menciones sin asociar</b></td>
						</tr>
						<tr>
						    <td colspan="3"><div align="right">P&aacute;ginas : <%f_salidas_titulos.AccesoPagina%></div></td>
						</tr>
						<tr>
						    <td colspan="3" align="center"><%f_salidas_titulos.DibujaTabla%></td>
						</tr>
						<tr>
						    <td colspan="3"><div align="center"><%f_salidas_titulos.Pagina%></div></td>
						</tr>
						<tr>
						    <td colspan="3"><div align="right"><%if f_salidas_titulos.nroFilas <= 0 or estado_final <> "1" then
							                                         f_botonera.AgregaBotonParam "cambio_estado_salida_ti","deshabilitado","true"
																 end if
							                                     f_botonera.DibujaBoton "cambio_estado_salida_ti"%></div></td>
						</tr>
						</form>
						<tr><td colspan="3">&nbsp;</td></tr>
						<tr><td colspan="3" align="center"><font color="#0000CC"><b><%=lblAprobados%></b></font></td></tr>
						<tr><td colspan="3">&nbsp;</td></tr>
						<%if estado_final = "2" and lblAprobados = "" then%>
						<tr>
						    <td colspan="3" align="center">
							  <table width="80%" cellpadding="0" cellspacing="0" border="1">
							  <tr>
							      <td width="100%">
									  <table width="100%" cellpadding="0" cellspacing="0">
									  <form name="edicion_egreso">
										  <input type="hidden" name="plan_ccod_3" value="<%=q_plan_ccod%>"> 
										  <input type="hidden" name="carr_ccod_3" value="<%=q_carr_ccod%>"> 
										  <input type="hidden" name="pers_ncorr_3" value="<%=q_pers_ncorr%>"> 
									   <tr>
											<td colspan="3" align="center"><b>REGISTRO EGRESO DE ALUMNO</b></td>
									   </tr>
									   <tr>
											<td width="15%"><b>Fecha Proceso</b></td>
											<td width="5%"><b>:</b></td>
											<td width="80%"><input type="text" name="fecha_proceso" size="10" maxlength="10" value="<%=fecha_proceso%>" ID="FE-N"> (dd/mm/aaaa)</td>
									   </tr>
									   <tr>
											<td width="15%"><b>Fecha Egreso</b></td>
											<td width="5%"><b>:</b></td>
											<td width="80%"><input type="text" name="fecha_egreso" size="10" maxlength="10"  value="<%=fecha_egreso%>" ID="FE-N"> (dd/mm/aaaa)</td>
									   </tr>
									   <tr>
											<td width="15%"><b>Observaci&oacute;n</b></td>
											<td width="5%"><b>:</b></td>
											<td width="80%"><input type="text" name="observacion" size="50" maxlength="100"  value="<%=observacion_egreso%>" ID="TO-N"></td>
									   </tr>
									   <tr>
									        <td align="right"><%f_botonera.DibujaBoton "egresar_candidato"%></td>
									        <td colspan="2" align="right"><font size="-2" color="#000099">* El proceso puede generar matrícula de ajuste en estado de egreso.</font></td>
									   </tr>
									   </form>
									  </table>
							  </td>
							  </tr>
							  </table>
							</td>
						</tr>
						<%end if%>
						<tr><td colspan="3">&nbsp;</td></tr>
					  </table>	
					</td>
                </tr>
              </table>
              </div>
            </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="20%" height="20">
			   <table width="90%">
			   		<tr>
						<td width="33%"><div align="center"><%f_botonera.DibujaBoton "cerrar"%></div></td>
						<%if estado_final <> "2" then%>
						<td width="33%"><div align="center"><%if pendientes <> "0" or estado_final <> "1" then
							                                         f_botonera.AgregaBotonParam "rechazar","deshabilitado","true"
															  end if
						                                      f_botonera.DibujaBoton "rechazar"%></div></td>
						<td width="34%"><div align="center"><%if pendientes <> "0" or  estado_final <> "1" or lblAprobados <> "" then
							                                         f_botonera.AgregaBotonParam "v_b_titulos","deshabilitado","true"
															  end if
						                                      f_botonera.DibujaBoton "v_b_titulos"%></div></td>
					     <%end if%>
					</tr>
			   </table>
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
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
