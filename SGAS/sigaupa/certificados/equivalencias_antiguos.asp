<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
matr_ncorr = Request.QueryString("matr_ncorr")
secc_ccod  = Request.QueryString("secc_ccod")
asig_ccod1  = Request.QueryString("asig_ccod")
pers_nrut  = Request.QueryString("pers_nrut")
plan_ccod  = Request.QueryString("plan_ccod")
espe_ccod  = Request.QueryString("espe_ccod")
carr_ccod  = Request.QueryString("carr_ccod")
'response.Write("matr_ncorr= "&matr_ncorr&" secc_ccod= "&secc_ccod&" asig_ccod1= "&asig_ccod1&" <br>pers_nrut= "&pers_nrut&" plan_ccod= "&plan_ccod&" espe_ccod= "&espe_ccod&" carr_ccod= "&carr_ccod)
set pagina = new CPagina
pagina.Titulo = "Mantenedor de Equivalencias"



cons_historico="select a.asig_ccod,asig.asig_tdesc, asig.asig_tdesc + ' - '+ cast(a.asig_ccod as varchar) as asig_tdesc2 " & vbCrLf  & _
                  "	 from (  " & vbCrLf  & _
				   "	 select ma.nive_ccod, asig_ccod,esp.carr_ccod  " & vbCrLf  & _
			  	   "	 from especialidades esp, planes_estudio pl, malla_curricular ma  " & vbCrLf  & _
				   "	 where esp.espe_ccod=pl.espe_ccod  " & vbCrLf  & _
				   "	  and pl.plan_ccod=ma.plan_ccod  " & vbCrLf  & _
				   "	  and cast(pl.plan_ccod as varchar)='"&plan_ccod&"') a left outer join" & vbCrLf  & _
				   "	  (	  " & vbCrLf  & _
				   "	  select h.asig_ccod,a.sitf_ccod,a.carg_nnota_final,g.peri_ccod " & vbCrLf  & _
				   "		from  " & vbCrLf  & _
				   "			 cargas_academicas a, " & vbCrLf  & _
				   "			 alumnos b, " & vbCrLf  & _
				   "			 personas c, " & vbCrLf  & _
				   "			 ofertas_academicas d " & vbCrLf  & _
				   "			 ,planes_estudio e " & vbCrLf  & _
				   "			 ,especialidades f " & vbCrLf  & _
				   "			 ,secciones g " & vbCrLf  & _
				   "			 ,asignaturas h " & vbCrLf  & _
				   "		where  " & vbCrLf  & _
				   "			  a.matr_ncorr=b.matr_ncorr " & vbCrLf  & _
				   "			  and b.pers_ncorr=c.pers_ncorr " & vbCrLf  & _
				   "			  and b.ofer_ncorr=d.ofer_ncorr " & vbCrLf  & _
				   "			  and b.plan_ccod=e.plan_ccod " & vbCrLf  & _
				   "			  and e.espe_ccod=f.espe_ccod " & vbCrLf  & _
				   "			  and a.secc_ccod=g.secc_ccod " & vbCrLf  & _
				   "			  and g.asig_ccod=h.asig_ccod " & vbCrLf  & _
				   "			  and b.emat_ccod=1 " & vbCrLf  & _
				   "			  and cast(pers_nrut as varchar)='"&pers_nrut&"' " & vbCrLf  & _
				   "			  and cast(f.carr_ccod as varchar)='"&carr_ccod&"' " & vbCrLf  & _
				   "			  and cast(a.sitf_ccod as varchar) not in ('EE','EQ','NN') " & vbCrLf  & _
				   "		union   " & vbCrLf  & _
				   "		select  " & vbCrLf  & _
				   "			 a.asig_ccod,sitf_ccod,isnull(a.conv_nnota,0) as nota,e.peri_ccod " & vbCrLf  & _
				   "		from  " & vbCrLf  & _
				   "			 convalidaciones a " & vbCrLf  & _
				   "			 , alumnos b " & vbCrLf  & _
				   "			 ,personas c " & vbCrLf  & _
				   "			 , actas_convalidacion d " & vbCrLf  & _
				   "			 , ofertas_academicas e " & vbCrLf  & _
				   "			 , planes_estudio f " & vbCrLf  & _
				   "			 ,especialidades g " & vbCrLf  & _
				   "		where " & vbCrLf  & _
				   "			 a.matr_ncorr=b.matr_ncorr " & vbCrLf  & _
				   "			 and b.pers_ncorr=c.pers_ncorr " & vbCrLf  & _
				   "			 and a.acon_ncorr=d.acon_ncorr " & vbCrLf  & _
				   "			 and b.ofer_ncorr=e.ofer_ncorr " & vbCrLf  & _
				   "			 and b.plan_ccod=f.plan_ccod " & vbCrLf  & _
				   "			 and f.espe_ccod=g.espe_ccod " & vbCrLf  & _
				   "			 and cast(g.carr_ccod as varchar)='"&carr_ccod&"' " & vbCrLf  & _
				   "			 and cast(c.pers_nrut as varchar)='"&pers_nrut&"' " & vbCrLf  & _
				   "		union " & vbCrLf  & _
				   "		select " & vbCrLf  & _
				   "			  a.asig_ccod,b.sitf_ccod,b.carg_nnota_final,d.peri_ccod " & vbCrLf  & _
				   "		from " & vbCrLf  & _
				   "			equivalencias a " & vbCrLf  & _
				   "			, cargas_academicas b " & vbCrLf  & _
				   "			, secciones c " & vbCrLf  & _
				   "			, ofertas_academicas d " & vbCrLf  & _
				   "			, planes_estudio e " & vbCrLf  & _
				   "			, especialidades f " & vbCrLf  & _
				   "			, alumnos g " & vbCrLf  & _
				   "			, personas h " & vbCrLf  & _
				   "		where " & vbCrLf  & _
				   "			 a.matr_ncorr=b.matr_ncorr " & vbCrLf  & _
				   "			 and a.secc_ccod=b.secc_ccod " & vbCrLf  & _
				   "			 and b.secc_ccod=c.secc_ccod " & vbCrLf  & _
				   "			 and b.matr_ncorr=g.matr_ncorr " & vbCrLf  & _
				   "			 and d.ofer_ncorr=g.ofer_ncorr " & vbCrLf  & _
				   "			 and e.plan_ccod=g.plan_ccod " & vbCrLf  & _
				   "			 and e.espe_ccod=f.espe_ccod " & vbCrLf  & _
				   "			 and g.pers_ncorr=h.pers_ncorr " & vbCrLf  & _
				   "			 and cast(f.carr_ccod as varchar)='"&carr_ccod&"' " & vbCrLf  & _
				   "			 and cast(h.pers_nrut as varchar)='"&pers_nrut&"' " & vbCrLf  & _
				   "		union " & vbCrLf  & _
				   "		select distinct  " & vbCrLf  & _
				   "		   hf.asig_ccod,sitf_ccod,carg_nnota_final,peri_ccod  " & vbCrLf  & _
				   "		 from   " & vbCrLf  & _
				   "				homologacion_destino hd " & vbCrLf  & _
				   "				,homologacion_fuente hf " & vbCrLf  & _
				   "				,homologacion h " & vbCrLf  & _
				   "				,asignaturas asig,  " & vbCrLf  & _
				   "				secciones secc, " & vbCrLf  & _
				   "				(select  " & vbCrLf  & _
				   "						b.secc_ccod, b.matr_ncorr,b.sitf_ccod,b.carg_nnota_final " & vbCrLf  & _
				   "				from " & vbCrLf  & _
				   "				( " & vbCrLf  & _
				   "				select  " & vbCrLf  & _
				   "					   c.asig_ccod,a.carr_ccod,b.plan_ccod,a.espe_ccod " & vbCrLf  & _
				   "				from  " & vbCrLf  & _
				   "					 especialidades a, planes_estudio b, malla_curricular c  " & vbCrLf  & _
				   "				where  " & vbCrLf  & _
				   "					a.espe_ccod=b.espe_ccod " & vbCrLf  & _
				   "					and b.plan_ccod = c.plan_ccod " & vbCrLf  & _
				   "					and  cast(a.carr_ccod as varchar)='"&carr_ccod&"' " & vbCrLf  & _
				   "					and cast(b.plan_ccod as varchar) <> '"&plan_ccod&"' " & vbCrLf  & _
				   "					and cast(a.espe_ccod as varchar) <> '"&espe_ccod&"' " & vbCrLf  & _
				   "				)a, " & vbCrLf  & _
				   "				( " & vbCrLf  & _
				   "				select " & vbCrLf  & _
				   "					  d.asig_ccod, g.carr_ccod,f.plan_ccod, g.espe_ccod, a.carg_nnota_final , a.sitf_ccod,d.secc_ccod, a.matr_ncorr " & vbCrLf  & _
				   "				from  " & vbCrLf  & _
				   "					cargas_academicas a, personas b, alumnos c, secciones d " & vbCrLf  & _
				   "					,ofertas_academicas e, planes_estudio f, especialidades g   " & vbCrLf  & _
				   "				where b.pers_ncorr=c.pers_ncorr  " & vbCrLf  & _
				   "					and cast(b.pers_nrut as varchar)='"&pers_nrut&"'  " & vbCrLf  & _
				   "					and a.matr_ncorr=c.matr_ncorr  " & vbCrLf  & _
				   "					and a.secc_ccod=d.secc_ccod " & vbCrLf  & _
				   "					and c.ofer_ncorr=e.ofer_ncorr " & vbCrLf  & _
				   "					and c.plan_ccod=f.plan_ccod " & vbCrLf  & _
				   "					and f.espe_ccod=g.espe_ccod " & vbCrLf  & _
				   "					and d.carr_ccod=g.carr_ccod " & vbCrLf  & _
				   "					and cast(a.sitf_ccod as varchar) not in('EQ','EE') " & vbCrLf  & _
				   "					and cast(g.carr_ccod as varchar)='"&carr_ccod&"' " & vbCrLf  & _
				   "					and cast(f.plan_ccod as varchar)<>'"&plan_ccod&"' " & vbCrLf  & _
				   "					and cast(g.espe_ccod as varchar)<> '"&espe_ccod&"' " & vbCrLf  & _
				   "				) b " & vbCrLf  & _
				   "				where  " & vbCrLf  & _
				   "					a.plan_ccod = b.plan_ccod and " & vbCrLf  & _
				   "					a.espe_ccod = b.espe_ccod and " & vbCrLf  & _
				   "					a.carr_ccod = b.carr_ccod and " & vbCrLf  & _
				   "					a.asig_ccod = b.asig_ccod ) " & vbCrLf  & _
				   "				carg " & vbCrLf  & _
				   "				, alumnos al " & vbCrLf  & _
				   "				, personas pers " & vbCrLf  & _
				   "		where hd.homo_ccod=h.homo_ccod  " & vbCrLf  & _
				   "				and hf.homo_ccod=h.homo_ccod  " & vbCrLf  & _
				   "				and asig.asig_ccod=hd.asig_ccod  " & vbCrLf  & _
				   "				and asig.asig_ccod=secc.asig_ccod  " & vbCrLf  & _
				   "				and secc.secc_ccod=carg.secc_ccod  " & vbCrLf  & _
				   "				and al.matr_ncorr=carg.matr_ncorr  " & vbCrLf  & _
				   "				and pers.pers_ncorr=al.pers_ncorr  " & vbCrLf  & _
				   "				and hd.asig_ccod <> hf.asig_ccod  " & vbCrLf  & _
				   "				and cast(sitf_ccod as varchar) not in ('EQ','EE') " & vbCrLf  & _ 
				   "				and h.THOM_CCOD = 1  " & vbCrLf  & _
				   "				and cast(pers.pers_nrut as varchar)='"&pers_nrut&"'  " & vbCrLf  & _
				   "		) b  on  a.asig_ccod = b.asig_ccod " & vbCrLf  & _
				   "		join   asignaturas asig on a.asig_ccod=asig.asig_ccod  " & vbCrLf  & _
				   "	    left outer join periodos_academicos pa on b.peri_ccod=pa.peri_ccod" & vbCrLf  & _
				   "        join carreras ca on ca.carr_ccod=a.carr_ccod " 
