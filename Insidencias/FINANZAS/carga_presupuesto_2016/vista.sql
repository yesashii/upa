create view protic.vis_ejecucion_presupuesto_anual_2016 as        
        
 	   SELECT cod_anio, cod_pre, cod_area, descripcion_area, concepto,detalle,1 as mes,enero As valor
        FROM protic.presupuesto_upa_2016
        UNION ALL
        SELECT cod_anio, cod_pre, cod_area, descripcion_area, concepto,detalle,2 as mes,febrero As valor   
        FROM protic.presupuesto_upa_2016
        UNION ALL
        SELECT cod_anio, cod_pre, cod_area, descripcion_area, concepto,detalle,3 as mes,marzo As valor   
        FROM protic.presupuesto_upa_2016
        UNION ALL
        SELECT cod_anio, cod_pre, cod_area, descripcion_area, concepto,detalle,4 as mes,abril As valor   
        FROM protic.presupuesto_upa_2016
        UNION ALL
        SELECT cod_anio, cod_pre, cod_area, descripcion_area, concepto,detalle,5 as mes,mayo As valor   
        FROM protic.presupuesto_upa_2016
        UNION ALL
        SELECT cod_anio, cod_pre, cod_area, descripcion_area, concepto,detalle,6 as mes,junio As valor   
        FROM protic.presupuesto_upa_2016
        UNION ALL
        SELECT cod_anio, cod_pre, cod_area, descripcion_area, concepto,detalle,7 as mes,julio As valor   
        FROM protic.presupuesto_upa_2016
        UNION ALL
        SELECT cod_anio, cod_pre, cod_area, descripcion_area, concepto,detalle,8 as mes,agosto As valor   
        FROM protic.presupuesto_upa_2016
        UNION ALL
        SELECT cod_anio, cod_pre, cod_area, descripcion_area, concepto,detalle,9 as mes,septiembre As valor   
        FROM protic.presupuesto_upa_2016
        UNION ALL
        SELECT cod_anio, cod_pre, cod_area, descripcion_area, concepto,detalle,10 as mes,octubre As valor   
        FROM protic.presupuesto_upa_2016
        UNION ALL
        SELECT cod_anio, cod_pre, cod_area, descripcion_area, concepto,detalle,11 as mes,noviembre As valor   
        FROM protic.presupuesto_upa_2016
        UNION ALL
        SELECT cod_anio, cod_pre, cod_area, descripcion_area, concepto,detalle,12 as mes,diciembre As valor   
        FROM protic.presupuesto_upa_2016