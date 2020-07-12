#!/bin/bash

printf "package $1.db2;

import $1.DAOFactory;\n\n" > Db2DAOFactory.java

for i in $( seq 1 $(((($#)-5))))
do
	classParamIndex=$((($i)+5))
	printf "import $1.${!classParamIndex}DAO;\n" >> Db2DAOFactory.java
done

printf "\nimport java.sql.Connection;
import java.sql.DriverManager;

public class Db2DAOFactory extends DAOFactory {

	/**
	 * Name of the class that holds the jdbc driver implementation for the DB2 database
	 */
	public static final String DRIVER = \"$2\";
	
	/**
	 * URI of the database to connect to
	 */
	public static final String DBURL = \"$3\";

	public static final String USERNAME = \"$4\";												
	public static final String PASSWORD = \"$5\";												

	// --------------------------------------------

	// static initializer block to load db driver class in memory
	static {
		try {
			Class.forName(DRIVER);
		} 
		catch (Exception e) {
			System.err.println(\"Db2DAOFactory: failed to load DB2 JDBC driver\" + \"\\\n\" + e.toString());
			e.printStackTrace();
		}
	}

	// --------------------------------------------

	/**
	 * For the sake of simplicity, here we create a brand new connection every time we are asked to.
	 * 
	 * Anyway, this is how things should go in the real world:
	 * 1. 	DB offers a limited number of connections (typically 100) so we can't really afford to 
	 * 		rely on factory invokers to always terminate the connection we have opened
	 * 2. 	At initialization, factory creates a well-defined number of connections (say 20) and put them
	 * 		in a pool
	 * 3.	create and close connection methods actually do not create or close brand new connections, but
	 * 		pick available connections from the pool, each time, and mark them as 'busy'/'free'
	 * 4.	factory does monitoring on the connection pool and force termination of connection in use
	 * 		for a too long time (invoker prob'ly forgot to close it... maybe due to exceptions it didn't handle well)
	 * 5.	terminated connections are replaced by brand new ones
	 */
	
	public static Connection createConnection() {
		try {
			return DriverManager.getConnection(DBURL,USERNAME,PASSWORD);
		} 
		catch (Exception e) {
			System.err.println(Db2DAOFactory.class.getName() + \".createConnection(): failed creating connection\" + \"\\\n\" + e.toString());
			e.printStackTrace();
			System.err.println(\"Was the database started? Is the database URL right?\");
			return null;
		}
	}
	
	/**
	 * For the sake of simplicity, here we actually close the connection we are told to.
	 */
	public static void closeConnection(Connection conn) {
		try {
			conn.close();
		}
		catch (Exception e) {
			System.err.println(Db2DAOFactory.class.getName() + \".closeConnection(): failed closing connection\" + \"\\\n\" + e.toString());
			e.printStackTrace();
		}
	}

	// --------------------------------------------\n\n" >> Db2DAOFactory.java
	
for i in $( seq 1 $(((($#)-5))) )
do
	classParamIndex=$((($i)+5))
	
	printf "	@Override
	public ${!classParamIndex}DAO get${!classParamIndex}DAO() {
		return new Db2${!classParamIndex}DAO();
	}\n\n" >> Db2DAOFactory.java
	
done

printf "}" >> Db2DAOFactory.java

#USAGE: generateDb2DAOFactory.sh basePackage (NOT db2 package) Db2DriverClassFull dbUrl dbUsername dbPassword beanClassNameOrMapping (DO NOT include "DTO" nor "DAO") [beanClassNameOrMapping]...