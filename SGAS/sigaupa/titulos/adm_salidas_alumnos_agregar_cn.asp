<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO: EGRESO Y TITULACION 
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:20/02/2013
'ACTUALIZADO POR		:JAIME PAINEMAL A.
'MOTIVO			:Corregir código, eliminar sentencia *=
'LINEA			:115,117,120,122,124,127,129,131,134,136,140,142,144,148,150,153,155,158,160,165,167,170,172,174,176
'********************************************************************
saca_ncorr  = Request.QueryString("saca_ncorr")
pers_ncorr  = Request.QueryString("pers_ncorr")

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Datos de Títulos y Grados"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores = new cErrores

if session("msjOk") <> ""  then
	mensaje_html = "<center> "&_
				   "     <table border='1'  bordercolor='#339900' cellspacing='2' cellpadding='5' align='center'> "&_
				   "       <tr>"&_
				   "	         <td align='center' bgcolor='#CCFFCC'>"&session("msjOk")&"</td> "&_
				   "       </tr>"&_
				   "     </table> "&_
				   " </center>"
	session("msjOk")=""
end if
if session("msjError") <> ""  then
	mensaje_html = "<center>"&_
				   "    <table border='1'  bordercolor='#CC6600' cellspacing='2' cellpadding='5' align='center'> "&_
				   "      <tr> "&_
				   "         <td align='center' bgcolor='#FFCC66'>"&session("msjError")&"</td> "&_
				   "      </tr> "&_
				   "    </table> "&_
				   "</center>"
	session("msjError")=""
end if

'---------------------------------------------------------------------------------------------------'
set f_salida = new CFormulario
f_salida.Carga_Parametros "adm_salidas_alumnos.xml", "salida"
f_salida.Inicializar conexion

