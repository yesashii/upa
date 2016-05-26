<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Activación de intereses"
'-----------------------------------------------------------------------

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion



set errores = new CErrores
'-----------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "calcular_intereses.xml", "botonera"
'-----------------------------------------------------------------------
 rut_alumno = request.querystring("busqueda[0][pers_nrut]")
 rut_alumno_digito = request.querystring("busqueda[0][pers_xdv]")
 v_sint_ccod = request.querystring("sint_ccod")
 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "calcular_intereses.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.Siguiente
 
 f_busqueda.AgregaCampoCons "pers_nrut", rut_alumno
 f_busqueda.AgregaCampoCons "pers_xdv", rut_alumno_digito

v_pers_ncorr = conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar) ='" & rut_alumno & "'")
if v_sint_ccod = "" then
	v_sint_ccod = conexion.consultaUno("Select max(sint_ccod) from simulacion_interes where esin_ccod=2 and cast(pers_ncorr as varchar) ='" & v_pers_ncorr & "'")
end if
'--------------------------------------------------------------------

'--------------------------------------------------------------------
set f_contrato = new CFormulario
f_contrato.Carga_Parametros "calcular_intereses.xml", "detalle_intereses"
f_contrato.Inicializar conexion


consulta = " Select  g.comp_ndocto_referencia,g.sint_ccod,dc.tcom_ccod,dc.comp_ndocto,dc.inst_ccod,dc.dcom_ncompromiso,dc.dcom_ncompromiso as cuota, "& vbCrLf &_
			" cast(protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ding_ndocto') as varchar) as numero_docto, "& vbCrLf &_    
			" cast(isnull(protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'monto'),cp.comp_mneto) as varchar) as monto_documento,  "& vbCrLf &_ 					
			" cast(protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ting_ccod') as varchar) as ting_ccod,  "& vbCrLf &_ 					
			" cast(protic.total_recepcionar_cuota(dc.tcom_ccod,dc.inst_ccod,dc.comp_ndocto,dc.dcom_ncompromiso) as numeric)	as deuda, "& vbCrLf &_
			" protic.total_recepcionar_cuota(dc.tcom_ccod,dc.inst_ccod,dc.comp_ndocto,dc.dcom_ncompromiso)	as c_saldo, "& vbCrLf &_									
			" protic.trunc(dc.DCOM_FCOMPROMISO) fecha_vencimiento,e.tcom_tdesc as tipo_compromiso,upper(d.ting_tdesc) as tipo_ingreso,  "& vbCrLf &_    
			" replace(g.sint_nfactor,',','.') as sint_nfactor, g.sint_minteres as interes,  "& vbCrLf &_    
			" case when datediff(day,dc.dcom_fcompromiso, getdate())>0 then datediff(day,dc.dcom_fcompromiso, getdate()) else 0 end as dias_mora, "& vbCrLf &_										
			" case when datediff(day,dc.dcom_fcompromiso, getdate())>0 then datediff(day,dc.dcom_fcompromiso, getdate()) else 0 end as c_dias_mora, "& vbCrLf &_										
			" protic.total_recepcionar_cuota(dc.tcom_ccod,dc.inst_ccod,dc.comp_ndocto,dc.dcom_ncompromiso)+ g.sint_minteres as total "& vbCrLf &_										
			" From compromisos cp "& vbCrLf &_ 
			" join detalle_compromisos dc "& vbCrLf &_ 
			" 	on cp.tcom_ccod = dc.tcom_ccod "& vbCrLf &_    
			" 	and cp.inst_ccod = dc.inst_ccod "& vbCrLf &_    
			" 	and cp.comp_ndocto = dc.comp_ndocto  "& vbCrLf &_
			" left outer join detalle_ingresos c "& vbCrLf &_ 
			" 	on protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ting_ccod') = c.ting_ccod  "& vbCrLf &_  
			" 	and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto "& vbCrLf &_  
			" 	and protic.documento_asociado_cuota(dc.tcom_ccod, dc.inst_ccod, dc.comp_ndocto, dc.dcom_ncompromiso, 'ingr_ncorr') = c.ingr_ncorr "& vbCrLf &_    
			" left join tipos_ingresos d "& vbCrLf &_   
			" 	on c.ting_ccod = d.ting_ccod "& vbCrLf &_
			" left join tipos_compromisos e "& vbCrLf &_   
			" 	on cp.tcom_ccod = e.tcom_ccod "& vbCrLf &_
			" left outer join rango_factor_interes h "& vbCrLf &_
			" 	on datediff(day,dc.dcom_fcompromiso, getdate()) between rafi_ndias_minimo and rafi_ndias_maximo "& vbCrLf &_
			" 	and floor(dc.dcom_mcompromiso/protic.valor_uf()) between rafi_mufes_min and rafi_mufes_max "& vbCrLf &_
			" left outer join factor_interes f "& vbCrLf &_
			" 	on f.rafi_ccod=h.rafi_ccod "& vbCrLf &_
			" 	and f.anos_ccod=datepart(year, getdate()) "& vbCrLf &_
			" 	and f.efin_ccod=1 "& vbCrLf &_
		 	" join simulacion_interes g "& vbCrLf &_
			"	on dc.tcom_ccod = g.tcom_ccod    "& vbCrLf &_   
			"	and dc.inst_ccod = g.inst_ccod   "& vbCrLf &_    
			"	and dc.comp_ndocto = g.comp_ndocto "& vbCrLf &_
			"	and dc.dcom_ncompromiso=g.dcom_ncompromiso "& vbCrLf &_
			"	and g.esin_ccod=2 "& vbCrLf &_
			" 	and cast(g.sint_ccod as varchar)= '"&v_sint_ccod&"' "& vbCrLf &_											
			" where g.pers_ncorr ="&v_pers_ncorr



