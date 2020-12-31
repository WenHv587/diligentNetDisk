package edu.cqupt.netdisk.utils;

import edu.cqupt.netdisk.domain.UserFile;
import edu.cqupt.netdisk.service.UserFileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * @author LWenH
 * @create 2020/12/21 - 20:52
 *
 * 文件名相关的工具类
 */
@Component
public class FilenameUtils {

    @Autowired
    private UserFileService userFileService;

    private int i = 1;

    /**
     * 检验用户上传的文件，如果名称和已有的文件名称相同，则做修改操作
     *
     * @param userId 用户id
     * @param filename 每次递归修改后的文件名，传参时传入文件名即可
     * @param resourceName 最初的文件名，在此基础上做修改。
     * @return
     */
    public String checkFilename(Integer userId, String filename, String resourceName) {
        System.out.println(userFileService);
        System.out.println("此时文件名称:" + filename);
        UserFile userFile = userFileService.getFileByFilename(userId, filename);
        if (userFile != null) {
            // 如果数据库中已存在重名文件，则更改这个文件名，规则为在文件名后加(1)，(2)等
            System.out.println("===================文件名重复，需要进行修改================");
            int index = resourceName.lastIndexOf(".");
            String pre = resourceName.substring(0, index);
            System.out.println("文件真实名称：" + pre);
            String suf = resourceName.substring(index);
            System.out.println("文件后缀：" + suf);
            filename = pre + "(" + i + ")" + suf;
            System.out.println("修改后名称: " + filename);
            i++;
            filename = checkFilename(userId, filename, resourceName);
        }
        return filename;
    }
}
