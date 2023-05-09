***********************************************************************
* 	PART 0: Environment			  									  *
***********************************************************************
*ssc install asdoc
***********************************************************************
* 	PART 1: Import			  										  *
************************************************************************
	*import excel
import excel "C:\Users\Azra\Desktop\SDDB\survey_SDDB.xlsx", firstrow clear

	*drop micrsoft survey variables
drop Starttime Completiontime Email Name Totalpoints Quizfeedback PointsWhatisyourgender FeedbackWhatisyourgender PointsHowoldareyou ///
FeedbackHowoldareyou FeedbackHowoldareyou PointsWhatisyourcurrentsc FeedbackWhatisyourcurrent PointsOnaveragehowmanyho FeedbackOnaveragehowmany ///
U V PointsDoyouuseyourphoneo FeedbackDoyouuseyourphone PointsHowoftendoyouusedi FeedbackHowoftendoyouuse AD AE PointsDoyoufinditdifficul ///
FeedbackDoyoufinditdiffic PointsHaveyouevermissedor FeedbackHaveyouevermissed PointsHaveyourgradessuffer FeedbackHaveyourgradessuff ///
FeedbackPleaseanswertheseq PointsPleaseanswertheseque Feedbackhowimportantiseduc Pointshowimportantiseducat Feedbackhowimportantisdigi ///
Pointshowimportantisdigita Feedbackyoufeelthatyourte Pointsyoufeelthatyourteac Feedbackyoufeellikeyounee Pointsyoufeellikeyouneed ///
Feedbackyoufeellikestudyin Pointsyoufeellikestudying FeedbackHaveyoueverconside PointsHaveyoueverconsidere FeedbackIfyeswhatwasthe ///
PointsIfyeswhatwasthema FeedbackWhattypesofdigital PointsWhattypesofdigitale FeedbackDoyoupersonallythi PointsDoyoupersonallythink


***********************************************************************
* 	PART 2: Clean	  			
***********************************************************************
	*rename & label veriables
rename Whatisyourgender gender
lab var gender "Participants' gender"

rename Howoldareyou age
lab var age "Participants' age"

rename Whatisyourcurrentschoolleve education
lab var education "Participant's education level"

rename Onaveragehowmanyhoursofho study_hours
lab var study_hours "Average hours spent on studying per day"

rename Onaveragehowmanyhoursofsl sleep_hours
lab var sleep_hours "Average hours of sleep per night"

rename Doyouuseyourphoneoranyscr screen_hours
lab var screen_hours "Hours of blue light before sleeping"

rename Howoftendoyouusedigitalent usage_weekday
lab var usage_weekday "Average hours of digital entertainment use during a weekday"

rename AC usage_weekend
lab var usage_weekend "Average hours of digital entertainment use during a weekend"

rename Doyoufinditdifficulttobala digital_study_balance
lab var digital_study_balance "Difficulty of balancing time between studying and digital entertainment"

rename Haveyouevermissedorbeenlat study_miss
lab var digital_study_balance "Missing courses because of digital entertainment"

rename Haveyourgradessufferedbecaus study_grades
lab var study_grades "Deterioration of grades because of digital entertainment"

rename howimportantiseducationtoyo study_importance
lab var study_importance "Importance of education"

rename howimportantisdigitalenterta digital_importance
lab var study_importance "Importance of digital entertainment"

rename youfeelthatyourteachersprov study_support
lab var study_support "Support from the teacher"

rename youfeellikeyouneedhelpwith digital_help
lab var digital_help "Help needed with digital entertainment usage time"

rename youfeellikestudyingdoesnot study_future
lab var digital_help "Education does not offer a good future anymore"

rename Haveyoueverconsidereddroppin study_drop
lab var digital_help "Considered dropping out"

rename Ifyeswhatwasthemainreason study_drop_reason
lab var study_drop_reason "Dropping out reason"

rename Whattypesofdigitalentertainm digital_type
lab var digital_type "Type of digital entertainment used"

rename Doyoupersonallythinkthatdig digital_study_drop
lab var digital_type "If digital entertainment affect dropout ratios"

	*values labels
*likert values

local likertvariables study_importance digital_importance study_support study_future digital_help
label define likertt 0 "Very Unlikely" 1 "Somewhat Unlikely" 2 "Neither likely nor unlikely" 3 "Somewhat likely" 4 "Very likely"

