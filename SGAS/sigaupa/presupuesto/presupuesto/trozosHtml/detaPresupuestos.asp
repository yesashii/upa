
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"
set conexion2 = new CConexion2
conexion2.Inicializar "upacifico"

v_anio_actual	= conexion2.ConsultaUno("select year(getdate())")
v_prox_anio		= v_anio_actual+1

set f_meses = new CFormulario
f_meses.Carga_Parametros "solicitud_presupuestaria.xml", "solicitud"
f_meses.Inicializar conexion2
f_meses.consultar sql_meses


sql_meses= ""& vbCrLf &_ 
"select          Upper(nombremes)                           as mes,                                              "& vbCrLf &_
"                indice                                     as mes_venc,                                         "& vbCrLf &_
"                Sum(Cast(isnull(solicitado,0) as    numeric)) as solicitado,                                    "& vbCrLf &_
"                Sum(Cast(isnull(presupuestado,0) as numeric)) as presupuestado                                  "& vbCrLf &_
"from            softland.sw_mesce                             as b                                              "& vbCrLf &_
"left outer join                                                                                                 "& vbCrLf &_
"                (                                                                                               "& vbCrLf &_
"                         select   pa.mes             as mes,                                                    "& vbCrLf &_
"                                  Sum(solicitado)    as solicitado,                                             "& vbCrLf &_
"                                  Sum(presupuestado) as presupuestado                                           "& vbCrLf &_
"                         from     (                                                                             "& vbCrLf &_
"                                           select   Sum(valor) as presupuestado,                                "& vbCrLf &_
"                                                    0          as solicitado,                                   "& vbCrLf &_
"                                                    mes,                                                        "& vbCrLf &_
"                                                    cod_anio,                                                   "& vbCrLf &_
"                                                    cod_pre,                                                    "& vbCrLf &_
"                                                    cod_area,                                                   "& vbCrLf &_
"                                                    descripcion_area,                                           "& vbCrLf &_
"                                                    concepto                                                    "& vbCrLf &_
"                                           from     presupuesto_upa.protic.vis_ejecucion_presupuesto_anual_2013 "& vbCrLf &_
"                                           where    cod_pre='"&codcaja&"' 										 "& vbCrLf &_	
"                                           and      cod_area="&area_ccod&" "&str_concepto&" "&str_detalle&"     "& vbCrLf &_
"                                           and      cod_anio=year(getdate())                                    "& vbCrLf &_
"                                           group by mes,                                                        "& vbCrLf &_
"                                                    cod_anio,                                                   "& vbCrLf &_
"                                                    cod_pre,                                                    "& vbCrLf &_
"                                                    cod_area,                                                   "& vbCrLf &_
"                                                    descripcion_area,                                           "& vbCrLf &_
"                                                    concepto                                                    "& vbCrLf &_
"                                           union                                                                "& vbCrLf &_
"                                           select   0          as presupuestado,                                "& vbCrLf &_
"                                                    sum(valor) as solicitado,                                   "& vbCrLf &_
"                                                    mes,                                                        "& vbCrLf &_
"                                                    cod_anio,                                                   "& vbCrLf &_
"                                                    cod_pre,                                                    "& vbCrLf &_
"                                                    cod_area,                                                   "& vbCrLf &_
"                                                    descripcion_area,                                           "& vbCrLf &_
"                                                    concepto                                                    "& vbCrLf &_
"                                           from     presupuesto_upa.protic.vis_solicitud_presupuesto_anual      "& vbCrLf &_
"                                           where    cod_pre='"&codcaja&"'                                       "& vbCrLf &_
"                                           and      cod_area="&area_ccod&" "&str_concepto&" "&str_detalle&"     "& vbCrLf &_
"                                           and      cod_anio=year(getdate())+1                                  "& vbCrLf &_
"                                           group by mes,                                                        "& vbCrLf &_
"                                                    cod_anio,                                                   "& vbCrLf &_
"                                                    cod_pre,                                                    "& vbCrLf &_
"                                                    cod_area,                                                   "& vbCrLf &_
"                                                    descripcion_area,                                           "& vbCrLf &_
"                                                    concepto ) as pa                                            "& vbCrLf &_
"                         group by pa.mes )as a                                                                  "& vbCrLf &_
"on              indice=mes                                                                                      "& vbCrLf &_
"group by        nombremes,                                                                                      "& vbCrLf &_
"                indice                                                                                          "

%>


<table width="95%" border="1" align="center"  >
	<tr  bgcolor='#C4D7FF' bordercolor='#999999'> 
	  <th width="33%">MES</th>
	  <th width="19%"><%=v_prox_anio%></th>
	  <th width="48%"><%=v_anio_actual%></th>
	</tr>
<%
v_total_soli	=0
v_total_presu	=0
while f_meses.Siguiente
	v_total_soli	=	v_total_soli	+	Cdbl(f_meses.ObtenerValor("solicitado"))
	v_total_presu	=	v_total_presu	+	Cdbl(f_meses.ObtenerValor("presupuestado"))
	v_mes_venc		=	Cint(f_meses.ObtenerValor("mes_venc"))
%>
<tr bordercolor='#999999'>	
  <td><font color="#0033FF"><a href="JAVASCRIPT:ver_detalle(<%=area_ccod%>,'<%=codcaja%>',<%=v_mes_venc%>);" class="meses"><%f_meses.DibujaCampo("mes")%></a></font></td>
  <td><%=f_meses.DibujaCampo("solicitado")%></td><td><%=formatcurrency(f_meses.ObtenerValor("presupuestado"),0)%><%=f_meses.DibujaCampo("presupuestado")%></td>
</tr>
 <%wend%>
 <tr bordercolor='#999999'>
	<td><a href="JAVASCRIPT:ver_detalle(<%=area_ccod%>,'<%=codcaja%>',0);"><b>TOTAL</b></a></td>
	<td align="right"><input type='text' name='total_solicitud' value='' readonly style="background-color:#EDEDEF;border: 1px #EDEDEF solid;">
	</td>
	<td><b><%=formatcurrency(v_total_presu,0,0)%></b></td>
 </tr>
</table>