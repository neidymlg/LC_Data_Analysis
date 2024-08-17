--changing values to match other columns
UPDATE lc_table SET "Lung Cancer" = 'Yes' WHERE "Lung Cancer" = 'YES';
UPDATE lc_table SET "Lung Cancer" = 'No' WHERE "Lung Cancer" = 'NO';

/*
--------------------------------------------------------------------
Procedures
--------------------------------------------------------------------
*/

CREATE OR REPLACE PROCEDURE ADDROW_LCTABLE(
	gender character,
	age integer,
	smoking character varying(3),
	y_fingers character varying(3),
	anxiety character varying(3),
	pressure character varying(3),
	disease character varying(3),
	fatigue character varying(3),
	allergy character varying(3),
	wheezing character varying(3),
	alcohol character varying(3),
	coughing character varying(3),
	breathing_diff character varying(3),
	swallowing_diff character varying(3),
	chest_pain character varying(3),
	lung_cancer character varying(3)
)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO lc_table("Gender", "Age", "Smoking", "Yellow Fingers", "Anxiety", 
	"Peer Pressure", "Chronic Disease", "Fatigue", "Allergy", "Wheezing", "Alcohol Consuming", "Coughing", 
	"Shortness of Breath", "Swallowing Difficulty", "Chest Pain", "Lung Cancer")
	VALUES (gender,age, smoking, y_fingers, anxiety, pressure, disease, fatigue, allergy, wheezing, alcohol, coughing,
	breathing_diff, swallowing_diff, chest_pain, lung_cancer);
	COMMIT;
END;$$;

CREATE OR REPLACE PROCEDURE DELETEROW_LCTABLE(
	gender character,
	age integer,
	smoking character varying(3),
	y_fingers character varying(3),
	anxiety character varying(3),
	pressure character varying(3),
	disease character varying(3),
	fatigue character varying(3),
	allergy character varying(3),
	wheezing character varying(3),
	alcohol character varying(3),
	coughing character varying(3),
	breathing_diff character varying(3),
	swallowing_diff character varying(3),
	chest_pain character varying(3),
	lung_cancer character varying(3)
)
LANGUAGE plpgsql
AS $$
BEGIN
	DELETE FROM lc_table WHERE 
	"Gender" = gender AND "Age" = age AND "Smoking" = smoking AND "Yellow Fingers"= y_fingers AND 
	"Anxiety" = anxiety AND "Peer Pressure" = pressure AND "Chronic Disease" = disease AND
	"Fatigue" = fatigue AND "Allergy" = allergy AND "Wheezing" = wheezing AND 
	"Alcohol Consuming"=alcohol AND "Coughing"=coughing AND "Shortness of Breath"=breathing_diff  AND
	"Swallowing Difficulty"=swallowing_diff AND "Chest Pain"=chest_pain AND "Lung Cancer"=lung_cancer;
	COMMIT;
END;$$;

--values ('M' or 'F', discrete value, 'Yes' or 'No' for the following 14 columns)
CALL ADDROW_LCTABLE('M', 18, 'Yes','Yes','Yes','Yes','Yes','Yes','Yes','Yes','Yes','Yes','Yes','Yes','Yes','Yes');
-- DELETE FROM lc_table WHERE "Age" = 18;
SELECT * FROM lc_table ORDER BY "Age";
CALL DELETEROW_LCTABLE('M', 18, 'Yes','Yes','Yes','Yes','Yes','Yes','Yes','Yes','Yes','Yes','Yes','Yes','Yes','Yes');
SELECT * FROM lc_table ORDER BY "Age";

DROP PROCEDURE IF EXISTS deleterow_lctable, addrow_lctable;

SELECT *
FROM information_schema.routines
WHERE routine_type = 'PROCEDURE';

