#!/bin/bash

printf "package $1;

public class $2{\n" > $2.java

for i in $( seq 1 $(((($#-2)/2))) )
do
    fieldTypeParamIndex=$((($i*2)+1))
    fieldNameParamIndex=$((($i*2)+2))
    printf "    ${!fieldTypeParamIndex} ${!fieldNameParamIndex};\n" >> $2.java
done

printf "\n    public $2(){
    }\n\n" >> $2.java

for i in $( seq 1 $(((($#-2)/2))) )
do
	fieldTypeParamIndex=$((($i*2)+1))
    fieldNameParamIndex=$((($i*2)+2))
	fieldName="${!fieldNameParamIndex}"
	fieldNameFirstUpper="$(tr '[:lower:]' '[:upper:]' <<< ${fieldName:0:1})${fieldName:1}"
    printf  "	public ${!fieldTypeParamIndex} get$fieldNameFirstUpper(){
		return this.${!fieldNameParamIndex};
	}\n\n" >> $2.java
	
	printf "	public void set$fieldNameFirstUpper(${!fieldTypeParamIndex} ${!fieldNameParamIndex}){
		this.${!fieldNameParamIndex} = ${!fieldNameParamIndex};
	}\n\n" >> $2.java
done

if [[ "$3" == "int" && "$4" == "id" ]] ; then
	printf "	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + id;
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		$2 other = ($2) obj;
		if (id != other.id)
			return false;
		return true;
	}\n\n" >> $2.java
	
fi

printf "}" >> $2.java

#USAGE: ./generateBean.sh basePackage beanClassName[DTO] (WARNING! "DTO" MUST be specified) ["int" "id"] fieldType fieldName [fieldType fieldName]...