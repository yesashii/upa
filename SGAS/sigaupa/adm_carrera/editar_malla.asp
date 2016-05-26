 <!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

set pagina = new CPagina
pagina.Titulo = "Actualizar Malla Curircular"
set botonera =  new CFormulario
botonera.carga_parametros "editar_malla.xml", "btn_edita_malla"
'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "desauas"

set negocio = new CNegocio
negocio.Inicializa conectar

'---------------------------------------------------------------------------------------------------
set tabla = new cformulario


codigo=  request.QueryString("mall_ccod")
plan =   request.QueryString("plan_ccod")
CodAsig= request.QueryString("asig_ccod")
Esp= request.QueryString("espe_ccod")
carr_ccod=request.QueryString("carr_ccod")

ConsultarCod="select carr_ccod from especialidades where espe_ccod='"& Esp&"'"
CodCarrera=conectar.consultauno(ConsultarCod)
ConEspe="select espe_tdesc from especialidades where espe_ccod='"& Esp&"'"
Espe=conectar.consultauno(ConEspe)
ConsultarCarr="select carr_tdesc from carreras where carr_ccod='"& CodCarrera &"'"
carrera=conectar.consultauno(ConsultarCarr)

'---------------------------------------------------------------------------
'---------------------------------------------------------------------------
set EMalla = new cformulario
EMalla.carga_parametros	"editar_malla.xml",	"edicion_malla"
Emalla.inicializar conectar
consulta = " SELECT  M.MALL_CCOD as mall_ccod, M.PLAN_CCOD as plan_ccod, M.NIVE_CCOD as nive_ccod, M.ASIG_CCOD as asig_ccod," & _
	       " P.PLAN_NCORRELATIVO AS PLAN_NCORRELATIVO, A.ASIG_TDESC AS ASIG_TDESC, A.ASIG_NHORAS AS ASIG_NHORAS, " & _
		   " M.MALL_NEVALUACION_MINIMA, trim(to_char(M.MALL_NOTA_PRESENTACION,'9.0')) as MALL_NOTA_PRESENTACION, M.MALL_PORCENTAJE_ASISTENCIA, M.MALL_PORCENTAJE_PRESENTACION, trim(to_char(M.MALL_NOTA_EXIMICION,'9.0')) as MALL_NOTA_EXIMICION "&_ 
		   " FROM malla_curricular M, planes_estudio P, asignaturas A " & _
		   " WHERE (    (P.plan_ccod = M.plan_ccod)" & _
           " AND (A.asig_ccod = M.asig_ccod)" & _
	       " AND (M.PLAN_CCOD='" & plan & "')" & _
    	   " AND (M.ASIG_CCOD='"& CodAsig&"') )"
'response.Write("<BR>" & consulta & "<BR>")

EMalla.consultar consulta
EMalla.siguiente

'---------------------------------------------------------------------------
'---------------------------------------------------------------------------

nro_niveles=conectar.consultauno("select max(nivel) from (select distinct " & _
		" b.nive_ccod as nivel, b.mall_ccod,b.plan_ccod as plan_ccod, c.espe_ccod as espe_ccod " & _
		" ,a.asig_ccod as asig_ccod, a.asig_tdesc as asignatura ,a.asig_nhoras as asig_nhoras " & _
		" from asignaturas a " & _
		" , malla_curricular b " & _
		" , planes_estudio c " & _
		" where a.asig_ccod = b.asig_ccod " & _
		" and b.plan_ccod=c.plan_ccod " & _
		" and b.plan_ccod = '"&plan&"' " & _
		" and c.espe_ccod = '"&esp&"' " & _
		" order by b.nive_ccod )")
		
