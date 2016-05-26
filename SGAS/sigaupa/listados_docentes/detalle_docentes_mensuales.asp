<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'response.Flush()
'for each k in request.QueryString()
'	response.Write(k&"<br>")
'next

sede = request.QueryString("sede_ccod")
grado = request.QueryString("grado")
periodo = request.QueryString("periodo")

url_anterior = "horas_docentes_mensuales.asp?busqueda[0][sede_ccod]="&sede


set conectar = new cConexion
conectar.inicializar "upacifico"

set negocio = new cnegocio
negocio.inicializa conectar



set pagina = new CPagina


set botonera =  new CFormulario
botonera.carga_parametros "docentes_mensuales.xml","botonera"
tituloPag = "Listado docentes "




set docentes = new cformulario
docentes.carga_parametros "docentes_mensuales.xml","lista_docentes_horas2"
docentes.inicializar conectar

plec_ccod = conectar.consultaUno("select plec_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")

if plec_ccod = "2" then
	anos_ccod = conectar.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&periodo&"'")
	primer_periodo = conectar.consultaUno("select peri_ccod from periodos_academicos where cast(anos_ccod as varchar)='"&anos_ccod&"' and plec_ccod = 1")
	filtro_periodo = "and cast(a.peri_ccod as varchar) = case g.duas_ccod when 3 then '"&primer_periodo&"' else '"&periodo&"' end "
else 
	filtro_periodo = "and cast(a.peri_ccod as varchar) = '"&periodo&"'"	
end if

if sede <> "" then
	filtro_sede= " and cast(a.sede_ccod as varchar)= '"&sede&"'"
	con_sede = " and hdc.sede_ccod= a.sede_ccod"
	campos = " c.pers_ncorr,a.sede_ccod "
else
	filtro_sede= ""	
	con_sede = " "
	campos = " c.pers_ncorr"
end if


if grado = 5 then
titulo = " Listado de docentes con grado académico Doctor"

consulta_Cantidad = " select e.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, "&vbCrLf &_
					" sede_tdesc as sede, carr_tdesc as carrera, ltrim(rtrim(asi.asig_ccod)) + ' ' + asig_tdesc as asignatura, se.secc_tdesc as seccion, "&vbCrLf &_
					" isnull(cast((horas / case asi.duas_ccod when 1 then 3 when 2 then 5 when 3 then 10 end  * 45 / 60) as decimal(4,1)),0) as horas  "&vbCrLf &_
					" from (select distinct "&campos&vbCrLf &_
					" from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d, carreras f,asignaturas g   "&vbCrLf &_
					" where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod   "&filtro_sede&vbCrLf &_
					" and c.pers_ncorr = d.pers_ncorr and d.grac_ccod = 5 and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3) "&vbCrLf &_
					" and d.egra_ccod in (1,3) and tpro_ccod=1  "&vbCrLf &_
					" and a.carr_ccod=f.carr_ccod and f.tcar_ccod = 1 "& filtro_periodo &vbCrLf &_
					" )a, horas_docentes_seccion_final hdc, asignaturas asi,personas e,secciones se,sedes sd, carreras car "&vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr and hdc.asig_ccod = asi.asig_ccod "&vbCrLf &_
					" and hdc.pers_ncorr=e.pers_ncorr and hdc.secc_ccod=se.secc_ccod "&vbCrLf &_
					" and se.sede_ccod=sd.sede_ccod and se.carr_ccod = car.carr_ccod "&con_sede&vbCrLf &_
					" and isnull(cast((horas / case asi.duas_ccod when 1 then 3 when 2 then 5 when 3 then 10 end  * 45 / 60) as decimal(4,1)),0) > 0 "
        

elseif grado = 4  then
titulo = " Listado de docentes con grado académico Magister"
consulta_Cantidad = "  select e.pers_ncorr,cast(e.pers_nrut as varchar)+'-'+e.pers_xdv as rut, e.pers_tape_paterno + ' '+ e.pers_tape_materno + ' ' + e.pers_tnombre as nombre, " &vbCrLf &_
					"  sede_tdesc as sede, carr_tdesc as carrera, ltrim(rtrim(asi.asig_ccod)) + ' ' + asig_tdesc as asignatura, se.secc_tdesc as seccion, " &vbCrLf &_
					"  isnull(cast((horas / case asi.duas_ccod when 1 then 3 when 2 then 5 when 3 then 10 end  * 45 / 60) as decimal(4,1)),0) as horas  " &vbCrLf &_
					"  from ( select distinct "&campos &vbCrLf &_
					"         from secciones a, bloques_horarios b, bloques_profesores c, grados_profesor d,carreras f,asignaturas g  " &vbCrLf &_
					"         where a.secc_ccod = b.secc_ccod and b.bloq_ccod=c.bloq_ccod  "&filtro_sede &vbCrLf &_
					"         and c.pers_ncorr = d.pers_ncorr and d.grac_ccod in (4,8) and a.asig_ccod=g.asig_ccod and g.duas_ccod in (1,2,3)  " &vbCrLf &_
					"         and not exists(select 1 from grados_profesor r where c.pers_ncorr=r.pers_ncorr and r.grac_ccod=5 and d.egra_ccod in (1,3))  " &vbCrLf &_
					"         and d.egra_ccod=1 and tpro_ccod=1  " &vbCrLf &_
					"         and a.carr_ccod=f.carr_ccod and f.tcar_ccod = 1 "& filtro_periodo &vbCrLf &_
					" )a, horas_docentes_seccion_final hdc, asignaturas asi,personas e,secciones se,sedes sd, carreras car " &vbCrLf &_
					" where hdc.pers_ncorr=a.pers_ncorr and hdc.asig_ccod = asi.asig_ccod " &vbCrLf &_
					" and hdc.pers_ncorr=e.pers_ncorr and hdc.secc_ccod=se.secc_ccod "&con_sede&vbCrLf &_
					" and se.sede_ccod=sd.sede_ccod and se.carr_ccod = car.carr_ccod " &vbCrLf &_
					" and isnull(cast((horas / case asi.duas_ccod when 1 then 3 when 2 then 5 when 3 then 10 end  * 45 / 60) as decimal(4,1)),0) > 0" 

