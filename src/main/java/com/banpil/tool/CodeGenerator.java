package com.banpil.tool;

import com.banpil.tool.config.CodeGeneratorConfig;
import com.baomidou.mybatisplus.annotation.DbType;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.core.toolkit.StringPool;
import com.baomidou.mybatisplus.generator.AutoGenerator;
import com.baomidou.mybatisplus.generator.InjectionConfig;
import com.baomidou.mybatisplus.generator.config.*;
import com.baomidou.mybatisplus.generator.config.po.TableField;
import com.baomidou.mybatisplus.generator.config.po.TableInfo;
import com.baomidou.mybatisplus.generator.config.rules.NamingStrategy;
import com.baomidou.mybatisplus.generator.engine.FreemarkerTemplateEngine;
import com.google.common.base.Joiner;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.jdbc.DataSourceProperties;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

        if (codeGeneratorConfig.isGenerateMapper()) {
            // todo 和mybatis-generator合并

        }

        String packagePath = codeGeneratorConfig.getModuleAbsPath() + File.separatorChar + codeGeneratorConfig.getPackageRelPath();
        String[] tables = codeGeneratorConfig.getTables().split(",");

        // 全局配置
        GlobalConfig globalConfig = new GlobalConfig();
        globalConfig.setActiveRecord(true)
                .setAuthor("Banpil")
                .setOutputDir(packagePath)
//                .setEnableCache(false)
//                .setBaseColumnList(false)
                .setIdType(IdType.AUTO)//主键类型
                .setFileOverride(codeGeneratorConfig.isOverride())
                .setEntityName("%")
                .setMapperName("%Mapper")
                .setXmlName("%Mapper")
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
        strategyConfig.setRestControllerStyle(true)
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
                .setEntitySerialVersionUID(codeGeneratorConfig.isSerialVersionUID())
                ;
        autoGenerator.setStrategy(strategyConfig);

        // 模板配置
        TemplateConfig templateConfig = new TemplateConfig();
        templateConfig.setController("template/controller.ftl")
                .setService("template/service.ftl")
                .setServiceImpl("template/serviceImpl.ftl")
//                .setXml("template/extmapper.xml.ftl")
//                .setMapper("template/extmapper.ftl")
//                .setEntity("template/entity.ftl")
        ;
        autoGenerator.setTemplate(templateConfig);
        autoGenerator.setTemplateEngine(new FreemarkerTemplateEngine());

        // 注入配置
        InjectionConfig injectionConfig = new InjectionConfig() {
            @Override
            public void initMap() {
                Map<String, Object> daoParams = new HashMap<>();
                List<TableInfo> tableInfoList = this.getConfig().getTableInfoList();
                if (CollectionUtils.isNotEmpty(tableInfoList)) {
                    tableInfoList.get(0).getFields().stream().filter(TableField::isKeyFlag).forEach(tableField -> {
                        daoParams.put("pkColumnName", tableField.getName());
                        daoParams.put("pkFieldName", tableField.getPropertyName());
                        daoParams.put("pkCapitalName", StringUtils.capitalize(tableField.getPropertyName()));
                        daoParams.put("pkFieldType", tableField.getPropertyType());
                    });
                }
                daoParams.put("daoClassName", this.getConfig().getGlobalConfig().getEntityName() + "Dao");
                daoParams.put("ExtMapperClassName", this.getConfig().getGlobalConfig().getEntityName() + "ExtMapper");
                daoParams.put("inputClassName", this.getConfig().getGlobalConfig().getEntityName() + "Input");
                daoParams.put("outputClassName", this.getConfig().getGlobalConfig().getEntityName() + "Output");
                daoParams.put("logicDeleteCapitalName", StringUtils.capitalize(this.getConfig().getStrategyConfig().getLogicDeleteFieldName()));
                this.setMap(daoParams);
            }
        };

        // 自定义文件生成
        List<CodeGeneratorConfig.ExtFileInfo> extFileInfos = codeGeneratorConfig.getExtFileInfos();
        for (CodeGeneratorConfig.ExtFileInfo extFileInfo: extFileInfos) {
            List<FileOutConfig> foc = new ArrayList<>();
            if ("input".equals(extFileInfo.getFileType())) {
                foc.add(new FileOutConfig("/template/entity.ftl") {
                    @Override
                    public String outputFile(TableInfo tableInfo) {
                        Map<String, Object> daoParams = injectionConfig.getMap();
                        daoParams.put("inputPackagePath", extFileInfo.getPackagePath());
                        return Joiner.on("").skipNulls().join(extFileInfo.getPackagePath(), File.separatorChar,
                                tableInfo.getEntityName() + "Input" + StringPool.DOT_JAVA);
                    }
                });
            }
            if ("output".equals(extFileInfo.getFileType())) {
                foc.add(new FileOutConfig("/template/entity.ftl") {
                    @Override
                    public String outputFile(TableInfo tableInfo) {
                        Map<String, Object> daoParams = injectionConfig.getMap();
                        daoParams.put("outputPackagePath", extFileInfo.getPackagePath());
                        return Joiner.on("").skipNulls().join(extFileInfo.getPackagePath(), File.separatorChar,
                                tableInfo.getEntityName() + "Output" + StringPool.DOT_JAVA);
                    }
                });
            }
            if ("extmapper".equals(extFileInfo.getFileType())) {
                foc.add(new FileOutConfig("/template/extmapper.ftl") {
                    @Override
                    public String outputFile(TableInfo tableInfo) {
                        Map<String, Object> daoParams = injectionConfig.getMap();
                        daoParams.put("extMapperPackagePath", extFileInfo.getPackagePath());
                        return Joiner.on("").skipNulls().join(extFileInfo.getPackagePath(), File.separatorChar,
                                tableInfo.getEntityName() + "ExtMapper" + StringPool.DOT_JAVA);
                    }
                });
                foc.add(new FileOutConfig("/template/extmapper.xml.ftl") {
                    @Override
                    public String outputFile(TableInfo tableInfo) {
                        return Joiner.on("").skipNulls().join(extFileInfo.getPackagePath(), File.separatorChar,
                                tableInfo.getEntityName() + "ExtMapper" + StringPool.DOT_XML);
                    }
                });
            }
            if ("dao".equals(extFileInfo.getFileType())) {
                foc.add(new FileOutConfig("/template/dao.ftl") {
                    @Override
                    public String outputFile(TableInfo tableInfo) {
                        Map<String, Object> daoParams = injectionConfig.getMap();
                        daoParams.put("daoPackagePath", extFileInfo.getPackagePath());
                        return Joiner.on("").skipNulls().join(extFileInfo.getPackagePath(), File.separatorChar,
                                tableInfo.getEntityName() + "Dao" + StringPool.DOT_JAVA);
                    }
                });
            }
            injectionConfig.setFileOutConfigList(foc);
        }
        autoGenerator.setCfg(injectionConfig);

        // 包名配置
        PackageConfig packageConfig = new PackageConfig();
        packageConfig.setParent(packagePath)
                .setController("controller")
                .setService("service")
                .setServiceImpl("service.impl")
                .setMapper("mapper")
                .setXml("mapper")
                .setEntity("mapper.entity")
        ;
        autoGenerator.setPackageInfo(packageConfig);
    }
}
