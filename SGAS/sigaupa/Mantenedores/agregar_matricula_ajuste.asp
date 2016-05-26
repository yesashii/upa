<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina

carr_ccod = request.querystring("a[0][carr_ccod]")
espe_ccod = request.querystring("a[0][espe_ccod]")
plan_ccod= request.QueryString("a[0][plan_ccod]")
pers_nrut= request.QueryString("pers_nrut")

pagina.Titulo = "Agregar Matricula de ajuste histórico"

'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

'----------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "adm_estado_alumnos.xml", "botonera"
'----------------------------------------------------------------

'-----------------------------------------------------------------------
carrera = conectar.consultauno("SELECT carr_tdesc FROM carreras WHERE cast(carr_ccod as varchar) = '" & carr_ccod & "'")
especialidad = conectar.consultauno("SELECT espe_tdesc FROM especialidades WHERE cast(espe_ccod as varchar)= '" & espe_ccod & "'")
planes = conectar.consultauno("SELECT plan_tdesc FROM planes_estudio WHERE cast(plan_ccod as varchar)= '" & plan_ccod & "'")

'----------------------------------------------------------------------------------------------------------------
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "adm_estado_alumnos.xml", "combo_carrera"
 f_busqueda.inicializar conectar

 peri = negocio.obtenerPeriodoAcademico ( "planificacion" ) 
 sede = negocio.obtenerSede
 pers_ncorr = conectar.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'")

 consulta="Select '"&carr_ccod&"' as carr_ccod, '"&espe_ccod&"' as espe_ccod, '"&plan_ccod&"' as plan_ccod"
 f_busqueda.consultar consulta

consulta = " select distinct d.carr_ccod,d.carr_tdesc,c.espe_ccod,c.espe_tdesc,e.plan_ccod,e.plan_tdesc " & vbCrLf & _
		   " from alumnos a, ofertas_academicas b, especialidades c, carreras d, planes_estudio e " & vbCrLf & _
		   " where cast(a.pers_ncorr as varchar)="&pers_ncorr&" and a.ofer_ncorr=b.ofer_ncorr " & vbCrLf & _
		   " and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod " & vbCrLf & _
		   " and a.plan_ccod=e.plan_ccod " & vbCrLf & _
		   " order by carr_tdesc, espe_tdesc, plan_tdesc " 
'response.Write("<pre>"&consulta&"</pre>")	
f_busqueda.inicializaListaDependiente "lBusqueda", consulta
f_busqueda.siguiente

nombre_alumno = conectar.consultaUno("select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'")

consulta_ultimo_periodo = " select max(peri_ccod) " & vbCrLf & _
						  " from alumnos a, ofertas_academicas b " & vbCrLf & _
						  " where a.ofer_ncorr=b.ofer_ncorr " & vbCrLf & _
						  " and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'" & vbCrLf & _
						  " and cast(b.espe_ccod as varchar)='"&espe_ccod&"'"
ultimo_periodo = conectar.consultaUno(consulta_ultimo_periodo)
'response.Write(consulta_ultimo_periodo)
ultimo_anos = conectar.consultaUno("select anos_ccod - 2  from periodos_academicos where cast(peri_ccod as varchar)='"&ultimo_periodo&"'")

if plan_ccod <> "" and pers_ncorr <> "" then 
'----------------------------------------------------------------------------------------------------------------
 set f_adicional = new CFormulario
 f_adicional.Carga_Parametros "adm_estado_alumnos.xml", "datos_extras"
 f_adicional.inicializar conectar

 consulta="Select '' as peri_ccod, '' as emat_ccod"
 f_adicional.consultar consulta

 f_adicional.agregaCampoParam "peri_ccod","destino","(select peri_ccod,peri_tdesc from periodos_academicos where anos_ccod >='"&ultimo_anos&"')a"
 f_adicional.siguiente
 
 
 consulta_cantidad= " select case count(*) when 0 then 'N' else 'S' end " & vbCrLf & _
				    " from alumnos a, ofertas_academicas b " & vbCrLf & _
				    " where cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' " & vbCrLf & _
				    " and a.ofer_ncorr=b.ofer_ncorr " & vbCrLf & _
					" and cast(b.espe_ccod as varchar)='"&espe_ccod&"' " & vbCrLf & _
					" and a.audi_tusuario  like '%ajunte matricula%'"
					
