      <%
	    Response.AddHeader "Content-Disposition", "attachment;filename=detalle_postulantes.xls"
        Response.ContentType = "application/vnd.ms-excel"
	  %>
      <script type="text/javascript">
          //two variables Controller and Action have to be initialized in the View HTML code
          var Controller ='ExcelDetalle';
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
                      <th align="center" bgcolor="#99CC00">Facultad</th>
                      <th align="center" bgcolor="#99CC00">Rut</th>
                      <th align="center" bgcolor="#99CC00">Nombre</th>
                      <th align="center" bgcolor="#99CC00">Ap. Paterno</th>
                      <th align="center" bgcolor="#99CC00">Ap. Materno</th>
                      <th align="center" bgcolor="#99CC00">Sexo</th>
                      <th align="center" bgcolor="#99CC00">Fecha Nacimiento</th>
                      <th align="center" bgcolor="#99CC00">Pa&iacute;s</th>
                      <th align="center" bgcolor="#99CC00">Region</th>
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
                      <td align="left"><%=Html.Encode(obj.Facultad) %></td>
                      <td align="left"><%=Html.Encode(obj.Rut) %></td>
                      <td align="left"><%=Html.Encode(obj.Nombre) %></td>
                      <td align="left"><%=Html.Encode(obj.Paterno) %></td>
                      <td align="left"><%=Html.Encode(obj.Materno) %></td>
                      <td align="left"><%=Html.Encode(obj.Sexo) %></td>
                      <td align="left"><%=Html.Encode(obj.FechaNac) %></td>
                      <td align="left"><%=Html.Encode(obj.Pais) %></td>
                      <td align="left"><%=Html.Encode(obj.Region) %></td>
        </tr>
                    <% 
                    Next
                    %>
     </table>
</body>
</html>

    