-------------------------------------------------------------------------------- 
-- Name: Autoimmune Disease without TNFAI
-- Author: NM\psilber1
-- Date: 7/7/2020
-- Task: RW-1126
-- IRB: STU00211830
-- Description: This project contains control patients with autoimmune disease
-- but no TNFAI use.
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Report Parameters. 
--------------------------------------------------------------------------------

--DECLARE @cohort_id AS INT = 4960;

--------------------------------------------------------------------------------
-- MainDataSet
--------------------------------------------------------------------------------
SELECT DISTINCT p.ir_id
	, cp.patient_study_id
	, p.patient_key
	, p.west_mrn AS NMHC_MRN
	, COALESCE(p.nmh_mrn,p.lfh_mrn) AS Cerner_MRN
	, p.nmff_mrn AS Legacy_epic_MRN
	, p.first_name
	, p.last_name
	, p.gender
	, p.birth_date
	, p.death_date
	, p.race_1
	, p.ethnic_group
INTO #cohort
FROM dim.vw_patient_current p
	JOIN FSM_Analytics.cohort.[cohort_patients] cp
		ON cp.source_ir_id = p.ir_id
		AND cp.[is_dltd_flg] = 0 
		AND cp.[cohort_id] = @cohort_id 
	JOIN FSM_Analytics.cohort.[cohorts] c 
		ON c.[cohort_id] = cp.[cohort_id] 
		AND c.[is_dltd_flg] = 0
;


--Patients have no drug use, so replacing the time component with the time of disease onset
/*
--------------------------------------------------------------------------------
-- First Prescription Date
--------------------------------------------------------------------------------
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
FROM dim.vw_medication m
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


--First prescription for each category
SELECT *
INTO #prescriptions
FROM (
	SELECT *
		, ROW_NUMBER() OVER (PARTITION BY ir_id, med_name ORDER BY order_start_datetime ASC) AS rnk
	FROM ( 
		SELECT DISTINCT p.ir_id
			, mk.med_name
			, mk.medication_name
			, mo.order_start_datetime
			, CASE WHEN MONTH(p.birth_date) > MONTH(mo.order_start_datetime) OR (MONTH(p.birth_date) = MONTH(mo.order_start_datetime) AND DAY(p.birth_date) > DAY(mo.order_start_datetime)) THEN DATEDIFF(YY, p.birth_date, mo.order_start_datetime) - 1 
				ELSE DATEDIFF(YY, p.birth_date, mo.order_start_datetime) END AS age_at_drug_initiation
			, mo.dose
		FROM fact.vw_medication_order mo
			JOIN dim.vw_medication m
				ON m.medication_key = mo.medication_key
			JOIN dim.vw_medication_order_profile mop
				ON mop.medication_order_profile_key = mo.medication_order_profile_key
				AND ISNULL(mop.order_status,'') NOT IN ('Canceled', 'Voided', 'Order Canceled', 'Voided With Results', 'Future', 'Incomplete')
			JOIN #cohort p
				ON p.patient_key = mo.patient_key
			JOIN #medKeys mk
				ON mk.medication_key = m.medication_key
			LEFT JOIN fact.vw_medication_administration mar
				ON mar.medication_order_key = mo.medication_order_key
		WHERE mo.order_start_datetime <= '1-22-2020'
		AND mar.medication_order_key IS NULL	--Exclude MAR
		) x
	) y
WHERE y.rnk = 1
;


--Last prescription for each category
SELECT *
INTO #prescriptionsRecent
FROM (
	SELECT *
		, ROW_NUMBER() OVER (PARTITION BY ir_id, med_name ORDER BY order_start_datetime DESC) AS rnk
	FROM ( 
		SELECT DISTINCT p.ir_id
			, mk.med_name
			, mo.order_start_datetime
		FROM fact.vw_medication_order mo
			JOIN dim.vw_medication m
				ON m.medication_key = mo.medication_key
			JOIN dim.vw_medication_order_profile mop
				ON mop.medication_order_profile_key = mo.medication_order_profile_key
				AND ISNULL(mop.order_status,'') NOT IN ('Canceled', 'Voided', 'Order Canceled', 'Voided With Results', 'Future', 'Incomplete')
			JOIN #cohort p
				ON p.patient_key = mo.patient_key
			JOIN #medKeys mk
				ON mk.medication_key = m.medication_key
			LEFT JOIN fact.vw_medication_administration mar
				ON mar.medication_order_key = mo.medication_order_key
		WHERE mo.order_start_datetime <= '1-22-2020'
		AND mar.medication_order_key IS NULL	--Exclude MAR
		) x
	) y
WHERE y.rnk = 1
;


--------------------------------------------------------------------------------
-- Infusion visits, per each med
--------------------------------------------------------------------------------
SELECT c.ir_id
	, COUNT(DISTINCT e.encounter_start_date_key) AS Infusion_visits
	, mk.med_name
INTO #infusion
FROM fact.vw_encounter_outpatient e
	JOIN dim.vw_encounter_type et
		ON et.encounter_type_key = e.encounter_type_key
		AND et.encounter_type_name = 'Infusion Visit'
	JOIN dim.vw_encounter_status st
		ON st.encounter_status_key = e.encounter_status_key
		AND st.encounter_status_name NOT IN ('Canceled', 'No Show', 'Left Without Seen')
	JOIN #cohort c
		ON c.patient_key = e.patient_key
	JOIN fact.vw_medication_order mo
		ON mo.encounter_outpatient_key = e.encounter_outpatient_key
		AND mo.encounter_outpatient_key > 0
	JOIN dim.vw_medication_order_profile mop
		ON mop.medication_order_profile_key = mo.medication_order_profile_key
		AND ISNULL(mop.order_status,'') NOT IN ('Canceled', 'Voided', 'Order Canceled', 'Voided With Results', 'Future', 'Incomplete')
	JOIN #medKeys mk
		ON mk.medication_key = mo.medication_key
GROUP BY c.ir_id
	, mk.med_name
;*/


