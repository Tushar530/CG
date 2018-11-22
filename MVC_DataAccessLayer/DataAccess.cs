using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MVC_DataAccessLayer;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace MVC_DataAccessLayer
{
    public class DataAccess
    {
        SqlTransaction objTran;
        SqlConnection objConn;

        public DataSet GetMyHireValidData(DataTable tb)
        {
            DataSet ds = new DataSet();
            SqlConnection objConn = SqlHelper.OpenConnection();
            try
            {
                var param = new SqlParameter[]
                  {
                   new SqlParameter("@Details",tb),
                     
                  };
                ds = SqlHelper.ExecuteDataset(objConn, null, CommandType.StoredProcedure, "usp_GetMYHireDemandData", param);
                return ds;
            }
            catch (Exception Ex)
            {
                return null;
            }
            finally
            {
                SqlHelper.CloseConnection(objConn);
                objConn = null;
                ds = null;
            }
        }



        public DataTable GetMyHireValidData1(DataTable dt)
        {
            DataSet ds = new DataSet();
            DataTable dt1 = new DataTable();
            SqlConnection objConn = SqlHelper.OpenConnection();
            try
            {
                var param = new SqlParameter[]
                  {
                    //new SqlParameter("@username",username),
                    new SqlParameter("@Details",dt),
                     
                  };
                dt1 = SqlHelper.ExecuteNonQuery(objConn, null, CommandType.StoredProcedure, "usp_GetMYHireDemandData", param);
                return dt1;
            }
            catch (Exception Ex)
            {
                return null;
            }
            finally
            {
                SqlHelper.CloseConnection(objConn);
                objConn = null;
                dt1 = null;
            }
        }

 

        public DataTable GetMyHireSingleSearch_Demand(string positionid)
        {
            DataTable ds = new DataTable();
            SqlConnection objConn = SqlHelper.OpenConnection();
            try
            {
                var param = new SqlParameter[]
                  {
                    new SqlParameter("@DemandId",positionid),
                     
                  };
                ds = SqlHelper.ExecuteNonQuery(objConn, null, CommandType.StoredProcedure, "USP_GetMyHireData_SingleSearch", param);
                return ds;
            }
            catch (Exception Ex)
            {
                return null;
            }
            finally
            {
                SqlHelper.CloseConnection(objConn);
                objConn = null;
                ds = null;
            }
        }

        //public DataSet GetMyHirePickListMaster(string PickListType)
        //{
        //    DataSet  ds = new DataSet();
        //    SqlConnection objConn = SqlHelper.OpenConnection();
        //    try
        //    {
        //        var param = new SqlParameter[]
        //          {
        //            new SqlParameter("@PickListType",PickListType),
                     
        //          };
        //        ds = SqlHelper.ExecuteNonQuery(objConn, null, CommandType.StoredProcedure, "USP_GetMyHirePickListData", param);
        //        return ds;
        //    }
        //    catch (Exception Ex)
        //    {
        //        return null;
        //    }
        //    finally
        //    {
        //        SqlHelper.CloseConnection(objConn);
        //        objConn = null;
        //        ds = null;
        //    }
        //}

        public DataSet GetMyHirePickListMaster(string PickListType)
        {
            DataSet ds = new DataSet();
            SqlConnection objConn = SqlHelper.OpenConnection();
            try
            {
                var param = new SqlParameter[]
                  {
                    new SqlParameter("@PickListType",PickListType),
                  
                  };
                ds = SqlHelper.ExecuteDataset(objConn, null, CommandType.StoredProcedure, "USP_GetMyHirePickListData", param);
                return ds;
            }
            catch (Exception Ex)
            {
                return null;
            }
            finally
            {
                SqlHelper.CloseConnection(objConn);
                objConn = null;
                ds = null;
            }
        }


        public DataTable GetMyCountryDropdown(string CountryCode)
        {
            DataTable ds = new DataTable();
            SqlConnection objConn = SqlHelper.OpenConnection();
            try
            {
                var param = new SqlParameter[]
                  {
                    new SqlParameter("@DdlValue",CountryCode),
                     
                  };
                ds = SqlHelper.ExecuteNonQuery(objConn, null, CommandType.StoredProcedure, "usp_Get_CountrySBU_DDL", param);
                return ds;
            }
            catch (Exception Ex)
            {
                return null;
            }
            finally
            {
                SqlHelper.CloseConnection(objConn);
                objConn = null;
                ds = null;
            }
        }


        public DataSet GetMyCountryDropdown3(string CountryCode)
        {
            DataSet ds = new DataSet();
            SqlConnection objConn = SqlHelper.OpenConnection();
            try
            {
                var param = new SqlParameter[]
                  {
                    new SqlParameter("@DdlValue",CountryCode),
                     
                  };
                ds = SqlHelper.ExecuteDataset(objConn, null, CommandType.StoredProcedure, "usp_Get_CountrySBU_DDL", param);
                return ds;
            }
            catch (Exception Ex)
            {
                return null;
            }
            finally
            {
                SqlHelper.CloseConnection(objConn);
                objConn = null;
                ds = null;
            }
        }


        public DataTable SaveAspBooking1(DataTable dt)
        {
            DataSet ds = new DataSet();
            DataTable dt1 = new DataTable();
            SqlConnection objConn = SqlHelper.OpenConnection();
            try
            {
                var param = new SqlParameter[]
                  {
                    new SqlParameter("@Details",dt),
                     
                  };
                dt1 = SqlHelper.ExecuteNonQuery(objConn, null, CommandType.StoredProcedure, "usp_GetMYHireDemandData", param);
                return dt1;
            }
            catch (Exception Ex)
            {
                return null;
            }
            finally
            {
                SqlHelper.CloseConnection(objConn);
                objConn = null;
                dt1 = null;
            }
        }

    }
}