'			" left outer join factor_interes f "& vbCrLf &_   
'			" 	on f.anos_ccod=datepart(year, getdate()) "& vbCrLf &_
'			" 	and datediff(day,dc.dcom_fcompromiso, getdate()) between fint_ndias_minimo and fint_ndias_maximo "& vbCrLf &_
'			"  and floor(dc.dcom_mcompromiso/protic.valor_uf()) between fint_mufes_min and fint_mufes_max "& vbCrLf &_


			
'response.Write("<pre>"&consulta&"</pre>")		

if not Esvacio(Request.QueryString) then
		'response.Write("entre")
 	  f_contrato.Consultar consulta
else
	 f_contrato.Consultar "select '' where 1=2"
	 f_contrato.AgregaParam "mensajeError", "Ingrese criterio de busqueda"
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
</script>



<style type="text/css">
<!--
.style4 {
	color: #42424A;
	font-weight: bold;
}
.style8 {font-size: 18px}
-->
</style>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
              <td><%pagina.DibujarLenguetas Array("Búsqueda de intereses para activar"), 1 %></td>
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
                </div></td>
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
<input type="hidden" name="pers_nrut" value="<%=rut_alumno%>">
<input type="hidden" name="pers_xdv" value="<%=rut_alumno_digito%>">
					<%pagina.DibujarSubtitulo "Intereses"%><br>
					<% f_contrato.DibujaTabla() %>
                  </form>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="198" bgcolor="#D8D8DE"><table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="20%">
                        <%
					   'if estado = "" then
					   if	f_contrato.NroFilas = 0 then
							botonera.agregabotonparam "guardar", "deshabilitado" ,"TRUE"							   
					   end if
					    'botonera.AgregaBotonUrlParam "pagos", "cont_ncorr", contrato			   
						botonera.DibujaBoton ("guardar")
					   %>
                      </td>
                      <td width="20%"> <div align="left"> 
                          <%
					   'if estado = "1" or estado = "" then
					   if	f_contrato.NroFilas = 0 then
							   botonera.agregabotonparam "activar", "deshabilitado" ,"TRUE"			   
					   end if
					    botonera.DibujaBoton ("activar")
					   %>
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
