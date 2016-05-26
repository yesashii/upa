<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION			        :
'FECHA CREACIÓN			      :
'CREADO POR				        :
'ENTRADA				          : NA
'SALIDA				            : NA
'MODULO QUE ES UTILIZADO	: PLANIFICACION ACADEMICA 
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION		: 28/03/2013
'ACTUALIZADO POR			  : Luis Herrera G.
'MOTIVO				          : Corregir código, eliminar sentencia *=
'LINEA				          : 287, 424
'********************************************************************
set pagina = new cPagina
set botonera = new CFormulario
set conexion = new cConexion
set negocio = new cNegocio
set formu_resul= new cformulario
set resultado_busqueda = new cFormulario
set nuevo_selec = new cFormulario

conexion.inicializar "upacifico"
negocio.inicializa conexion

botonera.carga_parametros "plan_academica_laboratorio.xml", "btn_plan_academica"
nivel=request.QueryString("bsec[0][nive_ccod]")
c_carr=request.QueryString("bsec[0][carr_ccod]")
session("c_carr_TMP")=c_carr
espe=request.QueryString("bsec[0][espe_ccod]")
plan=request.QueryString("bsec[0][plan_ccod]"): if plan="" then plan="0"

seccion_tdesc=request.QueryString("s[0][seleccion_seccion]")
'response.Write("seccion_tdesc "&seccion_tdesc)
if c_carr <> "" and nivel <> "" then
	filtro = " carr_ccod='" & c_carr & "' and nive_ccod=" & nivel & "  and c.espe_ccod='" & especialidad & "' and b.plan_ccod=" & plan  
elseif c_carr <> "" and nivel="" then
    filtro = " carr_ccod='" & c_carr & "' and c.espe_ccod='" & especialidad & "' and b.plan_ccod=" & plan   	
else
	filtro = " 1=2 "
end if

if nivel <> "" and c_carr <> "" and espe <> "" and plan <> "" then
	filtro= "c.carr_ccod='" & c_carr & "' and a.nive_ccod='" & nivel & "' and c.espe_ccod='" & espe & "' and b.plan_ccod = '"& plan & "'"
	pasa=false
elseif nivel = "" and c_carr <> "" and espe <> "" and plan <> "" then
	filtro= "c.carr_ccod='" & c_carr & "' and c.espe_ccod='" & espe & "' and b.plan_ccod = '"& plan & "'"
	pasa=false	
else
	filtro = " 1=2 "
	pasa=true
end if
'response.Write("Filtro "&filtro)

'buscamos el periodo para hacer la planificación en caso de que de esta se trate la actividad
usuario_paso=negocio.obtenerUsuario
autorizada = conexion.consultaUno("select isnull(count(*),0) from personas a, sis_roles_usuarios b where a.pers_ncorr=b.pers_ncorr and b.srol_ncorr=72 and cast(a.pers_nrut as varchar)='"&usuario_paso&"'")
actividad = session("_actividad")
'response.Write("actividad "&actividad&" autorizada "&autorizada)
'if ((actividad = "6") and (autorizada > "0")) then
'	periodo = session("_periodo")
'else
periodo =  negocio.obtenerPeriodoAcademico("PLANIFICACION")
anos_ccod2 = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar )='"&periodo&"'") 

plec_ccod = conexion.consultaUno("select plec_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
if plec_ccod <> "1" then
	peri = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod2&"' and plec_ccod=1 ")
else
	peri = periodo
end if

'end if
'peri =  negocio.obtenerPeriodoAcademico("CLASES18")

peri_tdesc  = conexion.consultaUno("select peri_tdesc from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")



'if anos_ccod2 < "2006" then
	condicion_periodo = " and cast(peri_ccod as varchar) = case duas_ccod when 3 then '"&peri&"' else '"& periodo &"' end "
'else
'	condicion_periodo = " and cast(peri_ccod as varchar)='"&periodo&"'"
'end if

sede = negocio.obtenerSede
'response.Write(periodo)
'response.Write("yaaaaaaaaaa")
'response.End()

consulta="select (select carr_tdesc from carreras where cast(carr_ccod as varchar)='" & c_carr & "') as carrera" & vbCrLf & _
	", (select espe_tdesc from especialidades where cast(espe_ccod as varchar)='" & espe & "') as especialidad" & vbCrLf & _
	", (select plan_ncorrelativo from planes_estudio where cast(plan_ccod as varchar)='" & plan & "') as plan1" & vbCrLf & _
	", (select plan_nresolucion from planes_estudio where cast(plan_ccod as varchar)='" & plan & "') as plan_nresolucion" & vbCrLf & _
	", '" & nivel & "' as nivel"
	
resultado_busqueda.carga_parametros "plan_academica_laboratorio.xml", "pl_academica2_titulos"
resultado_busqueda.inicializar conexion
resultado_busqueda.consultar consulta
resultado_busqueda.siguiente

nuevo_selec.carga_parametros "plan_academica_laboratorio.xml", "agregado_seccion"
nuevo_selec.inicializar conexion
nuevo_selec.consultar "select ''"

espe_tdesc = conexion.consultaUno("select espe_tdesc from especialidades where cast(espe_ccod as varchar)='"&espe&"'")
considerar_jornada = "SI"
if espe_tdesc="FORMACION PROFESIONAL ELECTIVA" or espe_tdesc="FORMACION GENERAL OPTATIVA" then
	considerar_jornada = "NO"
end if

if espe <> "" and considerar_jornada = "SI" then
	jorn_ccod = conexion.consultaUno("select jorn_ccod from ofertas_Academicas where cast(espe_ccod as varchar)='"&espe&"' and cast(peri_ccod as varchar)='"&peri&"' and cast(sede_ccod as varchar)='"&sede&"'")
	filtro_jornada = " and cast(jorn_ccod as varchar)='"&jorn_ccod&"'"
	if jorn_ccod = "" or esVacio(jorn_ccod) then
		filtro_jornada = " and cast(jorn_ccod as varchar) in ('1','2')"
	end if
	'filtro_jornada = " and cast(jorn_ccod as varchar)='"&jorn_ccod&"'"