--------------------------------------------------------------------------------
-- Autoimmune Disease onset
--------------------------------------------------------------------------------
SELECT DISTINCT p.ir_id
	, MIN(de.start_date_key) AS disease_onset_dt
INTO #disease
FROM NM_BI.fact.vw_diagnosis_event de
	JOIN NM_BI.dim.vw_diagnosis_terminology dt
		ON dt.diagnosis_key = de.diagnosis_key
	JOIN dim.vw_diagnosis_event_profile dep
		ON dep.diagnosis_event_profile_key = de.diagnosis_event_profile_key
		AND dep.event_type IN ('Problem List', 'Encounter Diagnosis')
	JOIN #cohort p
		ON p.patient_key = de.patient_key
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
GROUP BY p.ir_id
;


--------------------------------------------------------------------------------
-- Medications list at each prescription start date
--------------------------------------------------------------------------------
SELECT ir_id
	, dbo.text_agg(rnk, medication_name, ', ') AS meds_list
INTO #medsLists
FROM (
	SELECT *
		, ROW_NUMBER() OVER (PARTITION BY ir_id ORDER BY medication_Name DESC) AS rnk
	FROM ( 
		SELECT DISTINCT p.ir_id
			, m.medication_name
		FROM fact.vw_medication_order mo
			JOIN dim.vw_medication m
				ON m.medication_key = mo.medication_key
			JOIN dim.vw_medication_order_profile mop
				ON mop.medication_order_profile_key = mo.medication_order_profile_key
				AND ISNULL(mop.order_status,'') NOT IN ('Canceled', 'Voided', 'Order Canceled', 'Voided With Results', 'Future', 'Incomplete')
			JOIN #cohort p
				ON p.patient_key = mo.patient_key
			JOIN #disease pr
				ON pr.ir_id = p.ir_id
			JOIN dim.vw_medication mk
				ON mk.medication_key = m.medication_key
			LEFT JOIN fact.vw_medication_administration mar
				ON mar.medication_order_key = mo.medication_order_key
		WHERE mar.medication_order_key IS NULL	--Exclude MAR
		AND mo.order_start_date_key <= pr.disease_onset_dt	--medication starts prior to or same time as disease onset
		AND (mo.order_end_datetime IS NULL OR mo.order_end_datetime > pr.disease_onset_dt)	--medication ends after disease onset or does not end
		) x
	) y
GROUP BY ir_id
;


--------------------------------------------------------------------------------
-- BMI and smoking status at first prescription date
--------------------------------------------------------------------------------
SELECT *
INTO #bmiIndex
FROM ( 
	SELECT c.ir_id
		, v.recorded_datetime
		, v.vital_value_number
		, ROW_NUMBER() OVER (PARTITION BY c.ir_id ORDER BY ABS(DATEDIFF(DAY,v.recorded_datetime,pr.disease_onset_dt))) AS rnk
	FROM fact.vw_vital v
		JOIN dim.vw_vital_type vt
			ON vt.vital_type_key = v.vital_type_key
		JOIN #cohort c
			ON c.patient_key = v.patient_key
		JOIN #disease pr
			ON pr.ir_id = c.ir_id
	WHERE vt.vital_type_name_category = 'BMI'
	AND v.vital_value_number IS NOT NULL
	) x
WHERE x.rnk = 1
;


SELECT *
INTO #bmiCurrent
FROM ( 
	SELECT c.ir_id
		, v.recorded_datetime
		, v.vital_value_number
		, ROW_NUMBER() OVER (PARTITION BY c.ir_id ORDER BY v.recorded_datetime DESC) AS rnk
	FROM fact.vw_vital v
		JOIN dim.vw_vital_type vt
			ON vt.vital_type_key = v.vital_type_key
		JOIN #cohort c
			ON c.patient_key = v.patient_key
	WHERE vt.vital_type_name_category = 'BMI'
	AND v.vital_value_number IS NOT NULL
	) x
WHERE x.rnk = 1
;


SELECT y.* 
INTO #smoking 
FROM (
	SELECT DISTINCT x.ir_id
		, x.smoking_status
		, ROW_NUMBER() OVER (PARTITION BY x.ir_id ORDER BY ABS(DATEDIFF(DAY,contact_date,pr.disease_onset_dt))) AS latest_rank 
    FROM (
		SELECT DISTINCT mc.ir_id
            , zc.NAME AS Smoking_status
            , shx.contact_date 
        FROM #cohort mc
			JOIN cr_xwalk.vw_patient cx
				ON cx.ir_id = mc.ir_id
				AND cx.source_system_key = 1	--Clarity
            JOIN clarity.dbo.social_hx shx 
                ON cx.source_system_id = shx.pat_id 
            JOIN clarity.dbo.zc_smoking_tob_use zc 
                ON shx.smoking_tob_use_c = zc.smoking_tob_use_c 

        UNION

        SELECT DISTINCT mc.ir_id
            , zc.NAME AS Latest_smoking_status
            , shx.contact_date 
        FROM #cohort mc
			JOIN cr_xwalk.vw_patient cx
				ON cx.ir_id = mc.ir_id
				AND cx.source_system_key = 2	--Legacy Clarity
            JOIN nmff_clarity.dbo.social_hx shx 
                ON cx.source_system_id = shx.pat_id 
            JOIN nmff_clarity.dbo.zc_smoking_tob_use zc 
                ON shx.smoking_tob_use_c = zc.smoking_tob_use_c 

        UNION

        SELECT DISTINCT c.ir_id
            , ce.result_val
            , ce.event_end_dt_tm 
        FROM #cohort c 
			JOIN cr_xwalk.vw_patient cx
				ON cx.ir_id = c.ir_id
				AND cx.source_system_key = 3	--Cerner
			JOIN nmh_cerner.nmh_cerner_ods.clinical_event ce 
				ON ce.person_id = cx.source_system_id 
			JOIN nmh_cerner.nmh_cerner_ods.code_value cv 
				ON cv.code_value = ce.event_cd 
        WHERE ce.event_cd IN (24137696,                                         -- Tobacco Use                                                      
                                609193127,                                         -- Smoking Amount                                              
                                609195882,                                         -- Total Pack Years                                                
                                662611526                                        -- Other Tobacco Use                                           
                                ) 
		AND result_val <> 'Task Duplication'
		) x
		JOIN #disease pr
			ON pr.ir_id = x.ir_id
	) y 
