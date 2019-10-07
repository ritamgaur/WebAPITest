using Newtonsoft.Json.Linq;
using System;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Web.Http;
using System.Web.Http.Cors;
using WeightAddWebAPI.App_Code;
using WeightAddWebAPI.Models;

namespace WeightAddWebAPI.Controllers
{
    /// <summary>
    /// The 
    /// </summary>    
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class ValuesController : ApiController
    {
        #region Response constants
        const string RETURNKEY_STATUS = "status";
        const string RETURNKEY_MESSAGE = "message";
        const string RETURNKEY_Value = "Value";
        const string RETURNKEY_unit = "Unit";
        const string RETURNKEY_exception = "ExceptionMessage";
        #endregion 

        [HttpPost]
        public HttpResponseMessage Calculate([FromBody]RootObject mo)
        {
            JObject objmain = new JObject();
            try
            {
                double totalval = 0;
                if (ModelState.IsValid)
                {
                    foreach (var item in mo.items)
                    {
                        var val = Common.Conversion(item.value, item.unit.ToLower());
                        totalval += val;
                    }
                    objmain.Add(RETURNKEY_STATUS, true);
                    objmain.Add(RETURNKEY_MESSAGE, "Success");
                    objmain.Add(RETURNKEY_Value, totalval);
                    objmain.Add(RETURNKEY_unit, "mg");
                }
                else
                {
                    string invalidModelDetail = string.Empty;

                    foreach (var v in ModelState.Values)
                    {
                        if (v.Errors[0].ErrorMessage != "")
                        {
                            invalidModelDetail += v.Errors[0].ErrorMessage + " | ";
                        }
                        else if(v.Errors[0].Exception != null)
                        {
                            invalidModelDetail += v.Errors[0].Exception.Message + " | ";
                        }
                    }
                    objmain.Add(RETURNKEY_STATUS, false);
                    objmain.Add(RETURNKEY_MESSAGE, "Fail");
                    objmain.Add(RETURNKEY_exception, invalidModelDetail);
                    return Request.CreateErrorResponse(HttpStatusCode.BadRequest, objmain.ToString());
                }
            }
            catch (Exception ex)
            {
                objmain.Add(RETURNKEY_STATUS, false);
                objmain.Add(RETURNKEY_MESSAGE, "Failure");
                objmain.Add(RETURNKEY_exception, ex.Message);
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, objmain.ToString());
            }
            var response = Request.CreateResponse(HttpStatusCode.OK);
            response.Content = new StringContent(Convert.ToString(objmain), Encoding.UTF8, "application/json");
            return response;
        }
    }
}
