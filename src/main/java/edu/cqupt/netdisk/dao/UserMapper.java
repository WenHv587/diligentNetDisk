package edu.cqupt.netdisk.dao;

import edu.cqupt.netdisk.domain.User;

/**
 * @author LWenH
 * @create 2020/12/13 - 14:36
 *
 * 用户的持久层接口
 */
public interface UserMapper {

    /**
     * 增加新用户
     * @param user
     */
    void addUser(User user);

    /**
     * 按用户名或查询（查询数据库中是否已经存在）
     * @param username
     * @return
     */
    User getUserByUsername(String username);

    /**
     * 按邮箱查询
     * @param email
     * @return
     */
    User getUserByEmail(String email);

    /**
     * 修改用户的身份状态（开通会员）
     * @param userId
     */
    void updateStatus(Integer userId);
}
