<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
asig_tdesc = request.querystring("asig_tdesc")
asig_ccod_2 = request.QueryString("asig_ccod_2")
sede_ccod = request.QueryString("sede_ccod")
peri_ccod = request.QueryString("periodo")
asig_ccod = request.QueryString("asig_ccod")
carr_ccod = request.QueryString("carr_ccod")
nive_ccod = request.QueryString("nive_ccod")
espe_ccod = request.QueryString("espe_ccod")
plan_ccod = request.QueryString("plan_ccod")
codigo  = asig_ccod_2
asignatura = asig_tdesc
set pagina = new CPagina
set ftitulo = new cFormulario
pagina.Titulo = "Asignaturas Sin Plan De Estudio"

set botonera =  new CFormulario
botonera.carga_parametros "buscar_asignaturas_elec.xml", "btn_busca_asignaturas"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'---------------------------------------------------------------------------------------------------
set formulario = new cformulario
formulario.carga_parametros "buscar_asignaturas_elec.xml", "form_busca_asig_2"
formulario.inicializar conexion
if asig_ccod_2="" and asig_tdesc ="" then
	asig_ccod_2 ="NADA"
	asig_tdesc ="NADA"
end if

'"edicion_secc_asig.asp?sede_ccod=%sede_ccod%&amp;asig_ccod=%asig_ccod%&amp;carr_ccod=%carr_ccod%&amp;periodo=%periodo%&amp;nive_ccod=%nive_ccod%&amp;plan_ccod=%plan_ccod%&amp;espe_ccod=%espe_ccod%" 

consulta = "select asig_ccod,asig_tdesc, "& vbCrlf & _
		   "'"&sede_ccod&"' as sede_ccod,'"&carr_ccod&"' as carr_ccod,'"&peri_ccod&"' as periodo, "& vbCrlf & _
		   "'"&nive_ccod&"' as nive_ccod,'"&plan_ccod&"','"&espe_ccod&"' from asignaturas "& vbCrlf & _
		  " where asig_ccod not in (select asig_ccod  from malla_curricular)"& vbCrlf & _	
		  " and (asig_ccod = '"&asig_ccod_2&"' or '"&asig_ccod_2&"' is null )"& vbCrlf & _
		  " and (asig_tdesc like '%"&asig_tdesc&"%' or '%"&asig_tdesc&"%' is null )"






formulario.consultar consulta
'response.Write("<pre>"&consulta&"</pre>")
ftitulo.carga_parametros "parametros.xml", "4tt"
ftitulo.inicializar conexion
consulta_titulo = "Select (select carr_tdesc from carreras where cast(carr_ccod as varchar)='" & carr_ccod & "') as carr_tdesc," & _
                  "       (select asig_ccod  from asignaturas where cast(asig_ccod as varchar)='" & asig_ccod & "') as asig_ccod, " & _
				  "		  (select asig_tdesc from asignaturas where cast(asig_ccod as varchar)='" & asig_ccod & "') as asig_tdesc " 

				   
ftitulo.consultar consulta_titulo

ftitulo.siguiente

sql_malla = "select mall_ccod " & _
			" from malla_curricular " & _
			" where cast(asig_ccod as varchar)  = '"&asig_ccod&"'  " & _
			" and cast(plan_ccod as varchar) ='"&plan_ccod&"' " & _
			" and cast(nive_ccod as varchar) ='"&nive_ccod&"' " 
			
mall_ccod = conexion.consultauno(sql_malla)			

sql_electivos = " select a.secc_ccod,cast(rtrim(ltrim(c.asig_ccod)) as varchar)+'-'+cast(c.asig_tdesc as varchar)+' seccion'+' '+cast(secc_tdesc as varchar) as asignatura, " & _
				" isnull(protic.retorna_horario(isnull(cast(b.secc_ccod as varchar),'')),'NO TIENE HORARIO') as hor, " & _
				" isnull(protic.retorna_profesor(isnull(cast(b.secc_ccod as varchar),'')),'NO TIENE PROFESOR') profesor " & _
				" from electivos a,secciones b,asignaturas c " & _
				" where a.secc_ccod = b.secc_ccod " & _
				" and b.asig_ccod = c.asig_ccod "  & _
				" and cast(a.mall_ccod as varchar) = '"&mall_ccod&"'" & _
				" and cast(a.asig_ccod as varchar) = '"&asig_ccod&"'"

