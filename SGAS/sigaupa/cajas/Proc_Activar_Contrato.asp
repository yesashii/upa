<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'response.End()
set conexion = new CConexion
conexion.Inicializar "upacifico"
'---------------------------------------------------------------------
set negocio = new CNegocio
negocio.Inicializa conexion
set cajero = new CCajero
'

cajero.inicializar conexion, negocio.obtenerUsuario, negocio.obtenerSede
'---------------------------------------------------------------------
caja_abierta = cajero.obtenerCajaAbierta

Usuario = negocio.ObtenerUsuario()

' agregado para las boletas
v_sede = negocio.ObtenerSede()
'response.Write("Yajuuuuuuuuuuuuuuuu")
'response.End()
'-----------------------------------------------------------------------
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "parametros.xml", "tabla"
f_consulta.Inicializar conexion
'-----------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "Activar_Contrato.xml", "f_contratos"
formulario.Inicializar conexion
formulario.ProcesaForm

'contrato = formulario.ObtenerValorPost (0, "cont_ncorr")
'rut = formulario.ObtenerValorPost (0, "pers_nrut")
'digito = formulario.ObtenerValorPost (0, "pers_xdv")

for fila = 0 to formulario.CuentaPost - 1
	contrato_aux = formulario.ObtenerValorPost (fila, "cont_ncorr")
	if 	not EsVacio(contrato_aux) then
		contrato = contrato_aux
		rut = formulario.ObtenerValorPost (fila, "pers_nrut")
		digito = formulario.ObtenerValorPost (fila, "pers_xdv")
	end if
next

if contrato <> "" then

  SQL = " EXEC activa_contrato '" & contrato & "','" & caja_abierta & "' "
  'response.write SQL
  'response.end
  conexion.EjecutaPsql(SQL)
  
 
'###################################################################################
'###########################			BOLETAS 		############################
'IF negocio.ObtenerUsuario ="8876413"  or negocio.ObtenerUsuario ="11853739" or negocio.ObtenerUsuario ="8861959" or negocio.ObtenerUsuario ="12234131" or negocio.ObtenerUsuario ="8533344" or negocio.ObtenerUsuario ="12490446" or negocio.ObtenerUsuario ="13093764" or negocio.ObtenerUsuario ="12642965" or negocio.ObtenerUsuario ="12462083" or negocio.ObtenerUsuario ="15388705" or negocio.ObtenerUsuario ="15785003" or negocio.ObtenerUsuario ="13260927" or negocio.ObtenerUsuario ="13275090" then	

sql_ingreso="select  top 1 ingr_nfolio_referencia " & vbCrLf &_
			" from detalle_compromisos a, abonos b, ingresos c " & vbCrLf &_
			" where a.tcom_ccod in (1,2) " & vbCrLf &_
			"  and c.eing_ccod in(1,4) " & vbCrLf &_
			"  and a.comp_ndocto = " & contrato & " " & vbCrLf &_
			"  and a.tcom_ccod = b.tcom_ccod " & vbCrLf &_
			"  and a.inst_ccod = b.inst_ccod " & vbCrLf &_
			"  and a.comp_ndocto = b.comp_ndocto  " & vbCrLf &_
			"  and a.dcom_ncompromiso = b.dcom_ncompromiso " & vbCrLf &_
			"  and b.ingr_ncorr = c.ingr_ncorr " & vbCrLf &_
			"  group by ingr_nfolio_referencia "


  v_folio_referencia   =conexion.consultaUno(sql_ingreso)
 
  sql_crea_boletas="Exec genera_boletas_electronicas 1,"&v_folio_referencia&", 7, "&v_sede&","&caja_abierta&", '"&Usuario&"' "
  v_salida = conexion.ConsultaUno(sql_crea_boletas)

	'***************************************************************************************
	 sql_boletas="select pers_ncorr,isnull(pers_ncorr_aval,pers_ncorr)as pers_ncorr_aval,bole_ncorr from boletas where ingr_nfolio_referencia="&v_folio_referencia
	
	 set f_boletas = new CFormulario	
	 f_boletas.Carga_Parametros "tabla_vacia.xml","tabla"
	 f_boletas.Inicializar conexion
	 f_boletas.Consultar sql_boletas
	'***************************************************************************************
'END IF

'###################################################################################


