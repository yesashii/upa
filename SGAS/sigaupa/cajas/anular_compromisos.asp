<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Anulacion de Compromisos"
'-----------------------------------------------------------------------

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


set errores = new CErrores


'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "anular_compromisos.xml", "botonera"
'-----------------------------------------------------------------------
 rut_alumno = request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito = request.querystring("busqueda[0][pers_xdv]")
 accion = request.querystring("accion")
 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "anular_compromisos.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut_alumno
 f_busqueda.AgregaCampoCons "pers_xdv", rut_alumno_digito
'--------------------------------------------------------------------
'--------------------------------------------------------------------
set f_compromiso = new CFormulario
f_compromiso.Carga_Parametros "anular_compromisos.xml", "f_compromisos"
f_compromiso.Inicializar conexion




v_pers_ncorr=conexion.ConsultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&rut_alumno&"'")

if isnull(v_pers_ncorr)	or EsVacio(v_pers_ncorr) or v_pers_ncorr="" then
	v_pers_ncorr=conexion.ConsultaUno("select pers_ncorr from personas_postulante where cast(pers_nrut as varchar)='"&rut_alumno&"'")
end if

consulta1= " Select *,protic.trunc(a.comp_fdocto) as fecha_compromiso,a.comp_ndocto as c_comp_ndocto, '' as motivo "& vbCrLf &_
		  " from compromisos a, detalle_compromisos b,estados_compromisos c, detalles d,tipos_detalle e " & vbCrLf &_
		  " where cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"'"& vbCrLf &_
		  " and a.tcom_ccod		= b.tcom_ccod "& vbCrLf &_
		  " and a.inst_ccod		= b.inst_ccod "& vbCrLf &_
		  " and a.comp_ndocto	= b.comp_ndocto "& vbCrLf &_
		  " and b.tcom_ccod		= d.tcom_ccod "& vbCrLf &_
		  " and b.inst_ccod		= d.inst_ccod "& vbCrLf &_
		  " and b.comp_ndocto	= d.comp_ndocto "& vbCrLf &_
	      " and d.tdet_ccod		= e.tdet_ccod "& vbCrLf &_
		  " and a.tcom_ccod		= e.tcom_ccod "& vbCrLf &_
		  " and a.tcom_ccod not in (1,2,3,7) "& vbCrLf &_
		  " And a.ecom_ccod		= c.ecom_ccod "& vbCrLf &_
		  " and a.ecom_ccod not in (2,3) "& vbCrLf &_
		  " and exists (select  1 "& vbCrLf &_
          "      from abonos ab, ingresos ig, detalle_ingresos di  "& vbCrLf &_
          "     where ab.comp_ndocto=b.comp_ndocto "& vbCrLf &_
          "     and ab.tcom_ccod=b.tcom_ccod "& vbCrLf &_
          "     and ab.inst_ccod=b.inst_ccod "& vbCrLf &_
          "     and ab.dcom_ncompromiso=b.dcom_ncompromiso "& vbCrLf &_
          "     and ab.ingr_ncorr=ig.ingr_ncorr "& vbCrLf &_
          "     and ig.ingr_ncorr=di.ingr_ncorr "& vbCrLf &_ 
          "     and ig.ting_ccod in (16) "& vbCrLf &_
          "     and ig.eing_ccod in (4) "& vbCrLf &_
          "     and di.ting_ccod=53 "& vbCrLf &_
          "     and ig.pers_ncorr='"&v_pers_ncorr&"'  ) "& vbCrLf &_
		  " and not exists (select 1 from abonos ab, ingresos ig  "& vbCrLf &_
          "       where ab.comp_ndocto=b.comp_ndocto "& vbCrLf &_
          "       and ab.tcom_ccod=b.tcom_ccod "& vbCrLf &_
          "       and ab.inst_ccod=b.inst_ccod "& vbCrLf &_
          "       and ab.dcom_ncompromiso=b.dcom_ncompromiso "& vbCrLf &_
          "       and ab.ingr_ncorr=ig.ingr_ncorr "& vbCrLf &_
          "       and ig.ting_ccod not in (30,16) "& vbCrLf &_
          "       and ig.eing_ccod not in (3,6) ) "