WHERE y.latest_rank = 1 
;


--------------------------------------------------------------------------------
-- comorbidities, at disease onset
--------------------------------------------------------------------------------
SELECT ir_id
	, MAX(HTN) AS HTN
	, MAX(HLD) AS HLD
	, MAX(DM) AS DM
	, MAX(CHF) AS CHF
	, MAX(CAD) AS CAD
	, MAX(CKD) AS CKD
	, MAX(COPD) AS COPD
	, MAX(HIV_AIDS) AS HIV_AIDS
	, MIN(RA) AS RA
	, MIN(CD) AS CD
	, MIN(UC) AS UC
	, MIN(PSORIASIS) AS PSORIASIS
	, MIN(LYNCH_SYNDROME) AS LYNCH_SYNDROME
	, MIN(GARDNERS_SYNDROME) AS GARDNERS_SYNDROME
	, MIN(LI_FRAUMENI_SYNDROME) AS LI_FRAUMENI_SYNDROME
	, MIN(HPV) AS HPV
	, MIN(EBV) AS EBV
	, MIN(HBV) AS HBV
	, MIN(HCV) AS HCV
	, MIN(H_PYLORI) AS H_PYLORI
	, MIN(History_of_abnormal_DRE) AS History_of_abnormal_DRE
	, MIN(Ankylosing_Spondylitis) AS Ankylosing_Spondylitis
	, MIN(hidradenitis_suppurativa) AS hidradenitis_suppurativa
	, MIN(uveitis) AS uveitis
	, MIN(psoriatic_arthritis) AS psoriatic_arthritis
	, MIN(juvenile_idiopathic_arthritis) AS juvenile_idiopathic_arthritis
	, MIN(spondyloarthritis) AS spondyloarthritis
	, MIN(behcets_disease) AS behcets_disease
