<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
plan_ccod  = Request.QueryString("plan_ccod")
pers_ncorr  = Request.QueryString("pers_ncorr")
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Administración datos de egreso"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

q_plan_ccod  = plan_ccod

'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "antecedentes_titulados_escuela.xml", "botonera_de"

q_pers_nrut = conexion.consultaUno("select pers_nrut from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")


'---------------------------------------------------------------------------------------------------
set f_titulado = new CFormulario
f_titulado.Carga_Parametros "antecedentes_titulados_escuela.xml", "encabezado_de"
f_titulado.Inicializar conexion

'v_sede_ccod = negocio.ObtenerSede'

v_sede_ccod = conexion.consultaUno("select top 1 sede_ccod from personas a, alumnos b, ofertas_academicas c where cast(a.pers_nrut as varchar)='"&q_pers_nrut&"' and a.pers_ncorr=b.pers_ncorr and cast(b.plan_Ccod as varchar)='"&q_plan_ccod&"' and b.ofer_ncorr=c.ofer_ncorr order by peri_ccod desc")


SQL = " select top 1 b.sede_ccod, a.pers_ncorr, a.plan_ccod, c.espe_ccod, b.peri_ccod, e.carr_tdesc, c.espe_tdesc, "&_
      " h.peri_tdesc, d.sede_tdesc, g.plan_tdesc as plan_ncorrelativo, protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre "&_
      " from alumnos a, ofertas_academicas b, especialidades c, sedes d, carreras e, jornadas f, planes_estudio g, periodos_academicos h"&_
	  " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=c.espe_ccod and b.sede_ccod=d.sede_ccod and c.carr_ccod=e.carr_ccod "&_
	  " and b.jorn_ccod=f.jorn_ccod and a.plan_ccod=g.plan_ccod and b.peri_ccod=h.peri_ccod "&_
	  " and cast(a.pers_ncorr as varchar)= '" & pers_ncorr & "'"&_
	  " and cast(a.plan_ccod as varchar)= '" & plan_ccod & "' and emat_ccod <> 9 order by b.peri_ccod desc "

f_titulado.Consultar SQL
f_titulado.SiguienteF
v_sede_ccod = f_titulado.obtenerValor ("sede_ccod")

q_pers_ncorr = conexion.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
carr_ccod    = conexion.consultaUno("select carr_ccod from planes_estudio a, especialidades b where a.espe_ccod = b.espe_ccod and cast(plan_ccod as varchar)='"&plan_ccod&"'")
'response.Write("select case count(*) when 0 then 'N' else 'S' end  from detalles_titulacion_carrera where cast(plan_ccod as varchar)='"&q_plan_ccod&"' and cast(pers_ncorr as varchar)='"&q_pers_ncorr&"' and carr_ccod='"&carr_ccod&"'")
tiene_grabado = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end  from detalles_titulacion_carrera where cast(plan_ccod as varchar)='"&q_plan_ccod&"' and cast(pers_ncorr as varchar)='"&q_pers_ncorr&"' and carr_ccod='"&carr_ccod&"'")
plan_consulta = q_plan_ccod

'response.Write(tiene_grabado)

