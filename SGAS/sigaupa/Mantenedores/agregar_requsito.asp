<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
nive_ccod = request.QueryString("nive_ccod")
plan_ccod=request.QueryString("plan")
espe_ccod=request.QueryString("esp")
carr_ccod=request.QueryString("carr_ccod")
mall_ccod=request.QueryString("mall_ccod")

set pagina = new CPagina
pagina.Titulo = "Actualizar Malla Curircular"
set botonera =  new CFormulario
botonera.carga_parametros "agregar_requisito.xml", "btn_agrega_requisito"
'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

'---------------------------------------------------------------------------------------------------
set framos     = new cformulario
framos.carga_parametros "agregar_requisito.xml", "agregar"
framos.inicializar conectar
consulta_ramos=" select  b.nive_ccod as nive_ccod, b.nive_ccod as nive_ccod_2, b.mall_ccod,b.plan_ccod as plan_ccod, " & _
        	   " c.espe_ccod as espe_ccod ,a.asig_ccod as asig_ccod, " & _
		       " a.asig_tdesc as asig_tdesc ,a.asig_nhoras as asig_nhoras , 0 as treq_ccod" & _
               " from asignaturas a , malla_curricular b , planes_estudio c " & _
               " where a.asig_ccod = b.asig_ccod" & _
               " and b.plan_ccod=c.plan_ccod" & _
               " and b.plan_ccod = '"&plan_ccod&"'" & _ 
               " and c.espe_ccod = '"&espe_ccod&"' " & _
               " and b.NIVE_CCOD <'"&nive_ccod&"'" & _
			   " order by nive_ccod"

'response.Write(consulta_ramos)			   

framos.consultar consulta_ramos
'framos.siguiente

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
function agrega_req(formulario){
	  formulario.method="post";
	  formulario.action="actualizar_requisitos.asp";
	  formulario.submit();
}
function cerrar() {
	self.opener.location.reload()
	self.close();
}

</script>

</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../__base/im&#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../__base/im&#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../__base/im&#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../__base/im&#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">	  <br>
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
            <td><%pagina.DibujarLenguetas Array("Actualizar Malla Curricular"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><br><%pagina.DibujarSubtitulo "Agregar Requisitos"%>
              <form name="editar" method="post">
                <table width="70%" border="0" align="center">
                  <tr>
                    <td><div align="center">
                      <%framos.dibujatabla%>
                    </div></td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
                </table>
                <br>

		              <input name="nive_ccod" type="hidden" value="<%=nive_ccod%>">
              <input name="plan_ccod" type="hidden" value="<%=plan_ccod%>">
              <input name="carr_ccod" type="hidden" value="<%=carr_ccod%>">
              <input name="espe_ccod" type="hidden" value="<%=espe_ccod%>">
              <input name="mall_ccod" type="hidden" value="<%=mall_ccod%>">
			  <input name="v_usuario" type="hidden" value="<%=negocio.ObtenerUsuario%>">

  
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
					<%
						if nive_ccod <> 1 then
                  			response.Write("<td><div align=center>")
				  			botonera.dibujaboton "agregar"
                            response.Write("</div></td>")
						end if
				  	%>
                  <td><div align="center"> </div></td>
                  <td><div align="center"></div></td>
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
