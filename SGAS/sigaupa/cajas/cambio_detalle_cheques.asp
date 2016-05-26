<!--Versión 1.0 creada por Sinezio da Silva fecha 03-05-2015 supervisionada por Michael Shaw
hay dos paginas que estan viculadas a este XML cambio_detalle_cheque.xml y proc_cambio_detalle_cheque.asp-->

<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'---------------------------------------------------------------------------------------------------
q_pers_nrut 	= 	Request.QueryString("buscador[0][pers_nrut]")
q_pers_xdv 		= 	Request.QueryString("buscador[0][pers_xdv]")
q_COMP_NDOCTO	=	Request.QueryString("buscador[0][COMP_NDOCTO]")



set pagina = new CPagina
pagina.Titulo = "Ajuste de Cheques"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


set f_botonera = new CFormulario
f_botonera.Carga_Parametros "cambio_detalle_cheque.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "cambio_detalle_cheque.xml", "buscador"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv
f_busqueda.AgregaCampoCons "COMP_NDOCTO",q_COMP_NDOCTO 
f_busqueda.Siguiente

v_pers_ncorr = conexion.ConsultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar) = '" & q_pers_nrut & "'")


if q_pers_nrut <> "" and q_COMP_NDOCTO <> "" then
'---------------------------------------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "cambio_detalle_cheque.xml", "datos_alumno"
formulario.Inicializar conexion
sql_comentarios ="Select protic.obtener_rut(pers_ncorr) as rut,protic.obtener_nombre_completo(pers_ncorr, 'n') as nombre from personas where pers_nrut="&q_pers_nrut
formulario.Consultar sql_comentarios
formulario.Siguiente
'response.End()
'---------------------------------------------------------------------------------------------------
set datos = new CFormulario
datos.Carga_Parametros "cambio_detalle_cheque.xml", "detalle_ingreso"
datos.Inicializar conexion
consulta_documento ="select ingr_ncorr,ingr_ncorr as ingr_ncorr2, b.inst_ccod, b.comp_ndocto,b.comp_ndocto as comp_ndocto2, b.tcom_ccod, b.tcom_ccod as tcom_ccod2, case when b.tcom_ccod in (1,2) then cast(b.comp_ndocto as varchar)+ ' ('+protic.numero_contrato(b.comp_ndocto)+')'else cast(b.comp_ndocto as varchar) end as ncompromiso, b.dcom_ncompromiso as  dcom_ncompromiso2," & vbCrLf &_
								"     case " & vbCrLf &_
								"   when b.tcom_ccod=25 or b.tcom_ccod=4 or b.tcom_ccod=5 or b.tcom_ccod=8 or b.tcom_ccod=10 or b.tcom_ccod=26 or b.tcom_ccod=34 or b.tcom_ccod=35 or b.tcom_ccod=15 " & vbCrLf &_
        						"		then " & vbCrLf &_
							    "       (Select top 1 a1.tdet_tdesc from tipos_detalle a1,detalles a2 where a2.tcom_ccod=a.tcom_ccod and a2.inst_ccod=a.inst_ccod " & vbCrLf &_
							    "        and a2.comp_ndocto=a.comp_ndocto and a1.tdet_ccod=a2.tdet_ccod) " & vbCrLf &_
							    " 	when b.tcom_ccod=37 then (select a3.tcom_tdesc from tipos_compromisos a3 where a3.tcom_ccod=a.tcom_ccod)+'-'+protic.obtener_nombre_carrera(a.ofer_ncorr,'CJ') "& vbCrLf &_
								"   else " & vbCrLf &_
							    "        (select a3.tcom_tdesc from tipos_compromisos a3 where a3.tcom_ccod=a.tcom_ccod) " & vbCrLf &_
							    "    end as tcom_tdesc, " & vbCrLf &_
								"    b.dcom_ncompromiso,cast(b.dcom_ncompromiso as varchar) + '/' + cast(a.comp_ncuotas as varchar)  as ncuota," & vbCrLf &_
								"    protic.trunc(a.comp_fdocto) as comp_fdocto , protic.trunc(b.dcom_fcompromiso) as dcom_fcompromiso, b.dcom_mcompromiso,b.dcom_mcompromiso as dcom_mcompromiso2," & vbCrLf &_
								"    protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as ting_ccod," & vbCrLf &_
								"    case  "& vbCrLf &_
								"    when a.tcom_ccod=2 and  protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')=52 "& vbCrLf &_
								"        then  "& vbCrLf &_
								"          (select pag.PAGA_NCORR from  pagares pag 	where  pag.cont_ncorr =a.comp_ndocto and isnull(pag.opag_ccod,1) not in (2)) "& vbCrLf &_
								"        else "& vbCrLf &_
								"            protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') "& vbCrLf &_
								"        end as ding_ndocto, "& vbCrLf &_
								"    protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as abonos, " & vbCrLf &_
								"    protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as documentado," & vbCrLf &_
								"    isnull(b.dcom_mcompromiso, 0) - protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo, " & vbCrLf &_
								"(select d.edin_ccod from  estados_detalle_ingresos d" & vbCrLf &_
								"    where c.edin_ccod = d.edin_ccod) as edin_ccod," & vbCrLf &_
								"(select d.edin_tdesc+protic.obtener_institucion(c.ingr_ncorr) from estados_detalle_ingresos d" & vbCrLf &_
								"    where c.edin_ccod = d.edin_ccod) as edin_tdesc " & vbCrLf &_
								" from compromisos a INNER JOIN detalle_compromisos b " & vbCrLf &_
								"	ON a.tcom_ccod = b.tcom_ccod " & vbCrLf &_
								"    and a.inst_ccod = b.inst_ccod " & vbCrLf &_
								"    and a.comp_ndocto = b.comp_ndocto " & vbCrLf &_
								"    LEFT OUTER JOIN detalle_ingresos c " & vbCrLf &_
								"    ON protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') = c.ting_ccod " & vbCrLf &_
								"    and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto " & vbCrLf &_
								"    and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') = c.ingr_ncorr " & vbCrLf &_
								"    WHERE a.ecom_ccod = '1' " & vbCrLf &_
								"    and b.ecom_ccod <> '3' " & vbCrLf &_
								"    and cast(a.pers_ncorr as varchar) ='" & v_pers_ncorr & "'" & vbCrLf &_
								"	 and b.COMP_NDOCTO='" & q_COMP_NDOCTO & "'" & vbCrLf &_
								"	 and c.EDIN_CCOD = '1'" & vbCrLf &_
								"	 and c.TING_CCOD = '3'" & vbCrLf &_
								"	 and a.tcom_ccod = '1'" & vbCrLf &_
								"    order by b.dcom_fcompromiso desc"
							
