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
	        jms.setHost("smtp.gmail.com");//google smtp ���� ����(����)
	        jms.setPort(587);//���̹��� 465(����) //���� ��Ʈ
	        jms.setUsername("0427825@gmail.com");
	        jms.setPassword("nkognrjroqvrksyd");
	     
		//���λ���
	        Properties prop = new Properties();
	        prop.setProperty("mail.transport.protocol", "smtp");
	        prop.setProperty("mail.smtp.auth", "true"); 
	        prop.setProperty("mail.smtp.starttls.enable", "true");
	        prop.setProperty("mail.debug", "true");
	        jms.setJavaMailProperties(prop);

	        return jms;
	    }
}




