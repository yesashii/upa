<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
saca_ncorr  = Request.QueryString("saca_ncorr")
pers_ncorr  = Request.QueryString("pers_ncorr")
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Administración datos de egreso"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set f_salida = new CFormulario
f_salida.Carga_Parametros "expediente_titulacion.xml", "salida"
f_salida.Inicializar conexion

SQL = " select b.pers_ncorr,a.saca_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_nrut, b.pers_xdv,  "& vbCrLf &_
      " b.pers_tnombre + ' ' + b.pers_tape_paterno + ' ' + b.pers_tape_materno as alumno, "& vbCrLf &_
	  " a.saca_tdesc as salida, c.tsca_ccod,case c.tsca_ccod when 1 then '<font color=#073299><strong>' "& vbCrLf &_ 
      "            when 2 then '<font color=#004000><strong>' "& vbCrLf &_ 
  	  " 		   when 3 then '<font color=#b76d05><strong>' "& vbCrLf &_ 
	  "			   when 4 then '<font color=#714e9c><strong>' "& vbCrLf &_ 
	  " 		   when 5 then '<font color=#ab2b05><strong>' "& vbCrLf &_ 
	  "  		   when 6 then '<font color=#0078c0><strong>' end + c.tsca_tdesc + '</strong></font>' as tipo_salida, d.carr_ccod, d.carr_tdesc, "& vbCrLf &_
      "    (select top 1 sede_ccod from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod order by t2.peri_ccod desc) as sede_ccod, "& vbCrLf &_
      "    (select top 1 sede_tdesc from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            INNER JOIN sedes t4 "& vbCrLf &_
      "            ON t2.sede_ccod = t4.sede_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod order by t2.peri_ccod desc) as sede_tdesc, "& vbCrLf &_
      "    (select top 1 jorn_tdesc from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            INNER JOIN jornadas t4 "& vbCrLf &_
      "            ON t2.jorn_ccod = t4.jorn_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod order by t2.peri_ccod desc) as jorn_tdesc, "& vbCrLf &_
      "    (select top 1 peri_ccod from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (4,8) "& vbCrLf &_
      "            order by t2.peri_ccod desc) as peri_ccod, "& vbCrLf &_
      "    (select top 1 peri_tdesc from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod=t3.espe_ccod "& vbCrLf &_
      "            INNER JOIN periodos_academicos t4 "& vbCrLf &_
      "            ON t2.peri_ccod = t4.peri_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (4,8) "& vbCrLf &_
      "            order by t2.peri_ccod desc) as peri_tdesc, "& vbCrLf &_
      "    (select case count(*) when 0 then 'N' else 'S' end  from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod=t3.espe_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (4)) as egresado, "& vbCrLf &_
      "    (select case count(*) when 0 then 'N' else 'S' end  from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (8)) as titulado, "& vbCrLf &_
      "    (select top 1 t1.plan_ccod  from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (4) order by peri_ccod desc ) as plan_ccod, "& vbCrLf &_
      " asca_ncorr, protic.trunc(asca_fsalida) as asca_fsalida, asca_nfolio, asca_nregistro, replace(cast(asca_nnota as decimal(2,1)),',','.') as asca_nnota, ' '  as asca_bingr_manual, "& vbCrLf &_
      "    (select max(peri_ccod) "& vbCrLf &_
      "			from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "			ON t1.pers_ncorr = b.pers_ncorr "& vbCrLf &_
      "			INNER JOIN especialidades t3 "& vbCrLf &_
      "			ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "			WHERE t2.espe_ccod = t3.espe_ccod and t3.carr_ccod = d.carr_ccod and isnull(t1.emat_ccod,0) <> 9) as ultimo_periodo "& vbCrLf &_
      " from salidas_carrera a INNER JOIN personas b "& vbCrLf &_
      " ON cast(b.pers_ncorr as varchar)='"&pers_ncorr&"' and cast(a.saca_ncorr as varchar)='"&saca_ncorr&"' "& vbCrLf &_
      " INNER JOIN tipos_salidas_carrera c "& vbCrLf &_
      " ON a.tsca_ccod=c.tsca_ccod "& vbCrLf &_
      " INNER JOIN  carreras d "& vbCrLf &_
      " ON a.carr_ccod=d.carr_ccod "& vbCrLf &_
      " LEFT OUTER JOIN alumnos_salidas_carrera e "& vbCrLf &_
      " ON a.saca_ncorr = e.saca_ncorr and b.pers_ncorr = e.pers_ncorr" 

