<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION		:
'FECHA CREACIÓN		:
'CREADO POR 		:
'ENTRADA		:NA
'SALIDA			:NA
'MODULO QUE ES UTILIZADO:
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION 	:16/01/2013
'ACTUALIZADO POR		:JAIME PAINEMAL A.
'MOTIVO			:Optimizar código, eliminar sentencia *=
'LINEA			:86
'********************************************************************
rut	=	request.querystring("rut")
dv	=	request.querystring("dv")
if rut="" or dv="" then
	rut=0
	dv=0
end if
set pagina          	= 	new cpagina
set	negocio				=	new cnegocio
set conectar			=	new cconexion
set tabla_desbloqueo	= 	new cformulario
set botonera        	=  	new CFormulario

conectar.inicializar	"upacifico"
negocio.inicializa		conectar

tabla_desbloqueo.inicializar		conectar
tabla_desbloqueo.carga_parametros	"f_desbloqueos.xml","tabla_desbloqueos"
botonera.carga_parametros "f_desbloqueos.xml", "btn_f_desbloqueos"

	  
cons_tabla = "select distinct d.sede_tdesc,b.bloq_ncorr,b.pers_ncorr, cast(a.pers_nrut as varchar) + '-' + a.pers_xdv  as rut " & vbCrLf &_
				"    , a.pers_tape_paterno + ' ' +   a.PERS_TAPE_MATERNO + ' ' + a.pers_tnombre as nombre, " & vbCrLf &_
				"    convert(varchar,b.bloq_fbloqueo,103) as bloq_fbloqueo,convert(varchar,b.bloq_fbloqueo,103) as fbloqueo" & vbCrLf &_
				"    ,c.tblo_ccod,c.tblo_tdesc,b.eblo_ccod,b.bloq_tobservacion " & vbCrLf &_
				" from personas a,bloqueos b,tipos_bloqueos c,sedes d" & vbCrLf &_
				" where a.pers_ncorr = b.pers_ncorr" & vbCrLf &_
				"    and b.tblo_ccod = c.tblo_ccod" & vbCrLf &_
				"    and b.sede_ccod = d.sede_ccod" & vbCrLf &_
				"    and b.eblo_ccod in (1) " & vbCrLf &_
				"    and cast(a.pers_nrut as varchar) ='"& rut &"' " & vbCrLf &_
				"    and a.pers_xdv='"& dv &"'"



sql_pers_postulante="select * from personas_postulante Where pers_nrut="&rut&" And pers_xdv='"&dv&"'"
v_pers_ncorr_pos=conectar.ConsultaUno(sql_pers_postulante)

tabla_desbloqueo.consultar	cons_tabla
'response.Write("<pre>"&cons_tabla&"</pre>")
registros	=	conectar.consultauno("select count(*) ("&cons_tabla&")")

alumno	=	conectar.consultauno("select pers_tape_paterno + ' ' + pers_tape_materno + ', ' + pers_tnombre as alumno from personas where cast(pers_nrut as varchar) = '"& rut &"'")
'response.End()
if isnull(alumno) then
	alumno	=	conectar.consultauno("select pers_tape_paterno + ' ' + pers_tape_materno + ', ' + pers_tnombre as alumno from personas_postulante where cast(pers_nrut as varchar) = '"& rut &"'")
end if

' --------- DOCUMENTOS PENDIENTES O ENTREGADOS -----------------------
set tabla_documentos = new CFormulario
tabla_documentos.Carga_Parametros "genera_contrato_1.xml", "impedimentos"
tabla_documentos.Inicializar conectar

'sql_documentos_faltantes=" select a.doma_tdesc, " & vbCrLf &_
'						" Case ISNULL(b.doma_ccod,0) " & vbCrLf &_
'						"    When 0 then 'PENDIENTE'  Else 'ENTREGADO' end as Situacion" & vbCrLf &_
'						" From documentos_matricula a,documentos_postulantes b" & vbCrLf &_
'						" Where a.doma_ccod *= b.doma_ccod " & vbCrLf &_
'						" And cast(b.pers_ncorr as varchar)= '"&v_pers_ncorr_pos&"'" & vbCrLf &_
'						" And a.doma_ccod in (select doma_ccod " & vbCrLf &_
'						" From documentos_matricula Where doma_bobligatorio='S')" 

