--Inclusion criteria: Patients on any of the following drugs through 1/22/2020:
--Adalimumab [Humira OR Hadlima OR Imraldi OR Exemptia OR Amfrar OR Amjevita OR Cyltezo OR Idacio], Infliximab [Avakine OR Flixabi OR Inflectra OR Ixifi OR Remicade OR Remsima OR Renflexis OR Revellex OR Zessly], Etanercept [Enbrel OR Etacept OR Benepali OR Erelzi], Certolizumab [Cimzia], Golimumab [Simponi].


SELECT DISTINCT p.ir_id
FROM fact.vw_medication_order mo
	JOIN dim.vw_medication m
		ON m.medication_key = mo.medication_key
	JOIN dim.vw_medication_order_profile mop
		ON mop.medication_order_profile_key = mo.medication_order_profile_key
		AND ISNULL(mop.order_status,'') NOT IN ('Canceled', 'Voided', 'Order Canceled', 'Voided With Results', 'Future', 'Incomplete')
		AND ISNULL(mop.order_class,'') <> 'Facility Administered'
	JOIN dim.vw_patient p
		ON p.patient_key = mo.patient_key
	LEFT JOIN fact.vw_medication_administration mar
		ON mar.medication_order_key = mo.medication_order_key
WHERE (m.medication_name LIKE '%Adalimumab%'
OR m.medication_name LIKE '%Humira%'
OR m.medication_name LIKE '%Hadlima%'
OR m.medication_name LIKE '%Imraldi%'
OR m.medication_name LIKE '%Exemptia%'
OR m.medication_name LIKE '%Amfrar%'
OR m.medication_name LIKE '%Amjevita%'
OR m.medication_name LIKE '%Cyltezo%'
OR m.medication_name LIKE '%Idacio%'
OR m.medication_name LIKE '%Infliximab%'
OR m.medication_name LIKE '%Avakine%'
OR m.medication_name LIKE '%Flixabi%'
OR m.medication_name LIKE '%Inflectra%'
OR m.medication_name LIKE '%Ixifi%'
OR m.medication_name LIKE '%Remicade%'
OR m.medication_name LIKE '%Remsima%'
OR m.medication_name LIKE '%Renflexis%'
OR m.medication_name LIKE '%Revellex%'
OR m.medication_name LIKE '%Zessly%'
OR m.medication_name LIKE '%Etanercept%'
OR m.medication_name LIKE '%Enbrel%'
OR m.medication_name LIKE '%Etacept%'
OR m.medication_name LIKE '%Benepali%'
OR m.medication_name LIKE '%Erelzi%'
OR m.medication_name LIKE '%Certolizumab%'
OR m.medication_name LIKE '%Cimzia%'
OR m.medication_name LIKE '%Golimumab%'
OR m.medication_name LIKE '%Simponi%'
OR m.generic_name LIKE '%Adalimumab%'
OR m.generic_name LIKE '%Humira%'
OR m.generic_name LIKE '%Hadlima%'
OR m.generic_name LIKE '%Imraldi%'
OR m.generic_name LIKE '%Exemptia%'
OR m.generic_name LIKE '%Amfrar%'
OR m.generic_name LIKE '%Amjevita%'
OR m.generic_name LIKE '%Cyltezo%'
OR m.generic_name LIKE '%Idacio%'
OR m.generic_name LIKE '%Infliximab%'
OR m.generic_name LIKE '%Avakine%'
OR m.generic_name LIKE '%Flixabi%'
OR m.generic_name LIKE '%Inflectra%'
OR m.generic_name LIKE '%Ixifi%'
OR m.generic_name LIKE '%Remicade%'
OR m.generic_name LIKE '%Remsima%'
OR m.generic_name LIKE '%Renflexis%'
OR m.generic_name LIKE '%Revellex%'
OR m.generic_name LIKE '%Zessly%'
OR m.generic_name LIKE '%Etanercept%'
OR m.generic_name LIKE '%Enbrel%'
OR m.generic_name LIKE '%Etacept%'
OR m.generic_name LIKE '%Benepali%'
OR m.generic_name LIKE '%Erelzi%'
OR m.generic_name LIKE '%Certolizumab%'
OR m.generic_name LIKE '%Cimzia%'
OR m.generic_name LIKE '%Golimumab%'
OR m.generic_name LIKE '%Simponi%')
AND p.age >= 18
AND p.is_test_patient = 0
AND mo.order_placed_datetime <= '1-22-2020'
AND mar.medication_order_key IS NULL	--Exclude MAR
;