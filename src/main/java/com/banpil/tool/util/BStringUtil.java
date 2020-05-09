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


    public static String db2CamelCapital(String fieldName) {
        String[] fs = fieldName.split("_");
        if (fs.length == 0) return fieldName;
        return Arrays.stream(fs).map(StringUtils::capitalize).collect(Collectors.joining());
    }

    public static String pack2File(String packageRelPath) {
        return packageRelPath.replace('.', File.separatorChar);
    }
}
