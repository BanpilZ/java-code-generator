package com.banpil.tool.util;

import org.apache.commons.lang3.StringUtils;

import java.io.File;
import java.util.Arrays;
import java.util.stream.Collectors;

/**
 * @Author Banpil
 * @Date 2020-5-9 15:43
 **/
public class BStringUtil {

    private BStringUtil() {
        // do nothing
    }

    /**
     * 数据库列名格式改为首字母大写的驼峰格式
     * @param fieldName 列名
     * @return
     */
    public static String db2CamelCapital(String fieldName) {
        String[] fs = fieldName.split("_");
        if (fs.length == 0) return fieldName;
        return Arrays.stream(fs).map(StringUtils::capitalize).collect(Collectors.joining());
    }

    /**
     * 类路径格式改为文件路径格式
     * @param packageRelPath
     * @return
     */
    public static String pack2File(String packageRelPath) {
        return packageRelPath.replace('.', File.separatorChar);
    }
}