else
	filtro_jornada = ""
end if
'response.Write("select jorn_ccod from ofertas_Academicas where cast(espe_ccod as varchar)='"&espe&"' and cast(peri_ccod as varchar)='"&peri&"' and cast(sede_ccod as varchar)='"&sede&"'")

if not esVacio(c_carr) and not esVacio(espe) and not esVacio(plan) then
'************************agregado para seleccionar la sección de la cual se desean ver las asignaturas***************************************
'--------------------------------------------agregado por msandoval 15-04-2005 (no permite solapaciones de datosen el horario )
consulta_secciones = "(select distinct secc_tdesc " & vbCrLf & _
					 " from ( " & vbCrLf & _
					 " select secc_ccod, secc_tdesc, c.asig_ccod, asig_tdesc, asig_nhoras, sede_ccod, peri_ccod, b.moda_ccod, secc_nhoras_pagar,d.moda_tdesc " & vbCrLf & _
					 " from ( " & vbCrLf & _
					 " select asig_ccod  " & vbCrLf & _
					 " from   malla_curricular a  , planes_estudio b  , especialidades c " & vbCrLf & _
					 " where " & vbCrLf & _
					 " a.plan_ccod=b.plan_ccod " & vbCrLf & _
					 " and b.espe_ccod=c.espe_ccod " & vbCrLf & _
					 " and cast(c.carr_ccod as varchar)='"&c_carr&"' and cast(c.espe_ccod as varchar)='"&espe&"' and cast(b.plan_ccod as varchar)= '"&plan&"' " & vbCrLf & _
					 " ) a " & vbCrLf & _
					 " , secciones b " & vbCrLf & _
					 " , asignaturas c " & vbCrLf & _
					 " , modalidades d " & vbCrLf & _
					 " where " & vbCrLf & _
					 " a.asig_ccod=b.asig_ccod " & vbCrLf & _
					 " and b.moda_ccod=d.moda_ccod "&filtro_jornada & vbCrLf & _
					 " and a.asig_ccod=c.asig_ccod and secc_finicio_sec is not null and secc_ftermino_sec is not null " & vbCrLf & _
					 " and cast(carr_ccod as varchar) in ('"&c_carr&"') " & vbCrLf & _
					 " and cast(sede_ccod as varchar) = '"&sede&"' " & vbCrLf & _
					 " " & condicion_periodo & vbCrLf & _
					 " )aa ) bb " 

'response.Write("<pre>"&consulta_secciones&"</pre>")
					 
nuevo_selec.agregaCampoParam "seleccion_seccion","destino",consulta_secciones
end if
nuevo_selec.agregaCampoCons "seleccion_seccion",seccion_tdesc
nuevo_selec.siguiente
'********************************************************************************************************************************************

carreras = negocio.obtenerCarreras
if negocio.obtenerRol = "JC" then
	consulta_busqueda = "select  '" & c_carr &"' as carr_ccod,'" & espe &"' as espe_ccod ,'" & plan &"' as plan_ccod,'" & nivel &"' as nive_ccod " 
end if


formu_resul.carga_parametros "plan_academica_laboratorio.xml", "pl_academica"
formu_resul.inicializar conexion
formu_resul.consultar consulta_busqueda
'formu_resul.agregaCampoParam "carr_ccod", "filtro", " carr_ccod in ( " & carreras & ") "
formu_resul.agregaCampoParam "carr_ccod", "filtro", " cast(carr_ccod as varchar) in ( '" &c_carr& "') "
formu_resul.agregaCampoParam "espe_ccod", "filtro", " carr_ccod = '" & c_carr &"'" 
formu_resul.agregaCampoParam "plan_ccod", "filtro", " espe_ccod = '" & espe &"'"  
formu_resul.siguiente


'**********************************************

texto = "Debe seleccionar un criterio de búsqueda y presionar el botón buscar"


carrera       = c_carr
especialidad  = espe

set fbusqueda = new cFormulario
fbusqueda.carga_parametros "plan_academica_laboratorio.xml", "2"
fbusqueda.inicializar conexion
'peri = negocio.obtenerPeriodoAcademico ( "planificacion" ) 
sede = negocio.obtenerSede

if negocio.obtenerRol = "JC" then
	consulta = "select  '" & carrera &"' as carr_ccod,'" & especialidad &"' as espe_ccod ,'" & plan &"' as plan_ccod,'" & nivel &"' as nive_ccod " 
end if			

fbusqueda.consultar consulta
usuario=negocio.ObtenerUsuario()
pers_ncorr_encargado=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")


consulta2 = "SELECT distinct a.carr_ccod, a.carr_tdesc, b.espe_ccod, b.espe_tdesc, c.plan_ccod,c.plan_tdesc, " & vbCrLf & _
		   "		    c.plan_ncorrelativo " & vbCrLf & _
		   "	  FROM carreras a, especialidades b, planes_estudio c, ofertas_academicas d " & vbCrLf & _
		   "	 WHERE a.carr_ccod = b.carr_ccod " & vbCrLf & _
		   "	   AND b.espe_ccod = c.espe_ccod " & vbCrLf & _
		   "	   and b.espe_ccod = d.espe_ccod " & vbCrLf & _
		   "       and b.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where pers_ncorr='"&pers_ncorr_encargado&"')" & vbCrLf &_
		   "	   and d.sede_ccod = " & sede & vbCrLf & _
		   "	   and cast(d.peri_ccod as varchar) in ('" & peri &"','"&periodo&"')" & vbCrLf & _
		   " union " & vbCrLf & _
		   " select  distinct ltrim(rtrim(cast(a.carr_ccod as varchar))) as carr_ccod,a.carr_tdesc,b.espe_ccod,b.espe_tdesc,c.plan_ccod,c.plan_tdesc,c.plan_ncorrelativo " & vbCrLf & _
		   " from carreras a, especialidades b, planes_estudio c " & vbCrLf & _
		   " where a.carr_ccod=b.carr_ccod " & vbCrLf & _
		   " --and cast(b.carr_ccod as varchar)='"&carrera&"'" & vbCrLf & _
		   " and b.espe_ccod=c.espe_ccod" & vbCrLf & _
		   " and b.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where pers_ncorr='"&pers_ncorr_encargado&"')" & vbCrLf &_
		   " and b.espe_nplanificable='2' " & vbCrLf & _
		   " order by a.carr_tdesc,b.espe_tdesc,c.plan_tdesc asc" 

