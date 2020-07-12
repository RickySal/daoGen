#!/bin/bash

for i in $( seq 1 $(((($#)-1))) )
do
	classParamIndex=$((($i)+1))
	
	printf "package $1;

public interface ${!classParamIndex}DAO {

		// *** CRUD METHODS ***

	public void create(${!classParamIndex}DTO o);
	public ${!classParamIndex}DTO read(int id);
	public boolean update(${!classParamIndex}DTO o);
	public boolean delete(int id);


		// *** CUSTOM METHODS ***

	//public List<SomethingDTO> findSomethingBySomethingElse(String somethingElse); TODO


		// *** CREATE and DROP TABLE METHODS ***

	public boolean createTable();
	public boolean dropTable();

}
" > "${!classParamIndex}"DAO.java

done

#USAGE: ./generateBeanDAOInterfaces basePackage beanClassName (DO NOT include "DTO" nor "DAO") [beanClassName]...