<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeout = 2000 
set pagina = new CPagina
pagina.Titulo = "Estado de resultado - Facultades"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
v_usuario = negocio.ObtenerUsuario()
'response.Write("Usuario: "&Usuario)


'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "estados_resultados.xml", "botonera"
'-----------------------------------------------------------------------


 
'----------------------------------------------------------------------------

set f_ingreso = new CFormulario
f_ingreso.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
f_ingreso.Inicializar conexion


  		 
			sql_ingreso	=   " select b.cod_grupo,descripcion_grupo,b.cod_orden,b.descripcion,   "& vbCrLf &_
							"	sum(isnull(F1,0)) as F1,sum(isnull(F2,0)) as F2,sum(isnull(F3,0)) as F3,sum(isnull(F4,0)) as F4,  "& vbCrLf &_
							"	sum(isnull(F5,0)) as F5,sum(isnull(F6,0)) as F6,sum(isnull(F7,0)) as F7,sum(isnull(F8,0)) as F8,  "& vbCrLf &_
							"	sum(isnull(F9,0)) as F9,sum(isnull(F10,0)) as F10,sum(isnull(F11,0)) as F11,  "& vbCrLf &_
							"	sum(isnull(F1,0)) + sum(isnull(F2,0)) + sum(isnull(F3,0)) + sum(isnull(F4,0))+sum(isnull(F5,0)) + sum(isnull(F6,0)) + sum(isnull(F7,0)) + sum(isnull(F8,0)) + sum(isnull(F9,0)) + sum(isnull(F10,0)) + sum(isnull(F11,0)) as total   "& vbCrLf &_
							"	from  (  "& vbCrLf &_
							"		select cast(cod_dis as numeric) as codigo,   "& vbCrLf &_
							"		case cod_facultad when 1 then cast(sum(total) as numeric) end as F1,  "& vbCrLf &_
							"		case cod_facultad when 2 then cast(sum(total) as numeric) end as F2,  "& vbCrLf &_
							"		case cod_facultad when 3 then cast(sum(total) as numeric) end as F3,  "& vbCrLf &_
							"		case cod_facultad when 4 then cast(sum(total) as numeric) end as F4,  "& vbCrLf &_
							"		case cod_facultad when 5 then cast(sum(total) as numeric) end as F5,  "& vbCrLf &_
							"		case cod_facultad when 6 then cast(sum(total) as numeric) end as F6,  "& vbCrLf &_
							"		case cod_facultad when 7 then cast(sum(total) as numeric) end as F7,  "& vbCrLf &_
							"		case cod_facultad when 8 then cast(sum(total) as numeric) end as F8,  "& vbCrLf &_
							"		case cod_facultad when 9 then cast(sum(total) as numeric) end as F9,  "& vbCrLf &_
							"		case cod_facultad when 10 then cast(sum(total) as numeric) end as F10,  "& vbCrLf &_
							"		case cod_facultad when 11 then cast(sum(total) as numeric) end as F11  "& vbCrLf &_
							"		from eru_estados_resultados_upa a, eru_facultades_upa b  "& vbCrLf &_
							"		where a.facultad=b.facultad  "& vbCrLf &_
							"		group by cod_dis, cod_facultad  "& vbCrLf &_
							"	) as matriz, eru_codigos_estados_upa b, eru_grupos_estados c  "& vbCrLf &_
							"	where matriz.codigo=b.cod_dis  "& vbCrLf &_
							"	and b.cod_grupo=c.cod_grupo   "& vbCrLf &_
							"   and b.cod_grupo=1  "& vbCrLf &_
							"	group by descripcion_grupo,b.cod_grupo,b.cod_orden,codigo,b.descripcion  "& vbCrLf &_
							"	order by b.cod_grupo,b.cod_orden "
			
			'response.Write("<pre>"&sql_sedes&"</pre>")
			f_ingreso.consultar sql_ingreso
			

'************************************************************************
	set f_costo_operacional = new CFormulario
	f_costo_operacional.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
	f_costo_operacional.Inicializar conexion

			sql_costo_operacional	=   " select b.cod_grupo,descripcion_grupo,b.cod_orden,b.descripcion,   "& vbCrLf &_
							"	sum(isnull(F1,0)) as F1,sum(isnull(F2,0)) as F2,sum(isnull(F3,0)) as F3,sum(isnull(F4,0)) as F4,  "& vbCrLf &_
							"	sum(isnull(F5,0)) as F5,sum(isnull(F6,0)) as F6,sum(isnull(F7,0)) as F7,sum(isnull(F8,0)) as F8,  "& vbCrLf &_
							"	sum(isnull(F9,0)) as F9,sum(isnull(F10,0)) as F10,sum(isnull(F11,0)) as F11,  "& vbCrLf &_
							"	sum(isnull(F1,0)) + sum(isnull(F2,0)) + sum(isnull(F3,0)) + sum(isnull(F4,0))+sum(isnull(F5,0)) + sum(isnull(F6,0)) + sum(isnull(F7,0)) + sum(isnull(F8,0)) + sum(isnull(F9,0)) + sum(isnull(F10,0)) + sum(isnull(F11,0)) as total   "& vbCrLf &_
							"	from  (  "& vbCrLf &_
							"		select cast(cod_dis as numeric) as codigo,   "& vbCrLf &_
							"		case cod_facultad when 1 then cast(sum(total) as numeric) end as F1,  "& vbCrLf &_
							"		case cod_facultad when 2 then cast(sum(total) as numeric) end as F2,  "& vbCrLf &_
							"		case cod_facultad when 3 then cast(sum(total) as numeric) end as F3,  "& vbCrLf &_
							"		case cod_facultad when 4 then cast(sum(total) as numeric) end as F4,  "& vbCrLf &_
							"		case cod_facultad when 5 then cast(sum(total) as numeric) end as F5,  "& vbCrLf &_
							"		case cod_facultad when 6 then cast(sum(total) as numeric) end as F6,  "& vbCrLf &_
							"		case cod_facultad when 7 then cast(sum(total) as numeric) end as F7,  "& vbCrLf &_
							"		case cod_facultad when 8 then cast(sum(total) as numeric) end as F8,  "& vbCrLf &_
							"		case cod_facultad when 9 then cast(sum(total) as numeric) end as F9,  "& vbCrLf &_
							"		case cod_facultad when 10 then cast(sum(total) as numeric) end as F10,  "& vbCrLf &_
							"		case cod_facultad when 11 then cast(sum(total) as numeric) end as F11  "& vbCrLf &_
							"		from eru_estados_resultados_upa a, eru_facultades_upa b  "& vbCrLf &_
							"		where a.facultad=b.facultad  "& vbCrLf &_
							"		group by cod_dis, cod_facultad  "& vbCrLf &_
							"	) as matriz, eru_codigos_estados_upa b, eru_grupos_estados c  "& vbCrLf &_
							"	where matriz.codigo=b.cod_dis  "& vbCrLf &_
							"	and b.cod_grupo=c.cod_grupo   "& vbCrLf &_
							"   and b.cod_grupo=2  "& vbCrLf &_
							"	group by descripcion_grupo,b.cod_grupo,b.cod_orden,codigo,b.descripcion  "& vbCrLf &_
							"	order by b.cod_grupo,b.cod_orden "
			
			'response.Write("<pre>"&sql_sedes&"</pre>")
			f_costo_operacional.consultar sql_costo_operacional



