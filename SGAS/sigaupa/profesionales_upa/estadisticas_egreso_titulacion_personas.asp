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
carr_tdesc = conexion.consultaUno("select carr_tdesc from carreras where cast(carr_ccod as varchar)='"&carr_ccod&"'")
facu_tdesc = conexion.consultaUno("select facu_tdesc from facultades where cast(facu_ccod as varchar)='"&facu_ccod&"'")
sexo_tdesc = conexion.consultaUno("select sexo_tdesc from sexos where cast(sexo_ccod as varchar)='"&sexo_ccod&"'")
fecha1	   = conexion.consultaUno("select getDate()")
estado = ""
categoria = "PREGRADO"
institucion = "UNIVERSIDAD"
insti		= "U"
query = ""

set f_personas = new cformulario
f_personas.carga_parametros "estadisticas_egreso_titulacion.xml","personas"
f_personas.inicializar conexion

if tipo = "UEG" then
	estado = "Egresados de Universidad"
	query = "select distinct cast(f.pers_nrut as varchar)+'-'+f.pers_xdv as rut, f.pers_tape_paterno + ' ' + f.pers_tape_materno + ', ' + f.pers_tnombre as nombre, protic.ano_ingreso_carrera_egresa2(f.pers_ncorr,c.carr_ccod) as ano_ingreso  "& vbCrLf &_
            "    from detalles_titulacion_carrera a (nolock), carreras c,   "& vbCrLf &_
            "         areas_academicas d, facultades e,personas f (nolock)  "& vbCrLf &_
            "    where a.carr_ccod=c.carr_ccod  "& vbCrLf &_
            "    and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod   "& vbCrLf &_
            "    and a.pers_ncorr=f.pers_ncorr and isnull(protic.trunc(a.fecha_egreso),'')<>''  "& vbCrLf &_
            "    and e.facu_ccod = case when "&facu_ccod&" = 0 then e.facu_ccod else "&facu_ccod&" end  "& vbCrLf &_
            "    and c.carr_ccod = case when '"&carr_ccod&"' = '0' then c.carr_ccod else '"&carr_ccod&"' end  "& vbCrLf &_
            "    and (select top 1 t2.sede_ccod  "& vbCrLf &_
            "         from alumnos tt (nolock), ofertas_academicas t2, especialidades t3  "& vbCrLf &_
            "         where tt.ofer_ncorr=t2.ofer_ncorr and t2.espe_ccod=t3.espe_ccod  "& vbCrLf &_
            "         and tt.emat_ccod <> 9 and tt.pers_ncorr=a.pers_ncorr   "& vbCrLf &_
            "         and t3.carr_ccod=c.carr_ccod order by t2.peri_ccod desc) = "&sede_ccod&"  "& vbCrLf &_
            "    and cast(isnull(f.sexo_ccod,1) as varchar) = "&sexo_ccod&"  "& vbCrLf &_
            "    and not exists (select 1 from salidas_carrera tt where tt.carr_ccod=a.carr_ccod   "& vbCrLf &_
            "                    and tt.saca_ncorr=a.plan_ccod and tt.tsca_ccod = 4)  "& vbCrLf &_
            "    union  "& vbCrLf &_
            "    select distinct cast(f.pers_nrut as varchar)+'-'+f.pers_xdv as rut, f.pers_tape_paterno + ' ' + f.pers_tape_materno + ', ' + f.pers_tnombre as nombre, protic.ano_ingreso_carrera_egresa2(f.pers_ncorr,c.carr_ccod) as ano_ingreso    "& vbCrLf &_
            "    from egresados_upa2 a (nolock),carreras c (nolock),  "& vbCrLf &_
            "    areas_academicas d, facultades e,personas f (nolock)  "& vbCrLf &_
            "    where a.carr_ccod=c.carr_ccod  "& vbCrLf &_
            "    and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod and a.pers_ncorr=f.pers_ncorr  "& vbCrLf &_
            "    and a.ENTIDAD='U' and a.emat_ccod in (4,8)  "& vbCrLf &_
            "    and cast(a.sede_ccod as varchar) = "&sede_ccod&"  "& vbCrLf &_
            "    and e.facu_ccod = case when "&facu_ccod&" = 0 then e.facu_ccod else "&facu_ccod&" end  "& vbCrLf &_
            "    and c.carr_ccod = case when '"&carr_ccod&"' = '0' then c.carr_ccod else '"&carr_ccod&"' end  "& vbCrLf &_
            "    and cast(isnull(a.sexo_ccod,1) as varchar)= "&sexo_ccod&"  "& vbCrLf &_
            "    and not exists (select 1 from detalles_titulacion_carrera tt (nolock)  "& vbCrLf &_
            "                    where tt.pers_ncorr=a.pers_ncorr and tt.carr_ccod=c.carr_ccod  "& vbCrLf &_
            "                    and isnull(protic.trunc(tt.fecha_egreso),'') <> '') order by nombre asc"
