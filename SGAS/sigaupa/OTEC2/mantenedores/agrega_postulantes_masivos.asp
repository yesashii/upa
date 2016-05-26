<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
dgso_ncorr= request.QueryString("dgso_ncorr")
fpot_ccod= request.QueryString("fpot_ccod")
nord_compra= request.QueryString("nord_compra")
rut_empresa= request.QueryString("rut_empresa")
rut_otic= request.QueryString("rut_otic")
q_pers_nrut = Request.QueryString("m[0][pers_nrut]")
q_pers_xdv = Request.QueryString("m[0][pers_xdv]")

set pagina = new CPagina
pagina.Titulo = "Alumnos postulación masiva"

set botonera =  new CFormulario
botonera.carga_parametros "postulacion_masiva_otec.xml", "botonera_edita_alumnos"
'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

programa = conexion.consultaUno("select dcur_tdesc from datos_generales_secciones_otec a, diplomados_cursos b where a.dcur_ncorr=b.dcur_ncorr and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")
sede = conexion.consultaUno("select sede_tdesc from datos_generales_secciones_otec a, sedes b where a.sede_ccod=b.sede_ccod and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"'")
empresa = conexion.consultaUno("select empr_tnombre from empresas where cast(empr_nrut as varchar)='"&rut_empresa&"'")
empr_ncorr = conexion.consultaUno("select empr_ncorr from empresas where cast(empr_nrut as varchar)='"&rut_empresa&"'")
otic = conexion.consultaUno("select empr_tnombre from empresas where cast(empr_nrut as varchar)='"&rut_otic&"'")
total_maximo = conexion.consultaUno("select isnull((select top 1 ocot_nalumnos from ordenes_compras_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and cast(nord_compra as varchar)='"&nord_compra&"'),0)")
ya_ingresados = conexion.consultaUno("select count(*) from postulacion_otec where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and isnull(cast(norc_empresa as varchar),cast(norc_otic as varchar))='"&nord_compra&"'")

resultado = cdbl(total_maximo) - cdbl(ya_ingresados)
'response.Write(resultado)

rut_grabado = conexion.consultaUno("select count(*) from postulacion_otec a, personas b where cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and isnull(cast(norc_empresa as varchar),cast(norc_otic as varchar))='"&nord_compra&"' and a.pers_ncorr=b.pers_ncorr and cast(b.pers_nrut as varchar)='"&q_pers_nrut&"'")

mensaje_bloqueo = ""
if resultado=0 and rut_grabado="0" then
	mensaje_bloqueo = "Imposible agregar más postulantes a la orden de compra, ya cumplió con el número de postulantes declarado"
end if
'response.Write(mensaje_bloqueo)
'---------------------------------------------------------------------------------------------------
set datos_postulante = new cformulario
datos_postulante.carga_parametros "postulacion_masiva_otec.xml", "datos_postulante"
datos_postulante.inicializar conexion


consulta= "  select a.pers_ncorr,cast(a.pers_nrut as varchar) + '-' + a.pers_xdv as codigo_rut,a.pers_nrut,a.pers_xdv,a.pers_tnombre,a.pers_tape_paterno,a.pers_tape_materno, " & vbCrlf & _
		  "  protic.trunc(pers_fnacimiento) as pers_fnacimiento, nied_ccod, " & vbCrlf & _
		  "  pers_tprofesion, b.dire_tcalle,b.dire_tnro,b.dire_tpoblacion,b.dire_tblock,b.ciud_ccod, " & vbCrlf & _
		  "  a.pers_tfono,a.pers_tcelular,a.pers_temail, isnull(utiliza_sence,0) as utiliza_sence, fpot_ccod, pers_tempresa,pers_tcargo  "&vbCrlf&_
		  "  from personas a join  direcciones b " & vbCrlf & _
		  "     on  a.pers_ncorr=b.pers_ncorr " & vbCrlf & _
		  "  left outer join postulacion_otec c " & vbCrlf & _
		  "     on a.pers_ncorr = c.pers_ncorr and '"&dgso_ncorr&"' = cast(c.dgso_ncorr as varchar) " & vbCrlf & _
		  "  where cast(pers_nrut as varchar)='"&q_pers_nrut&"' " & vbCrlf & _
		  "  and  b.tdir_ccod=1 "

fue_grabado = conexion.consultaUno("select count(*) from ("&consulta&")aa")
esta_en_personas = conexion.consultaUno("select count(*) from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")		  
'response.Write("<pre>select count(*) from ("&consulta&")aa</pre>") 
if (esta_en_personas ="0" and q_pers_nrut <> "" and fue_grabado="0") or q_pers_nrut="" then
    'response.Write("entre acá")
	consulta = "select '"&q_pers_nrut&"' as pers_nrut,'"&q_pers_xdv&"' as pers_xdv, '"&q_pers_nrut&"' + '-' + '"&q_pers_xdv&"' as codigo_rut"
elseif esta_en_personas <> "0" and q_pers_nrut <> "" and fue_grabado="0" then
	consulta= "  select a.pers_ncorr,cast(a.pers_nrut as varchar) + '-' + a.pers_xdv as codigo_rut,a.pers_nrut,a.pers_xdv,a.pers_tnombre,a.pers_tape_paterno,a.pers_tape_materno, " & vbCrlf & _
			  "  protic.trunc(pers_fnacimiento) as pers_fnacimiento, " & vbCrlf & _
			  "  pers_tprofesion, b.dire_tcalle,b.dire_tnro,b.dire_tpoblacion,b.dire_tblock,b.ciud_ccod, " & vbCrlf & _
			  "  a.pers_tfono,a.pers_tcelular,a.pers_temail  " & vbCrlf & _
			  "  from personas a left outer join  direcciones b " & vbCrlf & _
			  "     on  a.pers_ncorr=b.pers_ncorr and 1 =  tdir_ccod " & vbCrlf & _
			  "  where cast(pers_nrut as varchar)='"&q_pers_nrut&"' " 

end if

'response.write("<pre>"&consulta&"</pre>")
datos_postulante.consultar consulta 
datos_postulante.siguiente

if q_pers_nrut <> "" then
	datos_postulante.agregaCampoParam "pers_tape_paterno","id","TO-N"
	datos_postulante.agregaCampoParam "pers_tape_materno","id","TO-N"
	datos_postulante.agregaCampoParam "pers_tnombre","id","TO-N"
	datos_postulante.agregaCampoParam "pers_fnacimiento","id","FE-N"
	datos_postulante.agregaCampoParam "nied_ccod","id","TO-N"
	datos_postulante.agregaCampoParam "pers_tprofesion","id","TO-N"
	datos_postulante.agregaCampoParam "dire_tcalle","id","TO-N"
	datos_postulante.agregaCampoParam "dire_tnumero","id","TO-N"
	datos_postulante.agregaCampoParam "ciud_ccod","id","TO-N"
	datos_postulante.agregaCampoParam "pers_temail","id","TO-N"
	datos_postulante.agregaCampoParam "pers_tempresa","id","TO-N"
	datos_postulante.agregaCampoParam "pers_tcargo","id","TO-N"
end if


set formulario_alumnos = new cformulario
formulario_alumnos.carga_parametros "postulacion_masiva_otec.xml", "f_alumnos_incorporados"
formulario_alumnos.inicializar conexion


consulta = " select a.pote_ncorr, cast(b.pers_nrut as varchar)+'-'+b.pers_xdv as rut, pers_tape_paterno + ' ' + pers_tape_materno + ', '+ pers_tnombre as nombre, '<a href=""javascript:direccionar_postulante('+ cast(b.pers_nrut as varchar) + ',' + b.pers_xdv + ')"">'+ 'Editar' + '</a>' as accion " & vbCrlf & _
           " from postulacion_otec a, personas b " & vbCrlf & _ 
           " where a.pers_ncorr=b.pers_ncorr and cast(dgso_ncorr as varchar)='"&dgso_ncorr&"' and isnull(cast(norc_empresa as varchar),cast(norc_otic as varchar))='"&nord_compra&"'  order by nombre"

'and empr_ncorr_empresa="&empr_ncorr&"
'response.write("<pre>"&empr_ncorr&"</pre>")
formulario_alumnos.consultar consulta 




lenguetas_masignaturas = Array(Array("Agregar alumno a postulación masiva", "#"))
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
function guardar(formulario){

if(preValidaFormulario(formulario))
    {	
    	formulario.action ='actualizar_modulos.asp';
		formulario.submit();
	}
	
}
function volver(){
	CerrarActualizar();
}

function validaCambios(){
	alert("..");
	return false;
}

function genera_digito (rut){
 var IgStringVerificador, IgN, IgSuma, IgDigito, IgDigitoVerificador, rut;
 var texto_rut = new String(rut);//rut de la otic
 var posicion_guion = 0;
		 posicion_guion = texto_rut.indexOf("-");
		 if (posicion_guion != -1)
		 {
			texto_rut = texto_rut.substring(0,posicion_guion);
			document.edicion.elements["m[0][pers_nrut]"].value= texto_rut;
			rut = texto_rut;
		 }
		// texto_rut.
		 //alert(texto_rut);
		   if (rut.length==7) rut = '0' + rut; 
		
		   
		   IgStringVerificador = '32765432';
		   IgSuma = 0;
		   for( IgN = 0; IgN < 8 && IgN < rut.length; IgN++)
			  IgSuma = eval(IgSuma + '+' + rut.substr(IgN, 1) + '*' + IgStringVerificador.substr(IgN, 1) + ';');
		   IgDigito = 11 - IgSuma % 11;
		   IgDigitoVerificador = IgDigito==10?'K':IgDigito==11?'0':IgDigito;
		   //alert(IgDigitoVerificador);
		   document.edicion.elements["m[0][pers_xdv]"].value=IgDigitoVerificador;
		//alert(rut+IgDigitoVerificador);
		_Buscar(this, document.forms['edicion'],'', 'ValidaRut33();', 'FALSE');
}

function ValidaRut33()
{
	rut = document.edicion.elements["m[0][pers_nrut]"].value + '-' + document.edicion.elements["m[0][pers_xdv]"].value;

	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido.');		
		document.edicion.elements["m[0][pers_xdv]"].objeto.select();
		return false;
	}
	
	return true;	
}
function direccionar_postulante(rut,dv)
{
 var dgso_ncorr = '<%=dgso_ncorr%>';//request.QueryString("dgso_ncorr")
     fpot_ccod  = '<%=fpot_ccod%>';//request.QueryString("fpot_ccod")
     nord_compra= '<%=nord_compra%>';//request.QueryString("nord_compra")
     rut_empresa= '<%=rut_empresa%>';//request.QueryString("rut_empresa")
     rut_otic   = '<%=rut_otic%>';//request.QueryString("rut_otic")
     //q_pers_nrut = Request.QueryString("m[0][pers_nrut]")
     //q_pers_xdv = Request.QueryString("m[0][pers_xdv]")
	 ruta = "agrega_postulantes_masivos.asp?dgso_ncorr="+dgso_ncorr+"&fpot_ccod="+fpot_ccod+"&nord_compra="+nord_compra+"&rut_empresa="+rut_empresa+"&rut_otic="+rut_otic+"&m[0][pers_nrut]="+rut+"&m[0][pers_xdv]="+dv;
	 
	 location.href=ruta;
	 
	 //alert(ruta);

}
</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="580" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas lenguetas_masignaturas, 1%> </td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
             
                  <table width="100%"  border="0">
                      <tr> 
                        <td width="25%"><strong>Programa</strong></td>
                        <td width="75%">:<%=programa%></td>
                      </tr>
                      <tr> 
                        <td width="25%"><strong>Sede</strong></td>
                        <td width="75%">:<%=sede%></td>
                      </tr>
                      <tr> 
                        <td width="25%"><strong>Orden de Compra</strong></td>
                        <td width="75%">:<%=nord_compra%></td>
                      </tr>
                      <tr> 
                        <td width="25%"><strong>Empresa</strong></td>
                        <td width="75%">:<%=empresa%></td>
                      </tr>
                      <%if fpot_ccod = "4" then%>
                      <tr> 
                        <td width="25%"><strong>Otic</strong></td>
                        <td width="75%">:<%=otic%></td>
                      </tr>
                      <%end if%>
                      <tr> 
                        <td width="25%"><strong>Registrados</strong></td>
                        <td width="75%">:<%=ya_ingresados%> de <%=total_maximo%> considerados en la orden de compra</td>
                      </tr>
                      <tr>
                        <td colspan="2">&nbsp;</td>
                      </tr>
                      <form name="edicion" method="post">
                        <input type="hidden" name="dgso_ncorr" value="<%=dgso_ncorr%>">
                        <input type="hidden" name="fpot_ccod" value="<%=fpot_ccod%>">
                        <input type="hidden" name="nord_compra" value="<%=nord_compra%>">
                        <input type="hidden" name="rut_empresa" value="<%=rut_empresa%>">
                        <input type="hidden" name="rut_otic" value="<%=rut_otic%>">
                       <tr>
                        <td colspan="2">
                          <table width="100%" cellpadding="0" cellspacing="0" >
                           
                               <tr>
                                  <td width="10%"><strong>Rut</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_postulante.dibujaCampo("pers_nrut")%>-
                                      <%datos_postulante.dibujaCampo("pers_xdv")%></td>
                                  <td width="10%" align="right"><strong>Nombre</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_postulante.dibujaCampo("pers_tnombre")%></td>
                                </tr>
                                <tr>
                                  <td width="10%"><strong>A.Paterno</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_postulante.dibujaCampo("pers_tape_paterno")%></td>
                                  <td width="10%" align="right"><strong>A.Materno</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_postulante.dibujaCampo("pers_tape_materno")%></td>
                                </tr>
                                <tr>
                                  <td width="10%"><strong>F.Nacimiento</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_postulante.dibujaCampo("pers_fnacimiento")%></td>
                                  <td width="10%" align="right"><strong>Profesión</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_postulante.dibujaCampo("pers_tprofesion")%></td>
                                </tr>
                                <tr>
                                  <td width="10%"><strong>Nivel Edu.</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td colspan="4"><%datos_postulante.dibujaCampo("nied_ccod")%></td>
                                </tr>
                                <tr>
                                  <td width="10%"><strong>Dirección</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_postulante.dibujaCampo("dire_tcalle")%></td>
                                  <td width="10%" align="right"><strong>Número</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_postulante.dibujaCampo("dire_tnro")%></td>
                                </tr>
                                <tr>
                                  <td width="10%"><strong>Población</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_postulante.dibujaCampo("dire_tpoblacion")%></td>
                                  <td width="10%" align="right"><strong>Depto</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_postulante.dibujaCampo("dire_tblock")%></td>
                                </tr>
                                <tr>
                                  <td width="10%"><strong>Comuna</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_postulante.dibujaCampo("ciud_ccod")%></td>
                                  <td width="10%" align="right"><strong>E-mail</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_postulante.dibujaCampo("pers_temail")%></td>
                                </tr>
                                <tr>
                                  <td width="10%"><strong>Fono</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_postulante.dibujaCampo("pers_tfono")%></td>
                                  <td width="10%" align="right"><strong>Celular</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_postulante.dibujaCampo("pers_tcelular")%></td>
                                </tr>
                                <tr>
                                  <td width="10%"><strong>Empresa</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_postulante.dibujaCampo("pers_tempresa")%></td>
                                  <td width="10%" align="right"><strong>Cargo</strong></td>
                                  <td width="1%"><strong>:</strong></td>
                                  <td width="39%"><%datos_postulante.dibujaCampo("pers_tcargo")%></td>
                                </tr>
                                <%if mensaje_bloqueo= "" then%>
                                <tr>
                                  <td colspan="6" align="right"><%botonera.dibujaboton "guardar_persona"%></td>
                                </tr>
                                <%else%>
                                <tr>
                                  <td colspan="6" align="right">&nbsp;</td>
                                </tr>
                                <tr>
                                  <td colspan="6" align="center" bgcolor="#993300"><font color="#FFFFFF"><%=mensaje_bloqueo%></font></td>
                                </tr>
                                <%end if%>
                          </table>
                        </td>
                      </tr>
                      </form>
                      <tr>
                        <td colspan="2"><%pagina.DibujarSubtitulo "Postulantes Incorporados"%></td>
                      </tr>
                      <form name="edicion_listado" method="post">
                          <tr>
                           <td colspan="2"><div align="right"><strong>P&aacute;ginas :</strong>                          
                              <%formulario_alumnos.accesopagina%>
                            </div></td>
                          </tr>
                          <tr>
                            <td colspan="2"><div align="center">
                                  <%formulario_alumnos.dibujatabla()%>
                            </div></td>
                          </tr>
                      </form>
                      <tr>
                        <td colspan="2">&nbsp;</td>
                      </tr>
                  </table>
                 
              
            </td>
          </tr>
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
                  <td><div align="center"><%botonera.dibujaboton "salir"%></div></td>
                  <td><div align="center"><%botonera.dibujaboton "eliminar"%></div></td>
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
	</td>
  </tr>  
</table>
</body>
</html>