consulta2= " Select *,protic.trunc(a.comp_fdocto) as fecha_compromiso,a.comp_ndocto as c_comp_ndocto, '' as motivo "& vbCrLf &_
		  " from compromisos a, detalle_compromisos b,estados_compromisos c, detalles d,tipos_detalle e " & vbCrLf &_
		  " where cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"'"& vbCrLf &_
		  " and a.tcom_ccod		= b.tcom_ccod "& vbCrLf &_
		  " and a.inst_ccod		= b.inst_ccod "& vbCrLf &_
		  " and a.comp_ndocto	= b.comp_ndocto "& vbCrLf &_
		  " and b.tcom_ccod		= d.tcom_ccod "& vbCrLf &_
		  " and b.inst_ccod		= d.inst_ccod "& vbCrLf &_
		  " and b.comp_ndocto	= d.comp_ndocto "& vbCrLf &_
	      " and d.tdet_ccod		= e.tdet_ccod "& vbCrLf &_
		  " and a.tcom_ccod		= e.tcom_ccod "& vbCrLf &_
		  " and a.tcom_ccod not in (1,2,3,7) "& vbCrLf &_
		  " And a.ecom_ccod		= c.ecom_ccod "& vbCrLf &_
		  " and a.ecom_ccod not in (2,3) "& vbCrLf &_
		  " and not exists (select 1 from abonos ab, ingresos ig  "& vbCrLf &_
          "       where ab.comp_ndocto=b.comp_ndocto "& vbCrLf &_
          "       and ab.tcom_ccod=b.tcom_ccod "& vbCrLf &_
          "       and ab.inst_ccod=b.inst_ccod "& vbCrLf &_
          "       and ab.dcom_ncompromiso=b.dcom_ncompromiso "& vbCrLf &_
          "       and ab.ingr_ncorr=ig.ingr_ncorr "& vbCrLf &_
          "       and ig.ting_ccod not in (30) "& vbCrLf &_
          "       and ig.eing_ccod not in (3,6) ) "


 consulta= "Select *,protic.trunc(a.comp_fdocto) as fecha_compromiso,a.comp_ndocto as c_comp_ndocto, '' as motivo "& vbCrLf &_
			 " from compromisos a, detalle_compromisos b,estados_compromisos c, detalles d,tipos_detalle e "& vbCrLf &_
			 " where cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"' "& vbCrLf &_
			 " and a.tcom_ccod		= b.tcom_ccod  "& vbCrLf &_
			 " and a.inst_ccod		= b.inst_ccod  "& vbCrLf &_
			 " and a.comp_ndocto	    = b.comp_ndocto  "& vbCrLf &_
			 " and b.tcom_ccod		= d.tcom_ccod  "& vbCrLf &_
			 " and b.inst_ccod		= d.inst_ccod  "& vbCrLf &_
			 " and b.comp_ndocto	    = d.comp_ndocto  "& vbCrLf &_
			 " and d.tdet_ccod		= e.tdet_ccod  "& vbCrLf &_
			 " and a.tcom_ccod		= e.tcom_ccod  "& vbCrLf &_
			 " and a.tcom_ccod not in (1,2,3,7)  "& vbCrLf &_
			 " And a.ecom_ccod		= c.ecom_ccod  "& vbCrLf &_
			 " and a.ecom_ccod not in (2,3)  "& vbCrLf &_
			 " and not exists (select ab.comp_ndocto from abonos ab, ingresos ig   "& vbCrLf &_
			 "          where ab.comp_ndocto=b.comp_ndocto  "& vbCrLf &_
			 "          and ab.tcom_ccod=b.tcom_ccod  "& vbCrLf &_
			 "          and ab.inst_ccod=b.inst_ccod  "& vbCrLf &_
			 "          and ab.dcom_ncompromiso=b.dcom_ncompromiso "& vbCrLf &_ 
			 "          and ab.ingr_ncorr=ig.ingr_ncorr  "& vbCrLf &_
			 "          and ig.ting_ccod not in (30)  "& vbCrLf &_
			 "          and ig.eing_ccod not in (3,6) "& vbCrLf &_
			 "          and ig.pers_ncorr='"&v_pers_ncorr&"' "& vbCrLf &_
			 "      union "& vbCrLf &_
			 "          select  ab.comp_ndocto  "& vbCrLf &_
			 "          from abonos ab, ingresos ig, detalle_ingresos di   "& vbCrLf &_
			 "              where ab.comp_ndocto=b.tcom_ccod "& vbCrLf &_
			 "              and ab.tcom_ccod=b.tcom_ccod  "& vbCrLf &_
			 "              and ab.inst_ccod=b.inst_ccod  "& vbCrLf &_
			 "              and ab.dcom_ncompromiso=b.dcom_ncompromiso "& vbCrLf &_
			 "              and ab.ingr_ncorr=ig.ingr_ncorr "& vbCrLf &_
			 "              and ig.ingr_ncorr=di.ingr_ncorr  "& vbCrLf &_
			 "              and ig.ting_ccod not in (16)  "& vbCrLf &_
			 "              and ig.eing_ccod in (4) "& vbCrLf &_
			 "              and di.ting_ccod=53 "& vbCrLf &_
			 "              and ig.pers_ncorr='"&v_pers_ncorr&"' "& vbCrLf &_
			 "      ) "


		  
