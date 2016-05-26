      <%
	    Response.AddHeader "Content-Disposition", "attachment;filename=detalle_matriculados.xls"
        Response.ContentType = "application/vnd.ms-excel"
	  %>
      <script type="text/javascript">
          //two variables Controller and Action have to be initialized in the View HTML code
          var Controller ='ExcelDetalleMatriculados';
          var Action = 'List_excel';
      </script>
      <%
	  chequeo_2005="checked='checked'"
	  chequeo_2006="checked='checked'"
	  chequeo_2007="checked='checked'"
	  chequeo_2008="checked='checked'"
	  chequeo_2009="checked='checked'"
	  chequeo_2010="checked='checked'"
	  chequeo_2011="checked='checked'"
	  chequeo_2012="checked='checked'"
	  chequeo_2013="checked='checked'"
	  chequeo_2014="checked='checked'"
	  
	  if request.QueryString("e2005")="" then
	  	chequeo_2005=""
	  end if
	  if request.QueryString("e2006")="" then
	  	chequeo_2006=""
	  end if
	  if request.QueryString("e2007")="" then
	  	chequeo_2007=""
	  end if
	  if request.QueryString("e2008")="" then
	  	chequeo_2008=""
	  end if
	  if request.QueryString("e2009")="" then
	  	chequeo_2009=""
	  end if
	  if request.QueryString("e2010")="" then
	  	chequeo_2010=""
	  end if
	  if request.QueryString("e2011")="" then
	  	chequeo_2011=""
	  end if
	  if request.QueryString("e2012")="" then
	  	chequeo_2012=""
	  end if
	  if request.QueryString("e2013")="" then
	  	chequeo_2013=""
	  end if
	  if request.QueryString("e2014")="" then
	  	chequeo_2014=""
	  end if
	  %>
      <html>
      <head>
      <title>Detalle postulantes</title>
      <meta http-equiv="Content-Type" content="text/html;">
      </head>
      <body >
      <table width="100%">
       	<tr>
        	          <th align="center" bgcolor="#99CC00">A&ntilde;o</th>
                      <th align="center" bgcolor="#99CC00">Sede</th>
                      <th align="center" bgcolor="#99CC00">Carrera</th>
                      <th align="center" bgcolor="#99CC00">Jornada</th>
                      <th align="center" bgcolor="#99CC00">Rut</th>
                      <th align="center" bgcolor="#99CC00">Nombre</th>
                      <th align="center" bgcolor="#99CC00">Ap. Paterno</th>
                      <th align="center" bgcolor="#99CC00">Ap. Materno</th>
                      <th align="center" bgcolor="#99CC00">Sexo</th>
                      <th align="center" bgcolor="#99CC00">Fecha Nacimiento</th>
                      <th align="center" bgcolor="#99CC00">C&oacute;digo Unico</th>
                      <th align="center" bgcolor="#99CC00">C&oacute;digo Unico Proceso</th>
                      <th align="center" bgcolor="#99CC00">C&oacute;digo RC</th>
                      <th align="center" bgcolor="#99CC00">Edad</th>
                      <th align="center" bgcolor="#99CC00">Edad Entero</th>
                      <th align="center" bgcolor="#99CC00">Rango Edad</th>
                      <th align="center" bgcolor="#99CC00">Cod Estado Civil</th>
                      <th align="center" bgcolor="#99CC00">Fecha Matrimonio</th>
                      <th align="center" bgcolor="#99CC00">Fecha Defunci&oacute;n</th>
                      <th align="center" bgcolor="#99CC00">A&ntilde;o Ing Pri A&ntilde;o</th>
                      <th align="center" bgcolor="#99CC00">Sem Ing Pri A&ntilde;o</th>
                      <th align="center" bgcolor="#99CC00">A&ntilde;o Ing Carrera</th>
                      <th align="center" bgcolor="#99CC00">Sem Ing Carrera</th>
                      <th align="center" bgcolor="#99CC00">Pa&iacute;s Estudios Previos</th>
                      <th align="center" bgcolor="#99CC00">Extranjero</th>
                      <th align="center" bgcolor="#99CC00">Num Pasaporte</th>
                      <th align="center" bgcolor="#99CC00">Nacionalidad</th>
                      <th align="center" bgcolor="#99CC00">Tipo Estudiante</th>
                      <th align="center" bgcolor="#99CC00">Tipo Residencia</th>
                      <th align="center" bgcolor="#99CC00">Perfil Nota EM</th>
                      <th align="center" bgcolor="#99CC00">N RBD A&ntilde;o Egreso</th>
                      <th align="center" bgcolor="#99CC00">N RBD</th>
                      <th align="center" bgcolor="#99CC00">N RBD NEM</th>
                      <th align="center" bgcolor="#99CC00">N RBD Cod Dependencia</th>
                      <th align="center" bgcolor="#99CC00">N RBD Regi&oacute;n</th>
                      <th align="center" bgcolor="#99CC00">N RBD Cod Establecimiento</th>
                      <th align="center" bgcolor="#99CC00">N RBD Tipo Establecimiento</th>
                      <th align="center" bgcolor="#99CC00">N RBD Clas Establecimiento</th>
                      <th align="center" bgcolor="#99CC00">R PSU</th>
                      <th align="center" bgcolor="#99CC00">R PSU A&ntilde;o Egreso</th>
                      <th align="center" bgcolor="#99CC00">R PSU RBD</th>
                      <th align="center" bgcolor="#99CC00">R PSU Cod Dependencia</th>
                      <th align="center" bgcolor="#99CC00">R PSU Regi&oacute;n</th>
                      <th align="center" bgcolor="#99CC00">R PSU NEM</th>
                      <th align="center" bgcolor="#99CC00">R PSU Tramo 50</th>
                      <th align="center" bgcolor="#99CC00">R PSU Tramo 50_2</th>
                      <th align="center" bgcolor="#99CC00">R PSU Tramo 100</th>
                      <th align="center" bgcolor="#99CC00">R PSU Tramo 600_700_720</th>
                      <th align="center" bgcolor="#99CC00">R PSU Tramo 475 por 50</th>
                      <th align="center" bgcolor="#99CC00">B Beca</th>
         </tr>
            
                    <%
                    Dim obj
                    For each obj in Model.Items
                    %>
        <tr>
                      <td align="left"><%=Html.Encode(obj.Anio) %></td>
                      <td align="left"><%=Html.Encode(obj.Sede) %></td>
                      <td align="left"><%=Html.Encode(obj.Carrera) %></td>
                      <td align="left"><%=Html.Encode(obj.Jornada) %></td>
                      <td align="left"><%=Html.Encode(obj.Rut) %></td>
                      <td align="left"><%=Html.Encode(obj.Nombre) %></td>
                      <td align="left"><%=Html.Encode(obj.Paterno) %></td>
                      <td align="left"><%=Html.Encode(obj.Materno) %></td>
                      <td align="left"><%=Html.Encode(obj.Sexo) %></td>
                      <td align="left"><%=Html.Encode(obj.FechaNac) %></td>
                      <td align="left"><%=Html.Encode(obj.CodigoUnico) %></td>
                      <td align="left"><%=Html.Encode(obj.CodigoUnicoProceso) %></td>
                      <td align="left"><%=Html.Encode(obj.CodigoRC) %></td>
                      <td align="left"><%=Html.Encode(obj.Edad) %></td>
                      <td align="left"><%=Html.Encode(obj.EdadEntero) %></td>
                      <td align="left"><%=Html.Encode(obj.RangoEdad) %></td>
                      <td align="left"><%=Html.Encode(obj.CodEstadoCivil) %></td>
                      <td align="left"><%=Html.Encode(obj.FechaMatrimonio) %></td>
                      <td align="left"><%=Html.Encode(obj.FechaDefuncion) %></td>
                      <td align="left"><%=Html.Encode(obj.AnoIngPriAno) %></td>
                      <td align="left"><%=Html.Encode(obj.SemIngPriAno) %></td>
                      <td align="left"><%=Html.Encode(obj.AnoIngCarrera) %></td>
                      <td align="left"><%=Html.Encode(obj.SemIngCarrera) %></td>
                      <td align="left"><%=Html.Encode(obj.PaisEstudiosPrevios) %></td>
                      <td align="left"><%=Html.Encode(obj.Extranjero) %></td>
                      <td align="left"><%=Html.Encode(obj.NumPasaporte) %></td>
                      <td align="left"><%=Html.Encode(obj.Nacionalidad) %></td>
                      <td align="left"><%=Html.Encode(obj.TipoEstudiante) %></td>
                      <td align="left"><%=Html.Encode(obj.TipoResidencia) %></td>
                      <td align="left"><%=Html.Encode(obj.PerfilNotaEm) %></td>
                      <td align="left"><%=Html.Encode(obj.NRbdAnioEgreso) %></td>
                      <td align="left"><%=Html.Encode(obj.NRbd) %></td>
                      <td align="left"><%=Html.Encode(obj.NRbdNem) %></td>
                      <td align="left"><%=Html.Encode(obj.NRbdCodDependencia) %></td>
                      <td align="left"><%=Html.Encode(obj.NRbdRegion) %></td>
                      <td align="left"><%=Html.Encode(obj.NRbdCodEstablecimiento) %></td>
                      <td align="left"><%=Html.Encode(obj.NRbdTipoEstablecimiento) %></td>
                      <td align="left"><%=Html.Encode(obj.NRbdClasEstablecimiento) %></td>
                      <td align="left"><%=Html.Encode(obj.RPsu) %></td>
                      <td align="left"><%=Html.Encode(obj.RPsuAnioEgreso) %></td>
                      <td align="left"><%=Html.Encode(obj.RPsuRbd) %></td>
                      <td align="left"><%=Html.Encode(obj.RPsuCodDependencia) %></td>
                      <td align="left"><%=Html.Encode(obj.RPsuRegion) %></td>
                      <td align="left"><%=Html.Encode(obj.RPsuNem) %></td>
                      <td align="left"><%=Html.Encode(obj.RPsuTramo50) %></td>
                      <td align="left"><%=Html.Encode(obj.RPsuTramo502) %></td>
                      <td align="left"><%=Html.Encode(obj.RPsuTramo100) %></td>
                      <td align="left"><%=Html.Encode(obj.RPsuTramo600700720) %></td>
                      <td align="left"><%=Html.Encode(obj.RPsuTramo475por50) %></td>
                      <td align="left"><%=Html.Encode(obj.BBeca) %></td>
        </tr>
                    <% 
                    Next
                    %>
     </table>
</body>
</html>

    