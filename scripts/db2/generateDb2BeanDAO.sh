#!/bin/bash

printf "package $1.db2;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.logging.Logger;

import $1.$2DAO;
import $1.$2DTO;\n\n" > Db2"$2"DAO.java

printf "public class Db2$2DAO implements $2DAO {

	Logger logger = Logger.getLogger( getClass().getCanonicalName() );
	
	static final String TABLE = \"$2\";	\n\n" >> Db2"$2"DAO.java
	
nFields="0";
for i in $( seq 1 $(((($#-2)/2))) )
do
	nFields=$((nFields+1))
    fieldNameParamIndex=$((($i*2)+2))
	printf "	static final String P$nFields = \"${!fieldNameParamIndex}\";\n">> Db2"$2"DAO.java
done

echo $nFields
	
printf "
	// INSERT INTO table ( id, name, description, ...) VALUES ( ?,?, ... );
	static final String insert = 
		\"INSERT INTO \" + TABLE + \" (\" " >> Db2"$2"DAO.java
		
for i in $( seq 1 $nFields )
do
	printf "+ P$i +" >> Db2"$2"DAO.java
	if [ "$i" -lt "$nFields" ]; then
		printf " \", \" " >> Db2"$2"DAO.java
	fi
done

printf " \" ) \" +		
		\"VALUES (" >> Db2"$2"DAO.java

for i in $( seq 1 $nFields )
do
	printf "?" >> Db2"$2"DAO.java
	if [ "$i" -lt "$nFields" ]; then
		printf ", " >> Db2"$2"DAO.java
	fi
done

printf ") \";
	
	// SELECT * FROM table WHERE idcolumn = ?;
	static String read_by_id = 
		\"SELECT * FROM \" + TABLE + \" WHERE \" + P1 + \" = ? \";

	// SELECT * FROM table WHERE stringcolumn = ?;
	static String read_all = 
		\"SELECT * FROM \" + TABLE;
	
	// DELETE FROM table WHERE idcolumn = ?;
	static String delete = 
		\"DELETE FROM \" + TABLE + \" WHERE \" + P1 + \" = ? \";

	// UPDATE table SET xxxcolumn = ?, ... WHERE idcolumn = ?;
	static String update = 
		\"UPDATE \" + TABLE + \" \" + 
		\"SET \" " >> Db2"$2"DAO.java
		
for i in $( seq 2 $nFields )
do
	printf "+ P$i + \" = ?" >> Db2"$2"DAO.java
	if [ "$i" -lt "$nFields" ]; then
		printf ", \" " >> Db2"$2"DAO.java
	fi
done

		
printf " \" + 
	    \"WHERE \" + P1 + \" = ? \";

	// SELECT * FROM table;
	static String query = 
		\"SELECT * FROM \" + TABLE + \" \";
	
	//static String custom_query_1 = //TODO personalizzare eventualmente
		//read_all + \" WHERE \" + P3 + \" = ? \";
	
	// -------------------------------------------------------------------------------------

	// CREATE entrytable ( code INT NOT NULL PRIMARY KEY, ... );
	static String create =                      		//TODO personalizzare (aggiungere o togliere parametri)
		\"CREATE \" +
			\"TABLE \" + TABLE +\" ( \" +
				P1 + \" $3 NOT NULL PRIMARY KEY, \" +	//TODO personalizzare tipo SQL (primary key, non nullo)\n" >> Db2"$2"DAO.java
				
for i in $( seq 2 $nFields )
do
	fieldNameParamIndex=$((($i*2)+1))
	printf "				P$i + \" ${!fieldNameParamIndex}" >> Db2"$2"DAO.java
	if [ "$i" -lt "$nFields" ]; then
		printf ", \" +\n" >> Db2"$2"DAO.java
	fi
done
				
printf " \" +							//TODO personalizzare tipo SQL
			\") \";
	
	static String drop = 
		\"DROP TABLE \" + TABLE + \" \";
	
	
	// === METODI DAO =========================================================================
	
	public void create($2DTO o) {							//TODO personalizza tipo
		
		Connection conn = Db2DAOFactory.createConnection();
		try {
			PreparedStatement prep_stmt = conn.prepareStatement(Db2$2DAO.insert);
			prep_stmt.clearParameters();\n\n" >> Db2"$2"DAO.java
			
for i in $( seq 1 $nFields )
do
	fieldTypeParamIndex=$((($i*2)+1))
	fieldNameParamIndex=$((($i*2)+2))
	fieldType="${!fieldTypeParamIndex}"
	fieldTypeFirstUpper="$(tr '[:lower:]' '[:upper:]' <<< ${fieldType:0:1})${fieldType:1}"
	fieldName="${!fieldNameParamIndex}"
	fieldNameFirstUpper="$(tr '[:lower:]' '[:upper:]' <<< ${fieldName:0:1})${fieldName:1}"
	
	if [ "$fieldType" = "Date" ]; then
		printf "			prep_stmt.setDate($i, new java.sql.Date(o.get$fieldNameFirstUpper().getTime()));\n" >> Db2"$2"DAO.java
	else
		printf "			prep_stmt.set$fieldTypeFirstUpper($i, o.get$fieldNameFirstUpper());\n" >> Db2"$2"DAO.java
	fi
done

printf "\n			prep_stmt.executeUpdate();
			prep_stmt.close();
		}
		catch (Exception e) {
			logger.warning(\"create(): failed to insert entry: \" + e.getMessage());
			e.printStackTrace();
		}
	}

	
	public $2DTO read(int id) {							//TODO personalizza tipo
		
		$2DTO result = null;

		if ( id < 0 )  {
			logger.warning(\"read(): cannot read an entry with a negative id\");
			return result;
		}

		Connection conn = Db2DAOFactory.createConnection();
		
		try {
			PreparedStatement prep_stmt = conn.prepareStatement(read_by_id);

			prep_stmt.clearParameters();
			prep_stmt.setInt(1, id);

			ResultSet rs = prep_stmt.executeQuery();

			if ( rs.next() ) {
				ProgettoDTO o = new " >> Db2"$2"DAO.java
				
if [ "${@: -1}" = "--proxy" ]; then
	printf "Db2$2ProxyDTO" >> Db2"$2"DAO.java
else
	printf "$2DTO" >> Db2"$2"DAO.java
fi

printf "();\n\n				//TODO some useful code for Db2 mapping\n" >> Db2"$2"DAO.java

for i in $( seq 1 $nFields )
do
	fieldTypeParamIndex=$((($i*2)+1))
	fieldNameParamIndex=$((($i*2)+2))
	fieldType="${!fieldTypeParamIndex}"
	fieldTypeFirstUpper="$(tr '[:lower:]' '[:upper:]' <<< ${fieldType:0:1})${fieldType:1}"
	fieldName="${!fieldNameParamIndex}"
	fieldNameFirstUpper="$(tr '[:lower:]' '[:upper:]' <<< ${fieldName:0:1})${fieldName:1}"
	
	if [ "$fieldType" = "Date" ]; then
		printf "				long secs = rs.getDate(P$i).getTime();
					java.util.Date $fieldName = new java.util.Date(secs);
					o.set$fieldNameFirstUpper($fieldName);\n" >> Db2"$2"DAO.java
	else
		printf "				o.set$fieldNameFirstUpper(rs.get$fieldTypeFirstUpper(P$i));\n" >> Db2"$2"DAO.java
	fi
	
done
				
printf "\n\n				result = o;
			}
			
			rs.close();
			prep_stmt.close();
		
		} catch (Exception e) {
			logger.warning(\"read(): failed to retrieve entry with id = \" + id+\": \"+e.getMessage());
			e.printStackTrace();
		} finally {
			Db2DAOFactory.closeConnection(conn);
		}
		
		return result;
	}

	// -------------------------------------------------------------------------------------

	
	public boolean update($2DTO o) {										//TODO personalizzare tipo
		
		boolean result = false;

		if ( o == null )  {
			logger.warning( \"update(): failed to update a null entry\");
			return result;
		}

		Connection conn = Db2DAOFactory.createConnection();

		try {
			PreparedStatement prep_stmt = conn.prepareStatement(Db2$2DAO.update);
			prep_stmt.clearParameters();\n\n" >> Db2"$2"DAO.java
			
for i in $( seq 1 $nFields )
do
	fieldTypeParamIndex=$((($i*2)+1))
	fieldNameParamIndex=$((($i*2)+2))
	fieldType="${!fieldTypeParamIndex}"
	fieldTypeFirstUpper="$(tr '[:lower:]' '[:upper:]' <<< ${fieldType:0:1})${fieldType:1}"
	fieldName="${!fieldNameParamIndex}"
	fieldNameFirstUpper="$(tr '[:lower:]' '[:upper:]' <<< ${fieldName:0:1})${fieldName:1}"
	
	if [ "$fieldType" = "Date" ]; then
		printf "			prep_stmt.setDate($i, new java.sql.Date(o.get$fieldNameFirstUpper().getTime()));\n" >> Db2"$2"DAO.java
	else
		printf "			prep_stmt.set$fieldTypeFirstUpper($i, o.get$fieldNameFirstUpper());\n" >> Db2"$2"DAO.java
	fi
done

printf "\n			prep_stmt.executeUpdate();
			result = true;
			prep_stmt.close();
			
		} catch (Exception e) {
			logger.warning(\"insert(): failed to update entry: \"+e.getMessage());
			e.printStackTrace();
			
		} finally {
			Db2DAOFactory.closeConnection(conn);
		}
		
		return result;
	}

	
	// -------------------------------------------------------------------------------------

	public boolean delete(int id) {
		
		boolean result = false;

		if ( id < 0 )  {
			logger.warning(\"delete(): cannot delete an entry with an invalid id \");
			return result;
		}

		Connection conn = Db2DAOFactory.createConnection();

		try {

			PreparedStatement prep_stmt = conn.prepareStatement(Db2$2DAO.delete);
			
			prep_stmt.clearParameters();
			prep_stmt.setInt(1, id);
			
			prep_stmt.executeUpdate();

			result = true;

			prep_stmt.close();
		} catch (Exception e) {
			logger.warning(\"delete(): failed to delete entry with id = \" + id+\": \"+e.getMessage());
			e.printStackTrace();
		} finally {
			Db2DAOFactory.closeConnection(conn);
		}
		
		return result;
	}


	// -------------------------------------------------------------------------------------

	// TODO add custom methods
	
	
	// -------------------------------------------------------------------------------------

	public boolean createTable() {
		
		boolean result = false;
		Connection conn = Db2DAOFactory.createConnection();

		try {
			Statement stmt = conn.createStatement();
			stmt.execute(create);
			result = true;
			stmt.close();
		} catch (Exception e) {
			logger.warning(\"createTable(): failed to create table '\"+TABLE+\"': \"+e.getMessage());
		} finally {
			Db2DAOFactory.closeConnection(conn);
		}

		return result;
	}
	

	public boolean dropTable() {
		boolean result = false;
		
		Connection conn = Db2DAOFactory.createConnection();

		try {
			Statement stmt = conn.createStatement();
			stmt.execute(drop);
			result = true;

			stmt.close();
		} catch (Exception e) {
			logger.warning(\"dropTable(): failed to drop table '\"+TABLE+\"': \"+e.getMessage());
		} finally {
			Db2DAOFactory.closeConnection(conn);
		}
		
		return result;
	}

}" >> Db2"$2"DAO.java

#WARNING: DO NOT include collections in the field list. This script is not designed to generate Db2 bean mapping DAO implementations! Use generateDb2BeanMappingDAO.sh instead.
#USAGE: ./generateDb2BeanDAO.sh basePackage beanClassName (DO NOT include "DTO" nor "DAO") fieldType fieldName (the first field MUST be the primary key) [fieldType fieldName]... (WARNING: DO NOT include collections!)