      <%
	    Response.AddHeader "Content-Disposition", "attachment;filename=total_docentes_jerarquia_grados.xls"
        Response.ContentType = "application/vnd.ms-excel"
	  %>
      <script type="text/javascript">
          //two variables Controller and Action have to be initialized in the View HTML code
          var Controller ='DocenteJerarquiaGrado';
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
      <title>Indicador de Docentes por jerarquía y grado</title>
      <meta http-equiv="Content-Type" content="text/html;">
      </head>
      <body >
      <table width="100%">
       	<tr>
        	          <th align="center" bgcolor="#99CC00">Jerarquia</th>
                      <th align="center" bgcolor="#99CC00">Grado</th>
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
                      <td align="left"><%=Html.Encode(obj.grado) %></td>
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
					Dim obj_tot
                    For each obj_tot in ModelTotal.Items
                    %>
        <tr>
                      <td colspan="2" align="right"><strong><%=Html.Encode(obj_tot.cabecera) %></strong></td>
                      <%if chequeo_2009 <> "" then%>
                      <td><%=Html.Encode(obj_tot.a2009) %></td>
                      <%end if%>
                      <%if chequeo_2010 <> "" then%>
                      <td><%=Html.Encode(obj_tot.a2010) %></td>
                      <%end if%>
                      <%if chequeo_2011 <> "" then%>
                      <td><%=Html.Encode(obj_tot.a2011) %></td>
                      <%end if%>
                      <%if chequeo_2012 <> "" then%>
                      <td><%=Html.Encode(obj_tot.a2012) %></td>
                      <%end if%>
                      <%if chequeo_2013 <> "" then%>
                      <td><%=Html.Encode(obj_tot.a2013) %></td>
                      <%end if%>
        </tr>
                      <% 
                    Next
                    %>
       <tr>
                      <th align="center" bgcolor="#CC9900">Jerarquia</th>
                      <th align="center" bgcolor="#CC9900">Grado</th>
                      <%if chequeo_2009 <> "" then%>
                      <th bgcolor="#CC9900">2009</th>
                      <%end if%>
                      <%if chequeo_2010 <> "" then%>
                      <th bgcolor="#CC9900">2010</th>
                      <%end if%>
                      <%if chequeo_2011 <> "" then%>
                      <th bgcolor="#CC9900">2011</th>
                      <%end if%>
                      <%if chequeo_2012 <> "" then%>
                      <th bgcolor="#CC9900">2012</th>
                      <%end if%>
                      <%if chequeo_2013 <> "" then%>
                      <th bgcolor="#CC9900">2013</th>
                      <%end if%>
        </tr>
            
                    <%
                    Dim obj2
                    For each obj2 in ModelHoras.Items
                    %>
        <tr>
                      <td align="left"><%=Html.Encode(obj2.cabecera) %></td>
                      <td align="left"><%=Html.Encode(obj2.grado) %></td>
                      <%if chequeo_2009 <> "" then%>
                      <td><%=Html.Encode(obj2.a2009) %></td>
                      <%end if%>
                      <%if chequeo_2010 <> "" then%>
                      <td><%=Html.Encode(obj2.a2010) %></td>
                      <%end if%>
                      <%if chequeo_2011 <> "" then%>
                      <td><%=Html.Encode(obj2.a2011) %></td>
                      <%end if%>
                      <%if chequeo_2012 <> "" then%>
                      <td><%=Html.Encode(obj2.a2012) %></td>
                      <%end if%>
                      <%if chequeo_2013 <> "" then%>
                      <td><%=Html.Encode(obj2.a2013) %></td>
                      <%end if%>
         </tr>
                      <% 
                    Next
					Dim obj_tot_horas
                    For each obj_tot_horas in ModelTotalHoras.Items
                    %>
        <tr>
                      <td colspan="2" align="right"><strong><%=Html.Encode(obj_tot_horas.cabecera) %></strong></td>
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

    