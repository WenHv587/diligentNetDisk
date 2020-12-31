package edu.cqupt.netdisk.test;

import edu.cqupt.netdisk.utils.FilenameUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.io.File;

/**
 * @author LWenH
 * @create 2020/12/21 - 21:25
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class TestDemo {

    @Autowired
    private FilenameUtils filenameUtils;

    @Test
    public void test1() {
        String filename = filenameUtils.checkFilename(1, "back.jpg", "back.jpg");
        System.out.println("最终返回的修改后的文件名：" + filename);
    }

    @Test
    public void test2() {
        File file = new File( "D:\\DeskTop\\netdisk\\1665813\\zipnew.dat");
        boolean f = file.delete();
        System.out.println(f);
    }
}