end if
if tipo = "UTI" then
	estado = "Titulados de Universidad"
	query= "select distinct cast(f.pers_nrut as varchar)+'-'+f.pers_xdv as rut, f.pers_tape_paterno + ' ' + f.pers_tape_materno + ', ' + f.pers_tnombre as nombre,protic.ano_ingreso_carrera_egresa2(f.pers_ncorr,c.carr_ccod) as ano_ingreso   "& vbCrLf &_
           " from alumnos_salidas_carrera a (nolock), salidas_carrera b (nolock), carreras c (nolock), "& vbCrLf &_ 
           "      areas_academicas d, facultades e,personas f (nolock) "& vbCrLf &_
           " where a.saca_ncorr = b.saca_ncorr and b.carr_ccod=c.carr_ccod "& vbCrLf &_
           " and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod  "& vbCrLf &_
           " and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (1,2,5) "& vbCrLf &_
           " and e.facu_ccod = case when "&facu_ccod&" = 0 then e.facu_ccod else "&facu_ccod&" end "& vbCrLf &_
           " and c.carr_ccod = case when '"&carr_ccod&"' = '0' then c.carr_ccod else '"&carr_ccod&"' end "& vbCrLf &_
           " and cast(a.sede_ccod as varchar)="&sede_ccod&" "& vbCrLf &_
           " and cast(isnull(f.sexo_ccod,1) as varchar)="&sexo_ccod&" "& vbCrLf &_
           " union "& vbCrLf &_
           " select distinct cast(f.pers_nrut as varchar)+'-'+f.pers_xdv as rut, f.pers_tape_paterno + ' ' + f.pers_tape_materno + ', ' + f.pers_tnombre as nombre,protic.ano_ingreso_carrera_egresa2(f.pers_ncorr,c.carr_ccod) as ano_ingreso   "& vbCrLf &_
           " from egresados_upa2 a (nolock),carreras c (nolock), "& vbCrLf &_
           " areas_academicas d, facultades e (nolock),personas f (nolock)  "& vbCrLf &_
           " where a.carr_ccod=c.carr_ccod "& vbCrLf &_
           " and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod and a.pers_ncorr=f.pers_ncorr "& vbCrLf &_
           " and a.ENTIDAD='U' and a.emat_ccod = 8 "& vbCrLf &_
           " and cast(a.sede_ccod as varchar)="&sede_ccod&" "& vbCrLf &_
           " and cast(isnull(a.sexo_ccod,1) as varchar)="&sexo_ccod&" "& vbCrLf &_ 
           " and e.facu_ccod = case when "&facu_ccod&" = 0 then e.facu_ccod else "&facu_ccod&" end "& vbCrLf &_
           " and c.carr_ccod = case when '"&carr_ccod&"' = '0' then c.carr_ccod else '"&carr_ccod&"' end "& vbCrLf &_
           " and not exists (select 1 from alumnos_salidas_carrera tt (nolock), salidas_carrera t2 (nolock) "& vbCrLf &_
           "                 where tt.saca_ncorr=t2.saca_ncorr "& vbCrLf &_
           "                 and tt.pers_ncorr=a.pers_ncorr and t2.carr_ccod=c.carr_ccod "& vbCrLf &_
           "                 and t2.tsca_ccod in (1,2,5)) order by nombre asc"
