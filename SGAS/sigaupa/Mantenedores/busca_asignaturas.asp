<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
asig_tdesc = request.querystring("asig_tdesc")
asig_ccod  = request.QueryString("asig_ccod")
codigo  = asig_ccod
asignatura = asig_tdesc
set pagina = new CPagina
pagina.Titulo = "Mantenedor De Asignaturas"

set botonera =  new CFormulario
botonera.carga_parametros "buscar_asignaturas.xml", "btn_busca_asignaturas"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'---------------------------------------------------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "buscar_asignaturas.xml", "form_busca_asig"
formulario.inicializar conexion
if asig_ccod="" and asig_tdesc ="" then
	asig_ccod =""
	asig_tdesc =""
end if
consulta =" select a.ASIG_CCOD, a.TASG_CCOD, a.EASI_CCOD, a.ASIG_TDESC, a.ASIG_NHORAS,  " & vbCrlf & _
" convert(varchar,asig_fini_vigencia,103) as ASIG_FINI_VIGENCIA, " & vbCrlf & _
" convert(varchar,asig_ffin_vigencia,103) as ASIG_FFIN_VIGENCIA,case a.duas_ccod when 1 then 'Trimestral' when 2 then 'Semestral' when 3 then 'Anual' when 5 then 'Periodo' else '' end as duas_tdesc, " & vbCrlf & _
" a.AUDI_TUSUARIO,a.AUDI_FMODIFICACION, b.easi_tdesc, c.tasg_tdesc,a.asig_nnivel_ayudante, d.clas_tdesc,isnull(e.area_tdesc,'--') as area,isnull(f.cred_tdesc,'--') as credito  " & vbCrlf & _
" from asignaturas a join estado_asignatura b" & vbCrlf & _
"      on a.easi_ccod = b.easi_ccod " & vbCrlf & _
" join tipos_asignatura c" & vbCrlf & _
"      on a.tasg_ccod  = c.tasg_ccod" & vbCrlf & _
" join clases_asignatura d" & vbCrlf & _
"      on isnull(a.clas_ccod,1) = d.clas_ccod" & vbCrlf & _
" left outer join area_asignatura e" & vbCrlf & _
"      on a.area_ccod=e.area_ccod" & vbCrlf & _
" left outer join creditos_asignatura f  " & vbCrlf & _
"      on a.cred_ccod = f.cred_ccod " & vbCrlf & _
" Where (a.asig_ccod like '%"&asig_ccod&"%' or '%"&asig_ccod&"%' is null )"& vbCrlf & _
" and ( a.asig_tdesc like '%"&asig_tdesc&"%' or '%"&asig_tdesc&"%' is null )"

'" nvl(to_char(a.ASIG_FINI_VIGENCIA, 'dd/mm/yyyy'),'- -') AS ASIG_FINI_VIGENCIA,   " & vbCrlf & _
'" nvl(to_char(a.ASIG_FFIN_VIGENCIA, 'dd/mm/yyyy'),'- -') AS ASIG_FFIN_VIGENCIA,  " & vbCrlf & _

'response.write("<pre>"&consulta&"</pre>")
formulario.consultar consulta & " order by asig_tdesc"
'response.Write("<pre>"&consulta&" order by asig_tdesc</pre>")

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
	formulario.action = 'busca_asignaturas.asp';
  	if(preValidaFormulario(formulario)){	
		formulario.submit();
		
	}
}
function abrir() {
	
	direccion = "consultar_asignatura.asp?codigo=<%=asig_ccod%>";
	resultado=window.open(direccion, "ventana1","width=250,height=100,scrollbars=no, left=380, top=350");
	
 // window.close();
}
function salir(){
window.close()
}
</script>

</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
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
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="40%"><div align="center"><input type="text" name="asig_ccod" size="20" maxlength="20" onKeyDown="return bloquearTeclas(event.keyCode,this)" onKeyUp="this.value=this.value.toUpperCase()" ID="TO-S" value="<%=codigo%>">
                      <br>
                                    Código Asignatura </div></td>
                  <td width="41%"><div align="center"><input type="text" name="asig_tdesc" size="20" maxlength="20" onKeyDown="return bloquearTeclas(event.keyCode,this)" onKeyUp="this.value=this.value.toUpperCase()" ID="TO-S" value="<%=asignatura%>">
                                    <br>
                                    Nombre Asignatura </div></td>
                  <td width="19%"><div align="center">
                    <%botonera.dibujaboton "buscar"%>
                  </div></td>
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
            <td><form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>                        <div align="center"><%pagina.DibujarTituloPagina%> <br>
                    </div></td>
                    </tr>
                  <tr>
                    <td><div align="right">
                      <div align="left">
                          <%pagina.DibujarSubtitulo "Lista De Asignaturas"%>                          
                      </div>
                      <div align="right">                        </div></td>
                  </tr>
                  <tr>
                    <td>                          <div align="left">
                    </div></td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
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
                </table>
                          <br>
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
                  <td><div align="center"><%botonera.dibujaboton "agregar"%></div></td>
                  <td><div align="center"><%botonera.dibujaboton "eliminar"%></div></td>
				  <td width="14%"> <div align="center">  <%
				                           botonera.agregabotonparam "excel", "url", "busca_asignaturas_excel.asp?asig_ccod="&asig_ccod&"&asig_tdesc="&asig_tdesc
										   botonera.dibujaboton "excel"
										%>
					 </div>
                  </td>
                  <td><div align="center"><%botonera.dibujaboton "salir"%></div></td>
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