f_salida.Consultar SQL
f_salida.Siguiente
plan_ccod = f_salida.obtenerValor("plan_ccod")
egresado  = f_salida.obtenerValor("egresado")
titulado  = f_salida.obtenerValor("titulado")
carr_ccod = f_salida.obtenerValor("carr_ccod")
tsca_ccod = f_salida.obtenerValor("tsca_ccod")
asca_ncorr = f_salida.obtenerValor("asca_ncorr")
asca_nregistro = f_salida.obtenerValor("asca_nregistro")
asca_nfolio = f_salida.obtenerValor("asca_nfolio")
folio = asca_nfolio
ultimo_periodo = f_salida.obtenerValor("ultimo_periodo")
carr_ccod_informar = carr_ccod
if egresado = "N" and not EsVacio(ultimo_periodo) then
 c_detalle_ultima_matricula = " Select top 1 'El alumno no se encuentra titulado en la carrera seleccionada, su última matrícula corresponde a la especialidad: <strong>'+lower(c.espe_tdesc)+' - '+lower(d.plan_tdesc)+'</strong>, con el estado de matrícula '+e.emat_tdesc "&_
                               " from alumnos a, ofertas_academicas b, especialidades c, planes_estudio d, estados_matriculas e "&_
							   " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.plan_ccod=d.plan_ccod and a.emat_ccod=e.emat_ccod "&_
							   " and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and cast(b.peri_ccod as varchar)='"&ultimo_periodo&"' and c.carr_ccod='"&carr_ccod&"' and isnull(a.emat_ccod,0) <> 9 order by peri_ccod desc "
 detalle_ultima_matricula =  conexion.consultaUno(c_detalle_ultima_matricula)
 c_plan_ccod = " select top 1 a.plan_ccod "&_
               " from alumnos a, ofertas_academicas b, especialidades c, planes_estudio d, estados_matriculas e "&_
			   " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.plan_ccod=d.plan_ccod and a.emat_ccod=e.emat_ccod "&_
			   " and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and cast(b.peri_ccod as varchar)='"&ultimo_periodo&"' and c.carr_ccod='"&carr_ccod&"' and isnull(a.emat_ccod,0) <> 9 order by peri_ccod desc "
 'response.Write(c_plan_ccod)
 plan_ccod = conexion.consultaUno(c_plan_ccod)
end if

q_plan_ccod  = plan_ccod
q_peri_ccod  = ultimo_periodo
q_pers_nrut  = f_salida.obtenerValor("pers_nrut")
q_pers_xdv   = f_salida.obtenerValor("pers_xdv")
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "expediente_titulacion.xml", "botonera_de"

'---------------------------------------------------------------------------------------------------
set f_titulado = new CFormulario
f_titulado.Carga_Parametros "expediente_titulacion.xml", "encabezado_de"
f_titulado.Inicializar conexion

'v_sede_ccod = negocio.ObtenerSede'

v_sede_ccod = conexion.consultaUno("select top 1 sede_ccod from personas a, alumnos b, ofertas_academicas c where cast(a.pers_nrut as varchar)='"&q_pers_nrut&"' and a.pers_ncorr=b.pers_ncorr and cast(b.plan_Ccod as varchar)='"&q_plan_ccod&"' and b.ofer_ncorr=c.ofer_ncorr order by peri_ccod desc")


SQL = " select f.sede_ccod, a.pers_ncorr, b.plan_ccod, c.espe_ccod, e.peri_ccod, d.carr_tdesc, c.espe_tdesc, e.peri_tdesc, f.sede_tdesc, plan_tdesc as plan_ncorrelativo, protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre"
SQL = SQL &  " from personas a, planes_estudio b, especialidades c, carreras d, periodos_academicos e, sedes f"
SQL = SQL &  " where b.espe_ccod = c.espe_ccod"
SQL = SQL &  "   and c.carr_ccod = d.carr_ccod"
SQL = SQL &  "   and cast(f.sede_ccod as varchar)= '" & v_sede_ccod & "'"
SQL = SQL &  "   and cast(e.peri_ccod as varchar)= '" & q_peri_ccod & "'"
SQL = SQL &  "   and cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "'"
SQL = SQL &  "   and cast(b.plan_ccod as varchar)= '" & q_plan_ccod & "'"

