package edu.cqupt.netdisk.utils;

import org.jodconverter.OfficeDocumentConverter;
import org.jodconverter.office.DefaultOfficeManagerBuilder;
import org.jodconverter.office.OfficeException;
import org.jodconverter.office.OfficeManager;
import org.springframework.stereotype.Component;

import java.io.File;

/**
 * @author LWenH
 * @create 2021/1/22 - 18:34
 *
 * 预览文件需要用到的工具类
 */
@Component
public class PreviewUtils {

    /**
     * 将文件转换为pdf格式以预览
     * @param sourceFile
     * @param targetFile
     * @throws OfficeException
     */
    public void doc2pdf(File sourceFile, File targetFile) throws OfficeException {
        OfficeManager officeManager = getOfficeManger();
        OfficeDocumentConverter converter = new OfficeDocumentConverter(officeManager);
        converter.convert(sourceFile,targetFile);
        System.out.println(targetFile.getPath());
        System.out.println("文件转换成功");
    }

    private OfficeManager getOfficeManger() {
        DefaultOfficeManagerBuilder builder = new DefaultOfficeManagerBuilder();
        builder.setOfficeHome("C:\\Program Files (x86)\\OpenOffice 4");
        OfficeManager officeManager = builder.build();
        try {
            officeManager.start();
        } catch (OfficeException e) {
            e.printStackTrace();
        }
        return officeManager;
    }
}