INTO #comorb
FROM (
	SELECT c.ir_id
		, CASE WHEN dt.diagnosis_code IN ('401.0', '401.1', '401.9', '403.00', '403.01', '403.10', '403.11', '403.90', '403.91', 'I10', 'I11.0', 'I11.9', 'I12.0', 'I12.9') THEN 1 ELSE NULL END AS HTN
		, CASE WHEN dt.diagnosis_code IN ('272.4', 'E78.00', 'E78.01', 'E78.1', 'E78.2', 'E78.3', 'E78.41', 'E78.49', 'E78.5') THEN 1 ELSE NULL END AS HLD
		, CASE WHEN dt.diagnosis_code_base IN ('250', 'E10', 'E11') THEN 1 ELSE NULL END AS DM
		, CASE WHEN dt.diagnosis_code IN ('428.0', '428.1', '428.20', '428.21', '428.22', '428.23', '428.30', '428.31', '428.32', '428.33', '428.40', '428.41', '428.42', '428.43', '428.9'
			, 'I50.1', 'I50.2', 'I50.3', 'I50.4', 'I50.8', 'I50.9') THEN 1 ELSE NULL END AS CHF
		, CASE WHEN dt.diagnosis_code_base IN ('I20', 'I21', 'I22', 'I23', 'I24', 'I25', '410') OR dt.diagnosis_code IN ('411.0', '411.1', '411.81', '411.89', '412', '414.00', '414.01'
			, '414.02', '414.03', '414.04', '414.05', '414.06', '414.07', '414.10', '414.11', '414.12', '414.19', '414.2', '414.3', '414.4', '414.8', '414.9') THEN 1 ELSE NULL END AS CAD
		, CASE WHEN dt.diagnosis_code_base IN ('N18', '585') THEN 1 ELSE NULL END AS CKD
		, CASE WHEN dt.diagnosis_code_base IN ('491', '492', '493', '494', 'J41', 'J42', 'J43', 'J44', 'J47') THEN 1 ELSE NULL END AS COPD
		, CASE WHEN dt.diagnosis_code_base IN ('042', 'B20') THEN 1 ELSE NULL END AS HIV_AIDS
		, CASE WHEN dt.diagnosis_code IN ('714.0', '714.1', '714.2', '714.30', '714.31', '714.32', '714.33', '714.4') OR dt.diagnosis_code_base = 'M05' THEN de.start_date_key ELSE NULL END AS RA
		, CASE WHEN dt.diagnosis_code IN ('555.0', '555.1', '555.2', '555.9', 'K50.0', 'K50.1', 'K50.8', 'K50.9') THEN de.start_date_key ELSE NULL END AS CD
		, CASE WHEN dt.diagnosis_code_base IN ('556', 'K50') THEN de.start_date_key ELSE NULL END AS UC
		, CASE WHEN dt.diagnosis_code_base IN ('696', 'L40') THEN de.start_date_key ELSE NULL END AS psoriasis
		, CASE WHEN dt.diagnosis_code IN ('758.5', 'Z15.02', 'Z15.04', 'Z15.09') THEN de.start_date_key ELSE NULL END AS LYNCH_SYNDROME
		, CASE WHEN dt.diagnosis_code IN ('758.5', 'Z15.09') THEN de.start_date_key ELSE NULL END AS GARDNERS_SYNDROME
		, CASE WHEN dt.diagnosis_code IN ('758.5', 'Z15.01', 'Z15.09') THEN de.start_date_key ELSE NULL END AS LI_FRAUMENI_SYNDROME
		, CASE WHEN dt.diagnosis_code IN ('078.10', '078.11', '078.12', '078.19', '079.4', 'B07.0', 'B07.8', 'B07.9') THEN de.start_date_key ELSE NULL END AS HPV
		, CASE WHEN dt.diagnosis_code IN ('B27.90', 'B27.91', 'B27.92', 'B27.99') OR dt.diagnosis_code_base = '075' THEN de.start_date_key ELSE NULL END AS EBV
		, CASE WHEN dt.diagnosis_code IN ('070.20', '070.21', '070.22', '070.23', '070.30', '070.31', '070.32', '070.33') THEN de.start_date_key ELSE NULL END AS HBV
		, CASE WHEN dt.diagnosis_code IN ('070.41', '070.44', '070.51', '070.54', '070.70', '070.71', 'B17.70', 'B17.11', 'B18.2', 'B19.20', 'B19.21') THEN de.start_date_key ELSE NULL END AS HCV
		, CASE WHEN dt.diagnosis_code IN ('041.86', 'B96.81') THEN de.start_date_key ELSE NULL END AS H_PYLORI
		, CASE WHEN dt.diagnosis_code IN ('796.4', '600.10', '600.11') THEN de.start_date_key ELSE NULL END AS History_of_abnormal_DRE
		, CASE WHEN dt.diagnosis_code_base IN ('720', 'M45') THEN de.start_date_key ELSE NULL END AS Ankylosing_Spondylitis
		, CASE WHEN dt.diagnosis_code IN ('705.83', 'L73.2') THEN de.start_date_key ELSE NULL END AS hidradenitis_suppurativa
		, CASE WHEN dt.diagnosis_code IN ('364.00', '364.01', '364.02', '364.03', '364.04', '364.05') OR LEFT(dt.diagnosis_code,5) IN ('H20.0', 'H20.1') THEN de.start_date_key ELSE NULL END AS uveitis
		, CASE WHEN dt.diagnosis_code IN ('696.0', '696.1', 'L40.50', 'L40.51', 'L40.52', 'L40.53', 'L40.54', 'L40.59') THEN de.start_date_key ELSE NULL END AS psoriatic_arthritis
		, CASE WHEN dt.diagnosis_code IN ('714.30', '714.31', '714.32', '714.33') OR dt.diagnosis_code_base = 'M08' THEN de.start_date_key ELSE NULL END AS juvenile_idiopathic_arthritis
		, CASE WHEN dt.diagnosis_code IN ('M46.80', 'M46.81', 'M46.82', 'M46.83', 'M46.84', 'M46.85', 'M46.86', 'M46.87', 'M46.88', 'M46.89') THEN de.start_date_key ELSE NULL END AS spondyloarthritis
		, CASE WHEN dt.diagnosis_code IN ('136.1', 'M35.2') THEN de.start_date_key ELSE NULL END AS behcets_disease
	FROM fact.vw_diagnosis_event de
		JOIN dim.vw_diagnosis_terminology dt
			ON dt.diagnosis_key = de.diagnosis_key
		JOIN #cohort c
			ON c.patient_key = de.patient_key
		JOIN #disease pr
			ON pr.ir_id = c.ir_id
	WHERE de.start_date_key <= pr.disease_onset_dt
	AND de.start_date_key > '1900-01-01'	--these are not reliable dates, so excluding them
	) x
GROUP BY ir_id
;


--------------------------------------------------------------------------------
-- Cancer in two parts: 1.) any cancer prior to prescription start, 2.) Cancer by category each diagnosis
--------------------------------------------------------------------------------
SELECT ir_id
	, MIN(Prostate			    ) AS Prostate
	, MIN(Bladder			    ) AS Bladder
	, MIN(Kidney			    ) AS Kidney
	, MIN(Testicular		    ) AS Testicular
	, MIN(Penile			    ) AS Penile
	, MIN(Lung				    ) AS Lung
	, MIN(Breast			    ) AS Breast
	, MIN(Colorectal		    ) AS Colorectal
	, MIN(Melanoma			    ) AS Melanoma
	, MIN(Cervical			    ) AS Cervical
	, MIN(Stomach			    ) AS Stomach
	, MIN(Liver				    ) AS Liver
	, MIN(Ovarian			    ) AS Ovarian
	, MIN(Uterine			    ) AS Uterine
	, MIN(Thyroid			    ) AS Thyroid
	, MIN(Pancreatic		    ) AS Pancreatic
	, MIN(Esophageal		    ) AS Esophageal
	, MIN(Non_hodghkin_lymphoma ) AS Non_hodghkin_lymphoma
	, MIN(Hodgkin_lymphoma		) AS Hodgkin_lymphoma
	, MIN(Leukemia				) AS Leukemia
	, MIN(Basal_cell			) AS Basal_cell
	, MIN(Squamous_cell			) AS Squamous_cell
