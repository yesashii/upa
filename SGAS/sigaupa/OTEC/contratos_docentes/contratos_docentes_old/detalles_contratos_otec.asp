<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Detalle Contratos OTEC"
set errores = new CErrores
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'---------------------------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "detalle_contratos_docentes_otec.xml", "botonera"
'---------------------------------------------------------------------------------------------------
 v_pers_ncorr = request.querystring("pers_ncorr")
 v_dcur_ncorr = request.querystring("dcur_ncorr")
 v_sede_ccod = request.querystring("sede_ccod")
 v_anos_ccod=request.querystring("anos_ccod")
usu=negocio.obtenerUsuario
 set f_contratos = new CFormulario
 f_contratos.Carga_Parametros "detalle_contratos_docentes_otec.xml", "contrato_creados"
 f_contratos.Inicializar conexion
 
 consulta = "Select distinct cdot_ncorr,(select ecdo_tdesc from estados_contratos_docentes ecd where ecd.ecdo_ccod=a.ecdo_ccod)as estado_contrato,cdot_fcontrato,cdot_finicio,cdot_ffin,ano_contrato,tcdo_ccod,a.ecdo_ccod "& vbCrLf &_ 
   			"From contratos_docentes_OTEC a,TIPOS_PROFESORES tp,estados_contratos_docentes ec "& vbCrLf &_ 
    		"    Where a.pers_ncorr="&v_pers_ncorr& vbCrLf &_
     		"and a.ano_contrato="&v_anos_ccod&""& vbCrLf &_ 
     		"and a.ecdo_ccod=ec.ecdo_ccod  and a.ecdo_ccod <> 3 "    
			
'response.Write("<pre>"&consulta&"</pre>")
 'response.End()
 f_contratos.Consultar consulta
 f_contratos.Siguiente
 q_tcdo_ccod=f_contratos.obtenerValor("tcdo_ccod")
 f_contratos.AgregaCampoCons "tcdo_ccod", q_tcdo_ccod

'response.End() 
 consulta_contrato = " Select top 1 cdot_ncorr " & vbCrLf &_ 
		    "From contratos_docentes_OTEC a " & vbCrLf &_ 
			"Where a.pers_ncorr="&v_pers_ncorr& vbCrLf &_ 
			"and a.ano_contrato="&v_anos_ccod&" and ecdo_ccod=1"
			
'response.Write("<pre>"&consulta_contrato&"</pre>")			
			
v_contrato_doc=conexion.ConsultaUno(consulta_contrato)
v_nombre_docente=conexion.ConsultaUno("Select protic.obtener_nombre_completo('"&v_pers_ncorr&"','n')")
v_nombre_curso=conexion.ConsultaUno("select dcur_tdesc from diplomados_cursos where dcur_ncorr="&v_dcur_ncorr&"")
'response.Write(" Curso: "&v_nombre_curso)
'response.End()
'----------------------------------------------------------------------------------

 set f_anexos = new CFormulario
 f_anexos.Carga_Parametros "detalle_contratos_docentes_otec.xml", "detalle_anexos_contratos"
 f_anexos.Inicializar conexion
 
 consulta_anexos=" Select *, (select eane_tdesc from estados_anexos ea where ea.eane_ccod=b.eane_ccod) as estado_anexo,b.eane_ccod as estado ,b.anot_ncodigo as anexo, a.cdot_ncorr as contrato " & vbCrLf &_ 
		    "From contratos_docentes_otec a, anexos_otec b, estados_anexos c " & vbCrLf &_ 
			"Where a.cdot_ncorr=b.cdot_ncorr " & vbCrLf &_ 
			"And a.pers_ncorr="&v_pers_ncorr& vbCrLf &_ 
			"and b.sede_ccod="&v_sede_ccod& vbCrLf &_ 
			"and b.eane_ccod=c.eane_ccod "& vbCrLf &_ 
			"and cast(a.cdot_ncorr as varchar)='"&v_contrato_doc&"' "& vbCrLf &_ 
			"and a.ecdo_ccod=1"
 
 f_anexos.Consultar consulta_anexos
 'f_anexos.SiguienteF
 

'response.Write("<br>"&consulta_anexos)

'response.Write(consulta_anexos)
'----------------------------------------------------------------------- 
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

<script language="JavaScript" >
function Guardar_Anexos(form){
mensaje="Guardar";
	if (preValidaFormulario(form)){
		if (verifica_check(form,mensaje)){
			return true;
		}
	}	
	return false;
} 

function Anula_Anexos(form){
mensaje="Anular";
	if (preValidaFormulario(form)){
		if (verifica_check(form,mensaje)){
			return true;
		}
	}	
	return false;
} 

function Anula_Contrato(form){
mensaje="Anular";
if (preValidaFormulario(form)){
		if (verifica_check(form,mensaje)){
			return true;
		}
	}	
	return false;
} 


