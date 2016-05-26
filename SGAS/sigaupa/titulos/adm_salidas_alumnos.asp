<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_carr_ccod = Request.QueryString("b[0][carr_ccod]")
q_pers_nrut = Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")
carr_ccod_consultada = q_carr_ccod

'---------- IP DE PRUEBA ----------
ip_usuario = Request.ServerVariables("REMOTE_ADDR")
'response.Write("ip_usuario = "&ip_usuario&"</br>") 
ip_de_prueba = "172.16.100.91"
'----------------------------------

if ip_usuario = ip_de_prueba then
'response.Write("q_carr_ccod = "&q_carr_ccod&"</br>") 
'response.Write("q_pers_nrut = "&q_pers_nrut&"</br>") 
'response.Write("q_pers_xdv = "&q_pers_xdv&"</br>") 
'response.Write("carr_ccod_consultada = "&carr_ccod_consultada&"</br>") 
end if

'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Administración Salidas Alumno"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores = new cErrores
'---------------------------------------------------------------------------------------------------
set f_botonera_g = new CFormulario
f_botonera_g.Carga_Parametros "botonera_generica.xml", "botonera"

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "adm_salidas_alumnos.xml", "botonera"

'---------------------------------------------------------------------------------------------------
v_sede_ccod = negocio.ObtenerSede

if ip_usuario = ip_de_prueba then
'response.Write("q_carr_ccod = "&q_carr_ccod&"</br>") 
'response.Write("q_pers_nrut = "&q_pers_nrut&"</br>") 
'response.Write("q_pers_xdv = "&q_pers_xdv&"</br>") 
'response.Write("carr_ccod_consultada = "&carr_ccod_consultada&"</br>") 
'response.Write("v_sede_ccod = "&v_sede_ccod&"</br>") 
end if

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "adm_salidas_alumnos.xml", "busqueda"
f_busqueda.Inicializar conexion

f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "carr_ccod", q_carr_ccod
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv


'---------- Para llenar combo de Carreras -----------------------------------------------------------------------------------------
SQL =        " select distinct c.carr_ccod, c.carr_tdesc "
SQL = SQL &  " from ofertas_academicas a, especialidades b, carreras c "
SQL = SQL &  " where a.espe_ccod = b.espe_ccod "
SQL = SQL &  "   and b.carr_ccod = c.carr_ccod "
SQL = SQL &  "   and exists (select 1 from alumnos tt where tt.ofer_ncorr=a.ofer_ncorr and tt.emat_ccod=1) "
SQL = SQL &  " UNION "
SQL = SQL &  "   select '' as carr_ccod,' TODAS ' as carr_tdesc "
SQL = SQL &  " order by c.carr_tdesc asc "
f_busqueda.InicializaListaDependiente "busqueda", SQL
'----------------------------------------------------------------------------------------------------------------------------------

if ip_usuario = ip_de_prueba then
'response.Write("q_carr_ccod = "&q_carr_ccod&"</br>") 
'response.Write("q_pers_nrut = "&q_pers_nrut&"</br>") 
'response.Write("q_pers_xdv = "&q_pers_xdv&"</br>") 
'response.Write("carr_ccod_consultada = "&carr_ccod_consultada&"</br>") 
'response.Write("v_sede_ccod = "&v_sede_ccod&"</br>") 
'response.Write("SQL = "&SQL&"</br>") 
end if

'---------- Si codigo de carrera no existe y rut existe-----------------------------------------------------------------------------
if q_carr_ccod = "" and q_pers_nrut <> "" then
    q_carr_ccod = conexion.consultaUno("select top 1 carr_ccod from alumnos tt, ofertas_academicas t2, especialidades t3, personas t4 where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod and tt.pers_ncorr=t4.pers_ncorr and cast(t4.pers_nrut as varchar)='"&q_pers_nrut&"' and emat_ccod not in (3,5,9,14) order by peri_ccod desc ")
end if
'----------------------------------------------------------------------------------------------------------------------------------

'---------- Datos del alumno(a) y condicion de egresado y titulado ----------------------------------------------------------------
c_datos = " select a.pers_ncorr, cast(pers_nrut as varchar)+'-'+pers_xdv as rut, "& vbCrLf &_
		  " protic.initCap(pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno) as alumno, "& vbCrLf &_
		  " (select case count(*) when 0 then 'N' else 'S' end from alumnos t1,ofertas_academicas t2, especialidades t3 "& vbCrLf &_
          "       where t1.pers_ncorr=a.pers_ncorr and t1.ofer_ncorr=t2.ofer_ncorr "& vbCrLf &_
          "       and t2.espe_ccod=t3.espe_ccod and t3.carr_ccod='"&q_carr_ccod&"' and t1.emat_ccod=8) as titulado, "& vbCrLf &_
		  " (select case count(*) when 0 then 'N' else 'S' end from alumnos t1,ofertas_academicas t2, especialidades t3 "& vbCrLf &_
          "       where t1.pers_ncorr=a.pers_ncorr and t1.ofer_ncorr=t2.ofer_ncorr "& vbCrLf &_
          "       and t2.espe_ccod=t3.espe_ccod and t3.carr_ccod='"&q_carr_ccod&"' and t1.emat_ccod=4) as egresado, "& vbCrLf &_
		  " (select case count(*) when 0 then 'N' else 'S' end from alumnos t1,ofertas_academicas t2, especialidades t3 "& vbCrLf &_
          "       where t1.pers_ncorr=a.pers_ncorr and t1.ofer_ncorr=t2.ofer_ncorr "& vbCrLf &_
          "       and t2.espe_ccod=t3.espe_ccod and t3.carr_ccod='"&q_carr_ccod&"' and t1.emat_ccod in (1,4) ) as en_carrera, "& vbCrLf &_             
		  " (select top 1 t1.plan_ccod from alumnos t1,ofertas_academicas t2, especialidades t3 "& vbCrLf &_ 
          "       where t1.pers_ncorr=a.pers_ncorr and t1.ofer_ncorr=t2.ofer_ncorr "& vbCrLf &_ 
          "       and t2.espe_ccod=t3.espe_ccod and t3.carr_ccod='"&q_carr_ccod&"' and t1.emat_ccod=8 order by t2.peri_ccod desc) as plan_titulacion, "& vbCrLf &_ 
		  " (select case count(*) when 0 then 'N' else 'S' end from alumnos t1,ofertas_academicas t2,especialidades t3, planes_estudio t4"& vbCrLf &_ 
          "       where t1.pers_ncorr=a.pers_ncorr and t1.ofer_ncorr=t2.ofer_ncorr and t1.plan_ccod=t4.plan_ccod "& vbCrLf &_ 
          "       and t2.espe_ccod=t3.espe_ccod and t3.carr_ccod='"&q_carr_ccod&"' and t1.emat_ccod=8 and t3.espe_ccod=t4.espe_ccod) as encasillado, "& vbCrLf &_ 
          " (select top 1 'El alumno se encuentra titulado para la carrera '+lower(t5.carr_tdesc)+' en la especialidad: <strong>'+lower(t3.espe_tdesc)+' - '+lower(t4.plan_tdesc)+'</strong>'  "& vbCrLf &_ 
          "      from alumnos t1,ofertas_academicas t2, especialidades t3,planes_estudio t4, carreras t5 "& vbCrLf &_ 
          "      where t1.pers_ncorr=a.pers_ncorr and t1.ofer_ncorr=t2.ofer_ncorr and t1.plan_ccod=t4.plan_ccod and t3.carr_ccod=t5.carr_ccod "& vbCrLf &_ 
          "      and t2.espe_ccod=t3.espe_ccod and t3.carr_ccod='"&q_carr_ccod&"' and t1.emat_ccod=8 order by t2.peri_ccod desc ) as detalle_titulacion,  "& vbCrLf &_ 
		  " (select max(peri_ccod)  "& vbCrLf &_ 
  		  "      from alumnos t1,ofertas_academicas t2, especialidades t3 "& vbCrLf &_ 
     	  "      where t1.pers_ncorr=a.pers_ncorr and t1.ofer_ncorr=t2.ofer_ncorr  "& vbCrLf &_ 
      	  "      and t2.espe_ccod=t3.espe_ccod and t3.carr_ccod='"&q_carr_ccod&"' and isnull(t1.emat_ccod,0) not in (3,5,9,14) ) as ultimo_periodo  "& vbCrLf &_ 
		  " from personas a "& vbCrLf &_
		  " where cast(pers_nrut as varchar)='"&q_pers_nrut&"'"
