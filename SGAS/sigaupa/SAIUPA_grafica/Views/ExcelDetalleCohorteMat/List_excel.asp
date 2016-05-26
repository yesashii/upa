      <%
	    Response.AddHeader "Content-Disposition", "attachment;filename=detalle_cohorte_mat.xls"
        Response.ContentType = "application/vnd.ms-excel"
	  %>
      <script type="text/javascript">
          //two variables Controller and Action have to be initialized in the View HTML code
          var Controller ='ExcelDetalleCohorteMat';
          var Action = 'List_excel';
      </script>
      <%
	  maximo_anio = request.QueryString("q")
	  v_anio_actual	= Year(now())
	  response.Write(v_anio_actual)
	  %>
      <html>
      <head>
      <title>Detalle Cohorte matriculados</title>
      <meta http-equiv="Content-Type" content="text/html;">
      </head>
      <body >
      <table width="100%">
       	<tr>
        	          <th align="center" bgcolor="#99CC00">A&ntilde;o</th>
        	          <th align="center" bgcolor="#99CC00">C&oacute;digo Unico</th>	
        	          <th align="center" bgcolor="#99CC00">C&oacute;digo Unico Proceso</th>	
        	          <th align="center" bgcolor="#99CC00">C&oacute;digo RC</th>	
        	          <th align="center" bgcolor="#99CC00">Sede</th>	
        	          <th align="center" bgcolor="#99CC00">Carrera</th>	
        	          <th align="center" bgcolor="#99CC00">Facultad</th>	
        	          <th align="center" bgcolor="#99CC00">Jornada</th>
        	          <th align="center" bgcolor="#99CC00">Duraci&oacute;n</th>	
        	          <th align="center" bgcolor="#99CC00">RUT</th>	
        	          <th align="center" bgcolor="#99CC00">Apellido Paterno</th>	
        	          <th align="center" bgcolor="#99CC00">Apellido Materno</th>
        	          <th align="center" bgcolor="#99CC00">Nombres</th>	
                      <%if maximo_anio + 1 <=  v_anio_actual then%>
        	          <th align="center" bgcolor="#99CC00">A&ntilde;o 1</th>
        	          <th align="center" bgcolor="#99CC00">Detalle A&ntilde;o 1</th>
                      <%end if
					  if maximo_anio + 2 <=  v_anio_actual then%>
        	          <th align="center" bgcolor="#99CC00">A&ntilde;o 2</th>	
        	          <th align="center" bgcolor="#99CC00">Detalle A&ntilde;o 2</th>	
                      <%end if
					  if maximo_anio + 3 <=  v_anio_actual then%>
        	          <th align="center" bgcolor="#99CC00">A&ntilde;o 3</th>	
        	          <th align="center" bgcolor="#99CC00">Detalle A&ntilde;o 3</th>	
                      <%end if
					  if maximo_anio + 4 <=  v_anio_actual then%>
        	          <th align="center" bgcolor="#99CC00">A&ntilde;o 4</th>	
        	          <th align="center" bgcolor="#99CC00">Detalle A&ntilde;o 4</th>	
                      <%end if
					  if maximo_anio + 5 <=  v_anio_actual then%>
        	          <th align="center" bgcolor="#99CC00">A&ntilde;o 5</th>	
        	          <th align="center" bgcolor="#99CC00">Detalle A&ntilde;o 5</th>	
                      <%end if
					  if maximo_anio + 6 <=  v_anio_actual then%>
        	          <th align="center" bgcolor="#99CC00">A&ntilde;o 6</th>	
        	          <th align="center" bgcolor="#99CC00">Detalle A&ntilde;o 6</th>	
                      <%end if
					  if maximo_anio + 7 <=  v_anio_actual then%>
        	          <th align="center" bgcolor="#99CC00">A&ntilde;o 7</th>	
        	          <th align="center" bgcolor="#99CC00">Detalle A&ntilde;o 7</th>	
                      <%end if
					  if maximo_anio + 8 <=  v_anio_actual then%>
        	          <th align="center" bgcolor="#99CC00">A&ntilde;o 8</th>	
        	          <th align="center" bgcolor="#99CC00">Detalle A&ntilde;o 8</th>	
                      <%end if
					  if maximo_anio + 9 <=  v_anio_actual then%>
        	          <th align="center" bgcolor="#99CC00">A&ntilde;o 9</th>	
        	          <th align="center" bgcolor="#99CC00">Detalle A&ntilde;o 9</th>	
                      <%end if
					  if maximo_anio + 10 <=  v_anio_actual then%>
        	          <th align="center" bgcolor="#99CC00">A&ntilde;o 10</th>	
        	          <th align="center" bgcolor="#99CC00">Detalle A&ntilde;o 10</th>	
                      <%end if
					  if maximo_anio + 11 <=  v_anio_actual then%>
        	          <th align="center" bgcolor="#99CC00">A&ntilde;o 11</th>	
        	          <th align="center" bgcolor="#99CC00">Detalle A&ntilde;o 11</th>	
                      <%end if
					  if maximo_anio + 12 <=  v_anio_actual then%>
        	          <th align="center" bgcolor="#99CC00">A&ntilde;o 12</th>	
        	          <th align="center" bgcolor="#99CC00">Detalle A&ntilde;o 12</th>	
                      <%end if
					  if maximo_anio + 13 <=  v_anio_actual then%>
        	          <th align="center" bgcolor="#99CC00">A&ntilde;o 13</th>	
        	          <th align="center" bgcolor="#99CC00">Detalle A&ntilde;o 13</th>
                      <%end if%>
         </tr>
            
                    <%
                    Dim obj
                    For each obj in Model.Items
                    %>
        <tr>
                      <td align="left"><%=Html.Encode(obj.Anio) %></td>
                      <td align="left"><%=Html.Encode(obj.CodigoUnico) %></td>	
                      <td align="left"><%=Html.Encode(obj.CodigoUnicoProceso) %></td>	
                      <td align="left"><%=Html.Encode(obj.CodigoRC) %></td>	
                      <td align="left"><%=Html.Encode(obj.SedeTdesc) %></td>	
                      <td align="left"><%=Html.Encode(obj.CarrTdesc) %></td>	
                      <td align="left"><%=Html.Encode(obj.FacuTdesc) %></td>	
                      <td align="left"><%=Html.Encode(obj.JornTdesc) %></td>
                      <td align="left"><%=Html.Encode(obj.CarrDuracion) %></td>	
                      <td align="left"><%=Html.Encode(obj.RUT) %></td>	
                      <td align="left"><%=Html.Encode(obj.ApePaterno) %></td>	
                      <td align="left"><%=Html.Encode(obj.ApeMaterno) %></td>
                      <td align="left"><%=Html.Encode(obj.Nombres) %></td>
                      <%if maximo_anio + 1 <=  v_anio_actual then%>	
                      <td align="left"><%=Html.Encode(obj.Anio1) %></td>
                      <td align="left"><%=Html.Encode(obj.DetalleAnio1) %></td>
                      <%end if
					  if maximo_anio + 2 <=  v_anio_actual then%>
                      <td align="left"><%=Html.Encode(obj.Anio2) %></td>	
                      <td align="left"><%=Html.Encode(obj.DetalleAnio2) %></td>	
                      <%end if
					  if maximo_anio + 3 <=  v_anio_actual then%>
                      <td align="left"><%=Html.Encode(obj.Anio3) %></td>	
                      <td align="left"><%=Html.Encode(obj.DetalleAnio3) %></td>	
                      <%end if
					  if maximo_anio + 4 <=  v_anio_actual then%>
                      <td align="left"><%=Html.Encode(obj.Anio4) %></td>
                      <td align="left"><%=Html.Encode(obj.DetalleAnio4) %></td>	
                      <%end if
					  if maximo_anio + 5 <=  v_anio_actual then%>
                      <td align="left"><%=Html.Encode(obj.Anio5) %></td>	
                      <td align="left"><%=Html.Encode(obj.DetalleAnio5) %></td>	
                      <%end if
					  if maximo_anio + 6 <=  v_anio_actual then%>
                      <td align="left"><%=Html.Encode(obj.Anio6) %></td>	
                      <td align="left"><%=Html.Encode(obj.DetalleAnio6) %></td>	
                      <%end if
					  if maximo_anio + 7 <=  v_anio_actual then%>
                      <td align="left"><%=Html.Encode(obj.Anio7) %></td>	
                      <td align="left"><%=Html.Encode(obj.DetalleAnio7) %></td>	
                      <%end if
					  if maximo_anio + 8 <=  v_anio_actual then%>
                      <td align="left"><%=Html.Encode(obj.Anio8) %></td>	
                      <td align="left"><%=Html.Encode(obj.DetalleAnio8) %></td>	
                      <%end if
					  if maximo_anio + 9 <=  v_anio_actual then%>
                      <td align="left"><%=Html.Encode(obj.Anio9) %></td>	
                      <td align="left"><%=Html.Encode(obj.DetalleAnio9) %></td>	
                      <%end if
					  if maximo_anio + 10 <=  v_anio_actual then%>
                      <td align="left"><%=Html.Encode(obj.Anio10) %></td>	
                      <td align="left"><%=Html.Encode(obj.DetalleAnio10) %></td>	
                      <%end if
					  if maximo_anio + 11 <=  v_anio_actual then%>
                      <td align="left"><%=Html.Encode(obj.Anio11) %></td>	
                      <td align="left"><%=Html.Encode(obj.DetalleAnio11) %></td>	
                      <%end if
					  if maximo_anio + 12 <=  v_anio_actual then%>
                      <td align="left"><%=Html.Encode(obj.Anio12) %></td>	
                      <td align="left"><%=Html.Encode(obj.DetalleAnio12) %></td>	
                      <%end if
					  if maximo_anio + 13 <=  v_anio_actual then%>
                      <td align="left"><%=Html.Encode(obj.Anio13) %></td>	
                      <td align="left"><%=Html.Encode(obj.DetalleAnio13) %></td>
                      <%end if%>
        </tr>
                    <% 
                    Next
                    %>
     </table>
</body>
</html>

    