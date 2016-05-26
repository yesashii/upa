<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Reporte Morosidad"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set errores = new CErrores

set negocio = new CNegocio
negocio.Inicializa conexion

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "rendicion_cajas.xml", "botonera"

'---------------------------------------------------------------------------------------------------


v_peri_ccod_pos = negocio.ObtenerPeriodoAcademico("POSTULACION")
v_peri_ccod_18  = negocio.ObtenerPeriodoAcademico("CLASES18")
'response.Write("peri postulacion: "&v_peri_ccod_pos&" <br> Peri Calses18: "&v_peri_ccod_18)
if cint(v_peri_ccod_pos) < cint(v_peri_ccod_18) then
	v_peri_ccod = v_peri_ccod_18
else
	v_peri_ccod =v_peri_ccod_pos
end if
periodo = v_peri_ccod


v_pers_ncorr = request.QueryString("pers_ncorr")
q_pers_nrut=conexion.consultaUno("select pers_nrut from personas where pers_ncorr="&v_pers_ncorr)
'---------------------------------------------------------------------------------------------------

set f_datos_alumno = new CFormulario
f_datos_alumno.Carga_Parametros "tabla_vacia.xml", "tabla_vacia"
f_datos_alumno.Inicializar conexion

sql_datos_alumnos=  " Select protic.obtener_nombre_completo(pers_ncorr,'n') as nombre,protic.obtener_rut(pers_ncorr) as rut_alumno, " & vbCrLf &_
					" protic.obtener_nombre_carrera((select top 1 a.ofer_ncorr from alumnos a where a.pers_ncorr="&v_pers_ncorr&"  and emat_ccod=1 order by matr_ncorr desc),'CJ') as carrera  " & vbCrLf &_
					" From personas where pers_ncorr="&v_pers_ncorr

f_datos_alumno.Consultar sql_datos_alumnos
f_datos_alumno.SiguienteF



if v_peri_cta="" then
	v_peri_cta=v_peri_ccod
end if

set persona = new CPersona
persona.Inicializar conexion, q_pers_nrut

set alumno = new CAlumno
es_alumno = false

if EsVacio(persona.ObtenerMatriculaPeriodo(v_peri_cta)) then
' obtiene el periodo de la ultima matricula existente

	sql_ultima_matricula="select max(peri_ccod) from postulantes a, alumnos b where a.post_ncorr=b.post_ncorr and cast(b.pers_ncorr as varchar)='"&v_pers_ncorr&"'"
	v_peri_ant=conexion.ConsultaUno(sql_ultima_matricula)
	'response.Write("<hr>"&sql_ultima_matricula&"<br> Periodo ultimo: "&v_peri_ant&"<hr>")
	'response.End() 
	if EsVacio(v_peri_ant) then ' no existe matricula para ningun periodo
		set f_datos = persona
		persona="SI"
	else ' busca matricula correspondiante a ultimo periodo cursado

		if EsVacio(persona.ObtenerMatriculaPeriodo(v_peri_ant)) then
			set f_datos = persona
			persona="SI"
		else
			es_alumno = true
			alumno.InicializarCarreras conexion, persona.ObtenerMatriculaPeriodo(v_peri_ant), v_peri_ant,v_peri_cta
			set f_datos = alumno
			persona="NO&periodo="&v_peri_ant&"&filtro="&filtro&"&peri_sel="&v_peri_cta
		end if
	end if
else
	es_alumno = true
	alumno.InicializarCarreras conexion, persona.ObtenerMatriculaPeriodo(v_peri_cta), v_peri_cta,v_peri_cta
	set f_datos = alumno
	persona="NO&periodo="&v_peri_cta&"&filtro="&filtro&"&peri_sel="&v_peri_cta
end if


