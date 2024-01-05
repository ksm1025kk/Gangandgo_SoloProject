package vo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ReplyVO {
	private int r_idx, b_idx, m_idx, r_thumbup, r_ref, r_step, r_depth, r_nested, r_parent_idx, r_status;
	private String r_content, r_postdate, m_nickname;
}
