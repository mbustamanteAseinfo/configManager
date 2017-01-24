select * into tbl_temp_documentos_pan from exp.tdo_tipos_de_documento where tdo_codpai = 'pa';
GO
delete from tbl_temp_documentos_pan;
GO
insert into tbl_temp_documentos_pan(tdo_codpai, tdo_descripcion, tdo_abreviatura, tdo_nombre_por_segmento, tdo_fmt_nombre_completo) values ('pa','C�dula','CIP',0, '{0} {1} {2} {3} {4} {5}'),
('pa','Documento SAP','SAP',0,'{0} {1} {2} {3} {4} {5}'),
('pa','Pasaporte','PAS',0,'{0} {1} {2} {3} {4} {5}'),
('pa','Seguro Social','SS',0,'{0} {1} {2} {3} {4} {5}'),
('pa','Carnet Blanco','CBL',0,'{0} {1} {2} {3} {4} {5}'),
('pa','Carnet Verde','CVE',0,'{0} {1} {2} {3} {4} {5}'),
('pa','Licencia de Conducir','LICC',0,'{0} {1} {2} {3} {4} {5}'),
('pa','Permiso de Trabajo','PTR',0,'{0} {1} {2} {3} {4} {5}'),
('pa','Carnet de Migraci�n','CMI',0,'{0} {1} {2} {3} {4} {5}'),
('pa','Crisol de Razas','--CRR',0,'{0} {1} {2} {3} {4} {5}'),
('pa','Fondo de Cesant�as','FCES',0,'{0} {1} {2} {3} {4} {5}'),
('pa','Ficha Digital CSS','FDIG',0,'{0} {1} {2} {3} {4} {5}');
GO
insert exp.tdo_tipos_de_documento(tdo_codpai, tdo_descripcion, tdo_abreviatura, tdo_nombre_por_segmento, tdo_fmt_nombre_completo) select tdo_codpai, tdo_descripcion, tdo_abreviatura, tdo_nombre_por_segmento, tdo_fmt_nombre_completo from tbl_temp_documentos_pan where tdo_descripcion not in (select tdo_descripcion from exp.tdo_tipos_de_documento);
GO
drop table tbl_temp_documentos_pan;
GO