if tiene_grabado = "S" then
	 consulta = " select pers_ncorr,plan_ccod,carr_ccod,nombre_empresa,ubicacion_empresa,telefono_empresa,email_empresa,nombre_encargado,asca_nregistro,asca_nfolio,protic.trunc(fecha_proceso) as fecha_proceso, "& vbCrLf &_
				" cargo_encargado,protic.trunc(inicio_practica) as inicio_practica,protic.trunc(termino_practica) as termino_practica,observaciones,'"&carr_ccod_informar&"' as carr_ccod, "& vbCrLf &_
			    " descripcion_practica,isnull(horas_practica,(select t2.asig_nhoras from malla_curricular tt, asignaturas t2 "& vbCrLf &_
				" where tt.asig_ccod=t2.asig_ccod and tt.plan_ccod = a.plan_ccod and t2.asig_tdesc = 'PRACTICA PROFESIONAL') ) as horas_practica, "& vbCrLf &_
				" replace(calificacion_practica,',','.') as calificacion_practica,b.sitf_ccod,protic.trunc(fecha_egreso) as fecha_egreso, "& vbCrLf &_
				" isnull((Select top 1 t3.asig_ccod from alumnos tt, cargas_academicas t2, secciones t3, asignaturas t4 "& vbCrLf &_
 				" where tt.matr_ncorr=t2.matr_ncorr and t2.secc_ccod=t3.secc_ccod and t3.asig_ccod=t4.asig_ccod and t4.asig_tdesc like 'practica profesional%'  "& vbCrLf &_
				"  and tt.pers_ncorr=a.pers_ncorr and t3.carr_ccod=a.carr_ccod),(select t2.asig_ccod from malla_curricular tt, asignaturas t2 "& vbCrLf &_
				"  where tt.asig_ccod=t2.asig_ccod and tt.plan_ccod = a.plan_ccod and t2.asig_tdesc = 'PRACTICA PROFESIONAL')) as asig_ccod,  "& vbCrLf &_
				" (Select top 1 t3.peri_ccod from alumnos tt, cargas_academicas t2, secciones t3, asignaturas t4 "& vbCrLf &_
				"  where tt.matr_ncorr=t2.matr_ncorr and t2.secc_ccod=t3.secc_ccod and t3.asig_ccod=t4.asig_ccod and t4.asig_tdesc like 'practica profesional%' "& vbCrLf &_
				"  and tt.pers_ncorr=a.pers_ncorr and t3.carr_ccod=a.carr_ccod) as peri_ccod,isnull(informar_cae,0) as informar_cae,observaciones_cae, isnull(protic.trunc(fecha_cae),protic.trunc(getDate())) as fecha_cae"& vbCrLf &_
				" from detalles_titulacion_carrera a left outer join situaciones_finales b "& vbCrLf &_
				" 		on a.concepto_practica = b.sitf_ccod "& vbCrLf &_
				" where cast(plan_ccod as varchar)='"&plan_consulta&"' "& vbCrLf &_
				" and cast(pers_ncorr as varchar)='"&q_pers_ncorr&"'"
else
     consulta = " select '"&carr_ccod&"' as carr_ccod,'"&plan_consulta&"' as plan_ccod, '"&q_pers_ncorr&"' as pers_ncorr, '"&registro&"' as salu_nregistro, '"&folio&"' as salu_nfolio,'"&carr_ccod_informar&"' as carr_ccod, "& vbCrLf &_
	            " (Select top 1 replace(t2.carg_nnota_final,',','.') from alumnos tt, cargas_academicas t2, secciones t3, asignaturas t4 "& vbCrLf &_
				"  where tt.matr_ncorr=t2.matr_ncorr and t2.secc_ccod=t3.secc_ccod and t3.asig_ccod=t4.asig_ccod and t4.asig_tdesc like 'practica profesional%' "& vbCrLf &_
				"  and cast(tt.pers_ncorr as varchar)='"&q_pers_ncorr&"' and t3.carr_ccod='"&carr_ccod_informar&"') as calificacion_practica,  "& vbCrLf &_
				" isnull( (Select top 1 t3.asig_ccod from alumnos tt, cargas_academicas t2, secciones t3, asignaturas t4 "& vbCrLf &_
				"  where tt.matr_ncorr=t2.matr_ncorr and t2.secc_ccod=t3.secc_ccod and t3.asig_ccod=t4.asig_ccod and t4.asig_tdesc like 'practica profesional%' "& vbCrLf &_
				"  and cast(tt.pers_ncorr as varchar)='"&q_pers_ncorr&"' and t3.carr_ccod='"&carr_ccod_informar&"'),(select t2.asig_ccod from malla_curricular tt, asignaturas t2 "& vbCrLf &_
 				"  where tt.asig_ccod=t2.asig_ccod and cast(tt.plan_ccod as varchar) = '"&q_plan_ccod&"' and t2.asig_tdesc = 'PRACTICA PROFESIONAL') ) as asig_ccod,  "& vbCrLf &_
				"  (Select top 1 t3.peri_ccod from alumnos tt, cargas_academicas t2, secciones t3, asignaturas t4 "& vbCrLf &_
				"  where tt.matr_ncorr=t2.matr_ncorr and t2.secc_ccod=t3.secc_ccod and t3.asig_ccod=t4.asig_ccod and t4.asig_tdesc like 'practica profesional%' "& vbCrLf &_
				"  and cast(tt.pers_ncorr as varchar)='"&q_pers_ncorr&"' and t3.carr_ccod='"&carr_ccod_informar&"') as peri_ccod,"& vbCrLf &_
				"  (Select top 1 t2.sitf_ccod from alumnos tt, cargas_academicas t2, secciones t3, asignaturas t4 "& vbCrLf &_
				"  where tt.matr_ncorr=t2.matr_ncorr and t2.secc_ccod=t3.secc_ccod and t3.asig_ccod=t4.asig_ccod and t4.asig_tdesc like 'practica profesional%' "& vbCrLf &_
				"  and cast(tt.pers_ncorr as varchar)='"&q_pers_ncorr&"' and t3.carr_ccod='"&carr_ccod_informar&"') as sitf_ccod, "& vbCrLf &_
				"  isnull( (Select top 1 t4.asig_nhoras from alumnos tt, cargas_academicas t2, secciones t3, asignaturas t4 "& vbCrLf &_
 				"  where tt.matr_ncorr=t2.matr_ncorr and t2.secc_ccod=t3.secc_ccod and t3.asig_ccod=t4.asig_ccod and t4.asig_tdesc like 'practica profesional%' "& vbCrLf &_
				"  and cast(tt.pers_ncorr as varchar)='"&q_pers_ncorr&"' and t3.carr_ccod='"&carr_ccod_informar&"'),(select t2.asig_nhoras from malla_curricular tt, asignaturas t2 "& vbCrLf &_
				"  where tt.asig_ccod=t2.asig_ccod and cast(tt.plan_ccod as varchar) = '"&q_plan_ccod&"' and t2.asig_tdesc = 'PRACTICA PROFESIONAL') )as horas_practica, protic.trunc(getDate()) as fecha_cae "