end if
'--------------------------------------------------------------------------------------------------------------------------
'response.Write("<pre>"&consulta&"</pre>")
sede_tdesc = conectar.consultaUno("select protic.initCap(sede_tdesc) from sedes where cast(sede_ccod as varchar)='"&sede&"'")
sexo_tdesc = conectar.consultaUno("select protic.initCap(sexo_tdesc) from sexos where cast(sexo_ccod as varchar)='"&sexo&"'")

if sede = "" then
sede_tdesc = " Todas las sedes"
end if


'response.Write("<pre>"&consulta_cantidad&" order by nombre</pre>")
docentes.Consultar consulta_cantidad &" order by nombre, sede,carrera"
cantidad_lista= conectar.consultaUno("select count(distinct aa.pers_ncorr) from ("&consulta_cantidad&")aa")
total_horas = conectar.consultaUno("select cast(sum(horas) as decimal(10,2)) from ("&consulta_cantidad&")aa")
url_excel="listado_gestion_matricula_2.asp?sede="&sede&"&espe_ccod="&espe_ccod&"&epos_ccod="&epos_ccod&"&emat_ccod="&emat_ccod&"&nuevo="&nuevo
'response.Write(total_horas)
%>
<html>
<head>
<title>Listado Docentes</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">

function ver_resumen()
{
//alert("muestra historico de notas");
self.open('<%=url_carga%>','notas','width=700px, height=550px, scrollbars=yes, resizable=yes')
}

</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../__base/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
                <td>
                  <%pagina.dibujarSubTitulo(titulo)%>
                </td>
          </tr>
          <tr>
            <td><div align="center">
                    <p align="left">&nbsp; </p>
                    <table width="100%" border="0">
                      <%if RegistrosN>0 then%>
                      <tr> 
                        <td align="center">&nbsp; </td>
                      </tr>
                      <%end if%>
                      
                    </table>
                    <form name="edicion">
                      <div align="left">
                        <input name="url" type="hidden" value="<%=request.ServerVariables("HTTP_REFERER")%>">
                      </div>
                      <table width="98%" align="center">
					    <tr>
                          <td width="10%"><strong>Sede</strong></td>
						  <td width="3%"><strong>:</strong></td>
						  <td><%=sede_tdesc%></td>
                        </tr>
						<tr>
                          <td width="10%"><strong>Horas</strong></td>
						  <td width="3%"><strong>:</strong></td>
						  <td><%=total_horas%></td>
                        </tr>
						<tr>
                          <td width="10%"><strong>Total</strong></td>
						  <td width="3%"><strong>:</strong></td>
						  <td><%=cantidad_lista%> Docente(s)</td>
                        </tr>
                        <tr>
                          <td align="center" colspan="3"> <div align="right">P&aacute;ginas: 
                              <%docentes.AccesoPagina()%>
                            </div></td>
                        </tr>
                        <tr> 
                          <td align="center" colspan="3">&nbsp; <%docentes.dibujatabla()%> </td>
                        </tr>
                      </table>
                    </form>
                    <br>
                    <br>
                  </div>
                </td>
              </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28">
		 <table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="10%" height="20"><div align="center">
			 
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="11%"><div align="center"><% botonera.agregaBotonParam "anterior","url",url_anterior
				                                         botonera.dibujaboton "anterior"%> </div></td>
				  <td width="89%"> <div align="center">  <%
					                       botonera.agregabotonparam "excel", "url", "detalle_docentes_mensuales_excel.asp?sede="&sede&"&grado="&grado&"&periodo="&periodo
  									       botonera.dibujaboton "excel"
										%>
					 </div>  
                  </td>
               </tr>
              </table>
			
            </div></td>
            <td width="90%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<div align="right">* Las horas son medidas de forma cronológica &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
