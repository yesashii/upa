<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION				      :	
'FECHA CREACIÓN			      :
'CREADO POR					      :
'ENTRADA					        : NA
'SALIDA						        : NA
'MODULO QUE ES UTILIZADO	: CONTRATOS DOCENTES
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION		: 01/03/2013
'ACTUALIZADO POR			  : Luis Herrera G.
'MOTIVO						      : Corregir código, eliminar sentencia *=
'LINEA						      : 115, 118
'NOTAS                            : en la linea 220 el sistema presenta un error exta (ver observaciones de minuta)
'********************************************************************
set errores = new CErrores
set pagina = new CPagina
pagina.Titulo = "Contratacion de Docentes"
'----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "Contratacion_docentes.xml", "botonera"

'-----------------------------------------------------------------------
rut= request.querystring("busqueda[0][pers_nrut]")
dv=request.QueryString("busqueda[0][pers_xdv]")
carr_ccod = request.querystring("busqueda[0][carr_ccod]")
'response.write("-------> "&carr_ccod)
carr_ccod = request.QueryString("carr_ccod")
'response.Write("carr_select "& carr_select&"--ww carr_nuevo "&carr_ccod)
carr_select=carr_ccod
dim Jornada2
IF LEN(carr_ccod) = 3 THEN 
	Jornada2=RIGHT(carr_ccod,1)
	carr_ccod= MID(carr_ccod,1,LEN(carr_ccod)-2)
elseif LEN(carr_ccod) = 4 then
	Jornada2=RIGHT(carr_ccod,1)
	carr_ccod= MID(carr_ccod,1,LEN(carr_ccod)-1)
END IF

sede_ccod = negocio.obtenersede

carrera = conexion.consultauno("SELECT carr_tdesc FROM carreras WHERE carr_ccod = '" & carr_ccod & "'")
'

'----------------------------------------------------------------------- 
 set f_busqueda = new CFormulario
 f_busqueda.Carga_Parametros "Contratacion_docentes.xml", "f_busqueda"
 
 f_busqueda.Inicializar conexion
 f_busqueda.Consultar "select ''"
 	if  EsVacio(espe_ccod) then
  		f_busqueda.Agregacampoparam "espe_ccod", "filtro" , "1=2"
	else
		f_busqueda.Agregacampoparam "espe_ccod", "filtro" , "carr_ccod ='"&carr_ccod&"'"
		 f_busqueda.AgregaCampoCons "espe_ccod", espe_ccod 
	end if
 'response.write("==> " &  carr_select)
 f_busqueda.AgregaCampoCons "carr_ccod", carr_select
 f_busqueda.Siguiente 
 

 'ultimo = carr_ccod

'---------------------------------------------------------------------------------------------------
sede_ccod = negocio.obtenersede
set formulario = new cformulario

formulario.carga_parametros "busca_docentes.xml", "filtro_docentes2"
'formulario.carga_parametros "contratacion_docentes.xml", "filtro_docentes2"

