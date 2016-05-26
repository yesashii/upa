<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Mantenedor de Docentes"


rut= request.querystring("busqueda[0][pers_nrut]")
dv=request.QueryString("busqueda[0][pers_xdv]")
app=request.querystring("busqueda[0][pers_tape_paterno]")
apm=request.querystring("busqueda[0][pers_tape_materno]")
nombre=request.querystring("busqueda[0][pers_tnombre]")

if rut <> "" or dv <> "" or app <>  "" or apm <> "" or nombre <> "" then 
	pasa = false
else 
	pasa = true
end if


set conectar = new cconexion
set formulario = new cformulario
set negocio = new CNegocio



conectar.inicializar "upacifico"

negocio.inicializa conectar
formulario.carga_parametros "lec_busca_docentes.xml", "filtro_docentes"
formulario.inicializar conectar

sede_ccod = negocio.obtenersede
v_peri_planificado = negocio.obtenerPeriodoAcademico("PLANIFICACION")

set errores = new CErrores
'---------------------------------------------------------------------------------------
set f_busqueda = new CFormulario

f_busqueda.Carga_Parametros "lec_busca_docentes.xml", "busqueda"
f_busqueda.Inicializar conectar
f_busqueda.Consultar "select '' "
f_busqueda.Siguiente


f_busqueda.AgregaCampoCons "pers_nrut", rut
f_busqueda.AgregaCampoCons "pers_xdv", dv
f_busqueda.AgregaCampoCons "pers_tape_paterno", app
f_busqueda.AgregaCampoCons "pers_tape_materno", apm
f_busqueda.AgregaCampoCons "pers_tnombre", nombre

'---------------------------------------------------------------------------------------

'consulta = "select " &vbCrlf &_ 
'        "a.pers_ncorr, a.pers_nrut || '-' || a.pers_xdv  as rut " &vbCrlf &_
'		" , a.pers_tape_paterno || ' ' ||   a.PERS_TAPE_MATERNO || ' ' ||  a.pers_tnombre as nom " &vbCrlf &_
'       " , b.*,a.pais_ccod" &vbCrlf &_
'    " from " &vbCrlf &_
'        " personas a, profesores b " &vbCrlf &_
'    " where " &vbCrlf &_
'       " a.pers_ncorr=b.pers_ncorr " &vbCrlf &_
'       " and ( a.pers_nrut='" & rut & "'  or '" & rut & "' is null ) " &vbCrlf &_
'       " and ( a.pers_tape_paterno like'" & app & "%' or '" & app & "' is null ) " &vbCrlf &_
'       " and ( a.pers_tape_materno like'" & apm & "%' or '" & apm & "'is null ) " &vbCrlf &_
'       " and ( a.pers_tnombre like '" & nombre & "%' or '" & nombre & "' is null ) " &vbCrlf &_
'	   "  and b.sede_ccod = '"&negocio.ObtenerSede&"' " &vbCrlf &_
'	   " order by nom" 

consulta= " select " &vbCrlf &_
		  " a.pers_ncorr, cast(a.pers_nrut as varchar)+ '-' + cast(a.pers_xdv as varchar)  as rut, " &vbCrlf &_
		  " cast(a.pers_tape_paterno as varchar) + ' ' +  cast(a.PERS_TAPE_MATERNO as varchar)+ ' ' + cast(a.pers_tnombre as varchar) as nom, " &vbCrlf &_
		  " b.*,a.pais_ccod, " &vbCrlf &_
		  " CASE (select count(PERS_NCORR) from CARRERAS_DOCENTE where  pers_ncorr=b.pers_ncorr and peri_ccod="&v_peri_planificado&")" &vbCrlf &_		  
		  " WHEN 0 THEN 'NH' " &vbCrlf &_
		  " ELSE 'H' " &vbCrlf &_
		  " END AS Habilitado " &vbCrlf &_
 		  " from " &vbCrlf &_
 		  " personas a, profesores b " &vbCrlf &_
 		  " where " &vbCrlf &_
 		  " a.pers_ncorr=b.pers_ncorr " &vbCrlf &_
		  " and  cast(a.pers_nrut as varchar)= case '"&rut&"' when '' then cast(a.pers_nrut as varchar) else '"&rut&"' end " &vbCrlf &_
		  " and ( a.pers_tape_paterno like'" & app & "%' or '" & app & "' is null ) " &vbCrlf &_
		  " and ( a.pers_tape_materno like'" & apm & "%' or '" & apm & "'is null ) " &vbCrlf &_
		  " and ( a.pers_tnombre like '" & nombre & "%' or '" & nombre & "' is null ) " &vbCrlf &_
 		  " and cast(b.sede_ccod as varchar) = '"&negocio.ObtenerSede&"' " &vbCrlf &_
		  " order by nom"	   
	   
'response.Write("<pre>"& consulta & "</pre>")
'response.End()
formulario.consultar consulta
'response.Write(consulta)

texto = "Para buscar docentes ingrese un criterio de búsqueda y presione el botón ""Buscar""."


'-------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "lec_busca_docentes.xml", "botonera"


%>