tiene_ajustes = conectar.consultaUno(consulta_cantidad)					
end if


'ultimo período matriculado del alumno
consulta_ultimo_periodo_u = " select max(peri_ccod) " & vbCrLf & _
						    " from alumnos a, ofertas_academicas b " & vbCrLf & _
						    " where a.ofer_ncorr=b.ofer_ncorr " & vbCrLf & _
						    " and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"' and a.emat_ccod <> 9 " 
ultimo_periodo_u = conectar.consultaUno(consulta_ultimo_periodo_u)
'response.Write(ultimo_periodo_u)

'response.Write(pers_ncorr)
consulta_ultima_carrera = "select top 1 'La última matrícula registrada es durante el período '+protic.initCap(f.peri_tdesc)+' en '+ " & vbCrLf & _
						  "	protic.initCap(sede_tdesc+' - ' + carr_tdesc + '('+case b.jorn_ccod when 1 then 'D' else 'V' end+')')+ " & vbCrLf & _
						  "	'para la especialidad '+protic.initCap(d.espe_tdesc)+' - '+protic.initcap(plan_tdesc)+', quedando en estado de '+protic.initCap(h.emat_tdesc) as carrera  " & vbCrLf & _
						  "	from alumnos a, ofertas_academicas b, sedes c, especialidades d, carreras e, " & vbCrLf & _
						  "	periodos_academicos f,planes_estudio g,estados_matriculas h " & vbCrLf & _
						  "	where a.ofer_ncorr=b.ofer_ncorr and b.sede_ccod=c.sede_ccod and b.espe_Ccod=d.espe_ccod  " & vbCrLf & _
						  "	and b.peri_ccod=f.peri_ccod and a.plan_ccod=g.plan_ccod and a.emat_ccod=h.emat_ccod " & vbCrLf & _
						  "	and d.carr_ccod=e.carr_ccod and cast(a.pers_ncorr as varchar)='"&pers_ncorr&"'  " & vbCrLf & _
						  "	and cast(b.peri_ccod as varchar)='"&ultimo_periodo_u&"' " & vbCrLf & _
						  "	order by a.audi_fmodificacion desc"
						  
msj_ultima_carrera = conectar.consultaUno(consulta_ultima_carrera)
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
function ValidaBusqueda()
{
	return true;	
}

