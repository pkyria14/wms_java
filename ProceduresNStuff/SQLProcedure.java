package epl343project;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Scanner;

public class SQLProcedure {
	
	private static boolean dbDriverLoaded = false;
	private static Connection conn = null;
	Scanner in = new Scanner(System.in);
	
	
	private Connection getDBConnection() {
		String dbConnString = "jdbc:sqlserver://mssql.cs.ucy.ac.cy;databaseName=epl343_team2;user=epl343_team2;password=Tvb74qk6;";

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
	
	public String buildStatement (String ProcedureName, int c,boolean hasOutput) {
		String out;
		if (hasOutput)   out = "{?= call " + ProcedureName + " (" ;
		else  out = "{call " + ProcedureName + " (" ;
		int counter =0;
		while (counter<c) {
			if (counter<c-1)
			{counter++;
			out+="?,";
			}
			else {
				counter++;
				out+="?";
			}
		}
		out+=")}";
		return out;
	}
	/**
	 * 
	 * @param input User input for example EmployeeID
	 * @param ProcedureName The name of SQLProcedure for example EmployeeShow
	 * @param hasOutput True or False  mostly used for insert/update
	 * @param output The output of the procedure
	 */
	public String superFunction (String input ,String ProcedureName, boolean hasOutput ) {
		CallableStatement cstmt = null;
	    ResultSet rs = null;
	    int c=0;
		String ia [] = input.split("'");
		String Statement = buildStatement(ProcedureName,ia.length,hasOutput);
		String output = "" ;
		 try {
			 System.out.println(Statement);
			 cstmt = conn.prepareCall(Statement);
			 if (hasOutput) {
				 cstmt.registerOutParameter(1, Types.INTEGER);
				 while (c<ia.length) {
					 c++;
					 cstmt.setString(c+1, ia[c-1]); 
				 }
				 cstmt.execute();
				 int result = cstmt.getInt(1); 
				 output =String.valueOf(result);
				 return output;
			 } else {
				 while (c<ia.length) {
					 c++;
					 cstmt.setString(c, ia[c-1]); 
				 }
				 rs=cstmt.executeQuery();
				 c=0;
					int columns= getColumns(rs);
					 while (rs.next()) {	
							while (c<columns) {
								c++;
								output+=(rs.getString(c) + " , ");		
								}
							output+="\n";
				 }
				return output;
			 } 
			 
		 }catch (Exception e) {
			
		 }
	    
		return "Error";
	}
	
	public static void main (String args[] ) {
		SQLProcedure proc = new SQLProcedure ();
		conn= proc.getDBConnection();
		//System.out.println(proc.buildStatement("EmployeeShow",3,true));
		String output="";
		output = proc.superFunction("2,10,", "PalletUpdateExtraCost",true);
		System.out.println(output);
	}
}
