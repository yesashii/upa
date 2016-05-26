<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION				:	
'FECHA CREACIÓN				:
'CREADO POR					:
'ENTRADA					: NA
'SALIDA						: NA
'MODULO QUE ES UTILIZADO	: MANTENEDORES
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION		: 18/02/2013
'ACTUALIZADO POR			: Luis Herrera G.
'MOTIVO						: Corregir código, eliminar sentencia *=
'LINEA						: 77, 112
'********************************************************************

set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Mantenedor de Colegios"
'----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'response.End()
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "mantenedor_colegios.xml", "botonera"

'-----------------------------------------------------------------------
regi_ccod = request.querystring("busqueda[0][regi_ccod]")
ciud_ccod = request.querystring("busqueda[0][ciud_ccod]")
'ciud_tcomuna = request.querystring("busqueda[0][ciud_tcomuna]")
sin_ubicacion = request.querystring("busqueda[0][sin_ubicacion]")
nombre_colegio = request.querystring("busqueda[0][nombre_colegio]")
'response.Write(sin_ubicacion)
Region = conexion.consultauno("SELECT regi_tdesc FROM Regiones WHERE cast(regi_ccod as varchar)='" & regi_ccod&"'" )
Ciudad = conexion.consultauno("SELECT ciud_tcomuna FROM Ciudades WHERE cast(ciud_ccod as varchar)='" & ciud_ccod&"'"  )
Comuna = conexion.consultauno("SELECT ciud_tdesc FROM Ciudades WHERE cast(ciud_ccod as varchar)='" & ciud_ccod&"'"  )

'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "mantenedor_colegios.xml", "busqueda_nueva"
 f_busqueda.Inicializar conexion
 
 consulta="Select '"&regi_ccod&"' as regi_ccod, '"&ciud_ccod&"' as ciud_ccod, '"&sin_ubicacion&"' as sin_ubicacion, '"&nombre_colegio&"' as nombre_colegio"
 f_busqueda.consultar consulta

 consulta = " select a.regi_tdesc,a.regi_ccod,b.ciud_ccod, b.ciud_tdesc" & vbCrLf & _
			" from regiones a, ciudades b" & vbCrLf & _
			" where a.regi_ccod=b.regi_ccod "& vbCrLf & _
			" order by a.regi_ccod,ciud_tcomuna,ciud_tdesc"

'response.Write("<pre>"&consulta&"</pre>")	
 f_busqueda.inicializaListaDependiente "lBusqueda", consulta

 f_busqueda.Siguiente
  
'---------------------------------------------------------------------------------------------------
 set f_planes = new CFormulario
 f_planes.Carga_Parametros "mantenedor_colegios.xml", "f_colegios"
 f_planes.Inicializar conexion
 
 if sin_ubicacion ="N" or sin_ubicacion ="" then 
' consulta = " SELECT cole_ccod,cole_ccod as cole_ccod2,cole_tdesc,tcol_tdesc," & vbCrLf &_
' 			" (select case count(*) when 0 then 'No' else 'Sí '+ cast(count(*) as varchar) + ' persona(s)' end  " & vbCrLf &_
'  			" from ( select distinct pers_ncorr from personas_postulante pp where pp.cole_ccod= a.cole_ccod " & vbCrLf &_
'			" union  " & vbCrLf &_
'			"        select distinct pers_ncorr_alumno from personas_eventos_upa pp where pp.cole_ccod= a.cole_ccod)aa ) as con_personas " & vbCrLf &_
'            " FROM colegios a, Tipos_Colegios b " & vbCrLf &_
'		    " WHERE  cast(CIUD_CCOD as varchar) ='" & ciud_ccod & "'" & vbCrLf &_
'			" and a.tcol_ccod*=b.tcol_ccod and a.cole_tdesc like '%"&nombre_colegio&"%'"& vbCrLf &_
'			" ORDER BY cole_tdesc"
consulta = "select cole_ccod, " & vbCrLf &_
	"	cole_ccod as cole_ccod2, " & vbCrLf &_
	"	cole_tdesc,tcol_tdesc, " & vbCrLf &_
	"	( " & vbCrLf &_
	"		select case count(*) " & vbCrLf &_
	"			when 0 " & vbCrLf &_
	"			then 'No' " & vbCrLf &_
	"			else 'Sí '+ cast(count(*) as varchar) + ' persona(s)' " & vbCrLf &_
	"		end " & vbCrLf &_ 
	"		from " & vbCrLf &_ 
	"			( " & vbCrLf &_
	"				select distinct pers_ncorr " & vbCrLf &_
	"				from personas_postulante pp " & vbCrLf &_
	"				where pp.cole_ccod= a.cole_ccod " & vbCrLf &_
	"				union  " & vbCrLf &_
	"				select distinct pers_ncorr_alumno " & vbCrLf &_
	"				from personas_eventos_upa pp " & vbCrLf &_
	"				where pp.cole_ccod= a.cole_ccod " & vbCrLf &_
	"			)aa " & vbCrLf &_
	"	) as con_personas " & vbCrLf &_
	"from colegios a " & vbCrLf &_
	"	left outer join Tipos_Colegios b " & vbCrLf &_
	"	on a.tcol_ccod=b.tcol_ccod " & vbCrLf &_
	"where  cast(CIUD_CCOD as varchar) ='" & ciud_ccod & "'" & vbCrLf &_
	"	and a.cole_tdesc like '%"&nombre_colegio&"%'"& vbCrLf &_
	"order by cole_tdesc " 			
 else
