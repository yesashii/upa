<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Clasificacion por grado academico"
'response.End()
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion

session("pagina_anterior")= "2"

'------------------------------------------función para buscar la cantidad de docentes----------------------------------
Function Cantidad_docentes(sede,grado,tipo_jornada,sexo)
'-------------------------debemos buscar solo los dcentes pertenecientes a un solo grado, vale decir un doctor que tambien tiene un magister
'-----------------------------------------solo es considerado como doctor no como magister
if grado= 5 then
	filtro_estricto = " "
elseif grado=4 then 
	filtro_estricto = "  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5) " & vbCrLf 	
elseif grado=3 then 
	filtro_estricto = "  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (4,5)) " & vbCrLf 	
elseif grado=2 then 
	filtro_estricto = "  " & vbCrLf 	
elseif grado=1 then 
	filtro_estricto = "  and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (2)) " & vbCrLf 	
elseif grado =0 then
	filtro_estricto1 = "  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,5)) " & vbCrLf
	filtro_estricto2 = "  and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2)) " & vbCrLf 	
end if
'dependiendo del tipo de  jornada debemos buscar a los docentes cuyas horas esten dentro del criterio asignado.
if tipo_jornada = 1 then
    filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod) >= 33"  
elseif tipo_jornada = 2 then
	filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod) <= 32"  
elseif tipo_jornada = 3  then
    filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod) <= 19"  
end if

if sede = 2 then
	filtro_sede= " in ('1','2')"
else
	filtro_sede= " = '"&sede&"'"
end if

if grado > 2 then

consulta_Cantidad = " select count(distinct c.pers_ncorr) "& vbCrLf &_ 
					" from secciones a join bloques_horarios b "& vbCrLf &_
				    " 	on  a.secc_ccod = b.secc_ccod "& vbCrLf &_
					" join bloques_profesores c "& vbCrLf &_
					"   on  b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
					" join grados_profesor d "& vbCrLf &_
				    "   on  c.pers_ncorr = d.pers_ncorr "& vbCrLf &_
					" join personas e "& vbCrLf &_
				    "   on c.pers_ncorr = e.pers_ncorr    "& vbCrLf &_
					" where cast(d.grac_ccod as varchar)='"& grado&"' and c.tpro_ccod=1"& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					" "&filtro_estricto& vbCrLf &_
					" and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" and cast(e.sexo_ccod as varchar)='"&sexo&"'" 
Cantidad_docentes= conexion.consultaUno(consulta_cantidad)					

elseif grado > 0 and grado <= 2 then

consulta_Cantidad = " select count(distinct c.pers_ncorr) as cantidad_doctores "& vbCrLf &_
					" from secciones a join bloques_horarios b "& vbCrLf &_
					"    on  a.secc_ccod = b.secc_ccod "& vbCrLf &_
					" join bloques_profesores c "& vbCrLf &_
				    "    on  b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
					" join curriculum_docente d "& vbCrLf &_
				    "    on  c.pers_ncorr = d.pers_ncorr "& vbCrLf &_
					" join personas e "& vbCrLf &_
				    "    on c.pers_ncorr = e.pers_ncorr    "& vbCrLf &_
					" where cast(d.grac_ccod as varchar)='"&grado&"' and c.tpro_ccod=1"& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					" "&filtro_estricto& vbCrLf &_
					" and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" and not exists (select 1 from grados_profesor gr where gr.pers_ncorr = c.pers_ncorr and gr.grac_ccod in (3,4,5)) "& vbCrLf &_
				    " and cast(e.sexo_ccod as varchar)='"&sexo&"'"
Cantidad_docentes= conexion.consultaUno(consulta_cantidad)

else
consulta_Cantidad_sin_grado = " select count(distinct c.pers_ncorr) "& vbCrLf &_ 
					" from secciones a join bloques_horarios b "& vbCrLf &_
				    " 	on  a.secc_ccod = b.secc_ccod "& vbCrLf &_
					" join bloques_profesores c "& vbCrLf &_
					"   on  b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
					" join grados_profesor d "& vbCrLf &_
				    "   on  c.pers_ncorr = d.pers_ncorr "& vbCrLf &_
					" join personas e "& vbCrLf &_
				    "   on c.pers_ncorr = e.pers_ncorr    "& vbCrLf &_
					" where cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					" "&filtro_estricto1& vbCrLf &_
					" "&filtro_estricto2& vbCrLf &_
					" and cast(e.sexo_ccod as varchar)='"&sexo&"' and c.tpro_ccod=1"
						
