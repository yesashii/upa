      <%
	    Response.AddHeader "Content-Disposition", "attachment;filename=total_docentes_grado.xls"
        Response.ContentType = "application/vnd.ms-excel"
	  %>
      <script type="text/javascript">
          //two variables Controller and Action have to be initialized in the View HTML code
          var Controller ='DocenteGrado';
          var Action = 'List_excel';
      </script>
      <%
	  chequeo_2005=""
	  chequeo_2006=""
	  chequeo_2007=""
	  chequeo_2008=""
	  chequeo_2009="checked='checked'"
	  chequeo_2010="checked='checked'"
	  chequeo_2011="checked='checked'"
	  chequeo_2012="checked='checked'"
	  chequeo_2013="checked='checked'"
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
      <title>Indicador de Docentes por Grado académico</title>
      <meta http-equiv="Content-Type" content="text/html;">
      </head>
      <body >
      <table width="100%">
       	<tr>
        	          <th align="center" bgcolor="#99CC00">Docentes por Grado</th>
                      <%if chequeo_2009 <> "" then%>
                      <th bgcolor="#99CC00">2009</th>
                      <%end if%>
                      <%if chequeo_2010 <> "" then%>
                      <th bgcolor="#99CC00">2010</th>
                      <%end if%>
                      <%if chequeo_2011 <> "" then%>
                      <th bgcolor="#99CC00">2011</th>
                      <%end if%>
                      <%if chequeo_2012 <> "" then%>
                      <th bgcolor="#99CC00">2012</th>
                      <%end if%>
                      <%if chequeo_2013 <> "" then%>
                      <th bgcolor="#99CC00">2013</th>
                      <%end if%>
         </tr>
            
                    <%
                    Dim obj
                    For each obj in Model.Items
                    %>
        <tr>
                      <td align="left"><%=Html.Encode(obj.cabecera) %></td>
                      <%if chequeo_2009 <> "" then%>
                      <td><%=Html.Encode(obj.a2009) %></td>
                      <%end if%>
                      <%if chequeo_2010 <> "" then%>
                      <td><%=Html.Encode(obj.a2010) %></td>
                      <%end if%>
                      <%if chequeo_2011 <> "" then%>
                      <td><%=Html.Encode(obj.a2011) %></td>
                      <%end if%>
                      <%if chequeo_2012 <> "" then%>
                      <td><%=Html.Encode(obj.a2012) %></td>
                      <%end if%>
                      <%if chequeo_2013 <> "" then%>
                      <td><%=Html.Encode(obj.a2013) %></td>
                      <%end if%>
        </tr>
                      <% 
                    Next
					Dim obj_tot_sede
                    For each obj_tot_sede in ModelTotal.Items
                    %>
        <tr>
                      <td align="right"><strong><%=Html.Encode(obj_tot_sede.cabecera) %></strong></td>
                      <%if chequeo_2009 <> "" then%>
                      <td><%=Html.Encode(obj_tot_sede.a2009) %></td>
                      <%end if%>
                      <%if chequeo_2010 <> "" then%>
                      <td><%=Html.Encode(obj_tot_sede.a2010) %></td>
                      <%end if%>
                      <%if chequeo_2011 <> "" then%>
                      <td><%=Html.Encode(obj_tot_sede.a2011) %></td>
                      <%end if%>
                      <%if chequeo_2012 <> "" then%>
                      <td><%=Html.Encode(obj_tot_sede.a2012) %></td>
                      <%end if%>
                      <%if chequeo_2013 <> "" then%>
                      <td><%=Html.Encode(obj_tot_sede.a2013) %></td>
                      <%end if%>
        </tr>
                      <% 
                    Next
                    %>
                    
                    
        <tr>
        	          <th align="center" bgcolor="#FF9900">Horas Semanales por Grado</th>
                      <%if chequeo_2009 <> "" then%>
                      <th bgcolor="#FF9900">2009</th>
                      <%end if%>
                      <%if chequeo_2010 <> "" then%>
                      <th bgcolor="#FF9900">2010</th>
                      <%end if%>
                      <%if chequeo_2011 <> "" then%>
                      <th bgcolor="#FF9900">2011</th>
                      <%end if%>
                      <%if chequeo_2012 <> "" then%>
                      <th bgcolor="#FF9900">2012</th>
                      <%end if%>
                      <%if chequeo_2013 <> "" then%>
                      <th bgcolor="#FF9900">2013</th>
                      <%end if%>
         </tr>
            
                    <%
                    Dim objh
                    For each objh in ModelHoras.Items
                    %>
        <tr>
                      <td align="left"><%=Html.Encode(objh.cabecera) %></td>
                      <%if chequeo_2009 <> "" then%>
                      <td><%=Html.Encode(objh.a2009) %></td>
                      <%end if%>
                      <%if chequeo_2010 <> "" then%>
                      <td><%=Html.Encode(objh.a2010) %></td>
                      <%end if%>
                      <%if chequeo_2011 <> "" then%>
                      <td><%=Html.Encode(objh.a2011) %></td>
                      <%end if%>
                      <%if chequeo_2012 <> "" then%>
                      <td><%=Html.Encode(objh.a2012) %></td>
                      <%end if%>
                      <%if chequeo_2013 <> "" then%>
                      <td><%=Html.Encode(objh.a2013) %></td>
                      <%end if%>
        </tr>
                      <% 
                    Next
					Dim obj_tot_horas
                    For each obj_tot_horas in ModelTotalHoras.Items
                    %>
        <tr>
                      <td align="right"><strong><%=Html.Encode(obj_tot_horas.cabecera) %></strong></td>
                      <%if chequeo_2009 <> "" then%>
                      <td><%=Html.Encode(obj_tot_horas.a2009) %></td>
                      <%end if%>
                      <%if chequeo_2010 <> "" then%>
                      <td><%=Html.Encode(obj_tot_horas.a2010) %></td>
                      <%end if%>
                      <%if chequeo_2011 <> "" then%>
                      <td><%=Html.Encode(obj_tot_horas.a2011) %></td>
                      <%end if%>
                      <%if chequeo_2012 <> "" then%>
                      <td><%=Html.Encode(obj_tot_horas.a2012) %></td>
                      <%end if%>
                      <%if chequeo_2013 <> "" then%>
                      <td><%=Html.Encode(obj_tot_horas.a2013) %></td>
                      <%end if%>
        </tr>
                      <% 
                    Next
                    %>            
      
     </table>
</body>
</html>

    