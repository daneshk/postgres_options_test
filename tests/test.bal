import ballerina/sql;
import ballerina/test;
import ballerinax/postgresql;

postgresql:Client testDB = check new(
    host = "localhost",
    port = 5432,
    database = "testDB",
    username = "postgres",
    password = "postgres",
    options = {
        preparedStatementCacheQueries: 0,
        preparedStatementCacheSize: 0,
        preparedStatementThreshold: 0
    });
    
@test:Config {}
public function testPostgresOptions() returns sql:Error? {
    
    _ = check testDB->execute(`CREATE TABLE IF NOT EXISTS test_table (id INT, name TEXT)`);

    _ = check testDB->execute(`INSERT INTO test_table VALUES (1, 'John')`);
    _ = check testDB->execute(`INSERT INTO test_table VALUES (2, 'Doe')`);
    _ = check testDB->execute(`INSERT INTO test_table VALUES (3, 'Jane')`);

    stream<TestTable, sql:Error?> query = testDB->query(`SELECT * FROM test_table`);

    TestTable[] results = check from TestTable t in query 
    select t;

    test:assertEquals(results.length(), 3, "Incorrect number of records returned");
}

type TestTable record {|
    int id;
    string name;
|};