INTO #cancer
FROM ( 
	SELECT c.ir_id
		, CASE WHEN dt.diagnosis_code_base IN ('185', 'C61') OR dt.diagnosis_code IN ('233.4', 'D07.5') THEN de.start_date_key ELSE NULL END AS Prostate
		, CASE WHEN dt.diagnosis_code_base IN ('188', 'C67') OR dt.diagnosis_code IN ('233.7', 'D09.0') THEN de.start_date_key ELSE NULL END AS Bladder
		, CASE WHEN dt.diagnosis_code_base IN ('189', 'C64', 'C65', 'C66', 'C68') OR dt.diagnosis_code IN ('233.9', 'D09.10', 'D09.19') THEN de.start_date_key ELSE NULL END AS Kidney
		, CASE WHEN dt.diagnosis_code_base IN ('186', 'C62', 'C63') THEN de.start_date_key ELSE NULL END AS Testicular
		, CASE WHEN dt.diagnosis_code_base IN ('187', 'C60') OR dt.diagnosis_code IN ('233.5', '233.6', 'D07.4', 'D07.60', 'D07.61', 'D07.69') THEN de.start_date_key ELSE NULL END AS Penile
		, CASE WHEN dt.diagnosis_code_base IN ('162', 'C33', 'C34') OR dt.diagnosis_code IN ('209.21', '231.1', '231.2', 'C7A.090', 'D02.1', 'D02.20', 'D02.21', 'D02.22') THEN de.start_date_key ELSE NULL END AS Lung
		, CASE WHEN dt.diagnosis_code_base IN ('174', 'C50') OR dt.diagnosis_code IN ('233.0', 'D05.00', 'D05.01', 'D05.02', 'D05.10', 'D05.11', 'D05.12') THEN de.start_date_key ELSE NULL END AS Breast
		, CASE WHEN dt.diagnosis_code_base IN ('152', '153', '154', 'C17', 'C18', 'C19', 'C20', 'C21') OR LEFT(dt.diagnosis_code,5) IN ('209.0', '209.1', '230.3', '230.4', '230.5', 'C7A.0', 'D01.0', 'D01.1', 'D01.2', 'D01.3') THEN de.start_date_key ELSE NULL END AS Colorectal
		, CASE WHEN dt.diagnosis_code_base IN ('172', '232', 'C43', 'C4A', 'D03') OR dt.diagnosis_code IN ('209.30', '209.31', '209.32', '209.33', '209.34', '209.35', '209.36') THEN de.start_date_key ELSE NULL END AS Melanoma
		, CASE WHEN dt.diagnosis_code_base IN ('180', 'C53') OR dt.diagnosis_code IN ('233.1', 'D06.0', 'D06.1') THEN de.start_date_key ELSE NULL END AS Cervical
		, CASE WHEN dt.diagnosis_code_base IN ('151', 'C16') OR dt.diagnosis_code IN ('209.23', '230.2', 'D00.2') THEN de.start_date_key ELSE NULL END AS Stomach
		, CASE WHEN dt.diagnosis_code_base IN ('155', 'C22') OR dt.diagnosis_code IN ('230.8', 'D01.5') THEN de.start_date_key ELSE NULL END AS Liver
		, CASE WHEN dt.diagnosis_code_base IN ('183', 'C56', 'C57') THEN de.start_date_key ELSE NULL END AS Ovarian
		, CASE WHEN dt.diagnosis_code_base IN ('179', '182', 'C54') OR dt.diagnosis_code = 'D07.0' THEN de.start_date_key ELSE NULL END AS Uterine
		, CASE WHEN dt.diagnosis_code_base IN ('193', 'C73') OR dt.diagnosis_code IN ('234.8', 'D09.3') THEN de.start_date_key ELSE NULL END AS Thyroid
		, CASE WHEN dt.diagnosis_code_base IN ('157', 'C25') THEN de.start_date_key ELSE NULL END AS Pancreatic
		, CASE WHEN dt.diagnosis_code_base IN ('150', 'C15') OR dt.diagnosis_code IN ('230.1', 'D00.1') THEN de.start_date_key ELSE NULL END AS Esophageal
		, CASE WHEN LEFT(dt.diagnosis_code,5) IN ('200.2', '200.3', '200.4', '200.5', 'C83.0', 'C83.1', 'C83.3', 'C83.5', 'C83.7') OR dt.diagnosis_code_base IN ('C82', 'C84') THEN de.start_date_key ELSE NULL END AS Non_hodghkin_lymphoma
		, CASE WHEN dt.diagnosis_code_base IN ('201', 'C81') THEN de.start_date_key ELSE NULL END AS Hodgkin_lymphoma
		, CASE WHEN LEFT(dt.diagnosis_code,5) IN ('204.0', '204.1', '205.0', '205.1', 'C91.0', 'C91.1', 'C91.4', 'C92.0', 'C92.1', 'C92.2') THEN de.start_date_key ELSE NULL END AS Leukemia
		, CASE WHEN dt.diagnosis_code IN ('173.01', '173.11', '173.21', '173.31', '173.41', '173.51', '173.61', '173.71', 'C44.01', 'C44.111', 'C44.1121'
			, 'C44.1122', 'C44.1191', 'C44.1192', 'C44.211', 'C44.222', 'C44.219', 'C44.310', 'C44.311', 'C44.319', 'C44.41', 'C44.510'
			, 'C44.511', 'C44.519', 'C44.611', 'C44.612', 'C44.619', 'C44.711', 'C44.712', 'C44.719') OR dt.diagnosis_code_base = 'D04' THEN de.start_date_key ELSE NULL END AS Basal_cell
		, CASE WHEN dt.diagnosis_code IN ('173.02', '173.12', '173.22', '173.32', '173.42', '173.52', '173.62', '173.72', 'C44.02', 'C44.121', 'C44.1221'
			, 'C44.1222', 'C44.1291', 'C44.1292', 'C44.221', 'C44.222', 'C44.229', 'C44.320', 'C44.321', 'C44.329', 'C44.42', 'C44.520'
			, 'C44.521', 'C44.529', 'C44.621', 'C44.622', 'C44.629', 'C44.721', 'C44.722', 'C44.729') OR dt.diagnosis_code_base = 'D04' THEN de.start_date_key ELSE NULL END AS Squamous_cell
	FROM fact.vw_diagnosis_event de	
		JOIN dim.vw_diagnosis_terminology dt
			ON dt.diagnosis_key = de.diagnosis_key
		JOIN dim.vw_diagnosis_event_profile dep
			ON dep.diagnosis_event_profile_key = de.diagnosis_event_profile_key
			AND dep.event_type = 'Encounter Diagnosis'	--Limit to encounter diagnosis for Cancer
		JOIN #cohort c
			ON c.patient_key = de.patient_key
		) x