f_titulado.Consultar SQL
f_titulado.SiguienteF
v_sede_ccod = f_titulado.obtenerValor ("sede_ccod")

q_pers_ncorr = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
if tsca_ccod <> "4" then
	tiene_grabado = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end  from detalles_titulacion_carrera where cast(plan_ccod as varchar)='"&q_plan_ccod&"' and cast(pers_ncorr as varchar)='"&q_pers_ncorr&"' and carr_ccod='"&carr_ccod&"'")
	plan_consulta = q_plan_ccod
else
	tiene_grabado = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end  from detalles_titulacion_carrera where cast(plan_ccod as varchar)='"&saca_ncorr&"' and cast(pers_ncorr as varchar)='"&q_pers_ncorr&"'")
	plan_consulta = saca_ncorr
end if	

if tiene_grabado = "S" then
	 consulta = " select pers_ncorr,plan_ccod,nombre_empresa,ubicacion_empresa,telefono_empresa,email_empresa,nombre_encargado,protic.trunc(fecha_proceso) as fecha_proceso, "& vbCrLf &_
				" cargo_encargado,protic.trunc(inicio_practica) as inicio_practica,protic.trunc(termino_practica) as termino_practica,observaciones,'"&carr_ccod_informar&"' as carr_ccod, "& vbCrLf &_
			    " descripcion_practica,isnull(horas_practica,(select t2.asig_nhoras from malla_curricular tt, asignaturas t2 "& vbCrLf &_
				" where tt.asig_ccod=t2.asig_ccod and tt.plan_ccod = a.plan_ccod and t2.asig_tdesc = 'PRACTICA PROFESIONAL') ) as horas_practica "& vbCrLf &_
				" from detalles_titulacion_carrera a left outer join situaciones_finales b "& vbCrLf &_
				" 		on a.concepto_practica = b.sitf_ccod "& vbCrLf &_
				" where cast(plan_ccod as varchar)='"&plan_consulta&"' "& vbCrLf &_
				" and cast(pers_ncorr as varchar)='"&q_pers_ncorr&"'"
else
     consulta = " select '"&plan_consulta&"' as plan_ccod, '"&q_pers_ncorr&"' as pers_ncorr,'"&carr_ccod_informar&"' as carr_ccod "
end if
'response.Write("<pre>"&consulta&"</pre>")
set f_practica = new CFormulario
f_practica.Carga_Parametros "expediente_titulacion.xml", "detalle_datos_practica"
f_practica.Inicializar conexion

f_practica.Consultar consulta
f_practica.Siguiente

'---------------------------------------------------------------------------------------------------

f_botonera.AgregaBotonUrlParam "siguiente", "plan_ccod", q_plan_ccod
f_botonera.AgregaBotonUrlParam "siguiente", "peri_ccod", q_peri_ccod

f_botonera.AgregaBotonUrlParam "guardar_nuevo", "plan_ccod", q_plan_ccod
f_botonera.AgregaBotonUrlParam "guardar_nuevo", "peri_ccod", q_peri_ccod

'---------------------------------------------------------------------------------------------------
url_leng_0 = "exp_tit_mensajes.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_1 = "exp_tit_datos_personales.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_2 = "exp_tit_doctos_entregados.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_3 = "exp_tit_historico_notas.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_4 = "exp_tit_practica.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_5 = "exp_tit_egreso.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_6 = "exp_tit_salida.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_7 = "exp_tit_titulo.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr
url_leng_8 = "exp_tit_concentracion.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & pers_ncorr

'---------------------------------------------------------------------------------------------------

se_titulo = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end  from salidas_alumnos a, salidas_plan b where a.sapl_ncorr = b.sapl_ncorr and cast(b.plan_ccod as varchar)='"&q_plan_ccod&"' and cast(a.pers_ncorr as varchar)='"&q_pers_ncorr&"'")
'response.End()

rut_email = conexion.consultaUno("select cast(pers_nrut as varchar)+'-'+pers_xdv from personas where cast(pers_ncorr as varchar)='"&q_pers_ncorr&"'")
nombre_email = conexion.consultaUno("select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas where cast(pers_ncorr as varchar)='"&q_pers_ncorr&"'")
carrera_email = conexion.consultaUno("select carr_tdesc from carreras where carr_ccod='"&carr_ccod_informar&"'")
sede_email = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&v_sede_ccod&"'")

