<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<html>
<body>
<%
'Response.AddHeader "Content-Disposition", "attachment;filename=Reporte_Cheques.xls"
'Response.ContentType = "application/vnd.ms-excel"
'------------------------------------------------------------------------------------
set pagina = new CPagina
'-----------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new CNegocio
negocio.Inicializa conexion
'------------------------------------------------------------------------------------
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")

set f_consulta = new CFormulario
'------------------------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "Envios_Banco.xml", "f_detalle_agrupado"
formulario.Inicializar conexion
formulario.ProcesaForm
'formulario.ListarPost
for fila = 0 to formulario.CuentaPost - 1
   if fila = 0 then
     envio = formulario.ObtenerValorPost (0, "envi_ncorr")
   end if
   carta = formulario.ObtenerValorPost (fila, "carta")
   if carta = 1 then
      alumno = formulario.ObtenerValorPost (fila, "r_alumno")
      apoderado = formulario.ObtenerValorPost (fila, "r_apoderado")
      'response.Write("alumno: " & alumno & " apoderado: " & apoderado &"<BR>")
      response.Write("<html><body>")
	  encabezado()
	  consultar()
	  dibujar()
	  response.Write("</body></html>")
   else
      formulario.EliminaFilaPost fila 
   end if
next

function encabezado()
%>

<% 
end function

function consultar() 
  f_consulta.Carga_Parametros "Envios_Banco.xml", "f_carta_guia"
  f_consulta.Inicializar conexion
  sql = "SELECT a.envi_ncorr, a.envi_fenvio, a.inen_ccod, b.inen_tdesc, a.plaz_ccod, c.plaz_tdesc,  "&_
			 "obtener_nombre_completo(j.pers_ncorr,'PMN') as nombre_apoderado,  "&_
			 "obtener_rut (j.pers_ncorr) as rut_apoderado, k.dire_tcalle || ' ' || k.dire_tnro  as direccion, "&_
			 "e.ding_fdocto, e.ding_mdetalle, e.ding_ndocto "&_
		"FROM envios a, instituciones_envio b, plazas c, "&_
			 "detalle_envios d, detalle_ingresos e, ingresos f, "&_
			 "personas g, postulantes h, codeudor_postulacion i, "&_
			 "personas j, direcciones k, tipos_direcciones l "&_ 
		"WHERE a.inen_ccod = b.inen_ccod "&_
		  "AND a.plaz_ccod = c.plaz_ccod "&_
		  "AND a.envi_ncorr = d.envi_ncorr "&_
		  "AND d.ting_ccod = e.ting_ccod "&_
		  "AND d.ding_ndocto = e.ding_ndocto "&_
		  "AND d.ingr_ncorr = e.ingr_ncorr "&_
		  "AND e.ingr_ncorr = f.ingr_ncorr "&_
		  "AND f.pers_ncorr = g.pers_ncorr "&_
		  "AND g.pers_ncorr = h.pers_ncorr "&_
		  "AND h.peri_ccod ='" & Periodo & "' "&_
		  "AND h.post_ncorr = i.post_ncorr "&_
		  "AND i.pers_ncorr = j.pers_ncorr "&_
		  "AND j.pers_ncorr = k.pers_ncorr "&_
		  "AND k.tdir_ccod = l.tdir_ccod "&_
		  "AND l.tdir_ccod = 1 "&_ 
		  "AND a.envi_ncorr =" & envio & " "&_
		  "AND g.pers_nrut = nvl('" & alumno & "',g.pers_nrut) "&_
		  "AND j.pers_nrut = nvl('" & apoderado & "',j.pers_nrut)"
       
	   f_consulta.consultar  SQL
      cont = 0
      suma = 0
end function   


