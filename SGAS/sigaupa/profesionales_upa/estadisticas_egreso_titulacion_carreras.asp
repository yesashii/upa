<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeOut = 300000
set pagina = new CPagina
pagina.Titulo = "Estadísticas egresados, titulados y graduados"
'-------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------

sede_ccod 	= request.QueryString("sede_ccod")
tipo      	= request.QueryString("tipo")
sexo_ccod 	= request.QueryString("sexo_ccod")
institucion	= request.QueryString("institucion")
facu_ccod	= request.QueryString("facu_ccod")
carr_ccod   = request.QueryString("carr_ccod")


set botonera = new CFormulario
botonera.Carga_Parametros "estadisticas_egreso_titulacion.xml", "botonera"

sede_tdesc = conexion.consultaUno("select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede_ccod&"'")

set f_lista = new CFormulario
f_lista.Carga_Parametros "tabla_vacia.xml", "tabla"
f_lista.Inicializar conexion

UEG_H = "#333333"
if tipo = "UEG" and sexo_ccod = 1 then
	UEG_H = "#0033FF"
end if
UEG_M = "#333333"
if tipo = "UEG" and sexo_ccod = 2 then
	UEG_M = "#0033FF"
end if
UTI_H = "#333333"
if tipo = "UTI" and sexo_ccod = 1 then
	UTI_H = "#0033FF"
end if
UTI_M = "#333333"
if tipo = "UTI" and sexo_ccod = 2 then
	UTI_M = "#0033FF"
end if
PRG_H = "#333333"
if tipo = "PRG" and sexo_ccod = 1 then
	PRG_H = "#0033FF"
end if
PRG_M = "#333333"
if tipo = "PRG" and sexo_ccod = 2 then
	PRG_M = "#0033FF"
end if
SIE_H = "#333333"
if tipo = "SIE" and sexo_ccod = 1 then
	SIE_H = "#0033FF"
end if
SIE_M = "#333333"
if tipo = "SIE" and sexo_ccod = 2 then
	SIE_M = "#0033FF"
end if
SIT_H = "#333333"
if tipo = "SIT" and sexo_ccod = 1 then
	SIT_H = "#0033FF"
end if
SIT_M = "#333333"
if tipo = "SIT" and sexo_ccod = 2 then
	SIT_M = "#0033FF"
end if
IEG_H = "#333333"
if tipo = "IEG" and sexo_ccod = 1 then
	IEG_H = "#0033FF"
end if
IEG_M = "#333333"
if tipo = "IEG" and sexo_ccod = 2 then
	IEG_M = "#0033FF"
end if
ITI_H = "#333333"
if tipo = "ITI" and sexo_ccod = 1 then
	ITI_H = "#0033FF"
end if
ITI_M = "#333333"
if tipo = "ITI" and sexo_ccod = 2 then
	ITI_M = "#0033FF"
end if
POG_H = "#333333"
if tipo = "POG" and sexo_ccod = 1 then
	POG_H = "#0033FF"
end if
POG_M = "#333333"
if tipo = "POG" and sexo_ccod = 2 then
	POG_H = "#0033FF"
end if


consulta =  "select distinct facu_ccod,carr_ccod, carr_tdesc  "& vbCrLf &_
			",protic.estadistica_titulados("&sede_ccod&",1,'U','UEG',facu_ccod,carr_ccod) as egresados_U_hombres  "& vbCrLf &_
			",protic.estadistica_titulados("&sede_ccod&",2,'U','UEG',facu_ccod,carr_ccod) as egresados_U_mujeres  "& vbCrLf &_
			",protic.estadistica_titulados("&sede_ccod&",1,'U','UTI',facu_ccod,carr_ccod) as titulados_U_hombres  "& vbCrLf &_
			",protic.estadistica_titulados("&sede_ccod&",2,'U','UTI',facu_ccod,carr_ccod) as titulados_U_mujeres   "& vbCrLf &_
			",protic.estadistica_titulados("&sede_ccod&",1,'U','PRG',facu_ccod,carr_ccod) as graduados_PR_hombres  "& vbCrLf &_
			",protic.estadistica_titulados("&sede_ccod&",2,'U','PRG',facu_ccod,carr_ccod) as graduados_PR_mujeres  "& vbCrLf &_
			",protic.estadistica_titulados("&sede_ccod&",1,'U','SIE',facu_ccod,carr_ccod) as SIE_hombres  "& vbCrLf &_
			",protic.estadistica_titulados("&sede_ccod&",2,'U','SIE',facu_ccod,carr_ccod) as SIE_mujeres  "& vbCrLf &_
			",protic.estadistica_titulados("&sede_ccod&",1,'U','SIT',facu_ccod,carr_ccod) as SIT_hombres  "& vbCrLf &_
			",protic.estadistica_titulados("&sede_ccod&",2,'U','SIT',facu_ccod,carr_ccod) as SIT_mujeres  "& vbCrLf &_
			",isnull(protic.estadistica_titulados("&sede_ccod&",1,'I','IEG',facu_ccod,carr_ccod),0) as egresados_I_hombres  "& vbCrLf &_
			",isnull(protic.estadistica_titulados("&sede_ccod&",2,'I','IEG',facu_ccod,carr_ccod),0) as egresados_I_mujeres  "& vbCrLf &_
			",isnull(protic.estadistica_titulados("&sede_ccod&",1,'I','ITI',facu_ccod,carr_ccod),0) as titulados_I_hombres  "& vbCrLf &_
			",isnull(protic.estadistica_titulados("&sede_ccod&",2,'I','ITI',facu_ccod,carr_ccod),0) as titulados_I_mujeres  "& vbCrLf &_
			",protic.estadistica_titulados("&sede_ccod&",1,'U','POG',facu_ccod,carr_ccod) as graduados_PO_hombres "& vbCrLf &_
			",protic.estadistica_titulados("&sede_ccod&",2,'U','POG',facu_ccod,carr_ccod) as graduados_PO_mujeres "& vbCrLf &_
            "FROM  "& vbCrLf &_
			"( "& vbCrLf &_
            "select distinct e.facu_ccod,c.carr_ccod,c.carr_tdesc  "& vbCrLf &_
			"            from alumnos_salidas_carrera a (nolock),   "& vbCrLf &_
			"            salidas_carrera b (nolock), carreras c (nolock),   "& vbCrLf &_
			"            areas_academicas d, facultades e,personas f (nolock)  "& vbCrLf &_
			"            where a.saca_ncorr = b.saca_ncorr and b.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"            and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"            and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (1,2,5)  "& vbCrLf &_
			"            and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "& vbCrLf &_
			"union  "& vbCrLf &_
			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc  "& vbCrLf &_
			"            from egresados_upa2 a (nolock),carreras c (nolock),  "& vbCrLf &_
			"            areas_academicas d, facultades e (nolock)   "& vbCrLf &_
			"            where a.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"            and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"            and a.ENTIDAD='U' and a.emat_ccod = 8  "& vbCrLf &_
			"            and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "& vbCrLf &_
			"            and not exists (select 1   "& vbCrLf &_
			"                            from alumnos_salidas_carrera tt (nolock),  "& vbCrLf &_
			"                            salidas_carrera t2 (nolock)  "& vbCrLf &_
			"                            where tt.saca_ncorr=t2.saca_ncorr  "& vbCrLf &_
			"                            and tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
			"                            and t2.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"                            and t2.tsca_ccod in (1,2,5))     "& vbCrLf &_
			"union  "& vbCrLf &_
			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc  "& vbCrLf &_
			"                from detalles_titulacion_carrera a (nolock), carreras c,   "& vbCrLf &_
			"                     areas_academicas d, facultades e,personas f (nolock)  "& vbCrLf &_
			"                where a.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"                and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"                and a.pers_ncorr=f.pers_ncorr   "& vbCrLf &_
			"                and isnull(protic.trunc(a.fecha_egreso),'') <> ''  "& vbCrLf &_
			"                and (select top 1 t2.sede_ccod  "& vbCrLf &_
			"                     from alumnos tt (nolock),   "& vbCrLf &_
			"                     ofertas_academicas t2, especialidades t3  "& vbCrLf &_
			"                     where tt.ofer_ncorr=t2.ofer_ncorr   "& vbCrLf &_
			"                     and t2.espe_ccod=t3.espe_ccod  "& vbCrLf &_
			"                     and tt.emat_ccod <> 9   "& vbCrLf &_
			"                     and tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
			"                     and t3.carr_ccod=c.carr_ccod   "& vbCrLf &_
			"                     order by t2.peri_ccod desc) = '"&sede_ccod&"'  "& vbCrLf &_
			"                and not exists (select 1 from salidas_carrera tt   "& vbCrLf &_
			"                                where tt.carr_ccod=a.carr_ccod   "& vbCrLf &_
			"                                and tt.saca_ncorr=a.plan_ccod   "& vbCrLf &_
			"                                and tt.tsca_ccod = 4)  "& vbCrLf &_
			"union  "& vbCrLf &_
			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc  "& vbCrLf &_
			"                from egresados_upa2 a (nolock),carreras c (nolock),  "& vbCrLf &_
			"                areas_academicas d, facultades e  "& vbCrLf &_
			"                where a.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"                and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"                and a.ENTIDAD='U' and a.emat_ccod in (4,8)  "& vbCrLf &_
			"                and cast(a.sede_ccod as varchar) = '"&sede_ccod&"'  "& vbCrLf &_
			"                and not exists (select 1   "& vbCrLf &_
			"                                from detalles_titulacion_carrera tt(nolock)  "& vbCrLf &_
			"                                where tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
			"                                and tt.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"                                and isnull(protic.trunc(tt.fecha_egreso),'') <> '')  "& vbCrLf &_
			"union  "& vbCrLf &_
			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc  "& vbCrLf &_
			"                from alumnos_salidas_carrera a (nolock),   "& vbCrLf &_
			"                salidas_carrera b (nolock), carreras c (nolock),   "& vbCrLf &_
			"                areas_academicas d, facultades e,personas f (nolock)  "& vbCrLf &_
			"                where a.saca_ncorr = b.saca_ncorr   "& vbCrLf &_
			"                and b.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"                and c.area_ccod=d.area_ccod   "& vbCrLf &_
			"                and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"                and a.pers_ncorr=f.pers_ncorr   "& vbCrLf &_
			"                and b.tsca_ccod in (3) and c.tcar_ccod=1  "& vbCrLf &_
			"                and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "& vbCrLf &_
			"union  "& vbCrLf &_
			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc  "& vbCrLf &_
			"                from alumnos_salidas_carrera a (nolock),   "& vbCrLf &_
			"                salidas_carrera b (nolock), carreras c (nolock),   "& vbCrLf &_
			"                areas_academicas d, facultades e,personas f (nolock),  "& vbCrLf &_
			"                alumnos_salidas_intermedias g (nolock)  "& vbCrLf &_
			"                where a.saca_ncorr = b.saca_ncorr   "& vbCrLf &_
			"                and b.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"                and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"                and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (4)  "& vbCrLf &_
			"                and a.saca_ncorr=g.saca_ncorr   "& vbCrLf &_
			"                and a.pers_ncorr=g.pers_ncorr and g.emat_ccod in (8)  "& vbCrLf &_
			"                and g.saca_ncorr in (756,764,774)  "& vbCrLf &_
			"                and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "& vbCrLf &_
			"union  "& vbCrLf &_
			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc   "& vbCrLf &_
			"            from alumnos_salidas_carrera a (nolock),   "& vbCrLf &_
			"            salidas_carrera b (nolock), carreras c (nolock),   "& vbCrLf &_
			"            areas_academicas d, facultades e,personas f (nolock),  "& vbCrLf &_
			"            alumnos_salidas_intermedias g (nolock)  "& vbCrLf &_
			"            where a.saca_ncorr = b.saca_ncorr and b.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"            and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"            and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (4)  "& vbCrLf &_
			"            and a.saca_ncorr=g.saca_ncorr and a.pers_ncorr=g.pers_ncorr  "& vbCrLf &_
			"            and g.emat_ccod in (4,8)  "& vbCrLf &_
			"            and g.saca_ncorr not in (756,764,774)  "& vbCrLf &_
			"            and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "& vbCrLf &_
			"union  "& vbCrLf &_
			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc   "& vbCrLf &_
			"            from alumnos_salidas_carrera a (nolock),   "& vbCrLf &_
			"            salidas_carrera b (nolock), carreras c (nolock),   "& vbCrLf &_
			"            areas_academicas d, facultades e,personas f (nolock),  "& vbCrLf &_
			"            alumnos_salidas_intermedias g (nolock)  "& vbCrLf &_
			"            where a.saca_ncorr = b.saca_ncorr and b.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"            and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"            and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (4)  "& vbCrLf &_
			"            and a.saca_ncorr=g.saca_ncorr   "& vbCrLf &_
			"            and a.pers_ncorr=g.pers_ncorr and g.emat_ccod in (8)  "& vbCrLf &_
			"            and g.saca_ncorr not in (756,764,774)  "& vbCrLf &_
			"            and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "& vbCrLf &_
			"union  "& vbCrLf &_
			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc   "& vbCrLf &_
			"            from egresados_upa2 a (nolock),carreras c (nolock),  "& vbCrLf &_
			"            areas_academicas d, facultades e  "& vbCrLf &_
			"            where a.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"                and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"                and a.ENTIDAD='I' and a.emat_ccod in (4,8)  "& vbCrLf &_
			"                and cast(a.sede_ccod as varchar) = '"&sede_ccod&"'  "& vbCrLf &_
			"                and not exists (select 1   "& vbCrLf &_
			"                                from detalles_titulacion_carrera tt (nolock)  "& vbCrLf &_
			"                                where tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
			"                                and tt.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"                                and isnull(protic.trunc(tt.fecha_egreso),'') <> '')  "& vbCrLf &_
			"union  "& vbCrLf &_
			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc   "& vbCrLf &_
			"            from egresados_upa2 a (nolock),carreras c (nolock),  "& vbCrLf &_
			"            areas_academicas d, facultades e (nolock)   "& vbCrLf &_
			"            where a.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"            and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"            and a.ENTIDAD='I' and a.emat_ccod = 8  "& vbCrLf &_
			"            and cast(a.sede_ccod as varchar)='"&sede_ccod&"'  "& vbCrLf &_
			"            and not exists (select 1   "& vbCrLf &_
			"                            from alumnos_salidas_carrera tt (nolock),  "& vbCrLf &_
			"                            salidas_carrera t2 (nolock)  "& vbCrLf &_
			"                            where tt.saca_ncorr=t2.saca_ncorr  "& vbCrLf &_
			"                            and tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
			"                            and t2.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"                            and t2.tsca_ccod in (1,2,5))  "& vbCrLf &_
			"union  "& vbCrLf &_
			"select distinct  e.facu_ccod,c.carr_ccod,c.carr_tdesc   "& vbCrLf &_
			"                from alumnos_salidas_carrera a (nolock),   "& vbCrLf &_
			"                salidas_carrera b (nolock), carreras c (nolock),   "& vbCrLf &_
			"                areas_academicas d, facultades e,personas f (nolock)  "& vbCrLf &_
			"                where a.saca_ncorr = b.saca_ncorr   "& vbCrLf &_
			"                and b.carr_ccod=c.carr_ccod  "& vbCrLf &_
			"                and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
			"                and a.pers_ncorr=f.pers_ncorr   "& vbCrLf &_
			"                and b.tsca_ccod in (3) and c.tcar_ccod=2  "& vbCrLf &_
			"                and cast(a.sede_ccod as varchar)='"&sede_ccod&"'"& vbCrLf &_
			" ) ttr "& vbCrLf &_
			" ORDER BY carr_tdesc ASC "