formulario.inicializar conexion 'conectar
'consulta= " select distinct " &vbCrlf &_
'		  " a.pers_ncorr, cast(a.pers_nrut as varchar)+ '-' + cast(a.pers_xdv as varchar)  as rut, " &vbCrlf &_
'		  " cast(a.pers_tape_paterno as varchar) + ' ' +  cast(a.PERS_TAPE_MATERNO as varchar)+ ' ' + cast(a.pers_tnombre as varchar) as nom, " &vbCrlf &_
'		  " b.*,a.pais_ccod" &vbCrlf &_
'		  " , ( " &vbCrlf &_		  		  
'		  " select count(AA.BLOQ_CCOD) from BLOQUES_PROFESORES AA, BLOQUES_horarios BB, secciones CC " &vbCrlf &_		  
'		  " where AA.PERS_NCORR=c.pers_ncorr  " &vbCrlf &_		  		  
'		  " and BB.BLOQ_CCOD=AA.BLOQ_CCOD " &vbCrlf &_		  		  
'  		  " and CC.SECC_CCOD = BB.SECC_CCOD " &vbCrlf &_		  		  
'		  " and Cast(CC.CARR_CCOD AS VARCHAR)='"&carr_ccod&"' " &vbCrlf &_		  		  		  	  
'		  " AND AA.CDOC_NCORR IS NULL) AS PENDIENTES, " &vbCrlf &_		  
'		  " D.TCAT_VALOR, " &vbCrlf &_		  
'		  " (select count(AA.BLOQ_CCOD) from BLOQUES_PROFESORES AA, BLOQUES_horarios BB, secciones CC  " &vbCrlf &_		  		  
' 		  " where AA.PERS_NCORR=c.pers_ncorr  " &vbCrlf &_		  
' 		  " and BB.BLOQ_CCOD=AA.BLOQ_CCOD " &vbCrlf &_		  
' 		  " and CC.SECC_CCOD = BB.SECC_CCOD " &vbCrlf &_		  		  
'		  " and Cast(CC.CARR_CCOD AS VARCHAR)='"&carr_ccod&"' " &vbCrlf &_		  		  		  	  
' 		  " AND AA.CDOC_NCORR IS NOT NULL) AS CALCULADOS, " &vbCrlf &_		  
'		  " (SELECT count(distinct BLOQ_ANEXO) FROM BLOQUES_PROFESORES " &vbCrlf &_
'		  " WHERE PERS_NCORR=c.pers_ncorr and BLOQ_ANEXO IS NOT NULL and BLOQ_CCOD in( " &vbCrlf &_
'		  " select BLOQ_CCOD FROM BLOQUES_horarios A, secciones B where " &vbCrlf &_
'		  " A.SECC_CCOD = B.SECC_CCOD and CAST(B.CARR_CCOD as VARCHAR)='"&carr_ccod&"')) AS ANEXOSE,  " &vbCrlf &_
' 		  " (SELECT max(BLOQ_ANEXO) FROM BLOQUES_PROFESORES WHERE PERS_NCORR=C.PERS_NCORR and BLOQ_ANEXO IS NOT NULL) AS ANEXOST, " &vbCrlf &_		  		  		  
' 		  " (select DUAS_TDESC from DURACION_ASIGNATURA where DUAS_CCOD in( " &vbCrlf &_		  		  		  		  
' 		  " 	select max(DUAS_CCOD) as DUAS_CCOD from asignaturas where ASIG_CCOD in( " &vbCrlf &_		  		  		  		  
' 		  " 			select ASIG_CCOD from secciones where SECC_CCOD in( " &vbCrlf &_		  		  		  		  
' 		  " 						select SECC_CCOD from BLOQUES_horarios where BLOQ_CCOD in( " &vbCrlf &_		  		  		  		  
' 		  " 										select BLOQ_CCOD from BLOQUES_PROFESORES where PERS_NCORR=C.PERS_NCORR "&vbCrlf &_		  		  		  		  		  
' 		  "))))) as DUAS_TDESC" &vbCrlf &_		  		  		  		  
' 		  " from " &vbCrlf &_
' 		  " personas a , CARRERAS_DOCENTE b, BLOQUES_PROFESORES c, TIPOS_CATEGORIA D" &vbCrlf &_
' 		  " where " &vbCrlf &_
' 		  " a.pers_ncorr=b.pers_ncorr " &vbCrlf &_
' 		  " and b.pers_ncorr *=c.pers_ncorr " &vbCrlf &_		  
' 		  " --and  isnull(C.BPRO_MVALOR,0) >0" &vbCrlf &_		  		  
'		  " AND CAST(B.CARR_CCOD AS VARCHAR)='" & carr_ccod & "'" &vbCrlf &_
'		  " and D.TCAT_CCOD =* B.TCAT_CCOD" &vbCrlf &_
'		  " AND CAST(B.JORN_CCOD AS VARCHAR)='" & Jornada2 & "'" &vbCrlf &_		  		  		  
'   		  " AND B.sede_ccod =" & sede_ccod & vbCrlf &_		  		  		  
'		  " order by nom"

