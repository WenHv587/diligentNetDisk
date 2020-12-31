package edu.cqupt.netdisk.service.impl;

import edu.cqupt.netdisk.dao.UserMapper;
import edu.cqupt.netdisk.domain.User;
import edu.cqupt.netdisk.exception.UserException;
import edu.cqupt.netdisk.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author LWenH
 * @create 2020/12/13 - 17:28
 */
@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserMapper userMapper;

    /**
     * 登陆功能
     *
     * @param form
     * @throws UserException
     */
    @Override
    public User login(User form) throws UserException {
        /*
            校验表单的数据
         */
        User user = userMapper.getUserByUsername(form.getUsername());
        if (user == null) {
            throw new UserException("用户不存在！");
        } else if (! form.getPassword().equals(user.getPassword())) {
            throw new UserException("密码错误！");
        }
        return user;
    }

    /**
     * 注册功能
     *
     * @param form
     */
    @Override
    public void regist(User form) throws UserException {
        /*
            校验数据物理层面的错误（逻辑正确，但是和数据库中已有的重复了）
         */
        User user = userMapper.getUserByUsername(form.getUsername());
        if (user != null) {
            throw new UserException("用户名已被注册！");
        }
        user = userMapper.getUserByEmail(form.getEmail());
        if (user != null) {
            throw new UserException("邮箱已被注册！");
        }
        // 插入数据到数据库
        userMapper.addUser(form);
    }

    /**
     * 开通会员
     * @param userId
     */
    @Override
    public void openVip(Integer userId) {
        userMapper.updateStatus(userId);
    }
}
