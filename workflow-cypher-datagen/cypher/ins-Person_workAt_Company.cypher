LOAD CSV WITH HEADERS FROM 'file:///inserts/dynamic/Person_workAt_Company/' + $batch + '/' + $csv_file AS row FIELDTERMINATOR '|'
WITH
  datetime(row.creationDate) AS creationDate,
  toInteger(row.PersonId) AS personId,
  toInteger(row.CompanyId) AS companyId,
  toInteger(row.workFrom) AS workFrom
MATCH (person:Person {id: personId}), (company:Company {id: companyId})
CREATE (person)-[:WORK_AT {creationDate: creationDate, workFrom: workFrom}]->(company)
RETURN count(*)