MAX_nivel= conectar.consultauno(" SELECT  nvl(MIN(M2.NIVE_CCOD),0)" & _
 		  " FROM REQUISITOS R, MALLA_CURRICULAR M1, MALLA_CURRICULAR M2, tipos_requisito t, planes_estudio p " & _
          " WHERE R.MALL_CREQUISITO = M1.MALL_CCOD AND R.MALL_CCOD = M2.MALL_CCOD " & _
          " and r.TREQ_CCOD = t.TREQ_CCOD and m2.asig_ccod = m2.asig_ccod " & _
          " and m2.plan_ccod = p.plan_ccod and m2.plan_ccod = '"& plan&"'" & _ 
          " and p.espe_ccod = '"& esp &"' " & _
          " and m1.asig_ccod='"& CodAsig &"'" )

MIN_nivel= conectar.consultauno("SELECT nvl(MAX(M1.NIVE_CCOD),0) " & _
		   					   " FROM REQUISITOS R, MALLA_CURRICULAR M1, MALLA_CURRICULAR M2, tipos_requisito t, planes_estudio p " & _
							   " WHERE R.MALL_CREQUISITO = M1.MALL_CCOD" & _
							   " AND R.MALL_CCOD = M2.MALL_CCOD" & _
							   " and r.TREQ_CCOD = t.TREQ_CCOD" & _
							   " and m2.asig_ccod ='"& CodAsig&"'" & _
							   " and m2.plan_ccod = p.plan_ccod" & _
							   " and m2.plan_ccod ='"&plan&"' " & _
							   " and p.espe_ccod ='"&Esp&"'")


set fo = new cformulario
fo.carga_parametros "editar_malla.xml","AsgReq"
fo.inicializar conectar

requisito=  " SELECT  m1.mall_ccod as mall_crequisito, m2.mall_ccod as mall_ccod, asig.asig_tdesc as asig_tdesc, asig.asig_nhoras as asig_nhoras, m1.asig_ccod as asignatura,M1.ASIG_CCOD||' - '|| substr(t.TREQ_TDESC,1,3) as asig_ccod, m1.NIVE_CCOD AS NIVE_CCOD " & _
			" FROM REQUISITOS R, MALLA_CURRICULAR M1, MALLA_CURRICULAR M2, tipos_requisito t, planes_estudio p, asignaturas asig " &_
			" WHERE R.MALL_CREQUISITO = M1.MALL_CCOD " &_
			" AND R.MALL_CCOD = M2.MALL_CCOD " &_
			" and r.TREQ_CCOD = t.TREQ_CCOD " &_
			" and m2.asig_ccod = '" & Codasig & "' " &_
			" and m2.plan_ccod = p.plan_ccod " &_
			" and m2.plan_ccod = '"&plan&"' " &_
			" and p.espe_ccod = '" & Esp & "'" &_
			" and asig.asig_ccod=m1.asig_ccod" 

'response.Write(requisito)
fo.consultar requisito
if max_nivel="0" then
	max_nivel=nro_niveles+1
end if

'response.Write("<h1>"& min_nivel&" minimo<br>")
'response.Write("<h1>"& max_nivel&" maximo<br>")

'-------------------------------------------------------------------------
'-------------------------- HOMOLOGACIONES -------------------------------
'-------------------------------------------------------------------------

set f_homologaciones = new CFormulario
f_homologaciones.Carga_Parametros "editar_malla.xml", "f_homologaciones"
f_homologaciones.Inicializar conectar
consulta =  "SELECT a.homo_ccod, b.asig_ccod as destino, obtener_homologaciones (a.homo_ccod, b.asig_ccod) as homologaciones, "&_ 
            "count(c.ASIG_CCOD) as cant_asig, sum(nvl(c.hfue_nponderacion, 0)) as total_ponderacion "&_ 
			"FROM homologacion a, homologacion_destino b, homologacion_fuente c "&_
			"WHERE a.homo_ccod = b.homo_ccod "&_
			"  and a.homo_ccod = c.homo_ccod (+) "&_   
			"  and b.asig_ccod = '"& CodAsig & "' "&_
			"GROUP BY a.homo_ccod, b.asig_ccod "
'response.Write(consulta)
f_homologaciones.consultar consulta

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
function ir_crea_plan(){
window.location="crear_plan.asp?carr="+document.editar.carr_ccod.value+"&espe="+document.editar.esp.value+"&plan="+document.editar.plan.value+"&plan_ncorr="+document.editar.plan_ncorr.value;
}

