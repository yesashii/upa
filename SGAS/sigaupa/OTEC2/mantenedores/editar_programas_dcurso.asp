<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
mote_tdesc = request.querystring("mote_tdesc")
mote_ccod  = request.QueryString("mote_ccod")
dcur_ncorr = request.QueryString("dcur_ncorr")
codigo  = mote_ccod
modulo = mote_tdesc

'session("url_actual")="../mantenedores/m_modulos.asp?mote_tdesc="&mote_tdesc&"&mote_ccod="&mote_ccod
'response.Write("../mantenedores/m_modulos.asp?mote_tdesc="&mote_tdesc&"&mote_ccod="&mote_ccod)
set pagina = new CPagina
pagina.Titulo = "Agregar Modulos a <br> Diplomados"

set botonera =  new CFormulario
botonera.carga_parametros "m_diplomados_curso.xml", "botonera_modulos"
'response.End()
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set errores 	= new cErrores

'---------------------------------------------------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "m_diplomados_curso.xml", "form_busca_modulos"
formulario.inicializar conexion
if mote_ccod="" and mote_tdesc ="" then
	mote_ccod =""
	mote_tdesc =""
end if
consulta =" select '"&dcur_ncorr&"' as dcur_ncorr,a.mote_ccod,protic.initcap(a.mote_tdesc) as mote_tdesc " & vbCrlf & _
" from modulos_otec a" & vbCrlf & _
" Where ( a.mote_tdesc like '%"&mote_tdesc&"%' or '%"&mote_tdesc&"%' is null )" & vbCrlf & _
" and not exists (select 1 from mallas_otec b where a.mote_ccod=b.mote_ccod and cast(b.dcur_ncorr as varchar)='"&dcur_ncorr&"')"

'" nvl(to_char(a.ASIG_FINI_VIGENCIA, 'dd/mm/yyyy'),'- -') AS ASIG_FINI_VIGENCIA,   " & vbCrlf & _
'" nvl(to_char(a.ASIG_FFIN_VIGENCIA, 'dd/mm/yyyy'),'- -') AS ASIG_FFIN_VIGENCIA,  " & vbCrlf & _

'response.write("<pre>"&consulta&"</pre>")
formulario.consultar consulta & " order by mote_tdesc"
'response.Write("<pre>"&consulta&" order by asig_tdesc</pre>")