'************************************************************************
	set f_gasto_administracion = new CFormulario
	f_gasto_administracion.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
	f_gasto_administracion.Inicializar conexion

			sql_gasto_administracion	=   " select b.cod_grupo,descripcion_grupo,b.cod_orden,b.descripcion,   "& vbCrLf &_
							"	sum(isnull(F1,0)) as F1,sum(isnull(F2,0)) as F2,sum(isnull(F3,0)) as F3,sum(isnull(F4,0)) as F4,  "& vbCrLf &_
							"	sum(isnull(F5,0)) as F5,sum(isnull(F6,0)) as F6,sum(isnull(F7,0)) as F7,sum(isnull(F8,0)) as F8,  "& vbCrLf &_
							"	sum(isnull(F9,0)) as F9,sum(isnull(F10,0)) as F10,sum(isnull(F11,0)) as F11,  "& vbCrLf &_
							"	sum(isnull(F1,0)) + sum(isnull(F2,0)) + sum(isnull(F3,0)) + sum(isnull(F4,0))+sum(isnull(F5,0)) + sum(isnull(F6,0)) + sum(isnull(F7,0)) + sum(isnull(F8,0)) + sum(isnull(F9,0)) + sum(isnull(F10,0)) + sum(isnull(F11,0)) as total   "& vbCrLf &_
							"	from  (  "& vbCrLf &_
							"		select cast(cod_dis as numeric) as codigo,   "& vbCrLf &_
							"		case cod_facultad when 1 then cast(sum(total) as numeric) end as F1,  "& vbCrLf &_
							"		case cod_facultad when 2 then cast(sum(total) as numeric) end as F2,  "& vbCrLf &_
							"		case cod_facultad when 3 then cast(sum(total) as numeric) end as F3,  "& vbCrLf &_
							"		case cod_facultad when 4 then cast(sum(total) as numeric) end as F4,  "& vbCrLf &_
							"		case cod_facultad when 5 then cast(sum(total) as numeric) end as F5,  "& vbCrLf &_
							"		case cod_facultad when 6 then cast(sum(total) as numeric) end as F6,  "& vbCrLf &_
							"		case cod_facultad when 7 then cast(sum(total) as numeric) end as F7,  "& vbCrLf &_
							"		case cod_facultad when 8 then cast(sum(total) as numeric) end as F8,  "& vbCrLf &_
							"		case cod_facultad when 9 then cast(sum(total) as numeric) end as F9,  "& vbCrLf &_
							"		case cod_facultad when 10 then cast(sum(total) as numeric) end as F10,  "& vbCrLf &_
							"		case cod_facultad when 11 then cast(sum(total) as numeric) end as F11  "& vbCrLf &_
							"		from eru_estados_resultados_upa a, eru_facultades_upa b  "& vbCrLf &_
							"		where a.facultad=b.facultad  "& vbCrLf &_
							"		group by cod_dis, cod_facultad  "& vbCrLf &_
							"	) as matriz, eru_codigos_estados_upa b, eru_grupos_estados c  "& vbCrLf &_
							"	where matriz.codigo=b.cod_dis  "& vbCrLf &_
							"	and b.cod_grupo=c.cod_grupo   "& vbCrLf &_
							"   and b.cod_grupo=3  "& vbCrLf &_
							"	group by descripcion_grupo,b.cod_grupo,b.cod_orden,codigo,b.descripcion  "& vbCrLf &_
							"	order by b.cod_grupo,b.cod_orden "
			
			'response.Write("<pre>"&sql_sedes&"</pre>")
			f_gasto_administracion.consultar sql_gasto_administracion


'************************************************************************
	set f_gasto_indirecto = new CFormulario
	f_gasto_indirecto.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
	f_gasto_indirecto.Inicializar conexion

			sql_gasto_indirecto	=   " select b.cod_grupo,descripcion_grupo,b.cod_orden,b.descripcion,   "& vbCrLf &_
							"	sum(isnull(F1,0)) as F1,sum(isnull(F2,0)) as F2,sum(isnull(F3,0)) as F3,sum(isnull(F4,0)) as F4,  "& vbCrLf &_
							"	sum(isnull(F5,0)) as F5,sum(isnull(F6,0)) as F6,sum(isnull(F7,0)) as F7,sum(isnull(F8,0)) as F8,  "& vbCrLf &_
							"	sum(isnull(F9,0)) as F9,sum(isnull(F10,0)) as F10,sum(isnull(F11,0)) as F11,  "& vbCrLf &_
							"	sum(isnull(F1,0)) + sum(isnull(F2,0)) + sum(isnull(F3,0)) + sum(isnull(F4,0))+sum(isnull(F5,0)) + sum(isnull(F6,0)) + sum(isnull(F7,0)) + sum(isnull(F8,0)) + sum(isnull(F9,0)) + sum(isnull(F10,0)) + sum(isnull(F11,0)) as total   "& vbCrLf &_
							"	from  (  "& vbCrLf &_
							"		select cast(cod_dis as numeric) as codigo,   "& vbCrLf &_
							"		case cod_facultad when 1 then cast(sum(total) as numeric) end as F1,  "& vbCrLf &_
							"		case cod_facultad when 2 then cast(sum(total) as numeric) end as F2,  "& vbCrLf &_
							"		case cod_facultad when 3 then cast(sum(total) as numeric) end as F3,  "& vbCrLf &_
							"		case cod_facultad when 4 then cast(sum(total) as numeric) end as F4,  "& vbCrLf &_
							"		case cod_facultad when 5 then cast(sum(total) as numeric) end as F5,  "& vbCrLf &_
							"		case cod_facultad when 6 then cast(sum(total) as numeric) end as F6,  "& vbCrLf &_
							"		case cod_facultad when 7 then cast(sum(total) as numeric) end as F7,  "& vbCrLf &_
							"		case cod_facultad when 8 then cast(sum(total) as numeric) end as F8,  "& vbCrLf &_
							"		case cod_facultad when 9 then cast(sum(total) as numeric) end as F9,  "& vbCrLf &_
							"		case cod_facultad when 10 then cast(sum(total) as numeric) end as F10,  "& vbCrLf &_
							"		case cod_facultad when 11 then cast(sum(total) as numeric) end as F11  "& vbCrLf &_
							"		from eru_estados_resultados_upa a, eru_facultades_upa b  "& vbCrLf &_
							"		where a.facultad=b.facultad  "& vbCrLf &_
							"		group by cod_dis, cod_facultad  "& vbCrLf &_
							"	) as matriz, eru_codigos_estados_upa b, eru_grupos_estados c  "& vbCrLf &_
							"	where matriz.codigo=b.cod_dis  "& vbCrLf &_
							"	and b.cod_grupo=c.cod_grupo   "& vbCrLf &_
							"   and b.cod_grupo=4  "& vbCrLf &_
							"	group by descripcion_grupo,b.cod_grupo,b.cod_orden,codigo,b.descripcion  "& vbCrLf &_
							"	order by b.cod_grupo,b.cod_orden "
			
			'response.Write("<pre>"&sql_sedes&"</pre>")
			f_gasto_indirecto.consultar sql_gasto_indirecto


