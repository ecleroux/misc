using System.Text.RegularExpressions;

namespace Snippets.Snips.RegexSnips;

public class DateTimeRegexSnip
{
    public void Run()
    {
        DateTime dt = CastDateTimeFromValue("20240512", @"\b(?<year>\d{4})(?<month>\d{2})(?<day>\d{2})\b");
        Console.WriteLine(dt);
    }


    /// <summary>
    /// Input dateRegex examples:
    /// input dateRegex: For CCYYMMDD regex: \b(?<year>\d{4})(?<month>\d{2})(?<day>\d{2})\b
    /// input dateRegex: For CCYY.MM.DD regex: \b(?<year>\d{4}).(?<month>\d{2}).(?<day>\d{2})\b
    /// input dateRegex: For CCYY-MM-DD HH:MM regex: \b(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2}) (?<hour>\d{2}):(?<minute>\d{2})\b
    /// input dateRegex: For CCYY-MM-DD regex: \b(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})\b
    /// input dateRegex: For DD_MM_CCYY  regex: \b(?<day>\d{2})_(?<month>\d{2})_(?<year>\d{4})\b
    /// input dateRegex: For YYMMDD regex: \b(?<year>\d{2})(?<month>\d{2})(?<day>\d{2})\b
    /// input dateRegex: For CCYY_MM_DD regex: \b(?<year>\d{4})_(?<month>\d{2})_(?<day>\d{2})\b
    /// input dateRegex: For CCYY_MM_DD HH:MM:SS regex: \b(?<year>\d{4})_(?<month>\d{2})_(?<day>\d{2}) (?<hour>\d{2}):(?<minute>\d{2}):(?<second>\d{2})\b
    /// </summary>
    /// <param name="value">date in string</param>
    /// <param name="dateRegex">regex to interpret date</param>
    /// <returns></returns>
    private DateTime CastDateTimeFromValue(string value, string dateTimeRegex)
    {
        string date, hour, minute, second;

        date = Regex.Replace(value, dateTimeRegex, "${year}-${month}-${day}", RegexOptions.None, TimeSpan.FromMilliseconds(300));
        if (date.IndexOf("-") == 2)
            date = "20" + value;

        if (dateTimeRegex.Contains("hour"))
            hour = Regex.Replace(value, dateTimeRegex, "${hour}", RegexOptions.None, TimeSpan.FromMilliseconds(300));
        else
            hour = "00";

        if (dateTimeRegex.Contains("minute"))
            minute = Regex.Replace(value, dateTimeRegex, "${minute}", RegexOptions.None, TimeSpan.FromMilliseconds(300));
        else
            minute = "00";

        if (dateTimeRegex.Contains("second"))
            second = Regex.Replace(value, dateTimeRegex, "${second}", RegexOptions.None, TimeSpan.FromMilliseconds(300));
        else
            second = "00";

        return Convert.ToDateTime($"{date} {hour}:{minute}:{second}");
    }
}
