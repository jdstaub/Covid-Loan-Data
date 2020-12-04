-- PPP Loan Analysis

USE covid_loans;
-- Total, average, number of jobs reported, number of loans given out
SELECT
	SUM(loan_amount),
    AVG(loan_amount),
    SUM(jobs_reported),
    COUNT(*)
FROM ppp;


-- total, average, and max loan that went to a business with "Name Unavailable"
SELECT SUM(loan_amount),
	   AVG(loan_amount),
       MAX(loan_amount)
FROM ppp
WHERE business_name = 'NOT AVAILABLE';
-- $1216769 went to businesses without a name. The largest loan to a business without an
-- available name was #148440, and the average was #39251.

-- Find other info about businesses that recieved a loan but didn't have a name available.
SELECT
	loan_amount, business_name, state, zip, naics_code, business_type, jobs_reported, date_approved, lender, congressional_district,
    nc.naics_name
FROM ppp
LEFT OUTER JOIN naics_codes nc USING (naics_code)
WHERE business_name = 'NOT AVAILABLE';
-- Many of the business with name: N/A have the naics_code 339114 which after a quick google
-- indicate they are "Dental Equiptment and Supplies Manufacturing"
-- All of these "Dental" businesses also have no state or zip, and all filed for loans on 05/01/2020.
-- All had the same lender.
-- Maybe fishy, maybe bad data.

-- Find out which business_types recieved the most money and how that related to jobs reported.
SELECT 
	business_type,
    COUNT(business_type),
	SUM(loan_amount),
    AVG(loan_amount),
    AVG(jobs_reported)
FROM PPP
GROUP BY business_type
ORDER BY AVG(loan_amount) DESC;
-- Non Profit Childcare Centers (NPCC) got the most money on average, and also had the most jobs reported, on average.
-- Number of jobs reported is correlated with avg loan amount across business types, but it is not a very strong correlation
-- NPCCs had almost double the jobs reported but only ~6% higher loan amounts.

-- Find which industries got the most money and 'saved' the most jobs
SELECT SUM(loan_amount), SUM(jobs_reported), naics_code, 
	nc.naics_name
FROM ppp
LEFT OUTER JOIN naics_codes nc USING (naics_code)
GROUP BY naics_code
ORDER BY SUM(loan_amount) DESC;
-- By far the largest impact was on the Full-Service Restaurant industry, both in terms of money loaned and
-- jobs reported. After that come Dentists, Doctors, Lawyers, Limited-Service Restraunts, Religious
-- Organizations, Insurance Agencies, Real Estate Offices, Plumbing and HVAC Contractors, then home
-- construction.