'***********************
'ESTA NUEVA CONSULTA AGRUPA AMBAS SELECCIONES DE LA CLAUSULA UNION, 
'DEBIDO A QUE LA *LISTADEPENDIENTE* de javascript  EN SQL2005 LAS INTERPRETABA POR SEPARADO
'***********************
'consulta = "select * from ( " & vbCrLf & _
'		   " SELECT distinct a.carr_ccod, a.carr_tdesc, b.espe_ccod, b.espe_tdesc, c.plan_ccod,c.plan_tdesc, " & vbCrLf & _
'		   "		    c.plan_ncorrelativo " & vbCrLf & _
'		   "	  FROM carreras a, especialidades b, planes_estudio c, ofertas_academicas d " & vbCrLf & _
'		   "	 WHERE a.carr_ccod = b.carr_ccod " & vbCrLf & _
'		   "	   AND b.espe_ccod = c.espe_ccod " & vbCrLf & _
'		   "	   and b.espe_ccod = d.espe_ccod " & vbCrLf & _
'		   "       and b.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where pers_ncorr='"&pers_ncorr_encargado&"')" & vbCrLf &_
'		   "	   and d.sede_ccod = " & sede & vbCrLf & _
'		   "	   and cast(d.peri_ccod as varchar) in ('" & peri &"','"&periodo&"')" & vbCrLf & _
'		   " union " & vbCrLf & _
'		   " select  distinct ltrim(rtrim(cast(a.carr_ccod as varchar))) as carr_ccod,a.carr_tdesc,b.espe_ccod,b.espe_tdesc,c.plan_ccod,c.plan_tdesc,c.plan_ncorrelativo " & vbCrLf & _
'		   " from carreras a, especialidades b, planes_estudio c " & vbCrLf & _
'		   " where a.carr_ccod=b.carr_ccod " & vbCrLf & _
'		   " --and cast(b.carr_ccod as varchar)='"&carrera&"'" & vbCrLf & _
'		   " and b.espe_ccod=c.espe_ccod" & vbCrLf & _
'		   " and b.espe_ccod in (Select espe_ccod from sis_especialidades_usuario where pers_ncorr='"&pers_ncorr_encargado&"')" & vbCrLf &_
'		   " and b.espe_nplanificable='2' " & vbCrLf & _
'		   " ) as tabla " & vbCrLf & _
'		   " order by carr_tdesc,espe_tdesc,plan_tdesc asc"  
'-------------------------------------------------------------------------------------------------------------------------------- Actualización 08_05_2013 Luis Herrera
consulta = "select *                                                              " & vbCrLf & _
"from   (select distinct a.carr_ccod,                                             " & vbCrLf & _
"                        a.carr_tdesc,                                            " & vbCrLf & _
"                        b.espe_ccod,                                             " & vbCrLf & _
"                        b.espe_tdesc,                                            " & vbCrLf & _
"                        c.plan_ccod,                                             " & vbCrLf & _
"                        c.plan_tdesc,                                            " & vbCrLf & _
"                        c.plan_ncorrelativo                                      " & vbCrLf & _
"        from   carreras a,                                                       " & vbCrLf & _
"               especialidades b,                                                 " & vbCrLf & _
"               planes_estudio c,                                                 " & vbCrLf & _
"               ofertas_academicas d                                              " & vbCrLf & _
"        where  a.carr_ccod = b.carr_ccod                                         " & vbCrLf & _
"               and b.espe_ccod = c.espe_ccod                                     " & vbCrLf & _
"               and b.espe_ccod = d.espe_ccod                                     " & vbCrLf & _
"               and b.espe_ccod in (select espe_ccod                              " & vbCrLf & _
"                                   from   sis_especialidades_usuario             " & vbCrLf & _
"                                   where                                         " & vbCrLf & _
"                   pers_ncorr = '"&pers_ncorr_encargado&"')                      " & vbCrLf & _
"               and d.sede_ccod = " & sede & vbCrLf & _
"               and cast(d.peri_ccod as varchar) in (                             " & vbCrLf & _
"                   '" & peri &"', '"&periodo&"' )                                " & vbCrLf & _
"        union                                                                    " & vbCrLf & _
"        select distinct a.carr_ccod, " & vbCrLf & _
"                        a.carr_tdesc,                                            " & vbCrLf & _
"                        b.espe_ccod,                                             " & vbCrLf & _
"                        b.espe_tdesc,                                            " & vbCrLf & _
"                        c.plan_ccod,                                             " & vbCrLf & _
"                        c.plan_tdesc,                                            " & vbCrLf & _
"                        c.plan_ncorrelativo                                      " & vbCrLf & _
"        from   carreras a,                                                       " & vbCrLf & _
"               especialidades b,                                                 " & vbCrLf & _
"               planes_estudio c                                                  " & vbCrLf & _
"        where  a.carr_ccod = b.carr_ccod                                         " & vbCrLf & _
"               and b.espe_ccod = c.espe_ccod                                     " & vbCrLf & _
"               and b.espe_ccod in (select espe_ccod                              " & vbCrLf & _
"                                   from   sis_especialidades_usuario             " & vbCrLf & _
"                                   where                                         " & vbCrLf & _
"                   pers_ncorr = '"&pers_ncorr_encargado&"')                      " & vbCrLf & _
"               and b.espe_nplanificable = '2') as tabla                          " & vbCrLf & _
"order  by carr_tdesc,                                                            " & vbCrLf & _
"          espe_tdesc,                                                            " & vbCrLf & _
"          plan_tdesc asc                                                         " 
'-------------------------------------------------------------------------------------------------------------------------------- Actualización 08_05_2013 Luis Herrera
'cantidad= conexion.consultaUno("select count(*) from ( "&consulta2&") as tabla")
'response.Write("Cantidad registros: "&cantidad)

