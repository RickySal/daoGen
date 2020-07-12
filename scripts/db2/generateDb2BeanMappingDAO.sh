#!/bin/bash
#TODO: Tweak me

printf " package $1.db2;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import $1.$2DTO;
import $1.$1$2MappingDAO;
import $1.$2DTO;

public class Db2$2$3MappingDAO implements $2$3MappingDAO {
	
	static final String TABLE = \"$2_$3\";		

	static final String P1 = \"id$2\";
	static final String P2 = \"id$3\";

	// INSERT INTO table ( idCourse, idStudent ) VALUES ( ?,? );
	static final String insert = 
		\"INSERT \" +
			\"INTO \" + TABLE + \" ( \" + 
				P1 +\", \"+ P2 + \" \" +
			\") \" +
			\"VALUES (?,?) \"
		;
	
	// SELECT * FROM table WHERE idcolumns = ?;
	static String read_by_ids = 
		\"SELECT * \" +
			\"FROM \" + TABLE + \" \" +
			\"WHERE \" + P1 + \" = ? \" +
			\"AND \" + P2 + \" = ? \"
		;

	// SELECT * FROM table WHERE idcolumns = ?;
	static String read_by_id_$2 = 
		\"SELECT * \" +
			\"FROM \" + TABLE + \" \" +
			\"WHERE \" + P1 + \" = ? \"
		;

	// SELECT * FROM table WHERE idcolumns = ?;
	static String read_by_id_$3 = 
		\"SELECT * \" +
			\"FROM \" + TABLE + \" \" +
			\"WHERE \" + P2 + \" = ? \"
		;
	
	// SELECT * FROM table WHERE stringcolumn = ?;
	static String read_all = 
		\"SELECT * \" +
		\"FROM \" + TABLE + \" \";
	
	// DELETE FROM table WHERE idcolumn = ?;
	static String delete = 
		\"DELETE \" +
			\"FROM \" + TABLE + \" \" +
			\"WHERE \" + P1 + \" = ? \" +
			\"AND \" + P2 + \" = ? \"
		;

	// UPDATE table SET xxxcolumn = ?, ... WHERE idcolumn = ?;
	/*static String update = 
		\"UPDATE \" + TABLE + \" \" +
			\"SET \" + 
				NAME + \" = ?, \" +
			\"WHERE \" + ID + \" = ? \"
		;*/

	// SELECT * FROM table;
	static String query = 
		\"SELECT * \" +
			\"FROM \" + TABLE + \" \"
		;

	// -------------------------------------------------------------------------------------

	// CREATE entrytable ( code INT NOT NULL PRIMARY KEY, ... );
	static String create = 
		\"CREATE \" +
			\"TABLE \" + TABLE +\" ( \" +
				P1 + \" INT NOT NULL, \" +
				P2 + \" INT NOT NULL, \" +
				\"PRIMARY KEY (\" + P1 +\",\"+ P2 + \" ), \" +
					\"FOREIGN KEY (\"+P2+\") REFERENCES $3(id), \"+		
					\"FOREIGN KEY (\"+P1+\") REFERENCES $2(id) \"+			
				\") \"
		;
	static String drop = 
		\"DROP \" +
			\"TABLE \" + TABLE + \" \"
		;
	
	// SELECT * FROM table WHERE idcolumns = ?;
			static String $2sBy$3_query = 
				\"SELECT * \" +
					\"FROM \" + TABLE + \" A, $2 B \" +
					\"WHERE A.id$2 = B.id AND \" + P2 + \" = ? \";
			
			
	// SELECT * FROM table WHERE idcolumns = ?;
			static String $3sBy$2_query = 
				\"SELECT * \" +
					\"FROM \" + TABLE + \" A, $3 B \" +
					\"WHERE A.id$3 = B.id AND \" + P1 + \" = ? \";
	
	
	
