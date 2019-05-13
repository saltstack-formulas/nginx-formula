# -*- coding: utf-8 -*-
# vim: ft=sls

nginx-deprecated-in-v1.0.0-test-fail:
  test.fail_without_changes:
    - name: |


        ################################################################################
        #                                                                              #
        #                   WARNING: BREAKING CHANGES SINCE `v1.0.0`                   #
        #                                                                              #
        ################################################################################
        #                                                                              #
        # Prior to `v1.0.0`, this formula provided two methods for managing NGINX; the #
        # old method under `nginx` and the new method under `nginx.ng`. The old method #
        # has now been removed and `nginx.ng` has been promoted to be `nginx` in its   #
        # place.                                                                       #
        #                                                                              #
        # If you are not in a position to migrate, please pin your repo to the final   #
        # release tag before `v1.0.0`, i.e. `v0.56.1`.                                 #
        #                                                                              #
        # To migrate from `nginx.ng`, simply modify your pillar to promote the entire  #
        # section under `nginx:ng` so that it is under `nginx` instead. So with the    #
        # editor of your choice, highlight the entire section and then unindent one    #
        # level. Finish by removing the `ng:` line.                                    #
        #                                                                              #
        # To migrate from the old `nginx`, first convert to `nginx.ng` under `v0.56.1` #
        # and then follow the steps laid out in the paragraph directly above.          #
        #                                                                              #
        ################################################################################
    - failhard: True