'and protic.total_abonado_cuota(b.tcom_ccod,b.inst_ccod,b.comp_ndocto,b.dcom_ncompromiso)+protic.total_abono_documentado_cuota(b.tcom_ccod,b.inst_ccod,b.comp_ndocto,b.dcom_ncompromiso)=0			

'response.Write("<pre>"&consulta&"</pre>")		
'if Request.QueryString <> "" then
if not Esvacio(Request.QueryString) then
		'response.Write("entre")
 	  f_compromiso.Consultar consulta

 else
 	'response.Write("entre2")
	 f_compromiso.Consultar "select '' where 1=2"
	 'f_compromiso2.Consultar "select '' "
	 f_compromiso.AgregaParam "mensajeError", "Ingrese criterio de busqueda"

 end if


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

function Anular(){
formulario = document.edicion;
mensaje="Anular";
	if (verifica_check(formulario,mensaje)){
			return true;
	}
}
function Validar()
{
	formulario = document.buscador;
	
	rut_alumno = formulario.elements["busqueda[0][pers_nrut]"].value + "-" + formulario.elements["busqueda[0][pers_xdv]"].value;	
	if (formulario.elements["busqueda[0][pers_nrut]"].value  != '')
  	  if (!valida_rut(rut_alumno)) {
		alert('Ingrese un RUT válido.');
		formulario.elements["busqueda[0][pers_xdv]"].focus();
		formulario.elements["busqueda[0][pers_xdv]"].select();
		return false;
	  }
		
	return true;
}

function apaga_motivo(){
   nro = document.edicion.elements.length;
   num =0;
   for( i = 0; i < nro; i++ ) {
	  comp = document.edicion.elements[i];
	  str  = document.edicion.elements[i].name;
	  if(comp.type == 'checkbox'){
		    v_indice=extrae_indice(str);
			document.edicion.elements["compromisos["+v_indice+"][motivo]"].value='seleccione compromiso';
		 	document.edicion.elements["compromisos["+v_indice+"][motivo]"].disabled=true;
	  }
   }
}

