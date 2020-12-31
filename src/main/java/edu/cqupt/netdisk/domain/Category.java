package edu.cqupt.netdisk.domain;

/**
 * @author LWenH
 * @create 2020/12/16 - 17:46
 *
 * 文件类别的实体类
 */
public class Category {

    /**
     * 类别id
     */
    private Integer cid;
    /**
     * 类别名称
     */
    private String cname;

    public Integer getCid() {
        return cid;
    }

    public void setCid(Integer cid) {
        this.cid = cid;
    }

    public String getCname() {
        return cname;
    }

    public void setCname(String cname) {
        this.cname = cname;
    }

    @Override
    public String toString() {
        return "Category{" +
                "cid=" + cid +
                ", cname='" + cname + '\'' +
                '}';
    }
}
