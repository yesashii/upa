
      <script type="text/javascript">
          //two variables Controller and Action have to be initialized in the View HTML code
          var Controller ='DocenteGrado';
          var Action = 'List';
      </script>
      <script type="text/javascript" src="http://www.google.com/jsapi"></script>
	  <script type="text/javascript" src="Content/jquery-1.4.4.min.js"></script>
	  <script type="text/javascript" src="Content/jquery.gvChart-1.1.min.js"></script>
       <script type="text/javascript">
			gvChartInit();
			jQuery(document).ready(function(){
				jQuery("#tablaFacultad").gvChart({
					chartType: "ColumnChart",
					gvSettings: {
						vAxis: {title: "Cantidad"},
						hAxis: {title: "Periodo"},
						width: 500,
						colors:['#6fa9ce','#ffe799','#fa7874','#90c7a0','#eda64d','#1998cc','#f1f25a','#79ce5b'],
						height: 220
						}
				});
				
				jQuery("#tablaHoras").gvChart({
					chartType: "AreaChart",
					gvSettings: {
						vAxis: {title: "Horas"},
						hAxis: {title: "Periodo"},
						width: 500,
						colors:['#6fa9ce','#ffe799','#fa7874','#90c7a0','#eda64d','#1998cc','#f1f25a','#79ce5b'],
						height: 220
						}
				});	
				
			});
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
	  chequeo_2014="checked='checked'"
	  chequeo_2015="checked='checked'"
	  complemento_url = ""
  	  url_detalle = "&q="
	  maximo_anio = 2009
	  inicial = request.form("inicial")
	  if inicial = "" then
	  	inicial= 1
	  end if
	  if request.form("c2009")="" then
	  	chequeo_2009=""
	  else
	    complemento_url = complemento_url&"&e2009=1"
		maximo_anio = 2009
	  end if
	  if request.form("c2010")="" then
	  	chequeo_2010=""
	  else
	    complemento_url = complemento_url&"&e2010=1"
		maximo_anio = 2010
	  end if
	  if request.form("c2011")=""  and inicial <> 1 then
	  	chequeo_2011=""
	  else
	    complemento_url = complemento_url&"&e2011=1"
		maximo_anio = 2011
	  end if
	  if request.form("c2012")=""  and inicial <> 1 then
	  	chequeo_2012=""
	  else
	    complemento_url = complemento_url&"&e2012=1"
		maximo_anio = 2012
	  end if
	  if request.form("c2013")=""  and inicial <> 1 then
	  	chequeo_2013=""
	  else
	    complemento_url = complemento_url&"&e2013=1"
		maximo_anio = 2013
	  end if
	  if request.form("c2014")=""  and inicial <> 1 then
	  	chequeo_2014=""
	  else
	    complemento_url = complemento_url&"&e2014=1"
		maximo_anio = 2014
	  end if
	   if request.form("c2015")=""  and inicial <> 1 then
	  	chequeo_2015=""
	  else
	    complemento_url = complemento_url&"&e2015=1"
		maximo_anio = 2015
	  end if
	   url_detalle = url_detalle & "" & maximo_anio
	  %>
     <!-- <div class='GridViewScrollContainer'>-->
     <div id="cuadro0">
     <br />
     <h1>N° de docentes por Grado académico</h1>
     <p><i>"Cantidad de docentes y total de horas cronológicas semanales, distribuidas por Grádo académico máximo".</i></p> 
     <div id="titulo1" class="titulo">
     Filtros
     <input name="imagefield" type="image" src="Content/minimizar.jpg" onClick="minimizar('capa1')"/>
     <input name="imagefield" type="image" src="Content/encuadre.jpg" onClick="maximizar('capa1')"/>
     <input name="imagefield" type="image" src="Content/cerrar.jpg" style="margin-right:3px;" onClick="minimizar('capa1');minimizar('titulo1')"/>
     </div>
     <div id="capa1">
               <form name="formu_anos" target="_self" method="post">
               <input type="hidden" name="inicial" value="0" />
               <table width="90%" align="center">
                    <tr valign="top">
                        <td colspan="10"><h3 class="shad">Seleccione años a consultar</h3></td>
                    </tr>
                    <tr>
                        <td width="10%" align="center"><input type="checkbox" name="c2005" value="2005" <%=chequeo_2005%> onChange="document.formu_anos.submit();" ></td>
                        <td width="10%" align="center"><input type="checkbox" name="c2006" value="2006" <%=chequeo_2006%> onChange="document.formu_anos.submit();" ></td>
                        <td width="10%" align="center"><input type="checkbox" name="c2007" value="2007" <%=chequeo_2007%> onChange="document.formu_anos.submit();" ></td>
                        <td width="10%" align="center"><input type="checkbox" name="c2008" value="2008" <%=chequeo_2008%> onChange="document.formu_anos.submit();" ></td>
                        <td width="10%" align="center"><input type="checkbox" name="c2009" value="2009" <%=chequeo_2009%> onChange="document.formu_anos.submit();" ></td>
                        <td width="10%" align="center"><input type="checkbox" name="c2010" value="2010" <%=chequeo_2010%> onChange="document.formu_anos.submit();" ></td>
                        <td width="10%" align="center"><input type="checkbox" name="c2011" value="2011" <%=chequeo_2011%> onChange="document.formu_anos.submit();" ></td>
                        <td width="10%" align="center"><input type="checkbox" name="c2012" value="2012" <%=chequeo_2012%> onChange="document.formu_anos.submit();" ></td>
                        <td width="10%" align="center"><input type="checkbox" name="c2013" value="2013" <%=chequeo_2013%> onChange="document.formu_anos.submit();" ></td>
						<td width="10%" align="center"><input type="checkbox" name="c2014" value="2014" <%=chequeo_2014%> onChange="document.formu_anos.submit();" ></td>
                        <td width="10%" align="center"><input type="checkbox" name="c2015" value="2015" <%=chequeo_2015%> onChange="document.formu_anos.submit();" ></td>
                    </tr>
                    <tr>
                        <td width="10%" align="center"><font color="#999999">2005</font></td>
                        <td width="10%" align="center"><font color="#999999">2006</font></td>
                        <td width="10%" align="center"><font color="#999999">2007</font></td>
                        <td width="10%" align="center"><font color="#999999">2008</font></td>
                        <td width="10%" align="center"><font color="#999999">2009</font></td>
                        <td width="10%" align="center"><font color="#999999">2010</font></td>
                        <td width="10%" align="center"><font color="#999999">2011</font></td>
                        <td width="10%" align="center"><font color="#999999">2012</font></td>
                        <td width="10%" align="center"><font color="#999999">2013</font></td>
						<td width="10%" align="center"><font color="#999999">2014</font></td>
                        <td width="10%" align="center"><font color="#999999">2015</font></td>
                    </tr>
                    <tr>
                    	<td colspan="10" align="right">
				            <%=Html.ActionLink("<div class='btn' align='right'>Obtener Excel</div>","DocenteGrado","List_excel", "partial=excel"&complemento_url)%>
                            <%if session("_pers_ncorr_") = "0" then 
							   response.Write(Html.ActionLink("<div class='btn' align='right'>Detalle "&maximo_anio&"</div>","ExcelDetalleProfesores","List_excel", "partial=excel"&url_detalle))
							  end if
							%>
                        </td>	
                    </tr>
                    
               </table>
               </form>
     </div>
     <br />
     <div id="titulo2" class="titulo">
     N° de docentes
     <input name="imagefield" type="image" src="Content/minimizar.jpg" onClick="minimizar('capa2')"/>
     <input name="imagefield" type="image" src="Content/encuadre.jpg" onClick="maximizar('capa2')"/>
     <input name="imagefield" type="image" src="Content/cerrar.jpg" style="margin-right:3px;" onClick="minimizar('capa2');minimizar('titulo2')"/>
     </div>
     <div id="capa2">
            <table width="980">
               <tr valign="top">
                   <td  width="60%" align="center" style='font-size: 0.6em;'>
						<br />
                        <table width="100%">
                        <tr valign="top">
                        <td width="100%" align="center">
                                 <table bgcolor="#FFFFFF" class="tabla">
                                    <tr>
                                      <th>Grado académico</th>
                                      <%if chequeo_2009 <> "" then%>
                                      <th>2009</th>
                                      <%end if%>
                                      <%if chequeo_2010 <> "" then%>
                                      <th>2010</th>
                                      <%end if%>
                                      <%if chequeo_2011 <> "" then%>
                                      <th>2011</th>
                                      <%end if%>
                                      <%if chequeo_2012 <> "" then%>
                                      <th>2012</th>
                                      <%end if%>
                                      <%if chequeo_2013 <> "" then%>
                                      <th>2013</th>
                                      <%end if%>
									  <%if chequeo_2014 <> "" then%>
                                      <th>2014</th>
                                      <%end if%>
                                      <%if chequeo_2015 <> "" then%>
                                      <th>2015</th>
                                      <%end if%>
                                    </tr>
                            
                                    <%
                                if  IsNothing(Model) then
                                    %> <tr>
                                      <td colspan="6">Sin registros</td>
                                    </tr><%
                                Else
                                    Dim obj
                                    For each obj in Model.Items
                                    %>
                                    <tr>
                                      <td><div align="left"><%=Html.Encode(obj.cabecera) %></div></td>
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
									  <%if chequeo_2014 <> "" then%>
                                      <td><%=Html.Encode(obj.a2014) %></td>
                                      <%end if%>
                                      <%if chequeo_2015 <> "" then%>
                                      <td><%=Html.Encode(obj.a2015) %></td>
                                      <%end if%>
                                    </tr>
                                      <% 
                                    Next
                                 End If
                                 %>
                                </table>
                          </td>
                          </tr>
                          <tr><td align="center">&nbsp;</td></tr>
                          <tr><td align="center">&nbsp;</td></tr>
                          <tr><td align="center">&nbsp;</td></tr>
                          <tr>
                             <td align="center">
                                 <table bgcolor="#FFFFFF" class="tabla">
                                            <tr>
                                              <td>&nbsp;</td>
                                              <td>&nbsp;</td>
                                              <%if chequeo_2005 <> "" then%>
                                              <td width="18" height="18" bgcolor="#7dcaa7">&nbsp;</td>
                                              <td><font size="2"><strong>2005</strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2006 <> "" then%>
                                              <td width="18" height="18" bgcolor="#f79820">&nbsp;</td>
                                              <td><font size="2"><strong>2006</strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2007 <> "" then%>
                                              <td width="18" height="18" bgcolor="#23885b">&nbsp;</td>
                                              <td><font size="2"><strong>2007</strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2008 <> "" then%>
                                              <td width="18" height="18" bgcolor="#7fa3d6">&nbsp;</td>
                                              <td><font size="2"><strong>2008</strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2009 <> "" then%>
                                              <td width="18" height="18" bgcolor="#e77368">&nbsp;</td>
                                              <td><font size="2"><strong>2009</strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2010 <> "" then%>
                                              <td width="18" height="18" bgcolor="#35cbe8">&nbsp;</td>
                                              <td><font size="2"><strong>2010</strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2011 <> "" then%>
                                              <td width="18" height="18" bgcolor="#5cb200">&nbsp;</td>
                                              <td><font size="2"><strong>2011</strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2012 <> "" then%>
                                              <td width="18" height="18" bgcolor="#0e8ccb">&nbsp;</td>
                                              <td><font size="2"><strong>2012</strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2013 <> "" then%>
                                              <td width="18" height="18" bgcolor="#e85900">&nbsp;</td>
                                              <td><font size="2"><strong>2013</strong></font></td>
                                              <%end if%>
											  <%if chequeo_2014 <> "" then%>
                                              <td width="18" height="18" bgcolor="#e85900">&nbsp;</td>
                                              <td><font size="2"><strong>2014</strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2015 <> "" then%>
                                              <td width="18" height="18" bgcolor="#e85900">&nbsp;</td>
                                              <td><font size="2"><strong>2015</strong></font></td>
                                              <%end if%>
                                            </tr>
                                    
                                            <%
                                            Dim obj_tot_sede
                                            For each obj_tot_sede in ModelTotal.Items
                                            %>
                                            <tr>
                                              <td colspan="2"><div align="left"><font size="2"><strong><%=Html.Encode(obj_tot_sede.cabecera) %></strong></font></div></td>
                                              <%if chequeo_2005 <> "" then%>
                                              <td colspan="2" bgcolor="#7dcaa7"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_sede.a2005) %></strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2006 <> "" then%>
                                              <td colspan="2" bgcolor="#f79820"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_sede.a2006) %></strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2007 <> "" then%>
                                              <td colspan="2" bgcolor="#23885b"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_sede.a2007) %></strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2008 <> "" then%>
                                              <td colspan="2" bgcolor="#7fa3d6"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_sede.a2008) %></strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2009 <> "" then%>
                                              <td colspan="2" bgcolor="#e77368"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_sede.a2009) %></strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2010 <> "" then%>
                                              <td colspan="2" bgcolor="#35cbe8"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_sede.a2010) %></strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2011 <> "" then%>
                                              <td colspan="2" bgcolor="#5cb200"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_sede.a2011) %></strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2012 <> "" then%>
                                              <td colspan="2" bgcolor="#0e8ccb"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_sede.a2012) %></strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2013 <> "" then%>
                                              <td colspan="2" bgcolor="#e85900"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_sede.a2013) %></strong></font></td>
                                              <%end if%>
											  <%if chequeo_2014 <> "" then%>
                                              <td colspan="2" bgcolor="#e85900"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_sede.a2014) %></strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2015 <> "" then%>
                                              <td colspan="2" bgcolor="#e85900"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_sede.a2015) %></strong></font></td>
                                              <%end if%>
                                            </tr>
                                              <% 
                                            Next
                                              %>
                                   </table>
                             </td>
                          </tr>
                       </table>
                   </td>
                   <td  width="40%" align="center" style='font-size: 0.6em;'>
                        <br />
                            <table id='tablaFacultad' style="display:none">
                              <caption>N° de Docentes por Grado</caption>
                              <thead>
                                 <tr>
                                  <th></th>
                                  <%if chequeo_2009 <> "" then%>
                                  <th>2009</th>
                                  <%end if%>
                                  <%if chequeo_2010 <> "" then%>
                                  <th>2010</th>
                                  <%end if%>
                                  <%if chequeo_2011 <> "" then%>
                                  <th>2011</th>
                                  <%end if%>
                                  <%if chequeo_2012 <> "" then%>
                                  <th>2012</th>
                                  <%end if%>
                                  <%if chequeo_2013 <> "" then%>
                                  <th>2013</th>
                                  <%end if%>
								  <%if chequeo_2014 <> "" then%>
                                  <th>2014</th>
                                  <%end if%>
                                  <%if chequeo_2015 <> "" then%>
                                  <th>2015</th>
                                  <%end if%>
                                </tr>
                               </thead>
                                <%
                                Dim obj2_t
                                For each obj2_T in Model.Items
                                %>
                                <tbody>
                                <tr>
                                  <th><%=Html.Encode(obj2_t.cabecera) %></th>
                                  <%if chequeo_2009 <> "" then%>
                                  <td><%=Html.Encode(obj2_t.a2009) %></td>
                                  <%end if%>
                                  <%if chequeo_2010 <> "" then%>
                                  <td><%=Html.Encode(obj2_t.a2010) %></td>
                                  <%end if%>
                                  <%if chequeo_2011 <> "" then%>
                                  <td><%=Html.Encode(obj2_t.a2011) %></td>
                                  <%end if%>
                                  <%if chequeo_2012 <> "" then%>
                                  <td><%=Html.Encode(obj2_t.a2012) %></td>
                                  <%end if%>
                                  <%if chequeo_2013 <> "" then%>
                                  <td><%=Html.Encode(obj2_t.a2013) %></td>
                                  <%end if%>
								  <%if chequeo_2014 <> "" then%>
                                  <td><%=Html.Encode(obj2_t.a2014) %></td>
                                  <%end if%>
                                  <%if chequeo_2015 <> "" then%>
                                  <td><%=Html.Encode(obj2_t.a2015) %></td>
                                  <%end if%>
                                </tr>
                                  <% 
                                Next
                               %>
                             </tbody>
                             </table>
                        <br />
                   </td>
               </tr>
             </table>
     </div>
     <br />
     <div id="titulo3" class="titulo">
     Total de horas semanales
     <input name="imagefield" type="image" src="Content/minimizar.jpg" onClick="minimizar('capa3')"/>
     <input name="imagefield" type="image" src="Content/encuadre.jpg" onClick="maximizar('capa3')"/>
     <input name="imagefield" type="image" src="Content/cerrar.jpg" style="margin-right:3px;" onClick="minimizar('capa3');minimizar('titulo3')"/>
     </div>
     <div id="capa3">
            <table width="980">
               <tr valign="top">
                   <td  width="60%" align="center" style='font-size: 0.6em;'>
						<br />
                        <table width="100%">
                        <tr valign="top">
                        <td width="100%" align="center">
                            <table bgcolor="#FFFFFF" class="tabla">
                                <tr>
                                  <th>Grado académico</th>
                                  <%if chequeo_2009 <> "" then%>
                                  <th>2009</th>
                                  <%end if%>
                                  <%if chequeo_2010 <> "" then%>
                                  <th>2010</th>
                                  <%end if%>
                                  <%if chequeo_2011 <> "" then%>
                                  <th>2011</th>
                                  <%end if%>
                                  <%if chequeo_2012 <> "" then%>
                                  <th>2012</th>
                                  <%end if%>
                                  <%if chequeo_2013 <> "" then%>
                                  <th>2013</th>
                                  <%end if%>
								  <%if chequeo_2014 <> "" then%>
                                  <th>2014</th>
                                  <%end if%>
                                   <%if chequeo_2015 <> "" then%>
                                  <th>2015</th>
                                  <%end if%>
                                </tr>
                        
                                <%
                            if  IsNothing(ModelHoras) then
                                %> <tr>
                                  <td colspan="6">Sin registros</td>
                                </tr><%
                            Else
                                Dim objh
                                For each objh in ModelHoras.Items
                                %>
                                <tr>
                                  <td><div align="left"><%=Html.Encode(objh.cabecera) %></div></td>
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
								  <%if chequeo_2014 <> "" then%>
                                  <td><%=Html.Encode(objh.a2014) %></td>
                                  <%end if%>
                                   <%if chequeo_2015 <> "" then%>
                                  <td><%=Html.Encode(objh.a2015) %></td>
                                  <%end if%>
                                </tr>
                                  <% 
                                Next
                               End If
                             %>
                              </table>
                          </td>
                          </tr>
                          <tr><td align="center">&nbsp;</td></tr>
                          <tr><td align="center">&nbsp;</td></tr>
                          <tr><td align="center">&nbsp;</td></tr>
                          <tr>
                             <td align="center">
                                 <table bgcolor="#FFFFFF" class="tabla">
                                            <tr>
                                              <td>&nbsp;</td>
                                              <td>&nbsp;</td>
                                              <%if chequeo_2005 <> "" then%>
                                              <td width="18" height="18" bgcolor="#7dcaa7">&nbsp;</td>
                                              <td><font size="2"><strong>2005</strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2006 <> "" then%>
                                              <td width="18" height="18" bgcolor="#f79820">&nbsp;</td>
                                              <td><font size="2"><strong>2006</strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2007 <> "" then%>
                                              <td width="18" height="18" bgcolor="#23885b">&nbsp;</td>
                                              <td><font size="2"><strong>2007</strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2008 <> "" then%>
                                              <td width="18" height="18" bgcolor="#7fa3d6">&nbsp;</td>
                                              <td><font size="2"><strong>2008</strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2009 <> "" then%>
                                              <td width="18" height="18" bgcolor="#e77368">&nbsp;</td>
                                              <td><font size="2"><strong>2009</strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2010 <> "" then%>
                                              <td width="18" height="18" bgcolor="#35cbe8">&nbsp;</td>
                                              <td><font size="2"><strong>2010</strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2011 <> "" then%>
                                              <td width="18" height="18" bgcolor="#5cb200">&nbsp;</td>
                                              <td><font size="2"><strong>2011</strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2012 <> "" then%>
                                              <td width="18" height="18" bgcolor="#0e8ccb">&nbsp;</td>
                                              <td><font size="2"><strong>2012</strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2013 <> "" then%>
                                              <td width="18" height="18" bgcolor="#e85900">&nbsp;</td>
                                              <td><font size="2"><strong>2013</strong></font></td>
                                              <%end if%>
											  <%if chequeo_2014 <> "" then%>
                                              <td width="18" height="18" bgcolor="#e85900">&nbsp;</td>
                                              <td><font size="2"><strong>2014</strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2015 <> "" then%>
                                              <td width="18" height="18" bgcolor="#e85900">&nbsp;</td>
                                              <td><font size="2"><strong>2015</strong></font></td>
                                              <%end if%>
                                            </tr>
                                            <%
                                            Dim obj_tot_horas
                                            For each obj_tot_horas in ModelTotalHoras.Items
                                            %>
                                            <tr>
                                              <td colspan="2"><div align="left"><font size="2"><strong><%=Html.Encode(obj_tot_horas.cabecera) %></strong></font></div></td>
                                              <%if chequeo_2005 <> "" then%>
                                              <td colspan="2" bgcolor="#7dcaa7"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_horas.a2005) %></strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2006 <> "" then%>
                                              <td colspan="2" bgcolor="#f79820"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_horas.a2006) %></strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2007 <> "" then%>
                                              <td colspan="2" bgcolor="#23885b"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_horas.a2007) %></strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2008 <> "" then%>
                                              <td colspan="2" bgcolor="#7fa3d6"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_horas.a2008) %></strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2009 <> "" then%>
                                              <td colspan="2" bgcolor="#e77368"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_horas.a2009) %></strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2010 <> "" then%>
                                              <td colspan="2" bgcolor="#35cbe8"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_horas.a2010) %></strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2011 <> "" then%>
                                              <td colspan="2" bgcolor="#5cb200"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_horas.a2011) %></strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2012 <> "" then%>
                                              <td colspan="2" bgcolor="#0e8ccb"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_horas.a2012) %></strong></font></td>
                                              <%end if%>
                                              <%if chequeo_2013 <> "" then%>
                                              <td colspan="2" bgcolor="#e85900"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_horas.a2013) %></strong></font></td>
                                              <%end if%>
											  <%if chequeo_2014 <> "" then%>
                                              <td colspan="2" bgcolor="#e85900"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_horas.a2014) %></strong></font></td>
                                              <%end if%>
                                               <%if chequeo_2015 <> "" then%>
                                              <td colspan="2" bgcolor="#e85900"><font color="#FFFFFF" size="2"><strong><%=Html.Encode(obj_tot_horas.a2015) %></strong></font></td>
                                              <%end if%>
                                            </tr>
                                              <% 
                                            Next
                                              %>
                                   </table>
                             </td>
                          </tr>
                       </table>
                       <br />
                   </td>
                   <td  width="40%" align="center" style='font-size: 0.6em;'>
                        <br />
                             <table id='tablaHoras' style="display:none">
                              <caption>Horas semanales por Grado</caption>
                              <thead>
                                 <tr>
                                  <th></th>
                                  <%if chequeo_2009 <> "" then%>
                                  <th>2009</th>
                                  <%end if%>
                                  <%if chequeo_2010 <> "" then%>
                                  <th>2010</th>
                                  <%end if%>
                                  <%if chequeo_2011 <> "" then%>
                                  <th>2011</th>
                                  <%end if%>
                                  <%if chequeo_2012 <> "" then%>
                                  <th>2012</th>
                                  <%end if%>
                                  <%if chequeo_2013 <> "" then%>
                                  <th>2013</th>
                                  <%end if%>
								  <%if chequeo_2014 <> "" then%>
                                  <th>2014</th>
                                  <%end if%>
                                   <%if chequeo_2015 <> "" then%>
                                  <th>2015</th>
                                  <%end if%>
                                </tr>
                               </thead>
                                <%
                                Dim obj2h_t
                                For each obj2h_T in ModelHoras.Items
                                %>
                                <tbody>
                                <tr>
                                  <th><%=Html.Encode(obj2h_t.cabecera) %></th>
                                  <%if chequeo_2009 <> "" then%>
                                  <td><%=Html.Encode(obj2h_t.a2009) %></td>
                                  <%end if%>
                                  <%if chequeo_2010 <> "" then%>
                                  <td><%=Html.Encode(obj2h_t.a2010) %></td>
                                  <%end if%>
                                  <%if chequeo_2011 <> "" then%>
                                  <td><%=Html.Encode(obj2h_t.a2011) %></td>
                                  <%end if%>
                                  <%if chequeo_2012 <> "" then%>
                                  <td><%=Html.Encode(obj2h_t.a2012) %></td>
                                  <%end if%>
                                  <%if chequeo_2013 <> "" then%>
                                  <td><%=Html.Encode(obj2h_t.a2013) %></td>
                                  <%end if%>
								  <%if chequeo_2014 <> "" then%>
                                  <td><%=Html.Encode(obj2h_t.a2014) %></td>
                                  <%end if%>
                                  <%if chequeo_2015 <> "" then%>
                                  <td><%=Html.Encode(obj2h_t.a2015) %></td>
                                  <%end if%>
                                </tr>
                                  <% 
                                Next
                               %>
                             </tbody>
                             </table>
                            <br />
                   </td>
               </tr>
             </table>
       </div>
     <br />
    <table width="100%" height="30">
    	<tr>
           <td width="100%">&nbsp;</td>
        </tr>
    </table> 
    </div> 
    <br />
    <br />
    <br />
           <!--</div>-->

    