<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'---------------------------------------------------------------------------------------------------
Server.ScriptTimeOut = 150000
set pagina = new CPagina
pagina.Titulo = "Notas parciales Alumno"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

q_pers_nrut = Request.QueryString("b[0][pers_nrut]")
q_pers_xdv = Request.QueryString("b[0][pers_xdv]")
peri_ccod = negocio.obtenerPeriodoAcademico("PLANIFICACION")
anos_ccod = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
if anos_ccod = "" then 
	anos_ccod="2014"
end if
'response.Write(anos_ccod)
if q_pers_nrut <> "" then 
'--------------------------------------actualizaremos listado de notas temporales una vez al día----------------------------------------- 
'Lo primero es ver si ya fue actualizado el listado en el día..........

consulta_existencia = " select case count(*) when 0 then 'N' else 'S' end as existe " & vbCrLf &_
					  " from " & vbCrLf &_
					  " ( " & vbCrLf &_
					  " select top 1 * " & vbCrLf &_
					  " from NOTAS_TEMPORALES  " & vbCrLf &_
					  " where cast(anos_ccod as varchar)='"&anos_ccod&"' " & vbCrLf &_
					  " and convert(datetime,protic.trunc(fecha_grabado),103) = convert(datetime,protic.trunc(getDate()),103) " & vbCrLf &_
					  " )tabla"

existencia = conexion.consultaUno(consulta_existencia)
if anos_ccod <> "2014" then
	existencia="S"
end if
'Si no existe una actualización de la tabla para el día consultado, se debe actualizar, priemro eliminando los registros.
'response.Write(conexion.obtenerEstadoTransaccion)
if existencia = "N" then
    'response.Write("entre 2")
	c_eliminacion = "delete from NOTAS_TEMPORALES  where cast(anos_ccod as varchar)= '"&anos_ccod&"'"
	conexion.ejecutaS(c_eliminacion)
	respuesta = conexion.ObtenerEstadoTransaccion 
	'Si la eliminación fue realizada exitosamente
	'response.Write(conexion.obtenerEstadoTransaccion)
	if respuesta then
	    'response.Write("entre")
		c_agregar_registros = " insert into  NOTAS_TEMPORALES (PERS_NCORR,MATR_NCORR,SECC_CCOD,CALI_NCORR,CALA_NNOTA,CALI_NEVALUACION,CALI_NPONDERACION,CALI_FEVALUACION,TEVA_TDESC,CARG_NNOTA_FINAL,PERI_TDESC,ANOS_CCOD,ASIG_CCOD,ASIG_TDESC,DUAS_TDESC,CARR_CCOD,CARR_TDESC,JORN_CCOD,ESTADO_CIERRE_CCOD,AUDI_TUSUARIO,AUDI_FMODIFICACION,FECHA_GRABADO) " & vbCrLf &_
							  " select d.pers_ncorr,b.matr_ncorr,b.secc_ccod,e.cali_ncorr," & vbCrLf &_
							  " (select ca.cala_nnota from calificaciones_alumnos ca where ca.secc_ccod=b.secc_ccod and ca.matr_ncorr=b.matr_ncorr and ca.cali_ncorr=e.cali_ncorr) as cala_nnota," & vbCrLf &_
							  " e.cali_nevaluacion, cali_nponderacion,cali_fevaluacion, f.teva_tdesc, " & vbCrLf &_
							  " b.carg_nnota_final,peri_tdesc, anos_ccod,asi.asig_Ccod,asi.asig_tdesc,duas_tdesc," & vbCrLf &_
							  " a.carr_ccod,carr_tdesc, case a.jorn_ccod when 1 then '(D)' else '(V)' end as jorn_Ccod,isnull(a.estado_cierre_ccod,1) as estado_cierre_ccod," & vbCrLf &_
							  " 'sistema adm' as audi_tusuario,getdate() as audi_fmodificacion,getDate() as fecha_grabado" & vbCrLf &_
							  " from secciones a join cargas_academicas b " & vbCrLf &_
							  "    on a.secc_ccod=b.secc_ccod  " & vbCrLf &_
							  " join calificaciones_seccion e " & vbCrLf &_
							  "    on a.secc_ccod = e.secc_ccod   " & vbCrLf &_
							  " join tipos_evaluacion f " & vbCrLf &_
							  "    on e.teva_ccod = f.teva_ccod " & vbCrLf &_   
							  " join alumnos d " & vbCrLf &_
							  "    on b.matr_ncorr=d.matr_ncorr " & vbCrLf &_
							  " join periodos_academicos pea " & vbCrLf &_
							  "    on a.peri_ccod = pea.peri_ccod  " & vbCrLf &_
							  " join asignaturas asi " & vbCrLf &_
							  "    on asi.asig_Ccod = a.asig_Ccod  " & vbCrLf &_
						      " join duracion_asignatura dua " & vbCrLf &_
						      "    on asi.duas_ccod=dua.duas_ccod " & vbCrLf &_
							  " join carreras car " & vbCrLf &_
							  "    on a.carr_ccod=car.carr_ccod " & vbCrLf &_
							  " where a.peri_ccod in (select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)= '"&anos_ccod&"')  " 
	   conexion.ejecutaS(c_agregar_registros)
	   'response.Write("<pre>"&c_agregar_registros&"</pre>")		
	end if
