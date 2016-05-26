  Select distinct b.pers_nrut as codigo, 'A' as estado,'' as numero_ficha,'' as es_ficha,'' as tipo_remuneracion,
            '' as codigo_sub_empresa, b.pers_tape_paterno + '  ' + b.pers_tape_materno+ ' ' +b.pers_tnombre  as nombre,
            case when b.sexo_ccod=1 then 'M' else 'F' end as sexo, 
            a.DIRE_TCALLE+';'+a.DIRE_TNRO+';;'+a.DIRE_TDEPTO+';'+cast(d.ciud_ccod as varchar)+';'+d.ciud_tcomuna+';'+cast(regi_ccod as varchar)+';'+a.DIRE_TPOBLACION+' '+a.DIRE_TBLOCK as direccion,   
	    case e.tpro_ccod when 1 then 'DOCENTE' when 2 then 'AYUDANTE' end as tipo_docente,    
        b.pers_tfono as telefono,protic.trunc(b.pers_fnacimiento) as fecha_nac,    
 	    isnull(c.pais_tnacionalidad,c.pais_tdesc) as nacionalidad,getdate() as fecha_actual,    
 	    g.cudo_tinstitucion,case g.grac_ccod when 1 then ' TÉCNICO ' when 2 then ' PROFESIONAL ' else '' end as tipo_titulo,g.CUDO_TITULO as Nombre_TITULO,g.cudo_ano_egreso
        --,protic.obtener_grado_docente(b.pers_ncorr,'G') as grado_docente
     ,'----------- laboral----------------' as etapa1   
      -- experiancia labolar
      ,l.tiex_tdesc as tipo_experiencia,g.cudo_tinstitucion as institucion_exp,    
	  g.cudo_tdescripcion_experiencia as descripcion_cargo,g.cudo_trubro_institucion, i.pais_tdesc, 
	  cast(DATEPART(year, g.cudo_finicio) as varchar) + '-' + cast(DATEPART(year, g.cudo_ftermino) as varchar) as rango_fecha,    
	  protic.trunc(g.cudo_finicio) as fecha_inicio,protic.trunc(g.cudo_ftermino) as fecha_termino,g.cudo_tactividad,    
      case isnull(g.cudo_anos_experiencia,0)     
	  when 0 then     
	  case     
	      when DATEDIFF(month,g.cudo_finicio,g.cudo_ftermino)>=1 and  DATEDIFF(month,g.cudo_finicio,g.cudo_ftermino)<=5 then cast(DATEDIFF(month,g.cudo_finicio,g.cudo_ftermino) as varchar)+ ' Meses'    
          when DATEDIFF(month,g.cudo_finicio,g.cudo_ftermino)<1 then cast(DATEDIFF(day,g.cudo_finicio,g.cudo_ftermino) as varchar)+ ' Dias'    
      else cast(ceiling(DATEDIFF(month,g.cudo_finicio,g.cudo_ftermino)/cast(12 as decimal)) as varchar)+ ' Años'  end else cast(g.cudo_anos_experiencia as varchar) + ' Años' end as  cudo_anos_experiencia    
	  -- fin experiencia laboral
        from personas b    
	  left outer join direcciones a    
	     on b.pers_ncorr = a.pers_ncorr 
         and 1 = a.tdir_ccod    
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
         on b.pers_ncorr =g.pers_ncorr
      join tipo_experiencia_laboral l
        on g.tiex_ccod=l.tiex_ccod
	  left outer join paises i
        on g.pais_ccod=i.pais_ccod
      where cast(b.pers_ncorr as varchar) in (
                     select distinct a.pers_ncorr 
                        from bloques_profesores a, bloques_horarios b, secciones c 
                        where a.bloq_ccod=b.bloq_ccod
                        and b.secc_ccod=c.secc_ccod
                        and c.peri_ccod in (204,202)
                        )
      and g.tiex_ccod in (1,3,4)   
        
        