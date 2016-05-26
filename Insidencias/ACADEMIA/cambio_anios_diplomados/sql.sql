select * from diplomados_cursos
where DCUR_NCORR in (
1074,
1075,
1076,
1077,
1010,
1062,
1063,
1071,
1069,
1066,
1087,
1068
)


-- 2015
update diplomados_cursos
set dcur_tdesc = REPLACE(dcur_tdesc, '2016', '2015')
where DCUR_NCORR in (
1074,
1075,
1076,
1077,
1010,
1062,
1063,
1071,
1069,
1066,
1087,
1068
)

-- 2016
update diplomados_cursos
set dcur_tdesc = REPLACE(dcur_tdesc, '2015', '2016')
where DCUR_NCORR in (
1084,
1085,
1073,
1093,
1082,
1098,
1097,
1099,
1101,
1100,
1096,
1072
)

-- melipilla 

-- 2016
update diplomados_cursos
set dcur_tdesc = REPLACE(dcur_tdesc, '2015', '2016')
where DCUR_NCORR in (
1086,
1089
)













