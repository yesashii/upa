<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Actualizar Malla Curricular"
set botonera =  new CFormulario
botonera.carga_parametros "editar_malla.xml", "btn_edita_malla"
'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

'----------------restringir que solo puedan ver las modificaciones para usuarios  de registro_curricular------
'---------------------------------------autorizado por Marco Perelli 08-06-2005--------------------------
usuario=negocio.obtenerUsuario
restringir =conectar.consultaUno("select b.pers_ncorr from personas a, sis_roles_usuarios b where a.pers_ncorr=b.pers_ncorr and b.srol_ncorr=95 and cast(a.pers_nrut as varchar)='"&usuario&"'")
'---------------------------------------------------------------------------------------------------
set tabla = new cformulario
set EMalla = new cformulario

codigo		=  	request.QueryString("mall_ccod")
plan 		=   request.QueryString("plan_ccod")
CodAsig		= 	request.QueryString("asig_ccod")
Esp			= 	request.QueryString("espe_ccod")
carr_ccod	=	request.QueryString("carr_ccod")

carrera_cerrada= conectar.consultaUno("select carr_ncerrada from carreras where cast(carr_ccod as varchar)='"& carr_ccod &"'")
'response.Write("carrera_cerrada "&carrera_cerrada)
ConsultarCod="select carr_ccod from especialidades where espe_ccod='"& Esp&"'"
CodCarrera=conectar.consultauno(ConsultarCod)
ConEspe="select espe_tdesc from especialidades where espe_ccod='"& Esp&"'"
Espe=conectar.consultauno(ConEspe)
ConsultarCarr="select carr_tdesc from carreras where carr_ccod='"& CodCarrera &"'"
carrera=conectar.consultauno(ConsultarCarr)

EMalla.carga_parametros	"editar_malla.xml",	"edicion_malla"
Emalla.inicializar conectar

consulta = " SELECT  M.MALL_CCOD as mall_ccod, M.PLAN_CCOD as plan_ccod, M.NIVE_CCOD as nive_ccod, M.ASIG_CCOD as asig_ccod," & vbCrlf & _
	       " P.PLAN_NCORRELATIVO AS PLAN_NCORRELATIVO, A.ASIG_TDESC AS ASIG_TDESC, A.ASIG_NHORAS AS ASIG_NHORAS " & vbCrlf & _
		   " FROM malla_curricular M, planes_estudio P, asignaturas A " & vbCrlf & _
		   " WHERE (    (P.plan_ccod = M.plan_ccod)" & vbCrlf & _
           " AND (A.asig_ccod = M.asig_ccod)" & vbCrlf & _
	       " AND (M.PLAN_CCOD='" & plan & "')" & vbCrlf & _
    	   " AND (M.ASIG_CCOD='"& CodAsig&"') )"
'response.Write("<pre>"&consulta&"</pre>")

nro_niveles=conectar.consultauno("select max(b.nive_ccod) as nivel" & vbCrlf & _
		" from asignaturas a " & vbCrlf & _
		" , malla_curricular b " & vbCrlf & _
		" , planes_estudio c " & vbCrlf & _
		" where a.asig_ccod = b.asig_ccod " & vbCrlf & _
		" and b.plan_ccod=c.plan_ccod " & vbCrlf & _
		" and b.plan_ccod = '"&plan&"' " & vbCrlf & _
		" and c.espe_ccod = '"&esp&"' ")


		
