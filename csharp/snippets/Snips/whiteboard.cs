namespace Snippets;

public class whiteboard
{
    public void Run()
    {

         string connectionString = "your connection string";//dataProduct.ExtendedProperties[ExtendedPropertyKeys.SourceConnectionString].ResolveValueVariable(_configuration, dataProduct).ToString();

        string sourceLogIdColumn = "TO_CHAR(TO_TIMESTAMP(somecolumn / 1000), 'DD/MM/YYYY HH24:MI:SS')"; //dataProduct.ExtendedProperties[ExtendedPropertyKeys.SourceLogIdColumn].ToString();
        string sourceBusinessDateTimeColumn =  "date_trunc('day', somecolumn)"; //dataProduct.ExtendedProperties[ExtendedPropertyKeys.SourceBusinessDateTimeColumn].ToString();
        string sourceTable = "snapshot.\"Transactions\""; //"snapshot.transaction" //dataProduct.ExtendedProperties[ExtendedPropertyKeys.SourceTable].ToString();

        string commandText = $"SELECT {sourceLogIdColumn} AS SourceLogId, {sourceBusinessDateTimeColumn} AS BusinessDateTime FROM {sourceTable} GROUP BY {sourceLogIdColumn}, {sourceBusinessDateTimeColumn}";

        //Execute query
        //DataTable dataTable = await FillDataTableAsync(commandText, connectionString);
        //return dataTable.Rows.OfType<DataRow>().Select(dr => (dr.Field<long>("SourceLogId"), dr.Field<DateTime>("BusinessDateTime"))).ToList();
    
    }
}
