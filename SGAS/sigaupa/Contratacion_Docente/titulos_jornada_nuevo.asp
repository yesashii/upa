<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Clasificacion por título"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


periodo = negocio.obtenerPeriodoAcademico("Postulacion")
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "grados_jornada.xml", "botonera"

'-----------------------------------------------------------------------
carr_ccod = request.querystring("busqueda[0][carr_ccod]")
jorn_ccod = request.querystring("busqueda[0][jorn_ccod]")
sede_ccod = request.querystring("busqueda[0][sede_ccod]")
'response.Write(carr_ccod)
sede = sede_ccod
carrera = conexion.consultauno("SELECT carr_tdesc FROM carreras WHERE carr_ccod = '" & carr_ccod & "'")
'----------------------------------------------------------------------- 
'------------------------------------------función para buscar la cantidad de docentes----------------------------------
Function Cantidad_docentes(sede,grado,tipo_jornada,carrera,jornada)
'response.Write("entre")
'-------------------------debemos buscar solo los dcentes pertenecientes a un solo grado, vale decir un doctor que tambien tiene un magister
'-----------------------------------------solo es considerado como doctor no como magister
if grado=2 then 
	filtro_estricto = "  " & vbCrLf 	
elseif grado=1 then 
	filtro_estricto = "  and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (2)) " & vbCrLf 	
elseif grado =0 then
	filtro_estricto1 = "  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,5)) " & vbCrLf
	filtro_estricto2 = "  and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2)) " & vbCrLf 	
end if
'dependiendo del tipo de  jornada debemos buscar a los docentes cuyas horas esten dentro del criterio asignado.
if tipo_jornada = 1 then
    filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) >= 33"  
elseif tipo_jornada = 2 then
	filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) <= 32"  
elseif tipo_jornada = 3  then
    filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) <= 19"  
end if

'if sede = 2 then
'	filtro_sede= " in ('1','2')"
'else
	filtro_sede= " = '"&sede&"'"
'end if

if grado > 0 and grado <= 2 then

consulta_Cantidad = " select count(distinct c.pers_ncorr) as cantidad_doctores "& vbCrLf &_
					" from secciones a join bloques_horarios b "& vbCrLf &_
					"    on  a.secc_ccod = b.secc_ccod "& vbCrLf &_
					" join bloques_profesores c "& vbCrLf &_
				    "    on  b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
					" join curriculum_docente d "& vbCrLf &_
				    "    on  c.pers_ncorr = d.pers_ncorr "& vbCrLf &_
					" where cast(d.grac_ccod as varchar)='"&grado&"' and c.tpro_ccod=1"& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					" "&filtro_estricto& vbCrLf &_
					" and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" and cast(a.carr_ccod as varchar) ='"&carrera&"'"&vbCrLf &_
					" and cast(a.jorn_ccod as varchar) ='"&jornada&"'"&vbCrLf &_
					" and not exists (select 1 from grados_profesor gr where gr.pers_ncorr = c.pers_ncorr and gr.grac_ccod in (3,4,5)) "& vbCrLf
				    
Cantidad_docentes= conexion.consultaUno(consulta_cantidad)

else
						
consulta_Cantidad_sin_titulo = " select count(distinct c.pers_ncorr) as cantidad_doctores "& vbCrLf &_
					" from secciones a join bloques_horarios b "& vbCrLf &_
					"    on  a.secc_ccod = b.secc_ccod "& vbCrLf &_
					" join bloques_profesores c "& vbCrLf &_
				    "    on  b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
					" join curriculum_docente d "& vbCrLf &_
				    "    on  c.pers_ncorr = d.pers_ncorr "& vbCrLf &_
					" where not exists (select 1 from grados_profesor gr where gr.pers_ncorr = c.pers_ncorr) and c.tpro_ccod=1"& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					" "&filtro_estricto2& vbCrLf &_
					" and cast(a.sede_ccod as varchar)"&filtro_sede& vbCrLf &_
					" and cast(a.carr_ccod as varchar)='"&carrera&"'"&vbCrLf &_
					" and cast(a.jorn_ccod as varchar)= '"&jornada&"'"&vbCrLf


     Cantidad_docentes = cint(conexion.consultaUno(consulta_Cantidad_sin_titulo))
end if

End Function