SELECT 'How many patients have conditions out of each condition';
SELECT 
	COUNT(CASE "Smoking" WHEN 'Yes' THEN 1 ELSE NULL END)*100/COUNT("Smoking") AS "curr_smoker%",
	COUNT(CASE "Yellow Fingers" WHEN 'Yes' THEN 1 ELSE NULL END)*100/COUNT("Yellow Fingers") AS "curr_yellow_finger%",
	COUNT(CASE "Anxiety" WHEN 'Yes' THEN 1 ELSE NULL END)*100/COUNT("Anxiety") AS "curr_anxiety%",
	COUNT(CASE "Peer Pressure" WHEN 'Yes' THEN 1 ELSE NULL END)*100/COUNT("Peer Pressure") AS "curr_peer_pressure%",
	COUNT(CASE "Chronic Disease" WHEN 'Yes' THEN 1 ELSE NULL END)*100/COUNT("Chronic Disease") AS "curr_chronic_disease%",
	COUNT(CASE "Fatigue" WHEN 'Yes' THEN 1 ELSE NULL END)*100/COUNT("Fatigue") AS "curr_fatigue%",
	COUNT(CASE "Allergy" WHEN 'Yes' THEN 1 ELSE NULL END)*100/COUNT("Allergy") AS "curr_allergy%",
	COUNT(CASE "Wheezing" WHEN 'Yes' THEN 1 ELSE NULL END)*100/COUNT("Wheezing") AS "curr_wheezing%",
	COUNT(CASE "Alcohol Consuming" WHEN 'Yes' THEN 1 ELSE NULL END)*100/COUNT("Alcohol Consuming") AS "curr_alcohol_consumer%",
	COUNT(CASE "Coughing" WHEN 'Yes' THEN 1 ELSE NULL END)*100/COUNT("Coughing") AS "curr_coughing%",
	COUNT(CASE "Shortness of Breath" WHEN 'Yes' THEN 1 ELSE NULL END)*100/COUNT("Shortness of Breath") AS "curr_shortness_breath%",
	COUNT(CASE "Swallowing Difficulty" WHEN 'Yes' THEN 1 ELSE NULL END)*100/COUNT("Swallowing Difficulty") AS "curr_swallowing_difficulty%",
	COUNT(CASE "Chest Pain" WHEN 'Yes' THEN 1 ELSE NULL END)*100/COUNT("Chest Pain") AS "curr_chest_pain%",
	COUNT(CASE "Lung Cancer" WHEN 'Yes' THEN 1 ELSE NULL END)*100/COUNT("Lung Cancer") AS "curr_lung_cancer%"
FROM lc_table;

SELECT 'How many patients have conditions out of total amount of patients. This is the same as the above calculation, as none of the 
	conditions can be null. Otherwise, they would be different.';
SELECT 
	COUNT(CASE "Smoking" WHEN 'Yes' THEN 1 ELSE NULL END)*100/COUNT(*) AS "curr_smoker%",
	COUNT(CASE "Yellow Fingers" WHEN 'Yes' THEN 1 ELSE NULL END)*100/COUNT(*) AS "curr_yellow_finger%",
	COUNT(CASE "Anxiety" WHEN 'Yes' THEN 1 ELSE NULL END)*100/COUNT(*) AS "curr_anxiety%",
	COUNT(CASE "Peer Pressure" WHEN 'Yes' THEN 1 ELSE NULL END)*100/COUNT(*) AS "curr_peer_pressure%",
	COUNT(CASE "Chronic Disease" WHEN 'Yes' THEN 1 ELSE NULL END)*100/COUNT(*) AS "curr_chronic_disease%",
	COUNT(CASE "Fatigue" WHEN 'Yes' THEN 1 ELSE NULL END)*100/COUNT(*) AS "curr_fatigue%",
	COUNT(CASE "Allergy" WHEN 'Yes' THEN 1 ELSE NULL END)*100/COUNT(*) AS "curr_allergy%",
	COUNT(CASE "Wheezing" WHEN 'Yes' THEN 1 ELSE NULL END)*100/COUNT(*) AS "curr_wheezing%",
	COUNT(CASE "Alcohol Consuming" WHEN 'Yes' THEN 1 ELSE NULL END)*100/COUNT(*) AS "curr_alcohol_consumer%",
	COUNT(CASE "Coughing" WHEN 'Yes' THEN 1 ELSE NULL END)*100/COUNT(*) AS "curr_coughing%",
	COUNT(CASE "Shortness of Breath" WHEN 'Yes' THEN 1 ELSE NULL END)*100/COUNT(*) AS "curr_shortness_breath%",
	COUNT(CASE "Swallowing Difficulty" WHEN 'Yes' THEN 1 ELSE NULL END)*100/COUNT(*) AS "curr_swallowing_difficulty%",
	COUNT(CASE "Chest Pain" WHEN 'Yes' THEN 1 ELSE NULL END)*100/COUNT(*) AS "curr_chest_pain%",
	COUNT(CASE "Lung Cancer" WHEN 'Yes' THEN 1 ELSE NULL END)*100/COUNT(*) AS "curr_lung_cancer%"