'response.Write("<pre>"&consulta&"</pre>")
fbusqueda.inicializaListaDependiente "lBusqueda", consulta

fbusqueda.siguiente

'consulta_tabla="select a.secc_ccod, cast(a.asig_ccod as varchar)+ '-' + cast(a.secc_tdesc as varchar) as seccion, asig_tdesc, a.sede_ccod, peri_ccod," & vbCrLf & _
'   			   " protic.horario (b.secc_ccod) AS horario, case moda_ccod when 1 then asig_nhoras else secc_nhoras_pagar end as asig_nhoras," & vbCrLf & _ 
'   			   " COUNT (distinct bloq_ccod) AS horas,case duas_ccod when 1 then 'T' when 2 then 'S' when 3 then 'A' when 5 then 'P' end as d" & vbCrLf & _
'               " , isnull(round(cast(100/isnull(cast(case moda_ccod when 1 then asig_nhoras else secc_nhoras_pagar end as numeric),999999999)as decimal(5,2))*sum(protic.dias_habiles(dias_ccod,bloq_finicio_modulo,bloq_ftermino_modulo)),2),0) as porc " & vbCrLf & _
'               " , case when isnull(cast(case moda_ccod when 1 then asig_nhoras else secc_nhoras_pagar end as int),999999999) > isnull(sum(protic.dias_habiles(dias_ccod,bloq_finicio_modulo,bloq_ftermino_modulo)),0) then 1 else 2 end as estado " & vbCrLf & _
'               " , cast(isnull(round(sum(protic.dias_habiles(dias_ccod,bloq_finicio_modulo,bloq_ftermino_modulo)),2),0)* case a.sede_ccod when 2 then 1 when 4 then 1 else 2 end as varchar)" & vbCrLf & _
'               " + ' ( ' + cast( isnull(round(cast(100/isnull(cast(case moda_ccod when 1 then asig_nhoras else secc_nhoras_pagar end as numeric),999999999)as decimal(5,2))*sum(protic.dias_habiles(dias_ccod,bloq_finicio_modulo,bloq_ftermino_modulo)),0),0)* case a.sede_ccod when 2 then 1 when 4 then 1 else 2 end as varchar) + '% )' as hrs_asignadas" & vbCrLf & _
'               " ,  cast(sum(protic.dias_habiles(dias_ccod,bloq_finicio_modulo,bloq_ftermino_modulo)) as varchar)+' ('+cast(isnull(round(cast(100/isnull(cast(case moda_ccod when 1 then asig_nhoras else secc_nhoras_pagar end as int),999999999)as decimal(5,2))*sum(protic.dias_habiles(dias_ccod ,bloq_finicio_modulo,bloq_ftermino_modulo)),2),0) as varchar)+'%)' as horas_plan,moda_tdesc " & vbCrLf & _
'               " from ( " & vbCrLf & _   
'               " select secc_ccod, secc_tdesc,duas_ccod,c.asig_ccod, asig_tdesc, asig_nhoras, sede_ccod, peri_ccod, b.moda_ccod, secc_nhoras_pagar,d.moda_tdesc " & vbCrLf & _
'               " from ( " & vbCrLf & _
'                  " select asig_ccod,a.mall_ccod  " & vbCrLf & _
'                  " from  " & vbCrLf & _
'                  " malla_curricular a " & vbCrLf & _
'                  " , planes_estudio b " & vbCrLf & _
'                  " , especialidades c " & vbCrLf & _
'                  " where " & vbCrLf & _
'                  " a.plan_ccod=b.plan_ccod " & vbCrLf & _
'                  " and b.espe_ccod=c.espe_ccod " & vbCrLf & _
'                  " and "& filtro & vbCrLf & _
'                  " ) a " & vbCrLf & _
'                  " , secciones b " & vbCrLf & _
'                  " , asignaturas c " & vbCrLf & _
'				  " , modalidades d " & vbCrLf & _
'                  " where " & vbCrLf & _
'                  " a.asig_ccod=b.asig_ccod and a.mall_ccod = b.mall_ccod" & vbCrLf & _
'				  " and b.moda_ccod=d.moda_ccod "& filtro_jornada & vbCrLf & _
'                  " and a.asig_ccod=c.asig_ccod and secc_finicio_sec is not null and secc_ftermino_sec is not null" & vbCrLf & _
'                  " and carr_ccod in ('"& carrera &"')" & vbCrLf & _
'                  " and sede_ccod = "& sede &   vbCrLf & _
'                  " "& condicion_periodo &  vbCrLf & _
'                " ) a, bloques_horarios b " & vbCrLf & _
'                " WHERE a.secc_ccod *= b.secc_ccod  " 
                
