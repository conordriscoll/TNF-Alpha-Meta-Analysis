--Inclusion criteria (Cases): Patients on any of the following drugs through 1/22/2020:
--Adalimumab [Humira OR Hadlima OR Imraldi OR Exemptia OR Amfrar OR Amjevita OR Cyltezo OR Idacio], Infliximab [Avakine OR Flixabi OR Inflectra OR Ixifi OR Remicade OR Remsima OR Renflexis OR Revellex OR Zessly], Etanercept [Enbrel OR Etacept OR Benepali OR Erelzi], Certolizumab [Cimzia], Golimumab [Simponi].

--Control description: Patients with no TNF-A inhibitor exposure and no autoimmune disease comprising of:
--Psoriasis, Rheumatoid Arthritis, Crohn's Disease, Ulcerative Colitis, Ankylosing Spondylitis, Uveitis, Hidradenitis Suppurativa.

--Patients will be matched on age, race, gender, smoking status, BMI, and follow-up. 

--Follow-up is defined as the difference between the start of NMHC contact and the most recent NMHC contact, in months.
--Controls start of NMHC contact must be after 1/1/1998.
--Report generated will be the same variables as the initial cohort, realigning for medication-induction based variable.


SELECT DISTINCT control_ir_id
FROM FSM_EDW.reports_dm.rw2436_case_control_matching