'nro_niveles=conectar.consultauno("select max(nivel) from (select distinct " & vbCrlf & _
'		" b.nive_ccod as nivel, b.mall_ccod,b.plan_ccod as plan_ccod, c.espe_ccod as espe_ccod " & vbCrlf & _
'		" ,a.asig_ccod as asig_ccod, a.asig_tdesc as asignatura ,a.asig_nhoras as asig_nhoras " & vbCrlf & _
'		" from asignaturas a " & vbCrlf & _
'		" , malla_curricular b " & vbCrlf & _
'		" , planes_estudio c " & vbCrlf & _
'		" where a.asig_ccod = b.asig_ccod " & vbCrlf & _
'		" and b.plan_ccod=c.plan_ccod " & vbCrlf & _
'		" and b.plan_ccod = '"&plan&"' " & vbCrlf & _
'		" and c.espe_ccod = '"&esp&"' " & vbCrlf & _
'		" order by b.nive_ccod )")
		
		
'MAX_nivel= conectar.consultauno(" SELECT  nvl(MIN(M2.NIVE_CCOD),0)" & vbCrlf & _
MAX_nivel= conectar.consultauno(" SELECT  isnull(MIN(M2.NIVE_CCOD),0)" & vbCrlf & _
 		  " FROM REQUISITOS R, MALLA_CURRICULAR M1, MALLA_CURRICULAR M2, tipos_requisito t, planes_estudio p " & vbCrlf & _
          " WHERE R.MALL_CREQUISITO = M1.MALL_CCOD AND R.MALL_CCOD = M2.MALL_CCOD " & vbCrlf & _
          " and r.TREQ_CCOD = t.TREQ_CCOD and m2.asig_ccod = m2.asig_ccod " & vbCrlf & _
          " and m2.plan_ccod = p.plan_ccod and m2.plan_ccod = '"& plan&"'" & vbCrlf & _
          " and p.espe_ccod = '"& esp &"' " & vbCrlf & _
          " and m1.asig_ccod='"& CodAsig &"'" )


'MIN_nivel= conectar.consultauno("SELECT nvl(MAX(M1.NIVE_CCOD),0) " & _
MIN_nivel= conectar.consultauno("SELECT isnull(MAX(M1.NIVE_CCOD),0)" & vbCrlf & _
		   					   " FROM REQUISITOS R, MALLA_CURRICULAR M1, MALLA_CURRICULAR M2, tipos_requisito t, planes_estudio p " & vbCrlf & _
							   " WHERE R.MALL_CREQUISITO = M1.MALL_CCOD" & vbCrlf & _
							   " AND R.MALL_CCOD = M2.MALL_CCOD" & vbCrlf & _
							   " and r.TREQ_CCOD = t.TREQ_CCOD" & vbCrlf & _
							   " and m2.asig_ccod ='"& CodAsig&"'" & vbCrlf & _
							   " and m2.plan_ccod = p.plan_ccod" & vbCrlf & _
							   " and m2.plan_ccod ='"&plan&"' " & vbCrlf & _
							   " and p.espe_ccod ='"&Esp&"'")

EMalla.consultar consulta

EMalla.siguiente

set fo = new cformulario
fo.carga_parametros "editar_malla.xml","AsgReq"
fo.inicializar conectar

'requisito=  " SELECT  m1.mall_ccod as mall_crequisito, m2.mall_ccod as mall_ccod, asig.asig_tdesc as asig_tdesc, asig.asig_nhoras as asig_nhoras, m1.asig_ccod as asignatura,M1.ASIG_CCOD||' - '|| substr(t.TREQ_TDESC,1,3) as asig_ccod, m1.NIVE_CCOD AS NIVE_CCOD " & _
requisito=  " SELECT  m1.mall_ccod as mall_crequisito, m2.mall_ccod as mall_ccod, asig.asig_tdesc as asig_tdesc, asig.asig_nhoras as asig_nhoras, m1.asig_ccod as asignatura,M1.ASIG_CCOD + ' - ' + left(t.TREQ_TDESC,3) as asig_ccod, m1.NIVE_CCOD AS NIVE_CCOD " & vbCrlf & _
			" FROM REQUISITOS R, MALLA_CURRICULAR M1, MALLA_CURRICULAR M2, tipos_requisito t, planes_estudio p, asignaturas asig " & vbCrlf & _
			" WHERE R.MALL_CREQUISITO = M1.MALL_CCOD " & vbCrlf & _
			" AND R.MALL_CCOD = M2.MALL_CCOD " & vbCrlf & _
			" and r.TREQ_CCOD = t.TREQ_CCOD " & vbCrlf & _
			" and cast(m2.asig_ccod as varchar)= '" & Codasig & "' " & vbCrlf & _
			" and m2.plan_ccod = p.plan_ccod " & vbCrlf & _
			" and cast(m2.plan_ccod as varchar)= '"&plan&"' " & vbCrlf & _
			" and cast(p.espe_ccod as varchar)= '" & Esp & "'" & vbCrlf & _
			" and asig.asig_ccod=m1.asig_ccod" 