end if
'-----------------------------------------------------------------------------------------------------------------
end if
'response.Write(conexion.obtenerEstadoTransaccion)
'q_pers_nrut = Request.QueryString("b[0][pers_nrut]")
'q_pers_xdv = Request.QueryString("b[0][pers_xdv]")

'if esVacio(q_pers_nrut) then
'	q_pers_nrut = negocio.obtenerUsuario
'	q_pers_xdv = conexion.consultaUno("Select pers_xdv from personas_postulante where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
'end if
'---------------------------------------------------------------------------------------------------
'--------------------------------------------------------------------------
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "notas_alumno.xml", "nueva_busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select '' "
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
 f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
'--------------------------------------------------------------------------

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "notas_alumno.xml", "nueva_botonera"

set f_encabezado = new CFormulario
f_encabezado.Carga_Parametros "notas_alumno.xml", "encabezado"
f_encabezado.Inicializar conexion

pers_ncorr = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
'response.write("peri_ccod = "&peri_ccod)
if not esVacio(peri_ccod) then
consulta = "select protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, b.plan_ccod, " & vbCrLf &_
           "       protic.obtener_nombre_carrera(b.ofer_ncorr, 'C') as carrera, protic.ano_ingreso_plan(b.pers_ncorr, b.plan_ccod) as ano_ingreso_plan, cast(d.espe_nduracion as varchar) + ' Semestres' as duas_tdesc " & vbCrLf &_
		   "from personas a, alumnos b, ofertas_academicas c, especialidades d" & vbCrLf &_
		   "where a.pers_ncorr = b.pers_ncorr   " & vbCrLf &_
		   "  and b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
		   "  and c.espe_ccod = d.espe_ccod " & vbCrLf &_
		   "  and b.emat_ccod <> 9 " & vbCrLf &_
		   "  and cast(c.peri_ccod as varchar)= '"&peri_ccod&"'" & vbCrLf &_
		   "  and cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "' "
'response.write("<pre>"&consulta&"</pre>")		   
f_encabezado.AgregaCampoParam "carreras_alumno","permiso","OCULTO"
f_encabezado.AgregaCampoParam "carrera","permiso","LECTURA"

consulta_carrera="(Select '' as carr_ccod,'' as carr_tdesc) s"		   
else
consulta = "select top 1 protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, b.plan_ccod, " & vbCrLf &_
           "       ltrim(rtrim(protic.obtener_nombre_carrera(b.ofer_ncorr, 'C'))) as carrera, protic.ano_ingreso_plan(b.pers_ncorr, b.plan_ccod) as ano_ingreso_plan, cast(d.espe_nduracion as varchar) + ' Semestres' as duas_tdesc " & vbCrLf &_
		   "from personas a, alumnos b, ofertas_academicas c, especialidades d" & vbCrLf &_
		   "where a.pers_ncorr = b.pers_ncorr   " & vbCrLf &_
		   "  and b.ofer_ncorr = c.ofer_ncorr " & vbCrLf &_
		   "  and c.espe_ccod = d.espe_ccod " 
		   if not esVacio(carrera) then
		   		consulta=consulta & " and cast(d.carr_ccod as varchar)='"&carrera&"'"
		   else
				consulta=consulta & "  and b.ofer_ncorr = protic.ultima_oferta_matriculado(a.pers_ncorr) " 
		   end if
		   consulta=consulta &"  and b.emat_ccod <> 9 " & vbCrLf &_
		   "  and cast(a.pers_nrut as varchar)= '" & q_pers_nrut & "' "
		   