function seleccionar(objeto){
//alert(objeto.name);
str=objeto.name
v_indice=extrae_indice(str);
v_estado=document.edicion.elements["compromisos["+v_indice+"][motivo]"].disabled;
//alert(v_estado);
	if (!v_estado){
		document.edicion.elements["compromisos["+v_indice+"][motivo]"].value='seleccione compromiso';
		document.edicion.elements["compromisos["+v_indice+"][motivo]"].disabled=true;
	}else{
		document.edicion.elements["compromisos["+v_indice+"][motivo]"].value='';
		document.edicion.elements["compromisos["+v_indice+"][motivo]"].disabled=false;
	}
}

</script>



</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="apaga_motivo();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td><table border="0" cellpadding="0" cellspacing="0" width="100%">
            <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
            <tr>
              <td width="9"><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
              <td><img src="../imagenes/spacer.gif" width="100%" height="1" border="0" alt=""></td>
              <td width="7"><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
            <tr>
              <td width="9"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="100%" height="8" border="0" alt=""></td>
              <td width="7"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
            <tr>
              <td width="9"><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
              <td><%pagina.DibujarLenguetas Array("Búsqueda de contratos para activar"), 1 %></td>
              <td width="7"><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>              
            </tr>
            <tr>
              <td width="9"><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
              <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="100%" height="2" border="0" alt=""></td>
              <td width="7"><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
          </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE"><div align="center">
				<form name="buscador">
                  <table width="98%"  border="0">
                    <tr>
                      <td width="81%"><div align="center">
                        <table width="50%"  border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td width="37%">R.U.T. Alumno : </td>
                                  <td width="57%"> 
                                    <% f_busqueda.DibujaCampo ("pers_nrut") %>
                                    - <% f_busqueda.DibujaCampo ("pers_xdv") %>
									<a href="javascript:buscar_persona('busqueda[0][pers_nrut]', 'busqueda[0][pers_xdv]');"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a>
									</td>
                          </tr>
                        </table>
                      </div></td>
                      <td width="19%"><div align="center"><% botonera.DibujaBoton ("buscar") %></div></td>
                    </tr>
                  </table>
				</form>
                </div>
 <br>
<%if v_pers_ncorr <> "" then 
sql_morosidad="select isnull(pers_bmorosidad,'S') from personas where pers_ncorr="&v_pers_ncorr
v_considera=conexion.ConsultaUno(sql_morosidad)
if v_considera="N" then
	check_no="checked"
else
	check_si="checked"
end if
%>
	<form method="post" action="proc_considera_morosidad.asp">
	<input type="hidden" name="pers_ncorr" value="<%=v_pers_ncorr%>" > 
		Considerar Morosidad ? 
		<input type="radio" name="pers_bmorosidad" value="S" <%=check_si%> > Sí
		<input type="radio" name="pers_bmorosidad" value="N" <%=check_no%>> No
		<input type="submit" value="Guardar">
	</form>
<%end if%>
</td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="100%" height="13"></td>
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
                <td><img src="../imagenes/spacer.gif" width="100%" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td width="9"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="100%" height="8" border="0" alt=""></td>
              <td width="7"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>			  
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td bgcolor="#D8D8DE">
				<%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %>				
				</td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="100%" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>			 
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
&nbsp;<div align="center"><%pagina.DibujarTituloPagina%></div>
					<form name="edicion">
					<%pagina.DibujarSubtitulo "Compromisos"%><br>
					<div align="right">P&aacute;ginas: &nbsp; <%f_compromiso.AccesoPagina%> </div>
					<div align="center"><% f_compromiso.DibujaTabla() %></div>
                  </form>
				</td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="198" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="20%">&nbsp; </td>
                      <td width="20%"> <div align="left"> 
                          <%
					   'if estado = "1" or estado = "" then
					   if	f_compromiso.NroFilas = 0 then
							   botonera.agregabotonparam "anular", "deshabilitado" ,"TRUE"			   
					   end if
					    botonera.DibujaBoton ("anular")
					   %>
                        </div></td>
                      <td width="31%"> <div align="left"> 
                          
                        </div></td>
                      <td width="49%"> <div align="left"> 
                          <%botonera.DibujaBoton ("salir")%>
                        </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="157" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="311" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
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
