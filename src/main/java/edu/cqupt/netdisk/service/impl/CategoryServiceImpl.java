package edu.cqupt.netdisk.service.impl;

import edu.cqupt.netdisk.dao.CategoryMapper;
import edu.cqupt.netdisk.domain.Category;
import edu.cqupt.netdisk.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author LWenH
 * @create 2020/12/16 - 19:35
 */
@Service
public class CategoryServiceImpl implements CategoryService {
    @Autowired
    private CategoryMapper categoryMapper;

    /**
     * 得到所有文件类别
     *
     * @return
     */
    @Override
    public List<Category> getAllCategory() {
        return categoryMapper.getAllCategory();
    }

    /**
     * 根据类别id查找类别
     *
     * @param cid
     * @return
     */
    @Override
    public Category getCategoryById(Integer cid) {
        return categoryMapper.getCategoryById(cid);
    }
}
