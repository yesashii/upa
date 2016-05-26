 <!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
carrera       = request.QueryString("bsec[0][carr_ccod]")
especialidad  = request.QueryString("bsec[0][espe_ccod]")
nivel         = request.QueryString("bsec[0][nive_ccod]")
plan          = request.QueryString("bsec[0][plan_ccod]") 
carr_ccod = request.querystring("a[0][carr_ccod]")
espe_ccod = request.querystring("a[0][espe_ccod]")
plan_ccod= request.QueryString("a[0][plan_ccod]")


carrera=carr_ccod
especialidad=espe_ccod
plan=plan_ccod

'carrera22=carr_ccod
'especialidad22=espe_ccod
'planes22=plan_ccod
set errores = new CErrores

set pagina = new CPagina
pagina.Titulo = "Configurar Plan de Estudios"

set botonera =  new CFormulario
botonera.carga_parametros "configurar_plan.xml", "btn_busca_malla"
'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar


set tabla = new cformulario

ca="select cast(carr_ccod as varchar)+' - '+carr_tdesc as carr_tdesc from carreras where cast(carr_ccod as varchar)='"&carrera&"'"
rcarrera=conectar.consultauno(ca)
espe="select cast(espe_ccod as varchar)+ '-' +espe_tdesc as espe_tdesc from especialidades where cast(espe_ccod as varchar)='"&especialidad&"'"
respecialidad=conectar.consultauno(espe)
pl="select cast(plan_ccod as varchar)+'-'+cast(plan_ncorrelativo as varchar)+' - '+plan_tdesc as plan_ncorrelativo from planes_estudio where cast(plan_ccod as varchar)='"&plan&"'"
rplan=conectar.consultauno(pl)

tabla.carga_parametros	"configurar_plan.xml",	"tabla_conv"
tabla.inicializar		conectar

sede_ccod =1 ' negocio.obtenersede 
sede =1'negocio.obtenersede 

sede_ccod = negocio.ObtenerSede
sede = negocio.ObtenerSede
'response.End()
tablas=" select distinct " & vbCrLf & _
		" b.nive_ccod as nivel, b.mall_ccod,b.plan_ccod as plan_ccod, c.espe_ccod as espe_ccod " & vbCrLf & _
		" ,a.asig_ccod as asig_ccod, a.asig_tdesc as asignatura ,a.asig_nhoras as asig_nhoras,e.carr_ccod as carr_ccod,f.duas_tdesc as regimen, " & vbCrLf & _
		" case cpla_nporcentaje when null then '' else cast(cpla_nporcentaje as varchar) end as porcentaje, " & vbCrLf & _
        " case isnull(cpla_pertenece_certificado,0) when 0 then 'Sí' else 'No' end as en_certificado" & vbCrLf & _
		" from asignaturas a " & vbCrLf & _
		" , malla_curricular b " & vbCrLf & _
		" , planes_estudio c " & vbCrLf & _
		" , especialidades e" & vbCrLf & _
		" , duracion_asignatura f" & vbCrLf & _
		" , configuracion_planes g" & vbCrLf & _
		" where a.asig_ccod = b.asig_ccod " & vbCrLf & _
		" and e.ESPE_CCOD=c.ESPE_CCOD" & vbCrLf & _
		" and b.plan_ccod=c.plan_ccod " & vbCrLf & _
		" and a.duas_ccod=f.duas_ccod " & vbCrLf & _
		" and b.mall_ccod *= g.mall_ccod and b.asig_ccod *= g.asig_ccod " & vbCrLf & _
		" and b.mall_npermiso=0" & vbCrLf & _
		" and cast(b.plan_ccod as varchar)= '"&plan&"' " & vbCrLf & _
		" and cast(c.espe_ccod as varchar)= '"&especialidad&"' " & vbCrLf & _
		" order by b.nive_ccod,a.asig_ccod "
		

'response.Write("<pre>"&tablas&"</pre>")
set fo 		= 		new cFormulario
fo.carga_parametros	"configurar_plan.xml",	"tabla_conv"
fo.inicializar		conectar
fo.consultar 		tablas


'---------------------------------------------------modificado para corregir filtros 05-11-2004------------------


carrera = conectar.consultauno("SELECT carr_tdesc FROM carreras WHERE cast(carr_ccod as varchar) = '" & carr_ccod & "'")
especialidad = conectar.consultauno("SELECT espe_tdesc FROM especialidades WHERE cast(espe_ccod as varchar)= '" & espe_ccod & "'")
planes = conectar.consultauno("SELECT plan_tdesc FROM planes_estudio WHERE cast(plan_ccod as varchar)= '" & plan_ccod & "'")

 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "configurar_plan.xml", "buscador"
 f_busqueda.inicializar conectar

 peri = negocio.obtenerPeriodoAcademico ( "planificacion" ) 
 anos_ccod = conectar.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&peri&"'")
 sede = negocio.obtenerSede

 consulta="Select '"&carr_ccod&"' as carr_ccod, '"&espe_ccod&"' as espe_ccod, '"&plan_ccod&"' as plan_ccod"
 f_busqueda.consultar consulta

sede_tdesc = conectar.consultaUno("Select sede_tdesc from sedes where cast(sede_ccod as varchar)='"&sede&"'")