carr_param = conexion.consultaUno("select carr_ccod from salidas_carrera where cast(saca_ncorr as varchar)='"&saca_ncorr&"'")
permiso_escuela = conexion.consultaUno("select isnull((select isnull(peca_dat_personal,'0') from permisos_evt_carrera where carr_ccod='"&carr_param&"'),'0')")


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
function calcular_periodo(valor)
{
	var valor2 = isFecha(valor);
	var semestre_destino ="";
	var ano_destino;
	var egresado = '<%=egresado%>';
	var tsca_ccod = '<%=tsca_ccod%>';

	if ( (tsca_ccod != '4') )
	{
		if ( (valor2) && (valor !="") && (egresado=="N") )
		{
			var arreglo_fecha = valor.split("/");
			var dia = arreglo_fecha[0];
			var mes = arreglo_fecha[1];
			var ano = arreglo_fecha[2];
			if ( mes == 1 )
			  {
				 semestre_destino = " 1er ";
				 ano_destino = ano;
				 document.practica.anos_ccod_egreso.value=ano;
				 document.practica.plec_ccod_egreso.value="1";
			  }
			  else if(( mes > 1 )&&( mes <=7 ))
			  {
				 semestre_destino = " 2do ";
				 ano_destino = ano;
				 document.practica.anos_ccod_egreso.value=ano;
				 document.practica.plec_ccod_egreso.value="2";
			  }
			  else if( mes > 7 )
			  {
				 semestre_destino = " 1er ";
				 ano_destino = (ano*1)+1;
				 document.practica.anos_ccod_egreso.value=ano_destino;
				 document.practica.plec_ccod_egreso.value="1";
			  }
			  document.practica.descripcion.value = "-Al grabar se creará una matrícula con estado de egreso en el"+semestre_destino+"semestre del año "+ano_destino;
			  document.getElementById("texto_alerta").style.visibility="visible";
		}
	}	
}

function imprimir_etiqueta()
{
	irA('imprimir_etiqueta.asp?pers_ncorr=<%=q_pers_ncorr%>', 'v1', 750, 550);
}