'SQL = " select b.pers_ncorr,a.saca_ncorr,cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, b.pers_nrut, b.pers_xdv,  "& vbCrLf &_
'      " b.pers_tnombre + ' ' + b.pers_tape_paterno + ' ' + b.pers_tape_materno as alumno, "& vbCrLf &_
'	  " a.saca_tdesc as salida, c.tsca_ccod,case c.tsca_ccod when 1 then '<font color=#073299><strong>' "& vbCrLf &_ 
'      "            when 2 then '<font color=#004000><strong>' "& vbCrLf &_ 
'  	  " 		   when 3 then '<font color=#b76d05><strong>' "& vbCrLf &_ 
'	  "			   when 4 then '<font color=#714e9c><strong>' "& vbCrLf &_ 
'	  " 		   when 5 then '<font color=#ab2b05><strong>' "& vbCrLf &_ 
'	  "  		   when 6 then '<font color=#0078c0><strong>' end + c.tsca_tdesc + '</strong></font>' as tipo_salida, d.carr_ccod, d.carr_tdesc, "& vbCrLf &_
'      "    (select top 1 sede_ccod from alumnos t1, ofertas_academicas t2, especialidades t3 "& vbCrLf &_
'      "            where t1.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod "& vbCrLf &_
'      "            and t1.pers_ncorr=b.pers_ncorr and t3.carr_ccod=a.carr_ccod order by t2.peri_ccod desc) as sede_ccod, "& vbCrLf &_
'      "    (select top 1 sede_tdesc from alumnos t1, ofertas_academicas t2, especialidades t3,sedes t4 "& vbCrLf &_
'      "            where t1.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod and t2.sede_ccod=t4.sede_ccod "& vbCrLf &_
'      "            and t1.pers_ncorr=b.pers_ncorr and t3.carr_ccod=a.carr_ccod order by t2.peri_ccod desc) as sede_tdesc,   "& vbCrLf &_
'      "    (select top 1 jorn_tdesc from alumnos t1, ofertas_academicas t2, especialidades t3,jornadas t4 "& vbCrLf &_
'      "            where t1.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod and t2.jorn_ccod=t4.jorn_ccod "& vbCrLf &_
'      "            and t1.pers_ncorr=b.pers_ncorr and t3.carr_ccod=a.carr_ccod order by t2.peri_ccod desc) as jorn_tdesc,"& vbCrLf &_              
'	  "    (select top 1 peri_ccod from alumnos t1, ofertas_academicas t2, especialidades t3 "& vbCrLf &_
'      "            where t1.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod "& vbCrLf &_
'      "            and t1.pers_ncorr=b.pers_ncorr and t3.carr_ccod=a.carr_ccod and t1.emat_ccod in (4,8) "& vbCrLf &_
'	  "            order by t2.peri_ccod desc) as peri_ccod, "& vbCrLf &_
'	  "    (select top 1 peri_tdesc from alumnos t1, ofertas_academicas t2, especialidades t3,periodos_academicos t4 "& vbCrLf &_
'      "            where t1.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod and t2.peri_ccod=t4.peri_ccod "& vbCrLf &_
'      "            and t1.pers_ncorr=b.pers_ncorr and t3.carr_ccod=a.carr_ccod and t1.emat_ccod in (4,8) "& vbCrLf &_
'	  "            order by t2.peri_ccod desc) as peri_tdesc, "& vbCrLf &_
'      "    (select case count(*) when 0 then 'N' else 'S' end  from alumnos t1, ofertas_academicas t2, especialidades t3 "& vbCrLf &_
'      "            where t1.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod "& vbCrLf &_
'      "            and t1.pers_ncorr=b.pers_ncorr and t3.carr_ccod=a.carr_ccod and t1.emat_ccod in (4)) as egresado,     "& vbCrLf &_
'      "    (select case count(*) when 0 then 'N' else 'S' end  from alumnos t1, ofertas_academicas t2, especialidades t3 "& vbCrLf &_
'      "            where t1.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod "& vbCrLf &_
'      "            and t1.pers_ncorr=b.pers_ncorr and t3.carr_ccod=a.carr_ccod and t1.emat_ccod in (8)) as titulado, "& vbCrLf &_
'	  "    (select top 1 t1.plan_ccod  from alumnos t1, ofertas_academicas t2, especialidades t3 "& vbCrLf &_
'      "            where t1.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod "& vbCrLf &_
'      "            and t1.pers_ncorr=b.pers_ncorr and t3.carr_ccod=a.carr_ccod and t1.emat_ccod in (8) order by peri_ccod desc) as plan_ccod, "& vbCrLf &_
'	  " asca_ncorr, protic.trunc(asca_fsalida) as asca_fsalida, asca_nfolio, asca_nregistro, replace(cast(asca_nnota as decimal(2,1)),',','.') as asca_nnota, ' '  as asca_bingr_manual, "& vbCrLf &_ 
'	  " (select max(peri_ccod)  "& vbCrLf &_ 
'  	  "      from alumnos t1,ofertas_academicas t2, especialidades t3 "& vbCrLf &_ 
'      "      where t1.pers_ncorr=b.pers_ncorr and t1.ofer_ncorr=t2.ofer_ncorr  "& vbCrLf &_ 
'      "      and t2.espe_ccod=t3.espe_ccod and t3.carr_ccod=d.carr_ccod and isnull(t1.emat_ccod,0) <> 9) as ultimo_periodo  "& vbCrLf &_                                  
'	  " from salidas_carrera a, personas b,tipos_salidas_carrera c, carreras d, alumnos_salidas_carrera e "& vbCrLf &_
'	  " where cast(b.pers_ncorr as varchar)='"&pers_ncorr&"' and cast(a.saca_ncorr as varchar)='"&saca_ncorr&"' "& vbCrLf &_
'	  " and a.tsca_ccod=c.tsca_ccod and a.carr_ccod=d.carr_ccod "& vbCrLf &_
'	  " and a.saca_ncorr *= e.saca_ncorr and b.pers_ncorr *= e.pers_ncorr" 

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
      "            WHERE t1.pers_ncorr=b.pers_ncorr and t3.carr_ccod=a.carr_ccod order by t2.peri_ccod desc) as sede_ccod, "& vbCrLf &_ 
      "    (select top 1 sede_tdesc from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_ 
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_ 
      "            INNER JOIN especialidades t3 "& vbCrLf &_ 
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_ 
      "            INNER JOIN sedes t4 "& vbCrLf &_ 
      "            ON t2.sede_ccod=t4.sede_ccod "& vbCrLf &_ 
      "            WHERE t1.pers_ncorr=b.pers_ncorr and t3.carr_ccod=a.carr_ccod order by t2.peri_ccod desc) as sede_tdesc, "& vbCrLf &_ 
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
      "            ON t2.peri_ccod=t4.peri_ccod "& vbCrLf &_ 
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
      "            ON t2.espe_ccod=t3.espe_ccod "& vbCrLf &_ 
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (8)) as titulado, "& vbCrLf &_ 
      "    (select top 1 t1.plan_ccod  from alumnos t1 INNER JOIN ofertas_academicas t2 "& vbCrLf &_ 
      "            ON t1.ofer_ncorr = t2.ofer_ncorr "& vbCrLf &_ 
      "            INNER JOIN especialidades t3 "& vbCrLf &_ 
      "            ON t2.espe_ccod = t3.espe_ccod "& vbCrLf &_ 
      "            WHERE t1.pers_ncorr = b.pers_ncorr and t3.carr_ccod = a.carr_ccod and t1.emat_ccod in (8) order by peri_ccod desc) as plan_ccod, "& vbCrLf &_ 
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
      " ON a.tsca_ccod = c.tsca_ccod "& vbCrLf &_ 
      " INNER JOIN carreras d "& vbCrLf &_ 
      " ON a.carr_ccod = d.carr_ccod "& vbCrLf &_ 
      " LEFT OUTER JOIN alumnos_salidas_carrera e "& vbCrLf &_ 
      " ON a.saca_ncorr = e.saca_ncorr and b.pers_ncorr = e.pers_ncorr" 