'----------------------------------------------------------------------------------------------------------Nueva consulta 2008
consulta_tabla = "select a.secc_ccod,                                                                                                                            " & vbCrLf &_
"       cast(a.asig_ccod as varchar) + '-'                                                                                                                       " & vbCrLf &_
"       + cast(a.secc_tdesc as varchar)                                                              as seccion,                                                 " & vbCrLf &_
"       asig_tdesc,                                                                                                                                              " & vbCrLf &_
"       a.sede_ccod,                                                                                                                                             " & vbCrLf &_
"       peri_ccod,                                                                                                                                               " & vbCrLf &_
"       protic.horario (b.secc_ccod)                                                                 as horario,                                                 " & vbCrLf &_
"       case moda_ccod                                                                                                                                           " & vbCrLf &_
"         when 1 then asig_nhoras                                                                                                                                " & vbCrLf &_
"         else secc_nhoras_pagar                                                                                                                                 " & vbCrLf &_
"       end                                                                                          as asig_nhoras,                                             " & vbCrLf &_
"       count (distinct bloq_ccod)                                                                   as horas,                                                   " & vbCrLf &_
"       case duas_ccod                                                                                                                                           " & vbCrLf &_
"         when 1 then 'T'                                                                                                                                        " & vbCrLf &_
"         when 2 then 'S'                                                                                                                                        " & vbCrLf &_
"         when 3 then 'A'                                                                                                                                        " & vbCrLf &_
"         when 5 then 'P'                                                                                                                                        " & vbCrLf &_
"       end                                                                                          as d,                                                       " & vbCrLf &_
"       isnull(round(cast(100 / isnull(cast(case moda_ccod                                                                                                       " & vbCrLf &_
"                                             when 1 then asig_nhoras                                                                                            " & vbCrLf &_
"                                             else secc_nhoras_pagar                                                                                             " & vbCrLf &_
"                                           end as numeric), 999999999)as decimal(5, 2)) * sum(                                                                  " & vbCrLf &_
"                    protic.dias_habiles(dias_ccod, bloq_finicio_modulo, bloq_ftermino_modulo)                                                                   " & vbCrLf &_
"                                                                                          ), 2), 0) as porc,                                                    " & vbCrLf &_
"       case                                                                                                                                                     " & vbCrLf &_
"         when isnull(cast(case moda_ccod                                                                                                                        " & vbCrLf &_
"                            when 1 then asig_nhoras                                                                                                             " & vbCrLf &_
"                            else secc_nhoras_pagar                                                                                                              " & vbCrLf &_
"                          end as int), 999999999) > isnull(sum(protic.dias_habiles(dias_ccod, bloq_finicio_modulo, bloq_ftermino_modulo)), 0) then 1            " & vbCrLf &_
"         else 2                                                                                                                                                 " & vbCrLf &_
"       end                                                                                          as estado,                                                  " & vbCrLf &_
"       cast(isnull(round(sum(protic.dias_habiles(dias_ccod, bloq_finicio_modulo, bloq_ftermino_modulo)), 2), 0)* case a.sede_ccod when 2 then 1 when 4 then 1   " & vbCrLf &_
"       else 2                                                                                                                                                   " & vbCrLf &_
"       end as varchar) + ' ( ' + cast( isnull(round(cast(100/isnull(cast(case moda_ccod when 1 then asig_nhoras else secc_nhoras_pagar end as numeric),         " & vbCrLf &_
"       999999999)as                                                                                                                                             " & vbCrLf &_
"       decimal(5, 2))*sum(protic.dias_habiles(dias_ccod, bloq_finicio_modulo, bloq_ftermino_modulo)), 0), 0)* case a.sede_ccod when 2 then 1 when 4 then 1 else " & vbCrLf &_
"       2 end                                                                                                                                                    " & vbCrLf &_
"       as varchar) + '% )'                                                                          as hrs_asignadas,                                           " & vbCrLf &_
"       cast(sum(protic.dias_habiles(dias_ccod, bloq_finicio_modulo, bloq_ftermino_modulo)) as varchar)                                                          " & vbCrLf &_
"       + ' ('                                                                                                                                                   " & vbCrLf &_
"       + cast(isnull(round(cast(100/isnull(cast(case moda_ccod when 1 then asig_nhoras else secc_nhoras_pagar end as int), 999999999)as decimal(5,              " & vbCrLf &_
"       2))*sum(protic.dias_habiles(dias_ccod, bloq_finicio_modulo, bloq_ftermino_modulo)), 2), 0) as varchar)                                                   " & vbCrLf &_
"       + '%)'                                                                                       as horas_plan,                                              " & vbCrLf &_
"       moda_tdesc                                                                                                                                               " & vbCrLf &_
"from   (select secc_ccod,                                                                                                                                       " & vbCrLf &_
"               secc_tdesc,                                                                                                                                      " & vbCrLf &_
"               duas_ccod,                                                                                                                                       " & vbCrLf &_
"               c.asig_ccod,                                                                                                                                     " & vbCrLf &_
"               asig_tdesc,                                                                                                                                      " & vbCrLf &_
"               asig_nhoras,                                                                                                                                     " & vbCrLf &_
"               sede_ccod,                                                                                                                                       " & vbCrLf &_
"               peri_ccod,                                                                                                                                       " & vbCrLf &_
"               b.moda_ccod,                                                                                                                                     " & vbCrLf &_
"               secc_nhoras_pagar,                                                                                                                               " & vbCrLf &_
"               d.moda_tdesc                                                                                                                                     " & vbCrLf &_
"        from   (select asig_ccod,                                                                                                                               " & vbCrLf &_
"                       a.mall_ccod                                                                                                                              " & vbCrLf &_
"                from   malla_curricular as a                                                                                                                    " & vbCrLf &_
"                       inner join planes_estudio as b                                                                                                           " & vbCrLf &_
"                               on a.plan_ccod = b.plan_ccod                                                                                                     " & vbCrLf &_
"                       inner join especialidades as c                                                                                                           " & vbCrLf &_
"                               on b.espe_ccod = c.espe_ccod                                                                                                     " & vbCrLf &_
"                where "& filtro & vbCrLf & _ 
"               ) as a                                                                                                                                           " & vbCrLf &_
"               inner join secciones as b                                                                                                                        " & vbCrLf &_
"                       on a.asig_ccod = b.asig_ccod                                                                                                             " & vbCrLf &_
"                          and a.mall_ccod = b.mall_ccod                                                                                                         " & vbCrLf &_
"               inner join asignaturas as c                                                                                                                      " & vbCrLf &_
"                       on a.asig_ccod = c.asig_ccod                                                                                                             " & vbCrLf &_
"               inner join modalidades as d                                                                                                                      " & vbCrLf &_
"                       on b.moda_ccod = d.moda_ccod                                                                                                             " & vbCrLf &_
"        where  secc_finicio_sec is not null                                                                                                                     " & vbCrLf &_
"               "& filtro_jornada & vbCrLf & _ 
"               and secc_ftermino_sec is not null                                                                                                                " & vbCrLf &_
"               and carr_ccod in ( '"& carrera &"' )                                                                                                             " & vbCrLf &_
"			   	and sede_ccod = "& sede &   vbCrLf & _ 
"			   	"& condicion_periodo &  vbCrLf & _ 
"       ) as a                                                                                                                                                   " & vbCrLf &_
"       left outer join bloques_horarios as b                                                                                                                    " & vbCrLf &_
"                    on a.secc_ccod = b.secc_ccod                                                                                                                " 
'------------------------------------------------------------------------------------------------------fin_Nueva consulta 2008                
                
				if not esVacio(seccion_tdesc) then
					 consulta_tabla= consulta_tabla & " and a.secc_tdesc='"&seccion_tdesc&"' "
				end if				
                consulta_tabla= consulta_tabla & " GROUP BY a.secc_ccod, " & vbCrLf & _
                " a.asig_ccod,duas_ccod, " & vbCrLf & _
                " a.secc_tdesc, " & vbCrLf & _
                " asig_tdesc, " & vbCrLf & _
                " a.sede_ccod, " & vbCrLf & _
                " peri_ccod, " & vbCrLf & _
                " asig_nhoras, " & vbCrLf & _
				" moda_tdesc, " & vbCrLf & _
                " protic.horario (b.secc_ccod),moda_ccod,secc_nhoras_pagar " & vbCrLf & _
                " order by estado, seccion, porc"


