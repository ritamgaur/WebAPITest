using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApplication2
{
    public class RequestRootObject
    {
        public RequestRootObject() {
            items = new List<RequestItem>();

        }
        public List<RequestItem> items { get; set; }
    }

    public class RequestItem
    {
        public RequestItem(int pValue, string pUnit)
        {
            value = pValue;
            unit = pUnit;
        }
        public int value { get; set; }
        public string unit { get; set; }
    }

}