f_salida.Consultar SQL
'response.Write("<pre>"&SQL&"</pre>")'
f_salida.Siguiente
plan_ccod = f_salida.obtenerValor("plan_ccod")
egresado  = f_salida.obtenerValor("egresado")
titulado  = f_salida.obtenerValor("titulado")
carr_ccod = f_salida.obtenerValor("carr_ccod")
tsca_ccod = f_salida.obtenerValor("tsca_ccod")
asca_ncorr = f_salida.obtenerValor("asca_ncorr")
asca_nregistro = f_salida.obtenerValor("asca_nregistro")
ultimo_periodo = f_salida.obtenerValor("ultimo_periodo")
carr_ccod_informar = carr_ccod
if titulado = "N" and not EsVacio(ultimo_periodo) then
 c_detalle_ultima_matricula = " Select top 1 'El alumno no se encuentra titulado en la carrera seleccionada, su última matrícula corresponde a la especialidad: <strong>'+lower(c.espe_tdesc)+' - '+lower(d.plan_tdesc)+'</strong>, con el estado de matrícula '+e.emat_tdesc "&_
                               " from alumnos a, ofertas_academicas b, especialidades c, planes_estudio d, estados_matriculas e "&_
							   " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.plan_ccod=d.plan_ccod and a.emat_ccod=e.emat_ccod "&_
							   " and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and cast(b.peri_ccod as varchar)='"&ultimo_periodo&"' and c.carr_ccod='"&carr_ccod&"' and isnull(a.emat_ccod,0) <> 9 order by peri_ccod desc "
 detalle_ultima_matricula =  conexion.consultaUno(c_detalle_ultima_matricula)
 c_plan_ccod = " select top 1 a.plan_ccod "&_
               " from alumnos a, ofertas_academicas b, especialidades c, planes_estudio d, estados_matriculas e "&_
			   " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.plan_ccod=d.plan_ccod and a.emat_ccod=e.emat_ccod "&_
			   " and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and cast(b.peri_ccod as varchar)='"&ultimo_periodo&"' and c.carr_ccod='"&carr_ccod&"' and isnull(a.emat_ccod,0) <> 9 order by peri_ccod desc "
 
 c_plan_ccod = "SELECT plan_ccod FROM detalles_titulacion_carrera WHERE plan_ccod = (SELECT plan_ccod FROM SALIDAS_CARRERA WHERE SACA_NCORR="&saca_ncorr&") and cast(pers_ncorr as varchar)='"&pers_ncorr&"'"
 plan_ccod = conexion.consultaUno(c_plan_ccod)
