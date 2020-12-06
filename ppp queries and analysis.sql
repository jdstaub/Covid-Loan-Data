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
WHERE business_name IN ('Not Available', 'N/A', ' ');
-- $8,131,200 went to businesses without a name. The largest loan to a business without an
-- available name was $1,500,000, and the average was $74598.

-- Find other info about businesses that recieved a loan but didn't have a name available.
SELECT
	loan_amount, business_name, state, zip, ppp.naics_code, business_type, jobs_reported, date_approved, lender, congressional_district,
    nc.naics_name
FROM ppp
LEFT JOIN naics_codes nc ON ppp.naics_code = nc.naics_code
WHERE business_name IN ('Not Available', 'N/A', ' ');
-- Many of the business with name: N/A have the naics_code 339114, including the 3 largest loans
-- to business with name N/A. NAICS code means they are in "Dental Equiptment and Supplies Manufacturing."
-- All of these "Dental" businesses also have no state or zip, and all filed for loans on 05/01/2020.
-- All had the same lender, Bank of America, National Association.
-- Maybe fishy, maybe bad data.

-- Find out which business_types recieved the most money and how that related to jobs reported.
SELECT 
	business_type,
    COUNT(business_type),
	SUM(loan_amount),
    AVG(loan_amount),
    AVG(jobs_reported),
    AVG(loan_amount)/AVG(jobs_reported) AS loan_amount_per_job
FROM PPP
GROUP BY business_type
ORDER BY AVG(loan_amount) DESC;
-- Business of the type Employee Stock Ownership Plan got the most on average, and also had the highest
-- jobs reported. They had the second highest loan amount per job, slightly behind "Tenant in Common."

-- Find which industries got the most money and 'saved' the most jobs
SELECT SUM(loan_amount), SUM(jobs_reported), naics_code, 
	nc.naics_name
FROM ppp
LEFT OUTER JOIN naics_codes nc USING (naics_code)
GROUP BY naics_code
ORDER BY SUM(loan_amount) DESC;
-- By far the largest impact was on the Full-Service Restaurant industry, both in terms of money loaned and
-- jobs reported. After that come Doctors, Lawyers, New Car Dealers, Limited-Service Restraunts,
-- Plumbing and HVAC Contractors, then Commercial and Institutional Construction.

-- See how money was distributed between loans of different sizes.
SELECT '>= 150k' AS loan_size, COUNT(loan_amount), SUM(loan_amount), SUM(jobs_reported)
FROM ppp
WHERE loan_amount >= 150000
UNION
SELECT '<150k'AS loan_size, COUNT(loan_amount), SUM(loan_amount), SUM(jobs_reported)
FROM ppp
WHERE loan_amount < 150000
UNION
SELECT 'Any'AS loan_size, COUNT(loan_amount), SUM(loan_amount), SUM(jobs_reported)
FROM ppp;
-- Despite being 15% of the loans disbursed, loans >= 150k accounted for 76% of the money!
-- However, these larger loans also accounted for 66.6% of jobs reported.

SELECT '>= 500k' AS loan_size, COUNT(loan_amount), SUM(loan_amount), SUM(jobs_reported)
FROM ppp
WHERE loan_amount >= 500000
UNION
SELECT '< 500k' AS loan_size, COUNT(loan_amount), SUM(loan_amount), SUM(jobs_reported)
FROM ppp
WHERE loan_amount < 500000
UNION
SELECT 'Any' AS loan_size, COUNT(loan_amount), SUM(loan_amount), SUM(jobs_reported)
FROM ppp;
-- 4.49% of comapnies recieved 51.5% of the money disbursed and accounted for 41.1% of jobs recorded. 

-- In what industries were the large (>500k loans) distributed?
SELECT COUNT(loan_amount), SUM(loan_amount), SUM(jobs_reported), ppp.naics_code, nc.naics_name
FROM ppp
LEFT OUTER JOIN naics_codes nc USING (naics_code)
WHERE loan_amount < 500000
GROUP BY nc.naics_code;
-- Most loans >500k were distributed to companies without an naics_code.
-- Most of the money in loans >500k went to Full Service Restaurants, then Doctors, Dentists, Lawyers, Religious Orgs,
-- Pluming and HVAC Contractors, then Limited-Service Restaurants.

SELECT *
FROM ppp
WHERE business_name IN ('Not Available', 'N/A', ' ');