'response.Write("<pre>"&consulta_tabla&"</pre>")
'response.End()	
set f_tabla= new cformulario
f_tabla.carga_parametros "plan_academica_laboratorio.xml", "pl_academica2"
f_tabla.agregaCampoParam "Asignatura_Seccion","consulta", filtro
f_tabla.inicializar conexion
f_tabla.consultar consulta_tabla




'**********************************************Agregar la cadena de secciones pal horario*****************************
'********************************************************MSANDOVAL 25/01/2005*****************************************
'consulta_secc_ccod="select a.secc_ccod " & vbCrLf & _
'               " from ( " & vbCrLf & _   
'               " select secc_ccod, secc_tdesc, c.asig_ccod, asig_tdesc, asig_nhoras, sede_ccod, peri_ccod " & vbCrLf & _
'               " from ( " & vbCrLf & _
'                  " select asig_ccod  " & vbCrLf & _
'                  " from  " & vbCrLf & _
'                  " malla_curricular a " & vbCrLf & _
'                  " , planes_estudio b " & vbCrLf & _
'                  " , especialidades c " & vbCrLf & _
'                  " where " & vbCrLf & _
'                  " a.plan_ccod=b.plan_ccod " & vbCrLf & _
'                  " and b.espe_ccod=c.espe_ccod " & vbCrLf & _
'                  " and "& filtro & vbCrLf & _
'                  " ) a " & vbCrLf & _
'                  " , secciones b " & vbCrLf & _
'                  " , asignaturas c " & vbCrLf & _
'                  " where " & vbCrLf & _
'                  " a.asig_ccod=b.asig_ccod "& filtro_jornada & vbCrLf & _
'                  " and a.asig_ccod=c.asig_ccod and secc_finicio_sec is not null and secc_ftermino_sec is not null" & vbCrLf & _
'                  " and carr_ccod in ('"& carrera &"')" & vbCrLf & _
'                  " and sede_ccod = "& sede &   vbCrLf & _
'				  " and b.secc_ncupo > 0 "&   vbCrLf & _
'                  " " & condicion_periodo &  vbCrLf & _
'                " ) a, bloques_horarios b " & vbCrLf & _
'                " WHERE a.secc_ccod *= b.secc_ccod  " & vbCrLf & _
'                " GROUP BY a.secc_ccod,a.asig_ccod,a.secc_tdesc,asig_tdesc,a.sede_ccod,peri_ccod,asig_nhoras,protic.horario (b.secc_ccod)" 
                
'----------------------------------------------------------------------------------------------------------Nueva consulta 2008
consulta_secc_ccod = " select a.secc_ccod                       " & vbCrLf &_
"from   (select secc_ccod,                                      " & vbCrLf &_
"               secc_tdesc,                                     " & vbCrLf &_
"               c.asig_ccod,                                    " & vbCrLf &_
"               asig_tdesc,                                     " & vbCrLf &_
"               asig_nhoras,                                    " & vbCrLf &_
"               sede_ccod,                                      " & vbCrLf &_
"               peri_ccod                                       " & vbCrLf &_
"        from   (select asig_ccod                               " & vbCrLf &_
"                from   malla_curricular as a                   " & vbCrLf &_
"                       inner join planes_estudio as b          " & vbCrLf &_
"                               on a.plan_ccod = b.plan_ccod    " & vbCrLf &_
"                       inner join especialidades as c          " & vbCrLf &_
"                               on b.espe_ccod = c.espe_ccod    " & vbCrLf &_
"                where 	"& filtro & vbCrLf & _ 
"               ) as a                                          " & vbCrLf &_
"               inner join secciones as b                       " & vbCrLf &_
"                       on a.asig_ccod = b.asig_ccod            " & vbCrLf &_
"                          and b.secc_ncupo > 0                 " & vbCrLf &_
"               inner join asignaturas as c                     " & vbCrLf &_
"                       on a.asig_ccod = c.asig_ccod            " & vbCrLf &_
"        where  secc_finicio_sec is not null                    " & vbCrLf &_
"               "& filtro_jornada & vbCrLf & _ 
"               and secc_ftermino_sec is not null               " & vbCrLf &_
"               and carr_ccod in ( '"& carrera &"' )            " & vbCrLf &_
"			   and sede_ccod = "& sede &   vbCrLf & _ 
"			   " & condicion_periodo &  vbCrLf & _ 
"       ) as a                                                  " & vbCrLf &_
"       left outer join bloques_horarios as b                   " & vbCrLf &_
"                    on a.secc_ccod = b.secc_ccod               " & vbCrLf &_
"group  by a.secc_ccod,                                         " & vbCrLf &_
"          a.asig_ccod,                                         " & vbCrLf &_
"          a.secc_tdesc,                                        " & vbCrLf &_
"          asig_tdesc,                                          " & vbCrLf &_
"          a.sede_ccod,                                         " & vbCrLf &_
"          peri_ccod,                                           " & vbCrLf &_
"          asig_nhoras,                                         " & vbCrLf &_
"          protic.horario (b.secc_ccod)                         " 
'------------------------------------------------------------------------------------------------------fin_Nueva consulta 2008                
                
