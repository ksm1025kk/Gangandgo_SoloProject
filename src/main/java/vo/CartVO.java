package vo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CartVO {
	private int c_idx, m_idx, p_idx, c_count, p_price; //p_price추가
	private String p_name, p_img; //추가
}