consulta_Cantidad_sin_titulo = " select count(distinct c.pers_ncorr) as cantidad_doctores "& vbCrLf &_
					" from secciones a join bloques_horarios b "& vbCrLf &_
					"    on  a.secc_ccod = b.secc_ccod "& vbCrLf &_
					" join bloques_profesores c "& vbCrLf &_
				    "    on  b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
					" join curriculum_docente d "& vbCrLf &_
				    "    on  c.pers_ncorr = d.pers_ncorr "& vbCrLf &_
					" join personas e "& vbCrLf &_
				    "    on c.pers_ncorr = e.pers_ncorr    "& vbCrLf &_
					" where not exists (select 1 from grados_profesor gr where gr.pers_ncorr = c.pers_ncorr) "& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					" "&filtro_estricto2& vbCrLf &_
					" and cast(a.sede_ccod as varchar)"&filtro_sede& vbCrLf &_
					" and cast(e.sexo_ccod as varchar)='"&sexo&"' and c.tpro_ccod=1"		

     Cantidad_docentes = cint(conexion.consultaUno(consulta_Cantidad_sin_grado))+cint(conexion.consultaUno(consulta_Cantidad_sin_titulo))
end if


End Function

'------------------------------------------------------------------------------------------------------------------------------------
'-----------------------------------Funcion para buscar el total de horas de los docentes--------------------------------------------
'------------------------------------------función para buscar la cantidad de docentes----------------------------------
Function Cantidad_horas_docentes(sede,grado,tipo_jornada)
'-------------------------debemos buscar solo los dcentes pertenecientes a un solo grado, vale decir un doctor que tambien tiene un magister
'-----------------------------------------solo es considerado como doctor no como magister
if grado= 5 then
	filtro_estricto = " "
elseif grado=4 then 
	filtro_estricto = "  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5) " & vbCrLf 	
elseif grado=3 then 
	filtro_estricto = "  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (4,5)) " & vbCrLf 	
elseif grado=2 then 
	filtro_estricto = "  " & vbCrLf 	
elseif grado=1 then 
	filtro_estricto = "  and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (2)) " & vbCrLf 	
elseif grado =0 then
	filtro_estricto1 = "  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,5)) " & vbCrLf
	filtro_estricto2 = "  and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2)) " & vbCrLf 	
end if
'dependiendo del tipo de  jornada debemos buscar a los docentes cuyas horas esten dentro del criterio asignado.
if tipo_jornada = 1 then
    filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod) >= 33"  
elseif tipo_jornada = 2 then
	filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod) <= 32"  
elseif tipo_jornada = 3  then
    filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod) <= 19"  
end if

if sede = 2 then
	filtro_sede= " in ('1','2')"
else
	filtro_sede= " = '"&sede&"'"
end if

if grado > 2 then

consulta_Cantidad = " select cast(isnull(sum(horas * 45 / 60),0) as numeric) from (select distinct c.pers_ncorr,a.sede_ccod "& vbCrLf &_ 
					" from secciones a join bloques_horarios b "& vbCrLf &_
				    " 	on  a.secc_ccod = b.secc_ccod "& vbCrLf &_
					" join bloques_profesores c "& vbCrLf &_
					"   on  b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
					" join grados_profesor d "& vbCrLf &_
				    "   on  c.pers_ncorr = d.pers_ncorr "& vbCrLf &_
					" join personas e "& vbCrLf &_
				    "   on c.pers_ncorr = e.pers_ncorr    "& vbCrLf &_
					" where cast(d.grac_ccod as varchar)='"& grado&"' and c.tpro_ccod=1"& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					" "&filtro_estricto& vbCrLf &_
					" and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" )a, horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					" and hdc.sede_ccod= a.sede_ccod" 
Cantidad_horas_docentes= conexion.consultaUno(consulta_cantidad)					

elseif grado > 0 and grado <= 2 then