FROM lc_table;
SELECT * FROM lc_table;

/*
--------------------------------------------------------------------
Conditional Probability
--------------------------------------------------------------------
*/
SELECT 'Given that a user is a smoker, the following percentage shows how likely they are to have lung cancer:';
WITH smoking_lc_intersect (smoking_intersect) AS (
 	SELECT COUNT("Smoking") FROM lc_table WHERE "Smoking" = 'Yes' AND "Lung Cancer" = 'Yes'
),
	smoking_total (smoking_t) AS(
	SELECT COUNT("Smoking") FROM lc_table WHERE "Smoking" = 'Yes'
	)
SELECT (smoking_intersect*100)/smoking_t AS "likelihood of lung cancer if curr smoker%" FROM smoking_lc_intersect, smoking_total;

SELECT 'Given that a user has a chronic disease, the following percentage shows how likely they are to have lung cancer:';
WITH chronic_disease_intersect (cd_intersect) AS (
 	SELECT COUNT("Chronic Disease") FROM lc_table WHERE "Chronic Disease" = 'Yes' AND "Lung Cancer" = 'Yes'
),
	chronic_disease_total (cd_t) AS(
	SELECT COUNT("Chronic Disease") FROM lc_table WHERE "Chronic Disease" = 'Yes'
	)
SELECT (cd_intersect*100)/cd_t AS "likelihood of lung cancer if_ urr chronic disease%" FROM chronic_disease_intersect, chronic_disease_total;

SELECT 'Given that a user has fatigue, the following percentage shows how likely they are to have lung cancer:';
WITH fatigue_intersect (f_intersect) AS (
 	SELECT COUNT("Fatigue") FROM lc_table WHERE "Fatigue" = 'Yes' AND "Lung Cancer" = 'Yes'
),
	fatigue_total (f_t) AS(
	SELECT COUNT("Fatigue") FROM lc_table WHERE "Fatigue" = 'Yes'
	)
SELECT (f_intersect*100)/f_t AS "likelihood of lung cancer if curr fatigue%" FROM fatigue_intersect, fatigue_total;

SELECT 'Given that a user has chest pain, the following percentage shows how likely they are to have lung cancer:';
WITH chest_pain_intersect (cp_intersect) AS (
 	SELECT COUNT("Chest Pain") FROM lc_table WHERE "Chest Pain" = 'Yes' AND "Lung Cancer" = 'Yes'
),
	chest_pain_total (cp_t) AS(
	SELECT COUNT("Chest Pain") FROM lc_table WHERE "Chest Pain" = 'Yes'
	)
SELECT (cp_intersect*100)/cp_t AS "likelihood of lung cancer if curr chest pain%" FROM chest_pain_intersect, chest_pain_total;

SELECT 'Given that a user has yellow fingers, the following percentage shows how likely they are to have lung cancer:';
WITH yellow_fingers_intersect (yf_intersect) AS (
 	SELECT COUNT("Yellow Fingers") FROM lc_table WHERE "Yellow Fingers" = 'Yes' AND "Lung Cancer" = 'Yes'
),
	yellow_fingers_total (yf_t) AS(
	SELECT COUNT("Yellow Fingers") FROM lc_table WHERE "Yellow Fingers" = 'Yes'
	)
SELECT (yf_intersect*100)/yf_t AS "likelihood of lung cancer if curr yellow fingers%" FROM yellow_fingers_intersect, yellow_fingers_total;