'consulta_carrera="(select distinct ltrim(rtrim(d.carr_ccod)) as carr_ccod, ltrim(rtrim(d.carr_tdesc)) as carr_tdesc" & vbCrLf &_
'				 " from alumnos a, ofertas_academicas b, especialidades c, carreras d , periodos_academicos pea" & vbCrLf &_
'				 " where cast(a.pers_ncorr as varchar)='"&pers_ncorr_temporal&"' " & vbCrLf &_
'				 " and a.ofer_ncorr=b.ofer_ncorr " & vbCrLf &_
'				 " and b.espe_ccod=c.espe_ccod and b.peri_ccod = pea.peri_ccod and pea.anos_ccod >= 2005" & vbCrLf &_
'				 " and c.carr_ccod=d.carr_ccod ) s"

consulta_carrera=" (select distinct ltrim(rtrim(a.carr_ccod)) as carr_ccod, ltrim(rtrim(a.carr_tdesc)) as carr_tdesc " & vbCrLf &_
				 " from NOTAS_TEMPORALES a " & vbCrLf &_
				 " where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"') s"

f_encabezado.AgregaCampoParam "carreras_alumno","permiso","LECTURAESCRITURA"
f_encabezado.AgregaCampoParam "carrera","permiso","OCULTO"				 
end if
'response.Write("<pre>"&pers_ncorr_temporal&"</pre>")'

'response.Write("<pre>"&consulta_carrera&"</pre>")
f_encabezado.Consultar consulta
f_encabezado.Siguiente
f_encabezado.AgregaCampoCons "carreras_alumno", carrera
f_encabezado.AgregaCampoParam "carreras_alumno","destino",consulta_carrera
v_plan_ccod = f_encabezado.ObtenerValor("plan_ccod")

'---------------------------------------------------------------------------------------------------
'peri_ccod = negocio.obtenerPeriodoAcademico("TOMACARGA")

'anio_consulta = conexion.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
anio_consulta = anos_ccod
'pers_ncorr = conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
'response.Write(pers_ncorr)
set f_asignaturas = new CFormulario
f_asignaturas.Carga_Parametros "tabla_vacia.xml", "tabla"
f_asignaturas.Inicializar conexion

'consulta2 = " select a.matr_ncorr, b.peri_ccod,c.peri_tdesc, ltrim(rtrim(e.carr_tdesc)) + ' (' + case b.jorn_ccod when 1 then 'D' when 2 then 'V' end + ') ' as carrera, " & vbCrLf &_
'			" g.secc_ccod, ltrim(rtrim(h.asig_ccod)) + ' --> ' + h.asig_tdesc as asignatura,i.duas_tdesc  " & vbCrLf &_
'			" from alumnos a, ofertas_academicas b, periodos_academicos c, especialidades d, carreras e, " & vbCrLf &_
'			" cargas_academicas f, secciones g, asignaturas h, duracion_asignatura i " & vbCrLf &_
'			" where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr" & vbCrLf &_
'			" and b.peri_ccod=c.peri_ccod and b.espe_ccod=d.espe_ccod " & vbCrLf &_
'			" and d.carr_ccod = e.carr_ccod" & vbCrLf &_
'			" and a.matr_ncorr = f.matr_ncorr and f.secc_ccod=g.secc_ccod and g.asig_ccod = h.asig_ccod " & vbCrLf &_
'			" and h.duas_ccod = i.duas_ccod" & vbCrLf &_
'			" and cast(c.anos_ccod as varchar) = '"&anio_consulta&"' and a.emat_ccod in (1,2,4,8,13) " & vbCrLf &_
'			" order by b.peri_ccod asc "

consulta2 = "  select distinct a.matr_ncorr,a.peri_tdesc, ltrim(rtrim(a.carr_tdesc)) + a.jorn_ccod as carrera, " & vbCrLf &_
		    " a.secc_ccod, ltrim(rtrim(a.asig_ccod)) + ' --> ' + a.asig_tdesc as asignatura,a.duas_tdesc  " & vbCrLf &_
		    " from NOTAS_TEMPORALES a " & vbCrLf &_
			" where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' " & vbCrLf &_
			" and cast(a.anos_ccod as varchar) = '"&anos_ccod&"' " 
			

