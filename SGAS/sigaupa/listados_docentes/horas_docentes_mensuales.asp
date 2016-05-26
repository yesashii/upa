<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%Server.ScriptTimeOut = 150000
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Clasificacion por grado academico"
'response.End()
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
session("pagina_anterior")= "1"

Function Cantidad_horas_docentes(sede,grado,periodo)
'-------------------------debemos buscar solo los dcentes pertenecientes a un solo grado, vale decir un doctor que tambien tiene un magister
'-----------------------------------------solo es considerado como doctor no como magister
'dependiendo del tipo de  jornada debemos buscar a los docentes cuyas horas esten dentro del criterio asignado.

plec_ccod = conexion.consultaUno("select plec_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")

if plec_ccod = "2" then
	anos_ccod = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
	primer_periodo = conexion.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod&"' and plec_ccod = 1")
	filtro_periodo = "and cast(a.peri_ccod as varchar) = case g.duas_ccod when 3 then '"&primer_periodo&"' else '"&periodo&"' end "
else 
	filtro_periodo = "and cast(a.peri_ccod as varchar) = '"&periodo&"'"	
end if

if sede <> "" then
	filtro_sede= " and a.sede_ccod = '"&sede&"'"
	campos = " c.pers_ncorr,a.sede_ccod "
	filtro_adicional = " and hdc.sede_ccod= a.sede_ccod"
else
	filtro_sede= ""	
	campos = " c.pers_ncorr"
	filtro_adicional = " "
end if

if grado = 5 then

consulta_Cantidad = "  select cast(isnull(sum((horas / case asi.duas_ccod when 1 then 3 when 2 then 5 when 3 then 10 end ) * 45 / 60),0) as numeric) from (select distinct "&campos & vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d, carreras f,asignaturas g  " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					"  and d.egra_ccod in (1,3) and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and f.tcar_ccod = 1 "& filtro_periodo &vbCrLf &_
					" )a, horas_docentes_seccion_final hdc, asignaturas asi "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr and hdc.asig_ccod = asi.asig_ccod "& vbCrLf &_
					" "& filtro_adicional 
Cantidad_horas_docentes= conexion.consultaUno(consulta_cantidad)					

elseif grado = 4  then

consulta_Cantidad = "  select cast(isnull(sum((horas / case asi.duas_ccod when 1 then 3 when 2 then 5 when 3 then 10 end ) * 45 / 60),0) as numeric) from ( select distinct "&campos & vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,carreras f,asignaturas g  " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8) and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and f.tcar_ccod = 1"& filtro_periodo &vbCrLf &_
					" )a, horas_docentes_seccion_final hdc, asignaturas asi "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr and hdc.asig_ccod = asi.asig_ccod "& vbCrLf &_
					" "& filtro_adicional 
					
Cantidad_horas_docentes= conexion.consultaUno(consulta_cantidad)
elseif grado = 3  then

consulta_Cantidad = "  select cast(isnull(sum(horas * 45 / 60),0) as numeric) from ( select distinct "&campos & vbCrLf &_
					"  from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,carreras f,asignaturas g  " & vbCrLf &_
					"  where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					"  and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 3 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					"  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=4 and r.egra_ccod=1)  " & vbCrLf &_
					"  and d.egra_ccod=1 and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and f.tcar_ccod = 1"& filtro_periodo &vbCrLf &_
					" )a, horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					" "& filtro_adicional 
Cantidad_horas_docentes= conexion.consultaUno(consulta_cantidad)

elseif grado = 2  then
consulta_Cantidad = " select cast(isnull(sum(horas * 45 / 60),0) as numeric) " & vbCrLf &_
					"  from (  " & vbCrLf &_
					"  select distinct  "&campos & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,carreras f,asignaturas g  " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					"  and a.carr_ccod=f.carr_ccod and f.tcar_ccod = 1"& filtro_periodo &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)  " & vbCrLf &_
					" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )  " & vbCrLf &_
					" " & vbCrLf &_
					" union all  " & vbCrLf &_
					" select distinct "&campos & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,carreras f ,asignaturas g " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					" and d.grac_ccod = 2  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and f.tcar_ccod = 1"& filtro_periodo &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
					" )a, horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					" "& filtro_adicional