/*
IF OBJECT_ID('FSM_EDW.reports_dm.rw2436_case_control_matching', 'U') IS NOT NULL
DROP TABLE fsm_edw.reports_dm.rw2436_case_control_matching;

DECLARE @cohort_id AS INT = 4856;

--------------------------------------------------------------------------------
-- MainDataSet
--------------------------------------------------------------------------------
SELECT DISTINCT p.ir_id
	, p.patient_key
	, p.gender
	, p.birth_date
	, p.race_1
INTO #cohort
FROM NM_BI.dim.vw_patient_current p
	JOIN FSM_Analytics.cohort.[cohort_patients] cp
		ON cp.source_ir_id = p.ir_id
		AND cp.[is_dltd_flg] = 0 
		AND cp.[cohort_id] = @cohort_id 
	JOIN FSM_Analytics.cohort.[cohorts] c 
		ON c.[cohort_id] = cp.[cohort_id] 
		AND c.[is_dltd_flg] = 0
;


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


--First prescription for TNFAI drugs
--This index date will be used for all matching criteria
SELECT *
INTO #prescriptions
FROM (
	SELECT *
		, ROW_NUMBER() OVER (PARTITION BY ir_id ORDER BY order_start_datetime ASC) AS rnk
	FROM ( 
		SELECT DISTINCT p.ir_id
			, mk.med_name
			, mk.medication_name
			, mo.order_start_datetime
			, CASE WHEN MONTH(p.birth_date) > MONTH(mo.order_start_datetime) OR (MONTH(p.birth_date) = MONTH(mo.order_start_datetime) AND DAY(p.birth_date) > DAY(mo.order_start_datetime)) THEN DATEDIFF(YY, p.birth_date, mo.order_start_datetime) - 1 
				ELSE DATEDIFF(YY, p.birth_date, mo.order_start_datetime) END AS age_at_drug_initiation
		FROM NM_BI.fact.vw_medication_order mo
			JOIN NM_BI.dim.vw_medication m
				ON m.medication_key = mo.medication_key
			JOIN NM_BI.dim.vw_medication_order_profile mop
				ON mop.medication_order_profile_key = mo.medication_order_profile_key
				AND ISNULL(mop.order_status,'') NOT IN ('Canceled', 'Voided', 'Order Canceled', 'Voided With Results', 'Future', 'Incomplete')
			JOIN #cohort p
				ON p.patient_key = mo.patient_key
			JOIN #medKeys mk
				ON mk.medication_key = m.medication_key
			LEFT JOIN NM_BI.fact.vw_medication_administration mar
				ON mar.medication_order_key = mo.medication_order_key
		WHERE mo.order_start_datetime <= '1-22-2020'
		AND mar.medication_order_key IS NULL	--Exclude MAR
		) x
	) y
WHERE y.rnk = 1
;


SELECT *
INTO #bmiIndex
FROM ( 
	SELECT c.ir_id
		, v.vital_value_number
		, ROW_NUMBER() OVER (PARTITION BY c.ir_id ORDER BY ABS(DATEDIFF(DAY,v.recorded_datetime,pr.order_start_datetime))) AS rnk
	FROM NM_BI.fact.vw_vital v
		JOIN NM_BI.dim.vw_vital_type vt
			ON vt.vital_type_key = v.vital_type_key
		JOIN #cohort c
			ON c.patient_key = v.patient_key
		JOIN #prescriptions pr
			ON pr.ir_id = c.ir_id
	WHERE vt.vital_type_name_category = 'BMI'
	AND v.vital_value_number IS NOT NULL
	) x
WHERE x.rnk = 1
;


--Smoking status at drug intiation, categorized into current, former, never, unknown
SELECT DISTINCT ir_id
	, smoking_status
INTO #smoking 
FROM (
	SELECT DISTINCT x.ir_id
		, CASE WHEN x.smoking_status LIKE '%NEVER%' OR x.Smoking_status IN ('Never', 'None') THEN 'Never'
			WHEN x.smoking_status LIKE '%current%'
				OR x.Smoking_status IN ('1 pack a day', 'Under 1 pack a day', 'Under 1 pack a week', 'Yes, within the past 12 months', 'Tobacco Use, other')
				OR x.smoking_status LIKE '%heavy%'
				OR x.Smoking_status LIKE '%moderate%'
				OR x.smoking_status LIKE '%light%' THEN 'Current'
			WHEN x.Smoking_status LIKE '%former%'
				OR x.Smoking_status IN ('Yes, but more than 12 months ago', 'Quit more than 12 months ago', 'Past') THEN 'Former'
			WHEN x.smoking_status IN ('Patient refuses tobacco screen'	
							, 'Patient Unavailable'				
							, 'Unable to screen'				
							, 'Unknown if ever smoked'			
							, 'admitting rn did not chart'
							, 'Unknown if ever smoked') THEN 'Unknown' END AS smoking_status
		, ROW_NUMBER() OVER (PARTITION BY x.ir_id ORDER BY ABS(DATEDIFF(DAY,contact_date,order_start_datetime))) AS latest_rank 
    FROM (
		SELECT DISTINCT mc.ir_id
			, mc.order_start_datetime
            , zc.NAME AS Smoking_status
            , shx.contact_date 
        FROM #prescriptions mc
			JOIN cr_xwalk.vw_patient cx
				ON cx.ir_id = mc.ir_id
				AND cx.source_system_key = 1	--Clarity
            JOIN clarity.dbo.social_hx shx 
                ON cx.source_system_id = shx.pat_id 
            JOIN clarity.dbo.zc_smoking_tob_use zc 
                ON shx.smoking_tob_use_c = zc.smoking_tob_use_c 

        UNION

        SELECT DISTINCT mc.ir_id
			, mc.order_start_datetime
            , zc.NAME AS Latest_smoking_status
            , shx.contact_date 
        FROM #prescriptions mc
			JOIN cr_xwalk.vw_patient cx
				ON cx.ir_id = mc.ir_id
				AND cx.source_system_key = 2	--Legacy Clarity
            JOIN nmff_clarity.dbo.social_hx shx 
                ON cx.source_system_id = shx.pat_id 
            JOIN nmff_clarity.dbo.zc_smoking_tob_use zc 
                ON shx.smoking_tob_use_c = zc.smoking_tob_use_c 

        UNION

        SELECT DISTINCT c.ir_id
			, c.order_start_datetime
            , ce.result_val
            , ce.event_end_dt_tm 
        FROM #prescriptions c 
			JOIN cr_xwalk.vw_patient cx
				ON cx.ir_id = c.ir_id
				AND cx.source_system_key = 3	--Cerner
			JOIN nmh_cerner.nmh_cerner_ods.clinical_event ce 
				ON ce.person_id = cx.source_system_id 
			JOIN nmh_cerner.nmh_cerner_ods.code_value cv 
				ON cv.code_value = ce.event_cd 
        WHERE ce.event_cd IN (24137696,                                         -- Tobacco Use                                                      
                                609193127                                         -- Smoking Amount        
								--,
								--Removing these next two because they don't conform to the standard "former", "current", "never"                                      
                                --609195882,                                         -- Total Pack Years                                                
                                --662611526                                        -- Other Tobacco Use                                           
                                ) 
		AND result_val NOT IN ('Task Duplication'
							, 'Schedule Conflict'				--excluding all of these b/c they're too hard to categorize
							, 'pt was on 1012'					--excluding all of these b/c they're too hard to categorize
							, 'not admitted on 16E'				--excluding all of these b/c they're too hard to categorize
							, 'not inpt'						--excluding all of these b/c they're too hard to categorize
							, 'error'							--excluding all of these b/c they're too hard to categorize
							, 'chart done'						--excluding all of these b/c they're too hard to categorize
							, 'charted on incorrect order'		--excluding all of these b/c they're too hard to categorize
							, 'charted on incorrect patient'	--excluding all of these b/c they're too hard to categorize
							, 'completed 9/28 in SICU'			--excluding all of these b/c they're too hard to categorize
							, 'already complete'				--excluding all of these b/c they're too hard to categorize
							, ' '								--excluding all of these b/c they're too hard to categorize
							, 'Not Appropriate at this Time'	--excluding all of these b/c they're too hard to categorize
							, 'Other - See Comment'				--excluding all of these b/c they're too hard to categorize
							)
		) x
	) y 
WHERE y.latest_rank = 1
;


SELECT ir_id
	, DATEDIFF(MONTH,MIN(visit_dt), MAX(visit_dt)) AS months_of_followup
INTO #followup
FROM (
	SELECT c.ir_id
		, v.visit_start_date_key AS visit_dt
	FROM NM_BI.fact.vw_visit v
		JOIN #cohort c
			ON c.patient_key = v.patient_key
		JOIN #prescriptions pr
			ON pr.ir_id = c.ir_id
	WHERE v.visit_start_date_key <= pr.order_start_datetime	--months of follow-up at drug initiation
	AND v.visit_start_date_key > '1971-01-01'	--this date showed up a lot, which makes me think it must be junk

	UNION

	SELECT c.ir_id
		, e.encounter_start_date_key
	FROM NM_BI.fact.vw_encounter_outpatient e
		JOIN #cohort c
			ON c.patient_key = e.patient_key
		JOIN #prescriptions pr
			ON pr.ir_id = c.ir_id
		JOIN NM_BI.dim.vw_encounter_status st
			ON st.encounter_status_key = e.encounter_status_key
			AND st.encounter_status_name NOT IN ('Cancelled', 'Rescheduled', 'No Show', 'Canceled', 'Left Without Seen')
		JOIN NM_BI.dim.vw_encounter_type et
			ON et.encounter_type_key = e.encounter_type_key
	WHERE e.encounter_start_date_key <= pr.order_start_datetime --months of follow-up at drug initiation
	AND e.encounter_start_date_Key > '1971-01-01' --this date showed up a lot, which makes me think it must be junk
	) x
GROUP BY ir_id
;


SELECT DISTINCT c.ir_id				AS case_ir_id
	, pr.age_at_drug_initiation		AS case_age
	, CASE WHEN c.race_1 IS NULL OR c.race_1 IN ('Declined to Answer', 'Unable to Answer', 'Declined') THEN 'Unknown'
		WHEN c.race_1 = 'White or Caucasian' THEN 'White' ELSE c.race_1 END	AS case_race
	, c.gender						AS case_gender
	, cast(sm.smoking_status as varchar(max))				AS case_smoking
	, b.vital_value_number			AS case_bmi
	, fu.months_of_followup			AS case_followup_months
INTO #cases
FROM #cohort c
	JOIN #prescriptions pr
		ON pr.ir_id = c.ir_id
	JOIN #bmiIndex b
		ON b.ir_id = c.ir_id
	JOIN #smoking sm
		ON sm.ir_Id = c.ir_id
	JOIN #followup fu
		ON fu.ir_id = c.ir_id
;


--------------------------------------------------------
-- Controls 
--------------------------------------------------------
--All patients who received TNFAI drugs, this will be used as an exclusion criteria for the controls
SELECT DISTINCT p.ir_id
INTO #exclude1
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
INTO #exclude2
FROM NM_BI.fact.vw_diagnosis_event de
	JOIN NM_BI.dim.vw_diagnosis_terminology dt
		ON dt.diagnosis_key = de.diagnosis_key
	JOIN NM_BI.dim.vw_patient p
		ON p.patient_key = de.patient_key
WHERE (dt.diagnosis_code_base IN ('556', 'K50'	--UC
							, '720', 'M45'	--Ankylosing_Spondylitis
							)
OR dt.diagnosis_code IN ('364.00', '364.01', '364.02', '364.03', '364.04', '364.05'	--uveitis
						, '705.83', 'L73.2'	--hidradenitis_suppurativa
						)
OR LEFT(dt.diagnosis_code,5) IN ('H20.0', 'H20.1')	--uveitis
)
;


SELECT DISTINCT p.ir_id
	, p.patient_key
	, p.birth_date
	, p.age
	, p.race_1
	, p.gender
INTO #controlsPre
FROM NM_BI.dim.vw_patient_current p
WHERE NOT EXISTS (SELECT 'x' FROM #exclude1 cp WHERE cp.ir_id = p.ir_id)
AND NOT EXISTS (SELECT 'x' FROM #exclude2 e WHERE e.ir_id = p.ir_id)
AND p.is_test_patient = 0
AND p.full_name NOT LIKE '%zztest%'
AND p.age >= 18
;


SELECT *
INTO #bmiControls
FROM ( 
	SELECT c.ir_id
		, v.recorded_datetime
		, v.vital_value_number
		, ROW_NUMBER() OVER (PARTITION BY c.ir_id ORDER BY v.recorded_datetime DESC) AS rnk
	FROM NM_BI.fact.vw_vital v
		JOIN NM_BI.dim.vw_vital_type vt
			ON vt.vital_type_key = v.vital_type_key
		JOIN #controlsPre c
			ON c.patient_key = v.patient_key
	WHERE vt.vital_type_name_category = 'BMI'
	AND v.vital_value_number IS NOT NULL
	) x
WHERE x.rnk = 1
;


SELECT y.ir_id
	, y.smoking_status
INTO #smokingControls
FROM (
	SELECT DISTINCT x.ir_id
		, CASE WHEN x.smoking_status LIKE '%NEVER%' OR x.Smoking_status IN ('Never', 'None') THEN 'Never'
			WHEN x.smoking_status LIKE '%current%'
				OR x.Smoking_status IN ('1 pack a day', 'Under 1 pack a day', 'Under 1 pack a week', 'Yes, within the past 12 months', 'Tobacco Use, other')
				OR x.smoking_status LIKE '%heavy%'
				OR x.Smoking_status LIKE '%moderate%'
				OR x.smoking_status LIKE '%light%' THEN 'Current'
			WHEN x.Smoking_status LIKE '%former%'
				OR x.Smoking_status IN ('Yes, but more than 12 months ago', 'Quit more than 12 months ago', 'Past') THEN 'Former'
			WHEN x.smoking_status IN ('Patient refuses tobacco screen'	
							, 'Patient Unavailable'				
							, 'Unable to screen'				
							, 'Unknown if ever smoked'			
							, 'admitting rn did not chart'
							, 'Unknown if ever smoked') THEN 'Unknown'  else smoking_status end AS smoking_status
		, ROW_NUMBER() OVER (PARTITION BY x.ir_id ORDER BY contact_date DESC) AS latest_rank 
    FROM (
		SELECT DISTINCT mc.ir_id
            , zc.NAME AS Smoking_status
            , shx.contact_date 
        FROM #controlsPre mc
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
        FROM #controlsPre mc
			JOIN cr_xwalk.vw_patient cx
				ON cx.ir_id = mc.ir_id
				AND cx.source_system_key = 2	--Legacy Clarity
            JOIN nmff_clarity.dbo.social_hx shx 
                ON cx.source_system_id = shx.pat_id 
            JOIN nmff_clarity.dbo.zc_smoking_tob_use zc 
                ON shx.smoking_tob_use_c = zc.smoking_tob_use_c 

		/*
		--too hard to adjudicate these values at scale so skipping them, still get 1.5 million controls to choose from

        UNION

        SELECT DISTINCT c.ir_id
            , ce.result_val
            , ce.event_end_dt_tm 
        FROM #controlsPre c 
			JOIN cr_xwalk.vw_patient cx
				ON cx.ir_id = c.ir_id
				AND cx.source_system_key = 3	--Cerner
			JOIN nmh_cerner.nmh_cerner_ods.clinical_event ce 
				ON ce.person_id = cx.source_system_id 
			JOIN nmh_cerner.nmh_cerner_ods.code_value cv 
				ON cv.code_value = ce.event_cd 
        WHERE ce.event_cd IN (24137696,                                         -- Tobacco Use                                                      
                                609193127                                         -- Smoking Amount        
								--,
								--Removing these next two because they don't conform to the standard "former", "current", "never"                                      
                                --609195882,                                         -- Total Pack Years                                                
                                --662611526                                        -- Other Tobacco Use                                           
                                ) 
		AND result_val NOT IN ('Task Duplication'		
							, 'Schedule Conflict'				--excluding all of these b/c they're too hard to categorize
							, 'pt was on 1012'					--excluding all of these b/c they're too hard to categorize
							, 'not admitted on 16E'				--excluding all of these b/c they're too hard to categorize
							, 'not inpt'						--excluding all of these b/c they're too hard to categorize
							, 'error'							--excluding all of these b/c they're too hard to categorize
							, 'chart done'						--excluding all of these b/c they're too hard to categorize
							, 'charted on incorrect order'		--excluding all of these b/c they're too hard to categorize
							, 'charted on incorrect patient'	--excluding all of these b/c they're too hard to categorize
							, 'completed 9/28 in SICU'			--excluding all of these b/c they're too hard to categorize
							, 'already complete'				--excluding all of these b/c they're too hard to categorize
							, ' '								--excluding all of these b/c they're too hard to categorize
							, 'Not Appropriate at this Time'	--excluding all of these b/c they're too hard to categorize
							, 'Other - See Comment'				--excluding all of these b/c they're too hard to categorize
							)
		*/
		) x
	) y 