'-----------------------------------------------------------------------------
'*************************** TOTALIZADORES DE  SEDES *************************

			set f_totales = new CFormulario
			f_totales.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
			f_totales.Inicializar conexion
			
			sql_totales= " select sum(isnull(F1,0)) as F1,sum(isnull(F2,0)) as F2,sum(isnull(F3,0)) as F3,sum(isnull(F4,0)) as F4,  "& vbCrLf &_
						"	sum(isnull(F5,0)) as F5,sum(isnull(F6,0)) as F6,sum(isnull(F7,0)) as F7,sum(isnull(F8,0)) as F8,  "& vbCrLf &_
						"	sum(isnull(F9,0)) as F9,sum(isnull(F10,0)) as F10,sum(isnull(F11,0)) as F11,  "& vbCrLf &_
						"	sum(isnull(F1,0)) + sum(isnull(F2,0)) + sum(isnull(F3,0)) + sum(isnull(F4,0))+sum(isnull(F5,0)) + sum(isnull(F6,0)) + sum(isnull(F7,0)) + sum(isnull(F8,0)) + sum(isnull(F9,0)) + sum(isnull(F10,0)) + sum(isnull(F11,0)) as total   "& vbCrLf &_
						"	from  (  "& vbCrLf &_
						"		select cast(cod_dis as numeric) as codigo,   "& vbCrLf &_
						"		case cod_facultad when 1 then cast(sum(total) as numeric) end as F1,  "& vbCrLf &_
						"		case cod_facultad when 2 then cast(sum(total) as numeric) end as F2,  "& vbCrLf &_
						"		case cod_facultad when 3 then cast(sum(total) as numeric) end as F3,  "& vbCrLf &_
						"		case cod_facultad when 4 then cast(sum(total) as numeric) end as F4,  "& vbCrLf &_
						"		case cod_facultad when 5 then cast(sum(total) as numeric) end as F5,  "& vbCrLf &_
						"		case cod_facultad when 6 then cast(sum(total) as numeric) end as F6,  "& vbCrLf &_
						"		case cod_facultad when 7 then cast(sum(total) as numeric) end as F7,  "& vbCrLf &_
						"		case cod_facultad when 8 then cast(sum(total) as numeric) end as F8,  "& vbCrLf &_
						"		case cod_facultad when 9 then cast(sum(total) as numeric) end as F9,  "& vbCrLf &_
						"		case cod_facultad when 10 then cast(sum(total) as numeric) end as F10,  "& vbCrLf &_
						"		case cod_facultad when 11 then cast(sum(total) as numeric) end as F11  "& vbCrLf &_
						"	from eru_estados_resultados_upa a, eru_facultades_upa b  "& vbCrLf &_
						"	where a.facultad=b.facultad  "& vbCrLf &_
						"	group by cod_dis, cod_facultad  "& vbCrLf &_
						"	) as matriz, eru_codigos_estados_upa b, eru_grupos_estados c  "& vbCrLf &_
						"	where matriz.codigo=b.cod_dis  "& vbCrLf &_
						"	and b.cod_grupo=c.cod_grupo   "& vbCrLf &_
						"	and b.cod_grupo=1 "
			
			f_totales.consultar sql_totales
			while f_totales.Siguiente
				v_total_f1	=CDBL(f_totales.obtenerValor("f1"))*-1
				v_total_f2	=CDBL(f_totales.obtenerValor("f2"))*-1
				v_total_f3	=CDBL(f_totales.obtenerValor("f3"))*-1
				v_total_f4	=CDBL(f_totales.obtenerValor("f4"))*-1
				v_total_f5	=CDBL(f_totales.obtenerValor("f5"))*-1
				v_total_f6	=CDBL(f_totales.obtenerValor("f6"))*-1
				v_total_f7	=CDBL(f_totales.obtenerValor("f7"))*-1
				v_total_f8	=CDBL(f_totales.obtenerValor("f8"))*-1
				v_total_f9	=CDBL(f_totales.obtenerValor("f9"))*-1
				v_total_f10	=CDBL(f_totales.obtenerValor("f10"))*-1
				v_total_f11	=CDBL(f_totales.obtenerValor("f11"))*-1
				v_total_ingreso	=CDBL(f_totales.obtenerValor("total"))*-1
			wend

'**** Idea para automatizar los calculos de muchos elementos (no hay tiempo, se deja pendiente la automatizacion) ***
						Set variables = CreateObject("scripting.Dictionary")
						for i=1 to 11
							strclave = i
							strvalor = "f"&i
							variables.Add strclave, strvalor
						next
'-----------------------------------------------------------------------------
	
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
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>

<script language="JavaScript">
function imprimir()
{
  window.print();  
}
</script>
<style type="text/css">

@media print{ .noprint {visibility:hidden; }}
	
</style>
</head>