end if
if tipo = "PRG" then
	estado = "Graduados de Universidad"
	query= "select distinct cast(f.pers_nrut as varchar)+'-'+f.pers_xdv as rut, f.pers_tape_paterno + ' ' + f.pers_tape_materno + ', ' + f.pers_tnombre as nombre,protic.ano_ingreso_carrera_egresa2(f.pers_ncorr,c.carr_ccod) as ano_ingreso   "& vbCrLf &_
           "     from alumnos_salidas_carrera a (nolock), salidas_carrera b (nolock), carreras c (nolock),  "& vbCrLf &_
           "          areas_academicas d, facultades e,personas f (nolock) "& vbCrLf &_
           "     where a.saca_ncorr = b.saca_ncorr and b.carr_ccod=c.carr_ccod "& vbCrLf &_
           "     and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod  "& vbCrLf &_
           "     and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (3) and c.tcar_ccod=1 "& vbCrLf &_
           "     and cast(a.sede_ccod as varchar)="&sede_ccod&" "& vbCrLf &_
           "     and e.facu_ccod = case when "&facu_ccod&" = 0 then e.facu_ccod else "&facu_ccod&" end "& vbCrLf &_
           "     and c.carr_ccod = case when '"&carr_ccod&"' = '0' then c.carr_ccod else '"&carr_ccod&"' end "& vbCrLf &_
           "     and cast(isnull(f.sexo_ccod,1) as varchar)="&sexo_ccod&" "& vbCrLf &_
           "     union "& vbCrLf &_
           "     select distinct cast(f.pers_nrut as varchar)+'-'+f.pers_xdv as rut, f.pers_tape_paterno + ' ' + f.pers_tape_materno + ', ' + f.pers_tnombre as nombre,protic.ano_ingreso_carrera_egresa2(f.pers_ncorr,c.carr_ccod) as ano_ingreso   "& vbCrLf &_
           "     from alumnos_salidas_carrera a (nolock), salidas_carrera b (nolock), carreras c (nolock),  "& vbCrLf &_
           "          areas_academicas d, facultades e,personas f (nolock), alumnos_salidas_intermedias g (nolock) "& vbCrLf &_
           "     where a.saca_ncorr = b.saca_ncorr and b.carr_ccod=c.carr_ccod "& vbCrLf &_
           "     and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod  "& vbCrLf &_
           "     and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (4) "& vbCrLf &_
           "     and a.saca_ncorr=g.saca_ncorr and a.pers_ncorr=g.pers_ncorr and g.emat_ccod in (8) "& vbCrLf &_
           "     and g.saca_ncorr in (756,764,774) "& vbCrLf &_
           "     and e.facu_ccod = case when "&facu_ccod&" = 0 then e.facu_ccod else "&facu_ccod&" end "& vbCrLf &_
           "     and c.carr_ccod = case when '"&carr_ccod&"' = '0' then c.carr_ccod else '"&carr_ccod&"' end "& vbCrLf &_
           "     and cast(a.sede_ccod as varchar)="&sede_ccod&" "& vbCrLf &_
           "     and cast(isnull(f.sexo_ccod,1) as varchar)="&sexo_ccod&" order by nombre asc"
