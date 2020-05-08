package ${package.Controller};

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import ${package.Service}.${table.serviceName};
import ${cfg.inputClassName}.${cfg.inputPackagePath};
<#if restControllerStyle>
import org.springframework.web.bind.annotation.RestController;
<#else>
import org.springframework.stereotype.Controller;
</#if>
<#if superControllerClassPackage??>
import ${superControllerClassPackage};
import java.util.List;
import com.evergrande.sp.framework.client.dto.ResponseDto;

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
    public ResponseDto list(@RequestBody ${cfg.inputClassName} input,
                            @RequestParam(defaultValue = 1) Integer currentPage,
                            @RequestParam(defaultValue = 10) Integer pageSize) {
        successResponseWithData(service.list(input, currentPage, pageSize));
    }

    @PostMapping("listAll")
    public ResponseDto listAll(@RequestBody ${cfg.inputClassName} input) {
        successResponseWithData(service.listAll(input));
    }

    @PostMapping("save")
    public ResponseDto save(@RequestBody ${cfg.inputClassName} input) {
        successResponseWithData(service.save(input));
    }

    @PostMapping("update")
    public ResponseDto update(@RequestBody ${cfg.inputClassName} input) {
        successResponseWithData(service.update(input));
    }

    @GetMapping("queryById")
    public ResponseDto queryById(@RequestParam ${cfg.pkFieldType} ${cfg.pkFieldName}) {
        successResponseWithData(service.queryById(id));
    }

    @GetMapping("deleteById")
    public ResponseDto deleteById(@RequestParam ${cfg.pkFieldType} ${cfg.pkFieldName}) {
        successResponseWithData(service.deleteById(id));
    }

    @PostMapping("batchDelete")
    public ResponseDto batchDelete(@RequestBody List<${cfg.pkFieldType}> ${cfg.pkFieldName}s) {
        successResponseWithData(service.batchDelete(ids));
    }

<#if superControllerClass??>
    private ResponseDto successResponseWithData(Object data) {
        return new ResponseDto(ResponseCode.SUCCESS.getCode(), data,
                        environment.getProperty(ResponseCode.SUCCESS.getCode()), true);
    }
</#if>
}
</#if>