package ${package.Service};

import ${config.inputClassName}.${config.inputPackagePath};
import ${config.outputClassName}.${config.outputPackagePath};
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
public interface ${table.serviceName}<#if superServiceClass??> extends ${superServiceClass}</if> {

    PageInfo<${config.outputClassName}> list(${config.inputClassName} input, Integer currentPage, Integer pageSize);

    List<${config.outputClassName}> listAll(${config.inputClassName} input);

    int save(${config.inputClassName} input);

    int update(${config.inputClassName} input);

    ${config.outputClassName} queryById(${config.pkFieldType} ${config.pkFieldName});

    int deleteById(${config.pkFieldType} ${config.pkFieldName});

    int batchDelete(List<${config.pkFieldType}> ${config.pkFieldName}s);
}