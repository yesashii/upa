/* ***************************************************** */
/* 			ELIMINAR ORDEN DE COMPRA OTEC				*/
/* *************************************************** */

-- Se pide eliminar OC: 3122015

select * 
from   ordenes_compras_otec 
where  nord_compra = 3122015 

-- esto trae:

-- INSERT INTO .. ([dgso_ncorr], [empr_ncorr], [nord_compra], [empr_ncorr_2], [fpot_ccod], [ocot_nalumnos], [ocot_monto_otic], [ocot_monto_empresa], [AUDI_TUSUARIO], [AUDI_FMODIFICACION], [tdet_ccod], [ddcu_mdescuento], [monto_descuento_estimado], [monto_descuento_editado], [ocot_NRO_REGISTRO_SENCE], [orco_ncorr], [ocot_monto_persona]) VALUES ('1034', '135696', '3122015', NULL, '2', '35', '0', '735000', '11667970', '2015-12-11 10:04:34.350', '0', '.000', '0', '0', '0', '1400', NULL);

-- dgso_ncorr = 1034

-- vemos si hay más de una boleta a esa sección 

select * 
from   ordenes_compras_otec 
where  dgso_ncorr = 1034 

-- esto trae:

--1034	135696	508		NULL	2	35	0	4506326		11667970	2015-04-28 17:54:53.567	0	0.000	0	0	0	1348	NULL
--1034	135696	3122015	NULL	2	35	0	735000		11667970	2015-12-11 10:04:34.350	0	0.000	0	0	0	1400	NULL	


-- entonces en postulacion_otec está duplicado, por tanto se debe eliminar la OC y los alumnos en postulacion_otec con el número de órden de compra.


-- primero eliminamos la orden de compra

delete from ordenes_compras_otec 
where  nord_compra = 3122015 
       and dgso_ncorr = 1034 

-- luego se eliminan los duplicados en el curso.

-- Respaldo:

/*
select * from postulacion_otec
where  norc_empresa = 3122015 
and dgso_ncorr = 1034 



17327	198490	4	2015-04-28 18:20:52.390	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17590	277662	4	2015-12-11 10:05:07.317	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17591	278225	4	2015-12-11 10:05:20.387	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17592	278226	4	2015-12-11 10:05:35.693	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17593	278227	4	2015-12-11 10:05:48.670	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17594	278228	4	2015-12-11 10:06:00.067	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17595	278230	4	2015-12-11 10:06:14.237	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17596	278231	4	2015-12-11 10:06:27.470	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17597	278232	4	2015-12-11 10:06:39.977	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17598	278233	4	2015-12-11 10:06:52.150	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17599	99615	4	2015-12-11 10:07:17.020	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17600	278234	4	2015-12-11 10:07:30.043	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17601	182330	4	2015-12-11 10:07:55.517	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17602	278235	4	2015-12-11 10:08:10.480	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17603	278236	4	2015-12-11 10:08:25.783	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17605	278237	4	2015-12-11 10:11:04.390	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17606	278238	4	2015-12-11 10:14:00.933	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17607	278239	4	2015-12-11 10:14:20.577	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17608	278240	4	2015-12-11 10:14:55.640	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17609	278242	4	2015-12-11 10:16:43.330	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17610	272727	4	2015-12-11 10:17:03.497	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17611	278243	4	2015-12-11 10:17:20.850	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17612	278244	4	2015-12-11 10:17:40.123	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17614	276416	4	2015-12-11 10:18:17.877	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17615	173254	4	2015-12-11 10:18:51.720	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17616	278245	4	2015-12-11 10:19:50.050	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17617	278246	4	2015-12-11 10:20:03.730	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17618	278247	4	2015-12-11 10:20:18.230	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17619	278248	4	2015-12-11 10:20:51.570	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17620	278249	4	2015-12-11 10:21:04.610	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17621	281488	4	2015-12-11 10:21:39.863	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17622	278250	4	2015-12-11 10:21:59.427	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17623	278251	4	2015-12-11 10:22:11.660	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17624	278252	4	2015-12-11 10:22:29.923	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
17628	278241	4	2015-12-11 10:40:48.107	1034	0	2	135696	3122015	NULL	NULL	8	0	1	1	NULL	11667970	2015-12-11 10:42:57.163	330353	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
*/

delete from postulacion_otec 
where  norc_empresa = 3122015 
       and dgso_ncorr = 1034 



