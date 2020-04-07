package com.banpil.tool;

import com.banpil.tool.config.CodeGeneratorConfig;
import com.baomidou.mybatisplus.annotation.DbType;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.core.toolkit.StringPool;
import com.baomidou.mybatisplus.generator.AutoGenerator;
import com.baomidou.mybatisplus.generator.InjectionConfig;
import com.baomidou.mybatisplus.generator.config.*;
import com.baomidou.mybatisplus.generator.config.po.TableInfo;
import com.baomidou.mybatisplus.generator.config.rules.NamingStrategy;
import com.baomidou.mybatisplus.generator.engine.FreemarkerTemplateEngine;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.jdbc.DataSourceProperties;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * @Author Banpil
 * @Date 2020-4-7 15:01
 **/
public class CodeGenerator {

    @Autowired
    private CodeGeneratorConfig codeGeneratorConfig;

    @Autowired
    private DataSourceProperties dataSourceProperties;

    public void generateCode() throws IOException {

        AutoGenerator autoGenerator = new AutoGenerator();

        // todo 和mybatis-generator合并

        String packagePath = codeGeneratorConfig.getModuleAbsPath() + File.separatorChar + codeGeneratorConfig.getPackageRelPath();
        String[] tables = codeGeneratorConfig.getTables().split(",");

        // 全局配置
        GlobalConfig globalConfig = new GlobalConfig();
        globalConfig.setActiveRecord(true)
                .setAuthor(codeGeneratorConfig.getAuthor())
                .setOutputDir(packagePath)
//                .setEnableCache(false)
//                .setBaseColumnList(false)
                .setIdType(IdType.AUTO)//主键类型
                .setFileOverride(codeGeneratorConfig.isOverride())
//                .setEntityName("%")
//                .setMapperName("%ExtMapper")
//                .setXmlName("%ExtMapper")
                .setServiceName("%sService")
                .setServiceImplName("%sServiceImpl")
                .setControllerName("%sController")
                .setSwagger2(codeGeneratorConfig.isSwagger()) //是否使用Swagger
        ;
        autoGenerator.setGlobalConfig(globalConfig);

        // 数据库配置
        DataSourceConfig dataSourceConfig = new DataSourceConfig();
        dataSourceConfig.setDbType(DbType.getDbType(codeGeneratorConfig.getDbType()))
                .setUrl(dataSourceProperties.getUrl())
                .setUsername(dataSourceProperties.getUsername())
                .setPassword(dataSourceProperties.getPassword())
                .setDriverName(dataSourceProperties.getDriverClassName())
                .setSchemaName(codeGeneratorConfig.getSchemaName());
        autoGenerator.setDataSource(dataSourceConfig);

        // 数据库策略配置
        StrategyConfig strategyConfig = new StrategyConfig();
        strategyConfig
                .setCapitalMode(codeGeneratorConfig.isCapitalModel())
                .setLogicDeleteFieldName(codeGeneratorConfig.getLogicDeleteFieldName())
                .setNaming(NamingStrategy.underline_to_camel)
                .setColumnNaming(NamingStrategy.underline_to_camel)
                .setInclude(tables)
                .setEntityLombokModel(codeGeneratorConfig.isLombok()) //是否使用lombok
                .setSuperControllerClass(codeGeneratorConfig.getSuperControllerClass())
                .setSuperServiceClass(codeGeneratorConfig.getSuperServiceClass())
                .setSuperServiceImplClass(codeGeneratorConfig.getSuperServiceImplClass())
                .setSuperMapperClass(codeGeneratorConfig.getSuperMapperClass())
                .setSuperEntityClass(codeGeneratorConfig.getSuperEntityClass())
                .setSuperEntityColumns(codeGeneratorConfig.getSuperEntityColumns())
                ;
        autoGenerator.setStrategy(strategyConfig);

        // 模板配置
        TemplateConfig templateConfig = new TemplateConfig();
        templateConfig.setController("template/controller.ftl")
                .setService("template/service.ftl")
                .setServiceImpl("template/serviceImpl.ftl")
//                .setXml("template/mapper.xml.ftl")
//                .setMapper("template/mapper.ftl")
//                .setEntity("template/entity.ftl")
        ;
        autoGenerator.setTemplate(templateConfig);
        autoGenerator.setTemplateEngine(new FreemarkerTemplateEngine());

        // 注入配置
        InjectionConfig injectionConfig = new InjectionConfig() {
            @Override
            public void initMap() {
                this.setMap(getMap());
            }
        };

        // 自定义文件生成
        if (StringUtils.isNotBlank(codeGeneratorConfig.getExtFiles())) {
            List<String> extFileList = Arrays.asList(codeGeneratorConfig.getExtFiles());
            List<FileOutConfig> foc = new ArrayList<>();
            if (extFileList.contains("input")) {
                foc.add(new FileOutConfig("/template/entity.ftl") {
                    @Override
                    public String outputFile(TableInfo tableInfo) {
                        return packagePath + File.separatorChar + tableInfo.getEntityName() + "Input"
                                + StringPool.DOT_JAVA;
                    }
                });
            }
            if (extFileList.contains("output")) {
                foc.add(new FileOutConfig("/template/entity.ftl") {
                    @Override
                    public String outputFile(TableInfo tableInfo) {
                        return packagePath + File.separatorChar + tableInfo.getEntityName() + "Output"
                                + StringPool.DOT_JAVA;
                    }
                });
            }
            if (extFileList.contains("extmapper")) {
                foc.add(new FileOutConfig("/template/mapper.ftl") {
                    @Override
                    public String outputFile(TableInfo tableInfo) {
                        return packagePath + File.separatorChar + tableInfo.getEntityName() + "ExtMapper"
                                + StringPool.DOT_JAVA;
                    }
                });
                foc.add(new FileOutConfig("/template/mapper.xml.ftl") {
                    @Override
                    public String outputFile(TableInfo tableInfo) {
                        return packagePath + File.separatorChar + tableInfo.getEntityName() + "ExtMapper"
                                + StringPool.DOT_XML;
                    }
                });
            }
            injectionConfig.setFileOutConfigList(foc);
        }
        autoGenerator.setCfg(injectionConfig);

        PackageConfig packageConfig = new PackageConfig();
        packageConfig.setParent(packagePath)
                .setController("controller")
                .setService("service")
                .setServiceImpl("service.impl")
//                                .setMapper("extmapper")
//                                .setXml("extmapper")
//                                .setEntity("entity")
        ;
        autoGenerator.setPackageInfo(packageConfig);


    }
}
