<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Detalle Contratos"
set errores = new CErrores
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("PLANIFICACION")
anos_ccod = conexion.consultaUno("select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&Periodo&"'")
'anos_ccod=2009
'---------------------------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "detalle_contratos_docentes.xml", "botonera"
'---------------------------------------------------------------------------------------------------
 v_pers_ncorr = request.querystring("pers_ncorr")
 v_carr_ccod = request.querystring("carr_ccod")
 v_sede_ccod = request.querystring("sede_ccod")
 v_jorn_ccod = request.querystring("jorn_ccod")
 
 set f_contratos = new CFormulario
 f_contratos.Carga_Parametros "detalle_contratos_docentes.xml", "contrato_creados"
 f_contratos.Inicializar conexion
 
 consulta = " Select * " & vbCrLf &_ 
		    "   From contratos_docentes_upa a " & vbCrLf &_ 
			"    Where a.pers_ncorr="&v_pers_ncorr& vbCrLf &_ 
			"     and cast(a.ano_contrato as varchar)='"&anos_ccod&"'"& vbCrLf &_ 
			"     and a.ecdo_ccod <> 3 "

 
 f_contratos.Consultar consulta
 f_contratos.Siguiente

 consulta_contrato = " Select top 1 cdoc_ncorr " & vbCrLf &_ 
		    "   From contratos_docentes_upa a " & vbCrLf &_ 
			"    Where a.pers_ncorr="&v_pers_ncorr& vbCrLf &_ 
			"     and cast(a.ano_contrato as varchar)='"&anos_ccod&"'"& vbCrLf &_ 
			"     and a.ecdo_ccod <> 3 "
v_contrato_doc=conexion.ConsultaUno(consulta_contrato)
'response.Write(" Contrato: "&consulta_contrato)
'----------------------------------------------------------------------------------
set f_anexos = new CFormulario
f_anexos.Carga_Parametros "detalle_contratos_docentes.xml", "detalle_anexos_contratos"
f_anexos.Inicializar conexion

				 
consulta_anexos = " Select *, b.eane_ccod as estado ,b.anex_ncodigo as anexo, a.cdoc_ncorr as contrato  " & vbCrLf &_ 
		    "   From contratos_docentes_upa a, anexos b, estados_anexos c " & vbCrLf &_ 
			"    Where a.cdoc_ncorr=b.cdoc_ncorr " & vbCrLf &_ 
			"        And a.pers_ncorr="&v_pers_ncorr& vbCrLf &_ 
			"        and b.sede_ccod="&v_sede_ccod& vbCrLf &_ 
			"        and b.carr_ccod="&v_carr_ccod& vbCrLf &_ 
			"        and b.jorn_ccod="&v_jorn_ccod& vbCrLf &_ 
			" 		 and b.eane_ccod=c.eane_ccod "& vbCrLf &_ 
			" 		 and cast(a.cdoc_ncorr as varchar)='"&v_contrato_doc&"' "& vbCrLf &_ 
			"        and a.ecdo_ccod=1"
			
 
'response.Write("<pre>"&consulta_anexos&"</pre>")
v_nombre_docente=conexion.consultaUno("Select protic.obtener_nombre_completo('"&v_pers_ncorr&"','n')")
v_nombre_carrera= conexion.consultaUno("select top 1 (select sede_tdesc from sedes where sede_ccod="&v_sede_ccod&")+' - '+carr_tdesc +' - ' + case "&v_jorn_ccod&" when 1 then '(D)' else '(V)' end from carreras where carr_ccod='"&v_carr_ccod&"'")

 
 if Request.QueryString <> "" then
	  f_anexos.consultar consulta_anexos
	  
  else
	f_anexos.consultar "select '' where 1 = 2"
	f_anexos.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
  end if
'response.Write("<pre>"&consulta_anexos&"</pre>")
'response.End()
 cantidad=f_anexos.nroFilas
 if cantidad >0 then
 fila=0
	while f_anexos.siguiente
		
		  'response.Write("<br>Estado : "&f_anexos.ObtenerValor ("estado"))
		  v_estado=f_anexos.ObtenerValor ("estado")
		  if v_estado <> 1 then
		  	f_anexos.AgregaCampoFilaParam fila,"anex_finicio","permiso", "LECTURA"
			f_anexos.AgregaCampoFilaParam fila,"anex_ffin","permiso", "LECTURA"
			f_anexos.AgregaCampoFilaParam fila,"anex_ncuotas","permiso", "LECTURA"	
			f_anexos.AgregaCampoFilaParam fila,"anex_nhoras_coordina","permiso", "LECTURA"
	
		  end if
		  fila=fila+1
	wend	
 end if
 
 f_anexos.primero
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
	/*if (preValidaFormulario(form)){
		if (verifica_check(form,mensaje)){
			return true;
		}
	}*/
	alert("Funcion en etapa de desarrollo !!! ");	
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


function apaga_check(){
   nro = document.edicion.elements.length;
   num =0;
   for( i = 0; i < nro; i++ ) {
	  comp = document.edicion.elements[i];
	  str  = document.edicion.elements[i].name;
	  if(comp.type == 'checkbox'){
	     num += 1;
		 //alert(str);
		 v_indice=extrae_indice(str);
		 v_estado=document.edicion.elements["m["+v_indice+"][estado]"].value;
		 //alert("estado:"+v_estado);
		 if (v_estado!="1"){
		 	document.edicion.elements["m["+v_indice+"][anex_ncorr]"].disabled=true;
		 }
	  }
   }
}

</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="apaga_check();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../finanzas/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../finanzas/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../finanzas/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../finanzas/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">

<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
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
	<br>	
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
						<td width="9%"><strong>Escuela</strong></td>
						<td width="3%"><strong>:</strong></td>
						<td width="88%"><%=v_nombre_carrera%></td>
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
                      <%f_anexos.DibujaTabla %>
                    </div>
                  </form>
                    <br>
                </td>
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