set f_documentos = new CFormulario
f_documentos.Carga_Parametros "class_cuenta_corriente.xml", "compromisos_morosos"
f_documentos.Inicializar conexion

		   
sql_morosidad = 	" select cast(isnull(f.fint_nfactor_anual/(12*100),0) as decimal(5,4) ) as factor_interes, " & vbCrLf &_
						" case when datediff(day,b.dcom_fcompromiso, getdate())>5 then datediff(day,b.dcom_fcompromiso, getdate()) else 0 end as dias_mora, " & vbCrLf &_
						" ROUND((cast(isnull(f.fint_nfactor_anual,0)/(12*100) as decimal(5,4))*protic.total_recepcionar_cuota(b.tcom_ccod,b.inst_ccod,b.comp_ndocto,b.dcom_ncompromiso)*case when datediff(day,b.dcom_fcompromiso, getdate())>5 then datediff(day,b.dcom_fcompromiso, getdate())else 0 end)/30,0) as interes, "& vbCrLf &_
						" protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso)+ ROUND((cast(isnull(f.fint_nfactor_anual,0)/(12*100) as decimal(5,4))*protic.total_recepcionar_cuota(b.tcom_ccod,b.inst_ccod,b.comp_ndocto,b.dcom_ncompromiso)*case when datediff(day,b.dcom_fcompromiso, getdate())>5 then datediff(day,b.dcom_fcompromiso, getdate())else 0 end)/30,0) as a_pagar, "& vbCrLf &_						
						"     case " & vbCrLf &_
						"   when b.tcom_ccod=25 or b.tcom_ccod=4 or b.tcom_ccod=5 or b.tcom_ccod=8 or b.tcom_ccod=10 or b.tcom_ccod=26 or b.tcom_ccod=34 or b.tcom_ccod=35" & vbCrLf &_
						"		then " & vbCrLf &_
						"       (Select a1.tdet_tdesc from tipos_detalle a1,detalles a2 where a2.tcom_ccod=a.tcom_ccod and a2.inst_ccod=a.inst_ccod " & vbCrLf &_
						"        and a2.comp_ndocto=a.comp_ndocto and a1.tdet_ccod=a2.tdet_ccod) " & vbCrLf &_
						" 	when b.tcom_ccod=37 then (select a3.tcom_tdesc from tipos_compromisos a3 where a3.tcom_ccod=a.tcom_ccod)+'-'+protic.obtener_nombre_carrera(a.ofer_ncorr,'CJ') "& vbCrLf &_
						"   else " & vbCrLf &_
						"        (select a3.tcom_tdesc from tipos_compromisos a3 where a3.tcom_ccod=a.tcom_ccod) " & vbCrLf &_
						"    end as tcom_tdesc, " & vbCrLf &_
						"			b.comp_ndocto as c_comp_ndocto, cast(b.dcom_ncompromiso as varchar) + ' / '+ cast(a.comp_ncuotas as varchar) as ncuota, a.comp_fdocto, b.dcom_fcompromiso, b.dcom_mcompromiso, "& vbCrLf &_
						"			protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as ting_ccod,"& vbCrLf &_   
						"			protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') as ding_ndocto,  "& vbCrLf &_ 
						"			protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) + protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso)as abonos, "& vbCrLf &_
						"			protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo, "& vbCrLf &_
						"		    d.edin_tdesc  "& vbCrLf &_
						"		   "& vbCrLf &_
						"	 from "& vbCrLf &_
						"		compromisos a "& vbCrLf &_
						"		join detalle_compromisos b "& vbCrLf &_
						"			on a.tcom_ccod = b.tcom_ccod   "& vbCrLf &_ 
						"			and a.inst_ccod = b.inst_ccod    "& vbCrLf &_
						"			and a.comp_ndocto = b.comp_ndocto "& vbCrLf &_
						"		left outer join detalle_ingresos c "& vbCrLf &_
						"			on protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') = c.ting_ccod   "& vbCrLf &_
						"			   and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto  "& vbCrLf &_
						"			   and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') = c.ingr_ncorr    "& vbCrLf &_
						"		left join estados_detalle_ingresos d   "& vbCrLf &_
						"			on c.edin_ccod = d.edin_ccod "& vbCrLf &_
						" 		left outer join rango_factor_interes h "& vbCrLf &_  
						"			on datediff(day,b.dcom_fcompromiso, getdate()) between rafi_ndias_minimo and rafi_ndias_maximo "& vbCrLf &_   
						"			and floor(b.dcom_mcompromiso/protic.valor_uf()) between rafi_mufes_min and rafi_mufes_max "& vbCrLf &_  
						"		left outer join factor_interes f "& vbCrLf &_  
						"			on f.rafi_ccod=h.rafi_ccod "& vbCrLf &_  
						"			and f.anos_ccod=datepart(year, getdate()) "& vbCrLf &_  
						"			and f.efin_ccod=1 "& vbCrLf &_
						"	 where protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0  "& vbCrLf &_
						"	   --and isnull(d.udoc_ccod, 1) = 1  "& vbCrLf &_
						"	   and ( (c.ting_ccod is null) or  "& vbCrLf &_
						"			 (c.ting_ccod = 4 and d.edin_ccod not in (6) ) or  "& vbCrLf &_
						"			 (c.ting_ccod = 5 and d.edin_ccod not in (6) ) or  "& vbCrLf &_
						"			  (c.ting_ccod in (2, 50)) or  "& vbCrLf &_
						"			  (c.ting_ccod in (3,38) and d.edin_ccod not in (6, 12, 51)) or  "& vbCrLf &_
						"    		  (c.ting_ccod = 52 and d.edin_ccod not in (6) ) or "& vbCrLf &_
						"    		  (c.ting_ccod = 87 and d.edin_ccod not in (6) ) or "& vbCrLf &_
						"    		  (c.ting_ccod = 66 and d.edin_ccod not in (6) ) or"& vbCrLf &_
						"			  (c.ting_ccod = 88 and d.edin_ccod not in (6) ) "& vbCrLf &_
						"			)  "& vbCrLf &_
						"	   and a.ecom_ccod = '1'  "& vbCrLf &_
						"	   and b.ecom_ccod = '1'  "& vbCrLf &_
						"  	and cast(a.pers_ncorr  as varchar)= '" & v_pers_ncorr & "'"& vbCrLf &_
						"   and datediff(day,b.dcom_fcompromiso, getdate())>1 "& vbCrLf &_
						"	order by b.dcom_fcompromiso asc, b.dcom_ncompromiso asc, b.tcom_ccod asc "

