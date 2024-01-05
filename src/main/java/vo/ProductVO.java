package vo;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ProductVO {
	private int p_idx, p_price, p_amount, p_sale_count, p_review_count,p_status;
	private String p_name, p_img, p_info, p_pettype, p_category ,orderby;
	private MultipartFile photo;
}
