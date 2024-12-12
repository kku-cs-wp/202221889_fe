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
package kr.ac.kku.cs.wp.wsd.user.dao;

import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import org.springframework.stereotype.Repository;

import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Join;
import jakarta.persistence.criteria.JoinType;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;
import kr.ac.kku.cs.wp.wsd.support.sql.HibernateUtil;
import kr.ac.kku.cs.wp.wsd.tools.message.MessageException;
import kr.ac.kku.cs.wp.wsd.tools.secure.CryptoUtil;
import kr.ac.kku.cs.wp.wsd.user.entity.Role;
import kr.ac.kku.cs.wp.wsd.user.entity.User;
import kr.ac.kku.cs.wp.wsd.user.entity.UserRole;

/**
 * UserDAOHiberanteImpl
 * 
 * @author kiseokjang
 * @since 2024. 10. 6.
 * @version 1.0
 */
@Repository
public class UserDAOHImpl implements UserDAO {
	
	private static final Logger logger = LogManager.getLogger(UserDAOHImpl.class);
	
	/**
	 * unique id 생성
	 * @param session
	 * @return
	 */
	public String generateNewId(Session session) {
		CriteriaBuilder cb = session.getCriteriaBuilder();
		CriteriaQuery<User> cq = cb.createQuery(User.class);
		Root<User> root = cq.from(User.class);
		
		cq.orderBy(cb.desc(root.get("id")));
		
		Query<User> query = session.createQuery(cq);
		User user = query.setMaxResults(1).uniqueResult();
		
		String prefix = "kku_";
		String lastId = user.getId();
		int lastNumber = Integer.parseInt(lastId.split("_")[1]);
		int newNuumber  = lastNumber + 1;
		
		return prefix + newNuumber;
		
		
		
    }

	@Override
	public User getUserById(String userId) {
		User user = null;
		
		Transaction tx = null;
		
		try (Session session = HibernateUtil.getSessionFactory().openSession()) {
			
			user = session.get(User.class, userId);
			
		} catch (HibernateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
		
		return user;
	}

	@Override
	public User getUser(User user) {
		
		if (user != null) {
			try (Session session = HibernateUtil.getSessionFactory().openSession()){
				
				user = session.get(User.class, user.getId());
				
			} catch (HibernateException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				throw new MessageException(e.getMessage(), e);
		
			} 
			
		}
		return user;
	}

	@Override
	public User updateUser(User user) {
		
		Session session = null;
		Transaction tx = null;
		
		try {
			session = HibernateUtil.getSessionFactory().openSession();
			tx = session.beginTransaction();
			
			User existingUser = session.get(User.class, user.getId()) ;
			
			user = session.merge(user);
			
			tx.commit();
			
		} catch (HibernateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			if (tx != null && tx.isActive()) {
				tx.rollback();
			}
			
			throw new MessageException(e.getMessage(), e);
	
		} finally {
			if (session != null && session.isOpen()) {
				session.close();
			}
			
		}
		
		return user;
	}

	@Override
	public void deleteUser(User user) {
		Session session = null;
		Transaction tx = null;
		
		try {
			session = HibernateUtil.getSessionFactory().openSession();
			tx = session.beginTransaction();
			
			session.remove(user);
			
			tx.commit();
			
		} catch (HibernateException e) {
			if (tx != null && tx.isActive()) {
				tx.rollback();
			}
			throw new MessageException(e.getMessage(), e);
		} finally {
			if (session != null && session.isOpen()) {
				session.close();
			}
		}
		
	}

	@Override
	public User createUser(User user) {
		User rtn = null;
		Session session = null;
		Transaction tx = null;
		
		try {
			session = HibernateUtil.getSessionFactory().openSession();
			tx = session.beginTransaction();
			String newId = generateNewId(session);
			
			List<UserRole> userRoles =  user.getUserRoles();
			
			for (UserRole userRole : userRoles) {
				userRole.setUser(user);
				userRole.setRole((Role) session.get(Role.class, userRole.getId().getRoleId()));
			}
			
			user.setId(newId);
			user.setPassword(CryptoUtil.hash(user.getPassword(), CryptoUtil.genSalt()));
			
			session.persist(user);
			
			tx.commit();
			
			rtn = session.get(User.class, user.getId());
			
		} catch (HibernateException | NoSuchAlgorithmException e) {
			if (tx != null && tx.isActive()) {
				tx.rollback();
			}
			throw new MessageException(e.getMessage(), e);
		} finally {
			if (session != null && session.isOpen()) {
				session.close();
			}
		}
		
		return rtn;
		
	}

	@Override
	public List<User> getUsers(User user) {
		
		List<User> users = null;
		
		try (Session session = HibernateUtil.getSessionFactory().openSession()) {

			CriteriaBuilder cb= session.getCriteriaBuilder();
			CriteriaQuery<User> criteria = cb.createQuery(User.class);
			
			Root<User> root = criteria.from(User.class);
			Join<User, UserRole> userRolesJoin = root.join("userRoles", JoinType.LEFT);
				
			criteria.select(root);
			
			List<Predicate> cds = new ArrayList<Predicate>();
			
			if (user != null) {
				if (user.getId() != null && !user.getId().isEmpty())
					cds.add(cb.like(cb.lower(root.get("id")), "%"+ user.getId().toLowerCase() + "%"));
				if (user.getName() != null && !user.getName().isEmpty())
					cds.add(cb.like(cb.lower(root.get("name")), "%"+ user.getName().toLowerCase() + "%"));
				if (user.getEmail() != null && !user.getEmail().isEmpty())
					cds.add(cb.like(cb.lower(root.get("email")), "%"+ user.getEmail().toLowerCase() + "%"));
				if (user.getStatus() != null && !user.getStatus().isEmpty())
					cds.add(cb.like(cb.lower(root.get("status")), "%"+ user.getStatus().toLowerCase() + "%"));
				if (user.getUserRoles() != null && user.getUserRoles().size() > 0)
					cds.add(cb.like(userRolesJoin.get("roleName"), "%"+ user.getUserRoles().get(0).getRoleName()+ "%"));
				
				Predicate[] pArr = new Predicate[cds.size()];
				criteria.select(root).where(cb.or((Predicate[]) cds.toArray(pArr)));
			}
			
			
			users = session.createQuery(criteria).getResultList();
		
			
		} catch (HibernateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return users;
	}
	
	

}
