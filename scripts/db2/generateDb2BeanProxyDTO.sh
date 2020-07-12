#!/bin/bash

printf "package $1.db2;

import java.util.List;

import $1.$2DTO;
import $1.$2$3MappingDAO;
import $1.$3DTO;

public class Db2$2ProxyDTO extends $2DTO{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public Db2$2ProxyDTO() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	@Override
	public List<$3DTO> get$3s()
	{
		if(isAlreadyLoaded())
			return super.get$3s();
		else
		{
			$2$3MappingDAO mapper = new Db2$2$3MappingDAO();
			isAlreadyLoaded(true);
			return mapper.get$3sBy$2(super.getId());
		}
			
	}

}
" > Db2"$2"ProxyDTO.java

#USAGE: ./generateDb2BeanProxyDTO.sh basePackage proxyBeanClassName externalBeanClassName (WARNING: DO NOT INCLUDE "DTO")