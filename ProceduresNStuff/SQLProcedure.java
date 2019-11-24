package epl343project;

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
		String ia [] = input.split(",");
		int length = ia.length;
		if (input.equals("")) length=0;
		String Statement = buildStatement(ProcedureName,length,hasOutput);
		String output = "" ;
		 try {
			 System.out.println(Statement);
			 cstmt = conn.prepareCall(Statement);
			 if (hasOutput) {
				 cstmt.registerOutParameter(1, Types.INTEGER);
				 while (c<length) {
					 c++;
					 cstmt.setString(c+1, ia[c-1]); 
				 }
				 cstmt.execute();
				 int result = cstmt.getInt(1); 
				 output =Integer.toString(result);
				 return output;
			 } else {
				 while (c<length) {
					 c++;
					 cstmt.setString(c, ia[c-1]); 
				 }
				 rs=cstmt.executeQuery();
				 c=0;
					int columns= getColumns(rs);
					 while (rs.next()) {	
						 c=0;
							while (c<columns) {
								c++;
								output+=(rs.getString(c) + " , ");		
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
	
	public void toFile (String input , boolean toFile) {
		if (toFile) {
			//Ask from GUI or msg on screen for filename
			System.out.println("Filename");
			Scanner in = new Scanner(System.in);
			String filename = in.next();
			try {
				BufferedWriter writer= new BufferedWriter(new FileWriter(filename));
				writer.write(input);
				writer.close();
			} catch (IOException e) {
			}
		}else {
			//Output not file , either print to screen to send it to GUI?
			System.out.println(input);
		}
	}
	
	public static void main (String args[] ) {
		SQLProcedure proc = new SQLProcedure ();
		conn= proc.getDBConnection();
		//System.out.println(proc.buildStatement("EmployeeShow",3,true));
		String output="";
		//output = proc.superFunction("0000001,00001,K,K,1900-12-01,kman@email.com,Plebeian,99922623,22722723,overtherainbow,1,0", "EmployeeInsert",true);
		//output = proc.superFunction("", "printEmployee", false);
		output=proc.superFunction("103", "SearchItemByPosition", false);
		proc.toFile(output, true);
		//System.out.println(output);
	}
}