'consulta = " SELECT cole_ccod,cole_ccod as cole_ccod2,cole_tdesc,tcol_tdesc," & vbCrLf &_
'           " (select case count(*) when 0 then 'No' else 'Sí '+ cast(count(*) as varchar)  + ' persona(s)' end  " & vbCrLf &_
' 			" from ( select distinct pers_ncorr from personas_postulante pp where pp.cole_ccod= a.cole_ccod " & vbCrLf &_
'			" union  " & vbCrLf &_
'			"        select distinct pers_ncorr_alumno from personas_eventos_upa pp where pp.cole_ccod= a.cole_ccod)aa ) as con_personas " & vbCrLf &_
'            " FROM colegios a, Tipos_Colegios b " & vbCrLf &_
'		    " WHERE a.tcol_ccod *= b.tcol_ccod and a.cole_tdesc like '%"&nombre_colegio&"%'"& vbCrLf &_
'			" ORDER BY cole_tdesc"
consulta = "select cole_ccod,cole_ccod as cole_ccod2, "& vbCrLf &_
"	cole_tdesc, "& vbCrLf &_
"	tcol_tdesc, "& vbCrLf &_
"	( "& vbCrLf &_
"		select case count(*) "& vbCrLf &_
"			when 0 "& vbCrLf &_
"			then 'No' "& vbCrLf &_
"			else 'Sí '+ cast(count(*) as varchar)  + ' persona(s)' "& vbCrLf &_
"		end "& vbCrLf &_ 
"		from "& vbCrLf &_
"		( "& vbCrLf &_
"			select distinct pers_ncorr "& vbCrLf &_
"			from personas_postulante pp "& vbCrLf &_
"			where pp.cole_ccod = a.cole_ccod "& vbCrLf &_
"			union "& vbCrLf &_ 
"			select distinct pers_ncorr_alumno "& vbCrLf &_
"			from personas_eventos_upa pp "& vbCrLf &_
"			where pp.cole_ccod = a.cole_ccod "& vbCrLf &_
"		)aa "& vbCrLf &_
"	) as con_personas "& vbCrLf &_
"from colegios a "& vbCrLf &_
"left outer join Tipos_Colegios b "& vbCrLf &_
"on a.tcol_ccod = b.tcol_ccod "& vbCrLf &_
"where a.cole_tdesc like '%"&nombre_colegio&"%'"& vbCrLf &_
"order by cole_tdesc "

 end if
			
'response.Write("<pre>"&consulta&"</pre>")

 f_planes.Consultar consulta
 
		 
consulta = "SELECT CIUD_CCOD,ciud_tcomuna, REGI_CCOD  FROM ciudades order by ciud_tdesc"
conexion.Ejecuta consulta
set rec_comunas = conexion.ObtenerRS



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
function cargar()
{
  buscador.action="Especialidades.asp?busqueda[0][regi_ccod]=" + document.buscador.elements["busqueda[0][regi_ccod]"].value;
  buscador.method="POST";
  buscador.submit();
}


arr_comunas = new Array();

<%
rec_comunas.MoveFirst
i = 0
while not rec_comunas.Eof
%>
arr_comunas[<%=i%>] = new Array();
arr_comunas[<%=i%>]["ciud_ccod"] = '<%=rec_comunas("ciud_ccod")%>';
//arr_comunas[<%=i%>]["ciud_tcomuna"] = '<%=rec_comunas("ciud_tcomuna")%>';
arr_comunas[<%=i%>]["regi_ccod"] = '<%=rec_comunas("regi_ccod")%>';
<%	
	rec_comunas.MoveNext
	i = i + 1
wend
%>

function CargarComunas(formulario, regi_ccod)
{
	formulario.elements["busqueda[0][ciud_ccod]"].length = 0;
	op = document.createElement("OPTION");
	op.value = "-1";
	op.text = "Seleccione Una Comuna";
	formulario.elements["busqueda[0][ciud_ccod]"].add(op)
	for (i = 0; i < arr_comunas.length; i++)
	  { 
		if (arr_comunas[i]["regi_ccod"] == regi_ccod)
		 {
			op = document.createElement("OPTION");
			op.value = arr_comunas[i]["ciud_ccod"];
			//op.text = arr_comunas[i]["ciud_tcomuna"];
			formulario.elements["busqueda[0][ciud_ccod]"].add(op)			
		 }
	}	
}