consulta_Cantidad = " select cast(isnull(sum(horas * 45 / 60 ),0) as numeric) from (select distinct c.pers_ncorr,a.sede_ccod "& vbCrLf &_
					" from secciones a join bloques_horarios b "& vbCrLf &_
					"    on  a.secc_ccod = b.secc_ccod "& vbCrLf &_
					" join bloques_profesores c "& vbCrLf &_
				    "    on  b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
					" join curriculum_docente d "& vbCrLf &_
				    "    on  c.pers_ncorr = d.pers_ncorr "& vbCrLf &_
					" join personas e "& vbCrLf &_
				    "    on c.pers_ncorr = e.pers_ncorr    "& vbCrLf &_
					" where cast(d.grac_ccod as varchar)='"&grado&"' and c.tpro_ccod=1 "& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					" "&filtro_estricto& vbCrLf &_
					" and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" and not exists (select 1 from grados_profesor gr where gr.pers_ncorr = c.pers_ncorr and gr.grac_ccod in (3,4,5)) "& vbCrLf &_
				    " )a,horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					" and hdc.sede_ccod= a.sede_ccod" 
Cantidad_horas_docentes= conexion.consultaUno(consulta_cantidad)

else
consulta_Cantidad_sin_grado = " select cast(isnull(sum(horas * 45 / 60),0) as numeric) from (select distinct c.pers_ncorr,a.sede_ccod "& vbCrLf &_ 
					" from secciones a join bloques_horarios b "& vbCrLf &_
				    " 	on  a.secc_ccod = b.secc_ccod "& vbCrLf &_
					" join bloques_profesores c "& vbCrLf &_
					"   on  b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
					" join grados_profesor d "& vbCrLf &_
				    "   on  c.pers_ncorr = d.pers_ncorr "& vbCrLf &_
					" join personas e "& vbCrLf &_
				    "   on c.pers_ncorr = e.pers_ncorr    "& vbCrLf &_
					" where cast(a.sede_ccod as varchar) "&filtro_sede& " and c.tpro_ccod=1" & vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					" "&filtro_estricto1& vbCrLf &_
					" "&filtro_estricto2& vbCrLf &_
					" )a,horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					" and hdc.sede_ccod= a.sede_ccod" 
						
consulta_Cantidad_sin_titulo = " select cast(isnull(sum(horas * 45 / 60),0) as numeric) from (select distinct c.pers_ncorr,a.sede_ccod "& vbCrLf &_
					" from secciones a join bloques_horarios b "& vbCrLf &_
					"    on  a.secc_ccod = b.secc_ccod "& vbCrLf &_
					" join bloques_profesores c "& vbCrLf &_
				    "    on  b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
					" join curriculum_docente d "& vbCrLf &_
				    "    on  c.pers_ncorr = d.pers_ncorr "& vbCrLf &_
					" join personas e "& vbCrLf &_
				    "    on c.pers_ncorr = e.pers_ncorr    "& vbCrLf &_
					" where not exists (select 1 from grados_profesor gr where gr.pers_ncorr = c.pers_ncorr) and c.tpro_ccod=1"& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					" "&filtro_estricto2& vbCrLf &_
					" and cast(a.sede_ccod as varchar)"&filtro_sede& vbCrLf &_
					" )a,horas_docentes_seccion_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					" and hdc.sede_ccod= a.sede_ccod" 		

     Cantidad_horas_docentes = cint(conexion.consultaUno(consulta_Cantidad_sin_grado))+cint(conexion.consultaUno(consulta_Cantidad_sin_titulo))
