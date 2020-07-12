#!/bin/bash

printf "package $1;

import java.util.List;

public interface $2$3MappingDAO {

		// *** CREATE and DELETE METHODS ***

	public void create(int id$2, int id$3);
	public boolean delete(int id$2, int id$3);

	
		// *** CUSTOM METHODS ***



		// *** CREATE and DROP TABLE METHODS ***

	public boolean createTable();
	public boolean dropTable();
	
	
		// *** READ METHODS ***

	public List<$2DTO> get" > "$2$3"MappingDAO.java
	
	echo $4
	echo $5
	
if [[ -n "$4" && -n "$5" ]]; then
	printf "$4By$3(int id);
	public List<$3DTO> get$5By$2(int id);\n" >> "$2$3"MappingDAO.java
	
else
	printf "$2sBy$3(int id);
	public List<$3DTO> get$3sBy$2(int id);\n" >> "$2$3"MappingDAO.java
	
fi

printf "\n}" >> "$2$3"MappingDAO.java

#USAGE: ./generateBeanMappingDAOInterface.sh basePackage className1 (DO NOT include "DTO" nor "DAO") className2 [className1plural className2plural]