end if
if tipo = "SIE" then
	estado = "Egresados de Salidas Intermedias"
	query= "select distinct cast(f.pers_nrut as varchar)+'-'+f.pers_xdv as rut, f.pers_tape_paterno + ' ' + f.pers_tape_materno + ', ' + f.pers_tnombre as nombre,protic.ano_ingreso_carrera_egresa2(f.pers_ncorr,c.carr_ccod) as ano_ingreso    "& vbCrLf &_
           " from alumnos_salidas_carrera a (nolock), salidas_carrera b (nolock), carreras c (nolock),  "& vbCrLf &_
           "      areas_academicas d, facultades e,personas f (nolock), alumnos_salidas_intermedias g (nolock) "& vbCrLf &_
           " where a.saca_ncorr = b.saca_ncorr and b.carr_ccod=c.carr_ccod "& vbCrLf &_
           " and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod  "& vbCrLf &_
           " and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (4) "& vbCrLf &_
           " and a.saca_ncorr=g.saca_ncorr and a.pers_ncorr=g.pers_ncorr and g.emat_ccod in (4,8) "& vbCrLf &_
           " and g.saca_ncorr not in (756,764,774) "& vbCrLf &_
           " and e.facu_ccod = case when "&facu_ccod&" = 0 then e.facu_ccod else "&facu_ccod&" end "& vbCrLf &_
           " and c.carr_ccod = case when '"&carr_ccod&"' = '0' then c.carr_ccod else '"&carr_ccod&"' end "& vbCrLf &_
           " and cast(a.sede_ccod as varchar)="&sede_ccod&" "& vbCrLf &_
           " and cast(isnull(f.sexo_ccod,1) as varchar)="&sexo_ccod&" order by nombre asc"
end if
if tipo = "SIT" then
	estado = "Titulados de Salidas Intermedias"
	query= "select distinct cast(f.pers_nrut as varchar)+'-'+f.pers_xdv as rut, f.pers_tape_paterno + ' ' + f.pers_tape_materno + ', ' + f.pers_tnombre as nombre,protic.ano_ingreso_carrera_egresa2(f.pers_ncorr,c.carr_ccod) as ano_ingreso   "& vbCrLf &_ 
           " from alumnos_salidas_carrera a (nolock), salidas_carrera b (nolock), carreras c (nolock),  "& vbCrLf &_
           "      areas_academicas d, facultades e,personas f (nolock), alumnos_salidas_intermedias g (nolock) "& vbCrLf &_
           " where a.saca_ncorr = b.saca_ncorr and b.carr_ccod=c.carr_ccod "& vbCrLf &_
           " and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod  "& vbCrLf &_
           " and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (4) "& vbCrLf &_
           " and a.saca_ncorr=g.saca_ncorr and a.pers_ncorr=g.pers_ncorr and g.emat_ccod in (8) "& vbCrLf &_
           " and g.saca_ncorr not in (756,764,774) "& vbCrLf &_
           " and e.facu_ccod = case when "&facu_ccod&" = 0 then e.facu_ccod else "&facu_ccod&" end "& vbCrLf &_
           " and c.carr_ccod = case when '"&carr_ccod&"' = '0' then c.carr_ccod else '"&carr_ccod&"' end "& vbCrLf &_
           " and cast(a.sede_ccod as varchar)="&sede_ccod&" "& vbCrLf &_
           " and cast(isnull(f.sexo_ccod,1) as varchar)="&sexo_ccod&" order by nombre asc"
end if
if tipo = "IEG" then
	estado = "Egresados de Instituto"
	institucion = "INSTITUTO"
	insti		= "I"
	query ="select distinct cast(f.pers_nrut as varchar)+'-'+f.pers_xdv as rut, f.pers_tape_paterno + ' ' + f.pers_tape_materno + ', ' + f.pers_tnombre as nombre,protic.ano_ingreso_carrera_egresa2(f.pers_ncorr,c.carr_ccod) as ano_ingreso   "& vbCrLf &_
           " from egresados_upa2 a (nolock),carreras c (nolock), "& vbCrLf &_
           "     areas_academicas d, facultades e,personas f (nolock) "& vbCrLf &_
           " where a.carr_ccod=c.carr_ccod "& vbCrLf &_
           "     and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod  and a.pers_ncorr=f.pers_ncorr "& vbCrLf &_
           "     and a.ENTIDAD='I' and a.emat_ccod in (4,8) "& vbCrLf &_
           "     and cast(a.sede_ccod as varchar) = "&sede_ccod&" "& vbCrLf &_
           "     and cast(isnull(a.sexo_ccod,1) as varchar)= "&sexo_ccod&" "& vbCrLf &_
           "     and e.facu_ccod = case when "&facu_ccod&" = 0 then e.facu_ccod else "&facu_ccod&" end "& vbCrLf &_
           "     and c.carr_ccod = case when '"&carr_ccod&"' = '0' then c.carr_ccod else '"&carr_ccod&"' end "& vbCrLf &_
           "     and not exists (select 1 from detalles_titulacion_carrera tt (nolock) "& vbCrLf &_
           "                     where tt.pers_ncorr=a.pers_ncorr and tt.carr_ccod=c.carr_ccod "& vbCrLf &_
           "                     and isnull(protic.trunc(tt.fecha_egreso),'') <> '') order by nombre asc"
