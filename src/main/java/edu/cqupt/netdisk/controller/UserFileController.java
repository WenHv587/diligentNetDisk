package edu.cqupt.netdisk.controller;

import edu.cqupt.netdisk.domain.Category;
import edu.cqupt.netdisk.domain.Msg;
import edu.cqupt.netdisk.domain.User;
import edu.cqupt.netdisk.domain.UserFile;
import edu.cqupt.netdisk.service.CategoryService;
import edu.cqupt.netdisk.service.UserFileService;
import edu.cqupt.netdisk.utils.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.NoSuchFileException;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * @author LWenH
 * @create 2020/12/17 - 20:41
 */
@Controller
@RequestMapping(value = "/file")
public class UserFileController {
    @Autowired
    private UserFileService userFileService;

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private FilenameUtils filenameUtils;

    /**
     * 计算用户网盘中文件的总大小
     * @return
     */
    @RequestMapping(value = "/fileSizeSum")
    @ResponseBody
    public Msg fileSizeSum(@RequestParam(value = "userId") Integer userId) {
        double sum = userFileService.getFileSizeSum(userId);
        System.out.println("文件总大小=" + sum + "mb");
        String s = String.format("%.2f", sum);
        System.out.println("格式化=" + s);
        return Msg.success().add("sum", s);
    }

    /**
     * 修改文件名称
     *
     * @param userId 用户id
     * @param newName 文件的新名称
     * @param fid 文件id
     * @return
     */
    @RequestMapping(value = "/modifyName")
    @ResponseBody
    public Msg modifyFileName(@RequestParam(value = "userId") Integer userId
            , @RequestParam(value = "newName") String newName
            , @RequestParam(value = "fid") Integer fid
            , @RequestParam(value = "username") String username) {
        // 根据用户id和文件名称去数据库查重
        UserFile file = userFileService.getFileByFilename(userId, newName);
        if (file != null) {
            return Msg.fail().add("errorMsg","文件名已存在！");
        } else if (newName == null || newName.trim().isEmpty()){
            return Msg.fail().add("errorMsg","文件名不得为空！");
        } else {
            // 修改服务端的文件名
            System.out.println("文件id=" + fid);
            UserFile userFile = userFileService.getFileById(fid);
            String oldName = userFile.getFname();
            // 文件原本的的存储路径
            String path = "D:\\DeskTop\\netdisk\\"  + username + "\\" + oldName;
            System.out.println("文件原本的路径=" + oldName);
            File f = new File(path);
            int index = oldName.lastIndexOf('.');
            // 获取文件的后缀名
            String suf = oldName.substring(index);
            System.out.println("文件后缀=" + suf);
            // 对用户输入的文件名进行拼接
            newName += suf;
            String dest = "D:\\DeskTop\\netdisk\\"  + username + "\\" + newName;
            System.out.println("拼接后的路径=" + dest);
            if (!f.renameTo(new File(dest))) {
                return Msg.fail().add("errorMsg","文件名修改出现错误！请联系管理员！");
            }
            // 在数据库中修改文件名
            userFileService.modifyFileName(fid, newName);
            return Msg.success();
        }
    }

    /**
     * 清空用户回收站
     *
     * @param userId 用户id
     * @return
     */
    @RequestMapping(value = "/emptyTrash")
    @ResponseBody
    public Msg emptyTrash(@RequestParam(value = "userId") Integer userId, @RequestParam(value = "username") String username) {
        // 得到所有回收站中的文件
        List<UserFile> trashFileList = userFileService.getTrash(userId);
        // 遍历删除所有文件
        for (UserFile file : trashFileList) {
            userFileService.deleteFile(file.getFid(),username,file.getFname());
        }
        return Msg.success();
    }

    /**
     * 将文件从回收站恢复
     *
     * @param fid
     * @return
     */
    @RequestMapping(value = "/restore")
    @ResponseBody
    public Msg restoreFile(@RequestParam(value = "fid") Integer fid) {
        userFileService.restoreFile(fid);
        return Msg.success();
    }

    /**
     * 查询回收站中的文件
     *
     * @param userId
     * @return
     */
    @RequestMapping(value = "/getTrash")
    @ResponseBody
    public Msg getTrash(@RequestParam(value = "userId") Integer userId) {
        List<UserFile> fileList = userFileService.getTrash(userId);
        return Msg.success().add("fileList", fileList);
    }

