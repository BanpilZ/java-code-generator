package ${package.Service};

import ${cfg.inputPackagePath}.${entity}Input;
import ${cfg.outputPackagePath}.${entity}Output;
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
public interface ${table.serviceName} {

    PageInfo<${entity}Output> list(${entity}Input input);

    List<${entity}Output> listAll(${entity}Input input);

    int save(${entity}Input input);

    int update(${entity}Input input);

    ${entity}Output queryById(${cfg.pkFieldType} ${cfg.pkFieldName});

    int deleteById(${cfg.pkFieldType} ${cfg.pkFieldName});

    int batchDelete(List<${cfg.pkFieldType}> ${cfg.pkFieldName}s);
}