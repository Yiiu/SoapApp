import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:soap_app/config/router.dart';
import 'package:soap_app/pages/user/stores/user_store.dart';
import 'package:soap_app/repository/user_repository.dart';
import 'package:throttling/throttling.dart';

class UserHeaderFollowBtn extends StatelessWidget {
  UserHeaderFollowBtn({Key? key, required this.store}) : super(key: key);

  final UserPageStore store;

  final Throttling _followThr =
      Throttling(duration: const Duration(seconds: 2));

  final Throttling _unfollowThr =
      Throttling(duration: const Duration(seconds: 2));

  final UserRepository _userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    if (store.isOwner) {
      return OutlinedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(
            0,
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 0,
            ),
          ),
          backgroundColor: MaterialStateProperty.all(
            Colors.white.withOpacity(.1),
          ),
          overlayColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.focused) ||
                  states.contains(MaterialState.pressed))
                return Colors.black.withOpacity(.1);
              return Colors.transparent; // Defer to the widget's default.
            },
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              side: const BorderSide(color: Colors.red, width: 10),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          side: MaterialStateProperty.all(
            BorderSide(
              color: Colors.white.withOpacity(.8),
              width: 1,
            ),
          ),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(RouteName.edit_profile);
        },
        child: const Text(
          '编辑资料',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      );
    } else {
      if (store.user!.isFollowing != null && store.user!.isFollowing! > 0) {
        return SizedBox(
          width: 46,
          child: OutlinedButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(
                0,
              ),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(
                  // horizontal: 6,
                  vertical: 0,
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                Colors.white.withOpacity(.1),
              ),
              overlayColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.focused) ||
                      states.contains(MaterialState.pressed))
                    return Colors.black.withOpacity(.1);
                  return Colors.transparent; // Defer to the widget's default.
                },
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.red, width: 10),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              side: MaterialStateProperty.all(
                const BorderSide(
                  color: Colors.white,
                  width: 1,
                ),
              ),
            ),
            onPressed: () {
              _unfollowThr.throttle(() {
                _userRepository.unFollowUser(
                    store.user!.id, store.user!.username);
              });
            },
            child: const Icon(
              FeatherIcons.userCheck,
              color: Colors.white,
              size: 18,
            ),
          ),
        );
      } else {
        return OutlinedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(
              0,
            ),
            padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 0,
              ),
            ),
            backgroundColor: MaterialStateProperty.all(
              Theme.of(context).primaryColor,
            ),
            overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.focused) ||
                    states.contains(MaterialState.pressed))
                  return Colors.black.withOpacity(.1);
                return Colors.transparent; // Defer to the widget's default.
              },
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                side: const BorderSide(color: Colors.red, width: 10),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            side: MaterialStateProperty.all(
              BorderSide(
                color: Theme.of(context).primaryColor,
                width: 0,
              ),
            ),
          ),
          onPressed: () {
            _followThr.throttle(() {
              _userRepository.followUser(store.user!.id, store.user!.username);
            });
          },
          child: const Text(
            '关 注',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        );
      }
    }
  }
}