'---------------------------------------------------------------------------------------------------------------------Inicio onsulta Actualizada
consulta= "select distinct a.pers_ncorr, " &vbCrlf &_ 
"                cast(a.pers_nrut as varchar) + '-' " &vbCrlf &_ 
"                + cast(a.pers_xdv as varchar)         as rut, " &vbCrlf &_ 
"                cast(a.pers_tape_paterno as varchar) + ' ' " &vbCrlf &_ 
"                + cast(a.pers_tape_materno as varchar) + ' ' " &vbCrlf &_ 
"                + cast(a.pers_tnombre as varchar)     as nom, " &vbCrlf &_ 
"                b.*, " &vbCrlf &_ 
"                a.pais_ccod, " &vbCrlf &_ 
"                (select count(aa.bloq_ccod) " &vbCrlf &_ 
"                 from   bloques_profesores as aa " &vbCrlf &_ 
"                        join bloques_horarios as bb " &vbCrlf &_ 
"                          on bb.bloq_ccod = aa.bloq_ccod " &vbCrlf &_ 
"                        join secciones as cc " &vbCrlf &_ 
"                          on cc.secc_ccod = bb.secc_ccod " &vbCrlf &_ 
"                             and cast(cc.carr_ccod as varchar) ='"&carr_ccod&"' " &vbCrlf &_
"                             and aa.cdoc_ncorr is null " &vbCrlf &_ 
"                 where  aa.pers_ncorr = c.pers_ncorr) as pendientes, " &vbCrlf &_ 
"                d.tcat_valor, " &vbCrlf &_ 
"                (select count(aa.bloq_ccod) " &vbCrlf &_ 
"                 from   bloques_profesores as aa " &vbCrlf &_ 
"                        join bloques_horarios as bb " &vbCrlf &_ 
"                          on bb.bloq_ccod = aa.bloq_ccod " &vbCrlf &_ 
"                             and aa.cdoc_ncorr is not null " &vbCrlf &_ 
"                        join secciones as cc " &vbCrlf &_ 
"                          on cc.secc_ccod = bb.secc_ccod " &vbCrlf &_ 
"                             and cast(cc.carr_ccod as varchar) = '"&carr_ccod&"' " &vbCrlf &_ 
"                 where  aa.pers_ncorr = c.pers_ncorr) as calculados, " &vbCrlf &_ 
"                (select count(distinct bloq_anexo) " &vbCrlf &_ 
"                 from   bloques_profesores " &vbCrlf &_ 
"                 where  pers_ncorr = c.pers_ncorr " &vbCrlf &_ 
"                        and bloq_anexo is not null " &vbCrlf &_ 
"                        and bloq_ccod in(select bloq_ccod " &vbCrlf &_ 
"                                         from   bloques_horarios as a " &vbCrlf &_ 
"                                                join secciones as b " &vbCrlf &_ 
"                                                  on a.secc_ccod = b.secc_ccod " &vbCrlf &_ 
"                                                     and cast(b.carr_ccod as " &vbCrlf &_      
"                                                              varchar) = '"&carr_ccod&"' " &vbCrlf &_
"															  )) " &vbCrlf &_ 
"                                                      as anexose, " &vbCrlf &_ 
"                (select max(bloq_anexo) " &vbCrlf &_ 
"                 from   bloques_profesores " &vbCrlf &_ 
"                 where  pers_ncorr = c.pers_ncorr " &vbCrlf &_ 
"                        and bloq_anexo is not null)   as anexost, " &vbCrlf &_ 
"                (select duas_tdesc " &vbCrlf &_ 
"                 from   duracion_asignatura " &vbCrlf &_ 
"                 where  duas_ccod in(select max(duas_ccod) as duas_ccod " &vbCrlf &_ 
"                                     from   asignaturas " &vbCrlf &_ 
"                                     where  asig_ccod in(select asig_ccod " &vbCrlf &_ 
"                                                         from   secciones " &vbCrlf &_ 
"                                                         where " &vbCrlf &_ 
"                                            secc_ccod in(select secc_ccod " &vbCrlf &_ 
"                                                         from " &vbCrlf &_ 
"                                            bloques_horarios " &vbCrlf &_ 
"                                                         where " &vbCrlf &_ 
"                                            bloq_ccod in(select " &vbCrlf &_ 
"                                            bloq_ccod " &vbCrlf &_ 
"                                                         from " &vbCrlf &_ 
"                                            bloques_profesores " &vbCrlf &_ 
"                                                         where " &vbCrlf &_ 
"                                            pers_ncorr = c.pers_ncorr))))) " &vbCrlf &_ 
"                                                      as duas_tdesc " &vbCrlf &_ 
"from   personas as a " &vbCrlf &_ 
"       join carreras_docente as b " &vbCrlf &_ 
"         on a.pers_ncorr = b.pers_ncorr " &vbCrlf &_ 
"            --and  isnull(C.BPRO_MVALOR,0) >0 " &vbCrlf &_   
"            and cast(b.carr_ccod as varchar) = '" & carr_ccod & "' " &vbCrlf &_ 
"       left outer join bloques_profesores as c " &vbCrlf &_ 
"                    on b.pers_ncorr = c.pers_ncorr " &vbCrlf &_ 
"       left outer join tipos_categoria as d " &vbCrlf &_ 
"                    on b.tcat_ccod = d.tcat_ccod " &vbCrlf &_ 
"where  cast(b.jorn_ccod as varchar) = '" & Jornada2 & "' " &vbCrlf &_ 
"       and b.sede_ccod = " & sede_ccod & vbCrlf &_	
"order  by nom "
'---------------------------------------------------------------------------------------------------------------------Fin consulta actualizada
	   