'------------------------------------------------------------------------------------------------------------------------------------
'-----------------------------------Funcion para buscar el total de horas de los docentes--------------------------------------------
'------------------------------------------función para buscar la cantidad de docentes----------------------------------
Function Cantidad_horas_docentes(sede,grado,tipo_jornada,carrera,jornada)
'-------------------------debemos buscar solo los dcentes pertenecientes a un solo grado, vale decir un doctor que tambien tiene un magister
'-----------------------------------------solo es considerado como doctor no como magister
if grado=2 then 
	filtro_estricto = "  " & vbCrLf 	
elseif grado=1 then 
	filtro_estricto = "  and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (2)) " & vbCrLf 	
elseif grado =0 then
	filtro_estricto1 = "  and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (3,4,5)) " & vbCrLf
	filtro_estricto2 = "  and not exists(select 1 from curriculum_docente r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod in (1,2)) " & vbCrLf 	
end if
'dependiendo del tipo de  jornada debemos buscar a los docentes cuyas horas esten dentro del criterio asignado.
if tipo_jornada = 1 then
    filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) >= 33"  
elseif tipo_jornada = 2 then
	filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) >= 20 and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) <= 32"  
elseif tipo_jornada = 3  then
    filtro_horas = " and  (select sum(prof_nhoras) from horas_docentes_carrera_final hdc where hdc.pers_ncorr=c.pers_ncorr and hdc.sede_ccod= a.sede_ccod and hdc.carr_ccod= a.carr_ccod and hdc.jorn_ccod= a.jorn_ccod) <= 19"  
end if

'if sede = 2 then
'	filtro_sede= " in ('1','2')"
'else
	filtro_sede= " = '"&sede&"'"
'end if

if grado > 0 and grado <= 2 then

consulta_Cantidad = " select cast(isnull(sum(prof_nhoras),0) as numeric) from (select distinct c.pers_ncorr,a.sede_ccod,a.carr_ccod,a.jorn_ccod "& vbCrLf &_
					" from secciones a join bloques_horarios b "& vbCrLf &_
					"    on  a.secc_ccod = b.secc_ccod "& vbCrLf &_
					" join bloques_profesores c "& vbCrLf &_
				    "    on  b.bloq_ccod=c.bloq_ccod "& vbCrLf &_
					" join curriculum_docente d "& vbCrLf &_
				    "    on  c.pers_ncorr = d.pers_ncorr "& vbCrLf &_
					" join personas e "& vbCrLf &_
				    "    on c.pers_ncorr = e.pers_ncorr    "& vbCrLf &_
					" where cast(d.grac_ccod as varchar)='"&grado&"' "& vbCrLf &_
					" "&filtro_horas& vbCrLf &_
					" "&filtro_estricto& vbCrLf &_
					" and cast(a.sede_ccod as varchar) "&filtro_sede& vbCrLf &_
					" and cast(a.carr_ccod as varchar) ='"&carrera&"' and c.tpro_ccod=1"&vbCrLf &_
					" and cast(a.jorn_ccod as varchar) ='"&jornada&"'"&vbCrLf &_
					" and not exists (select 1 from grados_profesor gr where gr.pers_ncorr = c.pers_ncorr and gr.grac_ccod in (3,4,5)) "& vbCrLf &_
				    " )a,horas_docentes_carrera_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					" and hdc.sede_ccod= a.sede_ccod" & vbCrLf &_
					" and hdc.carr_ccod= a.carr_ccod" & vbCrLf &_
					" and hdc.jorn_ccod= a.jorn_ccod" 
Cantidad_horas_docentes= conexion.consultaUno(consulta_cantidad)

else
						
consulta_Cantidad_sin_titulo = " select cast(isnull(sum(prof_nhoras),0) as numeric) from (select distinct c.pers_ncorr,a.sede_ccod,a.carr_ccod,a.jorn_ccod "& vbCrLf &_
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
					" and cast(a.carr_ccod as varchar)='"&carrera&"' and c.tpro_ccod=1" &vbCrLf &_
					" and cast(a.jorn_ccod as varchar)='"&jornada&"'" &vbCrLf &_
					" )a,horas_docentes_carrera_final hdc "& vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr "& vbCrLf &_
					" and hdc.sede_ccod= a.sede_ccod" & vbCrLf &_
					" and hdc.carr_ccod= a.carr_ccod" & vbCrLf &_
					" and hdc.jorn_ccod= a.jorn_ccod" 		

     Cantidad_horas_docentes = cint(conexion.consultaUno(consulta_Cantidad_sin_titulo))