function enviar_email_masivo(destino)
{
    var sede = <%=v_sede_ccod%>;
	if (destino == 'F')
	{
		if (confirm("Está seguro que desea enviar email a Finanzas,\n¿Para continuar presione Aceptar?") )
			{
				var formulario = document.edicion_email;
				formulario.action = "http://www.upacifico.cl/super_test/motor_email_etiquetas.php?sede="+sede+"&destino="+destino;
				formulario.target = "_black";
				formulario.submit();
			}
	}
	else if (destino == 'A')
	{
		if (confirm("Está seguro que desea enviar email a Audiovisual,\n¿Para continuar presione Aceptar?") )
			{
				var formulario = document.edicion_email;
				formulario.action = "http://www.upacifico.cl/super_test/motor_email_etiquetas.php?sede="+sede+"&destino="+destino;
				formulario.target = "_black";
				formulario.submit();
			}
	}	
	else if (destino == 'B')
	{
		if (confirm("Está seguro que desea enviar email a Biblioteca,\n¿Para continuar presione Aceptar?") )
			{
				var formulario = document.edicion_email;
				formulario.action = "http://www.upacifico.cl/super_test/motor_email_etiquetas.php?sede="+sede+"&destino="+destino;
				formulario.target = "_black";
				formulario.submit();
			}
	}	
}
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
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
            <td><%pagina.DibujarLenguetasFClaro Array(Array("Mensajes", url_leng_0), Array("Datos Pers.", url_leng_1), Array("Docs Alumno", url_leng_2),Array("Hist. Notas", url_leng_3), Array("Práctica prof.", url_leng_4), Array("Datos Egreso", url_leng_5),Array("Reg. Salida", url_leng_6), Array("Tesis y comisión", url_leng_7), Array("Conc. Notas", url_leng_8)),5%></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
                <td> <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td>
                        <table width="98%"  border="0" align="center">
                          <tr> 
                            <td><div align="center"><%=mensaje_html%></div></td>
                          </tr>
						  <tr> 
                            <td><div align="center">
                                <%f_titulado.DibujaRegistro%>
                              </div></td>
                          </tr>
                        </table></td>
                    </tr>
                    <tr> 
                      <td>
                        <%pagina.DibujarSubtitulo "Datos de Práctica Profesional"%>
                        <form name="practica">
						  <input type="hidden" name="saca_ncorr" value="<%=saca_ncorr%>">
                          <table width="100%"  border="0" align="center">
                            <tr> 
                              <td align="center"> 
							  <table border="0" width="98%">
							       <tr> 
                                    <td width="14%" align="left"><strong>Empresa</strong>
                                      <input type="hidden" name="egreso[0][pers_ncorr]" value="<%=q_pers_ncorr%>"></td>
                                    <td width="1%" align="left"><strong>:</strong></td>
                                    <td width="35%" align="left">
                                      <%f_practica.dibujaCampo("nombre_empresa")%>
                                      <input type="hidden" name="egreso[0][plan_ccod]" value="<%=q_plan_ccod%>"></td>
                                    <td width="14%" align="left"><strong>Ubicación</strong></td>
                                    <td width="1%" align="left"><strong>:</strong></td>
                                    <td width="35%" align="left"><%f_practica.dibujaCampo("ubicacion_empresa")%></td>
                                  </tr>
                                  <tr> 
                                    <td width="14%" align="left"><strong>Teléfono</strong></td>
                                    <td width="1%" align="left"><strong>:</strong></td>
                                    <td width="35%" align="left"><%f_practica.dibujaCampo("telefono_empresa")%></td>
                                    <td width="14%" align="left"><strong>E-mail</strong></td>
                                    <td width="1%" align="left"><strong>:</strong></td>
                                    <td width="35%" align="left"><%f_practica.dibujaCampo("email_empresa")%></td>
                                  </tr>
                                  <tr> 
                                    <td width="14%" align="left"><strong>Encargado</strong></td>
                                    <td width="1%" align="left"><strong>:</strong></td>
                                    <td width="35%" align="left"><%f_practica.dibujaCampo("nombre_encargado")%></td>
                                    <td width="14%" align="left"><strong>Cargo</strong></td>
                                    <td width="1%" align="left"><strong>:</strong></td>
                                    <td width="35%" align="left"><%f_practica.dibujaCampo("cargo_encargado")%></td>
                                  </tr>
                                  <tr> 
                                    <td width="14%" align="left"><strong>Inicio</strong></td>
                                    <td width="1%" align="left"><strong>:</strong></td>
                                    <td width="35%" align="left"><%f_practica.dibujaCampo("inicio_practica")%></td>
                                    <td width="14%" align="left"><strong>Término</strong></td>
                                    <td width="1%" align="left"><strong>:</strong></td>
                                    <td width="35%" align="left"><%f_practica.dibujaCampo("termino_practica")%></td>
                                  </tr>
                                  <tr> 
                                    <td width="14%" align="left"><strong>Des. Trabajo</strong></td>
                                    <td width="1%" align="left"><strong>:</strong></td>
                                    <td width="14%" align="left"><%f_practica.dibujaCampo("descripcion_practica")%></td>
                                    <td width="14%" align="left"><strong>N° Horas</strong></td>
                                    <td width="1%" align="left"><strong>:</strong></td>
                                    <td width="35%" align="left"><%f_practica.dibujaCampo("horas_practica")%></td>
                                  </tr></table></td>
                            </tr>
                          </table>
                        </form></td>
                    </tr>
    				<tr>
                      <td>&nbsp;</td>
                    </tr>
					<% if permiso_escuela = "0" then%>
					  <tr>
						<td align="center"><font color="#8A0808">LA  ESCUELA NO POSEE PERMISOS DE INGRESO O EDICIÓN DE DATOS</font></td>
					  </tr>
					<%end if%>
				  <tr>
                    <td>&nbsp;</td>
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
            <td width="16%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
				  <td><div align="center"><%
				                            if permiso_escuela = "0" then
				                                f_botonera.AgregaBotonParam "guardar_practica" , "deshabilitado" , "true"
											end if
				                            f_botonera.DibujaBoton "guardar_practica"%></div></td>
                  <td><div align="center"><%f_botonera.DibujaBoton "cerrar"%></div></td>
                </tr>
              </table>
            </div></td>
            <td width="84%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