<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
        <td></td>
      </tr>
    </table>	
	<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
              <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td ><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td background="../imagenes/top_r1_c2.gif"><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="201" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Estado de resultado - Facultades </font></div>
                    </td>
                    <td width="456" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                  </tr>
                </table>
              </td>
              <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td background="../imagenes/top_r3_c2.gif"><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
            </tr>

              <tr>
                <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"> <div align="center"><BR><%pagina.DibujarTituloPagina%></div>
					<br/>
				  	<div align="center"><font color="#0033CC" size="2">VALORES ACUMULADOS AL MES DE JUNIO 2013</font></div>
				  	<br/>

				  <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#EDEDEF">
                    <tr> 
                      <td width="9" height="8"><img src="../imagenes/marco_claro/1.gif" width="9" height="8"></td>
                      <td height="8" background="../imagenes/marco_claro/2.gif"></td>
                      <td width="7" height="8"><img src="../imagenes/marco_claro/3.gif" width="7" height="8"></td>
                    </tr>
                    <tr> 
                      <td width="9" background="../imagenes/marco_claro/9.gif">&nbsp;</td>
                      <td>
					  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td height="2" background=""></td>
                          </tr>
                          <tr> 
                            <td> 
								<br/>
					
                              <table border="0" align="center"  >
                                <tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
                                  <th align="left">TIPO</th>
                                  <th colspan="2">FACULTAD DE COMUNICACIONES</th>
                                  <th colspan="2">FACULTAD DE DISEÑO</th>
                                  <th colspan="2">FACULTAD DE NEGOCIOS Y MARKETING</th>
								  <th colspan="2">FACULTAD DE CIENCIAS HUMANAS Y EDUCACION</th>
                                  <th colspan="2">AREA CIENCIAS AGROPECUARIAS</th>
                                  <th colspan="2">AREA CIENCIAS Y SALUD</th>
                                  <th colspan="2">AREA TECNICA MELIPILLA</th>
								  <th colspan="2">AREA TECNOLOGICA DE LA INFORMACION Y COMUNCIACION</th>
                                  <th colspan="2">CENTRO DE COMPETITIVIDAD</th>
                                  <th colspan="2">EXTENSION</th>
                                  <th colspan="2">PROYECTOS</th>
								  <th colspan="2">Total General</th>
                                </tr>
								<%
								v_grupo=1
								v_subtotal_f1	= 0
								v_subtotal_f2	= 0
								v_subtotal_f3	= 0
								v_subtotal_f4 	= 0
								v_subtotal_f5	= 0
								v_subtotal_f6	= 0
								v_subtotal_f7	= 0
								v_subtotal_f8 	= 0
								v_subtotal_f9	= 0
								v_subtotal_f10	= 0
								v_subtotal_f11 	= 0								
								v_subtotal_grupo= 0
								
								while f_ingreso.Siguiente
									descripcion_grupo= f_ingreso.ObtenerValor("descripcion_grupo")

										v_porcentaje_f1	= (CDBL(f_ingreso.ObtenerValor("f1"))*-100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_ingreso.ObtenerValor("f2"))*-100)/CDBL(v_total_f2)
										v_porcentaje_f3	= (CDBL(f_ingreso.ObtenerValor("f3"))*-100)/CDBL(v_total_f3)
										v_porcentaje_f4	= (CDBL(f_ingreso.ObtenerValor("f4"))*-100)/CDBL(v_total_f4)
										v_porcentaje_f5	= (CDBL(f_ingreso.ObtenerValor("f5"))*-100)/CDBL(v_total_f5)
										v_porcentaje_f6	= (CDBL(f_ingreso.ObtenerValor("f6"))*-100)/CDBL(v_total_f6)
										v_porcentaje_f7	= (CDBL(f_ingreso.ObtenerValor("f7"))*-100)/CDBL(v_total_f7)
										v_porcentaje_f8	= (CDBL(f_ingreso.ObtenerValor("f8"))*-100)/CDBL(v_total_f8)
										v_porcentaje_f9	= (CDBL(f_ingreso.ObtenerValor("f9"))*-100)/CDBL(v_total_f9)
										v_porcentaje_f10	= (CDBL(f_ingreso.ObtenerValor("f10"))*-100)/CDBL(v_total_f10)
										v_porcentaje_f11	= (CDBL(f_ingreso.ObtenerValor("f11"))*-100)/CDBL(v_total_f11)
																				
										v_porcentaje_total		= (CDBL(f_ingreso.ObtenerValor("total"))*-100)/CDBL(v_total_ingreso)
									
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_ingreso.ObtenerValor("f1"))*-1)
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_ingreso.ObtenerValor("f2"))*-1)
										v_subtotal_f3	= v_subtotal_f3 + (CDBL(f_ingreso.ObtenerValor("f3"))*-1)
										v_subtotal_f4	= v_subtotal_f4 + (CDBL(f_ingreso.ObtenerValor("f4"))*-1)
										v_subtotal_f5	= v_subtotal_f5 + (CDBL(f_ingreso.ObtenerValor("f5"))*-1)
										v_subtotal_f6	= v_subtotal_f6 + (CDBL(f_ingreso.ObtenerValor("f6"))*-1)
										v_subtotal_f7	= v_subtotal_f7 + (CDBL(f_ingreso.ObtenerValor("f7"))*-1)
										v_subtotal_f8	= v_subtotal_f8 + (CDBL(f_ingreso.ObtenerValor("f8"))*-1)
										v_subtotal_f9	= v_subtotal_f9 + (CDBL(f_ingreso.ObtenerValor("f9"))*-1)
										v_subtotal_f10	= v_subtotal_f10 + (CDBL(f_ingreso.ObtenerValor("f10"))*-1)
										v_subtotal_f11	= v_subtotal_f11 + (CDBL(f_ingreso.ObtenerValor("f11"))*-1)
										v_subtotal_grupo		= v_subtotal_grupo + (CDBL(f_ingreso.ObtenerValor("total"))*-1)
								%>
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_ingreso.DibujaCampo("descripcion")%></td>
					  			  			<td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f1"))*-1,0)%></td>
											<td nowrap><%=Round(v_porcentaje_f1,0)%>&nbsp;<strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f2"))*-1,0)%></td>
											<td nowrap><%=Round(v_porcentaje_f2,0)%>&nbsp;<strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f3"))*-1,0)%></td>
											<td nowrap><%=Round(v_porcentaje_f3,0)%>&nbsp;<strong>%</strong></td>
								  			<td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f4"))*-1,0)%></td>
											<td nowrap><%=Round(v_porcentaje_f4,0)%>&nbsp;<strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f5"))*-1,0)%></td>
											<td nowrap><%=Round(v_porcentaje_f5,0)%>&nbsp;<strong>%</strong></td>
   											<td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f6"))*-1,0)%></td>
											<td nowrap><%=Round(v_porcentaje_f6,0)%>&nbsp;<strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f7"))*-1,0)%></td>
											<td nowrap><%=Round(v_porcentaje_f7,0)%>&nbsp;<strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f8"))*-1,0)%></td>
											<td nowrap><%=Round(v_porcentaje_f8,0)%>&nbsp;<strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f9"))*-1,0)%></td>
											<td nowrap><%=Round(v_porcentaje_f9,0)%>&nbsp;<strong>%</strong></td>
   											<td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f10"))*-1,0)%></td>
											<td nowrap><%=Round(v_porcentaje_f10,0)%>&nbsp;<strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_ingreso.ObtenerValor("f11"))*-1,0)%></td>
											<td nowrap><%=Round(v_porcentaje_f11,0)%>&nbsp;<strong>%</strong></td>
								  <td nowrap bgcolor="#E0E0E0"><%=formatnumber(cdbl(f_ingreso.ObtenerValor("total"))*-1,0)%></td>
											<td nowrap bgcolor="#E0E0E0"><%=Round(v_porcentaje_total,0)%>&nbsp;<strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
								%>
								<!-- INICIO sub total de grupos -->
									<tr bordercolor='#999999' align="right">	
									  <th align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th nowrap ><%=formatnumber(v_subtotal_f1,0)%></th>
										<th nowrap>&nbsp;</th>
										<th nowrap ><%=formatnumber(v_subtotal_f2,0)%></th>
										<th nowrap>&nbsp;</th>										
									  <th nowrap ><%=formatnumber(v_subtotal_f3,0)%></th>
										<th nowrap>&nbsp;</th>										
									  <th nowrap ><%=formatnumber(v_subtotal_f4,0)%></th>
										<th nowrap>&nbsp;</th>										
									  <th nowrap ><%=formatnumber(v_subtotal_f5,0)%></th>
										<th nowrap>&nbsp;</th>										
									  <th nowrap ><%=formatnumber(v_subtotal_f6,0)%></th>
										<th nowrap>&nbsp;</th>										
									  <th nowrap ><%=formatnumber(v_subtotal_f7,0)%></th>
										<th nowrap>&nbsp;</th>										
									  <th nowrap ><%=formatnumber(v_subtotal_f8,0)%></th>
										<th nowrap>&nbsp;</th>										
									  <th nowrap ><%=formatnumber(v_subtotal_f9,0)%></th>
										<th nowrap>&nbsp;</th>										
									  <th nowrap ><%=formatnumber(v_subtotal_f10,0)%></th>
										<th nowrap>&nbsp;</th>										
									  <th nowrap ><%=formatnumber(v_subtotal_f11,0)%></th>
										<th nowrap>&nbsp;</th>										
									  <th nowrap ><%=formatnumber(v_total_ingreso,0)%></th>
										<th nowrap>&nbsp;</th>										
									</tr>
								<%

								v_subtotal_f1	= 0
								v_subtotal_f2	= 0
								v_subtotal_f3	= 0
								v_subtotal_f4 	= 0
								v_subtotal_f5	= 0
								v_subtotal_f6	= 0
								v_subtotal_f7	= 0
								v_subtotal_f8 	= 0
								v_subtotal_f9	= 0
								v_subtotal_f10	= 0
								v_subtotal_f11 	= 0								
								v_subtotal_grupo= 0
															
								while f_costo_operacional.Siguiente
									descripcion_grupo= f_costo_operacional.ObtenerValor("descripcion_grupo")
								
										v_porcentaje_f1	= (CDBL(f_costo_operacional.ObtenerValor("f1"))*100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_costo_operacional.ObtenerValor("f2"))*100)/CDBL(v_total_f2)
										v_porcentaje_f3	= (CDBL(f_costo_operacional.ObtenerValor("f3"))*100)/CDBL(v_total_f3)
										v_porcentaje_f4	= (CDBL(f_costo_operacional.ObtenerValor("f4"))*100)/CDBL(v_total_f4)
										v_porcentaje_f5	= (CDBL(f_costo_operacional.ObtenerValor("f5"))*100)/CDBL(v_total_f5)
										v_porcentaje_f6	= (CDBL(f_costo_operacional.ObtenerValor("f6"))*100)/CDBL(v_total_f6)
										v_porcentaje_f7	= (CDBL(f_costo_operacional.ObtenerValor("f7"))*100)/CDBL(v_total_f7)
										v_porcentaje_f8	= (CDBL(f_costo_operacional.ObtenerValor("f8"))*100)/CDBL(v_total_f8)
										v_porcentaje_f9	= (CDBL(f_costo_operacional.ObtenerValor("f9"))*100)/CDBL(v_total_f9)
										v_porcentaje_f10	= (CDBL(f_costo_operacional.ObtenerValor("f10"))*100)/CDBL(v_total_f10)
										v_porcentaje_f11	= (CDBL(f_costo_operacional.ObtenerValor("f11"))*100)/CDBL(v_total_f11)
																				
										v_porcentaje_total		= (CDBL(f_costo_operacional.ObtenerValor("total"))*100)/CDBL(v_total_ingreso)
									
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_costo_operacional.ObtenerValor("f1")))
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_costo_operacional.ObtenerValor("f2")))
										v_subtotal_f3	= v_subtotal_f3 + (CDBL(f_costo_operacional.ObtenerValor("f3")))
										v_subtotal_f4	= v_subtotal_f4 + (CDBL(f_costo_operacional.ObtenerValor("f4")))
										v_subtotal_f5	= v_subtotal_f5 + (CDBL(f_costo_operacional.ObtenerValor("f5")))
										v_subtotal_f6	= v_subtotal_f6 + (CDBL(f_costo_operacional.ObtenerValor("f6")))
										v_subtotal_f7	= v_subtotal_f7 + (CDBL(f_costo_operacional.ObtenerValor("f7")))
										v_subtotal_f8	= v_subtotal_f8 + (CDBL(f_costo_operacional.ObtenerValor("f8")))
										v_subtotal_f9	= v_subtotal_f9 + (CDBL(f_costo_operacional.ObtenerValor("f9")))
										v_subtotal_f10	= v_subtotal_f10 + (CDBL(f_costo_operacional.ObtenerValor("f10")))
										v_subtotal_f11	= v_subtotal_f11 + (CDBL(f_costo_operacional.ObtenerValor("f11")))
										v_subtotal_grupo		= v_subtotal_grupo + (CDBL(f_costo_operacional.ObtenerValor("total")))
								
								
								%>							
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_costo_operacional.DibujaCampo("descripcion")%></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f1")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f1,0)%>&nbsp;<strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f2")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f2,0)%>&nbsp;<strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f3")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f3,0)%>&nbsp;<strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f4")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f4,0)%>&nbsp;<strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f5")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f5,0)%>&nbsp;<strong>%</strong></td>
   											<td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f6")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f6,0)%>&nbsp;<strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f7")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f7,0)%>&nbsp;<strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f8")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f8,0)%>&nbsp;<strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f9")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f9,0)%>&nbsp;<strong>%</strong></td>
   											<td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f10")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f10,0)%>&nbsp;<strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_costo_operacional.ObtenerValor("f11")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f11,0)%>&nbsp;<strong>%</strong></td>
								  <td nowrap bgcolor="#E0E0E0"><%=formatnumber(f_costo_operacional.ObtenerValor("total"),0)%></td>
											<td nowrap bgcolor="#E0E0E0"><%=Round(v_porcentaje_total,0)%>&nbsp;<strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
								
									v_porc_grupo_f1	= (CDBL(v_subtotal_f1)*100)/CDBL(v_total_f1)
									v_porc_grupo_f2	= (CDBL(v_subtotal_f2)*100)/CDBL(v_total_f2)
									v_porc_grupo_f3	= (CDBL(v_subtotal_f3)*100)/CDBL(v_total_f3)
									v_porc_grupo_f4	= (CDBL(v_subtotal_f4)*100)/CDBL(v_total_f4)
									v_porc_grupo_f5	= (CDBL(v_subtotal_f5)*100)/CDBL(v_total_f5)
									v_porc_grupo_f6	= (CDBL(v_subtotal_f6)*100)/CDBL(v_total_f6)
									v_porc_grupo_f7	= (CDBL(v_subtotal_f7)*100)/CDBL(v_total_f7)
									v_porc_grupo_f8	= (CDBL(v_subtotal_f8)*100)/CDBL(v_total_f8)
									v_porc_grupo_f9	= (CDBL(v_subtotal_f9)*100)/CDBL(v_total_f9)
									v_porc_grupo_f10	= (CDBL(v_subtotal_f10)*100)/CDBL(v_total_f10)
									v_porc_grupo_f11	= (CDBL(v_subtotal_f11)*100)/CDBL(v_total_f11)
									
									v_porc_grupo_total		= (CDBL(v_subtotal_grupo)*100)/CDBL(v_total_ingreso)
									
									'*** Subtotal Acumulado (A-B)=C ***
									v_operacional_f1 	= CDBL(v_total_f1)-CDBL(v_subtotal_f1)
									v_operacional_f2 	= CDBL(v_total_f2)-CDBL(v_subtotal_f2)	
									v_operacional_f3 	= CDBL(v_total_f3)-CDBL(v_subtotal_f3)	
									v_operacional_f4 	= CDBL(v_total_f4)-CDBL(v_subtotal_f4)
									v_operacional_f5 	= CDBL(v_total_f5)-CDBL(v_subtotal_f5)
									v_operacional_f6 	= CDBL(v_total_f6)-CDBL(v_subtotal_f6)	
									v_operacional_f7 	= CDBL(v_total_f7)-CDBL(v_subtotal_f7)	
									v_operacional_f8 	= CDBL(v_total_f8)-CDBL(v_subtotal_f8)
									v_operacional_f9 	= CDBL(v_total_f9)-CDBL(v_subtotal_f9)
									v_operacional_f10 	= CDBL(v_total_f10)-CDBL(v_subtotal_f10)	
									v_operacional_f11 	= CDBL(v_total_f11)-CDBL(v_subtotal_f11)	
									
									v_operacional_total		 	= CDBL(v_total_ingreso)-CDBL(v_subtotal_grupo)	
									
									v_porc_operacional_f1	= (CDBL(v_operacional_f1)*100)/CDBL(v_total_f1)
									v_porc_operacional_f2	= (CDBL(v_operacional_f2)*100)/CDBL(v_total_f2)
									v_porc_operacional_f3	= (CDBL(v_operacional_f3)*100)/CDBL(v_total_f3)
									v_porc_operacional_f4	= (CDBL(v_operacional_f4)*100)/CDBL(v_total_f4)
									v_porc_operacional_f5	= (CDBL(v_operacional_f5)*100)/CDBL(v_total_f5)
									v_porc_operacional_f6	= (CDBL(v_operacional_f6)*100)/CDBL(v_total_f6)
									v_porc_operacional_f7	= (CDBL(v_operacional_f7)*100)/CDBL(v_total_f7)
									v_porc_operacional_f8	= (CDBL(v_operacional_f8)*100)/CDBL(v_total_f8)
									v_porc_operacional_f9	= (CDBL(v_operacional_f9)*100)/CDBL(v_total_f9)
									v_porc_operacional_f10	= (CDBL(v_operacional_f10)*100)/CDBL(v_total_f10)
									v_porc_operacional_f11	= (CDBL(v_operacional_f11)*100)/CDBL(v_total_f11)
																		
									v_porc_operacional_total		= (CDBL(v_operacional_total)*100)/CDBL(v_total_ingreso)			
								
								%>
								<!-- INICIO sub total de grupo -->
									<tr bordercolor='#999999' align="right">	
									  <th align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th nowrap><%=formatnumber(v_subtotal_f1,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f1,0)%>&nbsp;<strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f2,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f2,0)%>&nbsp;<strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f3,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f3,0)%>&nbsp;<strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f4,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f4,0)%>&nbsp;<strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f5,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f5,0)%>&nbsp;<strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f6,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f6,0)%>&nbsp;<strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f7,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f7,0)%>&nbsp;<strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f8,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f8,0)%>&nbsp;<strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f9,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f9,0)%>&nbsp;<strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f10,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f10,0)%>&nbsp;<strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f11,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f11,0)%>&nbsp;<strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_grupo,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_total,0)%>&nbsp;<strong>%</strong></th>
									</tr>
								<!-- INICIO totalizado de RESULTADO OPERACIONAL-->
									<tr><th colspan="25" height="5"></th></tr>
									<tr bordercolor='#999999' bgcolor="#FFFFCC" align="right">	
										<th align="left"><strong>RESULTADO OPERACIONAL</strong></th>
									  <th nowrap><%=formatnumber(v_operacional_f1,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_f1,0)%>&nbsp;<strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_operacional_f2,0)%></th>
									  <th nowrap><%=Round(v_porc_operacional_f2,0)%>&nbsp;<strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_operacional_f3,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_f3,0)%>&nbsp;<strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_operacional_f4,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_f4,0)%>&nbsp;<strong>%</strong></th>
										<th nowrap><%=formatnumber(v_operacional_f5,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_f5,0)%>&nbsp;<strong>%</strong></th>
										<th nowrap><%=formatnumber(v_operacional_f6,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_f6,0)%>&nbsp;<strong>%</strong></th>
										<th nowrap><%=formatnumber(v_operacional_f7,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_f7,0)%>&nbsp;<strong>%</strong></th>
										<th nowrap><%=formatnumber(v_operacional_f8,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_f8,0)%>&nbsp;<strong>%</strong></th>
										<th nowrap><%=formatnumber(v_operacional_f9,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_f9,0)%>&nbsp;<strong>%</strong></th>
										<th nowrap><%=formatnumber(v_operacional_f10,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_f10,0)%>&nbsp;<strong>%</strong></th>
										<th nowrap><%=formatnumber(v_operacional_f11,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_f11,0)%>&nbsp;<strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_operacional_total,0)%></th>
										<th nowrap><%=Round(v_porc_operacional_total,0)%>&nbsp;<strong>%</strong></th>
									</tr>
									<tr><th colspan="25" height="10"></th></tr>
								<%
								
								v_subtotal_f1	= 0
								v_subtotal_f2	= 0
								v_subtotal_f3	= 0
								v_subtotal_f4 	= 0
								v_subtotal_f5	= 0
								v_subtotal_f6	= 0
								v_subtotal_f7	= 0
								v_subtotal_f8 	= 0
								v_subtotal_f9	= 0
								v_subtotal_f10	= 0
								v_subtotal_f11 	= 0								
								v_subtotal_grupo= 0

								while f_gasto_administracion.Siguiente
										descripcion_grupo= f_gasto_administracion.ObtenerValor("descripcion_grupo")
										
										v_porcentaje_f1	= (CDBL(f_gasto_administracion.ObtenerValor("f1"))*100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_gasto_administracion.ObtenerValor("f2"))*100)/CDBL(v_total_f2)
										v_porcentaje_f3	= (CDBL(f_gasto_administracion.ObtenerValor("f3"))*100)/CDBL(v_total_f3)
										v_porcentaje_f4	= (CDBL(f_gasto_administracion.ObtenerValor("f4"))*100)/CDBL(v_total_f4)
										v_porcentaje_f5	= (CDBL(f_gasto_administracion.ObtenerValor("f5"))*100)/CDBL(v_total_f5)
										v_porcentaje_f6	= (CDBL(f_gasto_administracion.ObtenerValor("f6"))*100)/CDBL(v_total_f6)
										v_porcentaje_f7	= (CDBL(f_gasto_administracion.ObtenerValor("f7"))*100)/CDBL(v_total_f7)
										v_porcentaje_f8	= (CDBL(f_gasto_administracion.ObtenerValor("f8"))*100)/CDBL(v_total_f8)
										v_porcentaje_f9	= (CDBL(f_gasto_administracion.ObtenerValor("f9"))*100)/CDBL(v_total_f9)
										v_porcentaje_f10	= (CDBL(f_gasto_administracion.ObtenerValor("f10"))*100)/CDBL(v_total_f10)
										v_porcentaje_f11	= (CDBL(f_gasto_administracion.ObtenerValor("f11"))*100)/CDBL(v_total_f11)
																				
										v_porcentaje_total		= (CDBL(f_gasto_administracion.ObtenerValor("total"))*100)/CDBL(v_total_ingreso)
									
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_gasto_administracion.ObtenerValor("f1")))
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_gasto_administracion.ObtenerValor("f2")))
										v_subtotal_f3	= v_subtotal_f3 + (CDBL(f_gasto_administracion.ObtenerValor("f3")))
										v_subtotal_f4	= v_subtotal_f4 + (CDBL(f_gasto_administracion.ObtenerValor("f4")))
										v_subtotal_f5	= v_subtotal_f5 + (CDBL(f_gasto_administracion.ObtenerValor("f5")))
										v_subtotal_f6	= v_subtotal_f6 + (CDBL(f_gasto_administracion.ObtenerValor("f6")))
										v_subtotal_f7	= v_subtotal_f7 + (CDBL(f_gasto_administracion.ObtenerValor("f7")))
										v_subtotal_f8	= v_subtotal_f8 + (CDBL(f_gasto_administracion.ObtenerValor("f8")))
										v_subtotal_f9	= v_subtotal_f9 + (CDBL(f_gasto_administracion.ObtenerValor("f9")))
										v_subtotal_f10	= v_subtotal_f10 + (CDBL(f_gasto_administracion.ObtenerValor("f10")))
										v_subtotal_f11	= v_subtotal_f11 + (CDBL(f_gasto_administracion.ObtenerValor("f11")))
										v_subtotal_grupo		= v_subtotal_grupo + (CDBL(f_gasto_administracion.ObtenerValor("total")))
								
								%>							
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_gasto_administracion.DibujaCampo("descripcion")%></td>
								  <td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f1")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f1,0)%>&nbsp;<strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f2")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f2,0)%>&nbsp;<strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f3")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f3,0)%>&nbsp;<strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f4")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f4,0)%>&nbsp;<strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f5")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f5,0)%>&nbsp;<strong>%</strong></td>
   											<td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f6")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f6,0)%>&nbsp;<strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f7")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f7,0)%>&nbsp;<strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f8")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f8,0)%>&nbsp;<strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f9")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f9,0)%>&nbsp;<strong>%</strong></td>
   											<td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f10")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f10,0)%>&nbsp;<strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_administracion.ObtenerValor("f11")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f11,0)%>&nbsp;<strong>%</strong></td>
								  <td nowrap bgcolor="#E0E0E0"><%=formatnumber(f_gasto_administracion.ObtenerValor("total"),0)%></td>
											<td nowrap bgcolor="#E0E0E0"><%=Round(v_porcentaje_total,0)%>&nbsp;<strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
									v_porc_grupo_f1	= (CDBL(v_subtotal_f1)*100)/CDBL(v_total_f1)
									v_porc_grupo_f2	= (CDBL(v_subtotal_f2)*100)/CDBL(v_total_f2)
									v_porc_grupo_f3	= (CDBL(v_subtotal_f3)*100)/CDBL(v_total_f3)
									v_porc_grupo_f4	= (CDBL(v_subtotal_f4)*100)/CDBL(v_total_f4)
									v_porc_grupo_f5	= (CDBL(v_subtotal_f5)*100)/CDBL(v_total_f5)
									v_porc_grupo_f6	= (CDBL(v_subtotal_f6)*100)/CDBL(v_total_f6)
									v_porc_grupo_f7	= (CDBL(v_subtotal_f7)*100)/CDBL(v_total_f7)
									v_porc_grupo_f8	= (CDBL(v_subtotal_f8)*100)/CDBL(v_total_f8)
									v_porc_grupo_f9	= (CDBL(v_subtotal_f9)*100)/CDBL(v_total_f9)
									v_porc_grupo_f10	= (CDBL(v_subtotal_f10)*100)/CDBL(v_total_f10)
									v_porc_grupo_f11	= (CDBL(v_subtotal_f11)*100)/CDBL(v_total_f11)
									v_porc_grupo_total	= (CDBL(v_subtotal_grupo)*100)/CDBL(v_total_ingreso)

									'*** Subtotal Acumulado (C-D)=E ***
									v_adm_f1 	= CDBL(v_operacional_f1)-CDBL(v_subtotal_f1)
									v_adm_f2 	= CDBL(v_operacional_f2)-CDBL(v_subtotal_f2)	
									v_adm_f3 	= CDBL(v_operacional_f3)-CDBL(v_subtotal_f3)	
									v_adm_f4 	= CDBL(v_operacional_f4)-CDBL(v_subtotal_f4)
									v_adm_f5 	= CDBL(v_operacional_f5)-CDBL(v_subtotal_f5)
									v_adm_f6 	= CDBL(v_operacional_f6)-CDBL(v_subtotal_f6)	
									v_adm_f7 	= CDBL(v_operacional_f7)-CDBL(v_subtotal_f7)	
									v_adm_f8 	= CDBL(v_operacional_f8)-CDBL(v_subtotal_f8)
									v_adm_f9 	= CDBL(v_operacional_f9)-CDBL(v_subtotal_f9)
									v_adm_f10 	= CDBL(v_operacional_f10)-CDBL(v_subtotal_f10)	
									v_adm_f11 	= CDBL(v_operacional_f11)-CDBL(v_subtotal_f11)	
									
									v_adm_total		 	= CDBL(v_operacional_total)-CDBL(v_subtotal_grupo)	
									
									v_porc_adm_f1	= (CDBL(v_adm_f1)*100)/CDBL(v_total_f1)
									v_porc_adm_f2	= (CDBL(v_adm_f2)*100)/CDBL(v_total_f2)
									v_porc_adm_f3	= (CDBL(v_adm_f3)*100)/CDBL(v_total_f3)
									v_porc_adm_f4	= (CDBL(v_adm_f4)*100)/CDBL(v_total_f4)
									v_porc_adm_f5	= (CDBL(v_adm_f5)*100)/CDBL(v_total_f5)
									v_porc_adm_f6	= (CDBL(v_adm_f6)*100)/CDBL(v_total_f6)
									v_porc_adm_f7	= (CDBL(v_adm_f7)*100)/CDBL(v_total_f7)
									v_porc_adm_f8	= (CDBL(v_adm_f8)*100)/CDBL(v_total_f8)
									v_porc_adm_f9	= (CDBL(v_adm_f9)*100)/CDBL(v_total_f9)
									v_porc_adm_f10	= (CDBL(v_adm_f10)*100)/CDBL(v_total_f10)
									v_porc_adm_f11	= (CDBL(v_adm_f11)*100)/CDBL(v_total_f11)
									
									v_porc_adm_total		= (CDBL(v_adm_total)*100)/CDBL(v_total_ingreso)											
								%>
								<!-- INICIO sub total de grupos -->
									<tr bordercolor='#999999' align="right">	
									  <th align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th nowrap><%=formatnumber(v_subtotal_f1,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f1,0)%>&nbsp;<strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f2,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f2,0)%>&nbsp;<strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f3,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f3,0)%>&nbsp;<strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f4,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f4,0)%>&nbsp;<strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f5,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f5,0)%>&nbsp;<strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f6,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f6,0)%>&nbsp;<strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f7,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f7,0)%>&nbsp;<strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f8,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f8,0)%>&nbsp;<strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f9,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f9,0)%>&nbsp;<strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f10,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f10,0)%>&nbsp;<strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f11,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f11,0)%>&nbsp;<strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_grupo,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_total,0)%>&nbsp;<strong>%</strong></th>
									</tr>
								<!-- INICIO totalizado de RESULTADO OPERACIONAL-->
									<tr><th colspan="25" height="5"></th></tr>
									<tr bordercolor='#999999' bgcolor="#FFFFCC" align="right">	
										<th align="left"><strong>RESULTADO</strong></th>
									  <th nowrap><%=formatnumber(v_adm_f1,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f1,0)%>&nbsp;<strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_adm_f2,0)%></th>
									  <th nowrap><%=Round(v_porc_adm_f2,0)%>&nbsp;<strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_adm_f3,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f3,0)%>&nbsp;<strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_adm_f4,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f4,0)%>&nbsp;<strong>%</strong></th>
										<th nowrap><%=formatnumber(v_adm_f5,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f5,0)%>&nbsp;<strong>%</strong></th>
										<th nowrap><%=formatnumber(v_adm_f6,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f6,0)%>&nbsp;<strong>%</strong></th>
										<th nowrap><%=formatnumber(v_adm_f7,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f7,0)%>&nbsp;<strong>%</strong></th>
										<th nowrap><%=formatnumber(v_adm_f8,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f8,0)%>&nbsp;<strong>%</strong></th>
										<th nowrap><%=formatnumber(v_adm_f9,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f9,0)%>&nbsp;<strong>%</strong></th>
										<th nowrap><%=formatnumber(v_adm_f10,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f10,0)%>&nbsp;<strong>%</strong></th>
										<th nowrap><%=formatnumber(v_adm_f11,0)%></th>
										<th nowrap><%=Round(v_porc_adm_f11,0)%>&nbsp;<strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_adm_total,0)%></th>
										<th nowrap><%=Round(v_porc_adm_total,0)%>&nbsp;<strong>%</strong></th>
									</tr>
									<tr><th colspan="25" height="10"></th></tr>									
								 <%
								 
									v_subtotal_f1	= 0
									v_subtotal_f2	= 0
									v_subtotal_f3	= 0
									v_subtotal_f4 	= 0
									v_subtotal_f5	= 0
									v_subtotal_f6	= 0
									v_subtotal_f7	= 0
									v_subtotal_f8 	= 0
									v_subtotal_f9	= 0
									v_subtotal_f10	= 0
									v_subtotal_f11 	= 0								
									v_subtotal_grupo= 0
										
								 while f_gasto_indirecto.Siguiente
		
		  							    descripcion_grupo= f_gasto_indirecto.ObtenerValor("descripcion_grupo")
								 
										v_porcentaje_f1	= (CDBL(f_gasto_indirecto.ObtenerValor("f1"))*100)/CDBL(v_total_f1)
										v_porcentaje_f2	= (CDBL(f_gasto_indirecto.ObtenerValor("f2"))*100)/CDBL(v_total_f2)
										v_porcentaje_f3	= (CDBL(f_gasto_indirecto.ObtenerValor("f3"))*100)/CDBL(v_total_f3)
										v_porcentaje_f4	= (CDBL(f_gasto_indirecto.ObtenerValor("f4"))*100)/CDBL(v_total_f4)
										v_porcentaje_f5	= (CDBL(f_gasto_indirecto.ObtenerValor("f5"))*100)/CDBL(v_total_f5)
										v_porcentaje_f6	= (CDBL(f_gasto_indirecto.ObtenerValor("f6"))*100)/CDBL(v_total_f6)
										v_porcentaje_f7	= (CDBL(f_gasto_indirecto.ObtenerValor("f7"))*100)/CDBL(v_total_f7)
										v_porcentaje_f8	= (CDBL(f_gasto_indirecto.ObtenerValor("f8"))*100)/CDBL(v_total_f8)
										v_porcentaje_f9	= (CDBL(f_gasto_indirecto.ObtenerValor("f9"))*100)/CDBL(v_total_f9)
										v_porcentaje_f10	= (CDBL(f_gasto_indirecto.ObtenerValor("f10"))*100)/CDBL(v_total_f10)
										v_porcentaje_f11	= (CDBL(f_gasto_indirecto.ObtenerValor("f11"))*100)/CDBL(v_total_f11)
																				
										v_porcentaje_total		= (CDBL(f_gasto_indirecto.ObtenerValor("total"))*100)/CDBL(v_total_ingreso)
									
										v_subtotal_f1	= v_subtotal_f1 + (CDBL(f_gasto_indirecto.ObtenerValor("f1")))
										v_subtotal_f2	= v_subtotal_f2 + (CDBL(f_gasto_indirecto.ObtenerValor("f2")))
										v_subtotal_f3	= v_subtotal_f3 + (CDBL(f_gasto_indirecto.ObtenerValor("f3")))
										v_subtotal_f4	= v_subtotal_f4 + (CDBL(f_gasto_indirecto.ObtenerValor("f4")))
										v_subtotal_f5	= v_subtotal_f5 + (CDBL(f_gasto_indirecto.ObtenerValor("f5")))
										v_subtotal_f6	= v_subtotal_f6 + (CDBL(f_gasto_indirecto.ObtenerValor("f6")))
										v_subtotal_f7	= v_subtotal_f7 + (CDBL(f_gasto_indirecto.ObtenerValor("f7")))
										v_subtotal_f8	= v_subtotal_f8 + (CDBL(f_gasto_indirecto.ObtenerValor("f8")))
										v_subtotal_f9	= v_subtotal_f9 + (CDBL(f_gasto_indirecto.ObtenerValor("f9")))
										v_subtotal_f10	= v_subtotal_f10 + (CDBL(f_gasto_indirecto.ObtenerValor("f10")))
										v_subtotal_f11	= v_subtotal_f11 + (CDBL(f_gasto_indirecto.ObtenerValor("f11")))
										v_subtotal_grupo= v_subtotal_grupo + (CDBL(f_gasto_indirecto.ObtenerValor("total")))
								%>
								<!-- INICIO filas dinamicas con los resultados de la query general -->
								<tr bordercolor='#999999' bgcolor="#FFFFFF" align="right">	
                                  			<td align="left"><%f_gasto_indirecto.DibujaCampo("descripcion")%></td>
								  <td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f1")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f1,0)%>&nbsp;<strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f2")),0)%></td>
								  <td nowrap><%=Round(v_porcentaje_f2,0)%>&nbsp;<strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f3")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f3,0)%>&nbsp;<strong>%</strong></td>
								  <td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f4")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f4,0)%>&nbsp;<strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f5")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f5,0)%>&nbsp;<strong>%</strong></td>
   											<td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f6")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f6,0)%>&nbsp;<strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f7")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f7,0)%>&nbsp;<strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f8")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f8,0)%>&nbsp;<strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f9")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f9,0)%>&nbsp;<strong>%</strong></td>
   											<td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f10")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f10,0)%>&nbsp;<strong>%</strong></td>
											<td nowrap><%=formatnumber(cdbl(f_gasto_indirecto.ObtenerValor("f11")),0)%></td>
											<td nowrap><%=Round(v_porcentaje_f11,0)%>&nbsp;<strong>%</strong></td>
								  <td nowrap bgcolor="#E0E0E0"><%=formatnumber(f_gasto_indirecto.ObtenerValor("total"),0)%></td>
											<td nowrap bgcolor="#E0E0E0"><%=Round(v_porcentaje_total,0)%>&nbsp;<strong>%</strong></td>
                                </tr>
								<!-- FIN filas dinamicas-->
								<% 
								wend
								
								
									v_porc_grupo_f1	= (CDBL(v_subtotal_f1)*100)/CDBL(v_total_f1)
									v_porc_grupo_f2	= (CDBL(v_subtotal_f2)*100)/CDBL(v_total_f2)
									v_porc_grupo_f3	= (CDBL(v_subtotal_f3)*100)/CDBL(v_total_f3)
									v_porc_grupo_f4	= (CDBL(v_subtotal_f4)*100)/CDBL(v_total_f4)
									v_porc_grupo_f5	= (CDBL(v_subtotal_f5)*100)/CDBL(v_total_f5)
									v_porc_grupo_f6	= (CDBL(v_subtotal_f6)*100)/CDBL(v_total_f6)
									v_porc_grupo_f7	= (CDBL(v_subtotal_f7)*100)/CDBL(v_total_f7)
									v_porc_grupo_f8	= (CDBL(v_subtotal_f8)*100)/CDBL(v_total_f8)
									v_porc_grupo_f9	= (CDBL(v_subtotal_f9)*100)/CDBL(v_total_f9)
									v_porc_grupo_f10	= (CDBL(v_subtotal_f10)*100)/CDBL(v_total_f10)
									v_porc_grupo_f11	= (CDBL(v_subtotal_f11)*100)/CDBL(v_total_f11)
									v_porc_grupo_total	= (CDBL(v_subtotal_grupo)*100)/CDBL(v_total_ingreso)								
								
								
								%>
								<!-- INICIO sub total de grupos -->
									<tr bordercolor='#999999' align="right">	
									  <th align="left"><font color="#0033FF"><strong><%=descripcion_grupo%></strong></font></th>
										<th nowrap><%=formatnumber(v_subtotal_f1,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f1,0)%>&nbsp;<strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f2,0)%></th>
									  <th nowrap><%=Round(v_porc_grupo_f2,0)%>&nbsp;<strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f3,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f3,0)%>&nbsp;<strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f4,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f4,0)%>&nbsp;<strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f5,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f5,0)%>&nbsp;<strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f6,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f6,0)%>&nbsp;<strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f7,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f7,0)%>&nbsp;<strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f8,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f8,0)%>&nbsp;<strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f9,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f9,0)%>&nbsp;<strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_f10,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f10,0)%>&nbsp;<strong>%</strong></th>
										<th nowrap><%=formatnumber(v_subtotal_f11,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_f11,0)%>&nbsp;<strong>%</strong></th>
									  <th nowrap><%=formatnumber(v_subtotal_grupo,0)%></th>
										<th nowrap><%=Round(v_porc_grupo_total,0)%>&nbsp;<strong>%</strong></th>
									</tr>
									<%
									'*** Subtotal Acumulado (E-F)=G ***
									v_resul_total_f1 	= CDBL(v_adm_f1)-CDBL(v_subtotal_f1)
									v_resul_total_f2 	= CDBL(v_adm_f2)-CDBL(v_subtotal_f2)	
									v_resul_total_f3 	= CDBL(v_adm_f3)-CDBL(v_subtotal_f3)	
									v_resul_total_f4 	= CDBL(v_adm_f4)-CDBL(v_subtotal_f4)
									v_resul_total_f5 	= CDBL(v_adm_f5)-CDBL(v_subtotal_f5)
									v_resul_total_f6 	= CDBL(v_adm_f6)-CDBL(v_subtotal_f6)	
									v_resul_total_f7 	= CDBL(v_adm_f7)-CDBL(v_subtotal_f7)	
									v_resul_total_f8 	= CDBL(v_adm_f8)-CDBL(v_subtotal_f8)
									v_resul_total_f9 	= CDBL(v_adm_f9)-CDBL(v_subtotal_f9)
									v_resul_total_f10 	= CDBL(v_adm_f10)-CDBL(v_subtotal_f10)	
									v_resul_total_f11 	= CDBL(v_adm_f11)-CDBL(v_subtotal_f11)	
								
									v_resul_total	 	= CDBL(v_adm_total)-CDBL(v_subtotal_grupo)	
									
									v_porc_total_f1	= (CDBL(v_resul_total_f1)*100)/CDBL(v_total_f1)
									v_porc_total_f2	= (CDBL(v_resul_total_f2)*100)/CDBL(v_total_f2)
									v_porc_total_f3	= (CDBL(v_resul_total_f3)*100)/CDBL(v_total_f3)
									v_porc_total_f4	= (CDBL(v_resul_total_f4)*100)/CDBL(v_total_f4)
									v_porc_total_f5	= (CDBL(v_resul_total_f5)*100)/CDBL(v_total_f5)
									v_porc_total_f6	= (CDBL(v_resul_total_f6)*100)/CDBL(v_total_f6)
									v_porc_total_f7	= (CDBL(v_resul_total_f7)*100)/CDBL(v_total_f7)
									v_porc_total_f8	= (CDBL(v_resul_total_f8)*100)/CDBL(v_total_f8)
									v_porc_total_f9	= (CDBL(v_resul_total_f9)*100)/CDBL(v_total_f9)
									v_porc_total_f10	= (CDBL(v_resul_total_f10)*100)/CDBL(v_total_f10)
									v_porc_total_f11	= (CDBL(v_resul_total_f11)*100)/CDBL(v_total_f11)
																											
									v_porc_total_total		= (CDBL(v_resul_total)*100)/CDBL(v_total_ingreso)	
									
									%>
								 <tr><th colspan="25" height="5"></th></tr>
								 <tr bordercolor='#999999'  bgcolor="#FFFFCC" align="right">
								 	<td align="left"><b>RESULTADO TOTAL</b></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f1,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f1,0)%></b>&nbsp;<strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f2,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f2,0)%></b>&nbsp;<strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f3,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f3,0)%></b>&nbsp;<strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f4,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f4,0)%></b>&nbsp;<strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f5,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f5,0)%></b>&nbsp;<strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f6,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f6,0)%></b>&nbsp;<strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f7,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f7,0)%></b>&nbsp;<strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f8,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f8,0)%></b>&nbsp;<strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f9,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f9,0)%></b>&nbsp;<strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f10,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f10,0)%></b>&nbsp;<strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total_f11,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_f11,0)%></b>&nbsp;<strong>%</strong></td>
									<td nowrap><b><%=formatnumber(v_resul_total,0,0)%></b></td>
									<td nowrap><b><%=Round(v_porc_total_total,0)%></b>&nbsp;<strong>%</strong></td>
								 </tr>
                              </table>
						<br/>
						</td>
                          </tr>
                        </table></td>
                      		<td width="7" background="../imagenes/marco_claro/10.gif">&nbsp;</td>
                   	</tr>
					  	<tr  class="noprint">
							<td align="left" valign="top"><img src="../imagenes/marco_claro/17.gif" width="9" height="28"></td>
							<td valign="top">
							<!-- desde aca -->
							<table  width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
                          		<tr > 
                            		<td width="47%" height="20"><div align="center"> 
                                		<table width="94%"  border="0" cellspacing="0" cellpadding="0">
										  	<tr> 
												<td width="100%">
													<%botonera.DibujaBoton ("imprimir")%>
												</td>
										  	</tr>
                                		</table>
                              </div></td>
								<td width="53%" rowspan="2" background="../imagenes/marco_claro/15.gif"><img src="../imagenes/marco_claro/14.gif" width="12" height="28"></td>
                          	</tr>
							   <tr> 
                            		<td height="8" background="../imagenes/marco_claro/13.gif"></td>
                       		  </tr>
							</table>
							<!-- hasta aca 
							<img src="../imagenes/marco_claro/15.gif" width="100%" height="13">--></td>
							<td align="right" valign="top" height="13"><img src="../imagenes/marco_claro/16.gif" width="7"height="28"></td>
					  	</tr>
                  </table>
					<br/>
                </td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
            </table>
			
            <table  class="noprint" width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                <td width="20%" bgcolor="#D8D8DE"><table width="100%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td ><% botonera.DibujaBoton ("lanzadera") %> </td>
                    </tr>
                  </table>
                </td>
                <td width="80%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                <td width="7" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
              </tr>
              <tr>
                <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
              </tr>
            </table>
			
        </td>
      </tr>
    </table>
	<p>&nbsp;</p></td>
  </tr>  
</table>
</body>
</html>