end if
End Function
'------------------------------------------------------------------------------------------------------------------------------------


 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "grados_jornada.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "Select '"&sede_ccod&"' as sede_ccod,'"&carr_ccod&"' as carr_ccod, '"&jorn_ccod&"' as jorn_ccod"
 'f_busqueda.Consultar "select ''"

  consulta_carreras= "select distinct rtrim(ltrim(c.carr_ccod)) as carr_ccod,c.carr_tdesc,d.jorn_ccod,d.jorn_tdesc,e.sede_ccod,e.sede_tdesc"& vbCrLf &_
					" from ofertas_Academicas a, especialidades b, carreras c, jornadas d, sedes e "& vbCrLf &_
					" where a.espe_ccod=b.espe_ccod  and a.sede_ccod=e.sede_ccod"& vbCrLf &_
				    " and b.carr_ccod=c.carr_ccod and a.jorn_ccod=d.jorn_ccod"& vbCrLf &_
					" and cast(a.peri_ccod as varchar)='"&periodo&"' and c.tcar_ccod=1"& vbCrLf &_
				    " order by c.carr_tdesc,d.jorn_tdesc asc"
					
 'f_busqueda.agregaCampoParam "carr_ccod", "destino",consulta_carreras
 'f_busqueda.AgregaCampoCons "carr_ccod", carr_ccod 
 f_busqueda.inicializaListaDependiente "lBusqueda", consulta_carreras
 f_busqueda.Siguiente

'---------------------------------------------------------------------------------------------------
set f_grados = new CFormulario
f_grados.Carga_Parametros "grados_jornada.xml", "f_grados"
f_grados.Inicializar conexion

'----------------------------------------buscamos los valores-------------------------------------------------------------
'-----------Profesionales--------------------------------------------------------------------
if not esVacio(sede_ccod) and not esVacio(carr_ccod) and not esvacio(jorn_ccod) then
	cant_profesional_c = Cantidad_docentes(sede_ccod,2,1,carr_ccod,jorn_ccod)
	horas_profesional_c = Cantidad_horas_docentes(sede_ccod,2,1,carr_ccod,jorn_ccod)
	cant_profesional_m = Cantidad_docentes(sede_ccod,2,2,carr_ccod,jorn_ccod)
	horas_profesional_m = Cantidad_horas_docentes(sede_ccod,2,2,carr_ccod,jorn_ccod)
	cant_profesional_h = Cantidad_docentes(sede_ccod,2,3,carr_ccod,jorn_ccod)
	horas_profesional_h = Cantidad_horas_docentes(sede_ccod,2,3,carr_ccod,jorn_ccod)
	total_cant_profesional = cint(cant_profesional_c) + cint(cant_profesional_m) + cint(cant_profesional_h)
	total_horas_profesional = cint(horas_profesional_c) + cint(horas_profesional_m) + cint(horas_profesional_h)
	'-----------Tecnico--------------------------------------------------------------------
	cant_tecnico_c = Cantidad_docentes(sede_ccod,1,1,carr_ccod,jorn_ccod)
	horas_tecnico_c = Cantidad_horas_docentes(sede_ccod,1,1,carr_ccod,jorn_ccod)
	cant_tecnico_m = Cantidad_docentes(sede_ccod,1,2,carr_ccod,jorn_ccod)
	horas_tecnico_m = Cantidad_horas_docentes(sede_ccod,1,2,carr_ccod,jorn_ccod)
	cant_tecnico_h = Cantidad_docentes(sede_ccod,1,3,carr_ccod,jorn_ccod)
	horas_tecnico_h = Cantidad_horas_docentes(sede_ccod,1,3,carr_ccod,jorn_ccod)
	total_cant_tecnico = cint(cant_tecnico_c) + cint(cant_tecnico_m) + cint(cant_tecnico_h)
	total_horas_tecnico = cint(horas_tecnico_c) + cint(horas_tecnico_m) + cint(horas_tecnico_h)
	'-----------Sin titulos--------------------------------------------------------------------
	cant_sin_c = Cantidad_docentes(sede_ccod,0,1,carr_ccod,jorn_ccod)
	horas_sin_c = Cantidad_horas_docentes(sede_ccod,0,1,carr_ccod,jorn_ccod)
	cant_sin_m = Cantidad_docentes(sede_ccod,0,2,carr_ccod,jorn_ccod)
	horas_sin_m = Cantidad_horas_docentes(sede_ccod,0,2,carr_ccod,jorn_ccod)
	cant_sin_h = Cantidad_docentes(sede_ccod,0,3,carr_ccod,jorn_ccod)
	horas_sin_h = Cantidad_horas_docentes(sede_ccod,0,3,carr_ccod,jorn_ccod)
	total_cant_sin = cint(cant_sin_c) + cint(cant_sin_m) + cint(cant_sin_h)
	total_horas_sin = cint(horas_sin_c) + cint(horas_sin_m) + cint(horas_sin_h)
	'---------------------totales----------------------------------------------------------------
	total_cantidad_c = cint(cant_profesional_c) + cint(cant_tecnico_c)  + cint(cant_sin_c)
	total_horas_c = cint(horas_profesional_c) + cint(horas_tecnico_c) + cint(horas_sin_c)
   	total_cantidad_m = cint(cant_profesional_m) + cint(cant_tecnico_m) + cint(cant_sin_m)
	total_horas_m = cint(horas_profesional_m) + cint(horas_tecnico_m)  + cint(horas_sin_m)
	total_cantidad_h = cint(cant_profesional_h) + cint(cant_tecnico_h) + cint(cant_sin_h)
	total_horas_h = cint(horas_profesional_h) + cint(horas_tecnico_h)  + cint(horas_sin_h)
 
   	total_cantidad = cint(total_cantidad_c) + cint(total_cantidad_m) + cint(total_cantidad_h)
	total_horas = cint(total_horas_c) + cint(total_horas_m) + cint(total_horas_h)

	'-------------------------------------fin de la cosecha de valores--------------------------------------------------------	
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
colores = Array(3);
	colores[0] = '';
	//colores[1] = '#97AAC6';
	//colores[2] = '#C0C0C0';
	colores[1] = '#FFECC6';
	colores[2] = '#FFECC6';