function nivel(formulario){
		var nivel=MM_findObj("em[0][nive_ccod]");
		max_nivel=formulario.max_nivel.value;
		min_nivel=formulario.min_nivel.value;
		
		if (parseFloat(nivel.value)< parseFloat(max_nivel) && parseFloat(nivel.value)> parseFloat(min_nivel)){
			return(true);
		}
		else{
			return(false);
		}	
}
function elimina_req(formulario){
	  formulario.action="eliminar_requisitos.asp";
	  formulario.submit();
}
function agrega_req(formulario){
var nive_ccod=MM_findObj("em[0][nive_ccod]");
var plan=formulario.plan.value;
var esp=formulario.esp.value;
var carr_ccod=formulario.carr_ccod.value
var mall_ccod=formulario.mall_ccod.value
if(preValidaFormulario(formulario)){
		if(nivel(formulario)){
			 direccion="agregar_requsito.asp?nive_ccod="+nive_ccod.value+"&"+"plan="+plan+"&"+"esp="+esp+"&"+"carr_ccod="+carr_ccod+"&"+"mall_ccod="+mall_ccod;
		 	resultado=window.open(direccion, "ventana1","width=600,height=300,scrollbars=yes, left=0, top=0");
    	}
		else{
			alert('El nivel de la asignatura debe ser mayor a: '+ min_nivel+' y menor a: '+max_nivel);
		}
	}
	

}

function  prueba() {
var a = MM_findObj('direcciones[0][comu_ccod]', document);
var b = MM_findObj('direcciones[0][prov_ccod]', document);
var c = MM_findObj('direcciones[0][regi_ccod]', document);	
	if( a.value.length<6) {
		b.value=a.value.substr(0,3);
		c.value=a.value.substr(0,1);
	}
	else{
		b.value=a.value.substr(0,4);
		c.value=a.value.substr(0,2);
	}

alert(c.value)
}


function enviar(formulario){

	if(preValidaFormulario(formulario)){
		if(nivel(formulario)){
			formulario.action ='actualizar_malla.asp';	  
			formulario.submit();
		}
		else{
			alert('El nivel de la asignatura debe ser mayor a: '+ min_nivel+' y menor a: '+max_nivel);
		}
	}
	
}
function volver(formulario){
			formulario.method="get"
			formulario.action ='adm_mallas_curriculares.asp';	  
			formulario.submit();

}
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../__base/im&#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../__base/im&#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../__base/im&#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../__base/im&#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>

<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">	  <br>
	<table width="85%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
              <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Actualizar Malla Curricular"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><br><%pagina.DibujarSubtitulo "Asignaturas - Requisitos"%>
              <form name="editar" method="post">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>                     
                      <table width="100%" border="0" align="center">
                                  <tr> 
                                    <td width="23%" height="15" align="right"><div align="left"><font size="1"><strong>Programa 
                                        de estudio </strong></font></div></td>
                                    <td width="5%"><div align="center"><strong>:</strong></div></td>
                                    <td width="72%"><%=carrera%></td>
                                  </tr>
                                  <tr> 
                                    <td width="23%" height="15" align="right"><div align="left"><font size="1"><strong>Especialidad 
                                        </strong></font></div></td>
                                    <td><div align="center"><strong>:</strong></div></td>
                                    <td><%=Espe%></td>
                                  </tr>
                                  <tr> 
                                    <td height="15" align="right"><div align="left"><font size="1"><strong> 
                                        Plan </strong></font></div></td>
                                    <td><div align="center"><strong>:</strong></div></td>
                                    <td><%=EMalla.DibujaCampo("plan_ncorrelativo")%></td>
                                  </tr>
                                  <tr> 
                                    <td height="15" align="right"><div align="left"><strong>Cantidad 
                                        De Niveles </strong></div></td>
                                    <td><div align="center"><strong>:</strong></div></td>
                                    <td><%=nro_niveles%></td>
                                  </tr>
                                  <tr> 
                                    <td><div align="left"></div></td>
                                  </tr>
                                </table>
                      
                          <table width="100%" border="0">
                            <tr> 
                              <td colspan="4"><div align="center"><strong>ASIGNATURA</strong></div></td>
                            </tr>
                            <tr> 
                              <td colspan="4"><div align="center"> 
                                  <% 
	Emalla.dibujatabla()
