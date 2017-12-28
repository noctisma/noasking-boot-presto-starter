package com.noasking.boot.presto.demo;

import com.noasking.boot.presto.autoconfigure.PrestoJdbcUtils;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.sql.SQLException;
import java.util.List;

/**
 * Presto 测试类
 * Created by MaJing on 2017/12/26.
 */
@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(classes = PrestoDemoApplication.class)
public class TestPresto {

    @Autowired
    private PrestoJdbcUtils prestoJdbcUtils;

    /**
     * 测试获取连接
     */
    @Test
    public void testGetConn() {
        try {
            Assert.assertNotNull(prestoJdbcUtils.getConnection());
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Test
    public void testQuerySqlForKeyValue() {
        try {
            Assert.assertEquals(prestoJdbcUtils.querySqlForKeyValue("select * from d_ability limit 5").size(), 5);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Test
    public void testQueryRows() {
        try {
            List<Object[]> result = prestoJdbcUtils.queryRows("select * from d_ability limit 5");
            System.out.println(result);
            Assert.assertEquals(result.size(), 5);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Test
    public void testExcuteSql() {
        try {
            boolean result = prestoJdbcUtils.excuteSql("select * from d_ability limit 5");
            Assert.assertEquals(result, true);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Test
    public void testCountQuery() {
        try {
            long result = prestoJdbcUtils.countQuery("select count(1) from (select * from d_ability limit 5) b");
            System.out.println(result);
            Assert.assertEquals(result, 5L);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


}
