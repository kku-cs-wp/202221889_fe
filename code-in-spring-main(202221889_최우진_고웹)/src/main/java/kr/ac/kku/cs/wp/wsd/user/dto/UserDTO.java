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


import java.util.Date;
import java.util.List;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

/**
 * UserDTO
 * 
 * @author kiseokjang
 * @since 2024. 11. 9.
 * @version 1.0
 */
public class UserDTO {
	private String id;
	
	
	@Pattern(regexp = "^[\\p{L}\\p{M}\\p{N} ]*$", message="이름에는 특수문자를 사용할 수 없습니다.")
	private String name;
	
	@NotBlank(message="유효한 이메일 주소를 입력해주세요.")
	@Email(message = "유효한 이메일 주소를 입력해주세요.")
	private String email;
	
	@NotBlank (message = "비밀번호는 특수문자, 영문자, 숫자를 포함하여 8자리 이상이어야 합니다.")
	@Pattern(
	        regexp = "^$|(?=.*[A-Za-z])(?=.*\\d)(?=.*[~`!@#$%^&*()_\\-+=\\[\\]{}|\\\\;:'\",.<>/?]).{8,}$",
	        message = "비밀번호는 특수문자, 영문자, 숫자를 포함하여 8자리 이상이어야 합니다."
	    )
	private String password;
	
	 @Pattern(regexp = "재직중|퇴직", message="사용자 상태에서는 \"재직중|퇴직\"중에서 선택해야 합니다.")
	 @NotBlank(message="사용자 상태에서는 \"재직중|퇴직\"중에서 선택해야 합니다.")
	private String status;
	private String photo;
	private Date createdAt;
	private Date updatedAt;
	private List<UserRoleDTO> userRoles;

	// Getters and Setters
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getPhoto() {
		return photo;
	}

	public void setPhoto(String photo) {
		this.photo = photo;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

	public Date getUpdatedAt() {
		return updatedAt;
	}

	public void setUpdatedAt(Date updatedAt) {
		this.updatedAt = updatedAt;
	}

	public List<UserRoleDTO> getUserRoles() {
		return userRoles;
	}

	public void setUserRoles(List<UserRoleDTO> userRoles) {
		this.userRoles = userRoles;
	}
}