function cargar()
{
  buscador.action="grados_jornada_nuevo.asp?busqueda[0][carr_ccod]=" + document.buscador.elements["busqueda[0][carr_ccod]"].value;
  buscador.method="POST";
  buscador.submit();
}
</script>
<% f_busqueda.generaJS %>
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
                                <td width="83%"><%f_busqueda.dibujaCampoLista "lBusqueda", "sede_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="12%"><div align="left">Carrera</div></td>
                                <td width="5%"><div align="center">:</div></td>
                                <td width="83%"><%f_busqueda.dibujaCampoLista "lBusqueda", "carr_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="12%"><div align="left">Jornada</div></td>
                                <td width="5%"><div align="center">:</div></td>
                                <td width="83%"><%f_busqueda.dibujaCampoLista "lBusqueda", "jorn_ccod"%></td>
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
            <td><div align="center">
                     
                    <br>
                    <br><%pagina.DibujarSubtitulo carrera%>
                  
                  </div>
              <form name="edicion">
                <br>
				<!---------------------------------OTRA TABLA-------------------------------------->
				<tr>
                    <td align="center">
						    <table width="650" class="v1" border="1" cellpadding="0" cellspacing="0" borderColor="#999999" bgColor="#adadad">
                              <!--DWLayoutTable-->
                              <tr borderColor="#999999" bgColor="#c4d7ff">
                                <th width="100" rowspan="1" valign="bottom"><FONT color="#333333"><div align="center"><strong>DOCENTES</strong></div></font></th>
                                <th width="135" colspan="2" valign="top"><FONT color="#333333"><div align="center"><strong>PROFESIONALES</strong></div></font></th>
                                <th width="135" colspan="2" valign="top"><FONT color="#333333"><div align="center"><strong>TECNICOS</strong></div></font></th>
                                <th width="135" colspan="2" valign="top"><FONT color="#333333"><div align="center"><strong>SIN TITULOS</strong></div></font></th>
								<th width="145" colspan="2" valign="top"><FONT color="#333333"><div align="center"><strong>TOTAL</strong></div></font></th>
                              </tr>
							  <tr borderColor="#999999" bgColor="#c4d7ff">
                                <th><FONT color="#333333"><div align="center">JORNADA</div></font></th>
								<th><FONT color="#333333"><div align="center">N°</div></font></th>
                                <th><FONT color="#333333"><div align="center">HORAS</div></font></th>
                                <th><FONT color="#333333"><div align="center">N°</div></font></th>
                                <th><FONT color="#333333"><div align="center">HORAS</div></font></th>
								<th><FONT color="#333333"><div align="center">N°</div></font></th>
                                <th><FONT color="#333333"><div align="center">HORAS</div></font></th>
                                <th><FONT color="#333333"><div align="center"><strong>N°</strong></div></font></th>
                                <th><FONT color="#333333"><div align="center"><strong>HORAS</strong></div></font></th>
                              </tr>
							  <tr bgcolor="#FFFFFF">
										<td  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center">COMPLETA</div></td>
                                		<td class='click' onClick='irA("detalle_docentes_titulos_nuevos.asp?tipo=2&jornada=1&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&sede=<%=sede_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=Cant_profesional_c%></div></td>
                                		<td  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=horas_profesional_c%></div></td>
										<td class='click' onClick='irA("detalle_docentes_titulos_nuevos.asp?tipo=1&jornada=1&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&sede=<%=sede_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=Cant_tecnico_c%></div></td>
                                		<td  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=horas_tecnico_c%></div></td>
										<td class='click' onClick='irA("detalle_docentes_titulos_nuevos.asp?tipo=0&jornada=1&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&sede=<%=sede_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=Cant_sin_c%></div></td>
                                		<td  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=horas_sin_c%></div></td>
										<td  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=total_cantidad_c%></div></td>
                                		<td  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=total_horas_c%></div></td>
  	                           </tr>
							   <tr bgcolor="#FFFFFF">
										<td  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center">MEDIA</div></td>
                                		<td class='click' onClick='irA("detalle_docentes_titulos_nuevos.asp?tipo=2&jornada=2&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&sede=<%=sede_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=Cant_profesional_m%></div></td>
                                		<td  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=horas_profesional_m%></div></td>
										<td class='click' onClick='irA("detalle_docentes_titulos_nuevos.asp?tipo=1&jornada=2&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&sede=<%=sede_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=Cant_tecnico_m%></div></td>
                                		<td  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=horas_tecnico_m%></div></td>
										<td class='click' onClick='irA("detalle_docentes_titulos_nuevos.asp?tipo=0&jornada=2&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&sede=<%=sede_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=Cant_sin_m%></div></td>
                                		<td  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=horas_sin_m%></div></td>
										<td  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=total_cantidad_m%></div></td>
                                		<td  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=total_horas_m%></div></td>
  	                           </tr>
							   <tr bgcolor="#FFFFFF">
										<td  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center">HORA</div></td>
                                		<td class='click' onClick='irA("detalle_docentes_titulos_nuevos.asp?tipo=2&jornada=3&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&sede=<%=sede_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=Cant_profesional_h%></div></td>
                                		<td  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=horas_profesional_h%></div></td>
										<td class='click' onClick='irA("detalle_docentes_titulos_nuevos.asp?tipo=1&jornada=3&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&sede=<%=sede_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=Cant_tecnico_h%></div></td>
                                		<td  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=horas_tecnico_h%></div></td>
										<td class='click' onClick='irA("detalle_docentes_titulos_nuevos.asp?tipo=0&jornada=3&carr_ccod=<%=carr_ccod%>&jorn_ccod=<%=jorn_ccod%>&sede=<%=sede_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=Cant_sin_h%></div></td>
                                		<td  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=horas_sin_h%></div></td>
										<td  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=total_cantidad_h%></div></td>
                                		<td  onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)'><div align="center"><%=total_horas_h%></div></td>
  	                           </tr>
								<tr bgcolor="#FFFFFF"> 
										<td><div align="right" class="Estilo2"><strong>TOTAL</strong></div></td>
										<td><div align="center" class="Estilo4"><strong><%=total_cant_profesional%></strong></div></td>
										<td><div align="center" class="Estilo4"><strong><%=total_horas_profesional%></strong></div></td>
										<td><div align="center" class="Estilo4"><strong><%=total_cant_tecnico%></strong></div></td>
										<td><div align="center" class="Estilo4"><strong><%=total_horas_tecnico%></strong></div></td>
										<td><div align="center" class="Estilo4"><strong><%=total_cant_sin%></strong></div></td>
										<td><div align="center" class="Estilo4"><strong><%=total_horas_sin%></strong></div></td>
										<td><div align="center" class="Estilo4"><strong><%=total_cantidad%></strong></div></td>
										<td><div align="center" class="Estilo4"><strong><%=total_horas%></strong></div></td>
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
					                       botonera.agregabotonparam "excel", "url", "titulos_jornada_nuevo_excel.asp?carr_ccod="&carr_ccod&"&jorn_ccod="&jorn_ccod&"&sede_ccod="&sede_ccod
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
	<div align="right">* Horas semanales, medidas de forma cronológica &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
