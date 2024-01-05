package context;

import java.util.Properties;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;

@Configuration
public class Context_5_email {
	  @Bean
	    public static JavaMailSender mailSender() {
	        JavaMailSenderImpl jms = new JavaMailSenderImpl();
	        jms.setHost("smtp.gmail.com");//google smtp 서버 설정(고정)
	        jms.setPort(587);//네이버는 465(고정) //메일 포트
	        jms.setUsername("0427825@gmail.com");
	        jms.setPassword("nkognrjroqvrksyd");
	     
		//세부사항
	        Properties prop = new Properties();
	        prop.setProperty("mail.transport.protocol", "smtp");
	        prop.setProperty("mail.smtp.auth", "true"); 
	        prop.setProperty("mail.smtp.starttls.enable", "true");
	        prop.setProperty("mail.debug", "true");
	        jms.setJavaMailProperties(prop);

	        return jms;
	    }
}




