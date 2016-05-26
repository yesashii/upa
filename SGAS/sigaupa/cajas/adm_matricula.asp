<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
set botonera = new CFormulario
botonera.carga_parametros "ariel.xml", "btn_adm_matricula"

'----------------------------------------------------------------------------------------------------------------------
set conectar    = new cconexion
set fContrato   = new cformulario
set fnegocio     = new cnegocio
set errores 	= new cErrores
set persona	= new cFormulario
'----------------------------------------------------------------------------------------------------------------------
conectar.inicializar "desauas"
'----------------------------------------------------------------------------------------------------------------------
fnegocio.inicializa conectar
'----------------------------------------------------------------------------------------------------------------------
fContrato.carga_parametros "ariel.xml", "fContrato_matricula"
fContrato.inicializar conectar

'----------------------------------------------------------------------------------------------------------------------
sede_ccod       = fnegocio.obtenersede
peri_ccod       = fnegocio.obtenerPeriodoAcademico("postulacion")
contrato        = request.QueryString("contrato") : if (contrato = "") then contrato=0
rut				= request.QueryString("rut")
dv				= request.QueryString("dv")

'----------------------------------------------------------------------------------------------------------------------
persona.carga_parametros "paulo.xml","persona"
persona.inicializar conectar

personas = "select " & _
        "pers_ncorr as c, pers_nrut || '-' || pers_xdv  as rut " & _
		" , pers_tape_paterno || ' ' ||   PERS_TAPE_MATERNO || ' ' || pers_tnombre as nombre  " & _
	   " from personas" & _
	   " where pers_nrut='" & rut & "' " & _
       " and pers_xdv='" & dv & "'  "
persona.consultar personas	   
persona.siguiente

texto = ""

'----------------------------------------------------------------------------------------------------------------------
if rut <> "" then		
	sql_contrato	=	"select " & vbcrlf &_
						"		  a.*,b.paga_npagare,a.cont_ncorr as cont_ncorr_mostrar " & vbcrlf &_
						"	from  " & vbcrlf &_
						"		 contratos a, " & vbcrlf &_
						"		 pagares b, " & vbcrlf &_
						"		 postulantes c, " & vbcrlf &_
						"		 personas d " & vbcrlf &_
						"	where " & vbcrlf &_
						"		 a.paga_ncorr=b.paga_ncorr " & vbcrlf &_
						"		 and a.post_ncorr =c.post_ncorr " & vbcrlf &_
						"		 and c.pers_ncorr=d.pers_ncorr " & vbcrlf &_
						"		 and pers_nrut ='"& rut &"' " & vbcrlf &_
						"		 and econ_ccod = 2 -- Pendientes" & vbcrlf &_
						"	order by a.cont_fcontrato desc"
else	
	sql_contrato    = " select a.*,b.paga_npagare,a.cont_ncorr as cont_ncorr_mostrar " & _
    	              " from contratos a,pagares b " & _
        	          " where a.paga_ncorr=b.paga_ncorr " & _
					  "		 and econ_ccod = 2 -- Pendientes" & vbcrlf &_
					  " and   cont_ncorr=" & contrato 
end if

fContrato.consultar sql_contrato
'fContrato.siguiente

set errores = new CErrores				  
'----------------------------------------------------------------------------------------------------------------------

usuario 	= fnegocio.obtenerusuario

tipo_usuario	= conectar.consultauno("select COUNT(*) from funcionarios where pers_ncorr=(select pers_ncorr from personas where pers_nrut='"& usuario &"') and tfun_ccod=12")

%>


<html>
<head>
<title>Aplicar Contrato para Matricula</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
<!--

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function conmutames()
{
var condicion = MM_findObj ("csec[0][stpa_ccod]");
var mes       = MM_findObj ("csec[0][srde_ccod]");
   if (condicion.value > 1)
      {mes.disabled = true;}
   else
      {mes.disabled = false;}	  
  }	  

function eliminar()
{
 document.descuentos.action="eliminar_descuentos.asp";
 document.submit();
}
function agregar()
{
var post_ncorr_a = MM_findObj("csec[0][post_ncorr]");
var ofer_ncorr_a = MM_findObj("csec[0][ofer_ncorr]");
 direccion="edicion_descuentos.asp?post_ncorr_a="+post_ncorr_a.value+"&ofer_ncorr_a="+ofer_ncorr_a.value;
 resultado=window.open(direccion, "ventana1","width=500,height=350,scrollbars=no, left=0, top=0");
}