WHERE y.latest_rank = 1 
;


SELECT ir_id
	, DATEDIFF(MONTH,MIN(visit_dt), MAX(visit_dt)) AS months_of_followup
INTO #followupControls
FROM (
	SELECT c.ir_id
		, v.visit_start_date_key AS visit_dt
	FROM NM_BI.fact.vw_visit v
		JOIN #controlsPre c
			ON c.patient_key = v.patient_key
	WHERE v.visit_start_date_key <= '1-22-2020'
	AND v.visit_start_date_key > '1971-01-01' --this date showed up a lot, which makes me think it must be junk

	UNION

	SELECT c.ir_id
		, e.encounter_start_date_key
	FROM NM_BI.fact.vw_encounter_outpatient e
		JOIN #controlsPre c
			ON c.patient_key = e.patient_key
		JOIN NM_BI.dim.vw_encounter_status st
			ON st.encounter_status_key = e.encounter_status_key
			AND st.encounter_status_name NOT IN ('Cancelled', 'Rescheduled', 'No Show', 'Canceled', 'Left Without Seen')
		JOIN NM_BI.dim.vw_encounter_type et
			ON et.encounter_type_key = e.encounter_type_key
	WHERE e.encounter_start_date_key <= '1-22-2020'
	AND e.encounter_start_date_key > '1971-01-01' --this date showed up a lot, which makes me think it must be junk
	) x
