package edu.cqupt.netdisk.controller;

import edu.cqupt.netdisk.domain.Category;
import edu.cqupt.netdisk.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

/**
 * @author LWenH
 * @create 2020/12/16 - 19:38
 */
@Controller
@RequestMapping(value = "/category")
public class CategoryController {

    @Autowired
    private CategoryService categoryService;

    @RequestMapping(value = "/getAllCategory")
    public String getAllCategory(Model model) {
        List<Category> categoryList = categoryService.getAllCategory();
        model.addAttribute("categoryList", categoryList);
        return "left";
    }
}
