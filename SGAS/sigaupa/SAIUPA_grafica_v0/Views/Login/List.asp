<style>

body
{
    font: 12px 'Lucida Sans Unicode', 'Trebuchet MS', Arial, Helvetica;  
	text-align: center;  
}

/*--------------------*/

#login
{
    background-color: #F2F5A9;
    background-image: -webkit-gradient(linear, left top, left bottom, from(#F2F5A9), to(#eee));
    background-image: -webkit-linear-gradient(top, #F2F5A9, #eee);
    background-image: -moz-linear-gradient(top, #F2F5A9, #eee);
    background-image: -ms-linear-gradient(top, #F2F5A9, #eee);
    background-image: -o-linear-gradient(top, #F2F5A9, #eee);
    background-image: linear-gradient(top, #F2F5A9, #eee);  
    height: 260px;
    width: 600px;
    margin: 50px 0 0 0;
    padding: 30px;
    z-index: 1;
    -moz-border-radius: 3px;
    -webkit-border-radius: 3px;
    border-radius: 3px;  
    -webkit-box-shadow:
          0 0 2px rgba(0, 0, 0, 0.2),
          0 1px 1px rgba(0, 0, 0, .2),
          0 3px 0 #F2F5A9,
          0 4px 0 rgba(0, 0, 0, .2),
          0 6px 0 #fff,  
          0 7px 0 rgba(0, 0, 0, .2);
    -moz-box-shadow:
          0 0 2px rgba(0, 0, 0, 0.2),  
          1px 1px   0 rgba(0,   0,   0,   .1),
          3px 3px   0 rgba(255, 255, 255, 1),
          4px 4px   0 rgba(0,   0,   0,   .1),
          6px 6px   0 rgba(255, 255, 255, 1),  
          7px 7px   0 rgba(0,   0,   0,   .1);
    box-shadow:
          0 0 2px rgba(0, 0, 0, 0.2),  
          0 1px 1px rgba(0, 0, 0, .2),
          0 3px 0 #F2F5A9,
          0 4px 0 rgba(0, 0, 0, .2),
          0 6px 0 #F2F5A9,  
          0 7px 0 rgba(0, 0, 0, .2);
}

#login:before
{
    content: '';
    position: absolute;
    z-index: 1;
    border: 1px dashed #ccc;
    top: 5px;
    bottom: 5px;
    left: 5px;
    right: 5px;
    -moz-box-shadow: 0 0 0 1px #F2F5A9;
    -webkit-box-shadow: 0 0 0 1px #F2F5A9;
    box-shadow: 0 0 0 1px #F2F5A9;
}

/*--------------------*/

h1
{
    text-shadow: 0 1px 0 rgba(255, 255, 255, .7), 0px 2px 0 rgba(0, 0, 0, .5);
    text-transform: uppercase;
    text-align: center;
    color: #666;
    margin: 0 0 30px 0;
    letter-spacing: 4px;
    font: normal 26px/1 Verdana, Helvetica;
    position: relative;
}

h6
{
    text-align: center;
    color: #fff;
    margin: 100px 0 30px 0;
    letter-spacing: 4px;
    font: normal 18px/1 Verdana, Helvetica;
    position: relative;
}

h1:after, h1:before
{
    background-color: #777;
    content: "";
    height: 1px;
    position: absolute;
    top: 15px;
    width: 120px;   
}

h1:after
{ 
    background-image: -webkit-gradient(linear, left top, right top, from(#777), to(#fff));
    background-image: -webkit-linear-gradient(left, #777, #fff);
    background-image: -moz-linear-gradient(left, #777, #fff);
    background-image: -ms-linear-gradient(left, #777, #fff);
    background-image: -o-linear-gradient(left, #777, #fff);
    background-image: linear-gradient(left, #777, #fff);      
    right: 0;
}

h1:before
{
    background-image: -webkit-gradient(linear, right top, left top, from(#777), to(#fff));
    background-image: -webkit-linear-gradient(right, #777, #fff);
    background-image: -moz-linear-gradient(right, #777, #fff);
    background-image: -ms-linear-gradient(right, #777, #fff);
    background-image: -o-linear-gradient(right, #777, #fff);
    background-image: linear-gradient(right, #777, #fff);
    left: 0;
}

/*--------------------*/

fieldset
{
    border: 0;
    padding: 0;
    margin: 0;
}

/*--------------------*/


#actions a
{
    color: #3151A2;    
    float: right;
    line-height: 35px;
    margin-left: 10px;
}

/*--------------------*/

#back
{
    display: block;
    text-align: center;
    position: relative;
    top: 60px;
    color: #999;
}


</style>
<%
  pers = session("_pers_ncorr_")
%>
<div id="cuadro0">
<h6><font color="#444444">Sistema de Análisis Institucional<br /></font></h6>
	<div id="capa4">
        <table align="center" width="100%">
        <tr>
            <td width="100%" align="center">
                    <form id="login">
                        <h1>Bienvenido</h1>
                        <h4>El sistema de Indicadores está orientado a entregar en un solo sitio el acceso a los indicadores principales, informados por la Universidad a Instituciones Externas.</br>
                            En el menú superior podrá encontrar todos los indicadores institucionales que se encuentran validados por Dirección de análisis.</br>En el caso de requerir un indicador diferente, favor comunicarse con dicha dirección.
                            <div align="right"><img width="96" height="96" src="Content/chart_pie.png" /></div>
                        </h4>
                        
                    </form>
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

