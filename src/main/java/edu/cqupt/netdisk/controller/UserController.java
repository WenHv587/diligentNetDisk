package edu.cqupt.netdisk.controller;

import cn.itcast.mail.Mail;
import cn.itcast.mail.MailUtils;
import edu.cqupt.netdisk.domain.Msg;
import edu.cqupt.netdisk.domain.User;
import edu.cqupt.netdisk.exception.UserException;
import edu.cqupt.netdisk.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.mail.MessagingException;
import javax.mail.Session;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.text.MessageFormat;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

/**
 * @author LWenH
 * @create 2020/12/13 - 17:26
 */
@Controller
@RequestMapping(value = "/user")
public class UserController {
    @Autowired
    private UserService userService;

    /**
     * 发邮件
     *
     * @return
     */
    @RequestMapping(value = "/sendEmail")
    @ResponseBody
    public Msg sendEmail(HttpSession hs) throws IOException {
        System.out.println("准备发邮件");
        /*
            准备发邮件
         */
        Properties props = new Properties();
        // 加载配置文件
        ClassPathResource classPathResource = new ClassPathResource("email_template.properties");
        props.load(classPathResource.getInputStream());
        String host = props.getProperty("host"); // 获取服务器主机名
        System.out.println("host=" + host);
        String uname = props.getProperty("uname"); // 获取用户名
        String pwd = props.getProperty("pwd"); // 获取密码
        String from = props.getProperty("from"); // 获取发件人
        User user = (User) hs.getAttribute("session_user");
        String to = user.getEmail(); // 获取收件人
        String subject = props.getProperty("subject"); // 获取邮件主题
        String content = props.getProperty("content"); // 获取邮件内容
        content = MessageFormat.format(content, user.getUserId()); // 替换{0}占位符
        System.out.println(content);
        // 得到session
        Session session = MailUtils.createSession(host, uname, pwd);
        Mail mail = new Mail(from, to, subject, content);
        try {
            MailUtils.send(session,mail);
        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }
        return Msg.success();
    }

    /**
     * 修改用户状态（开通vip）
     *
     * @param userId
     * @return
     */
    @RequestMapping(value = "/openVip/{userId}")
    public String openVip(@PathVariable(value = "userId") Integer userId, HttpServletRequest request) {
        System.out.println("执行开通会员");
        userService.openVip(userId);
        return "vip";
    }

    /**
     * 退出登录功能
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/exit")
    public String exit(HttpServletRequest request) {
        // 将session设置为失效
        request.getSession().invalidate();
        return "login";
    }

    /**
     * 登录功能
     *
     * @param form
     * @param request
     * @return
     */
    @RequestMapping(value = "/login")
    @ResponseBody
    public Msg login(User form, HttpServletRequest request) {
        Map<String, String> errorMap = new HashMap<>();
        String username = form.getUsername();
        if (username == null || username.trim().isEmpty()) {
            errorMap.put("username", "请输入用户名！");
        } else if (username.length() < 2 || username.length() > 10) {
            errorMap.put("username", "请检查您的用户名！");
        }
        String password = form.getPassword();
        if (password == null || password.trim().isEmpty()) {
            errorMap.put("password", "请输入密码！");
        }
        if (errorMap.size() > 0) {
            return Msg.fail().add("errorMap", errorMap);
        }
        try {
            User user = userService.login(form);
            // 将对象保存到session中
            request.getSession().setAttribute("session_user", user);
            return Msg.success();
        } catch (UserException e) {
            return Msg.fail().add("loginException", e.getMessage());
        }
    }

    /**
     * 注册功能
     *
     * @param form
     * @return
     */
    @RequestMapping(value = "/regist")
    @ResponseBody
    public Msg regist(User form, HttpSession session, HttpServletRequest request) {
        String inputCode = request.getParameter("verifyCode");
        System.out.println("验证码=" + inputCode);
        Map<String, String> errorMap = new HashMap<>();
        // 用户名逻辑性校验
        String username = form.getUsername();
        System.out.println("用户名=" + username);
        if (username == null || username.trim().isEmpty()) {
            errorMap.put("username", "用户名不能为空！");
        } else if (username.length() < 2 || username.length() > 10) {
            errorMap.put("username", "用户名必须为2-10位！");
        }
        // 密码逻辑性校验
        String password = form.getPassword();
        if (password == null || password.trim().isEmpty()) {
            errorMap.put("password", "密码不能为空！");
        } else if (password.length() < 5 || password.length() > 45) {
            errorMap.put("password", "密码长度应该为5-45位！");
        }
        // 邮箱逻辑性校验
        String email = form.getEmail();
        System.out.println("邮箱=" + email);
        String regex = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$";
        if (email == null || email.trim().isEmpty()) {
            errorMap.put("email", "邮箱不能为空！");
        } else if (! email.matches(regex)) {
            errorMap.put("email", "邮箱格式错误！");
        }
        // 校验验证码是否正确
        // 从session中取出验证码
        String vcode = (String) session.getAttribute("sessionVcode");
        if (inputCode == null || inputCode.trim().isEmpty()) {
            errorMap.put("verifyCode", "请输入验证码！");
        } else if (! vcode.equalsIgnoreCase(inputCode)) {
            errorMap.put("verifyCode", "验证码错误！");
        }
        if (errorMap.size() > 0) {
            return Msg.fail().add("errorMap", errorMap);
        }
        try {
            userService.regist(form);
            /*
                用户注册成功以后，为每一个用户创建一个根文件夹，名称为该用户的用户名。
             */
            String path = "D:\\DeskTop\\netdisk\\";
            File file = new File(path + username);
            file.mkdirs();
            return Msg.success();
        } catch (UserException e) {
            return Msg.fail().add("UserException", e.getMessage());
        }
    }
}
