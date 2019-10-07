using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;

 
    public class CommonFunction
    {

        #region Write Error Message

        /// Handles error by accepting the error message
        /// Displays the page on which the error occured
        public static void WriteError(string errorMessage, string methodName)
        {
            try
            {
                string Directorypath = ConfigurationManager.AppSettings["physicalLogFilePath"].ToString() + "/Logs";
                string path =  ConfigurationManager.AppSettings["physicalLogFilePath"].ToString() + "/Logs/" + DateTime.Now.ToString("ddMMM_") + "MobileLogfile.log";
                if (!Directory.Exists(Directorypath))
                {
                    Directory.CreateDirectory(Directorypath);
                }
                if (!File.Exists(path))
                {
                    File.Create(path).Close();
                }
                using (StreamWriter w = File.AppendText(path))
                {
                    w.WriteLine("{0}", DateTime.Now.ToString());
                    string err = ": Error found at:" + methodName +": " +  errorMessage;
                    w.WriteLine(err);
                    w.WriteLine("------------------------------------------------------------------");
                    w.Flush();
                    w.Close();
                }
            }
            catch
            {

            }

        }
            #endregion

    }

 