'  el alumno debe estar matriculado en producción para ocupar los mísmos códigos de matrículaen desarrollo
'  post_ncorr_temporal = conexion.consultaUno("select post_ncorr from contratos where cast(cont_ncorr as varchar)='"&contrato&"'")
'  post_bnuevo  = conexion.consultaUno("select post_bnuevo from postulantes where cast(post_ncorr as varchar)='"&post_ncorr_temporal&"'")
'  periodo_traspaso  = conexion.consultaUno("select peri_ccod from postulantes where cast(post_ncorr as varchar)='"&post_ncorr_temporal&"'")
'  matriculado  = conexion.consultaUno("select count(*) from contratos a, alumnos b where cast(cont_ncorr as varchar)='"&contrato&"' and a.matr_ncorr = b.matr_ncorr and b.emat_ccod <> 9")
'  if post_bnuevo = "N" and matriculado <> "0" then
'      matricula_traspaso  = conexion.consultaUno("select b.matr_ncorr from contratos a, alumnos b where cast(cont_ncorr as varchar)='"&contrato&"' and a.matr_ncorr = b.matr_ncorr and b.emat_ccod <> 9")
'      oferta_traspaso =conexion.consultaUno("select ofer_ncorr from alumnos where cast(matr_ncorr as varchar)='"&matricula_traspaso&"'")
'	  persona_traspaso=conexion.consultaUno("select pers_ncorr from alumnos where cast(matr_ncorr as varchar)='"&matricula_traspaso&"'")   
'      plan_traspaso =conexion.consultaUno("select plan_ccod from alumnos where cast(matr_ncorr as varchar)='"&matricula_traspaso&"'")             
'      alum_nmatricula_traspaso =conexion.consultaUno("select alum_nmatricula from alumnos where cast(matr_ncorr as varchar)='"&matricula_traspaso&"'")                
'      emat_ccod_traspaso =conexion.consultaUno("select emat_ccod from alumnos where cast(matr_ncorr as varchar)='"&matricula_traspaso&"'")                       
      
'	  set conexion_directa = new CAlternativa
'      conexion_directa.Inicializa
	  'Primero vemos si existe la postulación en el servidor de desarrollo
'	  existe_postulacion = conexion_directa.ConsultaUnoDirecta("select count(*) from postulantes where cast(post_ncorr as varchar)='"&post_ncorr_temporal&"'")
'	  if existe_postulacion ="0" then
	  	'insertamos la postulación y el detalle
'	  	c_postulacion = "insert into postulantes (POST_NCORR,PERS_NCORR,EPOS_CCOD,TPOS_CCOD,PERI_CCOD,POST_BNUEVO,OFER_NCORR,AUDI_TUSUARIO,AUDI_FMODIFICACION)"&_
'		                  " values ("&post_ncorr_temporal&","&persona_traspaso&",2,1,"&periodo_traspaso&",'N',"&oferta_traspaso&",'Serv.Producción',getDate())"  
'	    c_detalle  = "insert into detalle_postulantes (POST_NCORR,OFER_NCORR,AUDI_TUSUARIO,AUDI_FMODIFICACION,DPOS_TOBSERVACION,EEPO_CCOD,DPOS_NCALIFICACION,dpos_fexamen)"&_
'		             " values ("&post_ncorr_temporal&","&oferta_traspaso&",'Serv.Producción',getDate(),NULL,5,NULL,getDate())" 
'	  else
'	    c_postulacion = "update postulantes set ofer_ncorr="&oferta_traspaso&",epos_ccod=2 where cast(post_ncorr as varchar)='"&post_ncorr_temporal&"'"
'	    existe_detalle = conexion_directa.ConsultaUnoDirecta("select count(*) from detalle_postulantes where cast(post_ncorr as varchar)='"&post_ncorr_temporal&"' and cast(ofer_ncorr as varchar)='"&oferta_traspaso&"'")
'	    if existe_detalle= "0" then
'		  c_detalle  = "insert into detalle_postulantes (POST_NCORR,OFER_NCORR,AUDI_TUSUARIO,AUDI_FMODIFICACION,DPOS_TOBSERVACION,EEPO_CCOD,DPOS_NCALIFICACION,dpos_fexamen)"&_
'		               " values ("&post_ncorr_temporal&","&oferta_traspaso&",'Serv.Producción',getDate(),NULL,5,NULL,getDate())" 
'		else
'		  c_detalle  = "update detalle_postulantes set eepo_ccod=5 where cast(post_ncorr as varchar)='"&post_ncorr_temporal&"' and cast(ofer_ncorr as varchar)='"&oferta_traspaso&"'"
'		end if
'	  end if
	  'realizamos lainserción de registros en las  tablas postulantes y detalle_postulantes   