GROUP BY ir_id
HAVING MIN(visit_dt) >= '1-1-1998'
;


SELECT DISTINCT cp.ir_id AS control_ir_id
	, cp.age AS control_age
	, CASE WHEN cp.race_1 IN ('Unable to Answer', 'Declined') OR cp.race_1 IS NULL THEN 'Unknown'
		WHEN cp.race_1 = 'Hispanic' THEN 'Hispanic or Latino'
		WHEN cp.race_1 = 'American Indian or Alaskan Native' THEN 'American Indian or Alaska Native' ELSE cp.race_1 END AS control_race
	, cp.gender AS control_gender
	, cast(smoking_status as varchar(max)) AS control_smoking
	, bmi.vital_value_number AS control_bmi
	, months_of_followup AS control_followup_months
	, 0 AS matched_flg
INTO #controls
FROM #controlsPre cp
	JOIN #bmiControls bmi
		ON bmi.ir_id = cp.ir_id
	JOIN #smokingControls smo
		ON smo.ir_id = cp.ir_id
	JOIN #followupControls fu
		ON fu.ir_id = cp.ir_id
WHERE NOT EXISTS (SELECT 'x' FROM #cases c WHERE c.case_ir_id = cp.ir_id)	--double check that no cases are included
;


------------------------------------------------------------
-- Case Control Matching
------------------------------------------------------------
-- CREATE MATCHED TABLE
create table #matched 
(
	  case_ir_id int,
      case_age int,
      case_gender char(1),
      case_race varchar(50),
      case_smoking varchar(max),
	  case_bmi float,
	  case_followup_months int,
      
	  control_ir_id int,
      control_age int,
      control_gender char(1),
      control_race varchar(50),
      control_smoking varchar(max),
	  control_bmi float,
	  control_followup_months int,
)

-- CREATE SELECTED MRD PT IDS TABLE
create table #selected_ir_ids
(
      control_ir_id int
);

create clustered index ci_selected_ir_ids ON #selected_ir_ids(control_ir_id ASC);


-- SET UP FOR LOOP
declare @case_ir_id int,
      @case_age int,
      @case_gender char(1),
      @case_race varchar(50),
      @case_smoking varchar(max),
	  @case_bmi float,
	  @case_followup_months int

declare case_cursor cursor for
select case_ir_id,
      case_age,
      case_gender,
      case_race,
      case_smoking,
	  case_bmi,
	  case_followup_months
from #cases
order by case_ir_id

open case_cursor; 

fetch next from case_cursor
into @case_ir_id,
      @case_age,
      @case_gender,
      @case_race,
      @case_smoking,
	  @case_bmi,
	  @case_followup_months

while @@fetch_status = 0
begin   
      
      insert into #matched
      output inserted.control_ir_id into #selected_ir_ids
      select top 3 @case_ir_id,	-- SET TOP X NUMBER OF CONTROLS YOU WANT
            @case_age,
            @case_gender,
            @case_race,
            @case_smoking,
			@case_bmi,
			@case_followup_months,
            
			c.control_ir_id,
            c.control_age,
            c.control_gender,
            c.control_race,
            c.control_smoking,
			c.control_bmi,
			c.control_followup_months
      from #controls c
      where @case_gender = c.control_gender
            and @case_race = c.control_race
			and @case_smoking = c.control_smoking
			and abs(@case_age - c.control_age) <= 5
			and abs(@case_bmi - c.control_bmi) <= 5
			and abs(@case_followup_months - c.control_followup_months) <= 10
            --and abs(datediff(month, @case_pt_birth_dts, c.cntr_pt_birth_dts)) <= 24 -- PLUS OR MINUS X MONTHS, DAYS, ETC.
            -- YOU COULD CHOOSE TO REUSE CONTROLS, OR NOT
            and not c.matched_flg > 0 
      order by abs(@case_age - c.control_age) asc, -- ORDER BY THE BEST MATCHES
			abs(@case_bmi - c.control_bmi) asc,
			abs(@case_followup_months - c.control_followup_months) asc,
            c.matched_flg asc -- PREFERENCE UNMATCHED/LEAST MATCHED CONTROLS IF YOU CHOOSE TO REUSE
            
      update #controls
      set matched_flg = x.matched_flg -- UPDATE THE CONTROLS THAT WERE USED
      from 
      (
            select m.control_ir_id,
                  count(*) as matched_flg
            from #matched m
      where exists (select 'x' from #selected_ir_ids s where s.control_ir_id = m.control_ir_id)   
      group by m.control_ir_id
      )x
      where x.control_ir_id = #controls.control_ir_id

                truncate table #selected_ir_ids;      

      fetch next from case_cursor
      into @case_ir_id,
            @case_age,
            @case_gender,
            @case_race,
            @case_smoking,
			@case_bmi,
			@case_followup_months
end

close case_cursor;	
deallocate case_cursor;


SELECT *
INTO FSM_EDW.reports_dm.rw2436_case_control_matching
FROM #matched


drop table #cases;
drop table #controls;
drop table #matched;
drop table #selected_ir_ids;
drop table #bmiControls;
drop table #bmiIndex;
drop table #cohort;
drop table #controlsPre;
drop table #exclude1;
drop table #exclude2;
drop table #followup;
drop table #followupControls;
drop table #medKeys;
drop table #prescriptions;
drop table #smoking;
drop table #smokingControls;
*/