end if
if tipo = "ITI" then
	estado = "Titulados de Instituto"
	institucion = "INSTITUTO"
	insti		= "I"
	query= " select distinct cast(f.pers_nrut as varchar)+'-'+f.pers_xdv as rut, f.pers_tape_paterno + ' ' + f.pers_tape_materno + ', ' + f.pers_tnombre as nombre,protic.ano_ingreso_carrera_egresa2(f.pers_ncorr,c.carr_ccod) as ano_ingreso    "& vbCrLf &_
           " from egresados_upa2 a (nolock),carreras c (nolock), "& vbCrLf &_
           " areas_academicas d, facultades e (nolock),personas f (nolock)  "& vbCrLf &_
           " where a.carr_ccod=c.carr_ccod "& vbCrLf &_
           " and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod and a.pers_ncorr=f.pers_ncorr "& vbCrLf &_
           " and a.ENTIDAD='I' and a.emat_ccod = 8 "& vbCrLf &_
           " and cast(a.sede_ccod as varchar)="&sede_ccod&" "& vbCrLf &_
           " and cast(isnull(a.sexo_ccod,1) as varchar)="&sexo_ccod&"  "& vbCrLf &_
           " and e.facu_ccod = case when "&facu_ccod&" = 0 then e.facu_ccod else "&facu_ccod&" end "& vbCrLf &_
           " and c.carr_ccod = case when '"&carr_ccod&"' = '0' then c.carr_ccod else '"&carr_ccod&"' end "& vbCrLf &_
           " and not exists (select 1 from alumnos_salidas_carrera tt (nolock), salidas_carrera t2 (nolock) "& vbCrLf &_
           "                 where tt.saca_ncorr=t2.saca_ncorr "& vbCrLf &_
           "                 and tt.pers_ncorr=a.pers_ncorr and t2.carr_ccod=c.carr_ccod "& vbCrLf &_
           "                 and t2.tsca_ccod in (1,2,5)) order by nombre asc"
end if
if tipo = "POG" then
	estado = "Graduados de Universidad"
	categoria = "POSTGRADO"
	query= " select distinct cast(f.pers_nrut as varchar)+'-'+f.pers_xdv as rut, f.pers_tape_paterno + ' ' + f.pers_tape_materno + ', ' + f.pers_tnombre as nombre,protic.ano_ingreso_carrera_egresa2(f.pers_ncorr,c.carr_ccod) as ano_ingreso   "& vbCrLf &_
           "     from alumnos_salidas_carrera a (nolock), salidas_carrera b (nolock), carreras c (nolock),  "& vbCrLf &_
           "          areas_academicas d, facultades e,personas f (nolock) "& vbCrLf &_
           "     where a.saca_ncorr = b.saca_ncorr and b.carr_ccod=c.carr_ccod "& vbCrLf &_
           "     and c.area_ccod=d.area_ccod and d.facu_ccod=e.facu_ccod  "& vbCrLf &_
           "     and a.pers_ncorr=f.pers_ncorr and b.tsca_ccod in (3) and c.tcar_ccod=2 "& vbCrLf &_
           "     and e.facu_ccod = case when "&facu_ccod&" = 0 then e.facu_ccod else "&facu_ccod&" end "& vbCrLf &_
           "     and c.carr_ccod = case when '"&carr_ccod&"' = '0' then c.carr_ccod else '"&carr_ccod&"' end "& vbCrLf &_
           "     and cast(a.sede_ccod as varchar)="&sede_ccod&" "& vbCrLf &_
           "     and cast(isnull(f.sexo_ccod,1) as varchar)="&sexo_ccod&" order by nombre asc"