end if
q_plan_ccod  = plan_ccod
q_peri_ccod  = ultimo_periodo
q_pers_nrut  = f_salida.obtenerValor("pers_nrut")
q_pers_xdv   = f_salida.obtenerValor("pers_xdv")

'---------------------------------------------------------------------------------------------------'
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "adm_salidas_alumnos.xml", "botonera_de"

'---------------------------------------------------------------------------------------------------'
set f_titulado = new CFormulario
f_titulado.Carga_Parametros "adm_salidas_alumnos.xml", "encabezado_de"
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
'response.Write("<pre>"&SQL&"</pre>")
f_titulado.Consultar SQL
f_titulado.SiguienteF
v_sede_ccod = f_titulado.obtenerValor ("sede_ccod")

q_pers_ncorr = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")

tsca_ccod = conexion.consultaUno("select tsca_ccod from salidas_carrera where cast(saca_ncorr as varchar)='"&saca_ncorr&"'")

'response.write "select tsca_ccod from salidas_carrera where cast(saca_ncorr as varchar)='"&saca_ncorr&"'"
'
'LOS TSCA_CCOD SON LOS SIGUIENTE
'
'TSCA_CCOD	TSCA_TDESC
'1	TÍTULO PROFESIONAL
'2	TÍTULO TÉCNICO DE NIVEL SUPERIOR
'3	GRADO ACADÉMICO
'4	SALIDA INTERMEDIA
'5	MENCIÓN
'6	MINORS
'7	TEORIA DE LA IMAGEN


if tsca_ccod = "4" then 
	
	sql_texto = "select case count(*) when 0 then 'N' else 'S' end  from detalles_titulacion_carrera where cast(plan_ccod as varchar)='"&saca_ncorr&"' and cast(pers_ncorr as varchar)='"&q_pers_ncorr&"'"
	'response.write sql_texto
	tiene_grabado = conexion.consultaUno(sql_texto)
	plan_consulta = saca_ncorr
	
else
	sql_texto = "select case count(*) when 0 then 'N' else 'S' end  from detalles_titulacion_carrera where cast(plan_ccod as varchar)='"&q_plan_ccod&"' and cast(pers_ncorr as varchar)='"&q_pers_ncorr&"' and carr_ccod='"&carr_ccod&"'"
	'response.write sql_texto &"<br>"
	tiene_grabado = conexion.consultaUno(sql_texto)
	plan_consulta = q_plan_ccod
end if


'response.write tiene_grabado

'---------------------------------------------------------------------------------------------------'
'----------------------------------------------Datos a mostrar en la concentración-----------------'
if tiene_grabado = "S" then
 
 consulta_concentracion = "  select pers_ncorr,plan_ccod,a.carr_ccod,replace(calificacion_notas,',','.') as calificacion_notas, "& vbCrLf &_
						  "  isnull(porcentaje_notas,(select top 1 saca_npond_asignaturas from salidas_carrera tt "& vbCrLf &_
                          "                           where tt.plan_ccod=a.plan_ccod and tt.carr_ccod=a.carr_ccod and tsca_ccod=1)) as porcentaje_notas, "& vbCrLf &_
						  " replace(cast(cast(calificacion_practica as decimal(2,1)) as varchar),',','.') as calificacion_practica,porcentaje_practica,porcentaje_tesis,isnull(mostrar_concentracion,'N') as mostrar_concentracion, "& vbCrLf &_
						  " replace(promedio_final,',','.') as promedio_final,replace(nota_tesis,',','.') as nota_tesis,porcentaje_nota_tesis, "& vbCrLf &_
						  " (select replace(cast(cast(avg(calificacion_asignada) as decimal(3,2)) as varchar),',','.') from comision_tesis tt  "& vbCrLf &_
                          "                     where tt.pers_ncorr=a.pers_ncorr and tt.plan_ccod=a.plan_ccod) as promedio_tesis   "& vbCrLf &_
						  " from detalles_titulacion_carrera a "& vbCrLf &_
					      " where cast(plan_ccod as varchar)='"&plan_consulta&"' and cast(pers_ncorr as varchar)='"&q_pers_ncorr&"' and carr_ccod='"&carr_ccod&"'"
