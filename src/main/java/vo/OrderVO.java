package vo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OrderVO {
	private int o_idx, m_idx, p_idx,o_count, o_delivered;
	private String o_date, o_addr, o_number, p_name,p_img;

}