'response.Write("<pre>"&consulta_secc_ccod&"</pre>")
set f_secc_ccod= new cformulario
f_secc_ccod.carga_parametros "plan_academica_laboratorio.xml", "pl_academica2"
f_secc_ccod.agregaCampoParam "Asignatura_Seccion","consulta", filtro
f_secc_ccod.inicializar conexion
f_secc_ccod.consultar consulta_secc_ccod


contador_secc=0
while f_secc_ccod.siguiente
	if contador_secc=0 then
	   cadena_secc_ccod="('"&f_secc_ccod.obtenerValor("secc_ccod")&"'"
    else
	   cadena_secc_ccod=cadena_secc_ccod &",'"&f_secc_ccod.obtenerValor("secc_ccod") & "'"
	end if
	contador_secc=contador_secc + 1
wend
cadena_secc_ccod=cadena_secc_ccod & ")"

if contador_secc=0 or esVacio(nivel) then
      botonera.AgregaBotonParam "HORARIO", "deshabilitado", "TRUE"
else
    carr_ccod=conexion.consultaUno("Select ltrim(rtrim("&c_carr&"))")
	espe_ccod=conexion.consultaUno("Select ltrim(rtrim("&espe&"))")
    url_horario="horario_carrera.asp?carr_ccod="&carr_ccod&"&espe_ccod="&espe_ccod&"&nive_ccod="&nivel&"&plan_ccod="&plan&"&secc_tdesc="&seccion_tdesc
end if
'response.Write("url "&url_horario)
'*********************************************************************************************************************

'********************corrección de filtros****************************************************************************
if esVacio(nivel) then
	nive_tdesc_1="Todos"
else
	nive_tdesc_1=conexion.consultaUno("Select nive_tdesc from niveles where cast(nive_ccod as varchar)='"&nivel&"'")
end if
	plan_tdesc_1=conexion.consultaUno("Select plan_tdesc from planes_estudio where cast(plan_ccod as varchar)='"&plan&"'")


%>


<html>
<head>
<title>Ingreso de Planificaci&oacute;n Acad&eacute;mica</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript" type="text/JavaScript">
<!--
function abrir() {
	direccion = "edicion_plan_acad.asp";
	window.open(direccion, "ventana1","width=600,height=400,scrollbars=YES, resizable=yes, left=0, top=0");
}


function enviar(formulario){
	formulario.action = 'plan_academica.asp';
  	formulario.submit();
 }

function enviar2(formulario){
   formulario.action = 'borrar_bloque.asp';
   formulario.submit();
 }


function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_nbGroup(event, grpName) { //v6.0
  var i,img,nbArr,args=MM_nbGroup.arguments;
  if (event == "init" && args.length > 2) {
    if ((img = MM_findObj(args[2])) != null && !img.MM_init) {
      img.MM_init = true; img.MM_up = args[3]; img.MM_dn = img.src;
      if ((nbArr = document[grpName]) == null) nbArr = document[grpName] = new Array();
      nbArr[nbArr.length] = img;
      for (i=4; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
        if (!img.MM_up) img.MM_up = img.src;
        img.src = img.MM_dn = args[i+1];
        nbArr[nbArr.length] = img;
    } }
  } else if (event == "over") {
    document.MM_nbOver = nbArr = new Array();
    for (i=1; i < args.length-1; i+=3) if ((img = MM_findObj(args[i])) != null) {
      if (!img.MM_up) img.MM_up = img.src;
      img.src = (img.MM_dn && args[i+2]) ? args[i+2] : ((args[i+1])? args[i+1] : img.MM_up);
      nbArr[nbArr.length] = img;
    }
  } else if (event == "out" ) {
    for (i=0; i < document.MM_nbOver.length; i++) {
      img = document.MM_nbOver[i]; img.src = (img.MM_dn) ? img.MM_dn : img.MM_up; }
  } else if (event == "down") {
    nbArr = document[grpName];
    if (nbArr)
      for (i=0; i < nbArr.length; i++) { img=nbArr[i]; img.src = img.MM_up; img.MM_dn = 0; }
    document[grpName] = nbArr = new Array();
    for (i=2; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
      if (!img.MM_up) img.MM_up = img.src;
      img.src = img.MM_dn = (args[i+1])? args[i+1] : img.MM_up;
      nbArr[nbArr.length] = img;
  } }
}

function enviar_datos(){
var url='<%=url_horario%>';
//alert("hola "+url);
self.open('<%=url_horario%>','horario_carrera','width=700px, height=600px, scrollbars=yes, resizable=yes')

}
function dibujar(formulario){
	formulario.submit();
}
//-->
</script>