function Guardar_Contrato(form){
mensaje="Guardar";
	if (preValidaFormulario(form)){
		if (verifica_check(form,mensaje)){
			return true;
		}
	}	
	return false;
} 
function Cerrar_Contrato(form){
mensaje="Cerrar";
	if (preValidaFormulario(form)){
		if (verifica_check(form,mensaje)){
			return true;
		}
	}	
	return false;
} 


function apaga_check(){
   nro = document.edicion.elements.length;
   num =0;
   for( i = 0; i < nro; i++ ) {
	  comp = document.edicion.elements[i];
	  str  = document.edicion.elements[i].name;
	  if(comp.type == 'checkbox'){
	     num += 1;
		 //alert("str="+str);
		 //alert("comp="+comp.type);
		 v_indice=extrae_indice(comp.name);
		  //alert("indice:"+v_indice);
		 v_estado=document.edicion.elements["m["+v_indice+"][eane_ccod]"].value;
		 //v_estado=form.elements["m["+v_indice+"][eane_ccod]"].value
		 //alert("estado:"+v_estado);
		 
		 if (v_estado !="1"){
		 //alert("estado:"+v_estado);
		 	document.edicion.elements["m["+v_indice+"][cdot_ncorr]"].disabled=true;
		 }
	  }
   }
}

function apaga_check2(){
   nro = document.contrato.elements.length;
   num =0;
   for( i = 0; i < nro; i++ ) {
	  comp = document.contrato.elements[i];
	  str  = document.contrato.elements[i].name;
	  if(comp.type == 'checkbox'){
	     num += 1;
		 //alert("str="+str);
		 //alert("comp="+comp.type);
		 v_indice=extrae_indice(comp.name);
		  //alert("indice:"+v_indice);
		 v_estado=document.contrato.elements["cdot["+v_indice+"][ecdo_ccod]"].value;
		 //v_estado=form.elements["m["+v_indice+"][eane_ccod]"].value
		 //alert("estado:"+v_estado);
		 
		 if (v_estado !="1"){
		 //alert("estado:"+v_estado);
		 	document.contrato.elements["cdot["+v_indice+"][cdot_ncorr]"].disabled=true;
		 }
	  }
   }
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="apaga_check(); apaga_check2();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../finanzas/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../finanzas/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../finanzas/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../finanzas/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">

<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
              <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="670" height="8" border="0" alt=""></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="14" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="208" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Contratos Creados</font></div></td>
                    <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="430" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
                  </tr>
              </table></td>
              <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>              
            </tr>
            <tr>
              <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
          </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"><div align="center">
				<form name="contrato">
                  <table width="98%"  border="0">
                    <tr>
                      <td colspan="2" align="center"><% f_contratos.DibujaTabla() %></td>                              
                    </tr>
					<tr>
					<td width="80%">&nbsp;</td>
						<td width="20%">
							<table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
								<tr> 
								  <td width="50%"><div align="center"><%botonera.dibujaboton "guardar_contrato"%></div></td>
								   <td width="50%"><div align="center"><%botonera.dibujaboton "cerrar_contrato"%></div></td>
								  <td width="50%"><div align="center"><%botonera.dibujaboton "anular_contrato"%></div></td>
								</tr>
						   	</table>
					  </td>
					</tr>
                  </table>
				  
				</form>
                </div></td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="670" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>			
          </td>
      </tr>
    </table>	
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
            <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
            <tr>
              <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="559" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="670" height="8" border="0"></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Listado 
                          Anexos Contrato</font></div>
                    </td>
                    <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                  </tr>
                </table>
              </td>
              <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
            </tr>
            <tr>
              <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="670" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
            </tr>
          </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"> <div align="center"><BR>
                    <%pagina.DibujarTituloPagina%>
					<table width="100%" border="0">
					<tr>
						<td width="9%"><strong>Curso</strong></td>
						<td width="3%"><strong>:</strong></td>
						<td ><%=v_nombre_curso%></td>
					</tr>
					<tr>
						<td><strong>Docente</strong></td>
						<td><strong>:</strong></td>
						<td><%=v_nombre_docente%></td>
					</tr>
					</table>
                    <table width="665" border="0">
                      <tr> 
                        <td width="116">&nbsp;</td>
                        <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
                            <%f_anexos.AccesoPagina%>
                          </div></td>
                        <td width="24"> <div align="right"> </div></td>
                      </tr>
                    </table>
                  </div>
                  <form name="edicion">
                    <div align="center">
                      <%f_anexos.DibujaTabla%>
                    </div>
                  </form>
                    <br>                </td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                <td bgcolor="#D8D8DE">
				<table width="100%"  border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td><div align="center"> <% botonera.dibujaboton "guardar" %></div></td>
                      <td><%botonera.dibujaboton "anular"%>
                      </td>
                      <td> <div align="left"> <% botonera.DibujaBoton "volver" %></div></td>
                      <td> <div align="left"> </div></td>
                    </tr>
                  </table>
                </td>
                <td width="167" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
              </tr>
              <tr>
                <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
              </tr>
            </table>
        </td>
      </tr>
    </table>
	<p>&nbsp;</p></td>
  </tr>  
</table>
</body>
</html>