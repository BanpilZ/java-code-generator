package ${package.ServiceImpl};

import ${package.Entity}.${entity};
import ${package.Service}.${table.serviceName};
<#if superServiceImplClass??>
import ${superServiceImplClassPackage};
</#if>
import ${cfg.daoPackagePath}.${cfg.daoClassName};
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
public class ${table.serviceImplName}<#if superServiceImplClass??>extends ${superServiceImplClass}</#if> implements ${table.serviceName} {

    @Autowired
    private ${cfg.daoClassName} dao;

    @Override
    public PageInfo<${cfg.outputClassName}> list(${cfg.inputClassName} input, Integer currentPage, Integer pageSize) {
        long count = dao.count(input);
        List<${cfg.outputClassName}> pageList = dao.list(input, currentPage, pageSize);
        return new PageInfo<>(currentPage, pageSize, count, pageList);
    }

    @Override
    public List<${cfg.outputClassName}> listAll(${cfg.inputClassName} input) {
        return dao.listAll(input);
    }

    @Override
    @Transactional
    public int save(${cfg.inputClassName} input) {
        return dao.save(input);
    }

    @Override
    @Transactional
    public int update(${cfg.inputClassName} input) {
        return dao.update(input);
    }

    @Override
    public ${cfg.outputClassName} queryById(${cfg.pkFieldType} ${cfg.pkFieldName}) {
        return dao.queryById(${cfg.pkFieldName});
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
}
</#if>