sql_documentos_faltantes=" select a.doma_tdesc, " & vbCrLf &_
						" Case ISNULL(b.doma_ccod,0) " & vbCrLf &_
						"    When 0 then 'PENDIENTE'  Else 'ENTREGADO' end as Situacion " & vbCrLf &_
						" From documentos_matricula a " & vbCrLf &_
						" LEFT OUTER JOIN documentos_postulantes b " & vbCrLf &_
 						"ON a.doma_ccod = b.doma_ccod " & vbCrLf &_
 						"And a.doma_ccod in (select doma_ccod From documentos_matricula Where doma_bobligatorio='S') " & vbCrLf &_
 						"where cast(b.pers_ncorr as varchar) = '"&v_pers_ncorr_pos&"'" 

'RESPONSE.Write("<pre>"&sql_documentos_faltantes&"</pre>")
tabla_documentos.Consultar sql_documentos_faltantes

' --------- DOCUMENTOS PENDIENTES O ENTREGADOS -----------------------

v_cantidad_requerida=conectar.ConsultaUno("select count(doma_ccod) From documentos_matricula Where doma_bobligatorio='S'")

	sql_documentos_requeridos= "select count(*) as total "& vbcrlf & _
								" From documentos_matricula a,documentos_postulantes b "& vbcrlf & _
								" Where a.doma_ccod = b.doma_ccod "& vbcrlf & _
								" And cast(b.pers_ncorr as varchar)= '"&v_pers_ncorr_pos&"' "& vbcrlf & _
								" And a.doma_ccod in (select doma_ccod "& vbcrlf & _
								" From documentos_matricula Where doma_bobligatorio='S') "
	'response.Write(sql_documentos_requeridos)							
	v_doc_requeridos_entregados=conectar.consultaUno(sql_documentos_requeridos)
	
	sql_moroso="select protic.es_moroso("&v_pers_ncorr_pos&",getdate()) as moroso"
	v_moroso=conectar.consultaUno(sql_moroso)
	
set tabla_morosidad = new CFormulario
tabla_morosidad.Carga_Parametros "f_desbloqueos.xml", "resumen_compromisos"
tabla_morosidad.Inicializar conectar	



if v_moroso="S" then
sql_compromisos_pendientes =      "		select   b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, b.comp_ndocto as c_comp_ndocto, b.tcom_ccod as c_tcom_ccod,  " & vbCrLf &_
								  "  			 cast(b.dcom_ncompromiso as varchar) + ' / ' + cast(a.comp_ncuotas as varchar) as ncuota, a.comp_fdocto, b.dcom_fcompromiso, b.dcom_mcompromiso,   " & vbCrLf &_
								  " 				 protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod') as ting_ccod,     " & vbCrLf &_
								  "				 protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') as ding_ndocto,     " & vbCrLf &_
								  "				 protic.total_abonado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as abonos,   " & vbCrLf &_
								  "				 protic.total_abono_documentado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as documentado,  " & vbCrLf &_ 
								  "			   protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) as saldo,   " & vbCrLf &_
								  "			   d.edin_ccod, d.edin_tdesc, d.udoc_ccod     " & vbCrLf &_
								  "		  from  " & vbCrLf &_
								  "		  compromisos a  " & vbCrLf &_
								  "		  join detalle_compromisos b  " & vbCrLf &_
								  "			on a.tcom_ccod = b.tcom_ccod     " & vbCrLf &_
								  "				and a.inst_ccod = b.inst_ccod     " & vbCrLf &_
								  "				and a.comp_ndocto = b.comp_ndocto " & vbCrLf &_
								  "		  left outer join detalle_ingresos c " & vbCrLf &_
								  "				on protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ting_ccod')    = c.ting_ccod    " & vbCrLf &_
								  "				and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ding_ndocto') = c.ding_ndocto    " & vbCrLf &_
								  "				and protic.documento_asociado_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso, 'ingr_ncorr')  = c.ingr_ncorr   " & vbCrLf &_
								  "		 left outer join estados_detalle_ingresos d  " & vbCrLf &_
								  "				on c.edin_ccod = d.edin_ccod " & vbCrLf &_
								  "		  where protic.total_recepcionar_cuota(b.tcom_ccod, b.inst_ccod, b.comp_ndocto, b.dcom_ncompromiso) > 0   " & vbCrLf &_
								  "			and a.ecom_ccod = '1'   " & vbCrLf &_
								  "			and b.ecom_ccod = '1'   " & vbCrLf &_
								  "    and b.dcom_fcompromiso <= getdate()  "& vbCrLf &_
					              "    and cast(a.pers_ncorr as varchar) = '" & v_pers_ncorr_pos & "'"