'response.Write("<pre>"&cons_historico&"</pre>")
'---------------------------------------------------------------------------------------------------

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "historico.xml", "botonera"
'---------------------------------------------------------------------------------------------------
asig_tdesc1=conexion.consultaUno("Select asig_tdesc from asignaturas where cast(asig_ccod as varchar)='"&asig_ccod1&"'")
'-------------------------------------------------------------------------------------------
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "historico.xml", "select_asignaturas"
f_busqueda.Inicializar conexion

f_busqueda.Consultar "select ''"
f_busqueda.Siguiente
f_busqueda.AgregaCampoParam "asig_ccod2" , "destino" , "(" & cons_historico & ")t"
'------------------------------------------------------------------------------------------
if esVacio(plan_ccod) then
	'conexion.MensajeError "Debe seleccionar un plan de estudios, para el alumno, antes de realizar una equivalencia."
	plan_ccod=0
end if
%>


<html>
<head>
<title>Generar equivalencia</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function agregar(formulario)
{var valor=formulario.elements["asigna[0][asig_ccod2]"].value;
if (valor!="")
{formulario.method="POST";
 formulario.action="Proc_equivalencias_antiguos.asp";
 formulario.submit();
}
else
{alert("Debe seleccionar una asignatura con la cual hacer la equivalencia");}

}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')">
<table width="540" border="0" align="center" cellpadding="0" cellspacing="0">
  <%'pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	    <br>
      <table width="450" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td>
		  <table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="450" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="450" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">
	 					<% 
	  						Response.Write("Asignatura Seleccionada <BR>")
      						      						
   						%>
	  					</font></div></td>
                       <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="450" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  
                <td bgcolor="#D8D8DE"> 
                  <form name="edicion33">
                    <table width="99%" border="0"><br>
                      <tr> 
                        <td width="27%"> <div align="left"><strong> 
                            Código Asignatura </strong></div></td>
                        <td width="2%"><div align="center"><strong>:</strong></div></td>
                        <td width="71%"> <%=asig_ccod1%> </td>
                      </tr>
					    <tr> 
                        <td width="27%"> <div align="left"><strong> 
                            Nombre Asignatura </strong></div></td>
                        <td width="2%"><div align="center"><strong>:</strong></div></td>
                        <td width="71%"> <%=asig_tdesc1%> </td>
                      </tr>
                    </table>
                    </form>
				    </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="450" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
               
            </table>
		  <br>
		  <table border="0" cellpadding="0" cellspacing="0" width="100%">
              <!-- fwtable fwsrc="marco contenidos.png" fwbase="top.gif" fwstyle="Dreamweaver" fwdocid = "742308039" fwnested="0" -->
              <tr>
                <td><img src="../imagenes/spacer.gif" width="9" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="450" height="1" border="0" alt=""></td>
                <td><img src="../imagenes/spacer.gif" width="7" height="1" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
                <td><img src="../imagenes/top_r1_c2.gif" alt="" name="top_r1_c2" width="450" height="8" border="0"></td>
                <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="13" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="209" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">
	 					<% 
	  						Response.Write("Generar Equivalencia <BR>")
      						      						
   						%>
	  					</font></div></td>
                       <td width="448" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    </tr>
                </table></td>
                <td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
              </tr>
              <tr>
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="450" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
              </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                  
                <td bgcolor="#D8D8DE"> <div align="center">&nbsp; <BR>
                    <%pagina.DibujarTituloPagina%>
                  </div>
                  <form name="edicion">
                    <table width="99%" border="0">
                      <tr> <input type="hidden" name="matr_ncorr" value="<%=matr_ncorr%>">
					       <input type="hidden" name="secc_ccod" value="<%=secc_ccod%>">
						   <input type="hidden" name="plan_ccod" value="<%=plan_ccod%>">
                        <td width="25%"> <div align="right"><strong> 
                            Asignatura </strong></div></td>
                        <td width="4%"><div align="center"><strong>:</strong></div></td>
                        <td width="71%"> <%f_busqueda.DibujaCampo("asig_ccod2")  %> </td>
                      </tr>
                    </table>
                    </form>
				  <br>				  </td>
                  <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
                </tr>
            </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9" rowspan="2"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
                  <td width="176" bgcolor="#D8D8DE"> 
                    <table width="58%" border="0" cellpadding="0" cellspacing="0">
                      <tr>
                        <td width="32%"><%'pagina.DibujarBoton "Aceptar", "GUARDAR-edicion", "Proc_Mant_Roles_Edicion.asp"
						botonera.dibujaboton "guardar2"%>
                        <td width="32%"><%'pagina.DibujarBoton "Cancelar", "CERRAR", ""
						botonera.dibujaboton "cancelar"%>
                      </tr>
                    </table>
</td>
                  <td width="47" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
                  <td width="234" rowspan="2" align="right" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
                </tr>
                <tr>
                  <td valign="bottom" bgcolor="#D8D8DE"><img src="../imagenes/abajo_r2_c2.gif" width="100%" height="8"></td>
                </tr>
            </table>
		    <p><br>
            </p>
            <p>&nbsp; </p></td>
        </tr>
      </table>	
   </td>
  </tr>  
</table>
</body>
</html>