    /**
     * 删除文件
     *
     * @param fid
     * @return
     */
    @RequestMapping(value = "/delete")
    @ResponseBody
    public Msg deleteFile(@RequestParam(value = "fid") Integer fid, @RequestParam("username") String username,
                          @RequestParam("filename") String filename) {
        boolean flag = userFileService.deleteFile(fid, username, filename);
        if (flag) {
            return Msg.success();
        } else {
            return Msg.fail();
        }
    }

    /**
     * 将文件批量放入回收站
     *
     * @param userId    用户id
     * @param fileNames 多个文件名拼接成的字符串
     * @return
     */
    @RequestMapping(value = "/trashMultiple")
    @ResponseBody
    public Msg trashFileMultiple(@RequestParam(value = "userId") Integer userId
            , @RequestParam("fileNames") String fileNames) {
        String[] names = fileNames.split(",");
        for (String filename : names) {
            System.out.println(filename);
            /*
                先根据用户id和文件名称获取到文件的id，再调用将文件放入回收站的方法
             */
            UserFile file = userFileService.getFileByFilename(userId, filename);
            String fstatus = "d_" + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
            userFileService.trashFile(file.getFid(), fstatus);
        }
        return Msg.success();
    }

    /**
     * 将单个文件放入回收站
     *
     * @param fid
     * @return
     */
    @RequestMapping(value = "/trash")
    @ResponseBody
    public Msg trashFile(@RequestParam(value = "fid") Integer fid) {
        String fstatus = "d_" + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        userFileService.trashFile(fid, fstatus);
        return Msg.success();
    }

    /**
     * 取消分享文件
     *
     * @param fid
     * @return
     */
    @RequestMapping(value = "/cancelShare")
    @ResponseBody
    public Msg cancelShare(@RequestParam(value = "fid") Integer fid) {
        userFileService.cancelShare(fid);
        return Msg.success();
    }

    /**
     * 分享文件
     *
     * @param fid
     * @return
     */
    @RequestMapping(value = "/shareFile")
    @ResponseBody
    public Msg shareFile(@RequestParam(value = "fid") Integer fid) {
        String fsatus = "s_" + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        userFileService.shareFile(fid, fsatus);
        return Msg.success();
    }

    /**
     * 批量共享文件
     *
     * @param userId    用户id
     * @param fileNames 多个文件名拼接成的字符串
     * @return
     */
    @RequestMapping(value = "/shareMultiple")
    @ResponseBody
    public Msg shareMultiple(@RequestParam(value = "userId") Integer userId
            , @RequestParam("fileNames") String fileNames) {
        String[] names = fileNames.split(",");
        for (String filename : names) {
            System.out.println(filename);
            /*
                先根据用户id和文件名称获取到文件的id，再调用分享文件的方法
             */
            UserFile file = userFileService.getFileByFilename(userId, filename);
            String fstatus = "s_" + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
            userFileService.shareFile(file.getFid(), fstatus);
        }
        return Msg.success();
    }

