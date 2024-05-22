-- 1. Query Tsunami date and description
SELECT 
    dd.[Year],
	ddesc.[Tsunami Event Validity],
	ddesc.[Tsunami Cause Code],
    ddesc.[Earthquake Magnitude],
	ddesc.[Vol],
    COUNT(f.[ID Fact]) AS [Fact Count]
FROM Fact f
JOIN DimDate dd ON f.[ID Date] = dd.[ID Date]
JOIN DimDescription ddesc ON f.[ID Description] = ddesc.[ID Description]
GROUP BY 
    dd.[Year],
    ddesc.[Tsunami Event Validity],
    ddesc.[Tsunami Cause Code],
    ddesc.[Earthquake Magnitude],
	ddesc.[Vol]

-- 2. Query total number of deaths over the year
SELECT 
    dd.[Year],
    SUM(CAST(dtd.[Total Deaths] AS INT)) AS [Total Deaths],
    COUNT(f.[ID Fact]) AS [Fact Count]  
FROM Fact f
JOIN DimDate dd ON f.[ID Date] = dd.[ID Date]
JOIN DimTotalDamage dtd ON f.[ID Total Damage] = dtd.[ID Total Damage]
GROUP BY dd.[Year]
ORDER BY dd.[Year]

-- 3. Query Tsunami Intensity over the year
SELECT 
    dd.[Year],
    dl.[Tsunami Intensity],
    COUNT(f.[ID Fact]) AS [Fact Count]
FROM Fact f
JOIN DimDate dd ON f.[ID Date] = dd.[ID Date]
JOIN DimLocation dl ON f.[ID Location] = dl.[ID Location]
GROUP BY dd.[Year], dl.[Tsunami Intensity]
ORDER BY dd.[Year], dl.[Tsunami Intensity]

-- 4. Query total of deaths over the year with country

SELECT 
    dl.[Country],
    dd.[Year],
    SUM(CAST(dtd.[Total Deaths] AS INT)) AS [Total Deaths],
	COUNT(f.[ID Fact]) AS [Fact Count]
FROM Fact f
JOIN DimDate dd ON f.[ID Date] = dd.[ID Date]
JOIN DimLocation dl ON f.[ID Location] = dl.[ID Location]
JOIN DimTotalDamage dtd ON f.[ID Total Damage] = dtd.[ID Total Damage]
GROUP BY dl.[Country], dd.[Year]
ORDER BY dl.[Country], dd.[Year]

-- 5. Query total damage ($Mil) and total houses damaged with country and location

SELECT 
    dl.[Country],
	SUM(CAST(dtd.[Total Damage ($Mil)] AS FLOAT)) AS [Total Damage ($Mil)],
    SUM(CAST(dtd.[Total Houses Damaged] AS INT)) AS [Total Houses Damaged],
    COUNT(*) AS [Fact Count]
FROM Fact f
JOIN DimLocation dl ON f.[ID Location] = dl.[ID Location]
JOIN DimTotalDamage dtd ON f.[ID Total Damage] = dtd.[ID Total Damage]
GROUP BY dl.[Country], dl.[Location Name]
ORDER BY dl.[Country], dl.[Location Name];

-- 6. Query Countries where has averegare Earthquake Magnitude, Vol occur 
--over the years of tsunamis
SELECT 
    dl.[Country],
    dd.[Year],
    ddesc.[Earthquake Magnitude],
    ddesc.[Vol],
    COUNT(f.[ID Fact]) AS [Fact Count]
FROM Fact f
JOIN DimLocation dl ON f.[ID Location] = dl.[ID Location]
JOIN DimDate dd ON f.[ID Date] = dd.[ID Date]
JOIN DimDescription ddesc ON f.[ID Description] = ddesc.[ID Description]
WHERE ddesc.[Earthquake Magnitude] IS NOT NULL AND ddesc.[Vol] IS NOT NULL
GROUP BY dl.[Country], dd.[Year], ddesc.[Earthquake Magnitude], ddesc.[Vol]
ORDER BY dl.[Country], dd.[Year];


-- 7. Countries and location has tsunami over the months

SELECT 
    dl.[Country],
    dl.[Location Name],
    dd.[Year],
    dd.[Mo] AS [Month],
    COUNT(f.[ID Fact]) AS [Fact Count]
FROM Fact f
JOIN DimLocation dl ON f.[ID Location] = dl.[ID Location]
JOIN DimDate dd ON f.[ID Date] = dd.[ID Date]
GROUP BY dl.[Country], dl.[Location Name], dd.[Year], dd.[Mo]
ORDER BY dl.[Country], dl.[Location Name], dd.[Year], dd.[Mo];


-- 8. Query  all countries, location name,  Tsunami Event Validity, 
--tsunami by hr, mn, sec, day, month, year         
SELECT 
    dl.[Country],
    dl.[Location Name],
    ddesc.[Tsunami Event Validity],
    dt.[Hr],
    dt.[Mn],
    dt.[Sec],
    dd.[Dy] AS [Day],
    dd.[Mo] AS [Month],
    dd.[Year],
    COUNT(f.[ID Fact]) AS [Fact Count]
FROM Fact f
JOIN DimLocation dl ON f.[ID Location] = dl.[ID Location]
JOIN DimDescription ddesc ON f.[ID Description] = ddesc.[ID Description]
JOIN DimTime dt ON f.[ID Time] = dt.[ID Time]
JOIN DimDate dd ON f.[ID Date] = dd.[ID Date]
GROUP BY 
    dl.[Country], dl.[Location Name], ddesc.[Tsunami Event Validity],
    dt.[Hr], dt.[Mn], dt.[Sec],
    dd.[Dy], dd.[Mo], dd.[Year]
ORDER BY 
    dd.[Year], dd.[Mo], dd.[Dy], 
    dt.[Hr], dt.[Mn], dt.[Sec], 
    dl.[Country], dl.[Location Name];
