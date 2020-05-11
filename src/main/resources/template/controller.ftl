package ${package.Controller};

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import ${package.Service}.${table.serviceName};
import ${cfg.inputPackagePath}.${entity}Input;
import java.util.List;
import com.evergrande.sp.framework.client.dto.ResponseDto;
<#if restControllerStyle>
import org.springframework.web.bind.annotation.RestController;
<#else>
import org.springframework.stereotype.Controller;
</#if>
<#if superControllerClassPackage??>
import ${superControllerClassPackage};
</#if>

/**
 * <p>
 * ${table.comment!} 前端控制器
 * </p>
 *
 * @author ${author}
 * @since ${date}
 */
<#if restControllerStyle>
@RestController
<#else>
@Controller
</#if>
@RequestMapping("<#if package.ModuleName??>/${package.ModuleName}</#if>/<#if controllerMappingHyphenStyle??>${controllerMappingHyphen}<#else>${table.entityPath}</#if>")
<#if kotlin>
class ${table.controllerName}<#if superControllerClass??> : ${superControllerClass}()</#if>
<#else>
<#if superControllerClass??>
public class ${table.controllerName} extends ${superControllerClass} {
<#else>
public class ${table.controllerName} {
</#if>

    @Autowired
    private ${table.serviceName} service;

    @PostMapping("list")
    public ResponseDto list(@RequestBody ${entity}Input input) {
        return successResponseWithData(service.list(input));
    }

    @PostMapping("listAll")
    public ResponseDto listAll(@RequestBody ${entity}Input input) {
        return successResponseWithData(service.listAll(input));
    }

    @PostMapping("save")
    public ResponseDto save(@RequestBody ${entity}Input input) {
        return successResponseWithData(service.save(input));
    }

    @PostMapping("update")
    public ResponseDto update(@RequestBody ${entity}Input input) {
        return successResponseWithData(service.update(input));
    }

    @GetMapping("queryById")
    public ResponseDto queryById(@RequestParam ${cfg.pkFieldType} ${cfg.pkFieldName}) {
        return successResponseWithData(service.queryById(${cfg.pkFieldName}));
    }

    @GetMapping("deleteById")
    public ResponseDto deleteById(@RequestParam ${cfg.pkFieldType} ${cfg.pkFieldName}) {
        return successResponseWithData(service.deleteById(${cfg.pkFieldName}));
    }

    @PostMapping("batchDelete")
    public ResponseDto batchDelete(@RequestBody List<${cfg.pkFieldType}> ${cfg.pkFieldName}s) {
        return successResponseWithData(service.batchDelete(${cfg.pkFieldName}s));
    }
}
</#if>