%>
                                </div></td>
                            </tr>
                            <tr> 
                              <td colspan="4"><div align="right"> 
                                  <%botonera.dibujaboton "nivel"%>
                                  &nbsp;&nbsp;&nbsp;</div></td>
                            </tr>
                            <tr> 
                              <td colspan="4"><div align="center"><strong>REQUISITOS</strong></div></td>
                            </tr>
                            <tr> 
                              <td colspan="4"> <div align="center"> 
                                  <%fo.dibujatabla()%>
                                </div></td>
                            </tr>
                            <tr> 
                              <td width="9%"> <div align="right"> </div></td>
                              <td width="78%">&nbsp; </td>
                              <td width="8%"> <%botonera.dibujaboton "agregar"%> </td>
                              <td width="5%"> 
							  <%   if fo.nroFilas > 0 then
								      botonera.agregaBotonParam "eliminar", "deshabilitado", "FALSE"
								   else
								      botonera.agregaBotonParam "eliminar", "deshabilitado", "TRUE"
								   end if
							  botonera.dibujaboton "eliminar"
							  %> </td>
                            </tr>
                            <tr> 
                              <td colspan="4">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td colspan="4"><div align="center"><strong>HOMOLOGACIONES</strong></div></td>
                            </tr>
                            <tr> 
                              <td colspan="4"> <div align="center"> 
                                  <%f_homologaciones.dibujatabla()%>
                                </div></td>
                            </tr>
                            <tr> 
                              <td><div align="center"> </div></td>
                              <td>&nbsp;</td>
                              <td>
                                <%
								botonera.agregaBotonParam  "agregar_homologacion", "url" , "Homologacion_Agregar.asp?homo_ccod=NUEVA&destino=" & CodAsig
								botonera.dibujaboton "agregar_homologacion"
								%>
                              </td>
                              <td>
                                <% 
								   if f_homologaciones.nroFilas > 0 then
								      botonera.agregaBotonParam "eliminar_homologacion", "deshabilitado", "FALSE"
								   else
								      botonera.agregaBotonParam "eliminar_homologacion", "deshabilitado", "TRUE"
								   end if
								   botonera.agregaBotonParam  "eliminar_homologacion", "url" , "Homologacion_Eliminar.asp"
								   botonera.dibujaboton "eliminar_homologacion"%>
                              </td>
                            </tr>
                          </table></td>
                  </tr>
                </table>
                          <br>
		  <input name="max_nivel" type="hidden" value="<%=max_nivel%>">
  		  <input name="min_nivel" type="hidden" value="<%=min_nivel%>">
  		  <input name="plan" type="hidden" value="<%=plan%>">
  		  <input name="esp" type="hidden" value="<%=esp%>">
		  <input name="plan_ncorr" type="hidden" value="<%=EMalla.obtenerValor("plan_ncorrelativo")%>">
		  <input name="mall_ccod" type="hidden" value="<%=codigo%>">
		  <input name="carr_ccod" type="hidden" value="<%=carr_ccod%>">
		  
		  <input name="bsec[0][carr_ccod]" type="hidden" value="<%=carr_ccod%>">	
   	      <input name="bsec[0][espe_ccod]" type="hidden" value="<%=esp%>">		
   		  <input name="bsec[0][plan_ccod]" type="hidden" value="<%=plan%>">
		
  
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
                            <%botonera.dibujaboton "volver"%>
                          </div></td>
                  <td><div align="center"> </div></td>
                  <td><div align="center"></div></td>
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
</td>
  </tr>  
</table>

</body>
</html>
