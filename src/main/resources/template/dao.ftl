package ${cfg.daoPackagePath};

import ${package.Entity}.${entity};
import ${package.Entity}.${entity}Criteria;
import ${package.Mapper}.${table.mapperName};
import ${cfg.extMapperPackagePath}.${entity}ExtMapper;
import java.util.List;
import org.springframework.stereotype.Repository;
import com.eg.egsc.framework.dao.base.BaseDao;
import org.apache.ibatis.session.RowBounds;

/**
 * <p>
 * ${table.comment!} 数据处理类
 * </p>
 *
 * @author ${author}
 * @since ${date}
 */
@Repository
public class ${entity}Dao extends BaseDao<${table.mapperName}, ${entity}ExtMapper, ${entity}> {

    @Override
    protected void setMapperClass() {
        super.setMapperClass(${table.mapperName}.class);
        super.setExtMapperClass(${entity}ExtMapper.class);
    }

    @Override
    protected void setEntityClass() {
        super.setEntityClass(${entity}.class);
    }

    public long count(${entity}Criteria example) {
        return getMapper().countByExample(example);
    }

    public List<${entity}> list(${entity}Criteria example, Integer currentPage, Integer pageSize) {
        return getMapper().selectByExampleWithRowbounds(example,
            new RowBounds((currentPage - 1) * pageSize, pageSize));
    }

    public List<${entity}> listAll(${entity}Criteria example) {
        return getMapper().selectByExample(example);
    }

    public int save(${entity} entity) {
        return getMapper().insert(entity);
    }

    public int update(${entity} entity) {
        return getMapper().updateByPrimaryKeySelective(entity);
    }

    public ${entity} queryById(${cfg.pkFieldType} ${cfg.pkFieldName}) {
        return getMapper().selectByPrimaryKey(${cfg.pkFieldName});
    }

    public int deleteById(${cfg.pkFieldType} ${cfg.pkFieldName}) {
    <#if logicDeleteFieldName??>
        ${entity} entity = new ${entity}();
        entity.set${cfg.pkCapitalName}(${cfg.pkFieldName});
        entity.set${cfg.logicDeleteCapitalName}((short) 0);
        return getMapper().updateByPrimaryKeySelective(entity);
    <#else>
        return getMapper().deleteByPrimaryKey(${cfg.pkFieldName});
    </#if>
    }

    public int batchDelete(List<${cfg.pkFieldType}> ${cfg.pkFieldName}s) {
        ${entity}Criteria example = new ${entity}Criteria();
        ${entity}Criteria.Criteria criteria = example.createCriteria();
        criteria.and${cfg.pkCapitalName}In(${cfg.pkFieldName}s);
    <#if logicDeleteFieldName??>
        ${entity} entity = new ${entity}();
        entity.set${cfg.logicDeleteCapitalName}((short) 0);
        return getMapper().updateByExampleSelective(entity, example);
    <#else>
        return getMapper().deleteByExample(example);
    </#if>
    }
}