  Select distinct b.pers_ncorr,b.pers_tnombre + ' ' + b.pers_tape_paterno + ' ' + b.pers_tape_materno as nombre_docente,    
	    case e.tpro_ccod when 1 then 'DOCENTE' when 2 then 'AYUDANTE' end as tipo_docente,    
 	    d.ciud_tdesc,a.DIRE_TCALLE,a.DIRE_TNRO,    
	    a.DIRE_TPOBLACION,a.DIRE_TBLOCK,a.DIRE_TDEPTO,a.DIRE_TLOCALIDAD,b.pers_tfono as fono,    
	    f.eciv_tdesc,cast(pers_nrut as varchar)+ '-' + pers_xdv as rut,    
 	    isnull(c.pais_tnacionalidad,c.pais_tdesc) as nacionalidad,protic.trunc(b.pers_fnacimiento) as fecha_nac,getdate() as fecha_actual,    
 	    (select min(prof_ingreso_uas)  from profesores where pers_ncorr=b.pers_ncorr group by pers_ncorr)as año_ingreso_upacifico,g.cudo_tinstitucion as institucion,
        case g.grac_ccod when 1 then ' TÉCNICO ' when 2 then ' PROFESIONAL ' else '' end as tipo_titulo,g.CUDO_TITULO as Nombre_TITULO,g.cudo_ano_egreso as año_egreso
        --,protic.obtener_grado_docente(b.pers_ncorr,'G') as grado_docente
     ,'----------- Exp. Laboral----------------' as etapa1   
      -- experiancia labolar
      ,g.cudo_tinstitucion as institucion_exp,    
	  g.cudo_tdescripcion_experiencia as descripcion_cargo,  
	  cast(DATEPART(year, g.cudo_finicio) as varchar) + '-' + cast(DATEPART(year, g.cudo_ftermino) as varchar) as rango_fecha,    
	  protic.trunc(g.cudo_finicio) as fecha_inicio,protic.trunc(g.cudo_ftermino) as fecha_termino,g.cudo_tactividad as actividad,    
      case isnull(g.cudo_anos_experiencia,0)     
	  when 0 then     
	  case     
	      when DATEDIFF(month,g.cudo_finicio,g.cudo_ftermino)>=1 and  DATEDIFF(month,g.cudo_finicio,g.cudo_ftermino)<=5 then cast(DATEDIFF(month,g.cudo_finicio,g.cudo_ftermino) as varchar)+ ' Meses'    
          when DATEDIFF(month,g.cudo_finicio,g.cudo_ftermino)<1 then cast(DATEDIFF(day,g.cudo_finicio,g.cudo_ftermino) as varchar)+ ' Dias'    
      else cast(ceiling(DATEDIFF(month,g.cudo_finicio,g.cudo_ftermino)/cast(12 as decimal)) as varchar)+ ' Años'  end else cast(g.cudo_anos_experiencia as varchar) + ' Años' end as  cudo_anos_experiencia    
	  -- fin experiencia laboral
      ,'----------- Exp. Docencia----------------' as etapa2
      -- experiencia docente
      ,h.cudo_tinstitucion as institucion,h.cudo_tactividad as actividad,    
	  h.cudo_trubro_institucion as rubro_institucion,h.cudo_anos_experiencia as años_experiencia,i.pais_tdesc as pais,h.cudo_tdescripcion_experiencia as descripcion_experiencia,   
	  cast(DATEPART(year, h.cudo_finicio) as varchar) + '-' + cast(DATEPART(year, h.cudo_ftermino) as varchar) as rango_fecha
      -- fin experiencia docente 
      ,'----------- Publicaciones----------------' as etapa3
      -- inicio publicaciones 
        ,protic.trunc(j.publ_fpublicacion) as fecha_publicacion,
		 j.publ_tdesc as publicacion,j.publ_tmedio as medio,j.publ_tautoria as autoria,k.pais_tdesc as pais_publicado
      -- fin publicaciones
      ,'----------- Investigaciones----------------' as etapa4
      -- inicio investigaciones       
        ,protic.trunc(m.publ_fpublicacion) as fecha_investigacion,     
	    m.publ_tdesc as investigacion,m.publ_tmedio as medio,m.publ_tautoria as autoria,n.pais_tdesc as pais
      -- fin investigaciones
      ,'----------- Otras Actividades----------------' as etapa5
      -- inicio otras actividades
      ,o.publ_totrasactividades as otras_actividades
      -- inicio otras actividades
      ,protic.obtener_carreras_docente_anuales(b.pers_ncorr,2006) as carreras
        from personas b    
	  left outer join direcciones a    
	     on b.pers_ncorr = a.pers_ncorr and 1 = a.tdir_ccod    
	  left outer join paises c    
	     on c.pais_ccod = b.pais_ccod    
	  left outer join ciudades d    
	     on d.ciud_ccod = a.ciud_ccod    
	  left outer join profesores e    
	     on e.pers_ncorr =b.pers_ncorr
         and e.tpro_ccod=1
	  left outer join estados_civiles f    
      	 on b.eciv_ccod=f.eciv_ccod
      left outer join  curriculum_docente g
         --on  c.pais_ccod = g.pais_ccod
         on b.pers_ncorr =g.pers_ncorr
         and g.tiex_ccod in (3,4)
      left outer join  curriculum_docente h
         on b.pers_ncorr =h.pers_ncorr
         and h.tiex_ccod in (1,2)              
	  left outer join paises i
        on h.pais_ccod=i.pais_ccod
      left outer join publicacion_docente j
        on b.pers_ncorr=j.pers_ncorr
        and j.tpub_ccod = 1 
      left outer join paises k
        on j.pais_ccod=k.pais_ccod
      left outer join publicacion_docente m
        on b.pers_ncorr=m.pers_ncorr
        and m.tpub_ccod = 2 
      left outer join paises n
        on m.pais_ccod=n.pais_ccod
      left outer join publicacion_docente o
        on b.pers_ncorr=o.pers_ncorr
        and o.tpub_ccod = 3 
    where cast(b.pers_ncorr as varchar) in (
                     select distinct a.pers_ncorr 
                        from bloques_profesores a, bloques_horarios b, secciones c 
                        where a.bloq_ccod=b.bloq_ccod
                        and b.secc_ccod=c.secc_ccod
                        and c.peri_ccod in (204,202)
                        )