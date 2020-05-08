package ${package.Service};

import ${cfg.inputClassName}.${cfg.inputPackagePath};
import ${cfg.outputClassName}.${cfg.outputPackagePath};
import com.evergrande.sp.framework.paging.PageInfo;
import java.util.List;

/**
 * <p>
 * ${table.comment!} 服务接口
 * </p>
 *
 * @author ${author}
 * @since ${date}
 */
public interface ${table.serviceName}<#if superServiceClass??> extends ${superServiceClass}</#if> {

    PageInfo<${cfg.outputClassName}> list(${cfg.inputClassName} input, Integer currentPage, Integer pageSize);

    List<${cfg.outputClassName}> listAll(${cfg.inputClassName} input);

    int save(${cfg.inputClassName} input);

    int update(${cfg.inputClassName} input);

    ${cfg.outputClassName} queryById(${cfg.pkFieldType} ${cfg.pkFieldName});

    int deleteById(${cfg.pkFieldType} ${cfg.pkFieldName});

    int batchDelete(List<${cfg.pkFieldType}> ${cfg.pkFieldName}s);
}