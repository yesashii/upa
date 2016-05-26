<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
matr_ncorr = Request.QueryString("enca[0][carreras_alumno]")
'---------------------------------------------------------------------------------------------------
'response.Write(matr_ncorr)
set pagina = new CPagina
pagina.Titulo = "Carga Registrada"

set errores = new CErrores

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "inicio_toma_carga.xml", "botonera"

set botonera = new CFormulario
botonera.Carga_Parametros "toma_carga.xml", "BotoneraTomaCarga"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "inicio_toma_carga.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select '' "
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv

'---------- asignamos por defecto el primer semestre año 2006 para el proseso de toma de carga
actividad = session("_actividad")
'response.Write("a "&actividad)
if (actividad = "7")  then
	v_peri_ccod = negocio.obtenerPeriodoAcademico("TOMACARGA")
else
	v_peri_ccod = negocio.obtenerPeriodoAcademico("CLASES18")
end if


pers_ncorr_temporal = conexion.consultaUno("select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
anos_ccod = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&v_peri_ccod&"'")
peri_tdesc= conexion.consultaUno("Select peri_tdesc from periodos_Academicos where cast(peri_ccod as varchar)='"&v_peri_ccod&"'")
sede_ccod = negocio.obtenerSede

'response.Write(pers_ncorr_temporal)
rut = conexion.consultaUno("select cast(pers_nrut as varchar)+ '-'+pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
nombre = conexion.consultaUno("select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")

'buscamos la cantidad de matriculas, para distintas carreras, que el alumnos tenga en el sistema......................................
c_cantidad_carreras = " select count(*) " & vbCrLf &_
					" from alumnos a, ofertas_academicas b, especialidades c " & vbCrLf &_
					" where cast(a.pers_ncorr as varchar)= '"&pers_ncorr_temporal&"'  " & vbCrLf &_
					" and a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
					" and b.espe_ccod=c.espe_ccod " & vbCrLf &_
					" and a.emat_ccod = 1 " & vbCrLf &_
					" and cast(b.peri_ccod as varchar)= '"&v_peri_ccod&"' " & vbCrLf &_
					" and cast(sede_ccod as varchar)= '"&sede_ccod&"'"
					
cantidad_carreras = conexion.consultaUno(c_cantidad_carreras)

if cantidad_carreras = "1" then 
    if esVacio(matr_ncorr) then
			consulta_matr=" Select top 1 b.matr_ncorr from personas a, alumnos b, ofertas_Academicas c" &_
						  " where a.pers_ncorr=b.pers_ncorr and b.ofer_ncorr=c.ofer_ncorr and emat_ccod not in (9,6,7,5,11) "&_
						  " and cast(c.peri_ccod as varchar)='"&v_peri_ccod&"' and cast(a.pers_nrut as varchar)='"&q_pers_nrut&"'"
							
			matr_ncorr= conexion.consultaUno(consulta_matr)	
    end if
	carrera = conexion.consultaUno("select carr_tdesc + ' -- ' + c.espe_tdesc from alumnos a, ofertas_academicas b, especialidades c, carreras d where cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' and a.ofer_ncorr=b.ofer_ncorr and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"' and cast(b.sede_ccod as varchar)='"&sede_ccod&"' and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod and emat_ccod not in (9,6,7,5,11) ")
elseif  cantidad_carreras = "0" then 
	c_cantidad_carreras = " select count(*) " & vbCrLf &_
					" from alumnos a, ofertas_academicas b, especialidades c " & vbCrLf &_
					" where cast(a.pers_ncorr as varchar)= '"&pers_ncorr_temporal&"'  " & vbCrLf &_
					" and a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
					" and b.espe_ccod=c.espe_ccod " & vbCrLf &_
					" and a.emat_ccod = 1 " & vbCrLf &_
					" and cast(b.peri_ccod as varchar)= '"&v_peri_ccod&"' " 
	if conexion.consultaUno(c_cantidad_carreras) > "0" then
		sede_tdesc = conexion.consultaUno("Select protic.initCap(sede_tdesc) from alumnos a, ofertas_academicas b, sedes c where cast(a.pers_ncorr as varchar)= '"&pers_ncorr_temporal&"' and a.ofer_ncorr=b.ofer_ncorr  and b.sede_ccod=c.sede_ccod and a.emat_ccod = 1 and cast(b.peri_ccod as varchar)= '"&v_peri_ccod&"'")
		mensaje = "El alumno no presenta matricula activa en el sistema para esta sede, tiene una en la sede " & sede_tdesc
	else
	     consulta_no_activa = "Select protic.initCap(emat_tdesc) from alumnos a, ofertas_academicas b, estados_matriculas c where cast(a.pers_ncorr as varchar)= '"&pers_ncorr_temporal&"' and a.ofer_ncorr=b.ofer_ncorr  and a.emat_ccod = c.emat_ccod and cast(b.peri_ccod as varchar)= '"&v_peri_ccod&"'"
	     no_activa= conexion.consultaUno(consulta_no_activa)
		 if not Esvacio(no_activa) and no_activa <> "" then
		 	mensaje = "El alumno no presenta matricula activa en el sistema, su última matricula esta en estado "& no_activa
		 else
		 	mensaje = "El Alumno no presenta matricula para el periodo consultado."	
		 end if
	end if

elseif cantidad_carreras > "1" then

if esVacio(matr_ncorr) then
	consulta_matr=" Select top 1 b.matr_ncorr from personas a, alumnos b, ofertas_Academicas c" &_
	              " where a.pers_ncorr=b.pers_ncorr and b.ofer_ncorr=c.ofer_ncorr and emat_ccod not in (9,6,7,5,11)"&_
				  " and cast(c.peri_ccod as varchar)='"&v_peri_ccod&"' and cast(a.pers_nrut as varchar)='"&q_pers_nrut&"'"
				  	
	matr_ncorr= conexion.consultaUno(consulta_matr)	
end if

carrera = conexion.consultaUno("Select carr_ccod from alumnos a, ofertas_Academicas b, especialidades c where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and cast( matr_ncorr as varchar)='"&matr_ncorr&"'")
'---------------------------------------------------------------------------------------------------
set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "inicio_toma_carga.xml", "encabezado"
f_encabezado.Inicializar conexion

consulta = "select top 1 protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, b.plan_ccod, " & vbCrLf &_
           "       ltrim(rtrim(protic.obtener_nombre_carrera(b.ofer_ncorr, 'C'))) as carrera, protic.ano_ingreso_carrera(b.pers_ncorr, d.carr_ccod) as ano_ingreso_plan, cast(d.espe_nduracion as varchar) + ' Semestres' as duas_tdesc " & vbCrLf &_
		   "from personas a, alumnos b, ofertas_academicas c, especialidades d" & vbCrLf &_
		   "where a.pers_ncorr = b.pers_ncorr   " & vbCrLf &_
		   "  and b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
		   "  and c.espe_ccod = d.espe_ccod " 
		   if not esVacio(carrera) then
		   		consulta=consulta & " and cast(d.carr_ccod as varchar)='"&carrera&"'"
		   else
				consulta=consulta & "  and b.ofer_ncorr = protic.ultima_oferta_matriculado(a.pers_ncorr) " 
		   end if
		   consulta=consulta &"  and b.emat_ccod not in (9,6,7,5,11) " & vbCrLf &_
		   "  and cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "' "
		   
consulta_carrera= "(select distinct a.matr_ncorr , ltrim(rtrim(d.carr_tdesc)) as carr_tdesc " & vbCrLf &_
				  " from alumnos a, ofertas_academicas b, especialidades c, carreras d " & vbCrLf &_
				  " where cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' " & vbCrLf &_
				  " and a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
				  " and b.espe_ccod=c.espe_ccod " & vbCrLf &_
				  " and c.carr_ccod=d.carr_ccod  and a.emat_ccod not in (9,6,7,5,11)" & vbCrLf &_
				  " and cast(b.peri_ccod as varchar)='"&v_peri_ccod&"')s"
 				 
'response.Write("<pre>"&consulta_carrera&"</pre>")
f_encabezado.AgregaCampoParam "carreras_alumno","permiso","LECTURAESCRITURA"
f_encabezado.AgregaCampoParam "carrera","permiso","OCULTO"				 



'response.Write("<pre>"&consulta&"</pre>")
f_encabezado.Consultar consulta
f_encabezado.Siguiente
f_encabezado.AgregaCampoCons "carreras_alumno", matr_ncorr
f_encabezado.AgregaCampoParam "carreras_alumno","destino",consulta_carrera
v_plan_ccod = f_encabezado.ObtenerValor("plan_ccod")

'---------------------------------------------------------------------------------------------------	
	
end if 



set f_alumno = new CFormulario
f_alumno.Carga_Parametros "inicio_toma_carga.xml", "carga_tomada"
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

'response.Write("<pre>"&consulta&"</pre>")
f_alumno.Consultar consulta

if matr_ncorr <> "" then
	tipo_plan = conexion.consultaUno("select isnull(plan_tcreditos,0) from alumnos a, planes_estudio b where a.plan_ccod=b.plan_ccod and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and emat_ccod not in (9,6,7,5,11)")
	if tipo_plan = "0" then
		mensaje_plan = "El Alumno Esta encasillado en un plan de estudios regulado por Sesiones"
	else
		mensaje_plan = "El Alumno esta encasillado en un plan de Estudios regulado por Sistema Créditos."
	end if		
	es_moroso = conexion.consultaUno("select protic.es_Moroso("&pers_ncorr_temporal&",getDate())")
	con_encuesta = conexion.consultaUno("select count(*)  from resultados_encuestas where cast(pers_ncorr_encuestado as varchar)='"&pers_ncorr_temporal&"'")
	if con_encuesta = "0" then
	 	mensaje_encuesta = "El Alumno no ha realizado la Evaluación Docente."
	end if
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

'response.Write("tipo_plan "&tipo_plan&" matr_ncorr "&matr_ncorr)

if tipo_plan <> "0" and matr_ncorr <> "" then
    'response.Write("<br>select protic.obtener_creditos_asignados("&matr_ncorr&")")
	suma_creditos = conexion.consultaUno("select protic.obtener_creditos_asignados("&matr_ncorr&")")
end if


'response.Write("suma_creditos " &suma_creditos)

url="../CERTIFICADOS/HISTORICO_NOTAS_LIBRE.ASP?busqueda[0][pers_nrut]="&q_pers_nrut&"&busqueda[0][pers_xdv]="&q_pers_xdv&"&ocultar=1"

'-------------buscamos el año de el periodo si es mayor a 2005 agregamos a la tabla asignaturas_comunes-----------
anos_ccod= conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&v_peri_ccod&"'")
if anos_ccod > "2005" then 
 consulta_insercion = " insert into asignaturas_comunes (mall_ccod,carr_ccod,asig_ccod,plan_ccod,peri_ccod,audi_tusuario,audi_fmodificacion) " & vbCrLf &_
					  " select distinct a.mall_ccod,a.carr_ccod,a.asig_ccod,b.plan_ccod,a.peri_ccod,'Agregado Sistema' as audi_tusuario, getDate() as audi_tusuario " & vbCrLf &_
					  " from secciones a,malla_curricular b, planes_estudio c " & vbCrLf &_
					  "	where cast(peri_ccod as varchar)='"&v_peri_ccod&"' and a.mall_ccod=b.mall_ccod and b.plan_ccod=c.plan_ccod " & vbCrLf &_
					  "	and isnull(c.plan_tcreditos,0) = 0 " & vbCrLf &_
					  " and not exists( select 1 from asignaturas_comunes ac where b.mall_ccod=ac.mall_ccod) " & vbCrLf &_
					  "	and a.carr_ccod <> '820' "

'response.Write("<pre>"&consulta_insercion&"</pre>")					  
conexion.ejecutaS(consulta_insercion)					  
end if

'----------------------debemos ver si el alumno esta bien encasillado con el plan de estudios y la especialidad
'-----------------------------agregado por Marcelo Sandoval-----------------------------------------
especialidad_plan = conexion.consultaUno("select b.espe_ccod from alumnos a, planes_estudio b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.plan_ccod=b.plan_ccod")
especialidad_oferta = conexion.consultaUno("select b.espe_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr")

if especialidad_plan <> especialidad_oferta and matr_ncorr <> "" then 
	mensaje_distintos = "Imposible realizar la toma de carga del alumno, ya que presenta problemas con el plan de estudios asignado, haga el favor de corregir este tema en el <strong>Mantenedor de cambio de especialidades</strong>. Luego podrá tomarle las asignaturas."
end if	

'response.End()	
'---------------------------------------------------------------------------------------------------------
'response.Write(matr_ncorr)
'debemos cerrar el proceso de toma de carga académica para cuaquier persona que tenga acceso a ella exceptuando registro curricular.
jornada_matricula = conexion.consultaUno("select b.jorn_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr=b.ofer_ncorr")
usuario_sesion = negocio.obtenerUsuario
sin_restriccion = conexion.consultaUno("select count(*) from personas a, sis_roles_usuarios b where a.pers_ncorr=b.pers_ncorr and b.srol_ncorr=2 and cast(a.pers_nrut as varchar)='"&usuario_sesion&"'")

'response.Write("jornada_matricula "	&jornada_matricula&" sin_restriccion "&sin_restriccion)

if jornada_matricula ="1" and sin_restriccion ="0" then
	cerrar_carga_diurno = true 
end if


cerrar_carga_diurno = false

'response.Write(cerrar_carga_diurno)

'if q_pers_nrut = "10440084" then
'	es_moroso = "N"
'end if
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
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                    <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td><div align="right"><strong>R.U.T. Alumno </strong></div></td>
                        <td width="50"><div align="center"><strong>:</strong></div></td>
                        <td><%f_busqueda.DIbujaCampo("pers_nrut")%> - <%f_busqueda.DibujaCampo("pers_xdv")%> <%pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]"%></td>
                      </tr>
                    </table>
                  </div></td>
                  <td width="19%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td>
                </tr>
              </table>
            </form></td>
          </tr>
        </table></td>
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
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.Titulo = "Carga Registrada <br>(" &peri_tdesc&")"
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
				  <%end if%>
				  <%if cantidad_carreras = "1" then %>
				  <tr>
				  	<td width="10%"><strong>Carrera</strong></td>
				  	<td width="1%"><strong>:</strong></td>
				  	<td><%=carrera%></td>
				  </tr>
				  <%elseif cantidad_carreras > "1" then %>
				  <tr>
				  	<td colspan="3">&nbsp;</td>
				  </tr>
				  <tr>
				  	<td colspan="3"><strong>Se ha detectado que tiene más de una matricula activa para el periodo.<br> Seleccione la carrera a consultar: </strong>
				  	  <%f_encabezado.DibujaCampo("carreras_alumno")%></td>
				  </tr>
				  <%end if%>
				  <%if mensaje <> "" and q_pers_nrut <> ""  then %>
				  <tr>
				  	<td colspan="3">&nbsp;</td>
				  </tr>
				  <tr>
				  	<td colspan="3" align="center"><font color="#0000FF"><strong>Imposible realizar la toma de carga del alumno </strong><br></font> Se ha detectado que : <%=mensaje%></td>
				  </tr>
				  <%end if%>
				  <%if es_moroso = "S" and q_pers_nrut <> ""  then %>
				  <tr>
				  	<td colspan="3">&nbsp;</td>
				  </tr>
				  <tr>
				  	<td colspan="3" align="center">Se ha detectado que presenta una morosidad en su cuenta corriente.</td>
				  </tr>
				  <%end if%>
				   <%if mensaje_distintos <> "" and q_pers_nrut <> ""  then %>
				  <tr>
				  	<td colspan="3">&nbsp;</td>
				  </tr>
				  <tr>
				  	<td colspan="3" align="center"><font color="#0000FF"><strong><%=mensaje_distintos%></td>
				  </tr>
				  <%end if%>
				  <tr>
				  	<td colspan="3">&nbsp;
					</td>
				  </tr>
				  <%if matr_ncorr <> "" then %>
				  <tr>
                    <td colspan="3"><%pagina.DibujarSubtitulo "Solicitante"%>
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
				  <%if tipo_plan <> "0" then%>
					  <%if cdbl(suma_creditos) >= 9 and cdbl(suma_creditos) <= 27 and f_alumno.nroFilas > 0 then%>
					  <tr>
						<td colspan="3" align="center"><font  size="2"color="#0000FF"><strong>Total de Cr&eacute;ditos Asignados <%=suma_creditos%></strong></font>
						</td>
					  </tr>
					  <%elseif (cdbl(suma_creditos) < 9 or cdbl(suma_creditos) > 27) and f_alumno.nroFilas > 0 then%>
					  <tr>
						<td colspan="3" align="center"><font  size="2" color="#FF0000"><strong>Atención el total de Cr&eacute;ditos Asignados (<%=suma_creditos%>) esta fuera del rango permitido (9-27) regularice dicha situación.</strong></font>
						</td>
					  </tr>
					  <%end if%>
				  <%end if%>
				  <tr>
				  	<td colspan="3">&nbsp;
					</td>
				  </tr>
				  <%if mensaje_encuesta<> "" then %>
				  <tr>
					  <td colspan="3" align="center"><strong><%=mensaje_encuesta%></strong>
					  </td>
				  </tr>
				  <%end if%>
				  <%if cerrar_carga_diurno then%>
				  <tr>
				     <td colspan="3" align="center">&nbsp;</td>
				  </tr>
				  <tr>
				     <td colspan="3" align="center"><font size="+1" face="Times New Roman, Times, serif"><strong>Lo sentimos pero el proceso de toma de carga para alumnos de r&eacute;gimen diurno finalizó el día 27 de marzo del presente.</strong></font></td>
				  </tr>
				  <%end if%>
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
                  <td><div align="center"><% if cerrar_carga_diurno then
				                                f_botonera.AgregaBotonParam "siguiente","deshabilitado","TRUE"       
				  							 end if
				                             if matr_ncorr = "" or mensaje_distintos <> "" then 
				                             	f_botonera.AgregaBotonParam "siguiente","deshabilitado","TRUE"
											 end if 
											   'f_botonera.AgregaBotonParam "siguiente","deshabilitado","TRUE"
											   f_botonera.DibujaBoton("siguiente")%></div></td>
                  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
				  <%if matr_ncorr <> "" then%>
				  <td><div align="center">
                    <%botonera.DibujaBoton "HORARIO"%>
                  </div></td>
                  <td><div align="center"><% botonera.DibujaBoton "NOTAS"%></div></td>
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
