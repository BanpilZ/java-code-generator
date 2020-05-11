package com.banpil.tool.config;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * @Author Banpil
 * @Date 2020-4-7 15:02
 **/
@Getter
@Setter
@Component
@ConfigurationProperties("code-gen.common")
public class CodeGeneratorConfig {

    //service模块项目路径
    private String projectPath;

    //类路径
    private String packageRelPath;

    private String author = "Banpil";

    //自定义文件
    private List<ExtFileInfo> extFileInfos;

    //表名，逗号分隔
    private String tables;

    //库名
    private String schemaName;

    //需要去掉的表前缀
    private String tablePrefix;

    //是否生成swagger注解
    private boolean swagger = false;

    //是否生成lombok注解
    private boolean lombok = false;

    //表字段是否大写命名
    private boolean capitalModel = false;

    //是否生成序列化id
    private boolean serialVersionUID = false;

    //生成后是否打开文件夹
    private boolean open = false;

    //是否生成字段注解
    private boolean entityTableFieldAnnotationEnable = false;

    //是否覆盖
    private boolean override = false;

    //是否打开activeRecord
    private boolean activeRecord = false;

    //数据库类型
    private String dbType;

    //逻辑删除标识位
    private String logicDeleteFieldName;

    //实体类父类
    private String superEntityClass;

    //自定义controller父类
    private String superControllerClass;

    //自定义service接口父类
    private String superServiceClass;

    //自定义service实现类父类
    private String superServiceImplClass;

    //自定义mapper父类
    private String superMapperClass;

    //自定义基础的Entity类，公共字段
    private String[] superEntityColumns;

    @Getter
    @Setter
    public static class ExtFileInfo {

        //目前支持dao,extmapper,input,output
        private String fileType;

        //自定义文件路径
        private String projectPath;

        //自定义类路径
        private String packageRelPath;
    }
}