'response.write consulta_documento
datos.Consultar consulta_documento

contador_fila = datos.nroFilas
sql_valor = "select SUM(b.dcom_mcompromiso)" & vbCrLf &_
" from compromisos a INNER JOIN detalle_compromisos b " & vbCrLf &_
"	ON a.tcom_ccod = b.tcom_ccod " & vbCrLf &_
"    and a.inst_ccod = b.inst_ccod " & vbCrLf &_
"    and a.comp_ndocto = b.comp_ndocto " & vbCrLf &_
"    LEFT OUTER JOIN detalle_ingresos c " & vbCrLf &_
"    ON protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') = c.ting_ccod " & vbCrLf &_
"    and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto " & vbCrLf &_
"    and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr') = c.ingr_ncorr " & vbCrLf &_
"    WHERE a.ecom_ccod = '1' " & vbCrLf &_
"    and b.ecom_ccod <> '3' " & vbCrLf &_
"    and cast(a.pers_ncorr as varchar) ='" & v_pers_ncorr & "'" & vbCrLf &_
"	 and b.COMP_NDOCTO='" & q_COMP_NDOCTO & "'" & vbCrLf &_
"	 and c.EDIN_CCOD = '1'" & vbCrLf &_
"	 and c.TING_CCOD = '3'" & vbCrLf &_
"	 and a.tcom_ccod = '1'"
somavalorbase = conexion.ConsultaUno(sql_valor)
'response.Write(contador_fila)
'response.End()
'--------------------------------------------------------------------------------------------------


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
function Mensaje(){
<% if session("mensaje_error")<>"" then%>
alert("<%=session("mensaje_error")%>");
<%
session("mensaje_error")=""
end if
%>
}


function ValidaBusqueda()
{
	rut=document.buscador.elements['buscador[0][pers_nrut]'].value+'-'+document.buscador.elements['buscador[0][pers_xdv]'].value
	
	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido');		
		document.buscador.elements['buscador[0][pers_nrut]'].focus()
		document.buscador.elements['buscador[0][pers_nrut]'].select()
		return false;
	}
	
	return true;	
}

