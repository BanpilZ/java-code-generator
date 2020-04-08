package ${config.daoPackagePath};

import ${package.Entity}.${entity};
import ${package.Entity}.${entity}Example;
import ${package.Mapper}.${table.mapperName};
import ${config.extMapperPackagePath};
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
<#else>
public class ${config.daoClassName} extends BaseDao<${table.mapperName}, ${config.extMapperClassName}, ${entity}> {

    @Override
    protected void setMapperClass() {
        super.setMapperClass(${table.mapperName}.class);
        super.setExtMapperClass(${config.extMapperClassName}.class);
    }

    @Override
    protected void setEntityClass() {
        super.setEntityClass(${entity}.class);
    }

    public long count(${config.inputClassName} input) {
        return getMapper().count(input2Example(input));
    }

    public List<${config.outputClassName}> list(${config.inputClassName} input, Integer currentPage, Integer pageSize) {
        List<${entity}> entityList = getMapper().selectByExampleWithRowbounds(input2Example(input),
            new RowBounds((currentPage - 1) * pageSize, pageSize));
        return entityList.stream().map(entity -> {
            ${config.outputClassName} output = new ${config.outputClassName}();
            BeanUtils.copyProperties(entity, output);
            return output;
        }).collect(Collectors.toList();
    }

    public List<${config.outputClassName}> listAll(${config.inputClassName} input) {
        List<${entity}> entityList = getMapper().selectByExample(input2Example(input));
        return entityList.stream().map(entity -> {
            ${config.outputClassName} output = new ${config.outputClassName}();
            BeanUtils.copyProperties(entity, output);
            return output;
        }).collect(Collectors.toList();
    }

    public int save(${config.inputClassName} input) {
        ${entity} entity = new ${entity}();
        BeanUtils.copyProperties(input, entity);
        return getMapper().insert(entity);
    }

    public int update(${config.inputClassName} input) {
        ${entity} entity = new ${entity}();
        BeanUtils.copyProperties(input, entity);
        return getMapper().updateByPrimaryKeySelective(entity);
    }

    public ${config.outputClassName} queryById(${config.pkFieldType} ${config.pkFieldName}) {
        ${config.outputClassName} output = new ${config.outputClassName}();
        BeanUtils.copyProperties(getMapper().selectByPrimaryKey(${config.pkFieldName}), output);
        return output;
    }

    public int deleteById(${config.pkFieldType} ${config.pkFieldName}) {
    <#if logicDeleteFieldName??>
        ${entity} entity = new ${entity}();
        entity.set${config.pkCapitalName}(${config.pkFieldName});
        entity.set${config.logicDeleteCapitalName}(1);
        return getMapper().updateByPrimaryKeySelective(entity);
    </#elseif>
        return getMapper().deleteByPrimaryKey(${config.pkFieldName});
    </#if>
    }

    public int batchDelete(List<${config.pkFieldType}> ${config.pkFieldName}s) {
        ${entity}Example example = new ${entity}Example();
        ${entity}Example.Criteria criteria = example.createCriteria();
        criteria.and${config.pkCapitalName}In(${config.pkFieldName}s);
    <#if logicDeleteFieldName??>
        ${entity} entity = new ${entity}();
        entity.set${config.logicDeleteCapitalName}(1);
        return getMapper().updateByExampleSelective(entity, example);
    </#elseif>
        return getMapper().deleteByExample(example);
    </#if>
    }

    private ${entity}Example input2Example(${config.inputClassName} input) {
        ${entity}Example example = new ${entity}Example();
        ${entity}Example.Criteria criteria = example.createCriteria();
<#list table.fields as field>
    <#if field.propertyType == "String">
        if (StringUtils.isNotBlank(input.get${field.capitalName}())) {
            criteria.and${field.capitalName}EqualTo(input.get${field.capitalName}());
        }
    </#elseif>
        if (input.get${field.capitalName}() != null) {
            criteria.and${field.capitalName}EqualTo(input.get${field.capitalName}());
        }
    </#if>
</#list>
        return example;
    }
}
</#if>