else
	sql_compromisos_pendientes="select '' where 1=2"
end if
tabla_morosidad.Consultar sql_compromisos_pendientes
	
if v_bloqueos = 0 and v_doc_requeridos_entregados = v_cantidad_requerida and v_moroso<>"S" then
	session("mensaje_error")="El alumno No presenta impedimentos de matricula "
end if					
%>

<html>
<head>
<style>
@media print{ .noprint {visibility:hidden; }}
</style>

<title>Activar Solicitudes</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript" type="text/JavaScript">
<!--



function enviar(formulario){
		if(!(valida_rut(formulario.rut.value + '-' + formulario.dv.value))){
		    alert('El RUT que Ud. ha ingresado no es válido.Por favor, ingréselo nuevamente.');
			formulario.rut.focus();
			formulario.rut.select();
		 }
		else{
			formulario.action = 'impedimentos.asp';
			formulario.submit();
		}
}



function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_nbGroup(event, grpName) { //v6.0
  var i,img,nbArr,args=MM_nbGroup.arguments;
  if (event == "init" && args.length > 2) {
    if ((img = MM_findObj(args[2])) != null && !img.MM_init) {
      img.MM_init = true; img.MM_up = args[3]; img.MM_dn = img.src;
      if ((nbArr = document[grpName]) == null) nbArr = document[grpName] = new Array();
      nbArr[nbArr.length] = img;
      for (i=4; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
        if (!img.MM_up) img.MM_up = img.src;
        img.src = img.MM_dn = args[i+1];
        nbArr[nbArr.length] = img;
    } }
  } else if (event == "over") {
    document.MM_nbOver = nbArr = new Array();
    for (i=1; i < args.length-1; i+=3) if ((img = MM_findObj(args[i])) != null) {
      if (!img.MM_up) img.MM_up = img.src;
      img.src = (img.MM_dn && args[i+2]) ? args[i+2] : ((args[i+1])? args[i+1] : img.MM_up);
      nbArr[nbArr.length] = img;
    }
  } else if (event == "out" ) {
    for (i=0; i < document.MM_nbOver.length; i++) {
      img = document.MM_nbOver[i]; img.src = (img.MM_dn) ? img.MM_dn : img.MM_up; }
  } else if (event == "down") {
    nbArr = document[grpName];
    if (nbArr)
      for (i=0; i < nbArr.length; i++) { img=nbArr[i]; img.src = img.MM_up; img.MM_dn = 0; }
    document[grpName] = nbArr = new Array();
    for (i=2; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
      if (!img.MM_up) img.MM_up = img.src;
      img.src = img.MM_dn = (args[i+1])? args[i+1] : img.MM_up;
      nbArr[nbArr.length] = img;
  } }
}
//-->

function MensajeError(){
<% if session("mensaje_error")<> "" then %>
	if(alert('<%=session("mensaje_error")%>')){
		<%session("mensaje_error")=""%>
	}
<%end if%>
}
</script>