	@Override
	public void create(int id$2, int id$3 ) {
		Connection conn = Db2DAOFactory.createConnection();
		try {
			PreparedStatement prep_stmt = conn.prepareStatement(insert);
			prep_stmt.clearParameters();
			prep_stmt.setInt(1, id$2);
			prep_stmt.setInt(2, id$3);
			prep_stmt.executeUpdate();
			prep_stmt.close();
		}
		catch (Exception e) {
			System.out.println(\"create(): failed to insert entry: \" + e.getMessage());
			e.printStackTrace();
		}
	}


	@Override
	public boolean delete(int id$2, int id$3) {
		boolean result = false;
		if ( id$2 < 0 || id$3 < 0 )  {
			System.out.println(\"delete(): cannot delete an entry with an invalid id \");
			return result;
		}
		Connection conn = Db2DAOFactory.createConnection();
		try {
			PreparedStatement prep_stmt = conn.prepareStatement(delete);
			prep_stmt.clearParameters();
			prep_stmt.setInt(1, id$2);
			prep_stmt.setInt(2, id$3);
			prep_stmt.executeUpdate();
			result = true;
			prep_stmt.close();
		}
		catch (Exception e) {
			System.out.println(\"delete(): failed to delete entry with idCourse = \" + idCourse +\" and idStudent = \" + idStudent + \": \"+e.getMessage());
			e.printStackTrace();
		}
		finally {
			Db2DAOFactory.closeConnection(conn);
		}
		return result;
	}
	
	@Override
	public boolean createTable() {
		boolean result = false;
		Connection conn = Db2DAOFactory.createConnection();
		try {
			Statement stmt = conn.createStatement();
			stmt.execute(create);
			result = true;
			stmt.close();
		}
		catch (Exception e) {
			System.out.println(\"createTable(): failed to create table '\"+TABLE+\"': \"+e.getMessage());
		}
		finally {
			Db2DAOFactory.closeConnection(conn);
		}
		return result;
	}

	@Override
	public boolean dropTable() {
		boolean result = false;
		Connection conn = Db2DAOFactory.createConnection();
		try {
			Statement stmt = conn.createStatement();
			stmt.execute(drop);
			result = true;
			stmt.close();
		}
		catch (Exception e) {
			System.out.println(\"dropTable(): failed to drop table '\"+TABLE+\"': \"+e.getMessage());
		}
		finally {
			Db2DAOFactory.closeConnection(conn);
		}
		return result;
	}
	

	@Override
	public List<$2DTO> get$2sBy$3(int id) {
		List<$2DTO> result = null;
		if ( id< 0 )  {
			System.out.println(\"read(): cannot read an entry with a negative id\");
			return result;
		}
		Connection conn = Db2DAOFactory.createConnection();
		result = new $4<$2DTO>();
		try {
			PreparedStatement prep_stmt = conn.prepareStatement($2sBy$3_query);
			prep_stmt.clearParameters();
			prep_stmt.setInt(1, id);
			ResultSet rs = prep_stmt.executeQuery();
			while(rs.next())
			{
				$2DTO o = new $2DTO();
				
				//TODO copy and paste from Db2$2DAO.java's read method and substitute P* parameters with field names
				
				result.add(o);
			}
			rs.close();
			prep_stmt.close();
		}
		catch (Exception e) {
			
			e.printStackTrace();
		}
		finally {
			Db2DAOFactory.closeConnection(conn);
		}
		return result;
	}

	@Override
	public List<$3DTO> get$3sBy$2(int id) {
		// TODO Auto-generated method stub
		List<$3DTO> result = null;
		if ( id< 0 )  {
			System.out.println(\"read(): cannot read an entry with a negative id\");
			return result;
		}
		Connection conn = Db2DAOFactory.createConnection();
		result = new $4<$3DTO>();
		try {
			PreparedStatement prep_stmt = conn.prepareStatement($3sBy$2_query);
			prep_stmt.clearParameters();
			prep_stmt.setInt(1, id);
			ResultSet rs = prep_stmt.executeQuery();
			while(rs.next())
			{
				StudentDTO o = new StudentDTO();
				
				//TODO copy and paste from Db2$3DAO.java's read method and substitute P* parameters with field names
				
				result.add(o);
			}
			rs.close();
			prep_stmt.close();
		}
		catch (Exception e) {
			
			e.printStackTrace();
		}
		finally {
			Db2DAOFactory.closeConnection(conn);
		}
		return result;
	}

}
" > Db2$2$3MappingDAO.java

#ALWAYS GENERATE * <--> * MAPPING. TODO PAY ATTENTION
#USAGE: ./generateDb2BeanMappingDAO.sh basePackage bean1ClassName bean2ClassName listType