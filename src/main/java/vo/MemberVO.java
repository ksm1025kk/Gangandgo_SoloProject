package vo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MemberVO {
	private int m_idx, m_auth;
	private String m_email, m_pwd, m_nickname, m_regdate, m_addr1,m_addr1_extra, m_addr2,m_addr2_extra, m_addr3, m_addr3_extra, m_tel;
}