'----------------------------------------------------------------------------------------------------------------------------------

if ip_usuario = ip_de_prueba then
'response.Write("q_carr_ccod = "&q_carr_ccod&"</br>") 
'response.Write("q_pers_nrut = "&q_pers_nrut&"</br>") 
'response.Write("q_pers_xdv = "&q_pers_xdv&"</br>") 
'response.Write("carr_ccod_consultada = "&carr_ccod_consultada&"</br>") 
'response.Write("v_sede_ccod = "&v_sede_ccod&"</br>") 
'response.Write("SQL = "&SQL&"</br>") 
'response.Write("q_carr_ccod = "&q_carr_ccod&"</br>") 
'response.Write("c_datos = "&c_datos&"</br>") 
end if

'---------- Descripcion de la Carrera ---------------------------------------------------------------------------------------------
carr_tdesc = conexion.consultaUno("select protic.initCap(carr_tdesc) from carreras where carr_ccod='"&q_carr_ccod&"'")
'----------------------------------------------------------------------------------------------------------------------------------

set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "tabla_vacia.xml", "tabla"
f_encabezado.Inicializar conexion

f_encabezado.Consultar c_datos
f_encabezado.siguiente

'---------- Datos del alumno(a) y condicion de egresado y titulado ----------------------------------------------------------------
detalle_titulacion = f_encabezado.obtenerValor("detalle_titulacion")
q_plan_ccod = f_encabezado.obtenerValor("plan_titulacion")
en_carrera = f_encabezado.obtenerValor("en_carrera")
encasillado = f_encabezado.obtenerValor("encasillado")
pers_ncorr = f_encabezado.obtenerValor("pers_ncorr")
titulado = f_encabezado.obtenerValor("titulado")
ultimo_periodo = f_encabezado.obtenerValor("ultimo_periodo")
'----------------------------------------------------------------------------------------------------------------------------------

if ip_usuario = ip_de_prueba then
'response.Write("q_carr_ccod = "&q_carr_ccod&"</br>") 
'response.Write("q_pers_nrut = "&q_pers_nrut&"</br>") 
'response.Write("q_pers_xdv = "&q_pers_xdv&"</br>") 
'response.Write("carr_ccod_consultada = "&carr_ccod_consultada&"</br>") 
'response.Write("v_sede_ccod = "&v_sede_ccod&"</br>") 
'response.Write("SQL = "&SQL&"</br>") 
'response.Write("q_carr_ccod = "&q_carr_ccod&"</br>") 
'response.Write("c_datos = "&c_datos&"</br>")
'response.Write("detalle_titulacion = "&detalle_titulacion&"</br>")  
'response.Write("q_plan_ccod = "&q_plan_ccod&"</br>")  
'response.Write("en_carrera = "&en_carrera&"</br>")  
'response.Write("encasillado = "&encasillado&"</br>")  
'response.Write("pers_ncorr = "&pers_ncorr&"</br>")  
'response.Write("titulado = "&titulado&"</br>")  
'response.Write("ultimo_periodo = "&ultimo_periodo&"</br>")  
end if

'---------- Si no tiene titulo y existe ultimo periodo ----------------------------------------------------------------------------
if titulado = "N" and not EsVacio(ultimo_periodo) then
 '---------- Advierte que el alumno(a) no esta titulo en la carrera seleccionada ----------
 c_detalle_ultima_matricula = " Select top 1 'El alumno no se encuentra titulado en la carrera seleccionada, su última matrícula corresponde a la especialidad: <strong>'+lower(c.espe_tdesc)+' - '+lower(d.plan_tdesc)+'</strong>, con el estado de matrícula '+e.emat_tdesc "&_
                               " from alumnos a, ofertas_academicas b, especialidades c, planes_estudio d, estados_matriculas e "&_
							   " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.plan_ccod=d.plan_ccod and a.emat_ccod=e.emat_ccod "&_
							   " and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and cast(b.peri_ccod as varchar)='"&ultimo_periodo&"' and c.carr_ccod='"&q_carr_ccod&"' and isnull(a.emat_ccod,0) not in (3,5,9,14) "
 detalle_ultima_matricula =  conexion.consultaUno(c_detalle_ultima_matricula)
 
 '---------- Determina plan de la carrera ----------
 c_plan_ccod = " select top 1 a.plan_ccod "&_
               " from alumnos a, ofertas_academicas b, especialidades c, planes_estudio d, estados_matriculas e "&_
			   " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.plan_ccod=d.plan_ccod and a.emat_ccod=e.emat_ccod "&_
			   " and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and cast(b.peri_ccod as varchar)='"&ultimo_periodo&"' and c.carr_ccod='"&q_carr_ccod&"' and isnull(a.emat_ccod,0) not in (3,5,9,14) "
 q_plan_ccod = conexion.consultaUno(c_plan_ccod)
end if
'----------------------------------------------------------------------------------------------------------------------------------

if ip_usuario = ip_de_prueba then
'response.Write("q_carr_ccod = "&q_carr_ccod&"</br>") 
'response.Write("q_pers_nrut = "&q_pers_nrut&"</br>") 
'response.Write("q_pers_xdv = "&q_pers_xdv&"</br>") 
'response.Write("carr_ccod_consultada = "&carr_ccod_consultada&"</br>") 
'response.Write("v_sede_ccod = "&v_sede_ccod&"</br>") 
'response.Write("SQL = "&SQL&"</br>") 
'response.Write("q_carr_ccod = "&q_carr_ccod&"</br>") 
'response.Write("c_datos = "&c_datos&"</br>")
'response.Write("detalle_titulacion = "&detalle_titulacion&"</br>")  
'response.Write("q_plan_ccod = "&q_plan_ccod&"</br>")  
'response.Write("en_carrera = "&en_carrera&"</br>")  
'response.Write("encasillado = "&encasillado&"</br>")  
'response.Write("pers_ncorr = "&pers_ncorr&"</br>")  
'response.Write("titulado = "&titulado&"</br>")  
'response.Write("ultimo_periodo = "&ultimo_periodo&"</br>")  
'response.Write("c_detalle_ultima_matricula = "&c_detalle_ultima_matricula&"</br>")  
'response.Write("detalle_ultima_matricula = "&detalle_ultima_matricula&"</br>")  
'response.Write("c_plan_ccod = "&c_plan_ccod&"</br>")  
'response.Write("q_plan_ccod = "&q_plan_ccod&"</br>")  
end if

'---------- En caso que el alumno presente matrícula en la carrera ----------------------------------------------------------------
if en_carrera ="S" then 
	'---------- Posee titulacion y detalle de matricula ----------
	if detalle_titulacion <> "" and titulado = "S"  then
		mensaje_html = "<center> "&_
					   "     <table border='1'  bordercolor='#339900' cellspacing='2' cellpadding='5' align='center'> "&_
					   "       <tr>"&_
					   "	         <td align='center' bgcolor='#CCFFCC'>"&detalle_titulacion&"</td> "&_
					   "       </tr>"&_
					   "     </table> "&_
					   " </center>"
	'---------- NO posee titulacion pero si detalle de matricula ----------
	else
		mensaje_html = "<center>"&_
					   "    <table border='1'  bordercolor='#CC6600' cellspacing='2' cellpadding='5' align='center'> "&_
					   "      <tr> "&_
					   "         <td align='center' bgcolor='#FFCC66'>"&detalle_ultima_matricula&"</td> "&_
					   "      </tr> "&_
					   "    </table> "&_
					   "</center>"
	end if
'--------- En caso que el alumno no presente matrícula en la carrera ----------
else
		mensaje_html = "<center>"&_
					   "    <table border='1'  bordercolor='#CC6600' cellspacing='2' cellpadding='5' align='center'> "&_
					   "      <tr> "&_
					   "         <td align='center' bgcolor='#FFCC66'>El alumno consultado no presenta matrícula en la carrera.</td> "&_
					   "      </tr> "&_
					   "    </table> "&_
					   "</center>"
end if
'----------------------------------------------------------------------------------------------------------------------------------

'---------- El alumno se encuentra mal encasillado en su matrícula con estado de titulación ---------------------------------------
msj_encasillado=""
if encasillado = "N" and q_plan_ccod <> "" and titulado="S"  then 
	msj_encasillado = "El alumno se encuentra mal encasillado(especialidad o plan de estudios), para su matrícula de titulado"
end if
'----------------------------------------------------------------------------------------------------------------------------------