GROUP BY ir_id
;


--------------------------------------------------------------------------------
-- Procedure counts
--------------------------------------------------------------------------------
SELECT ir_id
	, COUNT(DISTINCT screening_serum_psa_values			) AS Number_of_screening_serum_psa_values
	, COUNT(DISTINCT transrectal_diagnostic_ultrasound	) AS Number_of_transrectal_diagnostic_ultrasounds
	, COUNT(DISTINCT prostate_MRI						) AS Number_of_prostate_MRIs
	, COUNT(DISTINCT prostate_biopsies					) AS Number_of_prostate_biopsies
	, COUNT(DISTINCT screening_mammogram				) AS Number_of_screening_mammograms
	, COUNT(DISTINCT digital_breast_tomosynthesis		) AS Number_of_digital_breast_tomosynthesis
	, COUNT(DISTINCT breast_biopsies					) AS Number_of_breast_biopsies
	, COUNT(DISTINCT screening_CXR						) AS Number_of_screening_CXRs
	, COUNT(DISTINCT screening_low_dose_CT				) AS Number_of_screening_low_dose_CTs
	, COUNT(DISTINCT screening_colonoscopy				) AS Number_of_screening_colonoscopys
	, COUNT(DISTINCT screening_flexible_sigmoidoscopy	) AS Number_of_screening_flexible_sigmoidoscopys
	, COUNT(DISTINCT FOBT								) AS Number_of_FOBTs
	, COUNT(DISTINCT FIT								) AS Number_of_FITs
	, COUNT(DISTINCT barium_enema						) AS Number_of_barium_enemas
INTO #procedures
FROM (
	SELECT c.ir_id
		, CASE WHEN cpt_code = '84153' THEN cp.coded_procedure_date_key ELSE NULL END AS screening_serum_psa_values
		, CASE WHEN pr.cpt_code IN ('76872', '76942') THEN cp.coded_procedure_date_key ELSE NULL END AS transrectal_diagnostic_ultrasound
		, CASE WHEN pr.cpt_code = '72197' THEN cp.coded_procedure_date_key ELSE NULL END AS prostate_MRI
		, CASE WHEN pr.cpt_code IN ('55700', '55706') THEN cp.coded_procedure_date_key ELSE NULL END AS prostate_biopsies
		, CASE WHEN pr.cpt_code IN ('77067', '77066', '77065') THEN cp.coded_procedure_date_key ELSE NULL END AS screening_mammogram
		, CASE WHEN pr.cpt_code IN ('77061', '77062', '77063') THEN cp.coded_procedure_date_key ELSE NULL END AS digital_breast_tomosynthesis
		, CASE WHEN pr.cpt_code IN ('19081') THEN cp.coded_procedure_date_key ELSE NULL END AS breast_biopsies
		, CASE WHEN pr.cpt_code IN ('71045', '71046', '71047', '71048') THEN cp.coded_procedure_date_key ELSE NULL END AS screening_CXR
		, CASE WHEN pr.cpt_code IN ('71250') THEN cp.coded_procedure_date_key ELSE NULL END AS screening_low_dose_CT
		, CASE WHEN pr.cpt_code IN ('45378', '45380', '45381', '45382', '45383', '45384', '45385', '45386', '45387', '45391') THEN cp.coded_procedure_date_key ELSE NULL END AS screening_colonoscopy
		, CASE WHEN pr.cpt_code IN ('45330', '45331', '45332', '45333', '45334', '45335', '45337', '45338', '45339', '45340', '45341', '45342', '45347', '45349', '45350') THEN cp.coded_procedure_date_key ELSE NULL END AS screening_flexible_sigmoidoscopy
		, CASE WHEN pr.cpt_code IN ('82270') THEN cp.coded_procedure_date_key ELSE NULL END AS FOBT
		, CASE WHEN pr.cpt_code IN ('82274') THEN cp.coded_procedure_date_key ELSE NULL END AS FIT
		, CASE WHEN pr.cpt_code IN ('74270,  74280') THEN cp.coded_procedure_date_key ELSE NULL END AS barium_enema
	FROM fact.vw_coded_procedure cp
		JOIN #cohort c
			ON c.patient_key = cp.patient_key
		JOIN dim.vw_procedure pr
			ON pr.procedure_key = cp.procedure_key
	WHERE pr.cpt_code IN ('84153', '76872', '76942', '72197', '55700', '55706', '77067, 77066, 77065', '77061', '77062', '77063', '19081', '71045', '71046', '71047', '71048'
	, '71250', '45378', '45380', '45381', '45382', '45383', '45384', '45385', '45386', '45387', '45391', '45330', '45331', '45332', '45333', '45334', '45335'
	, '45337', '45338', '45339', '45340', '45341', '45342', '45347', '45349', '45350', '82270', '82274', '74270,  74280')
	) x
GROUP BY ir_id
;