    /**
     * 文件下载
     *
     * @param username 用户名。也就是用户文件文件夹的名称。
     * @param filename 文件名。
     * @return
     * @throws IOException
     */
    @RequestMapping(value = "/download")
    public ResponseEntity<byte[]> download(@RequestParam(value = "username") String username
            , @RequestParam(value = "filename") String filename, HttpServletRequest request
            , HttpServletResponse response) throws IOException, ServletException {
        System.out.println("文件下载...");
        // 获取文件在服务端的存储位置
        String path = "D:\\DeskTop\\netdisk\\" + username + "\\" + filename;
        System.out.println(path);
        // 读取指定位置的文件，返回为byte[]
        byte[] bys = new byte[0];
        try {
            bys = Files.readAllBytes(Paths.get(path));
        } catch (NoSuchFileException e) {
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        // 创建响应头对象
        HttpHeaders headers = new HttpHeaders();
        // 设置响应头数据
        headers.add("Content-Disposition", "attachment;filename=" + URLEncoder.encode(filename, "utf-8"));
        // 设置响应状态
        HttpStatus statusCode = HttpStatus.OK;
        // 封装到响应状态对象中
        return new ResponseEntity<>(bys, headers, statusCode);
    }

    /**
     * 查询共享资源
     *
     * @return
     */
    @RequestMapping(value = "/getPublic")
    @ResponseBody
    public Msg getPublic() {
        List<UserFile> fileList = userFileService.getPublicFile();
        return Msg.success().add("fileList", fileList);
    }

    /**
     * 查询某个用户指定类别的文件
     *
     * @param userId 用户id
     * @param cid    类别id
     * @return
     */
    @RequestMapping(value = "/getByCategory")
    @ResponseBody
    public Msg getByCategory(@RequestParam(value = "userId") Integer userId, @RequestParam(value = "cid") Integer cid) {
        // 查询数据
        List<UserFile> fileList = userFileService.getFileByCategory(userId, cid);
        return Msg.success().add("fileList", fileList);
    }

    /**
     * 查询某个用户的全部文件
     *
     * @param userId 用户id
     * @return 返回查询结果（json形式）
     */
    @RequestMapping(value = "/getAll")
    @ResponseBody
    public Msg getAll(@RequestParam(value = "userId") Integer userId) {
        // 查询数据
        List<UserFile> fileList = userFileService.getFileByUser(userId);
        return Msg.success().add("fileList", fileList);
    }

    /**
     * 上传文件
     *
     * @param session session对象，用于获得用户信息
     * @param file    要上传的文件
     * @param cid     文件的类别id
     * @return
     * @throws IOException
     */
    @RequestMapping(value = "/upload/{cid}")
    @ResponseBody
    public Msg upload(HttpSession session, @RequestParam("file") MultipartFile file, @PathVariable("cid") Integer cid) throws IOException {
        // 获取到用户
        User user = (User) session.getAttribute("session_user");
        // 目前已经存储的大小
        double fileSizeSum = userFileService.getFileSizeSum(user.getUserId());
        // 得到要上传的文件大小（此处是字节）
        long size = file.getSize();
        // 上传后的用户文件的总大小，单位为MB
        double sum = fileSizeSum + size / 1024.0 / 1024.0;
        System.out.println("上传以后的总大小=" + sum);
        if (user.getStatus() == 0) {
            if (sum > 1024) {
                // 如果上传文件的大小超出了用户容量的总限制，则提示错误
                return Msg.fail().add("msg", "您的空间不足以上传！开通会员享受超大空间！");
            }
        } else {
            if (sum > 5120) {
                return Msg.fail().add("msg","本网盘个人最大容量目前仅支持5GB！");
            }
        }
        // 上传的位置
        String path = "D:\\DeskTop\\netdisk\\" + user.getUsername();
        // 获取文件名
        String fname = file.getOriginalFilename();
        assert fname != null;
        // 对文件名进行处理
        String filename = filenameUtils.checkFilename(user.getUserId(), fname, fname);
        System.out.println("处理以后的文件名：" + filename);
        // 上传文件至服务端
        file.transferTo(new File(path, filename));
        // 获取文件类别
        Category category = categoryService.getCategoryById(cid);

        UserFile userFile = new UserFile();
        userFile.setFname(filename);

        // 对文件大小进行计算，合理显示（已经设置文件最大限制为50m）
        String sizeStr;
        if (size < 512000) {
            // 文件大小小于500kb直接以kb显示
            sizeStr = String.format("%.2f", size / 1024.0) + " KB";
        } else {
            // 其余显示mb
            sizeStr = String.format("%.2f", size / 1024.0 / 1024.0) + " MB";
        }
        userFile.setFsize(sizeStr);
        // 将当前日期转化为字符串，以字符串的形式存入数据库
        userFile.setFuploadtime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
        // 文件默认是私密的
        userFile.setFstatus("0");
        userFile.setUser(user);
        userFile.setCategory(category);
        // 向数据库插入文件信息
        userFileService.uploadFile(userFile);

        if (fname.equals(filename)) {
            return Msg.success();
        } else {
            return Msg.fail().add("msg", "文件名重复，已为您自动更名为： [" + filename + "] ，稍后您可以进行修改！");
        }
    }
}