<% fbusqueda.generaJS %>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif','../imagenes/botones/salir_f2.gif')">
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
                    <td width="5"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="106" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="center"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador</font><font size="1" face="Verdana, Arial, Helvetica, sans-serif"></font></div></td>
                    <td width="347" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="107" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                    <td width="105" align="right" bgcolor="#D8D8DE"><%=formu_resul.dibujaCampo("peri_tdesc")%></td>
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
				<table width="100%" cellpadding="0" cellspacing="0">
  <tr>
    <td>&nbsp;</td>
  </tr>
</table>

				<form name="buscador" method="get">
                  <table width="98%"  border="0">
                    <tr>
                      <td width="100%">
					   <table cellspacing=0 cellpadding=0 width="100%" border=0>
					      <tr>
						  	  <td width="20%" align="left"><strong>Programa de Estudio</strong></td>
							  <td width="80%" align="left"><strong>: </strong><% fbusqueda.dibujaCampoLista "lBusqueda", "carr_ccod"%>
																			  <input type="hidden" name="Carrera_ocul"  value="<%=c_carr%>">
																			  <input type="hidden" name="cadena_secc"  value="<%=cadena_secc_ccod%>">
							   </td>
						  </tr>
						  <tr>
						  	  <td width="20%" align="left"><strong>Especialidad</strong></td>
							  <td width="80%" align="left"><strong>: </strong><% fbusqueda.dibujaCampoLista "lBusqueda", "espe_ccod"%></td>
						  </tr>
						  <tr>
						  	  <td width="20%" align="left"><strong>Plan</strong></td>
							  <td width="80%" align="left"><strong>: </strong><% fbusqueda.dibujaCampoLista "lBusqueda", "plan_ccod"%></td>
						  </tr>
						  <tr>
						  	  <td width="20%" align="left"><strong>Nivel</strong></td>
							  <td width="80%" align="left"><strong>: </strong><%=fbusqueda.dibujaCampo("nive_ccod")%></td>
						  </tr>
                          <tr>
						  	  <td width="20%" align="left">&nbsp;</td>
							  <td width="80%" align="right"><%botonera.dibujaboton "buscar"%><% botonera.DibujaBoton("HORARIO") %></td>
						  </tr>
                       </table>
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
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="281" valign="middle" background="../imagenes/fondo1.gif">
                        <div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif"> <b><font color="#FFFFFF">PLANIFICACIÓN ACADÉMICA LABORATORIOS</font></b></font></div></td>
                      <td width="376" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
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
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				      <% if pasa  then 
				       response.Write(texto)
					  else%>
                    <form name="edicion22" >
					<input type="hidden" name="bsec[0][nive_ccod]" value="<%=nivel%>">
					<input type="hidden" name="bsec[0][carr_ccod]" value="<%=c_carr%>">
					<input type="hidden" name="bsec[0][espe_ccod]" value="<%=espe%>">
					<input type="hidden" name="bsec[0][plan_ccod]" value="<%=plan%>">
				    <table width="98%" cellspacing="0" cellpadding="0">
					  <tr align="left">
                        <td colspan="2" nowrap>&nbsp;</td>
                      </tr>
                      <tr>
                        <td width="20%" align="left" nowrap>Programa de Estudio </td>
                        <td width="80%" nowrap> :<strong>
                          <%resultado_busqueda.dibujaCampo("carrera")%>
                        </strong> </td>
                      </tr>
                      <tr>
                        <td align="left" nowrap>Especialidad </td>
                        <td nowrap> :<strong>
                          <%resultado_busqueda.dibujaCampo("especialidad")%>
                        </strong> </td>
                      </tr>
					  <tr>
                        <td align="left" nowrap>Nro. Resoluci&oacute;n </td>
                        <td nowrap> :<strong>
                          <%resultado_busqueda.dibujaCampo("plan_nresolucion")%>
                        </strong> </td>
                      </tr>
					  <tr>
                        <td align="left" nowrap>Plan </td>
                        <td nowrap> :<strong>
                          <%=plan_tdesc_1%>
                        </strong></td>
                      </tr>
					  <tr>
                        <td align="left" nowrap>Nivel </td>
                        <td nowrap> :<strong>
                          <%=nive_tdesc_1%>
                        </strong> </td>
                      </tr>
					  <tr>
                        <td align="left" nowrap>Secci&oacute;n </td>
                        <td nowrap> :
                        <%if f_tabla.nroFilas > 0 then
                             nuevo_selec.dibujaCampo("seleccion_seccion")   
						end if%>
                       </td>
                      </tr>
                    </table>
					</form>
                    <%end if%>
                    <br>
                    <div align="center">
                      <table width="98%" cellspacing="0" cellpadding="0">
                        <tr>
                          <td>&nbsp;</td>
                        </tr>
                        <tr align="center">
                        	<td colspan="5" nowrap><%pagina.DibujarSubtitulo "<center>PLANIFICACIONES "&peri_tdesc & "</center>"%></td>
                        </tr>
                        <tr>
                          <td align="right">&nbsp;</strong>
                          </td>
                        </tr>
                        <tr>
                          <td>&nbsp;</td>
                        </tr>
                        <tr>
                          <td align="right">
                            <form name="hola" method="post" action="">
                              <div align="center">
                                <%f_tabla.dibujaTabla()%>
                                <br>
                              </div>
                              <table width="4%" height="19" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                  <td width="30%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;</font></td>
                                  <td width="30%">&nbsp;</td>
                                  <td width="40%"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;</font></td>
                                </tr>
                              </table>
                            </form>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <div align="center"><br>
                            </div>
                          </td>
                        </tr>
                        <tr>
                          <td>* Indica que el bloque horario no cuenta con un
                            docente asignado</td>
                        </tr>
						<tr>
                          <td>Dur: Indica la duración de la asignatura; Trimestral(T), Semestral(S), Anual(A), Periodo(P).</td>
                        </tr>
                      </table>
                    </div>
                  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="89" bgcolor="#D8D8DE"> <div align="right"><%botonera.dibujaboton "salir"%></div></td>
                  <td width="273" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<p><br>
			<p><br>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