SELECT 'Given that a user has anxiety, the following percentage shows how likely they are to have lung cancer:';
WITH anxiety_intersect (anxiety_intersect) AS (
 	SELECT COUNT("Anxiety") FROM lc_table WHERE "Anxiety" = 'Yes' AND "Lung Cancer" = 'Yes'
),
	anxiety_total (anxiety_t) AS(
	SELECT COUNT("Anxiety") FROM lc_table WHERE "Anxiety" = 'Yes'
	)
SELECT (anxiety_intersect*100)/anxiety_t AS "likelihood of lung_cancer if curr anxiety%" FROM anxiety_intersect, anxiety_total;
SELECT 'Since anxiety is not a symptom commonly tied to lung cancer, we can say that this data is a bit biased in terms of showing
people who have comorbities and lung cancer';


/*
--------------------------------------------------------------------
Union and Intersect Probability
--------------------------------------------------------------------
*/
WITH smoking_lc_intersect (smoking_intersect) AS (
 	SELECT COUNT("Smoking") FROM lc_table WHERE "Smoking" = 'Yes' AND "Lung Cancer" = 'Yes'
),
	smoking_lc_addition (combo_t) AS (
	SELECT COUNT(CASE "Smoking" WHEN 'Yes' THEN 1 ELSE NULL END) + COUNT(CASE "Lung Cancer" WHEN 'Yes' THEN 1 ELSE NULL END) FROM lc_table
	),
	row_total (row_t) AS (
	SELECT COUNT(*) FROM lc_table
	) 
	SELECT  combo_t - smoking_intersect AS "Patients that smoke or have lung cancer", (combo_t - smoking_intersect)*100/row_t AS "Patients that smoke or have lung cancer%",
	(smoking_intersect*100)/row_t AS "Patients who both smoke and have lung cancer%"
	FROM smoking_lc_addition, smoking_lc_intersect, row_total;


/*
--------------------------------------------------------------------
Bayes Theorem
--------------------------------------------------------------------
*/

SELECT 'Given that a patient has lung cancer, find out how likely it is for the patient to also have yellow fingers.
	Assume that the likelihood of a patient having lung cancer given that they have yellow fingers is 49% (if the dataset is not changed). Note that 
	all calculations and percentages are based on the sample. Since the sample seems biased, this is not
	an accurate portrayal, and more data is definitely needed.';
WITH yf_lc_intersect (yf_lc_intersect) AS(
 	SELECT COUNT("Lung Cancer") * 100 FROM lc_table WHERE "Yellow Fingers" = 'Yes' AND "Lung Cancer" = 'Yes'
),
	curr_yellow_fingers_total (yf_t) AS (
	SELECT COUNT("Yellow Fingers") FROM lc_table WHERE "Yellow Fingers" = 'Yes'
),  curr_yf_total (curr_yf_t) AS (
	SELECT (COUNT(CASE "Yellow Fingers" WHEN 'Yes' THEN 1 ELSE NULL END)*100)/ COUNT("Yellow Fingers") FROM lc_table
	),
	curr_lc_total (curr_lc_t) AS (
	SELECT (COUNT(CASE "Lung Cancer" WHEN 'Yes' THEN 1 ELSE NULL END)*100)/ COUNT("Lung Cancer") FROM lc_table
	)
	SELECT ((yf_lc_intersect/yf_t) * curr_yf_t)/curr_lc_t AS "Patients who have yellow fingers given they have lung cancer%"
	FROM yf_lc_intersect, curr_yellow_fingers_total, curr_yf_total, curr_lc_total;

SELECT 'This following is just a calculation to ensure that we have the correct percentage.'
WITH yf_lc_intersect (lc_intersect) AS (
 	SELECT COUNT("Lung Cancer") FROM lc_table WHERE "Yellow Fingers" = 'Yes' AND "Lung Cancer" = 'Yes'
),
	lc_total (lc_t) AS(
	SELECT COUNT("Lung Cancer") FROM lc_table WHERE "Lung Cancer" = 'Yes'
	)
SELECT (lc_intersect*100)/lc_t AS "Patients who have yellow fingers given they have lung cancer%" FROM yf_lc_intersect, lc_total;