</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MensajeError();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','../matricula/im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('../matricula/im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('../matricula/im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('../matricula/im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
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
                    <td width="6" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                    <td width="152" valign="bottom" background="../imagenes/fondo1.gif">
                      <div align="center"><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Buscador de Alumnos</font></div></td>
                    <td width="46" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
                    <td width="466" bgcolor="#D8D8DE"><font color="#D8D8DE" size="1">.</font></td>
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
		   <form action="" method="get" name="buscador">
                  <table width="98%"  border="0">
                    <tr>
                      <td width="81%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td nowrap> <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">Rut&nbsp;<strong> 
                                <input type="text" name="rut" size="10" maxlength="8" id="rut" value="<%=rut%>">
                                - 
                                <input type="text" name="dv" size="2" maxlength="1" value="<%=dv%>" id="LE-N" 			onKeyUp="this.value=this.value.toUpperCase();">
                                </strong><a href="javascript:buscar_persona();"><img src="../imagenes/lupa_f2.gif" width="16" height="15" border="0"></a><strong> 
                                </strong></font></div>
                              <div align="center"></div></td>
                          </tr>
                        </table></td>
                      <td width="19%"><div align="center">
                        <%botonera.dibujaboton "buscar"%>
                      </div></td>
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
                      <td width="10" background="../imagenes/fondo1.gif"><img src="../imagenes/izq_1.gif" width="5" height="17"></td>
                      <td width="180" valign="middle" background="../imagenes/fondo1.gif">
                      <div align="left"><font color="#FFFFFF" size="1" face="Verdana, Arial, Helvetica, sans-serif">Detalles de situacion Alumno</font></div></td>
                      <td width="480" bgcolor="#D8D8DE"><img src="../imagenes/derech1.gif" width="6" height="17"></td>
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
                  
                <td bgcolor="#D8D8DE"> &nbsp; <form name="editar" method="post">
                    Resultado de la b&uacute;squeda:
					<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" >
                      <tr> 
                        <td align="left"> 
                          <%if rut <> "" then%>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td colspan="3">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td width="9%">&nbsp;</td>
                              <td width="1%">&nbsp;</td>
                              <td width="90%">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td nowrap><strong>RUT</strong></td>
                              <td nowrap><strong>:</strong></td>
                              <td nowrap><strong><%=rut%>-<%=dv%></strong></td>
                            </tr>
                            <tr> 
                              <td nowrap><strong>NOMBRE</strong></td>
                              <td nowrap><strong>:</strong></td>
                              <td nowrap><strong><%=alumno%></strong></td>
                            </tr>
                          </table>
                          <%
					  else
							response.Write("Ingrese el Rut del alumno que desea consultar.")
					  end if
					  %>
                          <br> <br> <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td align="center"><strong>LISTADO DE BLOQUEOS ACTIVOS 
                                </strong></td>
                            </tr>
                            <tr> 
                              <td align="right"> 
                                <%if tabla_desbloqueo.nrofilas > 0 then%>
                                <strong>Páginas: 
                                <%tabla_desbloqueo.accesoPagina()%>
                                </strong> 
                                <% end if %>
                              </td>
                            </tr>
                            <tr> 
                              <td align="center">
                                <%tabla_desbloqueo.dibujatabla()%>
                              </td>
                            </tr>
                            <tr> 
                              <td >&nbsp; </td>
                            </tr>
                          </table>
                          <br>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td align="center"><strong> DOCUMENTOS OBLIGATORIOS</strong></td>
                            </tr>
                            <tr> 
                              <td align="right"> 
                              </td>
                            </tr>
                            <tr> 
                              <td align="center">
                                <%tabla_documentos.dibujatabla()%>
                              </td>
                            </tr>
                            <tr> 
                              <td >&nbsp; </td>
                            </tr>
                            <tr>
                              <td  align="center"><strong>Morosidades</strong></td>
                            </tr>
                            <tr>
                              <td align="center"><%tabla_morosidad.dibujatabla()%></td>
                            </tr>
                            <tr>
                              <td >&nbsp;</td>
                            </tr>
                          </table>
                        </td>
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
                  <td width="104" bgcolor="#D8D8DE">
				  <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                       <td><div align="center">
                        <%botonera.dibujaboton "salir"%>
                      </div></td>
                    </tr>
                  </table>                    
                  </td>
                  <td width="258" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