end if
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
 f_busqueda.Carga_Parametros "docentes_x_sede.xml", "f_busqueda"
 
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
	<%if sede_ccod<>"" then%>
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
            <td><div align="center">
                     
                    <br>
					<%if sede_ccod=2 then%>
					<font color="#0000FF">
					* Los Datos de Providencia se suman a la sede Central ya que por encontrarse en la misma ciudad tiene el carácter de Campus.
                    </font>
					<%end if%>
					<br>
                  
                  </div>
              <form name="edicion">
                <br>
				<!---------------------------------OTRA TABLA-------------------------------------->
				<tr>
                    <td align="center">
						    <table width="100%" class="v1" border="1" cellpadding="0" cellspacing="0" borderColor="#999999" bgColor="#adadad">
                              <!--DWLayoutTable-->
                              <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td colspan="3" valign="bottom"><FONT color="#333333">
                                <div align="center"><strong>Docentes Programa de la Sede <%=sede_tdesc%></strong></div></font></td>
                              </tr>
							  <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td colspan="3" valign="bottom"><FONT color="#333333"><div align="center">AÑO 2005</div></font></td>
                              </tr>
							  
							  <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td width="50%" rowspan="1" valign="bottom"><FONT color="#333333"><div align="center">&nbsp;</div></font></td>
                                <td width="25%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Hombres</div></font></td>
                                <td width="25%" colspan="1" valign="top"><FONT color="#333333"><div align="center">Mujeres</div></font></td>
                              </tr>
							  <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td colspan="3" valign="bottom"><FONT color="#333333"><div align="center">Contrato Jornada Completa</div></font></td>
                              </tr>
							  <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Doctores</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=5&tipo_jornada=1&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,1,1)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=5&tipo_jornada=1&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,1,2)%></div></td>
							 </tr>
							<tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Magíster</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=4&tipo_jornada=1&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,1,1)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=4&tipo_jornada=1&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,1,2)%></div></td>
							 </tr>
							<tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Licenciados</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=3&tipo_jornada=1&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,1,1)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=3&tipo_jornada=1&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,1,2)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Profesionales</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=2&tipo_jornada=1&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,1,1)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=2&tipo_jornada=1&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,1,2)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Téc. Nivel Súperior</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=1&tipo_jornada=1&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,1,1)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=1&tipo_jornada=1&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,1,2)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Sin Título o grado</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=0&tipo_jornada=1&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,1,1)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=0&tipo_jornada=1&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,1,2)%></div></td>
							 </tr>
							 <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td colspan="3" valign="bottom"><FONT color="#333333"><div align="center">Contrato Media Jornada</div></font></td>
                              </tr>
							  <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Doctores</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=5&tipo_jornada=2&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,2,1)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=5&tipo_jornada=2&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,2,2)%></div></td>
							 </tr>
							<tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Magíster</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=4&tipo_jornada=2&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,2,1)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=4&tipo_jornada=2&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,2,2)%></div></td>
							 </tr>
							<tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Licenciados</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=3&tipo_jornada=2&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,2,1)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=3&tipo_jornada=2&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,2,2)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Profesionales</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=2&tipo_jornada=2&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,2,1)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=2&tipo_jornada=2&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,2,2)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Téc. Nivel Súperior</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=1&tipo_jornada=2&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,2,1)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=1&tipo_jornada=2&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,2,2)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Sin Título o grado</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=0&tipo_jornada=2&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,2,1)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=0&tipo_jornada=2&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,2,2)%></div></td>
							 </tr>
							 <tr borderColor="#999999" bgColor="#c4d7ff">
                                <td colspan="3" valign="bottom"><FONT color="#333333"><div align="center">Contrato Jornada Hora</div></font></td>
                              </tr>
							  <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Doctores</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=5&tipo_jornada=3&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,3,1)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=5&tipo_jornada=3&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,5,3,2)%></div></td>
							 </tr>
							<tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Magíster</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=4&tipo_jornada=3&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,3,1)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=4&tipo_jornada=3&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,4,3,2)%></div></td>
							 </tr>
							<tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Licenciados</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=3&tipo_jornada=3&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,3,1)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=3&tipo_jornada=3&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,3,3,2)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Profesionales</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=2&tipo_jornada=3&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,3,1)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=2&tipo_jornada=3&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,2,3,2)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Téc. Nivel Súperior</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=1&tipo_jornada=3&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,3,1)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=1&tipo_jornada=3&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,1,3,2)%></div></td>
							 </tr>
							 <tr bgcolor="#FFFFFF"> 
										<td><div align="left" class="Estilo2">Sin Título o grado</div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=0&tipo_jornada=3&sexo=1", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,3,1)%></div></td>
										<td class='click' onClick='irA("detalle_docentes_x_sede.asp?sede_ccod=<%=sede_ccod%>&grado=0&tipo_jornada=3&sexo=2", "2", 600, 400)'><div align="center" class="Estilo4"><%=Cantidad_docentes(sede_ccod,0,3,2)%></div></td>
							 </tr>							
						  </table>
					</td>
				</tr>
				<!----------------------------------FIN TABLA-------------------------------------->			
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
                   <td><div align="center"><%botonera.DibujaBoton "lanzadera"%></div></td>
				   <td width="14%"> <div align="center">  <%
					                       botonera.agregabotonparam "excel", "url", "docentes_x_sede_y_grado_excel.asp?sede_ccod="&sede_ccod
										   botonera.dibujaboton "excel"
										%>
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
	<%end if%>
	<div align="right">* Las horas son medidas de forma cronológica &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