'----------------------------------------------------------------------------------------------------------------------------------
set f_titulados = new CFormulario
f_titulados.Carga_Parametros "adm_salidas_alumnos.xml", "titulados"
f_titulados.Inicializar conexion
'response.Write("carr_ccod......: "&carr_ccod_consultada)
'----------------------------------------------------------------------------------------------------------------------------------

if ip_usuario = ip_de_prueba then
'response.Write("q_carr_ccod = "&q_carr_ccod&"</br>") 
'response.Write("q_pers_nrut = "&q_pers_nrut&"</br>") 
'response.Write("q_pers_xdv = "&q_pers_xdv&"</br>") 
'response.Write("carr_ccod_consultada = "&carr_ccod_consultada&"</br>") 
'response.Write("v_sede_ccod = "&v_sede_ccod&"</br>") 
'response.Write("SQL = "&SQL&"</br>") 
'response.Write("q_carr_ccod = "&q_carr_ccod&"</br>") 
'response.Write("c_datos = "&c_datos&"</br>")
'response.Write("detalle_titulacion = "&detalle_titulacion&"</br>")  
'response.Write("q_plan_ccod = "&q_plan_ccod&"</br>")  
'response.Write("en_carrera = "&en_carrera&"</br>")  
'response.Write("encasillado = "&encasillado&"</br>")  
'response.Write("pers_ncorr = "&pers_ncorr&"</br>")  
'response.Write("titulado = "&titulado&"</br>")  
'response.Write("ultimo_periodo = "&ultimo_periodo&"</br>")  
'response.Write("c_detalle_ultima_matricula = "&c_detalle_ultima_matricula&"</br>")  
'response.Write("detalle_ultima_matricula = "&detalle_ultima_matricula&"</br>")  
'response.Write("c_plan_ccod = "&c_plan_ccod&"</br>")  
'response.Write("q_plan_ccod = "&q_plan_ccod&"</br>")  
'response.Write("carr_ccod_consultada = "&carr_ccod_consultada&"</br>")  
end if

'---------- Si no existe carrera seleccionada -------------------------------------------------------------------------------------
if carr_ccod_consultada <> "" then
	filtro_carrera = " a.carr_ccod='"&q_carr_ccod&"' and"
	filtro_plan = " and cast(plan_ccod as varchar)='"&q_plan_ccod&"'"
else
	filtro_carrera = " a.carr_ccod in (select distinct carr_ccod from alumnos tt, ofertas_academicas t2, especialidades t3 where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod and cast(tt.pers_ncorr as varchar)='"&pers_ncorr&"' and emat_ccod not in (3,5,9,14) ) and "	
	filtro_plan = " and plan_ccod in (select distinct plan_ccod from alumnos tt, ofertas_academicas t2, especialidades t3 where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod and cast(tt.pers_ncorr as varchar)='"&pers_ncorr&"' and emat_ccod not in (3,5,9,14) ) "	
end if
'----------------------------------------------------------------------------------------------------------------------------------

if ip_usuario = ip_de_prueba then
'response.Write("q_carr_ccod = "&q_carr_ccod&"</br>") 
'response.Write("q_pers_nrut = "&q_pers_nrut&"</br>") 
'response.Write("q_pers_xdv = "&q_pers_xdv&"</br>") 
'response.Write("carr_ccod_consultada = "&carr_ccod_consultada&"</br>") 
'response.Write("v_sede_ccod = "&v_sede_ccod&"</br>") 
'response.Write("SQL = "&SQL&"</br>") 
'response.Write("q_carr_ccod = "&q_carr_ccod&"</br>") 
'response.Write("c_datos = "&c_datos&"</br>")
'response.Write("detalle_titulacion = "&detalle_titulacion&"</br>")  
'response.Write("q_plan_ccod = "&q_plan_ccod&"</br>")  
'response.Write("en_carrera = "&en_carrera&"</br>")  
'response.Write("encasillado = "&encasillado&"</br>")  
'response.Write("pers_ncorr = "&pers_ncorr&"</br>")  
'response.Write("titulado = "&titulado&"</br>")  
'response.Write("ultimo_periodo = "&ultimo_periodo&"</br>")  
'response.Write("c_detalle_ultima_matricula = "&c_detalle_ultima_matricula&"</br>")  
'response.Write("detalle_ultima_matricula = "&detalle_ultima_matricula&"</br>")  
'response.Write("c_plan_ccod = "&c_plan_ccod&"</br>")  
'response.Write("q_plan_ccod = "&q_plan_ccod&"</br>")  
'response.Write("carr_ccod_consultada = "&carr_ccod_consultada&"</br>")  
'response.Write("filtro_carrera = "&filtro_carrera&"</br>")  
'response.Write("filtro_plan = "&filtro_plan&"</br>")  
end if

'---------- Para llenar la grilla: Listado de Salidas ofrecidas por la Carrera ----------------------------------------------------
SQL_1 = "  select carr_ccod,carrera, '"&pers_ncorr&"' as pers_ncorr,tsca_ccod,case a.tsca_ccod when 1 then '<font color=#073299><strong>' "& vbCrLf &_ 
      "            when 2 then '<font color=#004000><strong>' "& vbCrLf &_ 
  	  " 		   when 3 then '<font color=#b76d05><strong>' "& vbCrLf &_ 
	  "			   when 4 then '<font color=#714e9c><strong>' "& vbCrLf &_ 
	  " 		   when 5 then '<font color=#ab2b05><strong>' "& vbCrLf &_ 
	  "  		   when 6 then '<font color=#0078c0><strong>' end + a.tsca_tdesc + '</strong></font>' as tsca_tdesc, "& vbCrLf &_ 
	  " saca_ncorr, saca_tdesc as salida, case tsca_ccod when 5 then mencion else '' end as mencion, "& vbCrLf &_ 
	  " (select count(*) from asignaturas_salidas_carrera tt where tt.saca_ncorr=a.saca_ncorr) as total_asignaturas_requeridas, "& vbCrLf &_ 
	  " (select top 1 ASCA_NFOLIO +'/'+cast(ASCA_NREGISTRO as varchar) from alumnos_salidas_carrera tt where tt.saca_ncorr=a.saca_ncorr and cast(tt.pers_ncorr as varchar)='"&pers_ncorr&"') as folio_reg, "& vbCrLf &_ 
	  " (select top 1 protic.trunc(ASCA_FSALIDA) from alumnos_salidas_carrera tt where tt.saca_ncorr=a.saca_ncorr and cast(tt.pers_ncorr as varchar)='"&pers_ncorr&"') as asca_fsalida, "& vbCrLf &_ 
	  " (select top 1 asca_nnota from alumnos_salidas_carrera tt where tt.saca_ncorr=a.saca_ncorr and cast(tt.pers_ncorr as varchar)='"&pers_ncorr&"') as asca_nnota, "& vbCrLf &_
	  " isnull((select count(*) from detalles_titulacion_carrera tt where tt.carr_ccod=a.carr_ccod and tt.plan_ccod=a.plan_ccod and cast(tt.pers_ncorr as varchar)='"&pers_ncorr&"'),0) as egreso1, "& vbCrLf &_
	  " isnull((select count(*) from detalles_titulacion_carrera tt where tt.carr_ccod=a.carr_ccod and tt.plan_ccod=a.saca_ncorr and cast(tt.pers_ncorr as varchar)='"&pers_ncorr&"'),0) as egreso2 "& vbCrLf &_ 
	  " from "& vbCrLf &_ 
	  " ( "& vbCrLf &_ 
	  " 	select a.carr_ccod,protic.initCap(c.carr_tdesc + isnull((select  ' : '+ espe_tdesc + ' : ' + plan_tdesc from planes_estudio tt, especialidades t2 where tt.plan_ccod=a.plan_ccod and tt.espe_ccod=t2.espe_ccod),'')) as carrera, a.tsca_ccod, tsca_tdesc, saca_ncorr,plan_ccod,isnull(linea_1_certificado + ' ' + linea_2_certificado,saca_tdesc) as saca_tdesc,'' as mencion  "& vbCrLf &_ 
	  " 	from salidas_carrera a, tipos_salidas_carrera b, carreras c "& vbCrLf &_ 
	  " 	where "&filtro_carrera&" a.tsca_ccod in (1,2) "&filtro_plan&" "& vbCrLf &_ 
	  " 	and a.tsca_ccod=b.tsca_ccod and a.carr_ccod=c.carr_ccod "& vbCrLf &_ 
	  " union "& vbCrLf &_ 
	  " 	select a.carr_ccod,protic.initCap(c.carr_tdesc + isnull((select  ' : '+ espe_tdesc + ' : ' + plan_tdesc from planes_estudio tt, especialidades t2 where tt.plan_ccod=a.plan_ccod and tt.espe_ccod=t2.espe_ccod),'')) as carrera, a.tsca_ccod, tsca_tdesc, saca_ncorr,plan_ccod,isnull(linea_1_certificado + ' ' + linea_2_certificado,saca_tdesc) as saca_tdesc, '' as mencion "& vbCrLf &_ 
	  " 	from salidas_carrera a, tipos_salidas_carrera b,carreras c "& vbCrLf &_ 
	  " 	where "&filtro_carrera&" a.tsca_ccod not in (1,2) "& vbCrLf &_ 
	  " 	and a.tsca_ccod=b.tsca_ccod and a.carr_ccod=c.carr_ccod "& vbCrLf &_ 
	  ") as a "& vbCrLf &_ 
	  " order by tsca_ccod asc"

