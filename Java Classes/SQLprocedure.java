

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;

public class SQLprocedure {
	
	private static boolean dbDriverLoaded = false;
	private static Connection conn = null;
	Scanner in = new Scanner(System.in);
	
	
	Connection getDBConnection() {
		String dbConnString = "jdbc:sqlserver://mssql.cs.ucy.ac.cy;databaseName=mpitsi04;user=mpitsi04;password=CvE57anY;";

		if (!dbDriverLoaded)
			try {
				Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
				dbDriverLoaded = true;
			} catch (ClassNotFoundException e) {
				System.out.println("Cannot load DB driver!");
				return null;
			}

		try {
			if (conn == null)
				conn = DriverManager.getConnection(dbConnString);
			else if (conn.isClosed())
				conn = DriverManager.getConnection(dbConnString);
		} catch (SQLException e) {
			System.out.print("Cannot connect to the DB!\nGot error: ");
			System.out.print(e.getErrorCode());
			System.out.print("\nSQL State: ");
			System.out.println(e.getSQLState());
			System.out.println(e.getMessage());
		}
	
		return conn;
	}
	
	public int getColumns (ResultSet rs) {
		ResultSetMetaData rsmd;
		try {
			rsmd = rs.getMetaData();
			int columnsNumber = rsmd.getColumnCount();
			return columnsNumber;
		} catch (SQLException e) {
		}
		return -1;
	}
	/**
	 * Build the sql callable statement
	 * 
	 * @param ProcedureName 
	 * @param c
	 * @param hasOutput If the sql procedures uses "Return"
	 * @return
	 */
	public String buildStatement (String ProcedureName, int c,boolean hasOutput) {
		String out;
		if (hasOutput)   {
			out = "{ ? = call " + ProcedureName + " (" ;
		}
		else  out = "{call " + ProcedureName + " (" ;
		int counter =0;
		while (counter<c) {
			counter++;
			if (counter<c)
			{
			out+="?,";
			}
			else {
				out+="?";
			}
		}
		out+=")}";
		return out;
	}
	/**
	 * It calls the statement and returns the results.
	 * 
	 * @param input User input
	 * @param ProcedureName The name of SQLProcedure for example EmployeeShow
	 * @param hasOutput True or False  mostly used for insert/update
	 * @param output The output of the procedure
	 */
	public String superFunction (List <String> input ,String ProcedureName, boolean hasOutput ) {
		CallableStatement cstmt = null;
	    ResultSet rs = null;
	    int c=0;
		//String [] ia =  (String[]) input.toArray();
		int length = input.size();
		//if (input.equals("")) length=0;
		String Statement = buildStatement(ProcedureName,length,hasOutput);
		String output = "" ;
		 try {
			 cstmt = conn.prepareCall(Statement);
			 if (hasOutput) {
				 cstmt.registerOutParameter(1, Types.INTEGER);
				 while (c<length) {
					 c++;
					 cstmt.setString(c+1, input.get(c-1)); 
				 }
				 cstmt.execute();
				 int result = cstmt.getInt(1); 
				 output =Integer.toString(result);
				 return output;
			 } else {
				 while (c<length) {
					 c++;
					 cstmt.setString(c, input.get(c-1)); 
				 }
				 rs=cstmt.executeQuery();
				 c=0;
					int columns= getColumns(rs);
					 while (rs.next()) {	
						 c=0;
							while (c<columns) {
								c++;
								output+=rs.getString(c) + ",";		
								}
							output+="\n";
				 }
				return output;
			 } 
			 
		 }catch (Exception e) {
			System.out.println(e.getMessage());
		 }
	    
		return "Error";
	}
	
}

