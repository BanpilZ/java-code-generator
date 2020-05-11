package com.banpil.tool;

import com.banpil.tool.config.CodeGeneratorConfig;
import com.banpil.tool.util.BStringUtil;
import com.baomidou.mybatisplus.annotation.DbType;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.core.toolkit.StringPool;
import com.baomidou.mybatisplus.generator.AutoGenerator;
import com.baomidou.mybatisplus.generator.InjectionConfig;
import com.baomidou.mybatisplus.generator.config.*;
import com.baomidou.mybatisplus.generator.config.po.TableField;
import com.baomidou.mybatisplus.generator.config.po.TableInfo;
import com.baomidou.mybatisplus.generator.config.rules.DateType;
import com.baomidou.mybatisplus.generator.config.rules.NamingStrategy;
import com.baomidou.mybatisplus.generator.engine.FreemarkerTemplateEngine;
import com.google.common.base.Joiner;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugins.annotations.LifecyclePhase;
import org.apache.maven.plugins.annotations.Mojo;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.jdbc.DataSourceProperties;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.stereotype.Component;
import org.springframework.test.context.junit4.SpringRunner;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author Banpil
 * @Date 2020-4-7 15:01
 **/
@Component
@Mojo(name = "generate", defaultPhase = LifecyclePhase.COMPILE)
@RunWith(SpringRunner.class)
@SpringBootTest
public class CodeGenerator extends AbstractMojo {

    @Autowired
    private CodeGeneratorConfig codeGeneratorConfig;

    @Autowired
    private DataSourceProperties dataSourceProperties;

