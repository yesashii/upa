<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
q_pers_nrut = Request.QueryString("busqueda[0][pers_nrut]")
q_pers_xdv = Request.QueryString("busqueda[0][pers_xdv]")
'---------------------------------------------------------------------------------------------------
set pagina = new CPagina
pagina.Titulo = "Impresión de Documentos"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
'nombre del alumno
consulta = "select pers_tnombre + ' ' + pers_tape_paterno " & vbCrLf &_
			"from personas"  & vbCrLf &_
			"where " & vbCrLf &_
			"cast(pers_nrut as varchar)='"&q_pers_nrut&"' and cast(pers_xdv as varchar)= '"&q_pers_xdv&"'"
nombre = conexion.consultauno(consulta)

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "impr_pagos.xml", "botonera"

'---------------------------------------------------------------------------------------------------
'set cajero = new CCajero
'cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede

'if not cajero.TieneCajaAbierta then
'	conexion.MensajeError "No puede recibir pagos si no tiene una caja abierta."
'	Response.Redirect("../lanzadera/lanzadera.asp")
'end if

'---------------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "impr_pagos.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoCons "pers_nrut", q_pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", q_pers_xdv

set formulario = new cformulario
formulario.carga_parametros "impr_pagos.xml", "form_busca_pagos"
formulario.inicializar conexion
if q_pers_nrut="" and q_pers_xdv ="" then
	q_pers_nrut =""
	q_pers_xdv =""
end if
pers_ncorr=conexion.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")

'consulta =" select distinct i.ingr_nfolio_referencia as nfolio,a.comp_ndocto,aa.total," & vbCrlf & _
'          " i.ingr_fpago as fecha_pago,t_i.ting_tdesc as tipo_ingreso, i.ting_ccod as nro_ting_ccod,i.pers_ncorr, " & vbCrlf & _
'		  " '<a href=""javascript:imprimir('+ cast(i.ingr_nfolio_referencia as varchar)+ ','+ cast(i.ting_ccod as varchar)+','+cast(i.pers_ncorr as varchar) +','+ cast(aa.total as varchar)+','+ cast(a.peri_ccod as varchar)+')"">'+ 'Volver a imprimir.' + '</a>' as imprimir " & vbCrlf & _
'         " from compromisos c,detalle_compromisos dc,abonos a,ingresos i,tipos_ingresos t_i," & vbCrlf & _
'          " (select i.ingr_nfolio_referencia,sum(i.ingr_mtotal) as total" & vbCrlf & _
'          " from compromisos c,detalle_compromisos dc,abonos a,ingresos i,tipos_ingresos t_i" & vbCrlf & _
'          " where cast(c.pers_ncorr as varchar)='"&pers_ncorr&"'" & vbCrlf & _
'          " and c.pers_ncorr=dc.pers_ncorr" & vbCrlf & _
'          " and c.comp_ndocto=dc.comp_ndocto" & vbCrlf & _
'          " and dc.comp_ndocto=a.comp_ndocto" & vbCrlf & _
'          " and a.ingr_ncorr= i.ingr_ncorr" & vbCrlf & _
'          " and i.ting_ccod=t_i.ting_ccod" & vbCrlf & _
'		  " and t_i.ting_ccod in (16,34,47,48,48,50)"& vbCrlf &_
'          " group by i.ingr_nfolio_referencia) aa" & vbCrlf & _
'          " where cast(c.pers_ncorr as varchar)='"&pers_ncorr&"'" & vbCrlf & _
'          " and i.ingr_nfolio_referencia=aa.ingr_nfolio_referencia" & vbCrlf & _
'          " and c.pers_ncorr=dc.pers_ncorr" & vbCrlf & _
'          " and c.comp_ndocto=dc.comp_ndocto" & vbCrlf & _
'          " and dc.comp_ndocto=a.comp_ndocto" & vbCrlf & _
'          " and a.ingr_ncorr= i.ingr_ncorr" & vbCrlf & _
'          " and i.ting_ccod=t_i.ting_ccod"& vbCrlf &_
'		  " and t_i.ting_ccod in (16,34,47,48,48,50)"

