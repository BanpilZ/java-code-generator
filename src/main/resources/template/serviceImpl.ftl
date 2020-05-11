package ${package.ServiceImpl};

import ${cfg.inputPackagePath}.${entity}Input;
import ${cfg.outputPackagePath}.${entity}Output;
import ${package.Service}.${table.serviceName};
import ${cfg.daoPackagePath}.${entity}Dao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
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
public class ${table.serviceImplName} implements ${table.serviceName} {

    @Autowired
    private ${entity}Dao dao;

    @Override
    public PageInfo<${entity}Output> list(${entity}Input input) {
        long count = dao.count(input);
        int currentPage = input.getCurrentPage();
        int pageSize = input.getPageSize();
        List<${entity}Output> pageList = dao.list(input, currentPage, pageSize);
        return new PageInfo<>(currentPage, pageSize, count, pageList);
    }

    @Override
    public List<${entity}Output> listAll(${entity}Input input) {
        return dao.listAll(input);
    }

    @Override
    @Transactional
    public int save(${entity}Input input) {
        return dao.save(input);
    }

    @Override
    @Transactional
    public int update(${entity}Input input) {
        return dao.update(input);
    }

    @Override
    public ${entity}Output queryById(${cfg.pkFieldType} ${cfg.pkFieldName}) {
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