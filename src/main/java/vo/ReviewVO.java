package vo;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
// 12/15 수정
public class ReviewVO {
	private int rv_idx, m_idx, od_idx, rv_score;
	private String rv_content, rv_postdate, rv_img, m_nickname; 
	private MultipartFile photos;
}