' response.Write("<pre>"&consulta_concentracion&"</pre>")
else
     consulta_concentracion = " select '"&plan_consulta&"' as plan_ccod, '"&q_pers_ncorr&"' as pers_ncorr"
end if
'response.Write("<pre>"&consulta_concentracion&"</pre>")'
set f_concentracion = new CFormulario
f_concentracion.Carga_Parametros "adm_salidas_alumnos.xml", "concentracion"
f_concentracion.Inicializar conexion

f_concentracion.Consultar consulta_concentracion
f_concentracion.Siguiente
promedio_tesis = f_concentracion.obtenerValor("promedio_tesis")
calificacion_practica = f_concentracion.obtenerValor("calificacion_practica")


'-------------------------------------------------------------------------------------------------- '
set f_param_impresion = new CFormulario
f_param_impresion.Carga_Parametros "adm_salidas_alumnos.xml", "param_impresion"
f_param_impresion.Inicializar conexion
f_param_impresion.Consultar "select ''"   
   
if esVacio(q_solo_aprobadas) or q_solo_aprobadas="N" then
	q_solo_aprobadas=""
end if 
if esVacio(ultimo_periodo) then
	q_peri_ccod2=1
else
	q_peri_ccod = ultimo_periodo
	q_peri_ccod2 = cint(ultimo_periodo)
end if	

f_param_impresion.AgregaCampoCons "pers_nrut", q_pers_nrut
f_param_impresion.AgregaCampoCons "pers_xdv", q_pers_xdv
f_param_impresion.AgregaCampoCons "peri_ccod", q_peri_ccod2
f_param_impresion.AgregaCampoCons "solo_aprobadas", q_solo_aprobadas
f_param_impresion.AgregaCampoCons "plan_ccod", plan_consulta
f_param_impresion.AgregaCampoCons "sede_ccod", v_sede_ccod
f_param_impresion.AgregaCampoCons "carrera", plan_consulta
'response.Write(v_sede_ccod)'
'---------------------------------------------------------------------------------------------------'

f_botonera.AgregaBotonUrlParam "siguiente", "plan_ccod", q_plan_ccod
f_botonera.AgregaBotonUrlParam "siguiente", "peri_ccod", q_peri_ccod

f_botonera.AgregaBotonUrlParam "guardar_nuevo", "plan_ccod", q_plan_ccod
f_botonera.AgregaBotonUrlParam "guardar_nuevo", "peri_ccod", q_peri_ccod

'---------------------------------------------------------------------------------------------------'
url_leng_1 = "adm_salidas_alumnos_agregar.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & q_pers_ncorr
url_leng_2 = "adm_salidas_alumnos_agregar_dp.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & q_pers_ncorr
url_leng_3 = "adm_salidas_alumnos_agregar_de.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & q_pers_ncorr
url_leng_4 = "adm_salidas_alumnos_agregar_dt.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & q_pers_ncorr
url_leng_5 = "adm_salidas_alumnos_agregar_cn.asp?saca_ncorr=" & saca_ncorr & "&pers_ncorr=" & q_pers_ncorr

'tsca_ccod = conexion.consultaUno("select tsca_ccod from salidas_carrera where cast(saca_ncorr as varchar)='"&saca_ncorr&"'")'
if tsca_ccod = "4" OR tsca_ccod = "3" then
	'salida = "select case count(*) when 0 then 'N' else 'S' end  from alumnos_salidas_intermedias where cast(saca_ncorr as varchar) = '"&saca_ncorr&"' and cast(pers_ncorr as varchar)='"&q_pers_ncorr&"' and emat_ccod=8 "
	'response.write salida
	salida_intermedia_licenciatura = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end  from alumnos_salidas_intermedias where cast(saca_ncorr as varchar) = '"&saca_ncorr&"' and cast(pers_ncorr as varchar)='"&q_pers_ncorr&"' and emat_ccod=8 ")
else
	salida_intermedia_licenciatura = "N"
end if	

