      <%
	    Response.AddHeader "Content-Disposition", "attachment;filename=detalle_matriculados.xls"
        Response.ContentType = "application/vnd.ms-excel"
	  %>
      <script type="text/javascript">
          //two variables Controller and Action have to be initialized in the View HTML code
          var Controller ='ExcelDetalleTitulados';
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
	  %>
      <html>
      <head>
      <title>Detalle cohorte tirulados</title>
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
                      <th align="center" bgcolor="#99CC00">Extranjero</th>
                      <th align="center" bgcolor="#99CC00">Nacionalidad</th>
                      <th align="center" bgcolor="#99CC00">T&iacute;tulo obtenido</th>
                      <th align="center" bgcolor="#99CC00">Grado obtenido</th>
                      <th align="center" bgcolor="#99CC00">Fecha de obtenci&oacute;n</th>
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
                      <td align="left"><%=Html.Encode(obj.Extranjero) %></td>
                      <td align="left"><%=Html.Encode(obj.Nacionalidad) %></td>
                      <td align="left"><%=Html.Encode(obj.NombTituloObtenido) %></td>
                      <td align="left"><%=Html.Encode(obj.NombGradoObtenido) %></td>
                      <td align="left"><%=Html.Encode(obj.FechaObtencionTitulo) %></td>
        </tr>
                    <% 
                    Next
                    %>
     </table>
</body>
</html>

    