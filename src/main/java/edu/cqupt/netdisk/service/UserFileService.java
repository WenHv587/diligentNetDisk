package edu.cqupt.netdisk.service;

import edu.cqupt.netdisk.domain.UserFile;

import java.util.List;

/**
 * @author LWenH
 * @create 2020/12/17 - 15:08
 */
public interface UserFileService {
    /**
     * 上传文件
     *
     * @param userFile
     */
    void uploadFile(UserFile userFile);

    /**
     * 根据用户id查询用户所有文件
     *
     * @param userId
     * @return
     */
    List<UserFile> getFileByUser(Integer userId);

    /**
     * 根据文件名查找用户文件
     *
     * @param userId   用户Id
     * @param filename 文件名
     * @return
     */
    UserFile getFileByFilename(Integer userId, String filename);

    /**
     * 查询指定用户某个类别的文件
     *
     * @param userId
     * @param cid
     * @return
     */
    List<UserFile> getFileByCategory(Integer userId, Integer cid);

    /**
     * 查询共享文件
     *
     * @return
     */
    List<UserFile> getPublicFile();

    /**
     * 共享文件
     *
     * @param fid     文件id
     * @param fstatus s_接日期字符串，表示文件分享状态以及分享时间
     */
    void shareFile(Integer fid, String fstatus);

    /**
     * 取消分享
     *
     * @param fid
     */
    void cancelShare(Integer fid);

    /**
     * 删除文件
     *
     * @param fid
     */
    boolean deleteFile(Integer fid, String username, String filename);

    /**
     * 将文件放入回收站
     *
     * @param fid     文件id
     * @param fstatus d_接日期字符串，表示文件在回收站的状态以及删除时间
     */
    void trashFile(Integer fid, String fstatus);

    /**
     * 查询用户回收站中的文件
     *
     * @return
     */
    List<UserFile> getTrash(Integer userID);

    /**
     * 将文件从回收站中恢复
     *
     * @param fid
     */
    void restoreFile(Integer fid);

    /**
     * 修改文件名称
     *
     * @param fid     文件id
     * @param newName 文件的新名称
     */
    void modifyFileName(Integer fid, String newName);

    /**
     * 根据文件id获取文件
     *
     * @param fid 文件id
     * @return
     */
    UserFile getFileById(Integer fid);

    /**
     * 计算用户文件总大小
     *
     * @param userId
     * @return
     */
    double getFileSizeSum(Integer userId);
}
