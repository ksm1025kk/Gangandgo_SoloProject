package dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;

import vo.MemberVO;

public class MemberDAO {

	@Autowired
	SqlSession sqlSession;

	// 멤버 전체 조회
	public List<MemberVO> selectList() {
		return sqlSession.selectList("m.member_list");
	}

	// 멤버 가입
	public int member_insert(MemberVO vo) {
		return sqlSession.insert("m.member_insert", vo);
	}

	// 이메일 중복 체크 -- 회원가입 시
	public int email_check(String m_email) {
		return sqlSession.selectOne("m.email_check", m_email);

	}

	// 닉네임 중복 체크
	public int nickname_check(String m_nickname) {
		return sqlSession.selectOne("m.nickname_check", m_nickname);

	}

	// 이메일이 db에 존재하는지 체크 -- 로그인 시
	public MemberVO email_exist_check(String m_email) {
		return sqlSession.selectOne("m.email_exist_check", m_email);
	}

	// 새로운비밀번호 변경
	public int newpwd_update(MemberVO vo) {
		return sqlSession.update("m.newpwd_update", vo);
	}

	// 닉네임변경
	public int member_info_modify(MemberVO vo) {
		return sqlSession.update("m.member_info_modify", vo);
	}

	// 계정업데이트
	public MemberVO selectOne(int m_idx) {
		return sqlSession.selectOne("m.member_selectOne", m_idx);
	}

	// 회원 탈퇴
	public int delete_membership(int m_idx) {
		return sqlSession.update("m.delete_membership", m_idx);
	}

	// 배송지 수정
	public int member_addr_modify(MemberVO vo) {
		return sqlSession.update("m.member_addr_modify", vo);
	}
}