end if

f_personas.Consultar query

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
        <td>
		 <table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Distribución de personas"), 1 %></td>
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
		  <form name="edicion" method="post">
		  <tr>
		  	<td align="center"> &nbsp;
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="20%"><strong>Categoría</strong></td>
						<td width="3%" align="center"><strong>:</strong></td>
						<td width="77%" align="left"><%=categoria%></td>
					</tr>
					<tr>
						<td width="20%"><strong>Institución</strong></td>
						<td width="3%" align="center"><strong>:</strong></td>
						<td width="77%" align="left"><%=institucion%></td>
					</tr>
					<tr>
						<td width="20%"><strong>Sede</strong></td>
						<td width="3%" align="center"><strong>:</strong></td>
						<td width="77%" align="left"><%=sede_tdesc%></td>
					</tr>
					<tr>
						<td width="20%"><strong>Carrera</strong></td>
						<td width="3%" align="center"><strong>:</strong></td>
						<td width="77%" align="left"><%=carr_tdesc%></td>
					</tr>
					<tr>
						<td width="20%"><strong>Facultad</strong></td>
						<td width="3%" align="center"><strong>:</strong></td>
						<td width="77%" align="left"><%=facu_tdesc%></td>
					</tr>
					<tr>
						<td width="20%"><strong>Estado</strong></td>
						<td width="3%" align="center"><strong>:</strong></td>
						<td width="77%" align="left"><%=estado%></td>
					</tr>
					<tr>
						<td width="20%"><strong>Género</strong></td>
						<td width="3%" align="center"><strong>:</strong></td>
						<td width="77%" align="left"><%=sexo_tdesc%></td>
					</tr>
					<tr>
						<td width="20%"><strong>Fecha</strong></td>
						<td width="3%" align="center"><strong>:</strong></td>
						<td width="77%" align="left"><%=fecha1%></td>
					</tr>
					<tr><td colspan="3">&nbsp;</td></tr>
					<tr><td colspan="3">&nbsp;</td></tr>
					<tr>
                          <td align="center" colspan="3"> 
						   <div align="right">P&aacute;ginas: 
                              <%f_personas.AccesoPagina()%>
                           </div>
						  </td>
                   </tr>
                   <tr> 
                          <td align="center" colspan="3"><%f_personas.dibujatabla()%> </td>
                   </tr>
				</table>
			</td>
		  </tr>
		  </form>
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
                        <td><div align="center"><%url_1 = "estadisticas_egreso_titulacion_carreras.asp?sede_ccod="&sede_ccod&"&tipo="&tipo&"&sexo_ccod="&sexo_ccod&"&institucion="&insti&"&facu_ccod="&facu_ccod&"&carr_ccod="&carr_ccod&""
						                          botonera.agregaBotonParam "volver","url",url_1
												  botonera.dibujaBoton "volver"
												 %>
							</div>
						</td>
						<td><div align="center">
												<% 
												   url_2 = "estadisticas_egreso_titulacion_personas_excel.asp?sede_ccod="&sede_ccod&"&tipo="&tipo&"&sexo_ccod="&sexo_ccod&"&institucion="&insti&"&facu_ccod="&facu_ccod&"&carr_ccod="&carr_ccod&""
												   botonera.agregaBotonParam "excel","url",url_2
												   botonera.dibujaBoton "excel"
												%>
							</div>
						</td>
						<td><div align="center">
												<% 
												   url_2 = "estadisticas_egreso_titulacion__detalle_personas_excel.asp?sede_ccod="&sede_ccod&"&tipo="&tipo&"&sexo_ccod="&sexo_ccod&"&institucion="&insti&"&facu_ccod="&facu_ccod&"&carr_ccod="&carr_ccod&""
												   botonera.agregaBotonParam "excel","url",url_2
												   botonera.agregaBotonParam "excel","texto","Reporte detalle alumnos"
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
