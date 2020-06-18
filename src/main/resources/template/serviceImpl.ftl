package ${package.ServiceImpl};

import ${cfg.inputPackagePath}.${entity}Input;
import ${cfg.outputPackagePath}.${entity}Output;
import ${package.Entity}.${entity};
import ${package.Entity}.${entity}Criteria;
import ${package.Service}.${table.serviceName};
import ${cfg.daoPackagePath}.${entity}Dao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import org.springframework.beans.BeanUtils;
import org.apache.commons.lang.StringUtils;
import java.util.stream.Collectors;
import com.eg.egsc.framework.paging.PageInfo;
import com.eg.egsc.common.component.sequence.SequenceService;

/**
 * <p>
 * ${table.comment!} 服务实现类
 * </p>
 *
 * @author ${author}
 * @since ${date}
 */
@Service
<#if kotlin>
open class ${table.serviceImplName} : ${superServiceImplClass}<${table.mapperName}, ${entity}>(), ${table.serviceName} {

}
<#else>
public class ${table.serviceImplName} implements ${table.serviceName} {

    @Autowired
    private ${entity}Dao dao;

    @Autowired
    private SequenceService sequenceServiceImpl;

    @Override
    public PageInfo<${entity}Output> list(${entity}Input input, int currentPage, int pageSize) {
        ${entity}Criteria example = input2Example(input);
        long total = dao.count(example);
        List<${entity}Output> pageList = dao.list(example, currentPage, pageSize).stream()
            .map(entity -> {
               ${entity}Output output = new ${entity}Output();
               BeanUtils.copyProperties(entity, output);
               return output;
        }).collect(Collectors.toList());
        return new PageInfo<>(currentPage, pageSize, total, rows);
    }

    @Override
    public List<${entity}> listAll(${entity}Input input) {
        ${entity}Criteria example = input2Example(input);
        return dao.listAll(example);
    }

    @Override
    @Transactional
    public int save(${entity}Input input) {
        ${entity} entity = new ${entity}();
        BeanUtils.copyProperties(input, entity);
        entity.setUuid(sequenceServiceImpl.getUUID());
        return dao.save(entity);
    }

    @Override
    @Transactional
    public int update(${entity}Input input) {
        ${entity} entity = new ${entity}();
        BeanUtils.copyProperties(input, entity);
        return dao.update(entity);
    }

    @Override
    public ${entity}Output queryById(${cfg.pkFieldType} ${cfg.pkFieldName}) {
        ${entity} entity = dao.queryById(${cfg.pkFieldName});
        if (entity == null) return null;
        ${entity}Output output = new ${entity}Output();
        BeanUtils.copyProperties(entity, output);
        return output;
    }

    @Override
    @Transactional
    public int deleteById(${cfg.pkFieldType} ${cfg.pkFieldName}) {
        return dao.deleteById(${cfg.pkFieldName});
    }

    @Override
    @Transactional
    public int batchDelete(List<${cfg.pkFieldType}> ${cfg.pkFieldName}s) {
        return dao.batchDelete(${cfg.pkFieldName}s);
    }

    private ${entity}Criteria input2Example(${entity}Input input) {
        ${entity}Criteria example = new ${entity}Criteria();
        ${entity}Criteria.Criteria criteria = example.createCriteria();
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
</#if>