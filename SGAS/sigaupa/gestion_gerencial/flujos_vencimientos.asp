<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
Server.ScriptTimeOut = 999999999
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Flujos de vencimientos por documento"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion

v_fecha_corte  = request.querystring("busqueda[0][ding_fdocto]")


 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "flujos_vencimientos.xml", "busqueda"
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 f_busqueda.siguiente
 
f_busqueda.AgregaCampoCons "ding_fdocto", v_fecha_corte


set f_botonera = new CFormulario
f_botonera.Carga_Parametros "flujos_vencimientos.xml", "botonera"



set f_flujo = new CFormulario
f_flujo.carga_parametros "flujos_vencimientos.xml", "resumen_flujo"
f_flujo.inicializar conexion 

sql_flujo=	" select top 10 protic.obtener_rut(a.pers_ncorr) as rut,c.ting_tdesc as tipo_docto, " & vbCrLf &_
			"	b.ding_ndocto as numero_docto,b.ding_ncorrelativo as correlativo,cast(b.ding_mdetalle as numeric) as detalle, " & vbCrLf &_
			"	cast(b.ding_mdocto as numeric) as total_docto,protic.trunc(b.ding_fdocto) as fecha_docto,d.edin_tdesc as estado_docto," & vbCrLf &_
			"	case when a.ting_ccod=15 then " & vbCrLf &_
			"		(select top 1 peri_tdesc from periodos_academicos where anos_ccod>=year(getdate()) and plec_ccod=1 order by peri_ccod asc) " & vbCrLf &_
			"		else (select top 1 peri_tdesc  from abonos ab, periodos_academicos pa where ab.peri_ccod=pa.peri_ccod and ab.ingr_ncorr=a.ingr_ncorr) end as periodo, " & vbCrLf &_
			"		(select sede_tdesc from sedes where sede_ccod in ((isnull((select top 1 sede_ccod from alumnos al, ofertas_academicas oa where al.ofer_ncorr=oa.ofer_ncorr and al.pers_ncorr=a.pers_ncorr  " & vbCrLf &_
			"		and oa.peri_ccod in (select top 1 pa.peri_ccod  from abonos ab, periodos_academicos pa where ab.peri_ccod=pa.peri_ccod and ab.ingr_ncorr=a.ingr_ncorr)),1)))) as sede " & vbCrLf &_
			"	from ingresos a (nolock), detalle_ingresos b (nolock),  " & vbCrLf &_
			"	tipos_ingresos c, estados_detalle_ingresos d " & vbCrLf &_
			"	where a.ingr_ncorr=b.ingr_ncorr " & vbCrLf &_
			"		and a.eing_ccod=4 -- documentados " & vbCrLf &_
			"		and b.ting_ccod in (3,4,13,38,51,52,59,66) --DOCUMENTOS (3=cheques,38=cheque protestado,4=letras, 13=T Credito, 51=T. Debito, 52=Pagare Tranbank,59= Multidebito,66= Pagare UPA) " & vbCrLf &_
			"		and convert(datetime,ding_fdocto,103)>=convert(datetime,'"&v_fecha_corte&"',103) " & vbCrLf &_
			"		and b.edin_ccod not in (6,11) " & vbCrLf &_
			"		and b.ingr_ncorr not in (select ingr_ncorr from documento_pagado) --TABLA CON DATOS DOCUMENTOS ABONADOS " & vbCrLf &_
			"		and b.ting_ccod=c.ting_ccod " & vbCrLf &_
			"		and b.edin_ccod=d.edin_ccod " & vbCrLf &_
			"		order by ding_fdocto, b.ting_ccod	"


if not Esvacio(Request.QueryString) then