mensaje_faltante = ""
'if egresado  = "N" and titulado  = "N" OR titulo_salida_intermedia = "0" then
'response.write Titulado&" .... "&salida_intermedia_licenciatura
if egresado  <> "S" AND Titulado  <> "S" AND salida_intermedia_licenciatura <> "S" then
	mensaje_faltante = "<center>"&_
				       "    <table border='1'  bordercolor='#CC6600' cellspacing='2' cellpadding='5' align='center'> "&_
					   "      <tr> "&_
					   "         <td align='center' bgcolor='#FFCC66'>El alumno no presenta matrículas en estado de egresado o titulado para la carrera seleccionada, se requiere de dichas matrículas para ingresar esta información.</td> "&_
					   "      </tr> "&_
					   "    </table> "&_
					   "</center>"
end if


se_titulo = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end  from salidas_alumnos a, salidas_plan b where a.sapl_ncorr = b.sapl_ncorr and cast(b.plan_ccod as varchar)='"&plan_ccod&"' and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'")
'response.End()'

codigo_carrera = carr_ccod

es_moroso = conexion.consultaUno("select protic.es_moroso('"&pers_ncorr&"', getDate())")


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
//ClipFloatByScriptma.03 
//pedimos el numero y el # de decimales 
function clipFloat(num,decimales)
{ 
	//creamos variable local String 
	var t=num+""; 
	/*Al string lo delimitamos desde 0 (inicio) hasta el punto, mas los decimales y 1 (el punto), y lo convertimos a numero flotante (real) 
	*/ 
	 var num2 = parseFloat(t.substring(0,(t.indexOf(".")+decimales+1))); 
	//regresamos el valor 
	//alert("recibo "+num+" devuelvo "+num2);
	return (num2); 
} 

function certificado_titulo()
{
   var formulario=document.edicion
   var peri=<%=q_peri_ccod%>;
   var plan=<%=q_plan_ccod%>;
   var rut=<%=q_pers_nrut%>;
   var sede=<%=v_sede_ccod%>;
   self.open('certificado_titulo.asp?peri_ccod='+ peri+'&plan_ccod='+plan+'&pers_nrut='+rut+'&sede_ccod='+sede,'certificado','width=700px, height=550px, scrollbars=yes, resizable=yes')
}

function calcular()
{
	var notas = document.concentracion.elements["concentracion[0][calificacion_notas]"].value;
	var practica = document.concentracion.elements["concentracion[0][calificacion_practica]"].value;
	var tesis = document.concentracion.elements["concentracion[0][calificacion_tesis]"].value;
	var nota_tesis = document.concentracion.elements["concentracion[0][nota_tesis]"].value;
	var porc_notas = document.concentracion.elements["concentracion[0][porcentaje_notas]"].value;
	var porc_practica = document.concentracion.elements["concentracion[0][porcentaje_practica]"].value;
	var porc_tesis = document.concentracion.elements["concentracion[0][porcentaje_tesis]"].value;
	var porc_nota_tesis = document.concentracion.elements["concentracion[0][porcentaje_nota_tesis]"].value;
	var valor1=0.0;
	var valor2=0.0;
	var valor3=0.0;
	var valor4=0.0;
	var suma = (porc_notas * 1) + (porc_practica * 1) + (porc_tesis * 1) + (porc_nota_tesis * 1);
	//alert(suma);
	var promedio_final=0.0;
	if (suma == 100 )
	 { valor1 = (notas * porc_notas) / 100;
	   valor1 = clipFloat(valor1,2);
	   document.concentracion.elements["valor1"].value=valor1;
	   valor2 = (practica * porc_practica) / 100;
	   valor2 = clipFloat(valor2,2);
	   document.concentracion.elements["valor2"].value=valor2;
	   valor3 = (tesis *  porc_tesis) / 100;
	   //alert(tesis+" * ("+porc_tesis+" / 100) ="+valor3);
	   valor3 = clipFloat(valor3,2);
	   document.concentracion.elements["valor3"].value=valor3;
	   valor4 = (nota_tesis * porc_nota_tesis) / 100;
	   valor4 = clipFloat(valor4,2);
	   document.concentracion.elements["valor4"].value=valor4;
	   //pasamos los valores del formulario
	   //valor1 = document.concentracion.elements["valor1"].value * 1;
	   //alert(valor1);
	   //valor2 = document.concentracion.elements["valor2"].value * 1;
	   //alert(valor2);
	   //valor3 = document.concentracion.elements["valor3"].value * 1;
	   //alert(valor3);
	   //valor4 = document.concentracion.elements["valor4"].value * 1;
	   //alert(valor4);
	   //alert(valor1+" + "+valor2+" + "+valor3+" + "+valor4);
	   promedio_final2 = valor1 + valor2 + valor3 + valor4;
	   //alert(valor1+" + "+valor2+" + "+valor3+" + "+valor4+" = "+promedio_final2);
	   //promedio_final2 = promedio_final;
	   //promedio_final2 = roundFun(promedio_final,2);//se rempleaza 10 por 2
	   ////promedio_final2 = roundFun(promedio_final2,1);
	   //alert("promedio " + promedio_final2);
	   document.concentracion.elements["promedio_final"].value=promedio_final2;
	   document.concentracion.elements["promedio_final"].value=document.concentracion.elements["promedio_final"].value.substring(0,4);
	   document.concentracion.elements["concentracion[0][promedio_final]"].value=promedio_final2;
	   document.concentracion.elements["concentracion[0][promedio_final]"].value=document.concentracion.elements["concentracion[0][promedio_final]"].value.substring(0,4);
	   if (confirm("¿Está Seguro que desea grabar los datos para la concentracón de notas?"))
	   {
	   		return true;
	   }
	   else
	   {
	  	 	return false;
	   }
	 }
	 else
	 {
	 	alert("El porcentaje ingresado no corresponde al 100% necesario para cálculos de promedio final");
	 }  
	//alert("promedio " + promedio_final);
	return false;
}

