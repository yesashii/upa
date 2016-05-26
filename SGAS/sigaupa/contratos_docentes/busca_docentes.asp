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
carr_ccod=request.querystring("carr_ccod")
'RESPONSE.Write(carr_ccod&"<BR>")
dim Jornada2
IF LEN(carr_ccod) >2 THEN 
	Jornada2=RIGHT(carr_ccod,1)
	carr_ccod= MID(carr_ccod,1,LEN(carr_ccod)-2)
END IF


if rut <> "" or dv <> "" or app <>  "" or apm <> "" or nombre <> "" then 
	pasa = false
else 
	pasa = true
end if


set conectar = new cconexion
set formulario = new cformulario
set negocio = new CNegocio

'proceso = "Planificacion"
peri_ccod = negocio.ObtenerPeriodoAcademico("PLANIFICACION")


conectar.inicializar "upacifico"

negocio.inicializa conectar
formulario.carga_parametros "Habilitacion_docentes.xml", "filtro_docentes2"
formulario.inicializar conectar

sede_ccod = negocio.obtenersede

set errores = new CErrores
'---------------------------------------------------------------------------------------
set f_busqueda = new CFormulario

f_busqueda.Carga_Parametros "Habilitacion_docentes.xml", "busqueda"
f_busqueda.Inicializar conectar
f_busqueda.Consultar "select '' "
f_busqueda.Siguiente


f_busqueda.AgregaCampoCons "pers_nrut", rut
f_busqueda.AgregaCampoCons "pers_xdv", dv
f_busqueda.AgregaCampoCons "pers_tape_paterno", app
f_busqueda.AgregaCampoCons "pers_tape_materno", apm
f_busqueda.AgregaCampoCons "pers_tnombre", nombre

'---------------------------------------------------------------------------------------
Sede_ccod = negocio.ObtenerSede

consulta=""
consulta = consulta & " select " & vbCrlf 
consulta = consulta &  " b.sede_ccod, a.pers_ncorr, cast(a.pers_nrut as varchar)+ '-' + cast(a.pers_xdv as varchar)  as rut, " &vbCrlf 
consulta = consulta &  " cast(a.pers_tape_paterno as varchar) + ' ' +  cast(a.PERS_TAPE_MATERNO as varchar)+ ' ' + cast(a.pers_tnombre as varchar) as nom, " &vbCrlf 
consulta = consulta &  " b.*,c.jdoc_tdesc, isnull(c.jdoc_ccod,99) as jerarquia, " &vbCrlf 
consulta = consulta &  carr_ccod & " as carr_ccod, " &vbCrlf 
consulta = consulta &  peri_ccod & " as peri_ccod," &vbCrlf 
consulta = consulta &  Jornada2 & " as jorn_ccod" &vbCrlf 
consulta = consulta &  " from " &vbCrlf 
consulta = consulta &  " personas a, profesores b, jerarquias_docentes c " &vbCrlf 
consulta = consulta &  " where " &vbCrlf 
consulta = consulta &  " a.pers_ncorr=b.pers_ncorr " & vbCrlf 
consulta = consulta &  " and b.jdoc_ccod=c.jdoc_ccod " & vbCrlf 
consulta = consulta &  " AND B.PERS_NCORR NOT IN(SELECT PERS_NCORR FROM CARRERAS_DOCENTE WHERE PERI_CCOD=" & peri_ccod & " AND CARR_CCOD=" & carr_ccod & " and cast(sede_ccod as varchar) = '"&negocio.ObtenerSede&"' AND JORN_CCOD="& Jornada2 &") " 
'if rut = "" and app = "" and apm="" and nombre = "" then consulta = consulta & " and 1=2" & vbCrlf 
if rut <> "" then consulta = consulta &  " and ( cast(a.pers_nrut as varchar)='" & rut & "'  or '" & rut & "' is null ) " &vbCrlf 
if app <> "" then consulta = consulta &  " and ( a.pers_tape_paterno like'%" & app & "%' or '" & app & "' is null ) " &vbCrlf 
if apm <> "" then consulta = consulta &  " and ( a.pers_tape_materno like'%" & apm & "%' or '" & apm & "'is null ) " &vbCrlf 
if nombre <> "" then consulta = consulta &  " and ( a.pers_tnombre like '%" & nombre & "%' or '" & nombre & "' is null ) " &vbCrlf 
consulta = consulta &  " and cast(b.sede_ccod as varchar) = '"&Sede_ccod&"' " &vbCrlf 
consulta = consulta &  " order by A.pers_tape_paterno, A.pers_tnombre"	   
	   
