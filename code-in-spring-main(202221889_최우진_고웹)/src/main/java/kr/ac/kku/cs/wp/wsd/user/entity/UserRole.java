package kr.ac.kku.cs.wp.wsd.user.entity;
// Generated 2024. 10. 6. 오전 9:13:44 by Hibernate Tools 6.5.1.Final

import jakarta.persistence.*;
import java.util.Objects;

@Entity
@Table(name = "user_role")
public class UserRole {

    @EmbeddedId
    private UserRoleId id;

    @ManyToOne
    @MapsId("userId")
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @MapsId("roleId")
    @JoinColumn(name = "role_id")
    private Role role;

    @Column(name = "role", length = 45)
    private String roleName;

    public UserRole() {}

    public UserRole(User user, Role role, String roleName) {
        this.user = user;
        this.role = role;
        this.roleName = roleName;
        this.id = new UserRoleId(user.getId(), role.getId());
    }

    // Getters and Setters
    public UserRoleId getId() { return id; }
    public void setId(UserRoleId id) { this.id = id; }
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    public Role getRole() { return role; }
    public void setRole(Role role) { this.role = role; }
    public String getRoleName() { return roleName; }
    public void setRoleName(String roleName) { this.roleName = roleName; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        UserRole userRole = (UserRole) o;
        return Objects.equals(id, userRole.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}


