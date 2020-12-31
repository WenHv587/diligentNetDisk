package edu.cqupt.netdisk.service.impl;

import edu.cqupt.netdisk.dao.UserFileMapper;
import edu.cqupt.netdisk.domain.UserFile;
import edu.cqupt.netdisk.service.UserFileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import java.io.File;
import java.util.List;

/**
 * @author LWenH
 * @create 2020/12/17 - 15:09
 * <p>
 * 用户文件的业务层实现类
 */
@Service
public class UserFileServiceImpl implements UserFileService {

    @Autowired
    private UserFileMapper userFileMapper;

    /**
     * 上传文件
     *
     * @param userFile
     */
    @Override
    public void uploadFile(UserFile userFile) {
        userFileMapper.addFile(userFile);
    }

    /**
     * 根据用户id查询用户所有文件
     *
     * @param userId 用户id
     * @return
     */
    @Override
    public List<UserFile> getFileByUser(Integer userId) {
        return userFileMapper.getFileByUser(userId);
    }

    /**
     * 根据用户名查找用户文件
     *
     * @param userId   用户Id
     * @param filename 文件名
     * @return
     */
    @Override
    public UserFile getFileByFilename(Integer userId, String filename) {
        return userFileMapper.getFileByFilename(userId, filename);
    }

    /**
     * 查询指定用户某个类别的文件
     *
     * @param userId
     * @param cid
     * @return
     */
    @Override
    public List<UserFile> getFileByCategory(Integer userId, Integer cid) {
        return userFileMapper.getFileByCategory(userId, cid);
    }

    /**
     * 查询所有共享文件
     *
     * @return
     */
    @Override
    public List<UserFile> getPublicFile() {
        return userFileMapper.getPublicFile();
    }

    /**
     * 共享文件
     *
     * @param fid     文件id
     * @param fstatus s_接日期字符串，表示文件分享状态以及分享时间
     */
    @Override
    public void shareFile(Integer fid, String fstatus) {
        userFileMapper.shareFile(fid, fstatus);
    }

    /**
     * 取消分享文件
     *
     * @param fid
     */
    @Override
    public void cancelShare(Integer fid) {
        userFileMapper.cancelShare(fid);
    }

    /**
     * 删除文件
     *
     * @param fid
     * @param username
     * @param filename
     */
    @Override
    public boolean deleteFile(Integer fid, String username, String filename) {
        // 在数据库中删除文件信息
        userFileMapper.deleteFile(fid);
        // 在服务端删除文件
        String path = "D:\\DeskTop\\netdisk\\" + username + "\\" + filename;
        File file = new File(path);
        return file.delete();
    }

    /**
     * 将文件放入回收站
     *
     * @param fid     文件id
     * @param fstatus d_接日期字符串，表示文件在回收站的状态以及删除时间
     */
    @Override
    public void trashFile(Integer fid, String fstatus) {
        userFileMapper.trashFile(fid, fstatus);
    }

    /**
     * 查询回收站中的文件
     *
     * @return
     */
    @Override
    public List<UserFile> getTrash(Integer userID) {
        return userFileMapper.getTrash(userID);
    }

    /**
     * 将文件从回收站里恢复
     *
     * @param fid
     */
    @Override
    public void restoreFile(Integer fid) {
        userFileMapper.restoreFile(fid);
    }

    /**
     * 修改文件名
     *
     * @param fid     文件id
     * @param newName 文件的新名称
     */
    @Override
    public void modifyFileName(Integer fid, String newName) {
        userFileMapper.modifyFileName(fid, newName);
    }

    /**
     * 根据文件id获取文件
     *
     * @param fid 文件id
     * @return
     */
    @Override
    public UserFile getFileById(Integer fid) {
        return userFileMapper.getFileById(fid);
    }

    /**
     * 计算用户文件总大小
     *
     * @param userId 用户id
     * @return
     */
    @Override
    public double getFileSizeSum(Integer userId) {
        // 根据userId查找所有的用户文件
        List<UserFile> fileList = getFileByUser(userId);
        // 遍历每个文件，计算文件大小
        double sum = 0;
        double size = 0;
        for (UserFile file : fileList) {
            // 数据库中文件大小的字符串（包括单位）
            String sizeStr = file.getFsize();
            // 除去单位以后的数字部分
            double fsize = Double.parseDouble(sizeStr.substring(0, sizeStr.length() - 3));
            System.out.println("文件大小数字部分=" + fsize);
            if (sizeStr.contains("KB")) {
                // 如果文件存储的大小单位为KB
                size = fsize / 1024;
                System.out.println(size);
            } else if (sizeStr.contains("MB")) {
                // 如果文件存储的大小单位为MB
                size = fsize;
            }
            sum += size;
        }
        return sum;
    }
}
