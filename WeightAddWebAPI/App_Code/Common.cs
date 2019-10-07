using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;

namespace WebApplication1.App_Code
{
    public class Common
    {
        public static double Conversion(double value, string unit)
        {
            double convalue = 0;

            if (unit == "kg")
            {
                convalue = (value * 1000000);
            }
            else if (unit == "g")
            {
                convalue = (value * 1000);
            }
            else
            {
                convalue = value;
            }
            return convalue;
        }

        public static int validatevalue(string value)
        {
            int result = 0;
            if (!Regex.IsMatch(value, @"^[+]?([0-9]+(?:[\.][0-9]*)?|\.[0-9]+)$"))
            {
                result = 1;
            }
            return result;
        }

    }
}