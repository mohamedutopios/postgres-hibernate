package formation.fdj.hibernate.config;

import net.ttddyy.dsproxy.listener.logging.SLF4JLogLevel;
import net.ttddyy.dsproxy.support.ProxyDataSourceBuilder;
import org.aopalliance.intercept.MethodInterceptor;
import org.aopalliance.intercept.MethodInvocation;
import org.springframework.aop.framework.ProxyFactory;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanPostProcessor;
import org.springframework.lang.Nullable;
import org.springframework.util.ReflectionUtils;

import javax.sql.DataSource;
import java.lang.reflect.Method;

public class DataSourceProxyPostProcessor implements BeanPostProcessor {
    @Override
    public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
        if(bean instanceof DataSource) {
            ProxyFactory proxy = new org.springframework.aop.framework.ProxyFactory(bean);
            proxy.addAdvice(new ProxyDataSourceInterceptor((DataSource) bean));
        }
        return bean;
    }

    @Override
    public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
        return bean;
    }

    private static class ProxyDataSourceInterceptor implements MethodInterceptor {

        private final DataSource dataSource;

        public ProxyDataSourceInterceptor(final DataSource dataSource) {
            super();
            this.dataSource = ProxyDataSourceBuilder.create(dataSource)
                    .name("DATA_SOURCE_PROXY")
                    .logQueryBySlf4j(SLF4JLogLevel.INFO)
                    .multiline()
                    .countQuery()
                    .build();
        }

        @Override
        public Object invoke(final MethodInvocation invocation) throws Throwable {

            final Method proxyMethod = ReflectionUtils.
                    findMethod(this.dataSource.getClass(),
                            invocation.getMethod().getName());

            if (proxyMethod != null) {
                return proxyMethod.invoke(this.dataSource, invocation.getArguments());
            }

            return invocation.proceed();
        }
    }
}