end if
'response.Write("<pre>"&consulta&"</pre>")
set f_practica = new CFormulario
f_practica.Carga_Parametros "antecedentes_titulados_escuela.xml", "detalle_datos_practica"
f_practica.Inicializar conexion

f_practica.Consultar consulta
f_practica.Siguiente
asig_ccod = f_practica.obtenerValor("asig_ccod")

'---------------------------------------------------------------------------------------------------

f_botonera.AgregaBotonUrlParam "siguiente", "plan_ccod", q_plan_ccod
f_botonera.AgregaBotonUrlParam "siguiente", "peri_ccod", q_peri_ccod

f_botonera.AgregaBotonUrlParam "guardar_nuevo", "plan_ccod", q_plan_ccod
f_botonera.AgregaBotonUrlParam "guardar_nuevo", "peri_ccod", q_peri_ccod

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
function calcular_periodo(valor)
{
	var valor2 = isFecha(valor);
	var semestre_destino ="";
	var ano_destino;
	var egresado = '<%=egresado%>';
	var tsca_ccod = '<%=tsca_ccod%>';

	if ( (tsca_ccod != '4') )
	{
		if ( (valor2) && (valor !="") && (egresado=="N") )
		{
			var arreglo_fecha = valor.split("/");
			var dia = arreglo_fecha[0];
			var mes = arreglo_fecha[1];
			var ano = arreglo_fecha[2];
			if ( mes == 1 )
			  {
				 semestre_destino = " 1er ";
				 ano_destino = ano;
				 document.practica.anos_ccod_egreso.value=ano;
				 document.practica.plec_ccod_egreso.value="1";
			  }
			  else if(( mes > 1 )&&( mes <=7 ))
			  {
				 semestre_destino = " 2do ";
				 ano_destino = ano;
				 document.practica.anos_ccod_egreso.value=ano;
				 document.practica.plec_ccod_egreso.value="2";
			  }
			  else if( mes > 7 )
			  {
				 semestre_destino = " 1er ";
				 ano_destino = (ano*1)+1;
				 document.practica.anos_ccod_egreso.value=ano_destino;
				 document.practica.plec_ccod_egreso.value="1";
			  }
			  document.practica.descripcion.value = "-Al grabar se creará una matrícula con estado de egreso en el"+semestre_destino+"semestre del año "+ano_destino;
			  document.getElementById("texto_alerta").style.visibility="visible";
		}
	}	
}
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA"><br><br>
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
            <td><%pagina.DibujarLenguetas Array("Práctica profesional"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
                <td> <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td>
                        <table width="98%"  border="0" align="center">
                          <tr> 
                            <td><div align="center"><%=mensaje_html%></div></td>
                          </tr>
						  <tr> 
                            <td><div align="center">
                                <%f_titulado.DibujaRegistro%>
                              </div></td>
                          </tr>
                        </table></td>
                    </tr>
                    <tr> 
                      <td>
                        <%pagina.DibujarSubtitulo "Datos de Práctica Profesional."%>
                        <form name="practica">
						  <input type="hidden" name="saca_ncorr" value="<%=saca_ncorr%>">
                          <table width="100%"  border="0" align="center">
                            <tr> 
                              <td align="center"> <table border="0" width="98%">
                                  <tr> 
                                    <td width="14%" align="left"><strong>Empresa</strong>
                                      <input type="hidden" name="egreso[0][pers_ncorr]" value="<%=q_pers_ncorr%>"></td>
                                    <td width="1%" align="left"><strong>:</strong></td>
                                    <td width="35%" align="left">
                                      <%f_practica.dibujaCampo("nombre_empresa")%>
                                      <input type="hidden" name="egreso[0][plan_ccod]" value="<%=q_plan_ccod%>"></td>
                                    <td width="14%" align="left"><strong>Ubicación</strong></td>
                                    <td width="1%" align="left"><strong>:</strong></td>
                                    <td width="35%" align="left">
                                      <%f_practica.dibujaCampo("ubicacion_empresa")%>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="14%" align="left"><strong>Teléfono</strong></td>
                                    <td width="1%" align="left"><strong>:</strong></td>
                                    <td width="35%" align="left">
                                      <%f_practica.dibujaCampo("telefono_empresa")%>
                                    </td>
                                    <td width="14%" align="left"><strong>E-mail</strong></td>
                                    <td width="1%" align="left"><strong>:</strong></td>
                                    <td width="35%" align="left">
                                      <%f_practica.dibujaCampo("email_empresa")%>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="14%" align="left"><strong>Encargado</strong></td>
                                    <td width="1%" align="left"><strong>:</strong></td>
                                    <td width="35%" align="left">
                                      <%f_practica.dibujaCampo("nombre_encargado")%>
                                    </td>
                                    <td width="14%" align="left"><strong>Cargo</strong></td>
                                    <td width="1%" align="left"><strong>:</strong></td>
                                    <td width="35%" align="left">
                                      <%f_practica.dibujaCampo("cargo_encargado")%>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="14%" align="left"><strong>Inicio</strong></td>
                                    <td width="1%" align="left"><strong>:</strong></td>
                                    <td width="35%" align="left">
                                      <%f_practica.dibujaCampo("inicio_practica")%>
                                    </td>
                                    <td width="14%" align="left"><strong>Término</strong></td>
                                    <td width="1%" align="left"><strong>:</strong></td>
                                    <td width="35%" align="left">
                                      <%f_practica.dibujaCampo("termino_practica")%>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="14%" align="left"><strong>Des. 
                                      Trabajo</strong></td>
                                    <td width="1%" align="left"><strong>:</strong></td>
                                    <td width="14%" align="left">
                                      <%f_practica.dibujaCampo("descripcion_practica")%>
                                    </td>
                                    <td width="14%" align="left"><strong>N° Horas</strong></td>
                                    <td width="1%" align="left"><strong>:</strong></td>
                                    <td width="35%" align="left">
                                      <%f_practica.dibujaCampo("horas_practica")%>
                                    </td>
                                  </tr>
                                  
                                </table></td>
                            </tr>
                          </table>
                        </form></td>
                    </tr>
                    <tr>
                      <td>&nbsp;</td>
                    </tr>
                  </table>
                  <br>
           </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="16%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
				  <td><div align="center"><%f_botonera.DibujaBoton "guardar_practica"%></div></td>
                  <td><div align="center"><%f_botonera.DibujaBoton "cerrar"%></div></td>
                </tr>
              </table>
            </div></td>
            <td width="84%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