function dibujar()
%>
<table width="1500" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td colspan="13"><div align="center"><strong><font size="5">CARTA GUIA DE 
        COBRANZAS</font></strong></div></td>
  </tr>
  <tr> 
    <td colspan="2">&nbsp;</td>
    <td colspan="3">&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="4"><table width="100%" border="0">
        <tr> 
          <td width="30%">&nbsp;</td>
          <td width="24%">&nbsp;</td>
          <td width="14%"><strong>FOLIO</strong></td>
          <td width="32%">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td colspan="2">&nbsp;</td>
    <td colspan="3">&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="2">&nbsp;</td>
    <td colspan="3">&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="2">&nbsp;</td>
    <td colspan="3">&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="3">OFICINA</td>
  </tr>
  <tr> 
    <td colspan="2">&nbsp;</td>
    <td colspan="3">&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="3"><table width="100%" border="0">
        <tr> 
          <td width="30%">&nbsp;</td>
          <td width="8%">de</td>
          <td width="23%">&nbsp;</td>
          <td width="10%">de</td>
          <td width="29%">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td colspan="2"><strong>Nombre Cedente</strong></td>
    <td colspan="3">&nbsp;</td>
    <td width="265">&nbsp;</td>
    <td width="155">&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="2"><table width="100%" border="1" cellpadding="0" cellspacing="0">
        <tr> 
          <td>&nbsp;</td>
        </tr>
      </table></td>
    <td colspan="3">&nbsp;</td>
    <td>&nbsp;</td>
    <td><strong>Tipo Cobranza</strong></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="2"><strong>Direcci&oacute;n</strong></td>
    <td colspan="3">&nbsp;</td>
    <td>&nbsp;</td>
    <td rowspan="2"><table width="100%" border="1" cellpadding="0" cellspacing="0">
        <tr> 
          <td width="27%">&nbsp;</td>
          <td width="73%">Cobranza</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          <td>Garant&iacute;a</td>
        </tr>
      </table></td>
    <td>&nbsp;</td>
    <td><strong>Moneda</strong></td>
    <td>&nbsp;</td>
    <td><strong>Clase Documento</strong></td>
    <td>&nbsp;</td>
    <td><strong>Tipo de Env&iacute;o</strong></td>
  </tr>
  <tr> 
    <td colspan="2"><table width="100%" border="1" cellpadding="0" cellspacing="0">
        <tr> 
          <td cellspacing="0">&nbsp;</td>
        </tr>
      </table></td>
    <td width="28">&nbsp;</td>
    <td width="28" rowspan="3"><table width="100%" border="1" cellpadding="0" cellspacing="0">
        <tr> 
          <td><div align="center">C M</div></td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
      </table></td>
    <td width="30">&nbsp;</td>
    <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr> 
          <td width="54%"><font size="2">Crear Nuevo Maestro</font></td>
          <td width="11%"><table width="100%" border="1" cellpadding="0" cellspacing="0">
              <tr> 
                <td>&nbsp;</td>
              </tr>
            </table></td>
          <td width="9%"><font size="3">SI</font></td>
          <td width="11%"><table width="100%" border="1" cellpadding="0" cellspacing="0">
              <tr> 
                <td>&nbsp;</td>
              </tr>
            </table></td>
          <td width="15%">NO</td>
        </tr>
      </table></td>
    <td width="47">&nbsp;</td>
    <td width="172" rowspan="4"><table width="100%" border="1" cellpadding="0" cellspacing="0">
        <tr> 
          <td width="30%">&nbsp;</td>
          <td width="70%">Pesos</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          <td>D&oacute;lar</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          <td>U.F.</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          <td>Otra:</td>
        </tr>
      </table></td>
    <td width="66">&nbsp;</td>
    <td width="171" rowspan="4"><table width="100%" border="1" cellpadding="0" cellspacing="0">
        <tr> 
          <td width="29%">&nbsp;</td>
          <td width="71%">Letra</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          <td>Pagar&eacute;</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          <td>Factura</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          <td>Otra:</td>
        </tr>
      </table></td>
    <td width="58">&nbsp;</td>
    <td width="168" rowspan="3"><table width="100%" border="1" cellpadding="0" cellspacing="0">
        <tr> 
          <td width="22%">&nbsp;</td>
          <td width="78%">Por Correo</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          <td>Casilla Interna</td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          <td>Otros Env&iacute;os</td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td width="97"><strong>R.U.T.</strong></td>
    <td width="215"><strong>Cta. Cte.</strong></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td><table width="77%" border="1" cellpadding="0" cellspacing="0">
        <tr> 
          <td>&nbsp;</td>
        </tr>
      </table></td>
    <td><table width="67%" border="1" cellpadding="0" cellspacing="0">
        <tr> 
          <td>&nbsp;</td>
        </tr>
      </table></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td colspan="2" rowspan="3"><table width="100%" border="1" cellpadding="0" cellspacing="0">
        <tr> 
          <td colspan="4"><div align="center"><strong>IDENTIFICACION</strong></div></td>
          <td width="8%"><div align="center"><strong>T</strong></div></td>
          <td width="8%"><div align="center"><strong>C</strong></div></td>
        </tr>
        <tr> 
          <td width="15%"><div align="center"><strong>RCPT.</strong></div></td>
          <td width="15%"><div align="center"><strong>MON.</strong></div></td>
          <td width="38%"><div align="center"><strong>N&ordm; CTA.ABONO</strong></div></td>
          <td width="16%"><div align="center"><strong>IMP</strong></div></td>
          <td><div align="center"><strong>O</strong></div></td>
          <td><div align="center"><strong>D</strong></div></td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
      </table></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="2">&nbsp;</td>
    <td colspan="3">&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="2">&nbsp;</td>
    <td colspan="3">&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="2">&nbsp;</td>
    <td colspan="3">&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