f_titulados.Consultar SQL_1
total_salidas = f_titulados.nroFilas
'----------------------------------------------------------------------------------------------------------------------------------

if ip_usuario = ip_de_prueba then
'response.Write("q_carr_ccod = "&q_carr_ccod&"</br>") 
'response.Write("q_pers_nrut = "&q_pers_nrut&"</br>") 
'response.Write("q_pers_xdv = "&q_pers_xdv&"</br>") 
'response.Write("carr_ccod_consultada = "&carr_ccod_consultada&"</br>") 
'response.Write("v_sede_ccod = "&v_sede_ccod&"</br>") 
'response.Write("SQL = "&SQL&"</br>") 
'response.Write("q_carr_ccod = "&q_carr_ccod&"</br>") 
'response.Write("c_datos = "&c_datos&"</br>")
'response.Write("detalle_titulacion = "&detalle_titulacion&"</br>")  
'response.Write("q_plan_ccod = "&q_plan_ccod&"</br>")  
'response.Write("en_carrera = "&en_carrera&"</br>")  
'response.Write("encasillado = "&encasillado&"</br>")  
'response.Write("pers_ncorr = "&pers_ncorr&"</br>")  
'response.Write("titulado = "&titulado&"</br>")  
'response.Write("ultimo_periodo = "&ultimo_periodo&"</br>")  
'response.Write("c_detalle_ultima_matricula = "&c_detalle_ultima_matricula&"</br>")  
'response.Write("detalle_ultima_matricula = "&detalle_ultima_matricula&"</br>")  
'response.Write("c_plan_ccod = "&c_plan_ccod&"</br>")  
'response.Write("q_plan_ccod = "&q_plan_ccod&"</br>")  
'response.Write("carr_ccod_consultada = "&carr_ccod_consultada&"</br>")  
'response.Write("filtro_carrera = "&filtro_carrera&"</br>")  
'response.Write("filtro_plan = "&filtro_plan&"</br>")  
'response.Write("SQL_1 = "&SQL_1&"</br>") 
end if

'---------- Para Habilitar Botoneras ----------------------------------------------------------------------------------------------
if f_encabezado.NroFilas = 0 then
	f_botonera.AgregaBotonParam "agregar", "deshabilitado", "TRUE"
	f_botonera.AgregaBotonParam "eliminar", "deshabilitado", "TRUE"
else
	f_botonera.AgregaBotonUrlParam "agregar", "dp[0][plan_ccod]", q_plan_ccod
	f_botonera.AgregaBotonUrlParam "agregar", "dp[0][peri_ccod]", q_peri_ccod
end if
'----------------------------------------------------------------------------------------------------------------------------------