Cantidad_horas_docentes= conexion.consultaUno(consulta_cantidad)

elseif grado = 1  then

consulta_Cantidad = " select cast(isnull(sum(horas * 45 / 60),0) as numeric)  " & vbCrLf &_
					" from (  " & vbCrLf &_
					" select distinct "&campos & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,carreras f,asignaturas g  " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod	and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)  " & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and f.tcar_ccod = 1"& filtro_periodo &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
					" and exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 1 )  " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
					" " & vbCrLf &_
					" union all  " & vbCrLf &_
					" select distinct "&campos & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,carreras  f,asignaturas g " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  " & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) " & vbCrLf &_
					" and d.grac_ccod = 1 and tpro_ccod=1   "&filtro_sede& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and f.tcar_ccod = 1"&filtro_periodo &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)   " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod = 2 )   " & vbCrLf &_
					" )a, horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					" "& filtro_adicional
Cantidad_horas_docentes= conexion.consultaUno(consulta_cantidad)

elseif grado = 0  then

consulta_Cantidad = " select cast(isnull(sum(horas * 45 / 60),0) as numeric) " & vbCrLf &_
					" from ( " & vbCrLf &_
					" select distinct "& campos & vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,carreras f,asignaturas g " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr  and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and f.tcar_ccod = 1"&filtro_periodo &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))   " & vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,8) and r.egra_ccod=1)   " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2) )  " & vbCrLf &_
					"  " & vbCrLf &_
					" union all  " & vbCrLf &_
					" select distinct "&campos& vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, curriculum_docente d,carreras f,asignaturas g " & vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)" & vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and tpro_ccod=1  "&filtro_sede& vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and f.tcar_ccod = 1"&filtro_periodo &vbCrLf &_
					" and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr)  " & vbCrLf &_
					" and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2))  " & vbCrLf &_
					" )a, horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					" "& filtro_adicional
Cantidad_horas_docentes= conexion.consultaUno(consulta_cantidad)

end if
'response.Write("<pre>"&consulta_Cantidad&"</pre>")
End Function

'------------------------------------------------------------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "docentes_x_sede.xml", "botonera"
sede_ccod = request.querystring("busqueda[0][sede_ccod]")
sede_tdesc = conexion.consultaUno("select protic.initcap(sede_tdesc) from sedes where cast(sede_ccod as varchar)= '"&sede_ccod&"'")
'response.Write(carr_ccod)
sede = sede_ccod
carrera = conexion.consultauno("SELECT carr_tdesc FROM carreras WHERE carr_ccod = '" & carr_ccod & "'")
'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "docentes_x_sede.xml", "f_busqueda_nuevo"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "Select '"&sede_ccod&"' as sede_ccod"
 f_busqueda.Siguiente
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
colores = Array(3);
	colores[0] = '';
	//colores[1] = '#97AAC6';
	//colores[2] = '#C0C0C0';
	colores[1] = '#FFECC6';
	colores[2] = '#FFECC6';