set formulario_elec = new cformulario
formulario_elec.carga_parametros "buscar_asignaturas_elec.xml", "asig_electivas"
formulario_elec.inicializar conexion

formulario_elec.consultar sql_electivos
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
	method="post";
	formulario.target="_self";
	formulario.action = 'proc_electivos.asp';
	formulario.submit();

}
function buscar(formulario){

	formulario.target="_self";
	formulario.action = 'busca_asignaturas_elec_2.asp';
	formulario.submit();

}

function abrir() {
	direccion = "consultar_asignatura.asp";
	resultado=window.open(direccion, "ventana1","width=250,height=100,scrollbars=no, left=380, top=350");
	
 // window.close();
}
function salir(){
	url = "edicion_secc_asig.asp?sede_ccod="+'<%=sede_ccod%>'+"&asig_ccod="+'<%=asig_ccod%>'+"&carr_ccod="+'<%=carr_ccod%>'+"&periodo="+'<%=peri_ccod%>'+"&nive_ccod="+'<%=nive_ccod%>'+"&plan_ccod="+'<%=plan_ccod%>'+"&espe_ccod="+'<%=espe_ccod%>'
//alert(url)
	window.navigate(url)

//self.opener.location.reload()
//self.close();
}
</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">

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
			                  <input type="hidden" name="periodo" value="<%= peri_ccod%>">
                  <input type="hidden" name="asig_ccod" value="<%= asig_ccod%>">
                  <input type="hidden" name="carr_ccod" value="<%= carr_ccod%>">
				  <input type="hidden" name="sede_ccod" value="<%= sede_ccod%>">
				  <input type="hidden" name="nive_ccod" value="<%= nive_ccod%>">
  				  <input type="hidden" name="espe_ccod" value="<%= espe_ccod%>">
  				  <input type="hidden" name="plan_ccod" value="<%= plan_ccod%>">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="40%"><div align="center"><input type="text" name="asig_ccod_2" size="20" maxlength="20" onKeyDown="return bloquearTeclas(event.keyCode,this)" onKeyUp="this.value=this.value.toUpperCase()" ID="TO-S" value="<%=codigo%>">
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
            <td height="135"><form name="edicion" method="post">
			<input type="hidden" name="sede_ccod" value="<%= sede_ccod%>">
                  <input type="hidden" name="periodo" value="<%= peri_ccod%>">
                  <input type="hidden" name="asig_ccod" value="<%= asig_ccod%>">
                  <input type="hidden" name="carr_ccod" value="<%= carr_ccod%>">
				  <input type="hidden" name="sede_ccod" value="<%= sede_ccod%>">
				  <input type="hidden" name="nive_ccod" value="<%= nive_ccod%>">
  				  <input type="hidden" name="espe_ccod" value="<%= espe_ccod%>">
  				  <input type="hidden" name="plan_ccod" value="<%= plan_ccod%>">
				   <input type="hidden" name="mall_ccod" value="<%= mall_ccod%>">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>                        <div align="center"><%pagina.DibujarTituloPagina%> <br>
                    </div></td>
                    </tr>
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Lista De Asignaturas"%></td>
                  </tr>
                  <tr>
                    <td><div align="left"><strong>Para agregar secciones a una asignatura debe seleccionar una fila desde la lista presentada y esta asignatura  se agregara como un electivo m&aacute;s para <strong>
                      <% ftitulo.dibujaCampo("asig_ccod") %>
  -
  <% ftitulo.dibujaCampo("asig_tdesc") %>
                      </strong>del programa de estudio <strong>
                      <% ftitulo.dibujaCampo("carr_tdesc") %>
                      </strong></strong>
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
                  <td><div align="center"></div></td>
                  <td><div align="center"></div></td>
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