'----------------------------------------------------------------------------------------------------------------------------------
'---------- Para determinar: salidas, titulos,egresos -----------------------------------------------------------------------------
tiene_salidas = conexion.consultaUno("select case count(*) when 0 then 'NO' else 'SI' end from alumnos_salidas_carrera a, salidas_carrera b where a.saca_ncorr=b.saca_ncorr and tsca_ccod in (1,3,5,6) and b.carr_ccod='"&q_carr_ccod&"' and cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
tiene_titulo_ajuste = conexion.consultaUno("select case count(*) when 0 then 'NO' else 'SI' end from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr = b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.emat_ccod in (8) and c.carr_ccod='"&q_carr_ccod&"' and a.alum_nmatricula=7777 and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'")
tiene_egreso_ajuste = conexion.consultaUno("select case count(*) when 0 then 'NO' else 'SI' end from alumnos a, ofertas_academicas b, especialidades c where a.ofer_ncorr = b.ofer_ncorr and b.espe_ccod=c.espe_ccod and a.emat_ccod in (4) and c.carr_ccod='"&q_carr_ccod&"' and a.alum_nmatricula=7777 and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'")
'----------------------------------------------------------------------------------------------------------------------------------

if ip_usuario = ip_de_prueba then
'response.Write("q_carr_ccod = "&q_carr_ccod&"</br>") 
'response.Write("q_pers_nrut = "&q_pers_nrut&"</br>") 
'response.Write("q_pers_xdv = "&q_pers_xdv&"</br>") 
'response.Write("carr_ccod_consultada = "&carr_ccod_consultada&"</br>") 
'response.Write("v_sede_ccod = "&v_sede_ccod&"</br>") 
'response.Write("SQL = "&SQL&"</br>") 
'response.Write("q_carr_ccod = "&q_carr_ccod&"</br>") 
'response.Write("c_datos = "&c_datos&"</br>")
'response.Write("detalle_titulacion = "&detalle_titulacion&"</br>")  
'response.Write("q_plan_ccod = "&q_plan_ccod&"</br>")  
'response.Write("en_carrera = "&en_carrera&"</br>")  
'response.Write("encasillado = "&encasillado&"</br>")  
'response.Write("pers_ncorr = "&pers_ncorr&"</br>")  
'response.Write("titulado = "&titulado&"</br>")  
'response.Write("ultimo_periodo = "&ultimo_periodo&"</br>")  
'response.Write("c_detalle_ultima_matricula = "&c_detalle_ultima_matricula&"</br>")  
'response.Write("detalle_ultima_matricula = "&detalle_ultima_matricula&"</br>")  
'response.Write("c_plan_ccod = "&c_plan_ccod&"</br>")  
'response.Write("q_plan_ccod = "&q_plan_ccod&"</br>")  
'response.Write("carr_ccod_consultada = "&carr_ccod_consultada&"</br>")  
'response.Write("filtro_carrera = "&filtro_carrera&"</br>")  
'response.Write("filtro_plan = "&filtro_plan&"</br>")  
'response.Write("SQL_1 = "&SQL_1&"</br>") 
'response.Write("tiene_salidas = "&tiene_salidas&"</br>") 
'response.Write("tiene_titulo_ajuste = "&tiene_titulo_ajuste&"</br>") 
'response.Write("tiene_egreso_ajuste = "&tiene_egreso_ajuste&"</br>") 
end if

'---------- Para saber si tine foto y nombre de foto ------------------------------------------------------------------------------
tiene_foto  = conexion.consultaUno("Select case count(*) when 0 then 'N' else 'S' end from rut_fotos_2010 where cast(rut as varchar)='"&q_pers_nrut&"'")
tiene_foto2 = conexion.consultaUno("Select case count(*) when 0 then 'N' else 'S' end from fotos_alumnos where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
if tiene_foto="S" then 
 	nombre_foto = conexion.consultaUno("Select ltrim(rtrim(imagen)) from rut_fotos_2010 where cast(rut as varchar)='"&q_pers_nrut&"'")
elseif tiene_foto="N" and tiene_foto2="S" then 
  	nombre_foto = conexion.consultaUno("Select ltrim(rtrim(foto_truta)) from fotos_alumnos where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")	
else
    nombre_foto = "user.png"
end if
'----------------------------------------------------------------------------------------------------------------------------------

if ip_usuario = ip_de_prueba then
'response.Write("q_carr_ccod = "&q_carr_ccod&"</br>") 
'response.Write("q_pers_nrut = "&q_pers_nrut&"</br>") 
'response.Write("q_pers_xdv = "&q_pers_xdv&"</br>") 
'response.Write("carr_ccod_consultada = "&carr_ccod_consultada&"</br>") 
'response.Write("v_sede_ccod = "&v_sede_ccod&"</br>") 
'response.Write("SQL = "&SQL&"</br>") 
'response.Write("q_carr_ccod = "&q_carr_ccod&"</br>") 
'response.Write("c_datos = "&c_datos&"</br>")
'response.Write("detalle_titulacion = "&detalle_titulacion&"</br>")  
'response.Write("q_plan_ccod = "&q_plan_ccod&"</br>")  
'response.Write("en_carrera = "&en_carrera&"</br>")  
'response.Write("encasillado = "&encasillado&"</br>")  
'response.Write("pers_ncorr = "&pers_ncorr&"</br>")  
'response.Write("titulado = "&titulado&"</br>")  
'response.Write("ultimo_periodo = "&ultimo_periodo&"</br>")  
'response.Write("c_detalle_ultima_matricula = "&c_detalle_ultima_matricula&"</br>")  
'response.Write("detalle_ultima_matricula = "&detalle_ultima_matricula&"</br>")  
'response.Write("c_plan_ccod = "&c_plan_ccod&"</br>")  
'response.Write("q_plan_ccod = "&q_plan_ccod&"</br>")  
'response.Write("carr_ccod_consultada = "&carr_ccod_consultada&"</br>")  
'response.Write("filtro_carrera = "&filtro_carrera&"</br>")  
'response.Write("filtro_plan = "&filtro_plan&"</br>")  
'response.Write("SQL_1 = "&SQL_1&"</br>") 
'response.Write("tiene_salidas = "&tiene_salidas&"</br>") 
'response.Write("tiene_titulo_ajuste = "&tiene_titulo_ajuste&"</br>") 
'response.Write("tiene_egreso_ajuste = "&tiene_egreso_ajuste&"</br>") 
'response.Write("tiene_foto = "&tiene_foto&"</br>") 
'response.Write("tiene_foto2 = "&tiene_foto2&"</br>") 
'response.Write("nombre_foto = "&nombre_foto&"</br>") 
'response.Write("pers_ncorr = "&pers_ncorr&"</br>") 
end if

'---------- Vemos bloqueos por persona --------------------------------------------------------------------------------------------
if pers_ncorr <> "" then
	set f_requerimientos = new CFormulario
	f_requerimientos.Carga_Parametros "tabla_vacia.xml", "tabla"
	f_requerimientos.Inicializar conexion
	
	'----- consultamos por los requerimientos de titulacion -----
	SQL_2 = " select isnull(ACADEMICA,'N') as ACADEMICA,isnull(FINANCIERA,'N') as FINANCIERA,isnull(BIBLIOTECA,'N') as BIBLIOTECA,isnull(AUDIOVISUAL,'N') as AUDIOVISUAL,"& vbCrLf & _
	      " isnull(LICENCIA_EM,'N') as LICENCIA_EM ,isnull(CONCENTRACION_EM,'N') as CONCENTRACION_EM,isnull(PAA_PSU,'N') as PAA_PSU,isnull(CEDULA_DI,'N') as CEDULA_DI,"& vbCrLf & _
		  " isnull(CERTIFICADO_TG,'N')as CERTIFICADO_TG,isnull(CONCENTRACION_NU,'N') as CONCENTRACION_NU,isnull(CURRICULUM_VITAE,'N') as CURRICULUM_VITAE,  " & vbCrLf & _
		  " isnull(MALLA_CURRICULAR,'N') as MALLA_CURRICULAR,isnull(CEDULA_DI,'N') as CEDULA_DI2  " & vbCrLf & _
		  " from requerimientos_titulacion " & vbCrLf & _
		  " where cast(pers_ncorr as varchar)= '"&pers_ncorr&"' "
	
	f_requerimientos.Consultar SQL_2
	f_requerimientos.Siguiente
	
	bloqueo_para_titulos = ""
	bloqueo_para_grados = ""
	
	'Bloqueo academico
	if f_requerimientos.obtenerValor("ACADEMICA") = "N" then
		bloqueo_para_titulos = "- ACADEMICA."
		bloqueo_para_grados = "- ACADEMICA."
	end if
	'Bloqueo financiero
    if f_requerimientos.obtenerValor("FINANCIERA") = "N" then
		bloqueo_para_titulos = bloqueo_para_titulos & "\n- FINANCIERA."
		bloqueo_para_grados = bloqueo_para_grados & "\n- FINANCIERA."
	end if
	'Bloqueo biblioteca
	if f_requerimientos.obtenerValor("BIBLIOTECA") = "N" then
		bloqueo_para_titulos = bloqueo_para_titulos & "\n- BIBLIOTECA."
		bloqueo_para_grados = bloqueo_para_grados & "\n- BIBLIOTECA."
	end if
	'Bloqueo audiovisual
	if f_requerimientos.obtenerValor("AUDIOVISUAL") = "N" then
		bloqueo_para_titulos = bloqueo_para_titulos & "\n- AUDIOVISUAL."
		bloqueo_para_grados = bloqueo_para_grados & "\n- AUDIOVISUAL."
	end if
	'Bloqueo licencia EM
	if f_requerimientos.obtenerValor("LICENCIA_EM") = "N" then
		bloqueo_para_titulos = bloqueo_para_titulos & "\n- LICENCIA ENSEÑANZA MEDIA."
	end if
	'Bloqueos concentracion EM
	if f_requerimientos.obtenerValor("CONCENTRACION_EM") = "N" then
		bloqueo_para_titulos = bloqueo_para_titulos & "\n- NOTAS ENSEÑANZA MEDIA."
	end if	
	'Bloqueo PAA u PSU
	if f_requerimientos.obtenerValor("PAA_PSU") = "N" then
		bloqueo_para_titulos = bloqueo_para_titulos & "\n- RESULTADOS PAA/PSU."
	end if	
	'Bloqueo cedula de identidad
    if f_requerimientos.obtenerValor("CEDULA_DI") = "N" then
		bloqueo_para_titulos = bloqueo_para_titulos & "\n- CÉDULA DE IDENTIDAD."
		bloqueo_para_grados = bloqueo_para_grados & "\n- CÉDULA DE IDENTIDAD."
	end if
	'Bloqueo certificado de titulo y grado
	if f_requerimientos.obtenerValor("CERTIFICADO_TG") = "N" then
		bloqueo_para_grados = bloqueo_para_grados & "\n- CERTIFICADO TITULO O GRADO."
	end if
	'Bloqueo concentracion de notas universidad
	if f_requerimientos.obtenerValor("CONCENTRACION_NU") = "N" then
		bloqueo_para_grados = bloqueo_para_grados & "\n- CONCENTRACION NOTAS UNIVERSIDAD."
	end if
	'Bloqueo curriculum vitae
	if f_requerimientos.obtenerValor("CURRICULUM_VITAE") = "N" then
		bloqueo_para_grados = bloqueo_para_grados & "\n- CURRICULUM VITAE."
	end if
	
	'Resumen Bloqueo para Titulo
	if bloqueo_para_titulos <> "" then
		bloqueo_para_titulos = "SE ENCONTRARON LOS SIGUIENTES BLOQUEOS:\n"&bloqueo_para_titulos
	end if
	
	'Resumen Bloqueo para Grado Academico
	if bloqueo_para_grados <> "" then
		bloqueo_para_grados = "SE ENCONTRARON LOS SIGUIENTES BLOQUEOS:\n"&bloqueo_para_grados
	end if
	
	if ip_usuario = ip_de_prueba then
	'response.Write("bloqueo_para_titulos = "&bloqueo_para_titulos&"</br>") 
	'response.Write("bloqueo_para_grados = "&bloqueo_para_grados&"</br>") 
	end if

	v_mes_actual = Month(now())
	
	if v_mes_actual <= 3 then
	  ano_consulta = conexion.consultaUno("select datepart(year,getDate()) - 1 ")
	else
	  ano_consulta = conexion.consultaUno("select datepart(year,getDate())")
	end if
	
	es_cae = conexion.consultaUno("select case count(*) when 0 then 'NO' else 'SI' end  from ufe_alumnos_cae ttt where cast(ttt.anos_ccod as varchar)='"&ano_consulta&"' and esca_ccod=1 and cast(ttt.rut as varchar)= '"&q_pers_nrut&"'")

	if ip_usuario = ip_de_prueba then
	'response.Write("bloqueo_para_titulos = "&bloqueo_para_titulos&"</br>") 
	'response.Write("bloqueo_para_grados = "&bloqueo_para_grados&"</br>") 
	'response.Write("v_mes_actual = "&v_mes_actual&"</br>") 
	'response.Write("es_cae = "&es_cae&"</br>") 
	end if
	
end if
'----------------------------------------------------------------------------------------------------------------------------------

if ip_usuario = ip_de_prueba then
'response.Write("q_carr_ccod = "&q_carr_ccod&"</br>") 
'response.Write("q_pers_nrut = "&q_pers_nrut&"</br>") 
'response.Write("q_pers_xdv = "&q_pers_xdv&"</br>") 
'response.Write("carr_ccod_consultada = "&carr_ccod_consultada&"</br>") 
'response.Write("v_sede_ccod = "&v_sede_ccod&"</br>") 
'response.Write("SQL = "&SQL&"</br>") 
'response.Write("q_carr_ccod = "&q_carr_ccod&"</br>") 
'response.Write("c_datos = "&c_datos&"</br>")
'response.Write("detalle_titulacion = "&detalle_titulacion&"</br>")  
'response.Write("q_plan_ccod = "&q_plan_ccod&"</br>")  
'response.Write("en_carrera = "&en_carrera&"</br>")  
'response.Write("encasillado = "&encasillado&"</br>")  
'response.Write("pers_ncorr = "&pers_ncorr&"</br>")  
'response.Write("titulado = "&titulado&"</br>")  
'response.Write("ultimo_periodo = "&ultimo_periodo&"</br>")  
'response.Write("c_detalle_ultima_matricula = "&c_detalle_ultima_matricula&"</br>")  
'response.Write("detalle_ultima_matricula = "&detalle_ultima_matricula&"</br>")  
'response.Write("c_plan_ccod = "&c_plan_ccod&"</br>")  
'response.Write("q_plan_ccod = "&q_plan_ccod&"</br>")  
'response.Write("carr_ccod_consultada = "&carr_ccod_consultada&"</br>")  
'response.Write("filtro_carrera = "&filtro_carrera&"</br>")  
'response.Write("filtro_plan = "&filtro_plan&"</br>")  
'response.Write("SQL_1 = "&SQL_1&"</br>") 
'response.Write("tiene_salidas = "&tiene_salidas&"</br>") 
'response.Write("tiene_titulo_ajuste = "&tiene_titulo_ajuste&"</br>") 
'response.Write("tiene_egreso_ajuste = "&tiene_egreso_ajuste&"</br>") 
'response.Write("tiene_foto = "&tiene_foto&"</br>") 
'response.Write("tiene_foto2 = "&tiene_foto2&"</br>") 
'response.Write("nombre_foto = "&nombre_foto&"</br>") 
'response.Write("SQL_2 = "&SQL_2&"</br>") 
'response.Write("bloqueo_para_titulos = "&bloqueo_para_titulos&"</br>") 
'response.Write("bloqueo_para_grados = "&bloqueo_para_grados&"</br>") 
'response.Write("v_mes_actual = "&v_mes_actual&"</br>") 
'response.Write("es_cae = "&es_cae&"</br>") 
end if

'---------- Vemos si es moroso ----------------------------------------------------------------------------------------------------
if not esvacio(pers_ncorr) then
    es_moroso = conexion.consultaUno("select protic.es_moroso('"&pers_ncorr&"', getDate())")
	if es_moroso="N" then
		moroso = "No"
	else
		moroso = "Sí"		
    end if
	tiene_arancel_titulacion = conexion.consultaUno("select count(*) from compromisos where tcom_ccod = 4 and cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
	'response.Write(tiene_arancel_titulacion)
    if tiene_arancel_titulacion <> "0" then
		monto_compromiso = conexion.consultaUno("select isnull((select sum(comp_mdocumento) from compromisos where tcom_ccod = 4 and cast(pers_ncorr as varchar)='"&pers_ncorr&"'),0)")
		c_cuota = " select isnull((select sum(protic.total_recepcionar_cuota(4,1,b.comp_ndocto,b.dcom_ncompromiso)) as cuota "&_
				  " from compromisos a, detalle_compromisos b "&_
				  " where a.tcom_ccod=4  and a.ecom_ccod <> 3 and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'"&_
				  " and a.tcom_ccod=b.tcom_ccod "&_
				  " and a.comp_ndocto=b.comp_ndocto),0)"
	    couta = conexion.consultaUno(c_cuota)
		if couta <> "0" then
			mensaje_titulacion = "ADEUDA ARANCEL DE TITULO ($"& FormatNumber((cdbl(couta)),0)&")"
		else
			mensaje_titulacion = "ARANCEL DE TITULO CANCELADO"
		end if	
	else
	        mensaje_titulacion = "ADEUDA ARANCEL DE TITULO"
    end if
end if
'----------------------------------------------------------------------------------------------------------------------------------

if ip_usuario = ip_de_prueba then
'response.Write("q_carr_ccod = "&q_carr_ccod&"</br>") 
'response.Write("q_pers_nrut = "&q_pers_nrut&"</br>") 
'response.Write("q_pers_xdv = "&q_pers_xdv&"</br>") 
'response.Write("carr_ccod_consultada = "&carr_ccod_consultada&"</br>") 
'response.Write("v_sede_ccod = "&v_sede_ccod&"</br>") 
'response.Write("SQL = "&SQL&"</br>") 
'response.Write("q_carr_ccod = "&q_carr_ccod&"</br>") 
'response.Write("c_datos = "&c_datos&"</br>")
'response.Write("detalle_titulacion = "&detalle_titulacion&"</br>")  
'response.Write("q_plan_ccod = "&q_plan_ccod&"</br>")  
'response.Write("en_carrera = "&en_carrera&"</br>")  
'response.Write("encasillado = "&encasillado&"</br>")  
'response.Write("pers_ncorr = "&pers_ncorr&"</br>")  
'response.Write("titulado = "&titulado&"</br>")  
'response.Write("ultimo_periodo = "&ultimo_periodo&"</br>")  
'response.Write("c_detalle_ultima_matricula = "&c_detalle_ultima_matricula&"</br>")  
'response.Write("detalle_ultima_matricula = "&detalle_ultima_matricula&"</br>")  
'response.Write("c_plan_ccod = "&c_plan_ccod&"</br>")  
'response.Write("q_plan_ccod = "&q_plan_ccod&"</br>")  
'response.Write("carr_ccod_consultada = "&carr_ccod_consultada&"</br>")  
'response.Write("filtro_carrera = "&filtro_carrera&"</br>")  
'response.Write("filtro_plan = "&filtro_plan&"</br>")  
'response.Write("SQL_1 = "&SQL_1&"</br>") 
'response.Write("tiene_salidas = "&tiene_salidas&"</br>") 
'response.Write("tiene_titulo_ajuste = "&tiene_titulo_ajuste&"</br>") 
'response.Write("tiene_egreso_ajuste = "&tiene_egreso_ajuste&"</br>") 
'response.Write("tiene_foto = "&tiene_foto&"</br>") 
'response.Write("tiene_foto2 = "&tiene_foto2&"</br>") 
'response.Write("nombre_foto = "&nombre_foto&"</br>") 
'response.Write("SQL_2 = "&SQL_2&"</br>") 
'response.Write("bloqueo_para_titulos = "&bloqueo_para_titulos&"</br>") 
'response.Write("bloqueo_para_grados = "&bloqueo_para_grados&"</br>") 
'response.Write("v_mes_actual = "&v_mes_actual&"</br>") 
'response.Write("es_cae = "&es_cae&"</br>") 
'response.Write("pers_ncorr = "&pers_ncorr&"</br>") 
'response.Write("es_moroso = "&es_moroso&"</br>") 
'response.Write("moroso = "&moroso&"</br>") 
'response.Write("c_cuota = "&c_cuota&"</br>") 
'response.Write("couta = "&couta&"</br>") 
'response.Write("mensaje_titulacion = "&mensaje_titulacion&"</br>") 
end if


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
var par=false;
colores = Array(3);   colores[0] = ''; colores[1] = '#FFECC6'; colores[2] = '#FFECC6';
function parpadeo() 
{
	document.getElementById('txt').style.visibility= (par) ? 'visible' : 'hidden';
	par = !par;
}
function guardar_imprimir(carrera,tipo_interno)
{
	var tipo = 0;
	if (tipo_interno=="1")
	{
		tipo="3";
	}
	else if (tipo_interno=="2")
	{
		tipo="5";
	}
	else if (tipo_interno=="3")
	{
		tipo="4";
	}
	else if (tipo_interno=="4")
	{
		tipo="6";
	}
	else if (tipo_interno=="5")
	{
		tipo="7";
	}
	else if (tipo_interno=="6")
	{
		tipo="8";
	}
	
	respuesta = confirm("¿Está seguro que desea guardar la solicitud del certificado?"); 
	var rut = '<%=q_pers_nrut%>';
	if (respuesta)
	{
        irA('guarda_certificado.asp?carr_ccod='+carrera+'&tipo='+tipo+'&pers_nrut='+rut, '1', 50, 50); 
	}
}
function eliminar(saca,pers) 
{
	respuesta = confirm("¿Está seguro que desea eliminar la salida del alumno?, esto puede afectar la estadística de titulados"); 
	if (respuesta)
	{
        irA('adm_salidas_alumnos_eliminar.asp?saca_ncorr='+saca+'&pers_ncorr='+pers, '1', 50, 50); 
	}
}
function Validar()
{
	formulario = document.buscador;
	
	rut_alumno = formulario.elements["b[0][pers_nrut]"].value + "-" + formulario.elements["b[0][pers_xdv]"].value;	
	if (formulario.elements["b[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["b[0][pers_xdv]"].focus();
		formulario.elements["b[0][pers_xdv]"].select();
		return false;
	  }
	
	
	return true;
}

function genera_digito (rut){
 var IgStringVerificador, IgN, IgSuma, IgDigito, IgDigitoVerificador, rut;
 var texto_rut = new String(rut);
 var posicion_guion = 0;
 
 posicion_guion = texto_rut.indexOf("-");
 if (posicion_guion != -1)
 {
    texto_rut = texto_rut.substring(0,posicion_guion);
    document.buscador.elements["b[0][pers_nrut]"].value= texto_rut;
	rut = texto_rut;
 }
// texto_rut.
 //alert(texto_rut);
   if (rut.length==7) rut = '0' + rut; 

   IgStringVerificador = '32765432';
   IgSuma = 0;
   for( IgN = 0; IgN < 8 && IgN < rut.length; IgN++)
      IgSuma = eval(IgSuma + '+' + rut.substr(IgN, 1) + '*' + IgStringVerificador.substr(IgN, 1) + ';');
   IgDigito = 11 - IgSuma % 11;
   IgDigitoVerificador = IgDigito==10?'K':IgDigito==11?'0':IgDigito;
   //alert(IgDigitoVerificador);
buscador.elements["b[0][pers_xdv]"].value=IgDigitoVerificador;
//alert(rut+IgDigitoVerificador);
_Buscar(this, document.forms['buscador'],'', 'Validar();', 'FALSE');
}
</script>

<%f_busqueda.GeneraJS%>

<style type="text/css">
.blink {text-decoration: blink;}
</style>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');setInterval('parpadeo()',500);" onBlur="revisaVentana(); ">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  	<tr>
    	<td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  	</tr>
  	<%pagina.DibujarEncabezado()%>  
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
        		<td width="9" background="../imagenes/izq.gif"></td>
        		<td>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
					  </tr>
					  <tr>
						<td height="2" background="../imagenes/top_r3_c2.gif"></td>
					  </tr>
					  <tr>
            			<td>
							<form name="buscador">
              				<br>
              					<table width="98%"  border="0" align="center">
               					 <tr>
                  					<td width="81%">
									<div align="center">
                   						<table width="98%"  border="0">
										  <tr>
											<td width="14%"><strong>Carrera</strong></td>
											<td width="2%"><strong>:</strong></td>
											<td colspan="4" width="84%"><%f_busqueda.DibujaCampoLista "busqueda", "carr_ccod"%></td>
										  </tr>
										  <tr>
											<td width="14%"><strong>Rut Alumno</strong></td>
											<td width="2%"><strong>:</strong></td>
											<td colspan="3" width="54%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
															<%f_busqueda.DibujaCampo("pers_nrut") %>
															- 
															<%f_busqueda.DibujaCampo("pers_xdv")%>
															</font><a href="javascript:buscar_persona('b[0][pers_nrut]', 'b[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
											<td width="30%"><%f_botonera.DibujaBoton "buscar"%></td>
										  </tr>
                      					</table>
									</div>
									</td>
                                </tr>
                               </table>
                            </form>
					 </td>
                 </tr>
               </table>
			 </td>
             <td width="7" background="../imagenes/der.gif"></td>
          </tr>
		  <tr>
			<td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
			<td height="13" background="../imagenes/base2.gif"></td>
			<td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
		  </tr>
    </table>
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
				<td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
			  </tr>
			  <tr>
				<td height="2" background="../imagenes/top_r3_c2.gif"></td>
			  </tr>
          	  <tr>
                <td align="center">
				 <br>
                 <%pagina.DibujarTituloPagina%><br>
                 <br>
			     <table width="98%"  border="0">
                 <tr>
                  <td width="100%" align="left">
				   <%if q_pers_nrut <> "" then%>
				   <table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="80%" align="left">
							<table width="98%" cellpadding="0" cellspacing="0">
								<tr>
									<td width="10%" align="left"><strong>RUT</strong></td>
									<td width="1%" align="center"><strong>:</strong></td>
									<td align="left"><%=f_encabezado.obtenerValor("rut")%></td>
								</tr>
								<tr>
									<td width="10%" align="left"><strong>Alumno</strong></td>
									<td width="1%" align="center"><strong>:</strong></td>
									<td align="left"><%=f_encabezado.obtenerValor("alumno")%></td>
								</tr>
								<tr>
									<td width="10%" align="left"><strong>Moroso</strong></td>
									<td width="1%" align="center"><strong>:</strong></td>
									<td align="left"><%=moroso%></td>
								</tr>
                                <tr>
									<td width="10%" align="left"><strong>Deuda</strong></td>
									<td width="1%" align="center"><strong>:</strong></td>
									<td align="left"><%=mensaje_titulacion%></td>
								</tr>
								<tr><td colspan="3" align="center"><span id="txt"><font color="#993300"><%=msj_encasillado%></font></span></td></tr>
								<tr><td colspan="3">&nbsp;</td></tr>
								<tr><td colspan="3" align="center"><%=mensaje_html%></td></tr>
								<%if es_cae="SI" then%>
								<tr><td colspan="3">&nbsp;</td></tr>
								<tr><td colspan="3" align="center" bgcolor="#FF9900"><font face="Times New Roman, Times, serif" size="+2" color="#0033CC">ALUMNO(A) BENEFICIO CAE <%=ano_consulta%></font></td></tr>
								<%end if%>
								
							</table>
						  </td>
						  <td width="20%" align="center">
							  <img width="90" height="98" src="../informacion_alumno_2008b/imagenes/alumnos/<%=nombre_foto%>" border="2">
						  </td>
					</tr>
				  </table>
				  <%end if%>
                  </td>
                </tr>
              </table>
			 
              <form name="edicion" method="get">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
				 <%if en_carrera ="S" then %>
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Listado de Salidas ofrecidas por la carrera"%>
                      <table width="98%"  border="0" align="center">
                        <tr>
                          <td scope="col"><div align="right">P&aacute;ginas : <%f_titulados.AccesoPagina%></div></td>
                        </tr>
                        <tr>
                          <td align="center">
                          		<table class="v1" width="98%" border="1" bordercolor="#999999" bgcolor="#adadad" cellspacing="0" cellpadding="0">
                                	<tr borderColor="#999999" bgColor="#c4d7ff">
                                        <TH><FONT color="#333333">carrera</FONT></TH>	
										<TH><FONT color="#333333">Tipo</FONT></TH>
                                        <TH><FONT color="#333333">Título</FONT></TH>
                                        <TH><FONT color="#333333">Folio Nº/Reg.Nº</FONT></TH>
                                        <TH><FONT color="#333333">Fecha</FONT></TH>
                                        <TH><FONT color="#333333">Nota</FONT></TH>
                                        <TH><FONT color="#333333">Acción</FONT></TH>
                                    </tr>
                                    <%if total_salidas > 0 then
									    f_titulados.primero
										while f_titulados.siguiente 
										carrera = f_titulados.obtenerValor("carrera")
										tipo = f_titulados.obtenerValor("tsca_tdesc")
										salida = f_titulados.obtenerValor("salida")
										mencion = f_titulados.obtenerValor("mencion")
										folio = f_titulados.obtenerValor("folio_reg")
										fecha_salida = f_titulados.obtenerValor("asca_fsalida")
										nota = f_titulados.obtenerValor("asca_nnota")
										pers_ncorr = f_titulados.obtenerValor("pers_ncorr")
										saca_ncorr = f_titulados.obtenerValor("saca_ncorr")
										asig = f_titulados.obtenerValor("total_asignaturas_requeridas")
										tsca_ccod = f_titulados.obtenerValor("tsca_ccod")
										cod_carrera = f_titulados.obtenerValor("carr_ccod")
										egreso1 = f_titulados.obtenerValor("egreso1")
										egreso2 = f_titulados.obtenerValor("egreso2")
										es_licencitura = conexion.consultaUno("select case when '"&salida&"' like '%licen%' then 1 else 0 end as lic")
										%>
                                        <tr bgColor="#ffffff">
                                            <td onMouseOver="resaltar(this);" onMouseOut="desResaltar(this);"><%=carrera%></td>
											<td onMouseOver="resaltar(this);" onMouseOut="desResaltar(this);"><%=tipo%></td>
											<%if (egreso1 <> "0" or egreso2 <> "0") and 1=2 then%>
                                            	<td onMouseOver="resaltar(this);" onMouseOut="desResaltar(this);"><strong><%=salida%></strong></td>
											<%else%>
												<td onMouseOver="resaltar(this);" onMouseOut="desResaltar(this);"><%=salida%></td>
											<%end if%>
                                            <td onMouseOver="resaltar(this);" onMouseOut="desResaltar(this);"><%=folio%></td>
                                            <td onMouseOver="resaltar(this);" onMouseOut="desResaltar(this);"><%=fecha_salida%></td>
                                            <td onMouseOver="resaltar(this);" onMouseOut="desResaltar(this);" align="center"><%=nota%></td>
                                            <td onMouseOver="resaltar(this);" onMouseOut="desResaltar(this);">
                                            	<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#FFFFFF">
                                                	<tr>
                                                    	<td width="20%" align="center">
                                                           <a href="javascript:irA('adm_salidas_alumnos_agregar.asp?saca_ncorr=<%=saca_ncorr%>&pers_ncorr=<%=pers_ncorr%>', '1', 750, 400);" title="Agregar/Editar salida a alumno">
                                                           	<img width="16" height="16" src="../imagenes/editar.png" border="0">
                                                           </a>
                                                        </td>
                                                        <td width="20%" align="center">
                                                           <%if folio <> "" then%>
                                                           		<a href="javascript:eliminar(<%=saca_ncorr%>,<%=pers_ncorr%>);" title="Eliminar salida del alumno">
                                                                	<img width="16" height="16" src="../imagenes/eliminar.png" border="0">
                                                                </a>
                                                           <%end if%>
                                                        </td>
                                                        <td width="20%" align="center">
                                                          <%if asig > "0" then%>
                                                           <a href="javascript:irA('cumplimiento_asignaturas_salida_carrera.asp?saca_ncorr=<%=saca_ncorr%>&pers_ncorr=<%=pers_ncorr%>', '1', 750, 400);" title="Ver cumplimiento de requisitos de asignaturas">
                                                           	<img width="16" height="16" src="../imagenes/asignaturas.png" border="0">
														   </a>
                                                          <%end if%>
                                                        </td>
                                                        <td width="20%" align="center">
                                                           <%if folio <> "" and moroso <> "Sí" then
														        if tsca_ccod = "1" or tsca_ccod="2" or tsca_ccod="4" or tsca_ccod="5" or tsca_ccod="6" then 
																	if bloqueo_para_titulos = "" then
																	c_licenciatura = " select count(*) "&_
																	                 " from salidas_carrera "&_
																					 " where cast(saca_ncorr as varchar) ='"&saca_ncorr&"' "&_
																					 " and saca_tdesc like '%LICENCIA%'"
																	'response.write c_licenciatura
																	es_licenciatura = conexion.consultaUno(c_licenciatura)
																	
																	%>
																		<%if es_licenciatura = "0" then %>
																			<a href="javascript:irA('prueba.asp?saca_ncorr=<%=saca_ncorr%>&pers_ncorr=<%=pers_ncorr%>&tsca_ccod=<%=tsca_ccod%>', '1', 750, 550);" title="Imprimir certificado de salida">
																			  <img width="16" height="16" src="../imagenes/imprimir.png" border="0">
																			</a>
																		<%else%>
																		    <a href="javascript:irA('certificado_grado.asp?saca_ncorr=<%=saca_ncorr%>&pers_ncorr=<%=pers_ncorr%>&tsca_ccod=<%=tsca_ccod%>', '1', 750, 550);" title="Imprimir certificado de salida Intermedia">
																			  <img width="16" height="16" src="../imagenes/imprimir.png" border="0">
																			</a>
																		<%end if%>
																	<%else%>
																		<a href="javascript:alert('<%=bloqueo_para_titulos%>');" title="Imprimir certificado de salida">
																		  <img width="16" height="16" src="../imagenes/imprimir.png" border="0">
																		</a>
	                                                                <%end if%>
																<%else
																   if bloqueo_para_grados = "" or es_licencitura="1" then%>
																		<a href="javascript:irA('certificado_grado.asp?saca_ncorr=<%=saca_ncorr%>&pers_ncorr=<%=pers_ncorr%>&tsca_ccod=<%=tsca_ccod%>', '1', 750, 550);" title="Imprimir certificado de salida">
																		  <img width="16" height="16" src="../imagenes/imprimir.png" border="0">
																		</a>
																  <%else%>
																        <a href="javascript:alert('<%=bloqueo_para_grados%>');" title="Imprimir certificado de salida">
																		  <img width="16" height="16" src="../imagenes/imprimir.png" border="0">
																		</a> 
																<%  end if
																end if%>
                                                           <%end if%>     
                                                        </td>
														<td width="20%" align="center">
                                                           <%if folio <> "" and moroso <> "Sí" then%>
														        <a href="javascript:guardar_imprimir(<%=cod_carrera%>,<%=tsca_ccod%>);" title="Guardar solicitud certificado">
                                                                	<img width="16" height="16" src="../imagenes/guardar.png" border="0">
                                                                </a>
															<%end if%>     
                                                        </td>
                                                </table>
                                            </td>
                                        </tr>
                                    <%  wend
									 else%>
                                    <tr bgColor="#ffffff">
                                    	<td colspan="6" align="center">No existen salidas asociadas a la carrera y alumno indicado</td>
                                    </tr>
                                    <%end if%>
                                 </table>
                          </td>
                        </tr>
                        <tr>
                          <td align="right"><font color="#0033FF">Para asignar el alumno a la salida, haga clic sobre ella</font></td>
                        </tr>
                      </table></td>
                  </tr>
				  <input type="hidden" name="pers_ncorr" value="<%=pers_ncorr%>">
				  <input type="hidden" name="carr_ccod" value="<%=q_carr_ccod%>">
				  <%end if%>
                </table>
            </form>
			</td>
		 </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
	  <%if tiene_titulo_ajuste ="NO" or tiene_salidas = "SI" or tiene_egreso_ajuste ="NO" then %>
	  <tr valign="bottom">
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td height="28" align="center"><font color="#CC6600">Debe eliminar todas las salidas profesionales antes de eliminar las matrículas</font></td>
	    <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
	  <%end if%>
	  <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera_g.DibujaBoton "salir"%></div></td>
				  <td><div align="center"><% if tiene_titulo_ajuste ="NO" or tiene_salidas = "SI" then
				                                f_botonera.agregaBotonParam "eliminar_matr_titulado","deshabilitado","true"
											 end if      
				                             f_botonera.DibujaBoton "eliminar_matr_titulado"%>
					  </div>
				  </td>
				  <td><div align="center"><% if tiene_egreso_ajuste ="NO" or tiene_salidas="SI" then
				                                f_botonera.agregaBotonParam "eliminar_matr_egresado","deshabilitado","true"
											 end if      
				                             f_botonera.DibujaBoton "eliminar_matr_egresado"%>
					  </div>
				  </td>
				  <td><div align="center"><% if esVacio(q_pers_nrut) then
				                                f_botonera.agregaBotonParam "certificados_emitidos","deshabilitado","true"
											 else
											    url="certificados_emitidos.asp?pers_nrut="&q_pers_nrut&"&pers_xdv="&q_pers_xdv
												f_botonera.AgregaBotonParam "certificados_emitidos","url",url	
											 end if      
				                             f_botonera.DibujaBoton "certificados_emitidos"%>
					  </div>
				  </td>
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
