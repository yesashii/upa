<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
on error resume next
set conectar = new cconexion
conectar.inicializar "upacifico"


set formulario = new cformulario

set negocio = new CNegocio
negocio.Inicializa conectar

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next


v_dcur_ncorr = request.Form("dcur_ncorr")
v_dcur_ncorr_emula = request.Form("m[0][dcur_ncorr_a_emular]")


if v_dcur_ncorr_emula <> "" then

  set formulario2 = new cformulario
  formulario2.carga_parametros "tabla_vacia.xml", "tabla"
  formulario2.inicializar conectar
		
  consulta= " SELECT MOTE_CCOD,isnull(MAOT_NHORAS_PROGRAMA,0) as MAOT_NHORAS_PROGRAMA,0 as MAOT_NPRESUPUESTO_RELATOR,  " & vbCrlf & _ 
            " isnull(MAOT_NHORAS_AYUDANTIA,0) as MAOT_NHORAS_AYUDANTIA,0 as MAOT_NPRESUPUESTO_AYUDANTIA,  " & vbCrlf & _
			" isnull(MAOT_NORDEN,1) as MAOT_NORDEN " & vbCrlf & _
			" FROM mallas_otec " & vbCrlf & _
			" WHERE cast(dcur_ncorr as varchar)= '" & v_dcur_ncorr_emula & "'" 
	
  formulario2.consultar consulta
  if formulario2.nroFilas > 0 then
        c_orden = conectar.consultaUno("select isnull((select max(DCUR_NORDEN)+ 1 from programas_asociados where cast(dcur_ncorr as varchar)='"&v_dcur_ncorr&"'),1)")
  	    c_insert_0 = " Insert into programas_asociados (DCUR_NCORR,DCUR_NCORR_ORIGEN,DCUR_NORDEN,AUDI_TUSUARIO,AUDI_FMODIFICACION) "&_
				     " values ("&v_dcur_ncorr&","&v_dcur_ncorr_emula&","&c_orden&",'"&negocio.obtenerUsuario&"',getDate() )"
		'response.Write(c_insert_0)
		conectar.ejecutaS c_insert_0
  end if
  
  while formulario2.siguiente
		mote = formulario2.obtenerValor("MOTE_CCOD")
		horasp   = formulario2.obtenerValor("MAOT_NHORAS_PROGRAMA")
		presup   = formulario2.obtenerValor("MAOT_NPRESUPUESTO_RELATOR")
		horasa   = formulario2.obtenerValor("MAOT_NHORAS_AYUDANTIA")
		presua   = formulario2.obtenerValor("MAOT_NPRESUPUESTO_AYUDANTIA")
		c_orden2 = conectar.consultaUno("select isnull((select max(MAOT_NORDEN)+ 1 from mallas_otec where cast(dcur_ncorr as varchar)='"&v_dcur_ncorr&"'),1)")
			
		maot_ncorr = conectar.consultaUno("exec obtenerSecuencia 'mallas_otec'")
		c_insert = " Insert into mallas_otec (MAOT_NCORR,DCUR_NCORR,MOTE_CCOD,MAOT_NHORAS_PROGRAMA,MAOT_NPRESUPUESTO_RELATOR,MAOT_NHORAS_AYUDANTIA, "&_	
		           "                          MAOT_NPRESUPUESTO_AYUDANTIA,MAOT_NORDEN,AUDI_TUSUARIO,AUDI_FMODIFICACION,MAOT_ORDEN_RELACION) "&_
				   " values ("&maot_ncorr&","&v_dcur_ncorr&",'"&mote&"',"&horasp&","&presup&","&horasa&","&presua&","&c_orden2&",'"&negocio.obtenerUsuario&"',getDate(),"&c_orden&" )"
		'response.Write("<br>"&c_insert)
		conectar.ejecutaS c_insert
   wend

end if

'response.End()
	
if conectar.obtenerEstadoTransaccion then 
	conectar.MensajeError "Relación de programas guardada exitosamente"
end if

 response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>