f_asignaturas.Consultar consulta2 & " order by a.peri_tdesc asc "
'response.Write(consulta2 & " order by a.peri_tdesc asc ")
nombre_carrera=f_encabezado.obtenerValor("carrera")

set f_notas_parciales = new CFormulario
f_notas_parciales.Carga_Parametros "notas_alumno.xml", "notas_parciales"
f_notas_parciales.Inicializar conexion


lenguetas_notas = Array(Array("Listado Notas Parciales", "notas_parciales_alumno.asp"))

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

var t_parametros;

function Inicio()
{
	t_parametros = new CTabla("p")
}

function dibujar(formulario){
	formulario.submit();
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

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	  <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
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
                            <td width="210" valign="bottom" background="../imagenes/fondo1.gif"> 
                              <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador 
                                </font></div></td>
                            <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                            <td width="423" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
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
                          <form name="buscador">
                            <table width="98%"  border="0">
                              <tr> 
                                <td width="81%"><table width="524" border="0">
                                    <tr> 
                                      <td width="98">Rut Usuario</td>
                                      <td width="23">:</td>
                                      <td width="389"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                        <%f_busqueda.DibujaCampo("pers_nrut") %>
                                        - 
                                        <%f_busqueda.DibujaCampo("pers_xdv")%>
                                        </font><a href="javascript:buscar_persona('b[0][pers_nrut]', 'b[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a></td>
                                    </tr>
                                  </table></td>
                                <td width="19%"><div align="center"> 
                                    <%f_botonera.DibujaBoton "buscar" %>
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
                  </table></td>
              </tr>
            </table></td>
      </tr>
    </table>
	  <br>
	<table width="85%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas lenguetas_notas, 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
		  <tr>
            <td>
			<form name="edicion" action="notas_alumno.asp">
			 <div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
              <br>
			   <%if not esVacio(q_pers_nrut) then%>
			   <table width="98%"  border="0">
                <tr>
                  <td width="64" align="left"><strong>RUT</strong></td>
				  <td width="11"  align="center"><strong>:</strong></td>
				  <td width="83"  align="left"><%f_encabezado.DibujaCampo("rut")%></td>
				  <td width="182" align="left"><strong>Nombre</strong></td>
				  <td width="14"  align="center"><strong>:</strong></td>
				  <td width="266"  align="left"><%f_encabezado.DibujaCampo("nombre")%></td>
                </tr>
				<tr>
                  <td width="64" align="left"><strong>Carrera</strong></td>
				  <td width="11"  align="center"><strong>:</strong></td>
				  <td  align="left" colspan="4"><%=nombre_carrera%></td>
			    </tr>
				 <tr>
                  <td width="64" align="left"><strong>Duraci&oacute;n</strong></td>
				  <td width="11"  align="center"><strong>:</strong></td>
				  <td width="83"  align="left"><%f_encabezado.DibujaCampo("duas_tdesc")%></td>
				  <td width="182" align="left"><strong>Año Ingreso al Plan de Estudios</strong></td>
				  <td width="14"  align="center"><strong>:</strong></td>
				  <td width="266"  align="left"><%f_encabezado.DibujaCampo("ano_ingreso_plan")%></td>
                </tr>
              </table>
			  <%end if%>
			  </div>
              
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <% 
				  if f_asignaturas.NroFilas > 0 and q_pers_nrut <> "" then 
				  
				  while f_asignaturas.siguiente 
				  matr_ncorr = f_asignaturas.obtenerValor("matr_ncorr")
				  secc_ccod  = f_asignaturas.obtenerValor("secc_ccod")
				  periodo    = f_asignaturas.obtenerValor("peri_tdesc")
				  carrera    = f_asignaturas.obtenerValor("carrera")
				  asignatura = f_asignaturas.obtenerValor("asignatura")
				  duracion   = f_asignaturas.obtenerValor("duas_tdesc")
				  'response.Write("matr "&matr_ncorr & "secc "&secc_ccod)
				  %>
				  <tr><td>&nbsp;</td></tr>
				  <tr>
                    <td><%pagina.DibujarSubtitulo periodo & " - " & carrera%> </td>
				  </tr>	
				  <tr>
					 <td><font size="3" color="#0000FF" face="Times New Roman, Times, serif"><%=asignatura & " (" & duracion &") " %></font></td> 
				   </tr>
				   <tr><td>&nbsp;</td></tr>
				   <tr><td>
                      <table width="98%"  border="0" align="center">
					  <% 'consulta3 = " select cali_nevaluacion as n,teva_tdesc as tipo,cali_nponderacion as ponderacion, protic.trunc(cali_fevaluacion) as fecha, " & vbCrLf &_
						'			 " c.cala_nnota as nota  " & vbCrLf &_
						'			 " from calificaciones_seccion a join  tipos_evaluacion b " & vbCrLf &_
						'			 "      on a.teva_ccod = b.teva_ccod " & vbCrLf &_
						'			 " left outer join calificaciones_alumnos c " & vbCrLf &_
						'			 "       on a.secc_ccod = c.secc_ccod and a.cali_ncorr = c.cali_ncorr and cast(c.matr_ncorr as varchar)= '"&matr_ncorr&"' " & vbCrLf &_
						'			 " where cast(a.secc_ccod as varchar)= '"&secc_ccod &"' " & vbCrLf &_
						'			 " order by cali_nevaluacion   " 
									 
						  consulta3 = " select cali_nevaluacion as n,teva_tdesc as tipo,cali_nponderacion as ponderacion, protic.trunc(cali_fevaluacion) as fecha, " & vbCrLf &_
									  " a.cala_nnota as nota  " & vbCrLf &_
									  " from NOTAS_TEMPORALES a " & vbCrLf &_
									  " where cast(a.secc_ccod as varchar)= '"&secc_ccod&"' " & vbCrLf &_
									  " and cast(a.matr_ncorr as varchar)= '"&matr_ncorr&"'  " & vbCrLf &_
									  " order by cali_nevaluacion "			 
                         'response.Write("<pre>"&consulta3&"</pre>")									 
			    		 f_notas_parciales.Consultar consulta3
						 
						 promedio = conexion.consultaUno("select cast(cast(carg_nnota_final as decimal(2,1)) as varchar) from NOTAS_TEMPORALES where cast(matr_ncorr as varchar)='"&matr_ncorr&"' and cast(secc_ccod as varchar)='" & secc_ccod & "'")
                         estado = conexion.consultaUno("select isnull(estado_cierre_ccod,1) from NOTAS_TEMPORALES where cast(matr_ncorr as varchar)='"&matr_ncorr&"' and cast(secc_ccod as varchar)='" & secc_ccod & "'")
						 sitf_ccod = conexion.consultaUno("select isnull(sitf_ccod,'') from cargas_academicas where cast(matr_ncorr as varchar)='"&matr_ncorr&"' and cast(secc_ccod as varchar)='" & secc_ccod & "'")
             			 'response.Write(estado)
						 if estado <> "2" then
						 	mensaje_estado = "(Provisorio) "
						 else
						 	mensaje_estado = "(Definitivo) "
						 end if		
						 %>
						<tr>
                          <td scope="col" colspan="6"><div align="center"><%f_notas_parciales.DibujaTabla%></div></td>
                        </tr>
						<%f_notas_parciales.primero
						  matr_ncorr = ""
						  secc_ccod =  ""
						  consulta3 = ""%>
						  <tr>
						   <td colspan="6" align="left">
						        <table width="85%">
						      	<tr>
								    <td align="right">  <%if sitf_ccod <> "RI" then %>
									                    	<strong>Promedio<%=mensaje_estado%> : <%=promedio %></strong></td>
														<%else%>
															<font color="#990000" size="2"><strong>Reprobado por Inasistencia</strong></font>
														<%end if%>	
								</tr>
						        </table>
						   </td>
						  </tr>
					   </table>
					 </td>
                  </tr>
				  <tr><td><hr></td></tr>
				  <%wend
				  end if%>
                </table>
              <br>
			  <input type="hidden" name="b[0][pers_nrut]" value="<%=q_pers_nrut%>"> 
              <input name="b[0][pers_xdv]" type="hidden" value="<%=q_pers_xdv%>">
			  <input name="b[0][peri_ccod]" type="hidden" value="<%=q_peri_ccod%>">
			 </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="24%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%'f_botonera.DibujaBoton "excel"%></div></td>
                  <td><div align="center"><%f_botonera.DibujaBoton "salir"%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="76%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
