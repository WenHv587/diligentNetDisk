package edu.cqupt.netdisk.service;

import edu.cqupt.netdisk.domain.User;
import edu.cqupt.netdisk.exception.UserException;

/**
 * @author LWenH
 * @create 2020/12/13 - 17:28
 */
public interface UserService {
    /**
     * 注册功能
     *
     * @param form
     */
    void regist(User form) throws UserException;

    /**
     * 登录功能
     *
     * @param form
     * @throws UserException
     */
    User login(User form) throws UserException;

    /**
     * 开通会员
     * @param userId
     */
    void openVip(Integer userId);
}