<html>
<head>
<title>Mantenedor de Docentes</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function ValidarImpresion()
{
form = document.edicion;
nro = form.elements.length;
valor = uno_seleccionado(form);
if	(valor == 1)// se selecciono uno
	{
	for	( i = 0; i < nro; i++ ) 
		{
		comp = form.elements[i];
		str  = form.elements[i].name;
		if	((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo'))
			{
		  	//	alert(str);
			indice=extrae_indice(str);
			 //alert("Indice:"+indice);m[0][pers_ncorr]
			v_pers_ncorr=form.elements["m["+indice+"][pers_ncorr]"].value;
			if	(v_pers_ncorr!="") // estado del contrato debe ser activo
				{ 
				//cont_ncorr = form.elements["contratos["+indice+"][cont_ncorr]"].value;
				//return true;
				pagina = "formulario_19.asp?pers_ncorr=" +v_pers_ncorr;
				resultado = open(pagina,'wAgregar','width=750px, height=600px, scrollbars=yes, resizable=yes');
				resultado.focus();
				return false;
				}	
		  	}
		}
	alert("Opción de impresión sólo para contratos activos.");	
	return false;	
	}
else	
	{
	alert('Ud. no ha seleccionado registro o selecciono más de uno, debe seleccionar sólo un registro.');
	return false;
	}
//alert("Opción de impresión sólo para contratos activos.");	
return false;	
}
function uno_seleccionado(form){
	  	nro = form.elements.length;
   		num =0;
	   for( i = 0; i < nro; i++ ) {
		  comp = form.elements[i];
		  str  = form.elements[i].name;
		  
		  if((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo')){
	 		num += 1;
		  }
	   }
	   return num;
 }
</script>

</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
                    <td width="5"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="100" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="center"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador</font></div></td>
                    <td width="6"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
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
				<form name="buscador">
                  <table width="98%"  border="0">
                    <tr>
                      <td width="81%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td valign="top" nowrap>
                            <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                              <%f_busqueda.DibujaCampo("pers_nrut")%>
        -
        <%f_busqueda.DibujaCampo("pers_xdv")%>
        <br>
        Rut Docente</font></div></td>
                          <td valign="top">
                            <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">                              
                              <%f_busqueda.DibujaCampo("pers_tape_paterno")%>
                              <br>
        Apellido Paterno</font></div></td>
                          <td valign="top">
                            <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">                              
                              <%f_busqueda.DibujaCampo("pers_tape_materno")%>
                              <br>
        Apellido Materno</font></div></td>
                          <td valign="top">
                            <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">                              
                              <%f_busqueda.DibujaCampo("pers_tnombre")%>
                              <br>
        Nombre</font></div></td>
                          <td>
                            <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"> </font></div></td>
                        </tr>
                      </table></td>
                      <td width="19%"><div align="center"><% f_botonera.DibujaBoton("buscar") %></div></td>
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
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Resultados de la b&uacute;squeda</font></div></td>
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
				    
					<%if pasa  then 
				       response.Write(texto)
					  else%>
	    </p>
	  <table>
				   <tr><td nowrap>Resultado de la búsqueda </td></tr>
	    </table><%if rut <>"" and dv<>"" then%>                   
				   <table>
				   <tr><td>Rut Docente</td><td><strong><%response.write(rut&" - "&dv)%></strong></td></tr>
				   </table><%else if app <>"" and apm <>"" and nombre <> ""then %>
                    <table>
				   <tr>
				        <td nowrap>Ap. Paterno Ap. Materno, Nombre : </td>
                        <td><strong><%response.Write(app&"   "&apm&", "&nombre)%></strong></td>
				   </tr>
				   </table><%else if app <>"" and apm <>"" then %>
				   <table>
				   <tr>
				   <td>Apellidos : </td><td><strong><%response.Write(app&" - "&apm)%></strong></td>
				   </tr>
				   </table><%else if app <> "" then%>
				   <table>
				   <tr>
				   <td>Apellido Paterno : </td><td><strong><%response.Write(app)%></strong></td>
				   </tr>
				   </table><%else if apm <>"" then %>
				   <table>
				   <tr>
				   <td>Apellido Materno : </td><td><strong><%response.Write(apm)%></strong></td>
				   </tr>
				   </table>
                    <%else if nombre <>"" then %>
				   <table>
				   <tr>
				   <td>Nombre : </td><td><strong><%response.Write(nombre)%></strong></td>
				   </tr>
				   </table><% end if
				   	end if 
					end if
					end if
					end if
					end if
					end if%>
      <form name="edicion">
        <table width="90%" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td><div align="center"><br>
              <%pagina.DibujarTituloPagina%>
              <br>
              </div></td>
          </tr>
          <tr>
            <td align="right"> <strong>P&aacute;ginas&nbsp;:&nbsp;</strong>&nbsp;
                <%formulario.accesoPagina%>
            </td>
          </tr>
          <tr>
            <td align="right">&nbsp;</td>
          </tr>
          <tr>
            <td align="left">
              <%formulario.dibujaTabla()%>
              <br>
      Esta p&aacute;gina muestra la lista de los docentes vigentes en la sede. <br>
      Para visualizar los datos de un docente haga clic en un registro de la lista.<br>
      El bot&oacute;n &quot;Eliminar&quot; deja no vigente al docente seleccionado en la caja de chequeo.<br>
      Si el docente no existe en su sede puede agregarlo con el bot&oacute;n &quot;Agregar&quot;.<br>
                                  <font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;</font>
                                  <div align="right"></div></td>
          </tr>
        </table>
      </form>
					
					
				  <form action="editar_docente.asp" method="get" name="form2" id="form2">
                    <input name="rut" type="hidden" id="rut" value="<%=rut%>">
                    <input name="dv" type="hidden" id="dv" value="<%=dv%>">
                  </form>  				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="232" bgcolor="#D8D8DE"> 
                  <div align="center">
                    <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                       
                        
						<% if	formulario.nroFilas <> 0 then%>
								<td><div align="center">
						  		<%f_botonera.DibujaBoton("imprimir")%>
		                        </div></td>
						<% end if%>
                        <td><div align="center">
						  <%f_botonera.DibujaBoton("salir")%>
                        </div></td>
					</tr>
                    </table>
                  </div></td>
                  <td width="130" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
