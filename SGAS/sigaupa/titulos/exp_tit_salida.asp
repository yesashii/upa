<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_saca_ncorr = Request.QueryString("saca_ncorr")
q_pers_ncorr = Request.QueryString("pers_ncorr")
saca_ncorr = Request.QueryString("saca_ncorr")
pers_ncorr = Request.QueryString("pers_ncorr")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Asignar/Editar salida de alumno"


'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "expediente_titulacion.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_salida = new CFormulario
f_salida.Carga_Parametros "expediente_titulacion.xml", "salida"
f_salida.Inicializar conexion

SQL = " select b.pers_ncorr,a.saca_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut,  "& vbCrLf &_
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
      "            INNER JOIN  especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr=b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (4,8) "& vbCrLf &_
      "            order by t2.peri_ccod desc) as peri_ccod, "& vbCrLf &_
      "    (select top 1 peri_tdesc from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            INNER JOIN periodos_academicos t4 "& vbCrLf &_
      "            ON t2.peri_ccod = t4.peri_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr=b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (4,8) "& vbCrLf &_
      "            order by t2.peri_ccod desc) as peri_tdesc, "& vbCrLf &_
      "    (select case count(*) when 0 then 'N' else 'S' end  from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (4)) as egresado, "& vbCrLf &_
      "    (select case count(*) when 0 then 'N' else 'S' end  from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN  especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (8)) as titulado, "& vbCrLf &_
      "    (select top 1 t1.plan_ccod  from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "            INNER JOIN especialidades t3 "& vbCrLf &_
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (8) order by peri_ccod desc ) as plan_ccod, "& vbCrLf &_
      " asca_ncorr, protic.trunc(asca_fsalida) as asca_fsalida, asca_nfolio, asca_nregistro, replace(cast(asca_nnota as decimal(2,1)),',','.') as asca_nnota, ' '  as asca_bingr_manual, "& vbCrLf &_
      "    (select max(peri_ccod) "& vbCrLf &_
      "			from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_
      "			ON t1.pers_ncorr = b.pers_ncorr "& vbCrLf &_
      "			INNER JOIN  especialidades t3 "& vbCrLf &_
      "			ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_
      "			WHERE t2.espe_ccod = t3.espe_ccod and t3.carr_ccod = d.carr_ccod and isnull(t1.emat_ccod,0) <> 9) as ultimo_periodo "& vbCrLf &_
      " from salidas_carrera a INNER JOIN personas b "& vbCrLf &_
      " ON cast(b.pers_ncorr as varchar)='"&q_pers_ncorr&"' and cast(a.saca_ncorr as varchar)='"&q_saca_ncorr&"' "& vbCrLf &_
      " INNER JOIN tipos_salidas_carrera c "& vbCrLf &_
      " ON a.tsca_ccod=c.tsca_ccod "& vbCrLf &_
      " INNER JOIN carreras d "& vbCrLf &_
      " ON a.carr_ccod = d.carr_ccod "& vbCrLf &_
      " LEFT OUTER JOIN alumnos_salidas_carrera e "& vbCrLf &_
      " ON a.saca_ncorr = e.saca_ncorr and b.pers_ncorr = e.pers_ncorr" 

'response.Write("<pre>"&SQL&"</pre>")
f_salida.Consultar SQL
f_salida.Siguiente
plan_ccod = f_salida.obtenerValor("plan_ccod")
egresado  = f_salida.obtenerValor("egresado")
titulado  = f_salida.obtenerValor("titulado")
carr_ccod = f_salida.obtenerValor("carr_ccod")
tsca_ccod = f_salida.obtenerValor("tsca_ccod")
asca_ncorr = f_salida.obtenerValor("asca_ncorr")
asca_nregistro = f_salida.obtenerValor("asca_nregistro")
ultimo_periodo = f_salida.obtenerValor("ultimo_periodo")
carr_ccod_defecto = carr_ccod

if titulado = "N" and not EsVacio(ultimo_periodo) then
 c_detalle_ultima_matricula = " Select top 1 'El alumno no se encuentra titulado en la carrera seleccionada, su última matrícula corresponde a la especialidad: <strong>'+lower(c.espe_tdesc)+' - '+lower(d.plan_tdesc)+'</strong>, con el estado de matrícula '+e.emat_tdesc "&_
                               " from alumnos a, ofertas_academicas b, especialidades c, planes_estudio d, estados_matriculas e "&_
							   " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.plan_ccod=d.plan_ccod and a.emat_ccod=e.emat_ccod "&_
							   " and cast(a.pers_ncorr as varchar)='"&q_pers_ncorr&"' and cast(b.peri_ccod as varchar)='"&ultimo_periodo&"' and c.carr_ccod='"&carr_ccod&"' and isnull(a.emat_ccod,0) <> 9 order by peri_ccod desc "
 detalle_ultima_matricula =  conexion.consultaUno(c_detalle_ultima_matricula)
 c_plan_ccod = " select top 1 a.plan_ccod "&_
               " from alumnos a, ofertas_academicas b, especialidades c, planes_estudio d, estados_matriculas e "&_
			   " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.plan_ccod=d.plan_ccod and a.emat_ccod=e.emat_ccod "&_
			   " and cast(a.pers_ncorr as varchar)='"&q_pers_ncorr&"' and cast(b.peri_ccod as varchar)='"&ultimo_periodo&"' and c.carr_ccod='"&carr_ccod&"' and isnull(a.emat_ccod,0) <> 9 order by peri_ccod desc "
 plan_ccod = conexion.consultaUno(c_plan_ccod)