'response.Write("<pre>"& consulta & "</pre>")
'response.End()
formulario.consultar consulta
'response.Write(consulta)

texto = "Para buscar docentes ingrese un criterio de búsqueda y presione el botón ""Buscar""."


'-------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "Habilitacion_docentes.xml", "botonera2"

if not esvacio(carr_ccod) and carr_ccod<> "" then
	periodo = "<br>" & conectar.consultaUno("Select peri_tdesc from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
    pagina.Titulo = "Mantenedor de Docentes"&periodo

end if

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

function verifica_check(){
   nro = document.edicion.elements.length;
   num =0;
   for( i = 0; i < nro; i++ ) {
	  comp = document.edicion.elements[i];
	  str  = document.edicion.elements[i].name;
	  v_indice=extrae_indice(str);

	  if((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo') ){
	     num += 1;

		 v_jerarquia=document.edicion.elements["mmm["+v_indice+"][jerarquia]"].value;
			if ((v_jerarquia==0)||(v_jerarquia==99)){
				alert("No puede habilitar a un docente que no ha sido jerarquizado");
return false;
			}else{
				window.open("proc_habilitacion_agregar.asp?pers_ncorr="+ comp.value+"&Sede_ccod=<%=Sede_ccod%>&carr_ccod=<%=carr_ccod%>&peri_ccod=<%=peri_ccod%>&jorn_ccod=<%=Jornada2%>");
			}


	  }
   }
   if( num == 0 ) {
      	alert('No ha seleccionado ningún registro para Habilitar');
		formu.submit();
	  	return false;
   }	
}


function enviar(formu){
	formu.action="proc_habilitacion_agregar.asp";
	formu.submit();
	return false;
}
</script>

</head>
<body bgcolor="#cc6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <%if EsVacio(carr_ccod) or carr_ccod = "" then%>
  <tr>
    <td><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()
  end if%>  
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
                              <%f_busqueda.DibujaCampo("pers_tape_paterno")%>                 <input type="hidden" name="carr_ccod"  value="<%=carr_ccod & " " & Jornada2%>">
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
      <form name="edicion" >
        <table width="90%" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td><div align="center"><br>
                <input type="hidden" name="carr_ccod"  value="<%=carr_ccod & " " & Jornada2%>">
                <%pagina.DibujarTituloPagina%>
              <br>
              </div></td>
          </tr>
		  <tr>
            <td align="right">&nbsp;
            </td>
          </tr>
          <tr>
            <td align="left">Docentes Vigentes Sede <div align="right"><strong>P&aacute;ginas&nbsp;:&nbsp;</strong>&nbsp;
                <%formulario.accesoPagina%></div> 
            </td>
          </tr>
          <tr>
            <td align="right">&nbsp;</td>
          </tr>
          <tr>
            <td align="left">
              <%formulario.dibujaTabla()%>
			  <% if carr_ccod <> "" then %>
              <input name="submit" type="submit" value="Guarda Docentes" onClick="verifica_check();">
   		      <%f_botonera.DibujaBoton("salir2")%>
			  <% end if%>
              
      <%if EsVacio(carr_ccod) or carr_ccod = "" then%> 
	  <br>Esta p&aacute;gina muestra la lista de los docentes vigentes en la sede. <br>
      Para visualizar los datos de un docente haga clic en un registro de la lista.<br>
      El bot&oacute;n &quot;Eliminar&quot; deja no vigente al docente seleccionado en la caja de chequeo.<br>
      Si el docente no existe en su sede puede agregarlo con el bot&oacute;n &quot;Agregar&quot;.<br>
	  <%end if%>
                                  <font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;</font>
                                  <div align="right"></div></td>
          </tr>
        </table>
      </form>
					
					
				  <!---<form action="proc_habilitacion_agregar.asp" method="post" name="form2" id="form2">
                    <input name="rut" type="hidden" id="rut" value="<%=rut%>">
                    <input name="dv" type="hidden" id="dv" value="<%=dv%>">
                  </form>-->  				  <br>				  </td>
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
                        <td><div align="center">
						<% 'f_botonera.DibujaBoton("agregar")
					if formulario.nrofilas()>0 then
						%>
						<% end if %>
</div></td>
                        <td><div align="center">
						  <%'f_botonera.DibujaBoton("eliminar")%>
                        </div></td>
                        <td><div align="center">
						  <% if carr_ccod = "" then 
						         f_botonera.DibujaBoton("salir")
							 end if%>
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