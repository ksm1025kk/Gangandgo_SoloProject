package vo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OrderdetailVO {
	private int od_idx, o_idx, p_idx, od_price, od_count, od_review_check;
	private String p_name, p_img; //추가
}