f_documentos.Consultar sql_morosidad
'response.Write("<pre>"&consulta&"</pre>")
'--------------------------------------------------------------------------------------------------

%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_inicial.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">


<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script>
function imprimir()
{
  window.print();  
}
</script>
</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<style>
@media print{ .noprint {visibility:hidden; }}
</style>
<table width="600" height="80%" border="1" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" >
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" >
      <tr>
        <td>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr>
              	<td valign="top">
					<table width="100%">
						<tr>
							<td width="15%"><img src="../imagenes/logo_upa.jpg" /></td>
							<td width="75%"> <div align="center"><%pagina.DibujarTituloPagina%></div></td>
							<td width="10%"></td>
						</tr>
					</table>  
				</td>
            </tr>
            <tr>
              <td>
					<table width="100%">
					<tr>
						<td colspan="4"> <p><font size="2">Reporte de morosidad calculado con fecha <strong><%=date()%></strong> </font></p></td>
					</tr>
					<tr>
						<td><strong>Rut :</strong></td>
						<td><%=f_datos_alumno.DibujaCampo("rut_alumno")%></td>
						<td><strong>Nombre :</strong></td>
						<td><%=f_datos_alumno.DibujaCampo("nombre")%></td>
					</tr>
					<tr>
						<%	if 	es_alumno = true then%>
						<td colspan="4">
							<% f_datos.DibujaDatos2
								else%>
						<td colspan="2"><b>Estado Matricula :</b></td>
						<td>NO MATRICULADO
					<%end if%>
						</td>
					</tr>
					</table>
						 <br><br><br><br>
							  <b><font color="#666677" size="2">Detalle de documentos en mora </font></b> <br><br>
							  <div align="center">
								<%f_documentos.DibujaTabla%>
							  <br>
                </td>
            </tr>
        </table></td>
      </tr>
      <tr>
        <td><br/><br/><br/><br/><center>___________________________________<br/> 
        v.b Cobranza 
        </center><br/></td>
      </tr>
      <tr>
        <td align="center" class="noprint" ><%f_botonera.DibujaBoton("imprimir")%></td>
      </tr>
    </table>
	</td>
  </tr>  
</table>
</body>
</html>