f_lista.Consultar consulta 
			

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
function enviar(formulario){
           	formulario.action ="estadisticas_egreso_titulacion.asp";//?matr_ncorr="+matricula+"&pers_ncorr="+pers+"&sede_ccod="+sede+"&plan_ccod="+plan+"&peri_ccod="+periodo+"&asig_ccod="+asignatura;
			formulario.submit();
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
            <td><%pagina.DibujarLenguetas Array("Distribución por carreras"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%>
			  </div>
            </td>
		  </tr>
		  <tr>
            <td align="right" height="30">&nbsp;</td>
		  </tr>
		  <form name="edicion" method="post">
		  <tr>
		  	<td align="center">
				<script language='javaScript1.2'> colores = Array(3);   colores[0] = ''; colores[1] = '#FFECC6'; colores[2] = '#FFECC6'; </script>
				<table class='v1' width='100%' border='1' cellpadding='0' cellspacing='0' bordercolor='#999999' bgcolor='#ADADAD' id='tb_secciones'>
				<tr bgcolor='#C4D7FF' bordercolor='#999999'>
					<th><font color='#333333'>&nbsp;</font></th>
					<th colspan="10"><font color='#333333'>Universidad Pregrado</font></th>
					<th colspan="2"><font color='#333333'>Universidad Postgrado</font></th>
					<th colspan="4"><font color='#333333'>Instituto</font></th>
				</tr>
				<tr bgcolor='#C4D7FF' bordercolor='#999999'>
					<th><font color='#333333'><%=sede_tdesc%></font></th>
					<th colspan="2"><font color='#333333'>Egresados</font></th>
					<th colspan="2"><font color='#333333'>Titulados</font></th>
					<th colspan="2"><font color='#333333'>Grados</font></th>
					<th colspan="2"><font color='#333333'>S.I.E</font></th>
					<th colspan="2"><font color='#333333'>S.I.T</font></th>
					<th colspan="2"><font color='#333333'>Grados</font></th>
					<th colspan="2"><font color='#333333'>Egresados</font></th>
					<th colspan="2"><font color='#333333'>Titulados</font></th>
				</tr>
				<tr bgcolor='#C4D7FF' bordercolor='#999999'>
						<th><font color='#333333'>&nbsp;</font></th>
						<th><font color='<%=UEG_H%>'>H</font></th>
						<th><font color='<%=UEG_M%>'>M</font></th>
						<th><font color='<%=UTI_H%>'>H</font></th>
						<th><font color='<%=UTI_M%>'>M</font></th>
						<th><font color='<%=PRG_H%>'>H</font></th>
						<th><font color='<%=PRG_M%>'>M</font></th>
						<th><font color='<%=SIE_H%>'>H</font></th>
						<th><font color='<%=SIE_M%>'>M</font></th>
						<th><font color='<%=SIT_H%>'>H</font></th>
						<th><font color='<%=SIT_M%>'>M</font></th>
						<th><font color='<%=POG_H%>'>H</font></th>
						<th><font color='<%=POG_M%>'>M</font></th>
					    <th><font color='<%=IEG_H%>'>H</font></th>
						<th><font color='<%=IEG_M%>'>M</font></th>
						<th><font color='<%=ITI_H%>'>H</font></th>
						<th><font color='<%=ITI_M%>'>M</font></th>
				</tr>
				<%  TEUH = 0
					TEUM = 0
					TTUH = 0
					TTUM = 0
					TGPH = 0
					TGPM = 0
					TESH = 0
					TESM = 0
					TTSH = 0
					TTSM = 0
					TEIH = 0
					TEIM = 0
					TTIH = 0
					TTIM = 0
					TGGH = 0
					TGGM = 0
					num=1
				  while f_lista.siguiente
				    carr_ccod = f_lista.obtenerValor("carr_ccod")
					facu_ccod = f_lista.obtenerValor("facu_ccod")
					carrera   = f_lista.obtenerValor("carr_tdesc")
					EUH       = f_lista.obtenerValor("egresados_U_hombres")
					TEUH = TEUH + cint(EUH)
				    EUM       = f_lista.obtenerValor("egresados_U_mujeres")
					TEUM = TEUM + cint(EUM)
					TUH       = f_lista.obtenerValor("titulados_U_hombres")
					TTUH = TTUH + cint(TUH)
					TUM       = f_lista.obtenerValor("titulados_U_mujeres")
					TTUM = TTUM + cint(TUM) 
					GPH       = f_lista.obtenerValor("graduados_PR_hombres")
					TGPH = TGPH + cint(GPH)
					GPM       = f_lista.obtenerValor("graduados_PR_mujeres")
					TGPM = TGPM + cint(GPM)
					ESH       = f_lista.obtenerValor("SIE_hombres")
					TESH = TESH + cint(ESH)
					ESM       = f_lista.obtenerValor("SIE_mujeres")
					TESM = TESM + cint(ESM)
					TSH       = f_lista.obtenerValor("SIT_hombres")
					TTSH = TTSH + cint(TSH)
					TSM       = f_lista.obtenerValor("SIT_mujeres")
					TTSM = TTSM + cint(TSM)
					EIH       = f_lista.obtenerValor("egresados_I_hombres")
					TEIH = TEIH + cint(EIH)
					EIM       = f_lista.obtenerValor("egresados_I_mujeres")
					TEIM = TEIM + cint(EIM)
					TIH       = f_lista.obtenerValor("titulados_I_hombres")
					TTIH = TTIH + cint(TIH)
					TIM       = f_lista.obtenerValor("titulados_I_mujeres")
					TTIM = TTIM + cint(TIM)
					GGH       = f_lista.obtenerValor("graduados_PO_hombres")
					TGGH = TGGH + cint(GGH)
					GGM       = f_lista.obtenerValor("graduados_PO_mujeres")
					TGGM = TGGM + cint(GGM)
%>
				<tr bgcolor="#FFFFFF">
				    <input type="hidden" name="campo_<%=num%>_carrera" value="<%=carrera%>">
					<input type="hidden" name="campo_<%=num%>_c1" value="<%=EUH%>">
					<input type="hidden" name="campo_<%=num%>_c2" value="<%=EUM%>">
					<input type="hidden" name="campo_<%=num%>_c3" value="<%=TUH%>">
					<input type="hidden" name="campo_<%=num%>_c4" value="<%=TUM%>">
					<input type="hidden" name="campo_<%=num%>_c5" value="<%=GPH%>">
					<input type="hidden" name="campo_<%=num%>_c6" value="<%=GPM%>">
					<input type="hidden" name="campo_<%=num%>_c7" value="<%=ESH%>">
					<input type="hidden" name="campo_<%=num%>_c8" value="<%=ESM%>">
					<input type="hidden" name="campo_<%=num%>_c9" value="<%=TSH%>">
					<input type="hidden" name="campo_<%=num%>_c10" value="<%=TSM%>">
					<input type="hidden" name="campo_<%=num%>_c11" value="<%=GGH%>">
					<input type="hidden" name="campo_<%=num%>_c12" value="<%=GGM%>">
					<input type="hidden" name="campo_<%=num%>_c13" value="<%=EIH%>">
					<input type="hidden" name="campo_<%=num%>_c14" value="<%=EIM%>">
					<input type="hidden" name="campo_<%=num%>_c15" value="<%=TIH%>">
					<input type="hidden" name="campo_<%=num%>_c16" value="<%=TIM%>">
					<td align='LEFT' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font size="1"><%=carrera%></font></td>
					<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_personas.asp?sede_ccod=<%=sede_ccod%>&tipo=UEG&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=UEG_H%>'><%=EUH%></font></td>
					<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_personas.asp?sede_ccod=<%=sede_ccod%>&tipo=UEG&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=UEG_M%>'><%=EUM%></font></td>
					<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_personas.asp?sede_ccod=<%=sede_ccod%>&tipo=UTI&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=UTI_H%>'><%=TUH%></font></td>
					<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_personas.asp?sede_ccod=<%=sede_ccod%>&tipo=UTI&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=UTI_M%>'><%=TUM%></font></td>
					<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_personas.asp?sede_ccod=<%=sede_ccod%>&tipo=PRG&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=PRG_H%>'><%=GPH%></font></td>
					<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_personas.asp?sede_ccod=<%=sede_ccod%>&tipo=PRG&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=PRG_M%>'><%=GPM%></font></td>
					<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_personas.asp?sede_ccod=<%=sede_ccod%>&tipo=SIE&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=SIE_H%>'><%=ESH%></font></td>
					<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_personas.asp?sede_ccod=<%=sede_ccod%>&tipo=SIE&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=SIE_M%>'><%=ESM%></font></td>
					<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_personas.asp?sede_ccod=<%=sede_ccod%>&tipo=SIT&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=SIT_H%>'><%=TSH%></font></td>
					<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_personas.asp?sede_ccod=<%=sede_ccod%>&tipo=SIT&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=SIT_M%>'><%=TSM%></font></td>
					<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_personas.asp?sede_ccod=<%=sede_ccod%>&tipo=POG&sexo_ccod=1&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=POG_H%>'><%=GGH%></font></td>
					<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_personas.asp?sede_ccod=<%=sede_ccod%>&tipo=POG&sexo_ccod=2&institucion=U&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=POG_M%>'><%=GGM%></font></td>
					<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_personas.asp?sede_ccod=<%=sede_ccod%>&tipo=IEG&sexo_ccod=1&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=IEG_H%>'><%=EIH%></font></td>
					<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_personas.asp?sede_ccod=<%=sede_ccod%>&tipo=IEG&sexo_ccod=2&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=IEG_M%>'><%=EIM%></font></td>
					<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_personas.asp?sede_ccod=<%=sede_ccod%>&tipo=ITI&sexo_ccod=1&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=ITI_H%>'><%=TIH%></font></td>
					<td align='CENTER' class='click' onClick='irA("estadisticas_egreso_titulacion_personas.asp?sede_ccod=<%=sede_ccod%>&tipo=ITI&sexo_ccod=2&institucion=I&facu_ccod=<%=facu_ccod%>&carr_ccod=<%=carr_ccod%>", "2", 600, 400)' onMouseOver='resaltar(this)' onMouseOut='desResaltar(this)' ><font color='<%=ITI_M%>'><%=TIM%></font></td>
				</tr>
				<%num = num + 1
				  wend%>
				<tr bgcolor="#FFFFFF">
				    <input type="hidden" name="campo_<%=num%>_carrera" value="TOTALES">
					<input type="hidden" name="campo_<%=num%>_c1" value="<%=TEUH%>">
					<input type="hidden" name="campo_<%=num%>_c2" value="<%=TEUM%>">
					<input type="hidden" name="campo_<%=num%>_c3" value="<%=TTUH%>">
					<input type="hidden" name="campo_<%=num%>_c4" value="<%=TTUM%>">
					<input type="hidden" name="campo_<%=num%>_c5" value="<%=TGPH%>">
					<input type="hidden" name="campo_<%=num%>_c6" value="<%=TGPM%>">
					<input type="hidden" name="campo_<%=num%>_c7" value="<%=TESH%>">
					<input type="hidden" name="campo_<%=num%>_c8" value="<%=TESM%>">
					<input type="hidden" name="campo_<%=num%>_c9" value="<%=TTSH%>">
					<input type="hidden" name="campo_<%=num%>_c10" value="<%=TTSM%>">
					<input type="hidden" name="campo_<%=num%>_c11" value="<%=TGGH%>">
					<input type="hidden" name="campo_<%=num%>_c12" value="<%=TGGM%>">
					<input type="hidden" name="campo_<%=num%>_c13" value="<%=TEIH%>">
					<input type="hidden" name="campo_<%=num%>_c14" value="<%=TEIM%>">
					<input type="hidden" name="campo_<%=num%>_c15" value="<%=TTIH%>">
					<input type="hidden" name="campo_<%=num%>_c16" value="<%=TTIM%>">
					<td align='right'>TOTALES</td>
					<td align='CENTER'><font color='<%=UEG_H%>'><strong><%=TEUH%></strong></font></td>
					<td align='CENTER'><font color='<%=UEG_M%>'><strong><%=TEUM%></strong></font></td>
					<td align='CENTER'><font color='<%=UTI_H%>'><strong><%=TTUH%></strong></font></td>
					<td align='CENTER'><font color='<%=UTI_M%>'><strong><%=TTUM%></strong></font></td>
					<td align='CENTER'><font color='<%=PRG_H%>'><strong><%=TGPH%></strong></font></td>
					<td align='CENTER'><font color='<%=PRG_M%>'><strong><%=TGPM%></strong></font></td>
					<td align='CENTER'><font color='<%=SIE_H%>'><strong><%=TESH%></strong></font></td>
					<td align='CENTER'><font color='<%=SIE_M%>'><strong><%=TESM%></strong></font></td>
					<td align='CENTER'><font color='<%=SIT_H%>'><strong><%=TTSH%></strong></font></td>
					<td align='CENTER'><font color='<%=SIT_M%>'><strong><%=TTSM%></strong></font></td>
					<td align='CENTER'><font color='<%=POG_H%>'><strong><%=TGGH%></strong></font></td>
					<td align='CENTER'><font color='<%=POG_M%>'><strong><%=TGGM%></strong></font></td>
					<td align='CENTER'><font color='<%=IEG_H%>'><strong><%=TEIH%></strong></font></td>
					<td align='CENTER'><font color='<%=IEG_M%>'><strong><%=TEIM%></strong></font></td>
					<td align='CENTER'><font color='<%=ITI_H%>'><strong><%=TTIH%></strong></font></td>
					<td align='CENTER'><font color='<%=ITI_M%>'><strong><%=TTIM%></strong></font></td>
				</tr>
			   </table>
			</td>
		  </tr>
		    <input type="hidden" name="sede" value="<%=sede_tdesc%>">
		    <input type="hidden" name="registros" value="<%=num%>">
		  </form>
		  <tr>
            <td align="right">* Presione sobre el n&uacute;mero de inter&eacute;s para visualizar el dato a un detalle mayor.</td>
		  </tr>
		  <tr>
            <td align="right" height="50">&nbsp;</td>
		  </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="18%" height="20"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td><div align="center"><%
						                          url_1 = "estadisticas_egreso_titulacion.asp"
						                          botonera.agregaBotonParam "volver","url",url_1
												  botonera.dibujaBoton "volver" 
												 %></div></td>
						<td><div align="center">
						    <% 
							   url_2 = "estadisticas_egreso_titulacion_carreras_excel.asp"
 							   botonera.agregaBotonParam "excel","url",url_2
							   botonera.dibujaBoton "excel"
							%>
							</div>
						</td>
                      </tr>
                    </table>
            </div></td>
            <td width="82%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