end if

if EsVacio(asca_nregistro) then

	if tsca_ccod = "1" or tsca_ccod="3" or tsca_ccod="5" or tsca_ccod="6" then
		c_folio = " select asca_nfolio from alumnos_salidas_carrera a, salidas_carrera b, planes_estudio c, especialidades d"&_
		          " where a.saca_ncorr=b.saca_ncorr and b.tsca_ccod in (1,3,5,6) and b.plan_ccod=c.plan_ccod"&_
				  " and c.espe_ccod=d.espe_ccod and cast(a.pers_ncorr as varchar)='"&q_pers_ncorr&"' and d.carr_ccod='"&carr_ccod&"'"
		folio = conexion.consultaUno(c_folio)
		c_registro = " select asca_nregistro from alumnos_salidas_carrera a, salidas_carrera b, planes_estudio c, especialidades d"&_
		             " where a.saca_ncorr=b.saca_ncorr and b.tsca_ccod in (1,3,5,6) and b.plan_ccod=c.plan_ccod"&_
				     " and c.espe_ccod=d.espe_ccod and cast(a.pers_ncorr as varchar)='"&q_pers_ncorr&"' and d.carr_ccod='"&carr_ccod&"'"
		registro = conexion.consultaUno(c_registro)
    end if
	
	if EsVacio(folio) then
		c_registro = "select isnull(max(cast(asca_nregistro as numeric)),0) from alumnos_salidas_carrera "
		registro = conexion.consultaUno(c_registro)
		c_registro2 = "select isnull(max(cast(salu_nregistro as numeric)),0) from detalles_titulacion "
		registro2 = conexion.consultaUno(c_registro2)
		if cdbl(registro) < cdbl(registro2) then
			registro = registro2
		end if 
		registro = cint(registro) + 1
		if carr_ccod = "51" or carr_ccod = "930" or carr_ccod = "810" or carr_ccod = "920" then 
			carr_ccod="51"
		end if
		if carr_ccod = "12" or carr_ccod = "910" or carr_ccod = "900" or carr_ccod = "890" then 
			carr_ccod="12"
		end if
		folio = conexion.consultaUno("select ltrim(rtrim('"&carr_ccod&"'))+'-'+cast('"&registro&"' as varchar)+'-'+cast(datepart(year,getDate())as varchar)")
	end if
	
	f_salida.agregaCampoCons "asca_nregistro",registro
	f_salida.agregaCampoCons "asca_nfolio",folio
end if

					  
mensaje_as_faltantes = ""
if asignaturas_faltantes > "0" then
	mensaje_as_faltantes = "Se ha detectado que el usuario no presenta aprobadas todas las asignaturas requeridas por esta salida, le resta(n) "&asignaturas_faltantes&" asignatura(s) por aprobar."
end if

mensaje_bloqueo = ""
if (tsca_ccod="1" or tsca_ccod="3" or tsca_ccod="5" or tsca_ccod="6") and titulado="N" then
mensaje_bloqueo = "Imposible asignar la salida al alumno, este tipo de salida requiere que el alumno presente estado de titulado en la carrera."
end if

f_salida.primero


'Debemos emular el caso de mostrar las licenciaturas de la carrera y generar la salida directamente para el alumno
if tsca_ccod="1" then
'response.End()
    
    set licenciaturas	=	new cformulario
	licenciaturas.inicializar		conexion
	licenciaturas.carga_parametros	"expediente_titulacion.xml","licenciaturas"
	c_licenciaturas	=	"select '' as saca_ncorr2 "
	licenciaturas.consultar	c_licenciaturas
	c_licenciaturas = "select saca_ncorr as saca_ncorr2,saca_tdesc from salidas_carrera "&_
					  "where carr_ccod='"&carr_ccod&"' and tsca_ccod=3 and saca_tdesc like 'Licencia%' "
	'response.Write(c_licenciaturas)				  
	q_grabado = conexion.consultaUno("select count(*) from alumnos_salidas_carrera a,salidas_carrera b where cast(a.pers_ncorr as varchar)='"&q_pers_ncorr&"' and a.saca_ncorr=b.saca_ncorr and tsca_ccod=3 and carr_ccod='"&carr_ccod_defecto&"'")
	
	if q_grabado <> "0" then
		q_saca_ncorr2 = conexion.consultaUno("select a.saca_ncorr from alumnos_salidas_carrera a,salidas_carrera b where cast(a.pers_ncorr as varchar)='"&q_pers_ncorr&"' and a.saca_ncorr=b.saca_ncorr and tsca_ccod=3 and carr_ccod='"&carr_ccod_defecto&"'")
	else
		q_saca_ncorr2 = null
	end if
	
	licenciaturas.agregacampoparam	"saca_ncorr2",	"destino", "("& c_licenciaturas &")m"
	licenciaturas.agregacampocons	"saca_ncorr2",	q_saca_ncorr2
	licenciaturas.siguiente
					  
