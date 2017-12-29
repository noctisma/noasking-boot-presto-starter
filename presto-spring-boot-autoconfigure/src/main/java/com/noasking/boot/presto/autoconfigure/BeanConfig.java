package com.noasking.boot.presto.autoconfigure;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanFactoryPostProcessor;
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.beans.factory.support.BeanDefinitionRegistry;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

/**
 * Created by MaJing on 2017/12/29.
 */
//@Component
public class BeanConfig implements BeanFactoryPostProcessor, ApplicationContextAware {

    private ApplicationContext applicationContext;

    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        this.applicationContext = applicationContext;
    }

    public void postProcessBeanFactory(ConfigurableListableBeanFactory beanFactory) throws BeansException {
        ClassPathSelectAnnotationsScanner scanner = new ClassPathSelectAnnotationsScanner((BeanDefinitionRegistry)
                beanFactory);
        scanner.setResourceLoader(this.applicationContext);
        //scanner.scan("presto.demo");
    }
}