</script>
<% f_busqueda.generaJS %>
</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="500" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  
  <tr> 
    <td valign="top" bgcolor="#EAEAEA"> <br> <br> <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
        <tr> 
          <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
          <td height="8" background="../imagenes/top_r1_c2.gif"></td>
          <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
        </tr>
        <tr> 
          <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
          <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td><%pagina.DibujarLenguetas Array("Generar Matricula"), 1 %></td>
              </tr>
              <tr> 
                <td height="2" background="../imagenes/top_r3_c2.gif"></td>
              </tr>
              <tr> 
                <td><div align="center"><br>
                    <%pagina.DibujarTituloPagina%>
                    <br><BR>
                  </div>
				   
                  <form name="edicion">
                    <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr> <input type="hidden" name="pers_nrut" value="<%=pers_nrut%>">
                        <td>
                          <table width="100%" border="0">
                            <tr> 
                              <td align="center"><div align="justify"><strong>El propósito de esta funcionalidad es poder generar matrículas al alumno para conceptos de ajustes en los siguientes casos:<br><br>
							                                                  - El alumno se titule en el mismo periodo de egreso a modo de dejar ambos registros en el sistema.<br>
																			  - El alumno es eliminado o suspendido de estudios del sistema luego de pasar un semestre activo.<br>
																			  - El alumno no se vuelve a matricular.<hr></strong></div></td>
                             </tr>
							 <%if msj_ultima_carrera <> "" then%>
							 <tr><td align="center" bgcolor="#0066FF"><font color="#FFFFFF"><%=msj_ultima_carrera%></font></td></tr>
							 <tr><td align="center">&nbsp;</td></tr>
							 <%end if%>
                             <td align="left"><div align="center">
                             <table width="100%" border="0">
                              <tr> 
                                <td><div align="left"><strong>Carrera</strong></div></td>
                                <td><div align="center"><strong>:</strong></div></td>
                                <td>
                                  <%f_busqueda.dibujaCampoLista "lBusqueda", "carr_ccod" %>
                                </td>
                              </tr>
                              <tr> 
                                <td width="15%"><div align="left"><strong>Especialidad</strong></div></td>
                                <td width="4%"><div align="center"><strong>:</strong></div></td>
                                <td width="81%">
                                  <%f_busqueda.dibujaCampoLista "lBusqueda", "espe_ccod" %>
                                </td>
                              </tr>
							  <tr> 
                                <td width="15%"><div align="left"><strong>Planes</strong></div></td>
                                <td width="4%"><div align="center"><strong>:</strong></div></td>
                                <td width="81%"><table width="100%">
								                 <tr valign="top">
												 <td width="75%"><%f_busqueda.dibujaCampoLista "lBusqueda", "plan_ccod"%></td>
												 <td><%botonera.dibujaBoton "buscar_periodo" %></td>
												 </tr> 
								                </table>
                                 </td>
                              </tr>
							  <%if plan_ccod <> "" and pers_nrut <> "" then %>
							  <tr> 
                                <td width="15%"><div align="left"><strong>Alumno</strong></div></td>
                                <td width="4%"><div align="center"><strong>:</strong></div></td>
                                <td width="81%"><%=nombre_alumno%>
                                </td>
                              </tr>
							  <%if tiene_ajustes="S" then%>
							  <tr>
							     <td colspan="3" align="center">&nbsp;</td>
							  </tr>
							  <tr>
							     <td colspan="3" align="center" bgcolor="#993300"><font color="#FFFFFF"><strong>Este alumno ya posee una matricula de ajuste para esta especialidad.</strong></font></td>
							  </tr>
							  <%else%>
							  <tr> 
                                <td width="15%"><div align="left"><strong>Periodo</strong></div></td>
                                <td width="4%"><div align="center"><strong>:</strong></div></td>
                                <td width="81%"><%f_adicional.dibujaCampo("peri_ccod")%>
                                </td>
                              </tr>
							  <tr> 
                                <td width="15%"><div align="left"><strong>Estado</strong></div></td>
                                <td width="4%"><div align="center"><strong>:</strong></div></td>
                                <td width="81%"><%f_adicional.dibujaCampo("emat_ccod")%>
                                </td>
                              </tr>
							  <%end if
							  end if%>
							  
							  
                            </table>
                          </div></td>
                          </table>
                          <br></td>
                      </tr>
                    </table>
                    <br>
                  </form></td>
              </tr>
            </table></td>
          <td width="7" background="../imagenes/der.gif">&nbsp;</td>
        </tr>
        <tr> 
          <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
          <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="19%" height="20"><div align="center"> 
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td width="47%"><div align="center">
                            <%if tiene_ajustes="S" or plan_ccod = "" then
							     botonera.agregaBotonParam "guardar_matricula","deshabilitado","true"
							   end if
							'botonera.agregaBotonParam "guardar_nueva", "url", "Proc_Especialidades_Agregar.asp?espe_ccod=" & espe_ccod & ""
							botonera.dibujaBoton "guardar_matricula" %>
                          </div></td>
                        <td width="53%"><div align="center">
                            <%botonera.dibujaBoton "cerrar" %>
                          </div></td>
                      </tr>
                    </table>
                  </div></td>
                <td width="81%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
              </tr>
              <tr> 
                <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
              </tr>
            </table></td>
          <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
        </tr>
      </table>
      <br> </td>
  </tr>
</table>
</body>
</html>