end if

'-------------------------------------------------------------------
if EsVacio(asca_ncorr) then
	str_accion = "Asignar salida de alumno"
else
	str_accion = "Editar salida de alumno"
end if

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
	var titulado = '<%=titulado%>';
	var tsca_ccod = '<%=tsca_ccod%>';
	if ( (tsca_ccod != '4') )
	{
		if ( (valor2) && (valor !="") && (titulado=='N') )
		{
			var arreglo_fecha = valor.split("/");
			var dia = arreglo_fecha[0];
			var mes = arreglo_fecha[1];
			var ano = arreglo_fecha[2];
			if ( mes == 1 )
			  {
				 semestre_destino = " 1er ";
				 ano_destino = ano;
				 document.edicion.anos_ccod_titulacion.value=ano;
				 document.edicion.plec_ccod_titulacion.value="1";
			  }
			  else if(( mes > 1 )&&( mes <=7 ))
			  {
				 semestre_destino = " 2do ";
				 ano_destino = ano;
				 document.edicion.anos_ccod_titulacion.value=ano;
				 document.edicion.plec_ccod_titulacion.value="2";
			  }
			  else if( mes > 7 )
			  {
				 semestre_destino = " 1er ";
				 ano_destino = (ano*1)+1;
				 document.edicion.anos_ccod_titulacion.value=ano_destino;
				 document.edicion.plec_ccod_titulacion.value="1";
			  }
			  document.edicion.descripcion.value = "-Al grabar se creará una matrícula con estado de titulado en el"+semestre_destino+"semestre del año "+ano_destino;
			  document.getElementById("texto_alerta").style.visibility="visible";
		}
	}	
}
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">	  <br>
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
            <td><%pagina.DibujarLenguetasFClaro Array(Array("Mensajes", url_leng_0), Array("Datos Pers.", url_leng_1), Array("Docs Alumno", url_leng_2),Array("Hist. Notas", url_leng_3), Array("Práctica prof.", url_leng_4), Array("Datos Egreso", url_leng_5),Array("Reg. Salida", url_leng_6), Array("Tesis y comisión", url_leng_7), Array("Conc. Notas", url_leng_8)), 7%></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><br>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo str_accion%>
                      <br>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><div align="center"><%f_salida.DibujaRegistro%></div></td>
                        </tr>
                        <tr>
                          <td>&nbsp;</td>
                        </tr>
						<%if tsca_ccod="1" then%>
                        <tr>
                          <td>
						  	  <table width="100%" height="30" cellpadding="0" cellspacing="0" border="1">
							  	<tr>
								    <td width="20%"><strong>Licenciatura :</strong></td>
								   <td width="80%"><%licenciaturas.DibujaCampo("saca_ncorr2")%></td>
								</tr>
							  </table>	
						  </td>
                        </tr>
						<%end if%> 						
						<tr>
                          <td align="left">
						    <div  align="left" id="texto_alerta" style="visibility: hidden;">
                          	<input type="text" size="100" maxlength="200" name="descripcion" style="background=#8a9a21;color=#FFFFFF;border: none;font-weight: bold" value="">
                            <input type="hidden" name="anos_ccod_titulacion" value="">
							<input type="hidden" name="plec_ccod_titulacion" value="">
						    </div>
						  </td>
                        </tr>
						
                        <%if mensaje_as_faltantes <> "" then %>
                        <tr>
                          <td bgcolor="#CC6600" align="left">
                          	<font color="#FFFFFF">
							  <strong>-<%=mensaje_as_faltantes%></strong>	                            
                             </font>
                          </td>
                        </tr>
                        <%end if%>
                        <%if mensaje_bloqueo <> "" then %>
                        <tr>
                          <td bgcolor="#CC6600" align="left">
                          	<font color="#FFFFFF">
							  <strong>-<%=mensaje_bloqueo%></strong>	                            
                             </font>
                          </td>
                        </tr>
                        <%end if%>
						<% if permiso_escuela = "0" then%>
						  <tr>
							<td align="center"><font color="#8A0808">LA  ESCUELA NO POSEE PERMISOS DE INGRESO O EDICIÓN DE DATOS</font></td>
						  </tr>
						<%end if%>
					  <tr>
						<td>&nbsp;</td>
					  </tr>
                      </table></td>
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
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><% if permiso_escuela = "0" then
				                                f_botonera.AgregaBotonParam "siguiente" , "deshabilitado" , "true"
											 end if
				                             f_botonera.DibujaBoton "siguiente" %></div></td>
                  <td><div align="center"><%f_botonera.DibujaBoton "cerrar" %></div></td>
                </tr>
              </table>
            </div></td>
            <td width="62%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