dcur_tdesc = conexion.consultaUno("select dcur_tdesc from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"'")

es_curso = conexion.consultaUno("select case count(*) when 0 then 'N' else 'S' end from diplomados_cursos where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"' and tdcu_ccod=1")
'response.Write("es curso " &es_curso)
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
function enviar(formulario){
    var dcur_ncorr = '<%=dcur_ncorr%>';
	formulario.action = 'editar_programas_dcurso.asp';
  	if(preValidaFormulario(formulario)){	
		formulario.submit();
		
	}
}
function abrir() {
	
	direccion = "editar_modulos.asp?codigo=<%=mote_ccod%>";
	resultado=window.open(direccion, "ventana1","width=400,height=200,scrollbars=no, left=380, top=350");
	
 // window.close();
}
function salir(){
window.close()
}

function seleccionar(elemento)
{ var es_curso = '<%=es_curso%>';
  var formulario = document.edicion;
	if (elemento.checked)
	 {
		str=elemento.name;
		      if(es_curso=="S")//debemos quitar otros módulos asociados si es curso
			  {
				  cantidad=document.edicion.length;
				  for(i=0;i<cantidad;i++)
				  {
				   elemento2=document.edicion.elements[i];
					if ( (elemento2.type=="checkbox") && (elemento2.name!=str) )
						{
						  if(elemento2.checked)
						  {
							 v_indice2=extrae_indice(elemento2.name);
							 document.edicion.elements["m["+v_indice2+"][maot_nhoras_programa]"].disabled=true;
							 document.edicion.elements["m["+v_indice2+"][maot_npresupuesto_relator]"].disabled=true;
							 document.edicion.elements["m["+v_indice2+"][dcur_norden]"].disabled=true;
							 document.edicion.elements["m["+v_indice2+"][maot_nhoras_programa]"].value="";
							 document.edicion.elements["m["+v_indice2+"][maot_npresupuesto_relator]"].value="";
							 document.edicion.elements["m["+v_indice2+"][dcur_norden]"].value="";
							 document.edicion.elements["m["+v_indice2+"][maot_nhoras_programa]"].id="NU-S";
							 document.edicion.elements["m["+v_indice2+"][maot_npresupuesto_relator]"].id="NU-S";
							 document.edicion.elements["m["+v_indice2+"][dcur_norden]"].id="NU-S";
							 elemento2.checked = false;
						  }
						}
				  }//fin del for
			  }//fin del if por si es curso	  
		
		v_indice=extrae_indice(str);
		//alert("es_curso "+es_curso);
		document.edicion.elements["m["+v_indice+"][maot_nhoras_programa]"].disabled=false;
		document.edicion.elements["m["+v_indice+"][maot_npresupuesto_relator]"].disabled=false;
		document.edicion.elements["m["+v_indice+"][dcur_norden]"].disabled=false;
		document.edicion.elements["m["+v_indice+"][maot_nhoras_programa]"].id="NU-N";
		document.edicion.elements["m["+v_indice+"][maot_npresupuesto_relator]"].id="NU-N";
		document.edicion.elements["m["+v_indice+"][dcur_norden]"].id="NU-N";
	 }
	else
	 {
		str=elemento.name;
		v_indice=extrae_indice(str);
		//alert("elemento "+elemento.name);
		document.edicion.elements["m["+v_indice+"][maot_nhoras_programa]"].disabled=true;
		document.edicion.elements["m["+v_indice+"][maot_npresupuesto_relator]"].disabled=true;
		document.edicion.elements["m["+v_indice+"][dcur_norden]"].disabled=true;
		document.edicion.elements["m["+v_indice+"][maot_nhoras_programa]"].id="NU-S";
		document.edicion.elements["m["+v_indice+"][maot_npresupuesto_relator]"].id="NU-S";
		document.edicion.elements["m["+v_indice+"][dcur_norden]"].id="NU-S";
	 }
}
</script>

</head>
<body bgcolor="#EAEAEA" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="550" height="100%">
<tr>
	<td bgcolor="#EAEAEA">
<table width="550" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA" align="center">
	</td></tr>
	
	
   <td valign="top" bgcolor="#EAEAEA" align="left">
	<table width="93%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
            <td>
                <table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
				  <tr>
                    <td><div align="center"><%pagina.DibujarTituloPagina%> <br></div></td>
                  </tr>
				  <tr>
                    <td align="center"><form name="buscador">
										  <br>
										  <table width="98%"  border="0" align="center">
											<tr>
												<td width="20%"><div align="center"><strong>Módulo</strong></td>
												<td width="3%"><div align="center"><strong>:</strong></td>
												<td width="62%"><input type="text" name="mote_tdesc" size="40" maxlength="20" onKeyDown="return bloquearTeclas(event.keyCode,this)" onKeyUp="this.value=this.value.toUpperCase()" id="TO-S" value="<%=modulo%>"></td>
											    <td align="right"><%botonera.dibujaboton "buscar"%></td>
											 </tr>
											 <tr>
												<td width="20%"><div align="center"><strong>Programa</strong></td>
												<td width="3%"><div align="center"><strong>:</strong></td>
												<td colspan="2"><strong><%=dcur_tdesc%></strong><input type="hidden" name="dcur_ncorr" value="<%=dcur_ncorr%>"></td>
											 </tr>
											 <%if es_curso = "S" then%>
											 <tr>
												<td colspan="4" align="center">
													<table width="95%" cellpadding="0" cellspacing="0">
														<tr><td align="center" bgcolor="#660000" align="center">
														      <font color="#FFFFFF" size="2"><strong>Recuerde que los cursos SÓLO pueden contener un módulo.</strong></font>
															</td>
														</tr>
													</table>
												</td>
											 </tr>
											 <%end if%>
    									  </table>
									   </form>
			    </td>
                  </tr> 
				  
				  <tr>
                    <td><hr></td>
                  </tr>
				  <form name="edicion">
                  <tr>
                    <td><div align="right"><strong>P&aacute;ginas :</strong>                          
                      <%formulario.accesopagina%>
                    </div></td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
                  <tr>
                    <td><div align="center">
                          <%formulario.dibujatabla()%>
                    </div></td>
                  </tr>
				 </form>
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
            <td width="28%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%botonera.dibujaboton "guardar"%></div></td>
                  <td><div align="center"><%botonera.dibujaboton "salir22"%></div></td>
                </tr>
              </table>
            </div></td>
            <td width="72%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	</td>
  </tr>  
</table>
</td>
</tr>
</table>
</body>
</html>
