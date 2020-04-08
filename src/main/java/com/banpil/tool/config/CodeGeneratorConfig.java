package com.banpil.tool.config;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;

import java.util.List;

/**
 * @Author Banpil
 * @Date 2020-4-7 15:02
 **/
@Getter
@Setter
@ConfigurationProperties("code-gen.common")
public class CodeGeneratorConfig {

    private String moduleAbsPath;

    private String packageRelPath;

    private List<ExtFileInfo> extFileInfos;

    private String tables;

    private String schemaName;

    private boolean override = true;

    private boolean swagger = false;

    private boolean lombok = false;

    private boolean capitalModel = false;

    private boolean serialVersionUID = false;

    private boolean generateMapper = false;

    private String dbType;

    private String logicDeleteFieldName;

    private String superEntityClass;

    private String superControllerClass;

    private String superServiceClass;

    private String superServiceImplClass;

    private String superMapperClass;

    private String[] superEntityColumns;

    @Getter
    @Setter
    public class ExtFileInfo {

        private String fileType;

        private String packagePath;

    }
}
