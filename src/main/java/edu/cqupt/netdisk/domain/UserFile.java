package edu.cqupt.netdisk.domain;

import java.util.Date;

/**
 * @author LWenH
 * @create 2020/12/17 - 14:40
 *
 * 文件的实体类
 */
public class UserFile {
    /**
     * 文件id
     */
    private Integer fid;
    /**
     * 文件名称
     */
    private String fname;
    /**
     * 文件大小
     */
    private String fsize;
    /**
     * 文件上传时间
     */
    private String fuploadtime;
    /**
     * 文件状态
     * 0代表个人文件，也就是最普通的文件
     * s_开头代表共享文件，后面会接上时间字符串，用于显示共享的时间
     * d_开头代表回收站文件，后面会接上时间字符串，用于显示删除时间
     */
    private String fstatus;
    /**
     * 文件的类别
     */
    private Category category;
    /**
     * 文件的上传者
     */
    private User user;

    public Integer getFid() {
        return fid;
    }

    public void setFid(Integer fid) {
        this.fid = fid;
    }

    public String getFname() {
        return fname;
    }

    public void setFname(String fname) {
        this.fname = fname;
    }

    public String getFsize() {
        return fsize;
    }

    public void setFsize(String fsize) {
        this.fsize = fsize;
    }

    public String getFuploadtime() {
        return fuploadtime;
    }

    public void setFuploadtime(String fuploadtime) {
        this.fuploadtime = fuploadtime;
    }

    public String getFstatus() {
        return fstatus;
    }

    public void setFstatus(String fstatus) {
        this.fstatus = fstatus;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    @Override
    public String toString() {
        return "UserFile{" +
                "fid=" + fid +
                ", fname='" + fname + '\'' +
                ", fsize='" + fsize + '\'' +
                ", fuploadtime='" + fuploadtime + '\'' +
                ", fstatus='" + fstatus + '\'' +
                ", category=" + category +
                ", user=" + user +
                '}';
    }
}
