package edu.cqupt.netdisk.service;

import edu.cqupt.netdisk.domain.Category;

import java.util.List;

/**
 * @author LWenH
 * @create 2020/12/16 - 19:33
 */
public interface CategoryService {

    /**
     * 得到所有的文件类别
     *
     * @return
     */
    List<Category> getAllCategory();

    /**
     * 根据类别id获取类别
     *
     * @param cid
     * @return
     */
    Category getCategoryById(Integer cid);
}