'response.Write("<pre>"&requisito&"</pre>")		
'response.end 

'response.Write(requisito)
fo.consultar requisito
	
if max_nivel = "0" then
	max_nivel=cint(nro_niveles) + 1
end if

'response.Write("<h1>"& min_nivel&" minimo<br>")
'response.Write("<h1>"& max_nivel&" maximo<br>")

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
		
		if (parseFloat(nivel.value)< 11 && parseFloat(nivel.value)> parseFloat(min_nivel)){
			return(true);
		}
		else{
			return(false);
		}	
}
function elimina_req(formulario){
	mensaje="eliminar Requisitos";
	if (verifica_check(formulario,mensaje)) {
	  formulario.action="eliminar_requisitos.asp";
	  formulario.submit();
	} 
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
            var plan;
			var espe;
			var carr_ccod;
			plan=<%=plan%>;
			espe=<%=Esp%>;
			carr_ccod=<%=carr_ccod%>;
					
			//alert("plan= "+plan+" especialidad= "+espe+" carrera= "+carr_ccod);
			//reemplazado este link porqueno conserva filtro carrera
			//window.location="adm_mallas_curriculares.asp?busqueda[0][carr_ccod]="+carr_ccod+"&busqueda[0][espe_ccod]="+espe+"&busqueda[0][plan_ccod]="+plan;	  
			
			window.location="ADM_MALLAS_CURRICULARES.ASP?a%5B0%5D%5Bcarr_ccod%5D="+carr_ccod+"+&a%5B0%5D%5Bespe_ccod%5D="+espe+"+&a%5B0%5D%5Bplan_ccod%5D="+plan;
			
			

}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  	</tr
  ><tr>
    <td valign="top" bgcolor="#EAEAEA">	  <br>
	<table width="70%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
                          <td width="42%" height="15" align="left"><font size="1"><strong>Programa de estudio</strong></font></td>
                          <td>:<%=carrera%></td>
                        </tr>
                        <tr>
                          <td width="42%" height="15" align="left"><font size="1"><strong>Especialidad</strong></font></td>
                          <td>:<%=Espe%></td>
                        </tr>
                        <tr>
                          <td height="15" align="left"><font size="1"><strong> Plan</strong></font></td>
                          <td>:<%=EMalla.DibujaCampo("plan_ncorrelativo")%></td>
                        </tr>
                        <tr>
                          <td height="15" align="left"><strong>Cantidad De Niveles </strong></td>
                          <td>:<%=nro_niveles%></td>
                        </tr>
                        <tr>
                          <td>&nbsp;</td>
                        </tr>
                      </table>
                      
                      <table width="100%" border="0">
                        <tr>
                          <td><div align="center"><strong>ASIGNATURA</strong></div></td>
                        </tr>
                        <tr>
                          <td><div align="center">
                            <% 
	Emalla.dibujatabla()
%>
</div></td>
                        </tr>
                        <tr>
                          <td><div align="right"><%
						     if ((carrera_cerrada="1") or (not Esvacio(restringir))) then
					    			 botonera.agregaBotonParam "nivel","deshabilitado","TRUE"
							 end if
							 botonera.dibujaboton "nivel"%>&nbsp;&nbsp;&nbsp;</div></td>
                        </tr>
                        <tr>
                          <td><div align="center"><strong>REQUISITOS</strong></div></td>
                        </tr>
                        <tr>
                          <td><div align="center">
                            <%fo.dibujatabla()%>
                          </div></td>
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
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                    <%
					if ((carrera_cerrada="1") or (not Esvacio(restringir))) then
					     botonera.agregaBotonParam "agregar","deshabilitado","TRUE"
					end if
					botonera.dibujaboton "agregar"%>
                  </div></td>
                  <td><div align="center"> <%
				  if ((carrera_cerrada="1") or (not Esvacio(restringir))) then
					     botonera.agregaBotonParam "eliminar","deshabilitado","TRUE"
				  end if
				  botonera.dibujaboton "eliminar"%></div></td>
                  <td><div align="center"><%botonera.dibujaboton "volver"%></div></td>
                </tr>
              </table>
            </div></td>
            <td width="62%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
