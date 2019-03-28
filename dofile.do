** HEALTH ECONOMETRICS AND POLICY EVALUATION COURSE **
* Thursday, 28th March 2019 *
* University of Oxford *


** Part 1: EVALUATING INTERVENTIONS **

/*
Consider the model Y = B0 + B1X + U. Assume that X is binary (i.e. only
takes on the values 0 and 1) and that E (U|X) = 0. It is possible to show that:

B1 = E (Y | X = 1) - E (Y | X = 0) 
B0 = E (Y | X = 0) 

Now consider the model:

ChildMortality = B0 + B1 * WaterPrivatization + U 

where WaterPrivatization = 1 if the municipality privatizes its water services, = 0 otherwise. 
Suppose that you observe an i.i.d. sample on the variables ChildMortality and WaterPrivatization a
Suppose that, in your dataset, ChildMortality is 8% in municipalities that privatize. A
Suppose that in your data set, ChildMortality is 14% in municipalities that do not privatize. 
What are the OLS estimates of B0 and B1?

*/

/*
** Part 2: DIFFERENCE-IN-DIFFERENCES APPROACH **
Levine, P.B., McKnight, R., and Heep, S. (2011), "How Effective are Public Policies to Increase Health Insurance Coverage Among Young Adults", American Economic Journal: Economic Policy 3 (February 2011): 129–156

Country: 
United States

Health policy issue:
Up to 1997, Medicaid eligibility very restrictive (up to age 19)
Very low rates of insurance coverage for older teenagers (14 to 19)

Intervention: 
The introduction State Children’s Health Insurance Program between 1997 and 1999
allows young to be covered under their parents’ employer-provided plan.

Question: 
Does this policy increase health insurance takeup among young ? 

Research Strategy:
Compare variation insurance coverage after 1998 for those who are under age 19 (First-diff)
With the variation in insurance coverage after 1998 for those who are above age 19 (Second-diff)

Estimator: [(Coverage_under19_after1998)-(Coverage_under19_before1998)]-[(Coverage_over19_after1998)-(Coverage_over19_before1998)]
*/

* A1: Open the dataset and describe the variable. What are the relevant variables for our analysis?
* Dataset available at: https://www.aeaweb.org/articles?id=10.1257/pol.3.1.129

des
sum

** A2: Inspect trends
keep if a_age>=16 & a_age<=22
gen count=1
gen d_age=(a_age<19)
collapse (sum) count insured , by(d_age year)
gen perc_insured=insured/count*100
twoway (line  perc_insured year if d_age==0) || (line  perc_insured year if d_age==1), xline(1997)

* Alternatively:
use "/Users/nicolo/Downloads/assignment2.dta", clear
gen period1=(year>=1990 & year<=1995)
gen period2=(year>=1999 & year<=2003)
gen period3=(year>=2004 & year<=2009)
gen count=1
gen period=1 if period1==1
replace period=2 if period2==1
replace period=3 if period3==1
collapse (sum) count privhi pubhi insured, by(period age)
gen perc_insured=insured/count*100
twoway (line  perc_insured age if period==1, lcolor(blu)) || (line  perc_insured age if period==2) || (line  perc_insured age if period==3), xline(19)

** A3: Implement a Difference-in-Differences model: What is the effect of the reform on insurance coverage for teenagers aged 14-19?

** A4: Is there a differential effect on public vs private insurance?


** Part 3: INSTRUMENTAL VARIABLE APPROACH **
* A. Colin Cameron and Pravin K. Trivedi (2008), "Microeconometrics using Stata" , Chapter 6, Stata Press

/*
Country:
The original data is from the Medical Expenditure Panel Survey for United States residents over 65 

Question:
How does having (or not) a health insurance influence drug expenditure?

Issue:
Having health insurance is not independent from drug expenditure. Why?
*/

use http://zamek415.free.fr/mus06data, clear
des
gen agesq=age^2
global x2list age agesq female totchr blhisp linc 
sum ldrugexp hi_empunion $x2list

* A1: Regression analysis: What is the effect of having an insurance provided by the employer or union on drug expenditure?

* A2: What variables mediate the relationship between having an additional insurance and drug expeniture?

* A3: Instrumental variable approach
/*
Endogeneity of independent variable (endogenous explanatory variable)
causes also  the correlation with the error term which leads again to bias and inconsistency 
in all of the OLS estimators
*/

*The idea is to find a third variable, which is correlated with the outcome variable only through the endogenous regressor (The instrument is exogenous)
* In the dataset we have four candidate instruments:
des ssiratio lowincome multlc firmsz
sum ssiratio lowincome multlc firmsz 

correlate hi_empunion ssiratio lowincome multlc firmsz 

* Use command ivregress to fit an IV model and comment the results


** Part 4: COMPETITION ***
use "/Users/nicolo/Downloads/concentration by hospital 10_26_16.dta", clear
des
sum

twoway scatter loci hhi

gen uniform=runiform(.1900171,.9916006)
gen loci_unif=uniform*loci
gen mortality=volume*loci_unif
gen mortalityrate=volume/mortality
reg mortalityrate loci
gen logmortality=log(mortalityrate)
gen logloci=log(loci)
reg logmortality logloci

/*
North Hospital and South Hospital serve an Island community. They both have two departments; i) Inpatients; ii) Accident and Emergency (A&E). 
Patients can choose which hospital to visit when they require treatment, and as these are NHS hospitals, treatment is free at point of delivery to patients. 
In 2017, Central Hospital opened, located between the previously existing hospitals. Upon opening, it was only able to treat inpatients because the A&E department wasn’t complete.
1) how would the opening of Central Hospital affect potential patients, hospital management and the spending of the NHS on Island healthcare? 
Hint: think about quality of care, waiting times, activity levels, staffing etc. Would this impact just inpatient admissions or also those seeking A&E care? 
Can you think of any theories that may come be relevant when new capacity is added to healthcare provision?
*/



/*
In 2018, Central Hospital completed the development of their A&E department and it started to treat patients. 
2) how would the opening of Central Hospital’s A&E department affect patients, management and spending? Would this affect solely A&E or will there be any spillovers into inpatient activity?
*/

/*
In 2019, North East GP Centre opened. Located not far from North Hospital this site did not have the same facilities as a Hospital.
Their staff could perform minor procedures, and it acted as a gateway to North Hospital, referring patients who required more complicated treatment.
3) How would the opening of North East GP Hub affect the hospitals?  Would you expect all three hospitals to be impacted in the same way? 
What is likely to happen to the average complexity of a hospital admission?
*/