--------------------------------------------------------------------------------
-- Outpatient Visits by department
--------------------------------------------------------------------------------
SELECT ir_id
	, dbo.text_agg(rnk, department_name + ' (' + CAST(num_visits AS VARCHAR) + ' visits)', '; ') AS visits_by_department
INTO #OPvisits
FROM (
	SELECT ir_id
		, department_name
		, num_visits
		, ROW_NUMBER() OVER (PARTITION BY ir_id ORDER BY num_visits DESC) AS rnk
	FROM ( 
		SELECT DISTINCT c.ir_id
			, department_name
			, COUNT(DISTINCT e.encounter_start_date_key) AS num_visits
		FROM fact.vw_encounter_outpatient e
			JOIN dim.vw_encounter_status st
				ON st.encounter_status_key = e.encounter_status_key
				AND st.encounter_status_name NOT IN ('Canceled', 'Cancelled', 'HH Incomplete', 'Left without seen', 'No Show', 'Reminder Appointment', 'Rescheduled')
			JOIN dim.vw_encounter_type et
				ON et.encounter_type_key = e.encounter_type_key
				AND ISNULL(et.encounter_type_name,'') NOT IN ('Observation', 'Resolute Professional Billing Hospital Prof Fee', 'FS Transcribe Orders', 'Emergency Observation', 'Emergency'
					, 'Inpatient Pre-Admission', 'Telephone', 'Inpatient', 'Erroneous Encounter', 'Orders Only', 'Documentation Non Patient Facing', 'Outpatient Message', 'INR Telephone'
					, 'Canceled', 'Billing Encounters')
			JOIN dim.vw_department dep
				ON dep.department_key = e.department_key
				AND dep.department_name <> 'unknown'
			JOIN #cohort c
				ON c.patient_key = e.patient_key
		WHERE e.encounter_start_date_key <= GETDATE()
		GROUP BY c.ir_id
			, department_name
		) x
	) y
GROUP BY ir_id
;


--------------------------------------------------------------------------------
-- Most recent visit
--------------------------------------------------------------------------------
SELECT *
INTO #mostRecentVisit
FROM (
	SELECT c.ir_id
		, e.encounter_start_date_key
		, ROW_NUMBER() OVER (PARTITION BY c.ir_id ORDER BY e.encounter_start_date_key DESC) AS rnk
	FROM fact.vw_encounter_outpatient e
		JOIN dim.vw_encounter_status st
			ON st.encounter_status_key = e.encounter_status_key
			AND st.encounter_status_name NOT IN ('Canceled', 'Cancelled', 'HH Incomplete', 'Left without seen', 'No Show', 'Reminder Appointment', 'Rescheduled')
		JOIN dim.vw_encounter_type et
			ON et.encounter_type_key = e.encounter_type_key
			AND ISNULL(et.encounter_type_name,'') NOT IN ('Observation', 'Resolute Professional Billing Hospital Prof Fee', 'FS Transcribe Orders', 'Emergency Observation', 'Emergency'
				, 'Inpatient Pre-Admission', 'Telephone', 'Inpatient', 'Erroneous Encounter', 'Orders Only', 'Documentation Non Patient Facing', 'Outpatient Message', 'INR Telephone'
				, 'Canceled', 'Billing Encounters')
		JOIN dim.vw_department dep
			ON dep.department_key = e.department_key
		JOIN #cohort c
			ON c.patient_key = e.patient_key
	WHERE e.encounter_start_date_key <= GETDATE()
	) x
WHERE x.rnk = 1
;


--------------------------------------------------------------------------------
-- Number of Pap Smears
--------------------------------------------------------------------------------
SELECT ir_id
	, COUNT(DISTINCT coded_procedure_date_key) AS number_of_pap_smears
INTO #papsmear
FROM (
	SELECT DISTINCT c.ir_id
		, cp.coded_procedure_date_key
	FROM fact.vw_coded_procedure cp
		JOIN dim.vw_procedure pr
			ON pr.procedure_key = cp.procedure_key
		JOIN #cohort c
			ON c.patient_Key = cp.patient_key
	WHERE pr.procedure_code IN ('88141'
	, '88142'
	, '88143'
	, '88144'
	, '88145'
	, '88146'
	, '88147'
	, '88148'
	, '88149'
	, '88150'
	, '88151'
	, '88152'
	, '88153'
	, '88154'
	, '88155'
	, '88164'
	, '88165'
	, '88166'
	, '88167'
	, '88174'
	, '88175'
	, 'G0123'
	, 'G0124'
	, 'G0141'
	, 'G0143'
	, 'G0144'
	, 'G0145'
	, 'G0146'
	, 'G0147'
	, 'G0148')

	UNION

	SELECT DISTINCT c.ir_id
		, de.start_date_key
	FROM fact.vw_diagnosis_event de
		JOIN dim.vw_diagnosis_terminology dt
			ON dt.diagnosis_key = de.diagnosis_key
			AND dt.diagnosis_code_set = 'icd-10-cm'
		JOIN dim.vw_diagnosis_event_profile dep
			ON dep.diagnosis_event_profile_key = de.diagnosis_event_profile_key
		JOIN #cohort c
			ON c.patient_key = de.patient_key
	WHERE dt.diagnosis_code IN ('Z12.4', 'Z12.72')
	AND de.start_date_key > '1900-01-01'	--need real dates to count them effectively
	) x
GROUP BY ir_id
;