consulta=" select  distinct i.ingr_nfolio_referencia as nfolio,a.comp_ndocto,aa.total,a.peri_ccod,"& vbCrlf &_
         " i.ingr_fpago as fecha_pago,t_i.ting_tdesc as tipo_ingreso, i.ting_ccod as nro_ting_ccod,i.pers_ncorr, "& vbCrlf &_
         " '<a href=""javascript:imprimir('+ cast(i.ingr_nfolio_referencia as varchar)+ ','+ cast(i.ting_ccod as varchar)+','+cast(i.pers_ncorr as varchar) +','+ cast(aa.total as varchar)+','+ cast(a.peri_ccod as varchar)+')"">'+ 'Volver a imprimir.' + '</a>' as imprimir " & vbCrlf & _
         " from ingresos i,tipos_ingresos t_i,abonos a,"& vbCrlf &_
         " (select distinct i.ingr_nfolio_referencia,sum(i.ingr_mtotal) as total"& vbCrlf &_
         " from ingresos i,tipos_ingresos t_i"& vbCrlf &_
         " where cast(i.pers_ncorr as varchar)='"&pers_ncorr&"'"& vbCrlf &_
         " and i.ting_ccod=t_i.ting_ccod"& vbCrlf &_
		 " and cast(i.eing_ccod as varchar)<>'3'"&vbCrlf &_
         " and t_i.ting_ccod in (16,17,34,47,48,49,50)"& vbCrlf &_
         " group by i.ingr_nfolio_referencia) aa"& vbCrlf &_
         " where cast(i.pers_ncorr as varchar)='"&pers_ncorr&"'"& vbCrlf &_
		 " and a.ingr_ncorr=i.ingr_ncorr"& vbCrlf &_
         " and a.pers_ncorr=i.pers_ncorr"& vbCrlf &_
         " and i.ingr_nfolio_referencia=aa.ingr_nfolio_referencia"& vbCrlf &_
         " and i.ting_ccod=t_i.ting_ccod"& vbCrlf &_
		 " and cast(i.eing_ccod as varchar)<>'3'"&vbCrlf &_
         " and t_i.ting_ccod in (16,17,34,47,48,49,50)"& vbCrlf &_ 
         "  order by fecha_pago DESC "
'response.Write("<pre>"&consulta&"</pre>")
formulario.consultar consulta

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
function ValidaBusqueda()
{
	rut=document.buscador.elements['busqueda[0][pers_nrut]'].value+'-'+document.buscador.elements['busqueda[0][pers_xdv]'].value
	
	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido');		
		document.buscador.elements['busqueda[0][pers_nrut]'].focus()
		document.buscador.elements['busqueda[0][pers_nrut]'].select()
		return false;
	}
	
	return true;	
}

function imprimir(nfolio,tipo_doc,pers_ncorr,total,periodo)
{var url;
    if ((tipo_doc=='16')||(tipo_doc=='34')||(tipo_doc=='17')){
	     url="comp_ingreso.asp?nfolio="+ nfolio + "&nro_ting_ccod="+ tipo_doc + "&pers_ncorr="+pers_ncorr+"&total="+total+"&peri_ccod="+periodo;
	   }
	 else if(tipo_doc=='47'){
	     url="proc_genera_impboletaN_afecta.asp?nfolio="+ nfolio + "&nro_ting_ccod="+ tipo_doc + "&pers_ncorr="+pers_ncorr+"&total="+total+"&peri_ccod="+periodo;
	   }	
	  else if(tipo_doc=='48'){
	     url="proc_genera_impboleta_afecta.asp?nfolio="+ nfolio + "&nro_ting_ccod="+ tipo_doc + "&pers_ncorr="+pers_ncorr+"&total="+total+"&peri_ccod="+periodo;
	   } 
	   else if(tipo_doc=='49'){
	     url="proc_genera_impfacturaN_afecta.asp?nfolio="+ nfolio + "&nro_ting_ccod="+ tipo_doc + "&pers_ncorr="+pers_ncorr+"&total="+total+"&peri_ccod="+periodo;
	   }   
	   else if(tipo_doc=='50'){
	     url="proc_genera_impfactura_afecta.asp?nfolio="+ nfolio + "&nro_ting_ccod="+ tipo_doc + "&pers_ncorr="+pers_ncorr+"&total="+total+"&peri_ccod="+periodo;
	   }
	//alert(url);
	irA(url, "1", 700, 500)
    //return true;
}

nrofilasdibujadas=0

function existe(arreglo,valor){
	for (x=0;x<arreglo.length;x++){
		if (arreglo[x] == valor){
			return true
		}
	}
	return false
}
function InicioPagina()
{
	t_busqueda = new CTabla("busqueda");
}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="InicioPagina();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
                  <td width="81%"><div align="center">
                    <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td><div align="right"><strong>R.U.T. Alumno </strong></div></td>
                        <td width="50"><div align="center">:</div></td>
                        <td><%f_busqueda.DibujaCampo("pers_nrut")%> 
                        - 
                          <%f_busqueda.DibujaCampo("pers_xdv")%> <%pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]"%></td>
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
              <%pagina.DibujarTituloPagina%><br>
              <br>
              <table width="96%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                        <td width="10%"><strong>Nombre</strong></td>
						<td width="2%"><strong>:</strong></td>
						<td width="88%"><%=nombre%></td>
                </tr>
				 <tr>
                        <td width="10%"><strong>R.U.T</strong></td>
						<td width="2%"><strong>:</strong></td>
						<td width="82%"><% if q_pers_nrut <>"" then
						                     response.Write(q_pers_nrut&"-"&q_pers_xdv)
										    end if%></td>
                </tr>
              </table>
                </div>
              <form name="edicion">
                <input type="hidden" name="rut" value="<%=q_pers_nrut&"-"&q_pers_xdv%>">
				<input type="hidden" name="nombre" value="<%=nombre%>">
                 <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                    <td><div align="right">
                      <div align="left">
                          <%pagina.DibujarSubtitulo "Lista De ingresos pagados"%>                          
                      </div>
                      <div align="right">                        </div></td>
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
            <td width="16%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton("salir")%></div></td>
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