function inicio()
{
  <%if regi_ccod <> "" then%>
    CargarComunas(buscador, <%=regi_ccod%>);
	buscador.elements["busqueda[0][ciud_ccod]"].value ='<%=ciud_ccod%>'; 
  <%end if%>
}



</script>
<% f_busqueda.generaJS %>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
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
                            <table width="100%" border="0">
                              <tr> 
                                <td width="11%"><div align="left">Regi&oacute;n</div></td>
                                <td width="3%"><div align="center">:</div></td>
                                <td width="20%"><% f_busqueda.dibujaCampoLista "lBusqueda", "regi_ccod"%></td>
								<td width="30%" align="right">&nbsp;</td>
                                <td width="2%">&nbsp;</td>
                                <td><%' f_busqueda.dibujaCampoLista "lBusqueda", "ciud_tcomuna"%></td>
							 </tr>
							 <tr> 
                                <td width="11%"><div align="left">Comuna</div></td>
                                <td width="3%"><div align="center">:</div></td>
                                <td width="20%"><% f_busqueda.dibujaCampoLista "lBusqueda", "ciud_ccod"%></td>
								<td width="30%" align="right"><div align="right">Sólo por nombre</div></td>
                                <td width="2%"><div align="center">:</div></td>
                                <td><% f_busqueda.dibujaCampo("sin_ubicacion")%></td>
                              </tr>
							  <tr> 
                                <td width="11%"><div align="left">Colegio</div></td>
                                <td width="3%"><div align="center">:</div></td>
                                <td colspan="4"><% f_busqueda.dibujaCampo("nombre_colegio")%></td>
                              </tr>
                            </table>
                          </div></td>
                  <td width="19%"><div align="center"><%botonera.DibujaBoton "buscar"%></div></td>
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
            <td><div align="center">
                    <br> <%if region <> "" then%>
                    <table width="100%" border="0">
                      <!--DWLayoutTable-->
                      <tr>
                        <td width="5%"><strong>Regi&oacute;n</strong></td>
						<td width="2%"><strong>:</strong></td>
						<td width="93%"><strong><%=Region%></strong></td>
                      </tr>
					  <tr>
                        <td width="5%"><strong>Ciudad</strong></td>
						<td width="2%"><strong>:</strong></td>
						<td width="93%"><strong><%=ciudad%></strong></td>
                      </tr>
					  <tr>
                        <td width="5%"><strong>Comuna</strong></td>
						<td width="2%"><strong>:</strong></td>
						<td width="93%"><strong><%=Comuna%></strong></td>
                      </tr>
                    </table> 
                    <%end if%>
                    <br>
                  </div>
              <form name="edicion">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><div align="center"> 
                            <%pagina.DibujarTituloPagina%>
                            <br>
                            <table width="650" border="0">
                              <tr> 
                                <td width="116">&nbsp;</td>
                                <td width="511"><div align="right">P&aacute;ginas: 
                                    &nbsp; 
                                    <%f_planes.AccesoPagina%>
                                  </div></td>
                                <td width="24"> <div align="right"> </div></td>
                              </tr>
                            </table>                          
                            <% f_planes.DibujaTabla()%>
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
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"> 
                            <% if regi_ccod <> "" and ciud_ccod <> "" then
							      botonera.AgregaBotonParam "nueva" , "deshabilitado", "FALSE"
							   else
							     botonera.AgregaBotonParam "nueva" , "deshabilitado", "TRUE"
							   end if
							   botonera.AgregaBotonParam "nueva", "url", "Colegios_Agregar.asp?ciud_ccod=" & ciud_ccod&"&regi_ccod="&regi_ccod
							   botonera.DibujaBoton "nueva"
							%>
                          </div></td>
                  <td><div align="center">
                            <% if regi_ccod <> "" and ciud_ccod <> "" then
							      botonera.AgregaBotonParam "eliminar" , "deshabilitado", "FALSE"
							   else
							     botonera.AgregaBotonParam "eliminar" , "deshabilitado", "TRUE"
							   end if
							   botonera.DibujaBoton "eliminar"%>				  
                          </div></td>
                  <td><div align="center"><%botonera.DibujaBoton "lanzadera"%></div></td>
				  <td><div align="center"><%    if regi_ccod <> "" then
													botonera.agregaBotonParam "excel","url","colegios_excel.asp?regi_ccod="&regi_ccod&"&ciud_ccod="&ciud_ccod&"&sin_ubicacion="&sin_ubicacion&"&nombre_colegio="&nombre_colegio
													botonera.DibujaBoton "excel"
												end if
										  %></div></td>
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
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