function guarda_notas()
{
   var formulario=document.edicion
   var valor=edicion.elements["p[0][tdes_ccod]"].value;
   if (valor != "")
   		{   
			window.open('guarda_certificado.asp?carr_ccod=<%=codigo_carrera%>&tipo=1&pers_nrut=<%=q_pers_nrut%>&tdes_ccod='+ valor,'guardar','width=700px, height=550px, scrollbars=yes, resizable=yes')
		}
   else
   	    { 
	      	alert("Antes de guardar debe indicar el motivo por el que se extendió el certificado");
	     	edicion.elements["p[0][tdes_ccod]"].focus();		
	    }	
}
	  
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');">
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
            <td><%pagina.DibujarLenguetasFClaro Array(Array("Editar salida de alumno", url_leng_1), Array("Datos Personales", url_leng_2), Array("Información Egreso", url_leng_3), Array("Información Titulación", url_leng_4), Array("Conc. Notas", url_leng_5)),5%></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><br>
              
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>
                      <br>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td><div align="center"><%f_titulado.DibujaRegistro%></div></td>
                        </tr>
                      </table>
					</td>
                  </tr>
				  <tr><td>&nbsp;</td></tr>
				  <%if mensaje_faltante = "" then %>
				  <tr>
                    <td><%pagina.DibujarSubtitulo "Datos para Certificado de Concentración de Notas."%>
                      <br>
					  <form name="concentracion">
					      <input type="hidden" name="valor1" size="4" maxlength="4" value="">
						  <input type="hidden" name="valor2" size="4" maxlength="4" value="">
						  <input type="hidden" name="valor3" size="4" maxlength="4" value="">
						  <input type="hidden" name="valor4" size="4" maxlength="4" value="">
						  <input type="hidden" name="saca_ncorr" value="<%=saca_ncorr%>">
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td align="center">
						  		<table border="1" width="60%">
								<tr>
								    <td width="20%" align="center" bgcolor="#CC6600"><strong>Concepto</strong><input type="hidden" name="concentracion[0][pers_ncorr]" value="<%=q_pers_ncorr%>"></td>
									<td width="20%" align="center" bgcolor="#CC6600"><strong>Nota</strong><input type="hidden" name="concentracion[0][plan_ccod]" value="<%=q_plan_ccod%>"></td>
									<td width="20%" align="center" bgcolor="#CC6600"><strong>Porcentaje</strong><input type="hidden" name="concentracion[0][carr_ccod]" value="<%=carr_ccod%>"></td>
								</tr>
								<tr>
								    <td width="20%" align="right"><strong>Promedio Notas</strong></td>
									<td width="20%" align="center"><%f_concentracion.dibujaCampo("calificacion_notas")%></td>
									<td width="20%" align="center"><%f_concentracion.dibujaCampo("porcentaje_notas")%></td>
								</tr>
								<tr>
								    <td width="20%" align="right"><strong>Práctica Profesional</strong></td>
									<td width="20%" align="center"><%=calificacion_practica%><input type="hidden" name="concentracion[0][calificacion_practica]" maxlength="4" size="10" id="NO-N" value="<%=calificacion_practica%>"></td>
									<td width="20%" align="center"><%f_concentracion.dibujaCampo("porcentaje_practica")%></td>
								</tr>
								<tr>
								   <%if carr_ccod="860" then%>
								    <td width="20%" align="right"><strong>Seminario de Título</strong></td>
								   <%else%>
								    <td width="20%" align="right"><strong>Examen de Título</strong></td> 
								   <%end if%>
									<td width="20%" align="center"><%=promedio_tesis%><input type="hidden" name="concentracion[0][calificacion_tesis]" maxlength="4" size="10" id="NO-N" value="<%=promedio_tesis%>"></td>
									<td width="20%" align="center"><%f_concentracion.dibujaCampo("porcentaje_tesis")%><%f_concentracion.dibujaCampo("promedio_final")%></td>
								</tr>
								<tr>
								    <td width="20%" align="right"><strong>Nota de Tesis</strong></td>
									<td width="20%" align="center"><%f_concentracion.dibujaCampo("nota_tesis")%></td>
									<td width="20%" align="center"><%f_concentracion.dibujaCampo("porcentaje_nota_tesis")%></td>
								</tr>
								<tr>
								    <td width="20%" align="right" colspan="2"><strong>Promedio Final</strong></td>
									<td width="20%" align="center"><input type="text" name="promedio_final" maxlength="4" size="10" value="<%=f_concentracion.obtenerValor("promedio_final")%>" disabled></td>
								</tr>
								<tr>
								    <td width="20%" align="right" colspan="2"><strong>Mostrar en Concentración</strong></td>
									<td width="20%" align="center"><%f_concentracion.dibujaCampo("mostrar_concentracion")%></td>
								</tr>
								<tr>
								    <td colspan="7" align="right"><%f_botonera.DibujaBoton "guardar_concentracion"%></td>
    							</tr>
								</table>
						  </td>
                        </tr>
                      </table>
					  </form>
					</td>
                  </tr>
				  <form name="edicion">
				    <input type="hidden" name="pers_ncorr" value="<%=pers_ncorr%>">
					<input type="hidden" name="saca_ncorr" value="<%=saca_ncorr%>">
				  	<tr><td align="left"><%f_param_impresion.DibujaRegistro%></td></tr>
					<tr>
                          <td align="left">
							  <table width="80%" border="1">
							  	<tr>
							  		<td width="30%"><strong>Comentarios Certificado</strong></td>
									<td width="70%"><textarea cols="50" rows="3" name="comentario"></textarea></td>
							  	</tr>
							  </table>
						  </td>
					</tr>
					<tr><td align="left">&nbsp;</td></tr>
				  </form>
				  <%else%>
				  <tr><td align="center" height="200"><%=mensaje_faltante%></td></tr>
				  <%end if%>
                </table>
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
				  <td><div align="center"><%f_botonera.DibujaBoton "cerrar"%></div></td>
                  <td><div align="center"><%if mensaje_faltante = "" then
				                               if es_moroso = "S" then
											   		f_botonera.AgregaBotonParam "imprimir_titulado", "deshabilitado", "true"
											   end if
											   f_botonera.DibujaBoton "imprimir_titulado"
											 end if%></div></td>
                  <td><div align="center"><%f_botonera.DibujaBoton "guardar_notas"%></div></td>
				  <td><div align="center"></div></td>
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