function sumavalor()
{
	sumaValorModificado = 0
	contador_fila = '<%=contador_fila%>'	
	//alert(contador_fila)	
	for(x=0;x<contador_fila ;x++)
	{
		if( document.edicion.elements['datos_ingreso['+x+'][monto_cambio]'].value == '')
		{
			valorModificado = 0;
		}
		else{
			valorModificado=parseInt(document.edicion.elements['datos_ingreso['+x+'][monto_cambio]'].value)
		}
		sumaValorModificado = valorModificado+sumaValorModificado	 
	}
	document.getElementById('sumavalor').innerHTML = sumaValorModificado;
}

function ValidaValoresIngreso()
{
	
	
sumaValorModificado = 0
sumavalorBaseDatos = 0
contador_fila = '<%=contador_fila%>'	
//alert(contador_fila)	
for(x=0;x<contador_fila ;x++)
{
	
		valorModificado=parseInt(document.edicion.elements['datos_ingreso['+x+'][monto_cambio]'].value)
		valorBaseDatos=parseInt(document.edicion.elements['datos_ingreso['+x+'][dcom_mcompromiso2]'].value)
		sumaValorModificado = valorModificado+sumaValorModificado
		//sumaValorModificado='<%'=suma%>'		
		sumavalorBaseDatos = valorBaseDatos+sumavalorBaseDatos	
}
	if(sumaValorModificado==sumavalorBaseDatos)
			{
			return true;
			alert(sumaValorModificado)
			//alert("datos OK")
			}else
				{alert("Error...Las sumas de los valores entre el Monto y Monto Cambiado son distintos.")
				//alert(sumaValorModificado)
				sumaValorModificado='<%=suma%>'	
				return false;
				}

}//fin funcion ValidaValoresIngreso
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Mensaje();"onBlur="revisaVentana();">

<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr>
    <td height="65"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
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
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="2">
                      <tr>
                        <td width="32%"><div align="right"><strong>R.U.T</strong>.</div></td>
                        <td width="7%"><div align="center"><strong>:</strong></div></td>
                        <td width="61%"><%f_busqueda.DibujaCampo("pers_nrut")%>
      -
        <%f_busqueda.DibujaCampo("pers_xdv")%>
        <%pagina.DibujarBuscaPersonas "buscador[0][pers_nrut]", "buscador[0][pers_xdv]" %></td>
                      </tr>
                    </table>
                    <table width="90%"  border="0" cellspacing="0" cellpadding="2">
                      <tr>
                        <td width="32%"><div align="right"><strong>No. de Documento</strong>.</div></td>
                        <td width="7%"><div align="center"><strong>:</strong></div></td>
                        <td width="61%"><%f_busqueda.DibujaCampo("COMP_NDOCTO")%></td>
                      </tr>
                    </table>
                  </div></td>
                  <td width="19%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td>
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
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%>
              <br>	
              <br>	
</div>		
	<%if q_pers_nrut <> "" then%>
			<form name="edicion">
			  <table width="80%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
                    <td width="15%"><strong>Rut</strong></td>
                    <td width="85%"><%formulario.dibujaCampo("rut")%></td>
                </tr>
				<tr>
                    <td><strong>Nombre</strong></td>
                    <td><%formulario.dibujaCampo("nombre")%></td>
                </tr>
                <tr>
                  <td><strong>Monto total</strong></td>
                  <td><%=somavalorbase%></td></tr>
                <tr><td colspan="2"></td></tr>

              </table> 
              <table width="60%" border="0" align="center">
                      <tr>
						<td width="800" align="center"><p>
						  <%datos.DibujaTabla%>
						</p>
					      <table width="268" border="0" align="right">
					        <tr>
					          <td width="94"><font color ="red"><strong>Suma Total</strong></font></td>
					          <td width="10" align="center"><strong>:</strong></td>
					          <td width="150"><strong>
					          <div id="sumavalor">0</div></strong></td>
				            </tr>
				          </table>
				        <p>&nbsp; </p></td>
                        
						</tr>
                        
                        
                    </table>
              <table>
              
              </table>
			</form>  
            <%end if%>          
            </td></tr>            
      </table>
		
        </td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="18%" height="20"><div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0" align="center">
                      <tr>
                        <td width="45%">  
						
						<%f_botonera.DibujaBoton("guardar")%>
                          
                        </td>
                        <td width="55%"><div align="center">
                            <%f_botonera.DibujaBoton("salir")%>
                          </div></td>
                      </tr>
                    </table>
            </div></td>
            <td width="82%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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