function cargar()
{
  buscador.action="grados_jornada.asp?busqueda[0][carr_ccod]=" + document.buscador.elements["busqueda[0][carr_ccod]"].value;
  buscador.method="POST";
  buscador.submit();
}
</script>
<style type="text/css">
<!--
.Estilo2 {color: #000000}
.Estilo3 {font-weight: bold}
.Estilo4 {color: #000000; font-weight: bold; }
-->
</style>
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
                            <table width="100%" border="0">
                              <tr> 
                                <td width="12%"><div align="left">Sede</div></td>
                                <td width="5%"><div align="center">:</div></td>
                                <td width="83%"><%f_busqueda.dibujaCampo("sede_ccod")%></td>
                              </tr>
							  </table>
                          </div></td>
                  <td width="19%"><div align="center"><%botonera.DibujaBoton "buscar"%></div></td>
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
            <td>
              <form name="edicion">
                <br>
				<!---------------------------------OTRA TABLA-------------------------------------->
				<tr>
                    <td align="center">
						    <table width="100%" class="v1" border="1" cellpadding="0" cellspacing="0" borderColor="#999999" bgColor="#adadad">
                              <!--DWLayoutTable-->
                              <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td width="70%" colspan="12" valign="bottom"><FONT color="#333333"><div align="center"><strong>Resumen horas Mensuales Doctores <%=sede_tdesc%></strong></div></font></td>
                              </tr>
							  <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td width="5%" rowspan="1" valign="bottom"><FONT color="#333333"><div align="center">Enero</div></font></td>
								<td width="5%" rowspan="1" valign="bottom"><FONT color="#333333"><div align="center">Febrero</div></font></td>
                                <td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Marzo</div></font></td>
                                <td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Abril</div></font></td>
                                <td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Mayo</div></font></td>
								<td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Junio</div></font></td>
								<td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Julio</div></font></td>
								<td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Agosto</div></font></td>
								<td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Septiembre</div></font></td>
								<td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Octubre</div></font></td>
								<td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Noviebre</div></font></td>
								<td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Diciembre</div></font></td>
                              </tr>
							  <tr bgcolor="#FFFFFF"> 
										<td class='click' bgcolor="#c4d7ff">&nbsp;</td>
										<td class='click' bgcolor="#c4d7ff">&nbsp;</td>
										<td class='click' onClick='irA("detalle_docentes_mensuales.asp?sede_ccod=<%=sede_ccod%>&grado=5&periodo=164", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,164)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_mensuales.asp?sede_ccod=<%=sede_ccod%>&grado=5&periodo=164", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,164)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_mensuales.asp?sede_ccod=<%=sede_ccod%>&grado=5&periodo=164", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,164)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_mensuales.asp?sede_ccod=<%=sede_ccod%>&grado=5&periodo=164", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,164)%></div></td>
 										<td class='click' onClick='irA("detalle_docentes_mensuales.asp?sede_ccod=<%=sede_ccod%>&grado=5&periodo=164", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,164)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_mensuales.asp?sede_ccod=<%=sede_ccod%>&grado=5&periodo=200", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,200)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_mensuales.asp?sede_ccod=<%=sede_ccod%>&grado=5&periodo=200", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,200)%></div></td>
 										<td class='click' onClick='irA("detalle_docentes_mensuales.asp?sede_ccod=<%=sede_ccod%>&grado=5&periodo=200", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,200)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_mensuales.asp?sede_ccod=<%=sede_ccod%>&grado=5&periodo=200", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,200)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_mensuales.asp?sede_ccod=<%=sede_ccod%>&grado=5&periodo=200", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,200)%></div></td>
        					  </tr>
							  <tr bgcolor="#FFFFFF"> 
										<td class='click' bgcolor="#c4d7ff">&nbsp;</td>
										<td class='click' bgcolor="#c4d7ff">&nbsp;</td>
										<td class='click'><div align="center" class="Estilo4">&nbsp;</div></td>
										<td class='click'><div align="center" class="Estilo4">&nbsp;</div></td>
										<td class='click'><div align="center" class="Estilo4">&nbsp;</div></td>
										<td class='click'><div align="center" class="Estilo4">&nbsp;</div></td>
 										<td class='click'><div align="center" class="Estilo4">&nbsp;</div></td>
										<td class='click'><div align="center" class="Estilo4">&nbsp;</div></td>
										<td class='click'><div align="center" class="Estilo4">&nbsp;</div></td>
 										<td class='click' onClick='irA("detalle_docentes_mensuales.asp?sede_ccod=<%=sede_ccod%>&grado=5&periodo=201", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,201)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_mensuales.asp?sede_ccod=<%=sede_ccod%>&grado=5&periodo=201", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,201)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_mensuales.asp?sede_ccod=<%=sede_ccod%>&grado=5&periodo=201", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,5,201)%></div></td>
        					  </tr>
							  <tr bgcolor="#FFFFFF"> 
										<td class='click' bgcolor="#c4d7ff" colspan="2"><strong>Totales</strong></td>
										<td class='click'><div align="center"><%=Cantidad_horas_docentes(sede_ccod,5,164)%></div></td>
										<td class='click'><div align="center"><%=Cantidad_horas_docentes(sede_ccod,5,164)%></div></td>
										<td class='click'><div align="center"><%=Cantidad_horas_docentes(sede_ccod,5,164)%></div></td>
										<td class='click'><div align="center"><%=Cantidad_horas_docentes(sede_ccod,5,164)%></div></td>
 										<td class='click'><div align="center"><%=Cantidad_horas_docentes(sede_ccod,5,164)%></div></td>
										<td class='click'><div align="center"><%=Cantidad_horas_docentes(sede_ccod,5,200)%></div></td>
										<td class='click'><div align="center"><%=Cantidad_horas_docentes(sede_ccod,5,200)%></div></td>
 										<td class='click'><div align="center"><%=clng(Cantidad_horas_docentes(sede_ccod,5,200)) + clng(Cantidad_horas_docentes(sede_ccod,5,201))%></div></td>
										<td class='click'><div align="center"><%=clng(Cantidad_horas_docentes(sede_ccod,5,200)) + clng(Cantidad_horas_docentes(sede_ccod,5,201))%></div></td>
										<td class='click'><div align="center"><%=clng(Cantidad_horas_docentes(sede_ccod,5,200)) + clng(Cantidad_horas_docentes(sede_ccod,5,201))%></div></td>
        					  </tr>
							 
						  </table>
					</td> 
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
                    <td align="center">
						    <table width="100%" class="v1" border="1" cellpadding="0" cellspacing="0" borderColor="#999999" bgColor="#adadad">
                              <!--DWLayoutTable-->
                              <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td width="70%" colspan="12" valign="bottom"><FONT color="#333333"><div align="center"><strong>Resumen horas Mensuales Magister <%=sede_tdesc%></strong></div></font></td>
                              </tr>
							  <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td width="5%" rowspan="1" valign="bottom"><FONT color="#333333"><div align="center">Enero</div></font></td>
								<td width="5%" rowspan="1" valign="bottom"><FONT color="#333333"><div align="center">Febrero</div></font></td>
                                <td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Marzo</div></font></td>
                                <td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Abril</div></font></td>
                                <td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Mayo</div></font></td>
								<td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Junio</div></font></td>
								<td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Julio</div></font></td>
								<td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Agosto</div></font></td>
								<td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Septiembre</div></font></td>
								<td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Octubre</div></font></td>
								<td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Noviebre</div></font></td>
								<td width="10%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Diciembre</div></font></td>
                              </tr>
							  <tr bgcolor="#FFFFFF"> 
										<td class='click' bgcolor="#c4d7ff">&nbsp;</td>
										<td class='click' bgcolor="#c4d7ff">&nbsp;</td>
										<td class='click' onClick='irA("detalle_docentes_mensuales.asp?sede_ccod=<%=sede_ccod%>&grado=4&periodo=164", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,164)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_mensuales.asp?sede_ccod=<%=sede_ccod%>&grado=4&periodo=164", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,164)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_mensuales.asp?sede_ccod=<%=sede_ccod%>&grado=4&periodo=164", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,164)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_mensuales.asp?sede_ccod=<%=sede_ccod%>&grado=4&periodo=164", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,164)%></div></td>
 										<td class='click' onClick='irA("detalle_docentes_mensuales.asp?sede_ccod=<%=sede_ccod%>&grado=4&periodo=164", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,164)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_mensuales.asp?sede_ccod=<%=sede_ccod%>&grado=4&periodo=200", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,200)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_mensuales.asp?sede_ccod=<%=sede_ccod%>&grado=4&periodo=200", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,200)%></div></td>
 										<td class='click' onClick='irA("detalle_docentes_mensuales.asp?sede_ccod=<%=sede_ccod%>&grado=4&periodo=200", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,200)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_mensuales.asp?sede_ccod=<%=sede_ccod%>&grado=4&periodo=200", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,200)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_mensuales.asp?sede_ccod=<%=sede_ccod%>&grado=4&periodo=200", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,200)%></div></td>
        					  </tr>
							  <tr bgcolor="#FFFFFF"> 
										<td class='click' bgcolor="#c4d7ff">&nbsp;</td>
										<td class='click' bgcolor="#c4d7ff">&nbsp;</td>
										<td class='click'><div align="center" class="Estilo4">&nbsp;</div></td>
										<td class='click'><div align="center" class="Estilo4">&nbsp;</div></td>
										<td class='click'><div align="center" class="Estilo4">&nbsp;</div></td>
										<td class='click'><div align="center" class="Estilo4">&nbsp;</div></td>
 										<td class='click'><div align="center" class="Estilo4">&nbsp;</div></td>
										<td class='click'><div align="center" class="Estilo4">&nbsp;</div></td>
										<td class='click'><div align="center" class="Estilo4">&nbsp;</div></td>
 										<td class='click' onClick='irA("detalle_docentes_mensuales.asp?sede_ccod=<%=sede_ccod%>&grado=4&periodo=201", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,201)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_mensuales.asp?sede_ccod=<%=sede_ccod%>&grado=4&periodo=201", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,201)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_mensuales.asp?sede_ccod=<%=sede_ccod%>&grado=4&periodo=201", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_horas_docentes(sede_ccod,4,201)%></div></td>
        					  </tr>
							  <tr bgcolor="#FFFFFF"> 
										<td class='click' bgcolor="#c4d7ff" colspan="2"><strong>Totales</strong></td>
										<td class='click'><div align="center"><%=Cantidad_horas_docentes(sede_ccod,4,164)%></div></td>
										<td class='click'><div align="center"><%=Cantidad_horas_docentes(sede_ccod,4,164)%></div></td>
										<td class='click'><div align="center"><%=Cantidad_horas_docentes(sede_ccod,4,164)%></div></td>
										<td class='click'><div align="center"><%=Cantidad_horas_docentes(sede_ccod,4,164)%></div></td>
 										<td class='click'><div align="center"><%=Cantidad_horas_docentes(sede_ccod,4,164)%></div></td>
										<td class='click'><div align="center"><%=Cantidad_horas_docentes(sede_ccod,4,200)%></div></td>
										<td class='click'><div align="center"><%=Cantidad_horas_docentes(sede_ccod,4,200)%></div></td>
 										<td class='click'><div align="center"><%=clng(Cantidad_horas_docentes(sede_ccod,4,200)) + clng(Cantidad_horas_docentes(sede_ccod,4,201))%></div></td>
										<td class='click'><div align="center"><%=clng(Cantidad_horas_docentes(sede_ccod,4,200)) + clng(Cantidad_horas_docentes(sede_ccod,4,201))%></div></td>
										<td class='click'><div align="center"><%=clng(Cantidad_horas_docentes(sede_ccod,4,200)) + clng(Cantidad_horas_docentes(sede_ccod,4,201))%></div></td>
        					  </tr>
							 
						  </table>
					</td> 
				</tr>
				<tr><td>&nbsp;</td></tr>
				<!----------------------------------FIN TABLA-------------------------------------->			
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
	  <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="11%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                   <td><div align="center"><%botonera.DibujaBoton "lanzadera"%></div></td>
				   <td width="14%"> <div align="center">  <%
				                           if sede_ccod = "" then
					                       botonera.agregabotonparam "excel", "url", "docentes_x_sede_excel.asp"
										   else
										   botonera.agregabotonparam "excel", "url", "docentes_x_sede_excel.asp?sede_ccod="&sede_ccod
										   end if
										   'botonera.dibujaboton "excel"
										%>
					 </div>
                  </td>
                </tr>
              </table>
            </div></td>
            <td width="89%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<div align="right">* Las horas son medidas de forma cronológica &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
