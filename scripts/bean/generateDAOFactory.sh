#!/bin/bash

printf "package $1;

public abstract class DAOFactory {

	public static final int DB2 = 0;
	public static final int HSQLDB = 1;
	public static final int MYSQL = 2;
	
	public static DAOFactory getDAOFactory(int whichFactory) {
		switch ( whichFactory ) {
		case DB2:
			return new Db2DAOFactory();
		default:
			return null;
		}
	}\n\n" > DAOFactory.java
	
for i in $( seq 1 $(((($#)-1))) )
do
    classParamIndex=$((($i)+1))
    printf "    public abstract ${!classParamIndex}DAO get${!classParamIndex}DAO();\n" >> DAOFactory.java
done

printf "\n}" >> DAOFactory.java

#	public abstract ProgettoDAO getProgettoDAO();										//TODO personalizzare
#	public abstract WorkPackageDAO getWorkPackageDAO();									//TODO personalizzare
#	public abstract WorkPackagePartnerMappingDAO getWorkPackagePartnerMappingDAO();		//TODO personalizzare
#	public abstract PartnerDAO getPartnerDAO();											//TODO personalizzare
	
#USAGE: ./generateDAOFactory basePackage beanClassName (DO NOT include "DTO") [beanClassName]...
