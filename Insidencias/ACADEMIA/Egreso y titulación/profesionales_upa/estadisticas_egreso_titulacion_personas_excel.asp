<!-- #include file = "../biblioteca/_conexion.asp" -->

<%

Response.AddHeader "Content-Disposition", "attachment;filename=estadisticas_egreso_titulacion_personas.xls"
Response.ContentType = "application/vnd.ms-excel"
Server.ScriptTimeOut = 350000
set conexion = new CConexion
conexion.Inicializar "upacifico"

'-----------------------------------------------------------------------
fecha		= conexion.consultaUno("select getDate() ")
sede_ccod 	= request.QueryString("sede_ccod")
tipo      	= request.QueryString("tipo")
sexo_ccod 	= request.QueryString("sexo_ccod")
institucion	= request.QueryString("institucion")
facu_ccod	= request.QueryString("facu_ccod")
carr_ccod   = request.QueryString("carr_ccod")

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
f_personas.carga_parametros "tabla_vacia.xml","tabla"
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
<title>ESTADÍSTICAS EGRESADOS, TITULADOS Y GRADUADOS</title>
<meta http-equiv="Content-Type" content="text/html;">
</head>
<body >
<table width="100%" border="0">
  <tr> 
    <td colspan="3"><div align="center"><font size="+2" face="Arial, Helvetica, sans-serif">ESTADÍSTICAS EGRESADOS, TITULADOS Y GRADUADOS</font></div></td>
  </tr>
  <tr> 
    <td colspan="3">&nbsp;</td>
  </tr>
</table>
<p>&nbsp;</p>
<table width="100%" border="0">
   					<tr>
						<td width="20%"><strong>Categoría</strong></td>
						<td width="3%" align="left"><strong>:</strong><%=categoria%></td>
						<td width="77%" align="left">&nbsp;</td>
					</tr>
					<tr>
						<td width="20%"><strong>Institución</strong></td>
						<td width="3%" align="left"><strong>:</strong><%=institucion%></td>
						<td width="77%" align="left">&nbsp;</td>
					</tr>
					<tr>
						<td width="20%"><strong>Sede</strong></td>
						<td width="3%" align="left"><strong>:</strong><%=sede_tdesc%></td>
						<td width="77%" align="left">&nbsp;</td>
					</tr>
					<tr>
						<td width="20%"><strong>Carrera</strong></td>
						<td width="3%" align="left"><strong>:</strong><%=carr_tdesc%></td>
						<td width="77%" align="left">&nbsp;</td>
					</tr>
					<tr>
						<td width="20%"><strong>Facultad</strong></td>
						<td width="3%" align="left"><strong>:</strong><%=facu_tdesc%></td>
						<td width="77%" align="left">&nbsp;</td>
					</tr>
					<tr>
						<td width="20%"><strong>Estado</strong></td>
						<td width="3%" align="left"><strong>:</strong><%=estado%></td>
						<td width="77%" align="left">&nbsp;</td>
					</tr>
					<tr>
						<td width="20%"><strong>Género</strong></td>
						<td width="3%" align="left"><strong>:</strong><%=sexo_tdesc%></td>
						<td width="77%" align="left">&nbsp;</td>
					</tr>
					<tr>
						<td width="20%"><strong>Fecha</strong></td>
						<td width="3%" align="left"><strong>:</strong><%=fecha%></td>
						<td width="77%" align="left">&nbsp;</td>
					</tr>
					<tr><td colspan="3">&nbsp;</td></tr>
					<tr><td colspan="3">&nbsp;</td></tr>
					<tr>
						<td colspan="3" align="center">
							<table width="90%" cellpadding="0" cellspacing="1" border="1" bordercolor="#333333">
								<tr>
									<td align="center" bgcolor="#FF9900"><strong>FILA</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>RUT</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>NOMBRE</strong></td>
									<td align="center" bgcolor="#FF9900"><strong>AÑO INGRESO</strong></td>
								</tr>
								<%fila = 1
								  while f_personas.siguiente%>
								<tr>
									<td align="left" ><%=fila%></td>
									<td align="left" ><%=f_personas.obtenerValor("rut")%></td>
									<td align="left" ><%=f_personas.obtenerValor("nombre")%></td>
									<td align="center" ><%=f_personas.obtenerValor("ano_ingreso")%></td>
								</tr>
								<%fila = fila + 1
								   wend%>
							</table>
						</td>
					</tr>
</table>
<p>&nbsp; 
</p> 
<div align="center"></div>
</body>
</html>