'response.Write("<pre>"& consulta & "</pre>")
'response.End()
formulario.consultar consulta

 MyStr = "SELECT DISTINCT A.CARR_CCOD, A.CARR_TDESC + ' '  + case C.JORN_CCOD WHEN 1 THEN '(D)' ELSE '(V)' END AS CARR_TDESC "
 MyStr = MyStr & " FROM CARRERAS A, ESPECIALIDADES B, OFERTAS_ACADEMICAS C "
 MyStr = MyStr & " WHERE "
 MyStr = MyStr & " A.CARR_CCOD = B.CARR_CCOD "
 MyStr = MyStr & " AND B.ESPE_CCOD = C.ESPE_CCOD "
 MyStr = MyStr & " AND C.ESPE_CCOD IS NOT NULL "
 MyStr = MyStr & " AND C.SEDE_CCOD = " & sede_ccod
 MyStr = MyStr & " ORDER BY CARR_TDESC,a.carr_ccod " 
 
' RESPONSE.Write( MyStr)
set f_detalle_mat  = new cformulario
f_detalle_mat.carga_parametros "Habilitacion_docentes.xml", "f_detalle_serv"
f_detalle_mat.inicializar conexion							
f_detalle_mat.consultar MyStr
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


function verifica_check(){
   nro = document.edicion.elements.length;
   num =0;
   for( i = 0; i < nro; i++ ) {
	  comp = document.edicion.elements[i];
	  str  = document.edicion.elements[i].name;
	  if((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo') && (comp.name != 'Cerrar') && (comp.name != 'Indefinido') && (comp.name != 'HorasC')){
	     num += 1;
//		 alert(document.edicion.Cerrar.checked);
//		 alert(document.edicion.Porcentaje.value);
//		if (comp.name != 'Cerrar'){
		 window.open("../REPORTESNET/contrato_docente.aspx?pers_ncorr="+ document.edicion.elements[i].value+"&Cerrar="+document.edicion.Cerrar.checked+"&fechai="+document.edicion.finicio.value+"&fechaf="+document.edicion.ffin.value+"&fechaf1="+document.edicion.ffin1.value+"&Indefinido="+document.edicion.Indefinido.checked+"&HorasC="+document.edicion.HorasC.checked+"&Porcentaje="+document.edicion.Porcentaje.value+"&MontoMC="+document.edicion.MontoMC.value);
//		 }
	  }
   }
   if( num == 0 ) {
//		if(confirm('Ud. ha seleccionado '+ num +' registros para . ¿Desea continuar?')){
//			return true;
//		}
//		else{
//			return false;
//		}
//   }
//   else{
      alert('Ud. no ha seleccionado ningún registro para Imprimir');
	  return false;
   }	
}
</script>

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
                              <!--DWLayoutTable-->
                              <tr> 
                                <td><div align="left">Carrera</div></td>
                                <td><div align="center">:</div></td>
                                <td width="414">
                                  <% 'f_busqueda.dibujaCampo ("carr_ccod") %>
                                  <select name="carr_ccod">
								 <%  while f_detalle_mat.Siguiente 
								 if right(f_detalle_mat.ObtenerValor("CARR_TDESC"),3)="(D)" then
									 Jornada=1
								else
									 Jornada=2								
								end if								
								 
								 IF f_detalle_mat.ObtenerValor("CARR_CCOD") & Jornada = carr_ccod & " " & Jornada2 then
								 %>								
                                  <option value="<%=f_detalle_mat.ObtenerValor("CARR_CCOD")&Jornada%>" selected><%=f_detalle_mat.ObtenerValor("CARR_TDESC")%> </option> 								  
								  <% else %>
									<option value="<%=f_detalle_mat.ObtenerValor("CARR_CCOD")&Jornada%>"><%=f_detalle_mat.ObtenerValor("CARR_TDESC")%> </option> 								  								  
								 <%  
								 end if
								 wend %>								  
                                  </select>
                                  <%'<input type="hidden" name="carr_ccod"  value="<%=carr_ccod & " " & Jornada2">%>
								  
                                </td>
                              </tr>
                              <tr> 
                                <td width="15%" height="20"><div align="left"></div></td>
                                <td width="4%"><div align="center"></div></td>
                                <td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
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
                    <br> <%if carrera <> "" then%>
                    <table width="100%" border="0">
                      <tr>
                        <td><table width="99%" border="0" align="left" cellpadding="0" cellspacing="0">
  <tr> 
    <td width="16%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">Carrera</font></b></font></td>
    <td width="3%"><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2">: 
        </font></b></font></div></td>
    <td width="81%"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b><font color="#666677" size="2"><%=carrera%></font></b></font></td>
  </tr>
  <tr> 
    <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b></b></font></td>
    <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b></b></font></div></td>
    <td><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><b></b></font></td>
  </tr>
  <tr> 
    <td height="0" colspan="3"><font color="#666677"><img src="../imagenes/linea.gif" width="100%" height="9"></font></td>
  </tr>
</table></td>
                      </tr>
                    </table> <%end if%>
                    <br>
                  </div>
              <form name="edicion" method="post" action="proc_contratacion_calcular.asp?carr_ccod=<%=carr_ccod%>&JORN_CCOD=<%=Jornada2%>&sede_ccod=<%=sede_ccod%>">
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <!--DWLayoutTable-->
                  <tr>
                    <td height="60" colspan="5"><div align="center"> 
                            <%pagina.DibujarTituloPagina%>
                            <br>
                            <table width="650" border="0">
                              <tr> 
                                <td width="116">&nbsp;</td>
                                <td width="511"><div align="right">P&aacute;ginas: 
                                    &nbsp; 
                                    <%formulario.AccesoPagina%>
                                  </div></td>
                                <td width="24"> <div align="right"> </div></td>
                              </tr>
                            </table>                          
                            <%formulario.dibujaTabla()%>
</div></td>
                    <td width="1"></td>
                  </tr>
                  <tr>
                    <td width="120" rowspan="2" valign="top"><div align="center">                            
                            <% 
														if carr_ccod <> "" then 
							                            response.write("<input name='submit' type='submit' value='Calcular'>")
														end if
														%>
                            <br>
                        </div>
                    </td>
                  <td width="193" rowspan="2" valign="top"><div align="right">
                       <%dim fini, ffin, ffin1
						   fini="01/07/"&year(date)						   
						   ffin1="31/07/"&year(date)
						   ffin="30/09/"&year(date)						   
					   %>
					    F. Inicio 
                        <input name="finicio" type="text" id="finicio" size="11" maxlength="10" value="<%=fini%>">
                  </div>
                  </td>
                  <td width="128" height="18" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
                  <td width="73" rowspan="2" valign="top"><!--DWLayoutEmptyCell-->&nbsp;                    </td>
                  <td width="136" rowspan="3" valign="top"><div align="center">
                            <% 
														if carr_ccod <> "" then %>
					                                    <input name='submit' type='button' value='Imprimir' onClick="verifica_check();">
												        <%end if
														%>
                  </div>
                  </td>
                  <td></td>
                  </tr>
                  <tr>
                    <td rowspan="3" valign="top">                          <div align="right">%</div></td>
                  <td height="1"></td>
                  </tr>
                  <tr>
                    <td rowspan="2" valign="top">
                      <div align="right">
                        NO Horas Coor.
                           <input name="HorasC" type="checkbox" id="HorasC" value="checkbox">
</div>
                    </td>
                  <td rowspan="2" valign="top"><div align="right">
                        F.fin 1S.
                          <input name="ffin1" type="text" id="ffin1" size="11" maxlength="10" value="<%=ffin1%>">
                    </div>
                  </td>
                    <td rowspan="2" valign="top"><input name="Porcentaje" type="text" id="Porcentaje" value="75%" size="7" maxlength="4"></td>
                    <td height="1"></td>
                  </tr>
                  <tr>
                    <td height="17" valign="top"><div align="center">
                          <input name="Cerrar" type="checkbox" id="Cerrar" value="checkbox">
                        Cerrar</div>
                    </td>
                    <td></td>
                  </tr>
                  <tr>
                    <td height="18" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
                  <td valign="top"><div align="right">F. Fin
                          <input name="ffin" type="text" id="ffin2" size="11" maxlength="10" value="<%=ffin%>">
					        </div>
                  </td>
                  <td valign="top"><div align="right">Monto M. C.</div></td>
                  <td valign="top"><input name="MontoMC" type="text" id="MontoMC" value="0" size="8" maxlength="8"></td>
                  <td valign="top"><div align="center">                            
                            <input type="checkbox" name="Indefinido" value="checkbox">
                            C. Indefinido<br>
                        </div>
                  </td>
                  <td></td>
                  </tr>
                  <tr>
                    <td height="0"></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
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
                          </div></td>
                  <td><div align="center">                            				  
                          </div></td>
                  <td><div align="center"><%botonera.DibujaBoton "lanzadera"%></div></td>
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
