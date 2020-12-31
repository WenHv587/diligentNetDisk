package edu.cqupt.netdisk.domain;

import java.io.Serializable;

/**
 * @author LWenH
 * @create 2020/12/13 - 14:21
 *
 * 用户的实体类
 */
public class User implements Serializable {
    /**
     * 用户的ID
     */
    private Integer userId;
    /**
     * 用户名称
     */
    private String username;
    /**
     * 用户密码
     */
    private String password;
    /**
     * 用户邮箱
     */
    private String email;
    /**
     * 用户状态
     * 0代表非会员，1代表会员
     */
    private int status;

    public User() {
    }

    public User(Integer userId, String username, String password, String email, int status) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.email = email;
        this.status = status;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", username='" + username + '\'' +
                ", password='" + password + '\'' +
                ", eamil='" + email + '\'' +
                ", status=" + status +
                '}';
    }
}
