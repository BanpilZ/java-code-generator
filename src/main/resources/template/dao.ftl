package ${cfg.daoPackagePath};

import ${package.Entity}.${entity};
import ${package.Entity}.${entity}Example;
import ${package.Mapper}.${table.mapperName};
import ${cfg.extMapperPackagePath};
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.evergrande.sp.framework.dao.base.BaseDao;
import org.apache.commons.lang.StringUtils;
import org.apache.ibatis.session.RowBounds;
import org.springframework.beans.BeanUtils;

/**
 * <p>
 * ${table.comment!} 数据处理类
 * </p>
 *
 * @author ${author}
 * @since ${date}
 */
@Repository
public class ${cfg.daoClassName} extends BaseDao<${table.mapperName}, ${cfg.extMapperClassName}, ${entity}> {

    @Override
    protected void setMapperClass() {
        super.setMapperClass(${table.mapperName}.class);
        super.setExtMapperClass(${cfg.extMapperClassName}.class);
    }

    @Override
    protected void setEntityClass() {
        super.setEntityClass(${entity}.class);
    }

    public long count(${cfg.inputClassName} input) {
        return getMapper().count(input2Example(input));
    }

    public List<${cfg.outputClassName}> list(${cfg.inputClassName} input, Integer currentPage, Integer pageSize) {
        List<${entity}> entityList = getMapper().selectByExampleWithRowbounds(input2Example(input),
            new RowBounds((currentPage - 1) * pageSize, pageSize));
        return entityList.stream().map(entity -> {
            ${cfg.outputClassName} output = new ${cfg.outputClassName}();
            BeanUtils.copyProperties(entity, output);
            return output;
        }).collect(Collectors.toList();
    }

    public List<${cfg.outputClassName}> listAll(${cfg.inputClassName} input) {
        List<${entity}> entityList = getMapper().selectByExample(input2Example(input));
        return entityList.stream().map(entity -> {
            ${cfg.outputClassName} output = new ${cfg.outputClassName}();
            BeanUtils.copyProperties(entity, output);
            return output;
        }).collect(Collectors.toList();
    }

    public int save(${cfg.inputClassName} input) {
        ${entity} entity = new ${entity}();
        BeanUtils.copyProperties(input, entity);
        return getMapper().insert(entity);
    }

    public int update(${cfg.inputClassName} input) {
        ${entity} entity = new ${entity}();
        BeanUtils.copyProperties(input, entity);
        return getMapper().updateByPrimaryKeySelective(entity);
    }

    public ${cfg.outputClassName} queryById(${cfg.pkFieldType} ${cfg.pkFieldName}) {
        ${cfg.outputClassName} output = new ${cfg.outputClassName}();
        BeanUtils.copyProperties(getMapper().selectByPrimaryKey(${cfg.pkFieldName}), output);
        return output;
    }

    public int deleteById(${cfg.pkFieldType} ${cfg.pkFieldName}) {
    <#if logicDeleteFieldName??>
        ${entity} entity = new ${entity}();
        entity.set${cfg.pkCapitalName}(${cfg.pkFieldName});
        entity.set${cfg.logicDeleteCapitalName}(1);
        return getMapper().updateByPrimaryKeySelective(entity);
    <#else>
        return getMapper().deleteByPrimaryKey(${cfg.pkFieldName});
    </#if>
    }

    public int batchDelete(List<${cfg.pkFieldType}> ${cfg.pkFieldName}s) {
        ${entity}Example example = new ${entity}Example();
        ${entity}Example.Criteria criteria = example.createCriteria();
        criteria.and${cfg.pkCapitalName}In(${cfg.pkFieldName}s);
    <#if logicDeleteFieldName??>
        ${entity} entity = new ${entity}();
        entity.set${cfg.logicDeleteCapitalName}(1);
        return getMapper().updateByExampleSelective(entity, example);
    <#else>
        return getMapper().deleteByExample(example);
    </#if>
    }

    private ${entity}Example input2Example(${cfg.inputClassName} input) {
        ${entity}Example example = new ${entity}Example();
        ${entity}Example.Criteria criteria = example.createCriteria();
<#list table.fields as field>
    <#if field.propertyType == "String">
        if (StringUtils.isNotBlank(input.get${field.capitalName}())) {
            criteria.and${field.capitalName}EqualTo(input.get${field.capitalName}());
        }
    <#else>
        if (input.get${field.capitalName}() != null) {
            criteria.and${field.capitalName}EqualTo(input.get${field.capitalName}());
        }
    </#if>
</#list>
        return example;
    }
}