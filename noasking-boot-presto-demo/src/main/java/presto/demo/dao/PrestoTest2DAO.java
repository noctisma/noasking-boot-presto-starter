package presto.demo.dao;


import com.noasking.boot.presto.annotations.Select;
import com.noasking.boot.presto.repository.PrestoRepository;

/**
 * Created by MaJing on 2017/12/29.
 */
public interface PrestoTest2DAO extends PrestoRepository {

    @Select("select * from bb")
    public String coung(String aa, String bb);

}