    @Test
    @Override
    public void execute() throws MojoExecutionException {
        AutoGenerator autoGenerator = new AutoGenerator();
        // 项目路径
        String projectPath = codeGeneratorConfig.getProjectPath();
        // 要生成的表
        String[] tables = codeGeneratorConfig.getTables().split(",");

        // 全局配置
        GlobalConfig globalConfig = new GlobalConfig();
        globalConfig.setActiveRecord(codeGeneratorConfig.isActiveRecord())
                .setOpen(codeGeneratorConfig.isOpen()) // 执行完后是否打开目录
                .setAuthor(codeGeneratorConfig.getAuthor())
                .setOutputDir(projectPath)
//                .setEnableCache(false)
//                .setBaseColumnList(false)
                .setIdType(IdType.AUTO) //主键类型-自增
                .setDateType(DateType.ONLY_DATE) //日期类型-java.util.Date
                .setFileOverride(codeGeneratorConfig.isOverride()) // 是否覆盖
                .setEntityName("%s")
                .setMapperName("%sMapper")
                .setXmlName("%sMapper")
                .setServiceName("%sService")
                .setServiceImplName("%sServiceImpl")
                .setControllerName("%sController")
                .setSwagger2(codeGeneratorConfig.isSwagger()) //是否使用Swagger
        ;
        autoGenerator.setGlobalConfig(globalConfig);
        getLog().info("set global config...");

        // 数据库配置
        DataSourceConfig dataSourceConfig = new DataSourceConfig();
        dataSourceConfig.setDbType(DbType.getDbType(codeGeneratorConfig.getDbType()))
                .setUrl(dataSourceProperties.getUrl())
                .setUsername(dataSourceProperties.getUsername())
                .setPassword(dataSourceProperties.getPassword())
                .setDriverName(dataSourceProperties.getDriverClassName())
                .setSchemaName(codeGeneratorConfig.getSchemaName());
        autoGenerator.setDataSource(dataSourceConfig);
        getLog().info("set dataSource config...");

        // 数据库策略配置
        StrategyConfig strategyConfig = new StrategyConfig();
        strategyConfig.setRestControllerStyle(true)
                .setCapitalMode(codeGeneratorConfig.isCapitalModel()) //是否大写命名
                .setLogicDeleteFieldName(codeGeneratorConfig.getLogicDeleteFieldName()) //逻辑删除标识位
                .setNaming(NamingStrategy.underline_to_camel) //下划线转驼峰
                .setInclude(tables)
                .setTablePrefix(codeGeneratorConfig.getTablePrefix()) //表名前缀
                .setEntityTableFieldAnnotationEnable(codeGeneratorConfig.isEntityTableFieldAnnotationEnable()) //是否生成字段注解
                .setEntityLombokModel(codeGeneratorConfig.isLombok()) //是否使用lombok
                .setSuperControllerClass(codeGeneratorConfig.getSuperControllerClass())
                .setSuperServiceClass(codeGeneratorConfig.getSuperServiceClass())
                .setSuperServiceImplClass(codeGeneratorConfig.getSuperServiceImplClass())
                .setSuperMapperClass(codeGeneratorConfig.getSuperMapperClass())
                .setSuperEntityClass(codeGeneratorConfig.getSuperEntityClass())
                .setSuperEntityColumns(codeGeneratorConfig.getSuperEntityColumns())
                .setEntitySerialVersionUID(codeGeneratorConfig.isSerialVersionUID()) //是否实现java.io.Serializable
                ;
        autoGenerator.setStrategy(strategyConfig);
        getLog().info("set strategy config...");

        // 注入配置
        Map<String, Object> daoParams = new HashMap<>();
        InjectionConfig injectionConfig = new InjectionConfig() {
            @Override
            public void initMap() {
                List<TableInfo> tableInfoList = this.getConfig().getTableInfoList();
                if (CollectionUtils.isNotEmpty(tableInfoList)) {
                    // 主键名称
                    tableInfoList.get(0).getFields().stream().filter(TableField::isKeyFlag).forEach(tableField -> {
                        daoParams.put("pkColumnName", tableField.getName()); //主键列名
                        daoParams.put("pkFieldName", tableField.getPropertyName()); //主键字段名
                        daoParams.put("pkCapitalName", StringUtils.capitalize(tableField.getPropertyName())); //主键字段名首字母大写
                        daoParams.put("pkFieldType", tableField.getPropertyType()); //主键java类型
                    });
                }
                if (StringUtils.isNotEmpty(codeGeneratorConfig.getLogicDeleteFieldName())) { // 逻辑删除标识位
                    daoParams.put("logicDeleteCapitalName", BStringUtil.db2CamelCapital(codeGeneratorConfig.getLogicDeleteFieldName()));
                }
                this.setMap(daoParams);
            }
        };
        getLog().info("set injection config...");

        // 自定义文件生成
        List<CodeGeneratorConfig.ExtFileInfo> extFileInfos = codeGeneratorConfig.getExtFileInfos();
        List<FileOutConfig> foc = new ArrayList<>();
        for (CodeGeneratorConfig.ExtFileInfo extFileInfo: extFileInfos) {
            String filePath = Joiner.on("").skipNulls().join(extFileInfo.getProjectPath(), File.separatorChar,
                    BStringUtil.pack2File(extFileInfo.getPackageRelPath()), File.separatorChar);
            if ("input".equals(extFileInfo.getFileType())) {
                daoParams.put("inputPackagePath", extFileInfo.getPackageRelPath());
                foc.add(new FileOutConfig("/template/input.ftl") {
                    @Override
                    public String outputFile(TableInfo tableInfo) {
                        return Joiner.on("").skipNulls().join(filePath, tableInfo.getEntityName() + "Input" + StringPool.DOT_JAVA);
                    }
                });
            }
            if ("output".equals(extFileInfo.getFileType())) {
                daoParams.put("outputPackagePath", extFileInfo.getPackageRelPath());
                foc.add(new FileOutConfig("/template/output.ftl") {
                    @Override
                    public String outputFile(TableInfo tableInfo) {
                        return Joiner.on("").skipNulls().join(filePath, tableInfo.getEntityName() + "Output" + StringPool.DOT_JAVA);
                    }
                });
            }
            if ("extmapper".equals(extFileInfo.getFileType())) {
                daoParams.put("extMapperPackagePath", extFileInfo.getPackageRelPath());
                foc.add(new FileOutConfig("/template/extmapper.ftl") {
                    @Override
                    public String outputFile(TableInfo tableInfo) {
                        return Joiner.on("").skipNulls().join(filePath, tableInfo.getEntityName() + "ExtMapper" + StringPool.DOT_JAVA);
                    }
                });
                foc.add(new FileOutConfig("/template/extmapper.xml.ftl") {
                    @Override
                    public String outputFile(TableInfo tableInfo) {
                        return Joiner.on("").skipNulls().join(filePath, tableInfo.getEntityName() + "ExtMapper" + StringPool.DOT_XML);
                    }
                });
            }
            if ("dao".equals(extFileInfo.getFileType())) {
                daoParams.put("daoPackagePath", extFileInfo.getPackageRelPath());
                foc.add(new FileOutConfig("/template/dao.ftl") {
                    @Override
                    public String outputFile(TableInfo tableInfo) {
                        return Joiner.on("").skipNulls().join(filePath, tableInfo.getEntityName() + "Dao" + StringPool.DOT_JAVA);
                    }
                });
            }
        }
        injectionConfig.setFileOutConfigList(foc);
        autoGenerator.setCfg(injectionConfig);
        getLog().info("set fileOut config...");

        // 包名配置
        PackageConfig packageConfig = new PackageConfig();
        packageConfig.setParent(codeGeneratorConfig.getPackageRelPath())
                .setController("controller")
                .setService("service")
                .setServiceImpl("service.impl")
//                .setMapper("mapper")
//                .setXml("mapper")
                .setEntity("mapper.entity")
        ;
        autoGenerator.setPackageInfo(packageConfig);
        getLog().info("set package config...");

        // 模板配置
        TemplateConfig templateConfig = new TemplateConfig();
        templateConfig.setController("template/controller")
                .setService("template/service")
                .setServiceImpl("template/serviceImpl")
                .setXml(null) // 因为有默认值，设置成null表示不生成，下同
                .setMapper(null)
                .setEntity(null)
        ;
        autoGenerator.setTemplate(templateConfig);
        // 模板引擎Freemarker
        autoGenerator.setTemplateEngine(new FreemarkerTemplateEngine());
        getLog().info("set template config...");

        autoGenerator.execute();
        getLog().info("generate package end...");
    }
}
