package context;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import dao.AnswerDAO;
import dao.BoardDAO;
import dao.CartDAO;
import dao.HelpDAO;
import dao.MemberDAO;
import dao.OrderDAO;
import dao.ProductDAO;
import dao.ReplyDAO;
import dao.ReviewDAO;

@Configuration
public class Context_3_dao {
	@Bean
	public MemberDAO memberDAO() {
		return new MemberDAO();
	}
	
	@Bean
	public BoardDAO boardDAO() {
		return new BoardDAO();
	}
	
	@Bean
	public ReplyDAO replyDAO() {
		return new ReplyDAO();
	}
	
	@Bean
	public ProductDAO productDAO() {
		return new ProductDAO();
	}
	
	@Bean
	public HelpDAO helpDAO(){
		return new HelpDAO();
	}
	
	@Bean
	public AnswerDAO answerDAO(){
		return new AnswerDAO();
	}
	
	@Bean
	public CartDAO cartDAO() {
		return new CartDAO();
	}
	
	@Bean
	public OrderDAO orderDAO() {
		return new OrderDAO();
	}
	
	@Bean
	public ReviewDAO reviewDAO() {
		return new ReviewDAO();
	}
	
}




