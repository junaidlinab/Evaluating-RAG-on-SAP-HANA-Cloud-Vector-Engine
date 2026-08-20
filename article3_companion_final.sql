-- Evaluating RAG on SAP HANA Cloud Vector Engine
-- Companion Script
--
-- This script reproduces all results presented in the article.
-- Run each section sequentially in SAP HANA Cloud Database Explorer.
--
-- Embedding model: SAP_NEB.20240715
-- Author: Junaid Ahmed


-- Context Store

CREATE COLUMN TABLE ENTERPRISE_CONTEXT (
    ID              INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    DOMAIN          NVARCHAR(20) NOT NULL,
    DOC_ID          NVARCHAR(50) NOT NULL,
    DOC_TITLE       NVARCHAR(200) NOT NULL,
    CHUNK_ID        INTEGER NOT NULL,
    CHUNK_TEXT      NCLOB NOT NULL,
    CHUNK_VECTOR    REAL_VECTOR(768) NULL,
    FILING_TYPE     NVARCHAR(50) NULL,
    ENTITY          NVARCHAR(100) NULL,
    REGION          NVARCHAR(50) NULL,
    EFFECTIVE_DATE  DATE NULL,
    EXPIRY_DATE     DATE NULL,
    VERSION         INTEGER DEFAULT 1,
    IS_ACTIVE       NVARCHAR(1) DEFAULT 'Y',
    CREATED_AT      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Finance Documents

INSERT INTO ENTERPRISE_CONTEXT
(DOMAIN, DOC_ID, DOC_TITLE, CHUNK_ID, CHUNK_TEXT, FILING_TYPE, ENTITY, REGION, EFFECTIVE_DATE, EXPIRY_DATE, VERSION, IS_ACTIVE)
VALUES ('FINANCE', 'FIN-001', 'Treasury Policy — Foreign Exchange Hedging', 1,
'The Group''s foreign exchange hedging policy mandates that all anticipated foreign currency cash flows exceeding USD 500,000 equivalent must be hedged at a minimum coverage ratio of 75%. Hedging instruments are limited to vanilla forward contracts and purchased options with maturities not exceeding 18 months. Cross-currency swaps require Board-level approval. The Treasury function must maintain a rolling 12-month hedge book and report mark-to-market valuations monthly to the CFO.',
'POLICY', 'Meridian Capital Group', 'GLOBAL', '2025-01-01', '2025-12-31', 2, 'Y');

INSERT INTO ENTERPRISE_CONTEXT
(DOMAIN, DOC_ID, DOC_TITLE, CHUNK_ID, CHUNK_TEXT, FILING_TYPE, ENTITY, REGION, EFFECTIVE_DATE, EXPIRY_DATE, VERSION, IS_ACTIVE)
VALUES ('FINANCE', 'FIN-001', 'Treasury Policy — Foreign Exchange Hedging', 2,
'Permitted counterparties for FX hedging transactions are limited to financial institutions with a minimum credit rating of A- (S&P) or A3 (Moody''s). Maximum exposure to any single counterparty shall not exceed 25% of the total hedge book notional. Counterparty credit risk must be reviewed quarterly by the Risk Management function. ISDA Master Agreements must be in place with all counterparties prior to trade execution.',
'POLICY', 'Meridian Capital Group', 'GLOBAL', '2025-01-01', '2025-12-31', 2, 'Y');

INSERT INTO ENTERPRISE_CONTEXT
(DOMAIN, DOC_ID, DOC_TITLE, CHUNK_ID, CHUNK_TEXT, FILING_TYPE, ENTITY, REGION, EFFECTIVE_DATE, EXPIRY_DATE, VERSION, IS_ACTIVE)
VALUES ('FINANCE', 'FIN-001', 'Treasury Policy — Foreign Exchange Hedging', 3,
'Hedge effectiveness testing shall be performed prospectively using the critical terms match method and retrospectively using the dollar-offset method. A hedge is considered effective if the retrospective ratio falls within the range of 80% to 125%. Ineffective hedges must be de-designated immediately and the ineffective portion recognized in the income statement. All hedge documentation must comply with IFRS 9 requirements.',
'POLICY', 'Meridian Capital Group', 'GLOBAL', '2025-01-01', '2025-12-31', 2, 'Y');

INSERT INTO ENTERPRISE_CONTEXT
(DOMAIN, DOC_ID, DOC_TITLE, CHUNK_ID, CHUNK_TEXT, FILING_TYPE, ENTITY, REGION, EFFECTIVE_DATE, EXPIRY_DATE, VERSION, IS_ACTIVE)
VALUES ('FINANCE', 'FIN-002', 'Q3 2025 Earnings Summary — Meridian Capital Group', 1,
'Meridian Capital Group reported Q3 2025 consolidated revenue of USD 2.41 billion, an increase of 8.3% year-over-year. Operating income was USD 387 million with an operating margin of 16.1%, up from 14.8% in Q3 2024. Net income attributable to shareholders was USD 261 million, or USD 3.42 per diluted share. The effective tax rate for the quarter was 21.7%.',
'EARNINGS', 'Meridian Capital Group', 'NORTH AMERICA', '2025-10-15', '2026-03-31', 1, 'Y');

INSERT INTO ENTERPRISE_CONTEXT
(DOMAIN, DOC_ID, DOC_TITLE, CHUNK_ID, CHUNK_TEXT, FILING_TYPE, ENTITY, REGION, EFFECTIVE_DATE, EXPIRY_DATE, VERSION, IS_ACTIVE)
VALUES ('FINANCE', 'FIN-002', 'Q3 2025 Earnings Summary — Meridian Capital Group', 2,
'Revenue by segment: Investment Banking generated USD 892 million (37% of total), up 12% driven by strong M&A advisory. Asset Management contributed USD 743 million (31%), up 6% on higher AUM. Trading and Markets delivered USD 512 million (21%), down 3% on lower fixed income volumes. Wealth Management reported USD 264 million (11%), up 9% from net new client assets of USD 4.2 billion.',
'EARNINGS', 'Meridian Capital Group', 'NORTH AMERICA', '2025-10-15', '2026-03-31', 1, 'Y');

INSERT INTO ENTERPRISE_CONTEXT
(DOMAIN, DOC_ID, DOC_TITLE, CHUNK_ID, CHUNK_TEXT, FILING_TYPE, ENTITY, REGION, EFFECTIVE_DATE, EXPIRY_DATE, VERSION, IS_ACTIVE)
VALUES ('FINANCE', 'FIN-002', 'Q3 2025 Earnings Summary — Meridian Capital Group', 3,
'The Group maintains a Common Equity Tier 1 (CET1) ratio of 13.8%, well above the regulatory minimum of 10.5%. Total risk-weighted assets were USD 89.4 billion. The Board approved a quarterly dividend of USD 1.15 per share and authorized an additional USD 500 million share repurchase program. Return on tangible equity for Q3 was 14.2%.',
'EARNINGS', 'Meridian Capital Group', 'NORTH AMERICA', '2025-10-15', '2026-03-31', 1, 'Y');

INSERT INTO ENTERPRISE_CONTEXT
(DOMAIN, DOC_ID, DOC_TITLE, CHUNK_ID, CHUNK_TEXT, FILING_TYPE, ENTITY, REGION, EFFECTIVE_DATE, EXPIRY_DATE, VERSION, IS_ACTIVE)
VALUES ('FINANCE', 'FIN-003', 'Enterprise Risk Register — Q3 2025', 1,
'Risk ID: MRK-001. Category: Market Risk. Description: Significant adverse movement in interest rates impacting the Group''s fixed income trading portfolio and net interest income. Current exposure: USD 1.2 billion notional in rate-sensitive positions. Likelihood: Medium. Impact: High. Mitigation: Duration limits of +/- 2 years, daily VaR monitoring with 99% confidence interval, Board-approved stop-loss limits of USD 15 million per desk.',
'RISK', 'Meridian Capital Group', 'GLOBAL', '2025-07-01', '2025-12-31', 1, 'Y');

INSERT INTO ENTERPRISE_CONTEXT
(DOMAIN, DOC_ID, DOC_TITLE, CHUNK_ID, CHUNK_TEXT, FILING_TYPE, ENTITY, REGION, EFFECTIVE_DATE, EXPIRY_DATE, VERSION, IS_ACTIVE)
VALUES ('FINANCE', 'FIN-003', 'Enterprise Risk Register — Q3 2025', 2,
'Risk ID: OPR-003. Category: Operational Risk. Description: Failure of critical technology systems including trading platforms, settlement systems, and client-facing applications. Current exposure: All revenue-generating business lines. Likelihood: Low. Impact: Critical. Mitigation: Dual data center architecture with automated failover, RPO of 15 minutes, RTO of 2 hours, annual disaster recovery testing, third-party vendor SLAs with 99.95% uptime guarantees.',
'RISK', 'Meridian Capital Group', 'GLOBAL', '2025-07-01', '2025-12-31', 1, 'Y');


-- HR Documents

INSERT INTO ENTERPRISE_CONTEXT
(DOMAIN, DOC_ID, DOC_TITLE, CHUNK_ID, CHUNK_TEXT, FILING_TYPE, ENTITY, REGION, EFFECTIVE_DATE, EXPIRY_DATE, VERSION, IS_ACTIVE)
VALUES ('HR', 'HR-001', 'Global Leave Policy — Version 4', 1,
'All full-time employees are entitled to a minimum of 20 working days of annual leave per calendar year, accrued monthly. Part-time employees receive pro-rated entitlement based on contracted hours. Annual leave must be approved by the employee''s line manager at least 10 working days in advance for requests exceeding 5 consecutive days. Unused leave may be carried forward up to a maximum of 5 days into Q1 of the following year, subject to manager approval.',
'POLICY', 'Meridian Capital Group', 'GLOBAL', '2025-01-01', '2026-12-31', 4, 'Y');

INSERT INTO ENTERPRISE_CONTEXT
(DOMAIN, DOC_ID, DOC_TITLE, CHUNK_ID, CHUNK_TEXT, FILING_TYPE, ENTITY, REGION, EFFECTIVE_DATE, EXPIRY_DATE, VERSION, IS_ACTIVE)
VALUES ('HR', 'HR-001', 'Global Leave Policy — Version 4', 2,
'Parental leave provisions: Primary caregivers are entitled to 16 weeks of fully paid parental leave commencing from the date of birth or adoption. Secondary caregivers are entitled to 4 weeks of fully paid leave within the first 6 months. Employees returning from parental leave are guaranteed their previous role or an equivalent position at the same grade and compensation level. Parental leave does not affect annual leave accrual.',
'POLICY', 'Meridian Capital Group', 'GLOBAL', '2025-01-01', '2026-12-31', 4, 'Y');

INSERT INTO ENTERPRISE_CONTEXT
(DOMAIN, DOC_ID, DOC_TITLE, CHUNK_ID, CHUNK_TEXT, FILING_TYPE, ENTITY, REGION, EFFECTIVE_DATE, EXPIRY_DATE, VERSION, IS_ACTIVE)
VALUES ('HR', 'HR-002', 'Compensation Framework — Investment Banking Division', 1,
'Senior Manager grade in Investment Banking Division carries a base salary range of USD 185,000 to USD 240,000 with a target bonus of 80-120% of base salary. Performance evaluation is based on deal origination revenue (40%), client relationship development (25%), team leadership and mentoring (20%), and compliance and risk management (15%). Senior Managers are expected to originate minimum USD 5 million in fee revenue annually and maintain a pipeline of 3x their target.',
'COMPENSATION', 'Investment Banking Division', 'NORTH AMERICA', '2025-04-01', '2026-03-31', 1, 'Y');

INSERT INTO ENTERPRISE_CONTEXT
(DOMAIN, DOC_ID, DOC_TITLE, CHUNK_ID, CHUNK_TEXT, FILING_TYPE, ENTITY, REGION, EFFECTIVE_DATE, EXPIRY_DATE, VERSION, IS_ACTIVE)
VALUES ('HR', 'HR-002', 'Compensation Framework — Investment Banking Division', 2,
'Deferred compensation for Senior Manager grade: 30% of annual bonus above USD 100,000 is deferred over 3 years in equal installments. Deferred amounts are invested in a mix of Group equity (50%) and a diversified fund (50%). Clawback provisions apply for material risk events, compliance breaches, or voluntary departure within the deferral period. Accelerated vesting is available upon retirement after age 55 with minimum 10 years of service.',
'COMPENSATION', 'Investment Banking Division', 'NORTH AMERICA', '2025-04-01', '2026-03-31', 1, 'Y');

INSERT INTO ENTERPRISE_CONTEXT
(DOMAIN, DOC_ID, DOC_TITLE, CHUNK_ID, CHUNK_TEXT, FILING_TYPE, ENTITY, REGION, EFFECTIVE_DATE, EXPIRY_DATE, VERSION, IS_ACTIVE)
VALUES ('HR', 'HR-003', 'Compensation Framework — Technology Division', 1,
'Senior Manager grade in Technology Division carries a base salary range of USD 165,000 to USD 210,000 with a target bonus of 40-60% of base salary. Performance evaluation is based on project delivery and system reliability (35%), innovation and technical leadership (25%), team development and retention (25%), and stakeholder satisfaction (15%). Senior Managers are expected to lead a minimum of 2 major platform initiatives annually and maintain system uptime above 99.9%.',
'COMPENSATION', 'Technology Division', 'NORTH AMERICA', '2025-04-01', '2026-03-31', 1, 'Y');

INSERT INTO ENTERPRISE_CONTEXT
(DOMAIN, DOC_ID, DOC_TITLE, CHUNK_ID, CHUNK_TEXT, FILING_TYPE, ENTITY, REGION, EFFECTIVE_DATE, EXPIRY_DATE, VERSION, IS_ACTIVE)
VALUES ('HR', 'HR-003', 'Compensation Framework — Technology Division', 2,
'Retention equity grants for Technology Senior Managers: annual RSU grant of USD 50,000 to USD 80,000, vesting over 4 years with a 1-year cliff. Additional spot awards of up to USD 25,000 for critical project delivery or patent filings. Technology division employees are eligible for the Innovation Bonus Pool, funded at 2% of technology cost savings realized through automation and platform consolidation initiatives.',
'COMPENSATION', 'Technology Division', 'NORTH AMERICA', '2025-04-01', '2026-03-31', 1, 'Y');


-- Legal Documents

INSERT INTO ENTERPRISE_CONTEXT
(DOMAIN, DOC_ID, DOC_TITLE, CHUNK_ID, CHUNK_TEXT, FILING_TYPE, ENTITY, REGION, EFFECTIVE_DATE, EXPIRY_DATE, VERSION, IS_ACTIVE)
VALUES ('LEGAL', 'LEG-001', 'Data Protection and Privacy Policy — Version 3 (Superseded)', 1,
'Section 4.1: Personal data processing. The Group processes personal data in accordance with the General Data Protection Regulation (EU) 2016/679. Data subjects have the right to access, rectification, erasure, and portability of their personal data. Data retention periods are set at 7 years for client KYC data and 3 years for employee records post-termination. Data protection impact assessments are required for any new processing activity involving special categories of data.',
'POLICY', 'Meridian Capital Group', 'EU', '2023-06-01', '2025-05-31', 3, 'N');

INSERT INTO ENTERPRISE_CONTEXT
(DOMAIN, DOC_ID, DOC_TITLE, CHUNK_ID, CHUNK_TEXT, FILING_TYPE, ENTITY, REGION, EFFECTIVE_DATE, EXPIRY_DATE, VERSION, IS_ACTIVE)
VALUES ('LEGAL', 'LEG-001', 'Data Protection and Privacy Policy — Version 3 (Superseded)', 2,
'Section 5.2: Cross-border data transfers. Transfers of personal data outside the European Economic Area are permitted only where an adequacy decision exists or appropriate safeguards are in place, including Standard Contractual Clauses (SCCs) approved by the European Commission. Binding Corporate Rules have been approved by the Irish Data Protection Commission as the Group''s primary transfer mechanism for intra-group transfers.',
'POLICY', 'Meridian Capital Group', 'EU', '2023-06-01', '2025-05-31', 3, 'N');

INSERT INTO ENTERPRISE_CONTEXT
(DOMAIN, DOC_ID, DOC_TITLE, CHUNK_ID, CHUNK_TEXT, FILING_TYPE, ENTITY, REGION, EFFECTIVE_DATE, EXPIRY_DATE, VERSION, IS_ACTIVE)
VALUES ('LEGAL', 'LEG-002', 'Data Protection and Privacy Policy — Version 4 (Current)', 1,
'Section 4.1: Personal data processing. The Group processes personal data in accordance with the General Data Protection Regulation (EU) 2016/679 and the EU AI Act (Regulation 2024/1689). Data subjects have the right to access, rectification, erasure, portability, and the right to meaningful information about AI-assisted decisions affecting them. Data retention periods are set at 7 years for client KYC data, 5 years for AI training datasets, and 3 years for employee records post-termination. Data protection impact assessments are required for any new processing activity involving special categories of data or AI-based profiling.',
'POLICY', 'Meridian Capital Group', 'EU', '2025-06-01', '2027-05-31', 4, 'Y');

INSERT INTO ENTERPRISE_CONTEXT
(DOMAIN, DOC_ID, DOC_TITLE, CHUNK_ID, CHUNK_TEXT, FILING_TYPE, ENTITY, REGION, EFFECTIVE_DATE, EXPIRY_DATE, VERSION, IS_ACTIVE)
VALUES ('LEGAL', 'LEG-002', 'Data Protection and Privacy Policy — Version 4 (Current)', 2,
'Section 5.2: Cross-border data transfers. Transfers of personal data outside the European Economic Area are permitted only where an adequacy decision exists or appropriate safeguards are in place. The EU-US Data Privacy Framework is the primary mechanism for transfers to certified US entities, replacing Standard Contractual Clauses where applicable. Binding Corporate Rules remain in effect for intra-group transfers. All AI model training involving EU personal data must be performed within EEA-located infrastructure unless the data is fully anonymized prior to transfer.',
'POLICY', 'Meridian Capital Group', 'EU', '2025-06-01', '2027-05-31', 4, 'Y');

INSERT INTO ENTERPRISE_CONTEXT
(DOMAIN, DOC_ID, DOC_TITLE, CHUNK_ID, CHUNK_TEXT, FILING_TYPE, ENTITY, REGION, EFFECTIVE_DATE, EXPIRY_DATE, VERSION, IS_ACTIVE)
VALUES ('LEGAL', 'LEG-002', 'Data Protection and Privacy Policy — Version 4 (Current)', 3,
'Section 8.1: AI Governance. All AI systems deployed by the Group that process personal data or make decisions affecting natural persons must be registered in the Group AI Registry. High-risk AI systems as defined under Annex III of the EU AI Act require a conformity assessment prior to deployment. The Data Protection Officer and the AI Ethics Board must jointly approve any AI system classified as high-risk. Model documentation including training data provenance, performance metrics, and bias assessments must be maintained for the operational life of the system plus 5 years.',
'POLICY', 'Meridian Capital Group', 'EU', '2025-06-01', '2027-05-31', 4, 'Y');

INSERT INTO ENTERPRISE_CONTEXT
(DOMAIN, DOC_ID, DOC_TITLE, CHUNK_ID, CHUNK_TEXT, FILING_TYPE, ENTITY, REGION, EFFECTIVE_DATE, EXPIRY_DATE, VERSION, IS_ACTIVE)
VALUES ('LEGAL', 'LEG-003', 'Regulatory Compliance Framework — Anti-Money Laundering', 1,
'Article 12: Enhanced Due Diligence requirements. For clients classified as high-risk under the Group''s risk taxonomy, enhanced due diligence (EDD) must include: (a) independent verification of source of wealth and source of funds, (b) senior management approval for onboarding and annual review, (c) enhanced transaction monitoring with reduced thresholds — USD 5,000 for wire transfers (standard threshold: USD 10,000) and USD 2,000 for cash transactions (standard threshold: USD 5,000), and (d) annual on-site visits for correspondent banking relationships.',
'REGULATORY', 'Meridian Capital Group', 'GLOBAL', '2025-01-01', '2026-12-31', 2, 'Y');

INSERT INTO ENTERPRISE_CONTEXT
(DOMAIN, DOC_ID, DOC_TITLE, CHUNK_ID, CHUNK_TEXT, FILING_TYPE, ENTITY, REGION, EFFECTIVE_DATE, EXPIRY_DATE, VERSION, IS_ACTIVE)
VALUES ('LEGAL', 'LEG-003', 'Regulatory Compliance Framework — Anti-Money Laundering', 2,
'Article 15: Suspicious Activity Reporting. All employees are required to report any transaction or activity that gives rise to a suspicion of money laundering or terrorist financing to the Money Laundering Reporting Officer (MLRO) within 24 hours of identification. The MLRO must file a Suspicious Activity Report (SAR) with the relevant Financial Intelligence Unit within 3 working days of internal receipt. Tipping off — informing the client or any third party that a SAR has been filed — is a criminal offense under applicable law.',
'REGULATORY', 'Meridian Capital Group', 'GLOBAL', '2025-01-01', '2026-12-31', 2, 'Y');


-- Procurement Documents

INSERT INTO ENTERPRISE_CONTEXT
(DOMAIN, DOC_ID, DOC_TITLE, CHUNK_ID, CHUNK_TEXT, FILING_TYPE, ENTITY, REGION, EFFECTIVE_DATE, EXPIRY_DATE, VERSION, IS_ACTIVE)
VALUES ('PROCUREMENT', 'PROC-001', 'Preferred Supplier Evaluation — Cloud Infrastructure', 1,
'Supplier evaluation criteria for cloud infrastructure services. Vendors are assessed across five dimensions: (1) Technical capability — platform maturity, global region availability, compliance certifications (SOC 2 Type II, ISO 27001, FedRAMP mandatory), scored 0-30. (2) Commercial terms — pricing model transparency, volume discount structure, contract flexibility, scored 0-25. (3) Service reliability — historical uptime (minimum 99.95% required), incident response SLAs, disaster recovery capability, scored 0-20. (4) Security posture — encryption standards, access controls, vulnerability management program, scored 0-15. (5) Strategic alignment — roadmap fit, innovation partnership potential, executive sponsorship, scored 0-10.',
'EVALUATION', 'Technology Division', 'GLOBAL', '2025-03-01', '2025-12-31', 1, 'Y');

INSERT INTO ENTERPRISE_CONTEXT
(DOMAIN, DOC_ID, DOC_TITLE, CHUNK_ID, CHUNK_TEXT, FILING_TYPE, ENTITY, REGION, EFFECTIVE_DATE, EXPIRY_DATE, VERSION, IS_ACTIVE)
VALUES ('PROCUREMENT', 'PROC-001', 'Preferred Supplier Evaluation — Cloud Infrastructure', 2,
'Current evaluation results (March 2025): Vendor A (AWS) — Technical: 28, Commercial: 20, Reliability: 19, Security: 14, Strategic: 8. Total: 89/100. Status: Preferred. Vendor B (Azure) — Technical: 27, Commercial: 22, Reliability: 18, Security: 13, Strategic: 9. Total: 89/100. Status: Preferred. Vendor C (GCP) — Technical: 25, Commercial: 18, Reliability: 17, Security: 12, Strategic: 7. Total: 79/100. Status: Approved. Minimum threshold for Preferred status: 85/100. Approved status: 70/100. Vendors below 70 are placed on watch list with 6-month remediation period.',
'EVALUATION', 'Technology Division', 'GLOBAL', '2025-03-01', '2025-12-31', 1, 'Y');

INSERT INTO ENTERPRISE_CONTEXT
(DOMAIN, DOC_ID, DOC_TITLE, CHUNK_ID, CHUNK_TEXT, FILING_TYPE, ENTITY, REGION, EFFECTIVE_DATE, EXPIRY_DATE, VERSION, IS_ACTIVE)
VALUES ('PROCUREMENT', 'PROC-002', 'Master Services Agreement — Cloud Infrastructure (Vendor A)', 1,
'Clause 7: Service Level Commitments. Provider guarantees monthly uptime of 99.95% for compute services and 99.99% for object storage services. Service credits apply as follows: uptime 99.0%-99.95% — 10% credit on affected service fees; uptime 95.0%-99.0% — 25% credit; uptime below 95.0% — 50% credit. Credits are capped at 30% of monthly invoice value. Client must submit credit claims within 30 days of the incident. Provider''s total aggregate liability under this Agreement shall not exceed 12 months of fees paid.',
'CONTRACT', 'Meridian Capital Group', 'GLOBAL', '2025-04-01', '2028-03-31', 1, 'Y');

INSERT INTO ENTERPRISE_CONTEXT
(DOMAIN, DOC_ID, DOC_TITLE, CHUNK_ID, CHUNK_TEXT, FILING_TYPE, ENTITY, REGION, EFFECTIVE_DATE, EXPIRY_DATE, VERSION, IS_ACTIVE)
VALUES ('PROCUREMENT', 'PROC-002', 'Master Services Agreement — Cloud Infrastructure (Vendor A)', 2,
'Clause 12: Data Sovereignty and Processing Location. All Client data classified as Restricted or Confidential under the Client''s data classification policy must be processed and stored within the European Union. Provider shall not transfer, access, or process such data from any location outside the EU without prior written consent. Provider shall maintain a current list of all sub-processors and notify Client at least 30 days prior to any new sub-processor engagement. Client retains the right to object to any sub-processor on reasonable data protection grounds.',
'CONTRACT', 'Meridian Capital Group', 'GLOBAL', '2025-04-01', '2028-03-31', 1, 'Y');

INSERT INTO ENTERPRISE_CONTEXT
(DOMAIN, DOC_ID, DOC_TITLE, CHUNK_ID, CHUNK_TEXT, FILING_TYPE, ENTITY, REGION, EFFECTIVE_DATE, EXPIRY_DATE, VERSION, IS_ACTIVE)
VALUES ('PROCUREMENT', 'PROC-003', 'Procurement Policy — Technology Acquisitions', 1,
'Section 3: Approval thresholds for technology acquisitions. Purchases up to USD 25,000: Department Head approval. USD 25,001 to USD 100,000: Division CTO approval plus Procurement review. USD 100,001 to USD 500,000: Group CTO approval plus competitive tender (minimum 3 vendors). USD 500,001 to USD 2,000,000: CFO approval plus formal RFP process managed by Procurement. Above USD 2,000,000: Board approval plus formal RFP with independent evaluation committee. All technology acquisitions above USD 100,000 require a Total Cost of Ownership analysis covering a minimum 3-year period.',
'POLICY', 'Meridian Capital Group', 'GLOBAL', '2025-01-01', '2026-12-31', 3, 'Y');

INSERT INTO ENTERPRISE_CONTEXT
(DOMAIN, DOC_ID, DOC_TITLE, CHUNK_ID, CHUNK_TEXT, FILING_TYPE, ENTITY, REGION, EFFECTIVE_DATE, EXPIRY_DATE, VERSION, IS_ACTIVE)
VALUES ('PROCUREMENT', 'PROC-003', 'Procurement Policy — Technology Acquisitions', 2,
'Section 5: Vendor risk assessment. All new technology vendors must complete the Group''s Third-Party Risk Assessment questionnaire prior to contract execution. Assessment covers: information security controls, business continuity planning, financial stability (minimum Dun & Bradstreet rating of 3 or equivalent), regulatory compliance status, and ESG commitments. Vendors handling personal data must demonstrate GDPR compliance and agree to the Group''s Data Processing Agreement. Re-assessment is required annually for Tier 1 vendors (contract value above USD 500,000) and biannually for Tier 2 vendors.',
'POLICY', 'Meridian Capital Group', 'GLOBAL', '2025-01-01', '2026-12-31', 3, 'Y');


-- Verify and Embed

SELECT DOMAIN, COUNT(*) AS CHUNKS FROM ENTERPRISE_CONTEXT GROUP BY DOMAIN ORDER BY DOMAIN;

UPDATE ENTERPRISE_CONTEXT
SET CHUNK_VECTOR = TO_REAL_VECTOR(
    VECTOR_EMBEDDING(CHUNK_TEXT, 'DOCUMENT', 'SAP_NEB.20240715')
)
WHERE CHUNK_VECTOR IS NULL;

SELECT COUNT(*) AS EMBEDDED FROM ENTERPRISE_CONTEXT WHERE CHUNK_VECTOR IS NOT NULL;

CREATE HNSW VECTOR INDEX IDX_ENTERPRISE_CONTEXT_VECTOR
ON ENTERPRISE_CONTEXT(CHUNK_VECTOR)
SIMILARITY FUNCTION COSINE;


-- Cosine Similarity Queries

-- FQ-1
SELECT TOP 5 EC.ID, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, EC.ENTITY, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('What is the company''s foreign exchange hedging policy?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' ORDER BY SCORE DESC;

-- FQ-2
SELECT TOP 5 EC.ID, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, EC.ENTITY, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('What is the CET1 ratio?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' ORDER BY SCORE DESC;

-- FQ-3
SELECT TOP 5 EC.ID, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, EC.ENTITY, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('What was Q3 2025 revenue by segment?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' ORDER BY SCORE DESC;

-- FQ-4
SELECT TOP 5 EC.ID, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, EC.ENTITY, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('What are the stop-loss limits per trading desk?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' ORDER BY SCORE DESC;

-- FQ-5
SELECT TOP 5 EC.ID, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, EC.ENTITY, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('How does the company manage counterparty credit risk?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' ORDER BY SCORE DESC;

-- HQ-1
SELECT TOP 5 EC.ID, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, EC.ENTITY, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('What is the salary range for a Senior Manager?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' ORDER BY SCORE DESC;

-- HQ-2
SELECT TOP 5 EC.ID, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, EC.ENTITY, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('What is the bonus structure for Senior Managers in Investment Banking?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' ORDER BY SCORE DESC;

-- HQ-3
SELECT TOP 5 EC.ID, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, EC.ENTITY, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('What parental leave benefits does the company offer?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' ORDER BY SCORE DESC;

-- HQ-4
SELECT TOP 5 EC.ID, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, EC.ENTITY, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('What are the clawback provisions for deferred compensation?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' ORDER BY SCORE DESC;

-- HQ-5
SELECT TOP 5 EC.ID, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, EC.ENTITY, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('How does the company evaluate employee performance?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' ORDER BY SCORE DESC;

-- LQ-1 filtered
SELECT TOP 5 EC.ID, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, EC.VERSION, EC.IS_ACTIVE, EC.ENTITY, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('What is the current data protection policy on cross-border data transfers?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' ORDER BY SCORE DESC;

-- LQ-1 unfiltered (version currency test)
SELECT TOP 5 EC.ID, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, EC.VERSION, EC.IS_ACTIVE, EC.ENTITY, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('What is the current data protection policy on cross-border data transfers?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC ORDER BY SCORE DESC;

-- LQ-2
SELECT TOP 5 EC.ID, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, EC.ENTITY, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('What does Article 12 require for high-risk clients?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' ORDER BY SCORE DESC;

-- LQ-3
SELECT TOP 5 EC.ID, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, EC.VERSION, EC.ENTITY, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('What are the AI governance requirements?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' ORDER BY SCORE DESC;

-- LQ-4
SELECT TOP 5 EC.ID, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, EC.ENTITY, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('What is the threshold for filing a Suspicious Activity Report?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' ORDER BY SCORE DESC;

-- LQ-5 unfiltered (needs both versions for comparison)
SELECT TOP 5 EC.ID, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, EC.VERSION, EC.IS_ACTIVE, EC.ENTITY, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('How has the data retention policy changed from the previous version?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC ORDER BY SCORE DESC;

-- PQ-1
SELECT TOP 5 EC.ID, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, EC.ENTITY, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('What is the uptime SLA for our cloud infrastructure provider?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' ORDER BY SCORE DESC;

-- PQ-2
SELECT TOP 5 EC.ID, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, EC.ENTITY, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('What approval is needed for a USD 300,000 technology purchase?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' ORDER BY SCORE DESC;

-- PQ-3
SELECT TOP 5 EC.ID, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, EC.ENTITY, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('How do we evaluate cloud vendors?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' ORDER BY SCORE DESC;

-- PQ-4
SELECT TOP 5 EC.ID, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, EC.FILING_TYPE, EC.ENTITY, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('Where must our restricted data be stored under the cloud contract?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' ORDER BY SCORE DESC;

-- PQ-5
SELECT TOP 5 EC.ID, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, EC.ENTITY, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('What due diligence is required before engaging a new technology vendor?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' ORDER BY SCORE DESC;


-- L2 Distance Queries

-- L2 FQ-2
SELECT TOP 5 EC.ID, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW,
    L2DISTANCE(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('What is the CET1 ratio?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' ORDER BY SCORE ASC;

-- L2 HQ-1
SELECT TOP 5 EC.ID, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, EC.ENTITY, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW,
    L2DISTANCE(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('What is the salary range for a Senior Manager?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' ORDER BY SCORE ASC;

-- L2 LQ-1
SELECT TOP 5 EC.ID, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, EC.VERSION, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW,
    L2DISTANCE(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('What is the current data protection policy on cross-border data transfers?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' ORDER BY SCORE ASC;


-- BM25 Setup

CREATE COLUMN TABLE PAL_TFIDF_DATA (
    ID NVARCHAR(100),
    CONTENT NVARCHAR(5000),
    CATEGORY NVARCHAR(100)
);

INSERT INTO PAL_TFIDF_DATA (ID, CONTENT, CATEGORY)
SELECT TO_NVARCHAR(ID), TO_NVARCHAR(CHUNK_TEXT), DOMAIN
FROM ENTERPRISE_CONTEXT WHERE IS_ACTIVE = 'Y';

CREATE COLUMN TABLE PAL_TM_TERM (
    TM_TERMS NVARCHAR(1000),
    TM_TERM_FREQUENCY INTEGER,
    TM_IDF_FREQUENCY INTEGER,
    TF_VALUE DOUBLE,
    IDF_VALUE DOUBLE
);

CREATE COLUMN TABLE PAL_TM_DOC_TERM_FREQ (
    ID NVARCHAR(100),
    TM_TERMS NVARCHAR(1000),
    TM_TERM_FREQUENCY INTEGER
);

CREATE COLUMN TABLE PAL_TM_CATE (
    ID NVARCHAR(100),
    CATEGORY NVARCHAR(100)
);

CREATE COLUMN TABLE PAL_TF_PARAMS (
    PARAM_NAME NVARCHAR(256),
    INT_VALUE INTEGER,
    DOUBLE_VALUE DOUBLE,
    STRING_VALUE NVARCHAR(1000)
);

DO BEGIN
    lt_data = SELECT * FROM PAL_TFIDF_DATA;
    lt_param = SELECT * FROM PAL_TF_PARAMS;
    CALL _SYS_AFL.PAL_TF_ANALYSIS(:lt_data, :lt_param, lt_tm_term, lt_tm_doc_term_freq, lt_cate);
    INSERT INTO PAL_TM_TERM SELECT * FROM :lt_tm_term;
    INSERT INTO PAL_TM_DOC_TERM_FREQ SELECT * FROM :lt_tm_doc_term_freq;
    INSERT INTO PAL_TM_CATE SELECT * FROM :lt_cate;
END;

CREATE COLUMN TABLE PAL_BM25_KEYWORDS (
    ID INTEGER,
    KEYWORDS NVARCHAR(5000)
);

CREATE COLUMN TABLE PAL_BM25_PARAMS (
    PARAM_NAME NVARCHAR(256),
    INT_VALUE INTEGER,
    DOUBLE_VALUE DOUBLE,
    STRING_VALUE NVARCHAR(1000)
);

INSERT INTO PAL_BM25_PARAMS VALUES ('NUM_BEST_MATCHES', 5, NULL, NULL);

CREATE COLUMN TABLE PAL_BM25_RESULT (
    PREDICT_ID INTEGER,
    "INDEX" INTEGER,
    BEST_MATCH NVARCHAR(1000),
    SCORE DOUBLE
);

CREATE COLUMN TABLE PAL_BM25_EXTRA (
    ID INTEGER,
    CONTENT NVARCHAR(1000)
);


-- BM25 Queries
-- Pattern: truncate, insert query, call, select results

-- BM25 FQ-1
TRUNCATE TABLE PAL_BM25_KEYWORDS; TRUNCATE TABLE PAL_BM25_RESULT; TRUNCATE TABLE PAL_BM25_EXTRA;
INSERT INTO PAL_BM25_KEYWORDS VALUES (1, 'What is the company''s foreign exchange hedging policy?');
DO BEGIN lt_data = SELECT * FROM PAL_BM25_KEYWORDS; lt_param = SELECT * FROM PAL_BM25_PARAMS; lt_tm_term = SELECT * FROM PAL_TM_TERM; lt_tm_doc_term_freq = SELECT * FROM PAL_TM_DOC_TERM_FREQ; lt_cate = SELECT * FROM PAL_TM_CATE; CALL _SYS_AFL.PAL_SEARCH_DOCS_BY_KEYWORDS(:lt_tm_term, :lt_tm_doc_term_freq, :lt_cate, :lt_data, :lt_param, lt_result, lt_extra); INSERT INTO PAL_BM25_RESULT SELECT * FROM :lt_result; END;
SELECT R.SCORE, R.BEST_MATCH, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW FROM PAL_BM25_RESULT R INNER JOIN ENTERPRISE_CONTEXT EC ON TO_NVARCHAR(EC.ID) = R.BEST_MATCH ORDER BY R.SCORE DESC;

-- BM25 FQ-2
TRUNCATE TABLE PAL_BM25_KEYWORDS; TRUNCATE TABLE PAL_BM25_RESULT; TRUNCATE TABLE PAL_BM25_EXTRA;
INSERT INTO PAL_BM25_KEYWORDS VALUES (1, 'What is the CET1 ratio?');
DO BEGIN lt_data = SELECT * FROM PAL_BM25_KEYWORDS; lt_param = SELECT * FROM PAL_BM25_PARAMS; lt_tm_term = SELECT * FROM PAL_TM_TERM; lt_tm_doc_term_freq = SELECT * FROM PAL_TM_DOC_TERM_FREQ; lt_cate = SELECT * FROM PAL_TM_CATE; CALL _SYS_AFL.PAL_SEARCH_DOCS_BY_KEYWORDS(:lt_tm_term, :lt_tm_doc_term_freq, :lt_cate, :lt_data, :lt_param, lt_result, lt_extra); INSERT INTO PAL_BM25_RESULT SELECT * FROM :lt_result; END;
SELECT R.SCORE, R.BEST_MATCH, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW FROM PAL_BM25_RESULT R INNER JOIN ENTERPRISE_CONTEXT EC ON TO_NVARCHAR(EC.ID) = R.BEST_MATCH ORDER BY R.SCORE DESC;

-- BM25 FQ-3
TRUNCATE TABLE PAL_BM25_KEYWORDS; TRUNCATE TABLE PAL_BM25_RESULT; TRUNCATE TABLE PAL_BM25_EXTRA;
INSERT INTO PAL_BM25_KEYWORDS VALUES (1, 'What was Q3 2025 revenue by segment?');
DO BEGIN lt_data = SELECT * FROM PAL_BM25_KEYWORDS; lt_param = SELECT * FROM PAL_BM25_PARAMS; lt_tm_term = SELECT * FROM PAL_TM_TERM; lt_tm_doc_term_freq = SELECT * FROM PAL_TM_DOC_TERM_FREQ; lt_cate = SELECT * FROM PAL_TM_CATE; CALL _SYS_AFL.PAL_SEARCH_DOCS_BY_KEYWORDS(:lt_tm_term, :lt_tm_doc_term_freq, :lt_cate, :lt_data, :lt_param, lt_result, lt_extra); INSERT INTO PAL_BM25_RESULT SELECT * FROM :lt_result; END;
SELECT R.SCORE, R.BEST_MATCH, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW FROM PAL_BM25_RESULT R INNER JOIN ENTERPRISE_CONTEXT EC ON TO_NVARCHAR(EC.ID) = R.BEST_MATCH ORDER BY R.SCORE DESC;

-- BM25 FQ-4
TRUNCATE TABLE PAL_BM25_KEYWORDS; TRUNCATE TABLE PAL_BM25_RESULT; TRUNCATE TABLE PAL_BM25_EXTRA;
INSERT INTO PAL_BM25_KEYWORDS VALUES (1, 'What are the stop-loss limits per trading desk?');
DO BEGIN lt_data = SELECT * FROM PAL_BM25_KEYWORDS; lt_param = SELECT * FROM PAL_BM25_PARAMS; lt_tm_term = SELECT * FROM PAL_TM_TERM; lt_tm_doc_term_freq = SELECT * FROM PAL_TM_DOC_TERM_FREQ; lt_cate = SELECT * FROM PAL_TM_CATE; CALL _SYS_AFL.PAL_SEARCH_DOCS_BY_KEYWORDS(:lt_tm_term, :lt_tm_doc_term_freq, :lt_cate, :lt_data, :lt_param, lt_result, lt_extra); INSERT INTO PAL_BM25_RESULT SELECT * FROM :lt_result; END;
SELECT R.SCORE, R.BEST_MATCH, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW FROM PAL_BM25_RESULT R INNER JOIN ENTERPRISE_CONTEXT EC ON TO_NVARCHAR(EC.ID) = R.BEST_MATCH ORDER BY R.SCORE DESC;

-- BM25 FQ-5
TRUNCATE TABLE PAL_BM25_KEYWORDS; TRUNCATE TABLE PAL_BM25_RESULT; TRUNCATE TABLE PAL_BM25_EXTRA;
INSERT INTO PAL_BM25_KEYWORDS VALUES (1, 'How does the company manage counterparty credit risk?');
DO BEGIN lt_data = SELECT * FROM PAL_BM25_KEYWORDS; lt_param = SELECT * FROM PAL_BM25_PARAMS; lt_tm_term = SELECT * FROM PAL_TM_TERM; lt_tm_doc_term_freq = SELECT * FROM PAL_TM_DOC_TERM_FREQ; lt_cate = SELECT * FROM PAL_TM_CATE; CALL _SYS_AFL.PAL_SEARCH_DOCS_BY_KEYWORDS(:lt_tm_term, :lt_tm_doc_term_freq, :lt_cate, :lt_data, :lt_param, lt_result, lt_extra); INSERT INTO PAL_BM25_RESULT SELECT * FROM :lt_result; END;
SELECT R.SCORE, R.BEST_MATCH, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW FROM PAL_BM25_RESULT R INNER JOIN ENTERPRISE_CONTEXT EC ON TO_NVARCHAR(EC.ID) = R.BEST_MATCH ORDER BY R.SCORE DESC;

-- BM25 HQ-1
TRUNCATE TABLE PAL_BM25_KEYWORDS; TRUNCATE TABLE PAL_BM25_RESULT; TRUNCATE TABLE PAL_BM25_EXTRA;
INSERT INTO PAL_BM25_KEYWORDS VALUES (1, 'What is the salary range for a Senior Manager?');
DO BEGIN lt_data = SELECT * FROM PAL_BM25_KEYWORDS; lt_param = SELECT * FROM PAL_BM25_PARAMS; lt_tm_term = SELECT * FROM PAL_TM_TERM; lt_tm_doc_term_freq = SELECT * FROM PAL_TM_DOC_TERM_FREQ; lt_cate = SELECT * FROM PAL_TM_CATE; CALL _SYS_AFL.PAL_SEARCH_DOCS_BY_KEYWORDS(:lt_tm_term, :lt_tm_doc_term_freq, :lt_cate, :lt_data, :lt_param, lt_result, lt_extra); INSERT INTO PAL_BM25_RESULT SELECT * FROM :lt_result; END;
SELECT R.SCORE, R.BEST_MATCH, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW FROM PAL_BM25_RESULT R INNER JOIN ENTERPRISE_CONTEXT EC ON TO_NVARCHAR(EC.ID) = R.BEST_MATCH ORDER BY R.SCORE DESC;

-- BM25 HQ-2
TRUNCATE TABLE PAL_BM25_KEYWORDS; TRUNCATE TABLE PAL_BM25_RESULT; TRUNCATE TABLE PAL_BM25_EXTRA;
INSERT INTO PAL_BM25_KEYWORDS VALUES (1, 'What is the bonus structure for Senior Managers in Investment Banking?');
DO BEGIN lt_data = SELECT * FROM PAL_BM25_KEYWORDS; lt_param = SELECT * FROM PAL_BM25_PARAMS; lt_tm_term = SELECT * FROM PAL_TM_TERM; lt_tm_doc_term_freq = SELECT * FROM PAL_TM_DOC_TERM_FREQ; lt_cate = SELECT * FROM PAL_TM_CATE; CALL _SYS_AFL.PAL_SEARCH_DOCS_BY_KEYWORDS(:lt_tm_term, :lt_tm_doc_term_freq, :lt_cate, :lt_data, :lt_param, lt_result, lt_extra); INSERT INTO PAL_BM25_RESULT SELECT * FROM :lt_result; END;
SELECT R.SCORE, R.BEST_MATCH, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW FROM PAL_BM25_RESULT R INNER JOIN ENTERPRISE_CONTEXT EC ON TO_NVARCHAR(EC.ID) = R.BEST_MATCH ORDER BY R.SCORE DESC;

-- BM25 HQ-3
TRUNCATE TABLE PAL_BM25_KEYWORDS; TRUNCATE TABLE PAL_BM25_RESULT; TRUNCATE TABLE PAL_BM25_EXTRA;
INSERT INTO PAL_BM25_KEYWORDS VALUES (1, 'What parental leave benefits does the company offer?');
DO BEGIN lt_data = SELECT * FROM PAL_BM25_KEYWORDS; lt_param = SELECT * FROM PAL_BM25_PARAMS; lt_tm_term = SELECT * FROM PAL_TM_TERM; lt_tm_doc_term_freq = SELECT * FROM PAL_TM_DOC_TERM_FREQ; lt_cate = SELECT * FROM PAL_TM_CATE; CALL _SYS_AFL.PAL_SEARCH_DOCS_BY_KEYWORDS(:lt_tm_term, :lt_tm_doc_term_freq, :lt_cate, :lt_data, :lt_param, lt_result, lt_extra); INSERT INTO PAL_BM25_RESULT SELECT * FROM :lt_result; END;
SELECT R.SCORE, R.BEST_MATCH, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW FROM PAL_BM25_RESULT R INNER JOIN ENTERPRISE_CONTEXT EC ON TO_NVARCHAR(EC.ID) = R.BEST_MATCH ORDER BY R.SCORE DESC;

-- BM25 HQ-4
TRUNCATE TABLE PAL_BM25_KEYWORDS; TRUNCATE TABLE PAL_BM25_RESULT; TRUNCATE TABLE PAL_BM25_EXTRA;
INSERT INTO PAL_BM25_KEYWORDS VALUES (1, 'What are the clawback provisions for deferred compensation?');
DO BEGIN lt_data = SELECT * FROM PAL_BM25_KEYWORDS; lt_param = SELECT * FROM PAL_BM25_PARAMS; lt_tm_term = SELECT * FROM PAL_TM_TERM; lt_tm_doc_term_freq = SELECT * FROM PAL_TM_DOC_TERM_FREQ; lt_cate = SELECT * FROM PAL_TM_CATE; CALL _SYS_AFL.PAL_SEARCH_DOCS_BY_KEYWORDS(:lt_tm_term, :lt_tm_doc_term_freq, :lt_cate, :lt_data, :lt_param, lt_result, lt_extra); INSERT INTO PAL_BM25_RESULT SELECT * FROM :lt_result; END;
SELECT R.SCORE, R.BEST_MATCH, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW FROM PAL_BM25_RESULT R INNER JOIN ENTERPRISE_CONTEXT EC ON TO_NVARCHAR(EC.ID) = R.BEST_MATCH ORDER BY R.SCORE DESC;

-- BM25 HQ-5
TRUNCATE TABLE PAL_BM25_KEYWORDS; TRUNCATE TABLE PAL_BM25_RESULT; TRUNCATE TABLE PAL_BM25_EXTRA;
INSERT INTO PAL_BM25_KEYWORDS VALUES (1, 'How does the company evaluate employee performance?');
DO BEGIN lt_data = SELECT * FROM PAL_BM25_KEYWORDS; lt_param = SELECT * FROM PAL_BM25_PARAMS; lt_tm_term = SELECT * FROM PAL_TM_TERM; lt_tm_doc_term_freq = SELECT * FROM PAL_TM_DOC_TERM_FREQ; lt_cate = SELECT * FROM PAL_TM_CATE; CALL _SYS_AFL.PAL_SEARCH_DOCS_BY_KEYWORDS(:lt_tm_term, :lt_tm_doc_term_freq, :lt_cate, :lt_data, :lt_param, lt_result, lt_extra); INSERT INTO PAL_BM25_RESULT SELECT * FROM :lt_result; END;
SELECT R.SCORE, R.BEST_MATCH, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW FROM PAL_BM25_RESULT R INNER JOIN ENTERPRISE_CONTEXT EC ON TO_NVARCHAR(EC.ID) = R.BEST_MATCH ORDER BY R.SCORE DESC;

-- BM25 LQ-1
TRUNCATE TABLE PAL_BM25_KEYWORDS; TRUNCATE TABLE PAL_BM25_RESULT; TRUNCATE TABLE PAL_BM25_EXTRA;
INSERT INTO PAL_BM25_KEYWORDS VALUES (1, 'What is the current data protection policy on cross-border data transfers?');
DO BEGIN lt_data = SELECT * FROM PAL_BM25_KEYWORDS; lt_param = SELECT * FROM PAL_BM25_PARAMS; lt_tm_term = SELECT * FROM PAL_TM_TERM; lt_tm_doc_term_freq = SELECT * FROM PAL_TM_DOC_TERM_FREQ; lt_cate = SELECT * FROM PAL_TM_CATE; CALL _SYS_AFL.PAL_SEARCH_DOCS_BY_KEYWORDS(:lt_tm_term, :lt_tm_doc_term_freq, :lt_cate, :lt_data, :lt_param, lt_result, lt_extra); INSERT INTO PAL_BM25_RESULT SELECT * FROM :lt_result; END;
SELECT R.SCORE, R.BEST_MATCH, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW FROM PAL_BM25_RESULT R INNER JOIN ENTERPRISE_CONTEXT EC ON TO_NVARCHAR(EC.ID) = R.BEST_MATCH ORDER BY R.SCORE DESC;

-- BM25 LQ-2
TRUNCATE TABLE PAL_BM25_KEYWORDS; TRUNCATE TABLE PAL_BM25_RESULT; TRUNCATE TABLE PAL_BM25_EXTRA;
INSERT INTO PAL_BM25_KEYWORDS VALUES (1, 'What does Article 12 require for high-risk clients?');
DO BEGIN lt_data = SELECT * FROM PAL_BM25_KEYWORDS; lt_param = SELECT * FROM PAL_BM25_PARAMS; lt_tm_term = SELECT * FROM PAL_TM_TERM; lt_tm_doc_term_freq = SELECT * FROM PAL_TM_DOC_TERM_FREQ; lt_cate = SELECT * FROM PAL_TM_CATE; CALL _SYS_AFL.PAL_SEARCH_DOCS_BY_KEYWORDS(:lt_tm_term, :lt_tm_doc_term_freq, :lt_cate, :lt_data, :lt_param, lt_result, lt_extra); INSERT INTO PAL_BM25_RESULT SELECT * FROM :lt_result; END;
SELECT R.SCORE, R.BEST_MATCH, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW FROM PAL_BM25_RESULT R INNER JOIN ENTERPRISE_CONTEXT EC ON TO_NVARCHAR(EC.ID) = R.BEST_MATCH ORDER BY R.SCORE DESC;

-- BM25 LQ-3
TRUNCATE TABLE PAL_BM25_KEYWORDS; TRUNCATE TABLE PAL_BM25_RESULT; TRUNCATE TABLE PAL_BM25_EXTRA;
INSERT INTO PAL_BM25_KEYWORDS VALUES (1, 'What are the AI governance requirements?');
DO BEGIN lt_data = SELECT * FROM PAL_BM25_KEYWORDS; lt_param = SELECT * FROM PAL_BM25_PARAMS; lt_tm_term = SELECT * FROM PAL_TM_TERM; lt_tm_doc_term_freq = SELECT * FROM PAL_TM_DOC_TERM_FREQ; lt_cate = SELECT * FROM PAL_TM_CATE; CALL _SYS_AFL.PAL_SEARCH_DOCS_BY_KEYWORDS(:lt_tm_term, :lt_tm_doc_term_freq, :lt_cate, :lt_data, :lt_param, lt_result, lt_extra); INSERT INTO PAL_BM25_RESULT SELECT * FROM :lt_result; END;
SELECT R.SCORE, R.BEST_MATCH, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW FROM PAL_BM25_RESULT R INNER JOIN ENTERPRISE_CONTEXT EC ON TO_NVARCHAR(EC.ID) = R.BEST_MATCH ORDER BY R.SCORE DESC;

-- BM25 LQ-4
TRUNCATE TABLE PAL_BM25_KEYWORDS; TRUNCATE TABLE PAL_BM25_RESULT; TRUNCATE TABLE PAL_BM25_EXTRA;
INSERT INTO PAL_BM25_KEYWORDS VALUES (1, 'What is the threshold for filing a Suspicious Activity Report?');
DO BEGIN lt_data = SELECT * FROM PAL_BM25_KEYWORDS; lt_param = SELECT * FROM PAL_BM25_PARAMS; lt_tm_term = SELECT * FROM PAL_TM_TERM; lt_tm_doc_term_freq = SELECT * FROM PAL_TM_DOC_TERM_FREQ; lt_cate = SELECT * FROM PAL_TM_CATE; CALL _SYS_AFL.PAL_SEARCH_DOCS_BY_KEYWORDS(:lt_tm_term, :lt_tm_doc_term_freq, :lt_cate, :lt_data, :lt_param, lt_result, lt_extra); INSERT INTO PAL_BM25_RESULT SELECT * FROM :lt_result; END;
SELECT R.SCORE, R.BEST_MATCH, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW FROM PAL_BM25_RESULT R INNER JOIN ENTERPRISE_CONTEXT EC ON TO_NVARCHAR(EC.ID) = R.BEST_MATCH ORDER BY R.SCORE DESC;

-- BM25 PQ-1
TRUNCATE TABLE PAL_BM25_KEYWORDS; TRUNCATE TABLE PAL_BM25_RESULT; TRUNCATE TABLE PAL_BM25_EXTRA;
INSERT INTO PAL_BM25_KEYWORDS VALUES (1, 'What is the uptime SLA for our cloud infrastructure provider?');
DO BEGIN lt_data = SELECT * FROM PAL_BM25_KEYWORDS; lt_param = SELECT * FROM PAL_BM25_PARAMS; lt_tm_term = SELECT * FROM PAL_TM_TERM; lt_tm_doc_term_freq = SELECT * FROM PAL_TM_DOC_TERM_FREQ; lt_cate = SELECT * FROM PAL_TM_CATE; CALL _SYS_AFL.PAL_SEARCH_DOCS_BY_KEYWORDS(:lt_tm_term, :lt_tm_doc_term_freq, :lt_cate, :lt_data, :lt_param, lt_result, lt_extra); INSERT INTO PAL_BM25_RESULT SELECT * FROM :lt_result; END;
SELECT R.SCORE, R.BEST_MATCH, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW FROM PAL_BM25_RESULT R INNER JOIN ENTERPRISE_CONTEXT EC ON TO_NVARCHAR(EC.ID) = R.BEST_MATCH ORDER BY R.SCORE DESC;

-- BM25 PQ-2
TRUNCATE TABLE PAL_BM25_KEYWORDS; TRUNCATE TABLE PAL_BM25_RESULT; TRUNCATE TABLE PAL_BM25_EXTRA;
INSERT INTO PAL_BM25_KEYWORDS VALUES (1, 'What approval is needed for a USD 300,000 technology purchase?');
DO BEGIN lt_data = SELECT * FROM PAL_BM25_KEYWORDS; lt_param = SELECT * FROM PAL_BM25_PARAMS; lt_tm_term = SELECT * FROM PAL_TM_TERM; lt_tm_doc_term_freq = SELECT * FROM PAL_TM_DOC_TERM_FREQ; lt_cate = SELECT * FROM PAL_TM_CATE; CALL _SYS_AFL.PAL_SEARCH_DOCS_BY_KEYWORDS(:lt_tm_term, :lt_tm_doc_term_freq, :lt_cate, :lt_data, :lt_param, lt_result, lt_extra); INSERT INTO PAL_BM25_RESULT SELECT * FROM :lt_result; END;
SELECT R.SCORE, R.BEST_MATCH, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW FROM PAL_BM25_RESULT R INNER JOIN ENTERPRISE_CONTEXT EC ON TO_NVARCHAR(EC.ID) = R.BEST_MATCH ORDER BY R.SCORE DESC;

-- BM25 PQ-3
TRUNCATE TABLE PAL_BM25_KEYWORDS; TRUNCATE TABLE PAL_BM25_RESULT; TRUNCATE TABLE PAL_BM25_EXTRA;
INSERT INTO PAL_BM25_KEYWORDS VALUES (1, 'How do we evaluate cloud vendors?');
DO BEGIN lt_data = SELECT * FROM PAL_BM25_KEYWORDS; lt_param = SELECT * FROM PAL_BM25_PARAMS; lt_tm_term = SELECT * FROM PAL_TM_TERM; lt_tm_doc_term_freq = SELECT * FROM PAL_TM_DOC_TERM_FREQ; lt_cate = SELECT * FROM PAL_TM_CATE; CALL _SYS_AFL.PAL_SEARCH_DOCS_BY_KEYWORDS(:lt_tm_term, :lt_tm_doc_term_freq, :lt_cate, :lt_data, :lt_param, lt_result, lt_extra); INSERT INTO PAL_BM25_RESULT SELECT * FROM :lt_result; END;
SELECT R.SCORE, R.BEST_MATCH, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW FROM PAL_BM25_RESULT R INNER JOIN ENTERPRISE_CONTEXT EC ON TO_NVARCHAR(EC.ID) = R.BEST_MATCH ORDER BY R.SCORE DESC;

-- BM25 PQ-4
TRUNCATE TABLE PAL_BM25_KEYWORDS; TRUNCATE TABLE PAL_BM25_RESULT; TRUNCATE TABLE PAL_BM25_EXTRA;
INSERT INTO PAL_BM25_KEYWORDS VALUES (1, 'Where must our restricted data be stored under the cloud contract?');
DO BEGIN lt_data = SELECT * FROM PAL_BM25_KEYWORDS; lt_param = SELECT * FROM PAL_BM25_PARAMS; lt_tm_term = SELECT * FROM PAL_TM_TERM; lt_tm_doc_term_freq = SELECT * FROM PAL_TM_DOC_TERM_FREQ; lt_cate = SELECT * FROM PAL_TM_CATE; CALL _SYS_AFL.PAL_SEARCH_DOCS_BY_KEYWORDS(:lt_tm_term, :lt_tm_doc_term_freq, :lt_cate, :lt_data, :lt_param, lt_result, lt_extra); INSERT INTO PAL_BM25_RESULT SELECT * FROM :lt_result; END;
SELECT R.SCORE, R.BEST_MATCH, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW FROM PAL_BM25_RESULT R INNER JOIN ENTERPRISE_CONTEXT EC ON TO_NVARCHAR(EC.ID) = R.BEST_MATCH ORDER BY R.SCORE DESC;

-- BM25 PQ-5
TRUNCATE TABLE PAL_BM25_KEYWORDS; TRUNCATE TABLE PAL_BM25_RESULT; TRUNCATE TABLE PAL_BM25_EXTRA;
INSERT INTO PAL_BM25_KEYWORDS VALUES (1, 'What due diligence is required before engaging a new technology vendor?');
DO BEGIN lt_data = SELECT * FROM PAL_BM25_KEYWORDS; lt_param = SELECT * FROM PAL_BM25_PARAMS; lt_tm_term = SELECT * FROM PAL_TM_TERM; lt_tm_doc_term_freq = SELECT * FROM PAL_TM_DOC_TERM_FREQ; lt_cate = SELECT * FROM PAL_TM_CATE; CALL _SYS_AFL.PAL_SEARCH_DOCS_BY_KEYWORDS(:lt_tm_term, :lt_tm_doc_term_freq, :lt_cate, :lt_data, :lt_param, lt_result, lt_extra); INSERT INTO PAL_BM25_RESULT SELECT * FROM :lt_result; END;
SELECT R.SCORE, R.BEST_MATCH, EC.DOMAIN, EC.DOC_ID, EC.CHUNK_ID, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW FROM PAL_BM25_RESULT R INNER JOIN ENTERPRISE_CONTEXT EC ON TO_NVARCHAR(EC.ID) = R.BEST_MATCH ORDER BY R.SCORE DESC;


-- Out-of-Scope Queries (Confidence Calibration)

SELECT TOP 1 'OOS-1' AS QID, EC.DOC_ID, LEFT(EC.CHUNK_TEXT, 80) AS NEAREST_TRAP,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('What is the company''s environmental sustainability strategy?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' ORDER BY SCORE DESC;

SELECT TOP 1 'OOS-2' AS QID, EC.DOC_ID, LEFT(EC.CHUNK_TEXT, 80) AS NEAREST_TRAP,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('What is the office dress code policy?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' ORDER BY SCORE DESC;

SELECT TOP 1 'OOS-3' AS QID, EC.DOC_ID, LEFT(EC.CHUNK_TEXT, 80) AS NEAREST_TRAP,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('How do we handle customer complaints?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' ORDER BY SCORE DESC;

SELECT TOP 1 'OOS-4' AS QID, EC.DOC_ID, LEFT(EC.CHUNK_TEXT, 80) AS NEAREST_TRAP,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('What are the company''s manufacturing processes?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' ORDER BY SCORE DESC;

SELECT TOP 1 'OOS-5' AS QID, EC.DOC_ID, LEFT(EC.CHUNK_TEXT, 80) AS NEAREST_TRAP,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('What is the company''s policy on remote work?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' ORDER BY SCORE DESC;


-- Metadata Filtered Queries

-- HQ-2 with ENTITY filter
SELECT TOP 5 EC.DOC_ID, EC.ENTITY, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('What is the bonus structure for Senior Managers in Investment Banking?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' AND EC.ENTITY = 'Investment Banking Division' ORDER BY SCORE DESC;

-- PQ-4 with DOMAIN filter
SELECT TOP 5 EC.DOMAIN, EC.DOC_ID, EC.FILING_TYPE, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('Where must our restricted data be stored under the cloud contract?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' AND EC.DOMAIN = 'PROCUREMENT' ORDER BY SCORE DESC;

-- PQ-4 with FILING_TYPE filter
SELECT TOP 5 EC.DOMAIN, EC.DOC_ID, EC.FILING_TYPE, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('Where must our restricted data be stored under the cloud contract?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' AND EC.FILING_TYPE = 'CONTRACT' ORDER BY SCORE DESC;

-- PQ-5 with DOMAIN filter
SELECT TOP 5 EC.DOMAIN, EC.DOC_ID, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('What due diligence is required before engaging a new technology vendor?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' AND EC.DOMAIN = 'PROCUREMENT' ORDER BY SCORE DESC;

-- LQ-5 with IS_ACTIVE filter (demonstrates over-filtering)
SELECT TOP 5 EC.DOC_ID, EC.VERSION, EC.IS_ACTIVE, LEFT(EC.CHUNK_TEXT, 120) AS PREVIEW,
    COSINE_SIMILARITY(EC.CHUNK_VECTOR, TO_REAL_VECTOR(VECTOR_EMBEDDING('How has the data retention policy changed from the previous version?', 'QUERY', 'SAP_NEB.20240715'))) AS SCORE
FROM ENTERPRISE_CONTEXT EC WHERE EC.IS_ACTIVE = 'Y' ORDER BY SCORE DESC;