<BR>
<table width='1500' border='1' cellpadding="0" cellspacing="0">
  <tr> 
    <td width='32' rowspan='2'> <div align='center'><strong>Inst.</strong></div></td>
    <td width='359' rowspan='2'><strong>Girador/Aceptante/Suscriptor <BR>
      Ap. Paterno Ap. Materno Nombre</strong></td>
    <td width='104' rowspan='2'><div align='center'><strong>R.U.T.</strong></div></td>
    <td width='339' rowspan='2'><div align='center'><strong>Direcci&oacute;n</strong></div></td>
    <td width='194' rowspan='2'><strong>Comuna o Plaza Cobro</strong></td>
    <td colspan='3'><div align='center'><strong>Vencimiento</strong></div></td>
    <td width='111' rowspan='2'><div align='center'><strong>VALOR</strong></div></td>
    <td width='115' rowspan='2'> <div align='center'><strong>N&ordm; de Cedente</strong></div></td>
  </tr>
  <tr> 
    <td width='62'><div align='center'><strong>D&iacute;a</strong></div></td>
    <td width='64'><div align='center'><strong>Mes</strong></div></td>
    <td width='56'><div align='center'><strong>A&ntilde;o</strong></div></td>
  </tr>
  <% while f_consulta.Siguiente %>
  <tr> 
    <td><div align="right"><%=f_consulta.ObtenerValor("inen_ccod")%></div></td>
    <td><%=f_consulta.ObtenerValor("nombre_apoderado")%></td>
    <td><%=f_consulta.ObtenerValor("rut_apoderado")%></td>
    <td><%=f_consulta.ObtenerValor("direccion")%></td>
    <td><%'=f_consulta.ObtenerValor("")%></td>
    <td><div align="center"><%=mid(f_consulta.ObtenerValor("ding_fdocto"),1,2)%></div></td>
    <td><div align="center"><%=mid(f_consulta.ObtenerValor("ding_fdocto"),4,2)%></div></td>
    <td><div align="center"><%=mid(f_consulta.ObtenerValor("ding_fdocto"),7,4)%></div></td>
    <td><div align="right"><%=f_consulta.ObtenerValor("ding_mdetalle")%></div></td>
    <td> <div align="right"><%=f_consulta.ObtenerValor("ding_ndocto")%></div></td>
  </tr>
  <%   valor = f_consulta.ObtenerValor("ding_mdetalle")
       suma = suma + clng(valor)
       cont = cont + 1 
    wend   

  
  %>
</table> 
<p>
<table width="1500" border="0">
  <tr> 
    <td width="124" height="50">
<table width="117%" border="1">
        <tr> 
          <td width="53%" >N&ordm; Dcto.</td>
          <td width="47%"><div align="center"><%=cont%></div>
          </td>
        </tr>
      </table></td>
    <td width="49">&nbsp;</td>
    <td width="479"><table width="100%" border="1" cellpadding="0" cellspacing="0">
        <tr> 
          <td>&nbsp;</td>
        </tr>
      </table></td>
    <td width="38">&nbsp;</td>
    <td width="48">&nbsp;</td>
    <td width="246"><table width="100%" border="1" cellpadding="0" cellspacing="0">
        <tr> 
          <td>&nbsp;</td>
        </tr>
      </table></td>
    <td width="102">&nbsp;</td>
    <td width="143"><div align="right">Total</div></td>
    <td width="113"><table width="100%" border="1" cellpadding="0" cellspacing="0">
        <tr> 
          <td><div align="right"><%=suma%></div></td>
        </tr>
      </table></td>
    <td width="116">&nbsp;</td>
  </tr>
</table>

<p>
 <BR><BR><BR><BR><BR><BR>
  <%  end function %>



</html>