'      conexion_directa.EjecutaQueryDirecta (c_postulacion)
'	  conexion_directa.EjecutaQueryDirecta (c_detalle)
	  
	  'ahora debemos hacer la inserción de la persona en la tabla alumnos, es necesario respetar las claves ya que serán las que haran referencia a la carga de los alumnos
' 	  existe_matricula = conexion_directa.ConsultaUnoDirecta("select count(*) from alumnos where cast(matr_ncorr as varchar)='"&matricula_traspaso&"'")
'      if existe_matricula="0" then
	  	'debemos insertar el registro
'		c_alumnos = "insert into alumnos (MATR_NCORR,EMAT_CCOD,POST_NCORR,OFER_NCORR,PERS_NCORR,PLAN_CCOD,ALUM_NMATRICULA,ALUM_FMATRICULA,AUDI_TUSUARIO,AUDI_FMODIFICACION) "&_  
'		            " values("&matricula_traspaso&","&emat_ccod_traspaso&","&post_ncorr_temporal&","&oferta_traspaso&","&persona_traspaso&","&plan_traspaso&","&alum_nmatricula_traspaso&",getDate(),'Serv.Producción',getDate())"
'	  else
'	    c_alumnos = "update alumnos set emat_ccod="&emat_ccod_traspaso&",post_ncorr="&post_ncorr_temporal&",ofer_ncorr="&oferta_traspaso&",pers_ncorr="&persona_traspaso&", plan_ccod="&plan_traspaso&" where cast(matr_ncorr as varchar)='"&matricula_traspaso&"'"
'	  end if
'      conexion_directa.EjecutaQueryDirecta (c_alumnos)  
'  end if
  

  
end if


%>

<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="javascript" type="text/javascript">
	 <%

	 cantidad=f_boletas.nroFilas
		 if cantidad >0 then
			fila=0
			while f_boletas.siguiente
				
				  v_pers_ncorr=f_boletas.ObtenerValor("pers_ncorr")
				  v_pers_ncorr_aval=f_boletas.ObtenerValor("pers_ncorr_aval")
				  v_bole_ncorr=f_boletas.ObtenerValor("bole_ncorr")
				  if v_bole_ncorr <> "" then
					url="ver_detalle_boletas.asp?bole_ncorr="&v_bole_ncorr&"&pers_ncorr="&v_pers_ncorr&"&pers_ncorr_aval="&v_pers_ncorr_aval
					%>
						
						window.open("../certificados_dae/certificado_2.asp?pers_ncorr=<%=v_pers_ncorr%>");
						window.open("<%=url%>","<%=v_bole_ncorr%>");
						
					<%
				  end if
				  fila=fila+1
		
			wend	
		 end if
 
	%>

<%
if contrato <> "" then

sql_es_nuevo=" select count(*) from contratos a,postulantes b "&_
			 " where a.cont_ncorr="&contrato&" "&_
			 " and a.post_ncorr=b.post_ncorr "&_
			 " and post_bnuevo='S' "

v_es_nuevo=conexion.consultaUno(sql_es_nuevo)

sql_entregados=" Select count(*) from contratos a,postulantes b,documentos_postulantes c "&_
				" where a.cont_ncorr="&contrato&" "&_
				" and a.post_ncorr=b.post_ncorr "&_
				" and b.pers_ncorr=c.pers_ncorr "&_
				" and c.doma_ccod in (1,2,3,6) "&_
				" and b.post_bnuevo='S' "

v_entregados=conexion.consultaUno(sql_entregados)


url_reserva="constancia_reserva.asp?cont_ncorr="&contrato
	if v_es_nuevo>0 and v_entregados < 4 then
		%>
			window.open("<%=url_reserva%>","<%=contrato%>");
		<%
	end if

end if
%>
</script>


<script language="JavaScript">
   location.reload("activar_contrato.asp?busqueda[0][pers_nrut]=<%=rut%>&busqueda[0][pers_xdv]=<%=digito%>") 
</script>
