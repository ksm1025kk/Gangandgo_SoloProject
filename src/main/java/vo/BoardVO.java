package vo;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BoardVO {
	private int b_idx, m_idx, b_thumbup, b_readhit,b_reply_count,b_status;
	private String b_title, b_content, b_postdate, b_img, m_nickname,b_category;
	private MultipartFile[] photos;
}
