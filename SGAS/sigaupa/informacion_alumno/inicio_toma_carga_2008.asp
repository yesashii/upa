<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/revisa_session_alumno.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<% Server.ScriptTimeOut = 150000
 
' set conexion_directa = new CAlternativa
' conexion_directa.Inicializa 

q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
matr_ncorr = Request.QueryString("enca[0][carreras_alumno]")
'response.Write(matr_ncorr)
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Bienvenido a Toma de Asignaturas (Online)"

set errores = new CErrores
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "inicio_toma_carga_alfa.xml", "botonera"

set botonera = new CFormulario
botonera.Carga_Parametros "toma_carga_alfa.xml", "BotoneraTomaCarga"

if esVacio(q_pers_nrut) then
	q_pers_nrut = negocio.obtenerUsuario
	q_pers_xdv = conexion.consultaUno("Select pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
end if
pers_ncorr_temporal = conexion.consultaUno("select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
periodo_defecto = "210"
anos_ccod = conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo_defecto&"'")
primer_semestre = conexion.consultaUno("Select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod&"' and plec_ccod=1")
segundo_semestre = conexion.consultaUno("Select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod&"' and plec_ccod=2")
v_peri_ccod = periodo_defecto

if pers_ncorr_temporal <> "" then
    sede_ccod = conexion.consultaUno("select sede_ccod from alumnos a, ofertas_academicas b where cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and a.ofer_ncorr = b.ofer_ncorr and cast(b.peri_ccod as varchar)='"&periodo_defecto&"' and emat_ccod in (1)")
	'es_moroso = conexion_directa.ConsultaUnoDirecta("select protic.es_Moroso("&pers_ncorr_temporal&",getDate())")
	tiene_bloqueos = conexion.consultaUno("select count(*) from bloqueos where eblo_ccod=1 and cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"'")
	tipo_bloqueo = conexion.consultaUno("select protic.initcap(tblo_tdesc) from bloqueos a, tipos_bloqueos b where a.tblo_ccod=b.tblo_ccod and eblo_ccod=1 and cast(pers_ncorr as varchar)='"&pers_ncorr_temporal&"'")
	'v_plec_ccod = conexion.ConsultaUno("select plec_ccod from periodos_academicos where cast(peri_ccod as varchar) = '" & v_peri_ccod & "'")
	'if v_plec_ccod = "2" and es_moroso <> "S" and sede_ccod <> "" and tiene_bloqueos = "0" then
	'	sentencia = "exec CREAR_MATRICULA_SEG_SEMESTRE_VERSION_2 '" & sede_ccod & "', '" & q_pers_nrut & "', '" & v_peri_ccod& "'"
	'	conexion.EjecutaPsql(sentencia)
	'end if
	'if v_plec_ccod = "3" and es_moroso <> "S" and sede_ccod <> "" and tiene_bloqueos = "0" then
	'	sentencia = "exec CREAR_MATRICULA_TER_TRIMESTRE_VERSION_2 '" & sede_ccod & "', '" & q_pers_nrut & "', '" & v_peri_ccod& "'"
	'	conexion.EjecutaPsql(sentencia)
	'end if
	peri_tdesc= conexion.consultaUno("Select peri_tdesc from periodos_Academicos where cast(peri_ccod as varchar)='"&periodo_defecto&"'")
	rut = conexion.consultaUno("select cast(pers_nrut as varchar)+ '-'+pers_xdv from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
	nombre = conexion.consultaUno("select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
	matr_ncorr = ""
	consulta_matr=" Select top 1 b.matr_ncorr from personas a, alumnos b, ofertas_Academicas c" &_
				  " where a.pers_ncorr=b.pers_ncorr and b.ofer_ncorr=c.ofer_ncorr and emat_ccod in (1) "&_
				  " and cast(c.peri_ccod as varchar)='"&periodo_defecto&"' and cast(a.pers_nrut as varchar)='"&q_pers_nrut&"'"
								
	matr_ncorr= conexion.consultaUno(consulta_matr)	
	carrera = conexion.consultaUno("select carr_tdesc + ' -- ' + c.espe_tdesc from alumnos a, ofertas_academicas b, especialidades c, carreras d where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod")
	carr_ccod = conexion.consultaUno("Select ltrim(rtrim(carr_ccod)) from alumnos a, ofertas_Academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast( matr_ncorr as varchar)='"&matr_ncorr&"'")
	plan_ccod = conexion.consultaUno("Select plan_ccod from alumnos where cast(matr_ncorr as varchar)='"&matr_ncorr&"'")
end if




set f_alumno = new CFormulario
f_alumno.Carga_Parametros "inicio_toma_carga_alfa.xml", "carga_tomada"
f_alumno.Inicializar conexion

consulta = " select c.asig_ccod as cod_asignatura, c.asig_tdesc as asignatura,b.secc_tdesc as seccion, " & vbCrLf &_
		   " protic.horario_con_sala(b.secc_ccod) as horario, case acse_ncorr when 3 then 'Carga sin Pre-requisitos' else case a.carg_afecta_promedio when 'N' then 'Optativo' else 'Carga Regular' end end as tipo, "& vbCrLf &_
		   " isnull((select isnull(cred_valor,0) from asignaturas aa,creditos_Asignatura bb "& vbCrLf &_
           "  where aa.cred_ccod = bb.cred_ccod and aa.asig_ccod=c.asig_ccod),0) as creditos"& vbCrLf &_
		   " from cargas_Academicas a, secciones b, asignaturas c " & vbCrLf &_
		   " where cast(matr_ncorr as varchar)='"&matr_ncorr&"' " & vbCrLf &_
		   " and a.secc_ccod=b.secc_ccod " & vbCrLf &_
		   " and not exists (Select 1 from equivalencias eq where eq.matr_ncorr=a.matr_ncorr and eq.secc_ccod=a.secc_ccod) " & vbCrLf &_
		   " and b.asig_ccod=c.asig_ccod " & vbCrLf &_
		   " union all " & vbCrLf &_
		   " select c.asig_ccod as cod_asignatura, c.asig_tdesc as asignatura,b.secc_tdesc as seccion, " & vbCrLf &_
		   " protic.horario_con_sala(b.secc_ccod) as horario,case isnull(acse_ncorr,0) when 0 then 'Equivalencia' else 'Carga Extraordinaria' end as tipo, " & vbCrLf &_
		   " isnull((select isnull(cred_valor,0) from asignaturas aa,creditos_Asignatura bb "& vbCrLf &_
           "  where aa.cred_ccod = bb.cred_ccod and aa.asig_ccod=c.asig_ccod),0) as creditos"& vbCrLf &_
		   " from equivalencias a, secciones b, asignaturas c,cargas_academicas ca " & vbCrLf &_
		   " where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' " & vbCrLf &_
		   " and a.secc_ccod=b.secc_ccod  and a.matr_ncorr=ca.matr_ncorr and a.secc_ccod = ca.secc_ccod" & vbCrLf &_
		   " and b.asig_ccod=c.asig_ccod "

f_alumno.Consultar consulta

if matr_ncorr <> "" then
	tipo_plan = conexion.consultaUno("select isnull(plan_tcreditos,0) from planes_estudio where cast(plan_ccod as varchar)='"&plan_ccod&"'")
	if tipo_plan = "0" then
		mensaje_plan = "Esta cursando un plan de estudios basado en Sesiones."
	else
		mensaje_plan = "Esta cursando un plan de estudios basado en Créditos."
	end if		
	con_encuesta="1"
end if
  
session("pers_ncorr_alumno") = pers_ncorr_temporal
session("matr_ncorr") = matr_ncorr
suma_creditos=0.0
if tipo_plan <> "0" then
	while f_alumno.siguiente 
			suma_creditos= suma_creditos + cdbl(f_alumno.obtenerValor("creditos"))
	wend
	f_alumno.primero
end if

if tipo_plan <> "0" and matr_ncorr <> "" then
	suma_creditos = conexion.consultaUno("select protic.obtener_creditos_asignados("&matr_ncorr&")")
end if

url="../CERTIFICADOS/HISTORICO_NOTAS_LIBRE.ASP?busqueda[0][pers_nrut]="&q_pers_nrut&"&busqueda[0][pers_xdv]="&q_pers_xdv&"&ocultar=1"

'----------------------debemos ver si el alumno esta bien encasillado con el plan de estudios y la especialidad
'-----------------------------agregado por Marcelo Sandoval-----------------------------------------
especialidad_plan = conexion.consultaUno("select b.espe_ccod from alumnos a, planes_estudio b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.plan_ccod=b.plan_ccod")
especialidad_oferta = conexion.consultaUno("select b.espe_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr")
if especialidad_plan <> especialidad_oferta and matr_ncorr <> "" then 
	mensaje_distintos = "Presenta Problemas por mala asignación de plan de estudios, comuniquese con la Dirección de su Escuela para solucionarlo."
end if	

cerrar_carga_diurno = false

'debemos ver si el alumno completo toda la evaluacion docente del año 2007------------------------
if matr_ncorr <> "" then
c_encuestas = "select cantidad_carga_2007 - con_evaluacion_docente as diferencia "& vbCrLf &_
			  " from "& vbCrLf &_
		  	  " ( "& vbCrLf &_
			  " select cast(d.pers_nrut as varchar)+'-'+d.pers_xdv as rut, d.pers_tnombre + ' ' + d.pers_tape_paterno + ' ' + d.pers_tape_materno as alumno, "& vbCrLf &_
			  " (select count(*) from alumnos aa, ofertas_academicas bb, cargas_academicas cc "& vbCrLf &_
			  " where aa.pers_ncorr=a.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr and aa.matr_ncorr=cc.matr_ncorr "& vbCrLf &_
			  " and bb.peri_ccod in (206,208,209) and isnull(cc.sitf_ccod,'n') <> 'n' "& vbCrLf &_
			  " and exists (select 1 from secciones aaa, bloques_horarios bbb, bloques_profesores ccc "& vbCrLf &_
			  "             where aaa.secc_ccod=cc.secc_ccod and aaa.secc_ccod=bbb.secc_ccod  "& vbCrLf &_
			  "             and bbb.bloq_ccod=ccc.bloq_ccod and ccc.tpro_ccod=1 "& vbCrLf &_
			  "             and convert(datetime,protic.trunc(ccc.audi_fmodificacion),103) < convert(datetime,'20-10-2007',103))) as cantidad_carga_2007, "& vbCrLf &_
			  " (select count(*) from alumnos aa, ofertas_academicas bb, cargas_academicas cc "& vbCrLf &_
			  " where aa.pers_ncorr=a.pers_ncorr and aa.ofer_ncorr=bb.ofer_ncorr and aa.matr_ncorr=cc.matr_ncorr "& vbCrLf &_
			  " and bb.peri_ccod in (206,208,209) "& vbCrLf &_
			  " and exists (select 1 from secciones aaa, bloques_horarios bbb, bloques_profesores ccc "& vbCrLf &_
			  "             where aaa.secc_ccod=cc.secc_ccod and aaa.secc_ccod=bbb.secc_ccod  "& vbCrLf &_
			  "             and bbb.bloq_ccod=ccc.bloq_ccod and ccc.tpro_ccod=1 "& vbCrLf &_
			  "             and convert(datetime,protic.trunc(ccc.audi_fmodificacion),103) < convert(datetime,'20-10-2007',103)) "& vbCrLf &_
			  " and exists (select 1 from evaluacion_docente ffff where ffff.pers_ncorr_encuestado=aa.pers_ncorr  "& vbCrLf &_
			  "             and ffff.secc_ccod=cc.secc_ccod)) as con_evaluacion_docente               "& vbCrLf &_
			  " from alumnos a, ofertas_academicas b, especialidades c,personas d "& vbCrLf &_
			  " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod "& vbCrLf &_
			  " and c.carr_ccod='"&carr_ccod&"' and cast(b.peri_ccod as varchar)='"&periodo_defecto&"' "& vbCrLf &_
			  " and a.emat_ccod <> 9 and a.alum_nmatricula <> '7777' "& vbCrLf &_
			  " and a.pers_ncorr = d.pers_ncorr "& vbCrLf &_
			  " and b.post_bnuevo='N' "& vbCrLf &_
			  " and cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"'"& vbCrLf &_
			  " ) tabla_1"

              diferencia_encuestas = conexion.consultaUno(c_encuestas)
			  mensaje_encuesta = ""
			  if diferencia_encuestas > "0" then 
			  	mensaje_encuesta = "El alumno no contestó todas las evaluaciones docentes correspondientes al año 2007, le restan "&diferencia_encuestas&" encuestas por evaluar"
			  end if
			  if pers_ncorr_temporal="27757" or pers_ncorr_temporal="102680" or pers_ncorr_temporal="102665" or pers_ncorr_temporal="103442" or pers_ncorr_temporal="107093" or pers_ncorr_temporal="101924" or pers_ncorr_temporal="106139" or pers_ncorr_temporal="102850" or pers_ncorr_temporal="106379" or pers_ncorr_temporal="102244" or pers_ncorr_temporal="124378" or pers_ncorr_temporal="110818" or pers_ncorr_temporal="102479" or pers_ncorr_temporal="117500" or pers_ncorr_temporal="21513" or pers_ncorr_temporal= "102864" or pers_ncorr_temporal= "112289" or pers_ncorr_temporal="23213" or pers_ncorr_temporal="22652" or pers_ncorr_temporal="98132" or pers_ncorr_temporal="113850" or pers_ncorr_temporal="98383" or pers_ncorr_temporal="102495" or pers_ncorr_temporal="110426" or pers_ncorr_temporal="96971" or pers_ncorr_temporal="23218" or pers_ncorr_temporal="117125"  or pers_ncorr_temporal="97186" or pers_ncorr_temporal="21810" or pers_ncorr_temporal="20622" then 
			  	mensaje_encuesta = ""
			  end if
			  cumple_fecha_matricula = conexion.consultaUno("select case when convert(datetime,protic.trunc(alum_fmatricula),103) <= convert(datetime,'25-12-2007',103) then 'S' else 'N' end from alumnos where cast(matr_ncorr as varchar)='"&matr_ncorr&"'")
			  
			  mensaje_convocatoria = ""
			  'response.Write(carr_ccod)
			  if carr_ccod ="830" or carr_ccod ="850" or carr_ccod ="880" or carr_ccod ="870" or carr_ccod ="940" or carr_ccod ="950" or carr_ccod = "860" then
			  	mensaje_convocatoria = "La toma de carga para alumnos de tu carrera debe ser a través de tu coordinacion de escuela."
			  end if
			  
			  email_escuela = conexion.consultaUno("select email from sd_email_carrera where cod_carrera='"&carr_ccod&"'")
			  c_bloqueo_notas = " select case count(*) when 0 then 'Libre' else 'Bloqueado' end  "& vbCrLf &_
								" from sd_causal_eliminacion where cast(rut as varchar)='"&q_pers_nrut&"' "

              bloqueo_notas = conexion.consultaUno(c_bloqueo_notas)  
			  mensaje_bloqueo_notas = ""
			  if bloqueo_notas = "Bloqueado" then
			  	 mensaje_bloqueo_notas = "El alumno presenta un bloqueo académico en el sistema, lo que inpide la toma de carga, haga el favor de comunicarse con su escuela para solucionar la situación."
			  end if
end if

if matr_ncorr = "" then
	consulta_no_activa = "Select protic.initCap(emat_tdesc) from alumnos a, ofertas_academicas b, estados_matriculas c where cast(a.pers_ncorr as varchar)= '"&pers_ncorr_temporal&"' and a.ofer_ncorr=b.ofer_ncorr  and a.emat_ccod = c.emat_ccod and cast(b.peri_ccod as varchar)= '"&v_peri_ccod&"' and a.emat_ccod <> 1"
	no_activa= conexion.consultaUno(consulta_no_activa)
	if not Esvacio(no_activa) and no_activa <> "" then
				mensaje = "No presenta matricula activa en el sistema, su última matricula esta en estado "& no_activa
	else
				mensaje = "No presenta matricula activa para este periodo."	
	end if
	
end if	
es_nuevo = conexion.consultaUno("Select post_bnuevo from alumnos a, ofertas_academicas b where a.ofer_ncorr=b.ofer_ncorr and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")
'response.Write(es_nuevo)
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
function dibujar(formulario){
	formulario.submit();
}
function ver_notas()
{
self.open('<%=url%>','notas','width=700px, height=550px, scrollbars=yes, resizable=yes')
}

function horario(){
	self.open('horario.asp?matr_ncorr=<%=matr_ncorr%>','horario','width=700px, height=550px, scrollbars=yes, resizable=yes')
}

function imprimir() {
  var direccion;
  direccion="impresion_carga.asp";
  window.open(direccion ,"ventana1","width=520,height=540,scrollbars=yes, left=313, top=200");
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="80" valign="top"><img src="../imagenes/banner.jpg" width="750" height="100" border="0"></td>
  </tr>
  <%'pagina.DibujarEncabezado()%> 
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
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
            <td><%pagina.DibujarLenguetas Array("Toma de Asignaturas Online"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.Titulo = "Toma de Asignaturas Online <br>(" &peri_tdesc&")"
			    pagina.DibujarTituloPagina%><br>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
				  	<td colspan="3">&nbsp;<input type="hidden" name="busqueda[0][pers_nrut]" value="<%=q_pers_nrut%>">
					<input type="hidden" name="busqueda[0][pers_xdv]" value="<%=q_pers_xdv%>">
					</td>
				  </tr>
				  <tr>
				  	<td colspan="3">&nbsp;</td>
				  </tr>
				  <%if q_pers_nrut <> "" then %>
				  <tr>
				  	<td width="10%"><strong>Rut</strong></td>
				  	<td width="1%"><strong>:</strong></td>
				  	<td><%=rut%></td>
				  </tr>
				  <tr>
				  	<td width="10%"><strong>Nombre</strong></td>
				  	<td width="1%"><strong>:</strong></td>
				  	<td><%=nombre%></td>
				  </tr>
				  <tr>
				  	<td width="10%"><strong>Carrera</strong></td>
				  	<td width="1%"><strong>:</strong></td>
				  	<td><%=carrera%></td>
				  </tr>
				  <%end if%>
				  <tr>
				  	<td colspan="3">&nbsp;
					</td>
				  </tr>
				  <%if matr_ncorr <> "" then %>
				  <tr>
                    <td colspan="3"><%pagina.DibujarSubtitulo "Carga Académica Registrada"%>
                      <br>
                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                          <td><div align="right">Pagina <%f_alumno.accesoPagina%></div></td>
                        </tr>
						<tr>
                          <td><div align="center"><%f_alumno.DibujaTabla%></div></td>
                        </tr>
                      </table></td>
                  </tr>
				  <%end if%>
				  <tr>
				  	<td colspan="3">&nbsp;
					</td>
				  </tr>
				  <%if mensaje_plan <> "" then%>
				  <tr>
				  	<td colspan="3" align="center"><font  size="2"color="#0000FF"><strong><%=mensaje_plan%></strong></font>
					</td>
				  </tr>
				  <%end if%>
				  <tr>
				  	<td colspan="3" align="center">&nbsp;</td>
				  </tr>
				  <tr>
				  	<td colspan="3" align="center">
							<table width="90%" border="2" align="center">
								<tr>
									<td align="center" bgcolor="#FFFFFF">
									                   <%if email_escuela <> "" then %>
													   	Si presentas problemas en la toma de carga, comunicate con tu escuela en <b><%=email_escuela%></b>
													   <%end if%>
									</td>
								</tr>
								 <%if tipo_plan <> "0" and (cdbl(suma_creditos) < 9 or cdbl(suma_creditos) > 27) and f_alumno.nroFilas > 0 then%>
								  <tr>
									<td align="left">- El total de Cr&eacute;ditos Asignados (<%=suma_creditos%>), esta fuera del rango permitido (9-27).</strong></font>
									</td>
								  </tr>
								  <%end if%>
								   <%if mensaje <> "" and q_pers_nrut <> ""  then %>
								  <tr>
									<td align="left">- Se ha detectado que : <%=mensaje%></td>
								  </tr>
								  <%end if%>
								  <%if es_moroso = "S" and q_pers_nrut <> ""  then %>
								  <tr>
									<td align="left">- Se ha detectado que presenta una morosidad en su cuenta corriente, su deuda debe estar saldada para poder hacer la toma de ramos (Contáctese con departamento de cobranzas).</td>
								  </tr>
								  <%end if%>
								  <%if mensaje_encuesta<> "" then %>
								  <tr>
									<td align="left">- <%=mensaje_encuesta%></td>
								  </tr>
								  <%end if%>
								  <%if mensaje_distintos <> "" and q_pers_nrut <> ""  then %>
								  <tr>
									<td align="left">- <%=mensaje_distintos%></td>
								  </tr>
								  <%end if%>
								  <%if tiene_bloqueos <>"0" then %>
								  <tr>
									<td align="left">- Se ha detectado que presenta un bloqueo del  tipo: <%=tipo_bloqueo%></td>
								  </tr>
								  <%end if%>
								  <%if mensaje_convocatoria <> "" then %>
								  <tr>
									<td align="left">- <%=mensaje_convocatoria%></td>
								  </tr>
								  <%end if%>
								  <%if mensaje_bloqueo_notas <> "" then%>
								  <tr>
									<td align="left">- <%=mensaje_bloqueo_notas%></td>
								  </tr>
								  <%end if%>
								  <%if es_nuevo = "S" then%>
								  <tr>
									<td align="left">- La toma de carga para alumnos nuevos será realizada automáticamente al comienzo del año académico.</td>
								  </tr>
								  <%end if%>
								
							</table>
					</td>
				  </tr>
				  <tr>
				  	<td colspan="3">&nbsp;
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
            <td width="29%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr> 
				  <td><div align="center"><% f_botonera.agregaBotonParam "salir","url","menu_alumno.asp"
				                             f_botonera.DibujaBoton("salir")%></div></td>
                  <td><div align="center"><% if cerrar_carga_diurno then
				                                 f_botonera.AgregaBotonParam "siguiente","deshabilitado","TRUE"       
				  							 end if
				                             if matr_ncorr = "" or mensaje_distintos <> "" then
				                             	 f_botonera.AgregaBotonParam "siguiente","deshabilitado","TRUE"
											 end if 
											 if  mensaje_encuesta <> "" then 
											     f_botonera.AgregaBotonParam "siguiente","deshabilitado","TRUE"
											 end if
											 if es_moroso ="S" then
											 	 f_botonera.AgregaBotonParam "siguiente","deshabilitado","TRUE"
											 end if
											 if tiene_bloqueos <> "0" then
											 	 f_botonera.AgregaBotonParam "siguiente","deshabilitado","TRUE"
											 end if
											 if mensaje_bloqueo_notas <> "" then
											 	 f_botonera.AgregaBotonParam "siguiente","deshabilitado","TRUE"
											 end if
											 if mensaje_convocatoria <> "" then
											 	 f_botonera.AgregaBotonParam "siguiente","deshabilitado","TRUE"
											 end if
											 if es_nuevo = "S" then
											 	 f_botonera.AgregaBotonParam "siguiente","deshabilitado","TRUE"
											 end if
											   'f_botonera.AgregaBotonParam "siguiente","deshabilitado","FALSE"
											   f_botonera.DibujaBoton("siguiente")%></div></td>
                  <%if matr_ncorr <> "" then%>
				  <td><div align="center">
                    <%botonera.DibujaBoton "HORARIO"%>
                  </div></td>
                  <td><div align="center"><%' botonera.DibujaBoton "NOTAS"%></div></td>
    			   <td><div align="center"><%f_botonera.DibujaBoton ("imprimir")%></div></td>
				  <%end if%>
                  </tr>
              </table>
            </div></td>
            <td width="71%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
