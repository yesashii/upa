<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

peri_ccod=request.QueryString("a[0][peri_ccod]")
q_sede_ccod=request.QueryString("a[0][q_sede_ccod]")
fecha_consulta_r=request.QueryString("a[0][fecha_consulta_r]")
rut=request.QueryString("a[0][rut]")
dv=request.QueryString("a[0][dv]")
'response.Write(peri_ccod&"<br>"&sede_ccod&"<br>"&fecha)
'response.Write("<BR>"&fecha_consulta_r)
'---------------------------------------------------------------------------------------------------

set errores= new CErrores

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set pagina = new cPagina
set botonera = new CFormulario
botonera.carga_parametros "desbloquea_alumno.xml", "botonera"
'---------------------------------------------------------------------------------------------------

usu=negocio.ObtenerUsuario()
'---------------------------------------------------------------------------------------------------


'end if 
 set f_bloqueados = new CFormulario
f_bloqueados.Carga_Parametros "desbloquea_alumno.xml", "bloqueados"
f_bloqueados.Inicializar conexion

'side_ncorr=8
sql_descuentos= "select a.pers_ncorr,albs_ncorr,cast(pers_nrut as varchar)+'-'+pers_xdv as rut,pers_tape_paterno+' '+pers_tape_materno+' '+pers_tnombre as nombre,protic.trunc(albs_fbloqueo) as fecha_bloqueo  "& vbcrlf & _
"from alumno_bloqueo_sicologos a,personas b"& vbcrlf & _
"where a.pers_ncorr=b.PERS_NCORR"& vbcrlf & _
"and a.albs_fdesbloque is null"& vbcrlf & _
"and side_ncorr in (select side_ncorr "& vbcrlf & _
					"from sicologos_sede a,sicologos b"& vbcrlf & _
					"where a.sico_ncorr=b.sico_ncorr"& vbcrlf & _
					"and b.pers_ncorr=protic.Obtener_pers_ncorr('"&usu&"'))"

f_bloqueados.Consultar sql_descuentos
'response.Write(sql_descuentos)
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
function Validar(){
mensaje="Borrar";
//alert(dcur_ncorrM);


 nro = document.edicion.elements.length;
 
 //alert(nro);
   num =0;
   for( i = 0; i < nro; i++ ) {
	  comp = document.edicion.elements[i];
	  str  = document.edicion.elements[i].name;
	  	//alert("comp"+comp);
		//alert("str="+str);
	  if((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo')&&(comp.value != 1)){
	  //alert(comp.name);	
		indice=extrae_indice(comp.name);
		//alert(indice);
		//alert(num);
	     num += 1;
		return true;
	  }
   }
   if( num == 0 ) {

      alert('Ud. no ha seleccionado ningún Alumno para Desbloquear');
	return false;
   }	


}

</script>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');">
<table width="750" height="250" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	
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
            <td><%pagina.DibujarLenguetas Array("Alumnos Bloqueados"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td>
			
              <%pagina.DibujarTituloPagina%><br>
			  <form name="edicion">
                    <table width="75%" border="0" align="center">
						<tr>
                             <td align="right">P&aacute;gina:
                                 <%f_bloqueados.accesopagina%>
                             </td>
                            </tr>
					  <tr> 
                        <td colspan="3" align="center">
						        <%f_bloqueados.DibujaTabla()%>
						</td>
                      </tr>
                    </table>
				</form>
                  </div>
              </td>
		  </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="31%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                    
					<%botonera.DibujaBoton"desbloquear"%></div></td>
				   
				  
						
				   
				   	 
                  <td><div align="center"><%botonera.DibujaBoton("salir")%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="69%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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