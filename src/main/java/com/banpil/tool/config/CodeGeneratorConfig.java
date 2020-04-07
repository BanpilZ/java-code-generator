package com.banpil.tool.config;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * @Author Banpil
 * @Date 2020-4-7 15:02
 **/
@Getter
@Setter
@ConfigurationProperties("code-gen.common")
public class CodeGeneratorConfig {

    private String author = "banpil";

    private String moduleAbsPath;

    private String packageRelPath;

    private String extFiles;

    private String tables;

    private String schemaName;

    private boolean override = false;

    private boolean swagger = false;

    private boolean lombok = false;

    private boolean capitalModel = false;

    private String dbType = "mysql";

    private String logicDeleteFieldName = "delete_flag";

    private String superEntityClass;

    private String superControllerClass;

    private String superServiceClass;

    private String superServiceImplClass;

    private String superMapperClass;

    private String[] superEntityColumns;
}