consulta = " select distinct ltrim(rtrim(cast(a.carr_ccod as varchar))) as carr_ccod,a.carr_tdesc,b.espe_ccod,b.espe_tdesc,c.plan_ccod,c.plan_tdesc " & vbCrLf & _
		   " from carreras a, especialidades b, planes_estudio c, ofertas_Academicas d,periodos_academicos e " & vbCrLf & _
		   " where a.carr_ccod=b.carr_ccod " & vbCrLf & _
		   " and b.espe_ccod=c.espe_ccod " & vbCrLf & _
		   " and b.espe_ccod=d.espe_ccod and a.tcar_ccod = 1" & vbCrLf & _
		   " and cast(d.sede_ccod as varchar)='"&sede&"' " & vbCrLf & _
		   " and d.peri_ccod= e.peri_ccod and cast(e.anos_ccod as varchar)='"&anos_ccod&"' " & vbCrLf & _
		   " order by a.carr_tdesc,b.espe_tdesc,c.plan_tdesc asc" 
'response.Write("<pre>"&consulta&"</pre>")	
f_busqueda.inicializaListaDependiente "lBusqueda", consulta

f_busqueda.siguiente



set fAsignaturas = new cFormulario
'fbusqueda.carga_parametros "parametros.xml", "2"
'fbusqueda.inicializar conectar
fAsignaturas.carga_parametros "parametros.xml", "3"
fAsignaturas.inicializar conectar

peri =negocio.ObtenerPeriodoAcademico("PLANIFICACION")


carreras = negocio.obtenerCarreras
if plan="" then 
	plan="0"
end if



 n_asig  = conectar.consultauno(" select count(*) " & _
		" from malla_curricular a" & _
		" where cast(a.plan_ccod as varchar)= '"&plan&"' and mall_npermiso = 0")




carrera_cerrada= conectar.consultaUno("select carr_ncerrada from carreras where cast(carr_ccod as varchar)='"& carr_ccod &"'")
'response.Write("carrera_cerrada" &carrera_cerrada)
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
function elim_asig(formulario){
	mensaje="eliminar Asignaturas";
	if (verifica_check(formulario,mensaje)) {
		formulario.method="post"
		formulario.action = 'eliminar_asig_plan.asp';
		formulario.submit();
	}
}

function enviar(formulario){
formulario.submit();
}
function agrega_asig(formulario){

	direccion="agregar_asig.asp?carr="+formulario.carr.value+"&plan="+formulario.plan.value+"&espe="+formulario.espe.value;
	resultado=window.open(direccion, "ventana1","width=700,height=550,scrollbars=yes, left=0, top=0");
}





</script>
<% f_busqueda.generaJS %>
</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../__base/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../__base/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();" >
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
            <td><form name="buscador" method="get">
              <br>
                <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
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
                                <td width="15%"><div align="left"><strong>Plan</strong></div></td>
                                <td width="4%"><div align="center"><strong>:</strong></div></td>
                                <td width="81%"><%f_busqueda.dibujaCampoLista "lBusqueda", "plan_ccod"%></td>
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
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%><br>
                </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%if carrera <> "" and especialidad  <> "" and plan <> "" then %>
                          <table width="627">
                            <tr> 
                              <td width="137" nowrap>Sede</td>
                              <td width="478">:<strong><%=sede_tdesc%></strong></td>
                            </tr>
							<tr> 
                              <td width="137" nowrap>Programa de Estudio</td>
                              <td width="478">:<strong><%=rcarrera%></strong></td>
                            </tr>
                            <tr> 
                              <td>Especilidad</td>
                              <td>:<strong><%=respecialidad%></strong></td>
                            </tr>
                            <tr> 
                              <td>Plan</td>
                              <td>:<strong><%=rplan%></strong></td>
                            </tr>
                          </table>
                          <%end if %><br><%pagina.DibujarSubtitulo "Asignaturas del plan de estudios"%>
                      <br>
                      <table width="100%" border="0">
                        <tr>
                          <td>&nbsp;</td>
                        </tr>
                        <tr>
                          <td><div align="center">
                                <% 
									fo.dibujatabla()
								%>
                          </div></td>
                        </tr>
						<tr>
                          <td>- Las asignaturas que presenten porcentaje cero y se muestren en la concentración de notas, se considerará la nota como si fuera una asignatura normal.</td>
                        </tr>
						<tr>
                          <td>&nbsp;</td>
                        </tr>
     
                      </table>
					  </td>
                  </tr>
                </table>
                          <br>
						  	  <input name="n_asig" type="hidden" value="<%=n_asig%>">
						      <input name="carr" type="hidden" value="<%=rcarrera%>">
							  <input name="espe" type="hidden" value="<%=respecialidad%>">
							  <input name="planes2" type="hidden" value="<%=rplan%>">
							  
							   <input name="plan" type="hidden" value="<%=plan%>">
							  <input name="cod_carrera" type="hidden" value="<%=carr_ccod%>">
							  <input name="cod_planes" type="hidden" value="<%=plan_ccod%>">
							  <input name="cod_especialidad" type="hidden" value="<%=espe_ccod%>">

            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="15%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">  
				    <%'botonera.agregabotonparam "excel", "url", "listado_mallas_excel.asp"
					  'botonera.dibujaboton "excel"%>
				  </div></td>
                  <td><div align="center">
                    <%botonera.dibujaboton "SALIR"%>
                  </div></td>
                </tr>
              </table>
            </div></td>
            <td width="85%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