foreach var of local likertvariables {
	encode `var', generate(`var'_num)
	label values `var'_num likertt
}

*study_hours fix

replace study_hours ="0" if study_hours == "None"
replace study_hours ="3" if study_hours =="3+"
encode study_hours, gen(study_hours_num)

*drop old variables
drop study_importance digital_importance study_support study_future digital_help study_hours
***********************************************************************
* 	PART 3: Correct	  			
***********************************************************************
replace education ="Not studying anymore" if education =="Not studying anymore (if this is your case, please answer the next questions in reference to your studying years)"

replace study_drop_reason ="entourage" if study_drop_reason =="None. Kholta m*ayka"

***********************************************************************
* 	PART 4: Generate	  			
***********************************************************************
gen digital_type_social = 0
replace digital_type_social = 1 if ustrregexm(digital_type, "social media")
lab var digital_type_social "Uses social media"

gen digital_type_games = 0
replace digital_type_games = 1 if ustrregexm(digital_type, "video games") 
lab var digital_type_games "Plays video games"

gen digital_type_streaming = 0
replace digital_type_streaming = 1 if ustrregexm(digital_type, "online streaming") 
lab var digital_type_streaming "Watches streams"

gen digital_type_other = 0
replace digital_type_other = 1 if ustrregexm(digital_type, "other") 
lab var digital_type_other "Uses other type of digital entertainment"

gen digtal_presence = digital_type_social + digital_type_games + digital_type_streaming + digital_type_other
lab var digtal_presence "Digital presence score"


***********************************************************************
* 	PART 4: Stats	  			
***********************************************************************
cd "C:\Users\Azra\Desktop\SDDB\Output"

*outreg summary stats
asdoc describe, replace
asdoc sum ID study_importance digital_importance study_support study_future digital_help_num digital_type_social digital_type_games digital_type_streaming digital_type_other
*asdoc tabulate gender age education sleep_hours screen_hours usage_weekday usage_weekend digital_study_balance study_miss study_grades study_drop

putpdf clear
putpdf begin 
putpdf paragraph

putpdf text ("Survey: Relationship between Digital Entertainment use and school dropout ratios in Tunisia"), bold linebreak

putpdf text ("Date: `c(current_date)'"), bold linebreak

*gender
graph bar (count),over (gender) blabel(total, format(%9.2fc)) ///
	title("Gender distribution")  ///
	ytitle("Number of responses")
graph export gender.png, replace
putpdf paragraph, halign(center)
putpdf image gender.png
putpdf pagebreak

*age
graph bar (count),over (age) blabel(total, format(%9.2fc)) ///
	title("Age distribution")  ///
	ytitle("Number of responses")
graph export age.png, replace
putpdf paragraph, halign(center)
putpdf image age.png
putpdf pagebreak

*education
graph bar (count),over (education) blabel(total, format(%9.2fc)) ///
	title("Level of education")  ///
	ytitle("Number of responses")
graph export education.png, replace
putpdf paragraph, halign(center)
putpdf image education.png
putpdf pagebreak

*screen hours
graph pie, over(screen_hours) plabel(_all percent)  ///
	legend(pos(1) ring(0) col(1) symxsize(small) symysize(small)) ///
	title("Exposure to phone bluelight before sleep", size(large))
graph export screen_hours.png, replace
putpdf paragraph, halign(center)
putpdf image screen_hours.png
putpdf pagebreak

*sleep hours
generate order_sleep = 1 if sleep_hours=="less than 6 hours"
replace order_sleep = 2 if sleep_hours=="between 7 and 8 hours"
replace order_sleep = 3 if sleep_hours=="between 8 and 10 hours"
replace order_sleep = 4 if sleep_hours=="more than 10 hours"

graph hbar (count) ID, over(sleep_hours, sort(order_sleep))  blabel(total, format(%9.1fc)) ///
	legend (pos(6) row(3) ) ///
	title("Average sleep hours each night")  scale(*.5) ///
	ytitle("Number of responses") 
graph export sleep_hours.png, replace
putpdf paragraph, halign(center)
putpdf image sleep_hours.png
putpdf pagebreak
drop order_sleep

*usage weekday
generate order_educ = 1 if usage_weekday=="between an hour and 3 hours"
replace order_educ = 2 if usage_weekday=="between 3 hours and 6 hours"
replace order_educ = 3 if usage_weekday=="more than 6 hours"

graph hbar (count) ID, over(usage_weekday, sort(order_educ)) blabel(total, format(%9.1fc)) ///
	legend (pos(6) row(3) ) ///
        title("Average digital entertainment usage during weekday") scale(*.5) ///
        ytitle("Number of responses")
graph export usage_weekday.png, replace
putpdf paragraph, halign(center)
putpdf image usage_weekday.png
putpdf pagebreak
drop order_educ

*usage weekend
generate order_weekend = 1 if usage_weekend=="less than an hour"
replace order_weekend = 2 if usage_weekend=="between an hour and 3 hours"
replace order_weekend = 3 if usage_weekend=="between 3 hours and 6 hours"
replace order_weekend = 4 if usage_weekend=="more than 6 hours"

graph hbar (count) ID,over (usage_weekend, sort(order_weekend)) blabel(total, format(%9.2fc)) ///
	title("Average digital entertainment usage during weekend")  ///
	ytitle("Number of responses") scale(*.5) 
graph export usage_weekend.png, replace
putpdf paragraph, halign(center)
putpdf image usage_weekend.png
putpdf pagebreak
drop order_weekend
	
*digital study balance
graph pie, over(digital_study_balance) plabel(_all percent)  ///
	legend(pos(1) ring(0) col(1) symxsize(small) symysize(small)) ///
	title("Difficulty in balancing studies with digital entertainment", size(large))
graph export study_balance.png, replace
putpdf paragraph, halign(center)
putpdf image study_balance.png
putpdf pagebreak

*miss study
graph pie, over(study_miss) plabel(_all percent)  ///
	legend(pos(1) ring(0) col(1) symxsize(small) symysize(small)) ///
	title("Missed courses because of digital entertainment", size(large))
graph export miss_study.png, replace
putpdf paragraph, halign(center)
putpdf image miss_study.png
putpdf pagebreak

*study grades
graph pie, over(study_grades) plabel(_all percent)  ///
	legend(pos(1) ring(0) col(1) symxsize(small) symysize(small)) ///
	title("Deterioration of grades because of digital entertainment", size(large))
graph export study_grades.png, replace
putpdf paragraph, halign(center)
putpdf image study_grades.png
putpdf pagebreak

*dropout
graph pie, over(study_drop) plabel(_all percent)  ///
	legend(pos(1) ring(0) col(1) symxsize(small) symysize(small) margin(zero)) legend(size(vsmall) ) ///
	title("Have you ever considered dropping out of school?", size(large))
graph export dropout.png, replace
putpdf paragraph, halign(center)
putpdf image dropout.png
putpdf pagebreak

*Digital entertainment usage
gen Social_Media = digital_type_social/digtal_presence
lab var Social_Media "Social Media"
gen Video_Games = digital_type_games/digtal_presence
lab var Video_Games "Video Games"
gen Streaming = digital_type_streaming/digtal_presence
gen Other = digital_type_other/digtal_presence
 graph pie Social_Media Video_Games Streaming Other, plabel(_all percent)  ///
	legend(pos(1) ring(0) col(1) symxsize(small) symysize(small) margin(zero)) legend(size(vsmall) ) ///
	title("Type of digital entertainment used", size(large))
graph export type_digital.png, replace
putpdf paragraph, halign(center)
putpdf image type_digital.png
putpdf pagebreak
drop Social_Media Video_Games Streaming Other
*Likert scale
	*
graph hbar (mean) study_importance digital_importance study_support study_future digital_help, blabel(total, format(%9.2fc) gap(-0.2)) /// 
	legend (pos(6) row(9) label(1 "Importance of studying") label(2 "Importance of digital entertainment") ///
	label(3 "Support from teacher needed") label(4 "Help with digital entertainment usage needed") label(5 "Studying does not mean a good future anymore") size(vsmall)) ///
	title("Locus of studying for our participants") ///
	ylabel(0(1)4, nogrid)    
gr export likert.png, replace
putpdf paragraph, halign(center) 
putpdf image likert.png
putpdf pagebreak

putpdf save "SDBB_statistics", replace