function enviar(f)
{
	if(preValidaFormulario(f)){
		f.action="proc_matricula.asp";
		f.submit();
	}
}



function imprimir_contrato(f)
{
f.action="imprime_contrato.asp";
f.submit();
}

function imprimir_pagare(f)
{
f.action="imprime_pagare.asp";
f.submit();
}

function generar_contrato(f)
{
f.action="proc_contrato.asp";
f.submit();
}

function busqueda(formulario){
		if (formulario.rut.value !='' && formulario.dv.value !=''){
			if(!(valida_rut(formulario.rut.value + '-' + formulario.dv.value))){
				alert('El RUT que Ud. ha ingresado no es válido.Por favor, ingréselo nuevamente.');
				formulario.rut.focus();
				formulario.rut.select();
			 }
			 else{
				formulario.action='adm_matricula.asp';
				formulario.submit();
			}
		}
		else{
			formulario.action='adm_matricula.asp';
			formulario.submit();
		}
}
//-->
</script>
</head>
<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
            <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
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
                    <td width="6" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="167" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="center"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador de Alumnos </font></div></td>
                    <td width="10" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="491" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
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
				<form name="buscar" method="get" action="">
                  <table width="98%"  border="0">
                    <tr>
                      <td width="81%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr> 
                                  <td width="60%" nowrap> <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                     <br> <input type="text" name="rut" size="10" maxlength="8" id="NU-N" value="<%=rut%>">
                                      - 
                                      <input type="text" name="dv" size="2" maxlength="1" id="LE-N" 			onKeyUp="this.value=this.value.toUpperCase();" value="<%=dv%>">
                                      <br>
                                      <strong>Rut</strong> </font></div></td>
                                  <td width="40%"> <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> 
                                     <br> <input type="text" name="contrato" size="12" maxlength="12">
                                      <br>
                                      <strong>Numero de Contrato Interno</strong> 
                                      </font></div></td>
                                </tr>
                              </table></td>
                      <td width="19%"><div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif">
                        <%botonera.dibujaboton "buscar"%>
                      </font></div></td>
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Aplicar
                          Contrato para Matricula</font></div></td>
                      <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
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
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  <td bgcolor="#D8D8DE">
				    &nbsp;
                    <%if rut <>"" and dv <> "" then %>
                    <table width="50%" cellspacing="0" cellpadding="0">
                      <tr>
                        <td>Resultado de la B&uacute;squeda</td>
                      </tr>
                      <tr>
                        <td nowrap><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Rut: <strong><%=persona.dibujaCampo("rut")%></strong> Nombre:<strong> <%=persona.dibujaCampo("nombre")%></strong></font></td>
                      </tr>
                      <tr>
                                        </table>
                    <%else
					  response.Write(texto)
					  end if%>
<form name="pcontrato" method="post" action=""><input type="hidden" name="peri_ccod" value="<%=peri_ccod%>">
                            <table width="98%" border="0" cellpadding="0" cellspacing="0">
                              <tr> 
                                <td height="13" align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif"><strong>LISTADO 
                                  DE CONTRATOS</strong></font></td>
                              </tr>
                              <tr> 
                                <td align="right"><strong>P&aacute;ginas: </strong><%fContrato.accesoPagina()%></td>
                              </tr>
                              <tr> 
                                <td align="center"> 
                                  <% fContrato.dibujaTabla %>
                                </td>
                              </tr>
                              <tr>
                                <td align="right">&nbsp;</td>
                              </tr>
                              <tr> 
                                <td align="right"><font size="1" face="Verdana, Arial, Helvetica, sans-serif">
                                  <%botonera.dibujaboton "actualizar"%>
                                &nbsp;</font> 
                                </td>
                              </tr>
                            </table>
                  </form>				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="110" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><div align="center">
					  <%if tipo_funcionario > 0 then 
                        botonera.dibujaboton "salir"
					  else
					   botonera.dibujaboton "salir2"
					   end if%>
					
                      </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="252" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="315" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
			<p><br>
			<p><br>
			<p><br>
		  </td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
