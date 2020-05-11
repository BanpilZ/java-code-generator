package ${cfg.inputPackagePath};

<#list table.importPackages as pkg>
    <#if !pkg?contains("baomidou") && !pkg?contains("Serializable")>
import ${pkg};
    </#if>
</#list>
<#if entityLombokModel>
import lombok.*;
</#if>

/**
 * <p>
 * ${table.comment!}
 * </p>
 *
 * @author ${author}
 * @since ${date}
 */
<#if entityLombokModel>
@Data
    <#if superEntityClass??>
@EqualsAndHashCode(callSuper = true)
    <#else>
@EqualsAndHashCode(callSuper = false)
    </#if>
@Builder
@AllArgsConstructor
@NoArgsConstructor
</#if>
<#if superEntityClass??>
public class ${entity}Input extends ${superEntityClass}<#if activeRecord><${entity}></#if> {
<#elseif activeRecord>
public class ${entity}Input extends Model<${entity}> {
<#else>
public class ${entity}Input<#if entitySerialVersionUID> implements Serializable</#if> {
</#if>
<#if entitySerialVersionUID>
    private static final long serialVersionUID = 1L;
</#if>
<#if entityColumnConstant>
    <#list table.fields as field>
    public static final String ${field.name?upper_case} = "${field.name}";

    </#list>
</#if>
<#-- ----------  BEGIN 字段循环遍历  ---------->
<#list table.fields as field>
    <#if field.keyFlag>
        <#assign keyPropertyName="${field.propertyName}"/>
    </#if>

    <#if field.comment!?length gt 0>
    /**
     * ${field.comment}
     */
    </#if>
    <#-- -----   存在字段填充设置   ----->
    private ${field.propertyType} ${field.propertyName};
</#list>
<#------------  END 字段循环遍历  ---------->

<#if !entityLombokModel>
    <#list table.fields as field>
        <#if field.propertyType == "boolean">
            <#assign getprefix="is"/>
        <#else>
            <#assign getprefix="get"/>
        </#if>
    public ${field.propertyType} ${getprefix}${field.capitalName}() {
        return ${field.propertyName};
    }

    <#if entityBuilderModel>
    public ${entity}Input set${field.capitalName}(${field.propertyType} ${field.propertyName}) {
    <#else>
    public void set${field.capitalName}(${field.propertyType} ${field.propertyName}) {
    </#if>
        this.${field.propertyName} = ${field.propertyName};
        <#if entityBuilderModel>
        return this;
        </#if>
    }

    </#list>
</#if>
<#if activeRecord>
    @Override
    protected Serializable pkVal() {
    <#if keyPropertyName??>
        return this.${keyPropertyName};
    <#else>
        return null;
    </#if>
    }

</#if>
<#if !entityLombokModel>
    @Override
    public String toString() {
        return "${entity}Input{" +
    <#list table.fields as field>
        <#if field_index==0>
            "${field.propertyName}=" + ${field.propertyName} +
        <#else>
            ", ${field.propertyName}=" + ${field.propertyName} +
        </#if>
    </#list>
        "}";
    }
</#if>
}