using Newtonsoft.Json.Linq;
using System;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Web.Http;
using System.Web.Http.Cors;
using WeightAddWebAPI.App_Code;

namespace WeightAddWebAPI.Controllers
{
    /// <summary>
    /// This controller return the master values of various Units supported by the API.
    /// </summary>
    public class GetUnitsController : ApiController
    {
        #region Response constants
        const string RETURNKEY_STATUS = "status";
        const string RETURNKEY_MESSAGE = "message";
        const string RETURNKEY_Value = "Value";
        const string RETURNKEY_unit = "Unit";
        const string RETURNKEY_exception = "ExceptionMessage";
        #endregion
        [EnableCors(origins: "*", headers: "*", methods: "*")]
        [HttpGet]
        public HttpResponseMessage GetUnit()
        {

            JArray array = new JArray();
            array.Add("Kg");
            array.Add("g");
            array.Add("mg");

            JObject oUnits = new JObject();
            oUnits["units"] = array;

            //JObject obj = new JObject();
            
            /*obj.Add("unit", "KG");
            obj.Add("unit1", "G");
            obj.Add("unit2", "MG");*/

            var response = Request.CreateResponse(HttpStatusCode.OK);
            response.Content = new StringContent(oUnits.ToString(), Encoding.UTF8, "application/json");
            return response;
        }
    }
}