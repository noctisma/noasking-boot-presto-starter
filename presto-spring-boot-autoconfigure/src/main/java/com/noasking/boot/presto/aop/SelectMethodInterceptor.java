package com.noasking.boot.presto.aop;

import com.noasking.boot.presto.annotations.Select;
import org.aopalliance.intercept.MethodInterceptor;
import org.aopalliance.intercept.MethodInvocation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.annotation.AnnotationUtils;

import java.lang.reflect.Method;
import java.lang.reflect.Parameter;
import java.lang.reflect.Type;

/**
 * Created by MaJing on 2017/12/29.
 */
public class SelectMethodInterceptor implements MethodInterceptor {
    private Logger logger = LoggerFactory.getLogger(SelectMethodInterceptor.class);

    @Override
    public Object invoke(MethodInvocation invocation) throws Throwable {
        Object[] args = invocation.getArguments();
        Method method = invocation.getMethod();
        Select select = AnnotationUtils.findAnnotation(method, Select.class);
        System.out.println(select.value());
        Type returnType = method.getGenericReturnType(); // 返回值类型
        logger.info("返回值类型：" + returnType);
        Type[] parammType = method.getGenericParameterTypes(); ///
        for (Type type : parammType
                ) {
            logger.info("参数类型：" + type);
        }
        Parameter[] parameters = method.getParameters();
        for (Parameter parameter : parameters
                ) {
            logger.info("参数：" + parameter);

        }
        //return invocation.proceed();
        return "ccc";
    }

}