--------------------------------------------------------------------------------
-- Compilation
--------------------------------------------------------------------------------
SELECT DISTINCT c.patient_study_id AS patient_id
	, c.NMHC_MRN
	, c.Cerner_MRN
	, c.Legacy_Epic_MRN
	, c.first_name
	, c.last_name
	, c.birth_date
	, c.gender
	, c.race_1 AS race
	, c.ethnic_group
	, c.death_date
	, sm.Smoking_status AS Smoking_status_at_induction
	, bmi.vital_value_number AS BMI_value_at_induction
	, bmi.recorded_datetime AS BMI_dt
	, bmic.vital_value_number AS BMI_value_current
	, bmic.recorded_datetime AS BMI_dt_current
	, ml.meds_list AS meds_list_at_induction_dt
	, HTN
	, HLD
	, DM
	, CHF
	, CAD
	, CKD
	, COPD
	, HIV_AIDS
	, RA
	, CD
	, UC
	, PSORIASIS
	, LYNCH_SYNDROME
	, GARDNERS_SYNDROME
	, LI_FRAUMENI_SYNDROME
	, HPV
	, EBV
	, HBV
	, HCV
	, H_PYLORI
	, History_of_abnormal_DRE
	, Ankylosing_Spondylitis
	, hidradenitis_suppurativa
	, uveitis
	, psoriatic_arthritis
	, juvenile_idiopathic_arthritis
	, spondyloarthritis
	, behcets_disease
	, CASE WHEN Prostate < pr.disease_onset_dt
		OR Bladder < pr.disease_onset_dt
		OR Kidney < pr.disease_onset_dt
		OR Testicular < pr.disease_onset_dt
		OR Penile < pr.disease_onset_dt
		OR Lung < pr.disease_onset_dt
		OR Breast < pr.disease_onset_dt
		OR Colorectal < pr.disease_onset_dt
		OR Melanoma < pr.disease_onset_dt
		OR Cervical < pr.disease_onset_dt
		OR Stomach < pr.disease_onset_dt
		OR Liver < pr.disease_onset_dt
		OR Ovarian < pr.disease_onset_dt
		OR Uterine < pr.disease_onset_dt
		OR Thyroid < pr.disease_onset_dt
		OR Pancreatic < pr.disease_onset_dt
		OR Esophageal < pr.disease_onset_dt
		OR Non_hodghkin_lymphoma < pr.disease_onset_dt
		OR Hodgkin_lymphoma < pr.disease_onset_dt
		OR Leukemia < pr.disease_onset_dt
		OR Basal_cell < pr.disease_onset_dt
		OR Squamous_cell < pr.disease_onset_dt THEN 1 ELSE 0 END AS Cancer_prior_to_medication_start
	, Number_of_screening_serum_psa_values
	, Number_of_transrectal_diagnostic_ultrasounds
	, Number_of_prostate_MRIs
	, Number_of_prostate_biopsies
	, Number_of_screening_mammograms
	, Number_of_digital_breast_tomosynthesis
	, Number_of_breast_biopsies
	, Number_of_screening_CXRs
	, Number_of_screening_low_dose_CTs
	, Number_of_screening_colonoscopys
	, Number_of_screening_flexible_sigmoidoscopys
	, Number_of_FOBTs
	, Number_of_FITs
	, Number_of_barium_enemas
	, opv.visits_by_department
	, mrv.encounter_start_date_key AS Most_recent_visit_dt
	, Prostate					AS Prostate_cancer_dt
	, Bladder					AS Bladder_cancer_dt
	, Kidney					AS Kidney_cancer_dt
	, Testicular				AS Testicular_cancer_dt
	, Penile					AS Penile_cancer_dt
	, Lung						AS Lung_cancer_dt
	, Breast					AS Breast_cancer_dt
	, Colorectal				AS Colorectal_cancer_dt
	, Melanoma					AS Melanoma_cancer_dt
	, Cervical					AS Cervical_cancer_dt
	, Stomach					AS Stomach_cancer_dt
	, Liver						AS Liver_cancer_dt
	, Ovarian					AS Ovarian_cancer_dt
	, Uterine					AS Uterine_cancer_dt
	, Thyroid					AS Thyroid_cancer_dt
	, Pancreatic				AS Pancreatic_cancer_dt
	, Esophageal				AS Esophageal_cancer_dt
	, Non_hodghkin_lymphoma		AS Non_hodghkin_lymphoma_cancer_dt
	, Hodgkin_lymphoma			AS Hodgkin_lymphoma_cancer_dt
	, Leukemia					AS Leukemia_cancer_dt
	, Basal_cell				AS Basal_cell_cancer_dt
	, Squamous_cell				AS Squamous_cell_cancer_dt
	, ps.number_of_pap_smears
FROM #cohort c
	JOIN #disease pr
		ON pr.ir_id = c.ir_id
	LEFT JOIN #smoking sm
		ON sm.ir_id = c.ir_id
	LEFT JOIN #bmiIndex bmi
		ON bmi.ir_id = c.ir_id
	LEFT JOIN #bmiCurrent bmic
		ON bmic.ir_id = c.ir_id
	LEFT JOIN #medsLists ml
		ON ml.ir_id = c.ir_id
	LEFT JOIN #comorb co
		ON co.ir_id = c.ir_id
	LEFT JOIN #procedures pro
		ON pro.ir_id = c.ir_id
	LEFT JOIN #cancer ca
		ON ca.ir_id = c.ir_id
	LEFT JOIN #OPvisits opv
		ON opv.ir_id = c.ir_id
	LEFT JOIN #mostRecentVisit mrv
		ON mrv.ir_id = c.ir_id
	LEFT JOIN #papsmear ps
		ON ps.ir_id = c.ir_id
;


DROP TABLE #cohort;
DROP TABLE #bmiCurrent;
DROP TABLE #bmiIndex;
DROP TABLE #smoking;
DROP TABLE #medsLists;
DROP TABLE #comorb;
DROP TABLE #procedures;
DROP TABLE #cancer;
DROP TABLE #OPvisits;
DROP TABLE #mostRecentVisit;
DROP TABLE #disease;