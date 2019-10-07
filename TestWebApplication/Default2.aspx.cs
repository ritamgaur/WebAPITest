using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication2
{
    public partial class Default2 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
            if (!IsPostBack)
            {
                GetAndLoadUnitData();
            }
            
        }


        public void GetAndLoadUnitData()
        {
            //var request = (HttpWebRequest)WebRequest.Create("http://localhost:55167/api/GetUnits/GetUnit");
            var request = (HttpWebRequest)WebRequest.Create("https://unitscalcwebapi.azurewebsites.net/api/GetUnits/GetUnit");
            request.Method = "GET";
            request.ContentType = "application/json";
            var response = (HttpWebResponse)request.GetResponse();
            var responseString = new StreamReader(response.GetResponseStream()).ReadToEnd();
            var obj = JObject.Parse(responseString);

            JArray unitNames = (JArray)obj.SelectToken("units");

            DataTable _myDataTable = new DataTable();
 
            // create a DataRow using .NewRow()
            _myDataTable.Columns.AddRange(new DataColumn[1] { new DataColumn("units", typeof(string)) });


            for (int i = 0; i < unitNames.Count; i++)
            {
                _myDataTable.Rows.Add(unitNames[i]);
            }

            //Bind Data to the Dropdowns
            if (_myDataTable.Rows.Count > 0)
            {
                ddlunits.DataSource = _myDataTable;
                ddlunits.DataTextField = "units";
                ddlunits.DataValueField = "units";
                ddlunits.DataBind();

                ddlResultUnits.DataSource = _myDataTable;
                ddlResultUnits.DataTextField = "units";
                ddlResultUnits.DataValueField = "units";
                ddlResultUnits.DataBind();
            }
        }

        protected void btnadd_Click(object sender, EventArgs e)
        {
            if (!(ViewState["finaltable"] == null))
            {
                var tbl = (DataTable)ViewState["finaltable"];
                tbl.Rows.Add(0, Convert.ToString(txtvalues.Text), Convert.ToString(ddlunits.SelectedValue));
                var idtbl = AddIDcolumn(tbl);
                ViewState["finaltable"] = idtbl;
                bindgrid(idtbl);
            }
            else
            {
                DataTable dt = new DataTable();
                dt.Columns.AddRange(new DataColumn[2] {
                new DataColumn("value", typeof(string)),
                new DataColumn("units", typeof(string)) });
                dt.Rows.Add(Convert.ToString(txtvalues.Text), Convert.ToString(ddlunits.SelectedValue));
                var idtbl = AddIDcolumn(dt);
                ViewState["finaltable"] = idtbl;
                bindgrid(idtbl);
            }
        }

        public DataTable AddIDcolumn(DataTable dt)
        {
            int i = 1;
            DataTable dtid = new DataTable();
            dtid.Columns.AddRange(new DataColumn[3] {
                new DataColumn(("id"),typeof(int)),new DataColumn(("value"),typeof(string)),
                 new DataColumn(("units"),typeof(string))});
            foreach (DataRow dr in dt.Rows)
            {
                dtid.Rows.Add(i, Convert.ToString(dr["value"]), Convert.ToString(dr["units"]));
                i++;
            }
            return dtid;
        }

        protected void lnkdelete_Command(object sender, CommandEventArgs e)
        {
            if (ViewState["finaltable"] != null)
            {
                string id = e.CommandArgument.ToString();
                DataTable finaldt = (DataTable)ViewState["finaltable"];
                if (finaldt.Rows.Count == 1)
                {
                    finaldt = null;
                }
                else
                {
                    finaldt = finaldt.Select("id<>'" + id + "'").CopyToDataTable();
                }
                ViewState["finaltable"] = finaldt;
                bindgrid(finaldt);
            }
        }
        public void bindgrid(DataTable dt)
        {
            gvunits.DataSource = dt;
            gvunits.DataBind();
            gvunits.Visible = true;
        }

        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            if (gvunits.Rows.Count > 0)
            {
                RequestRootObject request = new RequestRootObject();
                
                //Iterate through the GridView to gather all input data for the request.
                foreach (GridViewRow row in gvunits.Rows)
                {
                    string value = Convert.ToString(row.Cells[0].Text);
                    string unit = Convert.ToString(row.Cells[1].Text);
                    request.items.Add(new RequestItem(Convert.ToInt32(value), Convert.ToString(unit)));
                    
                }

                //Create the Request JSON from the request object
                string requestJSON = JsonConvert.SerializeObject(request);
                
                //Pass the Request JSON to be sent to the API endpoint.
                string responseJSON=Submitdata(requestJSON);

                dynamic respData = JObject.Parse(responseJSON);

                //Response.Write(respData.status + respData.message);
                //message, Value, Unit
                double sum = Convert.ToDouble(respData.Value);

            switch(ddlResultUnits.SelectedValue)
                {
                    case "Kg":
                        this.lblResult.Text = "The total is: " + (sum/1000000).ToString("N3") + " Kg";
                        break;

                    case "g":
                        this.lblResult.Text = "The total is: " + (sum / 1000).ToString("N3") + " g";
                        break;

                    case "mg":
                        this.lblResult.Text = "The total is: " + sum.ToString("N3") + " mg";
                        break;

                }
                this.lblResult.Visible = true;



            }
        }

        /// <summary>
        /// Submits the data to the Web API based on passed JSON
        /// </summary>
        /// <param name="postdata"></param>
        /// <returns></returns>
        public string Submitdata(string requestJSON)
        {
            var request = (HttpWebRequest)WebRequest.Create("https://unitscalcwebapi.azurewebsites.net/api/Values/Calculate");
            // var postData = "{\"items\":[{\"Value\":1000,\"Unit\":\"KG\"}]}";
            var data = Encoding.ASCII.GetBytes(requestJSON);
            request.Method = "POST";
            request.ContentType = "application/json";
            request.ContentLength = data.Length;
            using (var stream = request.GetRequestStream())
            {
                stream.Write(data, 0, data.Length);
            }
            var response = (HttpWebResponse)request.GetResponse();
            var responseString = new StreamReader(response.GetResponseStream()).ReadToEnd();
            return responseString;
            // Response.Write(responseString);
        }

    }


}