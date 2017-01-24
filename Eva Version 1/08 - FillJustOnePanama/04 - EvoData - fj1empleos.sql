-- 'Inserting values into  emp_empleos '
SET IDENTITY_INSERT exp.emp_empleos ON 
INSERT  into exp.emp_empleos  
( emp_codigo ,  emp_codplz ,  emp_codexp ,  emp_estado ,  emp_estado_activo , 
  emp_fecha_ingreso ,  emp_fecha_retiro ,  emp_codcmr ,  emp_codmrt ,  emp_codtco ,  
  emp_codjor ,  emp_codtpl ,  emp_contrato_ini ,  emp_contrato_fin ,  emp_property_bag_data ) 
  VALUES 
  (1, 1, 1, 'A', 'A',
  convert(DATE,'01/09/2001'), NULL, NULL, NULL, 1,
  1, 1, convert(DATE,'01/09/2001'), NULL, null
);
SET IDENTITY_INSERT exp.emp_empleos Off 