package nl.vpro.poel.service;

import nl.vpro.poel.domain.Role;
import nl.vpro.poel.domain.User;
import nl.vpro.poel.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.Optional;

@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;

    @Autowired
    public UserServiceImpl(UserRepository userRepository) {
        this.userRepository = userRepository;

        // Initialize default users
        if (userRepository.count() == 0) {
            List<User> defaultUsers = Arrays.asList(
                    new User("n.breunese@vpro.nl", Role.ADMIN, "Van Breunhorst"),
                    new User("f.bosma@vpro.nl", Role.ADMIN, "Frank Bosma"),
                    new User("t.klok@vpro.nl", Role.ADMIN, "Timo Klok"),
                    new User("d.pronk@vpro.nl", Role.ADMIN, "David Pronk"),
                    new User("nils@breun.nl", Role.USER, "Van Breunhorst")
            );
            userRepository.save(defaultUsers);
        }
    }

    @Override
    public Optional<User> getUserById(long id) {
        return Optional.ofNullable(userRepository.findOne(id));
    }

    @Override
    public Optional<User> getUserByUsername(String email) {
         return userRepository.findOneByUsernameIgnoreCase(email);
    }

    @Override
    public Collection<User> getAllUsers() {
        return userRepository.findAll(new Sort("email"));
    }

//    @Override
//    public User create(UserCreateForm form) {
//        User user = new User();
//        user.setEmail(form.getEmail());
//        user.setPasswordHash(new BCryptPasswordEncoder().encode(form.getPassword()));
//        user.setRole(form.getRole());
//        return userRepository.save(user);
//    }
}
