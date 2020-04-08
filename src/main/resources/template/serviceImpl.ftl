package ${package.ServiceImpl};

import ${package.Entity}.${entity};
import ${package.Service}.${table.serviceName};
<#if superServiceImplClass??>
import ${superServiceImplClassPackage};
</if>
import ${config.daoPackagePath}.${config.dapClassName};
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.beans.BeanUtils;
import java.util.List;
import com.evergrande.sp.framework.paging.PageInfo;

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
public class ${table.serviceImplName}<#if superServiceImplClass??>extends ${superServiceImplClass}</if> implements ${table.serviceName} {

    @Autowired
    private ${config.daoClassName} dao;

    @Override
    public PageInfo<${config.outputClassName}> list(${config.inputClassName} input, Integer currentPage, Integer pageSize) {
        long count = dao.count(input);
        List<${config.outputClassName}> pageList = dao.list(input, currentPage, pageSize);
        return new PageInfo<>(currentPage, pageSize, count, pageList);
    }

    @Override
    public List<${config.outputClassName}> listAll(${config.inputClassName} input) {
        return dao.listAll(input);
    }

    @Override
    @Transactional
    public int save(${config.inputClassName} input) {
        return dao.save(input);
    }

    @Override
    @Transactional
    public int update(${config.inputClassName} input) {
        return dao.update(input);
    }

    @Override
    public ${config.outputClassName} queryById(${config.pkFieldType} ${config.pkFieldName}) {
        return dao.queryById(${config.pkFieldName});
    }

    @Override
    @Transactional
    public int deleteById(${config.pkFieldType} ${config.pkFieldName}) {
        return dao.deleteById(${config.pkFieldName});
    }

    @Override
    @Transactional
    public int batchDelete(List<${config.pkFieldType}> ${config.pkFieldName}s) {
        return dao.batchDelete(${config.pkFieldName}s);
    }
}
</#if>