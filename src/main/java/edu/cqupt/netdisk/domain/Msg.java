package edu.cqupt.netdisk.domain;

import java.util.HashMap;
import java.util.Map;

/**
 * @author LWenH
 * @create 2020/12/13 - 20:06
 * <p>
 * 通用的返回类
 */
public class Msg {
    /**
     * 返回的状态码
     * 200表示成功 500表示失败
     */
    private int code;
    /**
     * 返回的提示信息
     */
    private String msg;
    /**
     * 返回给浏览器的数据
     */
    private Map<String, Object> extend = new HashMap<>();

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Map<String, Object> getExtend() {
        return extend;
    }

    public void setExtend(Map<String, Object> extend) {
        this.extend = extend;
    }

    /**
     * 正确情况
     *
     * @return
     */
    public static Msg success() {
        Msg result = new Msg();
        result.setCode(200);
        result.setMsg("处理成功！");
        return result;
    }

    /**
     * 错误情况
     *
     * @return
     */
    public static Msg fail() {
        Msg result = new Msg();
        result.setCode(500);
        result.setMsg("处理失败！");
        return result;
    }

    /**
     * 为返回的Msg对象追加服务器数据
     *
     * @param key
     * @param value
     * @return
     */
    public Msg add(String key, Object value) {
        this.getExtend().put(key, value);
        return this;
    }
}
