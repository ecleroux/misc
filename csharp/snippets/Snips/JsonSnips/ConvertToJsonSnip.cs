using System.Text.Json;
using System.Text.Json.Serialization;

namespace Snippets.Snips.JsonSnips;

public class ConvertToJsonSnip
{
    public void Run()
    {
        WriteModelToFile();
        WriteModelListToFileCompact();
    }

    public void WriteModelToFile()
    {
        ExampleModel exampleModel = new ExampleModel
        {
            ExampleId = 123,
            Code = "The Code",
            Name = "The Name",
            Description = "The Description",
            Info = new Dictionary<string, object>{
                {"AAA", "123"},
                {"BBB", "sda"},
                {"CCC", "poi123 123poi"},
            },
            Enabled = true,
            Secret = "DO NOT WRITE"
        };

        // Convert the object to JSON format
        string jsonString = JsonSerializer.Serialize(exampleModel, new JsonSerializerOptions { WriteIndented = true });

        // Define the path to the output file
        string filePath = "exampleModel.json";

        // Write the JSON string to the file
        File.WriteAllText(filePath, jsonString);

        // Get the full path
        string fullPath = Path.GetFullPath(filePath);

        Console.WriteLine($"ExampleModel has been written to {fullPath}");
    }

    public void WriteModelListToFileCompact()
    {
        List<Example2Model> example2List = new List<Example2Model>
        {
            new Example2Model{ Id = 1, LogId = 100, BusinessDateTime = DateTime.Now, Value1 = "AAA", Value2 = "aaaaaaa" },
            new Example2Model{ Id = 2, LogId = 200, BusinessDateTime = DateTime.Now, Value1 = "BBB", Value2 = "bbbbbbb" },
            new Example2Model{ Id = 3, LogId = 300, BusinessDateTime = DateTime.Now, Value1 = "CCC", Value2 = "ccccccc" }
        };

        // Define the path to the output file
        string filePath = "example2List.json";

        // Use a MemoryStream to first write the JSON data (So that stream can be passed on to a writter)
        using (MemoryStream memoryStream = new MemoryStream())
        using (StreamWriter streamWriter = new StreamWriter(memoryStream))
        {
            streamWriter.Write("["); // Start the JSON array

            for (int i = 0; i < example2List.Count; i++)
            {
                var model = example2List[i];
                // Serialize each object to JSON format with indentation
                string jsonString = JsonSerializer.Serialize(model);

                // Write the serialized JSON object to the stream
                streamWriter.Write(jsonString);

                // Add a comma after each object except the last one
                if (i < example2List.Count - 1)
                {
                    streamWriter.WriteLine(",");
                }
                else
                {
                    streamWriter.Write("]"); // End the JSON array
                }
            }

            // Flush the stream writer to ensure all data is written to the memory stream
            streamWriter.Flush();

            // Write the content of the memory stream to the file
            memoryStream.Position = 0;
            using (FileStream fileStream = new FileStream(filePath, FileMode.Create, FileAccess.Write))
            {
                memoryStream.CopyTo(fileStream);
            }
        }

        // Get the full path
        string fullPath = Path.GetFullPath(filePath);
        Console.WriteLine($"List of Example2Model has been written to {fullPath}");
    }
}



/// Models
public class ExampleModel
{
    public int ExampleId { get; set; }
    public string Code { get; set; }
    public string Name { get; set; }
    public string Description { get; set; }
    public Dictionary<string, object> Info { get; set; } = new Dictionary<string, object>();
    public bool Enabled { get; set; }
    
    [JsonIgnore]
    public string Secret { get; set; }
}

public class Example2Model
{
    public int Id { get; set; }
    public long LogId { get; set; }
    public DateTime? BusinessDateTime { get; set; }
    public string Value1 { get; set; }
    public string Value2 { get; set; }
}