/*
 * Copyright (C) 2024 Kiseok Jang. All rights reserved.
 *
 * This software is licensed under the Personal and Limited Commercial Use License.
 * You may use this software for personal, educational, or non-commercial purposes.
 * For commercial use, ensure that your use does not infringe on the rights of others.
 *
 * For full license details, see the LICENSE file in the root directory of this project.
 *
 * Contact information: lecture4cs@gmail.com
 * 
 * 
 * 
 * 저작권 (C) 2024 장기. 모든 권리 보유.
 *
 * 이 소프트웨어는 개인 및 제한적인 상업적 사용 라이선스 하에 제공됩니다.
 * 이 소프트웨어는 개인적, 교육적 또는 비상업적 목적으로 자유롭게 사용할 수 있습니다.
 * 상업적 사용을 위해서는 타인의 권리를 침해하지 않도록 주의해야 합니다.
 *
 * 전체 라이선스 내용은 이 프로젝트의 루트 디렉토리에 있는 LICENSE 파일을 참조하십시오.
 *
 * 연락처: lecture4cs@gmail.com
 * 
 */
package kr.ac.kku.cs.wp.wsd.user.dto;

/**
 * UserRoleDTO
 * 
 * @author kiseokjang
 * @since 2024. 11. 9.
 * @version 1.0
 */
public class UserRoleDTO {
	private String userId;
	private String roleId;
	private String roleName;

	// Getters and Setters
	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getRoleId() {
		return roleId;
	}

	public void setRoleId(String roleId) {
		this.roleId = roleId;
	}

	public String getRoleName() {
		return roleName;
	}

	public void setRoleName(String roleName) {
		this.roleName = roleName;
	}
}
