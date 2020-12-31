package edu.cqupt.netdisk.utils;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.image.BufferedImage;
import java.io.IOException;

/**
 * @author LWenH
 * @create 2020/12/15 - 23:04
 * <p>
 * 用来进行页面跳转以及生成验证码图片的工具类
 */
@Controller
@RequestMapping(value = "/utils")
public class OtherUtils {

    @Autowired
    private VerifyCode verifyCode;

    @RequestMapping(value = "/verifyCode")
    public void test(HttpServletRequest request, HttpServletResponse response) throws IOException {
        /*
         * 1. 生成图片
         * 2. 保存图片上的文本到session域中
         * 3. 把图片响应给客户端
         */
        BufferedImage image = verifyCode.getImage();
        request.getSession().setAttribute("sessionVcode", verifyCode.getText());

        VerifyCode.output(image, response.getOutputStream());
    }

    /**
     * 进行页面跳转的方法
     *
     * @param target
     * @return
     */
    @RequestMapping(value = "/jump/{target}")
    public String jump(@PathVariable("target") String target) {
        return target;
    }
}
