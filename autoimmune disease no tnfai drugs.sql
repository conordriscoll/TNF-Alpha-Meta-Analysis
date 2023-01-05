--TNFAI Control Group #2: Patients with autoimmune disease and no TNFAI drugs. No matching on this group.
--Patients must be at least 18 years old.


--Gather all meds and create groupings first
SELECT medication_key
	, m.medication_name
	, CASE WHEN m.medication_name LIKE '%Adalimumab%'
		OR m.medication_name LIKE '%Humira%'
		OR m.medication_name LIKE '%Hadlima%'
		OR m.medication_name LIKE '%Imraldi%'
		OR m.medication_name LIKE '%Exemptia%'
		OR m.medication_name LIKE '%Amfrar%'
		OR m.medication_name LIKE '%Amjevita%'
		OR m.medication_name LIKE '%Cyltezo%'
		OR m.medication_name LIKE '%Idacio%'
		OR m.generic_name LIKE '%Adalimumab%'
		OR m.generic_name LIKE '%Humira%'
		OR m.generic_name LIKE '%Hadlima%'
		OR m.generic_name LIKE '%Imraldi%'
		OR m.generic_name LIKE '%Exemptia%'
		OR m.generic_name LIKE '%Amfrar%'
		OR m.generic_name LIKE '%Amjevita%'
		OR m.generic_name LIKE '%Cyltezo%'
		OR m.generic_name LIKE '%Idacio%' THEN 'Humira'
		WHEN m.medication_name LIKE '%Infliximab%'
		OR m.medication_name LIKE '%Avakine%'
		OR m.medication_name LIKE '%Flixabi%'
		OR m.medication_name LIKE '%Inflectra%'
		OR m.medication_name LIKE '%Ixifi%'
		OR m.medication_name LIKE '%Remicade%'
		OR m.medication_name LIKE '%Remsima%'
		OR m.medication_name LIKE '%Renflexis%'
		OR m.medication_name LIKE '%Revellex%'
		OR m.medication_name LIKE '%Zessly%'
		OR m.generic_name LIKE '%Infliximab%'
		OR m.generic_name LIKE '%Avakine%'
		OR m.generic_name LIKE '%Flixabi%'
		OR m.generic_name LIKE '%Inflectra%'
		OR m.generic_name LIKE '%Ixifi%'
		OR m.generic_name LIKE '%Remicade%'
		OR m.generic_name LIKE '%Remsima%'
		OR m.generic_name LIKE '%Renflexis%'
		OR m.generic_name LIKE '%Revellex%'
		OR m.generic_name LIKE '%Zessly%' THEN 'Infliximab'
		WHEN m.medication_name LIKE '%Etanercept%'
		OR m.medication_name LIKE '%Enbrel%'
		OR m.medication_name LIKE '%Etacept%'
		OR m.medication_name LIKE '%Benepali%'
		OR m.medication_name LIKE '%Erelzi%'
		OR m.generic_name LIKE '%Etanercept%'
		OR m.generic_name LIKE '%Enbrel%'
		OR m.generic_name LIKE '%Etacept%'
		OR m.generic_name LIKE '%Benepali%'
		OR m.generic_name LIKE '%Erelzi%' THEN 'Etanercept'
		WHEN m.medication_name LIKE '%Certolizumab%'
		OR m.medication_name LIKE '%Cimzia%'
		OR m.generic_name LIKE '%Certolizumab%'
		OR m.generic_name LIKE '%Cimzia%' THEN 'Certolizumab'
		WHEN m.medication_name LIKE '%Golimumab%'
		OR m.medication_name LIKE '%Simponi%'
		OR m.generic_name LIKE '%Golimumab%'
		OR m.generic_name LIKE '%Simponi%' THEN 'Golimumab' END AS med_name
INTO #medKeys
FROM NM_BI.dim.vw_medication m
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
;


--All patients who received TNFAI drugs, this will be used as an exclusion criteria for the controls
SELECT DISTINCT p.ir_id
INTO #exclude
FROM NM_BI.fact.vw_medication_order mo
	JOIN NM_BI.dim.vw_medication m
		ON m.medication_key = mo.medication_key
	JOIN NM_BI.dim.vw_medication_order_profile mop
		ON mop.medication_order_profile_key = mo.medication_order_profile_key
		AND ISNULL(mop.order_status,'') NOT IN ('Canceled', 'Voided', 'Order Canceled', 'Voided With Results', 'Future', 'Incomplete')
		AND ISNULL(mop.order_class,'') <> 'Facility Administered'
	JOIN #medKeys mk
		ON mk.medication_key = mo.medication_key
	JOIN NM_BI.dim.vw_patient p
		ON p.patient_key = mo.patient_key
	LEFT JOIN NM_BI.fact.vw_medication_administration mar
		ON mar.medication_order_key = mo.medication_order_key
WHERE  mo.order_start_datetime <= '1-22-2020'
AND mar.medication_order_key IS NULL	--Exclude MAR
;


--Patients with diagnoses for Ulcerative colitis, etc., will also be used as an exclusion criteria for the controls
SELECT DISTINCT p.ir_id
FROM NM_BI.fact.vw_diagnosis_event de
	JOIN NM_BI.dim.vw_diagnosis_terminology dt
		ON dt.diagnosis_key = de.diagnosis_key
	JOIN dim.vw_diagnosis_event_profile dep
		ON dep.diagnosis_event_profile_key = de.diagnosis_event_profile_key
		AND dep.event_type IN ('Problem List', 'Encounter Diagnosis')
	JOIN NM_BI.dim.vw_patient p
		ON p.patient_key = de.patient_key
		AND p.is_test_patient = 0			--exclude test patients
		AND p.full_name NOT LIKE '%zztes%'	--exclude test patients
		AND p.age >= 18	--over 18
WHERE (dt.diagnosis_code_base IN ('556', 'K50'	--UC
							, '720', 'M45'	--Ankylosing_Spondylitis
							, 'M05'	--rheumatoid arthritis
							)
OR dt.diagnosis_code IN ('364.00', '364.01', '364.02', '364.03', '364.04', '364.05'	--uveitis
						, '705.83', 'L73.2'	--hidradenitis_suppurativa
						, '555.0', '555.1', '555.2', '555.9', 'K50.0', 'K50.1', 'K50.8', 'K50.9'	--chrohn's diseasej
						, '714.0', '714.1', '714.2', '714.30', '714.31', '714.32', '714.33', '714.4'	--rheumatoid arthritis
						, '705.83', 'L73.2'	--hidradenitis_suppurativa
						)
OR LEFT(dt.diagnosis_code,5) IN ('H20.0', 'H20.1')	--uveitis
)
AND NOT EXISTS (SELECT 'x' FROM #exclude e WHERE e.ir_id = p.ir_id)
;


DROP TABLE #exclude;
DROP TABLE #medKeys;