'******* BORRA LA TABLA PARA LUEGO LLENARLA ********
sql_delete="delete from documento_pagado"
conexion.ejecutaS(sql_delete)

 
' **********Pobla la tabla con los datos necesarios **************
sql_inserta=  " insert into documento_pagado " & vbCrLf &_
			"	select  c.ingr_ncorr,'ghernan',getdate() " & vbCrLf &_
			"		 from      " & vbCrLf &_
			"	  	compromisos a (nolock)      " & vbCrLf &_
			"	  	join detalle_compromisos b (nolock)      " & vbCrLf &_
			"			on a.tcom_ccod = b.tcom_ccod         " & vbCrLf &_
			"			and a.inst_ccod = b.inst_ccod    " & vbCrLf &_     
			"			and a.comp_ndocto = b.comp_ndocto  " & vbCrLf &_
			"			and a.ecom_ccod = '1' " & vbCrLf &_		   		   
			"		join detalle_ingresos c (nolock) " & vbCrLf &_    
			"			on protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')    = c.ting_ccod " & vbCrLf &_
			"			and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto " & vbCrLf &_
			"			and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr')  = c.ingr_ncorr " & vbCrLf &_
			"			and c.ting_ccod in(3,4,13,38,51,52,59,66) " & vbCrLf &_
			"			and c.edin_ccod not in (6,11)     " & vbCrLf &_
			"		join ingresos e (nolock) " & vbCrLf &_
			"			on c.ingr_ncorr=e.ingr_ncorr " & vbCrLf &_
			"			and e.eing_ccod not in (3,6)  " & vbCrLf &_          
			"	where protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0 " & vbCrLf &_
			"	and protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso)= c.ding_mdocto "
			
'response.write(sql_inserta)
'conexion.ejecutaS(sql_inserta)

'***** TRAE LOS DATOS ALMACENADOS *********

	f_flujo.Consultar sql_flujo
	conexion.ejecutaS(sql_inserta)
	
else

	vacia = "select '' where 1=2 "
	
	f_flujo.Consultar vacia
	f_flujo.AgregaParam "mensajeError", "Ingrese fecha de corte"
	

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
<script language="JavaScript" src="../biblioteca/PopCalendar.js"></script>

<script language="JavaScript">

function salir(){
location.href="../lanzadera/lanzadera_up.asp?resolucion=1152";
}

</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../jefe_carrera/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../jefe_carrera/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();" >
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="72" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="72" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
                <td height="60">
<form name="buscador" method="get" action="">
              <br>
			   <table width="98%"  border="0" align="center">
                <tr>
                  <td width="82%"><div align="center">
                    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="27%"><strong>Fecha de Corte</strong> </td>
                        <td width="2%"><strong>:</strong></td>
                        <td width="71%"><%f_busqueda.dibujaCampo("ding_fdocto")%> (dd/mm/aaaa)</td>
                      </tr>
                    </table>
                  </div></td>
                  <td width="18%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td>
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
	<table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
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
            <td><br><div align="center"> 
                    <%pagina.DibujarTituloPagina%>
                </div>
              <form name="edicion" method="post" action="">
			     <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td>
					<table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                             <td align="right"></td>
                            </tr>
                               <tr>
                                 <td align="center">
								 	<%pagina.DibujarSubtitulo "Flujos de vencimientos"%><br>
									  <table width="665" border="0">
										<tr> 
										  <td width="116">&nbsp;</td>
										  <td width="511"><div align="right">P&aacute;ginas: &nbsp; 
											  <%f_flujo.AccesoPagina%>
											</div></td>
										  <td width="24"> <div align="right"> </div></td>
										</tr>
									  </table>									
                                    <%f_flujo.dibujaTabla()%>
									<br>
                                 </td>
                             </tr>
							 <tr>
							 	<td align="center">
								</td>
							 </tr>
							 <tr>
							    <td>&nbsp;
								</td>
							</tr>
						  </table>
                     </td>
                  </tr>
                </table>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="16%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="51%"><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
				  <td width="49%"> <div align="center">  <%f_botonera.dibujaboton "excel_flujos"%></div></td>
				  <td width="49%"> <div align="center">  <%f_botonera.dibujaboton "excel_abonos"%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="84%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
