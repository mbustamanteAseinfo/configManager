/* Script Generado por Evolution - Editor de Formulación de Planillas. 16-01-2017 11:45 AM */

begin transaction

delete from [sal].[fac_factores] where [fac_codigo] = '0d214ad6-e1ef-4500-aa69-51fbe539c264' and fac_codpai = 'pa';

insert into [sal].[fac_factores] ([fac_codigo],[fac_id],[fac_descripcion],[fac_vbscript],[fac_codfld],[fac_codpai],[fac_size]) values ('0d214ad6-e1ef-4500-aa69-51fbe539c264','SalarioBruto','Cálculo del Salario Bruto','Function SalarioBruto()
dep = Factores("DescuentoTNT").Value + Factores("DescuentoIncapacidad").Value 

if dep > Factores("SueldoQuincenal").Value then
   if Factores("DescuentoTNT").Value = 0 then
      '' Solo se descuenta incapacidad
      Factores("DescuentoIncapacidad").Value = Factores("SueldoQuincenal").Value

   elseif Factores("DescuentoIncapacidad").Value = 0 then
      '' Solo se descuenta TNT
      Factores("DescuentoTNT").Value = Factores("SueldoQuincenal").Value 

   else
      '' Los dos tienen valor, prioriza corregiendo primero el TNT
      dep = Factores("SueldoQuincenal").Value - Factores("DescuentoTNT").Value - Factores("DescuentoIncapacidad").Value 
      
      if dep < 0 then
            msgbox "El valor de los descuentos de tiempo no trabajado + incapacidad + descuentos ciclicos son mayores que el salario quincenal del empleado con código" & Emp_InfoSalario.Fields("emp_codigo").Value
      else     
        ''if Factores("DescuentoTNT").Value + dep > 0 then
        ''    Factores("DescuentoTNT").Value = Factores("DescuentoTNT").Value + dep
        ''else
        if Factores("DescuentoIncapacidad").Value + dep > 0 then
            Factores("DescuentoIncapacidad").Value = Factores("DescuentoIncapacidad").Value + dep
        end if
      end if
    end if
end if

if not isnull(Factores("DescuentoIncapacidad").CodTipoDescuento) and Factores("DescuentoIncapacidad").Value > 0 then
   agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("DescuentoIncapacidad").CodTipoDescuento, _
                               Factores("DescuentoIncapacidad").Value, 0, 0, _ 
                               "PAB", _
                               Factores("DiasDescuentoIncap").Value, _
                               "Dias"
end if

if not isnull(Factores("DescuentoTNT").CodTipoDescuento) and Factores("DescuentoTNT").Value > 0 and 1 = 2 then
   agrega_descuentos_historial Agrupadores, _
                               DescuentosEstaPlanilla, _
                               Emp_InfoSalario.Fields("EMP_CODIGO").Value, _
                               Pla_Periodo.Fields("PPL_CODPPL").Value, _
                               Factores("DescuentoTNT").CodTipoDescuento, _
                               Factores("DescuentoTNT").Value, 0, 0, _
                               "PAB", _
                               Factores("HorasTNT").Value, _
                               "Dias"                               
end if

Var_SalarioBruto = Factores("SueldoQuincenal").Value + _
                   Factores("Extraordinario").Value + _
                   Factores("GastoRepresentacion").Value + _                   
                   Factores("IngCiclicos").Value + _
                   Factores("DevRenta").Value + _
                   Factores("OtrosIngresos").Value - _
                   Factores("DescuentoTNT").Value - _
                   Factores("DescuentoIncapacidad").Value + _
                   Factores("Retroactivo").Value + _
                   Factores("RetroactivoGastoRep").Value

if var_salariobruto < 0 then
   var_salariobruto = 0
end if

SalarioBruto = var_salariobruto
End Function','double','pa',0);

commit transaction;
